package cn.com.easy.kpi.parser;

import java.io.BufferedReader;
import java.io.Reader;
import java.sql.Clob;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
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
import cn.com.easy.kpi.element.Dimension;
import cn.com.easy.kpi.element.Dimensions;
import cn.com.easy.kpi.element.Formula;
import cn.com.easy.kpi.element.Kpi;
import cn.com.easy.kpi.element.Measure;

public class GenerateKpiRule {
	
	// 复合指标组成的对象
	private Kpi kpi = null;
	// 复合指标数据源
	private EasyDataSource dataSource = null;
	//维度使用的数据源
	private EasyDataSource dimDataSource = null;
	
	private Map<String, Object> kpiMap = null;
	// 复合指标
	private Map<String, Map<String, Object>> formKpisMap = null;
	//指标中用到的表名
	private List<String> kpiUserTables = null;
	
	private List<Map<String,Object>> attrs = null;
	
	private String[] opers = {"等于","包含","大于","小于","不等于","大于等于","小于等于","为空","不为空"};
	
	private String[] operstr = {"=","in",">","<","!=",">=","<= ","is null","is not null"};

	
	/**
	 * 实例化通过KpiId
	 * @param kpiId
	 * @throws Exception 
	 */
	public GenerateKpiRule(String kpiId) throws Exception {
		this.parseKpiXml(kpiId);
		formKpisMap = new HashMap<String, Map<String,Object>>();
		kpiUserTables = new LinkedList<String>();
		attrs = new ArrayList<Map<String,Object>>();
		getFormKpis();
		getAttrs();
	}
	public void getAttrs() throws Exception{
		QueryRunner queryRunner = null;
		Connection conn = null;//
		try {
			String sql = "select ATTR_CODE,ATTR_NAME from X_KPI_ATTRIBUTE where ATTR_TYPE = ? ";
			conn = dataSource.getConnection();
			Object[] params = {kpiMap.get("ACCTTYPE")};
			queryRunner = new QueryRunner();
			attrs = queryRunner.query(conn, sql, params, new MapListHandler());
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception(e);
		} finally {
			if (conn != null)
				conn.close();
		}
	}
	public String getUseTables() throws Exception {
		String tableStr = "";
		if(kpiUserTables.size() > 0) {
			int i = 0 ;
			for (String table : kpiUserTables) {
				if(i ==  kpiUserTables.size()-1) {
					tableStr += table;
				} else {
					tableStr += table + ",";
				}
				i++;
			}
		}
		return tableStr;
	}
	
	public String parseFormulas() throws Exception {
		if(kpiMap == null) {
			throw new Exception("指标ID[" + kpi.getId() + "]，已不存在");
		}
		Formula formula = kpi.getFormulas().getFormula();// 复合指标组成公式
		String formulaSQL = validateZero(formula.getFormula());// 定义复合指标的公式SQL
		for (String id : getMeasuresInFormula(formula.getFormula())) {
			for (Measure measure : getMeasures()) {
				if (id.equals(measure.getId()) || id.substring(0,id.length()-2).equals(measure.getId().substring(0,measure.getId().length()-2))) {
					// 将{指标ID}替换成来源表和来源字段，以及聚合函数
					if("1".equals((String)kpiMap.get("KPI_TYPE"))) {
						formulaSQL = formulaSQL.replaceAll("\\{" + id
								+ "\\}",  "("
								+ measure.getTableLink() + "."
								+ measure.getColumnLink() + ") ");
						if(!kpiUserTables.contains(measure.getTableLink())) {
							kpiUserTables.add(measure.getTableLink());
						}
					} else {
						String[] kpis = id.split("_");
						String s = "";
						if(kpis.length > 2) {
							if(!"A".equals(kpis[kpis.length-1].toUpperCase())) {
								s = "_" + kpis[2];
							} 
						}
						
						formulaSQL = formulaSQL.replaceAll("\\{" + id
								+ "\\}",  "("
								+  String.valueOf(formKpisMap.get(measure.getKpiKey()).get("KPI_TABLE"))+ "."
								+  String.valueOf(formKpisMap.get(measure.getKpiKey()).get("KPI_COLUMN")) + s + ") ");
						
						if(!kpiUserTables.contains(formKpisMap.get(measure.getKpiKey()).get("KPI_TABLE"))) {
							kpiUserTables.add((String)formKpisMap.get(measure.getKpiKey()).get("KPI_TABLE"));
						}
					}
					break;
				}
				
			}
		}
		return formulaSQL;
	}
	
