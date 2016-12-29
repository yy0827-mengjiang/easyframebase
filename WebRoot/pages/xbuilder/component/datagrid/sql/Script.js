/** 描述：设置数据源
	参数：
		obj combobox数据对象
*/
function tableSetDataSource(obj){
	var info={};
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if(typeof(obj.id)!="undefined"&&obj.id!="请选择"){
		if(obj.attributes.datatype=="2"){//数据集为map类型
			$.messager.alert("系统提示","基础表格不能使用map类型数据集","error");
			$("#tableColumnDiv>ul").html("");
			return;
		}
		var xmlDatasourceId=$.ajax({url: appBase+"/getDataSourceIdJsonX.e?reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId,type:"POST",cache: false,async: false}).responseText;
//		if(obj.id==('B'+xmlDatasourceId)){
//			return false;
//		}
		if($("span[id^='tableKpiColumn_']").size()==0&&$("span[id^='tableDimColumn_']").size()==0&&$("span[id^='tableSortColumn_']").size()==0){
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
					tableColumnHtmlStr+=tableGenerationExtColumnDivLiHtml(data[i]["id"],data[i]["text"]);
				}else{
					tableColumnHtmlStr+=tableGenerationColumnDivLiHtml(data[i]["id"],data[i]["text"],data[i]["text"]);
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
			  	tableCheckTableColumn($(this).attr("data-columnId"),$(this).attr("data-columnName"),$(this).attr("data-columnDesc"));
			  	window.setTimeout(function(){ tableFlushColumnDiv(columnId);},1000); 
			});
			tableEnableOrDisabledSelectAllCol();
			tableInitColumnDiv();
			tableInitDimColumnDiv();
			tableInitKpiColumnDiv();
			tableInitSortColumnDiv();
			var sqlId=(obj.id).substring(1);
			TableEvent.setDatasourceId(reportId,containerId,componentId,sqlId);
		
		}else{
			$.messager.alert("基础表格","变更数据源失败，维度区域、指标区域或默认排序列区域已设置相关内容，请清除后再进行操作！","error");
			$("#tableDataSource").combobox("setValue",'B'+xmlDatasourceId);
			return false;
		}
		
		
	}
}

/** 描述：生成向被选择指标区域中添加指标的html代码（为了保证插入html的js的惟一性而独立出来的）
	参数：
		columnId 指标编码
		columnName 指标字段名称
		columnDesc 指标描述
*/
function tableGenerationColumnDivLiHtml(columnId,columnName,columnDesc){
	var tableColumnHtmlStr='';
	tableColumnHtmlStr+='<li>';
	tableColumnHtmlStr+='<input type="checkbox" id="tableColumnCheckbox_'+columnId+'" name="tableColumn" data-columnId="'+columnId+'" data-columnName="'+columnDesc+'" data-columnDesc="'+columnDesc+'" /><span id="tableColumn_'+columnId+'" name="tableColumn_'+columnDesc+'" title="'+columnDesc+'">'+columnDesc+'</span>';
	tableColumnHtmlStr+='</li>';
	return tableColumnHtmlStr;

}

function tableGenerationExtColumnDivLiHtml(columnId,columnName){
	var tableColumnHtmlStr='';
	tableColumnHtmlStr+='<li>';
	tableColumnHtmlStr+='<input type="checkbox" id="tableColumnCheckbox_C'+columnName+'" name="tableColumn" data-columnId="C'+columnName
						+'" data-columnName="'+columnName+'" data-columnDesc="'+columnName+'" /><span extcolumnid='+columnId+' id="tableColumn_C'+columnName+'" name="tableColumn_'+columnName
						+'" title="'+columnName+'">'+columnName+'</span><a href="javascript:void(0)" onclick="tableEditExtcolumn(\''+columnId+'\')" class="edit_col_btn"></a><a href="javascript:void(0)" onclick="tableRemoveExtcolumn(\''+columnId+'\')"  class="remove_col_btn"></a>';
	tableColumnHtmlStr+='</li>';
	return tableColumnHtmlStr;
}

/** 描述：还原方法的回调函数
	参数：
		data json数据
*/
function tableComponentEditBack(data){
	var thShowArray = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
	for(var th_i=0;th_i<26;th_i++){
		for(var th_j=0;th_j<26;th_j++){
			thShowArray[(th_i+1)*26+th_j]=thShowArray[th_i]+thShowArray[th_j];
		}
	}
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
				$("#tablePagiNum").numberbox("setValue",LayOutUtil.data.xDefautlTablePagiNum);
			}else{
				$("#tablePagiNum").numberbox("setValue",tablePagiNum);
			}
			
			
		}else{ 
			$("#tablePagi").iCheck('uncheck');
			$("#tablePagiNum").numberbox("disable");
			$("#tablePagiNum").numberbox("setValue",LayOutUtil.data.xDefautlTablePagiNum);
		}
		
		/*设置导出*/
		var tableExport=jsonObj.tableexport;
		if(typeof(tableExport)!="undefined"&&tableExport=='1'){
			$("#tableExport").iCheck('check');
		}else{ 
			$("#tableExport").iCheck('uncheck');
		}
		
		/*设置锁定列*/
		var tableCollock=jsonObj.tablecollock;
		var tableCollockNum=jsonObj.tablecollocknum;
		if(typeof(tableCollock)!="undefined"&&tableCollock=='1'){
			$("#tableColLock").iCheck('check');
			$("#tableColLockNum").numberbox("enable");
			$("#tableColLockNum").numberbox("setValue",tableCollockNum);
		}else{ 
			$("#tableColLock").iCheck('uncheck');
			$("#tableColLockNum").numberbox("disable");
			$("#tableColLockNum").numberbox("setValue","1");
		}
		
		/*设置显示行小计*/
		var showRowTotal = jsonObj.tableshowrowtotal;
		if(showRowTotal=='0'){
			$('#tableShowRowTotal').iCheck("uncheck");
		}else{ 
			$('#tableShowRowTotal').iCheck("check");
		}
		/*设置显示合计*/
		var showTotal = jsonObj.tableshowtotal;
		if(showTotal=='0'){
			$('#tableShowTotal').iCheck("uncheck");
			$("#tableShowTotalPosition").combobox("setValue","top");
			$("#tableShowTotalPosition").combobox("disable");
			$("#tableShowTotalName").val("合计");
			$("#tableShowTotalName").attr("disabled","disabled");
		}else{ 
			$('#tableShowTotal').iCheck("check");
			$("#tableShowTotalPosition").combobox("enable");
			$("#tableShowTotalName").removeAttr("disabled");
		}
		
		/*合计显示位置*/
		var showTotalPostion = jsonObj.tableshowtotalposition;
		$("#tableShowTotalPosition").combobox("setValue",showTotalPostion);
		
		/*合计显示名称*/
		var showTotalName = jsonObj.tableshowtotalname;
		$("#tableShowTotalName").val(showTotalName);
		
		/*设置指标聚合*/
		var setSum = jsonObj.tablesetsum;
		if(setSum=='0'){
			$('#tableSetNum').iCheck("uncheck");
			$("#tableShowRowTotal").iCheck('uncheck');
			$("#tableShowRowTotal").iCheck('disable');
			$("#tableShowTotal").iCheck('uncheck');
			$("#tableShowTotal").iCheck('disable');
			$("#tableShowTotalPosition").combobox("setValue","top");
			$("#tableShowTotalPosition").combobox("disable");
			if(LayOutUtil.data.sumControlExpFlag=='1'){
				$('#tableExport').iCheck("disable");
				$('#tableExport').iCheck("uncheck");
			}
		}else{ 
			$('#tableSetNum').iCheck("check");
			$("#tableShowRowTotal").iCheck("enable");
			$("#tableShowTotal").iCheck("enable");
			if(LayOutUtil.data.sumControlExpFlag=='1'){
				$('#tableExport').iCheck("enable");
			}
			
		}
				
		
		/*设置数据集和被选择指标区域数据*/
		var dateJson=$.ajax({url: appBase+"/getAllDataSourceJsonX.e?report_id="+reportId,type:"POST",cache: false,async: false}).responseText;
		var datasourceData=[];
		if(dateJson!=null&&dateJson!=""&&dateJson!="null"){
			datasourceData = $.evalJSON(dateJson);
			$("#tableDataSource").combobox('loadData', datasourceData); 
		}
		var columnDatas=null;
		var datasourceId=jsonObj.datasourceid;
		if(typeof(datasourceId)!="undefined"&&datasourceId!=null&&datasourceId!='null'){
			var useDatasourceId='B'+datasourceId;
			$("#tableDataSource").combobox("setValue",useDatasourceId);
			var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+reportId+"&report_sql_id="+useDatasourceId;
			var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
			
			//获得计算列
			var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+reportId+"&report_sql_id="+useDatasourceId;
			var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
			for(var i=0;i<extData.length;i++){
				data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
			}
			
			var tableColumnUl=$("#tableColumnDiv>ul");
			var tableColumnHtmlStr='';
			for(var i=0;i<data.length;i++){
				if(data[i].isextcolumn==true){
					tableColumnHtmlStr+=tableGenerationExtColumnDivLiHtml(data[i]["id"],data[i]["text"]);
				}else{
					tableColumnHtmlStr+=tableGenerationColumnDivLiHtml(data[i]["id"],data[i]["text"],data[i]["text"]);
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
			  	tableCheckTableColumn($(this).attr("data-columnId"),$(this).attr("data-columnName"),$(this).attr("data-columnDesc"));
			  	window.setTimeout(function(){ tableFlushColumnDiv(columnId);},1000); 
			});
			tableEnableOrDisabledSelectAllCol();
			tableInitColumnDiv();
			tableInitDimColumnDiv();
			tableInitKpiColumnDiv();
			tableInitSortColumnDiv();
			
			if(datasourceData!=undefined){
				for(var i=0;i<datasourceData.length;i++){
					if(useDatasourceId==datasourceData[i]["id"]){
						columnDatas=datasourceData[i]["children"]
					}
				}
			}
		}
		if(typeof(columnDatas)=="undefined"||columnDatas==null||columnDatas=='null'){
			columnDatas=[];
		}
		if(extData!=undefined){
			for(var i=0;i<extData.length;i++){
				columnDatas.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
			}
		}
		
		/*设置维度区域、指标区域和被选择指标区域（部分）*/
		var datastore=jsonObj.datastore;
		var dataColList=null;
		var tempDataColId=null;
		var tempDataColColumn=null;
		var tempDataColDesc=null;
		var tempDataColType=null;
		var tempIsVaildFlag=false;
		var tempDeleteDataColArray=[];
		if(typeof(datastore)!="undefined"&&datastore!=null&&datastore!='null'){
			dataColList=datastore.datacolList;
			if(typeof(dataColList)!="undefined"&&dataColList!=null&&dataColList!='null'){
				for(var i=0;i<dataColList.length;i++){
					for(var a=0;a<dataColList.length;a++){
						if(thShowArray[i]==dataColList[a]["tablecolcode"]&&(dataColList[a]["datacoltype"]=='dim'||dataColList[a]["datacoltype"]=='kpi')){
							tempDataColId=dataColList[a]["datacolid"];
							tempDataColColumn=dataColList[a]["datacolcode"];
							tempDataColDesc=dataColList[a]["datacoldesc"];
							tempDataColType=dataColList[a]["datacoltype"];
							if(typeof(tempDataColId)!="undefined"&&tempDataColId!=null&&tempDataColId!='null'){
								tempIsVaildFlag=false;
								for(var b=0;b<columnDatas.length;b++){
									if(tempDataColColumn==columnDatas[b]["text"]){
										tempIsVaildFlag=true;
										break;
									}
								
								}
								if(tempIsVaildFlag){
									if(tempDataColType=='dim'){
										tableInsertDimColumnHtml(tempDataColId,tempDataColColumn,tempDataColDesc,false);
									}else if(tempDataColType=='kpi'){
										tableInsertKpiColumnHtml(tempDataColId,tempDataColColumn,tempDataColDesc,false);
									}
									$("#tableColumnCheckbox_"+tempDataColId).iCheck('check');//设置被选择指标区域中指标为选中状态
								}else{
									var tempDeleteDataColInfo={};
									tempDeleteDataColInfo.type=tempDataColType;
									tempDeleteDataColInfo.id=tempDataColId;
									tempDeleteDataColInfo.column=tempDataColColumn;
									tempDeleteDataColInfo.desc=tempDataColDesc;
									tempDeleteDataColInfo.type=tempDataColType;
									tempDeleteDataColArray.push(tempDeleteDataColInfo);
								}
								
								
								
							}
							break;
							
						}
						
					}
				
				}
				
			}
		}
		
		
		/*设置排序区域和被选择指标区域（部分）*/
		var sortColStore=jsonObj.sortcolStore;
		var sortColList=null;
		var sortColId=null;
		var sortColColumn=null;
		var sortColDesc=null;
		var sortType=null;
		var sortKpiType=null;
		if(typeof(sortColStore)!="undefined"&&sortColStore!=null&&sortColStore!='null'){
			sortColList=sortColStore.sortcolList;
			if(typeof(sortColList)!="undefined"&&sortColList!=null&&sortColList!='null'){
				for(var i=0;i<sortColList.length;i++){
					sortColId=sortColList[i]["id"];
					sortColColumn=sortColList[i]["col"];
					sortColDesc=sortColList[i]["desc"];
					sortType=sortColList[i]["type"];
					sortKpiType=sortColList[i]["kpitype"];
					tempIsVaildFlag=false;
					for(var b=0;b<columnDatas.length;b++){
						if(sortColDesc==columnDatas[b]["text"]){
							tempIsVaildFlag=true;
							break;
						}
					}
					if(tempIsVaildFlag){
						tableInsertSortColumnHtml(sortColId,sortColColumn,sortColDesc,false);//向排序区域插入数据
						$("#tableColumnCheckbox_"+sortColId).iCheck('check');//设置被选择指标区域中指标为选中状态
						$("#tableSortColumnATag_"+sortType+"_"+sortColId).show().siblings("a[id^='tableSortColumnATag_']").hide();
						$("#tableSortColumnTypeATag_"+sortKpiType+"_"+sortColId).show().siblings("a[id^='tableSortColumnTypeATag_']").hide()
					}
					
				}
			}
		}
		
		
		tableEnableOrDisabledSelectAllCol();//设置 全选多选框
		if(tempDeleteDataColArray.length>0){
			tableRemoveMoreColumn(tempDeleteDataColArray);
		}
		
				
	}
}

