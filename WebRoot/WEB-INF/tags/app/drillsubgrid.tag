<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="id" required="true" %>                                               <e:description>主表格id</e:description>
<%@ attribute name="subid" required="false" %>                                            <e:description>次表格id</e:description>
<%@ attribute name="url" required="true" %>                                              <e:description>主数据路径</e:description>
<%@ attribute name="suburl" required="true" %>                                           <e:description>从数据路径</e:description>
<%@ attribute name="subcolumns" required="false" %>                                       <e:description>从表格列信息</e:description>
<%@ attribute name="drillfield" required="true" %>                                       <e:description>下钻的列，多个以,隔开</e:description>
<%@ attribute name="drillfieldtransform" required="false" %>                              <e:description>传参时下钻的列对应的列，下钻列与对应列以":"分隔,每个之间以","分隔,不写则不需转换,如"area_desc:area_no,city_desc:area_no"</e:description>
<%@ attribute name="subpagination" required="false" %> 									 <e:description>从表格是否显示分页，默认true，否为false</e:description>
<%@ attribute name="pagination" required="false" %> 									 <e:description>主表格是否显示分页，默认true，否为false</e:description>
<%@ attribute name="fitcol" required="false" %> 										 <e:description>从表格自动适应列，默认true，否为false</e:description>


<jsp:doBody var="bodyRes" />
<div id="drill_menu_${id}" class="easyui-menu" style="width:120px;">
	${e:replace(bodyRes, "id_template", id)}
	<div class="menu-sep"></div>
	<div onclick="Collapse_${id}()" iconCls="icon-cancel">关闭</div>
</div>
<script type="text/javascript">
var $Selecting_Row_${id} = 0;//选择的行号
var $Selecting_field_${id} = 0;//点击列字段名

var $Selecting_field_transform_${id} = [];//列字段名与对应列名
<e:if condition = "${drillfieldtransform!=null && drillfieldtransform ne ''}" >
	$Selecting_field_transform_${id} ='${drillfieldtransform}'.split(',');
</e:if>

var $SubField_Args_${id} = {};//下钻的参数，下钻列、维度
var Drill_Field_Arr_${id} = '${drillfield}'.split(',');//可以下钻的列数据

