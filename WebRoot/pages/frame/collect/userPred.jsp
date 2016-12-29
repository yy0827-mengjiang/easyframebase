<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%> 


		<script type="text/javascript"> 
			$(function(){
				$(window).resize(function(){
				 	$('#predictTable').datagrid('resize');
				 });
			}); 
			function formatterCZ(value, rowData) {
				var returnString = '';
	            returnString = value;
	            var thisUrl = rowData.URL;//对应 sql中url
	            returnString='<a href="javascript:void(0)" onclick="theHref(\''+value+'\',\''+thisUrl+'\');"><font style="color:#f00">'+value+'</font></a>'; 
	            return returnString;
	         }
	         function theHref(menuName,url){
		         //thisUrl跳转的 URL
		         parent.window.open1(null,menuName,url);
		         //window.location.href=thisUrl;
		         $("#predDialog").dialog('close');
		     }
		</script>
		<c:datagrid id="predictTable" url="pages/frame/collect/userPredAction.jsp?eaction=list" 
		pageSize="15" style="width:auto;height:264px;"  download="指标预警" nowrap="false" >
			<thead>
				<tr> 
					<th field="KPI_NAME" width="80" align="center">
						指标名称
					</th> 
					<th field="COMPARE_VALUE_TYPE" width="60" align="center">
						指标类型
					</th> 
					<th field="KPI_VALUE" width="60" align="center">
						指标值
					</th> 
					<th field="THRESHOLD_VALUE" width="60" align="center">
						阀指
					</th> 
					<th field="THRESHOLD_ID" width="80" align="center">
						阀指波动类型
					</th> 
					<th field="WAVE_VALUE" width="60" align="center">
						阀指波动值
					</th>   
					<th field="RESOURCES_NAME" width="80" align="center" formatter="formatterCZ">
						菜单名称
					</th>  
				</tr>
			</thead>
		</c:datagrid>
