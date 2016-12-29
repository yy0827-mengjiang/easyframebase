package cn.com.easy.kpi.action;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.Reader;
import java.sql.Clob;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.exception.JaxbException;
import cn.com.easy.jaxb.parser.DefaultJaxbParse;
import cn.com.easy.jaxb.parser.JaxbParse;
import cn.com.easy.kpi.baseKpi.service.BaseKpiService;
import cn.com.easy.kpi.baseKpi.service.FileUploadUtil;
import cn.com.easy.kpi.baseKpi.service.FormulaKpiUtil;
import cn.com.easy.kpi.element.Condition;
import cn.com.easy.kpi.element.Conditions;
import cn.com.easy.kpi.element.Condstr;
import cn.com.easy.kpi.element.Dictionary;
import cn.com.easy.kpi.element.Dimension;
import cn.com.easy.kpi.element.Dimensions;
import cn.com.easy.kpi.element.Expression;
import cn.com.easy.kpi.element.ForeignKeyLink;
import cn.com.easy.kpi.element.Formula;
import cn.com.easy.kpi.element.Formulas;
import cn.com.easy.kpi.element.Formulastr;
import cn.com.easy.kpi.element.Kpi;
import cn.com.easy.kpi.element.Measure;
import cn.com.easy.kpi.element.Measures;
import cn.com.easy.kpi.element.SelfWhere;
import cn.com.easy.kpi.parser.GenerateKpi;
import cn.com.easy.kpi.util.KpiUtil;
import cn.com.easy.kpi.util.Log;
import cn.com.easy.kpi.util.LogInfo;
/**
 * 
 * @author Sunxq
 *	xml地址:/eframe_oracle/src/sqlmap/db2/kpi/formulaKpiClass.xml
 */
@Controller
public class FormulaKpi {
	private SqlRunner runner;
	FormulaKpiUtil fku = new FormulaKpiUtil();

	@Action("formulaKpi")
	public void formulaKpi(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = null;
		Map user = (Map) request.getSession().getAttribute("UserInfo");
		FileUploadUtil flu = new FileUploadUtil();
		Map<String, Object> parameter = new HashMap<String, Object>();
		boolean flag = false;
		try{
			out = response.getWriter();
			flag = flu.fileUpload(request, parameter);
			parameter.put("result", flag);
			parameter.put("localAddr",request.getLocalAddr());
			parameter.put("userName",user.get("USER_NAME").toString());
			parameter.put("user", user.get("USER_ID").toString());
			this.java2XML(parameter);
			out.println("<script type='text/javascript'>");
			if ("draft".equals(parameter.get("status").toString())) {
				out.println("parent.callback('保存草稿成功',1);");
			} else {
				out.println("parent.callback('提交版本成功',1);");
			}
			out.println("</script>");
		} catch (Exception e) {
			out.println("<script type='text/javascript'>");
			if ("draft".equals(parameter.get("status").toString())) {
				out.println("parent.callback('保存草稿失败',0);");
			} else {
				out.println("parent.callback('提交版本失败',0);");
			}
			out.println("</script>");
			throw new Exception(e.getMessage());
		}
		// response.sendRedirect("pages/kpi/kpiManager/newKpiManager.jsp");
	}

	

