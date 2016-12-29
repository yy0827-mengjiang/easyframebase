<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources> 
<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
<e:style value="/resources/easyResources/component/easyui/icon.css" />
<e:style value="/resources/themes/base/boncBase@links.css"/>
<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
<html>
  <head>
    <title>指标库版本查询</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
 	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<script type="text/javascript">
		function show(v,r){
			return '<a href="javascript:void(0)" onclick="showDia('+r.V12+',\''+r.V6+'\',\''+r.V7+'\')">'+v+'</a>';
		}
		function showDia(kpi_key,caliber,explain){
			//var content='<div><span>指标口径：</span><textarea id="c" name="c" style="width:420px">'+caliber+'</textarea></div><div><span>指标解释：</span><textarea id="e" name="e" style="width:420px">'+explain+'</textarea></div>';
			//$('#show-dlg').dialog({content:content});
			//$('#show-dlg').dialog('open');
			window.open('../../../formulaKpiLook.e?kpi_key='+kpi_key);
		}
		function vfr(v,r){   
			if(v==1){
				return '<font size="3" color="red">是</font>';
			}               
			else{
				return '<font size="3">否</font>';
			}
		}
		function sfr(v,r){
			//return '<a href="javascript:void(0)" class="btn" onclick="pub('+r.V12+')">发布</a><a href="javascript:void(0)" class="btn" onclick="edit('+r.V12+')">编辑</a><a href="javascript:void(0)" class="btn" onclick="sibship(\''+v+'\',\''+r.V1+'\')">血缘关系</a>'
			return '<a href="javascript:void(0)" class="btn" onclick="pub('+r.V12+')">发布</a><a href="javascript:void(0)" class="btn" onclick="sibship(\''+v+'\',\''+r.V1+'\')">血缘关系</a>'
		}
		function pub(kpi_key){
		$.messager.confirm('确认信息','是否发布该指标?',function(r){
			if(r){
				$.post('<e:url value="/pages/kpi/version/kpi_version_action.jsp?action=pub"/>',{"kpi_key":kpi_key},function(data){
					if(data==1){
						$('#hisTable').datagrid('reload');
					}
				})			
			}
		})

		}
		function edit(kpi_key){
			window.open('../../../comKpilist.e?kpi_key='+kpi_key);
		}
		function sibship(v,n){
			//$('#sibwin').window('open');
		 	//$('#sib').attr('src',"../kpiManager/sibship.jsp?kpi_code="+v+"&kpi_name="+n);
		 	window.open("../kpiManager/sibship.jsp?kpi_code="+v+"&kpi_name="+n,'血缘关系', 'height=480, width=800, top=10, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');
		}
		$(function(){
			$('#sibwin').window({
				title:'Kpi',
				closed:true,
				collapsible:false,
				minimizable:false,
				modal:true,
				maximizable:false
			});
			
			$('#show-dlg').dialog({
				title:'口径&解释',
				closed:true
			});		
		});
		function showVer(value,rowData){
			return '<a href="javascript:void(0)" onclick="showVersion(\'${param.kpi_code}\',\''+rowData.V4+'\')">'+value+'</a>';
		}
		function showVersion(c,v){
			window.open('../../../formulaKpiLookVer.e?code='+c+'&version='+v);
		}
	</script>
  </head>
  
  <body>
    <c:datagrid url="/pages/kpi/version/kpi_version_action.jsp?action=list&kpi_code=${param.kpi_code}" id="hisTable" singleSelect="false" nowrap="false" fit="true" style="width:auto;height:90%;"   pageSize="15">
    	<thead>
    		<tr>
    			<th field="V1" width="120px" align="left" formatter="show">指标名称</th>
<!--     			<th field="V2" width="50px" align="left">指标分类</th> -->
<!--     			<th field="V3" width="50px" align="left">指标单位</th> -->
    			<th field="V4" width="50px" align="left">指标版本</th>
    			<th field="V5" width="50px" align="left" formatter="vfr">当前指标</th>
     			<th field="V6" width="150px" align="left">技术口径</th>
    			<th field="V7" width="150px" align="left">业务口径 </th>
    			<!--<th field="V8" width="50px" align="left">指标标记</th>
    			<th field="V9" width="50px" align="left">指标状态</th>
    			<th field="V10" width="50px" align="left">创建人</th>  -->
<!--     			<th field="V11" width="120px" align="center" formatter="sfr"></th>   -->
    		</tr>
    	</thead>
    </c:datagrid>
    <div id="show-dlg" style="width:500px;height:200px;top:50px;"></div>
	<div id="sibwin" style="width:1000px;height:650px;top:50px">
       	<iframe id="sib" src="" style="width:100%;height:98%;border:0;" frameboder="0"> 
    </div>
  </body>
</html>
