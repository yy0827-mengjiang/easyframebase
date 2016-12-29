<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:q4l var="types">
	select type_id, type_name from x_code_var_type order by ord
</e:q4l>
<e:q4l var="dims">
	select d.dim_id || '@' || dim_col_code "id", d.dim_var_name "text"
		  from x_dimension d
		 where d.dim_var_type like '%SELECT%'
</e:q4l>
<e:if condition="${applicationScope['xdbauth'] == '1'}" var="dataSourceElse">
	<e:q4l var="db_name_list">
		SELECT distinct X.DB_ID, DB_NAME, DB_SOURCE, x.ord
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
<div id="dlg" class="easyui-dialog" title="添加维度"
	buttons="#dlg-buttons" modal="true"
	style="width: 580px; height: 380px; top: 90px;">
		<form id="var_set_form" method="post" action="">
			<table class="windowsTable">
				<tr>
					<th>维度名称：</th>
					<td>
						<input name="dim_var_name" id="dim_var_desc" type="text" class="easyui-validatebox" required="true" />
					</td>
					<th>显示名称：</th>
					<td>
						<input name="dim_var_desc" id="dim_var_desc_1" type="text" class="easyui-validatebox" required="true" />
					</td>
				</tr>
				<tr>
					<th>类别：</th>
					<td>
						<e:select items="${types.list}" label="type_name" value="type_id" name="dim_var_type" id="dim_var_type" class="easyui-validatebox" required="true" 
						 onchange="changeVarType(this)" defaultValue="INPUT" style="width:142px;"/>
					</td> 
					<th id="CASELECT_1">
						联动级别：
					</th>
					<td id="CASELECT_2">
						<select id="caslvl" name="caslvl" style="width: 142px;" onchange="changeNext(this.value)">
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
				<tr id="SELECT_CONF">
					<th>
						创建类型：
					</th>
					<td>
						<input name="createType" type="radio" value="1" checked="checked" 
							onclick="change(1)">
						配置型
						<input name="createType" type="radio" value="2" onclick="change(2)" >
						手动型
					</td>
				</tr>
				<tr id="SELECT_CONF">
					<th>
						数据源：
					</th>
					<td colspan="3">
					<select id="database_name" name="database_name" style="width: 97%; height:26px;">
						<option value = "">--请选择--</option>
					    <e:forEach items="${db_name_list.list}" var="ds">
			                 <option value ="${ds.DB_SOURCE}">${ds.DB_NAME}</option>	
			            </e:forEach>	
					</select>
					</td>
				</tr>
				<tr id="SELECT_SQL">
					<th>
						维度SQL：
					</th>
					<td colspan="3">
						<textarea style="width: 99%;height: 60px;" id="sql" name="dimSql" class="easyui-validatebox" required="true"></textarea>
					</td>
				</tr>
				<tr id="SELECT">
					<th>码表名称：</th>
					<td><input name="dim_table" id="dim_table" type="text" class="easyui-validatebox" required="true" validType="test['码表名称：']"/></td>
					<th>编码字段：</th>
					<td><input name="dim_col_code" id="dim_col_code" type="text"  class="easyui-validatebox" required="true"/></td>
				</tr>
				<tr id="SELECT">
					<th>中文字段：</th>
					<td><input name="dim_col_desc" id="dim_col_desc" type="text"  class="easyui-validatebox" required="true"/></td>
					<th>排序字段：</th>
					<td><input name="dim_col_ord" id="dim_col_ord" type="text" class="easyui-validatebox" required="true" /></td>
				</tr>
				<tr id="CASELECT">
					<th>
						上级维度：
					</th>
					<td>
						<input type="hidden" name="parent_dim_id" id="parent_dim_id">
						<e:select items="${dims.list}"  label="text" value="id" name="parent_dim_id_show" id="parent_dim_id_show" style="width: 142px;" onchange="up_filed(this)"/>
					</td>
					<th>
						上级编码：
					</th>
					<td>
						<input type="text" id="dim_parent_col" name="dim_parent_col">
					</td>
				</tr>
				<tr id="SELECT_CASELECT">
					<th>
						默认值：
					</th>
					<td>
						<input type="text" id="defaule_value" name="defaule_value">
					</td>
					<th style="display: none;">
						默认显示：
					</th>
					<td style="display: none;">
						<input type="text" id="defaule_desc" name="defaule_desc">
					</td>
				</tr>
				<tr>
					<th>
						维度描述：
					</th>
					<td colspan="3">
						<textarea style="width: 99%;height: 60px;" id="dimDesc" name="dimDesc"></textarea>
						<input type="hidden" name="eaction" value="appendDim" />
						<input type="hidden" id="parent" name="parent" />
						<input id="tableUser" name="tableUser" type="hidden" />
					</td>
				</tr>
			</table>
		</form>
