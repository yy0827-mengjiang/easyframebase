<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="cn.com.easy.xbuilder.element.*,cn.com.easy.xbuilder.*"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<%
	String reportId = request.getParameter("reportId");
	Report reportObj = null;
	String type = "";
	if(reportId!=null){
		reportObj=XContext.getEditView(reportId);
		type = reportObj.getInfo().getType();
		request.setAttribute("fromtype",type);
	}
%>
<e:q4l var="types">
	select type_id, type_name from x_code_var_type where TYPE_ID in ('SELECT','CASELECT') order by ord
</e:q4l>
<e:q4l var="formulas">
	select type_id, type_name, type_desc, sort_id from x_formula_type t order by sort_id
</e:q4l>
<e:q4l var="showTypes">
	select '0' code ,'常规模式' codedesc from dual union all
	select '1' code ,'平铺模式' codedesc from dual union all
	select '2' code ,'弹出模式' codedesc from dual
</e:q4l>
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
<!-- 获得默认值的select选择器 -->
<e:q4l var="selValObj">
	select t.ATTR_CODE,t.ATTR_NAME from E_USER_ATTR_DIM t 
</e:q4l>

<script type="text/javascript">
$(function (){
	$('input.checkN').iCheck({
	    labelHover : false,
	    cursor : true,
	    checkboxClass : 'icheckbox_square-blue',
	    radioClass : 'iradio_square-blue',
	    increaseArea : '20%'
	}).on('ifClicked', function(event){
		if($(this).attr("name") == "dimVarType") {
			showPropertiesType($(this).attr("value"));
		} else if($(this).attr("name") == "select_double") {
			$("#select_double_s").val($(this).attr("value"));
			saveDimsion();
		} else {
			changeTable($(this).attr("value"));
		}
	});
	toolsAddHideEvent();
	
	
	//select选择器设置默认值
	//alert(3);
	//cn.com.easy.xbuilder.service.DimensionService.getSelectValue(function(data,exception){
	//	var jsonObj=$.parseJSON(data);
	//	for(var key in jsonObj){
	//		$("#selVal").append("<option value='"+key+"'>"+jsonObj[key]+"</option>");			    
	//	}	
	//});
	
});
function showPropertiesType(value){
	$("#dim_var_type").val(value);
	var create_type = $("#create_type").val();
	if(create_type == undefined || create_type == "") {
		create_type = "1";
	}
	if(value==""||value=="INPUT"||value=="UPLOAD"||value=="MONTH"||value=="DAY"||value=="HIDDEN"){
		showSimple();
	}else if(value=="SELECT"){
		showSelect(create_type);
	}else{
		var caslvl = $("#caslvl").val();
		if(caslvl == undefined || caslvl == "") {
			caslvl = "0";
		}
		showCascade(create_type,caslvl);
	}
	resetForm();
	saveDimsion();
}
function showSimple(){
	$("#tableColumn").hide();
	$("#tableSql").hide();
	$("#tableCascade").hide();
	$("#createTypeTr").hide();
	$("#database_name1_tr").hide();
	$("#trSelectDouble").hide();
	$("#selectTreeTemplates").show();
	resetForm();
} 
function showSelect(createType){
    if(createType=="1"){
    	$("#tableColumn").show();
    	$("#tableSql").hide();
//     	$("#rbType").iCheck('check');//.attr("checked",true);
    }if(createType=="2"){
    	$("#tableColumn").hide();
    	$("#tableSql").show();
//     	$("#rbType2").iCheck('check');//.attr("checked",true);
    }
    $("[name='createType']:radio").each(function(index,item){
		if(createType == $(item).val()) {
			$(item).iCheck('check'); 
		}
	});
	$("#tableCascade").show();
	$("#createTypeTr").show();
	$("#database_name1_tr").show();
	
	$("#caslvlTr").hide();
	$("#parent_dim_id_tr").hide();
	$("#dim_parent_col_tr").hide();
	$("#trSelectDouble").show();
	$("#selectTreeTemplates").hide();
}

