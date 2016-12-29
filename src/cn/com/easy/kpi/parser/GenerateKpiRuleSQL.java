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
import cn.com.easy.exception.JaxbException;
import cn.com.easy.jaxb.parser.DefaultJaxbParse;
import cn.com.easy.jaxb.parser.JaxbParse;
import cn.com.easy.kpi.element.Condition;
import cn.com.easy.kpi.element.Dictionary;
import cn.com.easy.kpi.element.Dimension;
import cn.com.easy.kpi.element.Formula;
import cn.com.easy.kpi.element.Kpi;
import cn.com.easy.kpi.element.Measure;

public class GenerateKpiRuleSQL {
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

	private List<Map<String, String>> havingList = null;
	// 读取类文件目录
	private String classPath = this.getClass().getClassLoader()
			.getResource("/").getPath();
	// 复合指标组成目录
	private final String kpiXmlPath = "/pages/kpi/custom/formal";
	// 复合指标组成的对象
	private Kpi kpi = null;
	// 复合指标数据源
	private EasyDataSource dataSource = null;
	// 元数据数据源
	private EasyDataSource dataSourceMeta = null;

	private List<Map<String, Object>> opter = null;
	String opterSql = "";

	/**
	 * 通过复合指标ID实例化
	 * 
	 * @param kpiId
	 * @throws Exception
	 */
	public GenerateKpiRuleSQL(String kpiId) throws Exception {
		readKpiTemplate(kpiId);
	}

