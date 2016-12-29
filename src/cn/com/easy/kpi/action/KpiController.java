package cn.com.easy.kpi.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.MapListHandler;
import org.apache.commons.io.FileUtils;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.exception.JaxbException;
import cn.com.easy.jaxb.parser.DefaultJaxbParse;
import cn.com.easy.jaxb.parser.JaxbParse;
import cn.com.easy.kpi.element.*;
import cn.com.easy.kpi.parser.GenerateKpi;
import cn.com.easy.kpi.service.KpiDbService;
import cn.com.easy.kpi.util.Log;
import cn.com.easy.kpi.util.LogInfo;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.util.StringUtils;

@Controller
public class KpiController {
	private SqlRunner runner;
	final String kpiSql = "SELECT T.OID OID,T.NAME NAME, nvl(nvl2(T.TABLENAME,t.TABLENAME, ''), ' ') TABLELINK,nvl(nvl2(T.FIELD_CODE,t.FIELD_CODE ,'' ), ' ') COLUMNLINK,'sum' AGGREGATOR FROM X_KPI_VIEW T WHERE 1=1";
	final String complexkpi = "SELECT T.KPI_KEY,T.KPI_CODE,T.KPI_NAME,'' TABLELINK,''COLUMNLINK,'sum' AGGREGATOR FROM X_KPI_INFO T WHERE 1=1";
	final String dimSql = "SELECT T.OID,T.NAME,nvl(nvl2(T.FIELD_ALIAS,t.FIELD_ALIAS,''),' ') FIELD_ALIAS,nvl(nvl2(T.TABLECODE,t.TABLECODE,''),' ') TABLECODE,nvl(nvl2(T.TABLENAME,t.TABLENAME,''),' ') TABLENAME,nvl(nvl2(T.LINKTABLE,t.LINKTABLE,''),' ') LINKTABLE,nvl(nvl2(t.FIELD_CODE,t.FIELD_CODE,''),' ') FIELD_CODE,CASE T.MENU_NAME WHEN '日' THEN '0' WHEN '月' THEN '2' ELSE '3' END TYPE  FROM X_DIMENSION_VIEW T WHERE 1=1";

	@Action("audit")
	public void audit(String kpiCode) throws IOException {
		GenerateKpi gk = new GenerateKpi();
		String srcFilePath = gk.getKpiTmpPath() + kpiCode + gk.getSuffix();
		String destFilePath = gk.getKpiPath() + kpiCode + gk.getSuffix();
		File srcFile = new File(srcFilePath);
		File destFile = new File(destFilePath);
		FileUtils.copyFile(srcFile, destFile);
		FileUtils.deleteQuietly(srcFile);
	}

	@Action("comKpilist")
	public String list(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String oid = request.getParameter("kpi_key");
		Class<Kpi> cla = Kpi.class;
		Map m = runner
				.queryForMap("SELECT T.KPI_CODE,T.KPI_CATEGORY,T.KPI_NAME,T.KPI_NUIT,T.KPI_BODY,T.KPI_CALIBER KPICALIBER,T.KPI_EXPLAIN KPIEXPLAIN,T.KPI_VERSION KPIVERSION,T.KPI_USER ,T.KPI_DEPT,T.KPI_FILE FROM X_KPI_INFO_TMP T WHERE T.KPI_KEY='"
						+ oid + "'");
		JaxbParse jp = new DefaultJaxbParse();
		Kpi kpi = jp.readXmlStr(cla, m.get("KPI_BODY").toString());
		// Kpi kpi = jp.readXmlStr(cla, s);
		Measures me = kpi.getMeasures();
		List<Measure> lm = me.getMeasureList();
		Formulas formulas = kpi.getFormulas();
		Formula fo = formulas.getFormula();
		String fm = fo.getFormula();
		String fm1 = fo.getFormula();
		String source = fo.getSource();
		String[] sources = source.split(",");
		String kpiCode = "";
		String complexkpiCode = "";
		for (int i = 0; i < sources.length; i++) {
			if (sources[i].startsWith("MF_")) {
				complexkpiCode = complexkpiCode + "," + sources[i];
			} else {
				kpiCode = kpiCode + "," + sources[i];
			}

			for (Measure measure : lm) {
				if (sources[i].equals(measure.getId())) {
					String type = "2";
					if (measure.getId().startsWith("MF_")) {
						type = "1";
					}
					fm = fm.replaceAll(
							"\\{" + measure.getId() + "\\}",
							(String) ("<input type='button' class='delBtnB' kpiName = '"
									+ measure.getName()
									+ "' kpiType = '"
									+ type
									+ "' kpiId = '"
									+ measure.getId()
									+ "' value='" + measure.getName() + "'>"));
					break;
				}
			}
		}

		List<Dimension> dimList = kpi.getDimensions().getDimensionList();
		List<Condition> conditions = kpi.getConditions().getConditionList();
		List<Map<String, String>> conList = new ArrayList<Map<String, String>>();
		SelfWhere sw = kpi.getSelfWhere();
		int count = 0;
		String dIndex = "";
		if (null != lm && !lm.isEmpty()) {
			for (Measure measure : lm) {
				Map<String, String> map = new HashMap<String, String>();
				for (int i = 0; i < conditions.size(); i++) {
					Condition condition = conditions.get(i);
					if (measure.getId().equals(condition.getSource())) {
						map.put("dimName", measure.getName());
						String unitSql = "select CODE,NAME from x_kpi_code where type = '1' and code = '"
								+ condition.getOperator() + "'";
						Map<String, String> unitl = (Map<String, String>) runner
								.queryForMap(unitSql);
						map.put("ljf", unitl.get("NAME"));
						map.put("tjz", condition.getParamsValue());
						String prependSql = "select CODE,NAME from x_kpi_code where type = '2' and code = '"
								+ condition.getPrepend() + "'";
						Map<String, String> prepend = (Map<String, String>) runner
								.queryForMap(prependSql);
						map.put("ljkjf",
								prepend.get("NAME")
										+ "<input type=hidden id=ljf_name"
										+ count
										+ " name=ljf_name"
										+ count
										+ "value="
										+ condition.getOperator()
										+ " ><input type=hidden id=ljkjf"
										+ count
										+ " name=ljkjf"
										+ count
										+ "value="
										+ condition.getPrepend()
										+ " ><input type=hidden id=tjz"
										+ count
										+ " name=tjz"
										+ count
										+ " ><input type=hidden id=did"
										+ count
										+ " name=did"
										+ count
										+ " ><input type=hidden name=hidconstant"
										+ count
										+ " id=hidconstant"
										+ count
										+ " value=1><input type=hidden id=dimName"
										+ count + " name=dimName" + count
										+ " value=" + measure.getId()
										+ "><input type=hidden id=isKpi"
										+ count + " name=isKpi" + count
										+ " value=1>");
						conditions.remove(i);
						conList.add(map);
						dIndex = dIndex + "," + count;
						count++;
						break;
					}
				}
			}
		}
		if (null != dimList && !dimList.isEmpty()) {
			for (Dimension dimension : dimList) {
				Map<String, String> map = new HashMap<String, String>();
				for (int i = 0; i < conditions.size(); i++) {
					Condition condition = conditions.get(i);
					if (dimension.getId().equals(condition.getSource())) {
						map.put("dimName", dimension.getName());
						String unitSql = "select CODE,NAME from x_kpi_code where type = '1' and code = '"
								+ condition.getOperator() + "'";
						Map<String, String> unitl = (Map<String, String>) runner
								.queryForMap(unitSql);
						map.put("ljf", unitl.get("NAME"));
						map.put("tjz", condition.getParamsValue());
						String prependSql = "select CODE,NAME from x_kpi_code where type = '2' and code = '"
								+ condition.getPrepend() + "'";
						Map<String, String> prepend = (Map<String, String>) runner
								.queryForMap(prependSql);
						map.put("ljkjf",
								prepend.get("NAME")
										+ "<input type=hidden id=ljf_name"
										+ count
										+ " name=ljf_name"
										+ count
										+ " value="
										+ condition.getOperator()
										+ " ><input type=hidden id=ljkjf"
										+ count
										+ " name=ljkjf"
										+ count
										+ " value="
										+ condition.getPrepend()
										+ " ><input type=hidden id=tjz"
										+ count
										+ " name=tjz"
										+ count
										+ " value="
										+ condition.getParamsValue()
										+ " ><input type=hidden id=did"
										+ count
										+ " name=did"
										+ count
										+ " value="
										+ condition.getParamId()
										+ " ><input type=hidden name=hidconstant"
										+ count + " id=hidconstant" + count
										+ " value=0><input type=hidden id=ljf"
										+ count + " name=ljf" + count
										+ " ><input type=hidden id=dimName"
										+ count + " name=dimName" + count
										+ " value=" + dimension.getId()
										+ "><input type=hidden id=isKpi"
										+ count + " name=isKpi" + count
										+ " value=0>");
						conditions.remove(i);
						conList.add(map);
						dIndex = dIndex + "," + count;
						count++;

						break;
					}
				}
			}
		}
		List<Map<String, String>> forList = new ArrayList<Map<String, String>>();
		Map<String, String> formula1 = new HashMap<String, String>();
		formula1.put("kpi_forms", fm);
		forList.add(formula1);

		request.setAttribute("cond", sw.getSeflCondition());
		request.setAttribute("name", m.get("KPI_NAME").toString());
		request.setAttribute("unit", m.get("KPI_NUIT").toString());
		request.setAttribute("fm", fm);
		request.setAttribute("KPIUSER", m.get("KPI_USER").toString());
		request.setAttribute("KPIDEPT", m.get("KPI_DEPT").toString());
		request.setAttribute("KPIFILE", m.get("KPI_FILE").toString());
		if (StringUtils.isNotEmpty(dIndex)) {
			request.setAttribute("dIndex", dIndex.substring(1, dIndex.length())
					+ ",");
		} else {
			request.setAttribute("dIndex", dIndex);
		}
		request.setAttribute("code", m.get("KPI_CODE").toString());
		request.setAttribute("kpiCalIber", m.get("KPICALIBER").toString());
		request.setAttribute("kpiExplain", m.get("KPIEXPLAIN").toString());
		request.setAttribute("dimCondition", JSONArray.fromObject(conList)
				.toString());
		request.setAttribute("oid", oid);
		request.setAttribute("KPIVERSION", m.get("KPIVERSION").toString());
		request.setAttribute("kpiCategory", m.get("KPI_CATEGORY").toString());
		return "/pages/kpi/manager/newEditkpi.jsp";
	}