function resetForm(){
// 	$("#rbType").iCheck('check');//attr("checked",true);
	$("#database_name1").val("");//数据源
	$("#sql").val("");//sql语句
	$("#dim_table").val("");//码表名称
	$("#dim_col_code").val("");//编码字段
	$("#dim_col_desc").val("");//中文字段
	$("#dim_col_ord").val("");//排序字段
	$("#parent_dimid").val("");//上级维度
	$("#dim_parent_col").val("");//上级编码
	$("#parent_dim_name").val("");//上级维度名称
	$("#defaule_value").val("");//默认值
	$("#mselect").iCheck('check');//$("#mselect").attr("checked",true);
	$("#caslvl").val("0");//联动级别
	//$("#formula").val("");
	//$("#fieldid").val("");
	//$("#fieldtype").val("");
}

function showCascade(createType,level){
	if(createType=="1"){
    	$("#tableColumn").show();
    	$("#tableSql").hide();
//     	$("#rbType").iCheck('check');//.attr("checked",true);
    }if(createType=="2"){
    	$("#tableColumn").hide();
    	$("#tableSql").show();
//     	$("#rbType2").iCheck('check');//.attr("checked",true);
    }
    $("[name='createType']:radio").each(function(index,item){
		if(createType == $(item).val()) {
			$(item).iCheck('check'); 
		}
	});
	$("#tableCascade").show();
	$("#createTypeTr").show();
	$("#database_name1_tr").show();
	$("#caslvlTr").show();
	
	if(level=="0"){
		$("#parent_dim_id_tr").hide();
		$("#dim_parent_col_tr").hide();
	}
	if(level=="1"){
		$("#parent_dim_id_tr").show();
		$("#dim_parent_col_tr").show();
	}
	$("#trSelectDouble").show();
	$("#selectTreeTemplates").hide();
}

function changeTable(type){
	$("#create_type").val(type);
	if(type=="1"){//配置型
		$("#tableColumn").show();
		$("#tableSql").hide();
	}else{
		$("#tableColumn").hide();
		$("#tableSql").show();
	}
	saveDimsion();
}

function changeLevel(value){
	if(parseInt(value)>0){
		$("#parent_dim_id_tr").show();
		$("#dim_parent_col_tr").show();
		cn.com.easy.xbuilder.service.DimensionService.getParentDims(StoreData.xid,$("#dim_var_name").val(),getParentDimsBack);
	}else{
		$("#parent_dim_id_tr").hide();
		$("#dim_parent_col_tr").hide();
	}
	saveDimsion();
}

//获取上级维度回调函数
function getParentDimsBack(data,exception){
	var dataArr=$.parseJSON(data);
	if(dataArr==undefined || dataArr == null || dataArr.length == 0){
		//alert("无上级维度");
		$.messager.alert("提示信息！","参数信息定义错误!<br/>错误信息：<span style=\"color:red\">无上级维度或已发生变化，不能建立联动</span>","error");
		$("#parent_dim_id_tr").show();
		$("#dim_parent_col_tr").show();
		return;
	}
	$("#parent_dimid").empty().append("<option value=''>-请选择-</option>");
	for(var i=0;i<dataArr.length;i++){
		var obj=dataArr[i];
		var idd=obj.varName+"@"+obj.codeColumn;
		var text=obj.type;
		text=text=="SELECT"?"下拉框":"多级联动";
		$("#parent_dimid").append("<option value='"+obj.varName+"@"+obj.codeColumn+"'>"+obj.varName+"</option>");
	}
}

function up_field(obj){
	var id = obj.value;//obj.id;
	var varnames = id.split("@");
	var codeColumn = varnames[1];//id.substring(id.indexOf("@")+1,id.length);
	var parentvarname = varnames[0];//id.substring(0,id.indexOf("@"));
	$("#dim_parent_col").val(codeColumn);
	$("#parent_dim_name").val(parentvarname);
	saveDimsion();
}

