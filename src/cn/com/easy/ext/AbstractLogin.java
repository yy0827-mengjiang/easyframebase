package cn.com.easy.ext;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;

public abstract class AbstractLogin {
	public  Map login(String user,String pwd,SqlRunner runner){
		return null;
	};
	public String setUser(Map user_info,HttpServletRequest request,SqlRunner runner) {
		//System.out.println(request.getHeader("user-agent"));
		String sessionId=request.getSession(true).getId();
		try {
			int i=0;
			if(user_info!=null){
				String DBSource=(String) request.getSession().getServletContext().getAttribute("DBSource");
				
				String sql = runner.sql("frame.log.insLoginLog");
				
				Map<String,String> parMap = new HashMap<String,String>(); 
				parMap.put("sessionId", sessionId);
				parMap.put("state", "0");
				parMap.put("user_id", String.valueOf(user_info.get("USER_ID")));
				parMap.put("ip", this.getIp(request));
				parMap.put("logout_date", "");
				parMap.put("useragent", request.getHeader("user-agent"));
				
				i = runner.execute(sql, parMap);
				
//				i=runner.execute("INSERT INTO E_LOGIN_LOG(SESSION_ID,STATE,USER_ID,CLIENT_IP,LOGIN_DATE,LOGOUT_DATE,CLIENT_BROWSOR) "
//						+ "VALUES('"+sessionId+"','0','"+user_info.get("USER_ID")+"','"+this.getIp(request)+"',sysdate,NULL,'"+request.getHeader("user-agent")+"')");
//				user_info.put("SESSION_ID", sessionId);
			}
			if(i==0){
				System.err.println("插入登陆日志失败");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.err.println("插入登陆日志抛出异常");
			e.printStackTrace();
		}
		user_info.put("IP", this.getIp(request));
		user_info.put("userReqIp", this.getIp(request));
		HttpSession session = request.getSession();
		session.setAttribute("UserInfo",user_info);
		session.setAttribute("userReqIp", request.getLocalAddr());
		Set<String> keys = user_info.keySet();
		for (Iterator it = keys.iterator(); it.hasNext();) {
			String key = (String) it.next();
			session.setAttribute(key, user_info.get(key));
		}
		PageAuthFilterHelper.setPageAuthInfo(session);//将用户菜单和所有菜单放到session中，过滤器中根据这个进行页面权限过滤
		return sessionId;
	}
	
	public String setUser(Map user_info,HttpServletRequest request) {
		Connection conn = null;
		Statement stat = null;
		String sessionId=request.getSession(true).getId();
		try {
			int i=0;
			if(user_info!=null){
				String DBSource=(String) request.getSession().getServletContext().getAttribute("DBSource");	
				
				SqlRunner runnersql = new SqlRunner();
				String sql = runnersql.sql("frame.log.insLoginLog");
				
				Map<String,String> parMap = new HashMap<String,String>(); 
				parMap.put("sessionId", sessionId);
				parMap.put("state", "0");
				parMap.put("user_id", String.valueOf(user_info.get("USER_ID")));
				parMap.put("ip", this.getIp(request));
				parMap.put("logout_date", "");
				parMap.put("useragent", request.getHeader("user-agent"));
				
				i = runnersql.execute(sql, parMap);
				
//				i=stat.executeUpdate("INSERT INTO E_LOGIN_LOG(SESSION_ID,STATE,USER_ID,CLIENT_IP,LOGIN_DATE,LOGOUT_DATE,CLIENT_BROWSOR) VALUES"
//						+ "('"+sessionId+"','0','"+user_info.get("USER_ID")+"','"+this.getIp(request)+"',sysdate,NULL,'"+request.getHeader("user-agent")+"')");
				user_info.put("SESSION_ID", sessionId);
			}
			if(i==0){
				System.err.println("插入登陆日志失败");
			}
		} catch (SQLException e) {
			System.err.println("插入登陆日志抛出异常");
			e.printStackTrace();
		}
		try {
			if(stat != null){
				stat.close();
			}
			if(conn != null){
				conn.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		user_info.put("IP", this.getIp(request));
		HttpSession session = request.getSession();
		session.setAttribute("UserInfo",user_info);
		Set<String> keys = user_info.keySet();
		for (Iterator it = keys.iterator(); it.hasNext();) {
			String key = (String) it.next();
			session.setAttribute(key, user_info.get(key));
		}
		return sessionId;
	}
	public void logout(HttpServletRequest request,SqlRunner runner) {
		HttpSession session = request.getSession();
		Map userInfo=null;
		if(session.getAttribute("UserInfo")!=null){
			int i=0;
			userInfo=(Map) session.getAttribute("UserInfo");
			if(userInfo!=null){
				try {
					String DBSource=(String) request.getSession().getServletContext().getAttribute("DBSource");		
					
					String sql = runner.sql("frame.log.updLoginLog");
					
					Map<String,String> parMap = new HashMap<String,String>(); 
					parMap.put("sessionId", String.valueOf(userInfo.get("SESSION_ID")));
					parMap.put("state", "1");
					parMap.put("user_id", String.valueOf(userInfo.get("USER_ID")));
					
					i = runner.execute(sql, parMap);
//					i=runner.execute("UPDATE E_LOGIN_LOG T "
//							+ "SET T.LOGOUT_DATE=SYSDATE,T.STATE='1' "
//							+ "WHERE T.SESSION_ID='"+userInfo.get("SESSION_ID")+"' "
//									+ "AND T.USER_ID='"+userInfo.get("USER_ID")+"'");
				} catch (SQLException e) {
					System.err.println("更新登陆日志抛出异常");
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			session.removeAttribute("UserInfo");
			
		}
		session.invalidate();
	}
	private static String getIp(HttpServletRequest request) {
		String ip = request.getHeader("x-forwarded-for");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		ip = ip.equals("0:0:0:0:0:0:0:1")?"127.0.0.1":ip;
		return ip;
	}
}