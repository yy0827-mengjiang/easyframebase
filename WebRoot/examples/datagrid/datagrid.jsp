<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>表格组件实例</title>
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<script type="text/javascript">
			function colFormatter1(value,rowData,rowIndex){
				return '<a href="#">'+value+'</a>';
			}
			function colFormatter2(value,rowData,rowIndex){
				if (value < 20){   
					return '<span style="color: red">'+value+'</span>';
				}else{
					return value;
				}
			}
			function onClickRow(rowIndex, rowData){
				alert("行单击事件"+rowIndex+rowData.AREA_NO);
			}
			function onDblClickRow(rowIndex, rowData){
				alert("行双击事件"+rowIndex+rowData.AREA_NO);
			}
			function onClickCell(rowIndex, field, value){
				alert("单元格单击事件"+rowIndex+field+value);
			}
			function onDblClickCell(rowIndex, field, value){
				alert("单元格双击事件"+rowIndex+field+value);
			}
			function onLoadSuccess(data){
				alert("加载当前页面数据成功事件:"+$.toJSON(data));
			}
			function onBeforeLoad(param){
				alert("数据表格预加载事件:"+$.toJSON(param));
			}
			function getSelected(){
				var selected = $('#table3').datagrid('getSelected');
				if (selected){
					alert("firstSelected\nAREA_NO:"+selected.AREA_NO+"|CITY_NO:"+selected.CITY_NO );
				}
			}
			function getSelections(){
				var ids = [];
				var rows = $('#table3').datagrid('getSelections');
				for(var i=0;i<rows.length;i++){
					ids.push(rows[i].AREA_NO);
				}
				alert("ALL AREA_NOS:"+ids.join(':'));
			}
			function clearSelections(){
				$('#table3').datagrid('clearSelections');
			}
			function aa(){
				alert($("button").is("#aaa"));
				/*alert("".index());vs
				/*var array=[3,2,2,3,2,9,4,9];
				array.sort();
				$.unique(array);
				for(var i=0;i<array.length;i++){
					alert(array[i]);
				}
				*/
				/*var array=$.map([-1,3,2,6],function(n){return [n,n+1];});
				for(var i=0;i<array.length;i++){
					alert(array[i]);
				}
				*/
				
				/*alert($.inArray(3,[0,2,3,1,3]));*/
				
				/*var array=$.grep([0,1,2], function(n,i){
						  return n > 0;
						}); 
				for(var i=0;i<array.length;i++){
					alert(array[i]);
				}
				*/
			}
		</script>
		<e:style value="resources/themes/base/boncBase@links.css"/>
		<e:style value="resources/themes/blue/boncBlue.css"/>
		</head>
<body>
<div class="exampleWarp">
<h1 class="titOne">普通表格</h1>
<h1 class="titThree">基本数据表格</h1>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table1" download="true" style="height:400px;">
	<thead>
		<tr>
			<th field="AREA_NO" width="300">地市编号</th>
			<th field="CITY_NO" width="300">区县编号</th>
			<th field="VALUE1" width="300">指标1</th>
			<th field="VALUE2" width="300">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">不分页表格</h1>
<div class="lable">&lt;c:datagrid&gt;标签的pagination属性设置为false</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table2" download="true" style="width:800px;height:400px;" pagination="false">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">数据表格添加checkbox</h1>
<div class="lable"> <a href="#" onclick="getSelected();return false;">GetSelected</a> <a href="#" onclick="getSelections();return false;">GetSelections</a> <a href="#" onclick="clearSelections();return false;">ClearSelections</a>[当表格要实现多选时，需要将属性singleSelect设置为false，如singleSelect="false"，默认为单选。]</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table3" singleSelect="false" style="width:900px;height:400px;" title="表格标题可自由定义">
	<thead>
		<tr>
			<th field="ck" checkbox="true"></th>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">化数据表格分页设置</h1>
<div class="lable"> &lt;c:datagrid&gt;标签的pageSize属性为设置初始页数据记录数的（当前为25），pageList属性为设置数据表都有什么样的分页大小的（当前为10,15,20,25）； <br/>
	注：pageSize属性的值必须与pageList属性的某个分页大小值相等 </div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table4" pageSize="25" pageList='10,15,20,25' style="width:900px;height:400px;" title="表格标题可自由定义">
	<thead>
		<tr>
			<th field="ck" checkbox="true"></th>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">数据表格行单击事件</h1>
