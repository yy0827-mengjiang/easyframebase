<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<div id="dlg" class="easyui-dialog" title="编辑维度分类" buttons="#dlg-buttons" modal="true" style="width:320px; height:205px; top:90px;">
	<form id="form1" method="post">
		<table class="windowsTable">
			<tr>
				<th>
					<label for="name">
						维度分类名称：
					</label>
				</th>
				<td>
					<input name="name" type="text" id="name" class="easyui-validatebox"
						style="width: 150px" />
				</td>
			</tr>
			<tr>
				<th>
					<label for="order">
						功能顺序：
					</label>
				</th>
				<td>
					<input onKeyUp="this.value=this.value.replace(/\D/g,'')"
						type="text" id="order" name="order" class="easyui-validatebox"
						style="width: 150px" />
					<input type="hidden" name="eaction" value="editDimCategory" />
					<input type="hidden" id="id" name="id" />
				</td>
			</tr>
		</table>
	</form>
</div>
<div id="dlg-buttons">
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#form1').submit();">保存</a>
	<a href="javascript:void(0)" class="easyui-linkbutton easyui-linkbutton-gray" onclick="javascript:$('#dlg').dialog('close');">关闭</a>
</div>
<script type="text/javascript">
	$(function(){
		$('#form1').form({
			url:appBase+'/pages/xbuilder/pagemanager/dimension/action.jsp',
    		success:function(data){
       			$.messager.alert('提示信息', data, 'info');
       			$('#dim_tree_grid').treegrid('reload',getSelected().PARENT_DIM_ID);
       			$('#dlg').dialog('close');
    		}
		});
		$("#name").val(getSelected().DIM_NAME);
		$("#order").val(getSelected().DIM_ORD);
		$("#id").val(getSelected().DIM_ID);
	});
</script>