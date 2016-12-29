<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
	<base href="<%=request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ request.getContextPath() + "/"%>">
	<title>下钻表格</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<c:resources type="easyui"  style="${ThemeStyle }"/>
	<script type="text/javascript">
		function formatter(value,rowData,rowIndex){
			if(value){
				return '<font color=red>'+value+'</font>';
			}else{
				return 0;
			}
		}
	</script>
	<e:style value="resources/themes/base/boncBase@links.css"/>
	<e:style value="resources/themes/blue/boncBlue.css"/>
	</head>
<body>
<div class="exampleWarp">
<h1 class="titOne">旋转组件所有参数</h1>
<h1 class="titThree">参数</h1>
<table class="parameters">
	<colgrounp>
		<col width="15%" />
		<col width="*" />
		<col width="*" />
	</colgrounp>
	<tr>
		<td>dim</td>
		<td>旋转维度</td>
		<td>值为day显示本月所有天数；month显示当前月；码表 用户.表名。或日月值，值必须以20开头，如20140408</td>
	</tr>
	<tr>
		<td>field</td>
		<td>字段前缀</td>
		<td>自动生成的字段前缀，后加0123</td>
	</tr>
	<tr>
		<td>codedesc</td>
		<td>可选</td>
		<td>当是码表时，字段显示的表列，默认为code_desc</td>
	</tr>
	</table>
<h1 class="titTwo">示例1：按照day，日期旋转</h1>
<table id="tt1" style="width: 800px; height: auto;">
	<thead>
	<tr>
	<c:rotate dim="day" field="V" align="center" width="140" editor="text"/>
	</tr>
	</thead>
</table>
<c:treegrid id="tt1" idField="ID" treeField="VD" treeFieldTitle="地域"
			treeFieldWidth="170"
			url="/examples/rotate/demoActon.jsp?eaction=loadDim"
			defaultDim="all,area" menuWidth="170" download="下钻示例1">
			<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
			<c:dimension label="区县" field="city" group="area_group" level="1"></c:dimension>
		</c:treegrid>
<br/>
<br/>
<h1 class="titTwo">示例2：按照日期旋转，并且指定最大日期</h1>
<table id="tt2" style="width: 800px; height: auto;">
			<thead>
		<tr>
					<c:rotate dim="20140408" field="V" align="center" width="140" editor="text" formatter="formatter"/>
				</tr>
	</thead>
		</table>
<c:treegrid id="tt2" idField="ID" treeField="VD" treeFieldTitle="地域"
			treeFieldWidth="170"
			url="/examples/rotate/demoActon.jsp?eaction=loadDim"
			defaultDim="all,area" menuWidth="170" download="下钻示例2">
			<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
			<c:dimension label="区县" field="city" group="area_group" level="1"></c:dimension>
		</c:treegrid>
<br/>
<br/>
<h1 class="titTwo">示例3：按照月份旋转，并且格式化列</h1>
<table id="tt3" style="width: 800px; height: auto;">
			<thead>
		<tr>
					<c:rotate dim="month" field="V" align="center" width="140" editor="text" formatter="formatter"/>
				</tr>
	</thead>
		</table>
<c:treegrid id="tt3" idField="ID" treeField="VD" treeFieldTitle="地域"
			treeFieldWidth="170"
			url="/examples/rotate/demoActon.jsp?eaction=loadDim"
			defaultDim="all,area" menuWidth="170" download="下钻示例3">
			<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
			<c:dimension label="区县" field="city" group="area_group" level="1"></c:dimension>
		</c:treegrid>
<h1 class="titTwo">示例4：按照码表测试</h1>
<table id="tt4" style="width: 800px; height: auto;">
			<thead>
		<tr>
					<c:rotate dim="e_role" field="V" align="center" width="140" editor="text" codedesc="ROLE_NAME"/>
				</tr>
	</thead>
		</table>
<c:treegrid id="tt4" idField="ID" treeField="VD" treeFieldTitle="地域"
			treeFieldWidth="170"
			url="/examples/rotate/demoActon.jsp?eaction=loadDim"
			defaultDim="all,area" menuWidth="170" download="下钻示例3">
			<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
			<c:dimension label="区县" field="city" group="area_group" level="1"></c:dimension>
		</c:treegrid>
	</div>
</body>
</html>