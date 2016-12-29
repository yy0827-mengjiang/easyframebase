package cn.com.easy.xbuilder.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import cn.com.easy.annotation.Service;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.kpi.interfaces.KpiMetadata;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.util.PinYinUtil;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Extcolumn;
import cn.com.easy.xbuilder.element.Report;

@Service("kpiSelectorService")
public class KpiSelectorService {
	
	private SqlRunner runner;
	
	/**
	 * 从指标库接口获取数据
	 * @param cubeId
	 * @param categories
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map<String, Object> getDataFromKpiLibrary(String cubeId,String categories,String xid) {
		Map<String,Object> resultMap = null ;
		try{
			
			HttpSession session = EasyContext.getContext().getRequest().getSession();
			String userId = ((Map)session.getAttribute("UserInfo")).get("USER_ID")+"";
			if(session.getAttribute("kpiSelectorMap")!=null&&((Map<String,Object>)session.getAttribute("kpiSelectorMap")).get(cubeId)!=null){
				resultMap = (Map<String,Object>)((Map<String,Object>)session.getAttribute("kpiSelectorMap")).get(cubeId);
				List mykpiList = (List)resultMap.get("mykpi");
				if(mykpiList!=null&&mykpiList.size()>1){
					mykpiList.remove(1);
					mykpiList.add(getCaculateColList(xid));
				}
			}else{
				String json = "";
//				if(cubeId.equals("1")){
//					json = "{\"kpi\": [{\"title\": \"统计类\", \"children\": [{\"id\": \"1\", \"column\": \"huawuliang\", \"desc\": \"话务量\", \"children\": [{\"id\": \"1_1\", \"column\": \"huawuliang_A\", \"desc\": \"话务量_今日值\"}, {\"id\": \"1_2\", \"column\": \"huawuliang_B\", \"desc\": \"话务量_昨日值\"}]}, {\"id\": \"2\", \"column\": \"tonghuashichang\", \"desc\": \"通话时长\", \"children\": [{\"id\": \"2_1\", \"column\": \"tonghuashichang_A\", \"desc\": \"通话时长_今日值\"}, {\"id\": \"2_2\", \"column\": \"tonghuashichang_B\", \"desc\": \"通话时长_昨日值\"}]}]}, {\"title\": \"收入类\", \"children\": [{\"id\": \"3\", \"column\": \"kuandai\", \"desc\": \"宽带收入\", \"children\": [{\"id\": \"3_1\", \"column\": \"kuandai_A\", \"desc\": \"宽带收入_今日值\"}, {\"id\": \"3_2\", \"column\": \"kuandai_B\", \"desc\": \"宽带收入_昨日值\"}]}, {\"id\": \"4\", \"column\": \"guwang\", \"desc\": \"固网收入\", \"children\": [{\"id\": \"4_1\", \"column\": \"guwang_A\", \"desc\": \"固网收入_今日值\"}, {\"id\": \"4_2\", \"column\": \"guwang_B\", \"desc\": \"固网收入_昨日值\"}]}]}], \"dim\": [{\"id\": \"5\", \"column\": \"acct_day\", \"desc\": \"日账期\"}, {\"id\": \"6\", \"column\": \"acct_month\", \"desc\": \"月账期\"}, {\"id\": \"7\", \"column\": \"area_no\", \"desc\": \"地市\"}], \"property\": [{\"id\": \"8\", \"column\": \"name\", \"desc\":\"姓名\"}, {\"id\": \"9\", \"column\": \"sex\", \"desc\": \"性别\"}]}";
//				}else{
//					json = "{\"kpi\": [{\"title\": \"统计类\", \"children\": [{\"id\": \"1\", \"column\": \"huawuliang\", \"desc\": \"话务量\", \"children\": [{\"id\": \"1_1\", \"column\": \"huawuliang_A\", \"desc\": \"话务量_今日值\"}, {\"id\": \"1_2\", \"column\": \"huawuliang_B\", \"desc\": \"话务量_昨日值\"}]}, {\"id\": \"2\", \"column\": \"tonghuashichang\", \"desc\": \"通话时长\", \"children\": [{\"id\": \"2_1\", \"column\": \"tonghuashichang_A\", \"desc\": \"通话时长_今日值\"}, {\"id\": \"2_2\", \"column\": \"tonghuashichang_B\", \"desc\": \"通话时长_昨日值\"}]}]}, {\"title\": \"收入类\", \"children\": [{\"id\": \"3\", \"column\": \"kuandai\", \"desc\": \"宽带收入\", \"children\": [{\"id\": \"3_1\", \"column\": \"kuandai_A\", \"desc\": \"宽带收入_今日值\"}, {\"id\": \"3_2\", \"column\": \"kuandai_B\", \"desc\": \"宽带收入_昨日值\"}]}, {\"id\": \"4\", \"column\": \"guwang\", \"desc\": \"固网收入\"}]}], \"dim\": [{\"id\": \"5\", \"column\": \"acct_day\", \"desc\": \"日账期\"}, {\"id\": \"6\", \"column\": \"acct_month\", \"desc\": \"月账期\"}, {\"id\": \"7\", \"column\": \"area_no\", \"desc\": \"地市\"}], \"property\": [{\"id\": \"8\", \"column\": \"name\", \"desc\":\"姓名\"}, {\"id\": \"9\", \"column\": \"sex\", \"desc\": \"性别\"}]}";
//				}
//				resultMap = (HashMap<String,Object>)Functions.json2java(json);
				
				resultMap = (new KpiMetadata()).getDimKpiData(cubeId, userId);
				List<Map> favList = getMyKpiList(cubeId);
				List<Map> caculateColList = getCaculateColList(xid); 
				List myKpiList = new ArrayList<Map>();
				myKpiList.add(favList);
				myKpiList.add(caculateColList);
				resultMap.put("mykpi", myKpiList);
				
				Map<String,String> myKpiIdMap = new HashMap<String,String>();
				for(Map map : favList){
					myKpiIdMap.put(String.valueOf(map.get("KPI_ID")) , "");
				}
				List<Map> kpiCategoryList = (List<Map>)resultMap.get("kpi");
				List<Map> kpiList;
				for(Map categoryMap : kpiCategoryList){
					kpiList = (List<Map>)categoryMap.get("children");
					if(kpiList==null){
						continue;
					}
					for(Map kpiMap : kpiList){
						if(myKpiIdMap.containsKey(kpiMap.get("id"))){
							kpiMap.put("favorite", '1');
						}else{
							kpiMap.put("favorite", '0');
						}
					}
				}
				if(session.getAttribute("kpiSelectorMap")==null){
					session.setAttribute("kpiSelectorMap", new HashMap<String,Object>());
				}
				((Map<String,Object>)session.getAttribute("kpiSelectorMap")).put(cubeId, resultMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return resultMap;
	}
	
	/**
	 * 刷新指标库
	 * @param cubeId
	 * @param categories
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> reload(String cubeId,String categories,String xid) {
		HttpSession session = EasyContext.getContext().getRequest().getSession();
		if(session.getAttribute("kpiSelectorMap")!=null&&((Map<String,Object>)session.getAttribute("kpiSelectorMap")).get(cubeId)!=null){
			((Map<String,Object>)session.getAttribute("kpiSelectorMap")).put(cubeId, null);
		}
		return getDataFromKpiLibrary(cubeId,categories,xid);
	}
	
	/**
	 * 获取指标库魔方列表
	 * @param userId
	 * @return
	 */
	public List<Map> getCubeList(String userId) {
		List<Map> resultList = new ArrayList<Map>();
//		String json = "[{\"id\":\"-1\",\"text\":\"--请选择魔方--\" }, {\"id\":\"1\",\"text\":\"日账指标\" }, {\"id\":\"2\",\"text\":\"月账指标\" }, {\"id\":\"3\",\"text\":\"经分指标\" }, {\"id\":\"4\",\"text\":\"网运指标\" }]";
//		resultList = (List<Map>)Functions.json2java(json);
		String sql = runner.sql("xbuilder.component.cubeList");
		try {
			resultList = (List<Map>)runner.queryForMapList(sql);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return resultList;
	}
	
	/**
	 * 根据关键字和首字母进行查询
	 * @param group
	 * @param keywords
	 * @param letter
	 * @param queryType
	 * @param category
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List queryData(String cubeId,String keywords,String letter,String queryType,String category) {
		HttpSession session = EasyContext.getContext().getRequest().getSession();
		List group = (List)((Map)((Map<String,Object>)session.getAttribute("kpiSelectorMap")).get(cubeId)).get(category);
		if((keywords==null||"".equals(keywords))&&(letter==null||"".equals(letter))){
			return group;
		}
		boolean keywordsUnionLetter = true;//是否是关键字和字母的组合查询
		ArrayList<HashMap<String,Object>> resultList = new ArrayList<HashMap<String,Object>>();
		List<Map> filterList;
		boolean keywordsBl = false;
		boolean letterBl = false;
		String firstLetter;
		if("kpi".equals(category) || "dim".equals(category)){
			Map groupItemMap;
			List<Map> kpiList;
			for(Object groupItem : group){
				groupItemMap = (Map)groupItem;
				kpiList=(List<Map>)groupItemMap.get("children");
				if(kpiList==null)
					continue;
				filterList = new ArrayList<Map>();
				for(Map kpiMap : kpiList){
					firstLetter = PinYinUtil.getFirstChar(String.valueOf(kpiMap.get("desc"))).toUpperCase();
					keywordsBl = String.valueOf(kpiMap.get("desc")).toUpperCase().indexOf(keywords.toUpperCase())!=-1;
				    letterBl = "".equals(letter)?true:letter.equals(firstLetter);
					if(keywordsUnionLetter){
						if(keywordsBl&&letterBl){
							filterList.add(kpiMap);
						}
					}else{
						if("keywords".equals(queryType)&&keywordsBl){
							filterList.add(kpiMap);
						}else if("letter".equals(queryType)&&letterBl){
							filterList.add(kpiMap);
						}
					}
				}
				if(filterList.size()>0){
					HashMap newGroupItemMap = new HashMap<String,Object>();
					newGroupItemMap.put("title", groupItemMap.get("title"));
					newGroupItemMap.put("children", filterList);
					resultList.add(newGroupItemMap);
				}
			}
		}else if("mykpi".equals(category)){
			HashMap<String,Object> itemMap;
			List searchList = new ArrayList<Map>();
			String descVar = "KPI_DESC";
			List<Object> tempList = null;
			for(Object item : group){
				tempList = (ArrayList<Object>)item;
				List validlist = new ArrayList();
				for(Object item2 : tempList){
					itemMap = (HashMap<String,Object>)item2;
					firstLetter = PinYinUtil.getFirstChar(String.valueOf(itemMap.get(descVar))).toUpperCase();
					keywordsBl = String.valueOf(itemMap.get(descVar)).toUpperCase().indexOf(keywords.toUpperCase())!=-1;
				    letterBl = "".equals(letter)?true:letter.equals(firstLetter);
				    
				    if(keywordsUnionLetter){
						if(keywordsBl&&letterBl){
							validlist.add(itemMap);
						}
					}else{
						if("keywords".equals(queryType)&&keywordsBl){
							tempList.add(itemMap);
						}else if("letter".equals(queryType)&&letterBl){
							validlist.add(itemMap);
						}
					}
				}
				searchList.add(validlist);
			}
			return searchList;
		}else{
			HashMap<String,Object> itemMap;
			List searchList = new ArrayList<Map>();
			String descVar = "desc";
			List<Object> tempList = (ArrayList<Object>)group;
			if(tempList!=null){
				for(Object item2 : tempList){
					itemMap = (HashMap<String,Object>)item2;
					firstLetter = PinYinUtil.getFirstChar(String.valueOf(itemMap.get(descVar))).toUpperCase();
					keywordsBl = String.valueOf(itemMap.get(descVar)).toUpperCase().indexOf(keywords.toUpperCase())!=-1;
				    letterBl = "".equals(letter)?true:letter.equals(firstLetter);
				    
				    if(keywordsUnionLetter){
						if(keywordsBl&&letterBl){
							searchList.add(itemMap);
						}
					}else{
						if("keywords".equals(queryType)&&keywordsBl){
							tempList.add(itemMap);
						}else if("letter".equals(queryType)&&letterBl){
							searchList.add(itemMap);
						}
					}
				}
			}
			return searchList;
		}
//		System.out.println("过滤结果："+Functions.java2json(resultList));
		return resultList;
	}
	
	/**
	 * 根据首字母排序
	 * @param cubeId
	 * @param letter
	 * @param keywords
	 * @param category
	 * @param sortType
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<HashMap<String,Object>> sort(String cubeId,String letter,String keywords,String category,String sortType) {
		List<HashMap<String,Object>> originalList = queryData(cubeId,keywords,letter,"keywords",category);
		List<HashMap<String,Object>> resultList = new ArrayList<HashMap<String,Object>>();
		if("kpi".equals(category) || "dim".equals(category)){
			String[] cateArr = new String[originalList.size()];
			String[] kpiDescArr ;
			Map categoryMap = new HashMap<String,Object>();
			Map kpiDescMap = new HashMap<String,Object>(); 
			Map groupItemMap;
			List<Map> kpiList;
			int i=0;
			for(Object groupItem : originalList){
				groupItemMap = (Map)groupItem;
				cateArr[i++] = String.valueOf(groupItemMap.get("title"));
				categoryMap.put(groupItemMap.get("title"), groupItemMap);
				if(groupItemMap.get("children")!=null){
					kpiDescMap = new HashMap<String,Object>(); 
					kpiList = (List<Map>)groupItemMap.get("children");
					kpiDescArr = new String[kpiList.size()];
					int index = 0;
					for(Map map : kpiList){
						kpiDescArr[index++] = String.valueOf(map.get("desc"));
						kpiDescMap.put(map.get("desc"), map);
					}
					Arrays.sort(kpiDescArr,new PinyinComparator());//指标排序
					List sortedKpiList = new ArrayList();
					if("asc".equals(sortType)){
						for(int j=0;j < kpiDescArr.length; j++){
							sortedKpiList.add(kpiDescMap.get(kpiDescArr[j]));
						}
					}else{
						for(int j=kpiDescArr.length-1;j>=0; j--){
							sortedKpiList.add(kpiDescMap.get(kpiDescArr[j]));
						}
					}
					groupItemMap.put("children", sortedKpiList);
				}
			}
			Arrays.sort(cateArr,new PinyinComparator());//指标类别排序
			if("asc".equals(sortType)){
				for(int j=0;j < cateArr.length; j++){
					resultList.add((HashMap<String,Object>)categoryMap.get(cateArr[j]));
				}
			}else{
				for(int j=cateArr.length-1;j>=0; j--){
					resultList.add((HashMap<String,Object>)categoryMap.get(cateArr[j]));
				}
			}
		}else{
			String[] cateArr = new String[originalList.size()];
			Map itemMap = new HashMap<String,Object>();
			Map groupItemMap;
			int i=0;
			String descVar = "mykpi".equals(category)?"KPI_DESC":"desc";
			for(Object groupItem : originalList){
				groupItemMap = (Map)groupItem;
				cateArr[i++] = String.valueOf(groupItemMap.get(descVar));
				itemMap.put(groupItemMap.get(descVar), groupItemMap);
			}
			Arrays.sort(cateArr,new PinyinComparator());
			if("asc".equals(sortType)){
				for(int j=0;j < cateArr.length; j++){
					resultList.add((HashMap<String,Object>)itemMap.get(cateArr[j]));
				}
			}else{
				for(int j=cateArr.length-1;j>=0; j--){
					resultList.add((HashMap<String,Object>)itemMap.get(cateArr[j]));
				}
			}
		}
		return resultList;
	}
	
	public static void main(String[] args) {
		String[] arr = new String[]{"吧统计类","啊收入类","左用户类","经分类","大小","参考"}; 
		Arrays.sort(arr,new PinyinComparator());
		for(String str : arr){
			System.out.println("===>"+str);
		}
	}
	
	/**
	 * 添加指标收藏
	 * @param kpiMap
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List addFavorite(String cubeId,Map kpiMap) {
		List resultList = new ArrayList<Object>();
		kpiMap.put("userId", ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID")+"");
		kpiMap.put("cubeId", cubeId);
		String sql = "insert into x_report_mykpi values(#userId#,#id#,#column#,#desc#,#category#,#cubeId#)";
		int size = 0;
		List<Map> mykpiList = new ArrayList<Map>();
		try {
			size = runner.execute(sql, kpiMap);
			//修改session中对应的kpi的favorite属性为1
			HttpSession session = EasyContext.getContext().getRequest().getSession();
			if(session.getAttribute("kpiSelectorMap")!=null&&((Map<String,Object>)session.getAttribute("kpiSelectorMap")).get(cubeId)!=null){
				Map<String,Object> resultMap = (Map<String,Object>)((Map<String,Object>)session.getAttribute("kpiSelectorMap")).get(cubeId);
				mykpiList = getMyKpiList(cubeId);
				resultMap.put("mykpi",mykpiList);
				List<Map> kpiCategoryList = (List<Map>)resultMap.get("kpi");
				List<Map> kpiList;
				for(Map categoryMap : kpiCategoryList){
					kpiList = (List<Map>)categoryMap.get("children");
					if(kpiList==null)
						continue;
					for(Map tempKpiMap : kpiList){
						if(kpiMap.get("id").equals(tempKpiMap.get("id"))){
							tempKpiMap.put("favorite", '1');
						}
					}
				}
				updateSessionCache(cubeId,resultMap);
			}
		} catch (SQLException e) {
			size = 0;
			e.printStackTrace();
		}
		resultList.add(String.valueOf(size)); 
		resultList.add(mykpiList); 
		return resultList;
	}
	/**
	 * 删除收藏的指标
	 * @param kpiId
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String removeFavorite(String cubeId,String kpiId) {
		String result = "";
		String userId = ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID")+"";
		Map paramMap = new HashMap<String,String>();
		paramMap.put("userId", userId);
		paramMap.put("kpiId", kpiId);
		paramMap.put("cubeId", cubeId);
		String sql = "delete from x_report_mykpi t where t.user_id = #userId# and t.kpi_id = #kpiId# and t.cube_id=#cubeId#";
		int size = 0;
		try {
			size = runner.execute(sql, paramMap);
			//修改session中对应的kpi的favorite属性为0
			HttpSession session = EasyContext.getContext().getRequest().getSession();
			if(session.getAttribute("kpiSelectorMap")!=null&&((Map<String,Object>)session.getAttribute("kpiSelectorMap")).get(cubeId)!=null){
				Map<String,Object> resultMap = (Map<String,Object>)((Map<String,Object>)session.getAttribute("kpiSelectorMap")).get(cubeId);
				resultMap.put("mykpi",getMyKpiList(cubeId));
				List<Map> kpiCategoryList = (List<Map>)resultMap.get("kpi");
				List<Map> kpiList;
				for(Map categoryMap : kpiCategoryList){
					kpiList = (List<Map>)categoryMap.get("children");
					if(kpiList==null)
						continue;
					for(Map kpiMap : kpiList){
						if(kpiId.equals(kpiMap.get("id"))){
							kpiMap.put("favorite", '0');
						}
					}
				}
				updateSessionCache(cubeId,resultMap);
			}
		} catch (SQLException e) {
			result = "0";
			e.printStackTrace();
		}
		result = String.valueOf(size); 
		return result;
	}
	
	/**
	 * 获取我的收藏的指标
	 * @param keywords
	 * @param letter
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<Map> getMyKpiList(String cubeId) {
		List resultList = new ArrayList<Map>() ;
		String userId = ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID")+"";
		Map paramMap = new HashMap<String,String>();
		paramMap.put("userId", userId);
		paramMap.put("cubeId", cubeId);
		String sql = "select * from x_report_mykpi t where t.user_id = #userId# and t.cube_id=#cubeId# order by kpi_category , kpi_desc ";
		try {
			resultList = runner.queryForMapList(sql, paramMap);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return resultList;
	}
	
	/**
	 * 获取计算列
	 * @param xid
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<Map> getCaculateColList(String xid) {
		Report report=XContext.getEditView(xid);
		List<Extcolumn> extColumnList=null;
		List<Map> resultMapList = new ArrayList<Map>();
		if(report.getExtcolumns()!=null&&report.getExtcolumns().getExtcolumnList()!=null){
			extColumnList = report.getExtcolumns().getExtcolumnList();
			Map extcolMap = null;
			for(Extcolumn extcolumn : extColumnList){
				extcolMap = new HashMap<String,String>();
				extcolMap.put("id", extcolumn.getId());
				extcolMap.put("text", extcolumn.getName());
				extcolMap.put("KPI_DESC", extcolumn.getName());
				resultMapList.add(extcolMap);
			}
		}
		return resultMapList;
	}
	
	@SuppressWarnings({ "unchecked" })
	private void updateSessionCache(String cubeId,Map<String,Object> cacheMap){
		HttpSession session = EasyContext.getContext().getRequest().getSession();
		if(session.getAttribute("kpiSelectorMap")!=null){
			((Map<String,Object>)session.getAttribute("kpiSelectorMap")).put(cubeId,cacheMap);
		}
	}
}

class PinyinComparator implements Comparator<String>{

	@Override
	public int compare(String arg0, String arg1) {
		char a = PinYinUtil.getFirstChar(arg0).charAt(0);
		char b = PinYinUtil.getFirstChar(arg1).charAt(0);
		return a - b;
	}  
	
}
/* 接口返回结果格式：
{
    "kpi": [
        {
            "title": "统计类", 
            "children": [
                {
                    "id": "1", 
                    "column": "area_no", 
                    "desc": "话务量", 
                    "children": {
                        "id": "1_1", 
                        "column": "area_no", 
                        "desc": "话务量_今日值"
                    }
                }
            ]
        }
    ], 
    "dim": [
        {
            "id": "1", 
            "column": "acct_day", 
            "desc": "日账期"
        }
    ], 
    "property": [
        {
            "id": "1", 
            "column": "name", 
            "desc": "姓名"
        }
    ]
}
*/ 