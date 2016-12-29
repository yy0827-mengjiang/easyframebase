<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:q4o var="cur_attr">
	select attr_code,
       parent_code,
       attr_name,
       show_mode,
       model_desc,
       code_table,
       code_key,
       code_parent_key,
       code_desc,
       code_ord,
       data_type,
       multi,
       attr_ord,
       is_null,
       default_value,
       default_desc,
        attr_desc,
       subsystem_id
  from e_user_attr_dim d ,e_user_ext_model m
	where attr_code=#attrCode#
	and
	d.show_mode=m.model_code
</e:q4o>
<e:q4l var="attrs">
	select type_code, type_desc, type_value from e_user_extvalue_type
</e:q4l>
<e:q4l var="models">
	select model_code, model_desc from e_user_ext_model
</e:q4l>
<e:q4l var="subsystemList">
	select sub.subsystem_id type_code, sub.subsystem_name type_desc
	  from d_subsystem sub
	 order by sub.ord
</e:q4l>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<c:resources type="easyui,app" style="${ThemeStyle }"></c:resources>
<e:style value="/resources/themes/base/boncBase@links.css"/>
<script type="text/javascript">
	var cur_show_model="${cur_attr.show_mode}";
	var isNull="${cur_attr.is_null}";
	var attr_father_code="${cur_attr.parent_code}";
	$(function(){
		$('#attrUpdForm').form({  
			url:"<e:url value='/pages/frame/portal/user/ext/ExtAction.jsp'/>?eaction=UPDATE",
		    onSubmit: function(){
		    	getFormPara();
		        return $(this).form('validate');
		    },  
		    success:function(data){  
		      if(data>0){
		      	//alert("保存成功！");
		      	window.location.href="<e:url value='/pages/frame/portal/user/ext/ExtManager.jsp'/>";
		      }
		    }  
		});
		$.extend($.fn.validatebox.defaults.rules, {
		     test: {
		         validator: function(value, param){
		         var temp = /[^A-Za-z0-9_.]/g;
				 var spaceEmpty = $.trim(value);
				 return !temp.test(spaceEmpty);
		         },
		     message: '{0}只能由数字、字母、圆点和下划线组成（A-Za-z0-9_）。'
		     }
		 });
		$("tr[id^=CASCADE]").each(function(){
			var temp = $(this).attr("id");
			if(!(temp.indexOf($.trim(cur_show_model))>-1)){
				$(this).hide();
				$(this).find(":input").removeAttr("class");
			}
		});
		$(".ISNULL").each(function(){
			if(!(isNull=='1')){
				$(this).hide();
				$(this).find(":input").removeAttr("class");
			}
		});
		$("#isNull").change(function(){
			var temp = this.value;
			$(".ISNULL").each(function(){
				if(temp == 1){
					$(this).find(":input").addClass("easyui-validatebox");
					$(this).show();
				}else{
					$(this).hide();
					$(this).find(":input").removeClass();
				}
			});
		});
		if(attr_father_code!='0'){
			$("#CASCADE_TREE_CITY_AREA").show();
		}
		$("#isNull").val("${cur_attr.is_null}");
		$("#muni").val("${cur_attr.multi}");
		$("#attr_father_code").val(attr_father_code);
		$("#ext_index").numberspinner('setValue', '${cur_attr.attr_ord}');
	});
	
	function updExtSave(){
		$('#attrUpdForm').submit();
	}
	function getFormPara(){
		var isNull = $("#isNull").val();
		var attr_father_code=$("#attr_father_code").val();
		if(isNull == '0'){
			$("#default_value").val('');
			$("#default_desc").val('');
		}
		if(attr_father_code=='0'){
			$("#code_parent_key").val('');
		}
	}
	function goBack(){
		window.location.href="<e:url value='/pages/frame/portal/user/ext/ExtManager.jsp'/>";
	}
	function numboxChange(obj){
		if(obj.value!=0){
			$("#CASCADE_TREE_CITY_AREA").show();
		}else{
			//$("#code_parent_key").val('');
			$("#CASCADE_TREE_CITY_AREA").hide();
		}
	}
</script>
</head>
<body>
<div class="contents-head">
	<h2>扩展属性修改</h2>
	<div class="search-area">
		<a href="javascript:void(0);" class="easyui-linkbutton" onclick="updExtSave()">保存</a>
		<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-gray" onclick="goBack()">取消</a>
	</div>
