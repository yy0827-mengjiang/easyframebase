package cn.com.easy.ext;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.service.component.ComponentBaseService;

@Controller
public class FrameJspJsonAction extends ComponentBaseService{
	
	
	private SqlRunner runner ;
	/* 描述：获取当前用户能访问到的菜单的列表，
	 * 参数：request
	 * 返回：List<Map>,map中包含的键有RESOURCES_ID、RESOURCES_NAME、PARENT_ID、AUTH_CREATE、AUTH_READ、AUTH_UPDATE、AUTH_DELETE
	 * 	*/
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private List<Map> getCurrentUserMenuList(HttpServletRequest request) throws SQLException{
		Map userInfo=(request.getSession().getAttribute("UserInfo")==null?null:(Map) request.getSession().getAttribute("UserInfo"));
		Map<String,String> paramMap=new HashMap<String, String>();
		paramMap.put("userId", String.valueOf(userInfo.get("USER_ID")));
		StringBuilder sqlStrBui=new StringBuilder();
		if("1".equals(String.valueOf(userInfo.get("ADMIN")))){//管理员有全部权限
			sqlStrBui.append(runner.sql("frame.menuManager.menuList"));
		}else{//非管理员有自己所属权限
			sqlStrBui.append(runner.sql("frame.menuManager.menuList.admin"));
		}
		
		List nodeMapList=runner.queryForMapList(sqlStrBui.toString(),paramMap);
		return nodeMapList;
	}
	/* 描述：获取菜单的子孙菜单（包含本身）
	 * 参数：
	 * 	menuList  原始菜单(map中包含的键有RESOURCES_ID、RESOURCES_NAME、PARENT_ID、AUTH_CREATE、AUTH_READ、AUTH_UPDATE、AUTH_DELETE)
	 * 	menuId	要查找的菜单的id
	 * 返回：List<Map>,map中包含的键有RESOURCES_ID、RESOURCES_NAME、PARENT_ID、AUTH_CREATE、AUTH_READ、AUTH_UPDATE、AUTH_DELETE
	 * 	*/
	@SuppressWarnings("rawtypes")
	private List<Map> getChildrenMenuList(List<Map> menuList,String menuId){
		List<Map> resultMapList=new ArrayList<Map>();
		if(menuId==null||"".equals(menuId)){
			resultMapList=menuList;
		}
		for(Map tempMap:menuList){
			if(menuId.equals(String.valueOf(tempMap.get("RESOURCES_ID")))){
				resultMapList.add(tempMap);
				continue;
			}
			if(menuId.equals(String.valueOf(tempMap.get("PARENT_ID")))){
				List<Map> childrenMapList=getChildrenMenuList(menuList,String.valueOf(tempMap.get("RESOURCES_ID")));
				for(Map tempChildMap:childrenMapList){
					resultMapList.add(tempChildMap);
				}
				continue;
			}
		}
		return resultMapList;
		
	}
	/* 描述：获取菜单的祖先菜单（包含本身）
	 * 参数：
	 * 	menuList  原始菜单(map中包含的键有RESOURCES_ID、RESOURCES_NAME、PARENT_ID、AUTH_CREATE、AUTH_READ、AUTH_UPDATE、AUTH_DELETE)
	 * 	menuId	要查找的菜单的id
	 * 返回：List<Map>,map中包含的键有RESOURCES_ID、RESOURCES_NAME、PARENT_ID、AUTH_CREATE、AUTH_READ、AUTH_UPDATE、AUTH_DELETE
	 * 	*/
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
	
