package cn.com.easy.xbuilder.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.service.DataSetService;
import cn.com.easy.xbuilder.service.component.ComponentBaseService;

@Controller
public class XbuilderJspJsonAction extends ComponentBaseService{
	
	
	private SqlRunner runner ;
	
	@SuppressWarnings("rawtypes")
	private List<Map> getChildrenRoleList(List<Map> roleList,String roleId){
		List<Map> resultMapList=new ArrayList<Map>();
		if(roleId==null||"".equals(roleId)){
			resultMapList=roleList;
		}
		for(Map tempMap:roleList){
			if(roleId.equals(String.valueOf(tempMap.get("ROLE_CODE")))){
				resultMapList.add(tempMap);
				continue;
			}
			if(roleId.equals(String.valueOf(tempMap.get("PARENT_CODE")))){
				List<Map> childrenMapList=getChildrenRoleList(roleList,String.valueOf(tempMap.get("ROLE_CODE")));
				for(Map tempChildMap:childrenMapList){
					resultMapList.add(tempChildMap);
				}
				continue;
			}
		}
		return resultMapList;
		
	}
	@SuppressWarnings({ "rawtypes" })
	private List<Map> getParentMenuList(List<Map> menuList,String menuId){
		List<Map> resultMapList=new ArrayList<Map>();
		for(Map tempMap:menuList){
			if(menuId.equals(String.valueOf(tempMap.get("RESOURCES_ID")))){
				resultMapList.add(tempMap);
				List<Map> parentMapList=getParentMenuList(menuList,String.valueOf(tempMap.get("PARENT_ID")));
				for(Map tempChildMap:parentMapList){
					resultMapList.add(tempChildMap);
				}
			}
		
		}
		return resultMapList;
		
	}
	
