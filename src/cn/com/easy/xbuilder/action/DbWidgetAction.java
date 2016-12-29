package cn.com.easy.xbuilder.action;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.taglib.function.Functions;

/**
 * 
 * @author zuobin
 * 在线编辑SQL组件，根据扩展数据源展示数据源的表和表字段
 */
@Controller
public class DbWidgetAction {
	
	private SqlRunner runner;
    
	/**
	 * 获取扩展数据源信息
	 * @param request
	 * @param response
	 * @param defaultSelect
	 */
	@SuppressWarnings({ "rawtypes", "unchecked", "deprecation" })
	@Action("xbuilder/getExtDsInfo")
	public void getExtDsInfo(HttpServletRequest request, HttpServletResponse response,String defaultSelect) {
		PrintWriter out = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			String userId = ((Map)request.getSession().getAttribute("UserInfo")).get("USER_ID").toString();
			String sql = " select distinct ds.DB_ID as \"DB_ID\",ds.DB_NAME as \"DB_NAME\",ds.DB_SOURCE as \"DB_SOURCE\",ds.ORD as \"ORD\" from x_ext_db_source ds,X_DB_ACCOUNT da,E_USER_ACCOUNT ua "
					+" where ds.db_id = da.db_id and da.account_code = ua.account_code and ua.user_id= ? "
					+" order by ds.ORD ";
			String xdbauth = (String)EasyContext.getContext().getServletcontext().getAttribute("xdbauth");
			List<Map> extdsList = null;
			if(!"1".equals(xdbauth)) {
				sql = " select distinct ds.DB_ID as \"DB_ID\",ds.DB_NAME as \"DB_NAME\",ds.DB_SOURCE as \"DB_SOURCE\",ds.ORD as \"ORD\" from x_ext_db_source ds ";
				extdsList = (List<Map>)runner.queryForMapList(sql);
			} else { 
				extdsList = (List<Map>)runner.queryForMapList(sql, userId);
			}
			if(defaultSelect==null){
				Map map = new HashMap();
				map.put("DB_ID", "-1");
				map.put("DB_NAME", "----请选择扩展数据源----");
				map.put("DB_SOURCE", "-1");
				extdsList.add(0, map);
			}
			if(extdsList==null||extdsList.size()==0){
				out.print("[]");
			}else{
				out.print(Functions.java2json(extdsList));
			}
		} catch (Exception e) {
		    out.print("[]");
			e.printStackTrace();
		}
	}

	/**
	 * 根据所选扩展数据源获取数据源下的所有表
	 * @param request
	 * @param response
	 */
	@SuppressWarnings({ "rawtypes", "unchecked", "deprecation" })
	@Action("xbuilder/getTableInfo")
	public void getTableInfo(HttpServletRequest request, HttpServletResponse response) {
		PrintWriter out = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			String sql = "select table_name as \"ID\",table_name as \"TEXT\",table_desc as \"TABLE_DESC\",ext_datasource as \"EXT_DATASOURCE\",owner as \"OWNER\" from x_extds_info t where t.ext_datasource=? order by table_name";
			String db_source = request.getParameter("db_source");
			List<Map> tbList = (List<Map>)runner.queryForMapList(sql, db_source);
			List<Map> tempList = new ArrayList<Map>();
			for(Map tbMap : tbList){
				Map tmpMap = new HashMap();
				tmpMap.put("id", tbMap.get("ID"));
				tmpMap.put("text", tbMap.get("TEXT"));
				Map attrMap = new HashMap();
				attrMap.put("table_desc", tbMap.get("TABLE_DESC"));
				attrMap.put("ext_datasource", tbMap.get("EXT_DATASOURCE"));
				attrMap.put("owner", tbMap.get("OWNER"));
				tmpMap.put("attributes", attrMap);
				tempList.add(tmpMap);
			}
			out.print(Functions.java2json(tempList));
		} catch (Exception e) {
			out.print("[]");
			e.printStackTrace();
		}finally{
			if(out!=null){
				out.close();
			}
		}
	}
    
	/**
	 * 通过schema获取数据源下的表
	 * @param request
	 * @param response
	 * @param page 当前页
	 * @param rows 每页行数
	 * @param schema 用户
	 * @param db_source 数据源
	 * @param tablename 表名
	 */
	@Action("xbuilder/getTableInfoBySchema")
	public void getTableInfoBySchema(HttpServletRequest request, HttpServletResponse response,String page,String rows,String schema,String db_source,String tablename){
		PrintWriter out = null;
		Connection con = null;
		ResultSet rs = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			EasyDataSource datasource = getDataSource(db_source);
			con = datasource.getConnection();
			DatabaseMetaData metaData = con.getMetaData();
			if("".equals(schema)){
				schema = null;
			}else{
				schema = schema.toUpperCase();
			}
			rs = metaData.getTables(null, schema, null, new String[]{"TABLE"});  
			List<Map> list = new ArrayList<Map>();
			if(null!=tablename&&!"".endsWith(tablename)){
				page="1";
	    	}
		    while(rs.next()){
		    	Map<String, String>	map = new HashMap<String, String>();
		    	String table_name = rs.getString("TABLE_NAME");
		    	String remarks = rs.getString("TABLE_NAME");
		    	if(null!=tablename&&!"".endsWith(tablename)&&table_name.toUpperCase().contains(tablename.toUpperCase())){
		    		map.put("TABLE_NAME", table_name);
		    		map.put("TABLE_DESC", remarks);
		    		list.add(map);
		    	}
		    	if(null==tablename||"".endsWith(tablename)){
		    		map.put("TABLE_NAME", table_name);
		    		map.put("TABLE_DESC", remarks);
		    		list.add(map);
		    	}
		    }
		    int total = list.size();
		    Map<String, Object>	resmap = new HashMap<String, Object>();
		    resmap.put("total", total);
		    int pagea = Integer.parseInt(page);
		    int rowsa = Integer.parseInt(rows);
		    int end = pagea*rowsa;
		    if(pagea*rowsa>=total){
		    	end = total;
		    }
		    resmap.put("rows", list.subList((pagea-1)*rowsa, end));
		    out.print(Functions.java2json(resmap));
		} catch (Exception e) {
			out.print("[]");
			e.printStackTrace();
		}finally{
			if(rs!=null){
				try {
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if(con!=null){
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if(out!=null){
				out.close();
			}
		}
		
	}
	/**
	 * 获取表字段信息
	 * @param request
	 * @param response
	 * @param datasourceName
	 * @param tableName
	 */
	@SuppressWarnings({ "unchecked"})
	@Action("xbuilder/getColumnInfo")
	public void getColumnInfo(HttpServletRequest request, HttpServletResponse response,String datasourceName,String tableName,String owner) {
		PrintWriter out = null;
		Connection con = null;
		ResultSet colSet = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			EasyDataSource datasource = getDataSource(datasourceName);
			con = datasource.getConnection();
			DatabaseMetaData metaData = con.getMetaData();
			String dbType = metaData.getDatabaseProductName();
			String schemaPattern = owner ;
			String gpowner = owner;
			String gptableName = tableName;
			if(owner!=null&&!owner.equals("")&&!"Microsoft SQL Server".equals(dbType)){//除SqlServer以外，其他数据库schema使用大写
				schemaPattern = owner.toUpperCase();
			}
			if("PostgreSQL".equals(dbType)){
				schemaPattern = gpowner;
			}
			if(tableName!=null&&!tableName.equals("")){
				tableName = tableName.toUpperCase();
			}
			if("PostgreSQL".equals(dbType)){
				tableName = gptableName;
			}
			String descSql = "select COLUMNNAME,COLUMNREMARK from X_EXTDS_REMARKS r where r.extds='"+datasourceName+"' and upper(r.tablename)='"+tableName.toUpperCase()+"'";
			List<Map> descList = new ArrayList<Map>();
			descList = (List<Map>) runner.queryForMapList(descSql);
			Map<String,String> descMap = new HashMap<String,String>();
			for(Map<String,String> m:descList){
				String key = m.get("COLUMNNAME").toUpperCase();
				descMap.put(key, m.get("COLUMNREMARK"));
			}
			colSet = metaData.getColumns(null,schemaPattern, tableName, null);
			List<Map> resultList = new ArrayList<Map>();
			while(colSet.next()){
				Map map = new HashMap();
				String colName = colSet.getString("COLUMN_NAME").toUpperCase();
				map.put("colName", colName);
				String COLUMN_SIZE = colSet.getString("COLUMN_SIZE");
				String TYPE_NAME = colSet.getString("TYPE_NAME");
				if(!"".equals(COLUMN_SIZE)&&COLUMN_SIZE!=null){
					map.put("colType", TYPE_NAME+"("+COLUMN_SIZE+")");
				}else{
					map.put("colType", TYPE_NAME);
				}
				String REMARKS = colSet.getString("REMARKS");
				if(null!=descMap.get(colName)&&!"".equals(descMap.get(colName))){
					map.put("colDesc", descMap.get(colName));
				}else{
					map.put("colDesc", REMARKS);
				}				
				resultList.add(map);
			}
			Map<String,Object> resultMap = new HashMap<String,Object>();
			resultMap.put("total", resultList.size());
			resultMap.put("rows", resultList);
			out.print(Functions.java2json(resultMap));
		} catch (Exception e) {
		    out.print("{\"errMsg\":\"连接数据库发生错误！\",\"total\":\"0\",\"rows\":[]}");
			e.printStackTrace();
		}finally{
			if(colSet!=null){
				try {
					colSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if(con!=null){
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if(out!=null){
				out.close();
			}
		}
	}
     
	/**
	 * 获取数据库产品名
	 * @param request
	 * @param response
	 * @param datasourceName
	 * @param tableName
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Action("xbuilder/getDatabaseProductName")
	public void getDatabaseProductName(HttpServletRequest request, HttpServletResponse response,String datasourceName) {
		PrintWriter out = null;
		Connection con = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			EasyDataSource datasource = getDataSource(datasourceName);
			con = datasource.getConnection();  
			DatabaseMetaData metaData = con.getMetaData();
			String productName = metaData.getDatabaseProductName();
			out.print(productName);
			//con.close();
		} catch (Exception e) {
		    out.print("FAIL");
			e.printStackTrace();
		}finally{
			if(con!=null){
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}
	 public static EasyDataSource getDataSource(String dataSourceName){
		  EasyDataSource dataSource = null;
		  if(dataSourceName!= null && !dataSourceName.trim().equals("") && dataSourceName.trim().length() > 0)
			  dataSource = EasyContext.getContext().getDataSource(dataSourceName.trim());
		  else 
			  dataSource = EasyContext.getContext().getDataSource();
		  return dataSource;
	  }
}





