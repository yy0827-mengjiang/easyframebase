<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <a:base/>
	 <!-- 样式 信息 -->
	<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
	<e:set var="userId">${sessionScope.UserInfo.USER_ID}</e:set>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>操作日志页面</title>
    <script type="text/javascript">
    	var products ='[';
    		products+='{"DEFAULT_TYPE":"1","DEFTYPE":"常量"},';
    		products+='{"DEFAULT_TYPE":"2","DEFTYPE":"变量"}';
    		products+=']';
    		
    	var lastIndex = undefined;
    	$.extend($.fn.datagrid.methods, {
			editCell: function(jq,param){
				return jq.each(function(){
					var opts = $(this).datagrid('options');
					var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
					for(var i=0; i<fields.length; i++){
						var col = $(this).datagrid('getColumnOption', fields[i]);
						col.editor1 = col.editor;
						if (fields[i] != param.field){
							col.editor = null;
						}
					}
					$(this).datagrid('beginEdit', param.index);
                    var ed = $(this).datagrid('getEditor', param);
                    if (ed){
                        if ($(ed.target).hasClass('textbox-f')){
                            $(ed.target).textbox('textbox').focus();
                        } else {
                            $(ed.target).focus();
                        }
                    }
					for(var i=0; i<fields.length; i++){
						var col = $(this).datagrid('getColumnOption', fields[i]);
						col.editor = col.editor1;
					}
				});
			},
            enableCellEditing: function(jq){
                return jq.each(function(){
                    var dg = $(this);
                    var opts = dg.datagrid('options');
                    opts.oldOnClickCell = opts.onClickCell;
                    opts.onClickCell = function(index, field){
                        if (opts.editIndex != undefined){
                            if (dg.datagrid('validateRow', opts.editIndex)){
                                dg.datagrid('endEdit', opts.editIndex);
                                //行数据
                                var row = $('#defTable').datagrid("selectRow", opts.editIndex).datagrid("getSelected");
                                opertionRow(row,opts.editIndex,'upd');
                                opts.editIndex = undefined;
                            } else {
                                return;
                            }
                        }
                        var a = dg.datagrid('selectRow', index).datagrid('editCell', {
                            index: index,
                            field: field
                        });
                        opts.editIndex = index;
                        opts.oldOnClickCell.call(this, index, field);
                    }
                });
            }
		});

		$(function(){
			$('#defTable').datagrid().datagrid('enableCellEditing');
			
			//新增页面
			$("#defAddDialog").dialog({
				width:500,
				height:300,
				modal:true,
				closed:true,
				top:60,
				buttons:[{
					text:'提交',
					handler:savedefault
				}]
			});
		});
		
		function opertionRow(row,index,state){
			var postUrl = '';
			if(state=='upd'){
				postUrl="<e:url value='pages/xbuilder/dimension/defaultAction.jsp?eaction=UPDATE'/>";
			}else if(state=='del'){
				postUrl="<e:url value='pages/xbuilder/dimension/defaultAction.jsp?eaction=DELETE'/>";
			}else if(state='add'){
				postUrl="<e:url value='pages/xbuilder/dimension/defaultAction.jsp?eaction=INSERT'/>";
			}else{
				$.messager.alert("提示信息","操作失败！","error");
				return false;
			}
			$.post(postUrl,row,function(data){
				//$('#approveTable').datagrid('reload');
				//$('#defTable').datagrid('refreshRow',index);
				//$('#defTable').datagrid('endEdit', index);
			});
		}
		
		function doQuery(){
			lastIndex = undefined;
			var info = {};
			info.defaultdesc = $("#defaultdesc").val();
			info.defaultname = $("#defaultname").val();
			info.defaulttype = $("#defaulttype").val();
			$('#defTable').datagrid('load',info);
		}
		
		function delRow(){
			if (lastIndex == undefined){return}
			var row = $('#defTable').datagrid("selectRow",lastIndex).datagrid("getSelected");
			var rowNum = lastIndex+1;
			$.messager.confirm("确认信息","您确定要删除第【"+rowNum+"】行数据吗?",function(r){
				if(r){
					$('#defTable').datagrid('cancelEdit', lastIndex).datagrid('deleteRow', lastIndex);
					opertionRow(row,lastIndex,'del');
					lastIndex = undefined;
				}else{
					$('#defTable').datagrid('reload');
				}
			});
		}
		
		//单击行得到当前行号
		function onClickRow(rowIndex, rowData){
			lastIndex = rowIndex;
		}
		
		
		function savedefault(){
			var info = {};
			info.default_name = $("#default_name").val();
			info.default_desc = $("#default_desc").val();
			info.default_val = $("#default_val").val();
			info.default_type = $("#default_type").val();
			postUrl="<e:url value='pages/xbuilder/dimension/defaultAction.jsp?eaction=INSERT'/>";
			$.post(postUrl,info,function(data){
				//$('#approveTable').datagrid('refreshRow',index);
				$('#defTable').datagrid('reload');
				$("#defAddDialog").dialog("close");
				lastIndex = undefined;
			});
		}
		
		function adddefault(){
			doRest();
			lastIndex = undefined;
			$("#defAddDialog").dialog("open");
		}
		
		function doRest(){
			$("#default_desc").val("");
			$("#default_name").val("");
			$("#default_val").val("");
			$("#default_type").val("1");
		}
		
		//取转换后的值
		function formDefaultType(value,row){
			var str = '';
			if(value=='1'){
				str = '常量';
			}else if(value=='2'){
				str = '变量';
			}
			return str;
		}
		
		function endEditing(){
			if (lastIndex == undefined){return true}
			if ($('#defTable').datagrid('validateRow', lastIndex)){
				$('#defTable').datagrid('endEdit', lastIndex);
				lastIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
		
		//增加行
		function append(){
			if (endEditing()){
				$('#defTable').datagrid('appendRow',{DEFAULT_TYPE:'1'});
				lastIndex = $('#defTable').datagrid('getRows').length-1;
				$('#defTable').datagrid('selectRow', lastIndex).datagrid('beginEdit', lastIndex);
				$('#defTable').datagrid('endEdit', lastIndex);
				var row = $('#defTable').datagrid("selectRow",lastIndex).datagrid("getSelected");
				//console.log(row);
				postUrl="<e:url value='pages/xbuilder/dimension/defaultAction.jsp?eaction=INSERT'/>";
				$.post(postUrl,row,function(data){
					$('#defTable').datagrid('reload');
				});
			}
		}
		
		
    </script>
  </head>
  
  <body>
    <div id="tbar">
    	<table>
    		<tr>
    			<td>名称：<input id="defaultdesc" name="defaultdesc" type="text" style="width: 120px" value=""/> </td>
    			<td>传递名称：<input id="defaultname" name="defaultname" type="text" style="width: 120px" value=""/> </td>
    			<td>类型：
    			<select id="defaulttype" name="defaulttype" style="width: 130px">
    				<option value="">请选择</option>
    				<option value="1">常量</option>
    				<option value="2">变量</option>
    			</select>
				<td><a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a></td>
				<td><a href="javascript:void(0);" class="easyui-linkbutton" onclick="append()">新增</a></td>
				<td><a href="javascript:void(0);" class="easyui-linkbutton" onclick="delRow()">删除</a></td>
    		</tr>
    	</table>
    </div>
    
    <!-- datagrid 展示列 -->
     <c:datagrid url="pages/xbuilder/dimension/defaultAction.jsp?eaction=LIST" id="defTable" remoteSort="true" 
	       style="width:auto;height:500px;" fit="true" nowrap="false" toolbar="#tbar" pageSize="15" onClickRow="onClickRow">
		<thead >
			<tr>
				<th field="DEFAULT_ID" width="60" align="center"  sortable="true">主键</th>
				<th field="DEFAULT_DESC" width="60" align="center" editor="text" sortable="true">名称</th>
				<th field="DEFAULT_NAME" width="60" align="center" editor="text" sortable="true">传递名称</th>
				<th field="DEFAULT_VAL" width="60" align="center" editor="text" sortable="true">传递值</th>
					<th field="DEFAULT_TYPE" width="60" align="center"
						editor="{type:'combobox',options:{valueField:'DEFAULT_TYPE',textField:'DEFTYPE',method:'get',data:$.parseJSON(products),editable:false}}"
						formatter="formDefaultType" sortable="true">
						类型
					</th>
				</tr>
		</thead>
	</c:datagrid>
	
	<!-- 新增页面 -->
	<div id="defAddDialog" title="新增信息">
		<form action="" method="post" id="addTestForm">
			<table width="100%" height="170px" class="firstd" style="margin-top:8px;">
				<colgroup>
				<col width="19%">
				<col width="*">
				</colgroup>
				<tr>
					<td align="right">名称：</td>
					<td><input id="default_desc" name="default_desc" type="text" style="width: 329px;" value="" /></td>
					
				</tr>
				<tr>
					<td align="right">传递名称：</td>
					<td><input id="default_name" name="default_name" type="text" style="width: 329px;" value="" /></td>
				</tr>
				<tr>
					<td align="right">传递值：</td>
					<td><input id="default_val" name="default_val" type="text" style="width: 329px;" value=""/></td>
				</tr>
				<tr>
					<td align="right">类型：</td>
					<td>
						<select id="default_type" name="default_type" style="width: 340px;">
							<option value="1">常量</option>
							<option value="2">变量</option>
						</select>
					</td>
				</tr>
			</table>
		</form>
	</div>
	
  </body>
</html>
