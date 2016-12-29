<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%

//String attr_name = request.getParameter("attr_name"); 
//attr_name = attr_name!=null?new String(request.getParameter("attr_name").getBytes("ISO-8859-1"),"GBK"):""; 
//request.setAttribute("attr_name",attr_name); 

String attr_name=request.getParameter("attr_name")==null?"":request.getParameter("attr_name");
String isMessyCode_attr_name = request.getParameter("attr_name");

if(isMessyCode_attr_name == null || isMessyCode_attr_name.equals("") || isMessyCode_attr_name.toUpperCase().equals("NULL")){
   isMessyCode_attr_name = request.getAttribute("attr_name") + "";
}
if(isMessyCode_attr_name == null || isMessyCode_attr_name.equals("") || isMessyCode_attr_name.toUpperCase().equals("NULL")){
   isMessyCode_attr_name = request.getSession().getAttribute("attr_name") + "";
}
isMessyCode_attr_name = isMessyCode_attr_name!=null?new String(isMessyCode_attr_name.getBytes("ISO-8859-1"),"UTF-8"):"";
String isMessyCode_attr_name1 = request.getParameter("attr_name");
if(isMessyCode_attr_name1 == null || isMessyCode_attr_name1.equals("") || isMessyCode_attr_name1.toUpperCase().equals("NULL")){
   isMessyCode_attr_name1 = request.getAttribute("attr_name") + "";
}
if(isMessyCode_attr_name1 == null || isMessyCode_attr_name1.equals("") || isMessyCode_attr_name1.toUpperCase().equals("NULL")){
   isMessyCode_attr_name1 = request.getSession().getAttribute("attr_name") + "";}
isMessyCode_attr_name1 = isMessyCode_attr_name1!=null?new String(isMessyCode_attr_name1.getBytes("ISO-8859-1"),"gb2312"):"";