/** 描述：删除维度区域中维度记录
	参数：
		obj a标签对象
*/
function tableRemoveMoreColumn(deleteDataColArray){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var dataTrTd=$("#selectable_"+componentId+" tr:last>td");
	var deleteDataColColcodeArray=[];
	for(var a=0;a<deleteDataColArray.length;a++){
		for(var b=0;b<dataTrTd.length;b++){
			if($(dataTrTd[b]).text()==deleteDataColArray[a]["desc"]){
				deleteDataColColcodeArray.push($(tableFirstTrTh[b+1]).text());
			}
		
		}
		
	}
	var columnId;
	var columnName;
	var columnDesc;
	var columnType;
	var tempTablerowcode="";
	var tempTablecolcode="";
	var tempTableCellInd="";
	var tempLastRowCell=null;
	var tempReplaceCellColcode='';
	for(var i=0;i<deleteDataColArray.length;i++){
		columnId=deleteDataColArray[i]["id"];
		columnName=deleteDataColArray[i]["column"];
		columnDesc=deleteDataColArray[i]["desc"];
		columnType=deleteDataColArray[i]["type"];
		tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
		dataTrTd=$("#selectable_"+componentId+" tr:last>td");
		for(var a=0;a<dataTrTd.length;a++){
			if($(dataTrTd[a]).text()==columnDesc){
				tempReplaceCellColcode=$(tableFirstTrTh[dataTrTd.length]).text();
				tempTablerowcode=$(dataTrTd[a]).attr("istt").substring(2);
				tempTablecolcode=$(tableFirstTrTh[a+1]).text();
				tempTableCellInd=$(dataTrTd[a]).attr("tdInd");
				tableClearCell(componentId,tempTablerowcode,tempTablecolcode);
				tempLastRowCell=tableFindLastRowCellByTdInd(componentId,tempTableCellInd);
				tableClearCell(componentId,$(tempLastRowCell).attr("istt").substring(2),tempTablecolcode);
				tableMoveCell(componentId,tempTablerowcode,tempTablecolcode,tempReplaceCellColcode);
				if(columnType=='dim'){
					if($("#tableDimColumn_"+columnId).size()>0){
						$("#tableDimColumn_"+columnId).parent().parent().remove();
					}
				}else if(columnType=='kpi'){
					if($("#tableKpiColumn_"+columnId).size()>0){
						$("#tableKpiColumn_"+columnId).parent().parent().remove();
					}
				}
				
				tableFlushColumnDiv(columnId);
				break;
			}
		}
		
	
	}
	
	TableEvent.removeMoreCol(reportId,containerId,componentId,deleteDataColColcodeArray);
	
	
}



/** 描述：打开数据单元格的链接的设置参数的面板
	参数：
	
*/
function tableDataOpenEventLinkParamDialog(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var tableDataEventLink=$("#tableDataEventLink").val();
	if(tableDataEventLink==''){
		$.messager.alert("基础表格","请先选择一个报表后再设置参数！","error");
		return false;
	}
	$("#tableDataEventLinkParamCareSpan").html("注意：“对应数据列”中请选择维度字段或维度编码字段，不能选择指标！");
	var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+tableDataEventLink,type:"POST",cache: false,async: false}).responseText;
	dimsionsJson=$.parseJSON(dimsionsJson);
	
	var datasourceId=$.ajax({url: appBase+"/getDataSourceIdJsonX.e?reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId,type:"POST",cache: false,async: false}).responseText;
	if(datasourceId==''||datasourceId==null||datasourceId=='null'){
		$.messager.alert("基础表格","请先设置表格的数据源！","error");
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
		$("#tableDataEventLinkParamTable").html("");
		
		
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
					break;
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
		
		tableDataOpenEventLinkParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField);
	}
	
	
	$("#tableDataEventLinkParamDialog").dialog("open");
	hideToolsPanel();
}

/** 描述：打开数据单元格的联动的设置参数的面板
	参数：
	
*/
function tableDataOpenEventActiveDialog(eventComponetId,eventEventId){
	$("#tableDataEventActiveParamCareSpan").html("注意：“对应数据列”中请选择维度字段或维度编码字段，不能选择指标！");
	tableCurrentEvnetCompenentId=eventComponetId;
	tableCurrentEvnetEventId=eventEventId;
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+reportId+'&isTempFile=1',type:"POST",cache: false,async: false}).responseText;
	dimsionsJson=$.parseJSON(dimsionsJson);
	
	var datasourceId=$.ajax({url: appBase+"/getDataSourceIdJsonX.e?reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId,type:"POST",cache: false,async: false}).responseText;
	if(datasourceId==''||datasourceId==null||datasourceId=='null'){
		$.messager.alert("基础表格","请先设置表格的数据源！","error");
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
					if(eventList[x]["id"]==tableCurrentEvnetEventId&&eventList[x]["source"]==tableCurrentEvnetCompenentId){
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
	
	$("#tableDataEventActiveParamTable").html("");
	
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
					break;
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
		tableDataOpenEventActiveParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField);
	}
	
	$("#tableDataEventActiveParamDialog").dialog("open");
	hideToolsPanel();
}


/** 描述：设置标题
	参数：
		titleValue 标题内容
*/
function tableSetTitle(titleValue){
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	TableEvent.setTitle(reportId,containerId,componentId,titleValue);
}
/** 描述：设置显示标题
	参数：
		
*/
function tableSetShowTitle(){
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#tableShowTitle").attr("checked")!='checked'){
		resultValue='1';
	}
	TableEvent.setShowTitleFlag(reportId,containerId,componentId,resultValue);
}

