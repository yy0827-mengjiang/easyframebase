<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<e:q4o var="dateId">
select t.const_value val
  from sys_const_table t
 where t.const_name in ('calendar.curday_candidate')
</e:q4o>
<e:set var="dateidd">${dateId.val}</e:set>
<e:if
	condition="${param.acct_day !=null && param.acct_day ne ''}">
	<e:set var="dateidd">${param.acct_day}</e:set>
</e:if>
<e:q4l var="areas">
	select area_no,area_no_desc from ${CODE }.code_area
	where area_no != '430'
</e:q4l>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>NettedType starting page</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
		<c:resources type="easyui" style="b" />
	</head>
	<script>
		$(function(){
			var info = {};
			info.acct_day = '${dateidd}';
			info.area_no = '${param.area_no}';
			info.app_code = 'APP_001';
			info.id_desc = 'P2P应用';
			info.colno = 'USERS_NUM';
			info.coldesc = '用户数(户)';
			info.myunit = '户';
			loadChart1(info);
			loadChart2(info);
			loadChart3(info);
		});
		function doQuery(){
			var $form = $('#form1');
			$form.attr('action','<e:url value="/pages/special/dpi/netted/DpiNettedType.jsp"/>');
			$form.submit();
		}
		function myFormat(value,rowData){
			if(value){
				var ary = value.split('-');
				var id = rowData.ID;
				var id_desc = rowData.C1;
				var cellValue = ary[0];
				var colno = ary[1];
				var coldesc = $('#netted_tt').datagrid("getColumnOption",colno).title;
				var rs='<a href="javascript:void(0);" style="text-decoration: none;color:black;" onclick="onCC(\''+id+'\',\''+id_desc+'\',\''+colno+'\',\''+coldesc+'\')">'+cellValue+'</a>';
				return rs;
			}else{
				return '';
			}
		}
		function onCC(id,id_desc,colno,coldesc){
			var info = {};
			info.acct_day = '${dateidd}';
			info.area_no = '${param.area_no}';
			var ary = id.split('-');
			if(ary.length>1){
				info.app_code = ary[0];
				info.bus_code = ary[1];
			}else{
				info.app_code = ary[0];
			}
			info.id_desc = id_desc;
			info.colno = colno;
			var str = coldesc.replace(/<br>/gi,'');
			info.coldesc = str;
			var myunit = str.substring(str.indexOf('(')+1,str.indexOf(')'));
			info.myunit = myunit;
			//alert(info.app_code+','+info.bus_code+','+info.id_desc+','+info.colno+','+info.coldesc+','+info.myunit);
			loadChart1(info);
			loadChart2(info);
			loadChart3(info);
		}
		function loadChart1(info){
			var temp = info.id_desc+' '+info.coldesc+" 趋势分析";
			$('#chart1').panel({title:temp});
			var path = '<e:url value="/pages/special/dpi/netted/DpiNettedTypeChart1.jsp"/>';
			$('#chart1').load(path,info,function(data){});
		}
		function loadChart2(info){
			var temp = info.coldesc+" 上网类型占比分析";
			$('#chart2').panel({title:temp});
			var path = '<e:url value="/pages/special/dpi/netted/DpiNettedTypeChart2.jsp"/>';
			$('#chart2').load(path,info,function(data){});
		}
		function loadChart3(info){
			var temp = info.coldesc+" 子项对比分析";
			$('#chart3').panel({title:temp});
			var path = '<e:url value="/pages/special/dpi/netted/DpiNettedTypeChart3.jsp"/>';
			$('#chart3').load(path,info,function(data){});
		}
	</script>
	<body class="plr_08">
		<form id="form1" name="form1" action="" style="padding: 0px; margin-bottom: 0px; margin-top: 0px;">
			<div class="Conbox">
				<table>
					<tr>
						<td>
							<font size="2">时间：
								<c:datebox id="acct_day" name="acct_day"
									required="true" defaultValue="${dateidd}" />
							</font>
							<font size="2">地市：
								<e:select id="area_no" name="area_no" items="${areas.list}" 
									label="area_no_desc" value="area_no" style="width:100px"
									headLabel="全省" headValue="" defaultValue="${param.area_no}"/>
							</font>
							<font size="2">
								<a href="javascript:void(0);" class="easyui-linkbutton"
									plain="true" onclick="doQuery();" iconCls="icon-search">查询</a>
							</font>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<table id="netted_tt" style="table-layout:fixed;height:auto">
			<thead>
				<tr>
					<th field="USERS_NUM" width="95%" editor="text" align="right" sortable="true" formatter="myFormat">用户数(户)</th>
					<th field="HITS" width="95%" editor="text" align="right" sortable="true" formatter="myFormat">访问量(次)</th>
					<th field="HF" width="95%" editor="text" align="right" sortable="true" formatter="myFormat">户均访问量<br>(次/户)</th>
					<th field="FLOW" width="95%" editor="text" align="right" sortable="true" formatter="myFormat">流量(MB)</th>
					<th field="HL" width="95%" editor="text" align="right" sortable="true" formatter="myFormat">户均流量<br>(MB/户)</th>
				</tr>
			</thead>
		</table>
		<c:treetable id="netted_tt" idField="ID" treeField="C1" treeFieldTitle="类型名称"
			treeFieldWidth="220"
			url="/pages/example/drilldown/DpiNettedTypeAction.jsp?acct_day=${dateidd}&area_no=${param.area_no}"
			defaultDim="a1" menuWidth="100">
			<c:dimension label="业务类型" field="a2">
			<c:dimension label="地市" field="area">
			</c:dimension>
		</c:treetable>
	</body>
</html>
