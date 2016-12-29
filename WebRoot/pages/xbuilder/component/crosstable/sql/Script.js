/**
 * 设置数据源
 * @param obj:combobox数据对象
 */
function setCrossDataSource(obj){
	var info={};
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if(typeof(obj.id)!="undefined"&&obj.id!="请选择"){
		if(obj.attributes.datatype=="2"){//数据集为map类型
			$.messager.alert("系统提示","交叉表格不能使用map类型数据集","error");
			$("#tableColumnDiv>ul").html("");
			return;
		}
		var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+reportId+"&report_sql_id="+obj.id;
		var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
		//获得计算列
		var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+reportId+"&report_sql_id="+obj.id;
		var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
		for(var i=0;i<extData.length;i++){
			data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
		}
		var tableColumnUl=$("#tableColumnDiv>ul");
		var tableColumnHtmlStr='';
		for(var i=0;i<data.length;i++){
			if(data[i].isextcolumn==true){
				tableColumnHtmlStr+=crossTableGenerationExtColumnDivLiHtml(data[i]["id"],data[i]["text"]);
			}else{
				tableColumnHtmlStr+='<li>';
				tableColumnHtmlStr+='<input type="checkbox" id="tableColumnCheckbox_'+data[i]["id"]+'" name="tableColumn" data-columnId="'+data[i]["id"]+'" data-columnName="'+data[i]["text"]+'" data-columnDesc="'+data[i]["text"]+'" /><span id="tableColumn_'+data[i]["id"]+'" name="tableColumn_'+data[i]["text"]+'" title="'+data[i]["text"]+'">'+data[i]["text"]+'</span>';
				tableColumnHtmlStr+='</li>';
			}
			
		}
		tableColumnUl.html(tableColumnHtmlStr);
		$.parser.parse($("#tableColumnDiv"));
		$("input[name='tableColumn']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	var columnId=$(this).attr("data-columnId");
		  	var columnName = $(this).attr("data-columnName");
		  	var columnDesc = $(this).attr("data-columnDesc");
		  	var isChecked = $(this).attr("checked")!='checked';
		  	clickCrossTableColumnsCheckbox(columnId,columnName,columnDesc,isChecked);
		});

		initCrossColumnDiv();//初始化被选择列区域
		initCrossDimColumnDiv('horizontalDimColumnDiv','sql');//初始化横向维度区域
		initCrossDimColumnDiv('verticalDimColumnDiv','sql');//初始化纵向维度区域
		initCrossKpiColumnDiv('sql');//初始化指标区域
		initCrossSortColumnDiv('sql');//初始化排序区域
		
		var info={reportId:reportId,containerId:containerId,componentId:componentId,attrKey:"datasourceid",attrValue:(obj.id).substring(1)};
		crossTableService.setComponentAttr(info,function(data,exception){//保存数据源Id到xml
			if(exception!=undefined){
				$.messager.alert("交叉表格","设置数据源时出错！","error");
			}
		});
	}
}

/**
 * 备选区域指标复选框点击事件，选中时添加到指标区域，取消选中时删除区域中相应的值
 * @param columnId
 * @param columnName
 * @param columnDesc
 * @param isChecked
 */
function clickCrossTableColumnsCheckbox(columnId,columnName,columnDesc,isChecked){
	//选中时默认往指标区域添加
	if(isChecked){
		if(insertCrossKpiColumnHtml(columnId,columnName,columnDesc)){
			saveCrossKpiColumns();
		}
	}else{
		    var verDimLiList = $("#verticalDimColumnDiv>ul>li");
		    $.each(verDimLiList,function(index,li){
		    	var $span=$(li).find("span:eq(0)");
				var dimField = $span.attr("name").substring('tableDimColumn_'.length);
				if(dimField == columnName){
					removeCrossDimColumn(columnId);
				}
		    });
		    var horDimLiList = $("#horizontalDimColumnDiv>ul>li");
		    $.each(horDimLiList,function(index,li){
		    	var $span=$(li).find("span:eq(0)");
		    	var dimField = $span.attr("name").substring('tableDimColumn_'.length);
		    	if(dimField == columnName){
					removeCrossDimColumn(columnId);
				}
		    });
		    
		    var kpiLiList = $("#tableKpiColumnDiv>ul>li");
		    $.each(kpiLiList,function(index,li){
		    	var $span=$(li).find("span:eq(0)");
		    	var datacolcode = $span.attr("name").substring('tableKpiColumn_'.length);
		    	if(datacolcode == columnName){
					removeCrossKpiColumn(columnId);
				}
		    });
		    
		    var kpiLiList = $("#tableSortColumnDiv>ul>li");
		    $.each(kpiLiList,function(index,li){
		    	var $span=$(li).find("span:eq(0)");
		    	var col = $span.attr("name").substring('tableSortColumn_'.length);
		    	if(col == columnName){
					removeCrossKpiColumn(columnId);
				}
		    });
	}
}

