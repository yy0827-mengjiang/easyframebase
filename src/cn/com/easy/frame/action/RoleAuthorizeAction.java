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
import cn.com.easy.web.taglib.function.Functions;

/**
 * 角色授权
 * @author lmy
 */
@Controller
public class RoleAuthorizeAction {

	SqlRunner runner;
	
	//制作更新语句的SET列
	final String[] cudeiShort = {"C","U","D","E","I"};	//除读取权限外的所有列
	final String[] cudeiFull = {"auth_create","auth_update","auth_delete","auth_export","auth_issued"};
	
	/**
	 * 1.当选中一个节点后（Checked），更新下级，在权限表里存在的
	 * 2.插入所有下级，在权限表里不存在的
	 * 3.更新上级，在权限表里存在的（如果没有则不更新，执行第四步可插入）
	 * 4.插入上级，判断在权限表里有没有，有则不插
	 * @param request
	 * @param response
	 * @param roleId	角色ID
	 * @param menuId	当前选中的菜单	
	 * @param authType	权限类型：C,R,U,D,E,I	创建，读取，修改，删除，导出，下发
	 * @param checked   选中返回checked，　未选中返回null
	 * @throws Exception 
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	@Action("role/roleTreeGridCheckNode")
	public void treeGridCheckNode(HttpServletRequest request, HttpServletResponse response, String roleId, String menuId, String authType, String checked) throws Exception{
		System.out.println(String.format("clickNodeCheck roleId %s, menuId %s, authType %s, checked %s", roleId, menuId, authType, checked));
		
		String authValue = "checked".equals(checked) ? "1":"0";
		String updateValues = genUpdate(authType, authValue);
		String insertValues = genInsert(authType, authValue);
		StringBuffer sqlBuff = new StringBuffer();
		
		Map<String, String> parameterMap = new HashMap<String, String>();
		parameterMap.put("menuId", String.valueOf(menuId));
		parameterMap.put("roleId", String.valueOf(roleId));
		
		
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
		sqlBuff.append("SELECT RESOURCES_ID CURRENT_MENU_ID FROM E_MENU T WHERE T.URL='pages/frame/portal/role/RoleManager.jsp'");
		List emenuList = runner.queryForMapList(sqlBuff.toString(),parameterMap);
		Map currentMenuMap=null;
		if(emenuList!=null&&emenuList.size()>0){
			currentMenuMap = (Map)emenuList.get(0);
		}
		if(currentMenuMap!=null){
			currentMenuId=String.valueOf(currentMenuMap.get("CURRENT_MENU_ID"));
		}
		
		String operateMenuId="";//赋权（操作）的菜单id
		String operateMenuName="";//赋权（操作）的菜单名称
		sqlBuff.delete(0, sqlBuff.length());
		
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
		
		
		
		String operateRoleId="";//赋权（操作）的角色id
		String operateRoleName="";//赋权（操作）的角色名称
		sqlBuff.delete(0, sqlBuff.length());
		sqlBuff.append("SELECT ROLE_CODE,ROLE_NAME FROM E_ROLE WHERE ROLE_CODE=#roleId#");
		Map operateRoleMap=runner.queryForMap(sqlBuff.toString(),parameterMap);
		if(operateRoleMap!=null){
			operateRoleId=String.valueOf(operateRoleMap.get("ROLE_CODE"));
			operateRoleName=String.valueOf(operateRoleMap.get("ROLE_NAME"));
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
					sb.append("'"+s+"',");
				}
				sb.deleteCharAt(sb.length()-1);
				sb.append(')');
				sqlBuff.append("update E_ROLE_PERMISSION ").append(updateValues) 
				.append(" where menu_id in "+sb.toString()) 
				.append(" and role_code = #roleId#") ;
				if(!("1".equals(sessionAdmin))){
					sqlBuff.append("and menu_id in(select menu_id from (select menu_id,sum(auth_read) auth_read from E_USER_PERMISSION where user_id='"+sessionUserId+"' group by menu_id ) ll where auth_read>0 union all select menu_id from (select menu_id,sum(auth_read) auth_read from e_role_permission where role_code in(select role_code from e_user_role where user_id='"+sessionUserId+"') group by menu_id) ee where auth_read>0)");
				}
				updateChildrenNum=runner.execute(sqlBuff.toString(), parameterMap);
			}
			
			//2--插入所有下级，在权限表里不存在的
			sqlBuff.delete(0, sqlBuff.length());
			if(subList!=null&&!subList.isEmpty()){
				sqlBuff.append("insert into E_ROLE_PERMISSION(role_code,menu_id,auth_read,auth_create,auth_update,auth_delete,auth_export,auth_issued)") 
				.append("select #roleId#, resources_id").append(insertValues).append(" from ") 
				.append("(select * from e_menu where resources_id in "+sb.toString()+") menu_tree ")
				//判断是否已存在记录，这里不需要像注释内容那样卡读权限大于0
				.append("where menu_tree.resources_id not in(select menu_id from (select menu_id,sum(auth_read) auth_read from E_ROLE_PERMISSION where role_code=#roleId# group by menu_id) permission )") ;
				if(!("1".equals(sessionAdmin))){
					//判断当前登录用户对授权的菜单是否有读权限，如果有则可以进行授权，如果没有，则不进行授权
					sqlBuff.append(" and menu_tree.resources_id in(select menu_id from (select menu_id,sum(auth_read) auth_read from E_USER_PERMISSION where user_id='"+sessionUserId+"' group by menu_id ) rr where auth_read>0 union all select menu_id from (select menu_id,sum(auth_read) auth_read from e_role_permission where role_code in(select role_code from e_user_role where user_id='"+sessionUserId+"') group by menu_id) ee where auth_read>0)");
				}
				insertChildrenNum=runner.execute(sqlBuff.toString(), parameterMap);
			}
			
			//3--插入所有上级，判断在权限表里有没有，有则不插
			sqlBuff.delete(0, sqlBuff.length());
			List<String> list = new ArrayList<String>();
			getParentIds(menuId,list);
			StringBuffer sql = new StringBuffer();
			if(list!=null&&!list.isEmpty()){
				sql.append('(');
				for(String s : list){
					sql.append("'"+s+"',");
				}
				sql.deleteCharAt(sql.length()-1);
				sql.append(')');
				
			}
			if(list!=null&&!list.isEmpty()){
				sqlBuff.append("insert into E_ROLE_PERMISSION(role_code,menu_id,auth_read,auth_create,auth_update,auth_delete,auth_export,auth_issued)") 
					.append("select #roleId#, resources_id").append(insertValues).append(" from (select *  from e_menu  where resources_id in "+sql.toString()+") x where resources_id not in") 
					.append("(select menu_id from E_ROLE_PERMISSION where role_code=#roleId# ) ") ;
				insertParentNum=runner.execute(sqlBuff.toString(), parameterMap);
			}
			
			
			if ("1".equals(authValue)){
				//4--更新上级(递归)，在权限表里存在的(只有在选中时，在不选时，不影响上级)
				sqlBuff.delete(0, sqlBuff.length());
				if(list!=null&&!list.isEmpty()){
					sqlBuff.append("update E_ROLE_PERMISSION ").append(updateValues) 
					.append(" where menu_id in "+sql.toString()+" and role_code = #roleId#") ;
					updateParentNum=runner.execute(sqlBuff.toString(), parameterMap);
				}
				
			}
		} catch (Exception e) {
			// TODO: handle exception
			sqlBuff.delete(0, sqlBuff.length());
//			sqlBuff.append("insert into E_OPERATION_LOG(USER_ID,MENU_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES(");
//			sqlBuff.append("'"+sessionUserId+"',");
//			sqlBuff.append("'"+currentMenuId+"',");
//			sqlBuff.append("'"+("checked".equals(checked) ? "2":"4")+"',");
//			sqlBuff.append("'0',");
//			sqlBuff.append("'"+("checked".equals(checked) ? ("角色　　"+operateRoleName+"("+operateRoleId+")　添加赋权菜单　"+operateMenuName+"("+operateMenuId+")"):("角色　"+operateRoleName+"("+operateRoleId+")　删除赋权菜单　"+operateMenuName+"("+operateMenuId+")"))+"',");
//			sqlBuff.append("'"+sessionUserIp+"',");
//			sqlBuff.append("'"+Functions.getDate("yyyy-MM-dd HH:mm:ss")+"'");
//			sqlBuff.append(")");
			
			String sql = runner.sql("frame.log.insOperationLog");
			Map<String,String> parMap = new HashMap<String,String>(); 
			parMap.put("uid", sessionUserId);
			parMap.put("menuid", currentMenuId);
			parMap.put("operate_type_code", ("checked".equals(checked) ? "2":"4"));
			parMap.put("operate_result", "0");
			parMap.put("content", ("checked".equals(checked) ? ("角色　　"+operateRoleName+"("+operateRoleId+")　添加赋权菜单　"+operateMenuName+"("+operateMenuId+")"):("角色　"+operateRoleName+"("+operateRoleId+")　删除赋权菜单　"+operateMenuName+"("+operateMenuId+")")));
			parMap.put("client_ip", sessionUserIp);
			
			runner.execute(sql,parMap);
			e.printStackTrace();
		}
		
		/*插入日志*/
		if((updateChildrenNum+insertChildrenNum+insertParentNum+updateParentNum)>0){
			sqlBuff.delete(0, sqlBuff.length());
//			sqlBuff.append("insert into E_OPERATION_LOG(USER_ID,MENU_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES(");
//			sqlBuff.append("'"+sessionUserId+"',");
//			sqlBuff.append("'"+currentMenuId+"',");
//			sqlBuff.append("'"+("checked".equals(checked) ? "2":"4")+"',");
//			sqlBuff.append("'1',");
//			sqlBuff.append("'"+("checked".equals(checked) ? ("角色　　"+operateRoleName+"("+operateRoleId+")　添加赋权菜单　"+operateMenuName+"("+operateMenuId+")"):("角色　"+operateRoleName+"("+operateRoleId+")　删除赋权菜单　"+operateMenuName+"("+operateMenuId+")"))+"',");
//			sqlBuff.append("'"+sessionUserIp+"',");
//			sqlBuff.append("'"+Functions.getDate("yyyy-MM-dd HH:mm:ss")+"'");
//			sqlBuff.append(")");
			
			String sql = runner.sql("frame.log.insOperationLog");
			Map<String,String> parMap = new HashMap<String,String>(); 
			parMap.put("uid", sessionUserId);
			parMap.put("menuid", currentMenuId);
			parMap.put("operate_type_code", ("checked".equals(checked) ? "2":"4"));
			parMap.put("operate_result", "1");
			parMap.put("content", ("checked".equals(checked) ? ("角色　　"+operateRoleName+"("+operateRoleId+")　添加赋权菜单　"+operateMenuName+"("+operateMenuId+")"):("角色　"+operateRoleName+"("+operateRoleId+")　删除赋权菜单　"+operateMenuName+"("+operateMenuId+")")));
			parMap.put("client_ip", sessionUserIp);
			runner.execute(sql,parMap);
			
		}else{
			sqlBuff.delete(0, sqlBuff.length());
//			sqlBuff.append("insert into E_OPERATION_LOG(USER_ID,MENU_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES(");
//			sqlBuff.append("'"+sessionUserId+"',");
//			sqlBuff.append("'"+currentMenuId+"',");
//			sqlBuff.append("'"+("checked".equals(checked) ? "2":"4")+"',");
//			sqlBuff.append("'0',");
//			sqlBuff.append("'"+("checked".equals(checked) ? ("角色　　"+operateRoleName+"("+operateRoleId+")　添加赋权菜单　"+operateMenuName+"("+operateMenuId+")"):("角色　"+operateRoleName+"("+operateRoleId+")　删除赋权菜单　"+operateMenuName+"("+operateMenuId+")"))+"',");
//			sqlBuff.append("'"+sessionUserIp+"',");
//			sqlBuff.append("'"+Functions.getDate("yyyy-MM-dd HH:mm:ss")+"'");
			sqlBuff.append(")");
			
			String sql = runner.sql("frame.log.insOperationLog");
			Map<String,String> parMap = new HashMap<String,String>(); 
			parMap.put("uid", sessionUserId);
			parMap.put("menuid", currentMenuId);
			parMap.put("operate_type_code", ("checked".equals(checked) ? "2":"4"));
			parMap.put("operate_result", "0");
			parMap.put("content", ("checked".equals(checked) ? ("角色　　"+operateRoleName+"("+operateRoleId+")　添加赋权菜单　"+operateMenuName+"("+operateMenuId+")"):("角色　"+operateRoleName+"("+operateRoleId+")　删除赋权菜单　"+operateMenuName+"("+operateMenuId+")")));
			parMap.put("client_ip", sessionUserIp);
			runner.execute(sql,parMap);
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
}
