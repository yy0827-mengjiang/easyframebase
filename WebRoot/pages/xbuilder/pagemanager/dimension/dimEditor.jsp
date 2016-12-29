<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:q4l var="types">
	select type_id, type_name from x_code_var_type order by ord
</e:q4l>
<e:q4l var="dims">
	select d.dim_id "id", d.dim_var_name "text"
		  from x_dimension d
		 where d.dim_var_type like '%SELECT%'
</e:q4l>
<e:q4o var="cur" sql="xbuilder.dimensionManager.cur">
</e:q4o>
<e:if condition="${applicationScope['xdbauth'] == '1'}" var="dataSourceElse">
	<e:q4l var="db_name_list">
		SELECT distinct X.DB_ID, DB_NAME, DB_SOURCE,x.ord
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
<div id="dlg" class="easyui-dialog" title="编辑维度" data-options="modal:true,buttons:'#dlg-buttons'"
	style="width: 600px; height: 480px;  top: 90px;">
		<form id="form4" method="post" action="">
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
						 onchange="changeVarType(this,1)" defaultValue="${cur.dim_var_type}" style="width:142px;"/>
					</td> 
					<th id="CASELECT_1">
						联动级别：
					</th>
					<td id="CASELECT_2" align="right"> 
						<select id="caslvl" name="caslvl" style="width: 142px;"  onchange="changeNext(this.value)">
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
						<input name="createType" id="createType" type="radio" value="1" onclick="change(1)">
						配置型
						<input name="createType" id="createType" type="radio" value="2" onclick="change(2)" >
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
						<textarea style="width: 99%;height: 60px;" id="dimsql" name="dimSql" class="easyui-validatebox" required="true">${cur.dimSql}</textarea>
					</td>
				</tr>
				<tr id="SELECT">
					<th>码表名称：</th>
					<td><input name="dim_table" id="dim_table" type="text" class="easyui-validatebox" /></td>
					<th>编码字段：</th>
					<td><input name="dim_col_code" id="dim_col_code" type="text"  class="easyui-validatebox" /></td>
				</tr>
				<tr  id="SELECT">
					<th>中文字段：</th>
					<td><input name="dim_col_desc" id="dim_col_desc" type="text"  class="easyui-validatebox" /></td>
					<th>排序字段：</th>
					<td><input name="dim_col_ord" id="dim_col_ord" type="text" class="easyui-validatebox" /></td>
				</tr>
				<tr id="CASELECT">
					<th>
						上级维度：
					</th>
					<td>
						<input type="hidden" id="parent_dim_id" name="parent_dim_id">
						<e:select items="${dims.list}" label="text" value="id" name="parent_dim_id_show" id="parent_dim_id_show" defaultValue="${cur.parent_dim_id_show}" style="width: 142px;" onchange="up_filed(this)"/>
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
						<input type="text" id="defaule_desc" name="defaule_desc" disabled="disabled">
					</td>
				</tr>
				<tr>
					<th>
						维度描述：
					</th>
					<td colspan="3">
						<textarea style="width: 99%;height: 60px;" id="dimDesc" name="dimDesc">${cur.dimDesc }</textarea>
						<input id="tableUser" name="tableUser" type="hidden" />
						<input type="hidden" name="eaction" id="eaction" value="editDim" />
						<input type="hidden" name="id" value="${param.id }" />
					</td>
				</tr>
			</table>
		</form>
</div>
<div id="dlg-buttons">
	<a href="javascript:void(0)" class="easyui-linkbutton"  onclick="javascript:submit();">保存</a>
	<a href="javascript:void(0)" class="easyui-linkbutton easyui-linkbutton-gray"  onclick="javascript:$('#dlg').dialog('close');">关闭</a>