</div>

<div id="dlg-buttons">
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:submit();">保存</a>
	<a href="javascript:void(0)" class="easyui-linkbutton easyui-linkbutton-gray" onclick="javascript:reset()">重置</a>
</div>
<script type="text/javascript">
	$(function(){
		$("tr[id^=SELECT]").each(function(tr_index,obj){
	 		$(this).hide();
	 		$(this).find("input").each(function(index,dom){
				$(dom).attr("disabled","disabled");
			});
	 	});
	 	hideCaSelect();
		$("#parent").val(getSelected().DIM_ID);
		var obj = {};
		if($("#parent_dim_id_show").val() == null) {
			obj.value="@";
		} else {
			obj.value=$("#parent_dim_id_show").val();
		} 
		up_filed(obj);
	}); 
	
	function hideCaSelect(){
		$("#CASELECT").hide();
		$("#CASELECT_1").hide();
		$("#CASELECT_2").hide();
		$("#caslvl").attr("disabled","disabled");
		$("#parent_dim_id_show").attr("disabled","disabled");
		$("#parent_dim_id").attr("disabled","disabled");
		$("#dim_parent_col").attr("disabled","disabled");
	}
	function showCaSelect(){
		$("#CASELECT_1").show();
		$("#CASELECT_2").show();
		$("#caslvl").removeAttr("disabled");
		changeNext($("#caslvl").val());
	}
	
	reset=function(){
		$("tr[id^=SELECT]").each(function(){
	 		$(this).hide();
	 		$(this).find("input").each(function(index,dom){
				$(dom).attr("disabled","disabled");
			});
	 	});
	 	hideCaSelect();
		$('#var_set_form').form("reset");
	}
	submit=function(){
		var var_type = $("#dim_var_type").val();
		if(var_type=='SELECT'||var_type=='CASELECT') {
			/* 1.   2014-05-22 董一伯 保存异常，取消form得验证*/
			//if(!$("#var_set_form").form('validate'))
				//return;
			var createType = '';
			$("input[name=createType]").each(function(index,dom){
				if($(dom).attr("checked")=='checked' ||$(dom).attr("checked")==true )
					createType=dom.value;
			});
			
			var info = {};
			info.dim_table=$("#dim_table").val();
			info.dim_col_code=$("#dim_col_code").val();
			info.dim_col_desc=$("#dim_col_desc").val();
			info.dim_col_ord=$("#dim_col_ord").val();
			info.createType=createType;
			info.dimsql = base64encode(utf16to8($("#sql").val()));//$("#sql").val();
			info.caslvl = $("#caslvl option:selected").val();
			info.databaseName = $("#database_name option:selected").val();
			$.post(appBase+"/xbuilder/varcharge.e",info,function(data){
				if($.trim(data).indexOf("FAIL")==0){
					isTrue=false;
					$.messager.alert("提示信息！","表相关信息填写错误!<br/>错误信息：<span style=\"color:red\">"+data.substr(4)+"</span>","info");
				}else{
					$('#var_set_form').form('submit',{
						url:appBase+'/pages/xbuilder/pagemanager/dimension/action.jsp',
						/* 2.   2014-05-22 董一伯 保存异常，增加提交验证*/
						onSubmit:function(param){
						return $("#dim_var_desc_1").validatebox("isValid")&&$("#dim_var_desc").validatebox("isValid");				
						},
			    		success:function(data){
			       			$.messager.alert('提示信息', data, 'info');
			       			$('#dlg').dialog('close');
			       			$('#dim_tree_grid').treegrid('reload',getSelected().DIM_ID);
			    		}
					});					
				}
			});
		}else{
			
			$('#var_set_form').form('submit',{
				url:appBase+'/pages/xbuilder/pagemanager/dimension/action.jsp',
				onSubmit:function(param){
					if(createType == '' || createType == null){
						param.createType='2';
					}
					return $("#dim_var_desc_1").validatebox("isValid")&&$("#dim_var_desc").validatebox("isValid");
				},
	    		success:function(data){
	       			$.messager.alert('提示信息', data, 'info');
	       			$('#dlg').dialog('close');
	       			$('#dim_tree_grid').treegrid('reload',getSelected().DIM_ID);
	    		}
			});
		}
	}
	
	/*****************变量类型改变事件**********************/
	function changeVarType(obj){
		var value = obj.value;
		$("input[name=createType]").each(function(index,dom){
			if(index==0)
				$(dom).attr("checked","checked");
		});
		if(value=='CASELECT')
			showCaSelect();
		else
			hideCaSelect();
			
	    var createType = $('#createType').val()==undefined?'1':$('#createType').val();
	    change(createType);
		$("tr[id^=SELECT]").each(function(index,tr_dom){
			if((tr_dom.id.indexOf(value)>-1 || value=='CASELECT')&& tr_dom.id!='SELECT_SQL'){
				$(this).show();
				$(this).find("input").each(function(index,dom){
					$(dom).removeAttr("disabled");
				});
			} else{
				$(this).hide();
				$(this).find("input").each(function(index,dom){
					$(dom).attr("disabled","disabled");
				});
			}
		});
	}
	function changeNext(value){
		if(parseInt(value)>0){
			$("#CASELECT").show();
			$("#parent_dim_id").removeAttr("disabled");
			$("#parent_dim_id_show").removeAttr("disabled");
			$("#dim_parent_col").removeAttr("disabled");
		}else{
			$("#CASELECT").hide();
			$("#parent_dim_id_show").attr("disabled","disabled");
			$("#parent_dim_id").attr("disabled","disabled");
			$("#dim_parent_col").attr("disabled","disabled");
		}
	}
	
	function up_filed(obj){
		var id_col = obj.value.split('@');
		$("#parent_dim_id").val(id_col[0]);
		$("#dim_parent_col").val(id_col[1]);
	}
	function change(flag){
		if(flag==1){
			if($("#sql").val()==''){
				$("#sql").val(' ');
			}
			$("#dim_table").removeAttr("disabled");
			$("#dim_col_code").removeAttr("disabled");
			$("#dim_col_desc").removeAttr("disabled");
			$("#dim_col_ord").removeAttr("disabled");
			$("#sql").attr("disabled","disabled");
			$("tr[id=SELECT]").each(function(){
		 		$(this).show();
		 	});
			$("#SELECT_SQL").hide();
		}else{
			$("tr[id=SELECT]").each(function(){
		 		$(this).hide();
		 	});
			$("#dim_table").attr("disabled","disabled");
			$("#dim_col_code").attr("disabled","disabled");
			$("#dim_col_desc").attr("disabled","disabled");
			$("#dim_col_ord").attr("disabled","disabled");
			$("#sql").removeAttr("disabled");
			$("#SELECT_SQL").show();
		}
	}
</script>