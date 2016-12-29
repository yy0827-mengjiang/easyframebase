<%@ page language="java" import="java.util.*"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="dimObj" sql="kpi.dim.dimObj"/>
<e:q4l var="dimList" sql="kpi.dim.dimList"/>
<e:q4l var="dimCategoryList" sql="kpi.dim.dimCategoryList"/>
<e:q4l var="selValObj" sql="kpi.dim.selValObj"/> 
<!DOCTYPE>
<html>
<head>
<title>纬度新增</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta name="renderer" content="webkit"/> 
<meta http-equiv = "X-UA-Compatible" content = "IE=edge,chrome=1" /> 
<c:resources type="easyui"  style="${ThemeStyle }"/>
<e:style value="/resources/themes/base/boncBase@links.css"/>
<e:style value="/resources/themes/blue/boncBlue.css"/>
<e:style value="/resources/easyResources/component/easyui/icon.css" />
<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" /> 
<e:style value="/pages/xbuilder/resources/component/icheck/icheck.css"/>
<e:script value="/pages/xbuilder/resources/component/icheck/icheck.min.js"/>
<script type="text/javascript">
$(function() {
	$('input.checkN').iCheck({
	    labelHover : false,
	    cursor : true,
	    checkboxClass : 'icheckbox_square-blue',
	    radioClass : 'iradio_square-blue',
	    increaseArea : '20%'
	}).on('ifClicked', function(event){
		var tagName = $(this).attr("name");
		if(tagName == "conf_set") {
			automatic($(this).attr("value"));
		} else if (tagName == "dim_type") {
			isDate($(this).attr("value"));
		}
	});
	var browser_width;
	browser_width = $(".kpi_guide").eq(0).width();
	$('.tit_div1').css({'width':browser_width,'left':'10px' });
	$(window).resize(function() { 
			$('.tit_div1').css({'width':browser_width,'left':'10px' });
	}); 
	 var conf_type='${dimObj.CONF_TYPE}';
	 var dim_default='${dimObj.DIM_DEFAULT}';
	 var dim_type = '${dimObj.DIM_TYPE}';
	 if(dim_default == '0') {
		 $("#dim_default1").iCheck('check'); 
	 } else {
		 $("#dim_default2").iCheck('check'); 
	 }
	 if(dim_type == 'T'){
		 $("#dim_type1").iCheck('check'); 
		 $("#isDate").show();
	 } else if (dim_type == 'D'){
		 $("#dim_type2").iCheck('check'); 
		 $("#isDate").hide();
	 } else{
		 $("#dim_type3").iCheck('check'); 
		 $("#isDate").hide();
	 }
	 if(conf_type=='1'){
		 $("#rauto").iCheck('check'); 
		 $("#src_tab").val('${dimObj.CODE_TABLE}');
	 }else if(conf_type =='2'){
		 $("#rmanual").iCheck('check'); 
		 $("#sql_code").val('${dimObj.CODE_TABLE}');
	 }
	 automatic('${dimObj.CONF_TYPE}');
	 isDate('${dimObj.DIM_TYPE}');
	 $("#dim_level").val('${dimObj.DIM_LEVEL}');
	 $("#dim_right").val('${dimObj.DIM_RIGHT}');
	 $("#dim_category").val('${dimObj.DIM_CATEGORY}');
});
function isDate(value) {
	if(value == "D" || value == "M") {
		$("#isDate").hide();
	} else {
		$("#isDate").show();
	}
}
	function automatic(value){
		if (value == "2") {
			$('#auto').hide();
			$('#auto2').hide();
			$('#manual').show();
			$('#src_tab').val('');
			$('#conds').val('');
		} else {
			$('#auto').show();
			$('#auto2').show();
			$('#manual').hide();
			$('#sql_code').val('');
		}
	}
	
	function closeDim(){
		window.location.href='<e:url value="/pages/kpi/basedim/dimManager.jsp"/>';
	}
	function save(){
		var info={};
		info.dim_code=$("#dim_code").val(); 
		info.conf_type=$("input[name=conf_set]:checked").val();
		info.code_table=$("#src_tab").val()+$("#sql_code").val();
		info.code_table_desc=$("#code_table_desc").val();
		info.column_code=$("#column_code").val();
		info.column_desc=$("#column_desc").val();
		info.column_ord=$("#column_ord").val();
		info.column_parent=$("#column_parent").val();
		info.condition=$("#condition").val();
		info.dim_parent_code=$("#dim_parent_code").val();
		info.dim_level=$("#dim_level").val();
		info.dim_default =$("input[name=dim_default]:checked").val();
		info.dim_right=$("#dim_right").val();
		info.dim_type=$("input[name=dim_type]:checked").val();
		info.dim_category=$("#dim_category").val();
		//alert($.toJSON(info));
		if(validate()){
			$.messager.confirm('请确认','您确定要修改当前维度信息吗?',function(msg){
				if(msg) {
					$.post('<e:url value="/pages/kpi/basedim/dimAction.jsp?eaction=editDim"/>',info, function(data){
			            var temp = $.trim(data);
			           // alert(temp);
			            if(temp=='1'){
			            	$.messager.alert("信息","维度信息修改成功！","info",function(){
				            	window.location.href='<e:url value="/pages/kpi/basedim/dimManager.jsp"/>';
			            	});
			            }else{
			            	$.messager.alert("信息","维度信息修改失败!","error");
			            }
					});
				}
			});
		}
	}
	
	function validate(){
		var dim_type=$("input[name=dim_type]:checked").val();
		if($("#dim_code").val() == '' || $("#dim_code").val() == null){
			$.messager.alert("信息","纬度编码不能为空","error");
			return false;
		}else if($("#code_table_desc").val() == '' || $("#code_table_desc").val() == null){
			$.messager.alert("信息","维度名称不能为空","error");
			return false;
		}else if ($("#dim_category").val() == null || $("#dim_category").val() == ""){
			$.messager.alert("信息","维度分类不能为空","error");
			return false;
		}
		if(dim_type =="T") {
			if($("input[name=conf_set]:checked").val() == "1" && ($("#src_tab").val() == '' || $("#src_tab").val() == null)){
				$.messager.alert("信息","表名不能为空","error");
				return false;
			}else if($("input[name=conf_set]:checked").val() == "2" && ($("#sql_code").val() == '' || $("#sql_code").val() == null)){
				$.messager.alert("信息","SQL语句不能为空","error");
				return false;
			}else if($("#column_code").val() == '' || $("#column_code").val() == null){
				$.messager.alert("信息","编码字段列不能为空","error");
				return false;
			}else if($("#column_desc").val() == '' || $("#column_desc").val() == null){
				$.messager.alert("信息","描述字段列不能为空","error");
				return false;
			}else if($("#column_ord").val() == '' || $("#column_ord").val() == null){
				$.messager.alert("信息","排序字段列不能为空","error");
				return false;
			}else if($("#dim_parent_code").val() != "") {
				if($("#dim_level").val() == null || $("#dim_level").val() == "") {
					$.messager.alert("信息","联动级别不能为空","error");
					return false;
				}
			}
		} 
		return true;
	}
