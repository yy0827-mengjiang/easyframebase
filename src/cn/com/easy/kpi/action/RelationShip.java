package cn.com.easy.kpi.action;

import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.exception.JaxbException;
import cn.com.easy.jaxb.parser.DefaultJaxbParse;
import cn.com.easy.jaxb.parser.JaxbParse;
import cn.com.easy.kpi.element.Kpi;
import cn.com.easy.taglib.function.Functions;

@Controller
public class RelationShip {
	/**
	 *获取血缘关系，向上引用关系出不来，80%是因为指标的版本问题。 所以把递归中指标版本注掉了，如有问题，把指标版本打开。
	 */
	
	private SqlRunner runner;
	Map<String,Object> json = null;
	@Action("ship")
	public void ship(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		Map<String,Object> map = new HashMap<String,Object>();
		json = new HashMap<String,Object>();
		String kpiCode = request.getParameter("kpi_key");
		String version = request.getParameter("kpi_version");
		this.sub(kpiCode,version,json);	
		map.put("currNodeKpiName", ((Map<String,Object>) json.get("data")).get("KPI_NAME"));
		map.put("currNodeVersion", ((Map<String,Object>) json.get("data")).get("KPI_VERSION"));
		map.put("currNodeType", ((Map<String,Object>) json.get("data")).get("TYPE"));
		map.put("currNodeCaliber", ((Map<String,Object>) json.get("data")).get("KPI_CALIBER"));
		map.put("currTables", ((Map<String,Object>) json.get("data")).get("TAB_CODE"));
		map.put("currColnum", ((Map<String,Object>) json.get("data")).get("TAB_FIELD"));
		//向上
		this.children(kpiCode, version, json);
		//向下
		this.sibship(kpiCode, version, json,null);
		map.put("info", json);
		response.setHeader("Charset", "UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter pw=response.getWriter();
		JSONArray ja=new JSONArray();
		ja.add(map);
		System.out.println(ja);
		pw.write(ja.toString());
	}
	
	public void sibship(String kpiCode,String version,Map<String,Object> map,String type) throws SQLException{
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("kpiCode", kpiCode);
		param.put("version", version);
		String sibSql = runner.sql("java.kpi.RelationShipClass.sibship");
		List<Map<String,Object>> li = (List<Map<String, Object>>) runner.queryForMapList(sibSql,param);
		if(!li.isEmpty()){
			for(Map<String,Object> map2:li){
				Map<String,Object> sib =  new HashMap<String,Object>();
				this.subInfo(map2.get("SOURCE_CODE").toString(), map2.get("SOURCE_VERSION").toString(), sib,map2.get("SOURCE_TYPE").toString());
				if(!sib.isEmpty()){
					this.sibship(map2.get("SOURCE_CODE").toString(), map2.get("SOURCE_VERSION").toString(), sib,map2.get("SOURCE_TYPE").toString());
					((List<Map<String,Object>>)map.get("children")).add(sib);
				}else{
					this.source(map2.get("SOURCE_CODE").toString(), map2.get("SOURCE_VERSION").toString(),map,map2.get("SOURCE_TYPE").toString());
				}
			}
		}else{
			this.source(map.get("id").toString(), ((Map<String,String>) map.get("data")).get("KPI_VERSION"),map,type);
		}
	}
	private void subInfo(String kpiCode,String version,Map<String,Object> map) throws SQLException{
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("kpiCode", kpiCode);
		param.put("version", version);
		String infoSql =runner.sql("java.kpi.RelationShipClass.subInfo");
		List<Map<String,Object>> li = (List<Map<String, Object>>) runner.queryForMapList(infoSql,param);
		if(!li.isEmpty()){
			for(Map<String,Object> map2 :li){
				map.put("id", map2.get("KPI_CODE").toString());
				map.put("name", map2.get("KPI_NAME").toString());
				Map<String,String> data = new HashMap<String,String>();
				data.put("KPI_NAME", map2.get("KPI_NAME").toString());
				data.put("KPI_VERSION", map2.get("KPI_VERSION").toString());
				data.put("$orn", "right");
				data.put("TYPE", map2.get("VIEW_TYPE_NAME").toString());
//				data.put("KPI_CODE", map2.get("SERVICE_KEY").toString());
				data.put("KPI_CALIBER", map2.get("KPI_CALIBER").toString());
				data.put("KPI_EXPLAIN", map2.get("KPI_EXPLAIN").toString());
				data.put("TAB_CODE", "--");
				data.put("TAB_FIELD", "--");
				map.put("data", data);
				map.put("children", new ArrayList<Map<String,Object>>());
			}
			
		}
	}
	private void subInfo(String kpiCode,String version,Map<String,Object> map,String type) throws SQLException{
		if(!"6".equals(type)&&!"7".equals(type)){
//			this.dimInfo(kpiCode, version, map);
//		}else{
			this.subInfo(kpiCode, version, map);
		}
	}
	private void source(String kpiCode, String version, Map<String, Object> map,String type) throws SQLException {
		if(!"6".equals(type)&&!"7".equals(type)){
//			this.info(kpiCode, version, map);
//		}else{
			this.kpiInfo(kpiCode, version, map);
		}
		
	}
	private void info(String kpiCode, String version, Map<String, Object> map) throws SQLException{
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("kpiCode", kpiCode);
		param.put("version", version);
		String dimSql = runner.sql("java.kpi.RelationShipClass.info");
		List<Map<String,String>> dimList = (List<Map<String, String>>) runner.queryForMapList(dimSql,param);
		if(dimList.isEmpty()){
			return;
		}
		for(Map<String,String> map2 : dimList){
			Map<String,String> data = new HashMap<String,String>();
			data.put("KPI_NAME", map2.get("COLUMN_DESC"));
			data.put("KPI_TABLE", map2.get("CODE_TABLE"));
			data.put("KPI_VERSION", "1");
			data.put("$orn", "right");
			data.put("TYPE", "2");
			data.put("TAB_CODE", map2.get("KPI_CODE"));
			data.put("TAB_FIELD", map2.get("KPI_FIELD"));
			data.put("KPI_CALIBER","--");
			data.put("KPI_EXPLAIN", "--");
			Map<String, Object> sib1 = new HashMap<String,Object>();
			Map<String, Object> sib2 = new HashMap<String,Object>();
			sib1.put("id", map2.get("DIM_CODE")+"0");
			sib1.put("name", map2.get("CODE_TABLE"));
			sib1.put("data", data);
			sib1.put("children", new ArrayList<Map<String,Object>>());
			sib2.put("id", map2.get("DIM_CODE")+"1");
			sib2.put("name", map2.get("COLUMN_DESC"));
			sib2.put("data", data);
			sib2.put("children", new ArrayList<Map<String,Object>>());
			((List<Map<String,Object>>)map.get("children")).add(sib1);
			((List<Map<String,Object>>)map.get("children")).add(sib2);
		}
	}

	private void dimInfo(String kpiCode, String version, Map<String, Object> map) throws SQLException{
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("kpiCode", kpiCode);
		param.put("version", version);
		String dimSql = runner.sql("java.kpi.RelationShipClass.dimInfo");
		List<Map<String,String>> dimList = (List<Map<String, String>>) runner.queryForMapList(dimSql,param);
		if(dimList.isEmpty()){
			return;
		}
		for(Map<String,String> map2 : dimList){
			Map<String,String> data = new HashMap<String,String>();
			data.put("KPI_NAME", map2.get("COLUMN_DESC"));
			data.put("KPI_TABLE", map2.get("CODE_TABLE"));
			data.put("KPI_VERSION", "1");
			data.put("$orn", "right");
			data.put("TYPE", "2");
			data.put("TAB_CODE", map2.get("COLUMN_DESC"));
			data.put("TAB_FIELD", map2.get("COLUMN_CODE"));
			data.put("KPI_CALIBER","--");
			data.put("KPI_EXPLAIN", "--");
			map.put("id", map2.get("DIM_CODE"));
			map.put("name", "<img style='width:25px;heigth:25px;' src='../../xbuilder/resources/themes/base/images/icons/ico10_kpi.png'>  " + map2.get("COLUMN_DESC"));
			map.put("data", data);
			map.put("children", new ArrayList<Map<String,Object>>());
		}
	}
	
	private void kpiInfo(String kpiCode, String version, Map<String, Object> map) throws SQLException{
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("kpiCode", kpiCode);
		param.put("version", version);
		String rootSql = runner.sql("java.kpi.RelationShipClass.kpiInfo");
		Map<String,Object> icon = runner.queryForMap(rootSql,param);
		if(null==icon){
			return;
		}
		String sibSql = runner.sql("java.kpi.RelationShipClass.getBaseKpi");
		List<Map<String,String>> li = (List<Map<String, String>>) runner.queryForMapList(sibSql,param);
		if(!li.isEmpty()){
			for(int i=0;i<li.size();i++){
				Map<String,String> map2 = li.get(i);
				Map<String,String> data = new HashMap<String,String>();
				data.put("KPI_NAME", map2.get("KPI_NAME").toString());
				data.put("KPI_VERSION", map2.get("KPI_VERSION").toString());
				data.put("$orn", "right");
				data.put("TYPE", "基础指标");
				data.put("KPI_TABLE", map2.get("KPI_ORIGIN_SCHEMA") + "\n\r." + map2.get("KPI_ORIGIN_TABLE"));
				data.put("TAB_CODE", "--");
				data.put("TAB_FIELD", map2.get("KPI_ORIGIN_COLUMN"));
//				data.put("KPI_CODE", map2.get("KPI_CODE").toString());
				if(null==map.get("KPI_CALIBER")){
					data.put("KPI_CALIBER","--");
				}else{
					data.put("KPI_CALIBER",map2.get("KPI_ORIGIN_REGULAR").toString().replace("\r", "").replace("\n", ""));
				}
				if(null==map.get("KPI_EXPLAIN")){
					data.put("KPI_EXPLAIN", "--");
				}else{
					data.put("KPI_EXPLAIN", map2.get("KPI_EXPLAIN").toString().replace("\r", "").replace("\n", ""));
				}
				Map<String, Object> sib = new HashMap<String,Object>();
				
				/*Map<String,Object> tab1 = new HashMap<String,Object>();
				Map<String,Object> tab2 = new HashMap<String,Object>();
				tab1.put("id", map2.get("KPI_CODE") + "-1");
				tab1.put("name", map2.get("KPI_ORIGIN_SCHEMA") + "\n\r." + map2.get("KPI_ORIGIN_TABLE"));
				tab1.put("data", data);
				tab1.put("children", new HashMap<String,String>());
				tab2.put("id", map2.get("KPI_CODE") + "-2");
				tab2.put("name", map2.get("KPI_ORIGIN_COLUMN"));
				tab2.put("data",  data);
				tab2.put("children", new HashMap<String,String>());*/
				if(!map2.get("BASE_KEY").equals(json.get("id").toString())){
					sib.put("id", map2.get("KPI_CODE"));
					sib.put("name", "<img style='width:25px;heigth:25px;' src='../../xbuilder/resources/themes/base/images/icons/"+icon.get("ICON")+".png'>  " + map2.get("KPI_NAME"));
					sib.put("data", data);
					List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
//					以下两句是基础指标组成
//					list.add(tab1);
//					list.add(tab2);
					sib.put("children", list);
					((List<Map<String,Object>>)map.get("children")).add(sib);
//				}else{
//					((List<Map<String,Object>>)map.get("children")).add(tab1);
//					((List<Map<String,Object>>)map.get("children")).add(tab2);
				}
			}
		}
	}
	public void children(String kpiCode,String version,Map<String,Object> map) throws Exception{
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("kpiCode", kpiCode);
		param.put("version", version);
		String sourceSql = runner.sql("java.kpi.RelationShipClass.children");
		List<Map<String,Object>> li = (List<Map<String, Object>>) runner.queryForMapList(sourceSql,param);
		if(!li.isEmpty()){
			for (Map<String, Object> map2 : li) {
				Map<String,Object> sub = new HashMap<String,Object>();
				this.sub(map2.get("KPI_CODE").toString(),map2.get("KPI_VERSION").toString(), sub);
				this.children(map2.get("KPI_CODE").toString(),map2.get("KPI_VERSION").toString(), sub);
				if(!sub.isEmpty()){
					((List<Map<String,Object>>)map.get("children")).add(sub);
				}
			}
		}else{
			this.report(kpiCode,version,map);
		}
		
		
	}
	
	public void sub(String kpiCode,String version,Map<String,Object> sub) throws Exception{
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("kpiCode", kpiCode);
		param.put("version", version);
		String rootSql = runner.sql("java.kpi.RelationShipClass.sub");
		Map<String,Object> map = runner.queryForMap(rootSql,param);
		if(null==map){
			return;
		}
		sub.put("id", map.get("KPI_CODE"));
		sub.put("name", "<img style='width:25px;heigth:25px;' src='../../xbuilder/resources/themes/base/images/icons/"+map.get("ICON")+".png'>  "+map.get("NAME"));
		Map<String,String> data = new HashMap<String,String>();
		data.put("KPI_NAME", map.get("NAME").toString());
		data.put("KPI_VERSION", map.get("KPI_VERSION").toString());
		data.put("$orn", "left");
		data.put("TYPECODE",(String) map.get("TYPE_CODE"));
		data.put("TYPE", (String) map.get("VIEW_TYPE_NAME"));
		data.put("KPI_TABLE", "--");
		data.put("TAB_CODE", "--");
		data.put("TAB_FIELD", "--");
		if(null==map.get("KPI_CALIBER")){
			data.put("KPI_CALIBER","");
		}else{
			data.put("KPI_CALIBER",map.get("KPI_CALIBER").toString().replace("\r", "").replace("\n", ""));
		}
		if(null==map.get("KPI_EXPLAIN")){
			data.put("KPI_EXPLAIN", "");
		}else{
			data.put("KPI_EXPLAIN", map.get("KPI_EXPLAIN").toString().replace("\r", "").replace("\n", ""));
		}
		if(!"4".equals(data.get("TYPECODE"))){
			String kpiSql = runner.sql("java.kpi.RelationShipClass.TYPECODE4");
			Map<String,String> kpiMap = runner.queryForMap(kpiSql,param);
			System.out.println(kpiMap.get("KPI_BODY"));
			Kpi kpi = parseXMLToKpi(kpiMap.get("KPI_BODY"));
			data.put("formula", kpi.getFormulastr().getFormulaStr().replace("&lt;", "<").replace("&gt;", ">"));
			data.put("condstr", kpi.getCondstr().getCondStr().replace("&lt;", "<").replace("&gt;", ">"));
		}
		sub.put("data", data);
		sub.put("children", new ArrayList<Map<String,Object>>());
		
	}
	
	private Kpi parseXMLToKpi(String kpiXml) throws Exception {
		JaxbParse jaxb = null;
		Kpi kpi = null;
		try {
			jaxb = new DefaultJaxbParse();
			kpi = jaxb.readXmlStr(Kpi.class, kpiXml);
			return kpi;
		} catch (JaxbException e) {
			throw new Exception(e);
		}
	}

	public void report(String kpiCode,String version,Map<String,Object> map) throws SQLException{
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("kpiCode", kpiCode);
		param.put("version", version);
		String reportSql=runner.sql("java.kpi.RelationShipClass.report");
		List<Map<String,String>> li = (List<Map<String, String>>) runner.queryForMapList(reportSql,param);
		for (Map<String, String> map2 : li) {
			Map<String,Object> sub = new HashMap<String,Object>();
			sub.put("id", map2.get("ID"));
			sub.put("name","<img style='width:25px;heigth:25px;' src='../../xbuilder/resources/themes/base/images/icons/ico-kpi-report.png'>  "+map2.get("NAME"));
			Map<String,String> data = new HashMap<String,String>();			
			data.put("KPI_NAME", map2.get("NAME"));
			data.put("KPI_VERSION", map2.get("SYS_NAME"));
			data.put("$orn", "left");
			data.put("TYPE", "100");
			data.put("KPI_CALIBER", map2.get("CREATE_USER"));
			data.put("KPI_EXPLAIN", map2.get("CREATE_DATE"));
			data.put("KPI_TABLE", "--");
			data.put("TAB_CODE", "");
			data.put("TAB_FIELD", "--");
			data.put("TYPECODE","100");
			sub.put("data", data);
			List<Map<String,Object>> children = (List<Map<String,Object>>)map.get("children");
			children.add(sub);
			map.put("children", children);
		}
	}


}
