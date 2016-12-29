<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- /eframe_oracle/src/sqlmap/db2/kpi/setting.xml -->
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title>指标库配置</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	<script type="text/javascript">
	  function formatterCZ(value,rowData){
		  var _isFlag = '有效';
		  if(rowData.TYPE_STATUS=='1'){
			  _isFlag = '无效';
		  }
		  return '<a href="javascript:void(0);" onclick="edit(\''+rowData.TYPE_CODE+'\')">' + '设置' + '</a>&nbsp;&nbsp;<a href="javascript:void(0);" onclick="isStatus(\''+rowData.TYPE_STATUS+'\',\''+rowData.TYPE_CODE+'\')">' + _isFlag + '</a>';
	  }
	  function isStatus(status,id){
		  var _param = {}; 
		  _param.id=id;
		  var _text = '';
		  if(status=='0'){
			  _param.flag = '1';
			  _text = '有效';
		  }else{
			  _param.flag = '0';
			  _text = '无效';
		  }
		  $.messager.confirm('提示信息', "确认设置菜单" + _text + "吗？", function(r){
				if (r){
					$.ajax({
						type:'post',
						url:'<e:url value="/pages/kpi/kpiSetting/settingAction.jsp?eaction=status"/>',
						data:_param,
						async : false,
						success:function(data){
							var _data= $.parseJSON(data);
							if(_data!='0'){
								$.messager.alert("提示信息！", "设置成功！", "info",function(){
									$('#setTable').datagrid('load');
								});
							}
							
						}
				 	 });
				}
		  });
	  }
	  function edit(id){
		  var _param = {}; 
		  _param.id=id;
		  $.ajax({
				type:'post',
				url:'<e:url value="/pages/kpi/kpiSetting/settingAction.jsp?eaction=queryData"/>',
				data:_param,
				async : false,
				success:function(data){
					var _data= $.parseJSON(data);
					$('#ACTION').val('settingupdate');
					$('#ID').val($(_data).attr('TYPE_CODE'));
					$('#TYPE_NAME').val($(_data).attr('TYPE_NAME'));
					$('#VIEW_TYPE_NAME').val($(_data).attr('VIEW_TYPE_NAME'));
					$('#TYPE_ORD').val($(_data).attr('TYPE_ORD'));
					$('#URL').val($(_data).attr('URL'));
					$('#ICON').val($(_data).attr('ICON'));
					$('#SERVER_CLASS').val($(_data).attr('SERVER_CLASS'));
					var _user_type = $(_data).attr('USED_TYPE');
					if(_user_type!=null&&_user_type!=''){
						var _kpi_user_type = $("input[name='USED_TYPE']");
						_kpi_user_type.each(function(){
							if(_user_type.indexOf($(this).val())!=-1){
								$(this).attr('checked',true);
							}
						});
					}
					
					var _view_rule = $(_data).attr('VIEW_RULE');
					if(_view_rule!=null&&_view_rule!=''){
						var _kpi_view_rule = $("input[name='VIEW_RULE']");
						_kpi_view_rule.each(function(){
							if(_view_rule.indexOf($(this).val())!=-1){
								$(this).attr('checked',true);
							}
						});
					}
					var _ext_view = $(_data).attr('EXT_VIEW');
					var _kpi_ext_view = $("input[name='EXT_VIEW']");
					_kpi_ext_view.each(function(){
						if(_ext_view==$(this).val()){
							$(this).attr('checked',true);
						}
					});
					var _server_view = $(_data).attr('SERVER_VIEW');
					var _kpi_server_view = $("input[name='SERVER_VIEW']");
					_kpi_server_view.each(function(){
						if(_server_view==$(this).val()){
							$(this).attr('checked',true);
						}
					});
					$('#f-dlg').dialog('open'); 
				}
		 	 });
		 
	  }
	  function setAgree(){
	    var _param = {}; 
	  	_param.action = $('#ACTION').val();
	  	_param.type_code = $('#ID').val();
	  	_param.type_name = $('#TYPE_NAME').val();
	  	_param.view_type_name = $('#VIEW_TYPE_NAME').val();
	  	_param.type_ord = $('#TYPE_ORD').val();
	  	_param.url = $('#URL').val();
	  	_param.icon = $('#ICON').val();
	  	_param.server_class = $('#SERVER_CLASS').val();
	  	var _kpi_used_type = $("input[name='USED_TYPE']");
	  	_param.used_type = '';
	  	_kpi_used_type.each(function(){
			if($(this).attr('checked')){
				if(_param.used_type!=null&&_param.used_type!=''){
					_param.used_type +=',';
				}
				_param.used_type += $(this).val();
			}
		});
	  	_param.view_rule = '';
	  	var _kpi_view_rule = $("input[name='VIEW_RULE']");
	  	_kpi_view_rule.each(function(){
			if($(this).attr('checked')){
				if(_param.view_rule!=null&&_param.view_rule!=''){
					_param.view_rule +=',';
				}
				_param.view_rule += $(this).val();
			}
		});
	  	var _kpi_server_view = $("input[name='SERVER_VIEW']");
		_kpi_server_view.each(function(){
			if($(this).attr('checked')){
				_param.server_view = $(this).val();
			}
		});
		var _kpi_ext_view = $("input[name='EXT_VIEW']");
		_kpi_ext_view.each(function(){
			if($(this).attr('checked')){
				_param.ext_view = $(this).val();
			}
		});
		$.messager.confirm('提示信息', "确认修改右键菜单设置吗？", function(r){
			if (r){  
				 $.ajax({
						type:'post',
						url:'<e:url value="/pages/kpi/kpiSetting/settingAction.jsp?eaction=update"/>',
						data:_param,
						async : false,
						success:function(data){
							var _data= $.parseJSON(data);
							if(_data != 0){
								$.messager.alert("提示信息！", "设置成功！", "info",function(){
									$('#f-dlg').dialog('close');
									$('#setTable').datagrid('load');
								});
							}
							
						}
				 });
			}
		});
	  }
	</script>
  </head>
  
  <body>
  	<div class="kpi_guide">
	  	<div class="tit_div">
			<h3>右键菜单</h3>
		</div>
	</div>
	<div style="width:100%;height: 35%;">
		<c:datagrid url="pages/kpi/kpiSetting/settingAction.jsp?eaction=querySetting" id="setTable" pageSize="5" fit="true">
	    	<thead>
	    		<tr>
	    			<th field="TYPE_CODE" width="20%" align="center">菜单编码</th>
					<th field="TYPE_NAME" width="20%" align="center">菜单名称</th>
	    			<th field="URL" width="20%" align="center">菜单地址</th>
	    			<th field="SERVER_CLASS" width="20%" align="center">默认编码</th>
	    			<th field="STATUS" width="20%" align="center">是否有效</th>
	    			<th field="CZ" width="20%" formatter="formatterCZ" align="center">操作</th>
	    		</tr>
	    	</thead>
	    </c:datagrid>
    </div>
	<div id="f-dlg" class="easyui-dialog" title="关联属性" style="width:550px;height:550px;" data-options="closed:true,modal:true" buttons="#dlg-buttons1">
				<table class="windowsTable">
					<colgroup>
						<col width="20%" />
						<col width="70%" />
					</colgroup>
					<tr>
						<th >名称</th>
						<td>${cube.CUBE_NAME }
							<input type="hidden" name="ACTION" id="ACTION" value="insert">
							<input type="hidden" name="ID" id="ID" value="">
							<input type="text" name="TYPE_NAME" id="TYPE_NAME" value="" width="90%">
						</td>
					</tr>
					<tr>
						<th>使用指标</th>
						<td>
							<e:q4l var="USEDS">
								SELECT T.TYPE_CODE,T.TYPE_NAME FROM X_KPI_TYPE T WHERE T.TYPE_STATUS= '1'
							</e:q4l>
							<e:forEach items="${USEDS.list }" var="used">
								<input type="checkbox" name="USED_TYPE" style="width:auto" value="${used.TYPE_CODE }">${used.TYPE_NAME }
							</e:forEach>
						</td>
					</tr>
					<tr>
						<th>使用模块</th>
						<td>
							<input type="checkbox" name="VIEW_RULE" style="width:auto" value="1">基础信息 <input type="checkbox" name="VIEW_RULE" style="width:auto" value="2">约束条件 <input type="checkbox" name="VIEW_RULE" value="3" style="width:auto">公式
						</td>
					</tr>
					<tr>
						<th >显示名称</th>
						<td>
							<input type="text" name="VIEW_TYPE_NAME" id="VIEW_TYPE_NAME" width="90%">
						</td >
					</tr>
					<tr>
						<th >指标排序</th>
						<td>
							<input type="text" name="TYPE_ORD" id="TYPE_ORD" width="90%">
						</td >
					</tr>
					<tr>
						<th>地址</th>
						<td><input type="text" name="URL" id="URL" width="90%"></td>
					</tr>
					<tr>
						<th>图标</th>
						<td><input type="text" name="ICON" id="ICON" width="90%"></td>
					</tr>
					<tr>
						<th>指标编码</th>
						<td><input type="radio" name="SERVER_VIEW" value="0" style="width:auto">不显示 <input type="radio" name="SERVER_VIEW" value="1" style="width:auto">显示
						</td>
					</tr>
					<tr>
						<th>默认编码</th>
						<td><input type="text" name="SERVER_CLASS" id="SERVER_CLASS" width="90%"></td>
					</tr>
					<tr>
						<th>扩展属性</th>
						<td><input type="radio" name="EXT_VIEW" value="0" style="width:auto">不显示 <input type="radio" name="EXT_VIEW" value="1" style="width:auto">显示</td>
					</tr>
				</table>
		</div>
		<div id="dlg-buttons1"><a href="javascript:void(0)" class="easyui-linkbutton" onclick="setAgree()">确认</a></div>
  </body>
</html>
