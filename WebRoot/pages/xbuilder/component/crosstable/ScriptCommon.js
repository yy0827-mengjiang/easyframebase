var crossTableCurrentEvnetEventId='';
var crossTableHeadCellAttrNameArray=["data-tableHeadWidth","data-tableDataAlign","data-tableDataEvent","data-tableEventSelectJson","width","colType","colField"];
var crossTableDataCellAttrNameArray=["data-tableHeadWidth","data-tableDataType","data-tableDataNumberStep","data-tableDataThousand",
				"data-tableDataAlign","data-tableDataRowMerge","data-tableDataBorderSetFlag","data-tableDataBorderValue",
				"data-tableDataBorderGtColor","data-tableDataBorderLtColor","data-tableDataBorderShowUpDown",
				"data-tableDataEvent","data-tableEventSelectJson","width","colType","colField"];
var currentTableCellAttrMap=new Object();
var th_show = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
$(function(){
	for(var th_i=0;th_i<26;th_i++){
		for(var th_j=0;th_j<26;th_j++){
			th_show[(th_i+1)*26+th_j]=th_show[th_i]+th_show[th_j];
		}
	}	
});


/*********************************************数据单元格属性设置方法开始***************************************************/

/**
 * 设置标题内容
 * @param titleValue
 */
function setCrossTableTitle(titleValue){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var info={reportId:reportId,containerId:containerId,componentId:componentId,attrKey:"title",attrValue:titleValue};
    crossTableService.setComponentAttr(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存标题时出错！<br/>"+exception,"error");
		}else{
			updateNodeName(componentId,titleValue);
		}
	});
}

/**
 * 设置是否显示标题
 */
function setCrossTableShowTitle(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#tableShowTitle").attr("checked")!='checked'){
		resultValue='1';
	}
	var info={reportId:reportId,containerId:containerId,componentId:componentId,attrKey:"showTitle",attrValue:resultValue};
	crossTableService.setComponentAttr(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存是否显示标题时出错！<br/>"+exception,"error");
		}
	});
}

/**
 * 是否允许导出数据
 */
function setCrossTableExport(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#tableExport").attr("checked")!='checked'){
		resultValue='1';
	}
	var info={reportId:reportId,containerId:containerId,componentId:componentId,attrKey:"tableexport",attrValue:resultValue};
	crossTableService.setComponentAttr(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存是否导出时出错！<br/>"+exception,"error");
		}else{
			if(resultValue=='1'){
    			if($("#tablePagi").attr("checked")!="checked"&&$("#tablePagi").attr("checked")!=true){
    				setCrossTablePagination();
    				$('#tablePagi').iCheck("check");
    			}
    		}
		}
	});
}

/**
 * 是否允许分页
 */
function setCrossTablePagination(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#tablePagi").attr("checked")!='checked'){
		resultValue='1';
	}
	var info={reportId:reportId,containerId:containerId,componentId:componentId,attrKey:"tablepagi",attrValue:resultValue};
	crossTableService.setComponentAttr(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存是否分页时出错！<br/>"+exception,"error");
		}else{
			if(resultValue=='0'){
    			$("#tablePagiNum").numberbox("setValue",10);
    			$("#tablePagiNum").numberbox("disable");
    			$('#tableExport').iCheck("uncheck");
    			var info1={};
		    	info1.reportId=reportId;
		    	info1.containerId=containerId;
		    	info1.componentId=componentId;
		    	info1.attrKey="tableexport";
		    	info1.attrValue="0";
		    	crossTableService.setComponentAttr(info1,function(data,exception){
		    		if(exception!=undefined){
		    			$.messager.alert("交叉表格","保存每页记录数时出错！<br/>"+exception,"error");
		    		}else{
		    			tableSetPagiNum($("#tablePagiNum").numberbox("getValue"));
		    		}
		    	});
    		}else{
    			$("#tablePagiNum").numberbox("enable");
    		}
		}
	});
}

/** 
 * 描述：分页时，设置每页显示记录数
*/
function tableSetPagiNum(pagiNum){
	if($.trim(pagiNum)==''){
		pagiNum=10;
		$("#tablePagiNum").numberbox("setValue",pagiNum);
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var info={reportId:reportId,containerId:containerId,componentId:componentId,attrKey:"tablepaginum",attrValue:pagiNum};
	crossTableService.setComponentAttr(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存每页记录数时出错！<br/>"+exception,"error");
		}
	});
}

/**
 * 合计方式设置
 */
function setCrossTableSumType(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';//不合计
	if($("#tableRowSum").attr("checked")=='checked'&&$("#tableColumnSum").attr("checked")!='checked'){
		resultValue = "1";//行合计
	}else if($("#tableRowSum").attr("checked")!='checked'&&$("#tableColumnSum").attr("checked")=='checked'){
		resultValue = "2";//列合计
	}else if($("#tableRowSum").attr("checked")=='checked'&&$("#tableColumnSum").attr("checked")=='checked'){
		resultValue = "3";//行列都合计
	}
	var info={reportId:reportId,containerId:containerId,componentId:componentId,attrKey:"sumtype",attrValue:resultValue};
	crossTableService.setComponentAttr(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存合计方式时出错！<br/>"+exception,"error");
		}
	});
	if($("#tableColumnSum").attr("checked")=='checked'){
		$("input[name='rowSumPosition']").iCheck('enable');
	}else{
		$("input[name='rowSumPosition']").iCheck('disable');
	}
}

function setColSumName(colSumName){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var info={reportId:reportId,containerId:containerId,componentId:componentId,attrKey:"colSumName",attrValue:colSumName};
	crossTableService.setComponentAttr(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存列合计名称时出错<br/>"+exception,"error");
		}
	});
}

function setRowSumName(rowSumName){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var info={reportId:reportId,containerId:containerId,componentId:componentId,attrKey:"rowSumName",attrValue:rowSumName};
	crossTableService.setComponentAttr(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存行合计名称时出错<br/>"+exception,"error");
		}
	});
}

/**
 * 设置行合计位置
 */
function crossTableSetRowSumPosition(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var info={reportId:reportId,containerId:containerId,componentId:componentId,attrKey:"rowsumposition",attrValue:value};
	crossTableService.setComponentAttr(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存行合计位置时出错！<br/>"+exception,"error");
		}
	});
}

/**
 * 设置行维度显示类型
 * @param showType: 1:列表显示、2:树形显示
 */
function setCrossVerticalDimShowType(showType){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var info={reportId:reportId,containerId:containerId,componentId:componentId,attrKey:"rowtype",attrValue:showType};
	if(showType=="1"){
		$("#gridDisplay").removeClass("grid_normal").addClass("grid_active");
		$("#treeDisplay").removeClass("tree_active").addClass("tree_normal");
		//$("#tableExport").iCheck('enable');
	}else{
		$("#treeDisplay").removeClass("tree_normal").addClass("tree_active");
		$("#gridDisplay").removeClass("grid_active").addClass("grid_normal");
		//$("#tableExport").iCheck('disable');
	}
	crossTableService.setComponentAttr(info,function(data,exception){//保存数据源Id到xml
		if(exception!=undefined){
			$.messager.alert("交叉表格","设置行维度显示类型时出错！","error");
		}
	});
}

/**
 * 设置表格表头单元格中文描述
 * @param value
 */
function setCrossTableHeadColValue(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var colDesc = crossFilterHtml(value);
	var $selecteds = $("#selectable_"+componentId).find(".ui-selected").eq(0);
	$selecteds.html(colDesc);
	var colType = $($selecteds).attr("colType");
	var colField = $($selecteds).attr("colField");
	if(colType!=undefined&&colField!=undefined){
		var info = {reportId:reportId,containerId:containerId,componentId:componentId,colType:colType,colField:colField,colDesc:colDesc};
		crossTableService.setDataColDesc(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","保存列标题时出错！<br/>"+exception,"error");
			}else{
				crossTableSetHeadui();
				if(colType=="rowdim"||colType=="columndim"){
					var liSpanList=$("#verticalDimColumnDiv,#horizontalDimColumnDiv").find("span[id^='tableDimColumn_']");
					$.each(liSpanList,function(index,span){
						if($(span).text()==colField){
							$(span).attr("title",colDesc);
							return false;
						}
					});
				}else if(colType=="kpi"){
					var liSpanList=$("#tableKpiColumnDiv").find("span[id^='tableKpiColumn_']");
					$.each(liSpanList,function(index,span){
						if($(span).text()==colField){
							$(span).attr("title",colDesc);
							return false;
						}
					});
				}
			}
		});
	}
}

/**
 * 设置单元格宽度（与数据行相邻表头行中的单元格）
 * @param value
 */
function setCrossDataColumnWidth(value){
	var componentId=StoreData.curComponentId;
	if(value==''){
		value='100';
		$("#tableDataWidth").numberbox("setValue",value);
	}
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		$($selectTds[a]).attr("data-tableHeadWidth",value);
		$($selectTds[a]).attr("width",value+"px");
	}
	if($($selectTds[0]).attr("colType")=="rowdimdata"){
		saveCrossTableRowDimFormat();
	}else if($($selectTds[0]).attr("colType")=="kpidata"){
		saveCrossTableColumnFormat();
	}
}

/**
 * 设置数据单元格的数据类型
 * @param value
 */
function setCrossColumnDataType(value){
	$("#propertiesStoreDiv").attr("datafmttype",value);
	var $selectable= $("#selectable_"+StoreData.curComponentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		$($selectTds[a]).attr("data-tableDataType",value);
	}
	if(value!='common'){//非常规，即数值或百分数
		$("#tableDataNumberStep").numberbox("setValue",0);
		$("#tableDataNumberStep").numberbox("enable");
		$("#tableDataThousand").iCheck('uncheck');
		$("#tableDataThousand").iCheck('enable');
	}else{
		$("#tableDataNumberStep").numberbox("setValue",'');
		$("#tableDataNumberStep").numberbox("disable");
		$("#tableDataThousand").iCheck('uncheck');
		$("#tableDataThousand").iCheck('disable');
	}
	saveCrossTableColumnFormat();
}

/**
 * 设置数据单元格的数据的小数位数（数值或百分数时设置）
 * @param value
 */
function setCrossTableNumberStep(value){
	if($.trim(value)==''){
		value='0';
		$("#tableDataNumberStep").numberbox("setValue",'0');
	}
	var $selectable= $("#selectable_"+StoreData.curComponentId);
	var $selectTds=$selectable.find(".ui-selected");
	var total=0;
	for(var a=0;a<$selectTds.length;a++){
		if("kpidata"!=$($selectTds[a]).attr("colType")){
			continue;
		}
		total++;
		$($selectTds[a]).attr("data-tableDataNumberStep",value);
	}
	if(total>0){
		saveCrossTableColumnFormat();
	}
}

/**
 * 设置数据单元格的数据的 使用千分符（,）
 */
function setCrossTableThousand(){
	var value='0';
	if($("#tableDataThousand").attr("checked")!='checked'){//选中
		value='1';
	}
	$("#propertiesStoreDiv").attr("datafmtthousand",value);
	var $selectable= $("#selectable_"+StoreData.curComponentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		$($selectTds[a]).attr("data-tableDataThousand",value);
	}
	saveCrossTableColumnFormat();
}

/**
 * 设置数据单元格的数据的 使用千分符（,）
 */
function crossTableDataSetRowMerge(){
	var value='0';
	if($("#crossTableDataRowMerge").attr("checked")!='checked'){//选中
		value='1';
	}
	$("#propertiesStoreDiv").attr("datafmtrowmerge",value);
	var $selectable= $("#selectable_"+StoreData.curComponentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		$($selectTds[a]).attr("data-tableDataRowMerge",value);
	}
	var $selectable= $("#selectable_"+StoreData.curComponentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		$($selectTds[a]).attr("data-tableDataRowMerge",value);
	}
	if($($selectTds[0]).attr("colType")=="rowdimdata"){
		saveCrossTableRowDimFormat();
	}else if($($selectTds[0]).attr("colType")=="kpidata"){
		saveCrossTableColumnFormat();
	}
}
/**
 * 设置数据单元格的数据的 对齐方式
 * @param value
 */
