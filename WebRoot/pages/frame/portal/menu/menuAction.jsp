<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@page import="java.io.File"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="rootFlagObj" sql="frame.menuManager.rootFlagObj"/>
<e:q4o var="AreaNoExt" sql="frame.menuManager.areaNoExt"/>
<e:switch value="${param.eaction}">
	<e:case value="checkRsourceName">
		<e:q4o var="resourceCount" sql="frame.menuManager.resourceCountWithName"/>${resourceCount.RESOURCE_NUM}
	</e:case>
	<e:case value="addTreeNode">
		<e:set var="filePath"></e:set>
		<e:parseRequest/>
		<e:set var="menuId">${parentIdForAdd }</e:set>
		<e:q4o var="checkAuthCreate" sql="frame.menuManager.menuAuthInfoByMenuId"/>
		<e:if condition="${attachmentForAdd!=null&&attachmentForAdd!=''}">
			<e:set var="fileName"><%=System.currentTimeMillis() %></e:set>
			<e:copy file="${attachmentForAdd}" tofile="/pages/frame/download/${fileName}${attachmentForAdd.suffix}"/>
			<e:set var="filePath">/pages/frame/download/${fileName}${attachmentForAdd.suffix}</e:set>
		</e:if>
		<e:if condition="${checkAuthCreate.AUTH_CREATE>0||sessionScope.UserInfo.ADMIN=='1'||rootFlagObj.IS_ROOT!='0'}">
			<e:q4o var="treeNodeIdObj" sql="frame.menuManager.treeNodeIdObj"/>	
			<e:update var="insertTreeNode1"  sql="frame.menuManager.insertTreeNode"/>
			<e:update var="insertTreeNode2" sql="frame.menuManager.insertTreeNodeUserPermission"/>
			<e:update var="insertTreeNode3" sql="frame.menuManager.insertTreeNodeRolePermission"/>
			<e:if var="addMenuResultFlag" condition="${insertTreeNode1==0||insertTreeNode2==0||insertTreeNode3==0 }">
				<e:set var="insertTreeNode">0</e:set>
			</e:if>
			<e:else condition="${addMenuResultFlag }">
				<e:set var="insertTreeNode">1</e:set>
			</e:else>
			${insertTreeNode }
		</e:if>
		<e:set var="menuId">${treeNodeIdObj.SEQ_ID }</e:set>
		<e:q4o var="menuPathObj" sql="frame.menuManager.menuPathObjByMenuIdForLog"/>
		<a:log pageUrl="pages/frame/portal/menu/menuManager.jsp" operate="2" content="添加菜单 ${menuPathObj.PATH_SHOW}" result="${insertTreeNode}"/>
	</e:case>
	
	<e:case value="getOneResource">
		<e:q4o var="oneResourceObj" sql="frame.menuManager.oneResourceObj"/>${e:java2json(oneResourceObj)}
	</e:case>
	
	<e:case value="editeTreeNode">
		<e:parseRequest/>
		<e:set var="menuId">${currentIdForEdite }</e:set>
		<e:q4o var="checkAuthEdite" sql="frame.menuManager.menuAuthInfoByMenuId"/>
		<e:if condition="${attachmentForEdite!=null&&attachmentForEdite!=''}">
			<e:set var="fileName"><%=System.currentTimeMillis() %></e:set>
			<e:copy file="${attachmentForEdite}" tofile="/pages/frame/download/${fileName}${attachmentForEdite.suffix}"/>
			<e:set var="filePath">/pages/frame/download/${fileName}${attachmentForEdite.suffix}</e:set>
			<e:if condition="${checkAuthEdite.AUTH_UPDATE>0||sessionScope.UserInfo.ADMIN=='1'||rootFlagObj.IS_ROOT!='0'}">
				<e:update var="updateTreeNode1" sql="frame.menuManager.updateTreeNodeWithFilePath"/>${updateTreeNode1 }
			</e:if>
			<e:set var="menuId">${param.currentIdForEdite }</e:set>
			<e:q4o var="menuPathObj" sql="frame.menuManager.menuPathObjByMenuIdForLog"/>
			<a:log pageUrl="pages/frame/portal/menu/menuManager.jsp" operate="3" content="编辑菜单 ${menuPathObj.PATH_SHOW}" result="${updateTreeNode1}"/>
		</e:if>
		<e:if condition="${attachmentForEdite==null||attachmentForEdite==''}">
			<e:if condition="${checkAuthEdite.AUTH_UPDATE>0||sessionScope.UserInfo.ADMIN=='1'||rootFlagObj.IS_ROOT!='0'}">
				<e:update var="updateTreeNode" sql="frame.menuManager.updateTreeNodeWithoutFilePath"/>${updateTreeNode }
			</e:if>
			<e:set var="menuId">${param.currentIdForEdite }</e:set>
			<e:q4o var="menuPathObj" sql="frame.menuManager.menuPathObjByMenuIdForLog"/>
			<a:log pageUrl="pages/frame/portal/menu/menuManager.jsp" operate="3" content="编辑菜单 ${menuPathObj.PATH_SHOW}" result="${updateTreeNode}"/>
		</e:if>
	</e:case>
	<e:case value="cutToOthers">
		<e:set var="menuId">${param.sourceId}</e:set>
		<e:q4o var="checkAuthUpdateForCut" sql="frame.menuManager.menuAuthInfoByMenuId"/>
		<e:if condition="${checkAuthUpdateForCut.AUTH_DELETE>0||sessionScope.UserInfo.ADMIN=='1'||rootFlagObj.IS_ROOT!='0'}">
			<e:update var="updateCutToOthers" sql="frame.menuManager.updateCutToOthers"/>${updateCutToOthers }
		</e:if>
		<a:log pageUrl="pages/frame/portal/menu/menuManager.jsp" operate="3" content="移动菜单树结点" result="${updateCutToOthers}"/>
	</e:case>
	<e:case value="getHasSelectRoles">
		<c:tablequery>
			<e:sql name="frame.menuManager.menuHasSelectRoles"/>
		</c:tablequery>
	</e:case>
	
	<e:case value="getNeedSelectRoles">
		<c:tablequery>
			<e:sql name="frame.menuManager.menuNeedSelectRoles"/>
		</c:tablequery>
	</e:case>
	
	<e:case value="rolelist"> 
		<e:if condition="${param.type == '1' }">
			<c:tablequery>
				<e:sql name="frame.menuManager.userListByMenuId"/>
			</c:tablequery>
		</e:if>
		<e:if condition="${param.type == '0' }">
			<c:tablequery>
				<e:sql name="frame.menuManager.roleListByMenuId"/>
			</c:tablequery>
		</e:if>
	</e:case>
	<e:case value="checkResourceNameAndUrl">
		<%
			String menuName=request.getParameter("menuName")==null?"":request.getParameter("menuName");
			String url=request.getParameter("url")==null?"":request.getParameter("url");
			File file=new File(request.getRealPath("/")+url);
			if(file.exists()){
				request.setAttribute("fileExist","1");
			}else{
				request.setAttribute("fileExist","0");
			}
		%>
		<e:q4o var="resourceCount1" sql="frame.menuManager.menuResourceCount"/>
		<e:if condition="${resourceCount1.RESOURCE_NUM!='0'&&fileExist=='1'}">1</e:if>
		<e:if condition="${resourceCount1.RESOURCE_NUM=='0'||fileExist!='1'}">0</e:if>
	</e:case>
	<e:case value="LoadLeftTree">
	 	<e:if var="ifv" condition="${param.id == null || param.id eq ''}">
	 		<e:set var="id">${param.pid }</e:set>
	 		<e:q4l var="MenuList" sql="frame.menuManager.frameLeftMenuList"/>
        </e:if>
        <e:else condition="${ifv}">
           <e:set var="id">${param.id }</e:set>
           <e:q4l var="MenuList" sql="frame.menuManager.frameLeftMenuList"/>
        </e:else>
        [
            <e:forEach items="${MenuList.list}" var="item">
                <e:if condition="${index>0}">
                    ,
                </e:if>
                {
                	"id":"${item.RESOURCES_ID }",
                    "text":"${item.RESOURCES_NAME }",
                    "state":"${item.STATE}",
                    <e:if condition="${item.STATE eq 'closed'}" var="isLeaf">
                    	"iconCls":"icon-tree01",
                    </e:if>
                    <e:else condition="${isLeaf}">
                    	"iconCls":"icon-tree02",
                    </e:else>
                    "attributes":{
                        "url":"${item.URL}",
                        "menuState":"${item.RESOURCE_STATE}",
                        "menuType":"${item.RESOURCES_TYPE}"
                    }
                }
            </e:forEach>
        ]
	</e:case>
	<e:case value="LoadLeftTreeSub">
	<e:q4l var="SubMenuList">
		
		</e:q4l>
		<e:forEach items="${SubMenuList.list}" var="item">
		<e:if condition="${index==0}">
		    ${item.RESOURCES_ID}
		    <e:break/>
		</e:if>
		</e:forEach>
	</e:case>
	
</e:switch>