package cn.com.easy.ext;

import java.io.IOException;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.util.InvokeUtil;

@Controller
public class SsoLogin {
	private SqlRunner sqlRunner;
	private AbstractLogin abstractLogin;

	@Action("ssLogin")
	public String login(HttpServletRequest request, HttpServletResponse response,
			String user, String pwd,String url) {
		String loginClassName=(String) request.getSession().getServletContext().getAttribute("CustomLoginClass");
		String is_encrypt = (String) request.getSession().getServletContext().getAttribute("PwdEncrypt");
		try {
			response.setContentType("text/html");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			//是否重写登录方法
			if(loginClassName==null || loginClassName.equals("")){
				abstractLogin = LoginFactory.getLogin("cn.com.easy.ext.DefaultLogin");
			}else{
				abstractLogin = LoginFactory.getLogin(loginClassName);
			}

			//是否使用加密
			if(is_encrypt.equals("0")){
				//登录
				Map user_info = abstractLogin.login(user, pwd, sqlRunner);
				if(user_info != null){
					abstractLogin.setUser(user_info, request,sqlRunner);
					System.out.print("ssLogin.e return SUCCESS");
					return url;
				}else{
					System.out.print("ssLogin.e return FAIL:用户或密码错误");
					return "/index.jsp";
				}
			}else{
				String pwdSql = "select * from e_user where login_id=#loginId#";
				Map userLoginMap = new HashMap();
				userLoginMap.put("loginId", user);
				Map userMap = sqlRunner.queryForMap(pwdSql, userLoginMap);
				String pwdString = (String) userMap.get("password");
				String MD5Pwd=MD5.MD5Crypt(pwdString);
				//密码是否一致
				if(MD5Pwd.equals(pwd)){
				 	abstractLogin.setUser(userMap, request,sqlRunner);
				 	System.out.print("ssLogin.e return SUCCESS");
				 	return url;
				}else{
					System.out.print("ssLogin.e return FAIL:用户或密码错误");
					return "/index.jsp";
				}
			}
		} catch(Exception e){
			System.out.print("ssLogin.e return FAIL："+e.getMessage());
			e.printStackTrace();
			return "/index.jsp";
		}
	}
	
