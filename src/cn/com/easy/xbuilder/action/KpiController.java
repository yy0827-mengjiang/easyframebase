package cn.com.easy.xbuilder.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.kpi.interfaces.KpiForMetadata;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.kpi.KpiInterface;


@Controller
public class KpiController {
	
	private Map<String,Map> cachedTreeDataMap;//缓存Map，格式为：{300={id=300, text=基础维度, column=AREA_NO, state=closed, children=[{....}]}]
	private List<Map<String, Object>> g_childrenList;//存储查询结果，当查询结果为树叶子节点类型时：格式为[{id:id,text:text,attributes:{kpiType:dim/kpi}}],当结果类型为页面上的li内容时，格式为：[{id:id,name:name,column:column,type:type,kpiType:kpiType,isLeafFolder:true/false}]
	private String rootId = "t0";//树的根节点
	private String DIM_FOLDER = "dim_folder";//维度目录
	private String DIM_LEAF = "dim_leaf";//维度节点
	private String KPI_FOLDER = "kpi_folder";//指标目录
	private String KPI_LEAF_FOLDER = "kpi_leaf_folder";//指标节点目录（含有扩展指标的目录：如发展_本期值、发展_上期值等）
	private String KPI_LEAF = "kpi_leaf";//指标节点
	
	/**
	 * 获得指标库树数据
	 * @param request
	 * @param response
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Action("getTreeData")
	public void getTreeData(HttpServletRequest request, HttpServletResponse response) {
		PrintWriter out = null;
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			String nodeId = request.getParameter("id");
			String treeType = request.getParameter("treeType");//树类型：dim、kpi、all
			String reload = request.getParameter("reload");
			String userId = ((Map)request.getSession().getAttribute("UserInfo")).get("USER_ID").toString();
			cachedTreeDataMap = (Map<String,Map>)request.getSession().getAttribute("cachedTreeDataMap");//先从session中取缓存的map
			if("true".equals(reload)||cachedTreeDataMap==null){
				List treeNodeList = getTreeNodeListFromInterface(userId);
				request.getSession().setAttribute("treeNodeListFromInterface",treeNodeList);//将从接口中获得的list放入session中，查询时从session中取出再查询
				parseTreeNodeListToCacheMap(treeNodeList);
				request.getSession().setAttribute("cachedTreeDataMap", cachedTreeDataMap);//将缓存map放到session中，退出登录或session过期时缓存销毁
				
			}
			nodeId = nodeId == null ? rootId : nodeId;
			List<Map> treeNodeList = new ArrayList<Map>();//树节点结果集
			if(cachedTreeDataMap.get(nodeId)!=null){
				List<Map> children = (ArrayList)((Map<String,Object>)cachedTreeDataMap.get(nodeId)).get("children");
				if(children!=null){
					String tempNodeType = "";
					boolean condition = false;
					Map treeNodeMap = null;
					for(Map cacheMap : children){
						 tempNodeType = String.valueOf(cacheMap.get("STATE"));
						 if("kpi".equals(treeType)){
							 condition = KPI_FOLDER.equals(tempNodeType)||"folder".equals(tempNodeType);//"folder"为日账期指标或月账期指标，当nodeI的为rootId时children中才有有folder类型
						 }else if("dim".equals(treeType)){
							 condition = DIM_FOLDER.equals(tempNodeType)||"folder".equals(tempNodeType);
						 }else if("all".equals(treeType)){
							 condition = DIM_FOLDER.equals(tempNodeType)||KPI_FOLDER.equals(tempNodeType)||"folder".equals(tempNodeType);
						 }
						 if(condition){
							 treeNodeMap = new HashMap();
							 treeNodeMap.put("state", (DIM_LEAF.equals(tempNodeType)||KPI_LEAF.equals(tempNodeType))?"leaf":"closed");
							 treeNodeMap.put("id", cacheMap.get("ID"));
							 treeNodeMap.put("text", cacheMap.get("TEXT"));
					    	 Map attrMap = new HashMap<String,String>();
					    	 attrMap.put("kpiType",DIM_FOLDER.equals(tempNodeType)?"dim":"kpi");
					    	 treeNodeMap.put("attributes",attrMap);
					    	 treeNodeList.add(treeNodeMap);
						 }
					}
				}
			}
			String json = Functions.java2json(treeNodeList);
			out.write(json);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	} 
	
	/**
	 * 点击目录时获取子节点
	 * @param request
	 * @param response
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Action("selectTreeNode")
	public void selectTreeNode(HttpServletRequest request, HttpServletResponse response) {
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}		
		String treeType = request.getParameter("treeType");
		g_childrenList = new ArrayList<Map<String,Object>>();
		String userId = ((Map)request.getSession().getAttribute("UserInfo")).get("USER_ID").toString();
		getAllChildrenKpi(treeType,request.getParameter("parentId"),userId);
		PrintWriter out = null;
		try {
			out = response.getWriter();
			Map map = new HashMap();
			map.put("rows", g_childrenList);
			String json = Functions.java2json(map);
			out.write(json);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 查询指标库节点数据（查询按钮点击调用）
	 * @param request
	 * @param response
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Action("queryTreeData")
	public void queryTreeData(HttpServletRequest request, HttpServletResponse response) {
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}		
		String searchName=request.getParameter("searchName");
		String treeType = request.getParameter("treeType");
		String parentId = request.getParameter("parentId");
		g_childrenList = new ArrayList<Map<String,Object>>();
		String userId = ((Map)request.getSession().getAttribute("UserInfo")).get("USER_ID").toString();
		List<Map<String,String>> treeNodeList = (List<Map<String,String>>)request.getSession().getAttribute("treeNodeListFromInterface");
		if(treeNodeList==null){
			treeNodeList = getTreeNodeListFromInterface(userId);
		}
		for(Map<String,String> interMap : treeNodeList){
			if(parentId!=null&&!"".equals(parentId)&&!parentId.equals(interMap.get("PID"))){
				continue;
			}
			//思路：如果是all，碰到dim_leaf则添加，碰到kpi_leaf_folder从缓存map查找子的kpi_leaf然后判断子kpi_leaf是否符合查询条件，符合的就添加，然后判断g_childrenList的size是否增加，如果增加就把kpi_leaf_folder添加到size位置, 碰到kpi_leaf根据缓存map查找父id对应的map的nodeType,如果是kpi_leaf_folder则跳过，否则添加
			//如果是dim:碰到dim_leaf则添加
			//如果是kpi：碰到kpi_leaf_folder添加并且从缓存map查找子的kpi_leaf, 碰到kpi_leaf根据缓存map查找父id对应的map的nodeType,如果是kpi_leaf_folder则跳过，否则添加
			if(DIM_LEAF.equals(interMap.get("STATE"))){
				if("all".equals(treeType)||"dim".equals(treeType)){
					putNodeToChildrenList(searchName,interMap,true,-1);
				}
			}else if(KPI_LEAF_FOLDER.equals(interMap.get("STATE"))){
				if("all".equals(treeType)||"kpi".equals(treeType)){
					ArrayList<Map> children = (ArrayList<Map>)cachedTreeDataMap.get(interMap.get("ID")).get("children");
					int size = g_childrenList.size();
					if(children!=null){
						for(Map cacheMap :children){
							putNodeToChildrenList(searchName,cacheMap,true,-1);
						}
					}
					if(g_childrenList.size()>size){
						putNodeToChildrenList(searchName,interMap,false,size);
					}
				}
				
			}else if(KPI_LEAF.equals(interMap.get("STATE"))){
				if("all".equals(treeType)||"kpi".equals(treeType)){
					//如果是非缩进的就添加，否则就跳过，因为缩进的说明父节点是KPI_LEAF_FOLDER类型，而KPI_LEAF_FOLDER类型已在STATE=KPI_LEAF_FOLDER分支处理，如果不跳过，就重复添加了
					if("false".equals(cachedTreeDataMap.get(interMap.get("ID")).get("indent"))){
						putNodeToChildrenList(searchName,interMap,true,-1);
					}
				}
			}
		}
		PrintWriter out = null;
		try {
			out = response.getWriter();
			Map map = new HashMap();
			map.put("rows", g_childrenList);
			String json = Functions.java2json(map);
			out.write(json);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	
	/**************************************************************************************************************/
	
