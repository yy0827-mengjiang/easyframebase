<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="cn.com.easy.taglib.function.Functions"%>
<%@ page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>

<%
String post_title=request.getParameter("post_title")==null?"":request.getParameter("post_title");
String isMessyCode_post_title = request.getParameter("post_title");

if(isMessyCode_post_title == null || isMessyCode_post_title.equals("") || isMessyCode_post_title.toUpperCase().equals("NULL")){
   isMessyCode_post_title = request.getAttribute("post_title") + "";
}
if(isMessyCode_post_title == null || isMessyCode_post_title.equals("") || isMessyCode_post_title.toUpperCase().equals("NULL")){
   isMessyCode_post_title = request.getSession().getAttribute("post_title") + "";
}
isMessyCode_post_title = isMessyCode_post_title!=null?new String(isMessyCode_post_title.getBytes("ISO-8859-1"),"UTF-8"):"";
String isMessyCode_post_title1 = request.getParameter("post_title");
if(isMessyCode_post_title1 == null || isMessyCode_post_title1.equals("") || isMessyCode_post_title1.toUpperCase().equals("NULL")){
   isMessyCode_post_title1 = request.getAttribute("post_title") + "";
}
if(isMessyCode_post_title1 == null || isMessyCode_post_title1.equals("") || isMessyCode_post_title1.toUpperCase().equals("NULL")){
   isMessyCode_post_title1 = request.getSession().getAttribute("post_title") + "";}
isMessyCode_post_title1 = isMessyCode_post_title1!=null?new String(isMessyCode_post_title1.getBytes("ISO-8859-1"),"gb2312"):"";

if(CommonTools.isMessyCode(post_title)){
	if(!CommonTools.isMessyCode(isMessyCode_post_title)){
		request.setAttribute("post_title",isMessyCode_post_title);
	}
	else if(!CommonTools.isMessyCode(isMessyCode_post_title1)){
		request.setAttribute("post_title",isMessyCode_post_title1);
	}
	
}else{
	
	request.setAttribute("post_title",post_title);
}
%>

<e:switch value="${param.eaction}">
	<e:case value="list">
		<c:tablequery>
			<e:sql name="frame.notice.list"/>
		</c:tablequery>
	</e:case>
	<e:case value="add">
		<e:q4o var="seqObj" sql="frame.notice.nextvalForE_ln_seq"/>
		<e:set var="post_id" value="${seqObj.POSTID}"></e:set>
		<e:set var="post_role_java" value="${e:json2java(param.post_role)}"></e:set>
		<e:update transaction="true" sql="frame.notice.add"/>
	</e:case>
	<e:case value="edit">
		<e:set var="post_role_java" value="${e:json2java(param.post_role)}"></e:set>
		<e:update transaction="true" sql="frame.notice.edit"/>
	</e:case>
	<e:case value="delete">
		<e:update var="del_res" transaction="true" sql="frame.notice.delete"/>${del_res }
	</e:case>
	<e:case value="message">
		<e:q4o var="post" sql="frame.notice.post"/>${e:java2json(post) }
	</e:case>
	<e:case value="day_notice">
		<e:q4o var="notice_cc">
			<e:if condition="${DBSource=='oracle' }">
			select t1.POST_ID
			  from E_post t1, E_user t2
			 where t1.user_id = t2.user_id(+)
			   and t1.POST_STATE='1' 
			   and to_char(sysdate, 'yyyymmdd') between to_char(begin_date, 'yyyymmdd') and to_char(end_date, 'yyyymmdd')
			   and t1.post_id in (select a1.post_id from E_post_role a1, E_user_role a2 where a1.role_code = a2.role_code and a2.user_id = '${sessionScope.UserInfo.USER_ID}')
			 order by t1.issue_date desc
			</e:if>
			<e:if condition="${DBSource=='mysql' }">
				select t1.POST_ID
			  from E_post t1 left join  E_user t2
				on t1.user_id = t2.user_id
			   where date_format(now(), '%Y%m%d') between date_format(begin_date, '%Y%m%d') and date_format(end_date, '%Y%m%d')
			   and t1.POST_STATE='1' 
			   and t1.post_id in (select a1.post_id from E_post_role a1, E_user_role a2 where a1.role_code = a2.role_code and a2.user_id = '${sessionScope.UserInfo.USER_ID}')
			 order by t1.issue_date desc
			</e:if>
		</e:q4o>
		   <e:if condition="${notice_cc!=null && notice_cc !=''}">
		   ${notice_cc.POST_ID}
		   </e:if>
		   <e:if condition="${notice_cc==null || notice_cc ==''}">
		   0
		   </e:if>
	</e:case>
	<e:case value="content">
		<e:q4o var="post">
		<e:if condition="${DBSource=='oracle' }">
			select t1.post_title TITLE,
				   t1.POST_ID,
			       to_char(t1.begin_date, 'yyyy-mm-dd') BEGIN_DATE,
			       t1.post_content CC,
			       t1.USER_ID,
			       t2.USER_NAME
			  from E_post t1,e_user t2
			 where t1.user_id=t2.user_id(+)
			   and t1.post_id = #post_id#
		</e:if>
		<e:if condition="${DBSource=='mysql' }">
		select * from (
			select t1.post_title TITLE,
			       t1.POST_ID,
			       date_format(t1.BEGIN_DATE,'%Y%m%d') BEGIN_DATE,
			       t1.post_content CC,
			       t1.USER_ID,
			       t2.USER_NAME
			  from E_post t1 left join e_user t2
			 on t1.user_id=t2.user_id
			   where t1.post_id = #post_id#
			   )
		</e:if>
		</e:q4o>
		${e:toString(post.CC) }
	</e:case>
</e:switch>