	public String parseExpression() throws Exception {
		String expression = "";
		if (getConditions() != null && getConditions().size() > 0) {
			expression = this.kpi.getConditions().getExpression()
					.getExpression();
			if(!"AND".equals(expression.toUpperCase()) && !"OR".equals(expression.toUpperCase()) && !"(".equals(expression) && !")".equals(expression)){
				for (Condition condition : getConditions()) {
					if ("5".equals(condition.getType())) {
						Measure measure = getMeasure(condition.getSource());
						expression = expression.replaceAll(
								"\\{" + measure.getId() + "\\}",
								measure.getTableLink() + "."
										+ measure.getColumnLink());
						if(!kpiUserTables.contains(measure.getTableLink())) {
							kpiUserTables.add(measure.getTableLink());
						}
						continue;
					}
					Dimension dimension = getDimension(condition.getSource());
					if(dimension != null) {
						expression = expression.replaceAll(
								"\\{" + dimension.getId() + "\\}",
										 dimension.getColumnLink());
						//判断是会否是schema.table.column
						if(dimension.getColumnLink().indexOf(".") != -1) {
							String dimtables = dimension.getColumnLink();
							dimtables = dimtables.substring(0, dimtables.lastIndexOf("."));
							if(!kpiUserTables.contains(dimtables)) {
								kpiUserTables.add(dimtables);
							}
						}
//						if("1".equals(dimension.getConfType())) {
////							String dimtables = dimension.getDictionary().getDictionary();
//							//暂时没考虑怎么处理
//						} else {
//							if(dimension.getColumnLink().indexOf(".") != -1) {
//								String dimtables = dimension.getColumnLink();
//								dimtables = dimtables.substring(0, dimtables.lastIndexOf("."));
//								if(!kpiUserTables.contains(dimtables)) {
//									kpiUserTables.add(dimtables);
//								}
//							}
//						}
					
						continue;
					}
					if("1".equals((String)kpiMap.get("KPI_TYPE"))) {
						//指标或者属性
						if ("4".equals(condition.getType())) {
							Measure measure = getMeasure(condition.getSource());
							expression = expression.replaceAll(
									"\\{" + measure.getId() + "\\}",
									measure.getTableLink() + "."
											+ measure.getColumnLink());
							if(!kpiUserTables.contains(measure.getTableLink())) {
								kpiUserTables.add(measure.getTableLink());
							}
						}
					} else {
						String[] kpis = condition.getSource().split("_");
						String s = "";
						if(kpis.length > 2) {
							if(!"A".equals(kpis[kpis.length-1].toUpperCase())) {
								s = "_" + kpis[2];
							}
						}
						Measure measure = getMeasure(condition.getSource());
						if(null!=measure){
							if(measure.getId().startsWith("BK_")) {
								expression = expression.replaceAll(
										"\\{" + measure.getId() + "\\}",
										measure.getTableLink() + "."
												+ measure.getColumnLink());
								if(!kpiUserTables.contains(measure.getTableLink())) {
									kpiUserTables.add(measure.getTableLink());
								}
							} else {
								expression = expression.replaceAll(
										"\\{" + measure.getId() + "\\}",
										String.valueOf(formKpisMap.get(measure.getKpiKey()).get("KPI_TABLE")) + "."
												+ String.valueOf(formKpisMap.get(measure.getKpiKey()).get("KPI_COLUMN")) + s);
								if(!kpiUserTables.contains(formKpisMap.get(measure.getKpiKey()).get("KPI_TABLE"))) {
									kpiUserTables.add((String)formKpisMap.get(measure.getKpiKey()).get("KPI_TABLE"));
								}
							}
						}
					}
				}
			} else {
				expression = "";
			}
		}
		return expression;//.replaceAll("'", "''");
	}
	