	/* 描述：菜单管理,响应菜单树的json数据
	 * 参数：
	 * 返回：
	 **/
	@SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@Action("menu/loardTree")
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
			nodesList=new ArrayList<Map>();
			String id=(request.getParameter("id")==null?"":String.valueOf(request.getParameter("id")));
			if("".equals(id.trim())){//根结点
				Map rootNodeMap=runner.queryForMap(runner.sql("frame.menuManager.rootNode"));
				if(rootNodeMap==null||rootNodeMap.get("RESOURCES_ID")==null){
					runner.executet(runner.sql("frame.menuManager.insertRootNode"));
					rootNodeMap=runner.queryForMap(runner.sql("frame.menuManager.rootNode"));
				}
				Map<String,Object> nodeMap=new HashMap<String, Object>();
				if(rootNodeMap!=null){
					nodeMap.put("id", rootNodeMap.get("RESOURCES_ID"));
					nodeMap.put("text", rootNodeMap.get("RESOURCES_NAME"));
					nodeMap.put("state", "closed");
					Map<String,String> attributesMap=new HashMap<String, String>();
					attributesMap.put("authCreate", "1");
					attributesMap.put("authUpdate", "0");
					attributesMap.put("authDelete", "0");
					nodeMap.put("attributes", attributesMap);
					nodesList.add(nodeMap);
				}else{
					System.err.println("未找到根结点！");
				}
				
			}else{//非根结点
				List nodeMapList=getCurrentUserMenuList(request);
				if(nodeMapList!=null){
					for(Object nodeObj:nodeMapList){
						Map<String, String> tempNodeMap=new HashMap<String, String>();
						if(nodeObj!=null){
							tempNodeMap=(Map<String, String>) nodeObj;
						}
						if(id.equals(tempNodeMap.get("PARENT_ID"))){
							Map<String,Object> nodeMap=new HashMap<String, Object>();
							nodeMap.put("id", tempNodeMap.get("RESOURCES_ID"));
							nodeMap.put("text", tempNodeMap.get("RESOURCES_NAME"));
							for(Object nodeForChildObj:nodeMapList){
								Map<String, String> tempNodeForChildMap=new HashMap<String, String>();
								if(nodeForChildObj!=null){
									tempNodeForChildMap=(Map<String, String>) nodeForChildObj;
								}
								if(tempNodeMap.get("RESOURCES_ID")!=null&&tempNodeMap.get("RESOURCES_ID").equals(tempNodeForChildMap.get("PARENT_ID"))){
									nodeMap.put("state", "closed");
									break;
								}
							}
							
							Map<String,String> attributesMap=new HashMap<String, String>();
							attributesMap.put("authCreate", String.valueOf(tempNodeMap.get("AUTH_CREATE")));
							attributesMap.put("authUpdate", String.valueOf(tempNodeMap.get("AUTH_UPDATE")));
							attributesMap.put("authDelete", String.valueOf(tempNodeMap.get("AUTH_DELETE")));
							nodeMap.put("attributes", attributesMap);
							nodesList.add(nodeMap);
						}
						
						
					}
				}
			}
			jsonStr=Functions.java2json(nodesList);
//			System.out.println("jsonStr:"+jsonStr);
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
	
