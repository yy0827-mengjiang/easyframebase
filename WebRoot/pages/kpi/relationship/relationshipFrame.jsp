<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%-- <c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources> --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<e:q4l var="tl">
	SELECT T.ICON,T.TYPE_NAME FROM X_KPI_TYPE T WHERE T.TYPE_STATUS = '1'
</e:q4l>
<html>
  <head>
    
    <title>血缘关系</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<e:style value="/pages/kpi/relationship/css/base.css"/>
	<e:style value="/pages/kpi/relationship/css/Spacetree.css"/>
	<e:style value="/pages/kpi/relationship/css/prettify.css"/>
	<!--[if IE]><e:script value="/pages/kpi/relationship/js/excanvas.js"/><![endif]-->
	<style type="text/css">
		table{width:90%; margin-top:-10px; margin-left:7px; }
	</style>
	<script type="text/javascript">
		$(function(){
			 $('#formula-dlg').dialog({
				  title:"指标信息",
				  closed:true,
				  modal:true,
				  height:410,
				  width:550,
				  buttons:[{
					  text:"关闭",
					  iconCls:"icon-ok",
					  handler:function(){
						  $('#formula-dlg').dialog('close');
					  }
				  }]
			  });
		});
		$.getJSON("../../../ship.e",{"kpi_key":'${param.kpi_key}',"kpi_version":'${param.kpi_version}'},function(data){
			init(data[0].info);
			/* $('#kpiName').html(data[0].currNodeKpiName);
			$('#showTitle').html(data[0].currNodeKpiName);
         	$('#kpiVersion').html(data[0].currNodeVersion);
         	var _type = data[0].currNodeType;
         	if(_type=='100'){
         		_type = '报表';
         	}
         	$('#kpiType').html(_type);
         	if(data[0].currNodeCaliber!='--'){
         		$(".tha4").parents('tr').show();
        		$('#comment').html(node.data.KPI_CALIBER);
        	}else{
        		$(".tha4").parents('tr').hide();
        	}
         	$('#comment').html(data[0].currNodeCaliber);
         	if(data[0].currTables!='--'&&data[0].currColnum!='--'){
         		$('#table').html(data[0].currTables);
         		$('#colnum').html(data[0].currColnum);
         	}else{
         		$('tr[name="kpi"]').hide();
         	} */
         	
         	
         	
		});
		$(function(){
			$("button[name=close]").on('click',function(){
				$("#kpi").html("");
			    $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube=${param.cube_code}');
			});
		})

	</script>
	
  </head>
  <body>
  <div class="kpi_guide">
	<div class="tit_div1">
		<h3 id="showTitle">血缘信息</h3>
		<span>
           	<button type="button" name="close">关闭</button>
		</span>
	</div>
	<div class="editBase_div1">
	 <div class="editBase_div_child1">
      <div class="relationLeft">
     	 	<div class="loadArea">
     	 		<div id="container">
					<div id="center-container">
					    <div id="infovis" style="overflow: auto;width: 100%">  
					</div>
 				   
				</div>
     	 	</div>
      </div>
     <div>
		    <e:forEach items="${tl.list }" var="t">
				 <img style='width:25px;heigth:25px;' src='../../xbuilder/resources/themes/base/images/icons/${t.ICON }.png'>${t.TYPE_NAME }&nbsp;&nbsp;&nbsp;&nbsp;
			</e:forEach>
   	 </div> 
    <%--   <div class="relationRight">
      		<div class="relationData">
	  	 		<table class="shipTable">
					<colgroup>
						<col width="40%" />
						<col width="*" />
					</colgroup>
					<e:forEach items="${tl.list }" var="t">
						<tr>
							<td><img style='width:25px;heigth:25px;' src='../../xbuilder/resources/themes/base/images/icons/${t.ICON }.png'></td>
							<td>${t.TYPE_NAME }</td>
						</tr>
					</e:forEach>
				</table>
     		</div>
      </div> --%>
	   </div>
       </div>
      </div>
      </div>
      <div id="formula-dlg" class="easyui-dialog" style="width:650px;height:480px;" data-options="closed:true,modal:true">
  	 	  <table class="shipTable">
			<colgroup>
			<col width="40%" />
			<col width="*" />
			</colgroup>
				<tr>
					<th class="tha1">名称</th>
					<td id="kpiName"></td>
				</tr>
				<tr>
					<th class="tha2">版本</th>
					<td id="kpiVersion"></td>
				</tr>
				<tr>
					<th class="tha3">类型</th>
					<td id="kpiType"></td>
				</tr>
				<tr name="kpi">
					<th class="tha7">所在表</th>
					<td id="table"></td>
				</tr>
				<tr name="kpi">
					<th class="tha8">对应字段</th>
					<td id="colnum"></td>
				</tr>
				<tr>
					<th class="tha4">技术口径</th>
					<td>
						<span id="comment"></span>
					</td>
				</tr>
				<tr>
					<th class="tha9">业务口径</th>
					<td>
						<span id="comment1"></span>
					</td>
				</tr>
				<tr name="formula">
					<th class="tha5" >指标公式</th>
					<td></td>
				</tr>
				<tr name="formula">
					<td colspan="2" align="center">
						<span id="formula1"></span>
					</td>
				</tr>
				<tr name="cond">
					<th class="tha6">指标条件</th>
					<td></td>
				</tr>
				<tr name="cond">
					<td colspan="2">
						<table class="condTab formular_table" cellpadding="0" cellspacing="1">
							<thead>
								<tr>
									<td width="5%">
									</td>
									<td width="30%">名称/公式</td> 
									<td width="30%">连接符</td> 
									<td width="35%">条件值</td>
								</tr>
							</thead>
							<tbody id="cond1">
							</tbody>
						</table>
					</td>
				</tr>
			</table>
	      </div>
	</body>
</html>