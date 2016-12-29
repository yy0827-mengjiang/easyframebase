package cn.com.easy.terminal.action;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URL;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.tools.ant.types.FileList.FileName;
import org.omg.PortableInterceptor.SYSTEM_EXCEPTION;
import org.springframework.web.context.request.SessionScope;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.ext.DownLoad;
import cn.com.easy.taglib.function.Functions;

@Controller
public class TerminalController {
	
	private SqlRunner runner;
	//登录用户ID
	String userId = "";
	//登录用户IP
	String IP = "";
	String areaNo = "";
	String cityNo = "";
	
	//上传文档
	@Action("loadFiles")
	public void addFile(HttpServletRequest request,HttpServletResponse response,String menuId) throws Exception{

		HttpSession session = request.getSession();
		Map userInfo=(Map)request.getSession().getAttribute("UserInfo");
		
		userId = String.valueOf(userInfo.get("USER_ID"));
		IP = String.valueOf(userInfo.get("IP"));
		areaNo = String.valueOf(userInfo.get("AREA_NO"));
		cityNo = String.valueOf(userInfo.get("CITY_NO"));
		
		System.out.println("------"+cityNo);
		
		String userName  =String.valueOf(userInfo.get("USER_NAME"));
	   
		//上传文件路径
		String fileUrl = "";
		//上传文件类型
		String fileType = "";
		//上传文件名称
		String fielName = "";
		
		//上传文档ID（当前系统时间确保唯一）
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String ID = sdf.format(new Date());
		
		Map<String,Object> returnMap = new HashMap<String,Object>();
		response.setCharacterEncoding("UTF-8"); 
		// 提供解析时的一些缺省配置
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// 创建一个解析器,分析InputStream,该解析器会将分析的结果封装成一个FileItem对象的集合
		// 一个FileItem对象对应一个表单域
		ServletFileUpload sfu = new ServletFileUpload(factory);
		List<FileItem> items = sfu.parseRequest(request);
		//String fileUrl = "";
		returnMap.put("success", true);		
		
		for (int i = 0; i < items.size(); i++) {
			FileItem item = items.get(i);
			
			if (!item.isFormField()) {
				fileUrl = item.getName();
				// 在某些操作系统上,item.getName()方法会返回文件的完整名称,即包括路径
				String fileType1 = fileUrl.substring(fileUrl.lastIndexOf(".")); // 截取文件格式
				fileType = fileType1.substring(1);				
				
				// 自定义方式产生文件名
				fielName = fileUrl.substring(fileUrl.lastIndexOf("\\")+1,fileUrl.lastIndexOf(".")); 

				String filePath = request.getSession().getServletContext().getRealPath("/pages/terminal/loadFiles");
                File fielDir = new File(filePath);
				File uploadFile = new File(filePath + File.separator + fielName + fileType1);
				fileUrl = filePath+"\\"+  fielName + fileType1;
				if(!fielDir.exists()){
					fielDir.mkdirs();
                }
				item.write(uploadFile);				
			}
		}
	
		String addSql = "insert into "+"\"DIM_KNOWLEDGE\""+" values (\'"+fileType+"\',\'"+fielName+"\',\'"+fileUrl+"\',\'"+userName+"\',current_date,\'"+ID+"\',\'"+areaNo+"\',\'"+cityNo+"\')";
		int count = runner.execute(addSql);
		
		if(count == 1){
			//向日志表里插入一条记录
			String addSqlLog = "insert into "+"\"e_operation_log\""+" values (\'"+userId+"\',\'"+menuId+"\',\'"+2+"\',\'"+1+"\',\'"+"新增知识文档"+"\',\'"+IP+"\',now())";
			int count1 = runner.execute(addSqlLog);
		}else{
			String addSqlLog = "insert into "+"\"e_operation_log\""+" values (\'"+userId+"\',\'"+menuId+"\',\'"+2+"\',\'"+2+"\',\'"+"新增知识文档"+"\',\'"+IP+"\',now())";
			int count1 = runner.execute(addSqlLog);
		}
    	//返回知识库页面
    	response.sendRedirect("pages/terminal/knowledge/knowledge.jsp");
	}	

	//下载文档
	@Action("downFiles")	
	public void downFiles(HttpServletRequest request, HttpServletResponse response,String IDs,String menuId){
		/*response.setCharacterEncoding("UTF-8");*/
		try {
			HttpSession session = request.getSession();
			Map userInfo=(Map)request.getSession().getAttribute("UserInfo");
			
			userId = String.valueOf(userInfo.get("USER_ID"));
			IP = String.valueOf(userInfo.get("IP"));
			
			Map<String, String> map=(Map<String, String>)runner.queryForMap("SELECT "+"\"FILE_TYPE\""+","+"\"FILE_NAME\""+","+"\"URL\""+" FROM "+"\"DIM_KNOWLEDGE\""+" WHERE "+"\"ID\""+"="+IDs+"");
			//下载的文件的名称
			String fileName=map.get("FILE_NAME");
			//文件路径
			String filePath=map.get("URL");
			
			
			File file=new File(filePath);
			if(!(file.exists())){
				String addSqlLog = "insert into "+"\"e_operation_log\""+" values (\'"+userId+"\',\'"+menuId+"\',\'"+2+"\',\'"+2+"\',\'"+"下载知识文档"+"\',\'"+IP+"\',now())";
				int count1 = runner.execute(addSqlLog);
				System.err.println("要下载的文件不在在，文件路径为:"+filePath+"，id为:"+IDs);
				response.getWriter().write("<script>alert('文件不存在,请联系管理员!');history.back(-1);</script>");
			}else{
				DownLoad downs = new DownLoad();
				downs.downloadFile(request, response, filePath, fileName);
				String addSqlLog = "insert into "+"\"e_operation_log\""+" values (\'"+userId+"\',\'"+menuId+"\',\'"+2+"\',\'"+1+"\',\'"+"下载知识文档"+"\',\'"+IP+"\',now())";
				int count1 = runner.execute(addSqlLog);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}		
	}
}
