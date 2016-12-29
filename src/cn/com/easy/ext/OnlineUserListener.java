package cn.com.easy.ext;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import cn.com.easy.core.EasyContext;

/**
 * @author 版本
 */
public class OnlineUserListener implements HttpSessionListener,HttpSessionAttributeListener {
	private ApplicationContext ac=new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
	public void sessionDestroyed(HttpSessionEvent event) {
		String DBSource=(String) event.getSession().getServletContext().getAttribute("DBSource");		
		//System.out.println("OnlineUserListener DBSource----"+DBSource);
		String sid = event.getSession().getId(); 
		if(FrameVariable.onlineUsers.contains(sid)){
			FrameVariable.onlineUsers.remove(sid);
			Connection conn=null;
			Statement stmt=null;			
			//String DBSource=(String) event.getSession().getServletContext().getAttribute("DBSource");
			try {
				conn=EasyContext.getContext().getDataSource().getConnection();
				stmt=conn.createStatement();
				if("mysql".equals(DBSource)){
					stmt.execute("UPDATE E_LOGIN_LOG T SET T.LOGOUT_DATE=now() WHERE T.SESSION_ID='"+sid+"'");
				}else if("oracle".equals(DBSource)){
					stmt.execute("UPDATE E_LOGIN_LOG T SET T.LOGOUT_DATE=SYSDATE WHERE T.SESSION_ID='"+sid+"'");
				}else if("db2".equals(DBSource)){
					stmt.execute("UPDATE E_LOGIN_LOG T SET T.LOGOUT_DATE=CURRENT DATE WHERE T.SESSION_ID='"+sid+"'");
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				
				try {					
					stmt.close();
					if(conn!=null&&!conn.isClosed()){
						conn.close();
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			System.out.println("删除在线用户,session_id:" +sid);
		}
	}
    public void attributeAdded(HttpSessionBindingEvent se) { 
		String attr = se.getName();
		String sid = se.getSession().getId();
		if(attr.equals("UserInfo")){
			if(!FrameVariable.onlineUsers.contains(sid)){
				FrameVariable.onlineUsers.add(sid);
				System.out.println("添加在线用户,session_id:" +sid);
			}
		}
    }
    public void attributeRemoved(HttpSessionBindingEvent se) {
    	String attr = se.getName();
		String sid = se.getSession().getId();
		if(attr.equals("UserInfo")){
			if(FrameVariable.onlineUsers.contains(sid)){
				FrameVariable.onlineUsers.remove(sid);
				System.out.println("删除在线用户,session_id:" +sid);
			}
		}
    }
	public void sessionCreated(HttpSessionEvent arg0) {
		// TODO Auto-generated method stub
		
	}
	public void attributeReplaced(HttpSessionBindingEvent arg0) {
		// TODO Auto-generated method stub
		
	}  
}