<div class="lable"> 设置&lt;c:datagrid&gt;标签的onClickRow属性为js方法名，该js方法有两个参数 行索引（rowIndex）, 行数据（rowData）</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table5" onClickRow="onClickRow" style="width:800px;height:400px;">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">数据表格行双击事件</h1>
<div class="lable">设置&lt;c:datagrid&gt;标签的onDblClickRow属性为js方法名，该js方法有两个参数 行索引（rowIndex）, 行数据（rowData） </div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table6" onDblClickRow="onDblClickRow" style="width:800px;height:400px;">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">数据表格单元格单击事件</h1>
<div class="lable">设置&lt;c:datagrid&gt;标签的onClickCell属性为js方法名，该js方法有三个参数 ,行索引（rowIndex）, 列对应字段名（field）,单元格（value）</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table7" singleSelect="false" onClickCell="onClickCell" style="width:800px;height:400px;">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">数据表格单元格双击事件</h1>
<div class="lable"> 设置&lt;c:datagrid&gt;标签的onDblClickCell属性为js方法名，该js方法有三个参数 ,行索引（rowIndex）, 列对应字段名（field）,单元格（value）</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table8" onDblClickCell="onDblClickCell" style="width:800px;height:auto;">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">加载当前页面数据成功事件事件</h1>
<div class="lable"> 设置&lt;c:datagrid&gt;标签的onLoadSuccess属性为js方法名，该js方法有1个参数 请求参数（data）;查看效果请点击<a href='datagrid.jsp?isLoadSuccess=1'>onLoadSuccess</a></div>
<e:if condition="${param.isLoadSuccess=='1' }">
	<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table21" onLoadSuccess="onLoadSuccess" style="width:800px;height:auto;">
		<thead>
			<tr>
				<th field="AREA_NO" width="100">地市编号</th>
				<th field="CITY_NO" width="100">区县编号</th>
				<th field="VALUE1" width="100">指标1</th>
				<th field="VALUE2" width="100">指标2</th>
				<th field="VALUE3" width="200">指标3</th>
				<th field="VALUE4" width="200">指标4</th>
			</tr>
		</thead>
	</c:datagrid>
</e:if>
<e:if condition="${param.isLoadSuccess!='1'}">
	<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table21" style="width:800px;height:auto;">
		<thead>
			<tr>
				<th field="AREA_NO" width="100">地市编号</th>
				<th field="CITY_NO" width="100">区县编号</th>
				<th field="VALUE1" width="100">指标1</th>
				<th field="VALUE2" width="100">指标2</th>
				<th field="VALUE3" width="200">指标3</th>
				<th field="VALUE4" width="200">指标4</th>
			</tr>
		</thead>
	</c:datagrid>
</e:if>

<h1 class="titThree">数据表格预加载事件</h1>
<div class="lable"> 设置&lt;c:datagrid&gt;标签的onBeforeLoad属性为js方法名，该js方法有1个参数 请求参数（param）;查看效果请点击<a href='datagrid.jsp?isBeforeLoad=1'>onBeforeLoad</a></div>
<e:if condition="${param.isBeforeLoad=='1' }">
			<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table9" 
		onBeforeLoad="onBeforeLoad" style="width:800px;height:auto;">
		<thead>
			<tr>
				<th field="AREA_NO" width="100">地市编号</th>
				<th field="CITY_NO" width="100">区县编号</th>
				<th field="VALUE1" width="100">指标1</th>
				<th field="VALUE2" width="100">指标2</th>
				<th field="VALUE3" width="200">指标3</th>
				<th field="VALUE4" width="200">指标4</th>
			</tr>
		</thead>
	</c:datagrid>
		</e:if>
<e:if condition="${param.isBeforeLoad!='1' }">
			<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table9" style="width:800px;height:auto;">
		<thead>
			<tr>
				<th field="AREA_NO" width="100">地市编号</th>
				<th field="CITY_NO" width="100">区县编号</th>
				<th field="VALUE1" width="100">指标1</th>
				<th field="VALUE2" width="100">指标2</th>
				<th field="VALUE3" width="200">指标3</th>
				<th field="VALUE4" width="200">指标4</th>
			</tr>
		</thead>
	</c:datagrid>
		</e:if>
