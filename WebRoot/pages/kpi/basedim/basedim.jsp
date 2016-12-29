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

<e:q4o var="time">
	select to_char(CURRENT_TIMESTAMP,'yyyyMMddHH24mmssSSS') code from dual
</e:q4o>
<e:set var="code">
	${time.code }
</e:set>
<!DOCTYPE>
<html>
<head>
<title>基础维度baseDim.jsp</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<e:service />
<script type="text/javascript"
	src="<e:url value='/pages/kpi/basedim/basedim.js'/>"></script>
<script type="text/javascript">
	$(function() {
		dimType();
		automatic();
		onDataSource('${dataSourceName}');
	});
	function callback(msg,flag)   
	{   
		$.messager.alert('提示信息！', msg, 'info',function(){
			if(flag!="1"){
				return false;
			}else{
				 window.location.href='../../../pages/kpi/kpiManager/baseManager.jsp?account_type=${param.account_type}';

			}
		});
	}   
</script>
</head>

<body>
<form action="upload.jsp?eaction=saveDim" method="post" id="dimForm" enctype="multipart/form-data" target="hidden_frame">
<div class="kpi_guide">
	<div class="editBase_div">
	
	<div class="editBase_div_child">
		<dl>
<!-- 			<dt>维度编码：</dt> -->
			<dd>
				<input type="hidden" name="isPublish" id="isPublish" value="true">
				<input type="hidden" name="operation" id="operation" value="insert">
				<input type="hidden" name="baseType" id="baseType" value="2">
				<input type="hidden" name="account_type" id="account_type" value="${param.account_type}"/>
				<input type="hidden" name="parentId" id="parentId" value="${param.parentId }">
				<input type="hidden" id="base_key" name="base_key" value="BD_${code }"
					readonly="readonly">
			</dd>
			<dt>维度名称：</dt>
			<dd>
				<input type="text" id="dim_name" name="dim_name" onblur="validName()">
				<input type="hidden" id="dim_status" name="dim_status">
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
				<input type="text" id="dim_tab" name="dim_tab">
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
				<input type="radio" id="dim_type1" name="dim_type" value="1" checked="checked" onclick="dimType()">维度 
				<input type="radio" id="dim_type2" name="dim_type" value="0" onclick="dimType()">属性
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
					<input type="radio" id="rauto" name="conf_set" value="0" onclick="automatic()" checked="checked">自动 
					<input type="radio" id="rmanual" name="conf_set" value="1" onclick="automatic()">手动
				</dd>
			</dl>
			<div id="auto">
				<dl class="ddLine">
					<dt>使用码表：</dt>
					<dd>
						<input type="text" id="src_tab" name="src_tab" value="用户名.表名"
							onclick="if(value==defaultValue){value='';this.style.color='#000'}"
							onBlur="srcTab()"
							style="color:#999"  >
						<input type="hidden" id="src_onwer" name="src_onwer">
						<input type="hidden" id="src_table" name="src_table">
					</dd>
				</dl>
			</div>
			<div id="manual">
				<dl class="ddLine">
					<dt>SQL语句：</dt>
					<dd>
						<input type="text" id="sql_code" name="sql_code" value="select * from table..." onclick="if(value==defaultValue){value='';this.style.color='#000'}"
							onBlur="if(!value){value=defaultValue;this.style.color='#999'}else{doSearchSql();}" style="color:#999" >
					</dd>
				</dl>
			</div>
				<table id="dim_code" class="formular_table" cellpadding="0" cellspacing="1">
					<tr>
						<th width="40%">别名</th>
						<th>字段</th>
					</tr>
					<tr>
						<td>编码</td>
						<td><select id="code" name="code" class="long_select"><option value=" ">请选择</option></select></td>
					</tr>
					<tr>
						<td>名称</td>
						<td><select id="name" name="name" class="long_select"><option value=" ">请选择</option></select></td>
					</tr>
					<tr>
						<td>排序</td>
						<td><select id="ails" name="ails" class="long_select"><option value=" ">请选择</option></select></td>
					</tr>
				</table>
			 <div id="auto2">
				<dl class="ddLine">
					<dt>查询条件：</dt>
					<dd>
						<textarea rows="3" cols="10" id="conds" name="conds"></textarea>
					</dd>
				</dl>
			</div>
		</div>
		<dl>
			<dt>提出者：</dt>
			<dd>
				<input type="text" id="dim_author" name="dim_author">
			</dd>

			<dt>提出部门：</dt>
			<dd>
				<input type="text" id="dim_dept" name="dim_dept">
			</dd>
		</dl>
		<dl class="ddLine">
			<dt>需求来源：</dt>
			<dd>
				<textarea rows="3" cols="10" id="explain" name="explain"></textarea><br>
				<input type="file" id="upload_file_name" name="upload_file_name">
			</dd>
		</dl>
		<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>
	</div>   
	</form>
	<dl class="btn_div">
		<!-- <button id="" onclick="saved('0')">保存草稿</button> -->
		<button id="" onclick="saved('1')">提交版本</button>
		<button id="" onclick="closeDim()">关闭</button>
	</dl>
	</div>
</div>
</form>
</body>
</html>
