package cn.com.easy.kpi.parser;

import java.io.BufferedReader;
import java.io.Reader;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.MapListHandler;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.exception.JaxbException;
import cn.com.easy.jaxb.parser.DefaultJaxbParse;
import cn.com.easy.jaxb.parser.JaxbParse;
import cn.com.easy.kpi.element.Condition;
import cn.com.easy.kpi.element.Conditions;
import cn.com.easy.kpi.element.Dictionary;
import cn.com.easy.kpi.element.Dimension;
import cn.com.easy.kpi.element.Dimensions;
import cn.com.easy.kpi.element.Formula;
import cn.com.easy.kpi.element.Kpi;
import cn.com.easy.kpi.element.Measure;
import cn.com.easy.kpi.element.Measures;

public class GenerateFormKpiSQL {
	// 报表工具用到的维度
	private List<String> dims = null;
	// 报表工具用到的指标 复合指标规则：MF_复合指标ID_版本
	private List<String> kpis = null;
	// 报表工具的查询条件
	private List<Map<String, String>> wheres = null;
	// 报表工具的排序字段
	private List<Map<String, String>> orders = null;
	// 下钻表格中的下钻别名
	private Map<String, String> alias = null;
	// 基础维度和基础指标的来源表
	private List<Map<String, String>> tables = null;
	// 基础维度来源表
	private List<String> baseDimTables = null;
	// 基础指标来源表
	private List<String> baseKpiTables = null;
	// 复合指标使用表
	private List<String> formKpiTables = null;
	// 基础指标
	private Map<String, Map<String, Object>> baseKpis = null;
	// 基础维度
	private Map<String, Map<String, Object>> baseDims = null;
	// 复合指标
	private Map<String, Map<String, Object>> formKpisMap = null;
	
	private List<String> baseKpiSql = null;

	private List<Map<String, String>> havingList = null;
	// 复合指标组成的对象
	private Kpi kpi = null;
	// 复合指标数据源
	private EasyDataSource dataSource = null;
	// 元数据数据源
	private EasyDataSource dataSourceMeta = null;

	private List<Map<String, Object>> opter = null;
	
	private List<String> source_owner = null;
	String opterSql = "";

	/**
	 * 通过复合指标对象实例化
	 * 
	 * @param kpi
	 * @throws Exception
	 */
	public GenerateFormKpiSQL(Kpi kpi) throws Exception {
		this.kpi = kpi;
	}

	/**
	 * 基于报表工具的实例化
	 * 
	 * @param dims
	 * @param kpis
	 * @param wheres
	 * @param orders
	 * @throws Exception
	 */
	public GenerateFormKpiSQL(List<String> dims, List<String> kpis,
			List<Map<String, String>> wheres, List<Map<String, String>> orders,
			Map<String, String> alias) throws Exception {
		opterSql = "SELECT T.TYPE_ID,T.TYPE_NAME FROM X_FORMULA_TYPE T";
		this.dims = dims; // 实例化报表工具中使用的维度
		this.kpis = kpis;// 实例化报表工具中使用的指标
		this.wheres = wheres;// 实例化报表工具中的查询条件
		this.orders = orders;// 实例化报表工具中的排序字段
		this.alias = alias;// 下钻表格的别名
		dataSource = EasyContext.getContext().getDataSource();// 指标库用到的数据源
		if (!orders.isEmpty()) {
			for (Map<String, String> order : orders) {
				if ("dim".equals(order.get("type"))) {
					if (!"".equals(order.get("id")) && null != order.get("id"))
						if (!dims.contains(order.get("id")))
							dims.add(order.get("id"));
				} else {
					if (!"".equals(order.get("id")) && null != order.get("id"))
						kpis.add(order.get("id"));
				}

			}
		}
		baseDimTables = new LinkedList<String>();// 实例化基础维度来源表
		baseKpiTables = new LinkedList<String>();// 实例化基础指标来源表
		tables = new LinkedList<Map<String, String>>();// 实例化基础指标和维度的来源表
		formKpiTables = new LinkedList<String>();// 实例化维度的来源表
		baseDims = new LinkedHashMap<String, Map<String, Object>>();// 基础维度组成
		baseKpis = new LinkedHashMap<String, Map<String, Object>>();// 基础指标组成
		formKpisMap = new LinkedHashMap<String, Map<String, Object>>();// 复合指标
		havingList = new LinkedList<Map<String, String>>();//
		source_owner = new LinkedList<String>();//扩展数据源
		baseKpiSql = new LinkedList<String>();
		getMetaBaseDimensions();// 获取基础维度信息
		getFormKpis();// 获取复合指标信息
		this.getOpter();
	}
	
