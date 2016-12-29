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
import org.apache.commons.dbutils.handlers.MapHandler;
import org.apache.commons.dbutils.handlers.MapListHandler;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.exception.JaxbException;
import cn.com.easy.jaxb.parser.DefaultJaxbParse;
import cn.com.easy.jaxb.parser.JaxbParse;
import cn.com.easy.kpi.element.Condition;
import cn.com.easy.kpi.element.Dimension;
import cn.com.easy.kpi.element.Formula;
import cn.com.easy.kpi.element.Kpi;
import cn.com.easy.kpi.element.Measure;
import cn.com.easy.kpi.element.Measures;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Report;

public class GenerateKpiSQL {
	// 报表工具用到的维度
	private List<String> dims = null;
	// 报表工具用到的指标 复合指标规则：MF_复合指标ID_版本
	private List<Map<String, String>> kpis = null;
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
	//复合指标使用的基础指标
	private Map<String,List<Map<String,Object>>> baseFormKpi = null;
	
	
	private List<Map<String, String>> havingList = null;

	private Map<String, Object> cubeInfo = null;
	// 复合指标组成的对象
	private Kpi kpi = null;
	// 复合指标数据源
	private EasyDataSource dataSource = null;
	
	private List<Map<String, Object>> opter = null;

	private String cube_code = null;

	private Report report = null;

	private Component component = null;

	private List<Map<String, Object>> relInfo = null;

	private List<Map<String, Object>> attrInfo = null;

	private String mainTable = null;
	
	private String relation = null;

	private String opterSql = "";
	
	private List<String> useKpiList = null;
	
	private String mainTableAlias = null;
	
	private String formatterSql = "";