	@Action("lookKpilist")
	public String lookKpi(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String oid = request.getParameter("kpi_key");
		Class<Kpi> cla = Kpi.class;
		Map m = runner
				.queryForMap("SELECT T.KPI_CODE,T.KPI_CATEGORY,T.KPI_NAME,T.KPI_NUIT,T.KPI_BODY,T.KPI_CALIBER KPICALIBER,T.KPI_EXPLAIN KPIEXPLAIN,T.KPI_VERSION KPIVERSION,T.KPI_USER ,T.KPI_DEPT,T.KPI_FILE FROM X_KPI_INFO_TMP T WHERE T.KPI_KEY='"
						+ oid + "'");
		JaxbParse jp = new DefaultJaxbParse();
		Kpi kpi = jp.readXmlStr(cla, m.get("KPI_BODY").toString());
		// Kpi kpi = jp.readXmlStr(cla, s);
		Measures me = kpi.getMeasures();
		List<Measure> lm = me.getMeasureList();
		Formulas formulas = kpi.getFormulas();
		Formula fo = formulas.getFormula();
		String fm = fo.getFormula();
		String fm1 = fo.getFormula();
		String source = fo.getSource();
		String[] sources = source.split(",");
		String kpiCode = "";
		String complexkpiCode = "";
		for (int i = 0; i < sources.length; i++) {
			if (sources[i].startsWith("MF_")) {
				complexkpiCode = complexkpiCode + "," + sources[i];
			} else {
				kpiCode = kpiCode + "," + sources[i];
			}

			for (Measure measure : lm) {
				if (sources[i].equals(measure.getId())) {
					String type = "2";
					if (measure.getId().startsWith("MF_")) {
						type = "1";
					}
					fm = fm.replaceAll(
							"\\{" + measure.getId() + "\\}",
							(String) ("<input type='button' class='delBtnB' kpiName = '"
									+ measure.getName()
									+ "' kpiType = '"
									+ type
									+ "' kpiId = '"
									+ measure.getId()
									+ "' value='" + measure.getName() + "'>"));
					break;
				}
			}
		}

		List<Dimension> dimList = kpi.getDimensions().getDimensionList();
		List<Condition> conditions = kpi.getConditions().getConditionList();
		List<Map<String, String>> conList = new ArrayList<Map<String, String>>();
		SelfWhere sw = kpi.getSelfWhere();
		int count = 0;
		String dIndex = "";
		if (null != lm && !lm.isEmpty()) {
			for (Measure measure : lm) {
				Map<String, String> map = new HashMap<String, String>();
				for (int i = 0; i < conditions.size(); i++) {
					Condition condition = conditions.get(i);
					if (measure.getId().equals(condition.getSource())) {
						map.put("dimName", measure.getName());
						String unitSql = "select CODE,NAME from x_kpi_code where type = '1' and code = '"
								+ condition.getOperator() + "'";
						Map<String, String> unitl = (Map<String, String>) runner
								.queryForMap(unitSql);
						map.put("ljf", unitl.get("NAME"));
						map.put("tjz", condition.getParamsValue());
						String prependSql = "select CODE,NAME from x_kpi_code where type = '2' and code = '"
								+ condition.getPrepend() + "'";
						Map<String, String> prepend = (Map<String, String>) runner
								.queryForMap(prependSql);
						map.put("ljkjf", prepend.get("NAME")
								+ "<input type=hidden id=ljf_name" + count
								+ " name=ljf_name" + count
								+ " ><input type=hidden id=ljkjf" + count
								+ " name=ljkjf" + count
								+ " ><input type=hidden id=tjz" + count
								+ " name=tjz" + count
								+ " ><input type=hidden id=did" + count
								+ " name=did" + count
								+ " ><input type=hidden name=hidconstant"
								+ count + " id=hidconstant" + count
								+ " value=1><input type=hidden id=dimName"
								+ count + " name=dimName" + count + " value="
								+ measure.getId()
								+ "><input type=hidden id=isKpi" + count
								+ " name=isKpi" + count + " value=1>");
						conditions.remove(i);
						conList.add(map);
						dIndex = dIndex + "," + count;
						count++;
						break;
					}
				}
			}
		}
		if (null != dimList && !dimList.isEmpty()) {
			for (Dimension dimension : dimList) {
				Map<String, String> map = new HashMap<String, String>();
				for (int i = 0; i < conditions.size(); i++) {
					Condition condition = conditions.get(i);
					if (dimension.getId().equals(condition.getSource())) {
						map.put("dimName", dimension.getName());
						String unitSql = "select CODE,NAME from x_kpi_code where type = '1' and code = '"
								+ condition.getOperator() + "'";
						Map<String, String> unitl = (Map<String, String>) runner
								.queryForMap(unitSql);
						map.put("ljf", unitl.get("NAME"));
						map.put("tjz", condition.getParamsValue());
						String prependSql = "select CODE,NAME from x_kpi_code where type = '2' and code = '"
								+ condition.getPrepend() + "'";
						Map<String, String> prepend = (Map<String, String>) runner
								.queryForMap(prependSql);
						map.put("ljkjf",
								prepend.get("NAME")
										+ "<input type=hidden id=ljf_name"
										+ count
										+ " name=ljf_name"
										+ count
										+ " ><input type=hidden id=ljkjf"
										+ count
										+ " name=ljkjf"
										+ count
										+ " ><input type=hidden id=tjz"
										+ count
										+ " name=tjz"
										+ count
										+ " value="
										+ condition.getParamsValue()
										+ " ><input type=hidden id=did"
										+ count
										+ " name=did"
										+ count
										+ " value="
										+ condition.getParamId()
										+ " ><input type=hidden name=hidconstant"
										+ count + " id=hidconstant" + count
										+ " value=0><input type=hidden id=ljf"
										+ count + " name=ljf" + count
										+ " ><input type=hidden id=dimName"
										+ count + " name=dimName" + count
										+ " value=" + dimension.getId()
										+ "><input type=hidden id=isKpi"
										+ count + " name=isKpi" + count
										+ " value=0>");
						conditions.remove(i);
						conList.add(map);
						dIndex = dIndex + "," + count;
						count++;

						break;
					}
				}
			}
		}
		List<Map<String, String>> forList = new ArrayList<Map<String, String>>();
		Map<String, String> formula1 = new HashMap<String, String>();
		formula1.put("kpi_forms", fm);
		forList.add(formula1);

		request.setAttribute("cond", sw.getSeflCondition());
		request.setAttribute("name", m.get("KPI_NAME").toString());
		request.setAttribute("unit", m.get("KPI_NUIT").toString());
		request.setAttribute("fm", fm);
		request.setAttribute("KPIUSER", m.get("KPI_USER").toString());
		request.setAttribute("KPIDEPT", m.get("KPI_DEPT").toString());
		request.setAttribute("KPIFILE", m.get("KPI_FILE").toString());
		if (StringUtils.isNotEmpty(dIndex)) {
			request.setAttribute("dIndex", dIndex.substring(1, dIndex.length())
					+ ",");
		} else {
			request.setAttribute("dIndex", dIndex);
		}
		request.setAttribute("code", m.get("KPI_CODE").toString());
		request.setAttribute("kpiCalIber", m.get("KPICALIBER").toString());
		request.setAttribute("kpiExplain", m.get("KPIEXPLAIN").toString());
		request.setAttribute("dimCondition", JSONArray.fromObject(conList)
				.toString());
		request.setAttribute("oid", oid);
		request.setAttribute("KPIVERSION", m.get("KPIVERSION").toString());
		request.setAttribute("kpiCategory", m.get("KPI_CATEGORY").toString());
		return "/pages/kpi/manager/newLookkpi.jsp";
	}