	/**
	 * 将缓存map或者接口结果集的map放到g_childrenList中
	 * @param searchName：查询条件
	 * @param interOrCacheMap 缓存map或者接口结果集的map
	 * @param filter：是否过滤查询条件
	 * @param index：插入g_childrenList的下标
	 */
	private void putNodeToChildrenList(String searchName,Map<String,String> interOrCacheMap,boolean filter,int index){
		boolean isIndent = "true".equals(cachedTreeDataMap.get(interOrCacheMap.get("ID")).get("indent"));
		Map<String,Object> newMap = new HashMap<String,Object>();
		newMap.put("id", interOrCacheMap.get("ID"));
		newMap.put("name", isIndent ?"&emsp;&emsp;"+interOrCacheMap.get("TEXT"):interOrCacheMap.get("TEXT"));
		newMap.put("column", interOrCacheMap.get("COLUMN"));
		newMap.put("type", getTypeString(interOrCacheMap.get("STATE").split("_")[0],interOrCacheMap.get("TYPE")+""));
		newMap.put("kpiType", interOrCacheMap.get("STATE").split("_")[0]);
		newMap.put("isLeafFolder", KPI_LEAF_FOLDER.equals(interOrCacheMap.get("STATE")));
		if(filter){
			searchName = searchName.toLowerCase();
			if(searchName!=null&&!"".equals(searchName)&&interOrCacheMap.get("TEXT").toLowerCase().indexOf(searchName)>-1){
				g_childrenList.add(newMap);
			}else if(searchName==null||"".equals(searchName)){
				g_childrenList.add(newMap);
			}
		}else if(!filter){
			g_childrenList.add(index,newMap);
		}
		 
	}
	