</div>
<form action="" method="post" id="attrUpdForm" >
	<table class="pageTable">
	<colgroup>
	<col width="15%">
	<col width="*">
	</colgroup>
		<tr>
			<th>属性编码：</th>
			<td><input type="text" id="attr_code_temp" name="attr_code_temp" value="${cur_attr.attr_code}" disabled="disabled" style="width:200px;">
			<input type="hidden" id="attr_code" name="attr_code" value="${cur_attr.attr_code}"></td>
		</tr>
		<tr>
			<th>属性名称：</th>
			<td><input type="text" id="attr_name" name="attr_name" value="${cur_attr.attr_name}" class="easyui-validatebox" required style="width:200px;"></td>
		</tr>
		<tr>
			<th>属性描述：</th>
			<td>
				<input type="text" id="attr_desc" name="attr_desc" value="${cur_attr.attr_desc}" class="easyui-validatebox" style="width:200px;"></td>
			</td>
		</tr>
		<tr>
			<th>属性值类型：</th>
			<td>
				<e:select items="${attrs.list}" label="type_desc" id="ext_value_type" name="ext_value_type" value="type_code" defaultValue="${cur_attr.data_type}" style="width:200px;"/>
			</td>
		</tr>
		<tr>
			<th>展现模式：</th>
			<td>
				<input type="hidden" disabled="disabled" id="model_desc" name="model_desc" value="${cur_attr.model_desc  }">
				<input type="text" disabled="disabled" id="model_desc_temp" name="model_desc_temp" value="${cur_attr.model_desc  }" style="width:200px;">
				<e:description><e:select items="${models.list}" id="ext_model" name="ext_model" label="model_desc" value="model_code" defaultValue="${cur_attr.show_mode}" style="width:200px;"/></e:description>
			</td>
		</tr>
		
		<tr id="CASCADE_CASSELECT">
			<th>级联编码序号：</th>
			<td>
				<e:set var="father_codes">[{"value":0,"lable":"一级"},{"value":1,"lable":"二级"},{"value":2,"lable":"三级"},{"value":3,"lable":"四级"},{"value":4,"lable":"五级"},{"value":5,"lable":"六级"},{"value":6,"lable":"七级"}]</e:set>
				<e:select items="${e:json2java(father_codes)}" id="attr_father_code" name="attr_father_code" label="lable" value="value" onChange="numboxChange(this)" style="width:200px;"/>
			</td>
		</tr>
		<tr id="CASCADE_CHECKBOX_RADIO_SELECTS_TREE_CASSELECT">
			<th>候选项编码表名：</th>
			<td>
				<input type="text" id="code_table" name="code_table" value="${cur_attr.code_table }" class="easyui-validatebox" style="width:200px;">
			</td>
		</tr>
		<tr id="CASCADE_CHECKBOX_RADIO_SELECTS_TREE_CASSELECT">
			<th>候选项值列名：</th>
			<td>
				<input type="text" id="code_key" name="code_key" value="${cur_attr.code_key }" class="easyui-validatebox" required validType="test['候选项值列名']" style="width:200px;">
			</td>
		</tr>
		<tr id="CASCADE_TREE_CITY_AREA">
			<th>候选项上级编码列名：</th>
			<td>
				<input type="text" id="code_parent_key" name="code_parent_key" value="${cur_attr.code_parent_key }" class="easyui-validatebox" required validType="test['候选项上级编码列名']" style="width:200px;">
			</td>
		</tr>
		<tr id="CASCADE_CHECKBOX_RADIO_SELECTS_TREE_CASSELECT">
			<th>候选项描述列名：</th>
			<td>
				<input type="text" id="code_desc" name="code_desc" value="${cur_attr.code_desc }" class="easyui-validatebox" required validType="test['候选项描述列名']" style="width:200px;">
			</td>
		</tr>
		<tr id="CASCADE_CHECKBOX_RADIO_SELECTS_TREE_CASSELECT">
			<th>候选项排序列名：</th>
			<td>
				<input type="text" id="code_ord" name="code_ord" value="${cur_attr.code_ord }" class="easyui-validatebox" required validType="test['候选项排序列名']" style="width:200px;">
			</td>
		</tr>
		<tr id="CASCADE_SELECTS">
			<th>是否多选：</th>
			<td>
				<select id="muni" name="muni" style="width:200px;">
					<option value="1">是</option>
					<option value="0" selected="selected">否</option>
				</select>
			</td>
		</tr>
		<tr id="CASCADE_SELECTS_CASSELECT">
			<th>是否可以为空：</th>
			<td>
				<select id="isNull" name="isNull" style="width:200px;">
					<option value="1">是</option>
					<option value="0" selected="selected">否</option>
				</select><span class="easyui-font-gray">当展现模式是下拉列表时，则表示是否展现【全部】</span>
			</td>
		</tr>
		<tr class="ISNULL">
			<th>默认-值：</th>
			<td>
				<input type="text" id="default_value" name="default_value" value="${cur_attr.default_value }" style="width:200px;">
			</td>
		</tr>
		<tr class="ISNULL">
			<th>默认-描述：</th>
			<td>
				<input type="text" id="default_desc" name="default_desc" value="${cur_attr.default_desc }" style="width:200px;">
			</td>
		</tr>
		<tr>
			<th>扩展属性排序：</th>
			<td><input id="ext_index" name="ext_index" class="easyui-numberspinner" min="0" value="0" 
						required="true" style="width: 200px;"></input></td>
		</tr>
		<tr>
			<th class="borderNone1">所属子系统：</th>
			<td class="borderNone1">
				<e:select id="subsystem_id" name="subsystem_id" items="${subsystemList.list}" label="type_desc" value="type_code" headValue="" headLabel="无" defaultValue="${cur_attr.subsystem_id }" style="width:200px;"/>
			</td>
		</tr>
		<tr>
			<th><span class="easyui-font-red">说明：</span></th>
			<td class="borderNone1"><span class="easyui-font-gray">当扩展属性是地域（地市）、区县、乡镇时，列名称请用：AREA_NO、CITY_NO、TOWN_TO;编码表为sql时格式为:(sql)</span></td>
		</tr>
	</table>
</form>
</div>
</body>
</html>