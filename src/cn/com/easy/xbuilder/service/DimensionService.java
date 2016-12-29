package cn.com.easy.xbuilder.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import cn.com.easy.annotation.Service;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.ebuilder.parser.CommonTools;
import cn.com.easy.ebuilder.util.ListUtil;
import cn.com.easy.ebuilder.util.StringUtil;
import cn.com.easy.kpi.interfaces.KpiMetadata;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.util.SqlUtils;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Dimsions;
import cn.com.easy.xbuilder.element.Link;
import cn.com.easy.xbuilder.element.Query;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Sql;
import cn.com.easy.xbuilder.kpi.XDataSourceSql;

@Service
public class DimensionService extends XBaseService  {
	private String classPath = this.getClass().getClassLoader().getResource("/").getPath();
	private String FormalPagePath = "pages/xbuilder/usepage/formal/";
	private SqlRunner runner;

	private String getDimTypeName(String type) {
		String cnName = "";
		if ("INPUT".equals(type)) {
			cnName = "文本";
		} else if ("DAY".equals(type)) {
			cnName = "日账期";
		} else if ("MONTH".equals(type)) {
			cnName = "月账期";
		} else if ("SELECT".equals(type)) {
			cnName = "下拉框";
		} else if ("CASELECT".equals(type)) {
			cnName = "多级联动";
		} else if ("HIDDEN".equals(type)) {
			cnName = "隐藏域";
		}
		return cnName;
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
	
	public  List<Map> getRestrainVar(String reportId){
		List<String> parameterNames = new ArrayList<String>();
		List<Map> parameterNameMap = new ArrayList<Map>();
		Report reportObj=XContext.getEditView(reportId);
		List<Datasource> datasourceList = null;
		List<String> dimRs = new ArrayList<String>();
		if(reportObj.getDatasources()!=null&&reportObj.getDatasources().getDatasourceList()!=null){
			datasourceList = reportObj.getDatasources().getDatasourceList();
			for(Datasource datasource:datasourceList){
				List<String> paramNames = new ArrayList<String>();
				paramNames = getRestrain(datasource.getSql());
				parameterNames.addAll(paramNames);
			}
		}
		parameterNames = ListUtil.removeDuplicateWithOrder(parameterNames);
		//获取源数据现有的查询条件
		List<Dimsion> dimList= null;
		boolean dimStatus = false;
		if(reportObj.getDimsions() !=null && reportObj.getDimsions().getDimsionList() !=null){
			dimList = reportObj.getDimsions().getDimsionList();
			dimStatus = true;
			//删除源数据中的多余的dimsion节点(sql中已不存在的)
			for(String parameter: parameterNames){
				for(Dimsion dim : dimList){
					if(!parameterNames.contains(dim.getVarname())){
						dimList.remove(dim);
						break;
					}
				}
			}
		}
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		for(String parameter: parameterNames){
			Map dimMap = new HashMap();
			boolean rsTem = true;
			if(dimStatus)
			for(Dimsion dim : dimList){
				if(dim.getVarname().equals(parameter)){
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
					dimMap.put("sql",dim.getSql().getSql().replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\t", " "));
					dimMap.put("database",dim.getSql().getExtds());
					dimMap.put("createtype",dim.getCreatetype());
					dimMap.put("defaultvalue",dim.getDefaultvalue());
					dimMap.put("isparame",dim.getIsparame());
					dimMap.put("formula",dim.getFormula());
					dimMap.put("showtype",dim.getShowtype());
					dimMap.put("fieldid",dim.getFieldid());
					dimMap.put("fieldtype",dim.getFieldtype());
//暂时没有用到这些					
//					dimMap.put("id", parameter);
//					dimMap.put("varname", parameter);
//					dimMap.put("desc", dim.getVarname());
//					dimMap.put("name", dim.getVarname());
//					dimMap.put("ischeck", "0");//默认不选中
					rsTem = false;
					break;
				}
			}
			if(rsTem){
				dimMap.put("id", parameter);
				dimMap.put("varname", parameter);
				dimMap.put("desc", "参数("+parameter+")");
				dimMap.put("type", "INPUT");
				dimMap.put("name", "参数("+parameter+")");
				dimMap.put("ischeck", "0");//默认不选中
			}
			parameterNameMap.add(dimMap);
			if(!rsTem) {
				try {
					listSort(resultList);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return parameterNameMap;
	}
	public String addDimsionForKpi(String reportId) throws Exception {
		Report reportObj=XContext.getEditView(reportId);
		XDataSourceSql  dataSourceSql = new XDataSourceSql(reportObj);
		dataSourceSql.setAllSql();
		return "1";
	}
	/**
	 * 删除维度（指标库）
	 * @param reportId
	 * @param var_name
	 * @return
	 */
	public String delDimsion(String reportId, String var_name) {
		Report reportObj = XContext.getEditView(reportId);
		List<Dimsion> dimList= null;
		if(reportObj.getDimsions() !=null && reportObj.getDimsions().getDimsionList() !=null){
			dimList = reportObj.getDimsions().getDimsionList();
			//删除源数据中的dimsion节点
			for(Dimsion dim : dimList){
				if(var_name.equals(dim.getVarname())){
					dimList.remove(dim);
					break;
				}
			}
		}
		reportObj.getDimsions().setDimsionList(dimList);
		saveToXmlByObj(reportObj);
		return reportId;
	}
	/**
	 * 添加(修改)维度
	 * @param reportId
	 * @param jsonString
	 * @return
	 */
	public String addDimsion(String reportId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Dimsions dimList = reportObj.getDimsions();
		Dimsion dimsion=null;
		Map element=(Map)Functions.json2java(jsonString);
		Boolean isAdd=true;
		if(dimList==null){
			Dimsions dimsions=new Dimsions();
			dimsions.setDimsionList(new ArrayList<Dimsion>());
			reportObj.setDimsions(dimsions);
		}else{
			List<Dimsion> dimsionList=reportObj.getDimsions().getDimsionList();
			if(dimsionList!=null){
				for(Dimsion dim : dimsionList){
					if(dim.getVarname().equals(element.get("var_name"))){
						dimsion=dim;
						isAdd=false;
						break;
					}
				}
			}else{
				reportObj.getDimsions().setDimsionList(new ArrayList<Dimsion>());
			}
		}
		
		if(dimsion==null){
			dimsion=new Dimsion();
		}   
		if(isAdd)   //cn.com.easy.xbuilder.utils.StringUtil.getDataSequence()
			dimsion.setId("DIM_"+UUID.randomUUID().toString().replaceAll("-", ""));
		dimsion.setCodecolumn(getStringValue(""+element.get("codecolumn")));
		dimsion.setDesc(getStringValue(""+element.get("desc")));
		dimsion.setDesccolumn(getStringValue(""+element.get("desccolumn")));
		dimsion.setField(getStringValue(""+element.get("field")));
		String index = getStringValue(""+element.get("index"));
		if(!index.trim().equals(""))
			dimsion.setIndex(getStringValue(""+element.get("index")));
		dimsion.setIsselectm(getStringValue(""+element.get("isselectm")));
		dimsion.setLevel(getStringValue(""+element.get("level")));
		dimsion.setOrdercolumn(getStringValue(""+element.get("ordercolumn")));
		dimsion.setParentcol(getStringValue(""+element.get("parentcol")));
		dimsion.setParentdimname(getStringValue(""+element.get("parentdimname")));
		dimsion.setTable(getStringValue(""+element.get("table")));
		dimsion.setType(getStringValue(""+element.get("type")));
		dimsion.setVarname(getStringValue(""+element.get("var_name")));
		dimsion.setCreatetype(getStringValue(""+element.get("createtype")));
		dimsion.setDefaultvalue(getStringValue(""+element.get("defaultvalue")));
		//常量，用户属性
		dimsion.setDefaultValueType(getStringValue(""+element.get("defaultvaluetype")));
		dimsion.setDatasourceid(getStringValue(""+element.get("datasourceid")));
		dimsion.setConditiontype(getStringValue(""+element.get("conditiontype")));
		dimsion.setVardesc(getStringValue(""+element.get("vardesc")));
		
		Sql sql=new Sql();
		sql.setExtds(getStringValue(""+element.get("extds")));
		sql.setSql(getStringValue(""+element.get("sql")));
		dimsion.setSql(sql);
		String isparame = getStringValue(""+element.get("isparame")).replaceAll("\n", "").replaceAll("\r", "");
		if(!isparame.trim().equals("")) dimsion.setIsparame(isparame);
		else dimsion.setIsparame("0");
		if("2".equals(reportObj.getInfo().getType())) {
			if(!"".equals(getStringValue(""+element.get("formula")))) {
				dimsion.setFormula(getStringValue(""+element.get("formula")));
			}
			if(!"".equals(getStringValue(""+element.get("fieldid")))) {
				dimsion.setFieldid(getStringValue(""+element.get("fieldid")));
			} 
			if(!"".equals(getStringValue(""+element.get("fieldtype")))) {
				dimsion.setFieldtype(getStringValue(""+element.get("fieldtype")));
			}  
		} else {
			dimsion.setFormula(getStringValue(""+element.get("formula")));
			dimsion.setFieldid(getStringValue(""+element.get("fieldid")));
			dimsion.setFieldtype(getStringValue(""+element.get("fieldtype")));
		}
		dimsion.setShowtype(getStringValue(""+element.get("showtype")));
		if(isAdd){
			if(dimsion.getVarname() != null && !"".equals(dimsion.getVarname())) {
				reportObj.getDimsions().getDimsionList().add(dimsion);
			}
		}
		if(dimsion.getVarname() != null && !"".equals(dimsion.getVarname())) {
			saveToXmlByObj(reportObj);
		}
		return dimsion.getId();
	}
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
	 * 获取编辑的维度(用于回显约束条件属性)
	 */
	public String getEditDimsion(String reportId,String dimVarName){
		String result="";
		Report reportObj=XContext.getEditView(reportId);
		if(reportObj.getDimsions()!=null&&reportObj.getDimsions().getDimsionList()!=null){
			for(Dimsion dim : reportObj.getDimsions().getDimsionList()){
				if(dim.getVarname().equals(dimVarName)){
					result=Functions.java2json(dim);
					break;
				}
			}
		}
		return result;
	}
	/**
	 * 
	 * @param reportId
	 */
	public void removeAllDimsion(String reportId){
		Report reportObj=XContext.getEditView(reportId);
		Dimsions dimsions = new Dimsions();
		reportObj.setDimsions(dimsions);
		saveToXmlByObj(reportObj);
	}
	/**
	 * 添加查询条件
	 * @param reportId
	 * @param dimsionId
	 */
	public void addQueryLink(String reportId,String dimsionId){
		Report reportObj=XContext.getEditView(reportId);
		if(reportObj.getQuery()==null){
			Query queryObj=new Query();
			queryObj.setLinkList(new ArrayList<Link>());
			reportObj.setQuery(queryObj);
		}else{
			if(reportObj.getQuery().getLinkList()==null){
				reportObj.getQuery().setLinkList(new ArrayList<Link>());
			}
		}
		Link link=new Link();
		removeQueryLink(reportId,dimsionId);
		link.setDimsionid(dimsionId);
		reportObj.getQuery().getLinkList().add(link);
		saveToXmlByObj(reportObj);
	}
	/**
	 * 删除查询条件
	 * @param reportId
	 * @param dimsionId
	 */
	public void removeQueryLink(String reportId,String dimsionId){
		Report reportObj=XContext.getEditView(reportId);
		List<Link> linkList=reportObj.getQuery().getLinkList();
		if(linkList!=null&&linkList.size()>0){
			Link link=null;
			for(int i=0;i<linkList.size();i++){
				link=linkList.get(i);
				if(link.getDimsionid().equals(dimsionId)){
					linkList.remove(i);
					break;
				}
			}
		}
		saveToXmlByObj(reportObj);
	}
	/**
	 * 获取上级维度(SELECT和CASELECT)
	 */
	@SuppressWarnings("unchecked")
	public String getParentDims(String reportId,String varName){
		List parentColList = new ArrayList<Map>();
		Report reportObj=XContext.getEditView(reportId);
		if(reportObj.getDimsions()!=null&&reportObj.getDimsions().getDimsionList()!=null){
			List<Dimsion> dimList=reportObj.getDimsions().getDimsionList();
			String type="";
			for(Dimsion dim : dimList){
				type=dim.getType();
				if((type.equals("SELECT")||type.equals("CASELECT"))&&!varName.equals(dim.getVarname())){
					//result+=dim.getVarname()+":"+type+",";
					Map parentColMap = new HashMap();
					parentColMap.put("varName", dim.getVarname());
					parentColMap.put("codeColumn", dim.getCodecolumn());
					parentColMap.put("type", type);
					parentColList.add(parentColMap);
				}
			}
		}
		return Functions.java2json(parentColList);
	}
	/**
	 * 根据维度编号获取维度
	 * @param reportId
	 * @param dimsionId
	 * @return
	 */
	public Dimsion getDimsion(Report report,String dimsionId){
		Dimsion dm = null;
		if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null){
			for(Dimsion dim : report.getDimsions().getDimsionList()){
				if(dim.getId().equals(dimsionId)){
					dm = dim;
					break;
				}
			}
		}
		return dm;
	}
	/**
	 * 获取所有排序后的查询条件
	 * @param reportId
	 * @param dimsionId
	 * @return
	 * @throws Exception 
	 */
	public String getDimsions(String reportId) throws Exception{
		Report reportObj=XContext.getEditView(reportId);
		if(reportObj.getDimsions()!=null){
			List<Dimsion> dimList=reportObj.getDimsions().getDimsionList();
			if(dimList==null)
				dimList = new ArrayList<Dimsion>();
			List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
			for(Dimsion dim : dimList){
				if(dim.getVarname() != null && !"".equals(dim.getVarname())) {
					Map<String, Object> dimMap = new HashMap<String, Object>();
					dimMap.put("id",dim.getId());
					dimMap.put("type",dim.getType());
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
					dimMap.put("sql",dim.getSql().getSql().replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\t", " "));
					dimMap.put("createtype",dim.getCreatetype());
					dimMap.put("defaultvalue",dim.getDefaultvalue());
					dimMap.put("isparame",dim.getIsparame());
					dimMap.put("formula",dim.getFormula());
					dimMap.put("showtype",dim.getShowtype());
					dimMap.put("fieldid",dim.getFieldid());
					dimMap.put("fieldtype",dim.getFieldtype());
					dimMap.put("database",dim.getSql().getExtds());
					//常量,用户属性
					dimMap.put("defaultvaluetype",dim.getDefaultValueType());
					dimMap.put("datasourceid", dim.getDatasourceid());
					dimMap.put("conditiontype", dim.getConditiontype());
					dimMap.put("vardesc", dim.getVardesc());
					
					resultList.add(dimMap);
				}
			}
			listSort(resultList);
			return Functions.java2json(resultList);
		}
		return null;
		
	}
	public List<Map<String,Object>> autoInitDimsionForKpi(String cube_id) {
		KpiMetadata  kpiMetaData = new KpiMetadata();
		List<Map<String,Object>> dimList = new ArrayList<Map<String,Object>>();
		try {
			Map<String,Object> cubeMap = kpiMetaData.getCubeDataBase(cube_id);
			List<Map<String,Object>> list = null;
			list = kpiMetaData.getCubeDim(cube_id);
			if(list != null && list.size() > 0) {
				for(Map<String,Object> map : list) {
					Map<String,Object> allDimMap = new HashMap<String,Object>();
					allDimMap.put("var_name", map.get("DIM_COLUMN_CODE"));
					allDimMap.put("varname", map.get("DIM_COLUMN_CODE"));
					allDimMap.put("type", "INPUT");
					allDimMap.put("parentcol", "");
					allDimMap.put("parentdimname", "");
					allDimMap.put("table", "");
					allDimMap.put("codecolumn", "");
					allDimMap.put("desccolumn", "");
					allDimMap.put("ordercolumn", "");
					allDimMap.put("sql", "");
					allDimMap.put("desc", map.get("DIM_COLUMN_DESC").toString().replaceAll("\n", "").replaceAll("\r", "").replaceAll("\t", ""));
					allDimMap.put("database", "");
					allDimMap.put("defaultvalue", "");
					allDimMap.put("defaultvaluetype", "1");
					if(map.get("DIM_RIGHT") != null && !"".equals(map.get("DIM_RIGHT").toString())) {
						allDimMap.put("defaultvalue", map.get("DIM_RIGHT").toString());
						allDimMap.put("defaultvaluetype", "2");
					}
					allDimMap.put("id", map.get("DIM_COLUMN_CODE"));
					allDimMap.put("showtype", "0");
					allDimMap.put("formula", "05");
					allDimMap.put("fieldid", map.get("DIM_CODE"));
					allDimMap.put("fieldtype", "dim");
					allDimMap.put("isparame", "0");
					allDimMap.put("createtype", "1");
					allDimMap.put("databasename", "");
					allDimMap.put("level", "0");
					allDimMap.put("index", "0");
					allDimMap.put("datasourceid", "");
					allDimMap.put("conditiontype", "");
					allDimMap.put("vardesc", "");
					String conf_type = map.get("CONF_TYPE").toString();
					String sql = "";
					String table = "";
					String create_type = "2";
					String parent_column = (String)map.get("COLUMN_PARENT");
					if("D".equals(map.get("DIM_TYPE"))){
						allDimMap.put("type","DAY");
						allDimMap.put("createtype", "2");
					} else if("M".equals(map.get("DIM_TYPE"))){
						allDimMap.put("type","MONTH");
						allDimMap.put("createtype", "2");
					} else {
						if(parent_column != null && !"".equals(parent_column)) {
							parent_column = "," + parent_column + " AS PARENT_COL ";
						} else {
							parent_column = "";
						}
						if("1".equals(conf_type)) {
							if(map.get("CONDITION") != null && !"".equals(map.get("CONDITION").toString())) {
								sql = " select " + map.get("COLUMN_CODE") + " AS CODE,"+ map.get("COLUMN_DESC") +" AS CODEDESC,"+ map.get("COLUMN_ORD") +" AS ORD "+ parent_column +"  FROM " + map.get("CODE_TABLE").toString() +" " + map.get("CONDITION").toString();
							} else {
								table = map.get("CODE_TABLE").toString();
								create_type = "1";
							}
						} else {
							sql = " SELECT "+ map.get("COLUMN_CODE") + " AS CODE,"+ map.get("COLUMN_DESC") +" AS CODEDESC,"+ map.get("COLUMN_ORD") +" AS ORD "+ parent_column +" FROM ( " + map.get("CODE_TABLE").toString() + " ) ";
						}
//						allDimMap.put("var_name",map.get("COLUMN_CODE"));
//						allDimMap.put("varname",map.get("COLUMN_CODE"));
						if(map.get("DIM_LEVEL") !=null && !"".equals(map.get("DIM_LEVEL"))) {
							allDimMap.put("type","CASELECT");
							allDimMap.put("level",map.get("DIM_LEVEL"));
							if(map.get("DIM_PARENT_CODE") != null && !"".equals(String.valueOf(map.get("DIM_PARENT_CODE")))) {
								List<Map<String,Object>> parentList = kpiMetaData.getDim((String)map.get("DIM_PARENT_CODE"));
								Map<String,Object> parentMap = parentList.get(0);
								Map<String,Object> parentDim = kpiMetaData.getCubeDim(cube_id, (String)parentMap.get("DIM_CODE"));
								allDimMap.put("parentcol",map.get("COLUMN_PARENT"));
								allDimMap.put("parentdimname",parentDim.get("COLUMN_CODE"));
							}
						} else{
							allDimMap.put("type","SELECT");
						}
						allDimMap.put("table",table);
						if(table != null && !"".equals(table))
							allDimMap.put("codecolumn",map.get("COLUMN_CODE"));
						if(table != null && !"".equals(table))
							allDimMap.put("desccolumn",map.get("COLUMN_DESC"));
						if(table != null && !"".equals(table))
							allDimMap.put("ordercolumn",map.get("COLUMN_ORD"));
						allDimMap.put("sql",sql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\t", " "));
//						allDimMap.put("desc",map.get("CODE_TABLE_DESC"));
						allDimMap.put("database",cubeMap.get("CUBE_DATASOURCE"));
//						allDimMap.put("fieldid",map.get("DIM_CODE"));
						allDimMap.put("createtype", create_type);
						allDimMap.put("databasename", cubeMap.get("CUBE_DATASOURCE"));
					}
					dimList.add(allDimMap);
				}
			} 
		} catch(Exception e) {
			e.printStackTrace();
		}
		return dimList;
		
	}
	public Map<String,Object> getDimsionForKpi(String jsonString,String cube_id) {
		Map element=(Map)Functions.json2java(jsonString);
		KpiMetadata  kpiMetaData = new KpiMetadata();
		Map<String,Object> allDimMap = new HashMap<String,Object>();
		allDimMap.put("var_name", element.get("column"));
		allDimMap.put("varname", element.get("column"));
		allDimMap.put("type", "INPUT");
		allDimMap.put("parentcol", "");
		allDimMap.put("parentdimname", "");
		allDimMap.put("table", "");
		allDimMap.put("codecolumn", "");
		allDimMap.put("desccolumn", "");
		allDimMap.put("ordercolumn", "");
		allDimMap.put("sql", "");
		allDimMap.put("desc", element.get("desc").toString().replaceAll("\n", "").replaceAll("\r", "").replaceAll("\t", ""));
		allDimMap.put("database", "");
		allDimMap.put("defaultvalue", "");
		allDimMap.put("defaultvaluetype", "1");
		allDimMap.put("id", element.get("column"));
		allDimMap.put("showtype", "0");
		allDimMap.put("formula", "05");
		allDimMap.put("fieldid", element.get("id"));
		allDimMap.put("fieldtype", element.get("kpiType"));
		allDimMap.put("isparame", "0");
		allDimMap.put("createtype", "1");
		allDimMap.put("databasename", "");
		allDimMap.put("level", "0");
		allDimMap.put("index", "0");
		allDimMap.put("datasourceid", "");
		allDimMap.put("conditiontype", "");
		allDimMap.put("vardesc", "");
		try {
			Map<String,Object> cubeMap = kpiMetaData.getCubeDataBase(cube_id);
			List<Map<String,Object>> list = null;
			if("dim".equals(element.get("kpiType"))) {
 				list = kpiMetaData.getDim(element.get("id").toString());
				if(list != null && list.size() > 0) {
					Map<String,Object> map = list.get(0);
	 				Map<String,Object> columnMap = kpiMetaData.getCubeDim(cube_id, (String)map.get("DIM_CODE"));
					String conf_type = map.get("CONF_TYPE").toString();
					String sql = "";
					String table = "";
					String create_type = "2";
					String parent_column = (String)map.get("COLUMN_PARENT");
					allDimMap.put("var_name", columnMap.get("COLUMN_CODE"));
					allDimMap.put("varname", columnMap.get("COLUMN_CODE"));
					if(map.get("DIM_RIGHT") != null && !"".equals(map.get("DIM_RIGHT").toString())) {
						allDimMap.put("defaultvalue", map.get("DIM_RIGHT").toString());
						allDimMap.put("defaultvaluetype", "2");
					}
					if("D".equals(map.get("DIM_TYPE"))){
						allDimMap.put("type","DAY");
						allDimMap.put("createtype", "2");
					} else if("M".equals(map.get("DIM_TYPE"))){
						allDimMap.put("type","MONTH");
						allDimMap.put("createtype", "2");
					} else {
						if(parent_column != null && !"".equals(parent_column)) {
							parent_column = "," + parent_column + " AS PARENT_COL ";
						} else {
							parent_column = "";
						}
						if("1".equals(conf_type)) {
							if(map.get("CONDITION") != null && !"".equals(map.get("CONDITION").toString())) {
								sql = " select " + map.get("COLUMN_CODE") + " AS CODE,"+ map.get("COLUMN_DESC") +" AS CODEDESC,"+ map.get("COLUMN_ORD") +" AS ORD "+ parent_column +"  FROM " + map.get("CODE_TABLE").toString() +" " + map.get("CONDITION").toString();
							} else {
								table = map.get("CODE_TABLE").toString();
								create_type = "1";
							}
						} else {
							sql = " SELECT "+ map.get("COLUMN_CODE") + " AS CODE,"+ map.get("COLUMN_DESC") +" AS CODEDESC,"+ map.get("COLUMN_ORD") +" AS ORD "+ parent_column +" FROM ( " + map.get("CODE_TABLE").toString() + ")";
						}
//						allDimMap.put("var_name",map.get("COLUMN_CODE"));
//						allDimMap.put("varname",map.get("COLUMN_CODE"));
						if(map.get("DIM_LEVEL") !=null && !"".equals(map.get("DIM_LEVEL"))) {
							allDimMap.put("type","CASELECT");
							allDimMap.put("level",map.get("DIM_LEVEL"));
							if(map.get("DIM_PARENT_CODE") != null && !"".equals(String.valueOf(map.get("DIM_PARENT_CODE")))) {
								List<Map<String,Object>> parentList = kpiMetaData.getDim((String)map.get("DIM_PARENT_CODE"));
								Map<String,Object> parentMap = parentList.get(0);
								Map<String,Object> parentDim = kpiMetaData.getCubeDim(cube_id, (String)parentMap.get("DIM_CODE"));
								allDimMap.put("parentcol",map.get("COLUMN_PARENT"));
								allDimMap.put("parentdimname",parentDim.get("COLUMN_CODE"));
							}
						} else{
							allDimMap.put("type","SELECT");
						}
						allDimMap.put("table",table);
						if(table != null && !"".equals(table))
							allDimMap.put("codecolumn",map.get("COLUMN_CODE"));
						if(table != null && !"".equals(table))
							allDimMap.put("desccolumn",map.get("COLUMN_DESC"));
						if(table != null && !"".equals(table))
							allDimMap.put("ordercolumn",map.get("COLUMN_ORD"));
						allDimMap.put("sql",sql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\t", " "));
//						allDimMap.put("desc",map.get("CODE_TABLE_DESC"));
						allDimMap.put("database",cubeMap.get("CUBE_DATASOURCE"));
//						allDimMap.put("fieldid",map.get("DIM_CODE"));
						allDimMap.put("createtype", create_type);
						allDimMap.put("databasename", cubeMap.get("CUBE_DATASOURCE"));
					}
				}
			} else if("property".equals(element.get("kpiType"))){
				list = kpiMetaData.getAttr(element.get("id").toString());
				if(list != null && list.size() > 0) {
					Map<String,Object> map = list.get(0);
					if("D".equals(map.get("ATTR_TYPE"))){
						allDimMap.put("type","DAY");
						allDimMap.put("createtype", "2");
					} else {
						allDimMap.put("type","MONTH");
						allDimMap.put("createtype", "2");
					}
				}
			} else {
				list = new ArrayList<Map<String,Object>>();
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return allDimMap;
		
	}
	/**
	 * 根据维度变量名获取下级维度
	 * @param report
	 * @param dimVarname
	 * @return
	 */
	public Dimsion getChildDimsion(Report report,String dimVarname){
		Dimsion dm = null;
		if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null){
			for(Dimsion dim : report.getDimsions().getDimsionList()){
				if(dim.getType().equals("CASELECT")&&dim.getParentcol().equals(dimVarname)
						&&"1".equals(dim.getLevel())){
					dm = dim;
					break;
				}
			}
		}
		return dm;
	}
	
	public Dimsion getParentDimsion(Report report,String dimVarname){
		Dimsion dm = null;
		if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null){
			for(Dimsion dim : report.getDimsions().getDimsionList()){
				if(dim.getType().equals("CASELECT")&&dim.getVarname().equals(dimVarname)
						&&"0".equals(dim.getLevel())){
					dm = dim;
					break;
				}
			}
		}
		return dm;
	}
	
	/**
	 * 验证数据集SQL方法
	 * @param datasetName
	 * @param dataSql
	 * @param databaseName
	 * @return
	 */
	public String validateSql(String datasetName,String dataSql,String databaseName){
		StringBuffer info = new StringBuffer("");
		Connection con = null;
		PreparedStatement ps = null;
		try {
			dataSql = StringUtil.formatSql(dataSql, "{", "}");
			if (dataSql == null) {
				info.append("数据集【"+datasetName+"】:SQL格式拼写错误:｛｝没有成对出现或不正确的对！<br/>\n");
			}else if (dataSql.indexOf("AND") == 0) {
				info.append("数据集【"+datasetName+"】:第" + dataSql.substring(3)+ "个{}对内的应该存在AND|OR，请检查SQL拼写！<br/>\n");
			} else if ("COUNT".equals(dataSql)) {
				info.append("数据集【"+datasetName+"】:有部分##对没有被｛｝格式或者｛｝格式内不存在##对！<br/>\n");
			} 
			// 获得##对的变量名称集合
			List<String> parameterNames = new ArrayList<String>();
			String sql=SqlUtils.parseParameter(dataSql, parameterNames);
			try{
				dataSql = CommonTools.getSql(databaseName,sql);
			}catch(Exception e){
				info.append("数据集【"+datasetName+"】:获取数据源错误,请检查扩展数据源<br/>\n");
				e.printStackTrace();
			}
			
			int reg = StringUtil.getCounts(dataSql, "#");
			// 判断#的数量。是否成对出现
			if (reg % 2 != 0) {
				info.append("数据集【"+datasetName+"】:请检查#是否成对出现！<br/>\n");
			}
			con =  CommonTools.getConnection(databaseName);
			ps = con.prepareStatement(dataSql);
			for (int i = 0; i < parameterNames.size(); i++) {
				ps.setString(i + 1, null);//支持td数据，td数据库不支持null和''
			}
			ps.executeQuery();
		} catch (Exception e) {
			if(e.getMessage().indexOf("\n") == -1)
				info.append("数据集【"+datasetName+"】:"+e.getMessage()+"<br/>\n");
			else
				info.append("数据集【"+datasetName+"】:"+e.getMessage().substring(e.getMessage().indexOf(":") + 1, e.getMessage().indexOf("\n"))+"<br/>\n");
			e.printStackTrace();
		} finally {
				try {
					if(ps != null)
						ps.close();
					if(con != null)
						con.close();
				} catch (SQLException e) {
					info.append("数据集【"+datasetName+"】:"+e.getMessage().substring(e.getMessage().indexOf(":") + 1, e.getMessage().indexOf("\n"))+"<br/>\n");
					e.printStackTrace();
				}
		}
		return info.toString();
	}
	/**
	 * 验证维度SQL方法
	 * @param dim
	 * @return
	 */
	public String validateDimSql(Dimsion dim) {
		StringBuffer info = new StringBuffer("");
		String dim_col_code = dim.getCodecolumn();
		String dim_col_desc = dim.getDesccolumn();
		String dim_table = dim.getTable();
		String dim_col_ord = dim.getOrdercolumn();
		String createType = dim.getCreatetype();
		String dimsql = dim.getSql().getSql();
		String databaseName = dim.getSql().getExtds();
		String caslvl = dim.getLevel();
		String desc = "维度【"+dim.getDesc()+"】:";
		String dataSql = "select " + dim_col_code + " CODE,"+dim_col_desc + "  CODEDESC from " + dim_table+	" order by "+ dim_col_ord ;//where rownum=1
		StringBuffer sql = new StringBuffer("");
		try{
			sql = new StringBuffer(CommonTools.getSql(databaseName, dataSql));
		}catch(Exception e){
			info.append(desc+"获取数据源错误,请检查数据源<br/>\n");
			e.printStackTrace();
		}
		try {
			if("1".equals(dim.getLevel())&&dim.getParentcol().equals("")){
				info.append(desc+"上级编码不能为空<br/>\n");
			}
			if(createType != null && createType.equals("2")){
				String sqltmp = StringUtil.formatSql(dimsql.toString(), "{", "}");
				if("".equals(dimsql)){
					info.append(desc+"维度SQL不能为空<br/>\n");
				}else if (sqltmp == null) {
					info.append(desc+"SQL格式拼写错误:｛｝没有成对出现或不正确的对！<br/>\n");
				}else if (sqltmp.indexOf("AND") == 0) {
					info.append(desc+"请检查##号是否成对出现，或者{}对内的应该存在AND|OR，请检查SQL拼写！<br/>\n");//+ dimsql.substring(3)
				} else if ("COUNT".equals(sqltmp)) {
					info.append(desc+"有部分##对没有被｛｝格式或者｛｝格式内不存在##对！<br/>\n");
				} 
				sql = new StringBuffer("");
				if(dimsql!=null && dimsql.indexOf("#")!= -1){
					dimsql=dimsql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\\{", "").replaceAll("\\}", "");
					String sqlStrs[] = dimsql.split("#");
					for(int i = 0; i < sqlStrs.length;i++){
						if (i % 2 != 1) {
							sql.append(sqlStrs[i]);
						}else{
							sql.append("''");
						}
					}
				}else{
					sql = new StringBuffer(dimsql);
				}
			}
			int reg = StringUtil.getCounts(dimsql, "#");
			// 判断#的数量。是否成对出现
			if (reg % 2 != 0) {
				info.append(desc+"#号请成对出现！<br/>\n");
			}
			// 判断该码表是否存在
			int tmp = 0;String str = "";

			Connection con =  CommonTools.getConnection(databaseName);
			PreparedStatement ps = con.prepareStatement(sql.toString());
			ResultSet rs1 = ps.executeQuery();
			ResultSetMetaData rsmd = rs1.getMetaData();
			int cols = rsmd.getColumnCount();
			for (int i = 1; i <= cols; i++) {
				String o = rsmd.getColumnName(i);
				if(o!=null && "CODE".equals(((String) o).toUpperCase())){
					tmp ++;
				}
				if(o!=null && "CODEDESC".equals(((String) o).toUpperCase())){
					tmp ++;
				}
				if(caslvl!=null && !caslvl.equals("0")){
					if(o!=null && "PARENT_COL".equals(((String) o).toUpperCase())){
						tmp ++;
					}
				}
				str += o;
			}

			if(caslvl!=null && !caslvl.equals("") && !caslvl.equals("0") && createType != null && createType.equals("2")){
				if(tmp>=3){
				}else{
					info.append(desc+"SQL字段别名一定为: 编码列：code | 描述列：codedesc  |  上级字段：parent_col<br/>\n");
				}
			}else if((caslvl==null || caslvl.equals("0") || caslvl.equals("")) && createType != null && createType.equals("2")){
				if(tmp>=2){
				}else{
					info.append(desc+"SQL字段别名一定为:code 和 codedesc<br/>\n");
				}
			}
			try{
				rs1.close();
				con.close();
				ps.close();
			}catch(Exception e){
				e.printStackTrace();
				System.err.println("ReportSql.otherVarJudge方法释放连接时，出错:"+e.getMessage());
			}
		} catch (Exception e) {
			if(e.getMessage()!=null)
				info.append(desc+e.getMessage().substring(e.getMessage().indexOf(":") + 1,e.getMessage().indexOf("\n"))+"<br/>\n");
			e.printStackTrace();
		}
		
		return info.toString();
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
	  * 获得默认值的select选择器
	  * @param userid
	  * @param username
	  * @return
	  * @throws Exception
	  */
	 public String getSelectValue()throws Exception{
		 String jsonString = "";
		 Map<String,String> res = new HashMap<String,String>();
		 StringBuffer sql = new StringBuffer();
		 sql.append("select t.attr_code,t.attr_name from E_USER_ATTR_DIM t ");
		 List<Map<String,String>> attrList = (List<Map<String,String>>)runner.queryForMapList(sql.toString());
		 if(attrList!=null && attrList.size()>0){
			 for(int i=0;i<attrList.size();i++){
				 Map<String,String> map = attrList.get(i);
				 String key = map.get("ATTR_CODE");
				 String value = map.get("ATTR_NAME");
				 res.put(key.toUpperCase(), value);
			 }
		 }
		 jsonString = Functions.java2json(res);
		 return jsonString;
	 }
	 
	 
	/**
	 * @param args
	 * @throws Exception
	 */
	public static void main(String[] args) throws Exception {
//		// TODO Auto-generated method stub
//		String sql ="select 'mum ' a,'and my baby' b from dual where {'a' = #a#} {and 'b' = #b#}";
//		DimensionService a = new DimensionService();
//		List<String> sqlList = a.getRestrain(sql);
//		for(String tmp : sqlList){
//			System.out.println(tmp);
//		}
		List<Map<String,Object>> all = new ArrayList();
		Map aa = new HashMap();
		aa.put("index", "3");
		aa.put("desc", "c");
		all.add(aa);
		aa = new HashMap();
		aa.put("index", "2");
		aa.put("desc", "b");
		all.add(aa);
		aa = new HashMap();
		aa.put("index", "1");
		aa.put("desc", "a");
		all.add(aa);
		
		System.out.println(Functions.java2json(all));
		
		listSort(all);
		
		System.out.println(Functions.java2json(all));
	}
	
	
	
}
