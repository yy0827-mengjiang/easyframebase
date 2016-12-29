package cn.com.easy.frame.action;



import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;

/**
 * 角色授权
 * @author lmy
 */
@Controller
public class UserAuthorizeAction {

	SqlRunner runner;
	
	//制作更新语句的SET列
	final String[] cudeiShort = {"C","U","D","E"};	//除读取权限外的所有列
	final String[] cudeiFull = {"auth_create","auth_update","auth_delete","auth_export"};
	
	/**
	 * 1.当选中一个节点后（Checked），更新下级，在权限表里存在的
	 * 2.插入所有下级，在权限表里不存在的
	 * 3.更新上级，在权限表里存在的（如果没有则不更新，执行第四步可插入）
	 * 4.插入上级，判断在权限表里有没有，有则不插
	 * @param request
	 * @param response
	 * @param userId	角色ID
	 * @param menuId	当前选中的菜单	
	 * @param authType	权限类型：C,R,U,D,E,I	创建，读取，修改，删除，导出，下发
	 * @param checked   选中返回checked，　未选中返回null
	 * @throws SQLException 
	 * @throws Exception 
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	@Action("userTreeGridCheckNode")
	public void userTreeGridCheckNode(HttpServletRequest request, HttpServletResponse response, String userId, String menuId, String authType, String checked) throws SQLException{
		System.out.println(String.format("clickNodeCheck userId %s, menuId %s, authType %s, checked %s", userId, menuId, authType, checked));
		
		String authValue = "checked".equals(checked) ? "1":"0";
		String updateValues = genUpdate(authType, authValue);
		String insertValues = genInsert(authType, authValue);
		
		Map<String, String> parameterMap = new HashMap<String, String>();
		parameterMap.put("menuId", String.valueOf(menuId));
		parameterMap.put("userId", String.valueOf(userId));
		
		StringBuffer sqlBuff = new StringBuffer();
		
		/*插入日志准备start　*/
		int updateChildrenNum=0;//更新下级数量
		int insertChildrenNum=0;//插入所有下级数量
		int insertParentNum=0;//插入上级数量
		int updateParentNum=0;//更新上级数量
		
		String sessionUserIp=null;//当前登陆用户的ip
		String sessionUserId=null;//当前登陆用户的user_id
		String sessionAdmin=null;
		Map userInfo=(Map)request.getSession().getAttribute("UserInfo");
		sessionUserIp=String.valueOf(userInfo.get("IP"));
		sessionUserId=String.valueOf(userInfo.get("USER_ID"));
		sessionAdmin=String.valueOf(userInfo.get("ADMIN"));
		
		
		String currentMenuId="";//当前所有页面的菜单id,即用户管理的菜单id
		sqlBuff.delete(0, sqlBuff.length());
		
		String sqlMenu = this.runner.sql("frame.user.menuResource");
		
		sqlBuff.append(sqlMenu);
		
		Map currentMenuMap=runner.queryForMap(sqlBuff.toString(),parameterMap);
		if(currentMenuMap!=null){
			currentMenuId=String.valueOf(currentMenuMap.get("CURRENT_MENU_ID"));
			
		}
		
		String operateMenuId="";//赋权（操作）的菜单id
		String operateMenuName="";//赋权（操作）的菜单名称
//		sqlBuff.delete(0, sqlBuff.length());
//		sqlBuff.append("SELECT #menuId# RESOURCES_ID,REPLACE(WM_CONCAT(RESOURCES_NAME),',','>>') RESOURCES_NAME FROM (");
//		sqlBuff.append("	SELECT * FROM (");
//		sqlBuff.append("	SELECT RESOURCES_ID,RESOURCES_NAME,PARENT_ID FROM E_MENU START WITH RESOURCES_ID=#menuId# CONNECT BY RESOURCES_ID=PRIOR PARENT_ID");
//		sqlBuff.append("	) START WITH PARENT_ID=0 CONNECT BY PRIOR RESOURCES_ID=PARENT_ID");
//		sqlBuff.append(")");
//		Map operateMenuMap=runner.queryForMap(sqlBuff.toString(),parameterMap);
//		if(operateMenuMap!=null){
//			operateMenuId=String.valueOf(operateMenuMap.get("RESOURCES_ID"));
//			operateMenuName=String.valueOf(operateMenuMap.get("RESOURCES_NAME"));
//		}
		