	/**
	 * 通过复合指标对象实例化
	 * 
	 * @param kpi
	 * @throws Exception
	 */
	public GenerateKpiSQL(Kpi kpi) throws Exception {
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
	public GenerateKpiSQL(List<String> dims, List<Map<String, String>> kpis,
			List<Map<String, String>> wheres, List<Map<String, String>> orders,
			Map<String, String> alias, Report report, Component component)
			throws Exception {
		opterSql = "SELECT T.TYPE_ID,T.TYPE_NAME FROM X_FORMULA_TYPE T";
		formatterSql = "SELECT ATTR1,ATTR2,ATTR3 FROM X_KPI_CODE WHERE TYPE='0' AND CODE=? ";
		this.dims = dims; // 实例化报表工具中使用的维度
		this.kpis = kpis;// 实例化报表工具中使用的指标
		this.wheres = wheres;// 实例化报表工具中的查询条件
		this.orders = orders;// 实例化报表工具中的排序字段
		this.alias = alias;// 下钻表格的别名
		this.cube_code = report.getInfo().getCubeId();// 数据魔方编码
		this.report = report;
		this.component = component;
		dataSource = EasyContext.getContext().getDataSource();// 指标库用到的数据源
		if (!orders.isEmpty()) {
			for (Map<String, String> order : orders) {
				if ("dim".equals(order.get("type"))) {
					if (!"".equals(order.get("id")) && null != order.get("id"))
						if (!dims.contains(order.get("id")))
							dims.add(order.get("id"));
				} else {
					if (!"".equals(order.get("id")) && null != order.get("id")) {
						Map<String, String> map = new HashMap<String, String>();
						map.put("COLUMN_ID", order.get("id"));
						map.put("COLUMN_CODE", order.get("col"));
						kpis.add(map);
					}
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
		cubeInfo = new HashMap<String, Object>();
		relInfo = new ArrayList<Map<String, Object>>();// 关联方式
		attrInfo = new ArrayList<Map<String, Object>>();// 账期属性信息
		baseFormKpi = new HashMap<String,List<Map<String,Object>>>();//复合指标使用的基础指标
		getCubeInfo();
		getMetaBaseDimensions();// 获取基础维度信息
		getMetaBaseAttr();// 属性信息
		getMetaBaseMeasures();// 基础指标信息
		getFormKpis();// 获取复合指标信息
		this.getOpter();
		if(baseKpiTables != null && baseKpiTables.size() >0 ) {
			mainTable = baseKpiTables.get(0);
			if(mainTable.indexOf(".") != -1) {
				mainTableAlias = mainTable.substring(mainTable.indexOf(".") + 1);
			} else {
				mainTableAlias = mainTable;
			}
		}
	}

	/**
	 * 获取XBuilder指标库模式获取的SQL
	 * 
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> getSqlForBuilder() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("result", "success");
		try {
 			String sql = " SELECT 'B' AS ORD_CODE,";
			sql += getSqlSelect(true);// 嵌套select部分
			if("1".equals((String)cubeInfo.get("CUBE_ATTR"))) {
				sql += " FROM ( SELECT ";
				sql += getSqlSelect(false);// 基础指标和基础维度select部分
				sql += getSqlFrom();// 基础指标和基础维度from部分
				sql += getSqlWhere();// 基础指标和基础维度where部分
				if ("DATAGRID".equals(this.component.getType())) {
					if ("1".equals(component.getTablesetsum())) {
						sql += getSqlGroup(false);// 分组部分
					}
				} else {
					sql += getSqlGroup(false);// 分组部分
				}
				sql += " )  " + mainTableAlias ;
				sql += getSqlFromDim();
			} else {
				sql += " FROM ";
				sql += getRelationPubDimSql();
			}
			sql += getKpiWhere();// 复合指标作为查询条件
			String ordFlag = "";
			if ("DATAGRID".equals(this.component.getType())) {
				if ("1".equals(this.component.getTableshowtotal())) {
					String totalSql = " SELECT 'A' AS ORD_CODE, ";
					totalSql += getTotalSelect(this.component);
					if("1".equals((String)cubeInfo.get("CUBE_ATTR"))) {
						totalSql += " FROM ( SELECT ";
						totalSql += getSqlSelect(false);// 基础指标和基础维度select部分
						totalSql += getSqlFrom();// 基础指标和基础维度from部分
						totalSql += getSqlWhere();// 基础指标和基础维度where部分
						if ("1".equals(component.getTablesetsum())) {
							totalSql += getSqlGroup(false);// 分组部分
						}
						totalSql += " )  " + mainTableAlias ;
						totalSql += getSqlFromDim();
					} else {
						totalSql += " FROM ";
						totalSql += getRelationPubDimSql();
					}
					totalSql += getKpiWhere();// 复合指标作为查询条件
					if (this.component.getTableshowtotalposition() != null
							&& "TOP".equals(this.component
									.getTableshowtotalposition().toUpperCase())) {
						sql = totalSql + " UNION ALL " + sql;
						ordFlag = " ASC ";
					} else {
						sql = sql + " UNION ALL " + totalSql;
						ordFlag = " DESC ";
					}
				}
			}
			if (!"".equals(ordFlag)) {
				if (getSqlOrder() == null || "".equals(getSqlOrder())) {
					sql = " SELECT * FROM ( " + sql + " ) TT "
							+ " ORDER BY ORD_CODE " + ordFlag;
				} else {
					sql = " SELECT * FROM ( " + sql + " ) TT "
							+ " ORDER BY ORD_CODE " + ordFlag + ","
							+ getSqlOrder();
				}
			} else {
				if (getSqlOrder() != null && !"".equals(getSqlOrder())) {
					sql += " ORDER BY " + getSqlOrder();// 排序部分
				}
			}
			map.put("content", sql);
			map.put("datasource", (String) cubeInfo.get("CUBE_DATASOURCE"));
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
		if (this.kpi.getDimensions() != null) {
			return this.kpi.getDimensions().getDimensionList();
		} else {
			return null;
		}
	}

	protected Dimension getDimension(String id) {
		if (getDimensions() != null && getDimensions().size() > 0) {
			for (Dimension dimension : getDimensions()) {
				if (id.equals(dimension.getId())) {
					return dimension;
				}
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

	/**
	 * 获取数据魔方的信息
	 * 
	 * @throws Exception
	 */
	protected void getCubeInfo() throws Exception {
//		String sql = " SELECT CUBE_DATASOURCE, CUBE_ATTR FROM X_KPI_CUBE WHERE CUBE_CODE=? ";
//		Connection conn = null;//
		String sql = "";
		SqlRunner queryRunner = null;
		try {
			queryRunner = new SqlRunner();
//			conn = dataSource.getConnection();
			Map<String,Object> params = new HashMap<String,Object>();
			params.put("cube_code", cube_code);
			sql = queryRunner.sql("kpi.sql.querySQLCube");
//			String[] params = new String[1];
//			params[0] = cube_code;
			cubeInfo = queryRunner.queryForMap(sql,params);
			relation = (String)cubeInfo.get("CUBE_ATTR");
			if ("1".equals(cubeInfo.get("CUBE_ATTR"))) {
//				sql = "SELECT DECODE(TABLE_NAME,NULL, 'KPI_COM',TABLE_NAME) AS TABLE_NAME,COLUMN_CODE,COLUMN_IDX FROM X_KPI_RAL_KEY WHERE CUBE_CODE=? ";
				sql = queryRunner.sql("kpi.sql.querySQLRalKey");
			} else if ("2".equals(cubeInfo.get("CUBE_ATTR"))) {
//				sql = "SELECT DECODE(TABLE_NAME,NULL, 'KPI_COM',TABLE_NAME) AS TABLE_NAME,COLUMN_CODE,ID AS COLUMN_IDX FROM X_KPI_RAL_DIM WHERE CUBE_CODE=?";
				sql = queryRunner.sql("kpi.sql.querySQLRalDim");
			} else {
//				sql = "SELECT DECODE(TABLE_NAME,NULL, 'KPI_COM',TABLE_NAME) AS TABLE_NAME,COLUMN_NAME AS COLUMN_CODE,COLUMN_IDX FROM X_KPI_RAL_ATTR WHERE CUBE_CODE=? ";
				sql = queryRunner.sql("kpi.sql.querySQLRalAttr");
			}
			relInfo = (List<Map<String, Object>>) queryRunner.queryForMapList(sql,params);
//			sql = " SELECT DECODE(RAL.TABLE_NAME,NULL, 'KPI_COM',RAL.TABLE_NAME) AS TABLE_NAME,RAL.COLUMN_CODE,RAL.DIM_ORD AS COLUMN_IDX FROM  X_KPI_DIM_CODE DIM ,X_KPI_RAL_DIM RAL WHERE DIM.DIM_CODE=RAL.DIM_CODE AND DIM.DIM_TYPE IN('D','M') AND CUBE_CODE=? ";
			sql = queryRunner.sql("kpi.sql.querySQLDimTable");
			attrInfo = (List<Map<String, Object>>) queryRunner.queryForMapList(sql,params);
			if(attrInfo == null || attrInfo.size() == 0) {
				sql = queryRunner.sql("kpi.sql.querySQLAttrTable");
//				sql = " SELECT DECODE(TABLE_NAME,NULL, 'KPI_COM',TABLE_NAME) AS TABLE_NAME,COLUMN_NAME AS COLUMN_CODE,COLUMN_IDX FROM X_KPI_RAL_ATTR WHERE  ATTR_TYPE IN('D','M') AND CUBE_CODE=? ";
				attrInfo = (List<Map<String, Object>>) queryRunner.queryForMapList(sql,params);
			}
		} catch (Exception e) {
			throw new Exception(e);
		} 
//		finally {
//			if (conn != null) {
//				conn.close();
//			}
//		}
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
			// String sql =
			// "select T.ID,T.DIM_TYPE,T.CONF_TYPE,T.DIM_OWNER,T.DIM_TABLE,T.DIM_FIELD,T.CONDITION,T.ID,T.DIM_CODE,T.DIM_NAME,T.SRC_ONWER,T.SRC_TABLE,T.SQL_CODE,(SELECT code FROM X_SUB_BASEDIM_INFO WHERE DIM_ID=T.ID AND NAME='code' AND ROWNUM=1) AS FIELD_CODE, (SELECT code FROM X_SUB_BASEDIM_INFO WHERE DIM_ID=T.ID AND NAME='name' AND ROWNUM=1) AS FIELD_NAME,(SELECT code FROM X_SUB_BASEDIM_INFO WHERE DIM_ID=T.ID AND NAME='ails' AND ROWNUM=1) AS FIELD_ORD from X_BASEDIM_INFO T where ID in ( ";
			String sql = "SELECT RAL.DIM_CODE,RAL.TABLE_NAME,RAL.COLUMN_CODE AS DIM_COLUMN,";
			sql += "RAL.COLUMN_DESC,DIM.CODE_TABLE_DESC AS DIM_NAME,DIM.CONF_TYPE,DIM.CODE_TABLE,";
			sql += "DIM.COLUMN_CODE,DIM.COLUMN_DESC,DIM.COLUMN_ORD,DIM.COLUMN_PARENT,DIM.CONDITION, ";
			sql += "DIM.DIM_DEFAULT,DIM.DIM_RIGHT,DIM.DIM_TYPE ";
			sql += "FROM X_KPI_RAL_DIM RAL, X_KPI_DIM_CODE DIM WHERE RAL.DIM_CODE = DIM.DIM_CODE ";
			sql += " AND RAL.CUBE_CODE= '" + this.cube_code + "' ";
			sql += " AND RAL.DIM_CODE IN ( ";
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
				int i = 1;
				for (Map<String, Object> map : results) {
					Map<String, Object> dimMap = new HashMap<String, Object>();
					String dimTable = "";
					String dimTableAlias = "";
					boolean isSql = false;
					if (map.get("CONF_TYPE") != null
							&& "1".equals(String.valueOf(map.get("CONF_TYPE")))) {
						dimTable = String.valueOf(map.get("CODE_TABLE"));
						// 判断如果是schema.table的那种
						if (dimTable.indexOf(".") != -1) {
							dimTableAlias = dimTable.substring(dimTable
									.indexOf(".") + 1);
						} else {
							dimTableAlias = dimTable.toUpperCase();
						}
						if (map.get("CONDITION") != null
								&& !"".equals(String.valueOf(map
										.get("CONDITION")))) {
							isSql = true;
							String conditon = String.valueOf(map
									.get("CONDITION"));
							// conditon = new
							// String(org.apache.commons.codec.binary.Base64.decodeBase64(conditon),
							// "UTF-8");
							dimTable = " (SELECT "
									+ String.valueOf(map.get("COLUMN_CODE"))
									+ ","
									+ String.valueOf(map.get("COLUMN_DESC"));
							if (map.get("COLUMN_ORD") != null
									&& !"".equals(String.valueOf(map
											.get("COLUMN_ORD")))) {
								dimTable = dimTable + ","
										+ map.get("COLUMN_ORD") + " ";
							}

							dimTable = dimTable + " FROM  "
									+ String.valueOf(map.get("CODE_TABLE"))
									+ " " // 定义维度where条件时已添加where
									+ conditon + ") ";
						}
					} else {
						isSql = true;
						dimTable = "(" + String.valueOf(map.get("CODE_TABLE"))
								+ ") ";
					}
					if (isSql) {
						dimTable = dimTable.toUpperCase();// 如果是SQL模式给别名
						dimMap.put("TABLENAME", dimTable);
						dimTableAlias = "DIM_TABLE_" + String.valueOf(i);//(String) map.get("DIM_CODE");
					} else {
						dimMap.put("TABLENAME", dimTable.toUpperCase());
					}
					dimMap.put("DIM_TABLE", map.get("TABLE_NAME"));
					dimMap.put("DIM_FIELD", map.get("DIM_COLUMN"));
					dimMap.put("FIELD_CODE", map.get("COLUMN_CODE"));
					dimMap.put("FIELD_NAME", map.get("COLUMN_DESC"));
					dimMap.put("FIELD_ORD", map.get("COLUMN_ORD"));
					dimMap.put("TABLE_ALIAS", dimTableAlias);
					dimMap.put("DIM_CODE", map.get("DIM_CODE"));
					dimMap.put("DIM_TYPE", "dim");
					dimMap.put("DIM_DEFAULT", map.get("DIM_DEFAULT"));
					dimMap.put("DIM_RIGHT", map.get("DIM_RIGHT"));
					dimMap.put("DIM_DATA_TYPE", map.get("DIM_TYPE"));
					baseDims.put(String.valueOf(map.get("DIM_CODE")), dimMap);
					i++;
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

	protected void getMetaBaseAttr() throws Exception {
		StringBuffer attr = new StringBuffer("");
		for (int i = 0; i < dims.size(); i++) {
			if (!dims.get(i).startsWith("BD_")) {
				attr.append(dims.get(i) + ",");
			}
		}
		for (int i = 0; i < wheres.size(); i++) {
			if ("property".equals(wheres.get(i).get("type"))) {
				attr.append(wheres.get(i).get("id") + ",");
			}
		}
		for (int i = 0; i < orders.size(); i++) {
			if ("property".equals(orders.get(i).get("type"))) {
				attr.append(orders.get(i).get("id") + ",");
			}
		}
		if (!"".equals(attr.toString())) {
			// String sql =
			// "select T.ID,T.DIM_TYPE,T.CONF_TYPE,T.DIM_OWNER,T.DIM_TABLE,T.DIM_FIELD,T.CONDITION,T.ID,T.DIM_CODE,T.DIM_NAME,T.SRC_ONWER,T.SRC_TABLE,T.SQL_CODE,(SELECT code FROM X_SUB_BASEDIM_INFO WHERE DIM_ID=T.ID AND NAME='code' AND ROWNUM=1) AS FIELD_CODE, (SELECT code FROM X_SUB_BASEDIM_INFO WHERE DIM_ID=T.ID AND NAME='name' AND ROWNUM=1) AS FIELD_NAME,(SELECT code FROM X_SUB_BASEDIM_INFO WHERE DIM_ID=T.ID AND NAME='ails' AND ROWNUM=1) AS FIELD_ORD from X_BASEDIM_INFO T where ID in ( ";
			String sql = "SELECT ATTR.ID,ATTR.TABLE_NAME,ATTR.COLUMN_NAME AS DIM_COLUMN,ATTR.COLUMN_DESC,ATTR.ATTR_TYPE ";
			sql += "FROM X_KPI_RAL_ATTR ATTR ";
			sql += " WHERE ATTR.CUBE_CODE= '" + this.cube_code + "' ";
			sql += " AND ATTR.ID IN ( ";
			Connection conn = null;//
			List<Map<String, Object>> results = null;
			QueryRunner queryRunner = null;
			String[] params = attr.toString().split(",");
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
					String dimTable = "";
					String dimTableAlias = "";
					if (map.get("TABLE_NAME") != null
							&& !"".equals(map.get("TABLE_NAME").toString())) {
						dimTable = map.get("TABLE_NAME").toString();
						if (dimTable.indexOf(".") != -1) {
							dimTableAlias = dimTable.substring(dimTable
									.indexOf(".") + 1);
						} else {
							dimTableAlias = dimTable.toUpperCase();
						}
					}
					dimMap.put("DIM_TABLE", dimTable);
					dimMap.put("DIM_FIELD", map.get("DIM_COLUMN"));
					dimMap.put("FIELD_CODE", "");
					dimMap.put("FIELD_NAME", "");
					dimMap.put("FIELD_ORD", "");
					dimMap.put("TABLE_ALIAS", dimTableAlias);
					dimMap.put("DIM_CODE", map.get("ID"));
					dimMap.put("ATTR_TYPE", map.get("ATTR_TYPE"));
					dimMap.put("DIM_TYPE", "attr");
					if(dimTable != null && !"".equals(dimTable)) {
						if (!baseKpiTables.contains(dimTable.toUpperCase())) {
							baseKpiTables.add(dimTable.toUpperCase());
						}
					}
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

	/**
	 * 获取基础基表信息
	 * 
	 * @throws Exception
	 */
	protected void getMetaBaseMeasures() throws Exception {
		Map<String, String> baseKpiAttrMap = new HashMap<String, String>();
		StringBuffer kpi = new StringBuffer("");
		for (int i = 0; i < kpis.size(); i++) {
			String baseKpi = kpis.get(i).get("COLUMN_ID");
			if (isBaseKpi(kpis.get(i).get("COLUMN_CODE"))) {
				if (baseKpi.indexOf("_") != -1) {
					String kpi_code = baseKpi.substring(0,
							baseKpi.lastIndexOf("_"));
					kpi.append(kpi_code + ",");
					if (baseKpiAttrMap.containsKey(kpi_code)) {
						String curBaseKpiAttr = baseKpiAttrMap.get(kpi_code);
						baseKpiAttrMap.put(
								kpi_code,
								curBaseKpiAttr
										+ ","
										+ baseKpi.substring(baseKpi
												.lastIndexOf("_") + 1));
					} else {
						baseKpiAttrMap
								.put(kpi_code, baseKpi.substring(baseKpi
										.lastIndexOf("_") + 1));
					}
				} else {
					kpi.append(baseKpi + ",");
					baseKpiAttrMap.put(baseKpi, "NONE_ATTR");
				}
			}
		}
		String baseKpiStr = "";
		for (int i = 0; i < wheres.size(); i++) {
			if ("kpi".equals(wheres.get(i).get("type"))) {
				String baseKpi = wheres.get(i).get("id");
				if (isBaseKpi(wheres.get(i).get("varname"))) {
					if (baseKpi.indexOf("_") != -1) {
						String kpi_code = baseKpi.substring(0,
								baseKpi.lastIndexOf("_"));
						kpi.append(kpi_code + ",");
						if (baseKpiAttrMap.containsKey(kpi_code)) {
							String curBaseKpiAttr = baseKpiAttrMap
									.get(kpi_code);
							baseKpiAttrMap.put(
									kpi_code,
									curBaseKpiAttr
											+ ","
											+ baseKpi.substring(baseKpi
													.lastIndexOf("_") + 1));
						} else {
							baseKpiAttrMap.put(kpi_code, baseKpi
									.substring(baseKpi.lastIndexOf("_") + 1));
						}
						baseKpiStr += "," + kpi_code + ",|";
					} else {
						kpi.append(baseKpi + ",");
						baseKpiAttrMap.put(baseKpi, "NONE_ATTR");
						baseKpiStr += "," + baseKpi + ",|";
					}
				}
			}
		}
		for (int i = 0; i < orders.size(); i++) {
			if ("kpi".equals(orders.get(i).get("type"))) {
				String baseKpi = orders.get(i).get("id");
				if (isBaseKpi(orders.get(i).get("col"))) {
					if (baseKpi.indexOf("_") != -1) {
						String kpi_code = baseKpi.substring(0,
								baseKpi.lastIndexOf("_"));
						kpi.append(kpi_code + ",");
						if (baseKpiAttrMap.containsKey(kpi_code)) {
							String curBaseKpiAttr = baseKpiAttrMap
									.get(kpi_code);
							baseKpiAttrMap.put(
									kpi_code,
									curBaseKpiAttr
											+ ","
											+ baseKpi.substring(baseKpi
													.lastIndexOf("_") + 1));
						} else {
							baseKpiAttrMap.put(kpi_code, baseKpi
									.substring(baseKpi.lastIndexOf("_") + 1));
						}
					} else {
						kpi.append(baseKpi + ",");
						baseKpiAttrMap.put(baseKpi, "NONE_ATTR");
					}
				}
			}
		}
		if (!"".equals(kpi.toString())) {
			String sql = " SELECT ID,BASE_KEY,KPI_ORIGIN_SCHEMA,KPI_ORIGIN_TABLE,KPI_ORIGIN_COLUMN,KPI_CONDITION,KPI_NAME,TYPE,KPI_UNIT from X_BASE_KPI where ID in ( ";
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
				conn = dataSource.getConnection();
				results = queryRunner.query(conn, sql, params,
						new MapListHandler());
				// 处理结果集
				for (Map<String, Object> map : results) {
					String kpiTable = String.valueOf(map
							.get("KPI_ORIGIN_TABLE"));
					String kpiOwner = "";
					if (map.get("KPI_ORIGIN_SCHEMA") != null
							&& !"".equals(String.valueOf(map
									.get("KPI_ORIGIN_SCHEMA")))) {
						kpiTable = String.valueOf(map.get("KPI_ORIGIN_SCHEMA"))
								+ "." + kpiTable;
						kpiOwner = String.valueOf(map.get("KPI_ORIGIN_SCHEMA"));
					}
					String kpiId = String.valueOf(map.get("ID"));
					Map<String, Object> kpiMap = new HashMap<String, Object>();
					kpiMap.put("KPI_KEY", kpiId);
					if(baseKpiStr.indexOf("," + kpiId + ",") != -1 ) {
						kpiMap.put("KPI_WHERE", "1");
					} else {
						kpiMap.put("KPI_WHERE", "0");
					}
					kpiMap.put("KPI_CODE", map.get("BASE_KEY"));
					kpiMap.put("KPI_TYPE", map.get("TYPE"));// 先默认写死为4
					kpiMap.put("KPIOWNER", kpiOwner);
					kpiMap.put("KPI_NAME", map.get("KPI_NAME"));
					kpiMap.put("TABLENAME", kpiTable.toUpperCase());
					kpiMap.put("KPICOLUMN", map.get("KPI_ORIGIN_COLUMN"));
					kpiMap.put("SOURCE_COLUMN", kpiTable.toUpperCase() + "."
							+ String.valueOf(map.get("KPI_ORIGIN_COLUMN")));
					kpiMap.put("FRM1", "");
					kpiMap.put("FRM2", "");
					kpiMap.put("FRM3", "");
					String kpi_unit = (String)map.get("KPI_UNIT");
					if(kpi_unit != null && !"".equals(kpi_unit)) {
						Map<String,Object> frmMap = this.getKpiFrm(kpi_unit);
						if(frmMap != null) {
							kpiMap.put("FRM1", frmMap.get("ATTR1"));
							kpiMap.put("FRM2", frmMap.get("ATTR2"));
							kpiMap.put("FRM3", frmMap.get("ATTR3"));
						}
					}
					baseKpis.put(kpiId, kpiMap);
					if (baseKpiAttrMap.get(map.get("ID")) != null
							&& !"NONE_ATTR"
									.equals(String.valueOf(baseKpiAttrMap
											.get(map.get("ID"))))) {
						String[] attrs = null;
						String kpiAttr = String.valueOf(baseKpiAttrMap.get(map
								.get("ID")));
						attrs = kpiAttr.split(",");
						if (attrs != null && attrs.length > 0) {
							for (String s : attrs) {
								kpiId = String.valueOf(map.get("ID"));
								kpiMap = new HashMap<String, Object>();
								kpiMap.put("KPI_TYPE", map.get("TYPE"));// 先默认写死为4
								kpiMap.put("KPIOWNER", kpiOwner);
								kpiMap.put("KPI_NAME", map.get("KPI_NAME"));
								kpiMap.put("TABLENAME", kpiTable.toUpperCase());
								kpiMap.put("KPI_CODE", map.get("BASE_KEY"));
								kpiMap.put("KPICOLUMN",
										map.get("KPI_ORIGIN_COLUMN"));
								kpiMap.put(
										"SOURCE_COLUMN",
										kpiTable.toUpperCase()
												+ "."
												+ String.valueOf(map
														.get("KPI_ORIGIN_COLUMN")));
								if (!"A".equals(s)) {
									kpiId = kpiId + "_" + s;
									kpiMap.put("KPI_CODE",
											String.valueOf(map.get("BASE_KEY"))
													+ "_" + s);
									kpiMap.put(
											"KPICOLUMN",
											String.valueOf(map
													.get("KPI_ORIGIN_COLUMN"))
													+ "_" + s);
									kpiMap.put(
											"SOURCE_COLUMN",
											kpiTable.toUpperCase()
													+ "."
													+ String.valueOf(map
															.get("KPI_ORIGIN_COLUMN"))
													+ "_" + s);
								}
								kpiMap.put("KPI_KEY", kpiId);
								baseKpis.put(kpiId, kpiMap);
							}
						}
					}
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
		for (Map<String, String> kpi : kpis) {
			if (!isBaseKpi(kpi.get("COLUMN_CODE"))) {
				if (!formKpis.contains(kpi)) {
					fk.append(kpi.get("COLUMN_ID").split("_")[0] + ",");
					formKpis.add(kpi.get("COLUMN_ID"));
				}
			}
		}
		for (Map<String, String> map : wheres) {
			if ("kpi".equals(map.get("type"))) {
				if (!isBaseKpi(map.get("varname"))) {
					if (!formKpis.contains(map.get("id"))) {
						fk.append(map.get("id").split("_")[0] + ",");
						formKpis.add(map.get("id"));
					}
				}
			}
		}
		for (Map<String, String> map : orders) {
			if ("kpi".equals(map.get("type"))) {
				if (!isBaseKpi(map.get("col"))) {
					if (!formKpis.contains(map.get("id"))) {
						fk.append(map.get("id").split("_")[0] + ",");
						formKpis.add(map.get("id"));
					}
				}
			}
		}
		if (!"".equals(fk.toString())) {
			Connection conn = null;//
			QueryRunner queryRunner = null;
			try {
				if (formKpis.size() > 0) {
					queryRunner = new QueryRunner();
					String sql = "SELECT KPI_NAME,KPI_KEY,KPI_CODE,KPI_TYPE,KPI_BODY,KPI_OWNER,KPI_TABLE,KPI_COLUMN,ACCTTYPE,KPI_NUIT from X_KPI_INFO ";
					sql += " WHERE CUBE_CODE='" + cube_code
							+ "' AND KPI_KEY IN ( ";
					conn = dataSource.getConnection();
					String[] params = fk.toString().split(",");
					for (int i = 0; i < params.length; i++) {
						sql = sql + "?,";
					}
					sql = sql.substring(0, sql.length() - 1);
					sql = sql + ")";
					List<Map<String, Object>> results = queryRunner.query(conn,
							sql, params, new MapListHandler());
					// 处理结果集
					for (Map<String, Object> map : results) {
						Map<String, Object> kpiMap = new HashMap<String, Object>();
						String kpiTable = "";
						if (map.get("KPI_TABLE") != null
								&& !"".equals(String.valueOf(map
										.get("KPI_TABLE"))))
							kpiTable = String.valueOf(map.get("KPI_TABLE"));
						String kpiColumn = "";
						if (map.get("KPI_COLUMN") != null
								&& !"".equals(String.valueOf(map
										.get("KPI_COLUMN"))))
							kpiColumn = String.valueOf(map.get("KPI_COLUMN"));
						String kpiOwner = "";
						if (map.get("KPI_OWNER") != null
								&& !"".equals(String.valueOf(map
										.get("KPI_OWNER"))))
							kpiOwner = String.valueOf(map.get("KPI_OWNER"));
						kpiMap.put("KPI_KEY", map.get("KPI_KEY"));
						kpiMap.put("KPI_CODE", map.get("KPI_CODE"));
						kpiMap.put("KPI_TYPE", map.get("KPI_TYPE"));
						kpiMap.put("KPIOWNER", kpiOwner);
						kpiMap.put("KPI_NAME", map.get("KPI_NAME"));
						kpiMap.put("TABLENAME", kpiTable.toUpperCase());
						kpiMap.put("KPICOLUMN", kpiColumn.toUpperCase());
						kpiMap.put("KPI_BODY", map.get("KPI_BODY"));
						for (String kpi_attr : formKpis) {
							if (kpi_attr.indexOf("_") != -1) {
								if (kpi_attr.split("_")[0].equals(String
										.valueOf(map.get("KPI_KEY")))) {
									kpiMap.put("KPI_ATTR",
											kpi_attr.split("_")[1]);
									break;
								}
							} else {
								kpiMap.put("KPI_ATTR", "");
							}
						}
						kpiMap.put("FRM1", "");
						kpiMap.put("FRM2", "");
						kpiMap.put("FRM3", "");
						String kpi_unit = (String)map.get("KPI_NUIT");
						if(kpi_unit != null && !"".equals(kpi_unit)) {
							Map<String,Object> frmMap = this.getKpiFrm(kpi_unit);
							if(frmMap != null) {
								kpiMap.put("FRM1", frmMap.get("ATTR1"));//精度
								kpiMap.put("FRM2", frmMap.get("ATTR2"));//百分比
								kpiMap.put("FRM3", frmMap.get("ATTR3"));
							}
						}
						String kpiBody = this.ClobToString(map.get("KPI_BODY"));
						kpiMap.put(
								"SOURCE_COLUMN",
								parseBaseKpi(kpiBody, map.get("KPI_KEY")
										.toString()));
 						kpiMap.put(
								"SOURCE_COLUMN_FORMULAS",
								parseFormKpiFormulas(kpiBody,
										map.get("KPI_KEY").toString(),kpiMap).get(
										"SQL2"));
						kpiMap.put(
								"HAVING_COLUMN",
								parseFormKpiFormulas(kpiBody,
										map.get("KPI_KEY").toString(),kpiMap).get(
										"SQL1"));
						kpiMap.put("WHERE_COLUMN", parseFormKpiFormulas(kpiBody,
										map.get("KPI_KEY").toString(),kpiMap).get(
										"SQL3"));
						kpiMap.put(
								"SOURCE_COLUMN_FORMULAS_SUM",
								parseFormKpiFormulas(kpiBody,
										map.get("KPI_KEY").toString(),kpiMap).get(
										"SQL4"));
						formKpisMap.put(String.valueOf(map.get("KPI_KEY")),
								kpiMap);
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

	protected String parseBaseKpi(String kpiBody, String kpi_key)
			throws Exception {
		Kpi kpi = parseXMLToKpi(kpiBody);// 获取复合指标的组成结构体
		String sql = parseKpi(kpi, kpi_key);// 基础指标SQL
		return sql;
	}

	protected void parseFormKpi(String kpiBody) throws Exception {
		Kpi kpi = parseXMLToKpi(kpiBody);// 获取复合指标的组成结构体
		Measures measures = kpi.getMeasures();
		Connection conn = null;//
		QueryRunner queryRunner = null;
		StringBuffer fk = new StringBuffer("");
		try {
			queryRunner = new QueryRunner();
			String sql = "select KPI_NAME,KPI_KEY,KPI_CODE,KPI_TYPE,KPI_BODY,KPI_OWNER,KPI_TABLE,KPI_COLUMN,ACCTTYPE from X_KPI_INFO ";
			sql += " WHERE CUBE_CODE='" + cube_code + "' AND KPI_KEY in ( ";
			for (Measure measure : measures.getMeasureList()) {
				if (measure.getId().startsWith("FK_")) {
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
			List<Map<String, Object>> results = queryRunner.query(conn, sql,
					params, new MapListHandler());
			// 处理结果集
			for (Map<String, Object> map : results) {
				Map<String, Object> kpiMap = new HashMap<String, Object>();
				String kpiTable = "";
				if (map.get("KPI_TABLE") != null
						&& !"".equals(String.valueOf(map.get("KPI_TABLE"))))
					kpiTable = String.valueOf(map.get("KPI_TABLE"));
				String kpiColumn = "";
				if (map.get("KPI_COLUMN") != null
						&& !"".equals(String.valueOf(map.get("KPI_COLUMN"))))
					kpiColumn = String.valueOf(map.get("KPI_COLUMN"));
				String kpiOwner = "";
				if (map.get("KPI_OWNER") != null
						&& !"".equals(String.valueOf(map.get("KPI_OWNER"))))
					kpiOwner = String.valueOf(map.get("KPI_OWNER"));
				kpiMap.put("KPI_KEY", map.get("KPI_KEY"));
				kpiMap.put("KPI_CODE", map.get("KPI_CODE"));
				kpiMap.put("KPI_TYPE", map.get("KPI_TYPE"));
				kpiMap.put("KPIOWNER", kpiOwner);
				kpiMap.put("KPI_NAME", map.get("KPI_NAME"));
				kpiMap.put("TABLENAME", kpiTable.toUpperCase());
				kpiMap.put("KPICOLUMN", kpiColumn.toUpperCase());
				kpiMap.put("KPI_BODY", map.get("KPI_BODY"));
				for (Measure measure : measures.getMeasureList()) {
					if (measure.getKpiKey().split("_")[0].equals(String
							.valueOf(map.get("KPI_KEY")))) {
						kpiMap.put("KPI_ATTR", measure.getId().split("_")[2]);
						break;
					}
				}
				kpiMap.put(
						"SOURCE_COLUMN",
						parseBaseKpi(ClobToString(map.get("KPI_BODY")),
								(String) map.get("KPI_KEY")));
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
	 * 获取指标的单位信息
	 * @param kpi_unit
	 * @return
	 * @throws Exception
	 */
	protected Map<String,Object> getKpiFrm(String kpi_unit) throws Exception {
		Connection conn = null;//
		QueryRunner queryRunner = null;
		Map<String,Object> unitAttr = null;
		try {
			queryRunner = new QueryRunner();
			conn = dataSource.getConnection();
			unitAttr = queryRunner.query(conn,formatterSql, kpi_unit, new MapHandler());
		}catch (Exception e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			if (conn != null)
				conn.close();
		}
		return unitAttr;
	}
	/**
	 * 获取基础指标和维度的SELECT部分
	 * 
	 * @param isAll
	 * @return
	 * @throws Exception
	 */
	protected String getSqlSelect(boolean isAll) throws Exception {
		useKpiList = new ArrayList<String>();
		StringBuffer sql = new StringBuffer("");
		// 维度部分
		for (int i = 0; i < dims.size(); i++) {
			String dim = dims.get(i);
			if (!baseDims.containsKey(dim)) {
				continue;
				//throw new Exception("基础维度[" + dim + "]已移除，或者尚未定义");
			}
			// dim代表维度，attr代表属性，如果是标签只从事实表中取字段
			if ("dim".equals((String) baseDims.get(dim).get("DIM_TYPE"))) {
				String dim_data_type = (String )baseDims.get(dim).get("DIM_DATA_TYPE");
				if(dim_data_type == null || "T".equals(dim_data_type)||"".equals(dim_data_type)) {
					String codeAlias = (String) baseDims.get(dim).get("DIM_FIELD")
							+ "_CODE";
					String descAlias = (String) baseDims.get(dim).get("DIM_FIELD");
					if (alias != null && alias.size() > 0) { // 添加下钻的别名
						if (dim.equals(alias.get("id"))) {
							codeAlias = alias.get("code");
							descAlias = alias.get("name");
						}
					}
					if (!isAll) {
						sql.append(mainTable + "." + baseDims.get(dim).get("DIM_FIELD") + ","); 
//						sql.append(codeAlias + ",");
					} else {
						sql.append(baseDims.get(dim).get("TABLE_ALIAS") + "."
								+ baseDims.get(dim).get("FIELD_NAME") + " AS "
								+ descAlias + ",");
						sql.append(baseDims.get(dim).get("TABLE_ALIAS") + "."
								+ baseDims.get(dim).get("FIELD_CODE") + " AS "
								+ codeAlias + ",");
					}
				} else {
					if (!isAll) {
						sql.append(mainTable + "." + baseDims.get(dim).get("DIM_FIELD") + " AS "
								+  baseDims.get(dim).get("DIM_FIELD") + ","); 
					} else {
						sql.append(baseDims.get(dim).get("DIM_FIELD") + ",");
					}
				}
			} else {
				// for (int j = 0; j < baseKpiTables.size(); j++) {
				if (!isAll) {
					sql.append(mainTable + "." + baseDims.get(dim).get("DIM_FIELD") + " AS "
							+  baseDims.get(dim).get("DIM_FIELD") + ","); 
				} else {
					sql.append(baseDims.get(dim).get("DIM_FIELD") + ",");
				}
				// }
			}
		}
		// 基础指标部分
		int k = 0;
		for (Map.Entry<String, Map<String, Object>> entry : baseKpis.entrySet()) {
			String frm1 = (String) entry.getValue().get("FRM1");
			String frm2 = (String) entry.getValue().get("FRM2");
			String frm3 = (String) entry.getValue().get("FRM3");
			String tableName = (String) entry.getValue().get("TABLENAME");
			String tableAlias = tableName;
			if(tableName.indexOf(".") > 0) {
				tableAlias = tableName.substring(tableName.indexOf(".") +1);
			} 
			//if("0".equals((String) entry.getValue().get("KPI_WHERE"))) { //除查询条件之外的
				if (k == baseKpis.size() - 1) {
					if (isAll) {
						if(!useKpiList.contains((String) entry.getValue().get("KPI_CODE"))){
							if("1".equals((String)cubeInfo.get("CUBE_ATTR"))) {
								sql.append(" "
										+ formateSql(frm1,frm2,frm3,(String)entry.getValue().get("KPI_CODE")) + " AS " + entry.getValue().get("KPI_CODE")
										+ " ");
							} else {
								sql.append(" "
										+ formateSql(frm1,frm2,frm3,tableAlias + "." + (String)entry.getValue().get("KPI_CODE")) + " AS " + entry.getValue().get("KPI_CODE")
										+ " ");
								
							}
						
							useKpiList.add((String)entry.getValue().get("KPI_CODE"));
						}
					} else {
						if(!useKpiList.contains((String) entry.getValue().get("SOURCE_COLUMN"))){
							if ("DATAGRID".equals(this.component.getType())) {
								if ("1".equals(component.getTablesetsum())) {
									sql.append("SUM(" + entry.getValue().get("SOURCE_COLUMN")
											+ ") AS " + entry.getValue().get("KPI_CODE"));
								} else {
									sql.append(entry.getValue().get("SOURCE_COLUMN")
											+ " AS " + entry.getValue().get("KPI_CODE"));
								}
							} else {
								sql.append("SUM(" + entry.getValue().get("SOURCE_COLUMN")
										+ ") AS " + entry.getValue().get("KPI_CODE"));
							}
							useKpiList.add((String)entry.getValue().get("SOURCE_COLUMN"));
						}
					}
				} else {
					if (isAll) {
						if(!useKpiList.contains((String) entry.getValue().get("KPI_CODE"))){
							if("1".equals((String)cubeInfo.get("CUBE_ATTR"))) {
								sql.append(" "
										+ formateSql(frm1,frm2,frm3,(String)entry.getValue().get("KPI_CODE")) + " AS " + entry.getValue().get("KPI_CODE")
										+ ",");
							} else {
								sql.append(" "
										+ formateSql(frm1,frm2,frm3,tableAlias + "." + (String)entry.getValue().get("KPI_CODE")) + " AS " + entry.getValue().get("KPI_CODE")
										+ ",");
							}

							useKpiList.add((String)entry.getValue().get("KPI_CODE"));
						}
					} else {
						if(!useKpiList.contains((String) entry.getValue().get("SOURCE_COLUMN"))){
							if ("DATAGRID".equals(this.component.getType())) {
								if ("1".equals(component.getTablesetsum())) {
									sql.append("SUM(" + entry.getValue().get("SOURCE_COLUMN")
											+ ") AS " + entry.getValue().get("KPI_CODE") + ",");
								} else {
									sql.append(entry.getValue().get("SOURCE_COLUMN")
											+ " AS " + entry.getValue().get("KPI_CODE") + ",");
								}
							} else {
								sql.append("SUM(" + entry.getValue().get("SOURCE_COLUMN")
										+ ") AS " + entry.getValue().get("KPI_CODE") + ",");
							}
							useKpiList.add((String)entry.getValue().get("SOURCE_COLUMN"));
						}
					}
				}
			//}
			k++;
		}
		if(!"".equals(sql.toString())) {
			if (",".equals(sql.toString().substring(sql.toString().length() - 1))) {
				sql = new StringBuffer(sql.toString().substring(0,
						sql.toString().length() - 1));
			}
		}
		k = 0;
		// 复合指标
		for (Map.Entry<String, Map<String, Object>> entry : formKpisMap
				.entrySet()) {
			if (isAll) {
				sql.append(", "
						+ entry.getValue().get("SOURCE_COLUMN_FORMULAS"));
			} else {
				sql.append(", " + entry.getValue().get("SOURCE_COLUMN"));
			}
			k++;
		}
		if(!"".equals(sql.toString())) {
			if (",".equals(sql.toString().substring(0,1))) {
				sql = new StringBuffer(sql.toString().substring(1));
			}
		}
		return sql.toString();
	}

	public String getTotalSelect(Component component) throws Exception {
		StringBuffer sql = new StringBuffer("");
		// 维度部分
		
		for (int i = 0; i < dims.size(); i++) {
			String dim = dims.get(i);
			if (!baseDims.containsKey(dim)) {
				continue;
//				throw new Exception("基础维度[" + dim + "]已移除，或者尚未定义");
			}
			String text = " '--' ";
			
			// 判断第一列显示“合计”
			List<Datacol> datacols = component.getDatastore().getDatacolList();
			for (Datacol datacol : datacols) {
				if (dim.equals(datacol.getDatacolid())) {
					if (datacol.getTablecolcode() != null
							&& "A".equals(datacol.getTablecolcode()
									.toUpperCase())) {
						text = " '"+ component.getTableshowtotalname() +"' ";
					}
				}
			}
			// dim代表维度，attr代表属性，如果是标签只从事实表中取字段
			if ("dim".equals((String) baseDims.get(dim).get("DIM_TYPE"))) {
				String codeAlias = (String) baseDims.get(dim).get("DIM_FIELD")
						+ "_CODE";
				String descAlias = (String) baseDims.get(dim).get("DIM_FIELD");
				if (alias != null && alias.size() > 0) { // 添加下钻的别名
					if (dim.equals(alias.get("id"))) {
						codeAlias = alias.get("code");
						descAlias = alias.get("name");
					}
				}
				sql.append(text + " AS " + descAlias + ",");
				sql.append(" '' AS " + codeAlias + ",");
			} else {
				for (int j = 0; j < baseKpiTables.size(); j++) {
					sql.append(text + "AS "
							+ baseDims.get(dim).get("DIM_FIELD") + ",");
				}
			}
		}
		// 基础指标部分
		int k = 0;
		for (Map.Entry<String, Map<String, Object>> entry : baseKpis.entrySet()) {
			if (k == baseKpis.size() - 1) {
				if (sql.toString().indexOf(
						(String) entry.getValue().get("KPI_CODE")) == -1) {
					if ("DATAGRID".equals(this.component.getType())) {
						if ("1".equals(component.getTablesetsum())) {
							sql.append("SUM("
									+ entry.getValue().get("KPI_CODE")
									+ ") AS "
									+ entry.getValue().get("KPI_CODE") + " ");
						} else {
							sql.append(" " + entry.getValue().get("KPI_CODE")
									+ " ");
						}
					} else {
						sql.append("SUM(" + entry.getValue().get("KPI_CODE")
								+ ") AS " + entry.getValue().get("KPI_CODE")
								+ " ");
					}
				}
			} else {
				if (sql.toString().indexOf(
						(String) entry.getValue().get("KPI_CODE")) == -1) {
					if ("DATAGRID".equals(this.component.getType())) {
						if ("1".equals(component.getTablesetsum())) {
							sql.append("SUM("
									+ entry.getValue().get("KPI_CODE")
									+ ") AS "
									+ entry.getValue().get("KPI_CODE") + ",");
						} else {
							sql.append(" " + entry.getValue().get("KPI_CODE")
									+ ",");
						}
					} else {
						sql.append("SUM(" + entry.getValue().get("KPI_CODE")
								+ ") AS " + entry.getValue().get("KPI_CODE")
								+ ",");
					}
				}
			}
			k++;
		}
		if (",".equals(sql.toString().substring(sql.toString().length() - 1))) {
			sql = new StringBuffer(sql.toString().substring(0,
					sql.toString().length() - 1));
		}
		k = 0;
		// 复合指标
		for (Map.Entry<String, Map<String, Object>> entry : formKpisMap
				.entrySet()) {
			sql.append(" , " + entry.getValue().get("SOURCE_COLUMN_FORMULAS_SUM"));
			k++;
		}
		return sql.toString();
	}

	protected String getKpiWhere() throws Exception {
		String sql = "";
		if (havingList.size() > 0 && havingList.get(0).size() > 0) {
			sql = " where 1=1 ";
			for (Map<String, String> havingMap : havingList) {
				String column = (String)formKpisMap.get(havingMap.get("id")).get("WHERE_COLUMN");
				String varName = (String)formKpisMap.get(havingMap.get("id")).get("KPI_CODE");
				String var_name_type = havingMap.get("varnametype");
				if ("06".equals(havingMap.get("formula"))) {
					sql += " {and " + column + " >=#";
					sql += varName + "_1#} {and " + column;
					sql += "<= #" + varName + "_2#}";
				} else if ("10".equals(havingMap.get("formula"))) {
					sql += " {and " + column + " >#";
					sql += varName + "_1#} {and " + column;
					sql += "< #" + varName + "_2#}";
				} else if ("11".equals(havingMap.get("formula"))) {
					sql += " {and " + column + " >=#";
					sql += varName + "_1#} {and " + column;
					sql += "< #" + varName + "_2#}";
				} else if ("12".equals(havingMap.get("formula"))) {
					sql += " {and " + column + " >#";
					sql += varName + "_1#} {and " + column;
					sql += "<= #" + varName + "_2#}";
				} else if ("07".equals(havingMap.get("formula"))) {
					sql += " {and " + column + " like concat(concat('%',#" + varName + "#),'%')}";
				} else if ("08".equals(havingMap.get("formula"))) {
					sql += " {and " + column + " not like concat(concat('%',#" + varName + "#),'%')}";
				} else if ("09".equals(havingMap.get("formula"))) {
					sql += " {and " + column + " in(#" + varName + "#)}";
				} else {
					if ("1".equals(havingMap.get("multiple"))) { // 多选
						sql += " {and " + column + " in (#" + varName + "#)} ";
					} else {
						sql += " {and " + column;
						sql += this.opter(havingMap.get("formula")) + "#" + varName + "#}";
					}
				}
			}
		}
		return sql;
	}

	/**
	 * 获取表表中使用的所有表，并定义from部分
	 * 
	 * @return
	 * @throws Exception
	 */
	protected String getSqlFrom() throws Exception {
		StringBuffer sql = new StringBuffer(" FROM ");
		Map<String, String> ralTable = getRelationSql();
		String mainTable = ralTable.get("main");
		sql.append(" " + mainTable + " ");
		sql.append(ralTable.get("sql")); 
		return sql.toString();
	}

	protected String getSqlFromDim() throws Exception {
		StringBuffer sql = new StringBuffer("");
		Map<String, ArrayList<Map<String, Object>>> dimTable = new HashMap<String, ArrayList<Map<String, Object>>>();
		for (int i = 0; i < dims.size(); i++) {
			for (Map.Entry<String, Map<String, Object>> baseDim : baseDims
					.entrySet()) {
				if(dims.get(i).equals(baseDim.getKey())) {
					String  dim_data_type = (String)baseDim.getValue().get("DIM_DATA_TYPE");
					if(dim_data_type == null || "T".equals(dim_data_type) || "".equals(dim_data_type)) {
						if ("dim".equals(baseDim.getValue().get("DIM_TYPE"))) {
							if (dimTable.containsKey((String) baseDim.getValue().get(
									"TABLENAME"))) {
								ArrayList<Map<String, Object>> list = dimTable
										.get((String) baseDim.getValue().get("TABLENAME"));
								list.add(baseDim.getValue());
								dimTable.put((String) baseDim.getValue().get("TABLENAME"),
										list);
							} else {
								ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
								list.add(baseDim.getValue());
								dimTable.put((String) baseDim.getValue().get("TABLENAME"),
										list);
							}
						}
					}
				}
			}
		}
		
		for (Map.Entry<String, ArrayList<Map<String, Object>>> dim : dimTable
				.entrySet()) {
			sql.append(" INNER JOIN ");
			int k = 0;
			String str = " ( SELECT ";
			String group = "";
			String where = "";
			String alias = "";
			for (Map<String, Object> dm : dim.getValue()) {
				alias = (String) dm.get("TABLE_ALIAS");
				if (k == 0) {
					where += mainTableAlias + "." + dm.get("DIM_FIELD") + "="
							+ dm.get("TABLE_ALIAS") + "."
							+ dm.get("FIELD_CODE") + " ";
				} else {
					where += " and " + mainTableAlias + "." + dm.get("DIM_FIELD")
							+ "=" + dm.get("TABLE_ALIAS") + "."
							+ dm.get("FIELD_CODE") + " ";
				}
				if (k == dim.getValue().size() - 1) {
					str += dm.get("FIELD_CODE") + "," + dm.get("FIELD_NAME");
					group += dm.get("FIELD_CODE") + "," + dm.get("FIELD_NAME");
				} else {
					group += dm.get("FIELD_CODE") + "," + dm.get("FIELD_NAME")
							+ ",";
					str += dm.get("FIELD_CODE") + "," + dm.get("FIELD_NAME")
							+ ",";
				}
				k++;
			}
			str = str + " from " + dim.getKey() + " group by " + group + ") "
					+ alias + " ON " + where;
			sql.append(str);
		}
		return sql.toString();
	}
	/**
	 * 多表关联（主键模式)
	 * 
	 * @return
	 * @throws Exception
	 */
	private Map<String, String> getRelationSql() throws Exception {
		Map<String, String> tableSql = new HashMap<String, String>();
		// 多表关联部分
		String mainTable = baseKpiTables.get(0);
		tableSql.put("main", mainTable);
		if (baseKpiTables.size() == 1) {
			tableSql.put("sql", "");
		} else {
			StringBuffer sql = new StringBuffer("");
			// relInfo.get("TABLE_NAME");
			// relInfo.get("COLUMN_CODE");
			// KPI_COM
			List<Map<String, Object>> myCommon = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> mainTableInfo = new ArrayList<Map<String, Object>>();
			// 设置通用、主表信息
			Map<String, List<Map<String, Object>>> allTables = new HashMap<String, List<Map<String, Object>>>();
			for (Map<String, Object> maps : relInfo) {
				if ("KPI_COM".equals(maps.get("TABLE_NAME"))) {
					myCommon.add(maps);
				}
				if (mainTable.equals(maps.get("TABLE_NAME"))) {
					mainTableInfo.add(maps);
				}
			}
			for (int i = 1; i < baseKpiTables.size(); i++) {
				List<Map<String, Object>> other = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> maps : relInfo) {
					if (baseKpiTables.get(i).equals(
							maps.get("TABLE_NAME").toString())) {
						other.add(maps);
					}
				}
				if (other.size() > 0) {
					allTables.put(baseKpiTables.get(i), other);
				}
			}
			// sql.append(" INNER JOIN " + baseKpiTables.get(i) + " ON ");
			// boolean flag = false;
			for (int i = 1; i < baseKpiTables.size(); i++) {
				boolean flag = false;
				sql.append(" INNER JOIN " + baseKpiTables.get(i) + " ON ");
				if (allTables.containsKey(baseKpiTables.get(i))) {
					if (mainTableInfo != null && mainTableInfo.size() > 0) {
						int size = mainTableInfo.size() > allTables.get(
								baseKpiTables.get(i)).size() ? allTables.get(
								baseKpiTables.get(i)).size() : mainTableInfo
								.size();
						for (int j = 0; j < size; j++) {
							if (j == size - 1) {
								sql.append(" "
										+ mainTableInfo.get(j)
												.get("TABLE_NAME")
										+ "."
										+ mainTableInfo.get(j).get(
												"COLUMN_CODE") + " = ");
								sql.append(" "
										+ allTables.get(baseKpiTables.get(i))
												.get(j).get("TABLE_NAME")
										+ "."
										+ allTables.get(baseKpiTables.get(i))
												.get(j).get("COLUMN_CODE"));
							} else {
								sql.append(" "
										+ mainTableInfo.get(j)
												.get("TABLE_NAME")
										+ "."
										+ mainTableInfo.get(j).get(
												"COLUMN_CODE") + " = ");
								sql.append(" "
										+ allTables.get(baseKpiTables.get(i))
												.get(j).get("TABLE_NAME")
										+ "."
										+ allTables.get(baseKpiTables.get(i))
												.get(j).get("COLUMN_CODE")
										+ " AND ");
							}
							flag = true;
						}
					} else {
						int size = myCommon.size() > allTables.get(
								baseKpiTables.get(i)).size() ? allTables.get(
								baseKpiTables.get(i)).size() : myCommon.size();
						for (int j = 0; j < size; j++) {
							if (j == size - 1) {
								sql.append(" " + mainTable + "."
										+ myCommon.get(j).get("COLUMN_CODE")
										+ " = ");
								sql.append(" "
										+ allTables.get(baseKpiTables.get(i))
												.get(j).get("TABLE_NAME")
										+ "."
										+ allTables.get(baseKpiTables.get(i))
												.get(j).get("COLUMN_CODE"));
							} else {
								sql.append(" " + mainTable + "."
										+ myCommon.get(j).get("COLUMN_CODE")
										+ " = ");
								sql.append(" "
										+ allTables.get(baseKpiTables.get(i))
												.get(j).get("TABLE_NAME")
										+ "."
										+ allTables.get(baseKpiTables.get(i))
												.get(j).get("COLUMN_CODE")
										+ " AND ");
							}
							flag = true;
						}
					}
				} else {
					if (mainTableInfo != null && mainTableInfo.size() > 0) {
						int size = mainTableInfo.size() > myCommon.size() ? myCommon
								.size() : mainTableInfo.size();
						for (int j = 0; j < size; j++) {
							if (j == size - 1) {
								sql.append(" "
										+ mainTableInfo.get(j)
												.get("TABLE_NAME")
										+ "."
										+ mainTableInfo.get(j).get(
												"COLUMN_CODE") + " = ");
								sql.append(" "
										+ baseKpiTables.get(i)
										+ "."
										+ mainTableInfo.get(j).get(
												"COLUMN_CODE"));
							} else {
								sql.append(" "
										+ mainTableInfo.get(j)
												.get("TABLE_NAME")
										+ "."
										+ mainTableInfo.get(j).get(
												"COLUMN_CODE") + " = ");
								sql.append(" "
										+ baseKpiTables.get(i)
										+ "."
										+ mainTableInfo.get(j).get(
												"COLUMN_CODE") + " AND ");
							}
							flag = true;
						}
					} else {
						int size = myCommon.size();
						for (int j = 0; j < size; j++) {
							if (j == size - 1) {
								sql.append(" " + mainTable + "."
										+ myCommon.get(j).get("COLUMN_CODE")
										+ " = ");
								sql.append(" " + baseKpiTables.get(i) + "."
										+ myCommon.get(j).get("COLUMN_CODE"));
							} else {
								sql.append(" " + mainTable + "."
										+ myCommon.get(j).get("COLUMN_CODE")
										+ " = ");
								sql.append(" " + baseKpiTables.get(i) + "."
										+ myCommon.get(j).get("COLUMN_CODE")
										+ " AND ");
							}
							flag = true;
						}
					}
				}
				for (int j = 0; j < attrInfo.size(); j++) {
					if ("KPI_COM".equals(attrInfo.get(j).get("TABLE_NAME"))) {
						if (flag) {
							sql.append(" AND " + mainTable + "."
									+ attrInfo.get(j).get("COLUMN_CODE")
									+ " = ");
							sql.append(" " + baseKpiTables.get(i) + "."
									+ attrInfo.get(j).get("COLUMN_CODE"));
						} else {
							sql.append(" " + mainTable + "."
									+ attrInfo.get(j).get("COLUMN_CODE")
									+ " = ");
							sql.append(" " + baseKpiTables.get(i) + "."
									+ attrInfo.get(j).get("COLUMN_CODE"));
						}
					} else {
						if (baseKpiTables.get(i).equals(
								attrInfo.get(j).get("TABLE_NAME"))) {
							if (flag) {
								sql.append(" AND " + mainTable + "."
										+ attrInfo.get(j).get("COLUMN_CODE")
										+ " = ");
								sql.append(" " + baseKpiTables.get(i) + "."
										+ attrInfo.get(j).get("COLUMN_CODE"));
							} else {
								sql.append(" " + mainTable + "."
										+ attrInfo.get(j).get("COLUMN_CODE")
										+ " = ");
								sql.append(" " + baseKpiTables.get(i) + "."
										+ attrInfo.get(j).get("COLUMN_CODE"));
							}
						}
					}
				}
			}
			tableSql.put("sql", sql.toString());
		}
		return tableSql;
	}
	/**
	 * 多表关联 公共维度关联
	 * @return
	 * @throws Exception
	 */
	protected String getRelationPubDimSql() throws Exception {
		StringBuffer sql = new StringBuffer("");
		String firstTable = baseKpiTables.get(0);
		String firstTableAlias = "";
		if(firstTable.indexOf(".") > 0) {
			firstTableAlias = firstTable.substring(firstTable.indexOf(".")+1);
		} else {
			firstTableAlias = firstTable;
		}
		//此处处理公共维度关联的模式
		for (int i = 0; i < baseKpiTables.size(); i++) {
			String tableName = baseKpiTables.get(i);
			String tableAlias = "";
			if(tableName.indexOf(".") > 0) {
				tableAlias = tableName.substring(tableName.indexOf(".")+1);
			} else {
				tableAlias = tableName;
			}
			String tmpSql = " ( " + getGroupSql(tableName) + " ) " + tableAlias + " ";
			if(i > 0) {
				sql.append(" INNER JOIN ");
				sql.append(tmpSql);
				sql.append(" ON ");
				for (int j = 0; j < dims.size(); j++) {
					String dim = dims.get(j);
					if (!baseDims.containsKey(dim)) {
						continue;
					}
					if(j == 0) {
						sql.append(" " + firstTableAlias + "." + baseDims.get(dim).get("DIM_FIELD") + "=" + tableAlias + "." +  baseDims.get(dim).get("DIM_FIELD"));
					} else {
						sql.append(" AND " + firstTableAlias + "." + baseDims.get(dim).get("DIM_FIELD") + "=" + tableAlias + "." +  baseDims.get(dim).get("DIM_FIELD"));
					}
				}
			} else {
				sql.append(tmpSql);
			}
		}
		sql.append(getSqlFromDim(firstTableAlias));
		return sql.toString();
	}
	/**
	 * 维度关联模式
	 * @param tableName
	 * @return
	 * @throws Exception
	 */
	protected String getGroupSql(String tableName) throws Exception {
		StringBuffer sql = new StringBuffer(" SELECT ");
		StringBuffer groupSql = new StringBuffer(" GROUP BY ");
		for (int i = 0; i < dims.size(); i++) {
			String dim = dims.get(i);
			if (!baseDims.containsKey(dim)) {
				continue;
			}
			if ("dim".equals((String) baseDims.get(dim).get("DIM_TYPE"))) {
				sql.append(tableName + "." + baseDims.get(dim).get("DIM_FIELD") +",");
				groupSql.append(" "+ tableName + "." + baseDims.get(dim).get("DIM_FIELD") + ",");
			} else {
				sql.append(tableName + "." + baseDims.get(dim).get("DIM_FIELD") + ",");
				groupSql.append(" "+ tableName + "." + baseDims.get(dim).get("DIM_FIELD") + ",");
			}
		}
		if (",".equals(groupSql.toString().substring(groupSql.toString().length() - 1))) {
			groupSql = new StringBuffer(groupSql.toString().substring(0,
					groupSql.toString().length() - 1));
		}
		// 基础指标部分
		for (Map.Entry<String, Map<String, Object>> entry : baseKpis.entrySet()) {
			if(tableName.equals(entry.getValue().get("TABLENAME"))) {
				if (sql.toString().indexOf(
						(String) entry.getValue().get("SOURCE_COLUMN")) == -1) {
					sql.append(" SUM( "+ entry.getValue().get("SOURCE_COLUMN")
							+ ") AS " + entry.getValue().get("KPI_CODE")
							+ ",");
				}
			}
		}
		if (",".equals(sql.toString().substring(sql.toString().length() - 1))) {
			sql = new StringBuffer(sql.toString().substring(0,
					sql.toString().length() - 1));
		}
		// 复合指标
		for (Map.Entry<String, Map<String, Object>> entry : formKpisMap
				.entrySet()) {
			List<Map<String,Object>> formKpiList = baseFormKpi.get(entry.getKey());
			for(Map<String,Object> map : formKpiList) {
				if(tableName.equals(map.get("TABLENAME"))) {
					if (",".equals(sql.toString().substring(sql.toString().length() - 1))) {
						sql.append(" " + map.get("BASESQL"));
					} else{
						sql.append(" , " + map.get("BASESQL"));
					}
				}
			}
		}
		if (",".equals(sql.toString().substring(sql.toString().length() - 1))) {
			sql = new StringBuffer(sql.toString().substring(0,
					sql.toString().length() - 1));
		}
		sql.append(" FROM ");
		sql.append(" " + tableName + " ");
		//where部分
		sql.append(getSqlWhere(tableName));
		//分组部分
		sql.append(groupSql.toString());
		return sql.toString();
	}
	
	/**
	 * 获取基础指标和维度的SELECT部分（公用维度关联模式）
	 * 
	 * @param tableName
	 * @return
	 * @throws Exception
	 */
	protected Map<String,Object> getSqlSelect(String tableName) throws Exception {
		Map<String,Object> pubDimSql = new HashMap<String,Object>();
		StringBuffer groupSql = new StringBuffer(" group by ");
		StringBuffer sql = new StringBuffer("");
		// 维度部分
		for (int i = 0; i < dims.size(); i++) {
			String dim = dims.get(i);
			if (!baseDims.containsKey(dim)) {
				continue;
//				throw new Exception("基础维度[" + dim + "]已移除，或者尚未定义");
			}
			// dim代表维度，attr代表属性，如果是标签只从事实表中取字段
			if ("dim".equals((String) baseDims.get(dim).get("DIM_TYPE"))) {
				String codeAlias = (String) baseDims.get(dim).get("DIM_FIELD")
						+ "_CODE";
				String descAlias = (String) baseDims.get(dim).get("DIM_FIELD");
				if (alias != null && alias.size() > 0) { // 添加下钻的别名
					if (dim.equals(alias.get("id"))) {
						codeAlias = alias.get("code");
						descAlias = alias.get("name");
					}
				}
				sql.append(baseDims.get(dim).get("TABLE_ALIAS") + "."
						+ baseDims.get(dim).get("FIELD_NAME") + " AS "
						+ descAlias + ",");
				sql.append(baseDims.get(dim).get("TABLE_ALIAS") + "."
						+ baseDims.get(dim).get("FIELD_CODE") + " AS "
						+ codeAlias + ",");
				groupSql.append(" "+ baseDims.get(dim).get("TABLE_ALIAS") + "."
						+ baseDims.get(dim).get("FIELD_NAME") + " , ");
				groupSql.append(" "+ baseDims.get(dim).get("TABLE_ALIAS") + "."
						+ baseDims.get(dim).get("FIELD_CODE") + " , ");
			} else {
				sql.append(tableName + "."
						+ baseDims.get(dim).get("DIM_FIELD") + " AS "
						+ baseDims.get(dim).get("DIM_FIELD") + ",");
				groupSql.append(" "+ tableName + "." + baseDims.get(dim).get("DIM_FIELD") + " , ");
			}
		}
		// 基础指标部分
		for (Map.Entry<String, Map<String, Object>> entry : baseKpis.entrySet()) {
			if(tableName.equals(entry.getValue().get("TABLENAME"))) {
				if (sql.toString().indexOf(
						(String) entry.getValue().get("SOURCE_COLUMN")) == -1) {
					sql.append(" SUM( "+ entry.getValue().get("SOURCE_COLUMN")
							+ ") AS " + entry.getValue().get("KPI_CODE")
							+ ",");
				}
			}
		}
		if (",".equals(sql.toString().substring(sql.toString().length() - 1))) {
			sql = new StringBuffer(sql.toString().substring(0,
					sql.toString().length() - 1));
		}
		// 复合指标
		for (Map.Entry<String, Map<String, Object>> entry : formKpisMap
				.entrySet()) {
			List<Map<String,Object>> formKpiList = baseFormKpi.get(entry.getKey());
			for(Map<String,Object> map : formKpiList) {
				if(tableName.equals(map.get("TABLENAME"))) {
					sql.append(" , " + map.get("BASESQL") + "  ");
				}
			}
		}
		pubDimSql.put("SQL", sql.toString());
		pubDimSql.put("GROUPSQL", groupSql.toString());
		return pubDimSql;
	}
	/**
	 * 获取sql中的维度关联部分（公共维度关联）
	 * @param tableName
	 * @return
	 * @throws Exception
	 */
	protected String getSqlFromDim(String tableName) throws Exception {
		StringBuffer sql = new StringBuffer("");
		Map<String, ArrayList<Map<String, Object>>> dimTable = new HashMap<String, ArrayList<Map<String, Object>>>();
		for (int i = 0; i < dims.size(); i++) {
			for (Map.Entry<String, Map<String, Object>> baseDim : baseDims
					.entrySet()) {
				if(dims.get(i).equals(baseDim.getKey())) {
					String  dim_data_type = (String)baseDim.getValue().get("DIM_DATA_TYPE");
					if(dim_data_type == null || "T".equals(dim_data_type) || "".equals(dim_data_type)) {
						if ("dim".equals(baseDim.getValue().get("DIM_TYPE"))) {
							if (dimTable.containsKey((String) baseDim.getValue().get(
									"TABLENAME"))) {
								ArrayList<Map<String, Object>> list = dimTable
										.get((String) baseDim.getValue().get("TABLENAME"));
								list.add(baseDim.getValue());
								dimTable.put((String) baseDim.getValue().get("TABLENAME"),
										list);
							} else {
								ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
								list.add(baseDim.getValue());
								dimTable.put((String) baseDim.getValue().get("TABLENAME"),
										list);
							}
						}
					}
				}
			}
		}
		
		for (Map.Entry<String, ArrayList<Map<String, Object>>> dim : dimTable
				.entrySet()) {
			sql.append(" INNER JOIN ");
			int k = 0;
			String str = " ( SELECT ";
			String group = "";
			String where = "";
			String alias = "";
			for (Map<String, Object> dm : dim.getValue()) {
				alias = (String) dm.get("TABLE_ALIAS");
				if (k == 0) {
					where += tableName + "." + dm.get("DIM_FIELD") + "="
							+ dm.get("TABLE_ALIAS") + "."
							+ dm.get("FIELD_CODE") + " ";
				} else {
					where += " and " + tableName + "." + dm.get("DIM_FIELD")
							+ "=" + dm.get("TABLE_ALIAS") + "."
							+ dm.get("FIELD_CODE") + " ";
				}
				if (k == dim.getValue().size() - 1) {
					str += dm.get("FIELD_CODE") + "," + dm.get("FIELD_NAME");
					group += dm.get("FIELD_CODE") + "," + dm.get("FIELD_NAME");
				} else {
					group += dm.get("FIELD_CODE") + "," + dm.get("FIELD_NAME")
							+ ",";
					str += dm.get("FIELD_CODE") + "," + dm.get("FIELD_NAME")
							+ ",";
				}
				k++;
			}
			str = str + " from " + dim.getKey() + " group by " + group + ") "
					+ alias + " ON " + where;
			sql.append(str);
		}
		return sql.toString();
	}
	/**
	 * 根据报表中定义的 where部分（公共维度关联）
	 * @param tableName
	 * @return
	 * @throws Exception
	 */
	protected String getSqlWhere(String tableName) throws Exception {
		StringBuffer sql = new StringBuffer("");
		boolean dimWhere = false;
		boolean kpiWhere = false;
		for (int i = 0; i < wheres.size(); i++) {
			// 如果是维度，则生成维度的查询条件
			String var_name = wheres.get(i).get("varname");
			if ("dim".equals(wheres.get(i).get("type"))) {
					if (!baseDims.containsKey(wheres.get(i).get("id")))
						continue;
//						throw new Exception("基础维度[" + wheres.get(i).get("id")
//								+ "]已移除，或者尚未定义");
					if (var_name == null || "".equals(var_name)) {
						var_name = (String) baseDims.get(
								wheres.get(i).get("id")).get("DIM_FIELD");
					}
					if ("06".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " >= #" + var_name
								+ "_1# }");
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " <= #" + var_name
								+ "_2# }");
					}if ("10".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " > #" + var_name
								+ "_1# }");
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " < #" + var_name
								+ "_2# }");
					} if ("11".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " >= #" + var_name
								+ "_1# }");
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " < #" + var_name
								+ "_2# }");
					} if ("12".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " > #" + var_name
								+ "_1# }");
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " <= #" + var_name
								+ "_2# }");
					} else if ("07".equals(wheres.get(i).get("formula"))) { // like
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD")
								+ " like concat(concat('%',#" + var_name
								+ "#),'%') }");
					} else if ("08".equals(wheres.get(i).get("formula"))) {// not like
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD")
								+ " not like concat(concat('%',#" + var_name
								+ "#),'%') }");
					} else if ("09".equals(wheres.get(i).get("formula"))) {// in
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " in (#" + var_name
								+ "#) }");
					} else {
						if ("1".equals(wheres.get(i).get("multiple"))) { // 多选
							sql.append(" { and "
									+ tableName
									+ "."
									+ baseDims.get(wheres.get(i).get("id"))
											.get("DIM_FIELD") + " in( #"
									+ var_name + "# ) }");
						} else {
							sql.append(" { and "
									+ tableName
									+ "."
									+ baseDims.get(wheres.get(i).get("id"))
											.get("DIM_FIELD") + " "
									+ this.opter(wheres.get(i).get("formula"))
									+ " #" + var_name + "# }");
						}
				}
				dimWhere = true;
			} else if ("property".equals(wheres.get(i).get("type"))) {
				if (var_name == null || "".equals(var_name)) {
					var_name = (String) baseDims.get(
						wheres.get(i).get("id")).get("DIM_FIELD");
				}
				if ("06".equals(wheres.get(i).get("formula"))) {
					sql.append(" { and "
							+ tableName
							+ "."
							+ baseDims.get(wheres.get(i).get("id")).get(
									"DIM_FIELD") + " >= #" + var_name
							+ "_1#}");
					sql.append(" { and "
							+ tableName
							+ "."
							+ baseDims.get(wheres.get(i).get("id")).get(
									"DIM_FIELD") + " <= #" + var_name
							+ "_2#}");
				} else if ("10".equals(wheres.get(i).get("formula"))) {
					sql.append(" { and "
							+ tableName
							+ "."
							+ baseDims.get(wheres.get(i).get("id")).get(
									"DIM_FIELD") + " > #" + var_name
							+ "_1#}");
					sql.append(" { and "
							+ tableName
							+ "."
							+ baseDims.get(wheres.get(i).get("id")).get(
									"DIM_FIELD") + " < #" + var_name
							+ "_2#}");
				} else if ("11".equals(wheres.get(i).get("formula"))) {
					sql.append(" { and "
							+ tableName
							+ "."
							+ baseDims.get(wheres.get(i).get("id")).get(
									"DIM_FIELD") + " >= #" + var_name
							+ "_1#}");
					sql.append(" { and "
							+ tableName
							+ "."
							+ baseDims.get(wheres.get(i).get("id")).get(
									"DIM_FIELD") + " < #" + var_name
							+ "_2#}");
				} else if ("12".equals(wheres.get(i).get("formula"))) {
					sql.append(" { and "
							+ tableName
							+ "."
							+ baseDims.get(wheres.get(i).get("id")).get(
									"DIM_FIELD") + " > #" + var_name
							+ "_1#}");
					sql.append(" { and "
							+ tableName
							+ "."
							+ baseDims.get(wheres.get(i).get("id")).get(
									"DIM_FIELD") + " <= #" + var_name
							+ "_2#}");
				}else if ("07".equals(wheres.get(i).get("formula"))) {
					sql.append(" { and "
							+ tableName
							+ "."
							+ baseDims.get(wheres.get(i).get("id")).get(
									"DIM_FIELD")
							+ " like concat(concat('%',#" + var_name
							+ "#),'%')}");
				} else if ("08".equals(wheres.get(i).get("formula"))) {
					sql.append(" { and "
							+ tableName
							+ "."
							+ baseDims.get(wheres.get(i).get("id")).get(
									"DIM_FIELD")
							+ " not like concat(concat('%',#" + var_name
							+ "#),'%')}");
				} else if ("09".equals(wheres.get(i).get("formula"))) {
					sql.append(" { and "
							+ tableName
							+ "."
							+ baseDims.get(wheres.get(i).get("id")).get(
									"DIM_FIELD") + " in(#" + var_name
							+ ")#}");
				} else {
					if ("1".equals(wheres.get(i).get("multiple"))) { // 多选
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id"))
										.get("DIM_FIELD") + " in(#"
								+ var_name + "#) }");
					} else {
						sql.append(" { and "
								+ tableName
								+ "."
								+ baseDims.get(wheres.get(i).get("id"))
										.get("DIM_FIELD") + " "
								+ this.opter(wheres.get(i).get("formula"))
								+ " #" + var_name + "# }");
					}
				}
				dimWhere = true;
			} else {
				// 基础指标作为查询条件
				if (isBaseKpi(var_name)) {
					String kpi_key = wheres.get(i).get("id");
					if (kpi_key.indexOf("_") != -1) {
						kpi_key = kpi_key.substring(0,kpi_key.lastIndexOf("_"));
					}
					String baseKpiTable = (String) baseKpis.get(kpi_key).get("TABLENAME");
					String column = (String) baseKpis.get(kpi_key).get("SOURCE_COLUMN");
					if(tableName.equals(baseKpiTable)) {
						if ("06".equals(wheres.get(i).get("formula"))) { 
							sql.append(" { and " + column + " >=#" + var_name
									+ "_1#} { and " + column + " <=#" + var_name
									+ "_2#}");
						} else if ("10".equals(wheres.get(i).get("formula"))) { 
							sql.append(" { and " + column + " >#" + var_name
									+ "_1#} { and " + column + " <#" + var_name
									+ "_2#}");
						} else if ("11".equals(wheres.get(i).get("formula"))) { 
							sql.append(" { and " + column + " >=#" + var_name
									+ "_1#} { and " + column + " <#" + var_name
									+ "_2#}");
						} else if ("12".equals(wheres.get(i).get("formula"))) { 
							sql.append(" { and " + column + " >#" + var_name
									+ "_1#} { and " + column + " <=#" + var_name
									+ "_2#}");
						} else if ("07".equals(wheres.get(i).get("formula"))) {
							sql.append(" { and " + column
									+ " like concat(concat('%',#" + var_name
									+ "#),'%')}");
						} else if ("08".equals(wheres.get(i).get("formula"))) {
							sql.append(" { and " + column
									+ " not like concat(concat('%',#" + var_name
									+ "#),'%')}");
						} else if ("09".equals(wheres.get(i).get("formula"))) {
							sql.append(" { and " + column + " in(#" + var_name
									+ "#)}");
						} else {
							if ("1".equals(wheres.get(i).get("multiple"))) { // 多选
								sql.append(" { and " + column + " in(#" + var_name
										+ "#)} ");
							} else {
								sql.append(" { and " + column
										+ this.opter(wheres.get(i).get("formula"))
										+ "#" + var_name + "#}");
							}
						}
						kpiWhere = true;
					}
				} else {
					havingList.add(wheres.get(i));
				}
			}
		}
		String where = "";
		if (dimWhere || kpiWhere) {
			where = " WHERE 1=1 ";
		}
		return where + sql.toString();
	}

	 
	/**
	 * 根据报表中定义的 where部分
	 * 
	 * @param isDim
	 *            判断维度还是指标
	 * @return
	 * @throws Exception
	 */
	protected String getSqlWhere() throws Exception {
		StringBuffer sql = new StringBuffer("");
		boolean dimWhere = false;
		boolean kpiWhere = false;
		for (int i = 0; i < wheres.size(); i++) {
			// 如果是维度，则生成维度的查询条件
			String var_name = wheres.get(i).get("varname");
			String var_name_type = wheres.get(i).get("varnametype");
			if ("dim".equals(wheres.get(i).get("type"))) {
				for (String tables : baseKpiTables) {
					if (!baseDims.containsKey(wheres.get(i).get("id")))
						continue;
//						throw new Exception("基础维度[" + wheres.get(i).get("id")
//								+ "]已移除，或者尚未定义");
					if(baseDims.get(
							wheres.get(i).get("id")).get("DIM_FIELD") != null &&
							!"".equals(baseDims.get(
									wheres.get(i).get("id")).get("DIM_FIELD"))) {
						var_name = (String) baseDims.get(
								wheres.get(i).get("id")).get("DIM_RIGHT");
					}
					if (var_name == null || "".equals(var_name)) {
							var_name = (String) baseDims.get(
									wheres.get(i).get("id")).get("DIM_FIELD");
					}
					if (baseDims.get(wheres.get(i).get("id")).get("DIM_TABLE") != null
							&& !"".equals(baseDims.get(wheres.get(i).get("id"))
									.get("DIM_TABLE").toString())) {
						String dim_data_type = (String) baseDims.get(wheres.get(i).get("id"))
								.get("DIM_DATA_TYPE");
						if(dim_data_type == null || "T".equals(dim_data_type) || "".equals(dim_data_type)) {
							tables = (String) baseDims.get(wheres.get(i).get("id"))
									.get("DIM_TABLE");
						}
					}
					if ("06".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " >= #" + var_name
								+ "_1# }");
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " <= #" + var_name
								+ "_2# }");
					} else if ("10".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " > #" + var_name
								+ "_1# }");
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " < #" + var_name
								+ "_2# }");
					} else if ("11".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " >= #" + var_name
								+ "_1# }");
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " < #" + var_name
								+ "_2# }");
					} else if ("12".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " > #" + var_name
								+ "_1# }");
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " <= #" + var_name
								+ "_2# }");
					} else if ("07".equals(wheres.get(i).get("formula"))) { // like
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD")
								+ " like concat(concat('%',#" + var_name
								+ "#),'%') }");
					} else if ("08".equals(wheres.get(i).get("formula"))) {// not like
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD")
								+ " not like concat(concat('%',#" + var_name
								+ "#),'%') }");
					} else if ("09".equals(wheres.get(i).get("formula"))) {// in
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " in (#" + var_name
								+ "#) }");
					} else {
						if ("1".equals(wheres.get(i).get("multiple"))) { // 多选
							sql.append(" { and "
									+ tables
									+ "."
									+ baseDims.get(wheres.get(i).get("id"))
											.get("DIM_FIELD") + " in( #"
									+ var_name + "# ) }");
						} else {
							sql.append(" { and "
									+ tables
									+ "."
									+ baseDims.get(wheres.get(i).get("id"))
											.get("DIM_FIELD") + " "
									+ this.opter(wheres.get(i).get("formula"))
									+ " #" + var_name + "# }");
						}
					}
				}
				dimWhere = true;
			} else if ("property".equals(wheres.get(i).get("type"))) {
				for (String tables : baseKpiTables) {
					if (var_name == null || "".equals(var_name)) {
						var_name = (String) baseDims.get(
								wheres.get(i).get("id")).get("DIM_FIELD");
					}
					if (baseDims.get(wheres.get(i).get("id")).get("TABLE_NAME") != null
							&& !"".equals(baseDims.get(wheres.get(i).get("id"))
									.get("TABLE_NAME").toString())) {
						tables = (String) baseDims.get(wheres.get(i).get("id"))
								.get("TABLE_NAME");
					}
					if ("06".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " >= #" + var_name
								+ "_1#}");
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " <= #" + var_name
								+ "_2#}");
					}else if ("10".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " > #" + var_name
								+ "_1# }");
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " < #" + var_name
								+ "_2# }");
					}else if ("11".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " >= #" + var_name
								+ "_1# }");
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " < #" + var_name
								+ "_2# }");
					} else if ("12".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " > #" + var_name
								+ "_1# }");
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " <= #" + var_name
								+ "_2# }");
					} else if ("07".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD")
								+ " like concat(concat('%',#" + var_name
								+ "#),'%')}");
					} else if ("08".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD")
								+ " not like concat(concat('%',#" + var_name
								+ "#),'%')}");
					} else if ("09".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and "
								+ tables
								+ "."
								+ baseDims.get(wheres.get(i).get("id")).get(
										"DIM_FIELD") + " in(#" + var_name
								+ ")#}");
					} else {
						if ("1".equals(wheres.get(i).get("multiple"))) { // 多选
							sql.append(" { and "
									+ tables
									+ "."
									+ baseDims.get(wheres.get(i).get("id"))
											.get("DIM_FIELD") + " in(#"
									+ var_name + "#) }");
						} else {
							sql.append(" { and "
									+ tables
									+ "."
									+ baseDims.get(wheres.get(i).get("id"))
											.get("DIM_FIELD") + " "
									+ this.opter(wheres.get(i).get("formula"))
									+ " #" + var_name + "# }");
						}
					}
				}
				dimWhere = true;
			} else {
				// 基础指标作为查询条件
				if (isBaseKpi(var_name)) {
					String kpi_key = wheres.get(i).get("id");
					if (kpi_key.indexOf("_") != -1) {
						kpi_key = kpi_key.substring(0,kpi_key.lastIndexOf("_"));
					}
					String column = (String) baseKpis.get(kpi_key).get("SOURCE_COLUMN");
					if ("06".equals(wheres.get(i).get("formula"))) { 
						sql.append(" { and " + column + " >=#" + var_name
								+ "_1#} { and " + column + " <=#" + var_name
								+ "_2#}");
					} else if ("10".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and " + column + " >#" + var_name
								+ "_1#} { and " + column + " <#" + var_name
								+ "_2#}");
					}else if ("11".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and " + column + " >=#" + var_name
								+ "_1#} { and " + column + " <#" + var_name
								+ "_2#}");
					}else if ("12".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and " + column + " >#" + var_name
								+ "_1#} { and " + column + " <=#" + var_name
								+ "_2#}");
					}else if ("07".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and " + column
								+ " like concat(concat('%',#" + var_name
								+ "#),'%')}");
					} else if ("08".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and " + column
								+ " not like concat(concat('%',#" + var_name
								+ "#),'%')}");
					} else if ("09".equals(wheres.get(i).get("formula"))) {
						sql.append(" { and " + column + " in(#" + var_name
								+ "#)}");
					} else {
						if ("1".equals(wheres.get(i).get("multiple"))) { // 多选
							sql.append(" { and " + column + " in(#" + var_name
									+ "#)} ");
						} else {
							sql.append(" { and " + column
									+ this.opter(wheres.get(i).get("formula"))
									+ "#" + var_name + "#}");
						}
					}
					kpiWhere = true;
				} else {
					havingList.add(wheres.get(i));
				}
			}
		}
		String where = "";
		if (dimWhere || kpiWhere) {
			where = " WHERE 1=1 ";
		}
		return where + sql.toString();
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
						sql.append(" " + baseDims.get(orders.get(i).get("id")).get("DIM_FIELD")
								+ "  " + orders.get(i).get("ord") + ",");
					} else {
						String dim_data_type = (String )baseDims.get(orders.get(i).get("id")).get("DIM_DATA_TYPE");
						if (alias != null && alias.size() > 0) { // 添加下钻的别名
							sql.append(" " + alias.get("code") + " "
									+ orders.get(i).get("ord") + ",");
						} else {
							if(dim_data_type == null || "T".equals(dim_data_type)||"".equals(dim_data_type)) {
								sql.append(" " + baseDims.get(orders.get(i).get("id"))
												.get("DIM_FIELD") + "_CODE "
										+ orders.get(i).get("ord") + ",");
							} else {
								sql.append(" " + baseDims.get(orders.get(i).get("id"))
												.get("DIM_FIELD") + " "
										+ orders.get(i).get("ord") + ",");
							}
						}
					}
				} else {
					sql.append(" " + orders.get(i).get("col") + " "
							+ orders.get(i).get("ord") + ",");
				}
			}
		}
		if (!"".equals(sql.toString())) {
			return sql.toString().substring(0, sql.toString().length() - 1);
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
								continue;
//								throw new Exception("基础指标["
//										+ orders.get(i).get("id")
//										+ "]已移除，或者尚未定义");
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
				continue;
//				throw new Exception("基础维度[" + dim + "]在元数据中已移除，或者尚未定义");
			}
			if ("dim".equals((String) baseDims.get(dim).get("DIM_TYPE"))) {
				String dim_data_type = (String)baseDims.get(dim).get("DIM_DATA_TYPE");
				if(dim_data_type == null || "T".equals(dim_data_type)||"".equals(dim_data_type)) {
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
						sql.append(mainTable + "." + baseDims.get(dim).get("DIM_FIELD") + ","); 
//						sql.append(baseDims.get(dim).get("TABLE_ALIAS") + "."
//								+ baseDims.get(dim).get("FIELD_CODE") + ",");
//						sql.append(baseDims.get(dim).get("TABLE_ALIAS") + "."
//								+ baseDims.get(dim).get("FIELD_NAME") + ",");
					}
				} else {
					if (isAll) {
						sql.append(baseDims.get(dim).get("DIM_FIELD") + ",");
					} else {
						sql.append(mainTable + "." + baseDims.get(dim).get("DIM_FIELD") + ","); 
//						sql.append(mainTable + "."
//								+ baseDims.get(dim).get("DIM_FIELD") + ",");
					}
				}
				
			} else {
				// for (String table : baseKpiTables) {
				if (isAll) {
					sql.append(baseDims.get(dim).get("DIM_FIELD") + ",");
				} else {
					sql.append(mainTable + "."
							+ baseDims.get(dim).get("DIM_FIELD") + ",");
				}
				// }
			}

		}
		if (!"".equals(sql.toString())) {
			return " group by "
					+ sql.toString().substring(0, sql.toString().length() - 1);
		}
		return sql.toString();
	}
	protected String formateSql(String frm1, String frm2,String frm3,String kpi) {
		String sql = kpi;
		if(frm1 != null && !"".equals(frm1)) {
			sql = " ROUND(" + kpi + ","+ frm1 +")";
			if (frm2 != null && "1".equals(frm2)) {
				sql = " CONCAT(TO_CHAR(ROUND((" + kpi + ")*100,"+ frm1 +")),'%') ";
			}
		}
		return sql;
	}