	/**
	 * 通过复合指标对象实例化
	 * 
	 * @param kpi
	 * @throws Exception
	 */
	public GenerateKpiRuleSQL(Kpi kpi) throws Exception {
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
	public GenerateKpiRuleSQL(List<String> dims, List<String> kpis,
			List<Map<String, String>> wheres, List<Map<String, String>> orders,
			Map<String, String> alias) throws Exception {
		opterSql = "SELECT T.TYPE_ID,T.TYPE_NAME FROM X_FORMULA_TYPE T";
		this.dims = dims; // 实例化报表工具中使用的维度
		this.kpis = kpis;// 实例化报表工具中使用的指标
		this.wheres = wheres;// 实例化报表工具中的查询条件
		this.orders = orders;// 实例化报表工具中的排序字段
		this.alias = alias;// 下钻表格的别名
		dataSource = EasyContext.getContext().getDataSource();// 指标库用到的数据源
		// 元数据的datasource
		dataSourceMeta = EasyContext.getContext().getDataSource();
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
		getMetaBaseDimensions();// 获取基础维度信息
		getMetaBaseMeasures();// 获取基础指标信息
		getFormKpis();// 获取复合指标信息
		this.getOpter();
		// XBuilderSQL语句生成
	}

	/**
	 * 
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> getSqlForBuilder() throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("result", "success");
		try {
			String sql = "";
			if (hasFormKpi()) {
				sql = getSqlSelect(true);// 嵌套select部分
				sql += " from ( ";
				sql += getSqlSelect(false);// 基础指标和基础维度select部分
				sql += getSqlFrom();// 基础指标和基础维度from部分x
				sql += getSqlWhere(true);// 基础指标和基础维度where部分
				sql += getSqlGroup(false);// 基础指标和基础维度group部分
				sql += parseFormKpiToSQL();// 复合指标部分
				sql += " ) a ";
				sql += getSqlWhere(false);// 指标作为查询条件部分
				sql += getSqlGroup(true);// 分组部分
				sql += getSqlHaving(); // 复合指标查询条件
			} else {
				sql += getSqlSelect(false);// 基础指标和基础维度select部分
				sql += getSqlFrom();// 基础指标和基础维度from部分x
				sql += getSqlWhere(true);// 基础指标和基础维度where部分
				sql += getSqlGroup(false);// 基础指标和基础维度group部分
			}
			sql += getSqlOrder();// 排序部分
			// sql += getSqlOrder(false);//排序部分
			map.put("content", sql);
		} catch (Exception e) {
			map.put("result", "failed");
			map.put("content", e.getMessage());
		}
		return map;
	}

	/**
	 * 解析复合指标生成SQL语句（报表工具）
	 * 
	 * @return
	 * @throws Exception
	 */
	protected String parseFormKpiToSQL() throws Exception {
		StringBuffer sqlDim = new StringBuffer(); // 定义报表中select部分使用的维度
		StringBuffer sql = new StringBuffer();// 定义复合指标生成的sql语句
		/*
		 * 报表工具中使用的维度
		 */
		for (int i = 0; i < dims.size(); i++) {
			String dim = dims.get(i);
			if (!baseDims.containsKey(dim)) {
				throw new Exception("基础维度[" + dim + "]中已移除，或者尚未定义");
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
				sqlDim.append(baseDims.get(dim).get("TABLENAME") + "."
						+ baseDims.get(dim).get("FIELD_NAME") + " as "
						+ descAlias + ",");
				sqlDim.append(baseDims.get(dim).get("TABLENAME") + "."
						+ baseDims.get(dim).get("FIELD_CODE") + " as "
						+ codeAlias + ",");
			} else {
				for (int j = 0; j < baseKpiTables.size(); j++) {
					String tables = baseKpiTables.get(j);
					sqlDim.append(tables + "."
							+ baseDims.get(dim).get("DIM_FIELD") + " as "
							+ baseDims.get(dim).get("DIM_FIELD") + ",");
				}
			}
		}
		// 基础指标

		for (Map.Entry<String, Map<String, Object>> baseKpi : baseKpis
				.entrySet()) {
			sqlDim.append(" 0 as " + baseKpi.getValue().get("KPI_FIELD") + ",");
		}
		int i = 0;
		int formKpisMapSize = formKpisMap.size();
		for (Map.Entry<String, Map<String, Object>> formKpi : formKpisMap
				.entrySet()) {
			sql.append(parseKpiToSQL(i, formKpi.getKey(), sqlDim.toString(),
					formKpisMapSize));// 解析复合指标生成SQL语句
			i++;
		}
		return sql.toString();
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

	/**
	 * 解析复合指标
	 * 
	 * @param index
	 * @param kpiId
	 * @param dim
	 * @param size
	 * @return
	 * @throws Exception
	 */
	protected String parseKpiToSQL(int index, String kpiId, String dim, int size)
			throws Exception {
		StringBuffer sql = new StringBuffer();
		if (hasFormKpi()) {
			sql.append(" union all");
		}
		sql.append(" select " + dim.toString());
		String kpiBody = this.ClobToString(formKpisMap.get(kpiId).get(
				"KPI_BODY"));
		parseXMLToKpi(kpiBody);// 获取复合指标的组成结构体
		Formula formula = kpi.getFormulas().getFormula();// 复合指标组成公式
		List<String> kpiTables = new ArrayList<String>();// 复合指标中使用的表
		int i = 0;
		for (Map.Entry<String, Map<String, Object>> formKpi : formKpisMap
				.entrySet()) {
			if (i == index) {
				if ("1".equals(formula.getType())) {// 复合指标的组成为公式
					String formulaSQL = "";// 定义复合指标的公式SQL
					if (i == size - 1)
						formulaSQL = " (" + formula.getFormula() + ") as "
								+ kpiId + "";
					else
						formulaSQL = " (" + formula.getFormula() + ") as "
								+ kpiId + ",";
					// 截取公式中使用的指标 遍历
					for (String id : getMeasuresInFormula(formula.getFormula())) {
						for (Measure measure : getMeasures()) {
							if (id.equals(measure.getId())) {
								// 保存复合指标公式中使用的指标所在的表名
								if (!kpiTables.contains(measure.getTableLink())) {
									kpiTables.add(measure.getTableLink()
											.toUpperCase());
								}
								// 将{指标ID}替换成来源表和来源字段，以及聚合函数
								// 例如：SUM(TABLE.COLUMN)
								formulaSQL = formulaSQL.replaceAll("\\{" + id
										+ "\\}", measure.getAggregator() + "("
										+ measure.getTableLink() + "."
										+ measure.getColumnLink() + ") ");
								break;
							}
						}
					}
					// 生成公式的SQL语句
					sql.append(formulaSQL);
				} else {// 如果复合指标组成是单一的复合指标
					for (Measure measure : getMeasures()) {
						if (formula.getSource().equals(measure.getId())) {// 判断是否是当前组成的基础指标
							// 保存复合指标公式中使用的指标所在的表名
							if (!kpiTables.contains(measure.getTableLink())) {
								kpiTables.add(measure.getTableLink()
										.toUpperCase());
							}
							// 生成复合指标的SQL部分 例如 sum(table.column)
							sql.append(" " + measure.getAggregator() + "("
									+ measure.getTableLink() + "."
									+ measure.getColumnLink() + ") ");
							// 将获取的指标ID 做为字段别名
							if (i == size - 1)
								sql.append(" as " + kpiId + " ");
							else
								sql.append(" as " + kpiId + ",");
							break;
						}
					}
				}
			} else {
				if (i == size - 1) {
					sql.append(" 0 as " + formKpi.getKey() + " ");
				} else {
					sql.append(" 0 as " + formKpi.getKey() + ", ");
				}

			}
			i++;
		}
		// from部分
		sql.append(" from ");
		for (String table : kpiTables) {
			sql.append(" " + table);
			for (Map.Entry<String, Map<String, Object>> baseDim : baseDims
					.entrySet()) {
				// 1代表维度，0代表标签，如果是标签只从事实表中取字段
				if ("1".equals(baseDim.getValue().get("DIM_TYPE"))) {
					sql.append(" LEFT JOIN "
							+ baseDim.getValue().get("TABLENAME") + " ON ");
					sql.append(" " + table + "."
							+ baseDim.getValue().get("DIM_FIELD") + " = "
							+ baseDim.getValue().get("TABLENAME") + "."
							+ baseDim.getValue().get("FIELD_CODE") + " ");
				}
			}
		}
		sql.append(getSqlWhere(true) + " ");
		// where部分
		StringBuffer having = new StringBuffer("");
		String expression = "";
		if (getConditions() != null && getConditions().size() > 0) {
			expression = this.kpi.getConditions().getExpression()
					.getExpression();
			for (Condition condition : getConditions()) {
				if ("baseDimNode".equals(condition.getType())) {// 维度 group by
					Dimension dimension = getDimension(condition.getSource());
					// 只取都是在一个表中的维度
					for (String table : kpiTables) {
						expression = expression.replaceAll(
								"\\{" + dimension.getId() + "\\}", table + "."
										+ dimension.getColumnLink());
					}
				} else if ("baseLabelNode".equals(condition.getType())) {
					Measure measure = getMeasure(condition.getSource());
					expression = expression.replaceAll(
							"\\{" + measure.getId() + "\\}",
							measure.getTableLink() + "."
									+ measure.getColumnLink());
				} else { // 指标 group by having
					Measure measure = getMeasure(condition.getSource());
					expression = expression.replaceAll(
							"\\{" + measure.getId() + "\\}",
							measure.getTableLink() + "."
									+ measure.getColumnLink());
//					having.append("  "
//							+ condition.getCondition().replaceAll(
//									"\\{" + measure.getId() + "\\}",
//									measure.getAggregator() + "("
//											+ measure.getTableLink() + "."
//											+ measure.getColumnLink() + ")"));
				}
			}
		}
		sql.append(expression);
		sql.append(getSqlGroup(false));
//		sql.append(having.toString());	
		return sql.toString();
	}

	public String parseKpiToSQL() throws Exception {
		StringBuffer sql = new StringBuffer("");
		StringBuffer select = new StringBuffer("");
		StringBuffer where = new StringBuffer("");
		StringBuffer group = new StringBuffer("");
		StringBuffer having = new StringBuffer("");
		List<String> tables = new ArrayList<String>();
		Formula formula = kpi.getFormulas().getFormula();
		// select 部分
		if ("1".equals(formula.getType())) {// 公式
			for (String kpiId : getMeasuresInFormula(formula.getFormula())) {
				for (Measure measure : getMeasures()) {
					if (kpiId.equals(measure.getId())) {
						if (!tables.contains(measure.getTableLink())) {
							tables.add(measure.getTableLink());
						}
						select.append(" " + measure.getAggregator() + "("
								+ measure.getTableLink() + "."
								+ measure.getColumnLink() + ") ");
						select.append(" as " + measure.getColumnLink() + ",");
						break;
					}
				}
			}
		} else {// 指标
			for (Measure measure : getMeasures()) {
				if (formula.getSource().equals(measure.getId())) {
					if (!tables.contains(measure.getTableLink())) {
						tables.add(measure.getTableLink());
					}
					select.append(" " + measure.getAggregator() + "("
							+ measure.getTableLink() + "."
							+ measure.getColumnLink() + ") ");
					select.append(" as " + measure.getColumnLink() + ",");
					break;
				}
			}
		}
		// where部分
		int j = 0;
		int k = 0;
		for (Condition condition : getConditions()) {
			if ("0".equals(condition.getType())) {// 维度 group by
				Dimension dimension = getDimension(condition.getSource());
				if (!tables.contains(dimension.getTableLink())) {
					tables.add(dimension.getTableLink());
				}
				/*
				 * 先采用子查询这种模式， 以后考虑用关联 需要添加对应的码表字段 采用select a, (select b from
				 * table t where t.a=b.a) as b from table b
				 */
				Dictionary dictionary = dimension.getDictionary();
				if (!"".equals(dictionary.getKey())
						&& !"".equals(dictionary.getName())
						&& !"".equals(dictionary.getTableLink())) {
					select.append("(select " + dictionary.getName() + " from "
							+ dictionary.getTableLink() + " t ");
					select.append(" where t." + dictionary.getKey() + "="
							+ dimension.getTableLink() + "."
							+ dimension.getColumnLink());
					select.append(") as " + dimension.getColumnLink() + ",");
				} else {
					select.append(" " + dimension.getTableLink() + "."
							+ dimension.getColumnLink() + ",");
				}
				if (j == 0)
					where.append(" where ");
				else
					where.append(" " + condition.getPrepend() + " ");
				where.append(condition.getCondition().replaceAll(
						"\\{" + dimension.getId() + "\\}",
						dimension.getTableLink() + "."
								+ dimension.getColumnLink()));
				group.append(" " + dimension.getTableLink() + "."
						+ dimension.getColumnLink() + ",");
				j++;
			} else { // 指标 group by having
				Measure measure = getMeasure(condition.getSource());
				select.append(" " + measure.getAggregator() + "("
						+ measure.getTableLink() + "."
						+ measure.getColumnLink() + ") ");
				select.append(" as " + measure.getColumnLink() + ",");
				if (k == 0)
					having.append(" having ");
				else
					having.append(" " + condition.getPrepend() + " ");
				having.append("  "
						+ condition.getCondition().replaceAll(
								"\\{" + measure.getId() + "\\}",
								measure.getTableLink() + "."
										+ measure.getColumnLink()));
				k++;
			}
		}
		// select部分
		sql.append(" select ");
		if (!"".equals(select.toString())) {
			sql.append(select.toString().substring(0,
					select.toString().length() - 1));
		}
		// from部分
		sql.append(" from ");
		for (int i = 0; i < tables.size(); i++) {
			if (i == tables.size() - 1) {
				sql.append(" " + tables.get(i) + " ");
			} else {
				sql.append(" " + tables.get(i) + ",");
			}
		}
		// where部分
		if (!"".equals(where.toString())) {
			sql.append(where.toString());
		}
		// group部分
		if (!"".equals(group.toString())) {
			sql.append(" group by "
					+ group.toString().substring(0,
							group.toString().length() - 1));
		}
		// having部分
		if (!"".equals(having.toString())) {
			sql.append(having.toString());
		}
		return sql.toString();
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

	protected void parseXMLToKpi(String kpiXml) throws Exception {
		JaxbParse jaxb = null;
		Kpi kpi = null;
		try {
			jaxb = new DefaultJaxbParse();
			kpi = jaxb.readXmlStr(Kpi.class, kpiXml);
		} catch (JaxbException e) {
			throw new Exception(e);
		}
		this.kpi = kpi;
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
			// "SELECT Z.*,X.DIMCODE FROM (select T.OID, T.NAME,T1.FIELD_CODE DIMCODENAME,T.FIELD_CODE,T.FIELD_NAME,T.TABLENAME,T.LINKTABLE from X_DIMENSION_VIEW T, X_FILELD_VIEW T1 where T.DELETE_FLAG = '0' AND T.TABLECODE = T1.TABLEID AND T1.FIELD_ALIAS = 'CODE_NAME') Z,(select T2.OID, T2.NAME, T3.FIELD_CODE DIMCODE, T2.FIELD_CODE, T2.FIELD_NAME, T2.TABLENAME, T2.LINKTABLE from X_DIMENSION_VIEW T2, X_FILELD_VIEW T3 where T2.DELETE_FLAG = '0' AND T2.TABLECODE = T3.TABLEID AND T3.FIELD_ALIAS = 'CODE') X WHERE Z.OID = X.OID AND X.OID in ( ";
			String sql = "select T.DIM_TYPE,T.CONF_TYPE,T.DIM_OWNER,T.DIM_TABLE,T.DIM_FIELD,T.CONDITION,T.ID,T.DIM_CODE,T.DIM_NAME,T.SRC_ONWER,T.SRC_TABLE,T.SQL_CODE,(SELECT code FROM X_SUB_BASEDIM_INFO WHERE DIM_ID=T.ID AND NAME='code' AND ROWNUM=1) AS FIELD_CODE, (SELECT code FROM X_SUB_BASEDIM_INFO WHERE DIM_ID=T.ID AND NAME='name' AND ROWNUM=1) AS FIELD_NAME from X_BASEDIM_INFO T where DIM_CODE in ( ";
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
				conn = dataSourceMeta.getConnection();
				// Object[] params = new Object[1];
				// params[0] = dim.toString().substring(0,
				// dim.toString().length()-1);
				results = queryRunner.query(conn, sql, params,
						new MapListHandler());
				// 处理结果集
				for (Map<String, Object> map : results) {
					Map<String, Object> dimMap = new HashMap<String, Object>();
					dimMap.put("DIM_TYPE", map.get("DIM_TYPE"));
					// 1代表维度，0代表标签，如果是标签只从事实表中取字段
					if ("1".equals(map.get("DIM_TYPE"))) {
						String dimTable = "";
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
							if (map.get("CONDITION") != null
									&& !"".equals(String.valueOf(map
											.get("CONDITION")))) {
								isSql = true;
								dimTable = " (SELECT "
										+ String.valueOf(map.get("FIELD_CODE"))
										+ ","
										+ String.valueOf(map.get("FIELD_NAME"))
										+ " FROM  " + dimTable + " WHERE "
										+ String.valueOf(map.get("CONDITION"));
							}
						} else {
							isSql = true;
							dimTable = "("
									+ String.valueOf(map.get("SQL_CODE"))
									+ ") ";
						}
						if (isSql) {
							dimTable = dimTable.toUpperCase() + "  "
									+ map.get("DIM_CODE");// 如何是SQL模式给别名
							dimMap.put("TABLENAME", map.get("DIM_CODE"));
						} else {
							dimMap.put("TABLENAME", dimTable.toUpperCase());
						}
						dimMap.put("DIM_FIELD", map.get("DIM_FIELD"));
						dimMap.put("FIELD_CODE", map.get("FIELD_CODE"));
						dimMap.put("FIELD_NAME", map.get("FIELD_NAME"));
					} else {
						dimMap.put("TABLENAME", "");
						dimMap.put("DIM_FIELD", map.get("DIM_FIELD"));
						dimMap.put("FIELD_CODE", "");
						dimMap.put("FIELD_NAME", "");
					}
					baseDims.put(String.valueOf(map.get("DIM_CODE")), dimMap);
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
			// String sql =
			// "select T.OID,T.NAME,T.FIELD_CODE,T.FIELD_NAME,T.TABLENAME from X_KPI_VIEW T where T.DELETE_FLAG='0' AND T.OID in (";
			String sql = " select BASE_KEY,KPI_ORIGIN_SCHEMA,KPI_ORIGIN_TABLE,KPI_ORIGIN_COLUMN from X_BASE_KPI where (TYPE='1' or TYPE='2') and BASE_KEY in ( ";
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
				results = queryRunner.query(conn, sql, params,
						new MapListHandler());
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
		for (String kpi : kpis) {
			if (!isBaseKpi(kpi)) {
				if (!formKpis.contains(kpi)) {
					formKpis.add(kpi);
				}
			}
		}
		for (Map<String, String> map : wheres) {
			if ("kpi".equals(map.get("type"))) {
				if (!isBaseKpi(map.get("id"))) {
					if (!formKpis.contains(map.get("id"))) {
						formKpis.add(map.get("id"));
					}
				}
			}
		}
		for (Map<String, String> map : orders) {
			if ("kpi".equals(map.get("type"))) {
				if (!isBaseKpi(map.get("id"))) {
					if (!formKpis.contains(map.get("id"))) {
						formKpis.add(map.get("id"));
					}
				}
			}
		}
		Connection conn = null;//
		QueryRunner queryRunner = null;
		try {
			if (formKpis.size() > 0) {
				String sql = "select KPI_BODY from X_KPI_INFO where kpi_code = ? ";
				conn = dataSource.getConnection();
				Object[] params = new Object[1];
				for (String kpi : formKpis) {
					queryRunner = new QueryRunner();
					params[0] = kpi;// 指标编码
					Map<String, Object> map = queryRunner.query(conn, sql,
							params, new MapHandler());
					formKpisMap.put(kpi, map);
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

	/**
	 * 
	 * @param tableFlag
	 *            dim or kpi
	 * @param table
	 * @throws Exception
	 */
	protected void addTables(String tableFlag, String table) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put(tableFlag, table);
		for (Map<String, String> myTable : tables) {
			if (!myTable.get(tableFlag).equals(table)) {
				tables.add(map);
			}
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
					sql.append(baseDims.get(dim).get("TABLENAME") + "."
							+ baseDims.get(dim).get("FIELD_NAME") + " AS "
							+ descAlias + ",");
					sql.append(baseDims.get(dim).get("TABLENAME") + "."
							+ baseDims.get(dim).get("FIELD_CODE") + " AS "
							+ codeAlias + ",");
				}
			} else {
				for (int j = 0; j < baseKpiTables.size(); j++) {
					String tables = baseKpiTables.get(j);
					sql.append(tables + "."
							+ baseDims.get(dim).get("DIM_FIELD") + " AS "
							+ baseDims.get(dim).get("DIM_FIELD") + ",");
				}
			}
		}
		// 基础指标部分
		int k = 0;
		for (Map.Entry<String, Map<String, Object>> entry : baseKpis.entrySet()) {
			for (String kpi : kpis) {
				if (isBaseKpi(kpi) && !baseKpis.isEmpty()
						&& !baseKpis.containsKey(kpi)) {
					throw new Exception("基础指标[" + kpi + "]已移除，或者尚未定义");
				}
			}
			if (k == baseKpis.size() - 1) {
				if (isAll)
					sql.append("SUM(" + entry.getValue().get("KPI_FIELD")
							+ ") AS " + entry.getValue().get("KPI_FIELD") + " ");
				else
					sql.append("SUM(" + entry.getValue().get("TABLENAME") + "."
							+ entry.getValue().get("KPI_FIELD") + ") AS "
							+ entry.getValue().get("KPI_FIELD") + " ");
			} else {
				if (isAll)
					sql.append("SUM(" + entry.getValue().get("KPI_FIELD")
							+ ") AS " + entry.getValue().get("KPI_FIELD") + ",");
				else
					sql.append("SUM(" + entry.getValue().get("TABLENAME") + "."
							+ entry.getValue().get("KPI_FIELD") + ") AS "
							+ entry.getValue().get("KPI_FIELD") + ",");
			}
			k++;
		}
		k = 0;
		// 复合指标
		for (Map.Entry<String, Map<String, Object>> entry : formKpisMap
				.entrySet()) {
			if (k == formKpisMap.size() - 1) {
				if (isAll)
					sql.append(" ,SUM(" + entry.getKey() + ") AS "
							+ entry.getKey() + " ");
				else
					sql.append(" , 0 AS " + entry.getKey() + " ");
			} else {
				if (isAll)
					sql.append(" , SUM(" + entry.getKey() + ") AS "
							+ entry.getKey());
				else
					sql.append(" , 0 AS " + entry.getKey());
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
		for (int i = 0; i < baseKpiTables.size(); i++) {
			String table = baseKpiTables.get(i);
			sql.append(" " + table);
			for (Map.Entry<String, Map<String, Object>> baseDim : baseDims
					.entrySet()) {
				if ("1".equals(baseDim.getValue().get("DIM_TYPE"))) {
					sql.append(" LEFT JOIN "
							+ baseDim.getValue().get("TABLENAME") + " ON ");
					sql.append(" " + table + "."
							+ baseDim.getValue().get("DIM_FIELD") + " = "
							+ baseDim.getValue().get("TABLENAME") + "."
							+ baseDim.getValue().get("FIELD_CODE") + " ");
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
		StringBuffer sql = new StringBuffer(" where 1=1 ");
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
											.get("TABLENAME")
									+ "."
									+ baseDims.get(wheres.get(i).get("id"))
											.get("FIELD_CODE") + " >= #"
									+ var_name + "_1# }");
							sql.append(" { and "
									+ baseDims.get(wheres.get(i).get("id"))
											.get("TABLENAME")
									+ "."
									+ baseDims.get(wheres.get(i).get("id"))
											.get("FIELD_CODE") + " <= #"
									+ var_name + "_2# }");
						} else {
							if ("1".equals(wheres.get(i).get("formula"))) { // 多选
								sql.append(" { and "
										+ baseDims.get(wheres.get(i).get("id"))
												.get("TABLENAME")
										+ "."
										+ baseDims.get(wheres.get(i).get("id"))
												.get("FIELD_CODE") + " in( #"
										+ var_name + "# ) }");
							} else {
								sql.append(" { and "
										+ baseDims.get(wheres.get(i).get("id"))
												.get("TABLENAME")
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
					sql.append(baseDims.get(dim).get("TABLENAME") + "."
							+ baseDims.get(dim).get("FIELD_CODE") + ",");
					sql.append(baseDims.get(dim).get("TABLENAME") + "."
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
		StringBuffer having = new StringBuffer(" having 1=1");
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

	/*
	 * 描述：从xml文件中读取指标对象 参数： xmlPath xml文件路径 返回值：指标对象实例
	 */
	protected void readKpiTemplate(String kpiId) throws Exception {
		String xmlPath = classPath.substring(0,
				classPath.indexOf("WEB-INF/classes"));
		xmlPath += kpiXmlPath + "/" + kpiId + ".xml";
		// String xmlPath = "c:/" + kpiId + ".xml";
		JaxbParse jaxb = null;
		Kpi kpi = null;
		try {
			jaxb = new DefaultJaxbParse();
			kpi = jaxb.read(Kpi.class, xmlPath);
		} catch (JaxbException e) {
			throw new Exception(e);
		}
		this.kpi = kpi;
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
			opter = queryRunner.query(dataSource.getConnection(), opterSql,
					null, new MapListHandler());
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
}
