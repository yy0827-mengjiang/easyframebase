package cn.com.easy.kpi.baseKpi.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.MapHandler;
import org.apache.commons.dbutils.handlers.MapListHandler;
import org.apache.commons.lang.StringUtils;

import cn.com.easy.annotation.Controller;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.exception.JaxbException;
import cn.com.easy.jaxb.parser.DefaultJaxbParse;
import cn.com.easy.jaxb.parser.JaxbParse;
import cn.com.easy.kpi.element.Kpi;
import cn.com.easy.kpi.element.KpiInfo;
import cn.com.easy.kpi.element.KpiSource;
import cn.com.easy.kpi.service.KpiDbService;
import cn.com.easy.kpi.util.Log;
import cn.com.easy.kpi.util.LogInfo;

public class FormulaKpiUtil {
	private final String kpiXmlPath = "/pages/kpi/custom/formal";
	private final String tmpKpiXmlPath = "/pages/kpi/custom/temp";
	private String classPath = this.getClass().getClassLoader().getResource("/").getPath();
	/*
	 * json字符串转list param:String jsonStr return :List<Map<String,String>>
	 * mapListJson
	 */
	public FormulaKpiUtil(){
		
	}
	public List<Map<String, String>> jsonStrToList(String jsonStr) {
		JSONArray jsonArray = JSONArray.fromObject(jsonStr);
		List<Map<String, String>> mapListJson = (List) jsonArray;
		return mapListJson;
	}

	/*
	 * 指标维度分类 param:List<Map<String,String>> mapListJson，List one,List tow,List
	 * thr return : void
	 */
	public void gaugeClass(List<Map<String, String>> li, List one, List tow,
			List thr) {
		for (int i = 0; i < li.size(); i++) {
			Map<String, String> map = li.get(i);
			if ("6".equals(map.get("nodeType"))||"7".equals(map.get("nodeType"))) {
				one.add(map.get("nodeId"));
			} else if ("4".equals(map.get("nodeType"))||"5".equals(map.get("nodeType"))) {
				tow.add(map.get("nodeId").split("-")[0]);
			} else if ("1".equals(map.get("nodeType"))||"2".equals(map.get("nodeType"))||"3".equals(map.get("nodeType"))) {
				thr.add(map.get("nodeId").split("-")[0]);
			}else if("0".equals(map.get("nodeType"))){
			}else{
				one.add(map.get("nodeId"));
				tow.add(map.get("nodeId").split("-")[0]);
				thr.add(map.get("nodeId").split("-")[0]);
			}
		}
	}

	/*
	 * list转String param:List<Map<String,String>> mapListJson，String str
	 * return:void
	 */
	public String listToStr(List<String> li) {
		if (li.isEmpty()) {
			return "";
		}
		String str = "";
		Iterator<String> it = li.iterator();
		while (it.hasNext()) {
			if (str.length() > 0) {
				str += ",";
			}
			str += it.next();
		}
		return str;
	}
	public List<Map<String, Object>> getDB(String sql, String params,SqlRunner runner)
			throws Exception {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String[] ss = {};
		if(StringUtils.isNotEmpty(params)){
			ss = params.split(",");
		}else{
			return li;
		}
		sql += "(";
		for (String s : ss) {
			if(null==s||"".equals(s)){
				continue;
			}
			if(s.split("_").length>=2){
				sql += "'" + s.split("_")[0] + "_" + s.split("_")[1]+ "',";
			}else{
				sql += "'" + s + "',";
			}
		}
		sql = sql.substring(0,sql.length()-1)+")";
		try {
			li = (List<Map<String, Object>>)runner.queryForMapList(sql);
		} catch (Exception e) {
			throw new Exception(e);
		}
		return li;
	}
	
	public int getKpiInfoSeq(SqlRunner runner) throws Exception{
		String seqSql = runner.sql("java.kpi.formulaKpiUtilClass.X_KPI_INFO_SEQ");
		Map<String, Object> map = new HashMap<String,Object>();
		try {
			map = runner.queryForMap(seqSql);
		} catch (Exception e) {
			throw new Exception(e);
		} 
		return Integer.parseInt(map.get("ID").toString());
	}
	