	/**
	 * 将从接口方法获取的list转换到缓存map中
	 * @param nodeList
	 * @param userId
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void parseTreeNodeListToCacheMap(List<Map<String,String>> nodeList){
		cachedTreeDataMap = new HashMap<String,Map>();
		for(Map<String,String> interMap:nodeList){
			cachedTreeDataMap.put(String.valueOf(interMap.get("ID")), interMap);
		}
		for(Map<String,String> interMap:nodeList){
			if(interMap.get("PID")!=null&&cachedTreeDataMap.get(interMap.get("ID"))!=null&&cachedTreeDataMap.get(interMap.get("PID"))!=null){
				Map<String,Object> nodeMap=(Map<String,Object>)cachedTreeDataMap.get(interMap.get("ID"));
				Map<String,Object> parerntNodeMap=(Map<String,Object>)cachedTreeDataMap.get(interMap.get("PID"));
				if(parerntNodeMap.get("children")==null){
					parerntNodeMap.put("children", new ArrayList<Map<String,Object>>());
				} 
				List<Map<String,Object>> children = (List<Map<String,Object>>)parerntNodeMap.get("children");
				children.add(nodeMap);
			}
		}
		//遍历缓存cachedTreeDataMap，如果是kpi_leaf，判断父节点nodeType是否是kpi_leaf_folder，添加“是否缩进”属性，如果是则不缩进，否则缩进
		Iterator<Map.Entry<String, Map>> mapEntry = cachedTreeDataMap.entrySet().iterator();
		Map<String,Object> cacheMap;
		String tempNodeType = "";
		while (mapEntry.hasNext()) {
			cacheMap = mapEntry.next().getValue();
			if(KPI_LEAF.equals(cacheMap.get("STATE"))){
				tempNodeType = ((Map<String,Object>)cachedTreeDataMap.get(String.valueOf(cacheMap.get("PID")))).get("STATE")+"";
				if(KPI_LEAF_FOLDER.equals(tempNodeType)){
					cacheMap.put("indent", "true");
				}else{
					cacheMap.put("indent", "false");
				}
			}
		}
		 
	}
	
	/**
     * 调用接口获取所有树节点的List
     * @return
     */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<Map<String,String>> getTreeNodeListFromInterface(String userId) {
		List treeNodeList=null;
		try {
			KpiInterface meta = new KpiForMetadata();
			Map paramMap = new HashMap();
			paramMap.put("pid", rootId);
			paramMap.put("userid", userId);
			treeNodeList = meta.getDimKpiData(paramMap);
//			String str ="["
//		          	+"{\"STATE\":\"folder\", \"KPI_CODE\":\"1\", \"PID\":\"t0\", \"TEXT\":\"日账指标\", \"ID\":\"0\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"},"
//		          	+"{\"STATE\":\"kpi_folder\", \"KPI_CODE\":1, \"PID\":\"0\", \"TEXT\":\"基础指标\", \"ID\":\"100\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"}," 
//          			+"{\"STATE\":\"kpi_folder\", \"KPI_CODE\":1, \"PID\":\"100\", \"TEXT\":\"发展类\", \"ID\":\"110\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"},"
//          				+"{\"STATE\":\"kpi_leaf_folder\", \"KPI_CODE\":\"1\", \"PID\":\"110\", \"TEXT\":\"当日新发展\", \"ID\":\"120\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"},"
//          					+"{\"STATE\":\"kpi_leaf\", \"KPI_CODE\":1, \"PID\":\"120\", \"TEXT\":\"当日新发展_当日值\", \"ID\":\"121\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"},"
//          					+"{\"STATE\":\"kpi_leaf\", \"KPI_CODE\":1, \"PID\":\"120\", \"TEXT\":\"当日新发展_昨日值\", \"ID\":\"122\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"},"
//          				+"{\"STATE\":\"kpi_leaf_folder\", \"KPI_CODE\":1, \"PID\":\"110\", \"TEXT\":\"计费时长\", \"ID\":\"130\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"},"
//          					+"{\"STATE\":\"kpi_leaf\", \"KPI_CODE\":1, \"PID\":\"130\", \"TEXT\":\"计费时长_当日值\", \"ID\":\"131\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"},"
//          					+"{\"STATE\":\"kpi_leaf\", \"KPI_CODE\":1, \"PID\":\"130\", \"TEXT\":\"计费时长_昨日值\", \"ID\":\"132\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"},"
//          			+"{\"STATE\":\"kpi_folder\", \"KPI_CODE\":1, \"PID\":\"100\", \"TEXT\":\"量收类\", \"ID\":\"140\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"},"
//          	    +"{\"STATE\":\"kpi_folder\", \"KPI_CODE\":1, \"PID\":\"0\", \"TEXT\":\"复合指标\", \"ID\":\"200\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"},"
//          	    	+"{\"STATE\":\"kpi_folder\", \"KPI_CODE\":1, \"PID\":\"200\", \"TEXT\":\"发展类复合指标\", \"ID\":\"210\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"},"	
//          	    +"{\"STATE\":\"dim_folder\", \"KPI_CODE\":1, \"PID\":\"0\", \"TEXT\":\"基础维度\", \"ID\":\"300\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"}," 
//          	        +"{\"STATE\":\"dim_folder\", \"KPI_CODE\":1, \"PID\":\"300\", \"TEXT\":\"公共维度\", \"ID\":\"310\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"}," 
//          	        	+"{\"STATE\":\"dim_leaf\", \"KPI_CODE\":1, \"PID\":\"310\", \"TEXT\":\"地市\", \"ID\":\"311\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"}," 
//          	        	+"{\"STATE\":\"dim_leaf\", \"KPI_CODE\":1, \"PID\":\"310\", \"TEXT\":\"区县\", \"ID\":\"312\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"},"  
//          	        +"{\"STATE\":\"dim_folder\", \"KPI_CODE\":1, \"PID\":\"300\", \"TEXT\":\"业务维度\", \"ID\":\"320\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"}," 
//          	            +"{\"STATE\":\"dim_leaf\", \"KPI_CODE\":1, \"PID\":\"320\", \"TEXT\":\"盟市\", \"ID\":\"321\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"}, "
//      	        	    +"{\"STATE\":\"dim_leaf\", \"KPI_CODE\":1, \"PID\":\"320\", \"TEXT\":\"月账期\", \"ID\":\"322\", \"TYPE\":\"1\", \"COLUMN\":\"AREA_NO\"}"
//          		
//        	+"]";
//			treeNodeList = (List) Functions.json2java(str);
			Map rootNodeMap = new HashMap<String,String>();
			rootNodeMap.put("STATE", "");
			rootNodeMap.put("KPI_CODE", "");
			rootNodeMap.put("PID", "");
			rootNodeMap.put("TEXT", "指标库");
			rootNodeMap.put("ID", rootId );
			rootNodeMap.put("TYPE", "");
			rootNodeMap.put("COLUMN", "");
			treeNodeList.add(0, rootNodeMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return treeNodeList;
	}
	 
	
	/**
	 * 获取某个目录的子节点，如果子节点是叶子节点直接添加到childrenList，如果是KPI_LEAF_FOLDER类型目录，递归查找其子节点
	 * 点击选择某个目录时调用
	 * @param searchCondition
	 * @param parentId
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void getAllChildrenKpi(String treeType,String parentId,String userId){
		List<Map<String, Object>> nodeList = null;
		if(cachedTreeDataMap.get(parentId)!=null&&cachedTreeDataMap.get(parentId).get("children")!=null){
			nodeList = (ArrayList)cachedTreeDataMap.get(parentId).get("children");
		}
		if(nodeList!=null){
			Map newMap = null;
			for(Map cacheMap : nodeList){
				if(KPI_LEAF.equals(cacheMap.get("STATE"))||DIM_LEAF.equals(cacheMap.get("STATE"))||(KPI_LEAF_FOLDER.equals(cacheMap.get("STATE"))&&treeType.equals("kpi"))){
						newMap = new HashMap();
						newMap.put("id", cacheMap.get("ID"));
						newMap.put("column", cacheMap.get("COLUMN"));
						newMap.put("type", getTypeString(treeType,cacheMap.get("TYPE")+""));
						newMap.put("kpiType", treeType);
						newMap.put("isLeafFolder", KPI_LEAF_FOLDER.equals(cacheMap.get("STATE"))?"true":"false");
						if(KPI_LEAF.equals(cacheMap.get("STATE"))){
							if("true".equals(cacheMap.get("indent"))){
								newMap.put("name", KPI_LEAF.equals(cacheMap.get("STATE")) ?"&emsp;&emsp;"+cacheMap.get("TEXT"):cacheMap.get("TEXT"));
							}else{
								newMap.put("name", cacheMap.get("TEXT"));
							}
						}else{
							newMap.put("name", cacheMap.get("TEXT"));
						}
						g_childrenList.add(newMap);
						if(KPI_LEAF_FOLDER.equals(cacheMap.get("STATE"))&&treeType.equals("kpi")){
							getAllChildrenKpi(treeType,cacheMap.get("ID")+"",userId);
						}
				}
			}
		}
		
	}
	
	private String getTypeString(String treeType,String type){
		String result = "";
		if("kpi".equals(treeType)){
			if("1".equals(type)){
				result = "基础指标";
			}else if("2".equals(type)){
				result = "复合指标";
			}else{
				result = "其他";
			}
		}else{
			if("1".equals(type)){
				result = "日维度";
			}else if("2".equals(type)){
				result = "月维度";
			}else{
				result = "其他";
			}
		}
		return result;
	}
}