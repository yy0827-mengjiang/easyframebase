<%@ page language="java" import="java.util.*,java.sql.*,java.text.*,cn.com.easy.core.*,cn.com.easy.taglib.function.*"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:if condition="${applicationScope['xdbauth'] == '1'}" var="dataSourceElse">
	<e:q4l var="db_name_list">
		SELECT distinct X.DB_ID, DB_NAME, DB_SOURCE ,x.ord
		    FROM X_EXT_DB_SOURCE  X,
		         X_DB_ACCOUNT  A
		    WHERE X.DB_ID=A.DB_ID
		      AND A.ACCOUNT_CODE in (
		          select ACCOUNT_CODE 
		             FROM E_USER_ACCOUNT
		           WHERE 
		               USER_ID = '${sessionScope.UserInfo.USER_ID}')
		       ORDER BY x.ord desc
 	</e:q4l>
</e:if>
<e:else condition="dataSourceElse">
 	<e:q4l var="db_name_list">
		SELECT  DB_ID, DB_NAME, DB_SOURCE FROM X_EXT_DB_SOURCE 
	</e:q4l>
</e:else>
<e:q4o var="base">
	select * from x_basedim_info t where t.id = ${param.ID }
</e:q4o>
<e:q4o var="dimFile">
	SELECT T.FILE_NAME FROM X_BASE_FILE_INFO T where t.type='2' and t.CODE = '${base.DIM_CODE }'
</e:q4o>
<e:q4o var="sub">
	select max(case t.name when cast('code' as nvarchar2(10)) then code end) as code,
       max(case t.name when cast('name' as nvarchar2(10)) then code end) as name,
       max(case t.name when cast('ails' as nvarchar2(10)) then code end) as ails
  from X_SUB_BASEDIM_INFO t
 where t.dim_id =${param.ID }

</e:q4o>
<!DOCTYPE>
<html>
<head>
<title>基础维度editBasedim.jsp</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<e:service />
<script type="text/javascript">
	$(function(){
		dimType();
		
		automatic();
		
		$("#database_name1").val('${base.DATASOURCE}');
		$("#dim_attr").val('${base.dim_attr}');
		$("#conds").val(utf8to16(base64decode('${base.CONDITION}')));
		
		if($('#dim_type1').attr('checked')){
			editDoSearch('${sub.CODE}','${sub.NAME}','${sub.AILS}');
		}
		
	});
	
	function callback(msg,flag)   
	{   
		$.messager.alert('提示信息！', msg, 'info',function(){
			if(flag!="1"){
				return false;
			}else{
				 window.location.href='../../../	pages/kpi/kpiManager/baseManager.jsp?account_type=${param.account_type}';
			}
		});
	}   
</script>
</head>

