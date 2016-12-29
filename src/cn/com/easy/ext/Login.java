package cn.com.easy.ext;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;

@Controller
public class Login {
	private SqlRunner runner;
	@Action("login")
	public String login(String user,String pwd,String validNum,HttpServletRequest request,HttpServletResponse response) {
		String is_encrypt = (String)request.getSession().getServletContext().getAttribute("PwdEncrypt");
		String forward = "Frame.jsp";
		AbstractLogin absLogin = null;
		String rCode = String.valueOf(request.getSession().getAttribute("rCode"));
		if(validNum==null||(validNum!=null&&validNum.length()==0)){
			request.setAttribute("loginName", user);
			request.setAttribute("loginPwd", pwd);
			request.setAttribute("LoginMsg_code","请输入验证码！");
			return "/index.jsp";
		}if(!validNum.equals(rCode)){
			request.setAttribute("loginName", user);
			request.setAttribute("loginPwd", pwd);
			request.setAttribute("LoginMsg_code","验证码不正确！");
			return "/index.jsp";
		}
		try {
			absLogin = instance(request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(is_encrypt.equals("1")){
			pwd=MD5.MD5Crypt(pwd);
		}
		Map user_info = absLogin.login(user,pwd,runner);
		if(user_info != null){
			absLogin.setUser(user_info,request,runner);
			try {
				response.sendRedirect("pages/frame/"+forward);
			} catch (IOException e) {
				e.printStackTrace();
				return "pages/frame/"+forward;
			}
			return null;
		}else{
			request.setAttribute("LoginMsg_user","用户名或密码错误");
			return "/index.jsp";
		}

	}
	
	@Action("logout")
	public void logout(HttpServletRequest request,HttpServletResponse response) {
		try{
			instance(request).logout(request,runner);
			response.sendRedirect("index.jsp");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	@Action("logoutForReturn")
	public void logoutForReturn(HttpServletRequest request,HttpServletResponse response) {
		try{
			instance(request).logout(request,runner);
			response.getWriter().write("1");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private static AbstractLogin instance(HttpServletRequest request) throws InstantiationException, IllegalAccessException, ClassNotFoundException {
		AbstractLogin absLogin = null;
		String login_class = (String)request.getSession().getServletContext().getAttribute("CustomLoginClass");
		if(login_class == null || login_class.equals("")){
			absLogin = LoginFactory.getLogin("cn.com.easy.ext.DefaultLogin");
		}else{
			absLogin = LoginFactory.getLogin(login_class);
		}
		return absLogin;
	}
	
	@Action("loginUserFrozen")
	public String frozenUser(HttpServletRequest request) {
		System.out.println("userName"+request.getParameter("userName"));
		String userName=request.getParameter("userName");
		try {
			runner.execute("update e_user t set t.state='2' where t.login_id=?", userName);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
}