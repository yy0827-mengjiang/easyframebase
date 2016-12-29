package cn.com.easy.xbuilder.service;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import net.sf.json.JSONObject;
import cn.com.easy.ebuilder.parser.CommonTools;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Components;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Containers;
import cn.com.easy.xbuilder.element.Crosscol;
import cn.com.easy.xbuilder.element.Crosscolstore;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Datastore;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Event;
import cn.com.easy.xbuilder.element.Eventstore;
import cn.com.easy.xbuilder.element.Parameter;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Sortcol;
import cn.com.easy.xbuilder.element.SortcolStore;

public class CrossService {
	
	//行维度map
	private Map<String,String> dimRowMap = new LinkedHashMap<String,String>();
	//行维度dimRowWidth
	private Map<String,String> dimWidthMap = new LinkedHashMap<String,String>();
	//行维度dimRowAlign
	private Map<String,String> dimAlignMap = new LinkedHashMap<String,String>();
	//列维度map
	private Map<String,String> dimColMap = new LinkedHashMap<String,String>();
	//指标map
	private Map<String,String> kpiMap = new LinkedHashMap<String,String>();
	//指标kpiWidth
	private Map<String,String> kpiWidthMap = new LinkedHashMap<String,String>();
	//指标kpiAlign
	private Map<String,String> kpiAlignMap = new LinkedHashMap<String,String>();
	//指标合计kpiSum
	private Map<String,Double> kpiSumMap = new LinkedHashMap<String,Double>();
	//指标总计kpiSumRow
	private Map<String,Double> kpiSumRowMap = new LinkedHashMap<String,Double>();
	//指标总计kpiSumCol
	private Map<String,Double> kpiSumColMap = new LinkedHashMap<String,Double>();
	private Map<String,String> paramMap = new HashMap<String,String>();
	private String reportId="";
	private String fileType="";
	//计算colspan的list
	private List<String> colspanList = new ArrayList<String>();
	@SuppressWarnings("unchecked")
	private List fileList = new ArrayList();

	//构造方法
	public CrossService(Component comp,String reportId,String fileType,Map<String,String> pMap){
		//初始化
		this.dimRowMap = this.getDataRow(comp);
		this.dimColMap = this.getDataCol(comp);
		this.dimWidthMap = this.getdimWidth(comp);
		this.dimAlignMap = this.getdimAlign(comp);
		this.kpiMap = this.getDataKpi(comp);
		this.kpiWidthMap = this.getkpiWidth(comp);
		this.kpiAlignMap = this.getkpiAlign(comp);
		this.kpiSumColMap = this.getkpiSum(comp);
		this.reportId = reportId;
		this.fileType = fileType;
		paramMap = pMap;
		colspanList = this.getMapKeyToList(dimColMap);
	}
	
	//列表 datagrid
	public Map<String,String> createTable(Component comp){
		Map<String,String> map = new HashMap<String,String>();
		
		return map;
	}
	
	//树型 treegrid
	public Map<String,String> createTreegrid(Component comp){
		Map<String,String> map = new HashMap<String,String>();
		
		return map;
	}
	
	
	//表头生成方法
	@SuppressWarnings("unchecked")
	public Map createTitle(Component comp,List<Map> resList){
		Map titleMap = new HashMap();
		List<String> kpiValue = new ArrayList<String>();
		StringBuffer title = new StringBuffer();
		//title.append("<thead>");
		
		//合计方式(合计方式:0:不合计、1:行合计、2:列合计、3:行列都合计;默认为0不合计)
		String sumtype = comp.getSumtype();
		//合并行数
		int rowspan = dimColMap.size()+1;
		
//		//计算colspan的值
//		List<String> cols = this.getColspan(comp, kpiMap, dimColMap, resList);
//		//倒序排列colspan的值
//		List<String> colspan = this.descList(cols);
		
		Map<String,Integer> sumMap = this.repeatMapSum(resList, dimColMap);
		
		
		//最后下一行的列数
		String lastStr = "";//this.lastDimCol(comp);
		List<Map> lastMap = new ArrayList<Map>();//this.resRepeat(resList, lastStr);
		
		//去掉维度列重复数据
		List<String> list = this.repeatSum(resList, dimColMap);
		List<Map> descColMap = this.resRepeat(resList, dimColMap);
		
		//格式化
		String script="";
		//第一列的值
		int first=0;
		
		if(dimColMap.size()>0){
			int i=0;
			for(Map.Entry<String, String> col : dimColMap.entrySet()){
				lastStr =this.lastDimCol(comp,i);
				lastMap = this.resRepeat(resList, lastStr);
				this.setFiledList(lastStr, lastMap);
				title.append("<tr class='ui-th'>");
				if(i==0){
					if(dimRowMap.size()>0){
						for(Map.Entry<String, String> row : dimRowMap.entrySet()){
							Map<String,String> fmt = this.strDimHead(comp, row.getKey(), i);
							String flg = fmt.get("flg");
							script+=fmt.get("script");
							if("true".equals(flg)){
								title.append("<th halign='center' field='"+row.getKey()+"' width='"+dimWidthMap.get(row.getKey())+"' align='"+dimAlignMap.get(row.getKey())+"' rowspan='"+rowspan+"' "+fmt.get("tdFmt")+" >"+row.getValue()+"</th>");
							}else{
								title.append("<th halign='center' field='"+row.getKey()+"' width='"+dimWidthMap.get(row.getKey())+"' align='"+dimAlignMap.get(row.getKey())+"' rowspan='"+rowspan+"'>"+row.getValue()+"</th>");
							}
							
						}
						String tmp = list.get(i);
						int step = Integer.valueOf(tmp);
						first= step;
						for(int j=0;j<step;j++){
							if(j==0){
								//判断合计
								if("2".equals(sumtype) || "3".equals(sumtype)){
									//添加合计
									title.append("<th halign='center' align='center' colspan='"+kpiMap.size()+"' rowspan='"+dimColMap.size()+"'>合计</th>");
								}
							}
							Map map = descColMap.get(j);
							this.removeColspanList(col.getKey());
							int size=0;
							int csi =0;
							if(dimColMap.size()==1){
								size=dimColMap.size();
								csi = this.getFristColspan(sumMap, size);
							}else{
								size=lastMap.size();
								csi = this.getFristColspan(sumMap, size);
							}
							title.append("<th halign='center' align='"+dimAlignMap.get(col.getKey())+"' colspan='"+csi+"'>"+map.get(col.getKey())+"</th>");
						}
					}
				}else{
					if(i==0){
						String ftemp = list.get(i);
						first=Integer.valueOf(ftemp);
					}else{
						String ftemp = list.get(i-1);
						first = Integer.valueOf(ftemp);
					}
					for(int k=0;k<first;k++){
						String tmp = list.get(i);
						int step = Integer.valueOf(tmp);
						this.removeColspanList(col.getKey());
						int csi = this.getColspan(sumMap, col.getKey());
						for(int j=0;j<step;j++){
							Map map = lastMap.get(j);
							title.append("<th halign='center' align='"+dimAlignMap.get(col.getKey())+"' colspan='"+csi+"' >"+map.get(col.getKey())+"</th>");
						}
					}
				}
				title.append("</tr>");
				i++;
			}
		}
	//	System.out.println(title);
		
		
		List<String> lastColList = this.splitListToMap();
		//最后一列
		title.append("<tr class='ui-th'> ");
		
		//判断合计
		if("2".equals(sumtype) || "3".equals(sumtype)){
			for(Map.Entry<String, String> kpi : kpiMap.entrySet()){
				title.append("<th halign='center' field='"+kpi.getKey()+"' width='"+kpiWidthMap.get(kpi.getKey())+"' align='"+kpiAlignMap.get(kpi.getKey())+"'>"+kpi.getValue()+"</th>");
			}
		}
		for(int j=0;j<lastColList.size();j++){
			for(Map.Entry<String, String> kpi : kpiMap.entrySet()){
				String astr = lastColList.get(j);
				String cstr = astr+"|"+kpi.getKey();
				kpiValue.add(cstr);
				//是否有格式化
				Map<String,String> fmt = this.strKpiHead(comp, kpi.getKey(),cstr,j);
				String flg = fmt.get("flg");
				script+=fmt.get("script");
				if("true".equals(flg)){
					title.append("<th halign='center' field='"+cstr+"' width='"+kpiWidthMap.get(kpi.getKey())+"' align='"+kpiAlignMap.get(kpi.getKey())+"' "+fmt.get("tdFmt")+" >"+kpi.getValue()+"</th>");	
				}else{
					title.append("<th halign='center' field='"+cstr+"' width='"+kpiWidthMap.get(kpi.getKey())+"' align='"+kpiAlignMap.get(kpi.getKey())+"'>"+kpi.getValue()+"</th>");	
				}
			}
		}
		title.append("</tr>");
	//	title.append("</thead>");
		
		titleMap.put("title", title.toString());
		titleMap.put("kpiValue", kpiValue);
		titleMap.put("script", script);
		return titleMap;
	}
	