	public String getMuchTableCondition() throws Exception{
		if(baseKpiTables.size() > 1) {
			
		} 
		return "";
	}
	
	
	/**
	 * 获取XBuilder指标库模式获取的SQL
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> getSqlForBuilder() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("result", "success");
		try {
			String sql = "";
			sql = getSqlSelect(true);// 嵌套select部分
			sql += " from ( ";
			sql += getSqlSelect(false);// 基础指标和基础维度select部分
			sql += getSqlFrom();// 基础指标和基础维度from部分x
			sql += getSqlWhere(true);// 基础指标和基础维度where部分
			sql += " ) a ";
			sql += getSqlWhere(false);// 指标作为查询条件部分
			sql += getSqlGroup(true);// 分组部分
			sql += getSqlHaving(); // 复合指标查询条件
			sql += getSqlOrder();// 排序部分
			map.put("content", sql);
			map.put("datasource", source_owner.get(0));
		} catch (Exception e) {
			map.put("result", "failed");
			map.put("content", e.getMessage());
		}
		return map;
	}
	
	public String ClobToString(Object object) throws Exception {
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
	protected List<Measure> getMeasures() {
		return this.kpi.getMeasures().getMeasureList();
	}
	protected Measure getMeasure(String id) {
		for (Measure measure : getMeasures()) {
			if (id.equals(measure.getId())) {
				return measure;
			}
		}
		return null;
	}

	protected List<Dimension> getDimensions() {
		return this.kpi.getDimensions().getDimensionList();
	}

	protected Dimension getDimension(String id) {
		for (Dimension dimension : getDimensions()) {
			if (id.equals(dimension.getId())) {
				return dimension;
			}
		}
		return null;
	}

	protected List<Condition> getConditions() {
		return this.kpi.getConditions().getConditionList();
	}

	protected List<String> getMeasuresInFormula(String formula) {
		List<String> measures = new ArrayList<String>();
		Pattern p = Pattern.compile("\\{(.*?)\\}");
		Matcher m = p.matcher(formula);
		while (m.find()) {
			measures.add(m.group(1));
		}
		return measures;
	}

	protected Kpi parseXMLToKpi(String kpiXml) throws Exception {
		JaxbParse jaxb = null;
		Kpi kpi = null;
		try {
			jaxb = new DefaultJaxbParse();
			kpi = jaxb.readXmlStr(Kpi.class, kpiXml);
		} catch (JaxbException e) {
			throw new Exception(e);
		}
		this.kpi = kpi;
		return kpi;
	}

	protected void getMetaBaseDimensions() throws Exception {
		StringBuffer dim = new StringBuffer("");
		for (int i = 0; i < dims.size(); i++) {
			dim.append(dims.get(i) + ",");
		}
		for (int i = 0; i < wheres.size(); i++) {
			if ("dim".equals(wheres.get(i).get("type"))) {
				dim.append(wheres.get(i).get("id") + ",");
			}
		}
		for (int i = 0; i < orders.size(); i++) {
			if ("dim".equals(orders.get(i).get("type"))) {
				dim.append(orders.get(i).get("id") + ",");
			}
		}
		if (!"".equals(dim.toString())) {
			String sql = "select T.ID,T.DIM_TYPE,T.CONF_TYPE,T.DIM_OWNER,T.DIM_TABLE,T.DIM_FIELD,T.CONDITION,T.ID,T.DIM_CODE,T.DIM_NAME,T.SRC_ONWER,T.SRC_TABLE,T.SQL_CODE,(SELECT code FROM X_SUB_BASEDIM_INFO WHERE DIM_ID=T.ID AND NAME='code' AND ROWNUM=1) AS FIELD_CODE, (SELECT code FROM X_SUB_BASEDIM_INFO WHERE DIM_ID=T.ID AND NAME='name' AND ROWNUM=1) AS FIELD_NAME,(SELECT code FROM X_SUB_BASEDIM_INFO WHERE DIM_ID=T.ID AND NAME='ails' AND ROWNUM=1) AS FIELD_ORD from X_BASEDIM_INFO T where ID in ( ";
			Connection conn = null;//
			List<Map<String, Object>> results = null;
			QueryRunner queryRunner = null;
			String[] params = dim.toString().split(",");
			for (int i = 0; i < params.length; i++) {
				sql = sql + "?,";
			}
			sql = sql.substring(0, sql.length() - 1);
			sql = sql + ")";
			try {
				queryRunner = new QueryRunner();
				conn = dataSource.getConnection();
				results = queryRunner.query(conn, sql, params,
						new MapListHandler());
				// 处理结果集
				for (Map<String, Object> map : results) {
					Map<String, Object> dimMap = new HashMap<String, Object>();
					dimMap.put("DIM_TYPE", map.get("DIM_TYPE"));
					// 1代表维度，0代表属性，如果是属性只从事实表中取字段
					if ("1".equals(map.get("DIM_TYPE"))) {
						String dimTable = "";
						String dimTableAlias = "";
						
						boolean isSql = false;
						if (map.get("CONF_TYPE") != null
								&& "0".equals(String.valueOf(map
										.get("CONF_TYPE")))) {
							dimTable = String.valueOf(map.get("SRC_TABLE"));
							if (map.get("SRC_ONWER") != null
									&& !"".equals(String.valueOf(map
											.get("SRC_ONWER")))) {
								dimTable = String.valueOf(map.get("SRC_ONWER"))
										+ "." + dimTable;
							}
							dimTableAlias = String.valueOf(map.get("SRC_TABLE")).toUpperCase();
							if (map.get("CONDITION") != null
									&& !"".equals(String.valueOf(map
											.get("CONDITION")))) {
								isSql = true;
								String conditon = String.valueOf(map.get("CONDITION"));
								conditon = new String(org.apache.commons.codec.binary.Base64.decodeBase64(conditon), "UTF-8");
								dimTable = " (SELECT "
										+ String.valueOf(map.get("FIELD_CODE"))
										+ ","
										+ String.valueOf(map.get("FIELD_NAME"))
										+ " FROM  " + dimTable + " "  //定义维度where条件时已添加where
										+ conditon + ") ";
							}
						} else {
							isSql = true;
							dimTable = "("
									+ String.valueOf(map.get("SQL_CODE"))
									+ ") ";
						}
						if (isSql) {
							dimTable = dimTable.toUpperCase();// 如果是SQL模式给别名
							dimMap.put("TABLENAME", dimTable);
							dimTableAlias = (String)map.get("DIM_CODE");
						} else {
							dimMap.put("TABLENAME", dimTable.toUpperCase());
						}
						dimMap.put("DIM_FIELD", map.get("DIM_FIELD"));
						dimMap.put("FIELD_CODE", map.get("FIELD_CODE"));
						dimMap.put("FIELD_NAME", map.get("FIELD_NAME"));
						dimMap.put("FIELD_ORD", map.get("FIELD_ORD"));
						dimMap.put("TABLE_ALIAS", dimTableAlias);
					} else {
						dimMap.put("TABLENAME", "");
						dimMap.put("DIM_FIELD", map.get("DIM_FIELD"));
						dimMap.put("FIELD_CODE", "");
						dimMap.put("FIELD_NAME", "");
						dimMap.put("FIELD_ORD", "");
					}
					dimMap.put("DIM_CODE", map.get("DIM_CODE"));
					baseDims.put(String.valueOf(map.get("ID")), dimMap);
				}
			} catch (Exception e) {
				throw new Exception(e);
			} finally {
				if (conn != null) {
					conn.close();
				}
			}
		}
	}

	protected void getMetaBaseMeasures() throws Exception {
		StringBuffer kpi = new StringBuffer("");
		for (int i = 0; i < kpis.size(); i++) {
			if (isBaseKpi(kpis.get(i))) {
				kpi.append(kpis.get(i) + ",");
			}
		}
		for (int i = 0; i < wheres.size(); i++) {
			if ("kpi".equals(wheres.get(i).get("type"))) {
				if (isBaseKpi(wheres.get(i).get("id"))) {
					kpi.append(wheres.get(i).get("id") + ",");
				}
			}
		}
		for (int i = 0; i < orders.size(); i++) {
			if ("kpi".equals(orders.get(i).get("type"))) {
				if (isBaseKpi(orders.get(i).get("id"))) {
					kpi.append(orders.get(i).get("id") + ",");
				}
			}
		}
		if (!"".equals(kpi.toString())) {
			String sql = " select BASE_KEY,KPI_ORIGIN_SCHEMA,KPI_ORIGIN_TABLE,KPI_ORIGIN_COLUMN,KPI_CONDITION from X_BASE_KPI where BASE_KEY in ( ";
			Connection conn = null;//
			List<Map<String, Object>> results = null;
			QueryRunner queryRunner = null;
			String[] params = kpi.toString().split(",");
			for (int i = 0; i < params.length; i++) {
				sql = sql + "?,";
			}
			sql = sql.substring(0, sql.length() - 1);
			sql = sql + ")";
			try {
				queryRunner = new QueryRunner();
				conn = dataSourceMeta.getConnection();
				results = queryRunner.query(conn, sql, params, new MapListHandler());
				// 处理结果集
				for (Map<String, Object> map : results) {
					Map<String, Object> kpiMap = new HashMap<String, Object>();

					String kpiTable = String.valueOf(map
							.get("KPI_ORIGIN_TABLE"));
					if (map.get("KPI_ORIGIN_SCHEMA") != null
							&& !"".equals(String.valueOf(map
									.get("KPI_ORIGIN_SCHEMA")))) {
						kpiTable = String.valueOf(map.get("KPI_ORIGIN_SCHEMA"))
								+ "." + kpiTable;
					}
					kpiMap.put("KPI_FIELD", map.get("KPI_ORIGIN_COLUMN"));
					kpiMap.put("TABLENAME", kpiTable.toUpperCase());
					baseKpis.put(String.valueOf(map.get("BASE_KEY")), kpiMap);
					if (!baseKpiTables.contains(kpiTable.toUpperCase())) {
						baseKpiTables.add(kpiTable.toUpperCase());
					}
				}
			} catch (Exception e) {
				throw new Exception(e);
			} finally {
				if (conn != null) {
					conn.close();
				}
			}
		}
	}

	/**
	 * 获取复合指标集合
	 * 
	 * @throws Exception
	 */
	protected void getFormKpis() throws Exception {
		List<String> formKpis = new ArrayList<String>();// 复合指标
		StringBuffer fk = new StringBuffer("");
		for (String kpi : kpis) {
			if (!isBaseKpi(kpi)) {
				if (!formKpis.contains(kpi)) {
					fk.append(kpi.split("_")[0] + ",");
					formKpis.add(kpi);
				}
			}
		}
		for (Map<String, String> map : wheres) {
			if ("kpi".equals(map.get("type"))) {
				if (!isBaseKpi(map.get("id"))) {
					if (!formKpis.contains(map.get("id"))) {
						fk.append(map.get("id").split("_")[0] + ",");
						formKpis.add(map.get("id"));
					}
				}
			}
		}
		for (Map<String, String> map : orders) {
			if ("kpi".equals(map.get("type"))) {
				if (!isBaseKpi(map.get("id"))) {
					if (!formKpis.contains(map.get("id"))) {
						fk.append(map.get("id").split("_")[0] + ",");
						formKpis.add(map.get("id"));
					}
				}
			}
		}
		if(!"".equals(fk.toString())) {
			Connection conn = null;//
			QueryRunner queryRunner = null;
			try {
				if (formKpis.size() > 0) {
					queryRunner = new QueryRunner();
					String sql = "select KPI_NAME,KPI_KEY,KPI_CODE,KPI_TYPE,KPI_BODY,KPI_OWNER,KPI_TABLE,KPI_COLUMN,ACCTTYPE from X_KPI_INFO where kpi_key in ( ";
					conn = dataSource.getConnection();
					String[] params = fk.toString().split(",");
					for (int i = 0; i < params.length; i++) {
						sql = sql + "?,";
					}
					sql = sql.substring(0, sql.length() - 1);
					sql = sql + ")";
					List<Map<String, Object>> results = queryRunner.query(conn, sql, params, new MapListHandler());
					// 处理结果集
					for (Map<String, Object> map : results) {
						Map<String, Object> kpiMap = new HashMap<String, Object>();
						String kpiTable = "";
						if(map.get("KPI_TABLE") != null && !"".equals(String.valueOf(map.get("KPI_TABLE"))))
							kpiTable = String.valueOf(map.get("KPI_TABLE"));
						String kpiColumn = "";
						if(map.get("KPI_COLUMN") != null && !"".equals(String.valueOf(map.get("KPI_COLUMN"))))
							kpiColumn = String.valueOf(map.get("KPI_COLUMN"));
						String kpiOwner = "";
						if(map.get("KPI_OWNER") != null && !"".equals(String.valueOf(map.get("KPI_OWNER"))))
							kpiOwner = String.valueOf(map.get("KPI_OWNER"));
						kpiMap.put("KPI_KEY", map.get("KPI_KEY"));
						kpiMap.put("KPI_CODE", map.get("KPI_CODE"));
						kpiMap.put("KPI_TYPE", map.get("KPI_TYPE"));
						kpiMap.put("KPIOWNER", kpiOwner);
						kpiMap.put("KPI_NAME", map.get("KPI_NAME"));
						kpiMap.put("TABLENAME", kpiTable.toUpperCase());
						kpiMap.put("KPICOLUMN", kpiColumn.toUpperCase());
						kpiMap.put("KPI_BODY", map.get("KPI_BODY"));
						for(String kpi_attr : formKpis) {
							if(kpi_attr.split("_")[0].equals(String.valueOf(map.get("KPI_KEY")))) {
								kpiMap.put("KPI_ATTR", kpi_attr.split("_")[1]);
								break;
							}
						}
						String kpiBody = this.ClobToString(map.get("KPI_BODY"));
						if("1".equals(map.get("KPI_TYPE"))) {//基础指标
							kpiMap.put("SOURCE_COLUMN", parseBaseKpi(kpiBody));
							baseKpis.put(String.valueOf(map.get("KPI_KEY")), kpiMap);
						} else if ("2".equals(map.get("KPI_TYPE"))) {//复合指标
							parseFormKpi(kpiBody);
							kpiMap.put("SOURCE_COLUMN", parseFormKpiFormulas(kpiBody));
							formKpisMap.put(String.valueOf(map.get("KPI_KEY")), kpiMap);
						} else {//衍生指标
							//暂时先不处理
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				throw new Exception(e);
			} finally {
				if (conn != null)
					conn.close();
			}
		}
	}
	protected String parseBaseKpi(String kpiBody) throws Exception{
		Kpi kpi = parseXMLToKpi(kpiBody);// 获取复合指标的组成结构体
		String sql = parseKpi(kpi);//基础指标SQL
		return sql;
	}
	
	protected void parseFormKpi(String kpiBody) throws Exception{
		Kpi kpi = parseXMLToKpi(kpiBody);// 获取复合指标的组成结构体
		Measures measures = kpi.getMeasures();
		Connection conn = null;//
		QueryRunner queryRunner = null;
		StringBuffer fk = new StringBuffer("");
		try {
			queryRunner = new QueryRunner();
			String sql = "select KPI_NAME,KPI_KEY,KPI_CODE,KPI_TYPE,KPI_BODY,KPI_OWNER,KPI_TABLE,KPI_COLUMN,ACCTTYPE from X_KPI_INFO where KPI_KEY in ( ";
			for(Measure measure : measures.getMeasureList()) {
				if(measure.getId().startsWith("FK_")) {
					fk.append(measure.getKpiKey().split("_")[0] + ",");
				}
			}
			conn = dataSource.getConnection();
			String[] params = fk.toString().split(",");
			for (int i = 0; i < params.length; i++) {
				sql = sql + "?,";
			}
			sql = sql.substring(0, sql.length() - 1);
			sql = sql + ")";
			List<Map<String, Object>> results = queryRunner.query(conn, sql, params, new MapListHandler());
			// 处理结果集
			for (Map<String, Object> map : results) {
				Map<String, Object> kpiMap = new HashMap<String, Object>();
				String kpiTable = "";
				if(map.get("KPI_TABLE") != null && !"".equals(String.valueOf(map.get("KPI_TABLE"))))
					kpiTable = String.valueOf(map.get("KPI_TABLE"));
				String kpiColumn = "";
				if(map.get("KPI_COLUMN") != null && !"".equals(String.valueOf(map.get("KPI_COLUMN"))))
					kpiColumn = String.valueOf(map.get("KPI_COLUMN"));
				String kpiOwner = "";
				if(map.get("KPI_OWNER") != null && !"".equals(String.valueOf(map.get("KPI_OWNER"))))
					kpiOwner = String.valueOf(map.get("KPI_OWNER"));
				kpiMap.put("KPI_KEY", map.get("KPI_KEY"));
				kpiMap.put("KPI_CODE", map.get("KPI_CODE"));
				kpiMap.put("KPI_TYPE", map.get("KPI_TYPE"));
				kpiMap.put("KPIOWNER", kpiOwner);
				kpiMap.put("KPI_NAME", map.get("KPI_NAME"));
				kpiMap.put("TABLENAME", kpiTable.toUpperCase());
				kpiMap.put("KPICOLUMN", kpiColumn.toUpperCase());
				kpiMap.put("KPI_BODY", map.get("KPI_BODY"));
				for(Measure measure : measures.getMeasureList()) {
					if(measure.getKpiKey().split("_")[0].equals(String.valueOf(map.get("KPI_KEY")))) {
						kpiMap.put("KPI_ATTR", measure.getId().split("_")[2]);
						break;
					}
				}
 				kpiMap.put("SOURCE_COLUMN", parseBaseKpi(ClobToString(map.get("KPI_BODY"))));
				baseKpis.put(String.valueOf(map.get("BASE_KEY")), kpiMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			if (conn != null)
				conn.close();
		}
	}
	/**
	 * 获取基础指标和维度的SELECT部分
	 * 
	 * @param isAll
	 * @return
	 * @throws Exception
	 */
	protected String getSqlSelect(boolean isAll) throws Exception {
		StringBuffer sql = new StringBuffer(" select ");
		// 维度部分
		for (int i = 0; i < dims.size(); i++) {
			String dim = dims.get(i);
			if (!baseDims.containsKey(dim)) {
				throw new Exception("基础维度[" + dim + "]已移除，或者尚未定义");
			}
			// 1代表维度，0代表标签，如果是标签只从事实表中取字段
			if ("1".equals((String) baseDims.get(dim).get("DIM_TYPE"))) {
				String codeAlias = (String) baseDims.get(dim).get("DIM_FIELD")
						+ "_CODE";
				String descAlias = (String) baseDims.get(dim).get("DIM_FIELD");
				if (alias != null && alias.size() > 0) { // 添加下钻的别名
					if (dim.equals(alias.get("id"))) {
						codeAlias = alias.get("code");
						descAlias = alias.get("name");
					}
				}
				if (isAll) {
					sql.append(descAlias + ",");
					sql.append(codeAlias + ",");
				} else {
					sql.append(baseDims.get(dim).get("TABLE_ALIAS") + "."
							+ baseDims.get(dim).get("FIELD_NAME") + " AS "
							+ descAlias + ",");
					sql.append(baseDims.get(dim).get("TABLE_ALIAS") + "."
							+ baseDims.get(dim).get("FIELD_CODE") + " AS "
							+ codeAlias + ",");
				}
			} else {
				for (int j = 0; j < baseKpiTables.size(); j++) {
					if(isAll) {
						sql.append(baseDims.get(dim).get("DIM_FIELD") + ",");
					} else {
						String tables = baseKpiTables.get(j);
						sql.append(tables + "."
								+ baseDims.get(dim).get("DIM_FIELD") + " AS "
								+ baseDims.get(dim).get("DIM_FIELD") + ",");
					}
				}
			}
		}
		// 基础指标部分
		int k = 0;
		for (Map.Entry<String, Map<String, Object>> entry : baseKpis.entrySet()) {
			if (k == baseKpis.size() - 1) {
				if (isAll) {
					if(sql.toString().indexOf((String)entry.getValue().get("KPI_CODE")) ==-1) {
						sql.append("SUM(" + entry.getValue().get("KPI_CODE")
								+ ") AS " + entry.getValue().get("KPI_CODE") + " ");
					}
				}else {
					if(sql.toString().indexOf((String)entry.getValue().get("SOURCE_COLUMN")) ==-1) {
						sql.append(entry.getValue().get("SOURCE_COLUMN") + " AS " + entry.getValue().get("KPI_CODE") );
					}
				}
			} else {
				if (isAll){
					if(sql.toString().indexOf((String)entry.getValue().get("KPI_CODE")) ==-1) {
						sql.append("SUM(" + entry.getValue().get("KPI_CODE")
								+ ") AS " + entry.getValue().get("KPI_CODE") + ",");
					}
				}else {
					if(sql.toString().indexOf((String)entry.getValue().get("SOURCE_COLUMN")) ==-1) {
						sql.append(entry.getValue().get("SOURCE_COLUMN")  + " AS " + entry.getValue().get("KPI_CODE") + ",");
					}
 				}
			}
			k++;
		}
		if(",".equals(sql.toString().substring(sql.toString().length()-1))) {
			sql = new StringBuffer(sql.toString().substring(0,sql.toString().length()-1));
		}
		k = 0;
//		// 复合指标
		for (Map.Entry<String, Map<String, Object>> entry : formKpisMap
				.entrySet()) {
			if(isAll) {
				sql.append(" , " + entry.getValue().get("SOURCE_COLUMN"));
			}
			k++;
		}
		return sql.toString();
	}
	/**
	 * 获取表表中使用的所有表，并定义from部分
	 * 
	 * @return
	 * @throws Exception
	 */
	protected String getSqlFrom() throws Exception {
		StringBuffer sql = new StringBuffer(" FROM ");
		Map<String,ArrayList<Map<String,Object>>> dimTable = new HashMap<String,ArrayList<Map<String,Object>>>();
		for (Map.Entry<String, Map<String, Object>> baseDim : baseDims
				.entrySet()) {
			if ("1".equals(baseDim.getValue().get("DIM_TYPE"))) {
				if(dimTable.containsKey((String)baseDim.getValue().get("TABLENAME"))) {
					ArrayList<Map<String,Object>> list = dimTable.get((String) baseDim.getValue().get("TABLENAME"));
					list.add(baseDim.getValue());
					dimTable.put((String) baseDim.getValue().get("TABLENAME"), list);
				} else {
					ArrayList<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
					list.add(baseDim.getValue());
					dimTable.put((String) baseDim.getValue().get("TABLENAME"), list);
				}
			}
		}
		for (int i = 0; i < baseKpiTables.size(); i++) {
			String table = baseKpiTables.get(i);
			sql.append(" " + table);
			for (Map.Entry<String, ArrayList<Map<String, Object>>> dim : dimTable
					.entrySet()) {
				if(dim.getValue().size() > 1) {
					sql.append(" INNER JOIN ");
					int k = 0;
					String str = " ( SELECT ";
					String group = "";
					String where = "";
					String alias = "";
					for(Map<String,Object> dm : dim.getValue()) {
						alias = (String)dm.get("TABLE_ALIAS");
						if(k == 0) {
							where += table + "." + dm.get("DIM_FIELD") + "=" + dm.get("TABLE_ALIAS") + "."
									+ dm.get("FIELD_CODE") + " ";
						} else {
							where += " and " + table + "." + dm.get("DIM_FIELD") + "=" + dm.get("TABLE_ALIAS") + "."
									+ dm.get("FIELD_CODE") + " ";
						}
						if(k== dim.getValue().size()-1) {
							str += dm.get("FIELD_CODE") + "," + dm.get("FIELD_NAME");
							group += dm.get("FIELD_CODE") + "," + dm.get("FIELD_NAME");
						} else { 
							group += dm.get("FIELD_CODE") + "," + dm.get("FIELD_NAME") +",";
							str += dm.get("FIELD_CODE") + "," + dm.get("FIELD_NAME") +",";
						}
						k++;
					}
					str = str + " from " + dim.getKey() + " group by " + group + ") " + alias + " ON " +  where;
					sql.append(str);
				} else {
					if("1".equals(dim.getValue().get(0).get("DIM_TYPE"))) {
						sql.append(" INNER JOIN "
								+ dim.getValue().get(0).get("TABLENAME") + " " + dim.getValue().get(0).get("TABLE_ALIAS")+ " ON ");
						sql.append(" " + table + "."
								+ dim.getValue().get(0).get("DIM_FIELD") + " = "
								+ dim.getValue().get(0).get("TABLE_ALIAS") + "."
								+ dim.getValue().get(0).get("FIELD_CODE") + " ");
					}
				}
			}
		}
		return sql.toString();
	}

	/**
	 * 根据报表中定义的 where部分
	 * 
	 * @param isDim
	 *            判断维度还是指标
	 * @return
	 * @throws Exception
	 */
	protected String getSqlWhere(boolean isDim) throws Exception {
		StringBuffer sql = new StringBuffer("");
		if(wheres != null && wheres.size() > 0 && wheres.get(0).size() > 0) {
			sql = new StringBuffer(" where 1=1 ");
		}
		for (int i = 0; i < wheres.size(); i++) {
			if (isDim) {
				// 如果是维度，则生成维度的查询条件
				if ("dim".equals(wheres.get(i).get("type"))) {
					if (!baseDims.containsKey(wheres.get(i).get("id")))
						throw new Exception("基础维度[" + wheres.get(i).get("id")
								+ "]已移除，或者尚未定义");
					String var_name = wheres.get(i).get("varname");
					if ("1".equals(baseDims.get(wheres.get(i).get("id")).get(
							"DIM_TYPE"))) {
						if (var_name == null || "".equals(var_name)) {
							var_name = (String) baseDims.get(
									wheres.get(i).get("id")).get("FIELD_CODE");
						}
						if ("06".equals(wheres.get(i).get("formula"))) {
							sql.append(" { and "
									+ baseDims.get(wheres.get(i).get("id"))
											.get("TABLE_ALIAS")
									+ "."
									+ baseDims.get(wheres.get(i).get("id"))
											.get("FIELD_CODE") + " >= #"
									+ var_name + "_1# }");
							sql.append(" { and "
									+ baseDims.get(wheres.get(i).get("id"))
											.get("TABLE_ALIAS")
									+ "."
									+ baseDims.get(wheres.get(i).get("id"))
											.get("FIELD_CODE") + " <= #"
									+ var_name + "_2# }");
						} else {
							if ("1".equals(wheres.get(i).get("formula"))) { // 多选
								sql.append(" { and "
										+ baseDims.get(wheres.get(i).get("id"))
												.get("TABLE_ALIAS")
										+ "."
										+ baseDims.get(wheres.get(i).get("id"))
												.get("FIELD_CODE") + " in( #"
										+ var_name + "# ) }");
							} else {
								sql.append(" { and "
										+ baseDims.get(wheres.get(i).get("id"))
												.get("TABLE_ALIAS")
										+ "."
										+ baseDims.get(wheres.get(i).get("id"))
												.get("FIELD_CODE")
										+ " "
										+ this.opter(wheres.get(i).get(
												"formula")) + " #" + var_name
										+ "# }");
							}
						}
					} else {
						for (String tables : baseKpiTables) {
							if (var_name == null || "".equals(var_name)) {
								var_name = (String) baseDims.get(
										wheres.get(i).get("id")).get(
										"DIM_FIELD");
							}
							if ("06".equals(wheres.get(i).get("formula"))) {
								sql.append(" { and "
										+ tables
										+ "."
										+ baseDims.get(wheres.get(i).get("id"))
												.get("DIM_FIELD") + " >= #"
										+ var_name + "_1#}");
								sql.append(" { and "
										+ tables
										+ "."
										+ baseDims.get(wheres.get(i).get("id"))
												.get("DIM_FIELD") + " <= #"
										+ var_name + "_2#}");
							} else {
								if ("1".equals(wheres.get(i).get("formula"))) { // 多选
									sql.append(" { and "
											+ tables
											+ "."
											+ baseDims.get(
													wheres.get(i).get("id"))
													.get("DIM_FIELD") + " in(#"
											+ var_name + "#) }");
								} else {
									sql.append(" { and "
											+ tables
											+ "."
											+ baseDims.get(
													wheres.get(i).get("id"))
													.get("DIM_FIELD")
											+ " "
											+ this.opter(wheres.get(i).get(
													"formula")) + " #"
											+ var_name + "# }");
								}
							}
						}
					}
				}
			} else { // 如果是指标则将指标嵌套在最外层的SQL语句部分
				if ("kpi".equals(wheres.get(i).get("type"))) {
					if (isBaseKpi(wheres.get(i).get("id"))) {
						if (!baseKpis.containsKey(wheres.get(i).get("id")))
							throw new Exception("基础指标["
									+ wheres.get(i).get("id") + "]已移除，或者尚未定义");
						String var_name = wheres.get(i).get("varname");
						if (var_name == null || "".equals(var_name)) {
							var_name = (String) baseKpis.get(
									wheres.get(i).get("id")).get("KPI_FIELD");
						}
						if ("06".equals(wheres.get(i).get("formula"))) {
							sql.append(" { and "
									+ baseKpis.get(wheres.get(i).get("id"))
											.get("KPI_FIELD")
									+ " >=  #"
									+ var_name
									+ "_1# and "
									+ baseKpis.get(wheres.get(i).get("id"))
											.get("KPI_FIELD") + "<= #"
									+ var_name + "_2# }");
						} else {
							sql.append(" { and "
									+ baseKpis.get(wheres.get(i).get("id"))
											.get("KPI_FIELD") + " "
									+ this.opter(wheres.get(i).get("formula"))
									+ " #" + var_name + "# }");
						}

					} else {
						// 复合指标的查询条件
						havingList.add(wheres.get(i));
					}
				}
			}
		}
		return sql.toString();
	}

	/**
	 * 根据报表中的排序生成order by部分
	 * 
	 * @return
	 * @throws Exception
	 */
	protected String getSqlOrder() throws Exception {
		StringBuffer sql = new StringBuffer("");
		for (int i = 0; i < orders.size(); i++) {
			if (null != orders.get(i).get("type")) {
				if ("dim".equals(orders.get(i).get("type"))) {
					// 1代表维度，0代表标签，如果是属性标签只从事实表中取字段
					if ("0".equals(baseDims.get(orders.get(i).get("id")).get(
							"DIM_TYPE"))) {
						sql.append(" "
								+ baseDims.get(orders.get(i).get("id")).get(
										"DIM_FIELD") + "  "
								+ orders.get(i).get("ord") + ",");
					} else {
						if (alias != null && alias.size() > 0) { // 添加下钻的别名
							sql.append(" " + alias.get("code") + " "
									+ orders.get(i).get("ord") + ",");
						} else {
							sql.append(" "
									+ baseDims.get(orders.get(i).get("id"))
											.get("DIM_FIELD") + "_CODE "
									+ orders.get(i).get("ord") + ",");
						}
					}
				} else {
					if (!isBaseKpi(orders.get(i).get("id"))) {
						sql.append(" " + orders.get(i).get("id") + " "
								+ orders.get(i).get("ord") + ",");
					} else {
						if (!baseKpis.containsKey(orders.get(i).get("id")))
							throw new Exception("基础指标["
									+ orders.get(i).get("id") + "]已移除，或者尚未定义");
						sql.append(" "
								+ baseKpis.get(orders.get(i).get("id")).get(
										"KPI_FIELD") + " "
								+ orders.get(i).get("ord") + ",");
					}
				}
			}
		}
		if (!"".equals(sql.toString())) {
			return " order by "
					+ sql.toString().substring(0, sql.toString().length() - 1);
		}
		return sql.toString();
	}

	/**
	 * 根据报表中的排序生成order by部分
	 * 
	 * @return
	 * @throws Exception
	 */
	protected String getSqlOrder(boolean isDim) throws Exception {
		StringBuffer sql = new StringBuffer("");
		for (int i = 0; i < orders.size(); i++) {
			if (null != orders.get(i).get("type")) {
				if (isDim) {
					if ("dim".equals(orders.get(i).get("type"))) {
						// 1代表维度，0代表标签，如果是属性标签只从事实表中取字段
						if ("0".equals(baseDims.get(orders.get(i).get("id"))
								.get("DIM_TYPE"))) {
							sql.append(" "
									+ baseDims.get(orders.get(i).get("id"))
											.get("DIM_FIELD") + "  "
									+ orders.get(i).get("ord") + ",");
						} else {
							if (alias != null && alias.size() > 0) { // 添加下钻的别名
								sql.append(" " + alias.get("code") + " "
										+ orders.get(i).get("ord") + ",");
							} else {
								sql.append(" "
										+ baseDims.get(orders.get(i).get("id"))
												.get("DIM_FIELD") + "_CODE "
										+ orders.get(i).get("ord") + ",");
							}
						}
					}
				} else {
					if (!"dim".equals(orders.get(i).get("type"))) {
						if (!isBaseKpi(orders.get(i).get("id"))) {
							sql.append(" " + orders.get(i).get("id") + " "
									+ orders.get(i).get("ord") + ",");
						} else {
							if (!baseKpis.containsKey(orders.get(i).get("id")))
								throw new Exception("基础指标["
										+ orders.get(i).get("id")
										+ "]已移除，或者尚未定义");
							sql.append(" "
									+ baseKpis.get(orders.get(i).get("id"))
											.get("KPI_FIELD") + " "
									+ orders.get(i).get("ord") + ",");
						}
					}
				}
			}
		}
		if (!"".equals(sql.toString())) {
			return " order by "
					+ sql.toString().substring(0, sql.toString().length() - 1);
		}
		return sql.toString();
	}

	/**
	 * 根据在报表中使用的基础维度作为group by 部分
	 * 
	 * @param isAll
	 *            isAll==true 则不包含表名部分
	 * @return
	 * @throws Exception
	 */
	protected String getSqlGroup(boolean isAll) throws Exception {
		StringBuffer sql = new StringBuffer("");
		for (String dim : dims) {
			if (!baseDims.containsKey(dim)) {
				throw new Exception("基础维度[" + dim + "]在元数据中已移除，或者尚未定义");
			}
			if ("1".equals((String) baseDims.get(dim).get("DIM_TYPE"))) {
				String codeAlias = (String) baseDims.get(dim).get("DIM_FIELD")
						+ "_CODE";
				String descAlias = (String) baseDims.get(dim).get("DIM_FIELD");
				if (alias != null && alias.size() > 0) { // 添加下钻的别名
					if (dim.equals(alias.get("id"))) {
						codeAlias = alias.get("code");
						descAlias = alias.get("name");
					}
				}
				if (isAll) {
					sql.append(descAlias + ",");
					sql.append(codeAlias + ",");
				} else {
					sql.append(baseDims.get(dim).get("TABLE_ALIAS") + "."
							+ baseDims.get(dim).get("FIELD_CODE") + ",");
					sql.append(baseDims.get(dim).get("TABLE_ALIAS") + "."
							+ baseDims.get(dim).get("FIELD_NAME") + ",");
				}
			} else {
				for (String table : baseKpiTables) {
					if (isAll) {
						sql.append(baseDims.get(dim).get("DIM_FIELD") + ",");
					} else {
						sql.append(table + "."
								+ baseDims.get(dim).get("DIM_FIELD") + ",");
					}
				}
			}

		}
		if (!"".equals(sql.toString())) {
			return " group by "
					+ sql.toString().substring(0, sql.toString().length() - 1);
		}
		return sql.toString();
	}

	protected String getSqlHaving() throws Exception {
		StringBuffer having = new StringBuffer("  ");
		if(havingList.size() > 0 && havingList.get(0).size() > 0) {
			having = new StringBuffer(" having 1=1");
		}
		for (Map<String, String> map : havingList) {
			if ("06".equals(map.get("formula"))) {
				having.append("{ and SUM(" + map.get("id") + ") >= #"
						+ map.get("id") + "_1# and SUM(" + map.get("id")
						+ ") <= #" + map.get("id") + "_2#}");
			} else {
				having.append("{ and SUM(" + map.get("id") + ") "
						+ this.opter(map.get("formula")) + " #" + map.get("id")
						+ "#}");
			}
		}
		return having.toString();
	}

	/**
	 * 判断是否是基础指标 复合指标以MF_开头
	 * 
	 * @param kpiId
	 * @return
	 */
	protected boolean isBaseKpi(String kpiId) {
		return kpiId.startsWith("BK_");
	}
	protected boolean hasFormKpi() {
		boolean flag = false;
		for (String kpiStr : kpis) {
			if (kpiStr.startsWith("FK_")) {
				flag = true;
			}
		}
		return flag;
	}
	 
	protected void getOpter() throws Exception {
		QueryRunner queryRunner = new QueryRunner();
		try {
			opter = queryRunner.query(dataSource.getConnection(), opterSql, null, new MapListHandler());
		} catch (SQLException e) {
			throw new Exception(e);
		}
	}

	protected String opter(String typeId) {
		for (Map<String, Object> map : opter) {
			if (typeId.equals(map.get("TYPE_ID"))) {
				return map.get("TYPE_NAME").toString();
			}
		}
		return "=";
	}
	protected String parseFormKpiFormulas(String kpiBody) throws Exception{
		Kpi kpi = parseXMLToKpi(kpiBody);// 获取复合指标的组成结构体
		Formula formula = kpi.getFormulas().getFormula();// 复合指标组成公式
		String formulaSQL = formula.getFormula();// 定义复合指标的公式SQL
		for (String id : getMeasuresInFormula(formula.getFormula())) {
			for (Measure measure : getMeasures()) {
				if (id.equals(measure.getId())) {
					// 将{指标ID}替换成来源表和来源字段，以及聚合函数
					formulaSQL = formulaSQL.replaceAll("\\{" + id
							+ "\\}",  measure.getAggregator() + "("
							+ measure.getId().substring(0,measure.getId().length()-2) + ") ");
					break;
				}
			}
		}
		formulaSQL = validateZero(formulaSQL);
		formulaSQL = " ( " + formulaSQL +") AS " + kpi.getId();
		return formulaSQL;
	}
	
	protected String getBaseMetaType(Measure measure) throws Exception {
		String sql = " select TYPE from X_BASE_KPI where BASE_KEY = '"+ measure.getKpiKey() + "'";
		QueryRunner queryRunner = new QueryRunner();
		List<Map<String, Object>> results = null;
		try {
			results = queryRunner.query(dataSource.getConnection(), sql, null, new MapListHandler());
		} catch (SQLException e) {
			throw new Exception(e);
		}
		if(results != null) {
			return (String)results.get(0).get("TYPE");
		} 
		return null;
	}

	protected String parseFormulas(Kpi kpi) throws Exception {
		Formula formula = kpi.getFormulas().getFormula();// 复合指标组成公式
		String formulaSQL = formula.getFormula();// 定义复合指标的公式SQL
		for (String id : getMeasuresInFormula(formula.getFormula())) {
			for (Measure measure : getMeasures()) {
				if (id.equals(measure.getId())) {
					// 将{指标ID}替换成来源表和来源字段，以及聚合函数
					formulaSQL = formulaSQL.replaceAll("\\{" + id
							+ "\\}",  "("
							+ measure.getTableLink() + "."
							+ measure.getColumnLink() + ") ");
					if(baseKpiTables != null) {
						if(!baseKpiTables.contains(measure.getTableLink())) {
							baseKpiTables.add(measure.getTableLink());
						}
					}
					if(source_owner != null) {
						if (!source_owner.contains(measure.getDatasource())) {
							source_owner.add(measure.getDatasource());
						}
					}
					break;
				}
			}
		}
		return formulaSQL;
	}
	
	public String parseExpression(Kpi kpi) throws Exception {
		String expression = "";
		if (getConditions() != null && getConditions().size() > 0) {
			expression = kpi.getConditions().getExpression()
					.getExpression();
			for (Condition condition : getConditions()) {
				if ("5".equals(condition.getType())) {
					Measure measure = getMeasure(condition.getSource());
					expression = expression.replaceAll(
							"\\{" + measure.getId() + "\\}",
							measure.getTableLink() + "."
									+ measure.getColumnLink());
					continue;
				}
				Dimension dimension = getDimension(condition.getSource());
				if(dimension != null) {
					expression = expression.replaceAll(
							"\\{" + dimension.getId() + "\\}",
									 dimension.getColumnLink());
					continue;
				}
				//指标或者属性
				if ("4".equals(condition.getType())) {
					Measure measure = getMeasure(condition.getSource());
					expression = expression.replaceAll(
							"\\{" + measure.getId() + "\\}",
							measure.getTableLink() + "."
									+ measure.getColumnLink());
				}
			}
		}
		return expression;
	}
	
	protected String parseKpi(Kpi kpi) throws Exception {
		StringBuffer sql = new StringBuffer("");
		String expression = parseExpression(kpi);
		String formulaSQL = parseFormulas(kpi);
		if(!"".equals(expression)) {
			sql.append(" (CASE WHEN ");
			if(expression.trim().toUpperCase().startsWith("AND")){
				expression = expression.substring(3);
			} else if(expression.trim().toUpperCase().startsWith("OR")) {
				expression = expression.substring(2);
			}
			sql.append(expression);
			sql.append(" THEN "+ formulaSQL +" ELSE 0 END ) ");
		} else {
			sql.append(formulaSQL);
		}
		return sql.toString();
	}
	
	protected String validateZero(String formula) {
		if(formula.indexOf("/") != -1) {
			StringBuffer sql = new StringBuffer("");
			String str = formula;
			while (str.indexOf("/") !=-1) {
				str = str.substring(formula.indexOf("/") + 1);
				if(str.trim().startsWith("(")) {
					if(!"".equals(sql.toString())) {
						sql.append(" or " + str.substring(0, str.indexOf(")")) + " = 0 ");
					} else {
						sql.append(" " + str.substring(0, str.indexOf(")")) + " = 0 ");
					}
				} else {
					String s = str;
					if (s.indexOf("+") != -1) {
						s = str.replaceAll("+", ",");
					} else if (s.indexOf("-") != -1) {
						s = str.replaceAll("-", ",");
					} else if(s.indexOf("*") != -1) {
						s = str.replaceAll("*", ",");
					} else if(s.indexOf("/") != -1){
						s = str.replaceAll("/", ",");
					}
					if(!"".equals(sql.toString())) {
						sql.append(" or " + s.split(",")[0] + " = 0 ");
					} else {
						sql.append(" " + s.split(",")[0] + " = 0 ");
					}
					
				}
			}
			return " case when (" + sql.toString() + ") then 0 else ("+ formula +") end ";
		} else {
			return formula;
		}
	}
}
