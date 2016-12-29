<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ page import="org.springframework.web.util.*" %>
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

<e:switch value="${param.eaction}">
	<e:case value="list">		
		<c:tablequery>
		<e:if condition="${DBSource=='oracle' }">
		select t1.USER_ID,
		       t1.LOGIN_ID,
		       t1.USER_NAME,
		       decode(t1.admin,1,'是',0,'否','未知') "ADMIN",
		       decode(t1.sex,1,'男',0,'女','未知') SEX,
		       t1.EMAIL,
		       t1.MOBILE,
		       t1.TELEPHONE,
		       decode(t1.state,1,'启用',0,'停用','未知') "STATE",
		       t1.PWD_STATE,
		       t1.MEMO,
		       to_char(t1.reg_date,'yyyymmdd') REG_DATE,
		       to_char(t1.update_date,'yyyymmdd') UPDATE_DATE,
		       t2.USER_NAME REG_USER,
		       t3.USER_NAME UPDATE_USER
		  from E_USER t1, E_USER t2, E_USER t3,(select * from e_user_attribute where ATTR_CODE='AREA_NO_BELONG') T4
		 where t1.REG_USER=t2.user_id(+)
		   and t1.UPDATE_USER=t3.user_id(+)
		   AND T1.user_id=T4.USER_ID(+)
		   <e:if condition="${sessionScope.UserInfo.AREA_NO_BELONG!=null&&sessionScope.UserInfo.AREA_NO_BELONG!=''&&sessionScope.UserInfo.AREA_NO_BELONG!='-1'}">
		   AND T4.ATTR_VALUE='${sessionScope.UserInfo.AREA_NO_BELONG }'
		   </e:if>
		   <e:if condition="${param.loginid!=null&&param.loginid!=''}">
		   and t1.LOGIN_ID like '%${param.loginid}%'
		   </e:if>
		   <e:if condition="${param.username!=null&&param.username!=''}">
		   and t1.USER_NAME like '%'||#username#||'%'
		   </e:if>
		   <e:if condition="${param.user_sex!=null&&param.user_sex!=''}">
		   and t1.sex=${param.user_sex}
		   </e:if>
		   <e:if condition="${param.user_admin!=null&&param.user_admin!=''}">
		   and t1.admin=${param.user_admin}
		   </e:if>
		  
		   and t1.state='1'
           and t1.user_id not in (select user_id from d_resource_teamwork w where w.res_id = #resId#)
		 order by t1.reg_date desc
		 </e:if>
		 <e:if condition="${DBSource=='mysql' }">
		  select  t1.USER_ID,          
	         t1.LOGIN_ID,           
	         t1.password "PASSWORD",           
	         t1.USER_NAME,           
	        (case t1.admin when 1 then '是' when 0 then '否' else '未知' end) ADMIN,
	        (case t1.sex when 1 then '男' when 0 then '女' else '未知' end) SEX,
	         t1.EMAIL,          
	         t1.MOBILE,         
	         t1.TELEPHONE,                    
	         (case t1.state when 1 then '启用' when 0 then '停用' else '未知' end) STATE ,         
	         t1.PWD_STATE,           
	         t1.MEMO,             
	         date_format(t1.reg_date,'%Y%m%d') REG_DATE,      
	         date_format(t1.update_date,'%Y%m%d') UPDATE_DATE,         
	         t2.USER_NAME REG_USER,          
	         t3.USER_NAME UPDATE_USER      
	         from E_USER t1 left join E_USER t2 on  t1.REG_USER=t2.user_id 
	         left join  E_USER t3 on t1.UPDATE_USER=t3.user_id
	         left join 
	         (select * from e_user_attribute where ATTR_CODE='AREA_NO_BELONG') T4          
	          on T1.user_id=T4.USER_ID 
	          where 1=1 
	          <e:if condition="${sessionScope.UserInfo.AREA_NO_BELONG!=null&&sessionScope.UserInfo.AREA_NO_BELONG!=''&&sessionScope.UserInfo.AREA_NO_BELONG!='-1'}">
		   AND T4.ATTR_VALUE='${sessionScope.UserInfo.AREA_NO_BELONG }'
		   </e:if>
		   <e:if condition="${param.loginid!=null&&param.loginid!=''}">
		   and t1.LOGIN_ID like '%${param.loginid}%'
		   </e:if>
		   <e:if condition="${param.username!=null&&param.username!=''}">
		   and t1.USER_NAME like concat('%',#username#,'%')
		   </e:if>
		   <e:if condition="${param.user_sex!=null&&param.user_sex!=''}">
		   and t1.sex=${param.user_sex}
		   </e:if>
		   <e:if condition="${param.user_admin!=null&&param.user_admin!=''}">
		   and t1.admin=${param.user_admin}
		   </e:if>
		   and t1.state='1'
		   and t1.user_id not in (select user_id from d_resource_teamwork w where w.res_id = #resId#)
          order by t1.reg_date desc  
		 	
		 </e:if>
		</c:tablequery>
	</e:case>
	
</e:switch>