	@Action("kpiUpdate")
	public void kpiUpdate(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String updateStr = "UPDATE X_KPI_INFO_TMP T SET T.KPI_NAME =?,T.KPI_CATEGORY = ?,T.KPI_NUIT = ?,T.KPI_ISCURR = ?,T.KPI_CALIBER = ?,T.KPI_EXPLAIN = ?,T.KPI_FLAG = ?,T.KPI_STATUS = ?,T.KPI_BODY = ?,T.UPDATE_USER =?,T.UPDATE_DATETIME = ?,T.KPI_USER=?,T.KPI_DEPT=?,T.KPI_FILE=?,T.KPI_VERSION     = ? WHERE T.KPI_KEY=?";
		String updateSouStr = " INSERT INTO X_KPI_SOURCE_TMP (SOURCE_KEY,KPI_CODE,KPI_VERSION,SOURCE_CODE,SOURCE_NAME,SOURCE_TABLE,SOURCE_COLUMN,SOURCE_CONDITION,SOURCE_TYPE) VALUES(?,?,?,?,?,?,?,?,?)";
		String delSource = "DELETE FROM X_KPI_SOURCE_TMP T WHERE T.SOURCE_KEY = ?";

		EasyDataSource dataSource = null;
		// 获取前台传值
		String dIndex = request.getParameter("dIndex");
		String kpiName = request.getParameter("kpiName");
		String kpiUnit0 = request.getParameter("kpiUnit0");
		String kpiUnit1 = request.getParameter("kpiUnit1");
		String formual = request.getParameter("formual");
		String isFormula = request.getParameter("isFormula");
		String kpiCode = request.getParameter("kpiCode");
		String comKpiCode = request.getParameter("code");
		String Kpiversion = request.getParameter("kpiVersion");
		String kpiCategory = request.getParameter("kpiCategory");
		String kpiUser = request.getParameter("kpiUser");
		String kpiDept = request.getParameter("kpiDept");
		String kpiFile = request.getParameter("kpiFile");
		String oid = request.getParameter("oid");
		String cond = request.getParameter("cond");// 手动输入条件
		// if (StringUtils.isNotEmpty(kpiCode)) {
		// kpiCode = kpiCode.substring(1, kpiCode.length());
		// }
		String complexkpiCode = request.getParameter("complexkpiCode");
		// if (StringUtils.isNotEmpty(complexkpiCode)) {
		// complexkpiCode = complexkpiCode.substring(1,
		// complexkpiCode.length());
		// }
		if (null == cond) {
			cond = "";
		}
		String kpiCalIber = request.getParameter("kpiCalIber");
		String kpiExplain = request.getParameter("kpiExplain");
		String[] condIndex = dIndex.split(",");
		List<Map<String, String>> conditions = new ArrayList<Map<String, String>>();
		for (int i = 0; i < condIndex.length; i++) {
			Map m = new HashMap<String, String>();
			m.put("dimName", request.getParameter("arr[" + i + "][dimName]"));
			m.put("dimCode", request.getParameter("arr[" + i + "][dimCode]"));
			m.put("ljfName", request.getParameter("arr[" + i + "][ljfName]"));
			m.put("tjzName", request.getParameter("arr[" + i + "][tjzUnit]"));
			m.put("tjzCode", request.getParameter("arr[" + i + "][did]"));
			m.put("ljkjf", request.getParameter("arr[" + i + "][ljkjf]"));
			m.put("isKpi", request.getParameter("arr[" + i + "][isKpi]"));
			m.put("constant", request.getParameter("arr[" + i + "][constant]"));
			conditions.add(m);
		}
		List<String> kpiCodes = new ArrayList<String>();
		List<String> dimCodes = new ArrayList<String>();
		List<String> complexkpiCodes = new ArrayList<String>();
		for (Map<String, String> map : conditions) {
			if ("1".equals(map.get("isKpi"))) {
				if (StringUtils.isNotEmpty(map.get("dimCode"))) {
					kpiCodes.add(map.get("dimCode"));
				}
			} else {
				if (StringUtils.isNotEmpty(map.get("dimCode"))) {
					dimCodes.add(map.get("dimCode"));
				}
			}
		}
		String[] kpiTmp = null;
		if (StringUtils.isNotEmpty(kpiCode)) {
			kpiTmp = kpiCode.trim().split(",");
		}
		String[] complexTmp = null;
		if (StringUtils.isNotEmpty(complexkpiCode)) {
			complexTmp = complexkpiCode.split(",");
		}
		if (null != kpiTmp && kpiTmp.length != 0) {
			for (int i = 0; i < kpiTmp.length; i++) {
				kpiCodes.add(kpiTmp[i]);
			}
		}
		if (null != complexTmp && complexTmp.length != 0) {
			for (int i = 0; i < complexTmp.length; i++) {
				complexkpiCodes.add(complexTmp[i]);
			}
		}
		// 查询标准指标
		List<Map<String, Object>> kpiList = new ArrayList<Map<String, Object>>();
		if (!kpiCodes.isEmpty()) {

			dataSource = EasyContext.getContext().getDataSource(
					"java:/comp/env/jndi/initdb");
			Connection conn = dataSource.getConnection();
			kpiList = this.getKpiOrDim(conn, kpiCodes, kpiSql);
			this.colseConn(conn);
		}
		// 查询复合指标
		List<Map<String, Object>> complexkpiList = new ArrayList<Map<String, Object>>();
		if (!complexkpiCodes.isEmpty()) {
			dataSource = EasyContext.getContext().getDataSource();
			Connection conn = dataSource.getConnection();
			complexkpiList = this.getComplexkpi(conn, complexkpiCodes,
					complexkpi);
			this.colseConn(conn);
		}
		// 查询维度
		List<Map<String, Object>> dimList = new ArrayList<Map<String, Object>>();
		if (!dimCodes.isEmpty()) {
			dataSource = EasyContext.getContext().getDataSource(
					"java:/comp/env/jndi/initdb");
			Connection conn = dataSource.getConnection();
			dimList = this.getKpiOrDim(conn, dimCodes, dimSql);
			this.colseConn(conn);
		}

		/**
		 * 生成XML
		 */
		// String uuid = UUID.randomUUID().toString();
		// uuid = uuid.replace("-", "").toUpperCase();
		String uuid = comKpiCode;
		Kpi kpi = new Kpi();
		kpi.setId(uuid);
		kpi.setVersion((Integer.parseInt(Kpiversion) + 1) + "");
		// XML中基础维度<dimensions>内容
		Dimensions dimensions = new Dimensions();

		List<Dimension> dList = new ArrayList<Dimension>();
		for (Map<String, Object> map : dimList) {
			Dimension dimension = new Dimension();
			dimension.setId(map.get("OID").toString());
			dimension.setName(map.get("NAME").toString());
			dimension.setAlias(map.get("FIELD_ALIAS").toString());
			dimension.setTableLink(map.get("LINKTABLE").toString());
			dimension.setColumnLink(map.get("FIELD_CODE").toString());
			dimension.setFormatType(map.get("TYPE").toString());
			// dimension.setDictionary(dictionary);
			Dictionary dictionary = new Dictionary();
			Map<String, String> m = this.getDictionary(dataSource,
					map.get("TABLECODE").toString(), map.get("TABLENAME")
							.toString());
			dictionary.setKey(m.get("KEY"));
			dictionary.setName(m.get("VALUE"));
			dictionary.setTableLink(m.get("TABLENAME"));
			dictionary.setDictionary(m.get("sql"));
			dimension.setDictionary(dictionary);

			dList.add(dimension);
		}
		dimensions.setDimensionList(dList);
		kpi.setDimensions(dimensions);

		// 生成XML基础指标<measures>内容
		Measures measures = new Measures();
		List<Measure> mList = new ArrayList<Measure>();
		for (Map<String, Object> map : kpiList) {
			Measure measure = new Measure();
			measure.setId(map.get("OID").toString());
			measure.setName(map.get("NAME").toString());
			measure.setAlias(map.get("NAME").toString());
			measure.setTableLink(map.get("TABLELINK").toString());
			measure.setColumnLink(map.get("COLUMNLINK").toString());
			measure.setAggregator(map.get("AGGREGATOR").toString());

			ForeignKeyLink foreignKeyLink = new ForeignKeyLink();
			foreignKeyLink.setDimension("");
			foreignKeyLink.setForeignKeyColumn("");
			measure.setForeignKeyLink(foreignKeyLink);

			mList.add(measure);
		}
		for (Map<String, Object> map : complexkpiList) {

			Measure measure = new Measure();
			measure.setId(map.get("KPI_CODE").toString());
			measure.setName(map.get("KPI_NAME").toString());
			measure.setAlias(map.get("KPI_NAME").toString());
			measure.setTableLink("");
			measure.setColumnLink("");
			measure.setAggregator(map.get("AGGREGATOR").toString());

			ForeignKeyLink foreignKeyLink = new ForeignKeyLink();
			foreignKeyLink.setDimension("");
			foreignKeyLink.setForeignKeyColumn("");

			measure.setForeignKeyLink(foreignKeyLink);

			mList.add(measure);

		}

		measures.setMeasureList(mList);
		kpi.setMeasures(measures);

		// 生成XML计算公式<formulas>内容
		Formulas formulas = new Formulas();
		Formula formula = new Formula();
		// formula.setName(kpiName);
		formula.setType(isFormula);
		if (StringUtils.isEmpty(kpiCode)) {
			formula.setSource(complexkpiCode);
		} else if (StringUtils.isEmpty(complexkpiCode)) {
			formula.setSource(kpiCode);
		} else {
			formula.setSource(kpiCode + "," + complexkpiCode);
		}

		formula.setFormula(formual);

		// Relation relation = new Relation();
		// relation.setRelation(kpiUnit1);
		// formula.setRelation(relation);

		List<Measure> fList = new ArrayList<Measure>();
		// this.getFormulaKpi(mList, kpiCode+complexkpiCode, fList);
		// formula.setMeasure(fList);

		formulas.setFormula(formula);
		kpi.setFormulas(formulas);

		// 生成XML约束条件<conditions>内容
		Conditions cons = new Conditions();
		List<Condition> clist = new ArrayList<Condition>();
		for (Map<String, String> map : conditions) {
			Condition condition = new Condition();
			condition.setSource(map.get("dimCode"));
			condition.setType(map.get("isKpi"));
			condition.setPrepend(map.get("ljkjf"));

			// Compose compose = new Compose();
			// Relation rel = new Relation();
			condition.setParamsType(map.get("constant"));
			condition.setOperator(map.get("ljfName"));

			if ("1".equals(map.get("constant"))) {
				condition.setParamsValue(map.get("tjzName"));
				condition.setParamId(map.get("tjzCode"));
				condition.setCondition(this.relation(map.get("dimCode"),
						map.get("ljfName"), map.get("constant"),
						map.get("tjzName")));
				// rel.setRelation(this.relation(map.get("dimCode"),
				// map.get("ljfName"), map.get("constant"),
				// map.get("tjzName")));
			} else {
				condition.setCondition(this.relation(map.get("dimCode"),
						map.get("ljfName"), map.get("constant"),
						map.get("tjzCode")));
				condition.setParamsValue(map.get("tjzName").substring(0,
						map.get("tjzName").length() - 1));//
				condition.setParamId(map.get("tjzCode"));
			}
			condition.setDataType("string");

			// condition.setCompose(compose);
			// condition.setRelation(rel);
			clist.add(condition);
		}

		SelfWhere sw = new SelfWhere();
		sw.setSeflCondition(cond);
		cons.setConditionList(clist);
		kpi.setConditions(cons);
		kpi.setSelfWhere(sw);

		String kpiBody = "";
		GenerateKpi gk = new GenerateKpi();
		gk.writeKpiTemplate(uuid, kpi);
		kpiBody = new String(gk.toByteArrayFromInputStream(new FileInputStream(
				gk.getFilePath() + gk.getSuffix())), "UTF-8");
		Map user = (Map) request.getSession().getAttribute("UserInfo");
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd kk:mm:ss.SSS");// 设定格式
		dateFormat.setLenient(false);
		java.sql.Timestamp dateTime = new java.sql.Timestamp(
				new Date().getTime());
		Object[] o = new Object[16];
		o[0] = kpiName;
		o[1] = kpiCategory;
		o[2] = kpiUnit0;
		o[3] = "1";
		o[4] = kpiCalIber;
		o[5] = kpiExplain;
		o[6] = "U";
		o[7] = "0";
		o[8] = kpiBody;
		o[9] = user.get("USER_ID").toString();
		o[10] = dateTime;
		o[11] = kpiUser;
		o[12] = kpiDept;
		o[13] = kpiFile;
		o[14] = Integer.parseInt(Kpiversion) + 1;
		o[15] = oid;

		Object[] del = new Object[1];
		del[0] = oid;
		runner.execute(delSource, del);

		Object[] obj = new Object[9];
		int size = 0;
		for (Dimension d : dList) {
			obj[0] = oid;
			obj[1] = comKpiCode;
			obj[2] = Integer.parseInt(Kpiversion) + 1;
			obj[3] = d.getId();
			obj[4] = d.getName();
			obj[5] = d.getTableLink();
			obj[6] = d.getColumnLink();
			obj[7] = d.getDictionary().getDictionary();
			obj[8] = "0";
			// obj[0] = d.getId();
			// obj[1] = d.getName();
			// obj[2] = d.getTableLink();
			// obj[3] = d.getColumnLink();
			// obj[4] = d.getDictionary().getDictionary();
			// obj[5] = "0";
			// obj[6] = Integer.parseInt(Kpiversion)+1;
			// obj[7] = oid;
			runner.execute(updateSouStr, obj);
			size++;
		}

		for (Measure mea : mList) {
			obj[0] = oid;
			obj[1] = comKpiCode;
			obj[2] = Integer.parseInt(Kpiversion) + 1;
			obj[3] = mea.getId();
			obj[4] = mea.getName();
			obj[5] = mea.getTableLink();
			obj[6] = mea.getColumnLink();
			obj[7] = "";
			obj[8] = "1";
			// obj[0] = mea.getId();
			// obj[1] = mea.getName();
			// obj[2] = mea.getTableLink();
			// obj[3] = mea.getColumnLink();
			// obj[4] = "";
			// obj[5] = "1";
			// obj[6] = Integer.parseInt(Kpiversion)+1;
			// obj[7] = oid;
			runner.execute(updateSouStr, obj);
			size++;
		}
		runner.update(updateStr, o);

		Map kpiMap = runner
				.queryForMap("SELECT T.KPI_CODE,T.KPI_CATEGORY,T.KPI_NAME,T.KPI_NUIT,T.KPI_BODY,T.KPI_CALIBER KPICALIBER,T.KPI_EXPLAIN KPIEXPLAIN,T.KPI_VERSION KPIVERSION FROM X_KPI_INFO_TMP T WHERE T.KPI_KEY='"
						+ oid + "'");
		// 增加日志
		LogInfo info = new LogInfo();
		Map m = runner
				.queryForMap("Select Nextval('X_KPI_LOG_SEQ') LOGSEQ");
		info.setLogKey(Integer.parseInt(m.get("LOGSEQ").toString()));
		info.setKpiKey(Integer.parseInt(oid));
		info.setKpiCode(kpiMap.get("KPI_CODE").toString());
		info.setKpiVersion(Integer.parseInt(Kpiversion));
		info.setLogAction("U");
		info.setLogDetatlBef(kpiMap.get("KPI_BODY").toString());
		info.setLogDetatlAft(kpiBody);
		Timestamp time = new Timestamp(new Date().getTime());
		info.setLogDateTime(time);
		info.setLogUser(user.get("USER_NAME").toString());
		info.setLogUserId(user.get("USER_ID").toString());
		info.setLogIp(request.getLocalAddr());
		Log.SaveLog(runner, info);

	}

