<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.web.util.*" %>
<%@page import="cn.com.easy.xbuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%
	String parentKey = request.getParameter("PARENT_KEY") != null ? new String(request.getParameter("PARENT_KEY").getBytes("ISO-8859-1"), "UTF-8") : "";
	String parentKey_gbk = request.getParameter("PARENT_KEY") != null ? new String(request.getParameter("PARENT_KEY").getBytes("ISO-8859-1"), "gb2312") : "";
	if (!CommonTools.isMessyCode(parentKey)) {
		request.setAttribute("PARENT_KEY", parentKey);
	} else if (!CommonTools.isMessyCode(parentKey_gbk)) {
		request.setAttribute("PARENT_KEY", parentKey_gbk);
	}
	String code_sql = request.getParameter("CODE_SQL");
	String sql = "";
	if(code_sql !=null){
		sql = new String(org.apache.commons.codec.binary.Base64.decodeBase64(request.getParameter("CODE_SQL")), "UTF-8");
		//System.out.println("SQL===>>>>"+sql);
		//sql = CommonTools.getDimSqlFina(sql,request);
	}
	
	String multiple = "" + request.getParameter("multiple");
	String parent_key = "" + request.getParameter("PARENT_KEY");
	
	/*if(multiple !=null && (multiple.equals("true") || multiple.equals("1"))){*/
		String parent_keyArray[] = parent_key.split(",");
		StringBuffer parent_key_tmp = new StringBuffer();
		parent_key = "'" + parent_key + "'";
		for (int i = 0; i < parent_keyArray.length; i++) {
			if (parent_keyArray[i].trim().equals("") || parent_keyArray[i].trim().toLowerCase().equals("null")) {
				continue;
			}
			parent_key_tmp.append(",'" + parent_keyArray[i].trim() + "'");
			if(parent_key_tmp != null && parent_key_tmp.length() > 1){
				parent_key = parent_key_tmp.toString().substring(1, parent_key_tmp.length());
			}
		}
	/*} else {
		//parent_key = "'" + parent_key + "'";
	}*/
	
%>
<e:switch value="${param.eaction}">
	<e:case value="extCascade">
		<e:if condition="${param.DATABASE_NAME!=null && param.DATABASE_NAME ne '' && e:trim(param.DATABASE_NAME) ne '' && e:trim(e:toLowerCase(param.DATABASE_NAME)) ne 'null'&& e:trim(e:toLowerCase(param.DATABASE_NAME)) ne 'undefined'}" var = "selectifa">
			<e:q4l var="extData" extds="${param.DATABASE_NAME}">
				<e:if condition="${param.CODE_SQL !=null && param.CODE_SQL ne '' && param.CODE_SQL ne 'undefined' }" var = "cconn">
				select CODE,CODEDESC from (
					select 'qing_xuan_zhe' CODE,'-请选择-' CODEDESC from dual union all
					select to_char(code) CODE,to_char(codedesc) CODEDESC from (<%=sql%>) inits
					<e:if condition="${param.DIM_LVL!=null&&param.DIM_LVL ne '' &&param.DIM_LVL ne'0'}"> 
						where PARENT_COL in(<%=parent_key%>)
					</e:if>
				) bb order by CODE desc  
				</e:if>
				<e:else condition="${cconn}">
					select CODE,CODEDESC from (
					select 'qing_xuan_zhe' CODE,'-请选择-' CODEDESC <e:if condition="${param.CODE_ORD!=null&&param.CODE_ORD!=''}"> 
					  ,'-1' ord </e:if> from dual union all
					select  ${param.CODE_KEY} CODE,${param.CODE_DESC} CODEDESC <e:if condition="${param.CODE_ORD!=null&&param.CODE_ORD!=''}"> 
					  ,${param.CODE_ORD} ord
					</e:if> from ${param.CODE_TABLE} 
					<e:if condition="${param.CODE_PARENT_KEY!=null&&param.CODE_PARENT_KEY ne '' &&param.CODE_PARENT_KEY!='0'}"> 
					where ${param.CODE_PARENT_KEY} in(<%=parent_key%>)
					</e:if>
					
					group by ${param.CODE_KEY},${param.CODE_DESC}
					<e:if condition="${param.CODE_ORD!=null&&param.CODE_ORD!=''}"> 
					  ,${param.CODE_ORD} 
					</e:if>
					
					<e:if condition="${param.CODE_ORD!=null&&param.CODE_ORD!=''}"> 
					 order by ord
					</e:if>
					) aa1 order by CODE desc  
				</e:else>
			</e:q4l>
		</e:if>
		<e:else condition="${selectifa}">
			<e:q4l var="extData">
				<e:if condition="${param.CODE_SQL !=null && param.CODE_SQL ne '' && param.CODE_SQL ne 'undefined' }" var = "cconn">
				select CODE,CODEDESC from (
					select 'qing_xuan_zhe' CODE,'-请选择-' CODEDESC from dual union all
					select code CODE,codedesc CODEDESC from (<%=sql%>) inits
					<e:if condition="${param.DIM_LVL!=null&&param.DIM_LVL ne '' &&param.DIM_LVL ne'0'}"> 
						where PARENT_COL in(<%=parent_key%>)
					</e:if>
				 ) bb order by CODE desc  
				</e:if>
				<e:else condition="${cconn}">
					select CODE,CODEDESC from (
					select 'qing_xuan_zhe' CODE,'-请选择-' CODEDESC <e:if condition="${param.CODE_ORD!=null&&param.CODE_ORD!=''}"> 
					  ,'-1' ord </e:if> from dual union all
					select   ${param.CODE_KEY} CODE,${param.CODE_DESC} CODEDESC <e:if condition="${param.CODE_ORD!=null&&param.CODE_ORD!=''}"> 
					  ,${param.CODE_ORD} ord
					</e:if> from ${param.CODE_TABLE} 
					
					<e:if condition="${param.CODE_PARENT_KEY!=null&&param.CODE_PARENT_KEY ne '' &&param.CODE_PARENT_KEY!='0'}"> 
					where ${param.CODE_PARENT_KEY} in(<%=parent_key%>)
					</e:if>
					
					group by 
					
					${param.CODE_KEY} ,${param.CODE_DESC}  <e:if condition="${param.CODE_ORD!=null&&param.CODE_ORD!=''}"> 
					  ,${param.CODE_ORD} 
					  </e:if>
					<e:if condition="${param.CODE_ORD!=null&&param.CODE_ORD!=''}"> 
					 order by ord
					</e:if>
					) aa2 order by CODE desc  
				</e:else>
			</e:q4l>
		</e:else>
		${e:replace(e:replace(e:replace(e:java2json(extData.list),"codedesc", "CODEDESC"),"code", "CODE"),"qing_xuan_zhe","")}
	</e:case>
</e:switch>