	//数据方法
	@SuppressWarnings("unchecked")
	public Map getDataJson(Component comp,List<Map> resList,List<String> kpiValue){
		String jsonStr = "";
		//合计方式:0:不合计、1:行合计、2:列合计、3:行列都合计;默认为0不合计
		String sumtype = comp.getSumtype();
		StringBuffer rowData = new StringBuffer();
		String lastRow = this.lastDimRow(comp);
		String rowkey = this.getRowsData(comp);
		List<String> dimAll =  this.allDimData(comp);
		List<String> rowsList = this.lastDimRowsData(comp, resList, rowkey);
		List<Map<String,Double>> sumRowList = new ArrayList<Map<String,Double>>();
		List<Map<String,String>> listDataJson = new ArrayList<Map<String,String>>();
		//循环行
		for(int i=0;i<rowsList.size();i++){
			//数据结果Map(用于转换map)
			Map<String,String> dataMap = new LinkedHashMap<String,String>();
			//初始化合计
			this.kpiSumMap = this.getkpiSum(comp);
			String resData="";
			String row = rowsList.get(i);
			//循环列
			for(int j=0;j<kpiValue.size();j++){
				String key = kpiValue.get(j);
				String value = this.querResData(row, key, resList, dimAll,lastRow,dataMap);
				resData +=value;
			}
			//拼维度
			String r = this.rowsAssembling(row,dataMap);
			resData = resData+r;
			resData = resData.substring(0,resData.length()-1);
			
			//维度列
			sumRowList.add(kpiSumRowMap);
			kpiSumRowMap = new LinkedHashMap<String,Double>();
			
			if("2".equals(sumtype) || "3".equals(sumtype)){
				//合计列值转换成String
				String resSum = this.sumMapToStr(dataMap);
				resData = resData+resSum;
			}
			//存入json转换结果
			listDataJson.add(dataMap);
			rowData.append("{");
			rowData.append(resData);
			rowData.append("},");
		}
		
		if("1".equals(sumtype) || "3".equals(sumtype)){
			String rowSumJson = this.sumRowKpiSum(kpiValue, sumRowList,lastRow);
			Map<String,String> sum = this.strToMap(rowSumJson);
			listDataJson.add(0,sum);
			rowData.insert(0, rowSumJson);
			
		}
		
		/**
		 * 测试ListMap的值
		 */
//		for(Map<String,String> map:listDataJson){
//			System.out.println(map);
//		}
		
		jsonStr = rowData.toString();
		jsonStr = jsonStr.substring(0,jsonStr.length()-1);
		jsonStr = "["+jsonStr+"]";
		
		Map resMap = new HashMap();
		resMap.put("jsonStr", jsonStr);
		resMap.put("jsonList", listDataJson);
		
		return resMap;
	}
	
	//获得行合并的值
	public String getRowsData(Component comp){
		String rows="";
		Map<String,String> rowData = new HashMap<String,String>();
		rowData = this.getDataRow(comp);
		if(rowData!=null){
			for(Map.Entry<String, String> map : rowData.entrySet()){
				rows += map.getKey()+",";
			}
		}
		rows = rows.substring(0, rows.length()-1);
		
		return rows;
	}
	