	public Map<String,Object> getCreateUserOrCreateDateTime(String kpi_code,SqlRunner runner) throws Exception{
		final String sql = runner.sql("java.kpi.formulaKpiUtilClass.getCreateUserOrCreateDateTime");
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String,Object> map = null;
		params.put("kpi_code", kpi_code);
		try {
			runner.queryForMap(sql, params);
		} catch (Exception e) {
			throw new Exception(e);
		}
		return map;
	}
	public int save(List<Map<String, Object>> dimList,List<Map<String, Object>> kpiList,List<Map<String, Object>> fKpiList,Map<String,Object> map,SqlRunner runner) throws Exception{
		List<KpiInfo> infoList = new LinkedList();
		List<KpiSource> sourceList = new LinkedList();
		KpiInfo ki = new KpiInfo();
		int key = 0;
		if("fUpdate".equals(map.get("operation"))){
			key = Integer.parseInt(map.get("fkId").toString());
		}else{
			key = this.getKpiInfoSeq(runner);
		}
		String fk_Code =map.get("base_key").toString();
		int fk_version = Integer.parseInt(map.get("formula_version").toString().trim());
		ki.setKpi_key(key);
		KpiDbService kds = new KpiDbService();
		if("1".equals(this.getServerNum(map.get("types").toString(), runner))){
			String codeId ="";
			if(null!=map.get("codeId")&&!"".equals(map.get("codeId").toString())){
				codeId = map.get("codeId").toString();
			}else{
				codeId= this.getSeq(runner);
			}
			 String kpiCode = "";
	         List<Map<String,String>> li = new FormulaKpiUtil().getCodeName(runner);
	         for(Map<String,String> param:li){
	         	kpiCode += map.get(param.get("CLASS_NAME")).toString();
	         }
			String serviceCode = kpiCode+codeId;
			ki.setService_Key(serviceCode);
		}
		ki.setAcctType(map.get("formKpi_type").toString());
		ki.setKpi_code(map.get("base_key").toString());
		ki.setKpi_name(map.get("formula_name").toString());
		ki.setKpi_category(Integer.parseInt(map.get("parentId").toString()));
//		ki.setKpi_category("1");
		ki.setKpi_nuit(map.get("kpi_nuit").toString());
		ki.setCube_code(map.get("cubeCode").toString());
		ki.setKpi_type(map.get("types").toString());
//		ki.setKpi_nuit(map.get("formula_unit").toString());
		ki.setKpi_version(Integer.parseInt(map.get("formula_version").toString()));
		ki.setKpi_iscurr("0");
		ki.setKpi_caliber(map.get("technical").toString());
		ki.setKpi_explain(map.get("business").toString());
		if("insert".equals(map.get("operation").toString())){
			ki.setKpi_flag("I");
		}else{
			ki.setKpi_flag("U");
		}
		if("draft".equals(map.get("status").toString())){
			ki.setKpi_status("99");
		}else{
			ki.setKpi_status("0");
		}
		
		ki.setKpi_body(map.get("xml").toString());
		ki.setKpi_user(map.get("dim_author").toString());
		ki.setKpi_dept(map.get("dim_dept").toString());
		ki.setExplain(map.get("explain").toString());
		ki.setKpi_file("");
		ki.setCreate_user(map.get("user").toString());
		ki.setCreate_datetime(new Date());
		ki.setCreate_datetime_old((String)map.get("create_datetime_old"));
		ki.setCreate_user_old((String)map.get("create_user_old"));
		infoList.add(ki);
		
		for(Map<String,Object> dimension : dimList){
			KpiSource source = new KpiSource();
			source.setSource_key(key);
			source.setKpi_code(fk_Code);
			source.setKpi_version(fk_version);
			source.setSource_code(dimension.get("DIM_CODE").toString());
			source.setSource_name(dimension.get("DIM_NAME").toString());
			if(null==dimension.get("TABLENAME")){
				source.setSource_table("");
			}else{
				source.setSource_table(dimension.get("TABLENAME").toString());
			}
			source.setSource_column(dimension.get("DIM_FIELD").toString());
			if(null==dimension.get("SQL_CODE")){
				source.setSource_condition("");
			}else{
				source.setSource_condition(dimension.get("SQL_CODE").toString());
			}
			source.setSource_type("0");
			if("1".equals(dimension.get("DIM_TYPE"))){
				source.setSource_type("6");
			}else{
				source.setSource_type("7");
			}
			source.setSource_version(0);
			
			sourceList.add(source);
		}
		
		for(Map<String,Object> measure :kpiList){
			KpiSource source = new KpiSource();
			source.setSource_key(key);
			source.setKpi_code(fk_Code);
			source.setKpi_version(fk_version);
			source.setSource_code(measure.get("BASE_KEY").toString());
			source.setSource_name(measure.get("KPI_NAME").toString());
			source.setSource_table(measure.get("TABLENAME").toString());
			source.setSource_column(measure.get("KPI_ORIGIN_COLUMN").toString());
			source.setSource_condition("");
//			if("1".equals(measure.get("TYPE"))){
//				source.setSource_type("4");
//			}else{
//				source.setSource_type("5");
//			}
			source.setSource_type((String)measure.get("TYPE"));
			source.setSource_version(Integer.parseInt(measure.get("KPI_VERSION").toString()));
			
			sourceList.add(source);
		}
		
		for(Map<String,Object> measure :fKpiList){
			KpiSource source = new KpiSource();
			source.setSource_key(key);
			source.setKpi_code(fk_Code);
			source.setKpi_version(fk_version);
			source.setSource_code(measure.get("KPI_CODE").toString());
			source.setSource_name(measure.get("KPI_NAME").toString());
			source.setSource_table("");
			source.setSource_column("");
			source.setSource_condition("");
			source.setSource_type(measure.get("KPI_TYPE").toString());
			source.setSource_version(Integer.parseInt(measure.get("KPI_VERSION").toString()));
			
			sourceList.add(source);
		}
		this.kpiLog(infoList, map, runner);
		if("fUpdate".equals(map.get("operation"))){
			this.updateKpi(infoList, runner);
			this.updateSource(infoList, sourceList, runner);
			this.updateAttr(infoList, runner);
		}
		return kds.kpiAdd2Db(infoList, sourceList, runner);	

		
	}
	
