package cn.com.easy.ext;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;

@Controller
public class FrameAction {
	private SqlRunner runner;
	@Action("updPwd")
	public void updPwd(String pwd_old,String pwd_new,String pwd_new_a,HttpServletRequest request,HttpServletResponse response) {
		String is_encrypt = (String)request.getSession().getServletContext().getAttribute("PwdEncrypt");
		String pwd_old_sql = "select * from e_user where loginId=#LOGIN_ID#";
		String pwd_new_sql = "update e_user set password=#PASSWORD#,UPDATE_DATE=SYSDATE where login_id=#LOGIN_ID#";
		PrintWriter out = null;
		//判断是否加密
		if(is_encrypt.equals("1")){
			pwd_old = MD5.MD5Crypt(pwd_old);
			pwd_new = MD5.MD5Crypt(pwd_new);
			pwd_new_a = MD5.MD5Crypt(pwd_new_a);
		} else if(is_encrypt.equals("2")){
			pwd_old = MD5.byte2hex(pwd_old.getBytes());
			pwd_new = MD5.byte2hex(pwd_new.getBytes());
			pwd_new_a = MD5.byte2hex(pwd_new_a.getBytes());
		}
		
		try {
			response.setHeader("Expires","-1");
			response.setHeader("Pragma","no-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/html");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			//判断两次密码是否相同
			if(!pwd_new.equals(pwd_new_a)){
				out.print("NOTEQ");
			}else{
				//从session中取出当前用户信息
				Map loginMap = (Map) request.getSession().getAttribute("UserInfo");
				//用户旧密码是否正确
				if(!pwd_old.equals(loginMap.get("PASSWORD"))){
					out.print("NOTOLD");
				}else{
					loginMap.remove("PASSWORD");
					loginMap.put("PASSWORD", pwd_new);
					int res = runner.execute(pwd_new_sql, loginMap);
					if(res>0){
						out.print("SUCCESS");
					}else{
						out.print("FAIL");
					}
				}
			}
			
		} catch (Exception e) {
			out.print("FAIL");
			e.printStackTrace();
		}finally{
			if(out != null){
				out.flush();
				out.close();
			}
		}
	}
	
	@Action("onlineuser")
	public void onlineUser(HttpServletRequest request,HttpServletResponse response){
		try {
			response.setHeader("Expires","-1");
			response.setHeader("Pragma","no-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/html");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().print(FrameVariable.onlineUsers.size());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Action("newPwd")
	public void newPwd(String user_id,HttpServletRequest request,HttpServletResponse response) {
		//密码初始化方法
		String is_encrypt = (String)request.getSession().getServletContext().getAttribute("PwdEncrypt");
		String pwd_new_sql = "update e_user set password=#PASSWORD#, update_date=sysdate-100 where user_id=#USER_ID#";
		PrintWriter out = null;
		
		String newPwd = (String)EasyContext.getContext().get("initialPwd");
		String newPwdMd5 = "";	//加密后的密码
		//判断是否加密
		if(is_encrypt.equals("1")){
			newPwdMd5 = MD5.MD5Crypt(newPwd);
		} else if(is_encrypt.equals("2")){
			newPwdMd5 = MD5.byte2hex(newPwd.getBytes());
		} else if(is_encrypt.equals("0")){
			newPwdMd5 = newPwd;
		}
		
		try {
			response.setHeader("Expires","-1");
			response.setHeader("Pragma","no-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/html");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			
			Map m = new HashMap();
			
			m.put("USER_ID", user_id);
			m.put("PASSWORD", newPwdMd5);
			int res = runner.execute(pwd_new_sql, m);
			if(res>0){
				out.print("SUCCESS");
			}else{
				out.print("FAIL");
			}
			
		} catch (Exception e) {
			out.print("FAIL");
			e.printStackTrace();
		}finally{
			if(out != null){
				out.flush();
				out.close();
			}
		}
		
	}
}