	//找出一行一列的结果
	@SuppressWarnings("unchecked")
	public String querResData(String row,String col,List<Map> resList,List<String> dimAll,String lastRow,Map<String,String> dataMap){
		StringBuffer resStr = new StringBuffer();
		String flg="false";
		String[] coldata = col.split("\\|");
		String kpi = coldata[coldata.length-1];
		List<String> listA = this.arrayToList(coldata,kpi);
		String[] rows = row.split("\\|");
		for(String r:rows){
			listA.add(r);
		}
		String strValue="";
		//获得每行的维度值
		for(Map map:resList){
			List<String> listB = new ArrayList<String>();
			for(String dim:dimAll){
				//每一行的值
				String str = (String)map.get(dim);
				listB.add(str);
			}
			//比较值两个list中的数据
			flg = this.compareToList(listA, listB);
			//flg==true 的话证明 有值
			if("true".equals(flg)){
				Object obj = map.get(kpi);
				String s = String.valueOf(obj);
				Double v = Double.valueOf(s);
				//列存入map
				dataMap.put(col, s);
				strValue = "'"+col+"':'"+s+"',";
				//列合计
				this.sumColKpiSum(kpi, s);
				this.sumKpiSum(kpi, s);
				//行合计
				kpiSumRowMap.put(col, v);
				break;
			}else{
				//列存入map
				dataMap.put(col, "0");
				strValue = "'"+col+"':'0',";
				kpiSumRowMap.put(col, 0.0);
			}
		}
		resStr.append(strValue);
		return resStr.toString();
	}
	
	//取当前Map中的 sql 并 拼装SQL语句
	public String getSqlByGroup(Component comp,String sqlMap){
		StringBuffer sql = new StringBuffer();
		sql.append("select "+this.getDimValue(comp)+","+this.getKpiValue(comp)+" ");
		sql.append("from( ");
		sqlMap = sqlMap.replaceAll("\\{", "");
		sqlMap = sqlMap.replaceAll("\\}", "");
		sql.append(sqlMap);
		sql.append(" ) aa ");
		sql.append(" group by "+this.getDimValue(comp)+" ");
		String order = this.getOrderValue(comp);
		if(!"".equals(order) && order!=null){
			sql.append("order by "+order+" ");
		}
		return sql.toString();
	}
	
	//获得select语句中的维度
	public String getDimValue(Component comp){
		String dim = "";
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(Crosscol col:crosscolList){
			dim += col.getDimfield()+",";
		}
		if(!"".equals(dim)&&dim.length()>0){
			dim = dim.substring(0,dim.length()-1);
		}
		return dim;
	}
	
	//获得select语句中的指标
	public String getKpiValue(Component comp){
		String kpi="";
		Datastore datastore = comp.getDatastore();
		List<Datacol> datacolList = datastore.getDatacolList();
		for(Datacol datacol:datacolList){
			kpi += "sum("+datacol.getDatacolcode()+")  "+datacol.getDatacolcode()+",";
		}
		if(!"".equals(kpi)&&kpi.length()>0){
			kpi = kpi.substring(0,kpi.length()-1);
		}
		return kpi;
	}
	
	//获得select语句中的 排序
	public String getOrderValue(Component comp){
		String order="";
		SortcolStore sorts = comp.getSortcolStore();
		if(sorts!=null){
			List<Sortcol> sortcolList = sorts.getSortcolList();
			if(sortcolList!=null && sortcolList.size()>0){
				for(Sortcol sortcol:sortcolList){
					order += sortcol.getCol()+" "+sortcol.getType()+",";
				}
				if(!"".equals(order)&&order.length()>0){
					order = order.substring(0,order.length()-1);
				}
			}
		}
		return order;
	}
	
	
	//获得行map
	public Map<String,String> getDataRow(Component comp){
		Map<String,String> dimMap = new LinkedHashMap<String,String>();
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(int i=0;i<crosscolList.size();i++){
			Crosscol cross = crosscolList.get(i);
			String type = cross.getType();
			if("1".equals(type)){
				dimMap.put(cross.getDimfield(), cross.getDimdesc());
			}
		}
		return dimMap;
	}
	
	//获得维度dimWidth
	public Map<String,String> getdimWidth(Component comp){
		Map<String,String> map = new LinkedHashMap<String,String>();
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(int i=0;i<crosscolList.size();i++){
			Crosscol cross = crosscolList.get(i);
			map.put(cross.getDimfield(), cross.getTableheadwidth());
		}
		return map;
	}
	
	//获得维度dimAlign
	public Map<String,String> getdimAlign(Component comp){
		Map<String,String> map = new LinkedHashMap<String,String>();
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(int i=0;i<crosscolList.size();i++){
			Crosscol cross = crosscolList.get(i);
			map.put(cross.getDimfield(), cross.getTableheadalign());
		}
		return map;
	}
	
	//获得列map
	public Map<String,String> getDataCol(Component comp){
		Map<String,String> dimMap = new LinkedHashMap<String,String>();
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(Crosscol cross:crosscolList){
			String type = cross.getType();
			if("2".equals(type)){
				dimMap.put(cross.getDimfield(), cross.getDimdesc());
			}
		}
		return dimMap;
	}
	
	//获得指标map
	public Map<String,String> getDataKpi(Component comp){
		Map<String,String> kpiMap = new LinkedHashMap<String,String>();
		Datastore datastore = comp.getDatastore();
		List<Datacol> datacolList = datastore.getDatacolList();
		for(Datacol datacol:datacolList){
			kpiMap.put(datacol.getDatacolcode(), datacol.getTablecoldesc());
		}
		return kpiMap;
	}
	
	//获得指标合计kpiSum
	public Map<String,Double> getkpiSum(Component comp){
		Map<String,Double> map = new LinkedHashMap<String,Double>();
		Datastore datastore = comp.getDatastore();
		List<Datacol> datacolList = datastore.getDatacolList();
		for(Datacol datacol:datacolList){
			map.put(datacol.getDatacolcode(), 0.0);
		}
		return map;
	}
	
	//获得指标kpiWidth
	public Map<String,String> getkpiWidth(Component comp){
		Map<String,String> map = new LinkedHashMap<String,String>();
		Datastore datastore = comp.getDatastore();
		List<Datacol> datacolList = datastore.getDatacolList();
		for(Datacol datacol:datacolList){
			map.put(datacol.getDatacolcode(), datacol.getTableheadwidth());
		}
		return map;
	}
	
	//获得指标kpiAlign
	public Map<String,String> getkpiAlign(Component comp){
		Map<String,String> map = new LinkedHashMap<String,String>();
		Datastore datastore = comp.getDatastore();
		List<Datacol> datacolList = datastore.getDatacolList();
		for(Datacol datacol:datacolList){
			map.put(datacol.getDatacolcode(), datacol.getTableheadalign());
		}
		return map;
	}
	
