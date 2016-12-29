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
import cn.com.easy.kpi.util.KpiUtil;
import cn.com.easy.kpi.util.SQLTool;
import cn.com.easy.taglib.function.Functions;

@Service
public class DimDbService {
	@SuppressWarnings("unchecked")
	public String vaildName(String value) {
		Connection conn = null;
		Statement state = null;
		ResultSet rs = null;
		String sql = "SELECT * FROM X_BASEDIM_INFO T WHERE T.DIM_NAME = '" + value + "'";
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			rs = state.executeQuery(sql);
			map.put("data", rs.next());
		} catch (Exception e) {
			map.put("data", true);
//			e.printStackTrace();
		}finally{
			try {
				if(null!=rs){
					rs.close();
				}
				if(null!=state){
					state.close();
				}
				if(null!=conn){
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return Functions.java2json(map);
	}

	@SuppressWarnings("unchecked")
	public String sourceTable(String dataBase1,String table,String dataSourceName) {
		Connection conn = null;
		Statement state = null;
		ResultSet rs = null;
		Map<String, Object> map = new HashMap<String, Object>();
		String sql = "select * from (" + table + ")";
		String dataBase = SQLTool.getDBType(dataSourceName);
		sql = SQLTool.getSql(dataBase, sql);
		try {
			List<String> list = new ArrayList<String>();
			if("".equals(dataSourceName)||null==dataSourceName){
				map.put("res", "failed");
				map.put("data", "请选择数据源！");
				return Functions.java2json(map);
			}else{
				conn = EasyContext.getContext().getDataSource(dataSourceName).getConnection();
			}
			state = conn.createStatement();
			rs = state.executeQuery(sql);
			java.sql.ResultSetMetaData rsmd = rs.getMetaData();
			for (int i = 1; i <= rsmd.getColumnCount(); i++) {
				list.add(rsmd.getColumnName(i));
			}
			String[] tabInfo = KpiUtil.split(table, ".");
			map.put("res", "success");
			map.put("data", list);
			map.put("schema", tabInfo[0]);
			map.put("table", tabInfo[1]);
		} catch (Exception e) {
			map.put("res", "failed");
			map.put("data", "表或视图不存在！");
			e.printStackTrace();
		} finally {
			try {
				if(null!=rs){
					rs.close();
				}
				if(null!=state){
					state.close();
				}
				if(null!=conn){
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				map.put("res", "failed");
				map.put("data", "数据源出错！");
				e.printStackTrace();
			}
		}
		return Functions.java2json(map);
	}

	@SuppressWarnings("unchecked")
	public String dimTabSeach(String value) {
		Connection conn = null;
		Statement state = null;
		ResultSet rs = null;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> mapInfo = new HashMap<String, String>();
		String[] tabInfo = KpiUtil.split(value, ".");
		if (tabInfo.length < 3) {
			map.put("res", "failed");
			map.put("data", "维度来源格式不正确！");
			return Functions.java2json(map);
		}
		String sql = "select " + tabInfo[2] + " from " + tabInfo[0] + "."
				+ tabInfo[1] + " where 1=2";

		try {
			List<String> list = new ArrayList<String>();
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			rs = state.executeQuery(sql);
			mapInfo.put("schema", tabInfo[0]);
			mapInfo.put("table", tabInfo[1]);
			mapInfo.put("column", tabInfo[2]);
			map.put("res", "success");
			map.put("data", mapInfo);

		} catch (Exception e) {
			map.put("res", "failed");
			map.put("data", "字段、表或视图不存在！");
			// e.printStackTrace();
		} finally {
			try {
				if(null!=rs){
					rs.close();
				}
				if(null!=state){
					state.close();
				}
				if(null!=conn){
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				map.put("res", "failed");
				map.put("data", "数据源出错！");
//				e.printStackTrace();
			}
		}

		return Functions.java2json(map);
	}

	@SuppressWarnings("unchecked")
	public String doSeachSql(String value,String dataSourceName) {
		Connection conn = null;
		Statement state = null;
		ResultSet rs = null;
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			List<String> list = new ArrayList<String>();
			if("".equals(dataSourceName)){
				conn = EasyContext.getContext().getDataSource().getConnection();
			}else{
				conn = EasyContext.getContext().getDataSource(dataSourceName).getConnection();	
			}
			
			state = conn.createStatement();
			rs = state.executeQuery(value);
			java.sql.ResultSetMetaData rsmd = rs.getMetaData();
			for (int i = 1; i <= rsmd.getColumnCount(); i++) {
				list.add(rsmd.getColumnName(i));
			}
			map.put("res", "success");
			map.put("data", list);
			map.put("sql", value);
		} catch (Exception e) {
			map.put("res", "failed");
			map.put("data", "表或视图不存在！");
			// e.printStackTrace();
		} finally {
			try {
				if(null!=rs){
					rs.close();
				}
				if(null!=state){
					state.close();
				}
				if(null!=conn){
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				map.put("res", "failed");
				map.put("data", "数据源出错！");
//				e.printStackTrace();
			}
		}
		return Functions.java2json(map);
	}

}