</script>
</head>

<body>
<input type="hidden" id="dim_code" name="dim_code" value="${param.dim_code }" readonly="true"/>
<div class="kpi_guide">
	<div class="tit_div1">
		<h3>维度信息</h3>
		<span>
				<button id="" onclick="save()">确定</button>
				<button id="" onclick="closeDim()">关闭</button>
<!-- 			<button id="" onclick="javascript:$('#downloadExcel_D').submit();">下载Excel模版</button> -->
		</span>
	</div>
	<div class="editBase_div1">
	<div class="editBase_div_child1">
		<div id="dimType">
			<dl class="fourD">
				<dt>维度名称：</dt>
				<dd>
					<input type="text" id="code_table_desc" name="ode_table_desc" class='easyui-validatebox textbox' data-options="required:true" value='${dimObj.CODE_TABLE_DESC}' />
				</dd>
				<dt>配置方式：</dt>
				<dd>
					<input type="radio" class="checkN" id="rauto" name="conf_set" value="1"  checked="checked">配置型 
					<input type="radio" class="checkN" id="rmanual" name="conf_set" value="2" >SQL型
				</dd>
			</dl>
			<dl class="fourD">
				<dt>维度类型：</dt>
				<dd>
					<input type="radio" class="checkN" id="dim_type1" name="dim_type" value="T"  checked="checked">&nbsp;通用 &nbsp;&nbsp;
					<input type="radio" class="checkN" id="dim_type2" name="dim_type" value="D" >&nbsp;日期	&nbsp;&nbsp;		
					<input type="radio" class="checkN" id="dim_type3" name="dim_type" value="M" >&nbsp;月份				
					</dd>
				<dt>维度分类：</dt>
				<dd>
				<select id="dim_category"  name="dim_category">
					<option value="">--请选择--</option>
					<e:forEach items="${dimCategoryList.list }" var="category">
						<option value="${category.CATEGORY_ID}">${category.CATEGORY_NAME}</option>
					</e:forEach>
				</select>
				</dd>
			</dl>
			<dl class="fourD">
				<dt>默认查询条件：</dt>
				<dd>
					<input type="radio" class="checkN" id="dim_default1" name="dim_default" value="0"  checked="checked">&nbsp;否 &nbsp;&nbsp;
					<input type="radio" class="checkN" id="dim_default2" name="dim_default" value="1" >&nbsp;是
				</dd>
				<dt>默认数据权限：</dt>
				<dd>
					<select id="dim_right" name="dim_right" >
						<option value="">--请选择--</option>
						<e:forEach items="${selValObj.list}" var="ds">
			                 <option value ="${ds.ATTR_CODE}">${ds.ATTR_NAME}</option>	
			            </e:forEach>
					</select>
				</dd>
			</dl>
			<div id="isDate">
			<div id="auto">
				<dl class="ddLine">
					<dt>使用码表：</dt>
					<dd>
						<input type="text" id="src_tab" name="src_tab"  placeholder="用户名.表名"
							style="color:#999"  class='easyui-validatebox textbox' data-options="required:true"/>
					</dd>
				</dl>
			</div>
			<div id="manual">
				<dl class="ddLine">
					<dt>SQL语句：</dt>
					<dd>
						<input type="text" id="sql_code" name="sql_code" placeholder="select * from table..." style="color:#999" class='easyui-validatebox textbox' data-options="required:true" />
					</dd>
				</dl>
			</div>
		<dl class="fourD">
			<dt>
				编码字段列：
			</dt>
			<dd>
				<input type="text" id="column_code" name="column_code" class='easyui-validatebox textbox' data-options="required:true" value='${dimObj.COLUMN_CODE}' />
			</dd>
			<dt>
				描述字段列：
			</dt>
			<dd>
				<input type="text" id="column_desc" name="column_desc" class='easyui-validatebox textbox' data-options="required:true" value='${dimObj.COLUMN_DESC}' />
			</dd>
		</dl>
		<dl class="fourD">
			<dt>
				排序字段列：
			</dt>
			<dd>
				<input type="text" id="column_ord" name="column_ord" class='easyui-validatebox textbox' data-options="required:true" value='${dimObj.COLUMN_ORD}'/>
			</dd>
			<dt>
				上级编码字段列：
			</dt>
			<dd>
				<input type="text" id="column_parent" name="column_parent" value='${dimObj.COLUMN_PARENT}'>
			</dd>
		</dl>
		<dl class="fourD">
			<dt>
				上级维度：
			</dt>
			<dd>
				<select id="dim_parent_code"  name="dim_parent_code">
					<option value="">--请选择--</option>
					<e:forEach items="${dimList.list }" var="dim">
						<option value="${dim.DIM_CODE}" <e:if condition="${dim.DIM_CODE == dimObj.DIM_PARENT_CODE}">selected</e:if>>${dim.CODE_TABLE_DESC}</option>
					</e:forEach>
				</select>
			</dd>
			<dt>
				联动级别：
			</dt>
			<dd>
				<select id="dim_level" name="dim_level">
					<option value="">--请选择--</option>
					<option value="0">一级</option>
					<option value="1">二级</option>
					<option value="2">三级</option>
					<option value="3">四级</option>
					<option value="4">五级</option>
					<option value="5">六级</option>
				</select>
			</dd>
		</dl>
		 <div id="auto2">
				<dl class="ddLine">
					<dt>查询条件：</dt>
					<dd>
						<textarea rows="3" cols="10" id="condition" name="condition">${dimObj.CONDITION}</textarea>
					</dd>
				</dl>
			</div>
			</div>
		<form id="downloadExcel_D" method="post" action="<e:url value="downloadExcelFile.e"/>">
			<input type="hidden" name="doc_type" value="dim">
    	</form> 
  	</div>
 	</div>
 	</div>
</div>
</body>
</html>