	//获得最后一列的值
	public String lastDimCol(Component comp,int s){
		List<String> mapList = new ArrayList<String>();
		String lastStr="";
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		if(crosscolList.size()>0){
			for(int i=0;i<crosscolList.size();i++){
				Crosscol cross = crosscolList.get(i);
				String type = cross.getType();
				if("2".equals(type)){
					int j = Integer.valueOf(cross.getIndex());
					mapList.add(j,cross.getDimfield());
				}
			}
			lastStr=mapList.get(s);
		}
		return lastStr;
	} 
	
	//获得最后一行的值
	public String lastDimRow(Component comp){
		List<String> mapList = new ArrayList<String>();
		String lastStr="";
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		if(crosscolList.size()>0){
			for(int i=0;i<crosscolList.size();i++){
				Crosscol cross = crosscolList.get(i);
				String type = cross.getType();
				if("1".equals(type)){
					int j = Integer.valueOf(cross.getIndex());
					mapList.add(j,cross.getDimfield());
				}
			}
			lastStr=mapList.get(mapList.size()-1);
		}
		return lastStr;
	}
	
	
	//获得最后一行的值
	@SuppressWarnings("unchecked")
	public List<String> lastDimRowsData(Component comp,List<Map> resList,String rowkey){
		List<String> temp = new ArrayList<String>();
		String[] dimRow = rowkey.split(",");
		for(Map map:resList){
			String tmp="";
			for(int i=0;i<dimRow.length;i++){
				tmp +=(String)map.get(dimRow[i])+"|";
			}
			tmp = tmp.substring(0,tmp.length()-1);
			temp.add(tmp);
		}
		List<String> list = new ArrayList<String>();
		//去掉重复的list
		for(String str:temp){
			 if(!list.contains(str)){
				 list.add(str);
			 }
		}
		return list;
	}
	
	
	//取出所有维度
	public List<String> allDimData(Component comp){
		List<String> dim = new ArrayList<String>();
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(int i=0;i<crosscolList.size();i++){
			Crosscol cross = crosscolList.get(i);
			dim.add(cross.getDimfield());
		}
		return dim;
	}
	
	
	//计算colspan的值
	@SuppressWarnings("unchecked")
	public int getFristColspan(Map<String,Integer> sumMap,int size){
		//lastMap = this.resRepeat(resList, key);
		int colspan = 1;
		int kpisize = kpiMap.size();
		for(String s:colspanList){
			int f=sumMap.get(s);
			colspan = colspan*f;
		}
		colspan = colspan*kpisize;
		return colspan;
	} 
	
	//计算colspan的值
	@SuppressWarnings("unchecked")
	public int getColspan(Map<String,Integer> sumMap,String key){
		//lastMap = this.resRepeat(resList, key);
		int colspan = 1;
		int kpisize = kpiMap.size();
		for(String s:colspanList){
			int f=sumMap.get(s);
			colspan = colspan*f;
		}
		colspan = colspan*kpisize;
		return colspan;
	} 
	
	//Map(key)转List
	public List<String> getMapKeyToList(Map<String,String> dimColMap){
		List<String> list = new ArrayList<String>();
		for(Map.Entry<String, String> map : dimColMap.entrySet()){
			list.add(map.getKey());
		}
		return list;
	}
	//
	public void removeColspanList(String key){
		for(int i = 0; i < colspanList.size(); i++){
			if (((String) colspanList.get(i)).startsWith(key)){
				colspanList.remove(i);
			}
		}
	}
	
	
	//
	@SuppressWarnings("unchecked")
	public Map<String,Integer> repeatMapSum(List<Map> resList,Map<String,String> dimColMap){
		Map<String,Integer> resmap = new HashMap<String,Integer>();
		for(Map.Entry<String, String> col : dimColMap.entrySet()){
			List<Map> list = new ArrayList<Map>();
			 for(int i=0;i<resList.size();i++){
				 Map map = resList.get(i);
				 Map<String,String> maptmp = new HashMap<String,String>();
				 maptmp.put((String)col.getKey(), (String)map.get(col.getKey()));
				 list.add(maptmp);
			 }
			 List<Map>tempList = new ArrayList<Map>();
			 for(Map m:list){
				 if(!tempList.contains(m)){
					 tempList.add(m);
				 }
			 }
			 resmap.put(col.getKey(), tempList.size());
			 //colspan.add(String.valueOf(tempList.size()));
		}
		//System.out.println(resmap);
		return resmap;
	}
	
	//存列名
	@SuppressWarnings("unchecked")
	public void setFiledList(String key,List<Map> lastMap){
		List<String> list = new ArrayList<String>();
		for(Map map:lastMap){
			list.add(map.get(key)+"");
		}
		fileList.add(list);
	}
	//解列名
	public List<String> splitListToMap() {
		Map<String,Object> map = new LinkedHashMap<String,Object>();
		int size = 1;
		for(int i = 0; i < fileList.size(); i++) {
			List list =(List) fileList.get(i);
			size = size * list.size();
		} 
		for(int i = 0; i < fileList.size(); i++) {
			List<String> list = (List<String>) fileList.get(i);
			int maxSize = size/list.size();
			List<String> tmpList = new ArrayList<String>();
			if(i == fileList.size() -1) {
				for(int j = 0; j < maxSize; j++) {
					for(String s: list) {
						tmpList.add(s);
					}
				}
			} else {
				for(String s: list) {
					for(int j = 0; j < maxSize; j++) {
						tmpList.add(s);
					}
				}
			}
			map.put(String.valueOf(i), tmpList);
		}
		Set set = map.keySet(); 
		Iterator it = set.iterator();
		Map<String,Object> lastMap = new LinkedHashMap<String,Object>();
		while(it.hasNext()) {
			List list = (List) map.get(it.next());
			for(int i = 0;i < list.size(); i++) {
				if(lastMap.containsKey(String.valueOf(i))) {
					lastMap.put(String.valueOf(i), lastMap.get(String.valueOf(i)) + "|" + list.get(i));
				} else {
					lastMap.put(String.valueOf(i), list.get(i));
				}
			}
		}
		
		List<String> resList = new ArrayList<String>();
		
		for(Map.Entry<String, Object> last : lastMap.entrySet()){
			resList.add((String)last.getValue());
		}
		
		return resList;
	}
	//解列名
	@SuppressWarnings("unchecked")
	public List<String> getFiledList(int sun){
		List<String> res = new ArrayList<String>();
		for(int i=0;i<fileList.size();i++){
			List<String> list =  (List<String>) fileList.get(i);
			if(list.size()==sun){
				res = list;
				break;
			}
		}
		return res;
	}
	
