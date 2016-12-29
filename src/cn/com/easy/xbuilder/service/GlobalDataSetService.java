package cn.com.easy.xbuilder.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;
import oracle.sql.CLOB;
import cn.com.easy.annotation.Service;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.parser.CommonTools;

@Service
public class GlobalDataSetService {
	
	public String addGlobalDataSet(String uuid,String sql,String dataSourceName,String dataSetName,String state) {
		Map<String,Object> resMap = new HashMap<String,Object>();
		Map<String,String> insMap = new HashMap<String,String>();
		String base64Sql = "";
		String flag = "";
		String res="";
		try {
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String create_time = ""+sdf.format(new Date());
			String create_user = ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID")+"";
			base64Sql = new String(org.apache.commons.codec.binary.Base64.decodeBase64(sql), "UTF-8");
			insMap = insertGlbSql(uuid,base64Sql,dataSourceName,dataSetName,create_user,create_time,state);
			flag = "true";
			res="保存成功";
		} catch (Exception e) {
			e.printStackTrace();
			flag = "false";
			res="保存失败";
		}
		JSONObject json = new JSONObject();
		resMap.put("flag", flag);
		resMap.put("res", res);
		if("false".equals(insMap.get(flag))){
			json = JSONObject.fromObject(insMap); 
		}else{
			json = JSONObject.fromObject(resMap); 
		}
		String jsonStr = json.toString();
		return jsonStr;
	}
	public static Map<String,String> insertGlbSql(String uuid,String base64Sql,String glbDataSourceName,String dataSetName,String create_user,String create_time,String state){
		Map<String,String> resMap = new HashMap<String,String>();
		String flag = "";
		String res = "";
		//jdbc连接对象
		String dataSourceName="";
		Connection conn = null;
		PreparedStatement stat = null;
		
		try {
			EasyDataSource datasource = CommonTools.getDataSource(dataSourceName);
			//数据库连接对象
			conn = datasource.getConnection();
			conn.setAutoCommit(false);
			String DBtype = conn.getMetaData().getDatabaseProductName().trim();
			if(null!=DBtype&&(DBtype.contains("DB2")||DBtype.contains("PostgreSQL"))){
				if(state.equals("upd")){
					String udpSql = "update x_dataset_global  set name = '"+dataSetName+"',type='"+glbDataSourceName+"',modify_user='"+create_user+"',modify_time='"+Functions.getDate("yyyyMMddHHmmss")+"',sql=?  where id ='"+uuid+"'";
					//修改
					stat = conn.prepareStatement(udpSql);
					stat.setString(1, base64Sql);
					stat.executeUpdate();
				}else{
					String delSql = "delete from x_dataset_global where id ='"+uuid+"'";
					//删除
					stat = conn.prepareStatement(delSql);
					stat.executeUpdate();
					String insSql = "insert into x_dataset_global (id, name, type, sql,create_user,create_time) " +
					"values ('"+uuid+"','"+dataSetName+"','"+glbDataSourceName+"',?,'"+create_user+"','"+Functions.getDate("yyyyMMddHHmmss")+"')";
					//添加
					stat = conn.prepareStatement(insSql);
					stat.setString(1, base64Sql);
					stat.executeUpdate();
				}
			}else{
				if(state.equals("upd")){
					String udpSql = "update x_dataset_global a set a.name = '"+dataSetName+"',a.type='"+glbDataSourceName+"',a.modify_user='"+create_user+"',a.modify_time='"+Functions.getDate("yyyyMMddHHmmss")+"',a.sql=empty_clob()  where a.id ='"+uuid+"'"; 
					//修改
					stat = conn.prepareStatement(udpSql);
					stat.executeUpdate();
				}else{
					String delSql = "delete from x_dataset_global where id ='"+uuid+"'";
					//删除
					stat = conn.prepareStatement(delSql);
					stat.executeUpdate();
					String insSql = "insert into x_dataset_global (id, name, type, sql,create_user,create_time) " +
					"values ('"+uuid+"','"+dataSetName+"','"+glbDataSourceName+"',empty_clob(),'"+create_user+"','"+Functions.getDate("yyyyMMddHHmmss")+"')";
					//添加
					stat = conn.prepareStatement(insSql);
					stat.executeUpdate();
				}
				
				String clobObj = "select SQL from x_dataset_global where id ='"+uuid+"' for update";
				stat = conn.prepareStatement(clobObj);
				ResultSet rs = stat.executeQuery(clobObj);
				
				if(rs.next()){
					CLOB clob = (CLOB) rs.getClob(1); 
					clob.setString(1, base64Sql);
					String upSql = "update x_dataset_global a set a.sql = ? where a.id ='"+uuid+"'"; 
					stat = conn.prepareStatement(upSql);
					stat.setClob(1, clob);
					stat.executeQuery();
					rs.close();
				}
			}
			conn.commit();
			flag="true";
			res="保存成功";
		} catch (Exception e) {
			e.printStackTrace();
			flag="false";
			if(e.getMessage().indexOf("\n")==-1){
				res = e.getMessage();
			}else{
				res = e.getMessage().substring(e.getMessage().indexOf(":")+1,e.getMessage().indexOf("\n"));
			}
			e.printStackTrace();
		}finally{
			try{
				if(stat != null){
					stat.close();
				}
				if(conn != null){
					conn.close();
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		resMap.put("flag", flag);
		resMap.put("res", res);
		return resMap;
	}

}