		Map curr = runner.queryForMap("SELECT RESOURCES_NAME,RESOURCES_ID FROM E_MENU WHERE RESOURCES_ID=#menuId#",parameterMap);
		String currName = curr.get("RESOURCES_NAME")+"";
		operateMenuName = currName;
		String resourceId = curr.get("RESOURCES_ID")+"";
		while(!"0".equals(resourceId)){
			String sql = "SELECT RESOURCES_ID,RESOURCES_NAME,PARENT_ID FROM E_MENU WHERE RESOURCES_ID=(SELECT PARENT_ID FROM E_MENU WHERE RESOURCES_ID='"+resourceId+"')" ;
			Map operateMenuMap=runner.queryForMap(sql,parameterMap);
			String resourceName = operateMenuMap.get("RESOURCES_NAME")+"";
			resourceId = operateMenuMap.get("RESOURCES_ID")+"";
			if(!"0".equals(resourceId)){
				operateMenuName = resourceName+">>"+operateMenuName;
			}
		}
		operateMenuId = String.valueOf(menuId);

		
		//String operateUserId="";//赋权（操作）的用户id
		String operateLoginId="";//赋权（操作）的登陆名称
		String operateUserName="";//赋权（操作）的用户名称
		sqlBuff.delete(0, sqlBuff.length());
		sqlBuff.append("SELECT USER_ID,USER_NAME,LOGIN_ID FROM E_USER WHERE USER_ID=#userId#");
		Map operateUserMap=runner.queryForMap(sqlBuff.toString(),parameterMap);
		if(operateUserMap!=null){
			//operateUserId=String.valueOf(operateUserMap.get("USER_ID"));
			operateLoginId=String.valueOf(operateUserMap.get("LOGIN_ID"));
			operateUserName=String.valueOf(operateUserMap.get("USER_NAME"));
		}
		