/**----------------------------------------------------------------其他方法----------------------------------------------------------------------------**/

/**
 * 交叉表格整体属性还原方法
 * @param containerId
 * @param componentId
 */
function crossTableComponentEdit(containerId,componentId){
	var reportId=StoreData.xid;
	StoreData.curContainerId=containerId;
	StoreData.curComponentId=componentId;
	var info = {reportId:reportId,containerId:containerId,componentId:componentId}
	crossTableService.getComponentJsonData(info,function(data,exception){//保存数据源Id到xml
		if(exception!=undefined){
			$.messager.alert("交叉表格","获取交叉表格属性时出错！"+exception,"error");
		}else{
			crossTableComponentEditBack(data);
		}
	});
}


/**
 * 还原方法的回调函数
 * @param data
 */
function crossTableComponentEditBack(data){
		var reportId=StoreData.xid;
		var containerId=StoreData.curContainerId;
		var componentId=StoreData.curComponentId;
		var jsonObj=$.parseJSON(data);
		if(jsonObj!=null&&jsonObj!=undefined){
			/*设置标题*/
			var title = jsonObj.title;
			if(typeof(title)=="undefined"||title==null||title=='null'){
				$("#tableTitle").val(''); 
			}else{ 
				$("#tableTitle").val(title);
			}
			/*设置显示标题*/
			var showTitle = jsonObj.showTitle;
			if(showTitle=='0'){
				$('#tableShowTitle').iCheck("uncheck");
			}else{ 
				$('#tableShowTitle').iCheck("check");
			}
			
			/*设置分页*/
			var tablePagi=jsonObj.tablepagi;
			var tablePagiNum=jsonObj.tablepaginum;
			if(typeof(tablePagi)!="undefined"&&tablePagi=='1'){
				$("#tablePagi").iCheck('check');
				$("#tablePagiNum").numberbox("enable");
				if(typeof(tablePagiNum)=="undefined"||tablePagiNum==null||tablePagiNum=='null'){
					$("#tablePagiNum").numberbox("setValue",10);
				}else{
					$("#tablePagiNum").numberbox("setValue",tablePagiNum);
				}
				
				
			}else{ 
				$("#tablePagi").iCheck('uncheck');
				$("#tablePagiNum").numberbox("disable");
				$("#tablePagiNum").numberbox("setValue",10);
			}
			
			/*设置导出*/
			var tableExport=jsonObj.tableexport;
			if(typeof(tableExport)!="undefined"&&tableExport=='1'){
				$("#tableExport").iCheck('check');
			}else{ 
				$("#tableExport").iCheck('uncheck');
			}
			
			/*设置数据集和被选择指标区域数据*/
			var dateJson=$.ajax({url: appBase+"/getAllDataSourceJsonX.e?report_id="+reportId,type:"POST",cache: false,async: false}).responseText;
			var datasourceData=[];
			if(dateJson!=null&&dateJson!=""&&dateJson!="null"){
				datasourceData = $.evalJSON(dateJson);
				$("#tableDataSource").combobox('loadData', datasourceData); 
			}
		
			var datasourceId=jsonObj.datasourceid;
			if(typeof(datasourceId)!="undefined"&&datasourceId!=null&&datasourceId!='null'){
				var useDatasourceId='B'+datasourceId;
				$("#tableDataSource").combobox("setValue",useDatasourceId);
				$.each(datasourceData,function(index,item){
					if(item.id == useDatasourceId){
						setCrossDataSource(item);
						return false;
					}
				});
			}
			
			
			var allSelectedColumns = new Array();
			//还原行维度和列维度区域
			if(jsonObj.crosscolstore!=null&&jsonObj.crosscolstore!=undefined&&jsonObj.crosscolstore.crosscolList!=null&&jsonObj.crosscolstore.crosscolList!=undefined){
				$.each(jsonObj.crosscolstore.crosscolList,function(index,col){
					var colType = col.type;
					var divId = colType=="1"?"verticalDimColumnDiv":"horizontalDimColumnDiv";
					insertCrossDimColumnHtml(divId,col.dimid,col.dimfield,col.dimdesc);
					allSelectedColumns.push(col.dimfield);
				});
			}
			
			//还原指标区域，同时初始化指标单元格的事件json
			if(jsonObj.datastore!=null&&jsonObj.datastore!=undefined&&jsonObj.datastore.datacolList!=null&&jsonObj.datastore.datacolList!=undefined){
				$.each(jsonObj.datastore.datacolList,function(index,col){
					insertCrossKpiColumnHtml(col.datacolid,col.datacolcode,col.tablecoldesc);
					allSelectedColumns.push(col.datacolcode);
				});
			}
			
			//还原排序区域
			if(jsonObj.sortcolStore!=null&&jsonObj.sortcolStore!=undefined&&jsonObj.sortcolStore.sortcolList!=null&&jsonObj.sortcolStore.sortcolList!=undefined){
				$.each(jsonObj.sortcolStore.sortcolList,function(index,col){
					insertCrossSortColumnHtml(col.id,col.col,col.desc);
					var kpiType='dim';
					if(col.kpitype!=undefined&&col.kpitype!=""){
						kpiType = col.kpitype;
					}
					$("#tableSortColumnATag_"+col.type+"_"+col.id).show().siblings("a[id^='tableSortColumnATag_']").hide();
					$("#tableSortColumnTypeATag_"+kpiType+"_"+col.id).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
					allSelectedColumns.push(col.col);
				});
			}
			
			//还原行维度显示方式图标
			var showType = jsonObj.rowtype;//1:列表，2：树形
			if(showType=="1"){
				$("#gridDisplay").removeClass("grid_normal").addClass("grid_active");
				$("#treeDisplay").removeClass("tree_active").addClass("tree_normal");
				//$("#tableExport").iCheck('enable');
			}else{
				$("#treeDisplay").removeClass("tree_normal").addClass("tree_active");
				$("#gridDisplay").removeClass("grid_active").addClass("grid_normal");
				//$("#tableExport").iCheck('disable');
			}
			
			//还原合计方式
			var sumtype = jsonObj.sumtype;
			if(sumtype=="0"){
				$('#tableRowSum').iCheck("uncheck");
				$('#tableColumnSum').iCheck("uncheck");
			}else if(sumtype=="1"){
				$('#tableRowSum').iCheck("check");
				$('#tableColumnSum').iCheck("uncheck");
			}else if(sumtype=="2"){
				$('#tableRowSum').iCheck("uncheck");
				$('#tableColumnSum').iCheck("check");
			}else if(sumtype=="3"){
				$('#tableRowSum').iCheck("check");
				$('#tableColumnSum').iCheck("check");
			}
			//还原行合计位置
			var rowsumposition = jsonObj.rowsumposition;
			$("input[name='rowSumPosition'][value='"+rowsumposition+"']").iCheck('check');
			if($("#tableColumnSum").attr("checked")=='checked'){
				$("input[name='rowSumPosition']").iCheck('enable');
			}else{
				$("input[name='rowSumPosition']").iCheck('disable');
			}
			
			//还原被选择列区域复选框选中状态
			 var liList = $("#tableColumnDiv>ul>li");
			 var tempField;
			 var tempId;
			 $.each(liList,function(index,li){
				 tempField=$(li).find("span").eq(0).text();
				 tempId = $(li).find("span").eq(0).attr("id").substring("tableColumn_".length);
				 $.each(allSelectedColumns,function(columnIndex,columnName){
					 if(columnName==tempField){
						 $("#tableColumnCheckbox_"+tempId).iCheck('check');
						 return false;
					 }
				 })
			 });
		}
		
}

