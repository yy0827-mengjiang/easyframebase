<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.web.util.*" %>
<%@ page import="cn.com.easy.taglib.function.Functions"%>
<%@ page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ page import="cn.com.easy.core.EasyContext" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<%

String username=request.getParameter("username")==null?"":request.getParameter("username");
String isMessyCode_username = request.getParameter("username");

if(isMessyCode_username == null || isMessyCode_username.equals("") || isMessyCode_username.toUpperCase().equals("NULL")){
   isMessyCode_username = request.getAttribute("username") + "";
}
if(isMessyCode_username == null || isMessyCode_username.equals("") || isMessyCode_username.toUpperCase().equals("NULL")){
   isMessyCode_username = request.getSession().getAttribute("username") + "";
}
isMessyCode_username = isMessyCode_username!=null?new String(isMessyCode_username.getBytes("ISO-8859-1"),"UTF-8"):"";
String isMessyCode_username1 = request.getParameter("username");
if(isMessyCode_username1 == null || isMessyCode_username1.equals("") || isMessyCode_username1.toUpperCase().equals("NULL")){
   isMessyCode_username1 = request.getAttribute("username") + "";
}
if(isMessyCode_username1 == null || isMessyCode_username1.equals("") || isMessyCode_username1.toUpperCase().equals("NULL")){
   isMessyCode_username1 = request.getSession().getAttribute("username") + "";}
isMessyCode_username1 = isMessyCode_username1!=null?new String(isMessyCode_username1.getBytes("ISO-8859-1"),"gb2312"):"";

if(CommonTools.isMessyCode(username)){
	if(!CommonTools.isMessyCode(isMessyCode_username)){
		request.setAttribute("username",isMessyCode_username);
	}
	else if(!CommonTools.isMessyCode(isMessyCode_username1)){
		request.setAttribute("username",isMessyCode_username1);
	}
	
}else{
	
	request.setAttribute("username",username);
}
%>
<e:q4o var="AreaNoExt">
 select COLUMN_NAME AREA_CONTROL_FRAME_COLUMN  from E_USER_EXT_COLUMN_ATTR t where ATTR_CODE='AREA_CONTROL_FRAME'
