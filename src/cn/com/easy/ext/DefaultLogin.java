package cn.com.easy.ext;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.MapListHandler;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;

public class DefaultLogin extends AbstractLogin {

	@SuppressWarnings({ "unchecked", "deprecation", "rawtypes" })
	@Override
	public Map login(String user, String pwd, SqlRunner runner) {
		Map userMap = null;
		try {
			userMap = runner.queryForMap(usql, new String[]{user,pwd});
			if(userMap != null){
				List<?> octList = runner.queryForMapList(octSql, new String[]{String.valueOf(userMap.get("USER_ID"))});
				if(octList != null && octList.size()>0){
					String octStr="";
					Map<String,String> tempMap;
					for(int i=0;i<octList.size();i++){
						Object tempObject=octList.get(i);
						tempMap=null;
						if(tempObject!=null){
							tempMap=(Map<String, String>) tempObject;
						}
						if(tempMap!=null){
							if(i==(octList.size()-1)){
								octStr+=String.valueOf(tempMap.get("ACCOUNT_CODE"));
								continue;
							}
							octStr+=String.valueOf(tempMap.get("ACCOUNT_CODE"))+",";
						}
						
					}
					userMap.put("USER_OCT", octStr);
				}
				List<Map<String,String>> exts = (List<Map<String,String>>)runner.queryForMapList(extSql,userMap.get("USER_ID"));
				for(Map ext:exts){
					String key = (String)ext.get("ATTR_CODE");
					if(key !=null && !key.equals("")){
						userMap.put(ext.get("ATTR_CODE"), ext.get("ATTR_VALUE"));
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return userMap;
	}
	public Map PortalLogin(String user,SqlRunner runner) {
		Map userMap = null;
		try {
			userMap = runner.queryForMap(pusql, new String[]{user});
			if(userMap != null){
				List<?> octList = runner.queryForMapList(octSql, new String[]{String.valueOf(userMap.get("USER_ID"))});
				if(octList != null && octList.size()>0){
					String octStr="";
					Map<String,String> tempMap;
					for(int i=0;i<octList.size();i++){
						Object tempObject=octList.get(i);
						tempMap=null;
						if(tempObject!=null){
							tempMap=(Map<String, String>) tempObject;
						}
						if(tempMap!=null){
							if(i==(octList.size()-1)){
								octStr+=String.valueOf(tempMap.get("ACCOUNT_CODE"));
								continue;
							}
							octStr+=String.valueOf(tempMap.get("ACCOUNT_CODE"))+",";
						}
						
					}
					userMap.put("USER_OCT", octStr);
				}
				List<Map<String,String>> exts = (List<Map<String,String>>)runner.queryForMapList(pextSql,userMap.get("USER_ID"));
				for(Map ext:exts){
					String key = (String)ext.get("ATTR_CODE");
					if(key !=null && !key.equals("")){
						userMap.put(ext.get("ATTR_CODE"), ext.get("ATTR_VALUE"));
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return userMap;
	}
	
	public Map<String,Object> PortalLogin(String user,HttpServletRequest request) {
		try {
			Map<String,Object> userMap = null;
			QueryRunner runner = new QueryRunner(); 
			Connection conn = EasyContext.getContext().getDataSource().getConnection();
			List<Map<String,Object>> list1 = runner.query(conn, "select * from e_user where LOGIN_ID='"+user+"' and STATE='1'", new MapListHandler());
			for(Map<String,Object> map1:list1){
				userMap = new HashMap<String,Object>();
				userMap.put("USER_ID",map1.get("USER_ID"));
				userMap.put("LOGIN_ID",map1.get("LOGIN_ID"));
				userMap.put("PASSWORD",map1.get("PASSWORD"));
				userMap.put("USER_NAME",map1.get("USER_NAME"));
				userMap.put("ADMIN",map1.get("ADMIN"));
				userMap.put("SEX",map1.get("SEX"));
				userMap.put("EMAIL",map1.get("EMAIL"));
				userMap.put("MOBILE",map1.get("MOBILE"));
				userMap.put("TELEPHONE",map1.get("TELEPHONE"));
				List<Map<String,Object>> list2 = runner.query(conn, "select c.ATTR_CODE,ATTR_VALUE from e_user a,e_user_attribute b,e_user_attr_dim c where a.user_id=b.user_id and b.attr_code=c.attr_code and a.LOGIN_ID='"+user+"'", new MapListHandler());
				for(Map<String,Object> map2:list2){
					userMap.put(map2.get("ATTR_CODE").toString(),map2.get("ATTR_VALUE"));
				}
			}
			List<Map<String,Object>> octList = runner.query(conn,"select ACCOUNT_CODE  from E_USER_ACCOUNT where user_id='"+String.valueOf(userMap.get("USER_ID"))+"'", new MapListHandler());
			if(octList != null && octList.size()>0){
				String octStr="";
				for(int i=0;i<octList.size();i++){
					Map<String,Object> tempMap=octList.get(i);
					if(i==(octList.size()-1)){
						octStr+=String.valueOf(tempMap.get("ACCOUNT_CODE"));
						continue;
					}
					octStr+=String.valueOf(tempMap.get("ACCOUNT_CODE"))+",";
				}
				userMap.put("USER_OCT", octStr);
			}
			super.setUser(userMap, request);
			return userMap;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private String usql = "SELECT USER_ID \"USER_ID\",LOGIN_ID \"LOGIN_ID\",PASSWORD \"PASSWORD\",USER_NAME \"USER_NAME\",ADMIN \"ADMIN\",SEX \"SEX\",EMAIL \"EMAIL\",MOBILE \"MOBILE\",TELEPHONE \"TELEPHONE\",STATE \"STATE\",PWD_STATE \"PWD_STATE\",MEMO \"MEMO\",REG_DATE \"REG_DATE\",UPDATE_DATE \"UPDATE_DATE\",REG_USER \"REG_USER\",UPDATE_USER \"UPDATE_USER\",EXT1 \"EXT1\",EXT2 \"EXT2\",EXT3 \"EXT3\",EXT4 \"EXT4\",EXT5 \"EXT5\",EXT6 \"EXT6\",EXT7 \"EXT7\",EXT8 \"EXT8\",EXT9 \"EXT9\",EXT10 \"EXT10\",EXT11 \"EXT11\",EXT12 \"EXT12\",EXT13 \"EXT13\",EXT14 \"EXT14\",EXT15 \"EXT15\",EXT16 \"EXT16\",EXT17 \"EXT17\",EXT18 \"EXT18\",EXT19 \"EXT19\",EXT20 \"EXT20\",EXT21 \"EXT21\",EXT22 \"EXT22\",EXT23 \"EXT23\",EXT24 \"EXT24\",EXT25 \"EXT25\",EXT26 \"EXT26\",EXT27 \"EXT27\",EXT28 \"EXT28\",EXT29 \"EXT29\",EXT30 \"EXT30\" FROM E_USER where LOGIN_ID=? and PASSWORD=? and STATE='1'";
	
	private String extSql = "select c.ATTR_CODE \"ATTR_CODE\",ATTR_VALUE \"ATTR_VALUE\" from e_user a,e_user_attribute b,e_user_attr_dim c where a.user_id=b.user_id and b.attr_code=c.attr_code and a.user_id=?";
	
	private String pusql = "SELECT USER_ID \"USER_ID\",LOGIN_ID \"LOGIN_ID\",PASSWORD \"PASSWORD\",USER_NAME \"USER_NAME\",ADMIN \"ADMIN\",SEX \"SEX\",EMAIL \"EMAIL\",MOBILE \"MOBILE\",TELEPHONE \"TELEPHONE\",STATE \"STATE\",PWD_STATE \"PWD_STATE\",MEMO \"MEMO\",REG_DATE \"REG_DATE\",UPDATE_DATE \"UPDATE_DATE\",REG_USER \"REG_USER\",UPDATE_USER \"UPDATE_USER\",EXT1 \"EXT1\",EXT2 \"EXT2\",EXT3 \"EXT3\",EXT4 \"EXT4\",EXT5 \"EXT5\",EXT6 \"EXT6\",EXT7 \"EXT7\",EXT8 \"EXT8\",EXT9 \"EXT9\",EXT10 \"EXT10\",EXT11 \"EXT11\",EXT12 \"EXT12\",EXT13 \"EXT13\",EXT14 \"EXT14\",EXT15 \"EXT15\",EXT16 \"EXT16\",EXT17 \"EXT17\",EXT18 \"EXT18\",EXT19 \"EXT19\",EXT20 \"EXT20\",EXT21 \"EXT21\",EXT22 \"EXT22\",EXT23 \"EXT23\",EXT24 \"EXT24\",EXT25 \"EXT25\",EXT26 \"EXT26\",EXT27 \"EXT27\",EXT28 \"EXT28\",EXT29 \"EXT29\",EXT30 \"EXT30\" FROM E_USER where USER_ID=? and STATE='1'";
	private String pextSql = "select c.ATTR_CODE \"ATTR_CODE\",ATTR_VALUE \"ATTR_VALUE\" from e_user a,e_user_attribute b,e_user_attr_dim c where a.user_id=b.user_id and b.attr_code=c.attr_code and a.user_id=?";
	private String octSql = "select ACCOUNT_CODE \"ACCOUNT_CODE\"  from E_USER_ACCOUNT where user_id=?";
}