/** 描述：是否分页显示
	参数：
*/
function tableSetPagi(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#tablePagi").attr("checked")!='checked'){
		resultValue='1';
	}
	TableEvent.setPagiFlag(reportId,containerId,componentId,resultValue);
}



/** 描述：分页时，设置每页显示记录数
	参数：
		pagiNum 记录数
*/
function tableSetPagiNum(pagiNum){
	if($.trim(pagiNum)==''){
		pagiNum=LayOutUtil.data.xDefautlTablePagiNum;
		$("#tablePagiNum").numberbox("setValue",pagiNum);
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	TableEvent.setPagiNum(reportId,containerId,componentId,pagiNum);
}

/** 描述：是否允许导出数据
	参数：
*/
function tableSetExport(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#tableExport").attr("checked")!='checked'){
		resultValue='1';
	}
	TableEvent.setExportFlag(reportId,containerId,componentId,resultValue);
}
/** 描述：是否锁定列
	参数：
*/
function tableSetColLock(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#tableColLock").attr("checked")!='checked'){
		$("#tableColLockNum").numberbox("setValue",1);
		$("#tableColLockNum").numberbox("enable");
		resultValue='1';
		$.messager.show({
			title:'锁定列提示',
			msg:'锁定列上方单元格不能进行列合并，否则锁定列将无效！',
			showType:'slide',
			style:{
				right:'',
				top:document.body.scrollTop+document.documentElement.scrollTop,
				bottom:''
			}
		});
	
		
	}else{
		$("#tableColLockNum").numberbox("setValue","1");
		$("#tableColLockNum").numberbox("disable");
		resultValue='0';
	}
	TableEvent.setColLockFlag(reportId,containerId,componentId,resultValue);
	
}
/** 描述：设置锁定列列数
	参数：
		colLockNum 列数
*/
function tableSetColLockNum(colLockNum){
	if($.trim(colLockNum)==''){
		colLockNum=1;
		$("#tableColLockNum").numberbox("setValue",colLockNum);
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	TableEvent.setColLockNum(reportId,containerId,componentId,colLockNum);
}

/** 描述：设置行小计
	参数：
		
*/
function tableSetShowRowTotal(){
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#tableShowRowTotal").attr("checked")!='checked'){
		resultValue='1';
	}
	TableEvent.setShowRowTotalFlag(reportId,containerId,componentId,resultValue);
}

/** 描述：设置合计
	参数：
		
*/
function tableSetShowTotal(){
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#tableShowTotal").attr("checked")!='checked'){
		resultValue='1';
	}
	if(resultValue=='0'){
		$("#tableShowTotalPosition").combobox("disable");
		$("#tableShowTotalName").attr("disabled","disabled");
	}else{
		$("#tableShowTotalPosition").combobox("enable");
		$("#tableShowTotalName").removeAttr("disabled");
	}
	TableEvent.setShowTotalFlag(reportId,containerId,componentId,resultValue);
}

/** 描述：设置合计显示位置
	参数：
		
*/
function tableSetShowTotalPosition(){
	
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue=$("#tableShowTotalPosition").combobox("getValue");
	TableEvent.setShowTotalPosition(reportId,containerId,componentId,resultValue);
}


/** 描述：设置合计时的显示名称
	参数：
		showTotalName 显示的合计名称
*/
function tableSetShowTotalName(showTotalName){
	if($.trim(showTotalName)==''){
		showTotalName='合计';
		$("#tableShowTotalName").val(showTotalName);
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	TableEvent.seShowTotalName(reportId,containerId,componentId,showTotalName);
}

/** 描述：设置指标聚合
	参数：
		
*/
function tableSetSetSum(){
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#tableSetNum").attr("checked")!='checked'){
		resultValue='1';
		$("#tableShowRowTotal").iCheck("enable");
		$("#tableShowTotal").iCheck("enable");
	}else{
		$("#tableShowRowTotal").iCheck('uncheck');
		$("#tableShowRowTotal").iCheck('disable');
		$("#tableShowTotal").iCheck('uncheck');
		$("#tableShowTotal").iCheck('disable');
		$("#tableShowTotalPosition").combobox("setValue","top");
		$("#tableShowTotalPosition").combobox("disable");
	}
	TableEvent.setSetSum(reportId,containerId,componentId,resultValue);
}


/** 描述：启用或禁用 全选多选框
	参数：
*/
function tableEnableOrDisabledSelectAllCol(){
	if($("span[id^='tableKpiColumn_']").size()!=0||$("span[id^='tableDimColumn_']").size()!=0||$("input[id^='tableColumnCheckbox_']").size()==0){
		$("#tableSelectAllCol").iCheck('disable');
		$("#tableSelectAllCol").iCheck('check');
	}else{
		$("#tableSelectAllCol").iCheck('uncheck');
		$("#tableSelectAllCol").iCheck('enable');
	}
}


