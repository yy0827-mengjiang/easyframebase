<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<e:switch value="${param.eaction}">

	<e:case value="getParentId">
		<e:q4o var="parentIdObj" sql="frame.roleManager.parentIdObj"></e:q4o>${parentIdObj.PARENT_CODE}
	</e:case>
	
	<e:case value="checkRoleName">
		<e:q4o var="roleNameCount" sql="frame.roleManager.roleNameCount"></e:q4o>${roleNameCount.ROLE_NAME_NUM}
	</e:case>
	
	<e:description>添加新角色</e:description>
	<e:case value="addTreeNode">
		<e:q4o var="seqIdObj" sql="frame.roleManager.seqIdObj"></e:q4o>
		<e:set var="seqId" value="${seqIdObj.SEQ_ID}"></e:set>
		<e:update var="insertTreeNode" sql="frame.roleManager.insertTreeNode"></e:update>${insertTreeNode}
		<a:log pageUrl="pages/frame/portal/role/RoleManager.jsp" operate="2" content="新增角色 ${param.roleNameForAdd }(${seqId})" result="${insertTreeNode }"/>
	</e:case>
	
	<e:description>获取一个角色信息</e:description>
	<e:case value="getOneTreeNode">
		<e:q4o var="oneTreeNodeObj" sql="frame.roleManager.oneTreeNodeObj"></e:q4o>${e:java2json(oneTreeNodeObj)}
	</e:case>
	
	<e:description>修改角色</e:description>
	<e:case value="editeTreeNode">
		<e:update var="updateTreeNode" sql="frame.roleManager.updateTreeNode"></e:update>${updateTreeNode}
		<a:log pageUrl="pages/frame/portal/role/RoleManager.jsp" operate="3" content="修改角色 ${param.roleNameForEdite}(${param.currentIdForEdite })" result="${updateTreeNode }"/>
	</e:case>
	
	<e:description>移动角色到其他目录下</e:description>
	<e:case value="cutToOthers">
		<e:update var="updateCutToOthers" sql="frame.roleManager.updateCutToOthers"></e:update>${updateCutToOthers }
	</e:case>
	
	<e:description>用户:获取已选用户</e:description>
	<e:case value="getHasSelectUsers">
		<e:q4o var="AreaNoExt" sql="frame.roleManager.AreaNoExt"></e:q4o>
		<c:tablequery>
			SELECT T.USER_ID as "USER_ID", T.LOGIN_ID AS "LOGIN_ID", T.USER_NAME AS "USER_NAME"
			  FROM (SELECT DISTINCT T1.USER_ID, T1.LOGIN_ID, T1.USER_NAME
			          FROM E_USER T1,
			               (
			               SELECT DISTINCT T1.USER_ID,
					      T1.LOGIN_ID,
					      T1.USER_NAME
					    FROM E_USER T1 
					    left join (SELECT A1.USER_ID,
					        A2.*
					      FROM E_USER_ROLE A1,
					        E_ROLE A2
					      WHERE A1.ROLE_CODE = A2.ROLE_CODE
					      ) T2 on T1.USER_ID = T2.USER_ID
					      where 1=1
			           <e:if condition="${sessionScope.UserInfo.AREA_ID!=null&&sessionScope.UserInfo.AREA_ID!=''&&sessionScope.UserInfo.AREA_ID=='-1'}">
					   AND 1 = 1
					   </e:if>
					    <e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'}">
						   <e:if condition="${AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=null&&AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=null&&AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=''}">
						    	and t1.${AreaNoExt.AREA_CONTROL_FRAME_COLUMN} = '${sessionScope.UserInfo.AREA_CONTROL_FRAME}'
						   		and t1.${AreaNoExt.AREA_CONTROL_FRAME_COLUMN} != '-1'
						    </e:if>
						   
					   </e:if>
					   )  aa
			        ) T
			 WHERE EXISTS (SELECT 1
			          FROM E_USER_ROLE A
			         WHERE A.ROLE_CODE = '${param.currentNodeId }'
			           AND A.USER_ID = T.USER_ID)
			       <e:if condition="${param.loginId!=null&&param.loginId!=''}">
				   		and LOGIN_ID like '%${param.loginId }%'
				   </e:if>
				   <e:if condition="${param.userName!=null&&param.userName!=''}">
				   		and USER_NAME LIKE '%${param.userName}%'
				   </e:if>
			 ORDER BY LOGIN_ID
		</c:tablequery>
	</e:case>
	
	<e:description>用户:删除用户</e:description>
	<e:case value="removeUser">
		<e:update var="deleteUser" sql="frame.roleManager.deleteUser"></e:update>${deleteUser}
		<e:q4o var="roleObj" sql="frame.roleManager.roleObj"></e:q4o>
		<e:q4o var="userObj" sql="frame.roleManager.userObj"></e:q4o>
		<a:log pageUrl="pages/frame/portal/role/RoleManager.jsp" operate="4" content="角色 ${roleObj.ROLE_NAME}（${roleObj.ROLE_CODE}）　删除用户　${userObj.USER_NAME}（${userObj.LOGIN_ID}）" result="${deleteUser}"/>
	</e:case>
	
	<e:description>用户:获得待选择用户</e:description>
	<e:case value="getNeedSelectUsers">
		<e:q4o var="AreaNoExt" sql="frame.roleManager.AreaNoExt"></e:q4o>
		<c:tablequery>
			SELECT T.USER_ID AS "USER_ID", T.LOGIN_ID AS "LOGIN_ID", T.USER_NAME AS"USER_NAME"
			  FROM (SELECT DISTINCT T1.USER_ID, T1.LOGIN_ID, T1.USER_NAME
			          FROM E_USER T1,
			               (
			               SELECT DISTINCT T1.USER_ID,
							      T1.LOGIN_ID,
							      T1.USER_NAME
							    FROM E_USER T1 
							    left join (SELECT A1.USER_ID,
							        A2.*
							      FROM E_USER_ROLE A1,
							        E_ROLE A2
							      WHERE A1.ROLE_CODE = A2.ROLE_CODE
							      ) T2 on T1.USER_ID = T2.USER_ID
							      where 1=1
			         <e:if condition="${sessionScope.UserInfo.AREA_ID!=null&&sessionScope.UserInfo.AREA_ID!=''&&sessionScope.UserInfo.AREA_ID=='-1'}">
					   AND 1 = 1
					   </e:if>
					   <e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'}">
					    <e:if condition="${AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=null&&AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=null&&AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=''}">
					    	and t1.${AreaNoExt.AREA_CONTROL_FRAME_COLUMN} = '${sessionScope.UserInfo.AREA_CONTROL_FRAME}'
					   		and t1.${AreaNoExt.AREA_CONTROL_FRAME_COLUMN} != '-1'
					    </e:if>
					 </e:if>
					 )  aa
			        ) T
			 WHERE NOT EXISTS (SELECT 1
			          FROM E_USER_ROLE A
			         WHERE A.ROLE_CODE = '${param.currentNodeId }'
			           AND A.USER_ID = T.USER_ID)
			       <e:if condition="${param.loginId!=null&&param.loginId!=''}">
				   		and LOGIN_ID like '%${param.loginId }%'
				   </e:if>
				   <e:if condition="${param.userName!=null&&param.userName!=''}">
				   		and USER_NAME LIKE '%${param.userName}%'
				   </e:if>
			 ORDER BY LOGIN_ID
		</c:tablequery>
	</e:case>
	
	<e:description>用户:添加用户</e:description>
	<e:case value="addUser">
		<e:update var="insertUser" sql="frame.roleManager.insertUser"></e:update>${insertUser }
		<e:q4o var="roleObj" sql="frame.roleManager.roleObj"></e:q4o>
		<e:q4o var="userObj" sql="frame.roleManager.userObj"></e:q4o>
		<a:log pageUrl="pages/frame/portal/role/RoleManager.jsp" operate="2" content="角色 ${roleObj.ROLE_NAME}（${roleObj.ROLE_CODE}）　添加用户　${userObj.USER_NAME}（${userObj.LOGIN_ID}）" result="${insertUser}"/>
	</e:case>
</e:switch>