<body>
<div class="kpi_guide">
	<div class="editBase_div">
	<form action="upload.jsp?eaction=saveDim" method="post" id="dimForm" enctype="multipart/form-data" target="hidden_frame">
		<div class="editBase_div_child">
		<dl>
			<dt>维度编码：</dt>
			<dd>
				<input type="hidden" name="isPublish" id="isPublish" value="false">
				<input type="hidden" name=operation id="operation" value="update">
				<input type="hidden" name="baseType" id="baseType" value="2">
				<input type="hidden" name="parentId" id="parentId" value="${base.CATEGORY }">
				<input type="hidden" name="account_type" id="account_type" value="${base.ACCOUNT_TYPE}">
				<input type="hidden" name="dim_id" id="dim_id" value="${base.ID }">
				<input type="text" id="base_key" name="base_key" value="${base.DIM_CODE }"
					readonly="readonly">
			</dd>
			<dt>维度名称：</dt>
			<dd>
				<input type="text" id="dim_name" name="dim_name" onblur="validName()" value="${base.DIM_NAME }">
				<input type="hidden" id="dim_status" name="dim_status" value="${base.DIM_STATUS }">
			</dd>
		</dl>
		<dl>
			<dt>数据源：</dt>
			<dd>
				<select id="database_name1" name="database_name" style="width: 97%; height:26px;">
					<option value = "">--请选择--</option>
				    <e:forEach items="${db_name_list.list}" var="ds">
		                 <option value ="${ds.DB_SOURCE}">${ds.DB_NAME}</option>	
		            </e:forEach>	
				</select>
			</dd>
			<dt>维度字段：</dt>
			<dd>
				<input type="text" id="dim_tab" name="dim_tab" value="${base.DIM_FIELD }"  >
				<input type="hidden" id="dim_onwer" name="dim_onwer">
				<input type="hidden" id="dim_table" name="dim_table">
				<input type="hidden" id="dim_field" name="dim_field">
			</dd>
		</dl>
		<dl>
			<dt>
				维度类型：
			</dt>
			<dd>
				<e:if condition="${base.DIM_TYPE eq	'1' }">
				<input type="radio" id="dim_type1" name="dim_type" value="1" checked="checked" onclick="dimType()">维度 
				<input type="radio" id="dim_type2" name="dim_type" value="0" onclick="dimType()">属性
				</e:if>
				<e:if condition="${base.DIM_TYPE eq	'0' }">
				<input type="radio" id="dim_type1" name="dim_type" value="1" checked="checked" onclick="dimType()">维度 
				<input type="radio" id="dim_type2" name="dim_type" value="0" onclick="dimType()" checked="checked">属性
				</e:if>
			</dd>
			<dt>
				维度属性：
			</dt>
			<dd>
				<select id="dim_attr" name="dim_attr">
					<option value="R">公共维度
					<option value="D">日维度
					<option value="M">月维度
				</select>
			</dd>
		</dl>
		<div id="dimType">
			<dl class="ddLine">
				<dt>码表配置：</dt>
				<dd>
					<e:if condition="${base.CONF_TYPE eq '0'}">
						<input type="radio" id="rauto" name="conf_set" value="0" onclick="automatic()" checked="checked">自动 
						<input type="radio" id="rmanual" name="conf_set" value="1" onclick="automatic()">手动
					</e:if>
					<e:if condition="${base.CONF_TYPE eq '1' }">
						<input type="radio" id="rauto" name="conf_set" value="0" onclick="automatic()">自动 
						<input type="radio" id="rmanual" name="conf_set" value="1" onclick="automatic()" checked="checked">手动
					</e:if>
				</dd>
			</dl>
			<div id="auto">
				<dl class="ddLine">
					<dt>使用码表：</dt>
					<dd>
						<input type="text" id="src_tab" name="src_tab" value="${base.SRC_ONWER }.${base.SRC_TABLE }"
							onBlur="srcTab()" >
						<input type="hidden" id="src_onwer" name="src_onwer" value="${base.SRC_ONWER }">
						<input type="hidden" id="src_table" name="src_table" value="${base.SRC_TABLE }">
					</dd>
				</dl>
			</div>
			<div id="manual">
			<dl class="ddLine">
				<dt>SQL语句：</dt>
				<dd>
					<e:if condition="${'' eq base.SQL_CODE}">
						<input type="text" id="sql_code" name="sql_code" value="select * from table..." onclick="if(value==defaultValue){value='';this.style.color='#000'}"
								onBlur="if(!value){value=defaultValue;this.style.color='#999'}else{doSearchSql();}" style="color:#999" >
					</e:if>
					<e:if condition="${'' ne base.SQL_CODE}">
						<input type="text" id="sql_code" name="sql_code" value="${base.SQL_CODE}" onclick="if(value==defaultValue){value='';this.style.color='#000'}"
								onBlur="if(!value){value=defaultValue;}else{doSearchSql();}">
					</e:if>
				</dd>
			</dl>
			</div>
				<table id="dim_code" class="formular_table" cellpadding="0" cellspacing="1">
					<tr>
						<th width="40%">别名</td>
						<th>字段</th>
					</tr>
					<tr>
						<td>编码</td>
						<td><select id="code" name="code"><option value="">请选择</option></select></td>
					</tr>
					<tr>
						<td>名称</td>
						<td><select id="name" name="name"><option value="">请选择</option></select></td>
					</tr>
					<tr>
						<td>排序</td>
						<td><select id="ails" name="ails"><option value="">请选择</option></select></td>
					</tr>
				</table>
			 <div id="auto2">
				<dl class="ddLine">
					<dt>查询条件：</dt>
					<dd>
						<textarea rows="3" cols="10" id="conds" name="conds">${base.CONDITION }</textarea>
					</dd>
				</dl>
			</div>
		</div>
		<dl>
			<dt>提出者：</dt>
			<dd>
				<input type="text" id="dim_author" name="dim_author" value="${base.DIM_AUTHOR }">
			</dd>

			<dt>提出部门：</dt>
			<dd>
				<input type="text" id="dim_dept" name="dim_dept"  value="${base.DIM_DEPT }">
			</dd>
		</dl>
		<dl class="ddLine">
			<dt>需求来源：</dt>
			<dd>
				<textarea rows="3" cols="10" id="explain" name="explain">${base.EXPLAIN }</textarea><br>
				<a>${dimFile.FILE_NAME }</a><br>
				<input type="file" id="upload_file_name" name="upload_file_name" >
			</dd>
		</dl>
		<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>   
	</form>
	</div>
	<dl class="btn_div">
		<!-- <button id="" onclick="saved('0')">保存草稿</button> -->
		<button id="" onclick="update('1')">提交版本</button>
		<button id="" onclick="closeDim()">关闭</button>
	</dl>
	</div>
	</div>
</body>
</html>