//
//	protected String getSqlHaving() throws Exception {
//		StringBuffer having = new StringBuffer("  ");
//		if (havingList.size() > 0 && havingList.get(0).size() > 0) {
//			having = new StringBuffer(" having 1=1");
//		}
//		for (Map<String, String> map : havingList) {
//			if (formKpisMap.containsKey(map.get("id"))) {
//				if ("06".equals(map.get("formula"))) {
//					having.append("{ and "
//							+ formKpisMap.get(map.get("id")).get(
//									"HAVING_COLUMN") + " >= #"
//							+ formKpisMap.get(map.get("id")).get("KPI_CODE")
//							+ "_1# and "
//							+ formKpisMap.get(map.get("id")).get("KPI_CODE")
//							+ " <= #"
//							+ formKpisMap.get(map.get("id")).get("KPI_CODE")
//							+ "_2#}");
//				} else {
//					having.append("{ and "
//							+ formKpisMap.get(map.get("id")).get(
//									"HAVING_COLUMN") + " "
//							+ this.opter(map.get("formula")) + " #"
//							+ formKpisMap.get(map.get("id")).get("KPI_CODE")
//							+ "#}");
//				}
//			}
//
//		}
//		return having.toString();
//	}

	/**
	 * 判断是否是基础指标 复合指标以FK_开头
	 * 
	 * @param kpiId
	 * @return
	 */
	protected boolean isBaseKpi(String kpiId) {
		return kpiId.startsWith("BK_");
	}

	protected boolean hasFormKpi() {
		boolean flag = false;
		for (Map<String, String> kpiStr : kpis) {
			if (kpiStr.get("COLUMN_ID").startsWith("FK_")) {
				flag = true;
			}
		}
		return flag;
	}

	protected void getOpter() throws Exception {
		Connection conn = null;
		QueryRunner queryRunner = null;
		try {
			conn = dataSource.getConnection();
			queryRunner = new QueryRunner();
			opter = queryRunner.query(conn, opterSql,
					null, new MapListHandler());
		} catch (SQLException e) {
			throw new Exception(e);
		} finally {
			if (conn != null) {
				conn.close();
			}
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

	protected Map<String, String> parseFormKpiFormulas(String kpiBody,
			String kpi_key,Map<String,Object> kpiMap) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		Kpi kpi = parseXMLToKpi(kpiBody);// 获取复合指标的组成结构体
		Formula formula = kpi.getFormulas().getFormula();// 复合指标组成公式
		String formulaSQL = formula.getFormula();// 定义复合指标的公式SQL
		String oformulaSQL = formula.getFormula();
		String sumFormulaSQL = formula.getFormula();
		String frm1 = (String)kpiMap.get("FRM1");
	    String frm2 = (String)kpiMap.get("FRM2");
	    String frm3 = (String)kpiMap.get("FRM3");
		for (String id : getMeasuresInFormula(formula.getFormula())) {
			for (Measure measure : getMeasures()) {
				if (id.equals(measure.getId())) {
					// 将{指标ID}替换成来源表和来源字段，以及聚合函数
					formulaSQL = formulaSQL.replaceAll("\\{" + id
							+ "\\}",  measure.getId() + kpi_key);
					
					oformulaSQL = oformulaSQL.replaceAll("\\{" + id 
							+ "\\}", measure.getId() + kpi_key);
					
					sumFormulaSQL = sumFormulaSQL.replaceAll("\\{" + id 
							+ "\\}", measure.getAggregator() + "(" + measure.getId() + kpi_key + ")");
					break;
				}
			}
		}
		formulaSQL = validateZero(formulaSQL);
		map.put("SQL1", formateSql(frm1,frm2,frm3,formulaSQL));
		formulaSQL = " ( " + formateSql(frm1,frm2,frm3,formulaSQL) + ") AS " + kpi.getId();
		map.put("SQL2", formulaSQL);
		map.put("SQL3", formateSql(frm1,frm2,frm3,oformulaSQL));
		map.put("SQL4", " ( " + formateSql(frm1,frm2,frm3,sumFormulaSQL) + ") AS " + kpi.getId());
		return map;
	}

	protected String getBaseMetaType(Measure measure) throws Exception {
		String sql = " select TYPE from X_BASE_KPI where BASE_KEY = '"
				+ measure.getKpiKey() + "'";
		QueryRunner queryRunner = new QueryRunner();
		List<Map<String, Object>> results = null;
		try {
			results = queryRunner.query(dataSource.getConnection(), sql, null,
					new MapListHandler());
		} catch (SQLException e) {
			throw new Exception(e);
		}
		if (results != null) {
			return (String) results.get(0).get("TYPE");
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
					formulaSQL = formulaSQL.replaceAll(
							"\\{" + id + "\\}",
							"(" + measure.getTableLink() + "."
									+ measure.getColumnLink() + ") ");
					if (baseKpiTables != null) {
						if (!baseKpiTables.contains(measure.getTableLink())) {
							baseKpiTables.add(measure.getTableLink());
						}
					}
					// if(source_owner != null) {
					// if (!source_owner.contains(measure.getDatasource())) {
					// source_owner.add(measure.getDatasource());
					// }
					// }
					break;
				}
			}
		}
		return formulaSQL;
	}

	public String parseExpression(Kpi kpi) throws Exception {
		String factTable = "";
		if (kpi.getMeasures().getMeasureList() != null
				&& kpi.getMeasures().getMeasureList().size() > 0) {
			factTable = kpi.getMeasures().getMeasureList().get(0)
					.getTableLink();
		}
		String expression = "";
		if (getConditions() != null && getConditions().size() > 0) {
			expression = kpi.getConditions().getExpression().getExpression();
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
				if (dimension != null) {
					expression = expression.replaceAll(
							"\\{" + dimension.getId() + "\\}", factTable + "."
									+ dimension.getColumnLink());
					continue;
				}
				// 指标或者属性
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

	protected String parseKpi(Kpi kpi, String kpi_key) throws Exception {
		StringBuffer sql = new StringBuffer("");
		Formula formula = kpi.getFormulas().getFormula();
		String expression = parseExpression(kpi);
		// String formulaSQL = parseFormulas(kpi);
		String baseKpiSql = "";
		List<Map<String,Object>> baseKpiList = new ArrayList<Map<String,Object>>();	
		String agg = "SUM";
		if ("DATAGRID".equals(this.component.getType())) {
			if (!"1".equals(component.getTablesetsum())) {
				agg = "";
			}
		} 
		for (String id : getMeasuresInFormula(formula.getFormula())) {
			for (Measure measure : getMeasures()) {
				if (id.equals(measure.getId())) {
				    Map<String,Object> baseKpiMap = new HashMap<String,Object>();
					if (!"".equals(expression)) {
						sql.append(" " + agg +  "(CASE WHEN ");
						if (expression.trim().toUpperCase().startsWith("AND")) {
							expression = expression.substring(3);
						} else if (expression.trim().toUpperCase()
								.startsWith("OR")) {
							expression = expression.substring(2);
						}
						if (expression.trim().toUpperCase().endsWith("AND")) {
							expression = expression.trim().substring(0,
									expression.trim().length() - 3);
						} else if (expression.trim().toUpperCase()
								.endsWith("OR")) {
							expression = expression.trim().substring(0,
									expression.trim().length() - 2);
						}
						sql.append(expression);
						baseKpiSql = sql.toString() + " THEN " + measure.getAggregator() 
								+ "("+ measure.getTableLink() + "." + measure.getColumnLink() 
								+ ") ELSE 0 END ) AS " + measure.getId() + kpi_key + ",";
						sql.append(" THEN " + measure.getTableLink() + "."
								+ measure.getColumnLink() + " ELSE 0 END ) AS "
								+ measure.getId() + kpi_key + ",");
					} else {
						sql.append(" " + agg + "(" + measure.getTableLink() + "."
								+ measure.getColumnLink() + ") AS "
								+ measure.getId() + kpi_key + ",");
						baseKpiSql = measure.getAggregator() + "(" + measure.getTableLink() + "."
								+ measure.getColumnLink() + ") AS " + measure.getId() + kpi_key + ",";
					}
					baseKpiMap.put("TABLENAME", measure.getTableLink().toUpperCase());
					baseKpiMap.put("BASESQL", baseKpiSql);
					if (baseKpiTables != null) {
						if (!baseKpiTables.contains(measure.getTableLink())) {
							baseKpiTables.add(measure.getTableLink());
						}
					}
					baseKpiList.add(baseKpiMap);
					break;
				}
			}
		}
		baseFormKpi.put(kpi_key, baseKpiList);
		if (!"".equals(sql.toString())) {
			return sql.toString().substring(0, sql.toString().length() - 1);
		}
		return sql.toString();
	}

	protected String validateZero(String formula) {
		if (formula.indexOf("/") != -1) {
			StringBuffer sql = new StringBuffer("");
			String str = formula;
			while (str.indexOf("/") != -1) {
				str = str.substring(str.indexOf("/") + 1);
				if (str.trim().startsWith("(")) {
					if(str.indexOf("/") == -1) { 
						if (!"".equals(sql.toString())) {
							sql.append(" or " + str
									+ " = 0 ");
						} else {
							sql.append(" " + str
									+ " = 0 ");
						}
					}
				} else {
					String s = str;
					if (s.indexOf("+") != -1) {
						s = str.replaceAll("\\+", ",");
					} else if (s.indexOf("-") != -1) {
						s = str.replaceAll("\\-", ",");
					} else if (s.indexOf("*") != -1) {
						s = str.replaceAll("\\*", ",");
					} else if (s.indexOf("/") != -1) {
						s = str.replaceAll("\\/", ",");
					}
					if (!"".equals(sql.toString())) {
						sql.append(" or " + s.split(",")[0] + " = 0 ");
					} else {
						sql.append(" " + s.split(",")[0] + " = 0 ");
					}
				}
			}
			return " case when (" + sql.toString() + ") then 0 else ("
					+ formula + ") end ";
		} else {
			return formula;
		}
	}
}