/** 描述：初始化被选指标区域
	参数：
		
*/
function tableInitColumnDiv(){
	$('#tableColumnDiv li').draggable({
		//proxy:'clone',
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

/** 描述：维度区域和指标区域的sortable的start事件执行的方法
	参数：
		
*/
function tableSortStartFun(event, ui){
	tableSortStartArray=[];
	tableSortStartTypeArray=[];
	var tempIndex=0;
	var columnLis=null;
	columnLis=$("#tableDimColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		tableSortStartArray[tempIndex]=$(columnLis[a]).find("span").eq(0).text();
		tableSortStartTypeArray[tempIndex]='dim';
		tempIndex++;
	}
	columnLis=$("#tableKpiColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		tableSortStartArray[tempIndex]=$(columnLis[a]).find("span").eq(0).text();
		tableSortStartTypeArray[tempIndex]='kpi';
		tempIndex++;
	}
	columnLis=$("#tableSortColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		tableSortStartArray[tempIndex]=$(columnLis[a]).find("span").eq(0).text();
		tableSortStartTypeArray[tempIndex]='sort';
		tempIndex++;
	}
	
}
/** 描述：维度区域和指标区域的sortable的stop事件执行的方法
	参数：
		
*/
function tableSortStopFun(event, ui){
	tableSortEndArray=[];
	var uiSpan=ui.item.find("span").eq(0);
	var currentItem=uiSpan.text();
	var continueFlag=true;
	var sourceType='';//源li的类型(dim,kpi,sort)
	var targetType='';//目标li的类型(dim,kpi,sort)
	var tempIndex=0;
	var columnLis=null;
	var tempUlLi=null;
	var tempUlLiSpan=null;
	var startNum=0;
	var endNum=0;
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var dimUlLiList=$("#tableDimColumnDiv>ul>li");
	var kpiUlLiList=$("#tableKpiColumnDiv>ul>li");
	var sortUlLiList=$("#tableSortColumnDiv>ul>li");
	
	/*维度*/
	for(var a=0;a<dimUlLiList.length;a++){
		tempUlLi=$(dimUlLiList[a]);
		tempUlLiSpan=tempUlLi.find("span").eq(0)
		if(tempUlLiSpan.text()==currentItem){
			var columnId,columnColumn,columnName,columnStr;
			if(tempUlLiSpan.attr("id").indexOf("tableDimColumn_")>-1&&uiSpan.attr("id").indexOf("tableDimColumn_")>-1){
				endNum=a;
				targetType='dim';
				sourceType='dim';
			
			}else if(tempUlLiSpan.attr("id").indexOf("tableKpiColumn_")>-1){
				endNum=a;
				targetType='dim';
				sourceType='kpi';
				columnId=tempUlLiSpan.attr("id").substring("tableKpiColumn_".length);
				columnColumn=tempUlLiSpan.attr("name").substring("tableKpiColumn_".length);
				columnName=tempUlLiSpan.text();
				var liSpan=$("span[id='tableColumn_"+columnId+"']");
				if($(liSpan).attr("extcolumnid")!=undefined){
					$.messager.alert("基础表格","<br/>计算列不能用做维度！","error");
					$("#tableKpiColumnDiv>ul").sortable('cancel');
					return false;
				}
				columnStr=tableGenerationDimColumnHtml(columnId,columnColumn,columnName);
				$("#tableKpiColumn_"+columnId).parent().parent().html($(columnStr).html());
				break;
			}else if(tempUlLiSpan.attr("id").indexOf("tableSortColumn_")>-1){
				endNum=a;
				targetType='dim';
				sourceType='sort';
				columnId=tempUlLiSpan.attr("id").substring("tableSortColumn_".length);
				columnColumn=tempUlLiSpan.attr("name").substring("tableSortColumn_".length);
				columnName=tempUlLiSpan.text();
				var liSpan=$("span[id='tableColumn_"+columnId+"']");
				if($(liSpan).attr("extcolumnid")!=undefined){
					$.messager.alert("基础表格","<br/>计算列不能用做维度！","error");
					$("#tableSortColumnDiv>ul").sortable('cancel');
					return false;
				}
				columnStr=tableGenerationDimColumnHtml(columnId,columnColumn,columnName);
				if($("#tableDimColumn_"+columnId).size()>0){
					$("#tableSortColumnDiv>ul").sortable( 'cancel' );
					$.messager.alert("基础表格","拖动无效，该维度在维度区域中已存在！","error");
					continueFlag=false;
					break;
				}
				if(($("#tableKpiColumn_"+columnId).size())>0){
					$("#tableSortColumnDiv>ul").sortable( 'cancel' );
					$.messager.alert("基础表格","拖动无效，该维度在指标区域中已存在！","error");
					continueFlag=false;
					break;
				}
				
				
				var dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
				var insertContinueFlag=true;
				
				var lastTrTd=$("#selectable_"+componentId+" tr:last>td:last");
				$('#selectable_'+componentId+' tr>td').removeClass("ui-selected");
				lastTrTd.addClass("ui-selected");
				if(lastTrTd.text()!=''){
					if(!tableInsertColumn(componentId,"right")){
						insertContinueFlag=false;
					}
				}
				lastTrTd.removeClass("ui-selected");
				$('#selectable_'+componentId).selectable('refresh');
				
				
				if(insertContinueFlag){
					var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
					var tempLastRowCell=null;
					dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
					for(var i=0;i<dataKpiTrTd.length;i++){
						if($.trim($(dataKpiTrTd[i]).text())==''){
							var tablerowcode=$(dataKpiTrTd[i]).attr("istt").substring(2);
							$(dataKpiTrTd[i]).text(columnName);
							$(dataKpiTrTd[i]).attr("data-tableDataTdType","kpi");
							tempLastRowCell=tableFindLastRowCellByTdInd(componentId,$(dataKpiTrTd[i]).attr("tdInd"));
							$(tempLastRowCell).text(columnName);
							break;
						}
					}
					
				}
				
				
				if(a==0){
					$("#tableDimColumnDiv>ul").prepend(columnStr);
				}else{
					$(dimUlLiList[a-1]).after(columnStr);
				}
				startNum=dimUlLiList.size()+kpiUlLiList.size()-1;
				$("#tableSortColumnDiv>ul").sortable('cancel');
				//$("#tableSortColumn_"+columnId).parent().parent().html($(columnStr).html());
				break;
			}
			
		}
	}
	if(!continueFlag){
		return false;
	}
	for(var a=0;a<kpiUlLiList.length;a++){
		tempUlLi=$(kpiUlLiList[a]);
		tempUlLiSpan=tempUlLi.find("span").eq(0)
		if(tempUlLiSpan.text()==currentItem){
			var columnId,columnColumn,columnName,columnStr;
			if(tempUlLiSpan.attr("id").indexOf("tableKpiColumn_")>-1&&uiSpan.attr("id").indexOf("tableKpiColumn_")>-1){
				endNum=dimUlLiList.length+a;
				targetType='kpi';
				sourceType='kpi';
			
			}else if(tempUlLiSpan.attr("id").indexOf("tableDimColumn_")>-1){
				endNum=dimUlLiList.length+a;
				targetType='kpi';
				sourceType='dim';
				columnId=tempUlLiSpan.attr("id").substring("tableDimColumn_".length);
				columnColumn=tempUlLiSpan.attr("name").substring("tableDimColumn_".length);
				columnName=tempUlLiSpan.text();
				columnStr=tableGenerationKpiColumnHtml(columnId,columnColumn,columnName);
				$("#tableDimColumn_"+columnId).parent().parent().html($(columnStr).html());
				break;
			}else if(tempUlLiSpan.attr("id").indexOf("tableSortColumn_")>-1){
				endNum=dimUlLiList.length+a;
				targetType='kpi';
				sourceType='sort';
				columnId=tempUlLiSpan.attr("id").substring("tableSortColumn_".length);
				columnColumn=tempUlLiSpan.attr("name").substring("tableSortColumn_".length);
				columnName=tempUlLiSpan.text();
				columnStr=tableGenerationKpiColumnHtml(columnId,columnColumn,columnName);
				if($("#tableDimColumn_"+columnId).size()>0){
					$("#tableSortColumnDiv>ul").sortable( 'cancel' );
					$.messager.alert("基础表格","拖动无效，该维度在维度区域中已存在！","error");
					continueFlag=false;
					break;
				}
				if(($("#tableKpiColumn_"+columnId).size())>0){
					$("#tableSortColumnDiv>ul").sortable( 'cancel' );
					$.messager.alert("基础表格","拖动无效，该维度在指标区域中已存在！","error");
					continueFlag=false;
					break;
				}

				var dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
				var insertContinueFlag=true;
				
				var lastTrTd=$("#selectable_"+componentId+" tr:last>td:last");
				$('#selectable_'+componentId+' tr>td').removeClass("ui-selected");
				lastTrTd.addClass("ui-selected");
				if(lastTrTd.text()!=''){
					if(!tableInsertColumn(componentId,"right")){
						insertContinueFlag=false;
					}
				}
				lastTrTd.removeClass("ui-selected");
				$('#selectable_'+componentId).selectable('refresh');
				
				
				if(insertContinueFlag){
					var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
					var tempLastRowCell=null;
					dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
					for(var i=0;i<dataKpiTrTd.length;i++){
						if($.trim($(dataKpiTrTd[i]).text())==''){
							var tablerowcode=$(dataKpiTrTd[i]).attr("istt").substring(2);
							$(dataKpiTrTd[i]).text(columnName);
							$(dataKpiTrTd[i]).attr("data-tableDataTdType","kpi");
							tempLastRowCell=tableFindLastRowCellByTdInd(componentId,$(dataKpiTrTd[i]).attr("tdInd"));
							$(tempLastRowCell).text(columnName);
							break;
						}
					}
					
				}
				
				
				if(a==0){
					$("#tableKpiColumnDiv>ul").prepend(columnStr);
				}else{
					$(kpiUlLiList[a-1]).after(columnStr);
				}
				startNum=dimUlLiList.size()+kpiUlLiList.size()-1;
				
				$("#tableSortColumnDiv>ul").sortable('cancel');
				
				//startNum=dimUlLiList.size()+kpiUlLiList.size()-1;
				//$("#tableSortColumn_"+columnId).parent().parent().html($(columnStr).html());
				break;
			}
			
		}
	}
	if(!continueFlag){
		return false;
	}
	for(var a=0;a<sortUlLiList.length;a++){
		tempUlLi=$(sortUlLiList[a]);
		tempUlLiSpan=tempUlLi.find("span").eq(0)
		if(tempUlLiSpan.text()==currentItem){
			if(tempUlLiSpan.text()==currentItem){
				var columnId,columnColumn,columnName,columnStr;
				if(tempUlLiSpan.attr("id").indexOf("tableDimColumn_")>-1){
					targetType='sort';
					sourceType='dim';
					columnId=tempUlLiSpan.attr("id").substring("tableDimColumn_".length);
					columnColumn=tempUlLiSpan.attr("name").substring("tableDimColumn_".length);
					columnName=tempUlLiSpan.text();
					columnStr=tableGenerationSortColumnHtml(columnId,columnColumn,columnName);
					
					if(($("#tableSortColumn_"+columnId).size())>0){
						$("#tableDimColumnDiv>ul").sortable( 'cancel' );
						$.messager.alert("基础表格","拖动无效，该维度在默认排序区域中已存在！","error");
						continueFlag=false;
						break;
					}
					if(a==0){
						$("#tableSortColumnDiv>ul").prepend(columnStr);
					}else{
						$(sortUlLiList[a-1]).after(columnStr);
					}
					$("#tableDimColumnDiv>ul").sortable( 'cancel' );
					$("#tableSortColumnTypeATag_dim_"+columnId).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
					$("#tableSortColumnATag_asc_"+columnId).show().siblings("a[id^='tableSortColumnATag_']").hide();
					break;
				}else if(tempUlLiSpan.attr("id").indexOf("tableKpiColumn_")>-1){
					targetType='sort';
					sourceType='kpi';
					columnId=tempUlLiSpan.attr("id").substring("tableKpiColumn_".length);
					columnColumn=tempUlLiSpan.attr("name").substring("tableKpiColumn_".length);
					columnName=tempUlLiSpan.text();
					columnStr=tableGenerationSortColumnHtml(columnId,columnColumn,columnName);
					if(($("#tableSortColumn_"+columnId).size())>0){
						$("#tableKpiColumnDiv>ul").sortable( 'cancel' );
						$.messager.alert("基础表格","拖动无效，该指标在默认排序区域中已存在！","error");
						continueFlag=false;
						break;
					}
					if(a==0){
						$("#tableSortColumnDiv>ul").prepend(columnStr);
					}else{
						$(sortUlLiList[a-1]).after(columnStr);
					}
					$("#tableKpiColumnDiv>ul").sortable('cancel');
					$("#tableSortColumnTypeATag_kpi_"+columnId).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
					$("#tableSortColumnATag_desc_"+columnId).show().siblings("a[id^='tableSortColumnATag_']").hide();
					break;
				}
			}
		}
	}
	if(!continueFlag){
		return false;
	}
	columnLis=$("#tableDimColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		tableSortEndArray[tempIndex]=$(columnLis[a]).find("span").eq(0).text();
		tempIndex++;
	}
	columnLis=$("#tableKpiColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		tableSortEndArray[tempIndex]=$(columnLis[a]).find("span").eq(0).text();
		tempIndex++;
	}
	columnLis=$("#tableSortColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		tableSortEndArray[tempIndex]=$(columnLis[a]).find("span").eq(0).text();
		tempIndex++;
	}
	if(targetType=='dim'||targetType=='kpi'){//目标区域是维度或指标
		if(startNum==0){
			for(var b=0;b<tableSortStartArray.length;b++){
				if(currentItem==tableSortStartArray[b]&&tableSortStartTypeArray[b]==sourceType){
					startNum=b;
					break;
				}
			}
		}
		
		var columnTrtds=$("#selectable_"+componentId+" tr:last>td");
		var currentRowNum=0;
		var currentColNum=0;
		for(var c=0;c<columnTrtds.length;c++){
			if($(columnTrtds[c]).text()==currentItem){
				currentColNum=parseInt($(columnTrtds[c]).attr("tdInd"));
				currentRowNum=parseInt($(columnTrtds[c]).attr("istt").substring(2));
				
				$(columnTrtds[c]).attr("data-tableDataTdType",targetType);
			}
		}
		var insertColNum=0;
		if(endNum>startNum){
			insertColNum=currentColNum+(endNum-startNum);
		}else{
			insertColNum=currentColNum-(startNum-endNum);
		}
		
		var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
		var currentColCode=$(tableFirstTrTh[currentColNum]).text();
		var insertColCode=$(tableFirstTrTh[insertColNum]).text();
		tableMoveCell(componentId,currentRowNum,currentColCode,insertColCode);
		var colInfo={};
		if(sourceType=='sort'){
			colInfo.datacolid=columnId;
			colInfo.datacolcode=columnColumn;
			colInfo.datacoldesc=columnName;
			colInfo.tablecoldesc=columnName;
			var extcolumnid = $("#tableColumn_C"+columnColumn).attr("extcolumnid");
			extcolumnid = extcolumnid==undefined?"":extcolumnid;
			colInfo.extcolumnid=extcolumnid;
			
		}
		if($("#tableSortColumnTypeATag_"+targetType+"_"+columnId)!=null&&$("#tableSortColumnTypeATag_"+targetType+"_"+columnId)!=undefined&&$("#tableSortColumnTypeATag_"+targetType+"_"+columnId).size()>0){
			$("#tableSortColumnTypeATag_"+targetType+"_"+columnId).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
		}
		colInfo.datacoltype=targetType;
		TableEvent.moveColPostion(reportId,containerId,componentId,currentRowNum,currentColCode,insertColCode,colInfo);
		
	}else if(targetType=='sort'||targetType==''){
		columnLis=$("#tableSortColumnDiv>ul>li");
		var columnSortInfoList=[];
		for(var a=0;a<columnLis.length;a++){
			tempUlLi=$(columnLis[a]);
			tempUlLiSpan=tempUlLi.find("span").eq(0);
			var info={};
			info["id"]=tempUlLiSpan.attr("id").substring("tableSortColumn_".length);
			info["col"]=tempUlLiSpan.attr("name").substring("tableSortColumn_".length);
			info["desc"]=tempUlLiSpan.text();
			
			var extcolumnid = $("#tableColumn_C"+info["col"]).attr("extcolumnid");
			extcolumnid = extcolumnid==undefined?"":extcolumnid;
			info.extcolumnid=extcolumnid;
			
			if($("#tableSortColumnATag_asc_"+info["id"]).is(":hidden")){
				info["type"]='desc';
			}else{
				info["type"]='asc';
			}
			if($("#tableSortColumnTypeATag_dim_"+info["id"]).is(":hidden")){
				info["kpitype"]='kpi';
			}else{
				info["kpitype"]='dim';
			}
			columnSortInfoList.push(info);
			
		}
		if(columnSortInfoList.length>0){
			TableEvent.overWriteSortCol(reportId,containerId,componentId,columnSortInfoList);
		}
	}
	
}

/** 描述：是否全选到指标区域中
	参数：
*/
function tableCheckAllTableColumn(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if($("#tableSelectAllCol").attr("checked")!='checked'){
		var tableColumnObjArray=[];
		var tableColumns=$("#tableColumnDiv>ul>li span[id^='tableColumn_']");
		var subIndex='tableColumn_'.length;
		for(var a=0;a<tableColumns.length;a++){
			var info={};
			info.columnId=$(tableColumns[a]).attr("id").substring(subIndex);
			info.columnName=$(tableColumns[a]).attr("name").substring(subIndex);
			info.columnDesc=$(tableColumns[a]).text();
			info.extcolumnid = $(tableColumns[a]).attr("extcolumnid")==undefined?"":$(tableColumns[a]).attr("extcolumnid");
			tableColumnObjArray.push(info);
		}
		
		tableInsertMoreKpiColumn(tableColumnObjArray);

	}
	//TableEvent.setPagiFlag(reportId,containerId,componentId,resultValue);
}

/** 描述：初始化维度区域
	参数：
		
*/
function tableInitDimColumnDiv(){
	$('#tableDimColumnDiv').droppable({
		accept:'#tableColumnDiv li',
		onDragEnter:function(e,source){
		},
		onDragLeave:function(e,source){
		},
		onDrop:function (e, source) {
			var liSpan=$(source).find("span[id^='tableColumn_']");
			if($(liSpan).attr("extcolumnid")!=undefined){
				$.messager.alert("基础表格","<br/>计算列不能用做维度！","error");
				return;
			}
			var liCheckBox=$(source).find("input[type='checkbox']");
			liCheckBox.iCheck('check');
			tableEnableOrDisabledSelectAllCol();
			var subIndex='tableColumn_'.length;
			var dimId=liSpan.attr("id").substring(subIndex);
			var dimColumn=liSpan.attr("name").substring(subIndex);
			var dimName=liSpan.text();
			tableInsertDimColumn(dimId,dimColumn,dimName);
		}
	});
	var tableKpiColumnUl=$("#tableDimColumnDiv>ul");
	tableKpiColumnUl.sortable({
		connectWith: "#tableKpiColumnDiv>ul,#tableSortColumnDiv>ul",
		start : function(event, ui){tableSortStartFun(event, ui);},
		stop:function(event, ui){tableSortStopFun(event, ui);	}
	});
	tableKpiColumnUl.disableSelection();
}

/** 描述：删除维度区域中维度记录
	参数：
		obj a标签对象
*/
function tableRemoveDimColoumnLi(columnId,columnName,columnDesc){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var dataDimTrTd=$("#selectable_"+componentId+" tr:last>td");
	var tempTablerowcode="";
	var tempTablecolcode="";
	var tempTableCellInd="";
	var tempLastRowCell=null;
	var tempReplaceCellColcode='';
	for(var a=0;a<dataDimTrTd.length;a++){
		if($(dataDimTrTd[a]).text()==columnDesc){
			tempReplaceCellColcode=$(tableFirstTrTh[dataDimTrTd.length]).text();
			tempTablerowcode=$(dataDimTrTd[a]).attr("istt").substring(2);
			tempTablecolcode=$(tableFirstTrTh[a+1]).text();
			tempTableCellInd=$(dataDimTrTd[a]).attr("tdInd");
			tableClearCell(componentId,tempTablerowcode,tempTablecolcode);
			tempLastRowCell=tableFindLastRowCellByTdInd(componentId,tempTableCellInd);
			tableClearCell(componentId,$(tempLastRowCell).attr("istt").substring(2),tempTablecolcode);
			tableMoveCell(componentId,tempTablerowcode,tempTablecolcode,tempReplaceCellColcode);
			if($("#tableDimColumn_"+columnId).size()>0){
				$("#tableDimColumn_"+columnId).parent().parent().remove();
			}
			tableFlushColumnDiv(columnId);
			TableEvent.removeDimCol(reportId,containerId,componentId,tempTablecolcode);
			break;
		}
	}
	
}


/** 描述：初始化指标区域
	参数：
		
*/
function tableInitKpiColumnDiv(){
	$('#tableKpiColumnDiv').droppable({
		accept:'#tableColumnDiv li',
		onDragEnter:function(e,source){
		},
		onDragLeave:function(e,source){
		},
		onDrop:function (e, source) {
			var liCheckBox=$(source).find("input[type='checkbox']");
			liCheckBox.iCheck('check');
			tableEnableOrDisabledSelectAllCol();

			var liSpan=$(source).find("span[id^='tableColumn_']");
			var subIndex='tableColumn_'.length;
			var kpiId=liSpan.attr("id").substring(subIndex);
			var kpiColumn=liSpan.attr("name").substring(subIndex);
			var kpiName=liSpan.text();
			
			tableInsertKpiColumn(kpiId,kpiColumn,kpiName);
			
			
		}
	});
	var tableKpiColumnUl=$("#tableKpiColumnDiv>ul");
	tableKpiColumnUl.sortable({
		connectWith: "#tableDimColumnDiv>ul,#tableSortColumnDiv>ul",
		start : function(event, ui){tableSortStartFun(event, ui);},
		stop:function(event, ui){tableSortStopFun(event, ui);	}
	});
	tableKpiColumnUl.disableSelection();
}

/** 描述：删除指标区域中指标记录
	参数：
		obj a标签对象
*/
function tableRemoveKpiColoumnLi(columnId,columnName,columnDesc){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
	var tempTablerowcode="";
	var tempTablecolcode="";
	var tempTableCellInd="";
	var tempLastRowCell=null;
	var tempReplaceCellColcode='';
	for(var a=0;a<dataKpiTrTd.length;a++){
		if($(dataKpiTrTd[a]).text()==columnDesc){
			tempReplaceCellColcode=$(tableFirstTrTh[dataKpiTrTd.length]).text();
			tempTablerowcode=$(dataKpiTrTd[a]).attr("istt").substring(2);
			tempTablecolcode=$(tableFirstTrTh[a+1]).text();
			tempTableCellInd=$(dataKpiTrTd[a]).attr("tdInd");
			tableClearCell(componentId,tempTablerowcode,tempTablecolcode);
			tempLastRowCell=tableFindLastRowCellByTdInd(componentId,tempTableCellInd);
			tableClearCell(componentId,$(tempLastRowCell).attr("istt").substring(2),tempTablecolcode);
			tableMoveCell(componentId,tempTablerowcode,tempTablecolcode,tempReplaceCellColcode);
			if($("#tableKpiColumn_"+columnId).size()>0){
				$("#tableKpiColumn_"+columnId).parent().parent().remove();
			}
			tableFlushColumnDiv(columnId);
			TableEvent.removeKpiCol(reportId,containerId,componentId,tempTablecolcode);
			break;
		}
	}
	
}

/** 描述：初始化默认排序区域
	参数：
		
*/
function tableInitSortColumnDiv(){
	$('#tableSortColumnDiv').droppable({
		accept:'#tableColumnDiv li',
		onDragEnter:function(e,source){
		},
		onDragLeave:function(e,source){
		},
		onDrop:function (e, source) {
			var liCheckBox=$(source).find("input[type='checkbox']");
			liCheckBox.iCheck('check');
			tableEnableOrDisabledSelectAllCol();
			
			var liSpan=$(source).find("span[id^='tableColumn_']");
			
			
			var subIndex='tableColumn_'.length;
			var sortId=liSpan.attr("id").substring(subIndex);
			var sortColumn=liSpan.attr("name").substring(subIndex);
			var sortName=liSpan.text();
			
			tableInsertSortColumn(sortId,sortColumn,sortName);
			
		}
	  }
	);
	var tableSortColumnUl=$("#tableSortColumnDiv>ul");
	tableSortColumnUl.sortable({
		connectWith: "#tableDimColumnDiv>ul,#tableKpiColumnDiv>ul",
		start : function(event, ui){tableSortStartFun(event, ui);},
		stop:function(event, ui){tableSortStopFun(event, ui);	}
	}).disableSelection();
}

/** 描述：删除默认排序区域中默认排序记录
	参数：
		obj a标签对象
*/
function tableRemoveSortColoumnLi(columnId,columnName,columnDesc){
	if($("#tableSortColumn_"+columnId).size()>0){
		$("#tableSortColumn_"+columnId).parent().parent().remove();
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	tableFlushColumnDiv(columnId);
	var removeColumnIds=[];
	removeColumnIds.push(columnId);
	TableEvent.removeSortCol(reportId,containerId,componentId,removeColumnIds);
}

/** 描述：根据维度区域、指标区域和排序区域中指标来更改被选中区域指标的选中状态
	参数：
		指标id
		
*/
function tableFlushColumnDiv(columnId){
	if($("#tableDimColumnDiv>ul>li span[id='tableDimColumn_"+columnId+"']").size()==0
	   &&$("#tableKpiColumnDiv>ul>li span[id='tableKpiColumn_"+columnId+"']").size()==0
	   &&$("#tableSortColumnDiv>ul>li span[id='tableSortColumn_"+columnId+"']").size()==0){
	 	$("#tableColumnCheckbox_"+columnId).iCheck('uncheck');
	 	tableEnableOrDisabledSelectAllCol();
	}else{
		$("#tableColumnCheckbox_"+columnId).iCheck('check');
	}
}


/** 描述：点击被选指标区域中指标时，将选择的指标加到指标区域中
	参数：
		tableColumnId 选择的指标编码
		tableColumnName 选择的指标字段名称
		tableColumnDesc 选择的指标描述
*/
function tableCheckTableColumn(tableColumnId,tableColumnName,tableColumnDesc){
	var checkboxEle=$("#tableColumnCheckbox_"+tableColumnId);
	if(checkboxEle.attr("checked")!='checked'){//选中
		tableInsertKpiColumn(tableColumnId,tableColumnName,tableColumnDesc);
	}else{//取消
		var talbeDimColumnSpan=$("#tableDimColumnDiv>ul>li span[id='tableDimColumn_"+tableColumnId+"']");
        if(talbeDimColumnSpan.size()>0){
        	//$("#tableDimColumnCloseATag_"+tableColumnId).click();
        	tableRemoveDimColoumnLi(tableColumnId,tableColumnName,tableColumnDesc);
       	}
       	var talbeKpiColumnSpan=$("#tableKpiColumnDiv>ul>li span[id='tableKpiColumn_"+tableColumnId+"']");
       	if(talbeKpiColumnSpan.size()>0){
       		//$("#tableKpiColumnCloseATag_"+tableColumnId).click();
       		tableRemoveKpiColoumnLi(tableColumnId,tableColumnName,tableColumnDesc);
       	}
       	var talbeSortColumnSpan=$("#tableSortColumnDiv>ul>li span[id='tableSortColumn_"+tableColumnId+"']");
       	if(talbeSortColumnSpan.size()>0){
       		tableRemoveSortColoumnLi(tableColumnId,tableColumnName,tableColumnDesc);
       		//$("#tableSortColumnCloseATag_"+tableColumnId).click();
       		//talbeSortColumnSpan.parent().remove();
       	}
			
	}
	
}

/** 描述：向维度区域中添加指标
	参数：
		dimColumnId 指标编码
		dimColumnName 指标字段名称
		dimColumnDesc 指标描述
*/
function tableInsertDimColumn(dimColumnId,dimColumnName,dimColumnDesc){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var dataDimTrTd=$("#selectable_"+componentId+" tr:last>td");
	var continueFlag=true;
	var lastTrTd=$("#selectable_"+componentId+" tr:last>td:last");
	$('#selectable_'+componentId+' tr>td').removeClass("ui-selected");
	lastTrTd.addClass("ui-selected");
	if(lastTrTd.text()!=''){
		if(!tableInsertColumn(componentId,"right")){
			continueFlag=false;
		}
	}
	lastTrTd.removeClass("ui-selected");
	$('#selectable_'+componentId).selectable('refresh');
	
	var freeTrTdColCode=$("#selectable_"+componentId+" tr:first>th:last").text();
	var freeTrtd=$("#selectable_"+componentId+" tr:last>td:last");
	if(continueFlag){
		if(!tableInsertDimColumnHtml(dimColumnId,dimColumnName,dimColumnDesc,true)){
			return false;
		}
		dataDimTrTd=$("#selectable_"+componentId+" tr:last>td");
		var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
		var tempLastRowCell=null;
		for(var a=0;a<dataDimTrTd.length;a++){
			if($.trim($(dataDimTrTd[a]).attr("data-tableDataTdType"))!='dim'){
				var tablerowcode=$(dataDimTrTd[a]).attr("istt").substring(2);
				var info={};
				info.datacolid=dimColumnId;
				info.datacolcode=dimColumnName;
				info.datacoldesc=dimColumnDesc;
				info.tablecoldesc=dimColumnDesc;
				
				freeTrtd.text(dimColumnDesc);
				freeTrtd.attr("data-tableDataTdType","dim");
				tempLastRowCell=tableFindLastRowCellByTdInd(componentId,freeTrtd.attr("tdInd"));
				$(tempLastRowCell).text(dimColumnDesc);
				
				tableMoveCell(componentId,tablerowcode,freeTrTdColCode,$(tableFirstTrTh[a+1]).text());
				
				TableEvent.setDimCol(reportId,containerId,componentId,tablerowcode,$(tableFirstTrTh[a+1]).text(),info,freeTrTdColCode);
				break;
			}
		}
		tableEnableOrDisabledSelectAllCol();
	}
}


/** 描述：向维度区域中添加指标的html部分
	参数：
		dimColumnId 指标编码
		dimColumnName 指标字段名称
		dimColumnDesc 指标描述
		checkExist 是否检验存在不存在
*/
function tableInsertDimColumnHtml(dimColumnId,dimColumnName,dimColumnDesc,checkExist){
	var tableKpiColumnUl=$("#tableKpiColumnDiv>ul");
	var tableDimColumnUl=$("#tableDimColumnDiv>ul");
	var tableDimColumnHtmlStr='';
	if(checkExist){
		if(tableKpiColumnUl.find("li span[id='tableKpiColumn_"+dimColumnId+"']").size()>0){
			$.messager.alert("基础表格","选择无效，在指标区域已存在该指标！","error");
			return false;
		}
		if(tableDimColumnUl.find("li span[id='tableDimColumn_"+dimColumnId+"']").size()>0){
			$.messager.alert("基础表格","选择无效，在维度区域已存在该指标！","error");
			return false;
		}
	}else{
		var tableDimColumnUlLiSpan=tableDimColumnUl.find("li span[id='tableDimColumn_"+dimColumnId+"']");
		if(tableDimColumnUlLiSpan.size()>0){
			for(var a=0;a<tableDimColumnUlLiSpan.size();a++){
				$(tableDimColumnUlLiSpan[a]).parent().parent().remove();
			}
		}
		
		var tableKpiColumnUlLiSpan=tableKpiColumnUl.find("li span[id='tableKpiColumn_"+dimColumnId+"']");
		if(tableKpiColumnUlLiSpan.size()>0){
			for(var a=0;a<tableKpiColumnUlLiSpan.size();a++){
				$(tableKpiColumnUlLiSpan[a]).parent().parent().remove();
			}
		}
	}

	tableDimColumnHtmlStr=tableGenerationDimColumnHtml(dimColumnId,dimColumnName,dimColumnDesc);
	tableDimColumnUl.append(tableDimColumnHtmlStr);
	return true;
}

/** 描述：生成向维度区域中添加指标的html代码（为了保证插入html的js的惟一性而独立出来的）
	参数：
		kpiColumnId 指标编码
		kpiColumnName 指标字段名称
		kpiColumnDesc 指标描述
*/
function tableGenerationDimColumnHtml(dimColumnId,dimColumnName,dimColumnDesc){
	var tableDimColumnHtmlStr='';
	tableDimColumnHtmlStr+='<li><p class="delBtn">';
	tableDimColumnHtmlStr+='<span id="tableDimColumn_'+dimColumnId+'" name="tableDimColumn_'+dimColumnName+'" class="dropText" title="'+dimColumnDesc+'">'+dimColumnDesc+'</span>';
	tableDimColumnHtmlStr+='<span><a href="javascript:void(0);" id="tableDimColumnCloseATag_'+dimColumnId+'" class="colbtn" onclick="tableRemoveDimColoumnLi(\''+dimColumnId+'\',\''+dimColumnName+'\',\''+dimColumnDesc+'\')">删除</a></span>';
	tableDimColumnHtmlStr+='</p></li>';
	tableDimColumnHtmlStr+='';
	return tableDimColumnHtmlStr;

}

/** 描述：向指标区域中添加指标
	参数：
		kpiColumnId 指标编码
		kpiColumnName 指标字段名称
		kpiColumnDesc 指标描述
*/
function tableInsertKpiColumn(kpiColumnId,kpiColumnName,kpiColumnDesc){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
	var continueFlag=true;
	
	var lastTrTd=$("#selectable_"+componentId+" tr:last>td:last");
	$('#selectable_'+componentId+' tr>td').removeClass("ui-selected");
	lastTrTd.addClass("ui-selected");
	if(lastTrTd.text()!=''){
		if(!tableInsertColumn(componentId,"right")){
			continueFlag=false;
		}
	}
	lastTrTd.removeClass("ui-selected");
	$('#selectable_'+componentId).selectable('refresh');
	
	
	if(continueFlag){
		if(!tableInsertKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc,true)){
			return false;
		}
		var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
		var tempLastRowCell=null;
		dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
		for(var a=0;a<dataKpiTrTd.length;a++){
			if($.trim($(dataKpiTrTd[a]).text())==''){
				var tablerowcode=$(dataKpiTrTd[a]).attr("istt").substring(2);
				$(dataKpiTrTd[a]).text(kpiColumnDesc);
				$(dataKpiTrTd[a]).attr("data-tableDataTdType","kpi");
				tempLastRowCell=tableFindLastRowCellByTdInd(componentId,$(dataKpiTrTd[a]).attr("tdInd"));
				$(tempLastRowCell).text(kpiColumnDesc);
				var info={};
				info.datacolid=kpiColumnId;
				info.datacolcode=kpiColumnName;
				info.datacoldesc=kpiColumnDesc;
				info.tablecoldesc=kpiColumnDesc;
				var extcolumnid = $("#tableColumn_C"+kpiColumnName).attr("extcolumnid");
				extcolumnid = extcolumnid==undefined?"":extcolumnid;
				info.extcolumnid=extcolumnid;
				TableEvent.setKpiCol(reportId,containerId,componentId,tablerowcode,$(tableFirstTrTh[a+1]).text(),info);
				break;
			}
		}
		tableEnableOrDisabledSelectAllCol();
	}
	
}
/** 描述：向指标区域中添加指标的html部分
	参数：
		kpiColumnId 指标编码
		kpiColumnName 指标字段名称
		kpiColumnDesc 指标描述
		checkExist 是否检验存在不存在
*/
function tableInsertKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc,checkExist){
	var tableDimColumnUl=$("#tableDimColumnDiv>ul");
	var tableKpiColumnUl=$("#tableKpiColumnDiv>ul");
	if(checkExist){
		if(tableKpiColumnUl.find("li span[id='tableKpiColumn_"+kpiColumnId+"']").size()>0){
			$.messager.alert("基础表格","选择无效，在指标区域中已存在该指标！","error");
			return false;
		}
		if(tableDimColumnUl.find("li span[id='tableDimColumn_"+kpiColumnId+"']").size()>0){
			$.messager.alert("基础表格","选择无效，在维度区域中已存在该指标！","error");
			return false;
		}
	}else{
		var tableDimColumnUlLiSpan=tableDimColumnUl.find("li span[id='tableDimColumn_"+kpiColumnId+"']");
		if(tableDimColumnUlLiSpan.size()>0){
			for(var a=0;a<tableDimColumnUlLiSpan.size();a++){
				$(tableDimColumnUlLiSpan[a]).parent().parent().remove();
			}
		}
		
		var tableKpiColumnUlLiSpan=tableKpiColumnUl.find("li span[id='tableKpiColumn_"+kpiColumnId+"']");
		if(tableKpiColumnUlLiSpan.size()>0){
			for(var a=0;a<tableKpiColumnUlLiSpan.size();a++){
				$(tableKpiColumnUlLiSpan[a]).parent().rparent().emove();
			}
		}
	}
	var tableKpiColumnHtmlStr=tableGenerationKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc);//向指标区域中添加指标的html代码
	tableKpiColumnUl.append(tableKpiColumnHtmlStr);
	
	return true;
	
}
/** 描述：生成向指标区域中添加指标的html代码（为了保证插入html的js的惟一性而独立出来的）
	参数：
		kpiColumnId 指标编码
		kpiColumnName 指标字段名称
		kpiColumnDesc 指标描述
*/
function tableGenerationKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc){
	var tableKpiColumnHtmlStr='';
	tableKpiColumnHtmlStr+='<li><p class="delBtn">';
	tableKpiColumnHtmlStr+='<span id="tableKpiColumn_'+kpiColumnId+'" name="tableKpiColumn_'+kpiColumnName+'" class="dropText" title="'+kpiColumnDesc+'">'+kpiColumnDesc+'</span>';
	tableKpiColumnHtmlStr+='<span><a href="javascript:void(0);" class="colbtn" id="tableKpiColumnCloseATag_'+kpiColumnId+'" onclick="tableRemoveKpiColoumnLi(\''+kpiColumnId+'\',\''+kpiColumnName+'\',\''+kpiColumnDesc+'\')">删除</a></span>';
	tableKpiColumnHtmlStr+='</p></li>';
	return tableKpiColumnHtmlStr;

}
/** 描述：向指标区域中添加多个指标
	参数：
		columnList 对象数组，每个对象都有columnId,columnName,columnDesc三个属性
*/
function tableInsertMoreKpiColumn(columnList){
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	
	var tableKpiColumnUl=$("#tableKpiColumnDiv>ul");
	var kpiColumnId;
	var kpiColumnName;
	var kpiColumnDesc;
	var extcolumnid;
	var continueFlag=true;
	for(var i=0;i<columnList.length;i++){
		kpiColumnId=columnList[i]["columnId"];
		kpiColumnName=columnList[i]["columnName"];
		kpiColumnDesc=columnList[i]["columnDesc"];
		extcolumnid = columnList[i]["extcolumnid"]
		$("input[id^='tableColumnCheckbox_"+kpiColumnId+"']").iCheck('check');
		var tableKpiColumnHtmlStr=tableGenerationKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc);
		tableKpiColumnUl.append(tableKpiColumnHtmlStr);
	
		var dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
		var hasInsertCellFlag=false;
		for(var a=0;a<dataKpiTrTd.length;a++){
			if($.trim($(dataKpiTrTd[a]).text())==''){
				hasInsertCellFlag=true;
			}
		}
		continueFlag=true;
		if(!hasInsertCellFlag){
			$("#selectable_"+componentId+" tr>td").removeClass("ui-selected");
			var tempLastTrTr=$("#selectable_"+componentId+" tr:last>td:last");
			tempLastTrTr.addClass("ui-selected");
			if(!tableInsertColumn(componentId,"right")){
				continueFlag=false;
				break;
			}
			tempLastTrTr.removeClass("ui-selected");
			$('#selectable_'+componentId).selectable('refresh');
			
		}
		
		var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
		var tempLastRowCell=null;
		dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
		for(var a=0;a<dataKpiTrTd.length;a++){
			if($.trim($(dataKpiTrTd[a]).text())==''){
				var tablerowcode=$(dataKpiTrTd[a]).attr("istt").substring(2);
				$(dataKpiTrTd[a]).text(kpiColumnDesc);
				$(dataKpiTrTd[a]).attr("data-tableDataTdType","kpi");
				tempLastRowCell=tableFindLastRowCellByTdInd(componentId,$(dataKpiTrTd[a]).attr("tdInd"));
				$(tempLastRowCell).text(kpiColumnDesc);
				
				var cellInfo={};
				cellInfo.datacolid=kpiColumnId;
				cellInfo.datacolcode=kpiColumnName;
				cellInfo.datacoldesc=kpiColumnDesc;
				cellInfo.datacoltype="kpi";
				cellInfo.tablecoldesc=kpiColumnDesc;
				cellInfo.tablerowcode=tablerowcode;
				cellInfo.tablecolcode=$(tableFirstTrTh[a+1]).text();
				cellInfo.extcolumnid = extcolumnid;
				cellInfoList.push(cellInfo);
				break;
			}
		}
	}
	tableEnableOrDisabledSelectAllCol();
	if(continueFlag){
		TableEvent.setMoreKpiCol(reportId,containerId,componentId,cellInfoList);
	}
	
	
}