	public String parseKpi() throws Exception {
		StringBuffer sql = new StringBuffer("");
		String expression = parseExpression();
		String formulaSQL = parseFormulas();
		if(!"".equals(expression)) {
			sql.append(" CASE WHEN ");
			if(expression.trim().toUpperCase().startsWith("AND")){
				expression = expression.trim().substring(3);
			} else if(expression.trim().toUpperCase().startsWith("OR")) {
				expression = expression.trim().substring(2);
			}
			if(expression.trim().toUpperCase().endsWith("AND")) {
				expression = expression.trim().substring(0,expression.trim().length()-3);
			} else if (expression.trim().toUpperCase().endsWith("OR")) {
				expression = expression.trim().substring(0,expression.trim().length()-2);
			}
			sql.append(expression);
			sql.append(" THEN TO_NUMBER("+ formulaSQL +") ELSE 0 END ");
		} else {
			sql.append(formulaSQL);
		}
		return sql.toString();
	}
	protected void getFormKpis() throws Exception {
		List<Measure> measures = getMeasures();
		if(measures != null && measures.size() > 0) {
			Connection conn = null;//
			QueryRunner queryRunner = null;
			try {
				String sql = "select KPI_KEY,KPI_TABLE,KPI_COLUMN,KPI_NAME from X_KPI_INFO_TMP where kpi_key in ( ";
				String params = "";
				int i = 0;
				for(Measure measure : measures) {
					if(measure.getId().startsWith("FK_")){
						sql = sql + "?,";
						params += measure.getKpiKey() + ",";
						i++;
					}
				}
				if(!"".equals(params)) {
					queryRunner = new QueryRunner();
					conn = dataSource.getConnection();
					sql = sql.substring(0, sql.length() - 1);
					sql = sql + ")";
					if(!"".equals(params)) {
						params = params.substring(0,params.length()-1);
					}
					String[] sqlparams = params.split(",");
					List<Map<String, Object>> results = queryRunner.query(conn, sql, sqlparams, new MapListHandler());
					// 处理结果集
					for (Map<String, Object> map : results) {
						formKpisMap.put(String.valueOf(map.get("KPI_KEY")), map);
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
	/**
	 * 
	 * @return
	 */
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
		if(this.kpi != null) {
			Dimensions  dimensions = this.kpi.getDimensions();
			if(dimensions != null && dimensions.getDimensionList() != null && dimensions.getDimensionList().size() > 0) {
				return this.kpi.getDimensions().getDimensionList();
			}
		}
		return null;
	}

	protected Dimension getDimension(String id) {
		List<Dimension>  dimensions = getDimensions();
		if(dimensions != null) {
			for (Dimension dimension : dimensions) {
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
	/**
	 * 通过kpiId解析衍生指标
	 * @param kpiId
	 */
	protected void parseKpiXml(String kpiId) throws Exception{
		dataSource = EasyContext.getContext().getDataSource();// 指标库用到的数据源
		QueryRunner queryRunner = null;
		Connection conn = null;//
		try {
			if (kpiId != null && !"".equals(kpiId)) {
				String sql = "select KPI_TYPE,KPI_BODY,ACCTTYPE from X_KPI_INFO_TMP where kpi_key = ? ";
				conn = dataSource.getConnection();
				Object[] params = {kpiId};
				queryRunner = new QueryRunner();
				kpiMap = queryRunner.query(conn, sql, params, new MapHandler());
				if(kpiMap != null && kpiMap.get("KPI_BODY") != null) {
					parseXMLToKpi(this.ClobToString(kpiMap.get("KPI_BODY")));
				} else {
					this.kpi = null;
				}
			} else {
				this.kpi = null;
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
	 * 将衍生指标映射成指标对象
	 * @param kpiXml
	 * @throws Exception
	 */
	protected void parseXMLToKpi(String kpiXml) throws Exception {
		JaxbParse jaxb = null;
		Kpi kpi = null;
		try {
			jaxb = new DefaultJaxbParse();
			kpi = jaxb.readXmlStr(Kpi.class, kpiXml);
		} catch (JaxbException e) {
			e.printStackTrace();
			throw new Exception(e);
		}
		this.kpi = kpi;
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

	protected String validateZero(String formula) {
		if(formula.indexOf("/") != -1) {
			StringBuffer sql = new StringBuffer("");
			String str = formula;
			while (str.indexOf("/") !=-1) {
				str = str.substring(str.indexOf("/") + 1);
				try {
					Double.parseDouble(str);
				} catch(Exception e) {
					if(str.trim().startsWith("(")) {
						if(!"".equals(sql.toString())) {
							sql.append(" OR " + str.substring(0, str.indexOf(")")+1) + " = 0 ");
						} else {
							sql.append(" " + str.substring(0, str.indexOf(")")+1) + " = 0 ");
						}
					} else {
						String s = str;
						if (s.indexOf("+") != -1) {
							s = str.replaceAll("\\+", ",");
						} else if (s.indexOf("-") != -1) {
							s = str.replaceAll("\\-", ",");
						} else if(s.indexOf("*") != -1) {
							s = str.replaceAll("\\*", ",");
						} else if(s.indexOf("/") != -1){
							s = str.replaceAll("\\/", ",");
						}
						if(!"".equals(sql.toString())) {
							sql.append(" OR " + s.split(",")[0] + " = 0 ");
						} else {
							sql.append(" " + s.split(",")[0] + " = 0 ");
						}
					}
				}
				
			}
			return " CASE WHEN (" + sql.toString() + ") THEN 0 ELSE ("+ formula +") END ";
		} else {
			return formula;
		}
	}
	
	public String parseExpressionDesc() throws Exception {
		StringBuffer express = new StringBuffer("");
		String expression = "";
		if (getConditions() != null && getConditions().size() > 0) {
			int i = 1;
			for(Condition condition : getConditions()) {
				boolean flag = false;
				String[] kpis = condition.getSource().split("_");
				String s = "";
				if(kpis.length > 2) {
					for(Map<String,Object> attrMap : attrs) {
						if(kpis[2].equals(attrMap.get("ATTR_CODE"))) {
							s = "_" + attrMap.get("ATTR_NAME");
							break;
						}
					}
				}
				if("0".equals(condition.getType())) { //逻辑符
					if("AND".equals(condition.getOperator().toUpperCase())){
						express.append(" 并且 ");
					} else {
						express.append(" 或者 ");
					}
					flag = true;
				} else if("5".equals(condition.getType())) {//标签
					if(flag == false && i%2 == 0) {
						express.append(" 并且 ");
					}
					String value =  "1".equals(condition.getParamsValue())?"是":"否";
					Measure measure = getMeasure(condition.getSource());
					if(measure != null) {
						express.append(measure.getName() + s + " " +opers[Integer.parseInt(condition.getOperator())] + " " + value + " ");
					}
				} else if("6".equals(condition.getType())) {//维度
					if(flag == false && i%2 == 0) {
						express.append(" 并且 ");
					}
					Dimension dimension = getDimension(condition.getSource());
					if(dimension != null) {
						dimDataSource = EasyContext.getContext().getDataSource(dimension.getDataSource());
						Connection conn = null;
						QueryRunner queryRunner = null;
						StringBuffer sql = new StringBuffer("");
						try {
							sql.append(" SELECT " + dimension.getDictionary().getKey().toUpperCase() +"," );
							sql.append(" " + dimension.getDictionary().getName().toUpperCase() + " FROM ");
							if("1".equals(dimension.getConfType())) {
								sql.append(" " + dimension.getDictionary().getTableLink() + " ");
							} else {
								sql.append(" (" + dimension.getDictionary().getDictionary() + ") T");
							}
							sql.append(" WHERE " + dimension.getDictionary().getKey() + " ");
							if("1".equals(condition.getOperator())) {
								sql.append(" in ('" + condition.getParamsValue().replaceAll(",", "','")+"')");
							} else {
								if(Integer.parseInt(condition.getOperator()) > 6) {
									sql.append(" " + operstr[Integer.parseInt(condition.getOperator())] +" ");
								} else {
									sql.append(" " + operstr[Integer.parseInt(condition.getOperator())] +" " + "'"+  condition.getParamsValue() +"'");
								}
							}
							conn = dimDataSource.getConnection();
							queryRunner = new QueryRunner();
							List<Map<String, Object>> results = queryRunner.query(conn, sql.toString(), new MapListHandler());
							if(results != null && results.size() > 0) {
								String value = "";
								int j = 0;
								for(Map<String,Object> map : results) {
									if (j == results.size()-1) {
										value += String.valueOf(map.get(dimension.getDictionary().getName().toUpperCase()));
									} else {
										value += String.valueOf(map.get(dimension.getDictionary().getName().toUpperCase())) + "、";
									}
									j++;
								}
								express.append(dimension.getName() + " " +opers[Integer.parseInt(condition.getOperator())] + " " + value + " ");
							}

						} catch (Exception e) {
							e.printStackTrace();
							throw new Exception(e);
						} finally {
							if (conn != null)
								conn.close();
						}
					}
				} else {//指标
					if(flag == false && i%2 == 0) {
						express.append(" 并且 ");
					}
					if("1".equals((String)kpiMap.get("KPI_TYPE"))) {
						//指标或者属性
						if ("4".equals(condition.getType())) {
							Measure measure = getMeasure(condition.getSource());
							if(measure != null) {
								express.append(measure.getName() + s + " " +opers[Integer.parseInt(condition.getOperator())] + " " + condition.getParamsValue() + " ");
							}
						}
					} else {
						Measure measure = getMeasure(condition.getSource());
						if(null!=measure){
							if(measure.getId().startsWith("BK_")) {
								if(measure != null) {
									express.append(measure.getName() + s + " " +opers[Integer.parseInt(condition.getOperator())] + " " + condition.getParamsValue() + " ");
								}
							} else {
								if(measure != null) {
									express.append(String.valueOf(formKpisMap.get(measure.getKpiKey()).get("KPI_NAME")) + s + " " +opers[Integer.parseInt(condition.getOperator())] + " " + condition.getParamsValue() + " ");
								}
							}
						}
					}
				}
				i++;
			}
		}
		expression =express.toString();
		if(expression != null && !"".equals(expression)) {
			expression = expression.replaceAll("and", "并且").replaceAll("or", "或者");
		}
		return expression;
	}
	
	public String parseFormulasDesc() throws Exception {
		if(kpiMap == null) {
			throw new Exception("指标ID[" + kpi.getId() + "]，已不存在");
		}
		Formula formula = kpi.getFormulas().getFormula();// 复合指标组成公式
		String formulaSQL = formula.getFormula();// 定义复合指标的公式SQL
		for (String id : getMeasuresInFormula(formula.getFormula())) {
			for (Measure measure : getMeasures()) {
				if (id.equals(measure.getId()) || id.substring(0,id.length()-2).equals(measure.getId().substring(0,measure.getId().length()-2))) {
					// 将{指标ID}替换成来源表和来源字段，以及聚合函数
					if("1".equals((String)kpiMap.get("KPI_TYPE"))) {
						formulaSQL = formulaSQL.replaceAll("\\{" + id
								+ "\\}",  "("
								+ measure.getName()+ ") ");
						if(!kpiUserTables.contains(measure.getTableLink())) {
							kpiUserTables.add(measure.getTableLink());
						}
					} else {
						String[] kpis = id.split("_");
						String s = "";
						if(kpis.length > 2) {
							for(Map<String,Object> attrMap : attrs) {
								if(kpis[2].equals(attrMap.get("ATTR_CODE"))) {
									s = "_" + attrMap.get("ATTR_NAME");
									break;
								}
							}
						}
						if(formKpisMap.isEmpty()||formKpisMap == null||!formKpisMap.containsKey(measure.getKpiKey())) {
							formulaSQL = "";
						} else {
							formulaSQL = formulaSQL.replaceAll("\\{" + id
									+ "\\}",  "("
									+  String.valueOf(formKpisMap.get(measure.getKpiKey()).get("KPI_NAME"))+ s + ") ");
							if(!kpiUserTables.contains(formKpisMap.get(measure.getKpiKey()).get("KPI_TABLE"))) {
								kpiUserTables.add((String)formKpisMap.get(measure.getKpiKey()).get("KPI_TABLE"));
							}
						}
					}
					break;
				}
				
			}
		}
		return formulaSQL;
	}
}