function setCrossTableDataAlign(value){
	$("#propertiesStoreDiv").attr("datafmtalign",value);
	if(value=='left'){
		$("#tableDataAlignLeft").addClass("positionLeftSelect").removeClass("positionLeft");
		$("#tableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
		$("#tableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
	}else if(value=='center'){
		$("#tableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
		$("#tableDataAlignCenter").addClass("positionCenterSelect").removeClass("positionCenter");
		$("#tableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
	
	}else if(value=='right'){
		$("#tableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
		$("#tableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
		$("#tableDataAlignRight").addClass("positionRightSelect").removeClass("positionRight");
	}
	
	var $selectable= $("#selectable_"+StoreData.curComponentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		$($selectTds[a]).attr("data-tableDataAlign",value);
	}
	if($($selectTds[0]).attr("colType")=="rowdimdata"){
		saveCrossTableRowDimFormat();
	}else if($($selectTds[0]).attr("colType")=="kpidata"){
		saveCrossTableColumnFormat();
	}
}

/**
 * 设置数据单元格的数据的设置边界
 */
function setCrossTableBorderFlag(){
		var value='0';
		if($("#tableDataBorderSetFlag").attr("checked")!='checked'){//选中
			value='1';
		}
		var $selectable= $("#selectable_"+StoreData.curComponentId);
		var $selectTds=$selectable.find(".ui-selected");
		for(var a=0;a<$selectTds.length;a++){
			$($selectTds[a]).attr("data-tableDataBorderSetFlag",value);
		}
		$("#tableDataBorderValue").numberbox("setValue",'0');
		$("#tableDataBorderGtColor").spectrum("set","#00ff00");
		$("#tableDataBorderLtColor").spectrum("set","#ff0000");
		$("#tableDataBorderShowUpDown").iCheck('uncheck');
		if(value=='1'){
			$("#tableDataBorderValue").numberbox("enable");
			$("#tableDataBorderGtColor").spectrum("enable");
			$("#tableDataBorderLtColor").spectrum("enable");
			$("#tableDataBorderShowUpDown").iCheck('enable');
		}else{
			$("#tableDataBorderValue").numberbox("disable");
			$("#tableDataBorderGtColor").spectrum("disable");
			$("#tableDataBorderLtColor").spectrum("disable");
			$("#tableDataBorderShowUpDown").iCheck('disable');
		}
		
		$("#propertiesStoreDiv").attr("datafmtisbd",value);//是否设置边界
		$("#propertiesStoreDiv").attr("datafmtbdup",'#00ff00');//大于边界值的颜色
		$("#propertiesStoreDiv").attr("datafmtbddown",'#ff0000');//小于边界值的颜色
		saveCrossTableColumnFormat();
}

/**
 * 设置数据单元格的数据的边界值
 * @param value 边界值
 */
function setCrossTableBorderValue(value){
		if($.trim(value)==''){
			value='0';
			$("#tableDataBorderValue").numberbox("setValue",'0');
		}
		var $selectable= $("#selectable_"+StoreData.curComponentId);
		var $selectTds=$selectable.find(".ui-selected");
		var total = 0;
		for(var a=0;a<$selectTds.length;a++){
			if("kpidata"!=$($selectTds[a]).attr("colType")){
				continue;
			}
			$($selectTds[a]).attr("data-tableDataBorderValue",value);
			total++;
		}
		if(total>0){
			saveCrossTableColumnFormat();
		}
}

/**
 * 设置数据单元格的数据的大于边界值的颜色
 * @param color 颜色对象 
 */
function setCrossTableBorderGtColor(color){
		var value=color.toHexString();
		$("#propertiesStoreDiv").attr("datafmtbdup",value);//大于边界值的颜色
		var $selectable= $("#selectable_"+StoreData.curComponentId);
		var $selectTds=$selectable.find(".ui-selected");
		for(var a=0;a<$selectTds.length;a++){
			$($selectTds[a]).attr("data-tableDataBorderGtColor",value);
		}
		saveCrossTableColumnFormat();
}

/**
 * 设置数据单元格的数据的小于边界值的颜色
 * @param color 颜色对象
 */
function setCrossTableBorderLtColor(color){
		var value=color.toHexString();
		$("#propertiesStoreDiv").attr("datafmtbddown",value);//小于边界值的颜色
		var $selectable= $("#selectable_"+StoreData.curComponentId);
		var $selectTds=$selectable.find(".ui-selected");
		for(var a=0;a<$selectTds.length;a++){
			$($selectTds[a]).attr("data-tableDataBorderLtColor",value);
		}
		saveCrossTableColumnFormat();
}

/**
 * 设置是否显示上下箭头
 */
function setCrossTableShowUpDownArraw(){
		var value='0';
		if($("#tableDataBorderShowUpDown").attr("checked")!='checked'){//选中
			value='1';
		}
		var $selectable= $("#selectable_"+StoreData.curComponentId);
		var $selectTds=$selectable.find(".ui-selected");
		for(var a=0;a<$selectTds.length;a++){
			$($selectTds[a]).attr("data-tableDataBorderShowUpDown",value);
		}
		$("#propertiesStoreDiv").attr("datafmtisarrow",value);//小于边界值的颜色
		saveCrossTableColumnFormat();
}

/**
 * 保存行维度的格式到xml
 */
function saveCrossTableRowDimFormat(){
	var tableheadwidth = $("#tableDataWidth").val();//列宽度
	var datafmtalign = $("#propertiesStoreDiv").attr("datafmtalign");//数据对齐方式
	var datafmtrowmerge = $("#propertiesStoreDiv").attr("datafmtrowmerge");//数据对齐方式
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	var info={reportId:reportId,containerId:containerId,componentId:componentId};
	info.dataCols=new Array();
	for(var a=0;a<$selectTds.length;a++){
		var dataColInfo={};
		dataColInfo.datacolcode=$($selectTds[a]).attr("colField");
		dataColInfo.dataColAttrs=new Array();
		dataColInfo.dataColAttrs.push({attrKey:'tableheadwidth',attrValue:tableheadwidth});
		dataColInfo.dataColAttrs.push({attrKey:'tableheadalign',attrValue:datafmtalign});
		dataColInfo.dataColAttrs.push({attrKey:'datafmtrowmerge',attrValue:datafmtrowmerge});
		info.dataCols.push(dataColInfo);
	}
	crossTableService.setMoreDimColumnMoreAttrs(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存单元格格式时出错！<br/>"+exception,"error");
		}else{
			crossTableSetHeadui();
		}
	});
}



/**
 * 保存单元格的格式设置的所有属性值
 */
function saveCrossTableColumnFormat(){
	var tableheadwidth = $("#tableDataWidth").val();//列宽度
	var datafmttype = $("#propertiesStoreDiv").attr("datafmttype");//数据类型
	var datadecimal = $("#tableDataNumberStep").val();//小数位数
	var datafmtthousand = $("#propertiesStoreDiv").attr("datafmtthousand");//是否显示千分位符
	var datafmtalign = $("#propertiesStoreDiv").attr("datafmtalign");//数据对齐方式
	var datafmtrowmerge = $("#propertiesStoreDiv").attr("datafmtrowmerge");//数据对齐方式
	var datafmtisbd = $("#propertiesStoreDiv").attr("datafmtisbd");//是否设置边界
	var datafmtisbdvalue = $("#tableDataBorderValue").val();//边界值
	var datafmtbdup = $("#propertiesStoreDiv").attr("datafmtbdup");//大于边界值的颜色
	var datafmtbddown = $("#propertiesStoreDiv").attr("datafmtbddown");//小于边界值的颜色
	var datafmtisarrow = $("#propertiesStoreDiv").attr("datafmtisarrow");//是否显示上下箭头
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	var info={reportId:reportId,containerId:containerId,componentId:componentId};
	info.dataCols=new Array();
	for(var a=0;a<$selectTds.length;a++){
		var dataColInfo={};
		dataColInfo.datacolcode=$($selectTds[a]).attr("colField");
		dataColInfo.dataColAttrs=new Array();
		dataColInfo.dataColAttrs.push({attrKey:'tableheadwidth',attrValue:tableheadwidth});
		dataColInfo.dataColAttrs.push({attrKey:'datafmttype',attrValue:datafmttype});
		dataColInfo.dataColAttrs.push({attrKey:'datadecimal',attrValue:datadecimal});
		dataColInfo.dataColAttrs.push({attrKey:'datafmtthousand',attrValue:datafmtthousand});
		dataColInfo.dataColAttrs.push({attrKey:'datafmtalign',attrValue:datafmtalign});
		dataColInfo.dataColAttrs.push({attrKey:'datafmtrowmerge',attrValue:datafmtrowmerge});
		dataColInfo.dataColAttrs.push({attrKey:'datafmtisbd',attrValue:datafmtisbd});
		dataColInfo.dataColAttrs.push({attrKey:'datafmtisbdvalue',attrValue:datafmtisbdvalue});
		dataColInfo.dataColAttrs.push({attrKey:'datafmtbdup',attrValue:datafmtbdup});
		dataColInfo.dataColAttrs.push({attrKey:'datafmtbddown',attrValue:datafmtbddown});
		dataColInfo.dataColAttrs.push({attrKey:'datafmtisarrow',attrValue:datafmtisarrow});
		info.dataCols.push(dataColInfo);
	}
	crossTableService.setMoreDatacolMoreAttrs(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存单元格格式时出错！<br/>"+exception,"error");
		}else{
			crossTableSetHeadui();
		}
	});
}

/*********************************************数据单元格属性设置方法结束***************************************************/




/*********************************************生成设计表格方法开始***************************************************/
/**
 * 设置设计区表格HTML
 */
function setDesignTableHtml(){
	    var rowDims = new Array();
	    var columnDims = new Array();
	    var kpis = new Array();
	    var verDimLiList = $("#verticalDimColumnDiv>ul>li");
	    $.each(verDimLiList,function(index,li){
	    	var $span=$(li).find("span:eq(0)");
			var dimField = $span.attr("name").substring('tableDimColumn_'.length);
			var dimDesc = $span.attr("title");
			rowDims.push({field:dimField,desc:dimDesc});
	    });
	    var horDimLiList = $("#horizontalDimColumnDiv>ul>li");
	    $.each(horDimLiList,function(index,li){
	    	var $span=$(li).find("span:eq(0)");
	    	var dimField = $span.attr("name").substring('tableDimColumn_'.length);
	    	var dimDesc = $span.attr("title");
	    	columnDims.push({field:dimField,desc:dimDesc});
	    });
	    
	    var kpiLiList = $("#tableKpiColumnDiv>ul>li");
	    $.each(kpiLiList,function(index,li){
	    	var $span=$(li).find("span:eq(0)");
	    	var datacolcode = $span.attr("name").substring('tableKpiColumn_'.length);
	    	var kpiDesc = $span.attr("title");
	    	kpis.push({field:datacolcode,desc:kpiDesc});
	    });
	    //保存单元格已设置的属性到缓存中，用于重新生成设计表格代码后还原属性
	    currentTableCellAttrMap = new Object();
	    var allSettingTds = $("#selectable_"+StoreData.curComponentId).find("td[colType]");
	    $.each(allSettingTds,function(index,td){
	    	if($(td).attr("colType")=="rowdimdata"){
	    		currentTableCellAttrMap[$(td).attr("colField")] = new Object();
	    		
	    		$.each(crossTableHeadCellAttrNameArray,function(index,attrName){
	    			if($(td).attr(attrName)!=undefined){
	    				currentTableCellAttrMap[$(td).attr("colField")][attrName] = $(td).attr(attrName);
	    			}
	    		});
	    	}else if($(td).attr("colType")=="kpidata"){
	    		currentTableCellAttrMap[$(td).attr("colField")] = new Object();
	    		$.each(crossTableDataCellAttrNameArray,function(index,attrName){
	    			if($(td).attr(attrName)!=undefined){
	    				currentTableCellAttrMap[$(td).attr("colField")][attrName] = $(td).attr(attrName);
	    			}
	    		});
	    	}
	    });
	    //重新生成设计表格
	    createCrossTableDemo(rowDims,columnDims,kpis);
}

/**
 * 创建初始化设计表格(未合并单元格的表格)
 */
function createOriginalDesignTable(){
	var html = "<thead><tr class='ui-th-head'><th class='ui-state-default' istt='th1' style='background:#f8f8f8;'></th>";
	for(var i=0;i<7;i++){
		html+="<th class='ui-state-default' istt='th1'>"+th_show[i]+"</th>";
	}
	html+="</tr></thead><tbody>";
	var ishead = "";
	for(var i=0;i<6;i++){
		html+="<tr class='ui-th'>";
		ishead = i==5 ? "":"ishead='1'";
		for(var j=0;j<8;j++){
			if(j==0){
				html += "<th class='ui-state-default' istt='td"+(i+2)+"' "+ishead+">"+(i+1)+"</th>";
			}else{
				html += "<td class='ui-state-default' istt='td"+(i+2)+"' tdInd='"+j+"' "+ishead+"></td>";
			}
		}
		html+="</tr>";
	}
	html+="</tbody>";
	return html;
}

/**
 * 根据td下标合并单元格
 * @param $tds td数组
 * @param type 行或列：row/col
 * @param index 要合并的单元格，逗号分隔，开始下标-结束下标，例如：0-1,2-5,6-8,10-13
 */
function mergeCellByIndex($tds, type, index) {
    var indexArrs = index.split(',');
    var fromTo;
    var from;
    var to;
    
    for (var i in indexArrs) {
        fromTo = indexArrs[i];
        
        from = new Number(fromTo.split('-')[0]);
        to = new Number(fromTo.split('-')[1]);
        
        for (var j = 1 + from; j <= to; j++) {
            $($tds.get(j)).remove();
        }
        if (type == 'col') {
            $($tds.get(from)).attr("rowspan", to - from + 1);
        } else if (type == 'row') {
            $($tds.get(from)).attr("colspan", to - from + 1);
        }
    }
}

/**
 * 添加列
 * @param insertCount 要添加的列数
 */
function addNewColumn(insertCount){
	var componentId=StoreData.curComponentId;
	var trs = $("#selectable_"+componentId+"").find("tr");
	var fromIndex = $(trs).eq(0).find("th").length-1;
	$.each(trs,function(rowIndex,tr){
		for(var i=0;i<insertCount;i++){
			if(rowIndex==0){
				$(tr).append("<th class='ui-state-default' istt='th"+(rowIndex+1)+"'>"+th_show[fromIndex+i]+"</th>");
			}else if(rowIndex==trs.length-1){
				$(tr).append("<td class='ui-state-default' istt='td"+(rowIndex+1)+"' tdInd='"+(fromIndex+i+1)+"' ></td>");
			}else{
				$(tr).append("<td class='ui-state-default' istt='td"+(rowIndex+1)+"' tdInd='"+(fromIndex+i+1)+"' ishead='1'></td>");
			}
		}
	});
}

/**
 * 添加列
 * @param insertCount 要添加的行数
 */
function addNewRow(insertCount){
	var componentId=StoreData.curComponentId;
	var lastTr  = $("#selectable_"+componentId+">tbody>tr:last");
	var lastThNum = parseInt($(lastTr).find("th").eq(0).text());
	$(lastTr).find("th").attr("ishead","1");
	$(lastTr).find("td").attr("ishead","1");
	var tbody = $("#selectable_"+componentId+">tbody:eq(0)");
	for(var i=0;i<insertCount;i++){
		tbody.append($("#selectable_"+componentId+">tbody>tr:last").clone());
	    $("#selectable_"+componentId+">tbody>tr:last").find("th").eq(0).text(lastThNum+i+1);
	    var trLength = $("#selectable_"+componentId+"").find("tr").length;
	    $("#selectable_"+componentId+">tbody>tr:last").find("th").attr("istt","td"+trLength);
	    $("#selectable_"+componentId+">tbody>tr:last").find("td").attr("istt","td"+trLength);
	}
	lastTr  = $("#selectable_"+componentId+">tbody>tr:last");
	$(lastTr).find("th").removeAttr("ishead");
	$(lastTr).find("td").removeAttr("ishead");
}

/**
 * 创建设计表格
 * @param rowDims 行维度
 * @param columnDims 列维度
 * @param kpis 指标
 */
function createCrossTableDemo(rowDims,columnDims,kpis){
	var componentId = StoreData.curComponentId;
	$("#comp_scoll_"+componentId).empty();
	var html = "<table id='selectable_"+componentId+"' border='1' class='reportTable'  style='border-spacing: 0;'>"+createOriginalDesignTable()+"</table>";
	$("#comp_scoll_"+componentId).append(html);
	var rowDimCount = rowDims.length;//行维度个数
	var columnDimCount = columnDims.length;//列维度个数
	var kpiCount = kpis.length;//指标个数
	var currentRowCount = $("#selectable_"+componentId).find("tr").length-1;//当前表格总行数,不包含表头
	var currentColumnCount  = $("#selectable_"+componentId).find("tr:eq(0)").find("th").length-1;//当前表格总列数，不包含行头
	if(rowDimCount+kpiCount>currentColumnCount){
		var insertCount = rowDimCount+kpiCount-currentColumnCount;
		addNewColumn(insertCount);
		currentColumnCount = rowDimCount+kpiCount;
	}
	if(columnDimCount+2>currentRowCount){
		var insertCount = columnDimCount+2-currentRowCount;
		addNewRow(insertCount);
		currentRowCount = columnDimCount+2;
	} 
	//行维度
	var columnStartIndex=1;
	var fromRowNum = currentRowCount-columnDimCount - 2;//从第几行开始插入数据或开始合并的行下标
	var toRowNum = fromRowNum+columnDimCount;//合并到第几行
    for(var i=0;i<rowDims.length;i++){
    	var tempColumnTds = $("#selectable_"+componentId+" tr td[tdind='"+columnStartIndex+"']");
    	mergeCellByIndex(tempColumnTds, 'col', fromRowNum+"-"+toRowNum);
    	$(tempColumnTds[fromRowNum]).text(rowDims[i].desc);
    	$(tempColumnTds[fromRowNum]).attr("colField",rowDims[i].field);
    	$(tempColumnTds[fromRowNum]).attr("colType","rowdim");
    	var tdText = StoreData.dsType == "1" ? rowDims[i].field : rowDims[i].desc;
    	$(tempColumnTds[toRowNum+1]).text(tdText);
    	$(tempColumnTds[toRowNum+1]).attr("colField",rowDims[i].field);
    	$(tempColumnTds[toRowNum+1]).attr("colType","rowdimdata");
    	//从内存中还原已经设置的属性到单元格
    	var tdAttrMap = currentTableCellAttrMap[rowDims[i].field];
    	if(tdAttrMap!=undefined && tdAttrMap.colType == "rowdimdata"){
    		for(var key in tdAttrMap){
    			$(tempColumnTds[toRowNum+1]).attr(key,tdAttrMap[key]);
    			
    		}
    	}
    	columnStartIndex++;
    }
    //列维度
    var rowStartIndex = fromRowNum+1;//从第几行开始插入数据，包含表头行，所以+1
    for(var j=0;j<columnDims.length;j++){
    	var tempRowTds = $("#selectable_"+componentId).find("tr").eq(rowStartIndex).children("td");
    	if(tempRowTds.length==currentColumnCount){//td个数等于最大列数,下标为“rowDimCount”
    		mergeCellByIndex(tempRowTds, 'row', rowDimCount+"-"+(rowDimCount+kpiCount-1));
    		$(tempRowTds[rowDimCount]).text(columnDims[j].desc);
    		$(tempRowTds[rowDimCount]).attr("colField",columnDims[j].field);
    		$(tempRowTds[rowDimCount]).attr("colType","columndim");
    	}else{//由于合并行导致td个数少于最大列数，下标为0
    		mergeCellByIndex(tempRowTds, 'row', "0-"+(kpiCount-1));
    		$(tempRowTds[0]).text(columnDims[j].desc);
    		$(tempRowTds[0]).attr("colField",columnDims[j].field);
    		$(tempRowTds[0]).attr("colType","columndim");
    	}
    	rowStartIndex++;
    }
    //指标
    for(var k =0;k<kpiCount;k++){
    	//指标行
    	var kpiTds = $("#selectable_"+componentId).find("tr").eq(currentRowCount).children("td");
    	var tdText = StoreData.dsType == "1" ? kpis[k].field : kpis[k].desc;
    	$(kpiTds[rowDimCount+k]).text(tdText);
    	$(kpiTds[rowDimCount+k]).attr("colField",kpis[k].field);
    	$(kpiTds[rowDimCount+k]).attr("colType","kpidata");
    	//从内存中还原已经设置的属性到单元格
    	var tdAttrMap = currentTableCellAttrMap[kpis[k].field];
    	if(tdAttrMap!=undefined && tdAttrMap.colType == "kpidata"){
    		for(var key in tdAttrMap){
    			$(kpiTds[rowDimCount+k]).attr(key,tdAttrMap[key]);
    		}
    	}
    	//指标行的上一行，指标标题行
    	var kpiHeadTds = $("#selectable_"+componentId).find("tr").eq(currentRowCount-1).children("td");
    	if(kpiHeadTds.length<currentColumnCount){//如果行里td的个数小于最大列数，说明有行合并，下标从k开始
    		$(kpiHeadTds[k]).text(kpis[k].desc);
    		$(kpiHeadTds[k]).attr("colField",kpis[k].field);
        	$(kpiHeadTds[k]).attr("colType","kpi");
    	}else{
    		$(kpiHeadTds[rowDimCount+k]).text(kpis[k].desc);//没有行合并的，下标从“行维度个数+k”开始
    		$(kpiHeadTds[rowDimCount+k]).attr("colField",kpis[k].field);
        	$(kpiHeadTds[rowDimCount+k]).attr("colType","kpi");
    	}
    }
    crossTableSetHeadui();
    window["initSelectable"+componentId]();
}

/*********************************************************生成设计表格方法结束***********************************************************/





/*********************************************************设置联动相关方法开始***********************************************************/
/** 描述：点击数据单元格动作类型时执行的方法，“无”：清除动作并隐藏选项，“链接”：显示链接选项，“联动”：显示联动选项
参数：
	value 值
*/
function crossTableDataSetEvent(value){
		var reportId=StoreData.xid;
		var containerId=StoreData.curContainerId;
		var componentId=StoreData.curComponentId;
		
		var isHasSameEventJsonFlag=true;
		var tableEventSelectJsonStr='';
		var $selectable= $("#selectable_"+componentId);
		var $selectTds=$selectable.find(".ui-selected");
		for(var a=0;a<$selectTds.length;a++){
			if(a==0){
				tableEventSelectJsonStr=$($selectTds[a]).attr("data-tableEventSelectJson");
			}
			if(tableEventSelectJsonStr!=$($selectTds[a]).attr("data-tableEventSelectJson")){
				isHasSameEventJsonFlag=false;
			}
		}
		var eventList=[];
		if(isHasSameEventJsonFlag){
			if(tableEventSelectJsonStr==undefined||tableEventSelectJsonStr==''||tableEventSelectJsonStr==null||tableEventSelectJsonStr=='null'){
				tableEventSelectJsonStr='{}';
			}
			var tableEventSelectJson=$.parseJSON(tableEventSelectJsonStr);
			
			if(tableEventSelectJson!=null){
				eventList=tableEventSelectJson["eventList"];
				if(eventList==undefined||eventList==null||eventList==''||eventList=='null'){
					eventList=[];
				}
			}
		}
				
				
		if(value=="none"){
			$("#tableDataEventLinkDiv").hide();
			$("#tableDataEventActiveDiv").hide();
			var eventStoreList=[];
			var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
			var $selectable= $("#selectable_"+componentId);
			var $selectTds=$selectable.find(".ui-selected");
			var sourceType="";
			for(var a=0;a<$selectTds.length;a++){
				var evetStoreInfo={};
				evetStoreInfo.datacolcode=$($selectTds[a]).attr("colField");
				sourceType=$($selectTds[a]).attr("colType");
				eventStoreList.push(evetStoreInfo);
				if($($selectTds[a]).attr("data-tableDataEvent")!=value){
					$($selectTds[a]).removeAttr("data-tableEventSelectJson");
				}
				$($selectTds[a]).attr("data-tableDataEvent",value);
			}
			var info={};
	    	info.reportId=reportId;
	    	info.containerId=containerId;
	    	info.componentId=componentId;
	    	info.eventStoreList=eventStoreList;
	    	if(sourceType=="kpidata"){
	    		crossTableService.setClearMoreEvent(info,function(data,exception){
		    		if(exception!=undefined){
		    			$.messager.alert("交叉表格","清除单元格动作时出错！"+exception,"error");
		    		}else{
		    			crossTableSetHeadui();
		    		}
		    	});
	    	}else if(sourceType=="rowdimdata"){
	    		crossTableService.setClearRowDimEvent(info,function(data,exception){
		    		if(exception!=undefined){
		    			$.messager.alert("交叉表格","清除单元格动作时出错！"+exception,"error");
		    		}else{
		    			crossTableSetHeadui();
		    		}
		    	});
	    	}
	    	
		}else if(value=="link"){
			$("#tableDataEventLinkDiv").show();
			$("#tableDataEventActiveDiv").hide();
			var $selectable= $("#selectable_"+componentId);
			var $selectTds=$selectable.find(".ui-selected");
			var flag = 0;
			for(var a=0;a<$selectTds.length;a++){
				if($($selectTds[a]).attr("data-tableDataEvent")!=value){
					$($selectTds[a]).removeAttr("data-tableEventSelectJson");
					flag++;
				}
				$($selectTds[a]).attr("data-tableDataEvent",value);
			}
			if(flag>0){
				$("#tableDataEventLink").val("");
				$("#tableDataEventLinkShow").val("");
				$("#tableDataEventLinkParam").val("");
				$("#tableDataEventLinkParamShow").val("");
				setCrossTableEventType("link");
			}
			crossTableSetHeadui();
		}else if(value=='active'){
			var divHtmlStr='';
			var containersJson=$.ajax({url: appBase+"/getAllContainersJsonX.e?report_id="+reportId,type:"POST",cache: false,async: false}).responseText;
			containersJson=$.parseJSON(containersJson);
			if(containersJson!=null&&containersJson!=undefined&&containersJson!='null'){
				for(var a=0;a<containersJson.length;a++){
					var tempContainerId=containersJson[a]["id"];
					var tempContainerType=containersJson[a]["type"];
					var tempContainerPop=containersJson[a]["pop"];
					var tempComponents=containersJson[a]["components"];
					if(!(tempContainerPop=='1'&&tempContainerPop!=null&&tempContainerPop!=''&&tempContainerPop!='null')){
						if(tempComponents!=null&&tempComponents!=undefined&&tempComponents!='null'){
							var tempComponentList=tempComponents["componentList"];
							if(tempComponentList!=null&&tempComponentList!=undefined&&tempComponentList!='null'){
								for(var x=0;x<tempComponentList.length;x++){
									var tempComponentId=tempComponentList[x]["id"];
									var tempComponentType=tempComponentList[x]["type"];
									var tempComponentTitle=tempComponentList[x]["title"];
									if(tempComponentId==componentId||tempComponentType.indexOf("GRID")>-1||tempComponentType.indexOf("TABLE")>-1){
										continue;
									}
									var tempEventId=null;
									for(var w=0;w<eventList.length;w++){
										if(eventList[w]['source']==tempComponentId){
											tempEventId=eventList[w]["id"];
											break;
										}
									}
									var classStr='eventActive_'+tempComponentType.replace(/\d+/g,'');
									
									if(tempEventId==null||tempEventId==undefined||tempEventId=='null'){
										tempEventId=LayOutUtil.uuid();
										divHtmlStr+='<dt></dt>';
										divHtmlStr+='<dd>';
										divHtmlStr+='<p>';
										divHtmlStr+='<span>';
										divHtmlStr+='<input type="checkbox" id="tableDataEventActiveCheckbox" name="tableDataEventActiveCheckbox" value="'+tempComponentId+'" eventId="'+tempEventId+'"/><strong class="eventActiveChartCommon '+classStr+'">'+tempComponentTitle+'</strong>';
										divHtmlStr+='</span>';
										divHtmlStr+='<span>';
										divHtmlStr+='<input type="button" value="设置" class="eventActiveSetButtonClass" name="tableDataEventActiveButton" onclick="crossTableOpenEventActiveDialog(\''+tempComponentId+'\',\''+tempEventId+'\')" disabled="disabled"/>';
										divHtmlStr+='</span>';
										divHtmlStr+='</p>';
										divHtmlStr+='</dd>';
									}else{
										divHtmlStr+='<dt></dt>';
										divHtmlStr+='<dd>';
										divHtmlStr+='<p>';
										divHtmlStr+='<span>';
										divHtmlStr+='<input type="checkbox" id="tableDataEventActiveCheckbox" name="tableDataEventActiveCheckbox" value="'+tempComponentId+'" eventId="'+tempEventId+'" checked="checked"/><strong class="eventActiveChartCommon '+classStr+'">'+tempComponentTitle+'</strong>';
										divHtmlStr+='</span>';
										divHtmlStr+='<span>';
										divHtmlStr+='<input type="button" value="设置" class="eventActiveSetButtonClass" name="tableDataEventActiveButton" onclick="crossTableOpenEventActiveDialog(\''+tempComponentId+'\',\''+tempEventId+'\')" />';
										divHtmlStr+='</span>';
										divHtmlStr+='</p>';
										divHtmlStr+='</dd>';
									}
									
								}
							}
						}
					}
				}
			}
			$("#tableDataEventActiveDiv>dl").html(divHtmlStr);
			
			//动作类型多选框
			$("input[name='tableDataEventActiveCheckbox']").iCheck({
			    labelHover : false,
			    cursor : true,
			    checkboxClass : 'icheckbox_square-blue',
			    radioClass : 'iradio_square-blue',
			    increaseArea : '20%'
			}).on('ifClicked', function(event){
			  	crossTableEventActiveSetCheck(this);
			});
			
			var $selectable= $("#selectable_"+componentId);
			var $selectTds=$selectable.find(".ui-selected");
			var flag = 0;
			for(var a=0;a<$selectTds.length;a++){
				if($($selectTds[a]).attr("data-tableDataEvent")!=value){
					$($selectTds[a]).removeAttr("data-tableEventSelectJson");
					flag++;
				}
				$($selectTds[a]).attr("data-tableDataEvent",value);
			}
			if(flag>0){
				setCrossTableEventType("active");
			}
			$("#tableDataEventLinkDiv").hide();
			$("#tableDataEventActiveDiv").show();
			crossTableSetHeadui();
		}
}

/**
 * 打开数据单元格的选择面页的面板
 */
function crossTableDataOpenEventLinkDialog(){
	$("#crossTableDataEventLinkReportId").val("");
	$("#crossTableDataEventLinkReportName").val("");
	crossTableDataEventLinkReportQuery();
	$("#crossTableDataEventLinkDialog").dialog("open");
	hideToolsPanel();
}

/**
 * 数据单元格的选择面页的面板中点击查询按钮执行的方法
 */
function crossTableDataEventLinkReportQuery(){
	var info = {};
	info.crossTableDataEventLinkReportId = $("#crossTableDataEventLinkReportId").val();
	info.crossTableDataEventLinkReportName = $("#crossTableDataEventLinkReportName").val();
	info.crossTableDataEventLinkCurrentReportId=StoreData.xid;
	$("#crossTableDataEventLinkReportDatagrid").datagrid("load",info);
}
/**
 * 数据单元格的选择面页的面板中“操作”列的格式化方法
 * @param value
 * @param rowData
 * @returns {String}
 */
function crossTableDataEventLinkFormatter(value,rowData){
	var commentStr = '<a href="javascript:void(0);" style="text-decoration: none;margin:0 5px;" onclick="crossTableEventLinkReportCommit(\''+rowData.ID+'\',\''+rowData.NAME+'\',\''+rowData.URL+'\')">选择</a>';
	return  commentStr;
}

/**
 * 选择面页的面板中中点击完成按钮执行的方法
 * @param sourceId
 * @param sourceName
 * @param sourceUrl
 */
function crossTableEventLinkReportCommit(sourceId,sourceName,sourceUrl){
	$("#tableDataEventLinkShow").val(sourceName);
	$("#tableDataEventLink").val(sourceId);
	$('#crossTableDataEventLinkDialog').dialog('close');
	showToolsPanel();
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var eventStoreList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	var tempEventId='';
	var sourceType = "";
	for(var a=0;a<$selectTds.length;a++){
		var tableEventSelectJsonStr=$($selectTds[a]).attr("data-tableEventSelectJson");
		if(tableEventSelectJsonStr==undefined||tableEventSelectJsonStr==''||tableEventSelectJsonStr==null||tableEventSelectJsonStr=='null'){
			tableEventSelectJsonStr='{}';
		}
		var tableEventSelectJson=$.parseJSON(tableEventSelectJsonStr);
		
		var eventStore={};
		eventStore.type='link';
		eventStore.datacolcode=$($selectTds[a]).attr("colField");
		sourceType = $($selectTds[a]).attr("colType");
		var eventList=[];
		var event={};
		event.id=LayOutUtil.uuid();
		event.source=sourceId;
		event.sourceShow=sourceName;
		var tempEventStore=tableEventSelectJson;
		if(tempEventStore["eventList"]!=null){
			var tempEventList=tempEventStore["eventList"];
			if(tempEventList.length>0){
				event.id=tempEventList[0]["id"];
			}
		}
		
		eventList.push(event);
		eventStore.eventList=eventList;
		$($selectTds[a]).attr("data-tableEventSelectJson",$.toJSON(eventStore));
		eventStoreList.push(eventStore);
	}
	var info={};
	info.reportId=reportId;
	info.containerId=containerId;
	info.componentId=componentId;
	info.eventStoreList=eventStoreList;
	if(sourceType == "kpidata"){
		crossTableService.setMoreEventStoreMoreEvent(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","设置交叉表格链接属性时出错！"+exception,"error");
			}else{
				crossTableSetHeadui();
			}
		});
	}else if(sourceType == "rowdimdata"){
		crossTableService.setRowDimEvents(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","设置交叉表格链接属性时出错！"+exception,"error");
			}else{
				crossTableSetHeadui();
			}
		});
	}
	
}