/** 描述：向排序区域中添加指标
	参数：
		sortColumnId 指标编码
		sortColumnName 指标字段名称
		sortColumnDesc 指标描述
*/
function tableInsertSortColumn(sortColumnId,sortColumnName,sortColumnDesc){
	if(!tableInsertSortColumnHtml(sortColumnId,sortColumnName,sortColumnDesc,true)){
		return false;
	}	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var info={};
	var kpiType='dim';
	var modeStr='asc';
	if($("#tableDimColumn_"+sortColumnId).size()!=0){
		kpiType='dim';
		modeStr='asc';
	}else if($("#tableKpiColumn_"+sortColumnId).size()!=0||$("#tableColumn_C"+sortColumnName).attr("extcolumnid")!=undefined){
		kpiType='kpi';
		modeStr='desc';
	}
	$("#tableSortColumnTypeATag_"+kpiType+"_"+sortColumnId).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
	$("#tableSortColumnATag_"+modeStr+"_"+sortColumnId).show().siblings("a[id^='tableSortColumnATag_']").hide();
	
	info.id=sortColumnId;
	info.col=sortColumnName;
	info.desc=sortColumnDesc;
	info.type=modeStr;
	info.kpitype=kpiType;
	var extcolumnid = $("#tableColumn_C"+sortColumnName).attr("extcolumnid");
	extcolumnid = extcolumnid==undefined?"":extcolumnid;
	info.extcolumnid=extcolumnid;
	TableEvent.setSortCol(reportId,containerId,componentId,info);
}

