<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<div id="dlg" class="easyui-dialog" title="添加维度分类" buttons="#dlg-buttons" data-options="onClose:close,modal:true" style="width: 320px; height:200px; top:90px;">
	<form id="form0" method="post">
		<table class="windowsTable">
			<tr>
				<th>
					<label for="name">
						维度分类名称：
					</label>
				</th>
				<td>
					<input name="name" type="text" id="name" style="width: 150px"
						class="easyui-validatebox" required="true" />
				</td>
			</tr>
			<tr>
				<th>
					<label for="order">
						分类顺序：
					</label>
				</th>
				<td>
					<input onKeyUp="this.value=this.value.replace(/\D/g,'')" type="text" id="order" name="order" style="width: 150px" class="easyui-validatebox" required="true" />
					<input type="hidden" name="eaction" value="appendDimCategory" />
					<input type="hidden" id="parent" name="parent" />
				</td>
			</tr>
		</table>
	</form>
</div>
<div id="dlg-buttons">
	<a href="javascript:void(0)" class="easyui-linkbutton"  onclick="save()">保存</a>
	<a href="javascript:void(0)" class="easyui-linkbutton easyui-linkbutton-gray" onclick="reset()">重置</a>
</div>
<script type="text/javascript">
	$(function(){
		$('#form0').form({
			url:appBase+'/pages/xbuilder/pagemanager/dimension/action.jsp',
    		success:function(data){
       			$.messager.alert('提示信息', data, 'info');
       			$('#dlg').dialog('close');
       			$('#dim_tree_grid').treegrid('reload',getSelected().DIM_ID);
    		}
		});
		$("#parent").val(getSelected().DIM_ID);
	});
	function save(){
		$('#form0').submit();
	}
	function reset(){
		$('#form0').form('reset');
	}
	function close(){
		$("#dlg").remove();
	}
</script>