<h1 class="titThree">表格数据导出</h1>
<div class="lable">设置&lt;c:datagrid&gt;标签的download属性为导出文件名，downArgs为导出文件的获得sql的参数；downArgs可以不设置</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table10" download="true" downArgs="&A=33&b=44" style="width:800px;height:400px;">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">数据表格单元格内容超出后不换行</h1>
<div class="lable">设置&lt;c:datagrid&gt;标签的nowrap属性为true，false为超出后换行 </div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table11" nowrap="true" style="width:800px;height:400px;">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="20">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">锁定数据表格行列</h1>
<div class="lable"> 设置&lt;c:datagrid&gt;标签的frozenRows属性为 要锁定的前几行（当前为3），frozenColumns属性为 要锁定的列对象数组字符串（当前为[[{title:'地市编号',field:'AREA_NO',width:100}]]）；</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table112" download="" style="width:500px;height:300px;" frozenRows="3" pagination="true" frozenColumns="[[{title:'地市编号',field:'AREA_NO',width:100}]]">
	<thead>
		<tr>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="200">指标1</th>
			<th field="VALUE2" width="240">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="400">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">数据表格默认排序</h1>
<div class="lable">设置&lt;c:datagrid&gt;标签的sortName属性为 默认排序列列名，sortOrder属性为 排序方式（正序：asc/倒序：desc）；sortOrder属性为设置，默认为正序</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table13" sortName="AREA_NO" sortOrder="desc" style="width:800px;height:400px;">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">数据表格列客户端排序</h1>
<div class="lable"> 设置&lt;c:datagrid&gt;标签的remoteSort属性为false,并且&lt;c:datagrid&gt;标签下允许排序的th元素的sortable属性为true </div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table14" style="width:800px;height:400px;" title="表格标题可自由定义" remoteSort="false">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100" sortable="true">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">数据表服务端列排序</h1>
<div class="lable">当要以数据表服务端列排序的时候，&lt;c:datagrid&gt;标签的remoteSort属性应该设置为true或不设置(默认remoteSort属性为true),并且在允许排序的&lt;th&gt;中设置sortable属性为true</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table15" style="width:800px;height:400px;" >
	<thead data-options="frozen:true">
		<tr>
			<th field="AREA_NO" width="100" sortable="true">地市编号</th>
			<th field="CITY_NO" width="100" sortable="true">区县编号</th>
			<th field="VALUE1" width="100" sortable="true">指标1</th>
			<th field="VALUE2" width="100" sortable="true">指标2</th>
			<th field="VALUE3" width="200" sortable="true">指标3</th>
			<th field="VALUE4" width="200" sortable="true">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">数据表格格式化</h1>
<div class="lable">设置&lt;c:datagrid&gt;标签下th元素的formatter属性为js方法名，js方法有两个参数 单元格值（value）,行数据(rowData)</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table16" style="width:800px;height:400px;">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100" formatter="colFormatter1">区县编号</th>
			<th field="VALUE1" width="100" formatter="colFormatter2">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
			<th field="CUST_GROUP" width="200" >战略分群</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">复合表头数据表格</h1>
<div class="lable">设置方法与html中的table设置复杂表头一致</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table17"  style="width:800px;height:auto;">
	<thead>
		<tr>
			<th colspan="2">维度</th>
			<th colspan="4">数据</th>
		</tr>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">添加工具栏的数据表格</h1>
<div class="lable">设置&lt;c:datagrid&gt;标签的toolbar属性为 按钮所在元素(div)的id,如'#tb'</div>
<div id="tb"> <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="javascript:alert('Add');return false;">Add</a> <a href="#" class="easyui-linkbutton" iconCls="icon-cut" plain="true" onclick="javascript:alert('Cut');return false;">Cut</a> <a href="#" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="javascript:alert('Save');return false;">Save</a> </div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table18" style="width:800px;height:auto;" toolbar="#tb">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
<h1 class="titThree">添加标题的数据表格</h1>
<div class="lable">设置&lt;c:datagrid&gt;标签的title属性为 表格标题名</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table19" style="width:800px;height:400px;" title="表格标题可自由定义">
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>

<h1 class="titThree">某列相邻相同数据进行 行合并 </h1>
<div class="lable">
	设置&lt;c:datagrid&gt;标签的mergerFields属性为 列的字段名（th中的field属性值），多个值以“,”分隔，如“column1,column2”.(使用时需要注意数据记录的顺序)<br/>
	一般列数据进行合并的情景都是不需要分页的，所以还需要把分页功能去掉（pagination属性设置为false）
</div>
<c:datagrid url="/examples/datagrid/datagrid_action.jsp" id="table20" style="width:800px;height:400px;" title="表格1" mergerFields="AREA_NO," pagination="false" >
	<thead>
		<tr>
			<th field="AREA_NO" width="100">地市编号</th>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="VALUE1" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			<th field="VALUE3" width="200">指标3</th>
			<th field="VALUE4" width="200">指标4</th>
		</tr>
	</thead>
		</c:datagrid>
</div>

</body>
</html>