/** 描述：向排序区域中添加指标的html部分
	参数：
		sortColumnId 指标编码
		sortColumnName 指标字段名称
		sortColumnDesc 指标描述
		checkExist 是否检验存在不存在
*/
function tableInsertSortColumnHtml(sortColumnId,sortColumnName,sortColumnDesc,checkExist){
	var tableSortColumnUl=$("#tableSortColumnDiv>ul");
	if(checkExist){
		if(tableSortColumnUl.find("li span[id='tableSortColumn_"+sortColumnId+"']").size()>0){
			$.messager.alert("基础表格","选择无效，该默认排序列已存在！","error");
			return false;
		}
	}
	var tableSortColumnHtmlStr=tableGenerationSortColumnHtml(sortColumnId,sortColumnName,sortColumnDesc);
	tableSortColumnUl.append(tableSortColumnHtmlStr);
	return true;
}

/** 描述：生成向默认排序区域中添加指标的html代码（为了保证插入html的js的惟一性而独立出来的）
	参数：
		kpiColumnId 指标编码
		kpiColumnName 指标字段名称
		kpiColumnDesc 指标描述
*/
function tableGenerationSortColumnHtml(sortColumnId,sortColumnName,sortColumnDesc){
	var tableSortColumnHtmlStr='';
	tableSortColumnHtmlStr+='<li><p class="delBtn threeBtn">';
	tableSortColumnHtmlStr+='<span id="tableSortColumn_'+sortColumnId+'" name="tableSortColumn_'+sortColumnName+'" class="dropText" title="'+sortColumnDesc+'">'+sortColumnDesc+'</span>';
	tableSortColumnHtmlStr+="<span>";
	tableSortColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"tableSortColumnTypeATag_dim_"+sortColumnId+"\"  class=\"nicewidth active\" onclick=\"tableSetSortKpiType('kpi','"+sortColumnId+"')\">维度</a>"
	tableSortColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"tableSortColumnTypeATag_kpi_"+sortColumnId+"\" class=\"nicepoint active\" style=\"display: none\" onclick=\"tableSetSortKpiType('dim','"+sortColumnId+"')\">指标</a>"
	tableSortColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"tableSortColumnATag_asc_"+sortColumnId+"\" class=\"upbtn active\" style=\"display: none\" onclick=\"tableSetSortMode('desc','"+sortColumnId+"',this)\">正</a>"
	tableSortColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"tableSortColumnATag_desc_"+sortColumnId+"\" class=\"downbtn active\" onclick=\"tableSetSortMode('asc','"+sortColumnId+"',this)\">倒</a>"
	tableSortColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"tableSortColumnCloseATag_"+sortColumnId+"\" class=\"colbtn\" onclick=\"tableRemoveSortColoumnLi('"+sortColumnId+"','"+sortColumnName+"','"+sortColumnDesc+"')\">删除</a>"
	tableSortColumnHtmlStr+="</span>"
	tableSortColumnHtmlStr+='</p></li>';
	return tableSortColumnHtmlStr;

}
/** 描述：修改排序区域排序字段的排序方式（正序、倒序）
	参数：
		modeStr 排序字符（asc/desc）
*/
function tableSetSortMode(modeStr,columnId,obj){
	//$(obj).addClass("active").siblings().removeClass("active");
	$("#tableSortColumnATag_"+modeStr+"_"+columnId).show().siblings("a[id^='tableSortColumnATag_']").hide();
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var sortObj={};
	sortObj.id=columnId;
	sortObj.type=modeStr;
	
	TableEvent.setSortMode(reportId,containerId,componentId,sortObj);
}