	// 计算列的循环次数
	public int getlastColSum(int all){
		
		int s = kpiMap.size();
		
		int res = all/s;
		
		return res;
	}
	
	
	//计算colspan的值
	@SuppressWarnings("unchecked")
	public List<String> getColspan(Component comp,Map<String,String> kpiMap,Map<String,String> dimColMap,List<Map> resList){
		List<String> colspan = new ArrayList<String>();
		//去掉重复维度列值
		List<String> list = this.repeatSum(resList, dimColMap);
		for(int i=0;i<list.size();i++){
			if(i==0){
				int sum = (i+1)*kpiMap.size();
				colspan.add(String.valueOf(sum));
			}else{
				String temp = list.get(i);
				int sp = Integer.valueOf(temp);
				int sum = sp*kpiMap.size();
				colspan.add(String.valueOf(sum));
			}
		}
		return colspan;
	} 
	
	
	//去掉重复维度值
	@SuppressWarnings("unchecked")
	public List<String> repeatSum(List<Map> resList,Map<String,String> dimColMap){
		List<String> colspan = new ArrayList<String>();
		for(Map.Entry<String, String> col : dimColMap.entrySet()){
			List<Map> list = new ArrayList<Map>();
			 for(int i=0;i<resList.size();i++){
				 Map map = resList.get(i);
				 Map<String,String> maptmp = new HashMap<String,String>();
				 maptmp.put((String)col.getKey(), (String)map.get(col.getKey()));
				 list.add(maptmp);
			 }
			 List<Map> tempList = new ArrayList<Map>();
			 for(Map m:list){
				 if(!tempList.contains(m)){
					 tempList.add(m);
				 }
			 }
			 colspan.add(String.valueOf(tempList.size()));
		}
		return colspan;
	}
	
	//去掉重复维度列
	@SuppressWarnings("unchecked")
	public List<Map> resRepeat(List<Map> resList,String lastStr){
		List<Map> tempList = new ArrayList<Map>();
		List<Map> list = new ArrayList<Map>();
		for(int i=0;i<resList.size();i++){
			Map map = resList.get(i);
			Map<String,String> maptmp = new HashMap<String,String>();
			maptmp.put(lastStr, (String)map.get(lastStr));
			list.add(maptmp);
		}
		for(Map m:list){
			 if(!tempList.contains(m)){
				 tempList.add(m);
			 }
		 }
	    return tempList;
	}
	
	//去掉重复维度列
	@SuppressWarnings("unchecked")
	public List<Map> resRepeat(List<Map> resList,Map<String,String> dimColMap){
		List<Map> tempList = new ArrayList<Map>();
		for(Map.Entry<String, String> col : dimColMap.entrySet()){
			List<Map> list = new ArrayList<Map>();
			 for(int i=0;i<resList.size();i++){
				 Map map = resList.get(i);
				 Map<String,String> maptmp = new HashMap<String,String>();
				 maptmp.put((String)col.getKey(), (String)map.get(col.getKey()));
				 list.add(maptmp);
			 }
			 for(Map m:list){
				 if(!tempList.contains(m)){
					 tempList.add(m);
				 }
			 }
		}
		return tempList;
	}
	
	//倒序排列List的值 
	public List<String> descList(List<String> list){
		List<String> colspan = new ArrayList<String>();
		for(int i=list.size()-1;i>=0;i--){
			String tmp = list.get(i);
			colspan.add(tmp);
		}
		return colspan;
	}
	
	//Map取key的名字
	public String MapToStr(Map<String,String> map){
		String key="";
		for(Map.Entry<String, String> col : map.entrySet()){
			key = col.getValue();
		}
		return key;
	}
	
	//数组转list
	public List<String> arrayToList(String[] str,String kpi){
		List<String> list = new ArrayList<String>();
		for(int i=0;i<str.length;i++){
			if(!str[i].equals(kpi)){
				list.add(str[i]);
			}
		}
		return list;
	}
	
	//比较两个list的结果
	public String compareToList(List<String> a,List<String> b){
		String flg = "true";
		Collections.sort(a);
	    Collections.sort(b);
	    for(int i=0;i<a.size();i++){
	    	 if(!a.get(i).equals(b.get(i))){
	    		 flg="false";
	    	 }
	    }
	    return flg;
	}
	
	//拼装行数据
	public String rowsAssembling(String row,Map<String,String> dataMap){
		String str="";
		String[] rows = row.split("\\|");
		int i=0;
		for(Map.Entry<String, String> dim : dimRowMap.entrySet()){
			str +="'"+dim.getKey()+"':'"+rows[i]+"',"; 
			//存Map
			dataMap.put(dim.getKey(), rows[i]);
			i++;
		}
		return str;
	}
	
	//指标列相加
	public void sumColKpiSum(String key,String value){
		Double sum = kpiSumMap.get(key);
		Double v = Double.valueOf(value);
		sum=sum+v;
		DecimalFormat df = new DecimalFormat("#.00"); 
		String s = df.format(sum);
		sum = Double.valueOf(s);
		kpiSumMap.put(key, sum);
	}
	
	//指标列总数相加
	public void sumKpiSum(String key,String value){
		Double sum = kpiSumColMap.get(key);
		Double v = Double.valueOf(value);
		sum=sum+v;
		DecimalFormat df = new DecimalFormat("#.00");  
		String s = df.format(sum);
		sum = Double.valueOf(s);
		kpiSumColMap.put(key, sum);
	}
	
