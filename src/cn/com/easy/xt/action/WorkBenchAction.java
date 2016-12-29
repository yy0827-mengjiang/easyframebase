package cn.com.easy.xt.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.service.component.ComponentBaseService;
import cn.com.easy.xt.logic.WorkBenchLogic;

@Controller
public class WorkBenchAction extends ComponentBaseService{
	private WorkBenchLogic logic =new WorkBenchLogic();
	/**
	 * 任务执行返回用户信息
	 * @param request
	 * @param response
	 * @param paramMap
	 */
	@Action("taskExecuteUserInfo")
	public void taskExecuteUserInfo(HttpServletRequest request, HttpServletResponse response,Map<String,String> paramMap){
		
		Map<String,String>resMap = logic.getUsrInfo(paramMap);
		PrintWriter out = null;
		try{
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			out.print(Functions.java2json(resMap));
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(out != null){
				out.flush();
				out.close();
			}
		}
		
	}
	
	/**
	 * 任务执行工单信息
	 * @param request
	 * @param response
	 * @param paramMap
	 */
	@Action("taskExecuteWorkOrd")
	public String taskExecuteWorkOrd(HttpServletRequest request, HttpServletResponse response,Map<String,String> paramMap){
		String url = "pages/xt/workbench/aaa.jsp";
		Map map = logic.getTaskList(paramMap);
		List list = (List) map.get("items");
		request.setAttribute("list", list);
		return url;
	}
	
	/**
	 * 工单保存
	 * @param request
	 * @param response
	 * @param paramMap
	 */
	@Action("insTaskExecute")
	public void insTaskExecute(HttpServletRequest request, HttpServletResponse response,Map<String,String> paramMap){
		Map json = logic.insTaskExecute(paramMap);
		PrintWriter out = null;
		try{
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			out.print(Functions.java2json(json));
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(out != null){
				out.flush();
				out.close();
			}
		}
	}
	
	/**
	 * 查询工单历史
	 * @param request
	 * @param response
	 * @param paramMap
	 */
	public void taskHistoryList(HttpServletRequest request, HttpServletResponse response,Map<String,String> paramMap){
		Map json = logic.taskHistoryList(paramMap);
		PrintWriter out = null;
		try{
			
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			out.print(Functions.java2json(json));
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(out != null){
				out.flush();
				out.close();
			}
		}
		
		
	}
	
	/**
	 * 任务列表datagrid数据源
	 * @param params
	 * @param request
	 * @param response
	 */
	@Action("getActives")
	public void getActives(Map<String, Object> params,HttpServletRequest request,HttpServletResponse response) {
		//获取当前页码
		System.out.println("params>>>>>"+params);
		String pama="1=1";
		int page = 0;
		if (String.valueOf(params.get("page")) != null && !String.valueOf(params.get("page")).equals("")) {
			page = Integer.parseInt(String.valueOf(params.get("page")));
		}
		//获取显示行数
		int rows = Integer.parseInt(String.valueOf(params.get("rows")));
		System.out.println("rows>>"+rows+"-----page"+page);
		//获取登录人id
		String user_id=((Map<String, String>) request.getSession().getAttribute("UserInfo")).get("USER_ID");
		String task_name=(String) params.get("task_name");
		if (task_name!= null&&!"".equals(task_name)) {
			pama+=" and active_name like '%"+String.valueOf(params.get("task_name"))+"%'";
		}
		String active_class=(String) params.get("active_class");
		if (active_class!= null &&! "".equals(active_class)) {
			pama+=" and active_class = '"+active_class+"'";
		}
		Map<String,Object> data_params=new HashMap<String, Object>();
		data_params.put("pageNum", page);
		data_params.put("pageSize", rows);
		data_params.put("cellId", user_id);
		data_params.put("pama", pama);
		
		Map<String,Object> rowDatas=null;
		rowDatas=logic.getActives(data_params);
		String count = null;
		// datagrid请求数据 返回json ，
		List<Map<String, Object>> contentlist = null;
		System.out.println("datas>>>>>>"+rowDatas);
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		if(rowDatas!=null){
			count=(String) rowDatas.get("total");
			contentlist=(List<Map<String, Object>>) rowDatas.get("items");
			jsonMap.put("total", count);// total键 存放总记录数，必须的
			jsonMap.put("rows", contentlist);// rows键 存放每页记录 list
		}
		PrintWriter out = null;
		try {
			response.setHeader("Expires","-1");
			response.setHeader("Pragma","no-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/html");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			out.write(jsonMap == null ? "{}" : Functions.java2json(jsonMap));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			if(out != null){
				out.flush();
				out.close();
			}
		}
	}
	
	/**
	 * 任务列表datagrid数据源
	 * @param params
	 * @param request
	 * @param response
	 */
	@Action("getOrders")
	public void getOrders(Map<String, Object> params,HttpServletRequest request,HttpServletResponse response) {
		
	}
}
