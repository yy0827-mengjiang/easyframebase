package cn.com.easy.ebuilder.action;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.ebuilder.parser.CommonTools;
import cn.com.easy.ebuilder.util.ListUtil;
import cn.com.easy.ebuilder.util.StringUtil;
import cn.com.easy.util.SqlUtils;

import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class ReportSql {
	private SqlRunner runner;

	@Action("datafirst")
	public void first(HttpServletResponse response, String dataName,
			String dataSql,String databaseName) {
		PrintWriter out = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			// 去除｛｝对
			dataSql = StringUtil.formatSql(dataSql, "{", "}");
			// 判断sql是否合法
			if (dataSql.indexOf("AND") == 0) {
				out.print("FAIL第" + dataSql.substring(3)
						+ "个{}对内的应该存在AND|OR，请检查SQL拼写！");
				return;
			} else if ("COUNT".equals(dataSql)) {
				out.print("FAIL有部分##对没有被｛｝格式或者｛｝格式内不存在##对！");
				return;
			} else if (dataSql == null) {
				out.print("FAILSQL格式拼写错误:｛｝没有成对出现或不正确的对！");
				return;
			}
			// 获得##对的变量名称集合
			List<String> parameterNames = new ArrayList<String>();
			SqlUtils.parseParameter(dataSql, parameterNames);
			// 去除重复的变量
			parameterNames = ListUtil.removeDuplicateWithOrder(parameterNames);
			//dataSql = "select * from (" + dataSql + ") where rownum=1";
			dataSql = CommonTools.getSql(databaseName,dataSql);
			int reg = StringUtil.getCounts(dataSql, "#");
			StringBuffer res = new StringBuffer("SUCCESS");
			Map reqMap = new HashMap();
			// 判断#的数量。是否成对出现
			if (reg % 2 != 0) {
				out.print("FAIL请检查#是否成对出现！");
				return;
			}
			for (String s : parameterNames) {
				res.append(s).append(",");
				reqMap.put(s, null);
			}
			// 执行该sql，确保该sql符合语法
			System.out.println(databaseName);
			if (databaseName != null && !databaseName.equals("")
					&& !databaseName.toUpperCase().trim().equals("NULL")
					&& !databaseName.trim().equals(""))
				runner.queryForMapList(databaseName,dataSql, reqMap);
			else 
				runner.queryForMapList(dataSql, reqMap);
			// 删除最后一个逗号
			if (res.toString().length() > 7)
				res.deleteCharAt(res.length() - 1);
			out.print(res.toString());
		} catch (Exception e) {
			if(e.getMessage().indexOf("\n") == -1)
				out.print("FAIL"  + e.getMessage());
			else
				out.print("FAIL"  + e.getMessage().substring(e.getMessage().indexOf(":") + 1, e.getMessage().indexOf("\n")));
			e.printStackTrace();
		}
	}

	@Action("datatemp")
	public void tempData(HttpServletResponse response, String dataSql,
			String dataValue,String databaseName) {
		PrintWriter out = null;
		Map reqMap = new HashMap();
		Map resMap = new HashMap();
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			// 根据规则格式化sql
			dataSql = dataSql.replaceAll("##", "'");
			dataSql = StringUtil.formatSql(dataSql, "{", "}");
			// 判断sql是否合法
			if (dataSql.indexOf("AND") == 0) {
				out.print("FAIL第" + dataSql.substring(3)
						+ "个{}对内的应该存在AND|OR，请检查SQL拼写！");
				return;
			} else if ("COUNT".equals(dataSql)) {
				out.print("FAIL有部分##对没有被｛｝格式或者｛｝格式内不存在##对！");
				return;
			} else if (dataSql == null) {
				out.print("FAILSQL格式拼写错误:｛｝没有成对出现或不正确的对！");
				return;
			}
			// ##对内的变量名称集合
			List<String> parameterNames = new ArrayList<String>();
			SqlUtils.parseParameter(dataSql, parameterNames);
			// 删除重复的变量名
			parameterNames = ListUtil.removeDuplicateWithOrder(parameterNames);
			// 得到输入变量的值
			String[] value = dataValue.split(",");
			String temp_value = "";
			for (int i = 0; i < parameterNames.size(); i++) {
				if (i < value.length)
					temp_value = value[i];
				else
					temp_value = "";
				// 为变量赋值
				reqMap.put(parameterNames.get(i), temp_value);
			}
			//dataSql = "select * from (" + dataSql + ") inits where  rownum <= 10";
			dataSql = CommonTools.getSql(databaseName,dataSql);
			List<Map> l = null;
			// 判断页面是否为变量赋值，并根据不同情况采取相应的操作
			if (reqMap.size() == 0){
				if (databaseName != null && !databaseName.equals("")
						&& !databaseName.toUpperCase().trim().equals("NULL")
						&& !databaseName.trim().equals(""))
					l = (List<Map>) runner.queryForMapList(databaseName,dataSql.replaceAll("&", "\""),(Object[])null);
				else 
					l = (List<Map>) runner.queryForMapList(dataSql.replaceAll("&", "\""));
			}else{
				if (databaseName != null && !databaseName.equals("")
						&& !databaseName.toUpperCase().trim().equals("NULL")
						&& !databaseName.trim().equals(""))
					l = (List<Map>) runner.queryForMapList(databaseName,dataSql.replaceAll("&", "\""), reqMap);
				else 
					l = (List<Map>) runner.queryForMapList(dataSql.replaceAll("&", "\""), reqMap);
			}
			resMap.put("rows", l);
			resMap.put("total", l.size());
			// 返回json
			ObjectMapper mapper = new ObjectMapper();
			out.print(mapper.writeValueAsString(resMap).toString());
		} catch (Exception e) {
			if(e.getMessage().indexOf("\n") == -1)
				out.print("FAIL"  + e.getMessage());
			else
				out.print("FAIL" + e.getMessage().substring(e.getMessage().indexOf(":") + 1, e.getMessage().indexOf("\n")));
			e.printStackTrace();
		}
	}

	@Action("getfield")
	public void getfield(HttpServletResponse response, String dataSql,
			String dataValue,String databaseName) {
		PrintWriter out = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			dataSql = StringUtil.formatSql(dataSql, "{", "}");
			if (dataSql.indexOf("AND") == 0) {
				out.print("FAIL第" + dataSql.substring(3)
						+ "个{}对内的应该存在AND|OR，请检查SQL拼写！");
				return;
			} else if ("COUNT".equals(dataSql)) {
				out.print("FAIL有部分##对没有被｛｝格式或者｛｝格式内不存在##对！");
				return;
			} else if (dataSql == null) {
				out.print("FAILSQL格式拼写错误:｛｝没有成对出现或不正确的对！");
				return;
			}
			List<String> parameterNames = new ArrayList<String>();
			String[] value = dataValue.split(",");
			String sql = SqlUtils.parseParameter(dataSql, parameterNames);
			System.out.println(dataSql);
			//dataSql = "select * from (" + sql + ") inits where rownum =1";
			dataSql = CommonTools.getSql(databaseName,sql);
			Connection con =  CommonTools.getConnection(databaseName);//runner.getDataSource().getConnection();
			PreparedStatement ps = con.prepareStatement(dataSql);
			for (int i = 0; i < parameterNames.size(); i++) {
				ps.setString(i + 1, "");
			}
			ResultSet rs = ps.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			int cols = rsmd.getColumnCount();
			StringBuffer colNames = new StringBuffer("SUCCESS");
			for (int i = 1; i <= cols; i++) {
				colNames.append(rsmd.getColumnName(i));
				if (i != cols)
					colNames.append(",");
			}
			out.print(colNames.toString());
			try{
				rs.close();
				ps.close();
				con.close();
			}catch(Exception e){
				e.printStackTrace();
				System.err.println("ReportSql.getfield方法释放连接时，出错:"+e.getMessage());
			}
		} catch (Exception e) { 
			if(e.getMessage().indexOf("\n") == -1)
				out.print("FAIL"  + e.getMessage());
			else
				out.print("FAIL" + e.getMessage().substring(e.getMessage().indexOf(":") + 1, e.getMessage().indexOf("\n")));
			e.printStackTrace();
		}
	}

	@Action("varset")
	public void varJudge(String report_id, HttpServletResponse response) {
		Map varMap = new HashMap();
		varMap.put("report_id", report_id);
		String sql = "select d.dim_var_name from  sys_report_var_dim d where d.report_id=#report_id#";
		String sql_count = "";
		String del_sql = "";
		int count = 0;
		Connection con = null;
		PrintWriter out = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			con = CommonTools.getConnection();//runner.getDataSource().getConnection();
			List<Map> lm = (List<Map>) runner.queryForMapList(sql, varMap);
			for (Map m : lm) {
				// 判断该约束是否在该报表下的数据集中存在
				sql_count = "select count(1) from sys_report_sql r where r.report_sql like '%#"
						+ m.get("dim_var_name") + "#%' and report_id=?";
				PreparedStatement ps = con.prepareStatement(sql_count);
				ps.setString(1, report_id);
				ResultSet rs = ps.executeQuery();
				rs.next();
				count = rs.getInt(1);
				if (count == 0) {
					// 如果不存在，删除该约束
					del_sql = "delete from sys_report_var_dim where report_id=#report_id# and dim_var_name='"
							+ m.get("dim_var_name") + "'";
					runner.execute(del_sql, varMap);
				}
				rs.close();
				ps.close();
			}
			out.print("SUCCESS");
		} catch (Exception e) {
			out.print("FAIL");
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
				out.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	@Action("othervarset")
	public void otherVarJudge(HttpServletResponse response,
			String report_sql_id, String report_id, String new_report_id) {
		Map<String, String> varMap = new HashMap<String, String>();
		// 引用的数据集id
		varMap.put("report_sql_id", report_sql_id);
		// 引用的报表id
		varMap.put("report_id", report_id);
		// 新生成的报表Id
		varMap.put("new_report_id", new_report_id);
		String new_sql_count = "";
		String old_sql_count = "";
		String ins_sql = "";
		int new_count = 0;
		int old_count = 0;
		Connection con = null;
		PrintWriter out = null;
		// 所有引用报表下的约束变量
		String first_sql = "select d.dim_var_name from  sys_report_var_dim d where d.report_id=#report_id#";
		try {
			con = CommonTools.getConnection();//runner.getDataSource().getConnection();
			List<Map> lm = (List<Map>) runner
					.queryForMapList(first_sql, varMap);
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			PreparedStatement ps = null;
			PreparedStatement ps1 = null;
			ResultSet rs = null;
			ResultSet rs1 = null;
			for (Map m : lm) {
				// 该约束是否属于引用的数据集
				new_sql_count = "select count(1) from  sys_report_sql r where r.report_sql like '%#"
						+ m.get("dim_var_name")
						+ "#%' and report_id=? and report_sql_id=?";
				// 在新报表下是否存在该约束变量
				old_sql_count = "select count(1) from  sys_report_var_dim where report_id=? and dim_var_name='"
						+ m.get("dim_var_name") + "'";
				ps = con.prepareStatement(new_sql_count);
				ps.setString(1, varMap.get("report_id"));
				ps.setString(2, varMap.get("report_sql_id"));
				ps1 = con.prepareStatement(old_sql_count);
				ps1.setString(1, varMap.get("new_report_id"));
				rs = ps.executeQuery();
				rs.next();
				new_count = rs.getInt(1);
				rs1 = ps1.executeQuery();
				rs1.next();
				old_count = rs1.getInt(1);
				if (new_count > 0 && old_count == 0) {
					// 如果该约束属于该引用的数据集，并且新报表下并没有该约束，便新增此项
					ins_sql = "insert into sys_report_var_dim (report_id, dim_var_name, dim_var_type, dim_var_desc, dim_table, dim_col_code, dim_col_desc, dim_col_ord, dim_ord, select_double)"
							+ " select #new_report_id# report_id, dim_var_name, dim_var_type, dim_var_desc, dim_table, dim_col_code, dim_col_desc, dim_col_ord, dim_ord, select_double from "
							+ " sys_report_var_dim where  report_id=#report_id# and dim_var_name='"
							+ m.get("dim_var_name") + "'";
					runner.execute(ins_sql, varMap);
				}
				rs1.close();
				rs.close();
				ps.close();
				ps1.close();
			}
			try{
				con.close();
				if(ps !=null && !ps.isClosed())
				   ps.close();
			}catch(Exception e){
				e.printStackTrace();
				System.err.println("ReportSql.otherVarJudge方法释放连接时，出错:"+e.getMessage());
			}
			out.print("SUCCESS");
		} catch (Exception e) {
			out.print("FAIL");
			e.printStackTrace();
		}
	}

	@Action("varcharge")
	public void varCharge(String dim_table, String dim_col_code,
			String dim_col_desc, String dim_col_ord,String createType,String dimsql,String databaseName,
			String caslvl,HttpServletResponse response) {
		String dataSql = "select " +	dim_col_code + " CODE,"+dim_col_desc + "  CODEDESC from " + dim_table+	" order by "+ dim_col_ord ;//where rownum=1
		StringBuffer sql = new StringBuffer("");
				
		PrintWriter out = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			try{
				sql = new StringBuffer(CommonTools.getSql(databaseName, dataSql));
			}catch(Exception e){
				out.print("FAIL获取数据源错误,请检查扩展数据源");
				e.printStackTrace();
				return;
			}
			if(createType != null && createType.equals("2")){
				String sqltmp = StringUtil.formatSql(dimsql.toString(), "{", "}");
				if("".equals(dimsql)){
					out.print("FAIL维度SQL不能为空");
					return;
				}
				// 判断sql是否合法
				else if (sqltmp.indexOf("AND") == 0) {
					out.print("FAIL请检查##号是否成对出现，或者{}对内的应该存在AND|OR，请检查SQL拼写！");//+ dimsql.substring(3)
					return;
				} else if ("COUNT".equals(sqltmp)) {
					out.print("FAIL有部分##对没有被｛｝格式或者｛｝格式内不存在##对！");
					return;
				} else if (sqltmp == null) {
					out.print("FAILSQL格式拼写错误:｛｝没有成对出现或不正确的对！");
					return;
				}
				sql = new StringBuffer("");
				if(dimsql!=null && dimsql.indexOf("#")!= -1){
					dimsql=dimsql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\\{", "").replaceAll("\\}", "");
					String sqlStrs[] = dimsql.split("#");
					for(int i = 0; i < sqlStrs.length;i++){
						if (i % 2 != 1) {
							sql.append(sqlStrs[i]);
						}else{
							sql.append("''");//.append(sqlStrs[i]).append("'");
						}
					}
				}else{
					sql = new StringBuffer(dimsql);
				}
			}
			int reg = StringUtil.getCounts(dimsql, "#");
			// 判断#的数量。是否成对出现
			if (reg % 2 != 0) {
				out.print("FAIL" + "#号请成对出现！");
				return;
			}
			// 判断该码表是否存在
			int tmp = 0;String str = "";
			
			List rs = new ArrayList();
			if (databaseName != null && !databaseName.equals("")
					&& !databaseName.toUpperCase().trim().equals("NULL")
					&& !databaseName.trim().equals(""))
				rs = runner.queryForMapList(databaseName,sql.toString(),(Object[])null);
			else
				rs = runner.queryForMapList(sql.toString());
			//Connection con = CommonTools.getConnection();//runner.getDataSource().getConnection();
			Connection con =  CommonTools.getConnection(databaseName);
			PreparedStatement ps = con.prepareStatement(sql.toString());
			ResultSet rs1 = ps.executeQuery();
			ResultSetMetaData rsmd = rs1.getMetaData();
			int cols = rsmd.getColumnCount();
			for (int i = 1; i <= cols; i++) {
				String o = rsmd.getColumnName(i);
				if(o!=null && "CODE".equals(((String) o).toUpperCase())){
					tmp ++;
				}
				if(o!=null && "CODEDESC".equals(((String) o).toUpperCase())){
					tmp ++;
				}
				if(caslvl!=null && !caslvl.equals("0")){
					if(o!=null && "PARENT_COL".equals(((String) o).toUpperCase())){
						tmp ++;
					}
				}
				str += o;
				System.out.println(caslvl);
			}

			if(caslvl!=null && !caslvl.equals("") && !caslvl.equals("0") && createType != null && createType.equals("2")){
				if(tmp>=3){
					out.print("SUCCESS");
				}else{
					out.print("FAIL" + "SQL字段别名一定为: 编码列：code | 描述列：codedesc  |  上级字段：parent_col");
				}
			}else if((caslvl==null || caslvl.equals("0") || caslvl.equals("")) && createType != null && createType.equals("2")){
				if(tmp>=2){
					out.print("SUCCESS");
				}else{
					out.print("FAIL" + "SQL字段别名一定为:code 和 codedesc");
				}
			}else{
				out.print("SUCCESS");
			}
			try{
				rs1.close();
				con.close();
				ps.close();
			}catch(Exception e){
				e.printStackTrace();
				System.err.println("ReportSql.otherVarJudge方法释放连接时，出错:"+e.getMessage());
			}
		} catch (Exception e) {
			out.print("FAIL"+ e.getMessage().substring(e.getMessage().indexOf(":") + 1,e.getMessage().indexOf("\n")));
			e.printStackTrace();
		}
	}

	public void varChage_temp(String dim_table, String dim_col_code,
			String dim_col_desc, String dim_col_ord,
			HttpServletResponse response) {
		StringBuffer sql = new StringBuffer(
				"select count(1) total from all_col_comments where owner=#dim_ower# and table_name=#table_name#");
		String[] ower_table = dim_table.split("\\.");
		Map<String, String> map = new HashMap<String, String>();
		map.put("dim_ower", ower_table[0].toUpperCase());
		map.put("table_name", ower_table[1].toUpperCase());
		PrintWriter out = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			Map<String, Object> resMap = runner
					.queryForMap(sql.toString(), map);
			if ("0".equals(resMap.get("total").toString())) {
				out.print("FAIL表或视图不存在！");
				return;
			}
			map.put("column_name", dim_col_code.toUpperCase());
			sql.append(" and column_name=#column_name#");
			resMap = runner.queryForMap(sql.toString(), map);
			if ("0".equals(resMap.get("total").toString())) {
				out.print("FAIL编码字段不存在，请检查！");
				return;
			}
			map.remove("column_name");
			map.put("column_name", dim_col_desc.toUpperCase());
			resMap = runner.queryForMap(sql.toString(), map);
			if ("0".equals(resMap.get("total").toString())) {
				out.print("FAIL中文字段不存在，请检查！");
				return;
			}
			map.remove("column_name");
			map.put("column_name", dim_col_ord.toUpperCase());
			resMap = runner.queryForMap(sql.toString(), map);
			if ("0".equals(resMap.get("total").toString())) {
				out.print("FAIL排序字段不存在，请检查！");
				return;
			}
			out.print("SUCCESS");
		} catch (Exception e) {
			out.print("FAIL" + e.getMessage());
			e.printStackTrace();
		} finally {
			if (out != null)
				out.close();
		}
	}
	@Action("test")
	public void test(String dim_table, String dim_col_code,
			String dim_col_desc, String dim_col_ord,String createType,String dimsql,
			String caslvl,HttpServletResponse response) {
	}
}