/**
 * 打开数据单元格的链接的设置参数的面板
 * @returns {Boolean}
 */
function crossTableDataOpenEventLinkParamDialog(){
		var reportId=StoreData.xid;
		var containerId=StoreData.curContainerId;
		var componentId=StoreData.curComponentId;
		
		var tableDataEventLink=$("#tableDataEventLink").val();
		if(tableDataEventLink==''){
			$.messager.alert("交叉表格","请先选择一个报表后再设置参数！"+exception,"error");
			return false;
		}
		var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+tableDataEventLink,type:"POST",cache: false,async: false}).responseText;
		dimsionsJson=$.parseJSON(dimsionsJson);
		
		var datasourceId=$.ajax({url: appBase+"/getDataSourceIdJsonX.e?reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId,type:"POST",cache: false,async: false}).responseText;
		if(datasourceId==''||datasourceId==null||datasourceId=='null'){
			$.messager.alert("交叉表格","请先设置表格的数据源！"+exception,"error");
			return false;
		}
		var columnsJson=$.ajax({url: appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+reportId+"&report_sql_id=B"+datasourceId,type:"POST",cache: false,async: false}).responseText;
		columnsJson=$.parseJSON(columnsJson);
		
		var info={};
		info['text']='请选择';
		columnsJson.unshift(info);
		
		var isHasSameEventJsonFlag=true;
		var tableEventSelectJsonStr='';
		var $selectable= $("#selectable_"+componentId);
		var $selectTds=$selectable.find(".ui-selected");
		for(var a=0;a<$selectTds.length;a++){
			if(a==0){
				tableEventSelectJsonStr=$($selectTds[a]).attr("data-tableEventSelectJson");
			}
			/*是否都是有相同的事件json数据 */
			if(tableEventSelectJsonStr!=$($selectTds[a]).attr("data-tableEventSelectJson")){
				isHasSameEventJsonFlag=false;
			}
		}
		var parameterList=[];
		if(isHasSameEventJsonFlag){
			if(tableEventSelectJsonStr==undefined||tableEventSelectJsonStr==''||tableEventSelectJsonStr==null||tableEventSelectJsonStr=='null'){
				tableEventSelectJsonStr='{}';
			}
			var tableEventSelectJson=$.parseJSON(tableEventSelectJsonStr);
			
			if(tableEventSelectJson!=null){
				var eventList=tableEventSelectJson["eventList"];
				if(eventList!=undefined&&eventList!=null&&eventList!=''&&eventList!='null'&&eventList.length>0){
					var event=eventList[0];
					if(event!=undefined&&event!=null&&event!=''&&event!='null'){
						parameterList=event["parameterList"];
						if(parameterList==undefined||parameterList==null||parameterList==''||parameterList=='null'){
							parameterList=[];
						}
					}
				}
			}
			$("#crossTableDataEventLinkParamTable").html("");
			
			
		}
		for(var a=0;a<dimsionsJson.length;a++){
			var dimsionId=dimsionsJson[a]["id"];
			var name=dimsionsJson[a]["varname"];
			var nameDesc=dimsionsJson[a]["desc"];
			var value='请选择';
			var valueData=columnsJson;
			var valueField='text';
			var TextField='text';
			if(parameterList.length==0){
				for(var x=0;x<columnsJson.length;x++){
					if(columnsJson[x]['text'].toLowerCase()==name.toLowerCase()){
						value=columnsJson[x]['text'];
					}
					if(columnsJson[x]['text'].replace(/_/g,"").toLowerCase()==name.toLowerCase()){
						value=columnsJson[x]['text'];
						break;
					}
				}
			}else{
				for(var y=0;y<parameterList.length;y++){
					if(parameterList[y]['name']==name){
						value=parameterList[y]['value'];
					}
				}
			}
			crossTableEventLinkParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField);
		}
		$("#crossTableDataEventLinkParamDialog").dialog("open");
		hideToolsPanel();
}

