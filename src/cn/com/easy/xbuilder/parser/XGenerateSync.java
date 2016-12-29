package cn.com.easy.xbuilder.parser;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.web.taglib.function.Functions;

public class XGenerateSync {
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public boolean syncEvt(Map<String,String> params){
		System.out.println(">>>>接收到：来自"+params.get("from")+"系统 到 "+params.get("to")+"系统的同步报表"+params.get("reportId")+"请求。");
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sysId = params.get("to");
		StringBuffer upeBuff = new StringBuffer("");
		List<Map<String,String>> dataList = new ArrayList<Map<String,String>>();
		Map paramMap = new HashMap();
		paramMap.put("sysId", sysId);
		paramMap.put("versionId", params.get("versionId"));
		paramMap.put("reportId", params.get("reportId"));
		SqlRunner runner = new SqlRunner();
		String sql = runner.sql("xbuilder.syncJsp.allReportForSync");
		sql = sql.replaceAll("#sysId#", "'"+sysId+"'");
		if(!params.get("reportId").equals("all")){
			sql = runner.sql("xbuilder.syncJsp.reportForSync");
			sql = sql.replaceAll("#versionId#", "'"+params.get("versionId")+"'");
			sql = sql.replaceAll("#reportId#", "'"+params.get("reportId")+"'");
		}
		
		try {
			EasyDataSource datasource = EasyContext.getContext().getDataSource();
			conn = datasource.getConnection();
			String dbType = datasource.getDataSourceDB().toLowerCase();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			while(rs.next()){
				Map<String,String> data = new HashMap<String,String>();
				String xid = rs.getString("XID");
				data.put("XID",xid);
				data.put("FROM",params.get("from"));
				data.put("TO",params.get("to"));
				data.put("VERSION",String.valueOf(rs.getInt("VERSION")));
				data.put("CREATE_USER",params.get("createUser"));
				data.put("FILE_NAME",rs.getString("FILE_NAME"));
				if("oracle".equals(dbType)||"db2".equals(dbType)){
					Clob clob = (Clob) rs.getClob("JSP_DATA");  
					data.put("JSP_DATA",clob.getSubString(1, (int) clob.length()));
				}else if("mysql".equals(dbType)||"postgresql".equals(dbType)||"postgre".equals(dbType)){
					data.put("JSP_DATA",rs.getString("JSP_DATA"));
				}else{
					
				}
				dataList.add(data);
				upeBuff.append("delete from x_jsp_sync where SYSID='"+sysId+"' and XID='"+xid+"';");
				upeBuff.append("insert into x_jsp_sync(sysid,xid,version,sync_time) values('"+sysId+"','"+xid+"',"+rs.getInt("VERSION")+",'"+Functions.getDate("yyyyMMddHHmmss")+"');");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try {
				if(rs!=null)
					rs.close();
				if(stmt!=null)
					stmt.close();
				if(conn!=null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		try{
			if(dataList.size()<=0){
				return true;
			}
			boolean result = true;
			for(Map<String,String> data:dataList){
				if(!this.saveToFile(data)){
					data.put("RESULT","1");
					data.put("DEMO","同步文件"+data.get("FILE_NAME")+"时出错。");
					result = false;
				}else{
					data.put("RESULT","0");
					data.put("DEMO","同步文件"+data.get("FILE_NAME")+"成功");
				}
			}
			this.log(dataList);
			if(!result){
				return false;
			}
			
			int num = runner.executet(upeBuff.toString());
			if(num<=0){
				return false;
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			dataList = null;
		}
		return false;
	}
	private boolean saveToFile(Map<String,String> data) {
		String path = this.getClass().getClassLoader().getResource("/").getPath().replace("WEB-INF/classes/", "/");
		String jsp = "pages/xbuilder/usepage/formal/"+ data.get("XID")+ "/"+ data.get("FILE_NAME");
		path += jsp;
		FileOutputStream fos = null;
		try {
			File file = new File(path);
			if (file.exists()) {
				//file.delete();
				String version = "0";
				if(null != data.get("VERSION") && !data.get("VERSION").equalsIgnoreCase("null")){
					int ver = Integer.parseInt(data.get("VERSION"))-1;
					if(ver<0){
						ver = ver<0?0:ver;
					}else if(ver>5){
						File deleFile = new File(path+"_V"+(ver-5));
						if (deleFile.exists()) {
							deleFile.delete();
						}
					}
					version = String.valueOf(ver);
				}
				file.renameTo(new File(path+"_V"+version));
			} else {
				if (!file.getParentFile().exists()) {
					file.getParentFile().mkdirs();
				}
			}

			fos = new FileOutputStream(path);
			OutputStreamWriter osw = new OutputStreamWriter(fos, "UTF-8");
			osw.write(data.get("JSP_DATA"));
			osw.flush();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fos != null) {
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return false;
	}
	private void log(List<Map<String,String>> dataList) {
		Connection conn = null;
		Statement stmt = null;
		try {
			StringBuffer upeBuff = new StringBuffer("");
			EasyDataSource datasource = EasyContext.getContext().getDataSource();
			conn = datasource.getConnection();
			stmt = conn.createStatement();
			String dbType = datasource.getDataSourceDB().toLowerCase();
			if(dataList!=null&&dataList.size()>0){
				if("oracle".equals(dbType)){
					upeBuff.append("insert into x_jsp_sync_log (xid,sys_from,sys_to,version,result,create_user,create_time,demo) ");
					for(Map<String,String> data : dataList){
						upeBuff.append(" select '"+data.get("XID")+"','"+data.get("FROM")+"','"+data.get("TO")+"','"+data.get("VERSION")+"',");
						upeBuff.append("'"+data.get("RESULT")+"','"+data.get("CREATE_USER")+"','"+Functions.getDate("yyyyMMddHHmmss")+"','"+data.get("DEMO")+"' from dual union all ");
					}
				}else{
					upeBuff.append("insert into x_jsp_sync_log(xid,sys_from,sys_to,version,result,create_user,create_time,demo) values");
					for(Map<String,String> data : dataList){
						upeBuff.append("('"+data.get("XID")+"','"+data.get("FROM")+"','"+data.get("TO")+"','"+data.get("VERSION")+"',");
						upeBuff.append("'"+data.get("RESULT")+"','"+data.get("CREATE_USER")+"','"+Functions.getDate("yyyyMMddHHmmss")+"','"+data.get("DEMO")+"'),");
					}
				}
			}
			if("oracle".equals(dbType)){
				if(upeBuff.toString().length()>0){
					upeBuff = new StringBuffer(upeBuff.substring(0, upeBuff.lastIndexOf("union")));
				}
			}else{
				if(upeBuff.toString().length()>0){
					upeBuff = new StringBuffer(upeBuff.substring(0, upeBuff.lastIndexOf(",")));
				}
			}
			stmt.execute(upeBuff.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try {
				if(stmt!=null)
					stmt.close();
				if(conn!=null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}