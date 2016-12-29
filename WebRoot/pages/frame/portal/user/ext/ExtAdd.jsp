<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
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
	$(function(){
		$.extend($.fn.validatebox.defaults.rules, {
		     test: {
		         validator: function(value, param){
		         var temp = /[^A-Za-z-0-9_]/g;
				 var spaceEmpty = value;
				 return !temp.test(spaceEmpty);
		         },
		     message: '{0}只能由数字、字母和下划线组成（A-Za-z0-9_）。'
		     }
		 });
		$('#extAddForm').form({  
			url:appBase + "/pages/frame/portal/user/ext/ExtAction.jsp?eaction=INSERT",
		    onSubmit: function(){  
		        return $(this).form('validate');
		    },  
		    success:function(data){  
		      if($.trim(data)>0){
		      	//alert("保存成功！");
		      	window.location.href=appBase + "/pages/frame/portal/user/ext/ExtManager.jsp";
		      }
		    }  
		}); 
		$("#ext_model").change(function(){
			var temp = this.value;
			$("tr[id^=CASCADE]").each(function(){
				var t_id = $(this).attr("id");
				if((t_id.indexOf(temp))>-1) {
					$(this).show();
				} else {
					$(this).find(":input").removeClass();
					$(this).hide();
				}
			});
			$(".ISNULL").each(function(){
				$(this).find(":input").removeClass();
				$(this).hide();
			});
			$("tr[id^=CASCADE] :input").each(function(){
				$(this).val('');
			});
			$("#isNull").val('0');
			$("#muni").val('0');
			$('#attr_father_code').numberbox('setValue', '0');  
		});
		$("#isNull").change(function(){
			var temp = this.value;
			$(".ISNULL").each(function(){
				if(temp == 1){
					$(this).show();
				}else{
					$(this).find(":input").removeClass();
					$(this).hide();
				}
			});
			$(".ISNULL :input").each(function(){
				$(this).val('');
			});
		});
		$("tr[id^=CASCADE]").each(function(){
			$(this).find(":input").removeClass();
			$(this).hide();
		});
		$(".ISNULL").each(function(){
			$(this).find(":input").removeClass();
			$(this).hide();
		});
	});
	function saveExt(){
		var postUrl= appBase + "/pages/frame/portal/user/ext/ExtAction.jsp";
		var　info = {};
		info.eaction="CUREXT";
		info.extId=$("#ext_code").val();
		if(info.extId==null || info.extId ==''){
			$('#extAddForm').submit();
			return;
		}
		$.post(postUrl,info,function(data){
			if(isEmpty(data)){
				$('#extAddForm').submit();
			}else{
				alert("属性编码已经存在！");
			}
		});
		
	}
	
	//判断是否为空
	function isEmpty(obj){
		if(obj==null || obj=='' ){
			return true;
		} else {
			var spaceEmpty = obj.replace(/\s/g,'');
			if(spaceEmpty == ''){
				return true;
			}
		}
		return false;
	}
	
	function goBack(){
		window.location.href=appBase + "/pages/frame/portal/user/ext/ExtManager.jsp";
	}
	
	function numboxChange(obj){
		if(obj.value!=0){
			$("#CASCADE_TREE_CITY_AREA").show();
		}else{
			$("#code_parent_key").val('');
			$("#CASCADE_TREE_CITY_AREA").hide();
		}
	}
</script>
</head>
<body>
<div class="contents-head">
	<h2>新增扩展属性</h2>
	<div class="search-area">
		<a href="javascript:void(0);" class="easyui-linkbutton" onclick="saveExt()">保存</a>
		<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-gray" onclick="goBack()">取消</a>
	</div>