function checkSql(){
	var info = {};
	info.dim_table=$("#dim_table").val();
	info.dim_col_code=$("#dim_col_code").val();
	info.dim_col_desc=$("#dim_col_desc").val();
	info.dim_col_ord=$("#dim_col_ord").val();
// 	info.createType=$("input[name=createType]:checked").val();
	info.createType=$("#create_type").val();
	info.dimsql = base64encode(utf16to8($("#sql").val()));
// 	info.select_double=$("input[name=select_double]:checked").val();//是否复选
	info.select_double=$("#select_double_s").val();//是否复选
	info.databaseName = $("#database_name1 option:selected").val();
	if($("#dim_var_type").val()=='CASELECT')
	    info.caslvl = $("#caslvl option:selected").val();
	else 
		info.caslvl = '';
	$.post(appBase+"/xbuilder/varcharge.e",info,function(data){
		 if($.trim(data).indexOf("FAIL")==0){
			 $.messager.alert("提示信息！","表相关信息填写错误!<br/>错误信息：<span style=\"color:red\">"+data.substr(4)+"</span>","error");
		 	 return;
		 }else{
	  		saveDimsion();
		 }
	 });				
}
function toolsAddHideEvent(){
	$(".propertiesPane h4").click(function(){
    	$(this).next("div.ppInterArea").slideToggle("fast");
    	$(this).toggleClass("ot");
    });
}



//选择是常量还是用户属性
function showhideDefault(){
	var defaultvaluetype = $("#defaultvaluetype").val();
	if("1"==defaultvaluetype){
		$("#inpVal").show();
		$("#selVal").hide();
	}else if("2"==defaultvaluetype){
		$("#inpVal").hide();
		$("#selVal").show();
	}
	saveDimsion();
}

//验证特殊字符
function validateInpVal(){
	var str = $("#inpVal").val();
	//过滤空格
	if(str!=""){
		//var pattern = /^[\u4E00-\u9FA5\uf900-\ufa2d\w\,\s]+$/;
		var pattern = new RegExp("[`~!@#$^&*()=|{}':;,\\[\\]<>/?~]");
		if(!pattern.test(str)){
			saveDimsion();
		}else{
			$.messager.alert("提示信息！","常量默认值添写错误!<br/>错误信息：输入信息不能包含特殊字符!","error");
		}
	}else{
		saveDimsion();
	}
	
}

</script>

