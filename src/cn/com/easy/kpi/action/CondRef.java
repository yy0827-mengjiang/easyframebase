package cn.com.easy.kpi.action;

import java.io.FileInputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.exception.JaxbException;
import cn.com.easy.jaxb.parser.DefaultJaxbParse;
import cn.com.easy.jaxb.parser.JaxbParse;
import cn.com.easy.kpi.element.Condition;
import cn.com.easy.kpi.element.Conditions;
import cn.com.easy.kpi.element.Condstr;
import cn.com.easy.kpi.element.Expression;
import cn.com.easy.kpi.element.Kpi;
import cn.com.easy.kpi.parser.GenerateKpi;
/**
 * 指标库刷XML及刷生成SQL的方法
 * @author Sunxq
 *
 */
@Controller
public class CondRef {
	private SqlRunner runner;
//	private String sqlXML = "select t.kpi_key||'' kpi_key,t.kpi_body,t.kpi_code from X_KPI_INFO t ";
	private String sqlXML = "select * from x_kpi_info_tmp t where t.kpi_code='FK_20160505160557741'";
	@Action("refCond")
	public void refCond(HttpServletRequest request, HttpServletResponse response) {
		List<Map<Object, Object>> kpis = new ArrayList<Map<Object, Object>>();
		try {
			List<Map<String, String>> xmls = (List<Map<String, String>>) runner
					.queryForMapList(sqlXML);
			for (Map<String, String> map : xmls) {
				String expression = "";
				Kpi kpi = parseXMLToKpi(map.get("KPI_BODY"));
				List<Condition> condintion = kpi.getConditions()
						.getConditionList();
				String condstr = kpi.getCondstr().getCondStr();
				if (null != condintion && !condintion.isEmpty()) {
					expression += this.Expression(expression, condintion);
					String conds = this.conds(condstr);
					Conditions conditions = kpi.getConditions();
					Expression expression1 = new Expression();
					expression1.setExpression(expression);
					conditions.setExpression(expression1);
					kpi.setConditions(conditions);
					Condstr c = new Condstr();
					c.setCondStr(conds);
					kpi.setCondstr(c);
					GenerateKpi gk = new GenerateKpi();
					gk.writeKpiTemplate(map.get("KPI_CODE"), kpi);
					String kpiBody = new String(
							gk.toByteArrayFromInputStream(new FileInputStream(
									gk.getFilePath() + gk.getSuffix())),
							"UTF-8");
					System.out.println(kpiBody);
					Map<Object, Object> xml = new HashMap<Object, Object>();
					xml.put("key", map.get("kpi_key"));
					xml.put("xml", kpiBody);
					kpis.add(xml);
				}
			}
			this.updateXml(kpis);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@Action("refSql")
	public void refSql(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String querySql = "select sql_id,b.kpi_key from x_kpi_sql_info a, x_kpi_info_tmp b where a.kpi_code = b.kpi_code and a.kpi_version = b.kpi_version and b.kpi_key in (3133,3513)";
		String updateSql = "update x_kpi_sql_info t set t.kpi_sql=?,t.rule_column=?,t.formula_column=?,t.user_table=? where t.sql_id=?";
		List<Map<Object,Object>> list = (List<Map<Object, Object>>) runner.queryForMapList(querySql);
		for(int i=0;i<list.size();i++){
			Map<Object,Object> map = list.get(i);
			cn.com.easy.kpi.parser.GenerateKpiRule kpiRule = new cn.com.easy.kpi.parser.GenerateKpiRule(map.get("kpi_key").toString());
			String sql = kpiRule.parseKpi();
			String rule_column = kpiRule.parseExpression();
			String formula_column = kpiRule.parseFormulas();
			String user_table = kpiRule.getUseTables();
			Object[] o = new Object[5];
			o[0]=sql;
			o[1]=rule_column;
			o[2]=formula_column;
			o[3]=user_table;
			o[4]=map.get("sql_id");
			System.err.println("---------------");
			System.out.println(map.get("kpi_key").toString());
			System.err.println("---------------");
			runner.execute(updateSql, o);

		}
	}

	private String conds(String condstr) {
		condstr = condstr.replace("&lt;", "<").replace("&gt;", ">")
				.replace("\"", "'");
		condstr = condstr
				.replace(
						"<td name='oper' nodeid='0'><select style='width:200px' attrname='nodeId'><option value='and'>并且</option>",
						"<td name='oper' nodeid='and'><select style='width:200px' attrname='nodeId'><option value='and'>并且</option>")
				.replace("'=''", "").replace("'", "\"");
		
		return condstr;
	}

	private String Expression(String exp, List<Condition> condintion) {
		String type = "0";
		String logic = "";
		String logicTmp = "";
		for (int i = 0; i < condintion.size(); i++) {
			Condition cond = condintion.get(i);
			if (!"3".equals(cond.getParamsType())) {
				if ("".equals(exp)) {
					logic = "and";
				} else if ("3".equals(type) && !"".equals(exp)) {
					if(")".equals(logicTmp)){
						logic = "and";
					}else{
						logic = "";
					}
				}else {
					logic = "and";
				}
				exp += " " + logic;
				String code = cond.getSource();
				String operatorCode = cond.getOperator();
				String operator = this.getOperator(operatorCode);
				String paramsValue = cond.getParamsValue();
				if ("1".equals(operatorCode)) {
					String[] ss = paramsValue.split(",");
					exp += " {" + code + "} ";
					exp += " " + operator + " (";
					for (int s = 0; s < ss.length; s++) {
						exp += "'" + ss[s] + "',";
					}
					exp = exp.substring(0, exp.length() - 1);
					exp += ") ";

				} else if ("7".equals(operatorCode)) {
					exp += " {" + code + "} ";
					exp += " " + operator;
				} else if ("8".equals(operatorCode)) {
					exp += " {" + code + "} ";
					exp += " " + operator;
				} else {

					exp += " {" + code + "} ";
					exp += " " + operator;
					exp += " '" + paramsValue + "'";
				}
				type = "0";
			} else {
				type = "3";
				if ("and".equals(cond.getOperator())) {
					logic = " " + cond.getOperator();
					logicTmp = "and";
				} else if (("or".equals(cond.getOperator()))) {
					logic = " " + cond.getOperator();
					logicTmp = "or";
				} else if (")".equals(cond.getOperator())) {
					logic = " " + cond.getOperator();
					logicTmp = ")";
				} else if ("(".equals(cond.getOperator()) && "".equals(exp)) {
					logic = " and " + cond.getOperator();
					logicTmp = "and (";
				} else if ("(".equals(cond.getOperator()) && !"".equals(exp)) {
					logic = "  " + cond.getOperator();
					logicTmp = "(";
				} else {
					logic = " and ";
				}
				exp += " " + logic;
				if ("0".equals(cond.getOperator())) {
					cond.setOperator("and");
				}
			}
		}
		return exp;
	}

	private String getOperator(String operatorCode) {
		String logic = "";
		if ("0".equals(operatorCode)) {
			logic = " = ";
		} else if ("1".equals(operatorCode)) {
			logic = " in ";
		} else if ("2".equals(operatorCode)) {
			logic = " > ";
		} else if ("3".equals(operatorCode)) {
			logic = " < ";
		} else if ("4".equals(operatorCode)) {
			logic = " <> ";
		} else if ("5".equals(operatorCode)) {
			logic = " >= ";
		} else if ("6".equals(operatorCode)) {
			logic = " <= ";
		} else if ("7".equals(operatorCode)) {
			logic = " is null";
		} else if ("8".equals(operatorCode)) {
			logic = " is not null";
		} else {

		}

		return logic;
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
	private void updateXml(List<Map<Object, Object>> kpis) throws SQLException{
		Object[] o = new Object[2];
		for(int i=0;i<kpis.size();i++){
			o[0]=((Map<Object, Object>)kpis.get(i)).get("xml");
			o[1]=((Map<Object, Object>)kpis.get(i)).get("key");
			String updateSql = "update x_kpi_info_tmp t set t.kpi_body = ? where t.kpi_key=?";
			runner.execute(updateSql, o);

		}
	
		
	}
}