</div>
<script type="text/javascript">
var caslvl = '';
	$(function(){
	 /*
		var p_id = '${param.id}';
		$.getJSON("<e:url value='/pages/ebuilder/pagemanager/dimension/action.jsp'/>?_dc="+new Date().getTime(),{id:p_id,eaction:"CURDIM"},function(data){
			var obj = {};
			obj.value=data.dim_var_type;
			var info = {};
			info = data;
			info.parent_dim_id_show = '';
			///$('#form4').form('reset');
			//$("#dim_var_name").focus();
			caslvl=data.caslvl;
			changeVarType(obj);
			change(data.createType);
			$('#form4').form("load",info);
			if(data.createType=='1'){
				$("#dimsql").val('');
			}
			$('#dim_var_desc').focus();
			alert(data.createType);
			$("#createType[name='createType'][value="+data.createType+"]").attr("checked","true");
			$("#parent_dim_id_show option[value='D20130625143049 area_no']").attr("selected", true);
			alert(data.parent_dim_id_show);
		});
		*/
		resetData();
	});
	function resetData(){
		var obj = {};
		obj.value='${cur.dim_var_type}';
		var $object = $('#dim_var_type');
		if('${cur.createType}'=='1'){
			$("#dimsql").val('');
		}
		//$('#dim_var_desc').focus();
		$("#dim_var_desc").val('${cur.dim_var_name}');
		$("#dim_var_desc_1").val('${cur.dim_var_desc}');
		if($object.val() == 'CASELECT' || $object.val() == 'SELECT'){
			$('#dim_table').val('${cur.dim_table}');
			$('#dim_col_code').val('${cur.dim_col_code}');
			$('#dim_col_desc').val('${cur.dim_col_desc}');
			$('#dim_col_ord').val('${cur.dim_col_ord}');
			
			$(":radio[name=createType][value='${cur.createType}']").attr("checked","checked");
			
			if('${cur.database_name}' != '')
				$("#database_name option[value='${cur.database_name}']").attr("selected", true);
			else
				$("#database_name option[value='']").attr("selected", true);
			if($object.val() == 'CASELECT'){
			
				$("#parent_dim_id_show option[value='${cur.parent_dim_id_show}']").attr("selected", "selected");
				$('#parent_dim_id').val('${cur.parent_dim_id}');
				$("#dim_parent_col").val('${cur.dim_parent_col}');
				$("#caslvl option[value='${cur.caslvl}']").attr("selected", true);
				
			}
			$("#defaule_value").val('${cur.defaule_value}');
			//$("#defaule_desc").val('${cur.defaule_desc}');
		}
		
		changeVarType($object,0);
		if($object.val() == 'CASELECT' || $object.val() == 'SELECT')
			change('${cur.createType}');
		if($object.val() == 'CASELECT')
			changeNext('${cur.caslvl}');
	}
	function hideCaSelect(){
		var sql = "${cur.dimSql}";
		$("#CASELECT").hide();
		$("#CASELECT_1").hide();
		$("#CASELECT_2").hide();
		$("#caslvl").attr("disabled","disabled");
		$("#parent_dim_id").attr("disabled","disabled");
		$("#parent_dim_id_show").attr("disabled","disabled");
		$("#dim_parent_col").attr("disabled","disabled");
		sql = sql.replace(/\r\n/g,' ');
		sql = sql.replace(/(^\s*)|(\s*$)/g, " ");
		$('#dimsql').val(sql);  
		$('#dim_table').val('${cur.dim_table}');
		$('#dim_col_code').val('${cur.dim_col_code}');
		$('#dim_col_desc').val('${cur.dim_col_desc}');
		$('#dim_col_ord').val('${cur.dim_col_ord}');
	}
	function showCaSelect(){
		$("#CASELECT_1").show();
		$("#CASELECT_2").show();
		$("#caslvl").removeAttr("disabled");
		changeNext(caslvl);
	}
		/*****************变量类型改变事件**********************/
		
	function changeVarType(obj,t){
		var value = obj.value;
		if(value == undefined){
			value = obj.val();
		}
		$("input[name=createType]").each(function(index,dom){
			if(t == 1){
				if(index==0){
					$(dom).attr("checked","checked");
				}else{
					$(dom).removeAttr("checked");
				}
			}
		});
		if(value=='CASELECT'){
			showCaSelect();
		}else{
			hideCaSelect();
		}
		$("tr[id^=SELECT]").each(function(index,obj){
			if((obj.id.indexOf(value)>-1 || value=='CASELECT')&& obj.id!='SELECT_SQL'){
				$(this).show();
				$(this).find("input").each(function(index,dom){
					$(dom).removeAttr("disabled");
				});
			}else{
				$(this).hide();
				$(this).find("input").each(function(index,dom){
					$(dom).attr("disabled","disabled");
				});
			}
		});
		//两个日期型
		if(value == 'DAY' || value == 'MONTH'){
			$("td[id^=CASELECT]").each(function(td_index,obj){
		 		$(this).hide();
		 		$(this).find("input").each(function(index,dom){
					$(dom).attr("disabled","disabled");
				});
		 	});
		 	$("tr[id^=SELECT]").each(function(tr_index,obj){
		 		$(this).hide();
		 		$(this).find("input").each(function(index,dom){
					$(dom).attr("disabled","disabled");
				});
		 	});
		}
	}
	submit=function(){
		var var_type = $("#dim_var_type").val();
		if(var_type=='SELECT' ||var_type=='CASELECT') {
		/**
		if(!$("#form4").form('validate'))
				return;
		**/
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
			info.dimsql = $("#dimsql").val();  
			info.dimsql = info.dimsql.replace(/\r\n/g,' ');
			info.dimsql = info.dimsql.replace(/(^\s*)|(\s*$)/g, " "); 
			info.dimsql = base64encode(utf16to8(info.dimsql));
			info.caslvl = $("#caslvl option:selected").val();
			info.databaseName = $("#database_name option:selected").val();
			$.post(appBase+"/xbuilder/varcharge.e",info,function(data){
				if($.trim(data).indexOf("FAIL")==0){
					isTrue=false;
					$.messager.alert("提示信息！","表相关信息填写错误!<br/>错误信息：<span style=\"color:red\">"+data.substr(4)+"</span>","error");
				}else{
					$('#form4').form('submit',{
						url:appBase+'/pages/xbuilder/pagemanager/dimension/action.jsp',
			    		success:function(data){
			       			$.messager.alert('提示信息', data, 'info');
			       			$('#dlg').dialog('close');
			       			$('#dim_tree_grid').treegrid('reload',$('#dim_tree_grid').treegrid('getParent',getSelected().DIM_ID).DIM_ID);
			    		}
					});
				}
			});
		}else{
		$('#form4').form('submit',{
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
       			$('#dim_tree_grid').treegrid('reload',$('#dim_tree_grid').treegrid('getParent',getSelected().DIM_ID).DIM_ID);
    		}
		});
		}
	}	
	function changeNext(value){
		if(parseInt(value)>0){
			$("#CASELECT").show();
			$("#parent_dim_id_show").removeAttr("disabled");
			$("#dim_parent_col").removeAttr("disabled");
		}else{
			$("#CASELECT").hide();
			$("#parent_dim_id_show").attr("disabled","disabled");
			$("#dim_parent_col").attr("disabled","disabled");
		}
	}
	
	function up_filed(obj){
		var id_col = obj.value.split(' ');
		$("#parent_dim_id").val(id_col[0]);
		$("#dim_parent_col").val(id_col[1]);
	}
	function change(flag){
		if(flag==1){
			if($("#dimsql").val()==''){
				$("#dimsql").val(' ');
			}
			$("#dim_table").removeAttr("disabled");
			$("#dim_col_code").removeAttr("disabled");
			$("#dim_col_desc").removeAttr("disabled");
			$("#dim_col_ord").removeAttr("disabled");
			$("#dimsql").attr("disabled","disabled");
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
			$("#dimsql").removeAttr("disabled");
			$("#SELECT_SQL").show();
		}
	}
</script>