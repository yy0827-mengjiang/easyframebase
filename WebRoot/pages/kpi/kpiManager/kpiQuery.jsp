<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources> 
<e:q4l var="kpiType">select code,name from X_KPI_CODE_TYPE where type='1' order by ord</e:q4l>
<e:q4l var="serviceType">select code,name from X_KPI_CODE_TYPE where type='2' order by ord</e:q4l>
<e:q4l var="classification">select code,name from X_KPI_CODE_TYPE where type='3' order by ord</e:q4l>
<e:q4l var="cycle">select code,name from X_KPI_CODE_TYPE where type='4'  order by ord</e:q4l>
<e:q4l var="reservedAttr">select code,name from X_KPI_CODE_TYPE where type='6' order by ord</e:q4l>
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
	<script>
		function query(){
			var params={};
			params.service_key = $("#service_key").val();
			params.kpi_name=$('#kpi_name').val();
			//params.kpi_iscurr=$('#kpi_iscurr').val();
			params.cube_code = $("#cube_code").combobox("getValue");
			/* params.kt = $("#kt").val();
			params.st = $("#st").val();
			params.cl = $("#cl").val();
			params.cy = $("#cy").val();
			params.ra = $("#ra").val(); */
			params.kpi_category = $("#kpi_category").combotree("getValue");
			params.kpiFlag = $("#kpiFlag").combobox("getValue");
			$('#kpiTable').datagrid('options').queryParams=params;
			$('#kpiTable').datagrid('reload');
		}
		function fr(value,row,index){
			return '<a id="kpi_status_1" href="javascript:void(0)" onclick="openDlg(\''+ row.V0 +'\')">'+value+'</a>';
		}
		function frhis(value,row,index) {
			return '<a id="kpi_status_1" href="javascript:void(0)" onclick="hisView(\''+ row.V1 +'\')">'+value+'</a>';
		}
		function openDlg(kpi_key){
			$('#other_data_dialog').dialog('open');
			$("#other_data_load").load('<e:url value="/pages/kpi/kpiManager/kpiQueryAudit.jsp"/>',{"kpi_key":kpi_key},function(data){
				$.parser.parse($("#other_data_load"));
			});
		}
		function hisView(kpi_code) {
	        window.open('../version/kpiTimelinr.jsp?kpi_code='+kpi_code,'历史版本', 'height=480, width=800, top=60, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');

		}
		function fView(value,row,index){
			return '<a href="javascript:void(0)" onclick="winView('+row.V0+')">'+value+'</a>';
		}		
		function winView(kpi_key){
			window.open('../../../formulaKpiLook.e?kpi_key='+kpi_key);
		}
		$(function(){
			$('#cube_code').combobox({
				editable : false,
				width : 150,
				url : '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCube"/>',
				valueField : 'CUBE_CODE',
				textField : 'CUBE_NAME',
				value :'',
				onSelect : function(_value) {
// 					$('#kpi_category').combotree({
// 					    url: '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory&cube_code="/>'+_value,
// 					    required: true
// 					});
					$('#kpi_category').combotree('reload');
				}
			});
			$('#kpi_category').combotree({
			    url: '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory"/>',
			    required: true,
			    value:'0',
			    onBeforeExpand:function(node) {
			    	var _cube_code = $('#cube_code').combobox("getValue");
			    	if(_cube_code==null ||_cube_code==' '){
			    		return false;
			    	}
			    	$('#kpi_category').combotree("tree").tree("options").url = '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory&cube_code="/>'+_cube_code;
			    }
			});
			$('#kpiFlag').combobox({
				editable : false,
				width : 100,
				url : '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryFlag"/>',
				valueField : 'VALUE',
				textField : 'TEXT',
				value :''
			});
		});
		function expPort(){
			cube_code = $('#cube_code').combobox("getValue");
			kpi_category = $('#kpi_category').combobox("getValue");
			kpi_status = $("#kpiFlag").combobox("getValue");
			kpi_code = $('#service_key').val();
			kpi_name=$('#kpi_name').val();
			window.location.href = "../../../expExcel.e?cube_code="+cube_code+"&kpi_category="+kpi_category+"&kpi_status="+kpi_status+"&kpi_code="+kpi_code+"&kpi_name="+kpi_name;
		}
	</script>	
  </head>
  
  <body>
  	<div id="tb">
  		<h2>指标查询</h2>
  		<div class="search-area">
  		            指标编码：<input type="text" id="service_key"/>
  			数据魔方：	<input id="cube_code">
  			<%-- <select id="cube_code">
						<option value="">--全部--</option>
					 	<e:forEach items="${cube.list }" var="c">
					 		<option value="${c.cube_code }">${c.cube_name }</option>
					 	</e:forEach>
					 </select> --%>&nbsp;&nbsp;
  		         <%--    业务编码：<select id="kt" name="kt">
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
				</select>
				<select id="ra" name="ra">
					<option value="">--全部--</option>
				    <e:forEach items="${reservedAttr.list}" var="ra">
		                 <option value ="${ra.CODE}">${ra.NAME}</option>	
		            </e:forEach>	
				</select>&nbsp;&nbsp; --%>
		          指标分类：<input id="kpi_category">
			指标状态：<input id="kpiFlag" name="kpiFlag">&nbsp;&nbsp;
  			指标名称： <input type="text" id="kpi_name"/>
  			<a class="easyui-linkbutton" onclick="query()">查询</a>
  			<a class="easyui-linkbutton" onclick="expPort()">导出</a>
  		</div>
  	</div>
    <c:datagrid url="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=query&queryFlag=1" id="kpiTable" singleSelect="true" nowrap="true" fit="true" toolbar="#tb" pageSize="20">
    	<thead>
    		<tr>
				<th field="V19"  formatter="fView"  width="80">指标编码</th>
    			<th field="V2" formatter="fView" width="100">指标名称</th>
    			<th field="V5" width="40" formatter="frhis">指标版本</th>
    			<th field="V21" width="50">指标类型</th>
<!--     			<th field="V7" width="100">技术口径</th> -->
<!--    				<th field="V8" width="100">业务口径</th> -->
    			<th field="V10" width="60">审核状态</th>
    			<th field="V9">指标状态</th>
    			<th field="V12" width="50">创建人</th>
    			<th field="V13" width="80">创建时间</th>
		    	<th field="V14" width="50">修改人</th>
    			<th field="V15" width="80">修改时间</th>
<!--     			<th field="V16" width="10%">审核人</th> -->
<!--     			<th field="V17" width="12%">审核时间</th> -->
    			<!--<th field="V6" width="80px">当前指标</th>
    			<th field="V7">指标口径</th>
    			<th field="V1">指标编码</th>
    			<th field="V8">指标解释</th>
    			<th field="V9">指标标记</th> -->
<!--     			<th field="V10" width="80px" formatter="fr">操作</th>    			 -->
    		</tr>
    	</thead>
    </c:datagrid>
	<div id="other_data_dialog" class="easyui-dialog" title="审核结果" data-options="closed:true,modal:true,top:80" style="width:650px; height:350px;">
			<div id="other_data_load" data-options="region:'center',fit:true">
			</div>
	</div>
  </body>
</html>
