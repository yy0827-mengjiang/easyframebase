package cn.com.easy.xbuilder.action;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;

/**
 *pl/sql编辑页面左侧的扩展数据源维护Action
 */
@Controller
public class EXTDataSourceAction {
	
	private SqlRunner runner;
	
	/**
	 * @param request
	 * @param response
	 * @param ID 扩展数据源ID x_extds_info.ID
	 * @param OWNER x_extds_info.OWNER
	 * @param TABLE_NAME x_extds_info.TABLE_NAME
	 * @param TABLE_DESC x_extds_info.TABLE_DESC
	 * @param EXT_DATASOURCE x_extds_info.EXT_DATASOURCE
	 */
	@Action("EXTDataSource/addEXTdataSource")
	public void addEXTDataSource(HttpServletRequest request, HttpServletResponse response,String ID,String OWNER,String TABLE_NAME,String TABLE_DESC,String EXT_DATASOURCE){
		Map<String,String> resMap = new HashMap<String,String>();
		String flag="";
		String msg="";
		int n = -1;
		PrintWriter out = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			String uuid = UUID.randomUUID().toString().replaceAll("-","");
			Map<String,String> paramMap = new HashMap<String,String>();
			paramMap.put("uuid", uuid);//新增时使用
			paramMap.put("id", ID);//修改时使用 
			paramMap.put("owner",OWNER);
			paramMap.put("table_name",TABLE_NAME);
			paramMap.put("table_desc",TABLE_DESC);
			paramMap.put("ext_datasource",EXT_DATASOURCE);
			String delSql = "delete from x_extds_info where OWNER=#owner# and TABLE_NAME=#table_name# and EXT_DATASOURCE=#ext_datasource# or ID=#id#";
			runner.execute(delSql, paramMap);
			String saveSql = "insert into x_extds_info values(#uuid#,#owner#,#table_name#,#table_desc#,#ext_datasource#)";
			n = runner.execute(saveSql, paramMap);
			if(n >0){
				flag = "true";
				msg = "保存成功";
			}else{
				flag = "false";
				msg = "保存失败";
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			flag = "false";
			msg = "保存时异常";
		}
		resMap.put("flag", flag);
		resMap.put("msg", msg);
		JSONObject json = JSONObject.fromObject(resMap); 
		String jsonStr = json.toString();
		out.print( jsonStr);
	}
}