$(document).ready(function() {
	var $X_${id},$Y_${id};//鼠标实时坐标
	$(document).mousemove(function(e){
		$X_${id} = e.pageX;
		$Y_${id} = e.pageY;
	});
	
	var ${subid}_columns1=[];
 <e:if condition = "${subcolumns==null || subcolumns eq ''}" >
	$("#${subid} tr").each(function(i,o){
		var columns2 = [];
		$(o).find("td").each(function(index, element) {
            var cols = $(element).attr('colspan') == undefined?"1":$(element).attr('colspan');
			var rows = $(element).attr('rowspan') == undefined?"1":$(element).attr('rowspan');
			var fieldkey = $(element).attr('field');
			var align=$(element).attr('align');
			var fmtkey = $(element).attr('formatter');
			var titlekey = $(element).text();
			var wkey = $(element).attr('width');
			var strs = $('#out').text();
			
			var colObj = {};
			colObj.title=titlekey;
			colObj.rowspan=rows;
			colObj.colspan=cols;
			if(fieldkey != undefined && fieldkey != ''){
				colObj.field=fieldkey;
			}
			if(align != undefined && align != ''){
				colObj.align=align;
			}
			if(fmtkey != undefined && fmtkey != ''){
				colObj.formatter=eval(fmtkey);
				
			}
			if(wkey != undefined && wkey != ''){
				colObj.width=wkey;
			}
			columns2[index]=colObj;
        });
		${subid}_columns1[i]=columns2;
	});
 </e:if>
 <e:if condition = "${subcolumns!=null && subcolumns ne ''}" >
 	${subid}_columns1 =[[${subcolumns}]];
 </e:if>
	$('#${id}').datagrid({
		view: detailview,
		url:(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'),
		<e:if condition = "${pagination!=null && pagination ne ''}" >
            	pagination:${pagination},
		 </e:if>
		 <e:if condition = "${pagination==null || pagination eq ''}" >
            	pagination:false,
		 </e:if>
		onClickCell:function(rowIndex, field, value){	
			$Selecting_field_${id} = field;
		 },
		 
		onClickRow:function(rowIndex, data){
			var factAtrField=$Selecting_field_${id};
			var tempFactAtrFieldArray=null;
			for(var a=0;a<$Selecting_field_transform_${id}.length;a++){
				tempFactAtrFieldArray=$Selecting_field_transform_${id}[a].split(":");
				if(tempFactAtrFieldArray.length==2){
					if(tempFactAtrFieldArray[0]==$Selecting_field_${id}){
						factAtrField=tempFactAtrFieldArray[1];
					}
				
				}
				
			}
			$SubField_Args_${id} ={};
			$Selecting_Row_${id} = rowIndex;
			for(var i=0;i<Drill_Field_Arr_${id}.length;i++){
				if(Drill_Field_Arr_${id}[i] == $Selecting_field_${id}){
		 			$SubField_Args_${id}[factAtrField] = data[factAtrField];
					$('#drill_menu_${id}').menu('show',{
						left: $X_${id},
						top: $Y_${id}
					});
					break;
		 		}
		 	}
		 },
	     detailFormatter:function(index,row){
	         return '<div style="padding:2px"><table id="ddv-' + index + '"></table></div>';
	     },
	     onExpandRow: function(index,row){
	     	 for(var i=0;i<$('#${id}').datagrid("getRows").length;i++){
		 		if($Selecting_Row_${id}!=i){
		 			$('#${id}').datagrid('collapseRow', i);
		 		}
		 	 }
	         $('#ddv-'+index).datagrid({
	             url:(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${suburl}'.indexOf("/")==0?'${suburl}':'/${suburl}'),
				 <e:if condition = "${fitcol!=null && fitcol ne ''}" >
	             	fitColumns:${fitcol},
				 </e:if>
				 <e:if condition = "${fitcol==null || fitcol eq ''}" >
	             	fitColumns:true,
				 </e:if>
	             
	             singleSelect:true,
	             rownumbers:true,
	             height:'auto',
				 <e:if condition = "${subpagination!=null && subpagination ne ''}" >
	             	pagination:${subpagination},
				 </e:if>
				 <e:if condition = "${subpagination==null || subpagination eq ''}" >
	             	pagination:true,
				 </e:if>
                 columns:${subid}_columns1,
	             onResize:function(){
	                 $('#${id}').datagrid('fixDetailRowHeight',index);
	             },
				 onBeforeLoad:function(param){
				 	var argsStr = '';
					 for(var k in $SubField_Args_${id}){
					 	argsStr +='&'+k+'='+$SubField_Args_${id}[k];
					 }
					if($(this).datagrid('options').url.indexOf("?")>-1){
					 	$(this).datagrid('options').url += argsStr;
					 }else{
					 	$(this).datagrid('options').url += "?"+argsStr.substring(1);
					 }
					 
					 //alert($(this).datagrid('options').url);
				 },
				 onLoadSuccess:function(){
					 setTimeout(function(){
					 	$('#${id}').datagrid('fixDetailRowHeight',index);
					 	$('#${id}').datagrid('resize');
					 	
					 	
					 	
					 },0);
				 }
			});
			$('#${id}').datagrid('fixDetailRowHeight',index);
		}
	});
});
function reload_${id}(t){
	$SubField_Args_${id}.eaction = t;
	$('#${id}').datagrid('collapseRow', $Selecting_Row_${id});
	$('#${id}').datagrid('expandRow', $Selecting_Row_${id});
}
function Collapse_${id}(t){
	$('#${id}').datagrid('collapseRow', $Selecting_Row_${id});
	$('#${id}').datagrid('resize');
}
</script>