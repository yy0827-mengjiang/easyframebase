package cn.com.easy.xbuilder.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import net.sf.json.JSONArray;

import cn.com.easy.annotation.Service;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.ebuilder.util.ListUtil;
import cn.com.easy.ebuilder.util.StringUtil;
import cn.com.easy.util.SqlUtils;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Datasources;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Report;

@Service("sqlSelectorService")
public class SqlSelectorService {
	
	/**
	 * 判断有没有数据集
	 * @param xid
	 * @return
	 */
	public boolean isDataSources(String xid){
		boolean flg = false;
		Report report = new Report();
		XBaseService base = new XBaseService();
		report = base.readFromXmlByViewId(xid);
		Datasources datasources = report.getDatasources();
		if(datasources!=null){
			List<Datasource> datasource = datasources.getDatasourceList();
			if(datasource!=null && datasource.size()>0){
				flg = true;
			}
		}
		return flg;
	}
	
	
	/**
	 * 获是元数据sql中的列名
	 * @param xid
	 * @return
	 */
	public String getMetadataDataSource(String xid){
		List<Map<String,List<String>>> resList = new ArrayList<Map<String,List<String>>>();
		Report report = new Report();
		XBaseService base = new XBaseService();
		report = base.readFromXmlByViewId(xid);
		Datasources datasources = report.getDatasources();
		if(datasources!=null){
			List<Datasource> datasource = datasources.getDatasourceList();
			if(datasource!=null && datasource.size()>0){
				for(int i=0;i<datasource.size();i++){
					Datasource sour = datasource.get(i);
					Map<String,String> mapSource = new HashMap<String,String>();
					mapSource.put("sourceName", sour.getName());
					mapSource.put("sourceId", sour.getId());
					//去掉{}部分
					String sql = this.getMeasuresInFormula(sour.getSql());
					mapSource.put("sql", sql);
					if(!"".equals(sour.getExtds())&&sour.getExtds()!=null){
						mapSource.put("extds", sour.getExtds());
					}else{
						mapSource.put("extds", "");
					}
					Map<String,List<String>> resMap = this.getListColumn(mapSource);
					resList.add(i,resMap);
				}
			}
		}
		JSONArray json = JSONArray.fromObject(resList); 
		String jsonStr = json.toString();
		return jsonStr;
	}
	
	/**
	 * 去掉{}中的部分
	 * @param sql
	 * @return
	 */
	public String getMeasuresInFormula(String formula){
		List<String> measures = new ArrayList<String>();
		Pattern p = Pattern.compile("\\{(.*?)\\}");  
		formula = replaceBlank(formula);
		String sql = formula.replaceAll("\n", "\t");
		Matcher m = p.matcher(sql);  
		while(m.find()){  
			measures.add(m.group(1));  
		}
		if(measures!=null&&measures.size()>0){
			for(int i=0;i<measures.size();i++){
				String condition = measures.get(i);
				formula = formula.replace(condition, "");
			}
			formula = formula.replace("{", "").replaceAll("}", "");
		}
		return formula;
	}
	
	/**
	 * 去掉字符串中特殊符
	 * @param sql
	 * @return
	 */
	public String replaceBlank(String sql){
		String s="";
		Pattern p = Pattern.compile("\t|\r|\n");
		Matcher m = p.matcher(sql);	
		s = m.replaceAll(" ");
		return s;
	}
	