	@Action("formulaKpiList")
	public String formulaKpiList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("kpi_key");
		String managerFlag = (String) request.getParameter("managerFlag");
		if (StringUtils.isNotEmpty(id)) {
			Map<String, String> kpiCode = new HashMap<String, String>();
			Kpi kpi;
			try {
				kpiCode = fku.getKpiCodeToInfo(id, runner);
				kpi = parseXMLToKpi(kpiCode.get("KPI_BODY"));
				
//				kpi = fku.readKpiTemplate(kpiCode.get("KPI_CODE"));
				BaseKpiService baseKpiService = new BaseKpiService();
				Map<String, String> fileMap = baseKpiService.queryFile(kpiCode
						.get("KPI_CODE"));
				if (fileMap != null) {
					request.setAttribute("fileName", fileMap.get("fileName"));
					request.setAttribute("filePath", fileMap.get("filePath"));
				}
			} catch (Exception e) {
				e.printStackTrace();
				throw new Exception(e.getMessage());
			}
			
				if("1".equals(fku.getServerNum(kpiCode.get("KPI_TYPE"), runner))){
					Map<String,String> code = new HashMap<String,String>();
		        	List<Map<String,String>> li = new FormulaKpiUtil().getCodeName(runner);
		        	int start = 0;
		        	if(null!=kpiCode.get("ID")&&!"".equals(kpiCode.get("ID"))){
			        	for(int i =0;i<li.size();i++){
			        		start = i*2;
			        		code.put(li.get(i).get("CLASS_NAME"), kpiCode.get("ID").substring(start, start+2));
			        	}
			        	request.setAttribute("serviceCode", JSONObject.fromObject(code));
						request.setAttribute(
								"codeId",
								kpiCode.get("ID").substring(start+2,
										kpiCode.get("ID").length()));
					}
				}
			request.setAttribute("formulaStr", kpi.getFormulastr()
					.getFormulaStr());
			request.setAttribute("condStr", kpi.getCondstr().getCondStr());
			request.setAttribute("id", id);
			request.setAttribute("kpiCode", kpiCode.get("KPI_CODE"));
			request.setAttribute("cube_code", kpiCode.get("CUBE_CODE"));
			request.setAttribute("baseType", kpiCode.get("KPI_TYPE"));
			request.setAttribute("managerFlag", managerFlag);
			return "/pages/kpi/formulaKpi/formulaEditKpi.jsp";
		}
		return "";
	}

	@Action("formulaKpiLook")
	public String formulaKpiLook(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("kpi_key");
		String lookUpFlag = (String) request.getParameter("lookUpFlag");
		if (StringUtils.isNotEmpty(id)) {
			Map<String, String> kpiCode = new HashMap<String, String>();
			Kpi kpi;
			try {
				kpiCode = fku.getKpiCodeToTMP(id, runner);
				kpi = parseXMLToKpi(kpiCode.get("KPI_BODY"));
				// .auditKpiTemplate(kpiCode.get("KPI_CODE"));
				BaseKpiService baseKpiService = new BaseKpiService();
				Map<String, String> fileMap = baseKpiService.queryFile(kpiCode
						.get("KPI_CODE"));
				if (fileMap != null) {
					request.setAttribute("fileName", fileMap.get("fileName"));
					request.setAttribute("filePath", fileMap.get("filePath"));
				}
			} catch (Exception e) {
				e.printStackTrace();
				throw new Exception(e.getMessage());
			}
			if("1".equals(fku.getServerNum(kpiCode.get("KPI_TYPE"), runner))){
				Map<String,String> code = new HashMap<String,String>();
	        	List<Map<String,String>> li = new FormulaKpiUtil().getCodeName(runner);
	        	int start = 0;
	        	if(null!=kpiCode.get("ID")&&!"".equals(kpiCode.get("ID"))){
		        	for(int i =0;i<li.size();i++){
		        		start = i*2;
		        		code.put(li.get(i).get("CLASS_NAME"), kpiCode.get("ID").substring(start, start+2));
		        	}
		        	request.setAttribute("serviceCode", JSONObject.fromObject(code));
					request.setAttribute(
							"codeId",
							kpiCode.get("ID").substring(start+2,
									kpiCode.get("ID").length()));
				}
			}
			request.setAttribute("formulaStr", kpi.getFormulastr()
					.getFormulaStr());
			request.setAttribute("condStr", kpi.getCondstr().getCondStr());
			request.setAttribute("id", id);
			request.setAttribute("kpiCode", kpiCode.get("KPI_CODE"));
			request.setAttribute("kpi_type", kpiCode.get("KPI_TYPE"));
			request.setAttribute("lookUpFlag", lookUpFlag);
			return "/pages/kpi/formulaKpi/formulaLookKpi.jsp";
		}
		return "";
	}
	@Action("formulaKpiLookVr")
	public String formulaKpiLookVr(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("kpi_key");
		String lookUpFlag = (String) request.getParameter("lookUpFlag");
		if (StringUtils.isNotEmpty(id)) {
			Map<String, String> kpiCode = new HashMap<String, String>();
			Kpi kpi;
			try {
				kpiCode = fku.getKpiCodeToTMP(id, runner);
				kpi = parseXMLToKpi(kpiCode.get("KPI_BODY"));
				// .auditKpiTemplate(kpiCode.get("KPI_CODE"));
				BaseKpiService baseKpiService = new BaseKpiService();
				Map<String, String> fileMap = baseKpiService.queryFile(kpiCode
						.get("KPI_CODE"));
				if (fileMap != null) {
					request.setAttribute("fileName", fileMap.get("fileName"));
					request.setAttribute("filePath", fileMap.get("filePath"));
				}
			} catch (Exception e) {
				e.printStackTrace();
				throw new Exception(e.getMessage());
			}
			if("1".equals(fku.getServerNum(kpiCode.get("KPI_TYPE"), runner))){
				Map<String,String> code = new HashMap<String,String>();
	        	List<Map<String,String>> li = new FormulaKpiUtil().getCodeName(runner);
	        	int start = 0;
	        	if(null!=kpiCode.get("ID")&&!"".equals(kpiCode.get("ID"))){
		        	for(int i =0;i<li.size();i++){
		        		start = i*2;
		        		code.put(li.get(i).get("CLASS_NAME"), kpiCode.get("ID").substring(start, start+2));
		        	}
		        	request.setAttribute("serviceCode", JSONObject.fromObject(code));
					request.setAttribute(
							"codeId",
							kpiCode.get("ID").substring(start+2,
									kpiCode.get("ID").length()));
				}
			}
			request.setAttribute("formulaStr", kpi.getFormulastr()
					.getFormulaStr());
			request.setAttribute("condStr", kpi.getCondstr().getCondStr());
			request.setAttribute("id", id);
			request.setAttribute("kpiCode", kpiCode.get("KPI_CODE"));
			request.setAttribute("kpi_type", kpiCode.get("KPI_TYPE"));
			request.setAttribute("lookUpFlag", lookUpFlag);
			return "/pages/kpi/formulaKpi/formulaLookKpiVr.jsp";
		}
		return "";
	}
	
	@Action("faileKpiList")
	public String faileKpiList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("kpi_key");
		String version = request.getParameter("version");
		String managerFlag = (String) request.getParameter("managerFlag");
		if (StringUtils.isNotEmpty(id)) {
			Map<String, String> kpiCode = new HashMap<String, String>();
			Kpi kpi;
			try {
				kpiCode = fku.getKpiCodeToTMP(id, runner);
				kpi = parseXMLToKpi(kpiCode.get("KPI_BODY"));
				
//				kpi = fku.readKpiTemplate(kpiCode.get("KPI_CODE"));
				BaseKpiService baseKpiService = new BaseKpiService();
				Map<String, String> fileMap = baseKpiService.queryFile(kpiCode
						.get("KPI_CODE"));
				if (fileMap != null) {
					request.setAttribute("fileName", fileMap.get("fileName"));
					request.setAttribute("filePath", fileMap.get("filePath"));
				}
			} catch (Exception e) {
				e.printStackTrace();
				throw new Exception(e.getMessage());
			}
			if("1".equals(fku.getServerNum(kpiCode.get("KPI_TYPE"), runner))){
				Map<String,String> code = new HashMap<String,String>();
	        	List<Map<String,String>> li = new FormulaKpiUtil().getCodeName(runner);
	        	int start = 0;
	        	if(null!=kpiCode.get("ID")&&!"".equals(kpiCode.get("ID"))){
		        	for(int i =0;i<li.size();i++){
		        		start = i*2;
		        		code.put(li.get(i).get("CLASS_NAME"), kpiCode.get("ID").substring(start, start+2));
		        	}
		        	request.setAttribute("serviceCode", JSONObject.fromObject(code));
					request.setAttribute(
							"codeId",
							kpiCode.get("ID").substring(start+2,
									kpiCode.get("ID").length()));
				}
			}
			request.setAttribute("formulaStr", kpi.getFormulastr()
					.getFormulaStr());
			request.setAttribute("condStr", kpi.getCondstr().getCondStr());
			request.setAttribute("id", id);
			request.setAttribute("kpiCode", kpiCode.get("KPI_CODE"));
			request.setAttribute("kpi_version", version);
			request.setAttribute("cube_code", kpiCode.get("CUBE_CODE"));
			request.setAttribute("kpi_type", kpiCode.get("KPI_TYPE"));
			request.setAttribute("managerFlag", managerFlag);
			return "/pages/kpi/kpifaile/formulaEditKpi.jsp";
		}
		return "";
	}
	
	@Action("formulaKpiLookVer")
	public String formulaKpiLookVer(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String code = request.getParameter("code");
		String version = request.getParameter("version");
		if (StringUtils.isNotEmpty(code)&&StringUtils.isNotEmpty(version)) {
			Map<String, String> kpiCode = new HashMap<String, String>();
			Kpi kpi;
			try {
				kpiCode = fku.kpi2CodeVer(code,version, runner);
				kpi = parseXMLToKpi(kpiCode.get("KPI_BODY"));
				// .auditKpiTemplate(kpiCode.get("KPI_CODE"));
				BaseKpiService baseKpiService = new BaseKpiService();
				Map<String, String> fileMap = baseKpiService.queryFile(kpiCode
						.get("KPI_CODE"));
				if (fileMap != null) {
					request.setAttribute("fileName", fileMap.get("fileName"));
					request.setAttribute("filePath", fileMap.get("filePath"));
				}
			} catch (Exception e) {
				e.printStackTrace();
				throw new Exception(e.getMessage());
			}
			if("1".equals(fku.getServerNum(kpiCode.get("KPI_TYPE"), runner))){
				Map<String,String> code1 = new HashMap<String,String>();
	        	List<Map<String,String>> li = new FormulaKpiUtil().getCodeName(runner);
	        	int start = 0;
	        	if(null!=kpiCode.get("ID")&&!"".equals(kpiCode.get("ID"))){
		        	for(int i =0;i<li.size();i++){
		        		start = i*2;
		        		code1.put(li.get(i).get("CLASS_NAME"), kpiCode.get("ID").substring(start, start+2));
		        	}
		        	request.setAttribute("serviceCode", JSONObject.fromObject(code1));
					request.setAttribute(
							"codeId",
							kpiCode.get("ID").substring(start+2,
									kpiCode.get("ID").length()));
				}
			}
			request.setAttribute("formulaStr", kpi.getFormulastr()
					.getFormulaStr());
			request.setAttribute("kpi_type", kpiCode.get("KPI_TYPE"));
			request.setAttribute("condStr", kpi.getCondstr().getCondStr());
			request.setAttribute("kpiCode", kpiCode.get("KPI_CODE"));
			return "/pages/kpi/formulaKpi/formulaLookKpi.jsp";
		}
		return "";
	}

	public int java2XML(Map parameter) throws Exception {
		List<String> baseDim = new ArrayList<String>();
		List<String> formulaKpi = new ArrayList<String>();
		List<String> baseKpi = new ArrayList<String>();
		String kpis = (String) parameter.get("kpis"); // 公式指标json
		String condJson = (String) parameter.get("condJson");// 条件json串
		String formulaCode = (String) parameter.get("base_key");// 指标编码
		String formulaVersion = (String) parameter.get("formula_version");// 指标版本
		String formula = (String) parameter.get("formula");// 公式
		String formulaID = (String) parameter.get("formulaKpi");// 公式指标的ID
		String formulaStr = (String) parameter.get("formulaStr");// 公式html
		String condStr = (String) parameter.get("condStr");// 条件html
		String condPar = (String) parameter.get("condPar");// 条件拼成的where
		String cubeCode = (String) parameter.get("cubeCode");//魔方编码
		List<Map<String, String>> formList = fku.jsonStrToList(kpis);
		List<Map<String, String>> condList = fku.jsonStrToList(condJson);

		List<Map<String, String>> allList = new ArrayList<Map<String, String>>();
		allList.addAll(formList);
		allList.addAll(condList);

		fku.gaugeClass(formList, baseDim, baseKpi, formulaKpi);
		fku.gaugeClass(condList, baseDim, baseKpi, formulaKpi);

		String bDimVal = fku.listToStr(baseDim);
		String bKpiVal = fku.listToStr(baseKpi);
		String fKpiVal = fku.listToStr(formulaKpi);

		List<Map<String, Object>> dimList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> kpiList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> fKpiList = new ArrayList<Map<String, Object>>();
		try {
			dimList = fku.getDB(runner.sql("java.kpi.formulaKpiClass.DIMSQL") +" WHERE t.cube_code='"+ cubeCode +"' AND t.dim_code IN ", bDimVal,runner);
			kpiList = fku.getDB(runner.sql("java.kpi.formulaKpiClass.KPISQL") + " AND t.cube_code='"+ cubeCode +"' AND T.base_key in ", bKpiVal,runner);
			fKpiList = fku.getDB(runner.sql("java.kpi.formulaKpiClass.FKPISQL") + " AND t.cube_code='"+ cubeCode +"' AND T.KPI_CODE in ", fKpiVal,runner);
			Map<String,Object> infor = fku.getCreateUserOrCreateDateTime(formulaCode,runner);
			if(infor != null && infor.size() > 0) {
				parameter.put("create_user_old", infor.get("CREATE_USER"));
				parameter.put("create_datetime_old", infor.get("CREATE_DATETIME"));
			} else {
				parameter.put("create_user_old", "");
				parameter.put("create_datetime_old", "");
			}
		} catch (Exception e) {
			throw new Exception(e);
		}
		Kpi kpi = new Kpi();
		kpi.setId(formulaCode);
		kpi.setVersion(formulaVersion);
		// XML中基础维度<dimensions>内容
		this.dimension(dimList, kpi);
		// XML中基础指标<measures>内容
		this.measure(allList, kpiList, fKpiList, kpi);

		Formulas formulas = new Formulas();
		Formula fa = new Formula();
		fa.setType("1");
		fa.setSource(formulaID);
		fa.setFormula(formula);

		formulas.setFormula(fa);
		kpi.setFormulas(formulas);

		this.condition(condList, kpi, condPar);
		Formulastr fs = new Formulastr();
		fs.setFormulaStr(formulaStr);
		kpi.setFormulastr(fs);
		Condstr cs = new Condstr();
		cs.setCondStr(condStr);
		kpi.setCondstr(cs);
		SelfWhere selfWhere = new SelfWhere();
		selfWhere.setSeflCondition("");
		kpi.setSelfWhere(selfWhere);
		String kpiBody = "";
		GenerateKpi gk = new GenerateKpi();
		try {
			gk.writeKpiTemplate(formulaCode, kpi);
			kpiBody = new String(
					gk.toByteArrayFromInputStream(new FileInputStream(gk
							.getFilePath() + gk.getSuffix())), "UTF-8");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			throw new Exception(e.getMessage());
		}
		parameter.put("xml", kpiBody);
		int count = fku.save(dimList, kpiList, fKpiList, parameter, runner);
		try {
			fku.saveAttr(parameter, runner);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			throw new Exception(e.getMessage());
		}
		return count;

	}

	// XML中基础维度<dimensions>内容
	public void dimension(List<Map<String, Object>> dimList, Kpi kpi) {
		Dimensions dimensions = new Dimensions();
		List<Dimension> dList = new ArrayList<Dimension>();
		for (Map<String, Object> map : dimList) {
			StringBuffer sql = new StringBuffer("");
			Dimension dimension = new Dimension();
			dimension.setId(map.get("DIM_CODE").toString());
			dimension.setName(map.get("DIM_NAME").toString());
			if (null == map.get("AILS") || "".equals(map.get("AILS"))) {
				dimension.setAlias("");
			} else {
				dimension.setAlias(map.get("AILS").toString());
			}
			if (null == map.get("DIM_TABLE") || "".equals(map.get("DIM_TABLE"))) {
				dimension.setTableLink("");
			} else {
				dimension.setTableLink(map.get("DIM_TABLE").toString());
			}
			dimension.setColumnLink(map.get("DIM_FIELD").toString());
			dimension.setConfType(map.get("CONF_TYPE").toString());
			dimension.setDimType(map.get("DIM_TYPE").toString());
			if (null != map.get("DATASOURCE")) {
				dimension.setDataSource(map.get("DATASOURCE").toString());
			} else {
				dimension.setDataSource("");
			}

			Dictionary dictionary = new Dictionary();
			if ("1".equals(map.get("DIM_TYPE").toString())) {
				dictionary.setKey(map.get("CODE").toString());
				dictionary.setName(map.get("NAME").toString());
				if("1".equals(map.get("CONF_TYPE"))) {
					if (null != map.get("CONDITION")) {
						sql.append("select ");
						sql.append(" ");
						sql.append(map.get("CODE").toString());
						sql.append(",");
						sql.append(map.get("NAME").toString());
						sql.append(" ");
						sql.append("from ");
						sql.append(" ");
						sql.append(map.get("TABLE_NAME").toString());
						sql.append(" ");
						sql.append(map.get("CONDITION").toString()
								.replace("\"", "'"));
					}
					dictionary.setTableLink(map.get("TABLE_NAME").toString());
				} else {
					sql.append(map.get("SQL_CODE")==null?"":map.get("SQL_CODE").toString());
					dictionary.setTableLink("");
				}
			} else {
				dictionary.setKey("");
				dictionary.setName("");
				dictionary.setTableLink("");
			}
			dictionary.setDictionary(sql.toString());
			dimension.setDictionary(dictionary);
			dList.add(dimension);
		}
		dimensions.setDimensionList(dList);
		kpi.setDimensions(dimensions);
	}

	// 生成XML基础指标<measures>内容
	public void measure(List<Map<String, String>> allList,
			List<Map<String, Object>> kpiList,
			List<Map<String, Object>> fKpiList, Kpi kpi) {
		Measures measures = new Measures();
		List<Measure> mList = new ArrayList<Measure>();
		for (Map<String, Object> map : kpiList) {
			Measure measure = new Measure();
			String code = fku.getCode(allList, map.get("BASE_KEY").toString());
			measure.setId(code);
			measure.setName(map.get("KPI_NAME").toString());
			measure.setAlias(map.get("KPI_NAME").toString());
			measure.setTableLink(map.get("TABLENAME").toString());
			measure.setColumnLink(map.get("KPI_ORIGIN_COLUMN").toString());
			measure.setAggregator("SUM");
			measure.setDatasource(map.get("KPI_EDS").toString());
			measure.setVersion(map.get("KPI_VERSION").toString());
			measure.setKpiKey(map.get("ID").toString());

			ForeignKeyLink foreignKeyLink = new ForeignKeyLink();
			foreignKeyLink.setDimension("");
			foreignKeyLink.setForeignKeyColumn("");
			measure.setForeignKeyLink(foreignKeyLink);

			mList.add(measure);
		}
		this.composite(allList, fKpiList, mList);
		measures.setMeasureList(mList);
		kpi.setMeasures(measures);

	}

	// 生成XML衍生指标<measures>内容中的复合指标
	public void composite(List<Map<String, String>> allList,
			List<Map<String, Object>> fKpiList, List<Measure> mList) {
		for (Map<String, Object> map : fKpiList) {
			Measure measure = new Measure();
			String code = fku.getCode(allList, map.get("KPI_CODE").toString());
			measure.setId(code);
			measure.setVersion(map.get("KPI_VERSION").toString());
			measure.setKpiKey(map.get("KPI_KEY").toString());
			measure.setName(map.get("KPI_NAME").toString());
			measure.setAlias(map.get("KPI_NAME").toString());
			measure.setTableLink("");
			measure.setColumnLink("");
			measure.setAggregator(map.get("AGGREGATOR").toString());
			if (null != map.get("DATASOURCE")) {
				measure.setDatasource(map.get("DATASOURCE").toString());
			} else {
				measure.setDatasource("");
			}

			ForeignKeyLink foreignKeyLink = new ForeignKeyLink();
			foreignKeyLink.setDimension("");
			foreignKeyLink.setForeignKeyColumn("");

			measure.setForeignKeyLink(foreignKeyLink);

			mList.add(measure);

		}
	}

	// 生成XML基础指标<condition>内容中的复合指标
	public void condition(List<Map<String, String>> condList, Kpi kpi,
			String expression) {
		Conditions conditions = new Conditions();
		List<Condition> cList = new ArrayList<Condition>();
		for (Map<String, String> map : condList) {
			Condition condition = new Condition();

			condition.setSource(map.get("nodeId"));
			condition.setType(map.get("nodeType"));
			condition.setOperator(map.get("oper"));
			condition.setDataType("string");
			if ("6".equals(map.get("nodeType"))
					|| "7".equals(map.get("nodeType"))) {
				condition.setParamsType("0");
			} else if ("4".equals(map.get("nodeType"))
					|| "5".equals(map.get("nodeType"))) {
				condition.setParamsType("0");
			} else if ("1".equals(map.get("nodeType"))) {
				condition.setParamsType("1");
			} else if ("2".equals(map.get("nodeType"))) {
				condition.setParamsType("1");
			} else if ("0".equals(map.get("nodeType"))) {
				condition.setParamsType("3");
			}
			condition.setParamsValue(map.get("condval"));
			condition.setCondition("");
			// condition.setParamId("");
			// condition.setPrepend("");
			// Relation relation = new Relation();
			// relation.setRelation("");
			// condition.setRelation(relation);
			cList.add(condition);
		}
		conditions.setConditionList(cList);
		Expression exp = new Expression();
		exp.setExpression(expression);
		conditions.setExpression(exp);
		kpi.setConditions(conditions);
	}

	protected String ClobToString(Object object) throws Exception {
		String reString = "";
		Reader is = ((Clob) object).getCharacterStream();// 得到流
		BufferedReader br = new BufferedReader(is);
		String s = br.readLine();
		StringBuffer sb = new StringBuffer();
		while (s != null) {// 执行循环将字符串全部取出付值给StringBuffer由StringBuffer转成STRING
			sb.append(s);
			s = br.readLine();
		}
		reString = sb.toString();
		return reString;
	}

	/**
	 * 将衍生指标映射成指标对象
	 * 
	 * @param kpiXml
	 * @throws Exception
	 */
	protected Kpi parseXMLToKpi(String kpiXml) throws Exception {
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

	@Action("downLoadFile")
	public String downLoadFile(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		try {
			String fileName = (String) request.getParameter("fileName");
			String filePath = (String) request.getParameter("filePath");
			fileName = new String(fileName.getBytes(), "iso-8859-1");
			response.reset();
			response.setContentType("APPLICATION/OCTET-STREAM");
			response.setHeader("Content-Disposition", "attachment;filename=\""
					+ fileName + "\"");
			ServletOutputStream outPut = response.getOutputStream();
			File downFile = new File(filePath);
			InputStream inStream = new FileInputStream(downFile);
			byte[] b = new byte[1024];
			int len;
			while ((len = inStream.read(b)) > 0) {
				outPut.write(b, 0, len);
			}
			response.setStatus(response.SC_OK);
			response.flushBuffer();
			outPut.close();
			inStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
}
