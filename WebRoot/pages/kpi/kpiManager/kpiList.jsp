<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<e:set var="cube_code" value="${param.cube_code}"></e:set>
<e:q4l var="kpiType">select code,name from X_KPI_CODE_TYPE where type='1' order by ord</e:q4l>
<e:q4l var="serviceType">select code,name from X_KPI_CODE_TYPE where type='2' order by ord</e:q4l>
<e:q4l var="classification">select code,name from X_KPI_CODE_TYPE where type='3' order by ord</e:q4l>
<e:q4l var="cycle">select code,name from X_KPI_CODE_TYPE where type='4'  order by ord</e:q4l>
<html>
  <head>
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	<script type="text/javascript">
		function query(){ 
			var params={};
			params.kpi_name=$('#kpi_name').val();
			params.kpi_iscurr=$('#kpi_iscurr').val();
			$('#kpiTable').datagrid('options').queryParams=params;
			$('#kpiTable').datagrid('reload');
		}
		function fr(value,row,index){
			var edit = '<a id="kpi_status_1" href="javascript:void(0)" onclick="openDlg(\''+ row.V0 +'\')">编辑</a>';
			var del = '<a id="kpi_status_1" href="javascript:void(0)" onclick="openDlg(\''+ row.V0 +'\')">删除</a>';
 			return edit + del;
		}
		function busiExplain(value,row,index) {
			return '<a id="kpi_status_2" href="javascript:void(0)" onclick="openDlg(\''+ value +'\',\'业务口径\')">'+value+'</a>';
		}
		function techExplain(value,row,index) {
			return '<a id="kpi_status_3" href="javascript:void(0)" onclick="openDlg(\''+ value +'\',\'技术口径\')">'+value+'</a>';
		}
		function openDlg(value,title){
			$("#explain").html(value);
			$('#other_data_dialog').dialog({title:title});
			$('#other_data_dialog').dialog('open');
		}
		function fView(value,row,index){
			return '<a href="javascript:void(0)" onclick="winView('+row.V0+')">'+value+'</a>';
		}
		function addKpiInfo(){
			var cube_code = $("#cube_code").val();
			window.open('kpiManager.jsp?cube_code=' + cube_code);
		}
	</script>	
  </head>
  
  <body>
  	<div id="tb">
  		<h2>指标管理</h2>
  		<div class="search-area">
  			业务编码：<select id="kt" name="kt">
        			<option value="">--全部--</option>
				    <e:forEach items="${kpiType.list}" var="kt">
		                 <option value ="${kt.CODE}">${kt.NAME}</option>	
		            </e:forEach>	
				</select>
				<select id="st" name="st">
					<option value="">--全部--</option>
				    <e:forEach items="${serviceType.list}" var="st">
		                 <option value ="${st.CODE}">${st.NAME}</option>	
		            </e:forEach>	
				</select>
				<select id="cl" name="cl">
					<option value="">--全部--</option>
				    <e:forEach items="${classification.list}" var="cl">
		                 <option value ="${cl.CODE}">${cl.NAME}</option>	
		            </e:forEach>	
				</select>
				<select id="cy" name="cy">
					<option value="">--全部--</option>
				    <e:forEach items="${cycle.list}" var="cy">
		                 <option value ="${cy.CODE}">${cy.NAME}</option>	
		            </e:forEach>	
				</select>&nbsp;&nbsp;
  			指标名称： <input type="text" id="kpi_name"/>
  			<a class="easyui-linkbutton" onclick="query()">查询</a>
			<a class="easyui-linkbutton" onclick="addKpiInfo()">新增</a>
  			
  		</div>
  	</div>
    <c:datagrid url="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=query&queryFlag=1&cube_code=${cube_code}" id="kpiTable" style="width:auto;"singleSelect="true" nowrap="false" fit="true" toolbar="#tb">
    	<thead>
    		<tr>
				<th field="V19" width="70">指标编码</th>
    			<th field="V2"  width="100">指标名称</th> 
    			<th field="V5" width="40">指标版本</th>
   				<th field="V8" width="150" formatter="busiExplain">业务口径</th>
    			<th field="V7" width="150" formatter="techExplain">技术口径</th>
<!--     			<th field="V10" width="15%">审核状态</th> -->
    			<th field="V12" width="60">创建人</th>
    			<th field="V13" width="60">创建时间</th>
<!--     			<th field="V14" width="10%">修改人</th> -->
<!--     			<th field="V15" width="12%">修改时间</th> -->
<!--     			<th field="V16" width="10%">审核人</th> -->
<!--     			<th field="V17" width="12%">审核时间</th> -->
    			<!--<th field="V6" width="80px">当前指标</th>
    			<th field="V7">指标口径</th>
    			<th field="V1">指标编码</th>
    			<th field="V8">指标解释</th>
    			<th field="V9">指标标记</th> -->
    			<th field="V10" width="60" formatter="fr">操作</th>    			
    		</tr>
    	</thead>
    </c:datagrid> 
	<div id="other_data_dialog" title="" class="easyui-dialog"  data-options="closed:true,modal:true,top:80" style="width:350px; height:220px;">
			 <div id="explain"></div>
	</div>
  </body>
</html>
