package cn.com.easy.kpi.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.easy.annotation.Service;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.taglib.function.Functions;

@Service
public class FormulaService {
	//指标名称验证
	@SuppressWarnings("unchecked")
	public String vaildName(String value,String type,String code) {
		Connection conn = null;
		Statement state = null;
		String sql = "SELECT t.kpi_key FROM X_KPI_INFO T WHERE T.KPI_NAME = '"
				+ value + "' AND T.CUBE_CODE = '" + type + "'and t.kpi_code <>'"+code+"' and t.kpi_flag <> 'D'";
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			ResultSet rs = state.executeQuery(sql);
			map.put("data", rs.next());
		} catch (Exception e) {
			map.put("data", true);
			// e.printStackTrace();
		} finally {
			try {
				if (null != state) {
					state.close();
				}
				if (null != conn) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return Functions.java2json(map);
	}
	//以前取约整条件的值，现在应该不用了
	@SuppressWarnings("unchecked")
	public String condValue(String value) {
		Connection conn = null;
		Statement state = null;
		Map<String, Object> result = new HashMap<String, Object>();
		String sql = "SELECT A.DATASOURCE,A.TABLENAME,B.CODE,B.NAME,A.CONDITION FROM ("
				+ "SELECT ID,DATASOURCE,SRC_ONWER||'.'||SRC_TABLE TABLENAME,dim_code,CONDITION FROM X_BASEDIM_INFO T) a,"
				+ " (select dim_id,max(case t.name when cast('code' as nvarchar2(10)) then code end) as code,"
				+ " max(case t.name when cast('name' as nvarchar2(10)) then code end) as name,"
				+ " max(case t.name when cast('ails' as nvarchar2(10)) then code end） as ails"
				+ " from X_SUB_BASEDIM_INFO t" + " group by dim_id) b"
				+ " where a.id= b.dim_id and a.id = '" + value + "'";
		Map<String, String> map = new HashMap<String, String>();
		try {
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			ResultSet rs = state.executeQuery(sql);
			while (rs.next()) {
				map.put("code", rs.getString("CODE"));
				map.put("name", rs.getString("NAME"));
				map.put("ds", rs.getString("DATASOURCE"));
				map.put("tableName", rs.getString("TABLENAME"));
				map.put("condition", rs.getString("CONDITION"));
			}

		} catch (Exception e) {
			result.put("res", "failed");
			e.printStackTrace();
		} finally {
			try {
				if (null != state) {
					state.close();
				}
				if (null != conn) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		try {
			List<Map<String, String>> list = new ArrayList<Map<String, String>>();
			String rSql = "";
			rSql = "select distinct " + map.get("code") + "," + map.get("name")
					+ " from " + map.get("tableName");
			if (null != map.get("condition")
					&& !"".equals(map.get("condition"))) {
				rSql = rSql + " " + new String(org.apache.commons.codec.binary.Base64.decodeBase64(map.get("condition")), "UTF-8");
			}
			conn = EasyContext.getContext().getDataSource(map.get("ds"))
					.getConnection();
			state = conn.createStatement();
			ResultSet rs = state.executeQuery(rSql);
			while (rs.next()) {
				Map<String, String> res = new HashMap<String, String>();
				res.put("code", rs.getString(map.get("code")));
				res.put("name", rs.getString(map.get("name")));
				list.add(res);
			}
			result.put("res", "success");
			result.put("data", list);
		} catch (Exception e) {
			result.put("res", "failed");
		} finally {
			try {
				if (null != state) {
					state.close();
				}
				if (null != conn) {
					conn.close();
				}
			} catch (SQLException e) {
				result.put("res", "failed");
				e.printStackTrace();
			}
		}
		return Functions.java2json(result);
	}
	//取约束条件的值
	public String setCondValue(String value) {
		Connection conn = null;
		Statement state = null;
		Map<String, Object> result = new HashMap<String, Object>();
	 
		//String sql = " SELECT TABLENAME AS \"TABLENAME\", CODE AS \"CODE\", NAME AS \"NAME\", CONDITION AS \"CONDITION\", CONF_TYPE AS \"CONF_TYPE\", SQL_CODE AS \"SQL_CODE\", CUBE_DATASOURCE AS \"CUBE_DATASOURCE\" FROM VIEW_DIM_CODE WHERE DIM_CODE = '" + value + "'";
		String sql = "";
		Map<String, String> map = new HashMap<String, String>(); 
		try {
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			sql = EasyContext.getContext().getSql("kpi.form.view_dim_code") + " WHERE DIM_CODE = '"+ value +"'" ;
			ResultSet rs = state.executeQuery(sql);
			while (rs.next()) {
				map.put("code", rs.getString("CODE"));
				map.put("name", rs.getString("NAME"));
				map.put("ds", rs.getString("CUBE_DATASOURCE"));
				map.put("tableName", rs.getString("TABLENAME"));
				map.put("condition", rs.getString("CONDITION"));
				map.put("conf_type", rs.getString("CONF_TYPE"));
				map.put("sql", rs.getString("SQL_CODE"));
			}

		} catch (Exception e) {
			result.put("res", "failed");
			e.printStackTrace();
		} finally {
			try {
				if (null != state) {
					state.close();
				}
				if (null != conn) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		try {
			List<Map<String, String>> list = new ArrayList<Map<String, String>>();
			String rSql = "";
			rSql = "select distinct " + map.get("code") + " as \"" + map.get("code").toUpperCase() + "\"," + map.get("name") + " as \"" + map.get("name").toUpperCase()
					+ "\" from " + map.get("tableName");
			if (null != map.get("condition")
					&& !"".equals(map.get("condition"))) {
//				rSql = rSql + " " + new String(org.apache.commons.codec.binary.Base64.decodeBase64(map.get("condition")), "UTF-8");
				rSql = rSql + " " + new String(map.get("condition"));

			}
			if("2".equals(map.get("conf_type"))) {
				rSql = map.get("sql");
			}
			conn = EasyContext.getContext().getDataSource(map.get("ds")).getConnection();
			state = conn.createStatement();
			ResultSet rs = state.executeQuery(rSql);
			while (rs.next()) {
				Map<String, String> res = new HashMap<String, String>();
				res.put("code", rs.getString(map.get("code").toUpperCase()));
				res.put("name", rs.getString(map.get("name").toUpperCase()));
				list.add(res);
			}
			result.put("res", "success");
			result.put("data", list);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("res", "failed");
		} finally {
			try {
				if (null != state) {
					state.close();
				}
				if (null != conn) {
					conn.close();
				}
			} catch (SQLException e) {
				result.put("res", "failed");
				e.printStackTrace();
			}
		}
		return Functions.java2json(result);
	}
	//验证是否审核
	public String validAudit(String value) {
		Connection conn = null;
		Statement state = null;
		String sql = "SELECT COUNT(1) count FROM X_KPI_INFO_TMP T WHERE T.KPI_ISCURR = '0' AND (T.KPI_STATUS = '0' OR T.KPI_STATUS <> '2' AND T.KPI_STATUS<>'3')  AND T.KPI_FLAG = 'U' AND T.KPI_CODE = '"
				+ value + "'";
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			ResultSet rs = state.executeQuery(sql);
			while (rs.next()) {
				result.put("count", rs.getObject("count").toString());
			}
			result.put("res", "success");
		} catch (Exception e) {
			result.put("res", "failed");
			e.printStackTrace();
		} finally {
			try {
				if (null != state) {
					state.close();
				}
				if (null != conn) {
					conn.close();
				}
			} catch (SQLException e) {
				result.put("res", "failed");
				e.printStackTrace();
			}
		}
		return Functions.java2json(result);
	}
	//取扩展属性
	@SuppressWarnings("unchecked")
	public String kpiAttr(String value) {
		Connection conn = null;
		Statement state = null;
		String sql = "SELECT ATTR_CODE,ATTR_NAME FROM X_KPI_ATTRIBUTE WHERE ATTR_TYPE='"
				+ value + "' ORDER BY ORD";
		List<Map<String, String>> li = new ArrayList<Map<String, String>>();
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			ResultSet rs = state.executeQuery(sql);
			while (rs.next()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("code", rs.getObject("ATTR_CODE").toString());
				map.put("text", rs.getObject("ATTR_NAME").toString());
				li.add(map);
			}
			result.put("data", li);
			result.put("res", "success");
		} catch (Exception e) {
			result.put("res", "failed");
			e.printStackTrace();
		} finally {
			try {
				if (null != state) {
					state.close();
				}
				if (null != conn) {
					conn.close();
				}
			} catch (SQLException e) {
				result.put("res", "failed");
				e.printStackTrace();
			}
		}
		return Functions.java2json(result);
	}
	
	@SuppressWarnings("unchecked")
	public String acctTypeSub(String kpiCode, String version, String acctType) {
		Connection conn = null;
		Statement state = null;
		String sql = "select t1.attr_code ATTRCODE,t1.attr_name ATTRNAME from X_KPI_ATTR_RELATION t,X_KPI_ATTRIBUTE t1 where t.attr_code = t1.attr_code and t1.attr_type='"
				+ acctType
				+ "' and t.kpi_code ='"
				+ kpiCode
				+ "' and t.kpi_version='" + version + "' order by t1.ord";
		List<Map<String, String>> li = new ArrayList<Map<String, String>>();
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			ResultSet rs = state.executeQuery(sql);
			while (rs.next()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("code", rs.getObject("ATTRCODE").toString());
				map.put("text", rs.getObject("ATTRNAME").toString());
				li.add(map);
			}
			result.put("data", li);
			result.put("res", "success");
		} catch (Exception e) {
			result.put("res", "failed");
			e.printStackTrace();
		}finally {
			try {
				if (null != state) {
					state.close();
				}
				if (null != conn) {
					conn.close();
				}
			} catch (SQLException e) {
				result.put("res", "failed");
				e.printStackTrace();
			}
		}
		return Functions.java2json(result);
	}
	
	public String vaildConds(String parameter) throws SQLException {
		Connection conn = null;
		Statement state = null;
		String sql = "select * from dual where 1=1";
		String tmp = parameter;
		String oldChar = "";
		Map<String, Object> result = new HashMap<String, Object>();
		if(tmp != null && !"".equals(tmp)) {
			if(tmp.trim().toUpperCase().endsWith("AND")) {
				tmp = tmp.trim().substring(0,tmp.trim().length()-3);
			} else if (tmp.trim().toUpperCase().endsWith("OR")) {
				tmp = tmp.trim().substring(0,tmp.trim().length()-2);
			}
		}
		while(tmp.indexOf("{")!=-1){
			int start = tmp.indexOf("{");
			int end = tmp.indexOf("}");
			oldChar = tmp.substring(start,end+1);
			tmp = tmp.replace(oldChar, "'1'");
		}
		sql += " " + tmp;
		try {
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			ResultSet rs = state.executeQuery(sql);
			result.put("res", "success");
		}catch(Exception e){
			result.put("res", "failed");
		}
		return Functions.java2json(result);
	}
	
	public String validMax(String kpiCode, String version){
		Connection conn = null;
		Statement state = null;
		String sql = "SELECT COUNT(1) count FROM X_KPI_INFO_TMP T WHERE T.KPI_FLAG = 'U' AND T.KPI_CODE = '" 
					+ kpiCode 
					+ "' AND T.KPI_VERSION > " 
					+ version + "";
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			ResultSet rs = state.executeQuery(sql);
			while (rs.next()) {
				result.put("count", rs.getObject("count").toString());
			}
			result.put("res", "success");
		} catch (Exception e) {
			result.put("res", "failed");
			e.printStackTrace();
		} finally {
			try {
				if (null != state) {
					state.close();
				}
				if (null != conn) {
					conn.close();
				}
			} catch (SQLException e) {
				result.put("res", "failed");
				e.printStackTrace();
			}
		}
		return Functions.java2json(result);
		
	}
}