if(CommonTools.isMessyCode(attr_name)){
	if(!CommonTools.isMessyCode(isMessyCode_attr_name)){
		request.setAttribute("attr_name",isMessyCode_attr_name);
	}
	else if(!CommonTools.isMessyCode(isMessyCode_attr_name1)){
		request.setAttribute("attr_name",isMessyCode_attr_name1);
	}
	
}else{
	
	request.setAttribute("attr_name",attr_name);
}
%>
<e:switch value="${param.eaction}">
	<e:case value="LIST">
		<c:tablequery>
			<e:sql name="frame.userext.list"/>
		</c:tablequery>
	</e:case>
	<e:case value="INSERT">
		<e:q4o var="maxExtColumnNum" >
			<e:sql name="frame.userext.maxExtColumnNum"/>
		</e:q4o>
		<e:update var="in_res" transaction="true" sql="frame.userext.add"></e:update>${in_res }
		<a:log pageUrl="pages/frame/portal/user/ext/ExtManager.jsp" operate="2" content="扩展属性管理>>添加新属性" result="${in_res }"/>
	</e:case>
	<e:case value="CUREXT">
		<e:q4o var="cur">
			select attr_code from e_user_attr_dim where attr_code=#extId#
		</e:q4o>${cur.attr_code }
	</e:case>
	<e:case value="DELETE">
		<e:q4o var="ExtColumnAttrRelObj">
			SELECT COLUMN_NAME FROM E_USER_EXT_COLUMN_ATTR WHERE ATTR_CODE=#attrCode#
		</e:q4o>
		<e:update var="res_del" transaction="true">
				delete from e_user_attr_dim where attr_code=#attrCode#;
				delete from E_USER_ATTRIBUTE where attr_code=#attrCode#;
				UPDATE E_USER SET ${ExtColumnAttrRelObj.COLUMN_NAME }=null;
				DELETE FROM E_USER_EXT_COLUMN_ATTR WHERE ATTR_CODE=#attrCode#;
		</e:update>${res_del }
		<a:log pageUrl="pages/frame/portal/user/ext/ExtManager.jsp" operate="4" content="扩展属性管理>>删除属性" result="${res_del }"/>
	</e:case>
	<e:case value="UPDATE">
		<e:update var="attr_res" sql="frame.userext.edit"></e:update>${attr_res }
		<a:log pageUrl="pages/frame/portal/user/ext/ExtManager.jsp" operate="3" content="扩展属性管理>>修改属性" result="${attr_res }"/>
	</e:case>
	<e:case value="CURATTR">
		<e:q4l var="cur_attr">
			select attr_code "attr_code",
		       parent_code "parent_code",
				attr_name         "attr_name",
				show_mode         "show_mode",
				model_desc        "model_desc",
				code_table        "code_table",
				code_key          "code_key",
				code_parent_key   "code_parent_key",
				code_desc         "code_desc",
				code_ord          "code_ord",
				data_type         "data_type",
				multi             "multi",
				attr_ord          "attr_ord",
				is_null           "is_null",
				default_value     "default_value",
				default_desc      "default_desc"
				from e_user_attr_dim d ,e_user_ext_model m
			where attr_code=#attrCode#
			and
			d.show_mode=m.model_code
		</e:q4l>${e:java2json(cur_attr.list) }
	</e:case>
	
	<e:case value="getHasSelectSubSystems">
		<c:tablequery>
			SELECT T.SUBSYSTEM_ID AS "SUBSYSTEM_ID",T.SUBSYSTEM_NAME AS "SUBSYSTEM_NAME"
			  FROM D_SUBSYSTEM T
			 WHERE EXISTS (SELECT 1
			          FROM E_USER_ATTR_SUBSYSTEM
			         WHERE SUBSYSTEM_ID = T.SUBSYSTEM_ID
			           AND ATTR_CODE = #attrCode#
			        )
			        <e:if condition="${param.id!=null&&param.id!=''}">
			            AND T.SUBSYSTEM_ID LIKE '%'||#id#||'%'
			        </e:if>
			        <e:if condition="${param.name!=null&&param.name!=''}">
			            AND T.SUBSYSTEM_NAME LIKE '%'||#name#||'%'
			        </e:if>
			  ORDER BY T.ORD
			
		</c:tablequery>
	</e:case>
	<e:case value="getNeedSelectSubSystems">
		<c:tablequery>
			SELECT T.SUBSYSTEM_ID as "SUBSYSTEM_ID",T.SUBSYSTEM_NAME as "SUBSYSTEM_NAME"
			  FROM D_SUBSYSTEM T
			 WHERE NOT EXISTS (SELECT 1
			          FROM E_USER_ATTR_SUBSYSTEM
			         WHERE SUBSYSTEM_ID = T.SUBSYSTEM_ID
			           AND ATTR_CODE = #attrCode#
			        )
			       <e:if condition="${param.id!=null&&param.id!=''}">
			            AND T.SUBSYSTEM_ID LIKE '%'||#id#||'%'
			        </e:if>
			        <e:if condition="${param.name!=null&&param.name!=''}">
			            AND T.SUBSYSTEM_NAME LIKE '%'||#name#||'%'
			        </e:if>
			  ORDER BY T.ORD
			
		</c:tablequery>
	</e:case>
	<e:case value="addSubSystem">
		<e:update var="insertSubSystem">
			INSERT INTO E_USER_ATTR_SUBSYSTEM(ATTR_CODE,SUBSYSTEM_ID) VALUES(#attrCode#,#subSystemId#)
		</e:update>${insertSubSystem }
	</e:case>
	<e:case value="removeSubSystem">
		<e:update var="deleteSubSystem">
			DELETE FROM E_USER_ATTR_SUBSYSTEM WHERE ATTR_CODE=#attrCode# AND SUBSYSTEM_ID=#subSystemId#
		</e:update>${deleteSubSystem }
	</e:case>
	
	
	
</e:switch>
		