	//指标行相加
	//rowSumJson="{'c网|KPI2':'999','c网|KPI3':'999','宽带|KPI2':'999','宽带|KPI3':'999','CODE':'','NAME':'总计','KPI2':'999','KPI3':'999'},";
	public String sumRowKpiSum(List<String> kpiValue,List<Map<String,Double>> sumRowList,String lastRow){
		StringBuffer rowJson = new StringBuffer();
		Map<String,Double> mapVal = new HashMap<String,Double>();
		for(String s:kpiValue){
			mapVal.put(s, 0.0);
		}
		String rowStr = "";
		for(int i=0;i<sumRowList.size();i++){
			Map<String,Double> row = sumRowList.get(i);
			for(String key:kpiValue){
				Double sum = row.get(key);
				Double v = mapVal.get(key);
				mapVal.put(key, sum+v);
			}
		}
		for(Map.Entry<String, Double> map : mapVal.entrySet()){
			rowStr+="'"+map.getKey()+"':'"+map.getValue()+"',";
		}
		for(Map.Entry<String, Double> map : kpiSumColMap.entrySet()){
			rowStr+="'"+map.getKey()+"':'"+map.getValue()+"',";
		}
		rowStr+=lastRow+":'总计'";
		rowJson.append("{");
		rowJson.append(rowStr);
		rowJson.append("},");
		return rowJson.toString();
	}
	
	//合计列值转换成String
	public String sumMapToStr(Map<String,String> dataMap){
		String res = "";
		for(Map.Entry<String, Double> map : kpiSumMap.entrySet()){
			res +=",'"+map.getKey()+"':'"+map.getValue()+"'";
			Double val = map.getValue();
			String str = String.valueOf(val);
			dataMap.put(map.getKey(), str);
		}
		return res;
	}
	
	//字符串Json转换面map
	@SuppressWarnings("unchecked")
	public Map<String,String> strToMap(String rowSumJson){
		rowSumJson = rowSumJson.substring(0,rowSumJson.length()-1);
		Map<String,String> map = new HashMap<String,String>();
		map = (Map<String,String>)JSONObject.toBean(JSONObject.fromObject(rowSumJson),Map.class);
		return map;
	}
	