/**
 * 数据单元格的链接的设置参数的面板的完成按钮的执行方法
 */
function crossTableDataEventLinkParamCommit(){
	var tableDataEventLinkParamTableTr=$("#crossTableDataEventLinkParamTable tr");
	var tableDataEventLinkParamShowStr='';
	var parameterList=[];
	for(var a=0;a<tableDataEventLinkParamTableTr.length;a++){
		var nameInput=$(tableDataEventLinkParamTableTr[a]).find("input[name='tableDataEventLinkParamName']");
		var valueInput=$(tableDataEventLinkParamTableTr[a]).find("input[name='tableDataEventLinkParamValue']");
		var value=null;
		if(valueInput!=undefined&&valueInput!=null&&valueInput.size()==1){
			value=valueInput.combobox().combobox("getValue");
		}
		if(value!=undefined&&value!=null&&value!=''&&value!='请选择'){
			if(nameInput!=undefined&&nameInput!=null&&nameInput.size()==1){
				var parameter={};
				parameter["dimsionid"]=nameInput.attr("dimsionId");
				parameter["name"]=nameInput.attr("id");
				parameter["value"]=value;
				parameterList.push(parameter);
				tableDataEventLinkParamShowStr+=nameInput.attr("value")+'='+value+';';
			}
		}
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var eventStoreList=[];
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	var sourceType="";
	for(var a=0;a<$selectTds.length;a++){
		var tableEventSelectJsonStr=$($selectTds[a]).attr("data-tableEventSelectJson");
		if(tableEventSelectJsonStr==undefined||tableEventSelectJsonStr==''||tableEventSelectJsonStr==null||tableEventSelectJsonStr=='null'){
			tableEventSelectJsonStr='{}';
		}
		var tableEventSelectJson=$.parseJSON(tableEventSelectJsonStr);
		if(tableEventSelectJson!=null){
			var eventList=tableEventSelectJson["eventList"];
			if(eventList!=undefined&&eventList!=null&&eventList!=''&&eventList!='null'&&eventList.length>0){
				var event=eventList[0];
				if(eventList!=undefined&&eventList!=null&&eventList!=''&&eventList!='null'){
					event.parameterList=parameterList;
					event.parameterShow=tableDataEventLinkParamShowStr;
				}
			}
		}
		$($selectTds[a]).attr("data-tableDataEvent",'link');
		$($selectTds[a]).attr("data-tableEventSelectJson",$.toJSON(tableEventSelectJson));
		sourceType=$($selectTds[a]).attr("colType");
		eventStoreList.push(tableEventSelectJson);
	}
	
	var info={};
	info.reportId=reportId;
	info.containerId=containerId;
	info.componentId=componentId;
	info.eventStoreList=eventStoreList;
	if(sourceType=="kpidata"){
		crossTableService.setMoreEventStoreMoreEvent(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","保存联动参数时出错！<br/>"+exception,"error");
			}else{
				crossTableSetHeadui();
			}
		});
	}else if(sourceType=="rowdimdata"){
		crossTableService.setRowDimEvents(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","保存联动参数时出错！<br/>"+exception,"error");
			}else{
				crossTableSetHeadui();
			}
		});
	}
	$("#tableDataEventLinkParamShow").val(tableDataEventLinkParamShowStr);
	$("#crossTableDataEventLinkParamDialog").dialog("close");
	showToolsPanel();
}

