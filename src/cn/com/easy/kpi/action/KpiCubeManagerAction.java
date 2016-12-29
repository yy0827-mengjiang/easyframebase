package cn.com.easy.kpi.action;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;

/**
 * @author Administrator
 * 数据魔方Action
 */
@Controller
public class KpiCubeManagerAction {
	
	private SqlRunner runner;
	
	/**
	 * @param request
	 * @param response
	 * @param ADD_CUBE_CODE 魔方编码
	 * @param ADD_CUBE_NAME 魔方名称
	 * @param ADD_CUBE_DESC 魔方描述
	 * @param ADD_CUBE_DATASOURCE 魔方数据源
	 * @param ADD_CUBE_ATTR 魔方属性 新增后不可修改。1主键，2维度，3属性
	 * @param ADD_ACCOUNT_TYPE 魔方状态 0无效，1有效
	 */
	@Action("KpiCubeManager/addKpiCube")
	public void addKpiCube(HttpServletRequest request, HttpServletResponse response,String ADD_CUBE_CODE,String ADD_CUBE_NAME,String ADD_CUBE_DESC,
			String ADD_CUBE_DATASOURCE,String ADD_CUBE_ATTR,String ADD_ACCOUNT_TYPE,String ADD_CUBE_FLAG){
		Map<String,String> resMap = new HashMap<String,String>();
		String flag="";
		String msg="";
		int n = -1;
		PrintWriter out = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			Map<String,String> paramMap = new HashMap<String,String>();
			paramMap.put("CUBE_CODE", ADD_CUBE_CODE);
			paramMap.put("CUBE_NAME", ADD_CUBE_NAME);
			paramMap.put("CUBE_DESC",ADD_CUBE_DESC);
			paramMap.put("CUBE_DATASOURCE",ADD_CUBE_DATASOURCE);
			paramMap.put("CUBE_ATTR",ADD_CUBE_ATTR);
			paramMap.put("ACCOUNT_TYPE",ADD_ACCOUNT_TYPE);
			paramMap.put("CUBE_STATUS","1");
			paramMap.put("CUBE_FLAG", ADD_CUBE_FLAG);
			String user = ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID")+"";
			paramMap.put("CUBE_CREATEUSER",user);//创建人
			String saveSql = "insert into X_KPI_CUBE(CUBE_CODE,CUBE_NAME,CUBE_DESC,CUBE_DATASOURCE,CUBE_ATTR,ACCOUNT_TYPE,CUBE_STATUS,CUBE_CREATEUSER,CUBE_FLAG,CUBE_CREATETIME) values(#CUBE_CODE#,#CUBE_NAME#,#CUBE_DESC#,#CUBE_DATASOURCE#,#CUBE_ATTR#,#ACCOUNT_TYPE#,#CUBE_STATUS#,#CUBE_CREATEUSER#,#CUBE_FLAG#,NOW())";
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
	/**
	 * @param request
	 * @param response
	 * @param CUBE_CODE 魔方编码
	 * @param CUBE_NAME 魔方名称
	 * @param CUBE_DESC 魔方描述
	 * @param CUBE_DATASOURCE 魔方数据源
	 * @param CUBE_ATTR 魔方属性 新增后不可修改。1主键，2维度，3属性
	 * @param ACCOUNT_TYPE 魔方状态 0无效，1有效
	 */
	@Action("KpiCubeManager/updateKpiCube")
	public void updateKpiCube(HttpServletRequest request, HttpServletResponse response,String CUBE_CODE,String CUBE_NAME,String CUBE_DESC,
			String CUBE_DATASOURCE,String CUBE_ATTR,String ACCOUNT_TYPE,String CUBE_FLAG){
		Map<String,String> resMap = new HashMap<String,String>();
		String flag="";
		String msg="";
		int n = -1;
		PrintWriter out = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			Map<String,String> paramMap = new HashMap<String,String>();
			paramMap.put("CUBE_CODE", CUBE_CODE);
			paramMap.put("CUBE_NAME", CUBE_NAME);
			paramMap.put("CUBE_DESC",CUBE_DESC);
			paramMap.put("CUBE_DATASOURCE",CUBE_DATASOURCE);
			paramMap.put("CUBE_ATTR",CUBE_ATTR);
			paramMap.put("ACCOUNT_TYPE",ACCOUNT_TYPE);
			paramMap.put("CUBE_FLAG",CUBE_FLAG);

//			paramMap.put("CUBE_STATUS",ADD_CUBE_STATUS);
			String user = ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID")+"";
			paramMap.put("CUBE_UPDATEUSER",user);//修改人
//			String udpSql = "update x_kpi_cube a set a.CUBE_CODE = #CUBE_CODE#,a.CUBE_NAME=#CUBE_NAME#,a.CUBE_DESC=#CUBE_DESC#,a.CUBE_DATASOURCE=#CUBE_DATASOURCE#" +
//					",a.CUBE_ATTR=#CUBE_ATTR# ,a.ACCOUNT_TYPE=#ACCOUNT_TYPE# ,a.CUBE_UPDATEUSER=#CUBE_UPDATEUSER#,a.CUBE_UPDATETIME=SYSTIMESTAMP,a.CUBE_FLAG=#CUBE_FLAG# where a.CUBE_CODE = #CUBE_CODE#";
			String udpSql = runner.sql("kpi.cube.updateCubeInfo");
			n = runner.execute(udpSql, paramMap);
			if(n >0){
				flag = "true";
				msg = "修改成功";
			}else{
				flag = "false";
				msg = "修改失败";
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			flag = "false";
			msg = "修改时异常";
		}
		resMap.put("flag", flag);
		resMap.put("msg", msg);
		JSONObject json = JSONObject.fromObject(resMap); 
		String jsonStr = json.toString();
		out.print( jsonStr);
	}
}
