package cn.com.easy.ext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import cn.com.easy.core.EasyContext;

public class PageAuthFilterHelper {
	
	/**
	 * 将用户菜单和所有菜单都放到session中(应在系统登录类登录成功方法中调用此方法)
	 * @param session
	 */
	@SuppressWarnings({ "rawtypes"})
	public static void setPageAuthInfo(HttpSession session){
		Map userInfo = (Map)session.getAttribute("UserInfo");
		Map userMenuMap = getUserMenu(userInfo.get("USER_ID")+"");
		Map allMenuMap = getAllMenu();
		session.setAttribute("userMenu", userMenuMap);
		session.setAttribute("allMenu", allMenuMap);
	}
	
	/**
	 * 查询用户已授权的菜单
	 * @param userId
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private  static Map getUserMenu(String userId){
		Connection conn = null;
		PreparedStatement statement = null;
		Map resultMap = new HashMap<String,String>();
		String sql = " select m1.resources_id,url from e_menu m1 where exists "
				+ " (select 1 from  "
						+ " (select distinct menu_id from ( "
								+ " select menu_id from e_user_permission t where t.user_id=? and t.auth_read=1 "
								+ " union all "
								+ " select menu_id from e_role_permission t1 where t1.auth_read=1 and t1.role_code in (select role_code from e_user_role where user_id=?) "
							+ " ) t2 "
						+ " ) m2 where m1.resources_id=m2.menu_id)";
		try {
				conn = EasyContext.getContext().getDataSource().getConnection();
				statement = conn.prepareStatement(sql);
				statement.setString(1, userId);
				statement.setString(2, userId);
				ResultSet rs = statement.executeQuery();	
				while(rs.next()){
					resultMap.put(rs.getString("url") , rs.getString("resources_id"));
				}				
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			try {
				if(statement != null){
					statement.close();
				}
				if(conn != null){
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return resultMap;
	}
	
	/**
	 * 查询系统所有的菜单
	 * @param userId
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private static Map getAllMenu(){
		Connection conn = null;
		Statement statement = null;
		Map resultMap = new HashMap<String,String>();
		String sql = " select distinct url,resources_id from e_menu where url is not null ";
		try {
				conn = EasyContext.getContext().getDataSource().getConnection();
				statement = conn.createStatement();
				ResultSet rs = statement.executeQuery(sql);	
				while(rs.next()){
					resultMap.put(rs.getString("url") , rs.getString("resources_id"));
				}				
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			try {
				if(statement != null){
					statement.close();
				}
				if(conn != null){
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return resultMap;
	}
}