/**
 * 数据单元格的联动的设置参数的面板的完成按钮执行的方法
 */
function crossTableDataEventActiveParamCommit(){
	var tableDataEventActiveParamTableTr=$("#crossTableDataEventActiveParamTable tr");
	var parameterList=[];
	for(var a=0;a<tableDataEventActiveParamTableTr.length;a++){
		var nameInput=$(tableDataEventActiveParamTableTr[a]).find("input[name='tableDataEventActiveParamName']");
		var valueInput=$(tableDataEventActiveParamTableTr[a]).find("input[name='tableDataEventActiveParamValue']");
		var value=null;
		if(valueInput!=undefined&&valueInput!=null&&valueInput.size()==1){
			value=valueInput.combobox().combobox("getValue");
		}
		if(value!=undefined&&value!=null&&value!=''&&value!='请选择'){
			if(nameInput!=undefined&&nameInput!=null&&nameInput.size()==1){
				var parameter={};
				parameter["dimsionid"]=nameInput.attr("dimsionId");
				parameter["name"]=nameInput.attr("id");
				parameter["value"]=value;
				parameterList.push(parameter);
			}
		}
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var eventStoreList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	var sourceType;
	for(var a=0;a<$selectTds.length;a++){
		var tableEventSelectJsonStr=$($selectTds[a]).attr("data-tableEventSelectJson");
		if(tableEventSelectJsonStr==undefined||tableEventSelectJsonStr==''||tableEventSelectJsonStr==null||tableEventSelectJsonStr=='null'){
			tableEventSelectJsonStr='{}';
		}
		var tableEventSelectJson=$.parseJSON(tableEventSelectJsonStr);
		if(tableEventSelectJson==null){
			tableEventSelectJson={};
		}
		tableEventSelectJson.type='cas';
		tableEventSelectJson.datacolcode=$($selectTds[a]).attr("colField");
		sourceType=$($selectTds[a]).attr("colType");
		var eventList=tableEventSelectJson["eventList"];
		if(eventList==undefined||eventList==null||eventList==''||eventList=='null'){
			eventList=[];
		}
		tableEventSelectJson.eventList=eventList;
		var event=null;
		for(var x=0;x<eventList.length;x++){
			if(eventList[x]["id"]==crossTableCurrentEvnetEventId&&eventList[x]["source"]==tableCurrentEvnetCompenentId){
				event=eventList[x];
				break;
			}
		}
		if(event==null){
			event={};
			event["id"]=crossTableCurrentEvnetEventId;
			event["source"]=tableCurrentEvnetCompenentId;
			eventList.push(event);
		}
		
		event.parameterList=parameterList;
		
		$($selectTds[a]).attr("data-tableEventSelectJson",$.toJSON(tableEventSelectJson));
		eventStoreList.push(tableEventSelectJson);
	}
	
	var info={};
	info.reportId=reportId;
	info.containerId=containerId;
	info.componentId=componentId;
	info.eventStoreList=eventStoreList;
	if(sourceType == "kpidata"){
		crossTableService.setMoreEventStoreMoreEvent(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","设置交叉表格联动属性时出错！"+exception,"error");
			}else{
				crossTableSetHeadui();
			}
		});
	}else if(sourceType == "rowdimdata"){
		crossTableService.setRowDimEvents(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","设置交叉表格联动属性时出错！"+exception,"error");
			}else{
				crossTableSetHeadui();
			}
		});
	}
	
	$("#crossTableDataEventActiveParamDialog").dialog("close");
	showToolsPanel();
}

