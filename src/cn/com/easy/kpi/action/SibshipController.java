package cn.com.easy.kpi.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.dbutils.DbUtils;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.MapHandler;
import org.apache.commons.dbutils.handlers.MapListHandler;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.core.EasyContext;

@Controller
public class SibshipController {
	private SqlRunner runner;
	@Action("sibshipJson")
	public void sibshipJson(String kpiKey,String kpiName,HttpServletRequest request,HttpServletResponse response) throws SQLException, IOException{
		response.setHeader("Charset", "UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter pw=response.getWriter();
		String sqlKpi="select t.source_code,decode(t.source_name,'','未命名',source_name) source_name,decode(t.source_table,' ','未命名',source_table) source_table,decode(t.source_column,' ','未命名',source_column) source_column from x_kpi_source_tmp t where t.source_type in ('1','2','4','5') and t.source_key='"+kpiKey+"'";
		String sqlDim="select t.source_code,decode(t.source_name,'','未命名',source_name) source_name,decode(t.source_table,' ','未命名',source_table) source_table,decode(t.source_column,' ','未命名',source_column) source_column from x_kpi_source_tmp t where t.source_type in ('6','7') and t.source_key='"+kpiKey+"'";		
		JSONArray tempJa=new JSONArray();
		sibshipJsonArray(sqlKpi,tempJa,1);
		sibshipJsonArray(sqlDim,tempJa,0);
		JSONObject jo=new JSONObject();
		jo.put("id", "K"+kpiKey);
		jo.put("text",kpiName);
		jo.put("style","complex");
		jo.put("children", tempJa);
		JSONArray ja=new JSONArray();
		ja.add(jo);
		//System.out.println(ja.toString());
		pw.write(ja.toString());
	}
	private void sibshipJsonArray(String sql,JSONArray ja,int type) throws SQLException{
		List<Map<String,String>> objList=(List<Map<String, String>>) runner.queryForMapList(sql);
		for(int i=0;i<objList.size();i++){
			JSONObject jo=new JSONObject();
			String source_code=objList.get(i).get("source_code");
			String source_name=objList.get(i).get("source_name");
			///
			String source_column=objList.get(i).get("source_column");
			JSONObject sourceColumnJo=new JSONObject();
			sourceColumnJo.put("id", "C"+source_code);
			sourceColumnJo.put("text", source_column);
			if(type==0){
				sourceColumnJo.put("style", "dim_column");
			}
			else{
				sourceColumnJo.put("style", "kpi_column");
			}
			//JSONArray sourceColumnJa=new JSONArray();
			//sourceColumnJa.add(sourceColumnJo);
			///
			String source_table=objList.get(i).get("source_table");
			JSONObject sourceTableJo=new JSONObject();
			sourceTableJo.put("id", "T"+source_code);
			sourceTableJo.put("text", source_table);	
			if(type==0){
				sourceTableJo.put("style", "dim_table");
			}
			else{
				sourceTableJo.put("style", "kpi_table");
			}			
			//sourceTableJo.put("children", sourceColumnJa);
			JSONArray sourceTableJa=new JSONArray();
			sourceTableJa.add(sourceTableJo);
			sourceTableJa.add(sourceColumnJo);
			///
			jo.put("id", source_code);
			jo.put("text", source_name);
			jo.put("children", sourceTableJa);
			if(type==0){
				jo.put("style", "dim");
			}
			else{
				jo.put("style", "kpi");
			}		
			ja.add(jo);
		}
	}
	@Action("sibshipMSG")
	public void sibshipMSG(String id,String type,HttpServletRequest request,HttpServletResponse response) throws Exception{
		response.setHeader("Charset", "UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		EasyDataSource dataSource=EasyContext.getContext().getContext().getDataSource();
		Connection conn=null;
		try {
			conn = dataSource.getConnection();
			QueryRunner qr=new QueryRunner();
			String sql="";
			if(type.equals("kpi")){
				sql="select t.field_name,t.tablename,t.kpi_spec from x_kpi_view t where t.oid='"+id+"'";
			}
			else if(type.equals("dim")){
				sql="select t.field_name,t.tablename, from x_dimension_view t where t.oid='"+id+"'";
			}
			else if(type.equals("complex")){
				conn=EasyContext.getContext().getDataSource().getConnection();
				sql="select t.kpi_explain,t.kpi_caliber from x_kpi_info_tmp t where kpi_key="+id.substring(1);
			}
			else{
				return;
			}
			Map<String,Object> msg=qr.query(conn, sql, new MapHandler());
			DbUtils.closeQuietly(conn);
			JSONObject jo=JSONObject.fromObject(msg);
			jo.put("type",type);
			PrintWriter pw=response.getWriter();
			pw.write(jo.toString());			
		} catch (Exception e) {
			throw e;
		}finally{
			DbUtils.closeQuietly(conn);
		}
			

		
	}
	/**
	 * @Description: TODO
	 * @param  @param args
	 * @return void
	 * @throws SQLException 
	 * 
	 */
	public static void main(String[] args) throws SQLException {
		// TODO Auto-generated method stub
		ApplicationContext ac=new ClassPathXmlApplicationContext("applicationContext.xml");
		DataSource ds=(DataSource) ac.getBean("dataSource");
		QueryRunner qr=new QueryRunner(ds);
	}
}
