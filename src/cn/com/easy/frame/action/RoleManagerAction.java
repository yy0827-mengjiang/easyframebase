package cn.com.easy.frame.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.web.taglib.function.Functions;
import cn.com.easy.xbuilder.service.component.ComponentBaseService;

@Controller
public class RoleManagerAction extends ComponentBaseService{
	
	
	private SqlRunner runner ;
	private List<Map> gChildrenRoleList;
	private String roleSql = " select * from e_role t where t.parent_code= #parentCode# ";
	private String childrenCountSql = "select count(1) CHILDREN_COUNT from e_role t where t.parent_code= #parentCode#";
	
	/**
	 * 获得用户拥有的角色以逗号分隔的字符串
	 * @param request
	 * @param response
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Action("role/getRolesOfUsers")
	public void getRolesOfUsers(HttpServletRequest request, HttpServletResponse response){
		PrintWriter out = null;
		String sql = runner.sql("frame.roleManager.rolesOfUserObj");
		Map paramMap = new HashMap<String,String>();
		paramMap.put("userId", ((Map)request.getSession().getAttribute("UserInfo")).get("USER_ID")+"");
		String result = "";
		try {
			List<Map> roleList = (List<Map>)runner.queryForMapList(sql, paramMap);
			for(Map map : roleList){
				result+=map.get("ROLE_CODE")+",";
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		try {
			if(result.length()>0){
				result = result.substring(0, result.lastIndexOf(","));
			}
			out = response.getWriter();
		} catch (IOException e) {
			e.printStackTrace();
		}
		out.print(result);
		
	}
	/**
	 * 删除角色
	 * @param request
	 * @param response
	 */
	@SuppressWarnings("rawtypes")
	@Action("role/deleteRole")
	public void deleteRole(HttpServletRequest request, HttpServletResponse response) {
		PrintWriter out = null;
		String result="1";
		gChildrenRoleList = new ArrayList<Map>();
		String parentRoleId = request.getParameter("currentNodeId");
		getAllChildrenRole(parentRoleId);
		StringBuffer inStr = new StringBuffer("'"+parentRoleId+"',");
		for(Map map : gChildrenRoleList){
			inStr.append("'"+getColumnValue("role_code",map)+"',");
		}
		String inSqlStr = inStr.toString();
		if(inSqlStr.length()>0){
			inSqlStr = inSqlStr.substring(0,inSqlStr.lastIndexOf(","));
		}
		Map paramMap = new HashMap();
		String roleSql = "SELECT ROLE_CODE,ROLE_NAME FROM E_ROLE WHERE ROLE_CODE = '"+parentRoleId+"'";
		Map roleMap=new HashMap();
		try {
			roleMap = runner.queryForMap(roleSql);
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
		String roleCode = roleMap.get("ROLE_CODE")+"";
		String roleName = roleMap.get("ROLE_NAME")+"";
				
		try {
			runner.execute("delete from E_USER_ROLE where role_code in ("+inSqlStr+")", paramMap);
			runner.execute("delete from E_ROLE_PERMISSION where role_code in ("+inSqlStr+")", paramMap);
			runner.execute("delete from E_POST_ROLE where role_code in ("+inSqlStr+")", paramMap);
			runner.execute("delete from E_ROLE where role_code in ("+inSqlStr+")", paramMap);
			result="1";
		} catch (SQLException e) {
			e.printStackTrace();
			result="0";
		}
		try {
			out = response.getWriter();
			out.print(result);
		} catch (IOException e) {
			e.printStackTrace();
		}
		//记录操作日志
		String content = "删除角色 "+roleName+"("+roleCode+")及子角色";
		String userId = ((Map)request.getSession().getAttribute("UserInfo")).get("USER_ID")+"";
		String userIp = ((Map)request.getSession().getAttribute("UserInfo")).get("IP")+"";
		writeOptLog("pages/frame/portal/role/RoleManager.jsp","4","1",content,userId,userIp);
	}
	
	/**
	 * 写操作日志
	 * @param pageUrl
	 * @param operate
	 * @param result
	 * @param content
	 * @param userId
	 * @param userIp
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void writeOptLog(String pageUrl,String operate,String result,String content,String userId,String userIp){
		String sql = "select RESOURCES_ID from  e_menu t left join D_SUBSYSTEM t1 on t.ext1=t1.subsystem_id and t.url='"+pageUrl+"'";
		try {
			List<Map> list = (List<Map>)runner.queryForMapList(sql);
			if(list!=null&&list.size()>0){
				Map map = list.get(0);
//				String insertSql = "insert into E_OPERATION_LOG(USER_ID,MENU_ID,OPERATE_TYPE_CODE,OPERATE_RESULT,CONTENT,CLIENT_IP,CREATE_DATE) VALUES(#userId#,#menuId#,#operate#,#result#,#content#,#userIp#,#createDate#)";
				String insertSql = runner.sql("frame.log.insOperationLog");
				Map paramMap = new HashMap<String,String>();
				paramMap.put("uid", userId);
				paramMap.put("menuId", map.get("RESOURCES_ID"));
				paramMap.put("operate_type_code", operate);
				paramMap.put("operate_result", result);
				paramMap.put("content", content);
				paramMap.put("client_ip", userIp);
				runner.execute(insertSql, paramMap);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 递归获得某个角色的所有子孙角色
	 * @param parentRoleId
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void getAllChildrenRole(String parentRoleId){
		Map paramMap = new HashMap<String,String>();
		paramMap.put("parentCode", parentRoleId);
		try {
			List<Map> roleList = (List<Map>)runner.queryForMapList(roleSql, paramMap);
			gChildrenRoleList.addAll(roleList);
			if(roleList!=null&&roleList.size()>0){
				String roleCode="";
				for(Map map : roleList){
					roleCode = getColumnValue("role_code",map);
					paramMap.put("parentCode", roleCode);
					Map countMap = runner.queryForMap(childrenCountSql, paramMap);
					if(countMap!=null){
						int childrenCount = 0;
						if(countMap.get("CHILDREN_COUNT")!=null){
							childrenCount = Integer.parseInt(countMap.get("CHILDREN_COUNT")+"");
						}
						if(childrenCount>0){
							getAllChildrenRole(roleCode);
						}		 
					}
				}
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	private String getColumnValue(String columnName,Map map){
		if(map.get(columnName)!=null){
			return map.get(columnName)+"";
		}else if(map.get(columnName.toLowerCase())!=null){
			return map.get(columnName.toLowerCase())+"";
		}else if(map.get(columnName.toUpperCase())!=null){
			return map.get(columnName.toUpperCase())+"";
		}
		return null;
	}
	
	
	@SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@Action("role/getRoleTree")
	public void getRoleTree(HttpServletRequest request, HttpServletResponse response) {
		PrintWriter out = null;
		String jsonStr=null;
		List<Map> rolesList=null;
		try {
			int rootNum = Integer.parseInt(String.valueOf(runner.queryForMap(runner.sql("frame.roleManager.rootNum")).get("ROOTNUM")));
			if(rootNum<1){
				runner.execute(runner.sql("frame.roleManager.insertRoot"), new HashMap());
			}
			Map userInfo=(request.getSession().getAttribute("UserInfo")==null?null:(Map) request.getSession().getAttribute("UserInfo"));
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			rolesList=new ArrayList<Map>();
			Map<String,String> paramMap=new HashMap<String, String>();
			paramMap.put("userId", String.valueOf(userInfo.get("USER_ID")));
			StringBuilder sqlStrBui=new StringBuilder();
			List allRoleMapList=runner.queryForMapList(runner.sql("frame.roleManager.allRoleList"),paramMap);
			List hasOwnRoleMapList=runner.queryForMapList(runner.sql("frame.roleManager.hasOwnRoleList"),paramMap);
			String id=(request.getParameter("id")==null?"":String.valueOf(request.getParameter("id")));
			if("".equals(id.trim())){
				if("1".equals(String.valueOf(userInfo.get("ADMIN")))){
					for(Object tempObj:allRoleMapList){
						Map<String, Object> tempRoleMap=null;
						if(tempObj!=null){
							tempRoleMap=(Map<String, Object>) tempObj;
						}
						if(tempRoleMap!=null){
							if("0".equals(tempRoleMap.get("ROLE_CODE"))){
								Map roleMap=new HashMap<String, Object>();
								roleMap.put("id", tempRoleMap.get("ROLE_CODE"));
								roleMap.put("text", tempRoleMap.get("ROLE_NAME"));
								if("0".equals(String.valueOf(tempRoleMap.get("ISLEAF")))){
									roleMap.put("state", "closed");
								}
								Map<String,String> attributesMap=new HashMap<String, String>();
								roleMap.put("attributes", attributesMap);
								rolesList.add(roleMap);
							}
						}
						
					}
				}else{
					Map tmpRootMap = null;
					Map checkRepeatMap = new HashMap();
					List hasOwnRoleMapListClone = new ArrayList();
					//克隆一份hasOwnRoleMapList，否则在下面的循环中调用removeOwnRoleChildren时会报错
					for(Object hasOwnRoleObj:hasOwnRoleMapList){
						hasOwnRoleMapListClone.add(hasOwnRoleObj);
					}
					for(Object hasOwnRoleObj:hasOwnRoleMapListClone){
						removeOwnRoleChildren(allRoleMapList,(Map<String, String>) hasOwnRoleObj,hasOwnRoleMapList);
					}
					for(Object hasOwnRoleObj:hasOwnRoleMapList){
							 tmpRootMap=(Map<String, String>) hasOwnRoleObj;
							 Map roleMap=new HashMap<String, Object>();
							 roleMap.put("id", tmpRootMap.get("ROLE_CODE"));
							 roleMap.put("text", tmpRootMap.get("ROLE_NAME"));
							 if("0".equals(String.valueOf(tmpRootMap.get("ISLEAF")))){
								 roleMap.put("state", "closed");
							 }
							 Map<String,String> attributesMap=new HashMap<String, String>();
							 roleMap.put("attributes", attributesMap);
							 rolesList.add(roleMap);
					}
				}
			}else{
				
				for(Object tempObj:allRoleMapList){
					Map<String, Object> tempRoleMap=null;
					if(tempObj!=null){
						tempRoleMap=(Map<String, Object>) tempObj;
					}
					if(tempRoleMap!=null){
						if(id.equals(tempRoleMap.get("PARENT_CODE"))){
							Map roleMap=new HashMap<String, Object>();
							roleMap.put("id", tempRoleMap.get("ROLE_CODE"));
							roleMap.put("text", tempRoleMap.get("ROLE_NAME"));
							if("0".equals(String.valueOf(tempRoleMap.get("ISLEAF")))){
								roleMap.put("state", "closed");
							}
							Map<String,String> attributesMap=new HashMap<String, String>();
							roleMap.put("attributes", attributesMap);
							rolesList.add(roleMap);
						}
					}
					
				}
			}
			
			jsonStr=Functions.java2json(rolesList);
			out.print(jsonStr);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	/**
	 * 递归删除每一条用户角色的子角色
	 * @param allRoleList
	 * @param currentRole
	 * @param ownRoleList
	 */
	private void removeOwnRoleChildren(List<Map> allRoleList,Map currentRole,List<Map> ownRoleList){
		int i=0;
		for(Map roleMap : allRoleList){
			if(roleMap.get("PARENT_CODE").equals(currentRole.get("ROLE_CODE"))){
				i++;
				Iterator<Map> iterator = ownRoleList.iterator();
				while(iterator.hasNext()){
					Map ownRoleMap = iterator.next();
					if(roleMap.get("ROLE_CODE").equals(ownRoleMap.get("ROLE_CODE"))){
						iterator.remove();
					}
				}
				removeOwnRoleChildren(allRoleList,roleMap,ownRoleList);
			}
		}
		if(i==0){
			return;
		}
	}
}