/**
 * 数据单元格的联动的设置参数的面板的添加行
 * @param dimsionId
 * @param name
 * @param nameDesc
 * @param value
 * @param valueData
 * @param valueField
 * @param TextField
 */
function crossTableOpenEventActiveParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField){
	var insertHtmlStr='';
	insertHtmlStr+='<tr>';
	insertHtmlStr+='<td width="50%">参数名:&nbsp;<input type="text" id="'+name+'" name="tableDataEventActiveParamName" dimsionId="'+dimsionId+'" style="width:120px;" value="" readonly="readonly"></td>';
	insertHtmlStr+='<td>对应数据列:&nbsp;<input name="tableDataEventActiveParamValue" value="请选择"  style="width:120px"></td>';
	insertHtmlStr+='</tr>';
	var $row = $(insertHtmlStr);
	$row.appendTo($("#crossTableDataEventActiveParamTable"));
	var tableDataEventActiveParamName=$row.find("input[name='tableDataEventActiveParamName']");
	tableDataEventActiveParamName.val(nameDesc);
	var tableDataEventActiveParamValue=$row.find("input[name='tableDataEventActiveParamValue']");
	tableDataEventActiveParamValue.combobox({   
	    data:valueData,   
	    valueField:valueField,   
	    textField:TextField,
	    editable:false,
	    value:value
	});  
}

/**
 * 数据单元格的联动的设置参数的面板的添加行
 * @param dimsionId 参数维度编号
 * @param name 参数名称
 * @param nameDesc 参数描述
 * @param value 对应本组件的维度列
 * @param valueData 所有可选列数组
 * @param valueField 下拉列表的值字段
 * @param TextField  下拉列表的文本字段
 */
function crossTableEventLinkParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField){
		var insertHtmlStr='';
		insertHtmlStr+='<tr>';
		insertHtmlStr+='<td width="50%">参数名:&nbsp;<input type="text" id="'+name+'" name="tableDataEventLinkParamName" dimsionId="'+dimsionId+'" style="width:120px;" value="" readonly="readonly"></td>';
		insertHtmlStr+='<td>对应数据列:&nbsp;<input name="tableDataEventLinkParamValue" value="请选择"  style="width:120px"></td>';
		insertHtmlStr+='</tr>';
		var $row = $(insertHtmlStr);
		$row.appendTo($("#crossTableDataEventLinkParamTable"));
		var tableDataEventLinkParamName=$row.find("input[name='tableDataEventLinkParamName']");
		tableDataEventLinkParamName.val(nameDesc);
		var tableDataEventLinkParamValue=$row.find("input[name='tableDataEventLinkParamValue']");
		tableDataEventLinkParamValue.combobox({   
		    data:valueData,   
		    valueField:valueField,   
		    textField:TextField,
		    editable:false,
		    value:value
		});  
}

/**
 * 设置数据单元格的联动面板中的组件是否联动
 * @param obj
 */
function crossTableEventActiveSetCheck(obj){
	var eventId=$(obj).attr("eventId");
	var eventSource=$(obj).attr("value");
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var isHasSameEventJsonFlag=true;
	var tableEventSelectJsonStr='';
	var tableEventSelectJson=null;
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		if(a==0){
			tableEventSelectJsonStr=$($selectTds[a]).attr("data-tableEventSelectJson");
		}
		if(tableEventSelectJsonStr!=$($selectTds[a]).attr("data-tableEventSelectJson")){
			isHasSameEventJsonFlag=false;
		}
	}
	var eventList=null;
	if(tableEventSelectJsonStr==undefined||tableEventSelectJsonStr==''||tableEventSelectJsonStr==null||tableEventSelectJsonStr=='null'){
		tableEventSelectJsonStr='{}';
	}
	tableEventSelectJson=$.parseJSON(tableEventSelectJsonStr);
	eventList=tableEventSelectJson["eventList"];
	if(eventList==undefined||eventList==null||eventList==''||eventList=='null'){
		eventList=[];
		tableEventSelectJson.eventList=eventList;
	}
	var eventInfo=null;
	var eventInfoIndex=0;
	for(var i=0;i<eventList.length;i++){
		if(eventList[i]["id"]==eventId){
			eventInfo=eventList[i];
			eventInfoIndex=i;
			break;
		}
	}
	if(eventInfo==undefined||eventInfo==null||eventInfo==''||eventInfo=='null'){
		eventInfo={};
		eventInfo.id=eventId;
		eventInfo.source=eventSource;
		eventInfoIndex=eventList.length;
		eventList.push(eventInfo);
	}
	
	if($(obj).attr("checked")!='checked'){
		$(obj).parent().parent().parent().find("input[name='tableDataEventActiveButton']").removeAttr("disabled");
	}else{
		eventInfo={};
		eventList[eventInfoIndex]=eventInfo;
		$(obj).parent().parent().parent().find("input[name='tableDataEventActiveButton']").attr("disabled","disabled");
	}
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var eventStoreList=[];
	var sourceType="";
	for(var a=0;a<$selectTds.length;a++){
		var tempEventStore=jQuery.extend(true, {}, tableEventSelectJson); 
		tempEventStore.type='cas';
		tempEventStore.datacolcode=$($selectTds[a]).attr("colField");
		sourceType=$($selectTds[a]).attr("colType");
		eventStoreList.push(tempEventStore);
		$($selectTds[a]).attr("data-tableEventSelectJson",$.toJSON(tableEventSelectJson));
	}
	var info={};
	info.reportId=reportId;
	info.containerId=containerId;
	info.componentId=componentId;
	info.eventStoreList=eventStoreList;
	if(sourceType == "kpidata"){
		crossTableService.setMoreEventStoreMoreEvent(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","设置组件联动时出错！"+exception,"error");
			}else{
				crossTableSetHeadui();
			}
		});
	}else if(sourceType == "rowdimdata"){
		crossTableService.setRowDimEvents(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","设置组件联动时出错！"+exception,"error");
			}else{
				crossTableSetHeadui();
			}
		});
	}
}


function setCrossTableEventType(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var eventStoreList=[];
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	var sourceType = "";
	for(var a=0;a<$selectTds.length;a++){
		var eventStore={};
		eventStore.type=value;
		eventStore.datacolcode=$($selectTds[a]).attr("colField");
		sourceType = $($selectTds[a]).attr("colType");
		eventStore.eventList=eventList=[];
		$($selectTds[a]).attr("data-tableEventSelectJson",$.toJSON(eventStore));
		eventStoreList.push(eventStore);
	}
	var info={};
	info.reportId=reportId;
	info.containerId=containerId;
	info.componentId=componentId;
	info.eventStoreList=eventStoreList;
	if(sourceType == "kpidata"){
		crossTableService.setMoreEventStoreMoreEvent(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","设置交叉表格链接属性时出错！"+exception,"error");
			}else{
				crossTableSetHeadui();
			}
		});
	}else if(sourceType == "rowdimdata"){
		crossTableService.setRowDimEvents(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","设置交叉表格链接属性时出错！"+exception,"error");
			}else{
				crossTableSetHeadui();
			}
		});
	}
	
}


/*********************************************其他方法开始***************************************************/
/**
 * 将"<"用"&lt;"替换、">"用"&gt;"替换
 * @param htmlCode
 * @returns
 */
function crossFilterHtml(htmlCode){
    return htmlCode.replace(/</g,"&lt;").replace(/>/g,"&gt;");//替换“<”和“>”
}

/**	描述：切换布局方式 
参数：
	lType 布局方式,1:电脑、2:手机
*/
function crossTableSwitchLType(lType){
	setTimeout(function(){
		if(lType=='1'){
			if($("#tablePagiDt").size()>0){
				$("#tablePagiDt").show();//显示分页的dt标签
			}
			if($("#tablePagiDd").size()>0){
				$("#tablePagiDd").show();//显示分页的dd标签
			}
			if($("#tableExportDt").size()>0){
				$("#tableExportDt").show();//显示导出的dt标签
			}
			if($("#tableExportDd").size()>0){
				$("#tableExportDd").show();//显示导出的dd标签
			}
			if($("#crossTableDataRowMergePTag").size()>0){
				$("#crossTableDataRowMergePTag").show();//显示行间相邻相同数据合并
			}
			if($("#crossTableDataEventDiv").size()>0){
				$("#crossTableDataEventDiv").show();//显示动作
			}
		
		}else if(lType=='2'){
			if($("#tablePagiDt").size()>0){
				$("#tablePagiDt").hide();//隐藏分页的dt标签
				
			}
			if($("#tablePagiDd").size()>0){
				$("#tablePagiDd").hide();//隐藏分页的dd标签
			}
			
			if($("#tableExportDt").size()>0){
				$("#tableExportDt").hide();//隐藏导出的dt标签
				
			}
			if($("#tableExportDd").size()>0){
				$("#tableExportDd").hide();//隐藏导出的dd标签
			}
			
			if($("#crossTableDataRowMergePTag").size()>0){
				$("#crossTableDataRowMergePTag").hide();//隐藏行间相邻相同数据合并
			}
			if($("#crossTableDataEventDiv").size()>0){
				$("#crossTableDataEventDiv").hide();//隐藏动作
			}
		}
	},100);
}


