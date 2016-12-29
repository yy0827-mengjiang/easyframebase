<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%> 
	<e:if condition="${param.type == '1'}">
		<c:datagrid url="/pages/frame/portal/menu/menuAction.jsp?eaction=rolelist&type=${param.type}&menu_id=${param.menu_id }" id="userTable" pageSize="15" fit="true"
					download="true" nowrap="false" title="菜单与用户对应关系" toolbar="#tbar">
			<thead>
				<tr>
					<th field="LOGIN_ID" width="100" align="center">
						用户登录号
					</th>
					<th field="USER_NAME" width="100" align="center">
						用户姓名
					</th>
			</thead>
		</c:datagrid> 
	</e:if>
	<e:if condition="${param.type == '0'}">
		<c:datagrid url="/pages/frame/portal/menu/menuAction.jsp?eaction=rolelist&type=${param.type}&menu_id=${param.menu_id }" id="userTable" pageSize="15" fit="true"
					download="true" nowrap="false" title="菜单与角色对应关系" toolbar="#tbar">
			<thead>
				<tr> 
					<th field="ROLE_NAME" width="100" align="center">
						角色名称
					</th> 
				</tr>
			</thead>
		</c:datagrid> 				
	</e:if>
		