	@Action("ssoAuth")
	public void ssoAuth(HttpServletRequest request, HttpServletResponse response,
			String user, String pwd,String encrypt) {
		String loginClassName=(String) request.getSession().getServletContext().getAttribute("CustomLoginClass");
		try {
			response.setContentType("text/html");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			//是否重写登录方法
			if(loginClassName==null || loginClassName.equals("")){
				abstractLogin = LoginFactory.getLogin("cn.com.easy.ext.DefaultLogin");
			}else{
				abstractLogin = LoginFactory.getLogin(loginClassName);
			}

			//是否使用加密
			if(encrypt.equals("0")){
				//登录
				Map user_info = abstractLogin.login(user, pwd, sqlRunner);
				if(user_info != null){
					abstractLogin.setUser(user_info, request,sqlRunner);
					System.out.print("ssLogin.e return SUCCESS");
					String key = UUID.randomUUID().toString().replaceAll("-", "");
					user_info.put("AuthTime", System.currentTimeMillis());
					TicketStore.ticket.put(key,user_info);
					response.getWriter().println(key);
					this.deleTimeOut();
				}else{
					System.out.print("ssLogin.e return FAIL:用户或密码错误");
					response.getWriter().println("fail");
					this.deleTimeOut();
				}
			}else{
				String pwdSql = "select * from e_user where login_id=#loginId#";
				Map userLoginMap = new HashMap();
				userLoginMap.put("loginId", user);
				Map userMap = sqlRunner.queryForMap(pwdSql, userLoginMap);
				String pwdString = (String) userMap.get("password");
				String MD5Pwd=MD5.MD5Crypt(pwdString);
				//密码是否一致
				if(MD5Pwd.equals(pwd)){
				 	abstractLogin.setUser(userMap, request,sqlRunner);
				 	System.out.print("ssLogin.e return SUCCESS");
				 	String key = UUID.randomUUID().toString().replaceAll("-", "");
				 	userMap.put("AuthTime", System.currentTimeMillis());
					TicketStore.ticket.put(key,userMap);
				 	response.getWriter().println(key);
				 	this.deleTimeOut();
				}else{
					System.out.print("ssLogin.e return FAIL:用户或密码错误");
					response.getWriter().println("fail");
					this.deleTimeOut();
				}
			}
		} catch(Exception e){
			System.out.print("ssLogin.e return FAIL："+e.getMessage());
			e.printStackTrace();
			try {
				response.getWriter().println("fail");
				this.deleTimeOut();
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}
	
	@Action("ssoVisit")
	public String ssoVisit(HttpServletRequest request, HttpServletResponse response,String key,String url) {
		if(TicketStore.ticket.containsKey(key)){
			TicketStore.ticket.get(key).put("AuthTime", System.currentTimeMillis());
			request.getSession().setAttribute("UserInfo", TicketStore.ticket.get(key));
			return url;
		}else{
			return "/index.jsp";
		}
	}
	
	private void deleTimeOut(){
		for(String item : TicketStore.ticket.keySet()){
			//删除超过10小时的记录
			long time1 = Long.parseLong(String.valueOf(TicketStore.ticket.get(item).get("AuthTime")));
			if(time1-System.currentTimeMillis()>=1000*60*60*10){
				TicketStore.ticket.remove(item);
			}
		}
	}
	
	@Action("portalAuth")
	public void portalAuth(HttpServletRequest request, HttpServletResponse response,String user,String token) {
		try {
			response.setContentType("text/html");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");

			InetAddress addr = InetAddress.getLocalHost();
			String ip = addr.getHostAddress();
			if(!token.equals(MD5.MD5Crypt(ip))){
				response.getWriter().println("fail");
			}
			
			DefaultLogin dLogin = new DefaultLogin();
			Map user_info = dLogin.PortalLogin(user, sqlRunner);
			if(user_info != null){
				String key = dLogin.setUser(user_info, request,sqlRunner);
				
				//String key = UUID.randomUUID().toString().replaceAll("-", "");
				user_info.put("AuthTime", System.currentTimeMillis());
				
				TicketStore.ticket.put(key,user_info);
				
				Cookie cookie = new Cookie("key",key);
				cookie.setMaxAge(60*60*24);
				response.addCookie(cookie);
			    Cookie[] cookies = request.getCookies();
			    if(cookies != null){
			        for(Cookie cookie1 : cookies){
			        	if(cookie1.getName().toLowerCase().equals("key")){
			        		System.out.println(">>>>>===SsoLogin.java 设置的cookies值为，key="+cookie1.getValue());
			        		break;
			        	}
			        }
			    }
				response.getWriter().println(key);
				this.deleTimeOut();
			}else{
				response.getWriter().println("fail");
				this.deleTimeOut();
			}
		} catch(Exception e){
			e.printStackTrace();
			try {
				response.getWriter().println("fail");
				this.deleTimeOut();
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}
	
	@Action("portalVisit")
	public String portalVisit(HttpServletRequest request, HttpServletResponse response,String key,String url) {
		if(TicketStore.ticket.containsKey(key)){
			TicketStore.ticket.get(key).put("AuthTime", System.currentTimeMillis());
			request.getSession().setAttribute("UserInfo", TicketStore.ticket.get(key));
			return url;
		}else{
			try {
				HttpSession session = request.getSession();
				String purl = (String)session.getServletContext().getAttribute("PortalSso");
				String code = InvokeUtil.invokeStr(purl+"?jsid="+key);
				if(!code.equals("success")){
					System.out.println("子系统掉线，调用门户接口地址："+purl+"?jsid="+key+"，失败！！！");
				}
				String furl = (String)session.getServletContext().getAttribute("PortalLogin");
				response.sendRedirect(furl);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}