	@Action("formulakpiAdd")
	public void kpiAdd(HttpServletRequest request, HttpServletResponse reponse)
			throws SQLException {
		EasyDataSource dataSource = null;
		// 获取前台传值
		String dIndex = request.getParameter("dIndex");
		String kpiName = request.getParameter("kpiName");
		String kpiUnit0 = request.getParameter("kpiUnit0");
		String kpiUnit1 = request.getParameter("kpiUnit1");
		String formual = request.getParameter("formual");
		String isFormula = request.getParameter("isFormula");
		String kpiCode = request.getParameter("kpiCode");
		String kpiVersion = request.getParameter("kpiVersion");
		String code = request.getParameter("code");
		String kpiUser = request.getParameter("kpiUser");
		String kpiDept = request.getParameter("kpiDept");
		String kpiFile = request.getParameter("kpiFile");
		String cond = request.getParameter("cond");// 手动输入条件
		if (StringUtils.isEmpty(kpiVersion)) {
			kpiVersion = "0";
		}
		// if (StringUtils.isNotEmpty(kpiCode)) {
		// kpiCode = kpiCode.substring(1, kpiCode.length());
		// }
		String parentId = request.getParameter("kpiCategory");
		if (StringUtils.isEmpty(parentId)) {
			parentId = "1";
		}
		String complexkpiCode = request.getParameter("complexkpiCode");
		// if (StringUtils.isNotEmpty(complexkpiCode)) {
		// complexkpiCode = complexkpiCode.substring(1,
		// complexkpiCode.length());
		// }
		if (null == cond) {
			cond = "";
		}
		String kpiCalIber = request.getParameter("kpiCalIber");
		String kpiExplain = request.getParameter("kpiExplain");
		String[] condIndex = null;
		if(null!=dIndex&&!"".equals(dIndex)){
			condIndex = dIndex.split(",");
		}else{
			condIndex = new String[0];
		}
		List<Map<String, String>> conditions = new ArrayList<Map<String, String>>();
		for (int i = 0; i < condIndex.length; i++) {
			Map m = new HashMap<String, String>();
			m.put("dimName", request.getParameter("arr[" + i + "][dimName]"));
			m.put("dimCode", request.getParameter("arr[" + i + "][dimCode]"));
			m.put("ljfName", request.getParameter("arr[" + i + "][ljfName]"));
			m.put("tjzName", request.getParameter("arr[" + i + "][tjzUnit]"));
			m.put("tjzCode", request.getParameter("arr[" + i + "][did]"));
			m.put("ljkjf", request.getParameter("arr[" + i + "][ljkjf]"));
			m.put("isKpi", request.getParameter("arr[" + i + "][isKpi]"));
			m.put("constant", request.getParameter("arr[" + i + "][constant]"));
			conditions.add(m);
		}
		List<String> kpiCodes = new ArrayList<String>();
		List<String> dimCodes = new ArrayList<String>();
		List<String> complexkpiCodes = new ArrayList<String>();
		for (Map<String, String> map : conditions) {
			if ("1".equals(map.get("isKpi"))) {
				if (StringUtils.isNotEmpty(map.get("dimCode"))) {
					kpiCodes.add(map.get("dimCode"));
				}
			} else {
				if (StringUtils.isNotEmpty(map.get("dimCode"))) {
					dimCodes.add(map.get("dimCode"));
				}
			}
		}
		String[] kpiTmp = null;
		if (StringUtils.isNotEmpty(kpiCode)) {
			kpiTmp = kpiCode.trim().split(",");
		}
		String[] complexTmp = null;
		if (StringUtils.isNotEmpty(complexkpiCode)) {
			complexTmp = complexkpiCode.split(",");
		}
		if (null != kpiTmp && kpiTmp.length != 0) {
			for (int i = 0; i < kpiTmp.length; i++) {
				kpiCodes.add(kpiTmp[i]);
			}
		}
		if (null != complexTmp && complexTmp.length != 0) {
			for (int i = 0; i < complexTmp.length; i++) {
				complexkpiCodes.add(complexTmp[i]);
			}
		}
		// 查询标准指标
		List<Map<String, Object>> kpiList = new ArrayList<Map<String, Object>>();
		if (!kpiCodes.isEmpty()) {

			dataSource = EasyContext.getContext().getDataSource(
					"java:/comp/env/jndi/initdb");
			Connection conn = dataSource.getConnection();
			kpiList = this.getKpiOrDim(conn, kpiCodes, kpiSql);
			this.colseConn(conn);
		}
		// 查询复合指标
		List<Map<String, Object>> complexkpiList = new ArrayList<Map<String, Object>>();
		if (!complexkpiCodes.isEmpty()) {
			dataSource = EasyContext.getContext().getDataSource();
			Connection conn = dataSource.getConnection();
			complexkpiList = this.getComplexkpi(conn, complexkpiCodes,
					complexkpi);
			this.colseConn(conn);
		}
		// 查询维度
		List<Map<String, Object>> dimList = new ArrayList<Map<String, Object>>();
		if (!dimCodes.isEmpty()) {
			dataSource = EasyContext.getContext().getDataSource(
					"java:/comp/env/jndi/initdb");
			Connection conn = dataSource.getConnection();
			dimList = this.getKpiOrDim(conn, dimCodes, dimSql);
			this.colseConn(conn);
		}

		/**
		 * 生成XML
		 */
		String uuid = UUID.randomUUID().toString();
		uuid = uuid.replace("-", "").toUpperCase();
		if (StringUtils.isNotEmpty(code)) {
			uuid = code;
		}
		String versionSql = "select nvl(max(kpi_version),0) VER from X_KPI_INFO_TMP t where t.kpi_code='"
				+ uuid + "'";
		Map v = runner.queryForMap(versionSql);
		int version = Integer.parseInt(v.get("VER").toString());
		// uuid = "MF_" + uuid;
		Kpi kpi = new Kpi();
		kpi.setId(uuid);
		kpi.setVersion(version + 1 + "");
		// XML中基础维度<dimensions>内容
		Dimensions dimensions = new Dimensions();

		List<Dimension> dList = new ArrayList<Dimension>();
		for (Map<String, Object> map : dimList) {
			Dimension dimension = new Dimension();
			dimension.setId(map.get("OID").toString());
			dimension.setName(map.get("NAME").toString());
			dimension.setAlias(map.get("FIELD_ALIAS").toString());
			dimension.setTableLink(map.get("LINKTABLE").toString());
			dimension.setColumnLink(map.get("FIELD_CODE").toString());
			dimension.setFormatType(map.get("TYPE").toString());
			// dimension.setDictionary(dictionary);
			Dictionary dictionary = new Dictionary();
			Map<String, String> m = this.getDictionary(dataSource,
					map.get("TABLECODE").toString(), map.get("TABLENAME")
							.toString());
			dictionary.setKey(m.get("KEY"));
			dictionary.setName(m.get("VALUE"));
			dictionary.setTableLink(m.get("TABLENAME"));
			dictionary.setDictionary(m.get("sql"));
			dimension.setDictionary(dictionary);

			dList.add(dimension);
		}
		dimensions.setDimensionList(dList);
		kpi.setDimensions(dimensions);

		// 生成XML基础指标<measures>内容
		Measures measures = new Measures();
		List<Measure> mList = new ArrayList<Measure>();
		for (Map<String, Object> map : kpiList) {
			Measure measure = new Measure();
			measure.setId(map.get("OID").toString());
			measure.setName(map.get("NAME").toString());
			measure.setAlias(map.get("NAME").toString());
			measure.setTableLink(map.get("TABLELINK").toString());
			measure.setColumnLink(map.get("COLUMNLINK").toString());
			measure.setAggregator(map.get("AGGREGATOR").toString());

			ForeignKeyLink foreignKeyLink = new ForeignKeyLink();
			foreignKeyLink.setDimension("");
			foreignKeyLink.setForeignKeyColumn("");
			measure.setForeignKeyLink(foreignKeyLink);

			mList.add(measure);
		}
		for (Map<String, Object> map : complexkpiList) {

			Measure measure = new Measure();
			measure.setId(map.get("KPI_CODE").toString());
			measure.setName(map.get("KPI_NAME").toString());
			measure.setAlias(map.get("KPI_NAME").toString());
			measure.setTableLink("");
			measure.setColumnLink("");
			measure.setAggregator(map.get("AGGREGATOR").toString());

			ForeignKeyLink foreignKeyLink = new ForeignKeyLink();
			foreignKeyLink.setDimension("");
			foreignKeyLink.setForeignKeyColumn("");

			measure.setForeignKeyLink(foreignKeyLink);

			mList.add(measure);

		}

		measures.setMeasureList(mList);
		kpi.setMeasures(measures);

		// 生成XML计算公式<formulas>内容
		Formulas formulas = new Formulas();
		Formula formula = new Formula();
		// formula.setName(kpiName);
		formula.setType(isFormula);
		if (StringUtils.isEmpty(kpiCode)) {
			formula.setSource(complexkpiCode);
		} else if (StringUtils.isEmpty(complexkpiCode)) {
			formula.setSource(kpiCode);
		} else {
			formula.setSource(kpiCode + "," + complexkpiCode);
		}

		formula.setFormula(formual);

		// Relation relation = new Relation();
		// relation.setRelation(kpiUnit1);
		// formula.setRelation(relation);

		List<Measure> fList = new ArrayList<Measure>();
		// this.getFormulaKpi(mList, kpiCode+complexkpiCode, fList);
		// formula.setMeasure(fList);

		formulas.setFormula(formula);
		kpi.setFormulas(formulas);

		// 生成XML约束条件<conditions>内容
		Conditions cons = new Conditions();
		List<Condition> clist = new ArrayList<Condition>();
		for (Map<String, String> map : conditions) {
			Condition condition = new Condition();
			condition.setSource(map.get("dimCode"));
			condition.setType(map.get("isKpi"));
			condition.setPrepend(map.get("ljkjf"));

			// Compose compose = new Compose();
			// Relation rel = new Relation();
			condition.setParamsType(map.get("constant"));
			condition.setOperator(map.get("ljfName"));
			if ("1".equals(map.get("constant"))) {
				condition.setParamsValue(map.get("tjzName"));
				condition.setParamId("");
				condition.setCondition(this.relation(map.get("dimCode"),
						map.get("ljfName"), map.get("constant"),
						map.get("tjzName")));
				// rel.setRelation(this.relation(map.get("dimCode"),
				// map.get("ljfName"), map.get("constant"),
				// map.get("tjzName")));
			} else {
				condition.setCondition(this.relation(map.get("dimCode"),
						map.get("ljfName"), map.get("constant"),
						map.get("tjzCode")));
				condition.setParamsValue(map.get("tjzName").substring(0,
						map.get("tjzName").length() - 1));
				condition.setParamId(map.get("tjzCode"));
			}
			condition.setDataType("string");

			// condition.setCompose(compose);
			// condition.setRelation(rel);
			clist.add(condition);
		}
		cons.setConditionList(clist);
		SelfWhere sw = new SelfWhere();
		sw.setSeflCondition(cond);

		kpi.setConditions(cons);
		kpi.setSelfWhere(sw);

		// 生成XML，保存数据库
		Map map = runner
				.queryForMap("Select Nextval('X_KPI_INFO_SEQ') SEQ");
		String kpiBody = "";
		GenerateKpi gk = new GenerateKpi();
		try {
			gk.writeKpiTemplate(uuid, kpi);
			kpiBody = new String(
					gk.toByteArrayFromInputStream(new FileInputStream(gk
							.getFilePath() + gk.getSuffix())), "UTF-8");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		List<KpiInfo> infoList = new LinkedList();
		List<KpiSource> sourceList = new LinkedList();
		KpiInfo ki = new KpiInfo();
		ki.setKpi_key(Integer.parseInt(map.get("SEQ").toString()));
		ki.setKpi_code(uuid);
		ki.setKpi_name(kpiName);
		ki.setKpi_category(Integer.parseInt(parentId));
		ki.setKpi_nuit(kpiUnit0);
		ki.setKpi_version(version + 1);
		ki.setKpi_iscurr("1");
		ki.setKpi_caliber(kpiCalIber);
		ki.setKpi_explain(kpiExplain);
		ki.setKpi_flag("I");
		ki.setKpi_status("0");
		ki.setKpi_body(kpiBody);
		ki.setKpi_user(kpiUser);
		ki.setKpi_dept(kpiDept);
		ki.setKpi_file(kpiFile);
		Map user = (Map) request.getSession().getAttribute("UserInfo");
		ki.setCreate_user(user.get("USER_ID").toString());
		ki.setCreate_datetime(new Date());

		infoList.add(ki);

		for (Dimension d : dList) {
			// Map m = runner
			// .queryForMap("Select X_KPI_SOURCE_SEQ.NEXTVAL SEQ from dual");
			KpiSource source = new KpiSource();
			source.setSource_key(Integer.parseInt(map.get("seq").toString()));
			source.setKpi_code(uuid);
			source.setKpi_version(version + 1);
			source.setSource_code(d.getId());
			source.setSource_name(d.getName());
			source.setSource_table(d.getTableLink());
			source.setSource_column(d.getColumnLink());
			source.setSource_condition(d.getDictionary().getDictionary());
			source.setSource_type("0");

			sourceList.add(source);
		}

		for (Measure mea : mList) {
			// Map m = runner
			// .queryForMap("Select X_KPI_SOURCE_SEQ.NEXTVAL SEQ from dual");
			KpiSource source = new KpiSource();
			source.setSource_key(Integer.parseInt(map.get("seq").toString()));
			source.setKpi_code(uuid);
			source.setKpi_version(version + 1);
			source.setSource_code(mea.getId());
			source.setSource_name(mea.getName());
			source.setSource_table(mea.getTableLink());
			source.setSource_column(mea.getColumnLink());
			source.setSource_condition("");
			source.setSource_type("1");

			sourceList.add(source);
		}
		KpiDbService kds = new KpiDbService();
		kds.kpiAdd2Db(infoList, sourceList, runner);

		// 增加日志
		LogInfo info = new LogInfo();
		Map m = runner
				.queryForMap("Select Nextval('X_KPI_LOG_SEQ') LOGSEQ");
		info.setLogKey(Integer.parseInt(m.get("LOGSEQ").toString()));
		info.setKpiKey(ki.getKpi_key());
		info.setKpiCode(uuid);
		info.setKpiVersion(ki.getKpi_version());
		info.setLogAction("I");
		info.setLogDetatlBef("");
		info.setLogDetatlAft(ki.getKpi_body());
		Timestamp time = new Timestamp(new Date().getTime());
		info.setLogDateTime(time);
		info.setLogUser(user.get("USER_NAME").toString());
		info.setLogUserId(user.get("USER_ID").toString());
		info.setLogIp(request.getLocalAddr());
		Log.SaveLog(runner, info);
	}

	// 查询指标和维度
	public List<Map<String, Object>> getDim(Connection conn,
			List<String> kpiCode, String sql, String dimId) throws SQLException {
		QueryRunner queryRunner = new QueryRunner();
		String where = " and T.OID in (";
		for (String string : kpiCode) {
			where += "'" + string + "',";
		}
		where = where.substring(0, where.length() - 1);
		where += ")";
		return queryRunner.query(conn, sql + where, null, new MapListHandler());
	}

	public List<Map<String, Object>> getKpiOrDim(Connection conn,
			List<String> kpiCode, String sql) throws SQLException {
		QueryRunner queryRunner = new QueryRunner();
		String where = " and T.OID in (";
		for (String string : kpiCode) {
			where += "'" + string + "',";
		}
		where = where.substring(0, where.length() - 1);
		where += ")";
		return queryRunner.query(conn, sql + where, null, new MapListHandler());
	}

	// 查询复合指标
	public List<Map<String, Object>> getComplexkpi(Connection conn,
			List<String> kpiCode, String sql) throws SQLException {
		QueryRunner queryRunner = new QueryRunner();
		String where = " and T.KPI_KEY IN (";
		for (String string : kpiCode) {
			where += "'" + string + "',";
		}
		where = where.substring(0, where.length() - 1);
		where += ")";
		return queryRunner.query(conn, sql + where, null, new MapListHandler());
	}

	public Map<String, String> getDictionary(EasyDataSource dataSource,
			String tableId, String tableName) throws SQLException {
		Connection conn = null;
		QueryRunner queryRunner = new QueryRunner();
		try {
			conn = dataSource.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		Map<String, String> m = new HashMap<String, String>();
		String sql = "select T.FIELD_CODE,T.TABLENAME,T.FIELD_ALIAS from X_FILELD_VIEW t where t.TABLEID='"
				+ tableId + "'";
		List<Map<String, Object>> list = queryRunner.query(conn, sql, null,
				new MapListHandler());
		// this.colseConn(conn);
		for (Map<String, Object> map : list) {
			if ("CODE".equals(map.get("FIELD_ALIAS").toString())) {
				m.put("KEY", map.get("FIELD_CODE").toString());
			}
			if ("CODE_NAME".equals(map.get("FIELD_ALIAS").toString())) {
				m.put("VALUE", map.get("FIELD_CODE").toString());
			}
			m.put("TABLENAME", map.get("TABLENAME").toString());
		}
		String dicSql = "";
		if (StringUtils.isNotEmpty(m.get("KEY"))) {
			if (StringUtils.isNotEmpty(m.get("VALUE"))) {
				dicSql = "select " + m.get("KEY") + "," + m.get("VALUE")
						+ " from " + tableName;
			}
		}
		m.put("sql", dicSql);

		return m;
	}

	// 从指标从获取公式使用指标
	public void getFormulaKpi(List<Measure> list, String kpiCode,
			List<Measure> fKpiList) {
		String[] code = null;
		if (StringUtils.isNotEmpty(kpiCode)) {
			code = kpiCode.split(",");
			for (String string : code) {
				for (Measure m : list) {
					if (string.equals(m.getId())) {
						fKpiList.add(m);
					}
				}
			}
		}
	}

	public String unit(List<Map<String, String>> l, String u, boolean flag) {
		StringBuffer sb = new StringBuffer();
		if (flag) {
			sb.append("<select id=kpi_unit0 name=kpi_unit0 style=width:100%; disabled=disabled>");
		} else {
			sb.append("<select id=kpi_unit0 name=kpi_unit0 style=width:100%;>");
		}
		for (Map<String, String> map : l) {
			if (u.equals(map.get("CODE"))) {
				sb.append("<option value=" + map.get("CODE")
						+ " selected=selected>");
				sb.append(map.get("NAME"));
				sb.append("</option>");
			} else {
				sb.append("<option value=" + map.get("CODE") + ">");
				sb.append(map.get("NAME"));
				sb.append("</option>");
			}
		}
		sb.append("</select>");
		return sb.toString();
	}

	// 接收数值，返回转义后的比较用算符
	public String escape(String num) {
		String esc = "";
		if (StringUtils.isNotEmpty(num)) {
			int n = Integer.parseInt(num);
			switch (n) {
			case 0:
				esc = "=";
				break;
			case 1:
				esc = "in";
				break;
			case 2:
				esc = "&gt;";
				break;
			case 3:
				esc = "&lt;";
				break;
			case 4:
				esc = "&lt;&gt;";
				break;
			case 5:
				esc = "&lt;=";
				break;
			case 6:
				esc = "&gt;=";
				break;
			default:
				esc = "=";
				break;
			}

		}
		return esc;
	}

	public String option(String num) {
		String esc = "";
		if (StringUtils.isNotEmpty(num)) {
			int n = Integer.parseInt(num);
			switch (n) {
			case 0:
				esc = "=";
				break;
			case 1:
				esc = "in";
				break;
			case 2:
				esc = ">";
				break;
			case 3:
				esc = "<";
				break;
			case 4:
				esc = "<>";
				break;
			case 5:
				esc = ">=";
				break;
			case 6:
				esc = "<=";
				break;
			default:
				esc = "=";
				break;
			}

		}
		return esc;
	}

	public String relation(String dimCode, String ljf_name, String constant,
			String tjzName) {
		String relation = "{";
		String tjz = "";
		if (StringUtils.isNotEmpty(tjzName)) {
			tjz = tjzName.substring(0, tjzName.length() - 1);
		} else {
			return relation = relation + dimCode + "} IS NULL";
		}
		if ("8".equals(ljf_name)) {
			relation = relation + dimCode + "} IS NOT NULL";
		} else if ("7".equals(ljf_name)) {
			relation = relation + dimCode + "} IS NULL";
		} else {
			String opr = this.option(ljf_name);

			if ("0".equals(constant)) {
				relation = relation + dimCode + "}" + opr + "'" + tjz + "'";
			} else {
				if (StringUtils.isNotEmpty(tjz)) {
					String[] tjzs = tjz.split(",");
					if (tjzs.length > 1) {
						relation = relation + dimCode + "} in (";
						for (String str : tjzs) {
							relation = relation + "'" + str + "',";
						}
						relation = relation.substring(0, relation.length() - 1);
						relation = relation + ")";
					} else {
						relation = relation + dimCode + "} " + opr + tjz;
					}
				}
			}
		}

		return relation;

	}

	// 关闭connection
	public void colseConn(Connection conn) {
		if (null != conn) {
			try {
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public String getLjf(String operator, String index, boolean flag) {
		String[] text = { "等于", "包含", "大于", "小于", "不等于", "大于等于", "小于等于", "为空",
				"不为空" };
		StringBuffer sb = new StringBuffer();
		if (flag) {
			sb.append("<select id=ljf_name"
					+ index
					+ " name=kpi_name"
					+ index
					+ " style=width:100%; onchange=onMultiple() disabled=disabled>");
		} else {
			sb.append("<select id=ljf_name" + index + " name=kpi_name" + index
					+ " style=width:100%; onchange=onMultiple()>");
		}
		for (int i = 0; i <= 8; i++) {
			if ((i + "").equals(operator)) {
				sb.append("<option value=" + i + " selected=selected>"
						+ text[i] + "</option>");
			} else {
				sb.append("<option value=" + i + ">" + text[i] + "</option>");
			}
		}

		sb.append("</select>");
		return sb.toString();
	}

	public String getLjkjf(String prepend, String index, boolean flag) {
		String[] texts = { "并且", "或者" };
		String[] values = { "and", "or" };
		StringBuffer sb = new StringBuffer();
		if (flag) {
			sb.append("<select id=ljkjf" + index + " name=ljkjf" + index
					+ " style=width:100%; disabled=disabled>");
		} else {
			sb.append("<select id=ljkjf" + index + " name=ljkjf" + index
					+ " style=width:100%;>");
		}
		for (int i = 0; i < values.length; i++) {
			if (values[i].equals(prepend)) {
				sb.append("<option value=" + values[i] + " selected=selected>"
						+ texts[i] + "</option>");
			} else {
				sb.append("<option value=" + values[i] + ">" + texts[i]
						+ "</option>");
			}
		}
		sb.append("</select>");
		return sb.toString();
	}
}