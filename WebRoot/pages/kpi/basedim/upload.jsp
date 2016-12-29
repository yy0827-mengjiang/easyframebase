<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>  
<%@ page import="java.util.*,cn.com.easy.kpi.baseKpi.service.FileUploadUtil"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>  
<%   
	Map parameter = new HashMap();
	FileUploadUtil fileUploadUtil = new FileUploadUtil();
	boolean flag = fileUploadUtil.fileUpload(request,parameter);
	request.setAttribute("flag", flag);
	request.setAttribute("parameter", parameter);
	
%>
<e:switch value="${parameter['operation'] }">
	<e:case value="insert">
		<e:q4o var="id">
			SELECT X_KPI_INFO_SEQ.NEXTVAL nextVal FROM DUAL
		</e:q4o>
		<e:update var="isUpdate">
			begin
				INSERT INTO X_BASEDIM_INFO
					  (ID,
					   DIM_CODE,
					   DIM_NAME,
					   DIM_OWNER,
					   DIM_TABLE,
					   DIM_FIELD,
					   CONF_TYPE,
					   CONDITION,
					   DIM_AUTHOR,
					   DIM_DEPT,
					   DIM_SOURCE,
					   SRC_ONWER,
		       		   SRC_TABLE,
		       		   SQL_CODE,
					   STATUS,
					   CREATE_USER,
					   CREATE_DATETIME,
					   CATEGORY,
					   EXPLAIN,
					   DATASOURCE,
					   DIM_TYPE,
					   DIM_ATTR,
					   ACCOUNT_TYPE
					   )VALUES(
					  	${id.nextVal },
					  	'${parameter["base_key"] }',
					  	'${parameter["dim_name"] }',
					  	'',
					  	'',
					  	'${parameter["dim_tab"] }',
					  	'${parameter["conf_set"] }',
					  	'${parameter["conds"] }',
					  	'${parameter["dim_author"] }',
					  	'${parameter["dim_dept"] }',
					  	'',
					  	'${parameter["src_onwer"] }',
					  	'${parameter["src_table"] }',
					  	'${parameter["sql_code"] }',
					  	'${parameter["dim_status"] }',
					  	'${UserInfo.USER_ID }',
					  	SYSDATE,
					  	'${parameter["parentId"] }',
					  	'${parameter["explain"] }',
					  	'${parameter["database_name"] }',
					  	'${parameter["dim_type"] }',
					  	'${parameter["dim_attr"] }',
					  	'${parameter["ACCOUNT_TYPE"] }'
					   );
			<e:if condition="${''!=code }">
				INSERT INTO X_SUB_BASEDIM_INFO(DIM_ID,NAME,CODE) VALUES (${id.nextVal },'code','${parameter["code"] }');
			</e:if>
			<e:if condition="${''!=name }">
				INSERT INTO X_SUB_BASEDIM_INFO(DIM_ID,NAME,CODE) VALUES (${id.nextVal },'name','${parameter["name"] }');
			</e:if>
			<e:if condition="${''!=ails }">
				INSERT INTO X_SUB_BASEDIM_INFO(DIM_ID,NAME,CODE) VALUES (${id.nextVal },'ails','${parameter["ails"] }');
			</e:if>
			end;
		</e:update>
		<%
			Integer cou = (Integer)pageContext.getAttribute("isUpdate");
			if (cou > 0) {
				out.println("<script type='text/javascript'>parent.callback('基础维度创成功','1');</script>");
			} else {
				out.println("<script type='text/javascript'>parent.callback('基础维度创失败','0');</script>");
			}
		%>
	</e:case>
	<e:case value="update">
		<e:update var="isUpdate">
		begin
		update X_BASEDIM_INFO t
		   set t.dim_name = '${parameter["dim_name"] }',
		       t.dim_owner = '',
		       t.dim_table = '',
		       t.dim_field = '${parameter["dim_tab"] }',
		       t.conf_type = '${parameter["conf_set"] }',
		       t.condition = '${parameter["conds"] }',
		       t.dim_author = '${parameter["dim_author"] }',
		       t.dim_dept = '${parameter["dim_dept"] }',
		       t.dim_source = '',
		       t.src_onwer = '${parameter["src_onwer"] }',
		       t.src_table = '${parameter["src_table"] }',
		       t.sql_code = '${parameter["sql_code"] }',
		       t.status = '${parameter["dim_status"] }',
		       t.update_user = '${UserInfo.USER_ID }',
		       t.update_datetime = SYSDATE,
		       t.category = '${parameter["parentId"] }',
		       t.explain = '${parameter["explain"] }',
		       t.DATASOURCE = '${parameter["database_name"] }',
			   t.DIM_TYPE ='${parameter["dim_type"] }',
			   t.DIM_ATTR = '${parameter["dim_attr"] }',
			   t.ACCOUNT_TYPE = '${parameter["account_type"] }'
		where t.id='${parameter["dim_id"] }';
			<e:if condition="${''!=code }">
				update X_SUB_BASEDIM_INFO t set t.code='${parameter["code"] }' where t.dim_id='${parameter["dim_id"] }' and t.name='code';
			</e:if>
			<e:if condition="${''!=name }">
				update X_SUB_BASEDIM_INFO t set t.code='${parameter["name"] }' where t.dim_id='${parameter["dim_id"] }' and  t.name='name';
			</e:if>
			<e:if condition="${''!=ails }">
				update X_SUB_BASEDIM_INFO t set t.code='${parameter["ails"] }' where t.dim_id='${parameter["dim_id"] }' and  t.name='ails';
			</e:if>
		end;
		</e:update>
		<%
			Integer cou = (Integer)pageContext.getAttribute("isUpdate");
			if (cou > 0) {
				out.println("<script type='text/javascript'>parent.callback('基础维度修改成功','1');</script>");
			} else {
				out.println("<script type='text/javascript'>parent.callback('基础维度修改失败','0');</script>");
			}
		%>
	</e:case>
</e:switch>
