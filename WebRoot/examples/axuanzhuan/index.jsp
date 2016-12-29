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
var colMap = new Map();

function xuanzhuan(){
	colMap.clear();
	var len = $('#dg').datagrid('getRows').length;
	if(len>20){
		alert('不建议旋转');
		return;
	}
	
	var FIELD = 'CITY_NO';
	var jsonColsAll = $('#dg').datagrid('options').columns[0];
	for(var i=0;i<jsonColsAll.length;i++){
		colMap.put(jsonColsAll[i].field, jsonColsAll[i].title);
	}
	//alert($.toJSON(colMap));
	
	var jsonCols = $('#dg').datagrid('getColumnFields');
	//alert($.toJSON(jsonCols));
	var jsonData = $('#dg').datagrid('getData').rows;
	//alert($.toJSON(jsonData));
	var newColsJson = dgColsJson(FIELD,jsonCols,jsonData);
	alert($.toJSON(newColsJson));
	var newDataJson = dgDataJson(FIELD,jsonCols,jsonData);
	alert($.toJSON(newDataJson));
	alert(newColsJson);
	alert(newDataJson);
	$('#dg').datagrid({
		width : 800,
		height : 400,
		url : '',
		columns : [newColsJson],
		data : newDataJson
	});
}
function dgColsJson(FIELD,jsonCols,jsonData){
	//组装表格标题栏
	var dgCols = [];
	var field = {};
	field.field = FIELD;
	field.title = colMap.get(FIELD);
	field.width = 60;
	field.align = 'center';
	dgCols[0] = field;
	for(var i=0;i<jsonData.length;i++){
		for(var j=0;j<jsonCols.length;j++){
			if(FIELD == jsonCols[j]){
				var field = {};
				field.field = $(jsonData[i]).attr('CITY_NO');
				field.title = $(jsonData[i]).attr('CITY_NO');
				field.width = 60;
				field.align = 'center';
			}
			dgCols[i+1] = field;
		}
	}
	return dgCols;
}
function dgDataJson(FIELD,jsonCols,jsonData){
	//组装表格数据
	var dgArr = [];
	var newArr = [];
	dgArr[0] = jsonCols;
	
	for(var i=0;i<jsonData.length;i++){
		var tmpArr = [];
		for(var j=0;j<jsonCols.length;j++){
			tmpArr[j] = $(jsonData[i]).attr(jsonCols[j]);
		}
		dgArr[i+1] = tmpArr;
	}
	for(var i=0;i<dgArr[0].length;i++){
		newArr[i] = [];
	}
	for(var i=0;i<dgArr.length;i++){
		for(var j=0;j<dgArr[i].length;j++){
			newArr[j][i] = dgArr[i][j];
		}
	}
	var str = '';
	for(var i=1;i<newArr.length;i++){
		if(i>1){str+=',';}
		var colStr = '';
		for(var j=0;j<newArr[i].length;j++){
			if(j>0){colStr+=',';}
			colStr = colStr + '"'+newArr[0][j]+'":"'+ (newArr[0][j]==FIELD ? colMap.get(newArr[i][j]) : newArr[i][j])+'"';
		}
		str = str + '{' + colStr + '}';
	}
	str = '[' + str + ']';
	var dgData = JSON.parse(str);
	return dgData;
}
$(function(){
	
});
function Map() {
    this.elements = new Array();

    //获取MAP元素个数
    this.size = function() {
        return this.elements.length;
    };

    //判断MAP是否为空
    this.isEmpty = function() {
        return (this.elements.length < 1);
    };

    //删除MAP所有元素
    this.clear = function() {
        this.elements = new Array();
    };

    //向MAP中增加元素（key, value) 
    this.put = function(_key, _value) {
    	if( this.containsKey(_key) ){
    		this.removeByKey(_key);
    	}
        this.elements.push( {
            key : _key,
            value : _value
        });
    };

    //删除指定KEY的元素，成功返回True，失败返回False
    this.removeByKey = function(_key) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == _key) {
                    this.elements.splice(i, 1);
                    return true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };
    
    //删除指定VALUE的元素，成功返回True，失败返回False
    this.removeByValue = function(_value) {//removeByValueAndKey
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].value == _value) {
                    this.elements.splice(i, 1);
                    return true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };
    
    //删除指定VALUE的元素，成功返回True，失败返回False
    this.removeByValueAndKey = function(_key,_value) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].value == _value && this.elements[i].key == _key) {
                    this.elements.splice(i, 1);
                    return true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };

    //获取指定KEY的元素值VALUE，失败返回NULL
    this.get = function(_key) {
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == _key) {
                    return this.elements[i].value;
                }
            }
        } catch (e) {
            return false;
        }
        return false;
    };

    //获取指定索引的元素（使用element.key，element.value获取KEY和VALUE），失败返回NULL
    this.element = function(_index) {
        if (_index < 0 || _index >= this.elements.length) {
            return null;
        }
        return this.elements[_index];
    };

    //判断MAP中是否含有指定KEY的元素
    this.containsKey = function(_key) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == _key) {
                    bln = true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };

    //判断MAP中是否含有指定VALUE的元素
    this.containsValue = function(_value) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].value == _value) {
                    bln = true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };
    
    //判断MAP中是否含有指定VALUE的元素
    this.containsObj = function(_key,_value) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].value == _value && this.elements[i].key == _key) {
                    bln = true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };

    //获取MAP中所有VALUE的数组（ARRAY）
    this.values = function() {
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {
            arr.push(this.elements[i].value);
        }
        return arr;
    };
    
    //获取MAP中所有VALUE的数组（ARRAY）
    this.valuesByKey = function(_key) {
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {
            if (this.elements[i].key == _key) {
                arr.push(this.elements[i].value);
            }
        }
        return arr;
    };

    //获取MAP中所有KEY的数组（ARRAY）
    this.keys = function() {
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {
            arr.push(this.elements[i].key);
        }
        return arr;
    };
    
    //获取key通过value
    this.keysByValue = function(_value) {
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {
            if(_value == this.elements[i].value){
                arr.push(this.elements[i].key);
            }
        }
        return arr;
    };
    
    //获取MAP中所有KEY的数组（ARRAY）
    this.keysRemoveDuplicate = function() {
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {
            var flag = true;
            for(var j=0;j<arr.length;j++){
                if(arr[j] == this.elements[i].key){
                    flag = false;
                    break;
                } 
            }
            if(flag){
                arr.push(this.elements[i].key);
            }
        }
        return arr;
    };
}
</script>
<e:style value="/resources/themes/common/css/examples.css"/>
</head>
<body>
<div class="exampleWarp">
<h1 class="titOne">普通表格</h1>
<h1 class="titThree">基本数据表格</h1>
<a id="btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="xuanzhuan()">旋转</a>
<c:datagrid url="/examples/axuanzhuan/action.jsp?eaction=default" id="dg" style="width:800px;height:400px;" pagination="false">
	<thead>
		<tr>
			<th field="CITY_NO" width="100">区县编号</th>
			<th field="rotaDim" width="100">指标1</th>
			<th field="VALUE2" width="100">指标2</th>
			
		</tr>
	</thead>
</c:datagrid>
</div>
</body>
</html>