</e:q4o>
<e:switch value="${param.eaction}">
	<e:case value="list">
		<e:q4o var="OldExtAttrDataNumObj">
			SELECT COUNT(1) NUM FROM E_USER_ATTR_DIM T where NOT EXISTS (SELECT 1 FROM e_user_ext_column_attr WHERE ATTR_CODE=T.ATTR_CODE) 
		</e:q4o>
		<e:if condition="${OldExtAttrDataNumObj.NUM > 0}">
			<e:q4l var="userAttrDim" sql="frame.user.userAttrDim"></e:q4l>
		
			<e:update transaction="true">
				<e:forEach items="${userAttrDim.list}" var="item">
				      insert into e_user_ext_column_attr(attr_code,column_name) values(#item.ATTR_CODE#,#item.COLUMN_NAME#);
				</e:forEach>
			</e:update>
		</e:if>
		<e:if var="AreaNoExtIsNull" condition="${AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=null&&AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=null&&AreaNoExt.AREA_CONTROL_FRAME_COLUMN!=''}">
			<c:tablequery>
				select t1.USER_ID "USER_ID",
                   t1.LOGIN_ID "LOGIN_ID",
                   t4.AREA_DESC "AREA_DESC",
                   t1.USER_NAME "USER_NAME",
                   (case t1.admin when 1 then '是' when 0 then '否' else '未知' end) "ADMIN",
                   (case t1.sex when 1 then '男' when 0 then '女' else '未知' end) "SEX",
                   t1.EMAIL "EMAIL",
                   t1.MOBILE "MOBILE",
                   t1.TELEPHONE "TELEPHONE",
                   (case t1.state when 1 then '启用' when 0 then '停用' else '未知' end) "STATE",
                   t1.PWD_STATE "PWD_STATE",
                   t1.MEMO "MEMO",
                   t1.reg_date  "REG_DATE",
                   t1.update_date  "UPDATE_DATE",
                   t2.USER_NAME "REG_USER",
                   t3.USER_NAME "UPDATE_USER"
				  from E_USER t1 
				  left join E_USER t2 on t1.REG_USER=t2.user_id  
				  left join E_USER t3 on t1.UPDATE_USER=t3.user_id
				  left join cmcode_area t4 on t1.${AreaNoExt.AREA_CONTROL_FRAME_COLUMN}=t4.AREA_NO
				 where 1=1
				   <e:if condition="${sessionScope.UserInfo.ADMIN != '1'}">
				   and t1.user_id in (select USER_ID
									 from E_USER_ACCOUNT
									WHERE ACCOUNT_CODE IN
											(select ACCOUNT_CODE 
											   from E_USER_ACCOUNT 
											  where user_id = '${sessionScope.UserInfo.USER_ID}'))
					</e:if>
					
				   <e:if condition="${param.loginid!=null&&param.loginid!=''}">
				   and t1.LOGIN_ID like '%${param.loginid}%'
				   </e:if>
				   <e:if condition="${param.username!=null&&param.username!=''}">
				   and t1.USER_NAME like '%${param.username}%'
				   </e:if>
				   <e:if condition="${param.user_sex!=null&&param.user_sex!=''}">
				   and t1.sex=${param.user_sex}
				   </e:if>
				   <e:if condition="${param.user_admin!=null&&param.user_admin!=''}">
				   and t1.admin=${param.user_admin}
				   </e:if>
				   <e:if condition="${param.user_state!=null&&param.user_state!=''}">
				   and t1.state=${param.user_state}
				   </e:if>
				   <e:if condition="${param.area_no!=null&&param.area_no!=''&&param.area_no!='-1'}">
					    AND t1.${AreaNoExt.AREA_CONTROL_FRAME_COLUMN} = '${param.area_no}'
				   </e:if>
				   <e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'}">
				    	and t1.${AreaNoExt.AREA_CONTROL_FRAME_COLUMN} = '${sessionScope.UserInfo.AREA_CONTROL_FRAME}'
			   			and t1.${AreaNoExt.AREA_CONTROL_FRAME_COLUMN} != '-1'
				   
				   </e:if>
				 order by t1.reg_date desc
			</c:tablequery>
		</e:if>
		<e:else condition="${AreaNoExtIsNull}">
			<c:tablequery>
				select t1.USER_ID "USER_ID",
	                   t1.LOGIN_ID "LOGIN_ID",
	                   '' "AREA_DESC",
	                   t1.USER_NAME "USER_NAME",
	                   (case t1.admin when 1 then '是' when 0 then '否' else '未知' end) "ADMIN",
	                   (case t1.sex when 1 then '男' when 0 then '女' else '未知' end) "SEX",
	                   t1.EMAIL "EMAIL",
	                   t1.MOBILE "MOBILE",
	                   t1.TELEPHONE "TELEPHONE",
	                   (case t1.state when 1 then '启用' when 0 then '停用' else '未知' end) "STATE",
	                   t1.PWD_STATE "PWD_STATE",
	                   t1.MEMO "MEMO",
	                   t1.reg_date "REG_DATE",
	                   t1.update_date "UPDATE_DATE",
	                   t2.USER_NAME "REG_USER",
	                   t3.USER_NAME "UPDATE_USER"
				  from E_USER t1 left join E_USER t2 on t1.REG_USER=t2.user_id left join E_USER t3 on t1.UPDATE_USER=t3.user_id
				 where 1=1
				   <e:if condition="${sessionScope.UserInfo.ADMIN != '1'}">
				   and t1.user_id in (select USER_ID
									 from E_USER_ACCOUNT
									WHERE ACCOUNT_CODE IN
											(select ACCOUNT_CODE 
											   from E_USER_ACCOUNT 
											  where user_id = '${sessionScope.UserInfo.USER_ID}'))
					</e:if>
				   <e:if condition="${param.loginid!=null&&param.loginid!=''}">
				   and t1.LOGIN_ID like '%${param.loginid}%'
				   </e:if>
				   <e:if condition="${param.username!=null&&param.username!=''}">
				   and t1.USER_NAME Like '%${param.username}%'
				   </e:if>
				   <e:if condition="${param.user_sex!=null&&param.user_sex!=''}">
				   and t1.sex=${param.user_sex}
				   </e:if>
				   <e:if condition="${param.user_admin!=null&&param.user_admin!=''}">
				   and t1.admin=${param.user_admin}
				   </e:if>
				   <e:if condition="${param.user_state!=null&&param.user_state!=''}">
				   and t1.state=${param.user_state}
				   </e:if>
				 order by t1.reg_date desc
			</c:tablequery>
		
		</e:else>
	</e:case>
	<e:case value="getAccount">
		<e:q4l var="accountList">
			SELECT ACCOUNT_NAME "ACCOUNT_NAME",ACCOUNT_CODE "ACCOUNT_CODE" FROM OCT_ACCOUNT 
			
			WHERE 1=1
			<e:if condition="${sessionScope.UserInfo.ADMIN != '1'}">
			and ACCOUNT_CODE IN ( select ACCOUNT_CODE 
											   from E_USER_ACCOUNT 
											  where user_id = '${sessionScope.UserInfo.USER_ID}')  order by ACCOUNT_CODE
			</e:if>
		</e:q4l>${e:java2json(accountList.list)}
	</e:case>
	<e:case value="add">
		<e:q4l var="ExtColumnAttrRelList">
			SELECT ATTR_CODE,COLUMN_NAME FROM E_USER_EXT_COLUMN_ATTR
		</e:q4l>
		<e:q4o var="loginIdSum">
			select count(1) c from E_USER where login_id='${param.login_id}'
		</e:q4o>
		<e:if condition="${loginIdSum.c eq 0 || loginIdSum.c eq'0'}" var="isHaveLoginId">
			<e:q4o var="seqObj" sql="frame.user.seqObj"/>
			<e:q4o var="userMaxExt" sql="frame.user.userMaxExt"/>
			<e:update var="addUser" transaction="true">

					
					<e:if condition="${applicationScope.PwdEncrypt=='1'}">
					<%
						String pwd = request.getParameter("password");
						if(pwd==null||"".equals(pwd)||"null".equals(pwd)){
							pwd =  (String)EasyContext.getContext().get("initialPwd");
						}
						pwd = cn.com.easy.ext.MD5.MD5Crypt(pwd);
						pageContext.setAttribute("pwd",pwd);
					%>
					insert into E_USER(user_id,login_id,password,user_name,admin,sex,email,mobile,telephone,state,pwd_state,memo,reg_date,update_date,reg_user,update_user) values('${seqObj.v_user_id}','${param.login_id}','<%=pwd %>','${param.name}',${param.admin},${param.sex},'${param.email}','${param.mobile}','${param.telephone}',${param.state},1,'${param.memo}',#time()#,#time()#,'${sessionScope.UserInfo.USER_ID}','${sessionScope.UserInfo.USER_ID}');
					</e:if>
					<e:if condition="${applicationScope.PwdEncrypt=='0'}">
					<%
						String pwd = request.getParameter("password");
						if(pwd==null||"".equals(pwd)||"null".equals(pwd)){
							pwd =  (String)EasyContext.getContext().get("initialPwd");
						}
						pageContext.setAttribute("pwd",pwd);
					%>
					insert into E_USER(user_id,login_id,password,user_name,admin,sex,email,mobile,telephone,state,pwd_state,memo,reg_date,update_date,reg_user,update_user) values('${seqObj.v_user_id}','${param.login_id}','${pwd}','${param.name}',${param.admin},${param.sex},'${param.email}','${param.mobile}','${param.telephone}',${param.state},0,'${param.memo}',#time()#,#time()#,'${sessionScope.UserInfo.USER_ID}','${sessionScope.UserInfo.USER_ID}');
					</e:if>
					<%
					Map dim = WebUtils.getParametersStartingWith(request, "dim_");
					pageContext.setAttribute("attr_list",dim);
					%>
					<e:forEach items="${attr_list}" var="item">
						<e:if condition="${item.value!=''}">
							<% 
							Map.Entry entry = (Map.Entry)pageContext.getAttribute("item");
							if(entry.getValue() instanceof String[]){
							%>
							insert into E_USER_ATTRIBUTE values('${seqObj.v_user_id}','${e:replace(item.key,'dim_','')}','${e:join(item.value,',')}',#time()#,#time()#,'${sessionScope.UserInfo.USER_ID}','${sessionScope.UserInfo.USER_ID}');
							<e:forEach items="${ExtColumnAttrRelList.list}" var="ExtColumnAttrRelItem">
					   			<e:if condition="${e:replace(item.key,'dim_','')==ExtColumnAttrRelItem.ATTR_CODE}">
					   				UPDATE E_USER SET ${ExtColumnAttrRelItem.COLUMN_NAME }='${e:join(item.value,',')}' WHERE USER_ID='${seqObj.v_user_id}';
					   			</e:if>
					   		</e:forEach>
							<% 
							}else{
							%>
							insert into E_USER_ATTRIBUTE values('${seqObj.v_user_id}','${e:replace(item.key,'dim_','')}','${e:trim(item.value)}',#time()#,#time()#,'${sessionScope.UserInfo.USER_ID}','${sessionScope.UserInfo.USER_ID}');
							<e:forEach items="${ExtColumnAttrRelList.list}" var="ExtColumnAttrRelItem">
					   			<e:if condition="${e:replace(item.key,'dim_','')==ExtColumnAttrRelItem.ATTR_CODE}">
					   				UPDATE E_USER SET ${ExtColumnAttrRelItem.COLUMN_NAME }='${e:trim(item.value)}' WHERE USER_ID='${seqObj.v_user_id}';
					   			</e:if>
					   		</e:forEach>
							<% 
							}
							%>
				   		</e:if>
				   		<e:if condition="${item.key=='MANAGER_ID'}">
							insert into E_USER_ATTRIBUTE values('${seqObj.v_user_id}','${e:replace(item.key,'dim_','')}','${userMaxExt.v_max_manager_id}',#time()#,#time()#,'${sessionScope.UserInfo.USER_ID}','${sessionScope.UserInfo.USER_ID}');
							<e:forEach items="${ExtColumnAttrRelList.list}" var="ExtColumnAttrRelItem">
					   			<e:if condition="${e:replace(item.key,'dim_','')==ExtColumnAttrRelItem.ATTR_CODE}">
					   				UPDATE E_USER SET ${ExtColumnAttrRelItem.COLUMN_NAME }='${userMaxExt.v_max_manager_id}' WHERE USER_ID='${seqObj.v_user_id}';
					   			</e:if>
					   		</e:forEach>							
						</e:if>
				   		
				   		
			   		</e:forEach>
			   		<e:forEach items="${e:split(param.account_code,',')}" var="account"> 
		   			 	insert into E_USER_ACCOUNT (ACCOUNT_CODE,user_id) values('${account }','${seqObj.v_user_id}' );
				   </e:forEach>
			   		
			</e:update>
			<a:log pageUrl="pages/frame/portal/user/UserManager.jsp" operate="2" content="新增用户 ${param.name}（${param.login_id}）" result="${addUser}"/>
		</e:if><e:else condition="${isHaveLoginId}">HAVINGLOGINID</e:else>
	</e:case>
	<e:case value="edit">
		<e:q4l var="ExtColumnAttrRelList">
			SELECT ATTR_CODE,COLUMN_NAME FROM E_USER_EXT_COLUMN_ATTR
		</e:q4l>
		<e:update var="editeUser" transaction="true">
				<e:if condition="${applicationScope.PwdEncrypt=='1'}">
				<%
				String pwd = request.getParameter("password");
				pwd = cn.com.easy.ext.MD5.MD5Crypt(pwd);
				%>
				update E_USER set login_id='${param.login_id}',<e:if condition="${param.password!=''}">password='<%=pwd %>',</e:if>user_name='${param.name}',admin=${param.admin},sex=${param.sex},email='${param.email}',mobile='${param.mobile}',telephone='${param.telephone}',state=${param.state},memo='${param.memo}',update_date=#time()#,update_user='${sessionScope.UserInfo.USER_ID}' where user_id='${param.user_id}';
				</e:if>
				<e:if condition="${applicationScope.PwdEncrypt=='0'}">
				update E_USER set login_id='${param.login_id}',<e:if condition="${param.password!=''}">password='${param.password}',</e:if>user_name='${param.name}',admin=${param.admin},sex=${param.sex},email='${param.email}',mobile='${param.mobile}',telephone='${param.telephone}',state=${param.state},memo='${param.memo}',update_date=#time()#,update_user='${sessionScope.UserInfo.USER_ID}' where user_id='${param.user_id}';
				</e:if>
				delete from E_USER_ATTRIBUTE where user_id='${param.user_id}';
				<%
				Map dim = WebUtils.getParametersStartingWith(request, "dim_");
				pageContext.setAttribute("attr_list",dim);
				%>
				<e:forEach items="${attr_list}" var="item">
					<e:if condition="${item.value!=''}">
						<% 
						Map.Entry entry = (Map.Entry)pageContext.getAttribute("item");
						if(entry.getValue() instanceof String[]){
						%>
						insert into E_USER_ATTRIBUTE values('${param.user_id}','${e:replace(item.key,'dim_','')}','${e:join(item.value,',')}',#time()#,#time()#,'${sessionScope.UserInfo.USER_ID}','${sessionScope.UserInfo.USER_ID}');
						<e:forEach items="${ExtColumnAttrRelList.list}" var="ExtColumnAttrRelItem">
				   			<e:if condition="${e:replace(item.key,'dim_','')==ExtColumnAttrRelItem.ATTR_CODE}">
				   				UPDATE E_USER SET ${ExtColumnAttrRelItem.COLUMN_NAME }='${e:join(item.value,',')}' WHERE USER_ID='${param.user_id}';
				   			</e:if>
				   		</e:forEach>
						<% 
						}else{
						%>
						insert into E_USER_ATTRIBUTE values('${param.user_id}','${e:replace(item.key,'dim_','')}','${e:trim(item.value)}',#time()#,#time()#,'${sessionScope.UserInfo.USER_ID}','${sessionScope.UserInfo.USER_ID}');
						<e:forEach items="${ExtColumnAttrRelList.list}" var="ExtColumnAttrRelItem">
				   			<e:if condition="${e:replace(item.key,'dim_','')==ExtColumnAttrRelItem.ATTR_CODE}">
				   				UPDATE E_USER SET ${ExtColumnAttrRelItem.COLUMN_NAME }='${e:trim(item.value)}' WHERE USER_ID='${param.user_id}';
				   			</e:if>
				   		</e:forEach>
						<% 
						}
						%>
			   		</e:if>
		   		</e:forEach>
		   		 delete from E_USER_ACCOUNT where user_id='${param.user_id}';
		   		 <e:forEach items="${e:split(param.account_code,',')}" var="account"> 
		   			 	insert into E_USER_ACCOUNT (ACCOUNT_CODE,user_id) values('${account }','${param.user_id}');
				  </e:forEach>
		</e:update>
		<a:log pageUrl="pages/frame/portal/user/UserManager.jsp" operate="3" content="修改用户 ${param.name}（${param.login_id}）" result="${editeUser}"/>
	</e:case>
	<e:case value="delete">
		<e:q4o var="userObj">
			SELECT LOGIN_ID,USER_NAME FROM E_USER WHERE USER_ID='${param.user_id}'
		</e:q4o>
		<e:update var="removeUser" transaction="true">
				delete from e_user_collect where user_id='${param.user_id}';
				delete from e_user_attribute where user_id='${param.user_id}';
				delete from e_user_role where user_id='${param.user_id}';
				delete from e_user_permission where user_id='${param.user_id}';
				delete from e_user where user_id='${param.user_id}';
				delete from E_USER_ACCOUNT where user_id='${param.user_id}';
		</e:update>
		<a:log pageUrl="pages/frame/portal/user/UserManager.jsp" operate="4" content="删除用户 ${userObj.USER_NAME}（${userObj.LOGIN_ID}）" result="${removeUser}"/>
	</e:case>
	<e:case value="extSelect">
		<e:q4o var="isExist" sql="frame.user.isExist"></e:q4o>
		<e:q4l var="extData">
			<e:if condition="${param.DEFAULT_VALUE!=null&&param.DEFAULT_VALUE!=''}"> 
			select '${param.DEFAULT_VALUE}' "${param.CODE_KEY}",'${param.DEFAULT_DESC}' "${param.CODE_DESC}" 
			union all
			</e:if>
			select ${param.CODE_KEY} "${param.CODE_KEY}",${param.CODE_DESC} "${param.CODE_DESC}" from (
				select ${param.CODE_KEY},${param.CODE_DESC} from ${param.CODE_TABLE}
				where 1=1
				<e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'}">					
					
						<e:if condition="${e:indexOf(param.CODE_KEY, 'AREA')!=-1 }" var='isTrue'>
							and ${param.CODE_KEY} =	'${sessionScope.UserInfo.AREA_CONTROL_FRAME}'
						</e:if>
						<e:else condition="${isTrue}">
							<e:if condition="${isExist.num == 1 }">
								and AREA_NO = '${sessionScope.UserInfo.AREA_CONTROL_FRAME}'
							</e:if>							
						</e:else>
				</e:if>	
				<e:if condition="${e:trim(sessionScope.UserInfo[param.CODE_KEY])!=null&&e:trim(sessionScope.UserInfo[param.CODE_KEY])!=''}"> 
					and  ${param.CODE_KEY}='${sessionScope.UserInfo[param.CODE_KEY]}'
				</e:if>
				<e:if condition="${param.CODE_ORD!=null&&param.CODE_ORD!=''}"> 
				  order by ${param.CODE_ORD}
				 </e:if>) T
		</e:q4l>
		${e:java2json(extData.list)}
	</e:case>
	<e:case value="extCascade">
		<e:q4l var="extData">
			<e:if condition="${param.DEFAULT_VALUE!=null&&param.DEFAULT_VALUE!=''}"> 
			select '${param.DEFAULT_VALUE}' "${param.CODE_KEY}",'${param.DEFAULT_DESC}' "${param.CODE_DESC}" 
			union all
			</e:if>
			select ${param.CODE_KEY} "${param.CODE_KEY}",${param.CODE_DESC} "${param.CODE_DESC}" from (
				select ${param.CODE_KEY},${param.CODE_DESC} from ${param.CODE_TABLE}
				where 1=1
				<e:if condition="${param.PARENT_CODE!=null&&param.PARENT_CODE!='0'}"> 
				and  ${param.CODE_PARENT_KEY}='${param.PARENT_KEY}'
				</e:if>
				<e:if condition="${sessionScope.UserInfo[param.CODE_KEY]!=null&&sessionScope.UserInfo[param.CODE_KEY]!=''}"> 
				and  ${param.CODE_KEY}='${sessionScope.UserInfo[param.CODE_KEY]}'
				</e:if>
			    <e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'&&param.PARENT_CODE =='0'}">					
					<e:if condition="${e:indexOf(param.CODE_KEY, 'AREA')!=-1 }" var='isTrue'>
						and ${param.CODE_KEY} =	'${sessionScope.UserInfo.AREA_CONTROL_FRAME}'
					</e:if>
					<e:else condition="${isTrue }">					
						and AREA_NO = '${sessionScope.UserInfo.AREA_CONTROL_FRAME}'
					</e:else>
				</e:if>
				<e:if condition="${param.CODE_ORD!=null&&param.CODE_ORD!=''}"> 
				 order by ${param.CODE_ORD}
				</e:if>) T
		</e:q4l>
		${e:java2json(extData.list)}
	</e:case>
	<e:case value="extTree">
		<e:q4l var="extData">
			<e:if condition="${param.PARENT_KEY==null||param.PARENT_KEY=='-1'}">
				SELECT ${param.CODE_KEY} ID,${param.CODE_DESC} NAME,0 TLEAF  
				   FROM ${param.CODE_TABLE} 
				   <e:if condition="${sessionScope.UserInfo.AREA_CONTROL_FRAME!=null&&sessionScope.UserInfo.AREA_CONTROL_FRAME!=''&&sessionScope.UserInfo.AREA_CONTROL_FRAME!='-1'}" var="isArea">					
						 WHERE ${param.CODE_PARENT_KEY} = (select ${param.CODE_PARENT_KEY} from ${param.CODE_TABLE} where ${param.CODE_KEY} = '${sessionScope.UserInfo.AREA_CONTROL_FRAME}')
				  		START WITH ${param.CODE_KEY} = '${sessionScope.UserInfo.AREA_CONTROL_FRAME}'
			   			 CONNECT BY ${param.CODE_PARENT_KEY} = PRIOR ${param.CODE_KEY}
					</e:if>
					<e:else condition="${isArea }">
						  <e:if condition="${param.PARENT_KEY==null}">
				   			WHERE ${param.CODE_PARENT_KEY} is null
				 		  </e:if>
				  			<e:if condition="${param.PARENT_KEY=='-1'}">
				   			WHERE ${param.CODE_PARENT_KEY} = '-1'
				  			</e:if>					
					</e:else>
			  </e:if>
			  <e:if condition="${param.PARENT_KEY!=null&&param.PARENT_KEY!='-1'}">
				 SELECT ${param.CODE_KEY} ID,${param.CODE_DESC} NAME,CONNECT_BY_ISLEAF TLEAF 
				   FROM ${param.CODE_TABLE} 
				  WHERE ${param.CODE_PARENT_KEY} = '${param.PARENT_KEY}'
				  START WITH ${param.CODE_KEY} = '${param.PARENT_KEY}'
			    CONNECT BY ${param.CODE_PARENT_KEY} = PRIOR ${param.CODE_KEY}
			    <e:if condition="${param.CODE_ORD!=null&&param.CODE_ORD!=''}"> 
				  ORDER BY ${param.CODE_ORD}
				</e:if>
			</e:if>
		</e:q4l>
		[
			<e:forEach items="${extData.list}" var="item">
				<e:set var="chdUrl">/pages/frame/portal/user/UserAction.jsp?eaction=extTree&PARENT_KEY=${item.ID }</e:set>
				<e:if condition="${index>0}">,</e:if>
				{
					"id":"${item.ID }",
					"text":"${item.NAME }",
					<e:if condition="${item.TLEAF==0}">
					"attributes":{
						"type":"folder"
					},
					"children":<jsp:include page="${chdUrl}"/>
					</e:if>
					<e:if condition="${item.TLEAF==1}">
					"iconCls":"icon-ppt",
					"attributes":{"type": "leaf"}
					</e:if>
				}
			</e:forEach>
		]
	</e:case>
	
</e:switch>