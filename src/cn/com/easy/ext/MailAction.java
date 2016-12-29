package cn.com.easy.ext;

import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import java.util.PropertyResourceBundle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;

@Controller
public class MailAction {
	private SqlRunner runner;
	
	@SuppressWarnings("unchecked")
	@Action("sendMail")
	public void sendMail(HttpServletRequest request,HttpServletResponse response) {
		PrintWriter out = null;
		try {
			response.setHeader("Expires","-1");
			response.setHeader("Pragma","no-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/html");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			
			PropertyResourceBundle prb = (PropertyResourceBundle) PropertyResourceBundle
			.getBundle("mail");

			
			String from = prb.getString("sys_email");
			//String smtp = "smtp."+from.substring(from.indexOf("@")+1,from.length());
			String smtp = prb.getString("sys_email_smtp");
			String to = request.getParameter("to");
			String[] toArray=null;
			if(to!=null&&!to.equals("")){
				toArray=to.split(",");
			}
			String copyto = "";
			String subject = request.getParameter("subject");
			String content = request.getParameter("content");
			String username=from.substring(0,from.indexOf("@"));
			String password=prb.getString("sys_email_pwd");
		 	String filename = "";
		 	if(toArray!=null&&toArray.length>0){
		 		Mail.send(smtp, from, toArray, subject, content, username, password, filename);
				out.print("SUCCESS");
		 	}else{
		 		out.print("FAIL");
		 	}
			
		} catch (Exception e) {
			out.print("FAIL");
			e.printStackTrace();
		}
	}
}