		/*插入日志准备end　*/
		
		
		try {
			
			//1--更新下级，在权限表里存在的
			sqlBuff.delete(0, sqlBuff.length());
			List<String> subList = new ArrayList<String>();
			getSubIds(String.valueOf(menuId),subList);
			StringBuffer sb = new StringBuffer();
			if(subList!=null&&!subList.isEmpty()){
				sb.append('(');
				for(String s : subList){
					String tmp = "";
					tmp = "'"+s+"'";
					sb.append(tmp).append(',');
				}
				sb.deleteCharAt(sb.length()-1);
				sb.append(')');
				
				
				sqlBuff.append("update E_USER_PERMISSION ").append(updateValues) 
				.append(" where menu_id in "+sb.toString()) 
				.append(" and user_id = #userId#") ;
				if(!("1".equals(sessionAdmin))){
					sqlBuff.append(" and menu_id in(select menu_id from (select menu_id,sum(auth_read) auth_read from E_USER_PERMISSION where user_id='"+sessionUserId+"' group by menu_id ) eup where auth_read>0 union all select menu_id from (select menu_id,sum(auth_read) auth_read from e_role_permission erp where role_code in(select role_code from e_user_role where user_id='"+sessionUserId+"') group by menu_id) erp1 where auth_read>0)");
				}
				updateChildrenNum=runner.execute(sqlBuff.toString(), parameterMap);
			}
//			sqlBuff.append("update E_USER_PERMISSION ").append(updateValues) 
//					.append(" where menu_id in (select resources_id from e_menu start with resources_id = #menuId# connect by parent_id=prior resources_id)") 
//					.append(" and user_id = #userId#") ;
//			if(!("1".equals(sessionAdmin))){
//				sqlBuff.append(" and menu_id in(select menu_id from (select menu_id,sum(auth_read) auth_read from E_USER_PERMISSION where user_id='"+sessionUserId+"' group by menu_id ) where auth_read>0 union all select menu_id from (select menu_id,sum(auth_read) auth_read from e_role_permission where role_code in(select role_code from e_user_role where user_id='"+sessionUserId+"') group by menu_id) where auth_read>0)");
//			}
			
			
			sqlBuff.delete(0, sqlBuff.length());
			//2--插入所有下级，在权限表里不存在的
//			sqlBuff.append("insert into E_USER_PERMISSION(user_id,menu_id,auth_read,auth_create,auth_update,auth_delete,auth_export)") 
//					.append("select #userId#, resources_id").append(insertValues).append(" from ") 
//					.append("(select * from e_menu start with resources_id = #menuId# connect by parent_id=prior resources_id) menu_tree ") 
//					.append("where menu_tree.resources_id not in(select menu_id from (select menu_id,sum(auth_read) auth_read from E_USER_PERMISSION where user_id=#userId#  group by menu_id) where auth_read>0)") ;
//			if(!("1".equals(sessionAdmin))){
//				sqlBuff.append("and menu_tree.resources_id in(select menu_id from (select menu_id,sum(auth_read) auth_read from E_USER_PERMISSION where user_id='"+sessionUserId+"' group by menu_id ) where auth_read>0 union all select menu_id from (select menu_id,sum(auth_read) auth_read from e_role_permission where role_code in(select role_code from e_user_role where user_id='"+sessionUserId+"') group by menu_id) where auth_read>0)");
//			}
			if(subList!=null&&!subList.isEmpty()){
				sqlBuff.append("insert into E_USER_PERMISSION(user_id,menu_id,auth_read,auth_create,auth_update,auth_delete,auth_export)") 
				.append("select #userId#, resources_id").append(insertValues).append(" from ") 
				.append("(select * from e_menu where resources_id in "+sb.toString()+") menu_tree ") 
				.append("where menu_tree.resources_id not in(select menu_id from (select menu_id,sum(auth_read) auth_read from E_USER_PERMISSION where user_id=#userId#  group by menu_id) permission where permission.auth_read>0)") ;
				if(!("1".equals(sessionAdmin))){
					sqlBuff.append("and menu_tree.resources_id in(select menu_id from (select menu_id,sum(auth_read) auth_read from E_USER_PERMISSION where user_id='"+sessionUserId+"' group by menu_id ) eup where auth_read>0 union all select menu_id from (select menu_id,sum(auth_read) auth_read from e_role_permission where role_code in(select role_code from e_user_role where user_id='"+sessionUserId+"') group by menu_id) erp where auth_read>0)");
				}
				insertChildrenNum=runner.execute(sqlBuff.toString(), parameterMap);
			}
			
			
			sqlBuff.delete(0, sqlBuff.length());
			//3--插入上级，判断在权限表里有没有，有则不插
			sqlBuff.append("insert into E_USER_PERMISSION(user_id,menu_id,auth_read,auth_create,auth_update,auth_delete,auth_export)") 
					.append("select #userId#, parent_id").append(insertValues).append(" from e_menu where resources_id = #menuId# and parent_id not in") 
					.append("(select menu_id from E_USER_PERMISSION where user_id=#userId# ) ") ;
			insertParentNum=runner.execute(sqlBuff.toString(), parameterMap);
			
			if ("1".equals(authValue)){
				//4--更新上级(递归)，在权限表里存在的(只有在选中时，在不选时，不影响上级)
				sqlBuff.delete(0, sqlBuff.length());
//				sqlBuff.append("update E_USER_PERMISSION ").append(updateValues) 
//						.append(" where menu_id in (select resources_id from e_menu start with resources_id = #menuId# connect by prior parent_id=resources_id) and user_id = #userId#") ;
//				updateParentNum=runner.execute(sqlBuff.toString(), parameterMap);
				List<String> list = new ArrayList<String>();
				getParentIds(menuId,list);
				if(list!=null&&!list.isEmpty()){
					StringBuffer sql = new StringBuffer();
					sql.append('(');
					for(String s : list){
						String tmp = "";
						tmp = "'"+s+"'";
						sql.append(tmp).append(',');
					}
					sql.deleteCharAt(sql.length()-1);
					sql.append(')');
					sqlBuff.append("update E_USER_PERMISSION ").append(updateValues) 
					.append(" where menu_id in "+sql.toString()+" and user_id = #userId#") ;
					updateParentNum=runner.execute(sqlBuff.toString(), parameterMap);
				}
				
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
//			sqlBuff.delete(0, sqlBuff.length());
//			sqlBuff.append("insert into E_OPERATION_LOG(USER_ID,MENU_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES(");
//			sqlBuff.append("'"+sessionUserId+"',");
//			sqlBuff.append("'"+currentMenuId+"',");
//			sqlBuff.append("'"+("checked".equals(checked) ? "2":"4")+"',");
//			sqlBuff.append("'0',");
//			sqlBuff.append("'"+("checked".equals(checked) ? ("用户　　"+operateUserName+"("+operateLoginId+")　添加赋权菜单　"+operateMenuName+"("+operateMenuId+")"):("用户　"+operateUserName+"("+operateLoginId+")　删除赋权菜单　"+operateMenuName+"("+operateMenuId+")"))+"',");
//			sqlBuff.append("'"+sessionUserIp+"',");
//			sqlBuff.append("SYSDATE");
//			sqlBuff.append(")");
//			runner.execute(sqlBuff.toString());
//			e.printStackTrace();
		}
		
		/*插入日志*/
//		if((updateChildrenNum+insertChildrenNum+insertParentNum+updateParentNum)>0){
//			
//			sqlBuff.delete(0, sqlBuff.length());
//			sqlBuff.append("insert into E_OPERATION_LOG(USER_ID,MENU_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES(");
//			sqlBuff.append("'"+sessionUserId+"',");
//			sqlBuff.append("'"+currentMenuId+"',");
//			sqlBuff.append("'"+("checked".equals(checked) ? "2":"4")+"',");
//			sqlBuff.append("'1',");
//			sqlBuff.append("'"+("checked".equals(checked) ? ("用户　"+operateUserName+"("+operateLoginId+")　添加赋权菜单　"+operateMenuName+"("+operateMenuId+")"):("用户　"+operateUserName+"("+operateLoginId+")　删除赋权菜单　"+operateMenuName+"("+operateMenuId+")"))+"',");
//			sqlBuff.append("'"+sessionUserIp+"',");
//			sqlBuff.append("SYSDATE");
//			sqlBuff.append(")");
//			runner.execute(sqlBuff.toString());
//		}else{
//			sqlBuff.delete(0, sqlBuff.length());
//			sqlBuff.append("insert into E_OPERATION_LOG(USER_ID,MENU_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES(");
//			sqlBuff.append("'"+sessionUserId+"',");
//			sqlBuff.append("'"+currentMenuId+"',");
//			sqlBuff.append("'"+("checked".equals(checked) ? "2":"4")+"',");
//			sqlBuff.append("'0',");
//			sqlBuff.append("'"+("checked".equals(checked) ? ("用户　"+operateUserName+"("+operateLoginId+")　添加赋权菜单　"+operateMenuName+"("+operateMenuId+")"):("用户　"+operateUserName+"("+operateLoginId+")　删除赋权菜单　"+operateMenuName+"("+operateMenuId+")"))+"',");
//			sqlBuff.append("'"+sessionUserIp+"',");
//			sqlBuff.append("SYSDATE");
//			sqlBuff.append(")");
//			runner.execute(sqlBuff.toString());
//			
//		}
	}