<style type="text/css">
.model_a{ padding:1px 13px 3px; height:25px; line-height:25px; border-radius:2px; background:#2b579a; border-bottom:2px solid #2b579a; color:#fff!important; text-align:center; -webkit-transition:all 0.2s; -moz-transition:all 0.2s; font-size:14px; border:none;}
.model_a:hover{ background:#3265b3;}
.btnItem1 li a.deleteBtn:link, .btnItem1 li a.deleteBtn:visited { margin-right:10px!important; height:25px; line-height:25px; background:#ef0e1e; border-bottom: 2px solid #ef0e1e;-webkit-transition: all 0.2s; -moz-transition: all 0.2s; -ms-transition: all 0.2s;  -o-transition: all 0.2s; transition: all 0.2s;}
</style>
    <form id="var_set_form" method="post" action="">
		<div class="propertiesPane">
			<h4>维度集</h4>
			<div class="ppInterArea">
			<dl>
				<dt>显示名称</dt>
				<dd>
					<input type="hidden" name="isModel" id="isModel" value="1"/>
					<input type="hidden" name="create_type" id="create_type" value="1">
					<input type="hidden" name="dim_var_type" id="dim_var_type" value="INPUT">
					<input type="hidden" name="report_id" id="report_id" value="${param.reportId}">
					<input name="dim_var_name" id="dim_var_name" type="hidden" value="${param.varname}"/>
					<input type="hidden" name="field" id="field" value="${param.varname}"/>
					<input name="fieldid" id="fieldid" type="hidden" value=""/>
					<input name="fieldtype" id="fieldtype" type="hidden" value=""/>
					<input type="hidden" id="select_double_s" name="select_double_s" value=""/>
					<input name="dim_var_desc" id="dim_var_desc" type="text" value="${param.desc }" class="easyui-validatebox" required="true" onblur="saveDimsion()" style="width:204px;" />
					<input type="hidden" id="dimtemplate_varname" value="${param.varname }"/>
					<input type="hidden" id="datasourceid" value="">
					<input type="hidden" id="conditiontype" value="">
					<input type="hidden" id="vardesc" value="">
				</dd>
				<dt>类别</dt>
				<dd>
				<input class="checkN" name="dimVarType" type="radio" value="INPUT" checked="checked"  id="dimVarType00"><label>常规</label>
				<e:forEach items="${types.list}" var="typeList" indexName="i">
					<input class="checkN" name="dimVarType" type="radio" value="${typeList.type_id}" <e:if condition="${typeList.type_id=='INPUT'}">checked="checked"</e:if>  id="dimVarType${i}"><label>${typeList.type_name }</label>
					<e:if condition="${i == 2 }">
						<br/>
					</e:if> 
				</e:forEach>
				<!-- 
				<label><a class="model_a" href="javascript:void(0);" onclick="selectTemplate('${param.varname}');">模板</a></label>
				 -->
				<!-- 
				<input class="checkN" name="dim_var_type" type="radio" value="modle"   id="dimVarType_all"><label>模板</label> -->
<!-- 				<e:select items="${types.list}" label="type_name" value="type_id" name="dim_var_type" id="dim_var_type" class="easyui-validatebox" required="true" 
 							 onchange="showPropertiesType(this)" defaultValue="INPUT" style="width:215px; height:24px;"  /> -->
 				</dd>
				<e:if condition="${fromtype!=null && fromtype eq '2'}">
					<dt>逻辑条件</dt>
					<dd>
						<e:select items="${formulas.list}" label="type_desc" value="type_id" name="formula" id="formula" class="easyui-validatebox wih_214 heih_24" required="true" 
								 onchange="saveDimsion()" defaultValue="05" />
					</dd>
				</e:if>
			</dl>
			<!-- 
			<ul class="btnItem1 bendItem1">
				<li><a href="javascript:void(0)" class="addBtn" id="var_select" onclick="selectTemplate('${param.varname}')" >统用模板</a></li>
			</ul> -->
			</div>
			<span id="selectTreeTemplates">
				<a:tree url="pages/xbuilder/dimension/DimensionAction.jsp?eaction=VARDIMTREE" id="var_select_load" onLoadSuccess="dimNodeextendAll" onClick="dimdbSelect"/>
			</span>
			<span id="createTypeTr">
				<h4>创建类型</h4>
				<div class="ppInterArea">
					<dl>
						<dt>创建方式</dt>
						<dd>
							<input class="checkN" name="createType" type="radio" value="1" checked="checked" onclick="changeTable('1')" id="rbType"><label>配置型</label>
							<input class="checkN" name="createType" type="radio" value="2" onclick="changeTable('2')" id="rbType2"><label>SQL型</label>
						</dd>
					</dl>
					<dl>
						<dt>数据源</dt>
						<dd>
						<select id="database_name1" name="database_name" style="width: 97%; height:26px;" onchange="saveDimsion()">
								<option value = "">--请选择--</option>
							    <e:forEach items="${db_name_list.list}" var="ds">
					                 <option value ="${ds.DB_SOURCE}">${ds.DB_NAME}</option>	
					            </e:forEach>	
							</select>
						</dd>
					</dl>
<!-- 					<ul class="btnItem1 bendItem1"  id="database_name1_tr"> -->
<!-- 						<li> -->
<!-- 							<select id="database_name1" name="database_name" style="width: 97%; height:26px;" onchange="saveDimsion()"> -->
<!-- 								<option value = "">--请选择--</option> -->
<!-- 							    <e:forEach items="${db_name_list.list}" var="ds"> -->
<!-- 					                 <option value ="${ds.DB_SOURCE}">${ds.DB_NAME}</option>	 -->
<!-- 					            </e:forEach>	 -->
<!-- 							</select> -->
<!-- 						</li> -->
<!-- 					</ul> -->
				</div>
			</span>
			<span id="tableColumn">
				<h4>数据集</h4>
				<div class="ppInterArea">
					<dl>
						<dt>码表名称</dt>
						<dd>
							<input name="dim_table" id="dim_table" type="text" class="easyui-validatebox wih_204" required="true" validType="testDataSet['码表名称：']" onblur="saveDimsion()" />
						</dd>
						<dt>编码字段</dt>
						<dd><input name="dim_col_code" id="dim_col_code" type="text"  class="easyui-validatebox wih_204" required="true"  onblur="saveDimsion()" /></dd>
					</dl>
					<dl>	
						<dt>中文字段</dt>
						<dd><input name="dim_col_desc" id="dim_col_desc" type="text"  class="easyui-validatebox wih_204" required="true"  onblur="saveDimsion()" /></dd>
						<dt>排序字段</dt>
						<dd><input name="dim_col_ord" id="dim_col_ord" type="text" class="easyui-validatebox wih_204" required="true" onblur="saveDimsion()" /></dd>
					</dl>
				</div>
			</span>
			<span id="tableSql">
				<h4>维度SQL</h4>
				<dl>
					<dt>维度SQL</dt>
					<dd>
						<textarea id="sql" name="dimSql" class="easyui-validatebox wih_204" required="true" onblur="checkSql()" style="height:180px;"></textarea>
					</dd>
				</dl>
			</span>
			<span id="tableCascade">
				<dl id="caslvlTr">
					<dt>联动级别</dt>
					<dd>
						<select id="caslvl" name="caslvl" onchange="changeLevel(this.value)" class="wih_214 heih_24" >
							<option value="0">一级</option>
							<option value="1">二级</option>
							<option value="2">三级</option>
							<option value="3">四级</option>
							<option value="4">五级</option>
							<option value="5">六级</option>
						</select>
					</dd>
				</dl>
				<dl id="parent_dim_id_tr">
					<dt>上级维度</dt>
					<dd>
						<select id="parent_dimid" name="parent_dimid" onchange="up_field(this);" class="wih_214 heih_24" >
							<option value="">-请选择-</option>
						</select>
					</dd>
				</dl>
				<dl id="dim_parent_col_tr">
					<dt>上级编码</dt>
					<dd>
						<input type="text" id="dim_parent_col" class="wih_204" name="dim_parent_col" onblur="saveDimsion()" />
						<input name="parent_dim_name" id="parent_dim_name" type="hidden" value=""/>
					</dd>
				</dl>
				<!-- 
				<dl>
					<dt>默认值</dt>
					<dd><input type="text" id="defaule_value" class="wih_204" name="defaule_value" onblur="saveDimsion()" ></dd>
				</dl>
				 -->
				 <dl>
				 	<dt>默认值</dt>
				 	<dd>
				 		<select id="defaultvaluetype" name="defaultvaluetype" onchange="showhideDefault()">
				 			<option value="1" selected="selected">常量</option>
							<option value="2">用户属性</option>
				 		</select>
				 		
				 		<input id="inpVal" name="inpVal" type="text" style="width: 120px;height: 24px" onblur="validateInpVal()" >	
						<select id="selVal" name="selVal"  style="display: none;width: 128px;height: 26px"  onchange="saveDimsion()">
							<option value="USER_ID">用户ID</option>
							<option value="USER_NAME">用户名称</option>
							<e:forEach items="${selValObj.list}" var="ds">
				                 <option value ="${ds.ATTR_CODE}">${ds.ATTR_NAME}</option>	
				            </e:forEach>
						</select>
				 	</dd>
				 </dl>
				
				<dl>
					<dt>显示类型</dt>
					<dd>
 						<e:select items="${showTypes.list}" label="codedesc" value="code" name="showtype" id="showtype" class="wih_214 heih_24"
							 onchange="saveDimsion()" defaultValue="0" />
					</dd>
				</dl>
				<dl id="trSelectDouble">
					<dt>是否多选</dt>
					<dd>
						<input class="checkN" id="select_double1" name="select_double" type="radio" value="1">是
			            <input class="checkN" id="select_double2" name="select_double" type="radio" value="0" checked="checked">否
					</dd>
				</dl>
			 </span>
			 <%if(reportObj !=null && "2".equals(reportObj.getInfo().getType())){ %>
			 <span>
		 		 <ul class="btnItem1">
					<li><a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-red" onclick="javascript:delDim('');" plain="true">删除条件</a>
					</li>
				 </ul>
			 </span>
			 <%}else{%>
			 <span id="dtcondtion" style="display: none;">
		 		 <ul class="btnItem1">
					<li><a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-red" onclick="javascript:delDim('');" plain="true">删除条件</a>
					</li>
				 </ul>
			 </span>
			 <%}%>
			</div>
      </form>