</div>
<form action="" method="post" id="extAddForm" >
	<table class="pageTable">
	<colgroup>
		<col width="11%">
		<col width="*">
	</colgroup>
		<tr>
			<th>属性编码：</th>
			<td><input type="text" id="ext_code" name="ext_code" class="easyui-validatebox" required validType="test['属性编码']" style="width:200px;"></td>
		</tr>
		<tr>
			<th>属性名称：</th>
			<td><input type="text" id="ext_name" name="ext_name" class="easyui-validatebox" required style="width:200px;"></td>
		</tr>
		<tr>
			<th>属性描述：</th>
			<td>
				<input type="text" id="ext_desc" name="ext_desc" class="easyui-validatebox" style="width:200px;">
			</td>
		</tr>
		<tr>
			<th>属性值类型：</th>
			<td>
				<e:select items="${attrs.list}" label="type_desc" id="ext_value_type" name="ext_value_type" value="type_code"  style="width: 200px;"/>
			</td>
		</tr>
		<tr>
			<th>展现模式：</th>
			<td>
				<e:select items="${models.list}" id="ext_model" name="ext_model" label="model_desc" value="model_code" defaultValue="INPUT"  style="width: 200px;"/> <span class="easyui-font-gray">展现模式的不同，需要配置的属性也将不同。</span></td>
		</tr>
		<tr id="CASCADE_CASSELECT">
			<th>级联编码序号：</th>
			<td>
				<select id="attr_father_code" name="attr_father_code" onChange="numboxChange(this)" style="width: 200px;">
					<option value="0">一级</option>
					<option value="1">二级</option>
					<option value="2">三级</option>
					<option value="3">四级</option>
					<option value="4">五级</option>
					<option value="5">六级</option>
					<option value="6">七级</option>
				</select>
			</td>
		</tr>
		<tr id="CASCADE_CHECKBOX_RADIO_SELECTS_TREE_CASSELECT">
			<th class="borderNone1">候选项编码表名：</th>
			<td class="borderNone1">
				<input type="text" id="code_table" name="code_table" class="easyui-validatebox" style="width:200px;">
			</td>
		</tr>
		<tr id="CASCADE_CHECKBOX_RADIO_SELECTS_TREE_CASSELECT">
			<th>候选项值列名：</th>
			<td>
				<input type="text" id="code_key" name="code_key" class="easyui-validatebox" required validType="test['候选项值列名']" style="width:200px;">
			</td>
		</tr>
		<tr id="CASCADE_TREE_CITY_AREA">
			<th>候选项上级编码列名：</th>
			<td>
				<input type="text" id="code_parent_key" name="code_parent_key" class="easyui-validatebox" required validType="test['候选项上级编码列名']" style="width:200px;">
			</td>
		</tr>
		<tr id="CASCADE_CHECKBOX_RADIO_SELECTS_TREE_CASSELECT">
			<th>候选项描述列名：</th>
			<td>
				<input type="text" id="code_desc" class="easyui-validatebox" name="code_desc" required validType="test['候选项描述列名']" style="width:200px;">
			</td>
		</tr>
		<tr id="CASCADE_CHECKBOX_RADIO_SELECTS_TREE_CASSELECT">
			<th class="borderNone1">候选项排序列名：</th>
			<td class="borderNone1">
				<input type="text" id="code_ord" name="code_ord" class="easyui-validatebox" required validType="test['候选项排序列名']" style="width:200px;">
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
					<option value="1" selected="selected">是</option>
					<option value="0">否</option>
				</select>当展现模式是下拉列表时，则表示是否展现【全部】
			</td>
		</tr>
		<tr class="ISNULL">
			<th>为空时默认值：</th>
			<td>
				<input type="text" id="default_value" name="default_value">
			</td>
		</tr>
		<tr class="ISNULL">
			<th>为空时默认描述：</th>
			<td>
				<input type="text" id="default_desc" name="default_desc" style="width:200px;">
			</td>
		</tr>
		<tr>
			<th class="borderNone1">扩展属性排序：</th>
			<td class="borderNone1">
				<input id="ext_index" name="ext_index" class="easyui-numberspinner" min="0" value="0" required="true" style="width:200px;" />
			</td>
		</tr>
		<tr>
			<th class="borderNone1">所属子系统：</th>
			<td class="borderNone1">
				<e:select id="subsystem_id" name="subsystem_id" items="${subsystemList.list}" label="type_desc" value="type_code" headValue="" headLabel="无" style="width:200px;"/>
			</td>
		</tr>
		<tr>
			<th class="borderNone1"><span class="easyui-font-red">说明：</span></th>
			<td class="borderNone1"><span class="easyui-font-gray">当扩展属性是地域（地市）、区县、乡镇时，列名称请用：AREA_NO、CITY_NO、TOWN_TO;编码表为sql时格式为:(sql)</span></td>
		</tr>
	</table>
</form>
</div>
</body>
</html>