/* 保存页头源码 */
function crossTableSetHeadui(){
	var componentId=StoreData.curComponentId;
	var headui=$('#selectable_' + componentId).html();
	var info={};
	info.reportId=StoreData.xid;
	info.containerId=StoreData.curContainerId;
	info.componentId=componentId;
	info.headui=headui;
	crossTableService.setHeadui(info,function(data,exception){});
}
/*****************************************************************其他方法结束*****************************************************************/



/*********************************************行维度区域、列维度区域、指标区域、排序列区域方法开始****************************************************/
/**---------------------------------------------------------------初始化各个区域的方法--------------------------------------------------------**/
var receivedDivId;
/** 
 * 初始化被选指标区域
*/
function initCrossColumnDiv(){
	$('#tableColumnDiv li').draggable({
		proxy:function(source){
			var p = $('<div style="border:1px solid #ccc;width:80px"></div>');
			p.html($(source).text()).appendTo('body');
			return p;
		},
		revert:true,
		cursor:'auto',
		onStartDrag: function () {
	         $(this).draggable('options').cursor = 'allowed';
	         var proxy = $(this).draggable('proxy').css('z-index', 99999);
	         proxy.hide();
	     },
	     onDrag: function(){
	     	if($(this).draggable('proxy')!=null){
	     		$(this).draggable('proxy').show();
	     	}
	     },
	     onStopDrag: function () {
	         $(this).draggable('options').cursor = 'move';
	     }
	});
}

/**
 * 初始化维度区域
 * @param divId
 */
function initCrossDimColumnDiv(divId,sourceType){
	$('#'+divId).droppable({
		onDragEnter:function(e,source){},
		onDragLeave:function(e,source){},
		onDrop:function (e, source) {
			if(sourceType=="sql"){
				var liSpan=$(source).find("span[id^='tableColumn_']");
				if(liSpan.attr("extcolumnid")!=undefined){
					$.messager.alert("交叉表格","计算列不能做维度！","error");
					return;
				}
				var liCheckBox=$(source).find("input[type='checkbox']");
				var subIndex='tableColumn_'.length;
				var dimId=liSpan.attr("id").substring(subIndex);
				var dimColumn=liSpan.attr("name").substring(subIndex);
				var dimDesc=liSpan.text();
				if(insertCrossDimColumnHtml(divId,dimId,dimColumn,dimDesc)){
					liCheckBox.iCheck('check');
					saveCrossDimColumns();
				}
			}else if(sourceType=="kpi"){
				var itemObj = null;
				if($(source).attr("key")==undefined){//计算列窗口指标不能拖动到此div
					return;
				}
				if($(source).attr("node-id")==undefined){//指标库选择
					 itemObj = crossTableKpiSelector.currentItem;
				}else{//计算列选择
					itemObj = {
							id:$(source).attr("node-id"),
							column:$(source).attr("node-id"),
							desc:$(source).attr("desc"),
							kpiType:'extcolumn'
					}
				}
				if(insertCrossDimColumnHtml(divId,itemObj.id,itemObj.column,itemObj.desc)){
					saveCrossDimColumns();
				}
			}
		}
	});
	var tableDimColumnUl=$("#"+divId+">ul");
	var connetWithDivId = divId =="verticalDimColumnDiv"?"horizontalDimColumnDiv":"verticalDimColumnDiv";
	tableDimColumnUl.sortable({
		connectWith: "#tableKpiColumnDiv>ul,#tableSortColumnDiv>ul,#"+connetWithDivId+">ul",
		start:function(event,ui){
			currentDragItem={item:ui.item[0],index:getCrossColumnIndex(divId,ui.item[0])};
		},
		stop:function(event,ui){
			setTimeout(function(){
				if(receivedDivId!=undefined){
					receivedDivId = undefined;
				}else{
					saveCrossDimColumns();
				}
			},500);
		},
		receive: dimColumnRecieve
	});
	
	tableDimColumnUl.disableSelection();
}

/**
 * 初始化指标区域
 */
function initCrossKpiColumnDiv(sourceType){
	$('#tableKpiColumnDiv').droppable({
		onDragEnter:function(e,source){},
		onDragLeave:function(e,source){},
		onDrop:function (e, source) {
			if(sourceType=="sql"){
				var liCheckBox=$(source).find("input[type='checkbox']");
				liCheckBox.iCheck('check');
				var liSpan=$(source).find("span[id^='tableColumn_']");
				var subIndex='tableColumn_'.length;
				var kpiId=liSpan.attr("id").substring(subIndex);
				var kpiColumn=liSpan.attr("name").substring(subIndex);
				var kpiName=liSpan.text();
				if(insertCrossKpiColumnHtml(kpiId,kpiColumn,kpiName)){
					saveCrossKpiColumns();
				}
			}else if(sourceType=="kpi"){
				var kpiObj = null;
				if($(source).attr("key")==undefined){//计算列窗口指标不能拖动到此div
					return;
				}
				if($(source).attr("node-id")==undefined){//指标库选择
					kpiObj = crossTableKpiSelector.currentItem;
				}else{//计算列选择
					kpiObj = {
							id:$(source).attr("node-id"),
							column:$(source).attr("node-id"),
							desc:$(source).attr("desc"),
							kpiType:'extcolumn'
					}
				}
				if(insertCrossKpiColumnHtml(kpiObj.id,kpiObj.column,kpiObj.desc)){
					saveCrossKpiColumns();
				}
			}
		}
	});
	var tableKpiColumnUl=$("#tableKpiColumnDiv>ul");
	tableKpiColumnUl.sortable({
		connectWith: "#horizontalDimColumnDiv>ul,#tableSortColumnDiv>ul,#verticalDimColumnDiv>ul",
		start:function(event,ui){
			currentDragItem={item:ui.item[0],index:getCrossColumnIndex("tableKpiColumnDiv",ui.item[0])};
		},
		stop:function(event,ui){
			setTimeout(function(){
				if(receivedDivId!=undefined){
					receivedDivId = undefined;
				}else{
					saveCrossKpiColumns();
				}
			},500);
		},
		receive: kpiColumnRecieve
	});
	tableKpiColumnUl.disableSelection();
}

/**
 * 初始化排序区域
 */
function initCrossSortColumnDiv(sourceType){
	$('#tableSortColumnDiv').droppable({
		onDragEnter:function(e,source){},
		onDragLeave:function(e,source){},
		onDrop:function (e, source) {
			var sortId,sortColumn,sortName,kpicolType;
			if(sourceType=="sql"){
				var liCheckBox=$(source).find("input[type='checkbox']");
				liCheckBox.iCheck('check');
				var liSpan=$(source).find("span[id^='tableColumn_']");
				var subIndex='tableColumn_'.length;
				sortId=liSpan.attr("id").substring(subIndex);
				sortColumn=liSpan.attr("name").substring(subIndex);
				sortName=liSpan.text();
			}else if(sourceType=="kpi"){
				var kpiObj = null;
				if($(source).attr("key")==undefined){//计算列窗口指标不能拖动到此div
					return;
				}
				if($(source).attr("node-id")==undefined){//指标库选择
					kpiObj = crossTableKpiSelector.currentItem;
					kpicolType="kpi";
				}else{//计算列选择
					kpiObj = {
							id:$(source).attr("node-id"),
							column:$(source).attr("node-id"),
							desc:$(source).attr("desc"),
							kpiType:'extcolumn'
					}
					kpicolType="extcolumn";
				}
				sortId=kpiObj.id;
				sortColumn=kpiObj.column;
				sortName=kpiObj.desc;
			}
			
			if(insertCrossSortColumnHtml(sortId,sortColumn,sortName)){
				var kpiType='dim';
				if($("#tableDimColumn_"+sortId).size()!=0){
					kpiType='dim';
				}else if($("#tableKpiColumn_"+sortId).size()!=0||$("#tableColumn_C"+sortName).attr("extcolumnid")!=undefined||kpicolType=="extcolumn"){
					kpiType='kpi';
				}
				$("#tableSortColumnTypeATag_"+kpiType+"_"+sortId).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
				if(kpiType=='kpi'){
					$("#tableSortColumnATag_desc_"+sortId).show();
					$("#tableSortColumnATag_asc_"+sortId).hide();
				}
				saveCrossSortColumns();
			}
		}
	  }
	);
	var tableSortColumnUl=$("#tableSortColumnDiv>ul");
	tableSortColumnUl.sortable({
		connectWith: "#horizontalDimColumnDiv>ul,#tableKpiColumnDiv>ul,#verticalDimColumnDiv>ul",
		start:function(event,ui){
			currentDragItem={item:ui.item[0],index:getCrossColumnIndex("tableSortColumnDiv",ui.item[0])};
		},
		stop:function(event,ui){
			setTimeout(function(){
				if(receivedDivId!=undefined){
					receivedDivId = undefined;
				}else{
					saveCrossSortColumns();
				}
			},500);
		},
		receive: sortColumnRecieve
	}).disableSelection();
}

/**----------------------------------------------------------------生成各区域行HTML方法----------------------------------------------------------------------------**/
/**
 * 生成向维度区域中添加指标的html代码
 * @param dimColumnId:指标编码
 * @param dimColumnName:指标字段名称
 * @param dimColumnDesc:指标描述
 * @returns {String}
 */
function generateDimColumnHtml(dimColumnId,dimColumnName,dimColumnDesc){
		dimColumnDesc = $.trim(dimColumnDesc);
		var tableDimColumnHtmlStr='';
		var spanText = StoreData.dsType == "1" ? dimColumnName : dimColumnDesc;
		tableDimColumnHtmlStr+='<li><p class="delBtn">';
		tableDimColumnHtmlStr+='<span id="tableDimColumn_'+dimColumnId+'" name="tableDimColumn_'+dimColumnName+'" class="dropText" title="'+dimColumnDesc+'">'+spanText+'</span>';
		tableDimColumnHtmlStr+='<span><a href="javascript:void(0);" id="tableDimColumnCloseATag_'+dimColumnId+'" class="colbtn" onclick="removeCrossDimColumn(\''+dimColumnId+'\')">删除</a></span>';
		tableDimColumnHtmlStr+='</p></li>';
		tableDimColumnHtmlStr+='';
		return tableDimColumnHtmlStr;
}

/**
 * 生成向指标区域中添加指标的html代码
 * @param kpiColumnId:指标编码
 * @param kpiColumnName:指标字段名称
 * @param kpiColumnDesc:指标描述
 * @returns {String}
 */
function generateKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc){
	kpiColumnDesc = $.trim(kpiColumnDesc);
	var tableKpiColumnHtmlStr='';
	var spanText = StoreData.dsType == "1" ? kpiColumnName : kpiColumnDesc;
	var extcolumnidStr = "";
	var extcolumnid=undefined;
	if(kpiColumnId==kpiColumnName){
		extcolumnid = kpiColumnId;
	}else{
		extcolumnid = $("span[name='tableColumn_"+kpiColumnName+"']").eq(0).attr("extcolumnid");
	}
	if(extcolumnid!=undefined){
		extcolumnidStr = 'extcolumnid="'+extcolumnid+'"';
	}
	tableKpiColumnHtmlStr+='<li><p class="delBtn">';
	tableKpiColumnHtmlStr+='<span id="tableKpiColumn_'+kpiColumnId+'" name="tableKpiColumn_'+kpiColumnName+'" class="dropText" '+extcolumnidStr+' title="'+kpiColumnDesc+'">'+spanText+'</span>';
	tableKpiColumnHtmlStr+='<span><a href="javascript:void(0);" class="colbtn" id="tableKpiColumnCloseATag_'+kpiColumnId+'" onclick="removeCrossKpiColumn(\''+kpiColumnId+'\')">删除</a></span>';
	tableKpiColumnHtmlStr+='</p></li>';
	return tableKpiColumnHtmlStr;
}

/**
 * 生成向默认排序区域中添加指标的html代码
 * @param sortColumnId:指标编码
 * @param sortColumnName:指标字段名称
 * @param sortColumnDesc:指标描述
 * @returns {String}
 */
