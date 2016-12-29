<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<e:q4l var="sysList">
   select IP ||':'|| PORT||'/'||APP_NAME as LOCATION,IP ||':'|| PORT||'/'||APP_NAME as LOCATION_NAME from X_CLUSTER_INFO
</e:q4l>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
		<title>Insert title here</title>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
		<script type="text/javascript">
		    var resultArr = [{value:'',text:'全部'},{value:'0',text:'同步成功'},{value:'1',text:'接收方原因同步失败'},{value:'2',text:'网络不通原因同步失败'},{value:'3',text:'其他原因同步失败'},{value:'4',text:'同步失败(全部原因)'}];
		    $(function(){
		    	var sysJson = ${e:java2json(sysList.list)};
		    	sysJson.unshift({LOCATION:'',LOCATION_NAME:'全部'});
		    	$("#sysFrom").combobox('loadData',sysJson).combobox({panelWidth:250}); 
		    	$("#sysTo").combobox('loadData',sysJson).combobox({panelWidth:250}); 
		    	$("#resultComb").combobox('loadData',resultArr); 
		    });
			function doQuery(){
				var info = {};
	    		info.result = $("#resultComb").combobox('getValue');
	    		info.startTime = $("#startTime").datebox('getValue');
	    		info.endTime = $("#endTime").datebox('getValue');
	    		info.sysFrom = $("#sysFrom").combobox('getValue');
	    		info.sysTo = $("#sysTo").combobox('getValue');
	    		$("#logTable").datagrid("reload",info);
			}
			function resultFormatter(value,rowData,rowIndex){
	    		return resultArr[parseInt(rowData.RESULT)+1].text;
	    	}
			 

			function dateFormatter(value,rowData,rowIndex){
				var datetime = rowData.CREATE_TIME;
				var year = datetime.substring(0,4);
				var month = datetime.substring(4,6);
				var day = datetime.substring(6,8);
				var hour = datetime.substring(8,10);
				var minute = datetime.substring(10,12);
				var second = datetime.substring(12,14);
				return year+"-"+month+"-"+day+" "+hour+":"+minute+":"+second;
			}
			
		</script>
	</head>
	<body>
		<div id="tbar" >
		<h2>集群同步日志</h2>
			<div class="search-area">
		       	 同步结果：<input class="easyui-combobox" data-options="valueField:'value',textField:'text'" style="width: 120px" id="resultComb"/>
				 发布系统：<input class="easyui-combobox" data-options="valueField:'LOCATION',textField:'LOCATION_NAME'" style="width: 120px" id="sysFrom"/>
				 接收系统：<input class="easyui-combobox" data-options="valueField:'LOCATION',textField:'LOCATION_NAME'" style="width: 120px" id="sysTo"/>
		    	 开始日期：<c:datebox id="startTime" style="width:100px" name="startTime" required="false" format="yyyymmdd"/>
		         结束日期：<c:datebox id="endTime" style="width:100px" name="endTime" required="false" format="yyyymmdd"/>
				 <a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
			</div>
	    </div>
	    <c:datagrid url="pages/xbuilder/pagemanager/SyncJspLogAction.jsp?eaction=LIST" id="logTable"
	       style="width:auto;height:500px;" fit="true" nowrap="false" toolbar="#tbar" pageSize="20" >
		<thead>
			<tr>
				<th field="XID" width="120">报表编号</th>
				<th field="SYS_FROM" width="200">发起系统</th>
				<th field="SYS_TO" width="200">接收系统</th>
				<th field="VERSION" width="50">版本号</th>
				<th field="RESULT" width="160" formatter="resultFormatter">同步结果</th>
				<th field="DEMO" width="200">描述信息</th>
				<th field="USER_NAME" width="100">创建人</th>
				<th field="CREATE_TIME" width="140" formatter="dateFormatter">创建时间</th>
			</tr>
		</thead>
	</c:datagrid>
	</body>
</html>