/** 描述：修改排序区域排序字段的类型（维度dim、指标kpi）
	参数：
		kpiType 指标类型
		columnId 指标编码
*/
function tableSetSortKpiType(kpiType,columnId){
	if($("#tableColumn_"+columnId).attr("extcolumnid")!=undefined){
		$.messager.alert("基础表格","计算列必须为指标类型,不能修改为维度类型！","error");
		return;
	}
	//$(obj).addClass("active").siblings().removeClass("active");
	$("#tableSortColumnTypeATag_"+kpiType+"_"+columnId).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var sortObj={};
	sortObj.id=columnId;
	sortObj.kpitype=kpiType;
	
	TableEvent.setSortKpiType(reportId,containerId,componentId,sortObj);
}


/**---------------------------------------------------------计算列开始-------------------------------------------------------*/

/**
 * 更新数据集UI
 */
function tableUpdataDatasetUI(action){
	var columnId = tableCaculateColumn.currentEditColumnObj.id;
	var columnName = tableCaculateColumn.currentEditColumnObj.name;
	//添加计算列成功后更新候选列区域
	if(action=="add"){
		var tableColumnUl=$("#tableColumnDiv>ul");
		var tableColumnHtmlStr=tableGenerationExtColumnDivLiHtml(columnId,columnName);
		tableColumnUl.append(tableColumnHtmlStr);
		tableInitColumnDiv();
		$("input[name='tableColumn']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	var columnId=$(this).attr("data-columnId");
		  	tableCheckTableColumn($(this).attr("data-columnId"),$(this).attr("data-columnName"),$(this).attr("data-columnDesc"));
		  	window.setTimeout(function(){ tableFlushColumnDiv(columnId);},1000); 
		});
		$("#tableColumn_C"+columnName).attr("extcolumnid",columnId);
		$.parser.parse($("#tableColumnDiv"));
	}else if(action=="edit"){//编辑计算列成功后更新候选列区域
		$("#tableColumnDiv span[extcolumnid="+columnId+"]").parent().prop('outerHTML', tableGenerationExtColumnDivLiHtml(columnId,columnName));
		tableInitColumnDiv();
		$("input[name='tableColumn']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	var columnId=$(this).attr("data-columnId");
		  	tableCheckTableColumn($(this).attr("data-columnId"),$(this).attr("data-columnName"),$(this).attr("data-columnDesc"));
		  	window.setTimeout(function(){ tableFlushColumnDiv(columnId);},1000); 
		});
		$.parser.parse($("#tableColumnDiv"));
		//下面代码实现，修改了指标时，维度区域指标区域排序区域和候选列区域要跟着联动功能
		var oldName = tableCaculateColumn.getColumnOldName();
		//更新表格模板上的数据
		if(oldName!=columnName){
			var componentId=StoreData.curComponentId;
			var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
			var dataTrTd=$("#selectable_"+componentId+" tr:last>td");
			var dataTitleTrTd = $("#selectable_"+componentId+" tr").eq($("#selectable_"+componentId+" tr").length-2).find("td");
			for(var a=0;a<dataTrTd.length;a++){
				if($(dataTrTd[a]).text()==oldName){
					$(dataTrTd[a]).text(columnName);
					if($(dataTitleTrTd[a]).text()==oldName){
						$(dataTitleTrTd[a]).text(columnName);
					}
					if($("span[name='tableKpiColumn_"+oldName+"']").size()>0){
						//保存指标改变到xml
						var tablerowcode=$(dataTrTd[a]).attr("istt").substring(2);
						var info={};
						info.datacolid="C"+columnName;
						info.datacolcode=columnName;
						info.datacoldesc=columnName;
						info.tablecoldesc=columnName;
						var extcolumnid = $("#tableColumn_C"+columnName).attr("extcolumnid");
						extcolumnid = extcolumnid==undefined?"":extcolumnid;
						info.extcolumnid=extcolumnid;
						TableEvent.setKpiCol(StoreData.xid,StoreData.curContainerId,componentId,tablerowcode,$(tableFirstTrTh[a+1]).text(),info);
					}
					
					if($("span[name='tableSortColumn_"+oldName+"']").size()>0){
						var info={};
						info.id="C"+oldName;
						info.col=columnName;
						info.desc=columnName;
						info.extcolumnid = columnId;
						info.newid="C"+columnName;
						TableEvent.setSortCol(StoreData.xid,StoreData.curContainerId,componentId,info);
					}
				}
			}
		}
		 
		if($("span[name='tableKpiColumn_"+oldName+"']").size()>0){
			$("#tableColumnCheckbox_C"+columnName).iCheck("check");
			if(oldName!=columnName){
				var columnHtml = tableGenerationKpiColumnHtml("C"+columnName,columnName,columnName);
				$("span[name='tableKpiColumn_"+oldName+"']").parent().parent().prop('outerHTML',columnHtml);
			}
		}
		if($("span[name='tableSortColumn_"+oldName+"']").size()>0){
			$("#tableColumnCheckbox_C"+columnName).iCheck("check");
			if(oldName!=columnName){
				var columnHtml = tableGenerationSortColumnHtml("C"+columnName,columnName,columnName);
				$("span[name='tableSortColumn_"+oldName+"']").parent().parent().prop('outerHTML',columnHtml);
			}
		}
	}else if(action=="remove"){//删除计算列成功后更新候选列区域
		var info = {reportId:StoreData.xid,extcolumnid:columnId};
		cn.com.easy.xbuilder.service.component.DatagridService.removeExtcolumn(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("基础表格","删除计算列出错！<br/>"+exception,"error");
			}else{
				var columnName = $("span[extcolumnid="+columnId+"]").text();
				$("span[extcolumnid="+columnId+"]").parent().remove();
				if($("#tableKpiColumn_C"+columnName).size()>0){
					tableRemoveKpiColoumnLi("C"+columnName,columnName,columnName);
				}
				if($("#tableSortColumn_C"+columnName).size()>0){
					tableRemoveSortColoumnLi("C"+columnName,columnName,columnName);
				}
			}
		});
	}
}


/**
 * 删除计算列
 * @param extcolumnid
 */
function tableRemoveExtcolumn(extcolumnid){
	tableCaculateColumn.removeCaculateCol(extcolumnid);
}

/**
 * 修改计算列
 * @param extcolumnid
 */
function tableEditExtcolumn(extcolumnid){
	tableCaculateColumn.init();
	tableCaculateColumn.open();
	tableCaculateColumn.currentAction="edit";
	tableCaculateColumn.switchEnable(true);
	tableCaculateColumn.closeWhenEditFinish=true;
	tableCaculateColumn.restoreCaculateColumn(extcolumnid);//回显计算列
}

/**-------------------------------------------------------计算列结束----------------------------------------------------------------------------------*/