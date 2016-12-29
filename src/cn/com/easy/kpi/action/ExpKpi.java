package cn.com.easy.kpi.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.kpi.parser.GenerateKpi;
import cn.com.easy.kpi.parser.GenerateKpiRule;

@Controller
public class ExpKpi {

	private SqlRunner runner;

	private SXSSFWorkbook wb;
	private SXSSFSheet sheet;
	private SXSSFRow row = null;
	private SXSSFCell cell = null;
	private final String CLASSPATH = GenerateKpi.class.getResource("/")
			.getPath();
	private final String PATH = CLASSPATH.substring(0,
			CLASSPATH.indexOf("WEB-INF/classes"));
	private String kpiPath = PATH + "pages/kpi/formulaKpi/tmp";

	@Action("expExcel")
	public void ExpKpi(HttpServletRequest request, HttpServletResponse response) {
		String kpi_code = request.getParameter("kpi_code");
		String cube_code = request.getParameter("cube_code");
		String category = request.getParameter("kpi_category");
		String kpi_status = request.getParameter("kpi_status");
		String kpi_name = request.getParameter("kpi_name");

		Map<String, String> params = new HashMap<String, String>();
		params.put("kpi_code", kpi_code);
		params.put("cube_code", cube_code);
		params.put("category", category);
		params.put("kpi_status", kpi_status);
		params.put("kpi_name", kpi_name);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String fileName = sdf.format(new Date()) + ".xlsx";
		File file = new File(kpiPath + "/" + fileName);
		try {
			OutputStream out = new FileOutputStream(file);
			List<Map<String, String>> li = this.getKpiInfo(params);
			this.createExcel(li, out);
			this.downFile(response, file);
		} catch (SQLException e) {
			e.printStackTrace();
			new Exception(e.getMessage());
		} catch (FileNotFoundException e) {
			// e.printStackTrace();
			new Exception(e.getMessage());
		} catch (Exception e) {
			// e.printStackTrace();
			new Exception(e.getMessage());
		}

	}

	private void downFile(HttpServletResponse response, File file)
			throws IOException {
		String fileName = file.getName();
		fileName = new String(fileName.getBytes(), "iso-8859-1");
		response.reset();
		response.setContentType("APPLICATION/OCTET-STREAM");
		response.setHeader("Content-Disposition", "attachment;filename=\""
				+ fileName + "\"");
		ServletOutputStream outPut = response.getOutputStream();
		InputStream inStream = new FileInputStream(file);
		byte[] b = new byte[1024];
		int len;
		while ((len = inStream.read(b)) > 0) {
			outPut.write(b, 0, len);
		}
		response.setStatus(response.SC_OK);
		response.flushBuffer();
		outPut.close();
		inStream.close();
	}

	private void createExcel(List<Map<String, String>> li, OutputStream out)
			throws Exception {
		wb = new SXSSFWorkbook(1000);
		sheet = (SXSSFSheet) wb.createSheet();
		row = (SXSSFRow) sheet.createRow(0);
		this.createTabHade(row);

		for (int i = 0; i < li.size(); i++) {
			row = (SXSSFRow) sheet.createRow(i + 1);
			Map<String, String> kpi = li.get(i);
			for (int j = 0; j < kpi.size(); j++) {
				cell = (SXSSFCell) row.createCell(j);
				if(j == 14) {
					GenerateKpiRule rule = new GenerateKpiRule(String.valueOf(kpi.get("V19")));
					String formula = rule.parseFormulasDesc();
					cell.setCellValue(formula);
				} else if (j == 15) {
					GenerateKpiRule rule = new GenerateKpiRule(String.valueOf(kpi.get("V19")));
					cell.setCellValue(rule.parseExpressionDesc());
				} else {
					cell.setCellValue(kpi.get("V" + j));
				}
			}
		}
		wb.write(out);
		out.flush();
		out.close();
	}

	private void createTabHade(SXSSFRow row) {
		cell = (SXSSFCell) row.createCell(0);
		cell.setCellValue("指标编码");
		cell = (SXSSFCell) row.createCell(1);
		cell.setCellValue("指标名称");
		cell = (SXSSFCell) row.createCell(2);
		cell.setCellValue("编码名称");
		cell = (SXSSFCell) row.createCell(3);
		cell.setCellValue("指标版本");
		cell = (SXSSFCell) row.createCell(4);
		cell.setCellValue("指标类型");
		cell = (SXSSFCell) row.createCell(5);
		cell.setCellValue("指标状态");
		cell = (SXSSFCell) row.createCell(6);
		cell.setCellValue("创建人");
		cell = (SXSSFCell) row.createCell(7);
		cell.setCellValue("创建时间");
		cell = (SXSSFCell) row.createCell(8);
		cell.setCellValue("修改人");
		cell = (SXSSFCell) row.createCell(9);
		cell.setCellValue("修改时间");
		cell = (SXSSFCell) row.createCell(10);
		cell.setCellValue("删除人");
		cell = (SXSSFCell) row.createCell(11);
		cell.setCellValue("删除时间");
		cell = (SXSSFCell) row.createCell(12);
		cell.setCellValue("提出者");
		cell = (SXSSFCell) row.createCell(13);
		cell.setCellValue("提出部门");
		cell = (SXSSFCell) row.createCell(14);
		cell.setCellValue("指标公式");
		cell = (SXSSFCell) row.createCell(15);
		cell.setCellValue("约束条件");
		cell = (SXSSFCell) row.createCell(16);
		cell.setCellValue("扩展属性");
		cell = (SXSSFCell) row.createCell(17);
		cell.setCellValue("技术口径");
		cell = (SXSSFCell) row.createCell(18);
		cell.setCellValue("业务口径");
	}