	public Kpi readKpiTemplate(String kpiCode) throws Exception {
		String xmlPath = classPath.substring(0,classPath.indexOf("WEB-INF/classes"));
		xmlPath += kpiXmlPath + "/" + kpiCode + ".xml";
//		String xmlPath = "c:/" + kpiId + ".xml";
		JaxbParse jaxb = null;
		Kpi kpi = null;
		try {
			jaxb = new DefaultJaxbParse();
			kpi = jaxb.read(Kpi.class, xmlPath);
		} catch (JaxbException e) {
			throw new Exception(e);
		}
		return kpi;
	}
	public Kpi auditKpiTemplate(String kpiCode) throws Exception {
		String xmlPath = classPath.substring(0,classPath.indexOf("WEB-INF/classes"));
		xmlPath += tmpKpiXmlPath + "/" + kpiCode + ".xml";
//		String xmlPath = "c:/" + kpiId + ".xml";
		JaxbParse jaxb = null;
		Kpi kpi = null;
		try {
			jaxb = new DefaultJaxbParse();
			kpi = jaxb.read(Kpi.class, xmlPath);
		} catch (JaxbException e) {
			throw new Exception(e);
		}
		return kpi;
	}
	public Map<String,String> getKpiCode(String id,SqlRunner runner) throws SQLException{
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("id", id);
		String kpiCodeSql = runner.sql("java.kpi.formulaKpiUtilClass.getKpiCode");
		Map<String,String> m = runner.queryForMap(kpiCodeSql,map);
		return m;
	}
	
	public Map<String,String> kpi2CodeVer(String code,String version,SqlRunner runner) throws SQLException{
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("code", code);
		params.put("version", version);
		String kpiCodeSql = runner.sql("java.kpi.formulaKpiUtilClass.kpi2CodeVer");
		Map<String,String> m = runner.queryForMap(kpiCodeSql,params);
		return m;
	}
	
	public Map<String,String> getKpiCodeToInfo(String id,SqlRunner runner) throws SQLException{
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("id", id);
		final String kpiCodeSql = runner.sql("java.kpi.formulaKpiUtilClass.getKpiCode");	
		Map<String,String> m = runner.queryForMap(kpiCodeSql,map);
		return m;
	}
	
	public Map<String,String> getKpiCodeToTMP(String id,SqlRunner runner) throws SQLException{
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("id", id);
		final String kpiCodeSql = runner.sql("java.kpi.formulaKpiUtilClass.getKpiCodeToTMP");	
		Map<String,String> m = runner.queryForMap(kpiCodeSql,map);
		return m;
	}
	
	public int hasAudit(String kpiCode,SqlRunner runner) throws SQLException{
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("kpiCode", kpiCode);
		String sql = runner.sql("java.kpi.formulaKpiUtilClass.hasAudit");
		int i = runner.execute(sql,kpiCode,map);
		return i;
	}
	public String getCode(List<Map<String,String>> list,String code){
		for (Map<String, String> map : list) {
			String key = map.get("nodeId");
			if(key.startsWith(code)){
				list.remove(map);
				return key;
			}
		}
		return "";
		
	}

