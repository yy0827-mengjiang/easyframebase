<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<script type="text/javascript">
		
		function formatterCZ(value,rowData){
			return '<a href="javascript:void(0);" onclick="del(\''+rowData.ID+'\')">删除</a>';			
		}
		function del(id){
			var _param={};
			_param.ID=id;
			$.messager.confirm('提示信息', "确认删除公式吗？", function(r){
				if (r){
					$.ajax({
						type:'post',
						url:'<e:url value="/pages/kpi/kpiSetting/formulaSetting.jsp"/>',
						data:_param,
						async : false,
						success:function(data){
							var _data =$.parseJSON(data);
							if(_data>=1){
								$.messager.alert("提示信息！", "公式删除成功！", "info",function(){
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
  <div style="width:100%;height: 32%;">
  	<c:datagrid url="pages/kpi/kpiSetting/settingAction.jsp?eaction=formulaInfo" id="setTable" pageSize="5" fit="true">
    	<thead>
    		<tr>
				<th field="NAME" width="20%" align="center">公式名称</th>
    			<th field="FORMULA_EXPLAIN" width="20%" align="center">公式说明</th>
    			<th field="OPER" width="20%" align="center" formatter="formatterCZ">操作</th>
    		</tr>
    	</thead>
	</c:datagrid>
  
  </div>
  </body>
</html>