	private List<Map<String, String>> getKpiInfo(Map<String, String> params)
			throws SQLException {
		String querySql = this.getSql(params);
		List<Map<String, String>> kpis = (List<Map<String, String>>) runner
				.queryForMapList(querySql);		
		return kpis;

	}

	private String getSql(Map<String, String> params) {
		StringBuffer querySql = new StringBuffer(
				"SELECT distinct Z1.V0,Z1.V1,Z1.V2,Z1.V3,Z1.V4,Z1.V5,Z1.V6,Z1.V7,Z1.V8,Z1.V9,Z1.V10,Z1.V11,Z1.V12,Z1.V13,Z1.V16,Z1.V17,Z1.V18,to_char(T4.RULE_COLUMN) V15,to_char(T4.FORMULA_COLUMN) V14,V19 FROM ("
					+ " SELECT T1.KPI_KEY V19, T1.KPI_CODE,T1.SERVICE_KEY V0,T1.KPI_NAME V1,EDIM.F_KPI_CODE(T1.SERVICE_KEY) V2,TO_CHAR(T1.KPI_VERSION) V3,"
					+ " (DECODE(T1.KPI_TYPE, '1', '基础指标', '2', '复合指标', '衍生指标') || '(' ||DECODE(T1.ACCTTYPE, '1', '日', '月') || ')') AS V4,"
					                  + " CASE T1.KPI_STATUS WHEN '0' THEN '指标定义审核' WHEN '1' THEN '指标技术审核' WHEN '2' THEN '在线指标' WHEN '3' THEN '审核不通过' WHEN '8' THEN '下线指标' WHEN '9' THEN '指标数据审核' END V5,"
					                  + " (SELECT USER_NAME FROM E_USER WHERE USER_ID = T1.CREATE_USER) V6,"
					                  + " TO_CHAR(T1.CREATE_DATETIME, 'YYYY-MM-DD') V7,"
					                  + " (SELECT USER_NAME FROM E_USER WHERE USER_ID = T1.UPDATE_USER) V8,"
					                  + " TO_CHAR(T1.UPDATE_DATETIME, 'YYYY-MM-DD') V9,"
					                  + " CASE T1.KPI_FLAG"
					                  + " WHEN 'D' THEN (SELECT Z.LOG_USER FROM X_KPI_LOG Z WHERE T1.KPI_CODE = Z.KPI_CODE AND T1.KPI_VERSION = Z.KPI_VERSION AND Z.LOG_ACTION='D')"
					                  + " ELSE ''END V10,"
					                  + " CASE T1.KPI_FLAG"
					                  + " WHEN 'D' THEN (SELECT TO_CHAR(Z.LOG_DATETIME, 'YYYY-MM-DD') FROM X_KPI_LOG Z WHERE T1.KPI_CODE = Z.KPI_CODE AND T1.KPI_VERSION = Z.KPI_VERSION AND Z.LOG_ACTION='D')"
					                  + " ELSE ''END V11,"
					                  + " T1.KPI_USER V12,T1.KPI_DEPT V13,"
					                  + " (SELECT TO_CHAR(WM_CONCAT(T5.ATTR_NAME)) FROM X_KPI_ATTRIBUTE T5, X_KPI_ATTR_RELATION T6"
					                  + " WHERE T5.ATTR_TYPE = T6.ACCTTYPE AND T5.ATTR_CODE = T6.ATTR_CODE AND T6.KPI_CODE(+) = T1.KPI_CODE AND T6.KPI_VERSION(+) = T1.KPI_VERSION ) V16,T1.KPI_CALIBER V17, T1.KPI_EXPLAIN V18"
					                  + " FROM X_KPI_INFO_TMP T1, X_KPI_CATEGORY T2, X_KPI_TYPE T3"
					                  + " WHERE T1.KPI_CATEGORY = T2.CATEGORY_ID AND T1.KPI_TYPE = T3.TYPE_CODE"
					                  + " AND ((T1.KPI_ISCURR = '0' AND"
					                       + " T1.KPI_STATUS IN ('0', '1', '3')) OR"
					                       + " (T1.KPI_ISCURR = '1' AND T1.KPI_STATUS = '2'))");
		if (params.isEmpty()) {
			return querySql.toString();
		}

		if (null != params.get("kpi_code")
				&& !"".equals(params.get("kpi_code"))) {
			querySql.append(" AND T1.SERVICE_KEY = '" + params.get("kpi_code")
					+ "'");
		}

		if (null != params.get("cube_code")
				&& !" ".equals(params.get("cube_code"))) {
			querySql.append(" AND T1.CUBE_CODE = '" + params.get("cube_code")
					+ "'");
		}

		if (null != params.get("category")
				&& !"".equals(params.get("category"))
				&& !"0".equals(params.get("category"))) {
			querySql.append(" AND T1.KPI_CATEGORY IN (SELECT X.CATEGORY_ID FROM X_KPI_CATEGORY X START WITH X.CATEGORY_ID="
					+ params.get("category")
					+ " CONNECT BY PRIOR X.CATEGORY_ID = X.CATEGORY_PARENT_ID) ");
		}

		if (null != params.get("kpi_status")
				&& !" ".equals(params.get("kpi_status"))) {
			querySql.append(" AND T1.KPI_FLAG = '" + params.get("kpi_status")
					+ "'");
		}

		if (null != params.get("kpi_name")
				&& !"".equals(params.get("kpi_name"))) {
			querySql.append(" AND T1.KPI_NAME LIKE '%" + params.get("kpi_name")
					+ "'%");
		}
		querySql.append(") Z1, X_KPI_SQL_INFO T4 WHERE Z1.KPI_CODE = T4.KPI_CODE(+) AND Z1.V3=T4.KPI_VERSION(+)");

		return querySql.toString();
	}
}