	private void getSubIds(String menuId, List<String> subList) {
		subList.add(menuId);
		String sql = "SELECT RESOURCES_ID,RESOURCES_NAME ,PARENT_ID FROM E_MENU WHERE PARENT_ID='"+menuId+"'" ;
		List<Map>  operateMenuMapList = new ArrayList<Map>();
		try {
			operateMenuMapList = (List<Map>)runner.queryForMapList(sql);
			if(operateMenuMapList!=null&&!operateMenuMapList.isEmpty()){
				for(Map m : operateMenuMapList){
					String resourceId = m.get("RESOURCES_ID")+"";
					getSubIds(resourceId,  subList) ;
				}
			} 
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}
	private void getParentIds(String menuId,List<String> list) {
			
			list.add(menuId);
			String sql = "SELECT RESOURCES_ID,RESOURCES_NAME,PARENT_ID FROM E_MENU WHERE RESOURCES_ID=(SELECT PARENT_ID FROM E_MENU WHERE RESOURCES_ID='"+menuId+"')" ;
			Map operateMenuMap;
			try {
				operateMenuMap = runner.queryForMap(sql);
				if(operateMenuMap == null){
					return;
				}
				String resourceId = operateMenuMap.get("RESOURCES_ID")+"";
				
				
				getParentIds(resourceId,list);
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
		
		
	}
	/**
	 * 生成更新语句
	 * @param authType
	 * @param authValue
	 * @return
	 */
	private String genUpdate(String authType, String authValue) {
		StringBuffer updateValuesBuff = new StringBuffer();
		if ("1".equals(authValue)){
			//如果是check状态，无论操作哪列，都会影响读取权限，将设置首列读取权限，
			updateValuesBuff.append("set auth_read=").append(authValue);	
			for(int i=0;i<cudeiShort.length;i++){
				//如果不是读取，则加入其它权限
				if (cudeiShort[i].equals(authType)){
					updateValuesBuff.append(",").append(cudeiFull[i]).append("=").append(authValue);
					break;
				}
			}
			
		}else{
			//如果是uncheck状态，无论操作哪列，不会影响读取权限，但操作读取，则影响所有列
			if ("R".equals(authType)){
				//如果读取，则设置读取和其它所有列
				updateValuesBuff.append("set auth_read=").append(authValue);
				for(int i=0;i<cudeiShort.length;i++){
					//修改所有其它权限
					updateValuesBuff.append(",").append(cudeiFull[i]).append("=").append(authValue);
				}
			}else{
				//非读取，只设置其它相关的列
				updateValuesBuff.append("set ");
				for(int i=0;i<cudeiShort.length;i++){
					//如果不是读取，则加入其它权限
					if (cudeiShort[i].equals(authType)){
						updateValuesBuff.append(cudeiFull[i]).append("=").append(authValue);
						break;
					}
				}
			}
		}
		return updateValuesBuff.toString();
	}
	
	/**
	 * 生成Inser语句
	 * @param authType
	 * @param authValue
	 * @return
	 */
	private String genInsert(String authType, String authValue) {
		StringBuffer insertValuesBuff = new StringBuffer();
		insertValuesBuff.append(",").append(authValue);	//首列为读取权限，无论操作哪列，都会影响读取权限
		for(int i=0;i<cudeiShort.length;i++){
			//如果不是读取，则加入其它权限
			if (cudeiShort[i].equals(authType)){
				insertValuesBuff.append(",").append(authValue);
			}else{
				insertValuesBuff.append(",0");	//增加时，其他权限默认为0，即无操作权限
			}
		}
		return insertValuesBuff.toString();
	}
}
