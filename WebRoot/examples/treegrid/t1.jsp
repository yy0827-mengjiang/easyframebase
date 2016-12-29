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
	function colFormatter1(value,rowData,rowIndex){
		return '<font color=red>'+value+'</font>';
	}
	function clickTT5Row(row){
		alert(row.V1);
	}
	function clickTT6Cell(field,row){
		alert(field);
	}
</script>
<e:style value="resources/themes/base/boncBase@links.css"/>
<e:style value="resources/themes/blue/boncBlue.css"/></head>
<body>
<div class="exampleWarp">
<h1 class="titOne">下钻表格所有参数</h1>
<h1 class="titThree">参数</h1>
<table class="parameters">
	<colgrounp>
		<col width="15%" />
		<col width="*" />
		<col width="*" />
	</colgrounp>
	<tr>
		<td>id</td>
		<td>表格id</td>
		<td>表格头的id</td>
	</tr>
	<tr>
		<td>idField</td>
		<td>主键对应列</td>
		<td>下钻维护的唯一标识，如地市的编码等</td>
	</tr>
	<tr>
		<td>treeField</td>
		<td>树对应列</td>
		<td>下钻列</td>
	</tr>
	<tr>
		<td>treeFieldTitle</td>
		<td>树对应列的标题</td>
		<td>下钻列标题</td>
	</tr>
	<tr>
		<td>treeFieldWidth</td>
		<td>树对应列的宽度</td>
		<td>下钻列宽度</td>
	</tr>
	<tr>
		<td>url</td>
		<td>数据路径</td>
		<td>查询表格数据的地址</td>
	</tr>
	<tr>
		<td>menuWidth</td>
		<td>维度菜单宽度</td>
		<td>下钻维度菜单的宽度</td>
	</tr>
	<tr>
		<td>defaultDim</td>
		<td>默认选中维度</td>
		<td>默认下钻的维护[自动][多个以,隔开,如area,city]</td>
	</tr>
	<tr>
		<td>onClickRow</td>
		<td>单击行事件</td>
		<td>onClickRow(row) ，row为点击行所有数据</td>
	</tr>
	<tr>
		<td>onClickCell</td>
		<td>单击列事件</td>
		<td>onClickCell(field,row)，field为点击的列，row为点击行所有数据</td>
	</tr>
	<tr>
		<td>download</td>
		<td>导出文件的名称</td>
		<td>导出文件的名称</td>
	</tr>
	<tr>
		<td>downArgs</td>
		<td>导出文件的获得sql的参数，格式为&A=33&b=44</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>extds</td>
		<td>数据源类型</td>
		<td>数据源类型，不填为框架默认数据源</td>
	</tr>
</table>
<h1 class="titTwo">示例1：顺序下钻表格，level参数，从0开始，必须先下钻地市，然后才可以下钻区县</h1>
<table id="tt1" style="width: 800px; height: auto;">
			<thead>
		<tr>
					<th field="V1" align="center" width="140" editor="text"> 指标1 </th>
					<th field="V2" align="center" width="140" editor="text"> 指标2 </th>
					<th field="V3" align="center" width="140" editor="text"> 指标3 </th>
				</tr>
	</thead>
		</table>
<c:treegrid id="tt1" idField="ID" treeField="V0" treeFieldTitle="地域"
			treeFieldWidth="170"
			url="/examples/treegrid/demoActon.jsp?eaction=loadDim"
			defaultDim="all,area" menuWidth="170" download="下钻示例1">
			<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
			<c:dimension label="区县" field="city" group="area_group" level="1"></c:dimension>
		</c:treegrid>
<h1 class="titTwo">示例2：自由下钻表格，level参数，都为0，地市、日期可以任意下钻</h1>
<table id="tt2" style="width: 800px; height: auto;">
	<thead>
	<tr>
		<th field="V1" align="center" width="140" editor="text"> 指标1 </th>
		<th field="V2" align="center" width="140" editor="text"> 指标2 </th>
		<th field="V3" align="center" width="140" editor="text"> 指标3 </th>
	</tr>
	</thead>
</table>
<c:treegrid id="tt2" idField="ID" treeField="V0" treeFieldTitle="维度"
			treeFieldWidth="170"
			url="/examples/treegrid/demoActon.jsp?eaction=loadDim"
			defaultDim="all,day" menuWidth="170" download="下钻示例2">
			<c:dimension label="日期" field="day" group="area_group" level="0"></c:dimension>
			<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
		</c:treegrid>
<h1 class="titTwo">示例3：自由下钻表格，level参数，都为0，地市、日期可以任意下钻，导出</h1>
<table id="tt3" style="width: 800px; height: auto;">
	<thead>
		<tr>
			<th field="V1" align="center" width="140" editor="text"> 指标1 </th>
			<th field="V2" align="center" width="140" editor="text"> 指标2 </th>
			<th field="V3" align="center" width="140" editor="text"> 指标3 </th>
		</tr>
	</thead>
</table>
<c:treegrid id="tt3" idField="ID" treeField="V0" treeFieldTitle="维度"
			treeFieldWidth="170"
			url="/examples/treegrid/demoActon.jsp?eaction=loadDim"
			defaultDim="all,day" menuWidth="170" download="下钻示例3">
			<c:dimension label="日期" field="day" group="area_group" level="0"></c:dimension>
			<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
		</c:treegrid>