	/**
	 * 根据元数据中的sql获得到列名
	 * @param mapSource
	 * @return
	 */
	public Map<String,List<String>> getListColumn(Map<String,String> mapSource){
		//jdbc连接对象
		Connection conn = null;
		PreparedStatement stat = null;
		EasyDataSource datasource = null;
		Map<String,List<String>> resMap = new HashMap<String,List<String>>();
		List<String> colList = new ArrayList<String>();
		String sql = mapSource.get("sql");
		String sourceId = mapSource.get("sourceId");
		String sourceName = mapSource.get("sourceName");
		String extds = mapSource.get("extds");
		try{
			if(!"".equals(extds)&&extds!=null){
				datasource = EasyContext.getContext().getDataSource(extds);
			}else{
				datasource = EasyContext.getContext().getDataSource();
			}
			conn = datasource.getConnection();
			stat = conn.prepareStatement(sql);
			ResultSet rs = stat.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCnt  = rsmd.getColumnCount();
			//先取列名
			for(int i=1;i<=columnCnt;i++){
				colList.add(rsmd.getColumnName(i).toLowerCase());
			}
			resMap.put(sourceId+";"+sourceName, colList);
			rs.close();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try{
				if(stat != null){
					stat.close();
				}
				if(conn != null){
					conn.close();
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return resMap;
	}
	
	/**
	 * 获得源数据中的查询条件
	 * @param reportId
	 * @return
	 */
	public  List<Map<String,String>> getRestrainVar(String reportId){
		List<Map<String,String>> parameterNameMap = new ArrayList<Map<String,String>>();
		Report reportObj=XContext.getEditView(reportId);
		//获取源数据现有的查询条件
		List<Dimsion> dimList= null;
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		boolean rsTem = true;
		if(reportObj.getDimsions() !=null && reportObj.getDimsions().getDimsionList() !=null){
			dimList = reportObj.getDimsions().getDimsionList();
			for(Dimsion dim : dimList){
				Map<String,String> dimMap = new HashMap<String,String>();
				dimMap.put("id",dim.getId());
				String type = getStringValue(dim.getType());
				if(type.equals("")) type = "INPUT";
				dimMap.put("type",type);
				dimMap.put("varname",dim.getVarname());
				dimMap.put("table",dim.getTable());
				dimMap.put("field",dim.getField());
				dimMap.put("desc",dim.getDesc());
				dimMap.put("codecolumn",dim.getCodecolumn());
				dimMap.put("desccolumn",dim.getDesccolumn());
				dimMap.put("level",dim.getLevel());
				dimMap.put("ordercolumn",dim.getOrdercolumn());
				dimMap.put("parentcol",dim.getParentcol());
				dimMap.put("parentdimname",dim.getParentdimname());
				dimMap.put("isselectm",dim.getIsselectm());
				dimMap.put("index",dim.getIndex());
				dimMap.put("sql",dim.getSql().getSql().replaceAll("\n", "").replaceAll("\r", ""));
				dimMap.put("database",dim.getSql().getExtds());
				dimMap.put("createtype",dim.getCreatetype());
				dimMap.put("defaultvalue",dim.getDefaultvalue());
				dimMap.put("isparame",dim.getIsparame());
				dimMap.put("formula",dim.getFormula());
				dimMap.put("showtype",dim.getShowtype());
				dimMap.put("fieldid",dim.getFieldid());
				dimMap.put("fieldtype",dim.getFieldtype());
				dimMap.put("datasourceid", dim.getDatasourceid());
				dimMap.put("conditiontype", dim.getConditiontype());
				dimMap.put("vardesc", dim.getVardesc());
				rsTem = false;
				parameterNameMap.add(dimMap);
			}
		}
		if(!rsTem) {
			try {
				listSort(resultList);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
//		for(Map s:parameterNameMap){
//			System.out.println(s);
//		}
		return parameterNameMap;
	}
	
	/**
	 * 过滤空
	 * @param string
	 * @return
	 */
	public static String getStringValue(String string) {
		if (string != null && !string.equals("")
				&& !string.toLowerCase().equals("undefined")
				&& !string.toLowerCase().equals("null")) {
			return string.trim();
		} else {
			return "";
		}
	}
	
	/**
	 * 指定字段排序
	 * @param resultList
	 * @throws Exception
	 */
	 public static void listSort(List<Map<String, Object>> resultList)
			throws Exception {
		Collections.sort(resultList, new Comparator<Map<String, Object>>() {
			public int compare(Map<String, Object> o1, Map<String, Object> o2) {
				String sstr1 = (String) o1.get("index");
				String sstr2 = (String) o2.get("index");
				if (sstr1 == null || sstr1.equals(""))
					sstr1 = "0";
				if (sstr2 == null || sstr2.equals(""))
					sstr2 = "0";
				Integer s1 = Integer.parseInt(sstr1);
				Integer s2 = Integer.parseInt(sstr2);
				if (s1 > s2) {
					return 1;
				} else {
					return -1;
				}
			}
		});
	} 
	 
 	/**
	 * 获取约束列表
	 * @param dataSql 数据源SQL
	 * @return 
	 */
	public List<String> getRestrain(String dataSql) {
		dataSql = StringUtil.formatSql(dataSql, "{", "}");
		List<String> parameterNames = new ArrayList<String>();
		SqlUtils.parseParameter(dataSql, parameterNames);
		parameterNames = ListUtil.removeDuplicateWithOrder(parameterNames);
		return parameterNames;
	}
}