	public void saveAttr(Map parameter, SqlRunner runner) throws SQLException {
		String sql = runner.sql("java.kpi.formulaKpiUtilClass.saveAttr");
		String kpiCode = parameter.get("base_key").toString();
		String[] relactionId = parameter.get("formKpiSub").toString().split(",");
		if(relactionId!=null){
			if(kpiCode.startsWith("FK_")){
				for(int i=0;i<relactionId.length;i++){
					String relaction = relactionId[i];
					if(relaction!=null&&!"".equals(relaction)){
						String kpiVersion = parameter.get("formula_version").toString();
						String userId = parameter.get("user").toString();
						String type = parameter.get("formKpi_type").toString();
						Map<String,Object> para = new HashMap<String,Object>();
						para.put("relaction", relaction);
						para.put("kpiCode", kpiCode);
						para.put("kpiVersion", kpiVersion);
						para.put("userId", userId);
						para.put("type", type);
						runner.execute(sql, para);
					}
				}
			}else if(kpiCode.startsWith("BK_")){
				for(int i=0;i<relactionId.length;i++){
					String relaction = relactionId[i];
					if(relaction!=null&&!"".equals(relaction)){
						String kpiVersion =parameter.get("kpi_version").toString();
						String userId = parameter.get("user").toString();
						String type = parameter.get("account_type").toString();
						Map<String,Object> para = new HashMap<String,Object>();
						para.put("relaction", relaction);
						para.put("kpiCode", kpiCode);
						para.put("kpiVersion", kpiVersion);
						para.put("userId", userId);
						para.put("type", type);
						runner.execute(sql, para);
					}
				}
			}
		}
		
	}
	
	public String getSeq(SqlRunner runner) throws SQLException{
		String sql =runner.sql("java.kpi.formulaKpiUtilClass.getSeq2Key");
		Map<String,Object> map = runner.queryForMap(sql);
		return map.get("SEQ").toString();
	}
	
	public void kpiLog(List<KpiInfo> infoList,Map<String,Object> map,SqlRunner runner) throws SQLException{
		for(KpiInfo kpiInfo :infoList){
			LogInfo info = new LogInfo();
			Map m = runner
					.queryForMap(runner.sql("java.kpi.formulaKpiUtilClass.logSQL"));
			info.setLogKey(Integer.parseInt(m.get("LOGSEQ").toString()));
			info.setKpiKey(kpiInfo.getKpi_key());
			info.setKpiCode(kpiInfo.getKpi_code());
			info.setKpiVersion(kpiInfo.getKpi_version());
			info.setLogAction(kpiInfo.getKpi_flag());
			//info.setLogDetatlBef();
			info.setLogDetatlAft(kpiInfo.getKpi_body());
			Timestamp time = new Timestamp(new Date().getTime());
			info.setLogDateTime(time);
			info.setLogUser(map.get("userName").toString());
			info.setLogUserId(map.get("user").toString());
			info.setLogIp(map.get("localAddr").toString());
			Log.SaveLog(runner, info);
		}
		
	}
	public void updateKpi(List<KpiInfo> infoList,SqlRunner runner) throws SQLException{
		String updateInfo=runner.sql("java.kpi.formulaKpiUtilClass.updateKpi");
		Map<String,Object> param = new HashMap<String,Object>();
		for(KpiInfo kpi:infoList){
			param.put("kpi_key", kpi.getKpi_key());
		}
		runner.execute(updateInfo, param);
	}
	public void updateSource(List<KpiInfo> infoList,List<KpiSource> sourceList,SqlRunner runner) throws SQLException{
		String deleteSource = runner.sql("java.kpi.formulaKpiUtilClass.updateSource");
		Map<String,Object> param = new HashMap<String,Object>();
		for(KpiInfo kpi:infoList){
			param.put("kpi_code", kpi.getKpi_code());
			param.put("kpi_version", kpi.getKpi_version());
		}
		runner.execute(deleteSource, param);
	}
	public void updateAttr(List<KpiInfo> infoList,SqlRunner runner) throws SQLException{
		String deleteAttr=runner.sql("java.kpi.formulaKpiUtilClass.updateAttr");
		for(KpiInfo kpi:infoList){
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("kpi_code", kpi.getKpi_code());
			param.put("kpi_version",kpi.getKpi_version());
			runner.execute(deleteAttr, param);
		}
	}
	public List<Map<String,String>> getCodeName(SqlRunner runner) throws SQLException{
		String querySql=runner.sql("java.kpi.formulaKpiUtilClass.getCodeName");
		List<Map<String,String>> li = (List<Map<String, String>>) runner.queryForMapList(querySql);
		return li;
	}
	public String getServerNum(String kpiTypes,SqlRunner runner) throws SQLException{
		String querySql = runner.sql("java.kpi.formulaKpiUtilClass.getServerNum");
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("kpiTypes", kpiTypes);
		Map<String,String> map = runner.queryForMap(querySql,params);
		if(map == null) {
			return "";
		}
		return map.get("SERVER_VIEW");
		
	}
	public String getInfoSql(SqlRunner runner) throws SQLException{
		String querySql = runner.sql("java.kpi.formulaKpiUtilClass.getInfoSql");
		Map<String,String> map = runner.queryForMap(querySql);
		return map.get("ID");
	}
	
}