<c:export id="tt3" fileName="下钻导出示例3"/>
<h1 class="titTwo">示例4：自由下钻表格，level参数，都为0，地市、日期可以任意下钻，格式化列</h1>
<table id="tt4" style="width: 800px; height: auto;">
	<thead>
	<tr>
		<th field="V1" align="center" width="140" editor="text"> 指标1 </th>
		<th field="V2" align="center" width="140" editor="text"> 指标2 </th>
		<th field="V3" align="center" width="140" editor="text" formatter="colFormatter1"> 指标3 </th>
	</tr>
	</thead>
</table>
<c:treegrid id="tt4" idField="ID" treeField="V0" treeFieldTitle="维度"
			treeFieldWidth="170"
			url="/examples/treegrid/demoActon.jsp?eaction=loadDim"
			defaultDim="all" menuWidth="170" download="下钻示例4">
			<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
		</c:treegrid>
<h1 class="titTwo">示例5：自由下钻表格，level参数，都为0，地市、日期可以任意下钻。单击行事件</h1>
<table id="tt5" style="width: 800px; height: auto;">
<thead>
	<tr>
		<th field="V1" align="center" width="140" editor="text"> 指标1 </th>
		<th field="V2" align="center" width="140" editor="text"> 指标2 </th>
		<th field="V3" align="center" width="140" editor="text"> 指标3 </th>
	</tr>
</thead>
</table>
<c:treegrid id="tt5" idField="ID" treeField="V0" treeFieldTitle="维度"
			treeFieldWidth="170"
			url="/examples/treegrid/demoActon.jsp?eaction=loadDim"
			defaultDim="all,day" menuWidth="170" download="下钻示例5" onClickRow="clickTT5Row">
			<c:dimension label="日期" field="day" group="area_group" level="0"></c:dimension>
			<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
		</c:treegrid>
<h1 class="titTwo">示例6：自由下钻表格，level参数，都为0，地市、日期可以任意下钻。单击列事件</h1>
<table id="tt6" style="width: 800px; height: auto;">
<thead>
	<tr>
		<th field="V1" align="center" width="140" editor="text"> 指标1 </th>
		<th field="V2" align="center" width="140" editor="text"> 指标2 </th>
		<th field="V3" align="center" width="140" editor="text"> 指标3 </th>
	</tr>
</thead>
</table>
<c:treegrid id="tt6" idField="ID" treeField="V0" treeFieldTitle="维度"
			treeFieldWidth="170"
			url="/examples/treegrid/demoActon.jsp?eaction=loadDim"
			defaultDim="all,day" menuWidth="170" download="下钻示例6" onClickCell="clickTT6Cell">
			<c:dimension label="日期" field="day" group="area_group" level="0"></c:dimension>
			<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
		</c:treegrid>
<h1 class="titTwo">示例7：自由下钻表格，level参数，都为0，地市、日期可以任意下钻。分组</h1>
<table id="tt7" style="width: 800px; height: auto;">
<thead>
	<tr>
		<th field="V1" align="center" width="140" editor="text"> 指标1 </th>
		<th field="V2" align="center" width="140" editor="text"> 指标2 </th>
		<th field="V3" align="center" width="140" editor="text"> 指标3 </th>
	</tr>
</thead>
</table>
<c:treegrid id="tt7" idField="ID" treeField="V0" treeFieldTitle="维度"
			treeFieldWidth="170"
			url="/examples/treegrid/demoActon.jsp?eaction=loadDim"
			defaultDim="all" menuWidth="170" download="下钻示例7">
			<c:dimension label="日期" field="day" group="day_group" level="0"></c:dimension>
			<c:dimensionGroup label="地域分组" menuWidth="140">
		<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
		<c:dimension label="区县" field="city" group="area_group" level="1"></c:dimension>
	</c:dimensionGroup>
		</c:treegrid>
<h1 class="titTwo">示例8：自由下钻表格，level参数，都为0，地市、日期可以任意下钻。复杂表头</h1>
<table id="tt8" style="width: 800px; height: auto;">
<thead>
	<tr>
		<th align="center" width="140" colspan="3"> 指标列 </th>
	</tr>
	<tr>
		<th field="V1" align="center" width="140" editor="text"> 指标1 </th>
		<th field="V2" align="center" width="140" editor="text"> 指标2 </th>
		<th field="V3" align="center" width="140" editor="text"> 指标3 </th>
	</tr>
</thead>
</table>
<c:treegrid id="tt8" idField="ID" treeField="V0" treeFieldTitle="维度"
			treeFieldWidth="170"
			url="/examples/treegrid/demoActon.jsp?eaction=loadDim"
			defaultDim="all,day" menuWidth="170" download="下钻示例8">
			<c:dimension label="日期" field="day" group="area_group" level="0"></c:dimension>
			<c:dimension label="地市" field="area" group="area_group" level="0"></c:dimension>
		</c:treegrid>
<c:export id="tt8" fileName="下钻示例8"/>
</div>
</body>
</html>