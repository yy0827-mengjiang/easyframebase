package cn.com.easy.ext;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;

@Controller
public class Examples {
	private SqlRunner runner;
	@Action("examples")
	public void login(String name,String password,HttpServletRequest request,HttpServletResponse response) {
/*		System.out.println("name="+name);
		System.out.println("password="+password);
		request.setAttribute("Message", name+","+password);
		request.getSession().setAttribute("Message", name+","+password);
		try {
			Map test = runner.queryForMap("select 'OK' key from dual where '1'=?", "1");
			System.out.println(test.get("KEY"));
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return "/examples/action.jsp";*/
		Map user = (Map)request.getSession().getAttribute("UserInfo");
		Object o = user.get("AREA_NO");
	}
}