<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="m" uri="http://www.bonc.com.cn/easy/taglib/m"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Mobile表格组件实例</title>
<m:resources type="webix"/>
<e:style value="/pages/mbuilder/resources/css/default.css"/>
<e:style value="/pages/mbuilder/resources/css/mobile.css"/>
<script type="text/javascript">
function colFormatter1(obj){
	return '<b>'+obj.VALUE4+'</b>';
}
function clickCellFunc(id, e, trg){
	//alert(id.row + ',' + id.column + ',' + trg.innerHTML);
}	
function doSelect(){
	var count = document.getElementById('count').value;
	var url = 'mdatagrid_action.jsp?eaction=xx&count='+count;
	datagridReload('aaa', url);
}
</script>
</head>
<body>
<input type="text" id="count" name="count"><input type="button" value="查询" onclick="doSelect()">
<m:datagrid id="aaa" url="examples/datagrid/mdatagrid_action.jsp?count=10" width="300" height="300" select="cell" clickCell="clickCellFunc" >
	<tr>
		<td field="CITY_NO" rowspan="2">a</td>
		<td>b</td>
		<td colspan="2">cd</td>
		<td field="VALUE4" rowspan="2">eV4</td>
	</tr>
	<tr>
		<td field="VALUE1" sort="int">V1</td>
		<td field="VALUE2" >V2</td>
		<td field="VALUE3" width="200">V3</td>
	</tr>
</m:datagrid>
</body>
</html>