	/* 描述：菜单管理,删除菜单树结点
	 * 参数：
	 * 返回：
	 **/
	@Autowired
	@SuppressWarnings({ "unused", "rawtypes", "null" })
	@Action("menu/removeTreeNode")
	public void menuRemoveTreeNode(HttpServletRequest request, HttpServletResponse response) {
		PrintWriter out = null;
		String jsonStr=null;
		try {
			Map userInfo=(request.getSession().getAttribute("UserInfo")==null?null:(Map) request.getSession().getAttribute("UserInfo"));
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			String menuId=(request.getParameter("currentNodeId")==null?"":String.valueOf(request.getParameter("currentNodeId")));
			List<Map> nodeMapList=getCurrentUserMenuList(request);
			List<Map> childrenNodeList=getChildrenMenuList(nodeMapList,menuId);
			Map<String,String> paramMap=new HashMap<String,String>();
			for(Map tempChildMap:childrenNodeList){
				paramMap.put("menuId", String.valueOf(tempChildMap.get("RESOURCES_ID")).trim());
				runner.execute(runner.sql("frame.menuManager.deleteUserPermissionByMenuId"), paramMap);
				runner.execute(runner.sql("frame.menuManager.deleteRolePermissionByMenuId"), paramMap);
				runner.execute(runner.sql("frame.menuManager.deleteUserCollectByMenuId"), paramMap);
				runner.execute(runner.sql("frame.menuManager.deleteTreeNodeByMenuId"), paramMap);
			}
			jsonStr="1";
			out.print(jsonStr);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			jsonStr="0";
			out.print(jsonStr);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			jsonStr="0";
			out.print(jsonStr);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			jsonStr="0";
			out.print(jsonStr);
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	
	/* 描述：菜单管理,授权,删除角色
	 * 参数：
	 * 返回：
	 **/
	@SuppressWarnings({ "unused", "rawtypes", "null" })
	@Action("menu/menuRemoveRole")
	public void menuRemoveRole(HttpServletRequest request, HttpServletResponse response) {
		PrintWriter out = null;
		String jsonStr=null;
		try {
			Map userInfo=(request.getSession().getAttribute("UserInfo")==null?null:(Map) request.getSession().getAttribute("UserInfo"));
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			String menuId=(request.getParameter("menuId")==null?"":String.valueOf(request.getParameter("menuId")));
			String roleCode=(request.getParameter("roleCode")==null?"":String.valueOf(request.getParameter("roleCode")));
			
			List<Map> nodeMapList=getCurrentUserMenuList(request);
			List<Map> childrenNodeList=getChildrenMenuList(nodeMapList,menuId);
			Map<String,String> paramMap=new HashMap<String,String>();
			paramMap.put("roleCode", roleCode);
			for(Map tempChildMap:childrenNodeList){
				paramMap.put("menuId", String.valueOf(tempChildMap.get("RESOURCES_ID")).trim());
				runner.execute(runner.sql("frame.menuManager.deleteRolePermissionByMenuIdAndRoleId"), paramMap);
			}
			jsonStr="1";
			out.print(jsonStr);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			jsonStr="0";
			out.print(jsonStr);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			jsonStr="0";
			out.print(jsonStr);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			jsonStr="0";
			out.print(jsonStr);
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	/* 描述：菜单管理,授权,添加角色
	 * 参数：
	 * 返回：
	 **/
	@SuppressWarnings({ "unused", "rawtypes", "null" })
	@Action("menu/menuAddRole")
	public void menuAddRole(HttpServletRequest request, HttpServletResponse response) {
		//'${param.roleCode }', RESOURCES_ID, '${param.createQX }', '${param.readQX }', '${param.updateQX }', '${param.deleteQX }', '${param.exportQX }'
		//${param.menuId } ${param.roleCode }
		PrintWriter out = null;
		String jsonStr=null;
		try {
			Map userInfo=(request.getSession().getAttribute("UserInfo")==null?null:(Map) request.getSession().getAttribute("UserInfo"));
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			String menuId=(request.getParameter("menuId")==null?"":String.valueOf(request.getParameter("menuId")));
			String roleCode=(request.getParameter("roleCode")==null?"":String.valueOf(request.getParameter("roleCode")));
			String createQX=(request.getParameter("createQX")==null?"":String.valueOf(request.getParameter("createQX")));
			String readQX=(request.getParameter("readQX")==null?"":String.valueOf(request.getParameter("readQX")));
			String updateQX=(request.getParameter("updateQX")==null?"":String.valueOf(request.getParameter("updateQX")));
			String deleteQX=(request.getParameter("deleteQX")==null?"":String.valueOf(request.getParameter("deleteQX")));
			String exportQX=(request.getParameter("exportQX")==null?"":String.valueOf(request.getParameter("exportQX")));
			
			List<Map> nodeMapList=getCurrentUserMenuList(request);
			Map<String,String> paramMap=new HashMap<String,String>();
			paramMap.put("roleCode", roleCode);
			paramMap.put("createQX", createQX);
			paramMap.put("readQX", readQX);
			paramMap.put("updateQX", updateQX);
			paramMap.put("deleteQX", deleteQX);
			paramMap.put("exportQX", exportQX);
			/*子孙*/
			List<Map> childrenNodeList=getChildrenMenuList(nodeMapList,menuId);
			for(Map tempChildMap:childrenNodeList){
				paramMap.put("menuId", String.valueOf(tempChildMap.get("RESOURCES_ID")).trim());
				runner.execute(runner.sql("frame.menuManager.insertRolePermissionForMenu"), paramMap);
			}
			/*祖先*/
			List<Map> parentNodeList=getParentMenuList(nodeMapList, menuId);
			for(Map tempParentMap:parentNodeList){
				if(menuId.equals(String.valueOf(tempParentMap.get("RESOURCES_ID")).trim())){
					continue;
				}
				paramMap.put("menuId", String.valueOf(tempParentMap.get("RESOURCES_ID")).trim());
				runner.execute(runner.sql("frame.menuManager.insertRolePermissionForMenu"), paramMap);
			}
			jsonStr="1";
			out.print(jsonStr);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			jsonStr="0";
			out.print(jsonStr);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			jsonStr="0";
			out.print(jsonStr);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			jsonStr="0";
			out.print(jsonStr);
		}finally{
			if(out != null){
				out.close();
			}
		}
	}

	
}

