package cn.com.easy.down.client.action;

import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.down.client.TransferClient;
import cn.com.easy.ext.DownLoad;
import cn.com.easy.taglib.function.Functions;
import net.sf.json.JSONObject;

@Controller
public class ExportCenterAction {
	private SqlRunner runner;
	private static int order = 0;
	
	/**
	 * 普通表格excel
	 * @param columns
	 * @param filename
	 * @param dataSourceName
	 * @param request
	 * @param response
	 */
	@SuppressWarnings("unchecked")
	@Action("downCtableEC")
	public void downCtableEC(String columns, String filename,
			String dataSourceName, HttpServletRequest request,
			HttpServletResponse response) {
		PrintWriter out = null;
		Map<String,String> resMap = new HashMap<String,String>();
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			
			String state = "1";
			Map<String, Object> info = getInfo(request);
			info.put("markInfo", getMarkInfo(request));	
			String csql = (String) request.getSession().getAttribute("down_c_talbe_sql");
			List<Map> clist = (List<Map>) request.getSession().getAttribute("down_c_talbe_list");
			String jsonData = null;
			if(null!=clist&&clist.size()>0){
				state = "2";
				jsonData = Functions.java2json(clist);
			}
			Map<String, String> parameters = getParames(request);
			
			dataSourceName = (String) request.getSession().getAttribute("down_c_talbe_db");
			String downLoadServerUrls=(request.getSession().getServletContext().getAttribute("DownLoadServerUrls")==null?"":(String)request.getSession().getServletContext().getAttribute("DownLoadServerUrls"));
			String []downLoadServerArray=StringUtils.split(downLoadServerUrls,";");
			int urlnum = downLoadServerArray.length;
			String ip = null;
			int port = 0;
			if(urlnum>0){
				ip = downLoadServerArray[order%urlnum].split(":")[0];
				port = Integer.parseInt(downLoadServerArray[order%urlnum].split(":")[1]);
			}
			String downParams=(request.getParameter("downParams")==null?"":request.getParameter("downParams"));
			info .put("downParams", downParams);
			info .put("fileType", "excel");
			info .put("downSql", csql);
			info .put("parameters", parameters);
			info .put("downDb", dataSourceName);
			String uuid = String.valueOf(UUID.randomUUID()).replaceAll("-", "");
			info .put("id", uuid);
			info .put("jsonData", jsonData);
			info .put("fileName", filename);
			info .put("columns", columns);
			info .put("commentType", "table");
			info .put("svgCode", null);
			info .put("dataType", state);//1sql  2json
			
			TransferClient client = new TransferClient(ip, port,info);
			client.service();
			
			resMap.put("id", uuid);
			JSONObject json = JSONObject.fromObject(resMap); 
			String jsonStr = String.valueOf(json);
			out.print( jsonStr);
			order++;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("在导出 " + filename + " 文件时出错，请联系管理员");
		} finally{
			if(out!=null){
				out.close();
			}
		}
		
	}
	/**
	 * 普通表格Xlsx
	 * @param columns
	 * @param filename
	 * @param dataSourceName
	 * @param request
	 * @param response
	 */
	@SuppressWarnings("unchecked")
	@Action("downCtableXlsxEC")
	public void downCtableXlsxEC(String columns, String filename,
			String dataSourceName, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			String state = "1";
			Map<String, Object> info = getInfo(request);
			info.put("markInfo", getMarkInfo(request));	
			String csql = (String) request.getSession().getAttribute("down_c_talbe_sql");
			List<Map> clist = (List<Map>) request.getSession().getAttribute("down_c_talbe_list");
			String jsonData = null;
			if(null!=clist&&clist.size()>0){
				state = "2";
				jsonData = Functions.java2json(clist);
			}
			Map<String, String> parameters = getParames(request);
			
			dataSourceName = (String) request.getSession().getAttribute("down_c_talbe_db");
			String downLoadServerUrls=(request.getSession().getServletContext().getAttribute("DownLoadServerUrls")==null?"":(String)request.getSession().getServletContext().getAttribute("DownLoadServerUrls"));
			String []downLoadServerArray=StringUtils.split(downLoadServerUrls,";");
			int urlnum = downLoadServerArray.length;
			String ip = null;
			int port = 0;
			if(urlnum>0){
				ip = downLoadServerArray[order%urlnum].split(":")[0];
				port = Integer.parseInt(downLoadServerArray[order%urlnum].split(":")[1]);
			}
			String downParams=(request.getParameter("downParams")==null?"":request.getParameter("downParams"));
			info .put("downParams", downParams);
			info .put("fileType", "xlsx");
			info .put("downSql", csql);
			info .put("parameters", parameters);
			info .put("downDb", dataSourceName);
			info .put("id", String.valueOf(UUID.randomUUID()).replaceAll("-", ""));
			info .put("jsonData", jsonData);
			info .put("fileName", filename);
			info .put("columns", columns);
			info .put("commentType", "table");
			info .put("svgCode", null);
			info .put("dataType", state);//1sql  2json
			
			TransferClient client = new TransferClient(ip, port,info);
			client.service();
			order++;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("在导出 " + filename + " 文件时出错，请联系管理员");
		} 
		
	}
	
	/**
	 * 普通表格pdf
	 * @param columns
	 * @param filename
	 * @param dataSourceName
	 * @param request
	 * @param response
	 */
	@SuppressWarnings("unchecked")
	@Action("downCtablePdfEC")
	public void downCtablePdfEC(String columns, String filename,
			String dataSourceName, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			String state = "1";
			Map<String, Object> info = getInfo(request);
			info.put("markInfo", getMarkInfo(request));
			String csql = (String) request.getSession().getAttribute("down_c_talbe_sql");
			List<Map> clist = (List<Map>) request.getSession().getAttribute("down_c_talbe_list");
			String jsonData = null;
			if(null!=clist&&clist.size()>0){
				state = "2";
				jsonData = Functions.java2json(clist);
			}
			Map<String, String> parameters = getParames(request);
			
			dataSourceName = (String) request.getSession().getAttribute("down_c_talbe_db");
			String downLoadServerUrls=(request.getSession().getServletContext().getAttribute("DownLoadServerUrls")==null?"":(String)request.getSession().getServletContext().getAttribute("DownLoadServerUrls"));
			String []downLoadServerArray=StringUtils.split(downLoadServerUrls,";");
			int urlnum = downLoadServerArray.length;
			String ip = null;
			int port = 0;
			if(urlnum>0){
				ip = downLoadServerArray[order%urlnum].split(":")[0];
				port = Integer.parseInt(downLoadServerArray[order%urlnum].split(":")[1]);
			}
			String downParams=(request.getParameter("downParams")==null?"":request.getParameter("downParams"));
			info .put("downParams", downParams);
			info .put("fileType", "pdf");
			info .put("downSql", csql);
			info .put("parameters", parameters);
			info .put("downDb", dataSourceName);
			info .put("id", String.valueOf(UUID.randomUUID()).replaceAll("-", ""));
			info .put("jsonData", jsonData);
			info .put("fileName", filename);
			info .put("columns", columns);
			info .put("commentType", "table");
			info .put("svgCode", null);
			info .put("dataType", state);//1sql  2json
			 
			TransferClient client = new TransferClient(ip, port,info);
			client.service();
			order++;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("在导出 " + filename + " 文件时出错，请联系管理员");
		} 
		
	}
	
	/**
	 * 导出交叉表格Excel
	 * @param jsonData
	 * @param fileName
	 * @param dataSourceName
	 * @param columns
	 * @param request
	 * @param response
	 */
	@Action("downXTableExcelEC")
	public void downXTableExcelEC(String jsonData, String fileName,
			String dataSourceName, String columns, HttpServletRequest request,
			HttpServletResponse response) {
		PrintWriter out = null;
		Map<String,String> resMap = new HashMap<String,String>();
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			
			Map<String, Object> info = getInfo(request);
			info.put("markInfo", getMarkInfo(request));
			String downLoadServerUrls=(request.getSession().getServletContext().getAttribute("DownLoadServerUrls")==null?"":(String)request.getSession().getServletContext().getAttribute("DownLoadServerUrls"));
			String []downLoadServerArray=StringUtils.split(downLoadServerUrls,";");
			int urlnum = downLoadServerArray.length;
			String ip = null;
			int port = 0;
			if(urlnum>0){
				ip = downLoadServerArray[order%urlnum].split(":")[0];
				port = Integer.parseInt(downLoadServerArray[order%urlnum].split(":")[1]);
			}
			String uuid = String.valueOf(UUID.randomUUID()).replaceAll("-", "");
			String downParams=(request.getParameter("downParams")==null?"":request.getParameter("downParams"));
			info .put("downParams", downParams);
			info .put("fileType", "excel");
			info .put("downSql", null);
			info .put("parameters", null);
			info .put("downDb", null);
			info .put("id", uuid);
			info .put("jsonData", jsonData);
			info .put("fileName", fileName);
			info .put("columns", columns);
			info .put("commentType", "table");
			info .put("svgCode", null);
			info .put("dataType", "2");//1sql  2json
			 
			TransferClient client = new TransferClient(ip, port,info);
			client.service();
			
			resMap.put("id", uuid);
			JSONObject json = JSONObject.fromObject(resMap); 
			String jsonStr = String.valueOf(json);
			out.print( jsonStr);
			order++;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("在导出 " + fileName + " 文件时出错，请联系管理员");
		}finally{
			if(out!=null){
				out.close();
			}
		}
	}
	
	/**
	 * 导出交叉表格Xlsx
	 * @param jsonData
	 * @param fileName
	 * @param dataSourceName
	 * @param columns
	 * @param request
	 * @param response
	 */
	@Action("downXTableXlsxEC")
	public void downXTableXlsxEC(String jsonData, String fileName,
			String dataSourceName, String columns, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			Map<String, Object> info = getInfo(request);
			info.put("markInfo", getMarkInfo(request));
			String downLoadServerUrls=(request.getSession().getServletContext().getAttribute("DownLoadServerUrls")==null?"":(String)request.getSession().getServletContext().getAttribute("DownLoadServerUrls"));
			String []downLoadServerArray=StringUtils.split(downLoadServerUrls,";");
			int urlnum = downLoadServerArray.length;
			String ip = null;
			int port = 0;
			if(urlnum>0){
				ip = downLoadServerArray[order%urlnum].split(":")[0];
				port = Integer.parseInt(downLoadServerArray[order%urlnum].split(":")[1]);
			}
			String downParams=(request.getParameter("downParams")==null?"":request.getParameter("downParams"));
			info .put("downParams", downParams);
			info .put("fileType", "xlsx");
			info .put("downSql", null);
			info .put("parameters", null);
			info .put("downDb", null);
			info .put("id", String.valueOf(UUID.randomUUID()).replaceAll("-", ""));
			info .put("jsonData", jsonData);
			info .put("fileName", fileName);
			info .put("columns", columns);
			info .put("commentType", "table");
			info .put("svgCode", null);
			info .put("dataType", "2");//1sql  2json
			
			TransferClient client = new TransferClient(ip, port,info);
			client.service();
			order++;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("在导出 " + fileName + " 文件时出错，请联系管理员");
		}
	}

	/**
	 * 导出交叉表格pdf
	 * @param jsonData
	 * @param fileName
	 * @param dataSourceName
	 * @param columns
	 * @param request
	 * @param response
	 */
	@Action("downXTablePdfEC")
	public void downXTablePdfEC(String jsonData, String fileName,
			String dataSourceName, String columns, HttpServletRequest request,
			HttpServletResponse response){
		try {
			Map<String, Object> info = getInfo(request);
			info.put("markInfo", getMarkInfo(request));
			String downLoadServerUrls=(request.getSession().getServletContext().getAttribute("DownLoadServerUrls")==null?"":(String)request.getSession().getServletContext().getAttribute("DownLoadServerUrls"));
			String []downLoadServerArray=StringUtils.split(downLoadServerUrls,";");
			int urlnum = downLoadServerArray.length;
			String ip = null;
			int port = 0;
			if(urlnum>0){
				ip = downLoadServerArray[order%urlnum].split(":")[0];
				port = Integer.parseInt(downLoadServerArray[order%urlnum].split(":")[1]);
			}
			String downParams=(request.getParameter("downParams")==null?"":request.getParameter("downParams"));
			info .put("downParams", downParams);
			info .put("fileType", "pdf");
			info .put("downSql", null);
			info .put("parameters", null);
			info .put("downDb", null);
			info .put("id", String.valueOf(UUID.randomUUID()).replaceAll("-", ""));
			info .put("jsonData", jsonData);
			info .put("fileName", fileName);
			info .put("columns", columns);
			info .put("commentType", "table");
			info .put("svgCode", null);
			info .put("dataType", "2");//1sql  2json
			 
			TransferClient client = new TransferClient(ip, port,info);
			client.service();
			order++;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("在导出 " + fileName + " 文件时出错，请联系管理员");
		}
	}
	
	/**
	 * 导出下钻列excel
	 * @param columns
	 * @param filename
	 * @param dataSourceName
	 * @param request
	 * @param response
	 */
	@Action("downTgridExcelEC")
	public void downTgridExcelEC(String columns, String filename,
			String dataSourceName, HttpServletRequest request,
			HttpServletResponse response) {
		PrintWriter out = null;
		Map<String,String> resMap = new HashMap<String,String>();
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();

			Map<String, Object> info = getInfo(request);
			info.put("markInfo", getMarkInfo(request));
			String csql = (String) request.getSession().getAttribute("down_t_talbe_sql");
			
			Map<String, String> parameters = getParames(request);
			
			dataSourceName = (String) request.getSession().getAttribute("down_t_talbe_db");
			String downLoadServerUrls=(request.getSession().getServletContext().getAttribute("DownLoadServerUrls")==null?"":(String)request.getSession().getServletContext().getAttribute("DownLoadServerUrls"));
			String []downLoadServerArray=StringUtils.split(downLoadServerUrls,";");
			int urlnum = downLoadServerArray.length;
			String ip = null;
			int port = 0;
			if(urlnum>0){
				ip = downLoadServerArray[order%urlnum].split(":")[0];
				port = Integer.parseInt(downLoadServerArray[order%urlnum].split(":")[1]);
			}
			String downParams=(request.getParameter("downParams")==null?"":request.getParameter("downParams"));
			info .put("downParams", downParams);
			info .put("fileType", "excel");
			info .put("downSql", csql);
			info .put("parameters", parameters);
			info .put("downDb", dataSourceName);
			String uuid = String.valueOf(UUID.randomUUID()).replaceAll("-", "");
			info .put("id", uuid);
			info .put("jsonData", null);
			info .put("fileName", filename);
			info .put("columns", columns);
			info .put("commentType", "table");
			info .put("svgCode", null);
			info .put("dataType", "1");//1sql  2json
			 
			TransferClient client = new TransferClient(ip, port,info);
			client.service();
			
			resMap.put("id", uuid);
			JSONObject json = JSONObject.fromObject(resMap); 
			String jsonStr = String.valueOf(json);
			out.print( jsonStr);
			order++;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("在导出 " + filename + " 文件时出错，请联系管理员");
		}finally{
			if(out!=null){
				out.close();
			}
		}
	}
	/**
	 * 导出下钻列Xlsx
	 * @param columns
	 * @param filename
	 * @param dataSourceName
	 * @param request
	 * @param response
	 */
	@Action("downTgridXlsxEC")
	public void downTgridXlsxEC(String columns, String filename,
			String dataSourceName, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			
			Map<String, Object> info = getInfo(request);
			info.put("markInfo", getMarkInfo(request));
			String csql = (String) request.getSession().getAttribute("down_t_talbe_sql");
			
			Map<String, String> parameters = getParames(request);
			
			dataSourceName = (String) request.getSession().getAttribute("down_t_talbe_db");
			String downLoadServerUrls=(request.getSession().getServletContext().getAttribute("DownLoadServerUrls")==null?"":(String)request.getSession().getServletContext().getAttribute("DownLoadServerUrls"));
			String []downLoadServerArray=StringUtils.split(downLoadServerUrls,";");
			int urlnum = downLoadServerArray.length;
			String ip = null;
			int port = 0;
			if(urlnum>0){
				ip = downLoadServerArray[order%urlnum].split(":")[0];
				port = Integer.parseInt(downLoadServerArray[order%urlnum].split(":")[1]);
			}
			String downParams=(request.getParameter("downParams")==null?"":request.getParameter("downParams"));
			info .put("downParams", downParams);
			info .put("fileType", "xlsx");
			info .put("downSql", csql);
			info .put("parameters", parameters);
			info .put("downDb", dataSourceName);
			info .put("id", String.valueOf(UUID.randomUUID()).replaceAll("-", ""));
			info .put("jsonData", null);
			info .put("fileName", filename);
			info .put("columns", columns);
			info .put("commentType", "table");
			info .put("svgCode", null);
			info .put("dataType", "1");//1sql  2json
			
			TransferClient client = new TransferClient(ip, port,info);
			client.service();
			order++;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("在导出 " + filename + " 文件时出错，请联系管理员");
		}
	}
	
	/**
	 * 导出下钻列pdf
	 * @param columns
	 * @param filename
	 * @param dataSourceName
	 * @param request
	 * @param response
	 */
	@Action("downTgridPdfEC")
	public void downTgridPdfEC(String columns, String filename,
			String dataSourceName, HttpServletRequest request,
			HttpServletResponse response) {
		try {

			Map<String, Object> info = getInfo(request);
			info.put("markInfo", getMarkInfo(request));
			String csql = (String) request.getSession().getAttribute("down_t_talbe_sql");
			
			Map<String, String> parameters = getParames(request);
			
			dataSourceName = (String) request.getSession().getAttribute("down_t_talbe_db");
			String downLoadServerUrls=(request.getSession().getServletContext().getAttribute("DownLoadServerUrls")==null?"":(String)request.getSession().getServletContext().getAttribute("DownLoadServerUrls"));
			String []downLoadServerArray=StringUtils.split(downLoadServerUrls,";");
			int urlnum = downLoadServerArray.length;
			String ip = null;
			int port = 0;
			if(urlnum>0){
				ip = downLoadServerArray[order%urlnum].split(":")[0];
				port = Integer.parseInt(downLoadServerArray[order%urlnum].split(":")[1]);
			}
			String downParams=(request.getParameter("downParams")==null?"":request.getParameter("downParams"));
			info .put("downParams", downParams);
			info .put("fileType", "pdf");
			info .put("downSql", csql);
			info .put("parameters", parameters);
			info .put("downDb", dataSourceName);
			info .put("id", String.valueOf(UUID.randomUUID()).replaceAll("-", ""));
			info .put("jsonData", null);
			info .put("fileName", filename);
			info .put("columns", columns);
			info .put("commentType", "table");
			info .put("svgCode", null);
			info .put("dataType", "1");//1sql  2json
			 
			TransferClient client = new TransferClient(ip, port,info);
			client.service();
			order++;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("在导出 " + filename + " 文件时出错，请联系管理员");
		}
	}
	
	
	/**
	 * 导出图表
	 * @param request
	 * @param response
	 */
	@Action("downChartEC")
	public void downChartEC(HttpServletRequest request, HttpServletResponse response) {
		String filename = "";
		try {
			System.out.println("downParams:"+request.getParameter("downParams"));
			Map<String, Object> info = getInfo(request);
			info.put("markInfo", getMarkInfo(request));
			filename = request.getParameter("filename");
			String contentType = request.getParameter("type");
			String svgCode = request.getParameter("svg");
			String dataSetJson = request.getParameter("dataSet");
			svgCode = svgCode.replaceAll("stroke=\"rgba(.*?)\"", "");
			svgCode = svgCode.replaceAll("fill=\"rgba(.*?)\"", "");
			String downLoadServerUrls=(request.getSession().getServletContext().getAttribute("DownLoadServerUrls")==null?"":(String)request.getSession().getServletContext().getAttribute("DownLoadServerUrls"));
			String []downLoadServerArray=StringUtils.split(downLoadServerUrls,";");
			int urlnum = downLoadServerArray.length;
			String ip = null;
			int port = 0;
			if(urlnum>0){
				ip = downLoadServerArray[order%urlnum].split(":")[0];
				port = Integer.parseInt(downLoadServerArray[order%urlnum].split(":")[1]);
			}
			String downParams=(request.getParameter("downParams")==null?"":request.getParameter("downParams"));
			info .put("downParams", downParams);
			info .put("fileType", contentType);
			info .put("downSql", null);
			info .put("parameters", null);
			info .put("downDb", null);
			info .put("id", String.valueOf(UUID.randomUUID()).replaceAll("-", ""));
			info .put("jsonData", dataSetJson);
			info .put("fileName", filename);
			info .put("columns", null);
			info .put("commentType", "chart");
			info .put("svgCode", svgCode);
			info .put("dataType", "2");//1sql  2json
			
			TransferClient client = new TransferClient(ip, port,info);
			client.service();
			order++;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("在导出 " + filename + " 文件时出错，请联系管理员");
		}
		
	}
	/**
	 * 取消下载
	 * @param request
	 * @param id
	 * @return
	 */
	@Action("cancelExportEC")
	public void cancelExport(HttpServletRequest request,HttpServletResponse response,String id){
		Map<String, String> res = new HashMap<String, String>();
		PrintWriter out = null;
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			Map<String, Object> info = new HashMap<String, Object>();
			info.put("id", id);
			info.put("action", "cancel");
			String downLoadServerUrls=(request.getSession().getServletContext().getAttribute("DownLoadServerUrls")==null?"":(String)request.getSession().getServletContext().getAttribute("DownLoadServerUrls"));
			String ip = downLoadServerUrls.split(":")[0];
			int port = Integer.parseInt(downLoadServerUrls.split(":")[1]);
			TransferClient client = new TransferClient(ip, port,info);
			client.service();
			res.put("flag", "true");
			JSONObject json = JSONObject.fromObject(res); 
			String jsonStr = json.toString();
			out.print( jsonStr);
			out.flush();
		} catch (Exception e) {
			e.printStackTrace();
			res.put("flag", "false");
			JSONObject json = JSONObject.fromObject(res); 
			String jsonStr = json.toString();
			out.print( jsonStr);
			out.flush();
		}finally{
			if(out!=null){
				out.close();
			}
		}
		
		
	}
	/**
	 * 删除文件
	 */
	@Action("deleteExportFileEC")
	public void deleteFile(HttpServletRequest request,HttpServletResponse response,String id,String statusId) {
		Map<String, String> res = new HashMap<String, String>();
		PrintWriter out = null;
		try {
			if(null!=statusId&&!"".equals(statusId)&&statusId.trim().equals("2")){
				this.cancelExport(request, response, id);
			}
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			Map<String, Object> info = new HashMap<String, Object>();
			info.put("id", id);
			info.put("action", "delete");
			String downLoadServerUrls=(request.getSession().getServletContext().getAttribute("DownLoadServerUrls")==null?"":(String)request.getSession().getServletContext().getAttribute("DownLoadServerUrls"));
			String ip = downLoadServerUrls.split(":")[0];
			int port = Integer.parseInt(downLoadServerUrls.split(":")[1]);
			TransferClient client = new TransferClient(ip, port,info);
			client.service();
			res.put("flag", "true");
			JSONObject json = JSONObject.fromObject(res); 
			String jsonStr = json.toString();
			out.print( jsonStr);
			out.flush();
		} catch (Exception e) {
			e.printStackTrace();
			res.put("flag", "false");
			JSONObject json = JSONObject.fromObject(res); 
			String jsonStr = json.toString();
			out.print( jsonStr);
			out.flush();
		}finally{
			if(out!=null){
				out.close();
			}
		}
	}
	/**
	 * 下载文件
	 * @param request
	 * @param response
	 * @param filePath
	 * @param fileName
	 */
	@Action("downFileEC")
	public void downFile(HttpServletRequest request, HttpServletResponse response,String filePath,String fileName){
		try{
			DownLoad down = new DownLoad();
			down.downloadFile(request, response, filePath, fileName);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 获取水印信息
	 * @param request
	 * @return
	 */
	private Map<String, String> getMarkInfo(HttpServletRequest request) throws Exception{
		Map<String, String> info = new HashMap<String, String>();
		String flag = (String) request.getSession().getServletContext()
				.getAttribute("PdfWaterMark");
		if (flag.equals("true")) {
			String text = (String) request.getSession().getServletContext()
					.getAttribute("WaterMarkText");
			if (text.equals("login_id")) {
				text = (String) request.getSession().getAttribute("LOGIN_ID");
			} else if (text.equals("user_name")) {
				text = (String) request.getSession().getAttribute("USER_NAME");
			}
			String timeFlag = (String) request.getSession().getServletContext()
			.getAttribute("WaterMarkTextAddedTime");
			if (timeFlag.equals("true")) {
				text += " "
						+ new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
								.format(new Date());
			}
					
			info.put("MaxExcelRow", (String) request.getSession()
					.getServletContext().getAttribute("MaxExcelRow"));
			info.put("MaxPdfRow", (String) request.getSession()
					.getServletContext().getAttribute("MaxPdfRow"));
			info.put("PdfWaterMark", flag);
			info.put("WaterMarkText", text);
			info.put("WaterMarkTextAddedTime", timeFlag);
			info.put("WaterMarkPosition", (String) request.getSession()
					.getServletContext().getAttribute("WaterMarkPosition"));
			info.put("WaterMarkColor", (String) request.getSession()
					.getServletContext().getAttribute("WaterMarkColor"));
			info.put("WaterMarkFontSize", (String) request.getSession()
					.getServletContext().getAttribute("WaterMarkFontSize"));
			info.put("WaterMarkRotate", (String) request.getSession()
					.getServletContext().getAttribute("WaterMarkRotate"));
			info.put("WaterMarkOpacit", (String) request.getSession()
					.getServletContext().getAttribute("WaterMarkOpacit"));
			info.put("waterMarkSpacing", (String) request.getSession()
					.getServletContext().getAttribute("waterMarkSpacing"));
		}
		info.put("action", "export");//导出时action为export
		info.put("userId", ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID")+"");
		info.put("systemFlag", (String) request.getSession()
				.getServletContext().getAttribute("SysTitle"));
		
		return info;
	}
	private Map<String, String> getParames(HttpServletRequest request) {
		Map<String, String[]> parametersMap = new HashMap<String, String[]>(request.getParameterMap());
		Map<String,String> parameters = new HashMap<String, String>();
		for (String key : parametersMap.keySet()) {
			for(String str :parametersMap.get(key)){
				parameters.put(key,str);
			}
		}
		return parameters;
	}
	private Map<String, Object> getInfo(HttpServletRequest request) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("action", "export");//导出时action为export
		map.put("userId", ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID")+"");
		map.put("systemFlag", (String) request.getSession()
				.getServletContext().getAttribute("SysTitle"));
		return map;
	}
	@Action("setDownStatus")
	public void setDownStatus(String downid, String status,
			HttpServletRequest request) {
		HttpSession session = request.getSession();
		String userid = (String) session.getAttribute("USER_ID");
		String userip = request.getLocalAddr();
		session.setAttribute(userip + "_" + userid + "_" + downid, status);
	}
	@SuppressWarnings("unchecked")
	@Action("getDownStatus")
	public void getDownStatus(HttpServletRequest request, HttpServletResponse response,String id){
		PrintWriter out = null;
		Map<String,String> resMap = new HashMap<String,String>();
		try {
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			out = response.getWriter();
			
			String sql = "select status_id from e_exporting_info e where e.id='"+id+"'";
			Map<String, String> map = runner.queryForMap(sql);
			String status_id = null;
			if(null!=map){
				status_id = map.get("status_id");
			}
			resMap.put("status_id", status_id);
			JSONObject json = JSONObject.fromObject(resMap); 
			String jsonStr = String.valueOf(json);
			out.print( jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
			System.err.print("获取下载状态时出错！");
		}finally{
			if(out!=null){
				out.close();
			}
		}
		
	}
	@Action("export2Log")
	  public void export2Log(String menuid, String content, HttpServletRequest request, HttpServletResponse response) {
		String uid = String.valueOf(request.getSession().getAttribute("USER_ID"));
	    String ip = String.valueOf(request.getSession().getAttribute("IP"));
	    try {
	    	
			String sql = this.runner.sql("frame.log.insOperationLog");
	    	
			Map<String,String> parMap = new HashMap<String,String>(); 
			parMap.put("uid", uid);
			parMap.put("menuid", menuid);
			parMap.put("operate_type_code", "5");
			parMap.put("operate_result", "1");
			parMap.put("content", content);
			parMap.put("client_ip", ip);
			
			int code = this.runner.execute(sql, parMap);
			
//	      int code = this.runner
//	        .execute("insert into E_OPERATION_LOG"
//	        		+ "(USER_ID,MENU_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES('" + 
//	        uid + 
//	        "','" + 
//	        menuid + 
//	        "','5','1','" + 
//	        content + 
//	        "','" + ip + "',sysdate)", new Object[0]);

	      if (code != 1)
	        System.out.println("保存用户[" + uid + "]，ip[" + ip + "]在菜单[" + 
	          menuid + "[下载[" + content + "]日志时发生错误。");
	    }
	    catch (SQLException e) {
	      e.printStackTrace();
	    }
	  }
	/**
     * 
     * @param id 旋转组件的id
     * @param dataJson 原始SQL查询结果的JSON字符串
     * @param rotaCol 旋转列(横向的维度列)
     * @param dimCol 维度列(纵向的维度列)
     * @param kpiCol 指标值列
     * @param rotaColOrder 非码表旋转时旋转列的排序方式 升序或降序(asc、desc)
     * @param rotaDimTable 以码表旋转的码表名
     * @param rotaDimCode 码表维度编码字段
     * @param rotaDimDesc 码表维度描述字段
     * @param rotaOrdCode 码表排序字段
     * @param rotaOrdType 码表排序方式 升序或降序(asc、desc)
     * @param request
     * @param response
     */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Action("rotaData")
	public void rotaData(String id,String dataJson, String rotaCol, String dimCol,
			String kpiCol,String rotaColOrder, String rotaDimTable, String rotaDimCode,String rotaDimDesc,
			String rotaOrdCode,String rotaOrdType,HttpServletRequest request,
			HttpServletResponse response) {
		PrintWriter out = null;
		try {
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			out = response.getWriter();
			Map ds = (Map) Functions.json2java(dataJson);
			List<Map> dsList = (List<Map>) ds.get("rows");
			String colData = getCols(id,dsList, rotaCol, dimCol,kpiCol,rotaColOrder,rotaDimTable,rotaDimCode,rotaDimDesc,rotaOrdCode,rotaOrdType,runner);
			String resultData = getFinalData(dsList, rotaCol, dimCol, kpiCol);
			Map<String, String> tagMap = new HashMap<String, String>();
			tagMap.put("cols", colData);
			tagMap.put("data", resultData);
			out.print(Functions.java2json(tagMap));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 获取旋转表格的所有的列
	 * @param id
	 * @param dataList
	 * @param rotaCol
	 * @param dimCol
	 * @param kpiCol
	 * @param rotaColOrder
	 * @param rotaDimTable
	 * @param rotaDimCode
	 * @param rotaDimDesc
	 * @param rotaOrdCode
	 * @param rotaOrdType
	 * @param runner
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static String getCols(String id,List<Map> dataList, String rotaCol,String dimCol,
			String kpiCol,String rotaColOrder, String rotaDimTable, String rotaDimCode,String rotaDimDesc,String rotaOrdCode,
			String rotaOrdType,SqlRunner runner) throws SQLException {
		String rotaColTmp = "";
		if (dataList != null && dataList.size() > 0) {
			List<Map> colList = new ArrayList<Map>();
			Map firstMap = dataList.get(0);
			Iterator iter2 = (Iterator) firstMap.keySet().iterator();
			Map rowDataMap1 = new LinkedHashMap();
			rowDataMap1.put("field", getStringValue(dimCol));
			rowDataMap1.put("title", getStringValue(dimCol));
			rowDataMap1.put("formatter", "formatter_"+id+"_"+getStringValue(dimCol));
			colList.add(rowDataMap1);
			while (iter2.hasNext()) {
				String ftv = iter2.next().toString();
				if (!getStringValue(ftv).equals(rotaCol)&&!getStringValue(ftv).equals(dimCol)
						&& !getStringValue(ftv).equals(kpiCol)) {
					rowDataMap1=new LinkedHashMap();
					rowDataMap1.put("field", getStringValue(ftv));
					rowDataMap1.put("title", getStringValue(ftv));
					rowDataMap1.put("formatter", "formatter_"+id+"_"+getStringValue(ftv));
					colList.add(rowDataMap1);
				}
			}
			if(!getStringValue(rotaDimTable).equals("") && !getStringValue(rotaDimDesc).equals("") ){
				StringBuffer sql = new StringBuffer(" SELECT DISTINCT ");
				sql.append(getStringValue(rotaDimDesc));				
				if(rotaOrdCode!=null&&!"".equals(rotaOrdCode)){
					sql.append(" , "+getStringValue(rotaOrdCode));
				}
				sql.append(" FROM ").append(getStringValue(rotaDimTable));
				if(rotaOrdCode!=null&&!"".equals(rotaOrdCode)){
					sql.append(" ORDER BY " + rotaOrdCode);
				}if(rotaOrdType!=null&&!"".equals(rotaOrdType)){
					sql.append(" "+rotaOrdType);
				}
				List<Map> dimDataList = (List<Map>) runner.queryForMapList(sql.toString());
				for(Map rowMap:dimDataList){
					if (!rotaColTmp.contains(getStringValue("" + rowMap.get(getStringValue(rotaDimDesc))))) {
						rotaColTmp += getStringValue("" + rowMap.get(getStringValue(rotaDimDesc))) + ",";
						Map rowDataMap = new LinkedHashMap();
						rowDataMap.put("field", getStringValue("" + rowMap.get(getStringValue(rotaDimDesc))));
						rowDataMap.put("title", getStringValue("" + rowMap.get(getStringValue(rotaDimDesc))));
						rowDataMap.put("formatter", "formatter_"+id);
						colList.add(rowDataMap);
					}
				}
			}else{
				List<String> columnList = new ArrayList<String>();
				for (Map rowMap : dataList) {
					if (!rotaColTmp.contains(getStringValue("" + rowMap.get(rotaCol)))) {
						rotaColTmp += getStringValue("" + rowMap.get(rotaCol)) + ",";
						columnList.add(getStringValue("" + rowMap.get(rotaCol)));
					}
				}
				String[] columnArr = new String[columnList.size()];
				int num=0;
				for(String column : columnList){
					columnArr[num++]=column;
				}
				String[] columnOrder=getColumnOrder(columnArr, rotaColOrder);
				for(String column : columnOrder){
					Map rowDataMap = new LinkedHashMap();
					rowDataMap.put("field", column);
					rowDataMap.put("title", column);
					rowDataMap.put("formatter", "formatter_"+id);
					colList.add(rowDataMap);
				}
			}
			rotaColTmp = Functions.java2json(colList);
		}
		return rotaColTmp;
	}

    /**
     * 获取排序后的列(如果全是数字开头的数组，就按开头数字的大小排列，如果不是，就按字符串ASCII码值排序)
     * @param columns 列头数组,orderType：排序方式：asc、desc
     * @return String[]
     */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private static String[]  getColumnOrder(String[] columns,String orderType) {
		Pattern pattern = Pattern.compile("^\\d.*");
		Matcher matcher;
		int numStartCount=0;
		for(String str : columns) {
			  matcher = pattern.matcher(str);
			  if(matcher.matches()){
				  numStartCount++;
			  }
		}
		String result[]=new String[columns.length];
		//全是数字开头的字符串数组
		if(numStartCount==columns.length){
			Arrays.sort(columns, new Com());
			int i=0;
			for(String str : columns) {
				result[i++]=str;
			}
		}else{//有非数字开头的字符串数组
			Arrays.sort(columns);
			int i=0;
			for(String str : columns) {
				result[i++]=str;
			}
		}
		//倒序排列
		if("desc".equals(orderType)){
			String[] resultDesc = new String[result.length];
			int k = 0;
			for(int j=result.length-1;j>=0;j--){
				resultDesc[k++]=result[j];
			}
			return resultDesc;
		}else{
			return result;
		}
		
	}
	/**
	 * 获取旋转后的JSON
	 * @param dataList
	 * @param rotaCol
	 * @param dimCol
	 * @param kpiCol
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static String getFinalData(List<Map> dataList, String rotaCol,
			String dimCol, String kpiCol) {
		//获取纵向维度的Map
		Map dimColMap = new LinkedHashMap<String, String>();
		for (Map rowMap : dataList) {
			dimColMap.put(rowMap.get(dimCol), null);
		}
		Iterator it = dimColMap.keySet().iterator();
		List resultList = new ArrayList<Object>();
		String colKey;
		while (it.hasNext()) {
			String key = (String) it.next();
			Map rotaColMap = new LinkedHashMap<String, String>();
			rotaColMap.put(dimCol, key);
			for (Map rowMap : dataList) {
				if (rowMap.get(dimCol).equals(key)) {
					Iterator it2 = rowMap.keySet().iterator();
					while (it2.hasNext()){
						colKey=(String) it2.next();
						//将非指标列非旋转列非维度列的列加入到旋转列Map中
						if(!colKey.equals(rotaCol)&&!colKey.equals(dimCol)&&!colKey.equals(kpiCol))
						    rotaColMap.put( colKey, rowMap.get(colKey));
					}
					rotaColMap.put(rowMap.get(rotaCol), rowMap.get(kpiCol));
				}
			}
			resultList.add(rotaColMap);
		}
		String json = Functions.java2json(resultList);
		String resultJson = "{\"total\":" + resultList.size() + ",\"rows\":" + json + "}";
		return resultJson;
	}
 
	public static String getStringValue(String string) {
		if (string != null && !string.equals("")
				&& !string.toLowerCase().equals("undefined")
				&& !string.toLowerCase().equals("null")) {
			return string.trim();
		} else {
			return "";
		}
	}
}

/**
 * 比较器
 * @param <T>
 */
class Com<T> implements Comparator<T> {
    public int compare(T o1, T o2) {
    	
        int i = getStartNum(String.valueOf(o1));
        int j = getStartNum(String.valueOf(o2));
        if (i > j) return 1;
        if (i < j) return -1;
        return 0;
    }
    
    private int getStartNum(String str){
    	  String numstr="0123456789";
		  String temp="";
		  for(int i=0;i<str.length();i++){
			  if(numstr.indexOf(str.charAt(i))!=-1){
				  temp+=str.charAt(i);
			  }else{
				  break;
			  }
		  }
		  return Integer.parseInt(temp);
    }
}