	// 工具方法，判断字符串是否为空，剔空格
	private boolean notNull(String s) {
		try {
			if (s != null && !s.equals("") && s.trim().length() > 0) {
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {
			return false;
		}
	}
	
	//去掉Map对象为空的值
	@SuppressWarnings("static-access")
	public Map<String,String> mapNotNull(Map<String,String> paramMap){
		CommonTools commontools_type = new CommonTools();
		Map<String,String> res = new HashMap<String,String>();
		for(Map.Entry<String, String> map : paramMap.entrySet()){
			String isMessyCode_type="";
			String isMessyCode_type_type="";
			if(map.getValue()!=null&&!"".equals(map.getValue())){
				try{
					isMessyCode_type = map.getValue();
					isMessyCode_type = isMessyCode_type!=null?new String(isMessyCode_type.getBytes("ISO-8859-1"),"UTF-8"):"";
					isMessyCode_type_type = map.getValue();
					isMessyCode_type_type = isMessyCode_type_type!=null?new String(isMessyCode_type_type.getBytes("ISO-8859-1"),"gb2312"):"";
				}catch(Exception e){
					e.printStackTrace();
				}
				//转码
				if(!commontools_type.isMessyCode(isMessyCode_type)){
					res.put(map.getKey(),isMessyCode_type);
				}
				else if(!commontools_type.isMessyCode(isMessyCode_type_type)){
					res.put(map.getKey(),isMessyCode_type_type);
				}
			}
		}
		return res;
	}
	
	//获得sql语句中{}的部分 替换为空
	public String getMeasuresInFormula(String formula,Map<String,String> paramMap) {
		List<String> measures = new ArrayList<String>();
		Pattern p = Pattern.compile("\\{(.*?)\\}");  
		Matcher m = p.matcher(formula);  
		while(m.find()){  
			measures.add(m.group(1));  
		}
		if(measures!=null&&measures.size()>0){
			for(int i=0;i<measures.size();i++){
				String condition = measures.get(i);
				for(Map.Entry<String, String> map : paramMap.entrySet()){
					String key = "#"+map.getKey()+"#";
					String val = map.getValue();
					if("".equals(val) || val==null || val=="null"){
						if(condition.indexOf(key)!=-1){
							formula = formula.replace(condition, "");
						}
					}
				}
			}
		}
		return formula;
	}
	
	//存联动ID
	public Map<String,String> getComp2cont(String reportId,String sourceId){
		Map<String,String> resMap = new HashMap<String,String>();
		XBaseService base = new XBaseService();
		Report report = base.readFromXmlByViewId(reportId);
		Containers containers = report.getContainers();
		List<Container> containerList = containers.getContainerList();
		for(Container container:containerList){
			String containerId= container.getId();
			Components components = container.getComponents();
			List<Component> componentList =components.getComponentList();
			for(Component component :componentList){
				String componentId = component.getId();
				if(sourceId.equals(componentId)){
					resMap.put(sourceId, containerId);
				}
			}
		}
		
		return resMap;
	}
	
	//获取查询条件为js对象
	public Map<String,String> getResObj(String reportId){
		Report report = XContext.getEditView(reportId);
		Map<String,String> parammap = new HashMap<String,String>();
		if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null&&report.getDimsions().getDimsionList().size()>0){
		   for(Dimsion dim : report.getDimsions().getDimsionList()){
			   if (dim.getIsparame().equals("0")) {
				   String value = paramMap.get(dim.getVarname());
				   if(value!=null&&!"".equals(value)){
					   parammap.put(dim.getVarname(),value);
				   }
				   
			   }
		   }
		}
		return parammap;
	}
	
	/**
	 * 格式化维度
	 */
	public Map<String,String>strDimHead(Component comp,String key,int i){
		Map<String,String> map = new HashMap<String,String>();
		String flg = "";
		String tdFmt="";
		StringBuffer script = new StringBuffer();
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(Crosscol cro:crosscolList){
			String field = cro.getDimfield();
			if(key.equals(field)){
				//联动维度 有没有连动
				boolean event = (cro.getEventstore()!=null && cro.getEventstore().getEventList()!=null && cro.getEventstore().getEventList().size()>0)?true:false;
				if(event){
					flg="true";
					String fun1 = key + "_"+cro.getId()+i;
					tdFmt = "formatter='"+fun1+"'";
					//拼script方法
					script.append("function " + fun1 + "(val,obj){").append("\n");
					script.append("var v = val;").append("\n");
					
					Map<String,String> parammap = this.getResObj(reportId);
					Eventstore eventstore = cro.getEventstore();
					Map<String,StringBuffer> paraMap = new HashMap<String,StringBuffer>();
					StringBuffer paraObj_Value = new StringBuffer();
					StringBuffer paraValue = new StringBuffer();
					StringBuffer paraStrs = new StringBuffer();
					List<Event> events = eventstore.getEventList();
					Map<String,String> comp2cont = new HashMap<String,String>();
					String fieldexd = "";
					
					for(int e=0;e<events.size();e++){
						StringBuffer paraObj = new StringBuffer();
						List<Parameter> parameters = events.get(e).getParameterList();
						if(parameters != null && parameters.size()>0){
							for(int para=0;para<parameters.size();para++){
								String value = parameters.get(para).getValue()+fieldexd;
								if(value != null && !value.equals("")){
									String pname = parameters.get(para).getName();
									paraObj.append(pname+":"+value+",");
									if(parammap.containsKey(pname)){
										parammap.remove(pname);
									}
									paraObj_Value.append("\\''+obj."+value+"+'\\',");
									paraValue.append(value+",");
									paraStrs.append(pname+"='+"+value+"+'&");
								}
							}
							if(paraObj.length()>0){
								paraObj.deleteCharAt(paraObj.length()-1).insert(0,"{").append("}");
								paraMap.put(events.get(e).getSource(), paraObj);
								comp2cont = this.getComp2cont(reportId, events.get(e).getSource());
							}
						}else{
							paraMap.put(events.get(e).getSource(), paraObj);
							comp2cont = this.getComp2cont(reportId, events.get(e).getSource());
						}
					}
					if(paraObj_Value.length()>0){
						paraObj_Value.deleteCharAt(paraObj_Value.length()-1);
						paraValue.deleteCharAt(paraValue.length()-1);
						paraStrs.deleteCharAt(paraStrs.length()-1);
					}
					
					script.append("return '<a href=\"javascript:void(0);\"  style=\"text-decoration:underline;\" onclick=\"F"+comp.getId() + "_"+ cro.getDimfield()+"_event("+paraObj_Value.toString()+");\">");
					script.append("'+v+'</a>';").append("\n}").append("\n");
					script.append("function F"+comp.getId() + "_"+ cro.getDimfield()+"_event("+paraValue.toString()+"){").append("\n");
					
					String type = cro.getEventstore().getType();
					
					if(type.equals("link")){
						String linkurl = events.get(0).getSource();
						script.append("window.open(appBase+'/pages/xbuilder/usepage/formal/"+ linkurl+ "/formal_"+ linkurl + ".jsp?a=1'+dimStr+'&"+paraStrs.toString()+"${urlParam}');");
					}else if(type.equals("cas")){
						for(String k:paraMap.keySet()){
							String queryParam = "";
							if(parammap.size()>0){
								for(String pkey:parammap.keySet()){
									queryParam += "&"+pkey+"="+parammap.get(pkey).replaceAll("'","");
								}
							}
							script.append("var dimStr = '&c=1';").append("\n");
							script.append("var divHeadLi_"+k+"=$('#div_head_li_"+comp2cont.get(k)+"_"+k+"');\n");
							script.append("if(divHeadLi_"+k+".parent().attr('ultype')=='r'){//切换\n");
							script.append("$('#div_head_li_"+comp2cont.get(k)+"_"+k+"').addClass('selected-tab-r').attr('selectLi','true').siblings('li').removeClass('selected-tab-r').removeAttr('selectLi');\n");
							script.append("}else if(divHeadLi_"+k+".parent().attr('ultype')=='l'){//选项卡\n");
							script.append("$('#div_head_li_"+comp2cont.get(k)+"_"+k+"').attr('selectLi','true').find('a').addClass('selected-tab-l').parent().siblings('li').removeAttr('selectLi').find('a').removeClass('selected-tab-l');\n");
							script.append("}\n$('#div_body_"+comp2cont.get(k)+"').html('');\n");
							script.append("$('#div_body_"+comp2cont.get(k)+"').load(appBase+'/pages/xbuilder/usepage/"+this.fileType+"/"+this.reportId+"/comp_"+k+".jsp"+"?componentId="+k+"&containerId="+comp2cont.get(k)+"'+dimStr+'&"+paraStrs.toString()+queryParam+"',function(data){\n");
							script.append("$.parser.parse($('#div_body_"+comp2cont.get(k)+"'));});\n");
						}
					}
					script.append("\n}");
					
				}
			}
		}
		
		map.put("script", script.toString());
		map.put("tdFmt", tdFmt);
		map.put("flg",flg);
		return map;
	}
	
	
	/**
	 * 表格使用。将xml中头源数据，解析为组件可用的头代码。 1、删除掉没使用的td 2、剃掉td中所有的class和style样式。
	 * 3、将设置的td属性，添加进来，如宽度，格式化等。 4、删除掉没使用的tr 2014-10-31 修改：返回为map，包含表头和列的格式化函数
	 */
	private Map<String, String> strKpiHead(Component comp,String key,String filed,int i){
		Map<String,String> map = new HashMap<String,String>();
		String flg = "";
		String tdFmt="";
		Datastore datastore = comp.getDatastore();
		StringBuffer script = new StringBuffer();
		List<Datacol> datacolList = datastore.getDatacolList();
		for(Datacol datacol:datacolList){
			String datacode = datacol.getDatacolcode();
			if(key.equals(datacode)){
				// 格式化数据：是否设置边界判断
				boolean isFmtBD = notNull(datacol.getDatafmtisbd())	&& datacol.getDatafmtisbd().toLowerCase().equals("1");
				// 格式化数据类型
				boolean dFmtT = !datacol.getDatafmttype().equals("common");
				// 格式化数据：是否显示千位符
				boolean dFmtTD = notNull(datacol.getDatafmtthousand())&& datacol.getDatafmtthousand().toLowerCase().equals("1");
				// 格式化数据：是否显示增减箭头
				boolean dArrow = notNull(datacol.getDatafmtisarrow())&& datacol.getDatafmtisarrow().toLowerCase().equals("1");
				//联动指标 有没有连动
				boolean event = (datacol.getEventstore() != null && datacol.getEventstore().getEventList() != null&& datacol.getEventstore().getEventList().size() >0)?true:false;//联动
				
				String suffixUP = dArrow ? "&uarr;" : "";// ↑
				String suffixDW = dArrow ? "&darr;" : "";// ↓
				
				//判断是否存在格式化
				if(isFmtBD || dFmtTD || dArrow || dFmtT ||event){
					flg="true";
					String fun1 = key + "_"+comp.getId()+i;
					tdFmt = "formatter='"+fun1+"'";
					//拼script方法
					script.append("function " + fun1 + "(val,obj){").append("\n");
					script.append("var v = val;").append("\n");
					
					if(dFmtT){
						if (datacol.getDatafmttype().equals("percent")) {
							script.append("v = transformValue(obj['" + filed + "'],"+ datacol.getDatadecimal()+ ",100,'%'," + dFmtTD + ");").append("\n");
						} else {
							script.append("v = transformValue(obj['" + filed + "'],"+ datacol.getDatadecimal()+ ",1,''," + dFmtTD + ");").append("\n");
						}
					}
					if (isFmtBD) {
						script.append("if(obj['" + filed + "'] >= "+ datacol.getDatafmtisbdvalue()+ "){").append("\n");
						script.append("v='<font color="+ datacol.getDatafmtbdup()+ ">'+v+'" + suffixUP+ "</font>';").append("\n");
						script.append("}else{").append("\n");
						script.append("v='<font color="+ datacol.getDatafmtbddown()+ ">'+v+'" + suffixDW+ "</font>';").append("\n");
						script.append("}").append("\n");
					}
					script.append("return v;}");
					
					if(event){
						Map<String,String> parammap = this.getResObj(reportId);
						Eventstore eventstore = datacol.getEventstore();
						Map<String,StringBuffer> paraMap = new HashMap<String,StringBuffer>();
						StringBuffer paraObj_Value = new StringBuffer();
						StringBuffer paraValue = new StringBuffer();
						StringBuffer paraStrs = new StringBuffer();
						List<Event> events = eventstore.getEventList();
						Map<String,String> comp2cont = new HashMap<String,String>();
						String fieldexd = "";
						
						for(int e=0;e<events.size();e++){
							StringBuffer paraObj = new StringBuffer();
							List<Parameter> parameters = events.get(e).getParameterList();
							if(parameters != null && parameters.size()>0){
								for(int para=0;para<parameters.size();para++){
									String value = parameters.get(para).getValue()+fieldexd;
									if(value != null && !value.equals("")){
										String pname = parameters.get(para).getName();
										paraObj.append(pname+":"+value+",");
										if(parammap.containsKey(pname)){
											parammap.remove(pname);
										}
										paraObj_Value.append("\\''+obj."+value+"+'\\',");
										paraValue.append(value+",");
										paraStrs.append(pname+"='+"+value+"+'&");
									}
								}
								if(paraObj.length()>0){
									paraObj.deleteCharAt(paraObj.length()-1).insert(0,"{").append("}");
									paraMap.put(events.get(e).getSource(), paraObj);
									comp2cont = this.getComp2cont(reportId, events.get(e).getSource());
								}
							}else{
								paraMap.put(events.get(e).getSource(), paraObj);
								comp2cont = this.getComp2cont(reportId, events.get(e).getSource());
							}
						}
						
						if(paraObj_Value.length()>0){
							paraObj_Value.deleteCharAt(paraObj_Value.length()-1);
							paraValue.deleteCharAt(paraValue.length()-1);
							paraStrs.deleteCharAt(paraStrs.length()-1);
						}
						script.delete(script.length()-10, script.length());
						
						script.append("return '<a href=\"javascript:void(0);\"  style=\"text-decoration:underline;\" onclick=\"F"+comp.getId() + "_"+ datacol.getDatacolcode()+"_event"+i+"("+paraObj_Value.toString()+");\">");
						script.append("'+v+'</a>';").append("\n}").append("\n");
						script.append("function F"+comp.getId() + "_"+ datacol.getDatacolcode()+"_event"+i+"("+paraValue.toString()+"){").append("\n");
						
						String type = datacol.getEventstore().getType();
						
						if(type.equals("link")){
							String linkurl = events.get(0).getSource();
							script.append("window.open(appBase+'/pages/xbuilder/usepage/formal/"+ linkurl+ "/formal_"+ linkurl + ".jsp?a=1'+dimStr+'&"+paraStrs.toString()+"${urlParam}');");
						}else if(type.equals("cas")){
							for(String k:paraMap.keySet()){
								String queryParam = "";
								if(parammap.size()>0){
									for(String pkey:parammap.keySet()){
										queryParam += "&"+pkey+"="+parammap.get(pkey).replaceAll("'","");
									}
								}
								script.append("var dimStr = '&c=1';").append("\n");
								script.append("var divHeadLi_"+k+"=$('#div_head_li_"+comp2cont.get(k)+"_"+k+"');\n");
								script.append("if(divHeadLi_"+k+".parent().attr('ultype')=='r'){//切换\n");
								script.append("$('#div_head_li_"+comp2cont.get(k)+"_"+k+"').addClass('selected-tab-r').attr('selectLi','true').siblings('li').removeClass('selected-tab-r').removeAttr('selectLi');\n");
								script.append("}else if(divHeadLi_"+k+".parent().attr('ultype')=='l'){//选项卡\n");
								script.append("$('#div_head_li_"+comp2cont.get(k)+"_"+k+"').attr('selectLi','true').find('a').addClass('selected-tab-l').parent().siblings('li').removeAttr('selectLi').find('a').removeClass('selected-tab-l');\n");
								script.append("}\n$('#div_body_"+comp2cont.get(k)+"').html('');\n");
								script.append("$('#div_body_"+comp2cont.get(k)+"').load(appBase+'/pages/xbuilder/usepage/"+this.fileType+"/"+this.reportId+"/comp_"+k+".jsp"+"?componentId="+k+"&containerId="+comp2cont.get(k)+"'+dimStr+'&"+paraStrs.toString()+queryParam+"',function(data){\n");
								script.append("$.parser.parse($('#div_body_"+comp2cont.get(k)+"'));});\n");
							}
						}
						script.append("\n}");
						
					}
					
					
				}
				
			}
		}
		map.put("script", script.toString());
		map.put("tdFmt", tdFmt);
		map.put("flg",flg);
		return map;
	}
	
}