	@SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@Action("xbuilder/loadMenuTreeData")
	public void xbuilderLoadMenuTreeData(HttpServletRequest request, HttpServletResponse response) {
		PrintWriter out = null;
		String jsonStr=null;
		List<Map> rolesList=null;
		try {
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
			List allRoleMapList=runner.queryForMapList(runner.sql("xbuilder.reportManager.allRoleList"),paramMap);
			List hasOwnRoleMapList=runner.queryForMapList(runner.sql("xbuilder.reportManager.hasOwnRoleList"),paramMap);
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
					
					List<String> hasOwnRoleReadOnlyList=new ArrayList<String>();
					List<String> deleteRoleList=new ArrayList<String>();
					List<String> rootRoleList=new ArrayList<String>();
					for(Object hasOwnRoleObj:hasOwnRoleMapList){
						Map<String,String> hasOwnRoleMap=null;
						if(hasOwnRoleObj!=null){
							hasOwnRoleMap=(Map<String, String>) hasOwnRoleObj;
						}
						if(hasOwnRoleMap.get("ROLE_CODE")!=null&&(!("".equals(hasOwnRoleMap.get("ROLE_CODE"))))){
							hasOwnRoleReadOnlyList.add(hasOwnRoleMap.get("ROLE_CODE"));
						}
					}
					List<Map> roleChildrenList=null;
					String tempStr=null;
					for(String tempHasOwnRoleReadOnlyStr:hasOwnRoleReadOnlyList){
						roleChildrenList=getChildrenRoleList(allRoleMapList,tempHasOwnRoleReadOnlyStr);
						for(Map tempRoleChildMap:roleChildrenList){
							tempStr=String.valueOf(tempRoleChildMap.get("ROLE_CODE"));
							if(tempStr.equals(tempHasOwnRoleReadOnlyStr)){
								continue;
							}
							for(String tempFindNeedDeleteRoleStr:hasOwnRoleReadOnlyList){
								if(tempStr.equals(tempFindNeedDeleteRoleStr)){
									if(!(deleteRoleList.contains(tempFindNeedDeleteRoleStr))){
										deleteRoleList.add(tempFindNeedDeleteRoleStr);
									}
									
								}
								
							}
							
						}
						
					}
					
					boolean isDeleteFlag=false;
					for(Object hasOwnRoleObj:hasOwnRoleMapList){
						Map<String,String> hasOwnRoleMap=null;
						if(hasOwnRoleObj!=null){
							hasOwnRoleMap=(Map<String, String>) hasOwnRoleObj;
						}
						isDeleteFlag=false;
						for(String deleteRoleStr:deleteRoleList){
							if(deleteRoleStr!=null&&deleteRoleStr.equals(hasOwnRoleMap.get("ROLE_CODE"))){
								isDeleteFlag=true;
							}
						}
						if(!isDeleteFlag){
							if(rootRoleList.contains(hasOwnRoleMap.get("ROLE_CODE"))){
								continue;
							}
							rootRoleList.add(hasOwnRoleMap.get("ROLE_CODE"));
						}
						
					}
					
					for(Object tempObj:allRoleMapList){
						Map<String, Object> tempRoleMap=null;
						if(tempObj!=null){
							tempRoleMap=(Map<String, Object>) tempObj;
						}
						if(tempRoleMap!=null){
							for(String tempRootRoleStr:rootRoleList){
								if(tempRootRoleStr!=null&&tempRootRoleStr.equals(tempRoleMap.get("ROLE_CODE"))){
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
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Action("xbuilder/editReportMenuRole")
	public void xbuilderEditReportMenuRole(HttpServletRequest request, HttpServletResponse response) {
		PrintWriter out = null;
		String jsonStr=null;
		try {
			
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			SimpleDateFormat  sdf=new SimpleDateFormat("yyyyMMddHHmmss");
			Map userInfo=(request.getSession().getAttribute("UserInfo")==null?null:(Map) request.getSession().getAttribute("UserInfo"));
			String formId=(request.getParameter("formId")==null?"":String.valueOf(request.getParameter("formId")));
			String formName=(request.getParameter("formName")==null?"":String.valueOf(request.getParameter("formName")));
			String removeRoleIds=(request.getParameter("removeRoleIds")==null?"":String.valueOf(request.getParameter("removeRoleIds")));
			String addRoleIds=(request.getParameter("addRoleIds")==null?"":String.valueOf(request.getParameter("addRoleIds")));
			
			List<String> removeRoleIdsList=(List<String>)Functions.json2java(removeRoleIds);
			List<String> addRoleIdsList=(List<String>)Functions.json2java(addRoleIds);
			Map<String,String> paramMap=new HashMap<String, String>();
			paramMap.put("userId", String.valueOf(userInfo.get("USER_ID")));
			paramMap.put("userName", String.valueOf(userInfo.get("USER_NAME")));
			paramMap.put("loginId", String.valueOf(userInfo.get("LOGIN_ID")));
			paramMap.put("ip", String.valueOf(userInfo.get("IP")));
			paramMap.put("formId", formId);
			paramMap.put("formName", formName);
			Map menuObj=runner.queryForMap(runner.sql("xbuilder.reportManager.menuObjForEditMenuRole"),paramMap);
			String menuId=null;
			if(menuObj!=null){
				menuId=String.valueOf(menuObj.get("MENU_ID"));
			}
			if("null".equals(String.valueOf(menuId).trim())){
				jsonStr="0";
				throw new Exception("未找到报表对应的菜单编码！");
			}
			
			Map tempMap=null;
			for(String tempDeleteRoleId:removeRoleIdsList){
				if((!("-1".equals(tempDeleteRoleId)))&&(!("0".equals(tempDeleteRoleId)))){
					paramMap.put("currentTime", sdf.format(new Date()));
					paramMap.put("menuId", menuId);
					paramMap.put("roleId", tempDeleteRoleId);
					runner.execute(runner.sql("xbuilder.reportManager.deleteRolePermissionForEditMenuRole"), paramMap);
					tempMap=runner.queryForMap(runner.sql("xbuilder.reportManager.roleObjForEditMenuRole"),paramMap);
					paramMap.put("roleName", String.valueOf(tempMap.get("ROLE_NAME")).trim());
					runner.execute(runner.sql("xbuilder.reportManager.insertLogForEditMenuRole"), paramMap);
					
				}
			}
			
			StringBuilder sqlStrBui=new StringBuilder();
			if("1".equals(String.valueOf(userInfo.get("ADMIN")))){//管理员有全部权限
				sqlStrBui.append(runner.sql("frame.menuManager.menuList"));
			}else{//非管理员有自己所属权限
				sqlStrBui.append(runner.sql("frame.menuManager.menuList.admin"));
			}
			List currentUserMenuMapList=runner.queryForMapList(sqlStrBui.toString(),paramMap);
			List<Map> parentMenuList=getParentMenuList(currentUserMenuMapList, menuId);
			for(String tempAddRoleId:addRoleIdsList){
				for(Map tempParentMap:parentMenuList){
					paramMap.put("currentTime", sdf.format(new Date()));
					paramMap.put("roleId", tempAddRoleId);
					paramMap.put("menuId", String.valueOf(tempParentMap.get("RESOURCES_ID")).trim());
					runner.execute(runner.sql("xbuilder.reportManager.insertRolePermissionForEditMenuRole"), paramMap);
				}
				paramMap.put("menuId", menuId);
				tempMap=runner.queryForMap(runner.sql("xbuilder.reportManager.roleObjForEditMenuRole"),paramMap);
				paramMap.put("roleName", String.valueOf(tempMap.get("ROLE_NAME")).trim());
				runner.execute(runner.sql("xbuilder.reportManager.insertLogForEditMenuRole"), paramMap);
			}
			
			jsonStr="1";
			
		} catch (UnsupportedEncodingException e) {
			jsonStr="0";
			e.printStackTrace();
		} catch (IOException e) {
			jsonStr="0";
			e.printStackTrace();
		} catch (SQLException e) {
			jsonStr="0";
			e.printStackTrace();
		} catch (Exception e) {
			jsonStr="0";
			e.printStackTrace();
		}finally{
			out.print(jsonStr);
			if(out != null){
				out.close();
			}
		}
	}
	
	@SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@Action("moudle/test")
	public void menuLoadTree(HttpServletRequest request, HttpServletResponse response) {
		PrintWriter out = null;
		String jsonStr=null;
		List<Map> nodesList=null;
		try {
			Map userInfo=(request.getSession().getAttribute("UserInfo")==null?null:(Map) request.getSession().getAttribute("UserInfo"));
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			
//			jsonStr=Functions.java2json(nodesList);
//			System.out.println("jsonStr:"+jsonStr);
			out.print(jsonStr);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	@Action("test")
	public void test(HttpServletRequest request, HttpServletResponse response) {
		String reportId=request.getParameter("report_id");
		String reportSqlId=request.getParameter("report_sql_id");
		PrintWriter out = null;
		DataSetService dataSetService=null;
		String jsonStr="";
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			if(reportId==null||"".equals(reportId)){
				out.print("[]");
				return;
			}
			if(reportSqlId==null||"".equals(reportSqlId)){
				out.print("[]");
				return;
			}
			dataSetService=new DataSetService();
			@SuppressWarnings("unused")
			List<Map> modelList=dataSetService.getTreeDataObj(reportId);
			if(modelList==null){
				modelList=new ArrayList<Map>();
			}
			for(Map tempDataMap:modelList){
				if(reportSqlId.equals(tempDataMap.get("id"))){
					jsonStr=Functions.java2json(tempDataMap.get("children"));
				}
				
			}
			out.print(jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	
	
	
}

