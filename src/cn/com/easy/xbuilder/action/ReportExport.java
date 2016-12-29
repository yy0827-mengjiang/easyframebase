package cn.com.easy.xbuilder.action;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.xbuilder.utils.ZipUtil;

@Controller
public class ReportExport {
	
	@Action("reportExport/zip")
	public void zip(HttpServletResponse response,HttpServletRequest request,String rname,String rpath){
		try {
			rname = java.net.URLDecoder.decode(rname,"utf-8");
			rname = new String(rname.getBytes(),"iso-8859-1");
			response.setContentType("application/octet-stream");  
			response.setHeader("Content-Disposition","attachment;filename=\""+rname+".zip"+"\"");   
			OutputStream os = response.getOutputStream();
			String dir = request.getSession().getServletContext().getRealPath("/").replaceAll("\\\\", "/");
			rpath = dir + rpath.substring(0,rpath.lastIndexOf("/"));
			
			ZipUtil.compress(os, rpath);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	@Action("reportExport/exists")
	public void exists(HttpServletResponse response,HttpServletRequest request,String rname,String rpath){
		try {
			String dir = request.getSession().getServletContext().getRealPath("/").replaceAll("\\\\", "/");
			rpath = dir + rpath.substring(0,rpath.lastIndexOf("/"));
			File file = new File(rpath);
			if(file.exists()){
				response.getWriter().write("1");
			}else{
				response.getWriter().write("0");
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
	@Action("reportExport/downloadFile")
	public void downloadFile(HttpServletResponse response,HttpServletRequest request,String rname,String rpath){
		try {
			rname = new String(rname.getBytes("ISO8859-1"), "UTF-8");
			String fileName = URLEncoder.encode(rname,"utf-8"); 
			response.setContentType("application/octet-stream");  
			response.setHeader("Content-Disposition","attachment;filename=\""+fileName+"\"");
			OutputStream os = response.getOutputStream();
			String dir = request.getSession().getServletContext().getRealPath("/").replaceAll("\\\\", "/");
			rpath = dir + rpath.substring(1,rpath.length());
			File file = new File(rpath);
			BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file));
			int count = 0;  
            byte data[] = new byte[2048];  
            while ((count = bis.read(data, 0, 2048)) != -1) {  
                os.write(data, 0, count);  
            }  
            bis.close();  
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