/** 描述：打开数据单元格的联动的设置参数的面板
参数：

*/
function crossTableOpenEventActiveDialog(eventComponetId,eventEventId){
		tableCurrentEvnetCompenentId=eventComponetId;
		crossTableCurrentEvnetEventId=eventEventId;
		var reportId=StoreData.xid;
		var containerId=StoreData.curContainerId;
		var componentId=StoreData.curComponentId;
		
		var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+reportId+'&isTempFile=1',type:"POST",cache: false,async: false}).responseText;
		dimsionsJson=$.parseJSON(dimsionsJson);
		
		var datasourceId=$.ajax({url: appBase+"/getDataSourceIdJsonX.e?reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId,type:"POST",cache: false,async: false}).responseText;
		if(datasourceId==''||datasourceId==null||datasourceId=='null'){
			$.messager.alert("交叉表格","请先设置表格的数据源！"+exception,"error");
			return false;
		}
		var columnsJson=$.ajax({url: appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+reportId+"&report_sql_id=B"+datasourceId,type:"POST",cache: false,async: false}).responseText;
		columnsJson=$.parseJSON(columnsJson);
		
		
		var info={};
		info['text']='请选择';
		columnsJson.unshift(info);
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
		var parameterList=[];
		if(isHasSameEventJsonFlag){
			if(tableEventSelectJsonStr==undefined||tableEventSelectJsonStr==''||tableEventSelectJsonStr==null||tableEventSelectJsonStr=='null'){
				tableEventSelectJsonStr='{}';
			}
			var tableEventSelectJson=$.parseJSON(tableEventSelectJsonStr);
			
			if(tableEventSelectJson!=null){
				var eventList=tableEventSelectJson["eventList"];
				if(eventList!=undefined&&eventList!=null&&eventList!=''&&eventList!='null'&&eventList.length>0){
					var event=null;
					for(var x=0;x<eventList.length;x++){
					    if(eventList[x]["id"]==crossTableCurrentEvnetEventId&&eventList[x]["source"]==tableCurrentEvnetCompenentId){
							event=eventList[x];
							break;
						}
					}
					if(event!=null){
						parameterList=event["parameterList"];
						if(parameterList==undefined||parameterList==null||parameterList==''||parameterList=='null'){
							parameterList=[];
						}
					}
					
				}
			}
		}
		
		$("#crossTableDataEventActiveParamTable").html("");
		
		for(var a=0;a<dimsionsJson.length;a++){
			var dimsionId=dimsionsJson[a]["id"];
			var name=dimsionsJson[a]["varname"];
			var nameDesc=dimsionsJson[a]["desc"];
			var value='请选择';
			var valueData=columnsJson;
			var valueField='text';
			var TextField='text';
			if(parameterList.length==0){
				for(var x=0;x<columnsJson.length;x++){
					if(columnsJson[x]['text'].toLowerCase()==name.toLowerCase()){
						value=columnsJson[x]['text'];
					}
					if(columnsJson[x]['text'].replace(/_/g,"").toLowerCase()==name.toLowerCase()){
						value=columnsJson[x]['text'];
						break;
					}
				}
			}else{
				for(var y=0;y<parameterList.length;y++){
					if(parameterList[y]['name']==name){
						value=parameterList[y]['value'];
					}
				}
			}
			crossTableOpenEventActiveParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField);
		}
		$("#crossTableDataEventActiveParamDialog").dialog("open");
		hideToolsPanel();
}

