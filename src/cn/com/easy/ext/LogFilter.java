package cn.com.easy.ext;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;

public class LogFilter implements Filter {
	
	@SuppressWarnings("unchecked")
	public void doFilter(ServletRequest arg0, ServletResponse arg1,
			FilterChain arg2) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) arg0;
		String url = request.getRequestURI();
		String appName = request.getContextPath();
		if (request.getSession().getAttribute("UserInfo") == null) {
			arg2.doFilter(arg0, arg1);
			return;
		}
		String userId = String.valueOf(((Map) request.getSession().getAttribute("UserInfo")).get("USER_ID"));
		String userIp = (String) ((Map) request.getSession().getAttribute(
				"UserInfo")).get("IP");
		Statement stmt = null;
		Statement stmt1 = null;
		ResultSet rs = null;
		Connection conn = null;
		SqlRunner runner = new SqlRunner();
		try {
			// if(conn==null||conn.isClosed()){
			conn = EasyContext.getContext().getDataSource().getConnection();
			// }
			stmt = conn.createStatement();
			stmt1 = conn.createStatement();
			rs = stmt.executeQuery("SELECT RESOURCES_ID,RESOURCES_NAME  FROM E_MENU T WHERE '"
							+ appName + "/'||T.URL='" + url + "'");
			if (rs.next()) {
				
				String sql = runner.sql("frame.log.insOperationLog");
				
				Map<String,String> parMap = new HashMap<String,String>(); 
				parMap.put("uid", userId);
				parMap.put("menuid", rs.getString("RESOURCES_ID"));
				parMap.put("operate_type_code", "1");
				parMap.put("operate_result", "1");
				parMap.put("content", "查询"+rs.getString("RESOURCES_NAME"));
				parMap.put("client_ip", userIp);
				
				runner.execute(sql, parMap);
//					stmt1.execute("insert into E_OPERATION_LOG"
//							+ "(USER_ID,MENU_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES("
//							+ "'"+ userId+ "','"+ rs.getString("RESOURCES_ID")+ "','1','1','查询"+ rs.getString("RESOURCES_NAME")
//								+ "','"
//								+ userIp + "',sysdate)");
			}

		} catch (SQLException e) {
			System.err.println("过滤器ogFilterִ的doFilter方法出错!");
			e.printStackTrace();
		} finally {
			try {
				stmt1.close();
				stmt.close();
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
		arg2.doFilter(arg0, arg1);
	}

	public void init(FilterConfig arg0) throws ServletException {
	}

	public void destroy() {
	}
}