function generateSortColumnHtml(sortColumnId,sortColumnName,sortColumnDesc,defaultOrderType){
	sortColumnDesc = $.trim(sortColumnDesc);
	var tableSortColumnHtmlStr='';
	var spanText = StoreData.dsType == "1" ? sortColumnName : sortColumnDesc;
	var extcolumnidStr = "";
	var extcolumnid=undefined;
	if(sortColumnId==sortColumnName){
		extcolumnid = sortColumnId;
	}else{
		extcolumnid = $("span[name='tableColumn_"+sortColumnName+"']").eq(0).attr("extcolumnid");
	}
	if(extcolumnid!=undefined){
		extcolumnidStr = 'extcolumnid="'+extcolumnid+'"';
	}
	tableSortColumnHtmlStr+='<li><p class="delBtn threeBtn">';
	tableSortColumnHtmlStr+='<span id="tableSortColumn_'+sortColumnId+'" name="tableSortColumn_'+sortColumnName+'" class="dropText" title="'+sortColumnDesc+'" '+extcolumnidStr+'>'+spanText+'</span>';
	tableSortColumnHtmlStr+="<span>";
	tableSortColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"tableSortColumnTypeATag_dim_"+sortColumnId+"\"  class=\"nicewidth active\" onclick=\"setCrossSortKpiType('kpi','"+sortColumnId+"',this)\">维度</a>"
	tableSortColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"tableSortColumnTypeATag_kpi_"+sortColumnId+"\" class=\"nicepoint active\" style=\"display: none\" onclick=\"setCrossSortKpiType('dim','"+sortColumnId+"',this)\">指标</a>"
	if(defaultOrderType=="asc"){
		tableSortColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"tableSortColumnATag_asc_"+sortColumnId+"\" class=\"upbtn active\" onclick=\"setCrossSortMode('desc','"+sortColumnId+"')\">正</a>"
		tableSortColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"tableSortColumnATag_desc_"+sortColumnId+"\" class=\"downbtn active\" style=\"display: none\" onclick=\"setCrossSortMode('asc','"+sortColumnId+"',this)\">倒</a>"
	}else{
		tableSortColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"tableSortColumnATag_asc_"+sortColumnId+"\" class=\"upbtn active\" style=\"display: none\" onclick=\"setCrossSortMode('desc','"+sortColumnId+"')\">正</a>"
		tableSortColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"tableSortColumnATag_desc_"+sortColumnId+"\" class=\"downbtn active\"  onclick=\"setCrossSortMode('asc','"+sortColumnId+"',this)\">倒</a>"
	}
	tableSortColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"tableSortColumnCloseATag_"+sortColumnId+"\" class=\"colbtn\" onclick=\"removeCrossSortColumn('"+sortColumnId+"')\">删除</a>"
	tableSortColumnHtmlStr+="</span>"
	tableSortColumnHtmlStr+='</p></li>';
	return tableSortColumnHtmlStr;
}

/**----------------------------------------------------------------保存到后台xml方法----------------------------------------------------------------------------**/
/** 
 * 保存所有横向纵向维度
*/
function saveCrossDimColumns(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var dimList = new Array();
    var verDimLiList = $("#verticalDimColumnDiv>ul>li");
    var subIndex = 'tableDimColumn_'.length;
    $.each(verDimLiList,function(index,li){
    	var $span=$(li).find("span:eq(0)");
    	var dimId=$span.attr("id").substring(subIndex);
		var dimField = $span.attr("name").substring(subIndex);
		var dimDesc = $span.attr("title");
		dimList.push({dimId:dimId,dimField:dimField,dimDesc:dimDesc,dimIndex:index,dimType:'1'});
    });
    var horDimLiList = $("#horizontalDimColumnDiv>ul>li");
    $.each(horDimLiList,function(index,li){
    	var $span=$(li).find("span:eq(0)");
    	var dimId=$span.attr("id").substring(subIndex);
    	var dimField = $span.attr("name").substring(subIndex);
    	var dimDesc = $span.attr("title");
    	dimList.push({dimId:dimId,dimField:dimField,dimDesc:dimDesc,dimIndex:index,dimType:'2'});
    });
    var info={reportId:reportId,containerId:containerId,componentId:componentId,dimMapList:dimList};
    crossTableService.saveCrossDimColumns(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存维度时出错！<br/>"+exception,"error");
		}else{
			setDesignTableHtml();
			if(window['crossTableInsertMoreKpiStoreColumn']!=undefined){
				crossTableInsertMoreKpiStoreColumn(true);
			}
		}
	});
}

/**
 * 保存指标列
 */
function saveCrossKpiColumns(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var kpiMapList = new Array();
	var kpiLiList = $("#tableKpiColumnDiv>ul>li");
    $.each(kpiLiList,function(index,li){
    	var $span=$(li).find("span:eq(0)");
    	var extcolumnid = $span.attr("extcolumnid");
    	var datacolid="";
    	var datacolcode="";
    	if(extcolumnid==undefined){
        	datacolid = $span.attr("id").substring('tableKpiColumn_'.length);
        	datacolcode = $span.attr("name").substring('tableKpiColumn_'.length);
        	extcolumnid = "";
    	}else{
//    		datacolid = "";
//        	datacolcode = "";
    		datacolid = $span.attr("id").substring('tableKpiColumn_'.length);
        	datacolcode = $span.attr("name").substring('tableKpiColumn_'.length);
    	}
    	var tablecoldesc = $span.attr("title");
		extcolumnid = extcolumnid==undefined?"":extcolumnid;
    	kpiMapList.push({datacolid:datacolid,datacolcode:datacolcode,tablecoldesc:tablecoldesc,extcolumnid:extcolumnid});
    });
    var info={reportId:reportId,containerId:containerId,componentId:componentId,kpiMapList:kpiMapList};
	crossTableService.saveCrossKpiColumns(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存指标时出错！<br/>"+exception,"error");
		}else{
			setDesignTableHtml();
			if(window['crossTableInsertMoreKpiStoreColumn']!=undefined){
				crossTableInsertMoreKpiStoreColumn(true);
			}
		}
	});
}

/**
 * 保存排序列
 */      
function saveCrossSortColumns(){
	var sortMapList = new Array();
	var liList = $("#tableSortColumnDiv>ul>li");
	$.each(liList,function(index,li){
		var $span0 = $(li).find("span:eq(0)");
		var $span1 = $(li).find("span:eq(1)");
    	var linkArr = $span1.find("a");
    	var extcolumnid = $span0.attr("extcolumnid");
		var colid = "";
		var colcol ="";
		if(extcolumnid==undefined){
			colid = $span0.attr("id").substring('tableSortColumn_'.length);
			colcol = $span0.attr("name").substring('tableSortColumn_'.length);
			extcolumnid="";
		}else{
//			colid = "";
//			colcol = "";
			colid = $span0.attr("id").substring('tableSortColumn_'.length);
			colcol = $span0.attr("name").substring('tableSortColumn_'.length);
		}
    	sortMapList.push({
    		id:colid,
    		col:colcol,
    		desc:$span0.text(),
    		type:$(linkArr[2]).css("display")=="block"?"asc":"desc",
    		kpitype:$(linkArr[0]).css("display")=="block"?"dim":"kpi",
    		extcolumnid:extcolumnid
    	});
	});
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
    var info={reportId:reportId,containerId:containerId,componentId:componentId,sortMapList:sortMapList};
	crossTableService.saveCrossSortColumns(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("交叉表格","保存排序时出错！<br/>"+exception,"error");
		}else{
			if(window['crossTableInsertMoreKpiStoreColumn']!=undefined){
				crossTableInsertMoreKpiStoreColumn(true);
			}
		}
	});
}

/**----------------------------------------------------------------删除各区域中指标项的方法----------------------------------------------------------------------------**/
/**
 * 删除维度区域中维度记录
 * @param columnId
 */
function removeCrossDimColumn(columnId){
	if($("#tableDimColumn_"+columnId).size()>0){
		$("#tableDimColumn_"+columnId).parent().parent().remove();
	}
	crossTableFlushColumnDiv(columnId);
	saveCrossDimColumns();
}

/**
 * 删除指标区域中指标记录
 * @param columnId
 */
function removeCrossKpiColumn(columnId){
	if($("#tableKpiColumn_"+columnId).size()>0){
		$("#tableKpiColumn_"+columnId).parent().parent().remove();
	}
	crossTableFlushColumnDiv(columnId);
	saveCrossKpiColumns();
}

/**
 * 删除默认排序区域中默认排序记录
 * @param columnId
 */
function removeCrossSortColumn(columnId){
	if($("#tableSortColumn_"+columnId).size()>0){
		$("#tableSortColumn_"+columnId).parent().parent().remove();
	}
	crossTableFlushColumnDiv(columnId);
	saveCrossSortColumns();
}

/**
 * 更改被选中区域指标的选中状态
 * @param columnId
 */
function crossTableFlushColumnDiv(columnId){
	if($("#tableColumnCheckbox_"+columnId)[0]!=undefined){
		var isHorDimCheck = $("#horizontalDimColumnDiv>ul>li span[id='tableDimColumn_"+columnId+"']").size()==0;
		var isVerDimCheck = $("#verticalDimColumnDiv>ul>li span[id='tableDimColumn_"+columnId+"']").size()==0;
		var isKpiCheck = $("#tableKpiColumnDiv>ul>li span[id='tableKpiColumn_"+columnId+"']").size()==0;
		var isSortCheck = $("#tableSortColumnDiv>ul>li span[id='tableSortColumn_"+columnId+"']").size()==0;
		if(isVerDimCheck&&isHorDimCheck&&isKpiCheck&&isSortCheck){
		 	$("#tableColumnCheckbox_"+columnId).iCheck('uncheck');
		}else{
			$("#tableColumnCheckbox_"+columnId).iCheck('check');
		}
	}
}

/**----------------------------------------------------------------向各区域添加指标项的方法----------------------------------------------------------------------------**/
/**
 * 向维度区域中添加指标的html部分
 * @param divId:横向维度或纵向维度的div编号
 * @param dimColumnId:指标编码
 * @param dimColumnName:指标字段名称
 * @param dimColumnDesc:指标描述
 * @returns {Boolean}
 */
function insertCrossDimColumnHtml(divId,dimColumnId,dimColumnName,dimColumnDesc){
		var tableDimColumnUl=$("#"+divId+">ul");
		var tableKpiColumnUl=$("#tableKpiColumnDiv>ul");
		var tableHorDimColumnUl=$("#horizontalDimColumnDiv>ul");
		var tableVerDimColumnUl=$("#verticalDimColumnDiv>ul");
		if(dimColumnId==dimColumnName){
			$.messager.alert("交叉表格","计算列不能做维度！","error");
			return false;
		}
		if(tableKpiColumnUl.find("li span[id='tableKpiColumn_"+dimColumnId+"']").size()>0){
			$.messager.alert("交叉表格","选择无效，在指标区域已存在该指标！","error");
			return false;
		}
		if(tableHorDimColumnUl.find("li span[id='tableDimColumn_"+dimColumnId+"']").size()>0){
			$.messager.alert("交叉表格","选择无效，在横向维度区域已存在该指标！","error");
			return false;
		}
		if(tableVerDimColumnUl.find("li span[id='tableDimColumn_"+dimColumnId+"']").size()>0){
			$.messager.alert("交叉表格","选择无效，在纵向维度区域已存在该指标！","error");
			return false;
		}
		var tableDimColumnHtmlStr=generateDimColumnHtml(dimColumnId,dimColumnName,dimColumnDesc);
		tableDimColumnUl.append(tableDimColumnHtmlStr);
		return true;
}

/**
 * 向指标区域中添加指标的html部分
 * @param kpiColumnId:指标编码
 * @param kpiColumnName:指标字段名称
 * @param kpiColumnDesc:指标描述
 * @param checkExist:是否检验存在不存在
 * @returns {Boolean}
 */
function insertCrossKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc){
	var tableKpiColumnUl=$("#tableKpiColumnDiv>ul");
	var tableHorDimColumnUl=$("#horizontalDimColumnDiv>ul");
	var tableVerDimColumnUl=$("#verticalDimColumnDiv>ul");
	if(tableKpiColumnUl.find("li span[id='tableKpiColumn_"+kpiColumnId+"']").size()>0){
		$.messager.alert("交叉表格","选择无效，在指标区域已存在该指标！","error");
		return false;
	}
	if(tableHorDimColumnUl.find("li span[id='tableDimColumn_"+kpiColumnId+"']").size()>0){
		$.messager.alert("交叉表格","选择无效，在横向维度区域已存在该指标！","error");
		return false;
	}
	if(tableVerDimColumnUl.find("li span[id='tableDimColumn_"+kpiColumnId+"']").size()>0){
		$.messager.alert("交叉表格","选择无效，在纵向维度区域已存在该指标！","error");
		return false;
	}
	var tableKpiColumnHtmlStr=generateKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc);//向指标区域中添加指标的html代码
	tableKpiColumnUl.append(tableKpiColumnHtmlStr);
	return true;
}

/**
 * 向排序区域中添加指标的html部分
 * @param sortColumnId:指标编码
 * @param sortColumnName:指标字段名称
 * @param sortColumnDesc:指标描述
 * @returns {Boolean}
 */