/**---------------------------------------------------------计算列开始-------------------------------------------------------*/


function crossTableGenerationExtColumnDivLiHtml(columnId,columnName){
	var tableColumnHtmlStr='';
	tableColumnHtmlStr+='<li>';
	tableColumnHtmlStr+='<input type="checkbox" id="tableColumnCheckbox_C'+columnName+'" name="tableColumn" data-columnId="C'+columnName
						+'" data-columnName="'+columnName+'" data-columnDesc="'+columnName+'" /><span extcolumnid='+columnId+' id="tableColumn_C'+columnName+'" name="tableColumn_'+columnName
						+'" title="'+columnName+'">'+columnName+'</span><a href="javascript:void(0)" onclick="crossTableEditExtcolumn(\''+columnId+'\')" class="edit_col_btn"></a><a href="javascript:void(0)" onclick="crossTableRemoveExtcolumn(\''+columnId+'\')"  class="remove_col_btn"></a>';
	tableColumnHtmlStr+='</li>';
	return tableColumnHtmlStr;
}

/**
 * 更新数据集UI
 */
function crossTableUpdataDatasetUI(action){
	var columnId = crossTableCaculateColumn.currentEditColumnObj.id;
	var columnName = crossTableCaculateColumn.currentEditColumnObj.name;
	//添加计算列成功后更新候选列区域
	if(action=="add"){
		var tableColumnUl=$("#tableColumnDiv>ul");
		var tableColumnHtmlStr=crossTableGenerationExtColumnDivLiHtml(columnId,columnName);
		tableColumnUl.append(tableColumnHtmlStr);
		initCrossColumnDiv();
		$("input[name='tableColumn']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
			var columnId=$(this).attr("data-columnId");
		  	var columnName = $(this).attr("data-columnName");
		  	var columnDesc = $(this).attr("data-columnDesc");
		  	var isChecked = $(this).attr("checked")!='checked';
		  	clickCrossTableColumnsCheckbox(columnId,columnName,columnDesc,isChecked);
		});
		$("#tableColumn_C"+columnName).attr("extcolumnid",columnId);
		$.parser.parse($("#tableColumnDiv"));
	}else if(action=="edit"){//编辑计算列成功后更新候选列区域
		$("#tableColumnDiv span[extcolumnid="+columnId+"]").parent().prop('outerHTML', crossTableGenerationExtColumnDivLiHtml(columnId,columnName));
		initCrossColumnDiv();
		$("input[name='tableColumn']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
			var columnId=$(this).attr("data-columnId");
		  	var columnName = $(this).attr("data-columnName");
		  	var columnDesc = $(this).attr("data-columnDesc");
		  	var isChecked = $(this).attr("checked")!='checked';
		  	clickCrossTableColumnsCheckbox(columnId,columnName,columnDesc,isChecked);
		});
		$.parser.parse($("#tableColumnDiv"));
		var oldName = crossTableCaculateColumn.getColumnOldName();
		if($("span[name='tableKpiColumn_"+oldName+"']").size()>0){
			$("#tableColumnCheckbox_C"+columnName).iCheck("check");
			if(oldName!=columnName){
				var columnHtml = generateKpiColumnHtml("C"+columnName,columnName,columnName);
				$("#tableKpiColumnDiv span[name='tableKpiColumn_"+oldName+"']").parent().parent().prop('outerHTML',columnHtml);
				saveCrossKpiColumns();
			}
		}
		if($("span[name='tableSortColumn_"+oldName+"']").size()>0){
			$("#tableColumnCheckbox_C"+columnName).iCheck("check");
			if(oldName!=columnName){
				var columnHtml = generateSortColumnHtml("C"+columnName,columnName,columnName);
				$("#tableSortColumnDiv span[name='tableSortColumn_"+oldName+"']").parent().parent().prop('outerHTML',columnHtml);
				saveCrossSortColumns();
			}
		}
	}else if(action=="remove"){//删除计算列成功后更新候选列区域
		var info = {reportId:StoreData.xid,extcolumnid:columnId};
		crossTableService.removeExtcolumn(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","删除计算列出错！<br/>"+exception,"error");
			}else{
				var columnName = $("#tableColumnDiv span[extcolumnid="+columnId+"]").text();
				$("#tableColumnDiv span[extcolumnid="+columnId+"]").parent().remove();
				if($("#tableKpiColumn_C"+columnName).size()>0){
					removeCrossKpiColumn("C"+columnName);
				}
				if($("#tableSortColumn_C"+columnName).size()>0){
					removeCrossSortColumn("C"+columnName);
				}
			}
		});
		
	}
}

/**
 * 修改计算列
 * @param extcolumnid
 */
function crossTableEditExtcolumn(extcolumnid){
	crossTableCaculateColumn.init();
	crossTableCaculateColumn.open();
	crossTableCaculateColumn.currentAction="edit";
	crossTableCaculateColumn.switchEnable(true);
	crossTableCaculateColumn.closeWhenEditFinish=true;
	crossTableCaculateColumn.restoreCaculateColumn(extcolumnid);//回显计算列
}

/**
 * 删除计算列
 * @param extcolumnid
 */
function crossTableRemoveExtcolumn(extcolumnid){
	crossTableCaculateColumn.removeCaculateCol(extcolumnid);
}
/**-------------------------------------------------------计算列结束----------------------------------------------------------------------------------*/