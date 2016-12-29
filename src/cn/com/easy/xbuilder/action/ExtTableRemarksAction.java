package cn.com.easy.xbuilder.action;

import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.taglib.function.Functions;

/**
 * 数据表字段描述管理
 * @author Administrator
 *
 */
@Controller
public class ExtTableRemarksAction {
	
	private SqlRunner runner;
	
	/**
	 * 添加字段描述到X_EXTDS_REMARKS
	 * @param jsonData
	 * @param response
	 */
	@SuppressWarnings("unchecked")
	@Action("ExtTableRemarksAction/addExtTableRemarks")
	public void addExtTableRemarks(String jsonData,HttpServletResponse response){
		String flag = "true";
		PrintWriter out = null;
		Map<String, String> res = new HashMap<String, String>();
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			Map<String, Object> map = new HashMap<String, Object>();
			map = (Map<String, Object>) Functions.json2java(jsonData);
			String tableName = map.get("tableName").toString();
			String extDs = map.get("extDs").toString();
			List list = new ArrayList();
			list = (List) map.get("rows");
			for(int i = 0;i<list.size();i++){
				String id = String.valueOf(UUID.randomUUID()).replaceAll("-", "");
				Map row = (Map) list.get(i);
				String colDesc = String.valueOf(row.get("colDesc"));
				String colName = String.valueOf(row.get("colName"));
				String delsql = "delete from X_EXTDS_REMARKS where EXTDS='"+extDs+"' and upper(TABLENAME)='"+tableName.toUpperCase()+"' and upper(COLUMNNAME)='"+colName.toUpperCase()+"'";
				runner.execute(delsql, new HashMap());
				String inssql = "insert into X_EXTDS_REMARKS VALUES ('"+id+"', '"+extDs+"', '"+tableName+"', '"+colName+"', ?)";
				runner.execute(inssql, new String[]{colDesc});
			}
			res.put("flag", flag);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "false";
			res.put("flag", flag);
		}finally{
			JSONObject json = JSONObject.fromObject(res); 
			String jsonStr = json.toString();
			out.print( jsonStr);
			out.flush();
			if(null!=out){
				out.close();
			}
		}
		
	}
	
}