function insertCrossSortColumnHtml(sortColumnId,sortColumnName,sortColumnDesc){
	var tableSortColumnUl=$("#tableSortColumnDiv>ul");
	if(tableSortColumnUl.find("li span[id='tableSortColumn_"+sortColumnId+"']").size()>0){
		$.messager.alert("交叉表格","选择无效，该默认排序列已存在！","error");
		return false;
	}
	var tableSortColumnHtmlStr=generateSortColumnHtml(sortColumnId,sortColumnName,sortColumnDesc,"asc");
	tableSortColumnUl.append(tableSortColumnHtmlStr);
	return true;
}

/**----------------------------------------------------------------各区域接收其他区域拖拽事件----------------------------------------------------------------------------**/
var currentDragItem=new Object();
/**
 * 维度区域接收其他区域拖拽事件
 * @param event
 * @param ui
 */
function dimColumnRecieve(event, ui) {
	receivedDivId="dim";
    var sourceDiv = ui.sender[0].parentElement.id;
    var targetDiv = ui.item[0].parentElement.parentElement.id;
    var sourceColumnId;
    if(sourceDiv=="verticalDimColumnDiv"||sourceDiv=="horizontalDimColumnDiv"){
    	saveCrossDimColumns();
    	var li = ui.item[0];
    	var $span0 = $(li).find("span:eq(0)");
		sourceColumnId = $span0.attr("id").substring("tableDimColumn_".length);
    }else if(sourceDiv=="tableKpiColumnDiv"){
    	var li = ui.item[0];
    	var $span0 = $(li).find("span:eq(0)");
		var $span1 = $(li).find("span:eq(1)");
		if($span0.attr("extcolumnid")!=undefined){
			li.remove();
			$.messager.alert("交叉表格","计算列不能做维度！","error");
			addDragedByIndex("tableKpiColumnDiv",currentDragItem);
			return;
		}
		$span0.attr("id",$span0.attr("id").replace("tableKpiColumn","tableDimColumn"));
		$span0.attr("name",$span0.attr("name").replace("tableKpiColumn","tableDimColumn"));
		$span1.find("a:eq(0)").attr("id",$span1.find("a:eq(0)").attr("id").replace("tableKpiColumn","tableDimColumn"));
		var columnId = $span0.attr("id").substring("tableDimColumn_".length);
		sourceColumnId = columnId;
		$span1.find("a:eq(0)").click(function(){
			removeCrossDimColumn(columnId);
		});
    	saveCrossDimColumns();
    	saveCrossKpiColumns();
    }else if(sourceDiv=="tableSortColumnDiv"){
    	var li = ui.item[0];
    	var $span0 = $(li).find("span:eq(0)");
		var $span1 = $(li).find("span:eq(1)");
		if($span0.attr("extcolumnid")!=undefined){
			li.remove();
			$.messager.alert("交叉表格","计算列不能做维度！","error");
			addDragedByIndex("tableSortColumnDiv",currentDragItem);
			return;
		}
		var columnId = $span0.attr("id").substring("tableSortColumn_".length);
		sourceColumnId = columnId;
		var columnName = $span0.attr("name").substring("tableSortColumn_".length);
		var columnDesc = $span0.text();

		var tableKpiColumnUl=$("#tableKpiColumnDiv>ul");
		var rowDimColumnUl=$("#verticalDimColumnDiv>ul");
		var colDimColumnUl=$("#horizontalDimColumnDiv>ul");
		if(tableKpiColumnUl.find("li span[id='tableKpiColumn_"+columnId+"']").size()>0){
			li.remove();
			$.messager.alert("交叉表格","选择无效，指标区域已存在该字段！","error");
		}else if(rowDimColumnUl.find("li span[id='tableDimColumn_"+columnId+"']").size()>0){
			li.remove();
			$.messager.alert("交叉表格","选择无效，行维度区域已存在该字段！","error");
		}else if(colDimColumnUl.find("li span[id='tableDimColumn_"+columnId+"']").size()>0){
			li.remove();
			$.messager.alert("交叉表格","选择无效，列维度区域已存在该字段！","error");
		}else{
			var tableDimColumnHtmlStr=generateDimColumnHtml(columnId,columnName,columnDesc);
			$(li).prop('outerHTML', tableDimColumnHtmlStr);
			saveCrossDimColumns();
		}
		addDragedByIndex("tableSortColumnDiv",currentDragItem);
    }
    var targetType = receivedDivId;
	if($("#tableSortColumnTypeATag_"+targetType+"_"+sourceColumnId)!=null&&$("#tableSortColumnTypeATag_"+targetType+"_"+sourceColumnId)!=undefined&&$("#tableSortColumnTypeATag_"+targetType+"_"+sourceColumnId).size()>0){
		$("#tableSortColumnTypeATag_"+targetType+"_"+sourceColumnId).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
	}
	saveCrossSortColumns();
}

/**
 * 指标区域接收其他区域拖拽事件
 * @param event
 * @param ui
 */
function kpiColumnRecieve(event, ui) {
	receivedDivId="kpi";
	var sourceDiv = ui.sender[0].parentElement.id;
	var sourceColumnId;
    if(sourceDiv=="verticalDimColumnDiv"||sourceDiv=="horizontalDimColumnDiv"){
    	var li = ui.item[0];
    	var $span0 = $(li).find("span:eq(0)");
    	var $span1 = $(li).find("span:eq(1)");
		$span0.attr("id",$span0.attr("id").replace("tableDimColumn","tableKpiColumn"));
		$span0.attr("name",$span0.attr("name").replace("tableDimColumn","tableKpiColumn"));
		$span1.find("a:eq(0)").attr("id",$span1.find("a:eq(0)").attr("id").replace("tableDimColumn","tableKpiColumn"));
		var columnId = $span0.attr("id").substring("tableKpiColumn_".length);
		sourceColumnId = columnId;
		$span1.find("a:eq(0)").click(function(){
			removeCrossKpiColumn(columnId);
		});
    	saveCrossDimColumns();
    	saveCrossKpiColumns();
    }else if(sourceDiv=="tableSortColumnDiv"){
    	var li = ui.item[0];
    	var $span0 = $(li).find("span:eq(0)");
		var columnId = $span0.attr("id").substring("tableSortColumn_".length);
		sourceColumnId = columnId;
		var columnName = $span0.attr("name").substring("tableSortColumn_".length);
		var columnDesc = $span0.attr("title");
		var tableKpiColumnUl=$("#tableKpiColumnDiv>ul");
		var rowDimColumnUl=$("#verticalDimColumnDiv>ul");
		var colDimColumnUl=$("#horizontalDimColumnDiv>ul");
		if(tableKpiColumnUl.find("li span[id='tableKpiColumn_"+columnId+"']").size()>0){
			li.remove();
			$.messager.alert("交叉表格","选择无效，指标区域已存在该字段！","error");
		}else if(rowDimColumnUl.find("li span[id='tableDimColumn_"+columnId+"']").size()>0){
			li.remove();
			$.messager.alert("交叉表格","选择无效，行维度区域已存在该字段！","error");
		}else if(colDimColumnUl.find("li span[id='tableDimColumn_"+columnId+"']").size()>0){
			li.remove();
			$.messager.alert("交叉表格","选择无效，列维度区域已存在该字段！","error");
		}else{
			
			var tableKpiColumnHtmlStr=generateKpiColumnHtml(columnId,columnName,columnDesc);
			$(li).prop('outerHTML', tableKpiColumnHtmlStr);
			saveCrossKpiColumns();
		}
		addDragedByIndex("tableSortColumnDiv",currentDragItem);
    }
    var targetType = receivedDivId;
	if($("#tableSortColumnTypeATag_"+targetType+"_"+sourceColumnId)!=null&&$("#tableSortColumnTypeATag_"+targetType+"_"+sourceColumnId)!=undefined&&$("#tableSortColumnTypeATag_"+targetType+"_"+sourceColumnId).size()>0){
		$("#tableSortColumnTypeATag_"+targetType+"_"+sourceColumnId).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
	}
	saveCrossSortColumns();
}


/**
 * 排序区域接收其他区域拖拽事件
 * @param event
 * @param ui
 */
function sortColumnRecieve(event, ui) {
	receivedDivId="sort";
	var sourceDiv = ui.sender[0].parentElement.id;
	if(sourceDiv=="verticalDimColumnDiv"||sourceDiv=="horizontalDimColumnDiv"){
    	var li = ui.item[0];
    	var $span0 = $(li).find("span:eq(0)");
		var columnId = $span0.attr("id").substring("tableDimColumn_".length);
		var columnName = $span0.attr("name").substring("tableDimColumn_".length);
		var columnDesc = $span0.text();
		var tableSortColumnUl=$("#tableSortColumnDiv>ul");
		if(tableSortColumnUl.find("li span[id='tableSortColumn_"+columnId+"']").size()>0){
			li.remove();
			$.messager.alert("交叉表格","选择无效，该默认排序列已存在！","error");
		}else{
			var tableSortColumnHtmlStr=generateSortColumnHtml(columnId,columnName,columnDesc,"asc");
			$(li).prop('outerHTML', tableSortColumnHtmlStr);
			$("#tableSortColumnTypeATag_dim_"+columnId).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
			saveCrossSortColumns();
		}
    }else if(sourceDiv=="tableKpiColumnDiv"){
    	var li = ui.item[0];
    	var $span0 = $(li).find("span:eq(0)");
		var columnId = $span0.attr("id").substring("tableKpiColumn_".length);
		var columnName = $span0.attr("name").substring("tableKpiColumn_".length);
		var columnDesc = $span0.text();
		var tableSortColumnUl=$("#tableSortColumnDiv>ul");
		if(tableSortColumnUl.find("li span[id='tableSortColumn_"+columnId+"']").size()>0){
			li.remove();
			$.messager.alert("交叉表格","选择无效，该默认排序列已存在！","error");
		}else{
			var tableSortColumnHtmlStr=generateSortColumnHtml(columnId,columnName,columnDesc,'desc');
			$(li).prop('outerHTML', tableSortColumnHtmlStr);
			$("#tableSortColumnTypeATag_kpi_"+columnId).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
			saveCrossSortColumns();
		}
    }
	addDragedByIndex(sourceDiv,currentDragItem);
}

/**
 * 修改排序区域排序字段的排序方式
 * @param modeStr:排序方式（asc/desc）
 * @param columnId:指标编码
 * @param obj
 */
function setCrossSortMode(modeStr,columnId){
	$("#tableSortColumnATag_"+modeStr+"_"+columnId).show().siblings("a[id^='tableSortColumnATag_']").hide();
	saveCrossSortColumns();
}

/**
 * 修改排序区域排序字段的类型
 * @param kpiType:类型(dim/kpi)
 * @param columnId:指标编码
 * @param obj
 */
function setCrossSortKpiType(kpiType,columnId,obj){
	if($("#tableSortColumn_"+columnId).attr("extcolumnid")!=undefined){
		$.messager.alert("表格","计算列必须为指标类型,不能修改为维度类型！","error");
		return;
	}
	$("#tableSortColumnTypeATag_"+kpiType+"_"+columnId).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
	saveCrossSortColumns();
}

/**
 * 根据divId和li获取当前拖动的li在该区域的下标
 * @param divId
 * @param li
 * @returns
 */
function getCrossColumnIndex(divId,li){
	var resultIndex = 0;
	var liList = $("#"+divId+">ul>li");
	var $span0 = $(li).find("span:eq(0)");
	var subIndex = 0;
	if(divId=="verticalDimColumnDiv"||divId=="horizontalDimColumnDiv"){
		subIndex = "tableDimColumn_".length;
	}else if(divId=="tableKpiColumnDiv"){
		subIndex = "tableKpiColumn_".length;
	}else if(divId=="tableSortColumnDiv"){
		subIndex = "tableSortColumn_".length;
	}
	var dragColumnName = $span0.attr("name").substring(subIndex);
	$.each(liList,function(index,item){
		var tempName = $(item).find("span:eq(0)").attr("name").substring(subIndex);
		if(tempName==dragColumnName){
			resultIndex = index;
			return false;
		}
	});
	return resultIndex;
}

/**
 * 添加当前拖动项到源div，用于复制功能
 * @param divId
 * @param currentDragItem
 */
function addDragedByIndex(divId,currentDragItem){
	var liList = $("#"+divId+">ul>li");
	var dragLi = currentDragItem.item;
	var dragIndex = currentDragItem.index;
	if(liList.length==dragIndex){
		$("#"+divId+">ul").append(dragLi);
	}else{
		$(liList).eq(dragIndex).before(dragLi);
	}
}