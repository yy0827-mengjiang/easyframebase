/**
 * 打开指标库选择对话框
 */ 
function openTreegridKpiDialog(){
	  var cubeId = StoreData.cubeId;
	  treegridKpiSelector.open(cubeId);
}

/** 描述：显示指标库选择窗口
	参数：
		
*/
function treeTableSelectCol(){
	treeTableColSelectorWin_openDialog();
	hideToolsPanel();
}

/** 描述：还原方法的回调函数
	参数：
		data json数据
*/
function treeTableComponentEditBack(data){
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
			$("#treeTableTitle").val(''); 
		}else{ 
			$("#treeTableTitle").val(title);
		}
		/*设置显示标题*/
		var showTitle = jsonObj.showTitle;
		if(showTitle=='0'){
			$('#treeTableShowTitle').iCheck("uncheck");
		}else{ 
			$('#treeTableShowTitle').iCheck("check");
		}
		/*设置分页*/
		var treeTablePagi=jsonObj.tablepagi;
		if(typeof(treeTablePagi)!="undefined"&&treeTablePagi=='1'){
			$("#treeTablePagi").iCheck('check');
		}else{ 
			$("#treeTablePagi").iCheck('uncheck'); 
		}
		
		/*设置导出*/
		var treeTableExport=jsonObj.tableexport;
		if(typeof(treeTableExport)!="undefined"&&treeTableExport=='1'){
			$("#treeTableExport").iCheck('check');
		}else{ 
			$("#treeTableExport").iCheck('uncheck');
		}
		
		/*设置维度区域、指标区域*/
		var datastore=jsonObj.datastore;
		var dataColList=null;
		var tempDataColId=null;
		var tempDataColColumn=null;
		var tempDataColDesc=null;
		var tempDataColType=null;
		if(typeof(datastore)!="undefined"&&datastore!=null&&datastore!='null'){
			dataColList=datastore.datacolList;
			if(typeof(dataColList)!="undefined"&&dataColList!=null&&dataColList!='null'){
				for(var i=0;i<=dataColList.length;i++){
					for(var a=0;a<dataColList.length;a++){
						if(thShowArray[i]==dataColList[a]["tablecolcode"]&&(dataColList[a]["datacoltype"]=='dim'||dataColList[a]["datacoltype"]=='kpi')){
							if(dataColList[a]["extcolumnid"]!=""){
								tempDataColId=dataColList[a]["extcolumnid"];
								tempDataColColumn=dataColList[a]["extcolumnid"];
							}else{
								tempDataColId=dataColList[a]["datacolid"];
								tempDataColColumn=dataColList[a]["datacolcode"];
							}
							tempDataColDesc=dataColList[a]["datacoldesc"];
							tempDataColType=dataColList[a]["datacoltype"];
							if(typeof(tempDataColId)!="undefined"&&tempDataColId!=null&&tempDataColId!='null'){
								if(tempDataColType=='dim'){
									treeTableInsertDimColumnHtml(tempDataColId,tempDataColColumn,tempDataColDesc,false);
								}else if(tempDataColType=='kpi'){
									treeTableInsertKpiColumnHtml(tempDataColId,tempDataColColumn,tempDataColDesc,false);
								}
							}
							break;
							
						}
						
					}
				
				}
				
			}
		}
		
		/*设置下钻区域*/
		var subdrills=jsonObj.subdrills;
		var subdrillColList=null;
		var subdrillColId=null;
		var subdrillColColumn=null;
		var subdrillColDesc=null;
		if(typeof(subdrills)!="undefined"&&subdrills!=null&&subdrills!='null'){
			subdrillColList=subdrills.subdrillList;
			if(typeof(subdrillColList)!="undefined"&&subdrillColList!=null&&subdrillColList!='null'){
				for(var i=0;i<subdrillColList.length;i++){
					subdrillColId=subdrillColList[i]["drillcolcodeid"];
					subdrillColColumn=subdrillColList[i]["drillcoldesc"];
					subdrillColDesc=subdrillColList[i]["drillcoltitle"];
					treeTableInsertDrillColumnHtml(subdrillColId,subdrillColColumn,subdrillColDesc,false);//向下钻区域插入数据
					
				}
			}
		}
				
	}
	
	/*设置kpistore*/
	var datasourceId=jsonObj.datasourceid;
	var kpistoreJson=$.ajax({url: appBase+"/getOneKpiStoreColsJsonX.e?report_id="+reportId+"&report_sql_id="+datasourceId,type:"POST",cache: false,async: false}).responseText;
	if(kpistoreJson!=null&&kpistoreJson!=undefined&&kpistoreJson!=''&&kpistoreJson!='null'){
		$("#treeTableKpiStoreDiv").attr("data-kpiStoreJson",kpistoreJson);
	}
	treeTableInitDimColumnDiv();
	treeTableInitKpiColumnDiv();
	treeTableInitDrillColumnDiv();
}


/** 描述：打开数据单元格的链接的设置参数的面板
	参数：
	
*/
function treeTableDataOpenEventLinkParamDialog(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var treeTableDataEventLink=$("#treeTableDataEventLink").val();
	if(treeTableDataEventLink==''){
		$.messager.alert("下钻表格","请先选择一个报表后再设置参数！","error");
		return false;
	}
	$("#treeTableDataEventLinkParamCareSpan").html("注意：“对应数据列”中请选择维度，不能选择指标！");
	var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+treeTableDataEventLink,type:"POST",cache: false,async: false}).responseText;
	dimsionsJson=$.parseJSON(dimsionsJson);
	
	var datasourceId=$.ajax({url: appBase+"/getDataSourceIdJsonX.e?reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId,type:"POST",cache: false,async: false}).responseText;
	
	var columnsJson=$.ajax({url: appBase+"/getOneKpiStoreHasSetDimColsJsonX.e?report_id="+reportId+"&report_sql_id="+datasourceId+'&containerId='+containerId+'&componentId='+componentId,type:"POST",cache: false,async: false}).responseText;
	columnsJson=$.parseJSON(columnsJson);

	var subdrillJson=$.ajax({url: appBase+"/getAllSubdrillsJsonJsonX.e?report_id="+reportId+'&containerId='+containerId+'&componentId='+componentId,type:"POST",cache: false,async: false}).responseText;
	subdrillJson=$.parseJSON(subdrillJson);
	
	var info={};
	info['kpicolumn']='请选择';
	info['kpidesc']='请选择';
	columnsJson.unshift(info);
	
	var isHasSameEventJsonFlag=true;
	var treeTableEventSelectJsonStr='';
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		if(a==0){
			treeTableEventSelectJsonStr=$($selectTds[a]).attr("data-treeTableEventSelectJson");
		}
		/*是否都是有相同的事件json数据 */
		if(treeTableEventSelectJsonStr!=$($selectTds[a]).attr("data-treeTableEventSelectJson")){
			isHasSameEventJsonFlag=false;
		}
	}
	var parameterList=[];
	if(isHasSameEventJsonFlag){
		if(treeTableEventSelectJsonStr==undefined||treeTableEventSelectJsonStr==''||treeTableEventSelectJsonStr==null||treeTableEventSelectJsonStr=='null'){
			treeTableEventSelectJsonStr='{}';
		}
		var treeTableEventSelectJson=$.parseJSON(treeTableEventSelectJsonStr);
		
		if(treeTableEventSelectJson!=null){
			var eventList=treeTableEventSelectJson["eventList"];
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
		$("#treeTableDataEventLinkParamtreeTable").html("");
		
		
	}
	for(var a=0;a<dimsionsJson.length;a++){
		var dimsionId=dimsionsJson[a]["id"];
		var name=dimsionsJson[a]["varname"];
		var nameDesc=dimsionsJson[a]["desc"];
		var value='请选择';
		var valueData=columnsJson;
		var valueField='kpicolumn';
		var TextField='kpidesc';
		var hasExistInTreeFlag=false;
		for(var b=0;b<subdrillJson.length;b++){
			if(name==subdrillJson[b]["drillcode"]){
				hasExistInTreeFlag=true;
				break;
			}
		}
		if(hasExistInTreeFlag){
			continue;
		}
		if(parameterList.length==0){
			for(var x=0;x<columnsJson.length;x++){
				if(columnsJson[x]['kpicolumn'].toLowerCase()==name.toLowerCase()){
					value=columnsJson[x]['kpicolumn'];
					break;
				}
				if(columnsJson[x]['kpicolumn'].replace(/_/g,"").toLowerCase()==name.toLowerCase()){
					value=columnsJson[x]['kpicolumn'];
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
		
		treeTableDataOpenEventLinkParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField);
	}
	
	
	$("#treeTableDataEventLinkParamDialog").dialog("open");
	hideToolsPanel();
}

/** 描述：打开数据单元格的联动的设置参数的面板
	参数：
	
*/
function treeTableDataOpenEventActiveDialog(eventComponetId,eventEventId){
	$("#treeTableDataEventActiveParamCareSpan").html("注意：“对应数据列”中请选择维度，不能选择指标！");
	treeTableCurrentEvnetCompenentId=eventComponetId;
	treeTableCurrentEvnetEventId=eventEventId;
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+reportId+'&isTempFile=1',type:"POST",cache: false,async: false}).responseText;
	dimsionsJson=$.parseJSON(dimsionsJson);
	
	var datasourceId=$.ajax({url: appBase+"/getDataSourceIdJsonX.e?reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId,type:"POST",cache: false,async: false}).responseText;
	
	var columnsJson=$.ajax({url: appBase+"/getOneKpiStoreHasSetDimColsJsonX.e?report_id="+reportId+"&report_sql_id="+datasourceId+'&containerId='+containerId+'&componentId='+componentId,type:"POST",cache: false,async: false}).responseText;
	columnsJson=$.parseJSON(columnsJson);
	
	var subdrillJson=$.ajax({url: appBase+"/getAllSubdrillsJsonJsonX.e?report_id="+reportId+'&containerId='+containerId+'&componentId='+componentId,type:"POST",cache: false,async: false}).responseText;
	subdrillJson=$.parseJSON(subdrillJson);
	
	var info={};
	info['kpicolumn']='请选择';
	info['kpidesc']='请选择';
	columnsJson.unshift(info);
	var isHasSameEventJsonFlag=true;
	var treeTableEventSelectJsonStr='';
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		if(a==0){
			treeTableEventSelectJsonStr=$($selectTds[a]).attr("data-treeTableEventSelectJson");
		}
		if(treeTableEventSelectJsonStr!=$($selectTds[a]).attr("data-treeTableEventSelectJson")){
			isHasSameEventJsonFlag=false;
		}
	}
	var parameterList=[];
	if(isHasSameEventJsonFlag){
		if(treeTableEventSelectJsonStr==undefined||treeTableEventSelectJsonStr==''||treeTableEventSelectJsonStr==null||treeTableEventSelectJsonStr=='null'){
			treeTableEventSelectJsonStr='{}';
		}
		var treeTableEventSelectJson=$.parseJSON(treeTableEventSelectJsonStr);
		
		if(treeTableEventSelectJson!=null){
			var eventList=treeTableEventSelectJson["eventList"];
			if(eventList!=undefined&&eventList!=null&&eventList!=''&&eventList!='null'&&eventList.length>0){
				var event=null;
				for(var x=0;x<eventList.length;x++){
					if(eventList[x]["id"]==treeTableCurrentEvnetEventId&&eventList[x]["source"]==treeTableCurrentEvnetCompenentId){
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
	
	$("#treeTableDataEventActiveParamtreeTable").html("");
	
	for(var a=0;a<dimsionsJson.length;a++){
		var dimsionId=dimsionsJson[a]["id"];
		var name=dimsionsJson[a]["varname"];
		var nameDesc=dimsionsJson[a]["desc"];
		var value='请选择';
		var valueData=columnsJson;
		var valueField='kpicolumn';
		var TextField='kpidesc';
		var hasExistInTreeFlag=false;
		for(var b=0;b<subdrillJson.length;b++){
			if(name==subdrillJson[b]["drillcode"]){
				hasExistInTreeFlag=true;
				break;
			}
		}
		if(hasExistInTreeFlag){
			continue;
		}
		if(parameterList.length==0){
			for(var x=0;x<columnsJson.length;x++){
				if(columnsJson[x]['kpicolumn'].toLowerCase()==name.toLowerCase()){
					value=columnsJson[x]['kpicolumn'];
					break;
				}
				if(columnsJson[x]['kpicolumn'].replace(/_/g,"").toLowerCase()==name.toLowerCase()){
					value=columnsJson[x]['kpicolumn'];
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
		treeTableDataOpenEventActiveParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField);
	}
	
	$("#treeTableDataEventActiveParamDialog").dialog("open");
	hideToolsPanel();
}



/** 描述：保存指标库中一个指标到div#treeTableKpiStoreDiv元素下
	参数：
		kpiid 指标编码
		kpicolumn 指标字段
		kpidesc 指标描述
		kpitype 指标类型
*/
function treeTableInsertKpiStore(kpiid,kpicolumn,kpidesc,kpitype){
	var kpiStoreJson=$("#treeTableKpiStoreDiv").attr("data-kpiStoreJson");
	if(kpiStoreJson==null||kpiStoreJson==undefined){
		kpiStoreJson=[];
	}else{
		kpiStoreJson=$.parseJSON(kpiStoreJson);
	}
	
	var hasExitFlag=false;
	for(var i=0;i<kpiStoreJson.length;i++){
		if(kpiStoreJson[i]!=null&&kpiStoreJson[i]["kpiid"]==kpiid){
			hasExitFlag=true;
			break;
		}
	}
	if(!hasExitFlag){
		var info={};
		info.kpiid=kpiid;
		info.kpicolumn=kpicolumn;
		info.kpidesc=kpidesc;
		info.kpitype=kpitype;
		kpiStoreJson.push(info);
		$("#treeTableKpiStoreDiv").attr("data-kpiStoreJson",$.toJSON(kpiStoreJson));
	}
	
}

/** 描述：从div#treeTableKpiStoreDiv元素中移除一个指标库指标
	参数：
		kpiid 指标编码
*/
function treeTableRemoveKpiStore(kpiid){
	var kpiStoreJson=$("#treeTableKpiStoreDiv").attr("data-kpiStoreJson");
	if(kpiStoreJson==null||kpiStoreJson==undefined){
		kpiStoreJson=[];
	}else{
		kpiStoreJson=$.parseJSON(kpiStoreJson);
	}
	var existNum=0;
	var columnLis;
	columnLis=$("#treeTableDimColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		if($(columnLis[a]).find("span").eq(0).attr("id")==("treeTableDimColumn_"+kpiid)){
			existNum++;
		}
	}
	columnLis=$("#treeTableKpiColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		if($(columnLis[a]).find("span").eq(0).attr("id")==("treeTableKpiColumn_"+kpiid)){
			existNum++;
		}
	}
	columnLis=$("#treeTableDrillColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		if($(columnLis[a]).find("span").eq(0).attr("id")==("treeTableDrillColumn_"+kpiid)){
			existNum++;
		}
	}
	if(existNum<1){
		for(var i=0;i<kpiStoreJson.length;i++){
			if(kpiStoreJson[i]!=null&&kpiStoreJson[i]["kpiid"]==kpiid){
				kpiStoreJson[i]=null;
				break;
			}
		}
	    $("#treeTableKpiStoreDiv").attr("data-kpiStoreJson",$.toJSON(kpiStoreJson));
	}
}


/** 描述：向可被选择的指标区域添加记录
	参数：
		operateXmlFlag 是否操作xml源数据
		backFun	回调函数
*/
function treeTableInsertMoreKpiStoreColumn(operateXmlFlag,backFun){
	var info={};
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var treeTableAddColumnArray=[];
	var kpiStoreJson=$("#treeTableKpiStoreDiv").attr("data-kpiStoreJson");
	if(kpiStoreJson==null||kpiStoreJson==undefined){
		kpiStoreJson=[];
	}else{
		kpiStoreJson=$.parseJSON(kpiStoreJson);
	}
	
	for(var a=0;a<kpiStoreJson.length;a++){
		if(kpiStoreJson[a]!=null){
			var info={};
			info["id"]=kpiStoreJson[a]["kpiid"];
			info["column"]=kpiStoreJson[a]["kpicolumn"];
			info["name"]=kpiStoreJson[a]["kpidesc"];
			info["kpiType"]=kpiStoreJson[a]["kpitype"];
			treeTableAddColumnArray.push(info);
		}
		
	}
	
	if(operateXmlFlag){
		//if(treeTableAddColumnArray.length>0){
			TreeTableEvent.addMoreKpiStoreCols(reportId,containerId,componentId,treeTableAddColumnArray,backFun);
		//}
	}
	
	
}


/** 描述：设置标题
	参数：
		titleValue 标题内容
*/
function treeTableSetTitle(titleValue){
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	treeTableHideColSelectorWin();//关闭指标列表窗口
	TreeTableEvent.setTitle(reportId,containerId,componentId,titleValue);
}
/** 描述：设置显示标题
	参数：
		
*/
function treeTableSetShowTitle(){
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#treeTableShowTitle").attr("checked")!='checked'){
		resultValue='1';
	}
	treeTableHideColSelectorWin();//关闭指标列表窗口
	TreeTableEvent.setShowTitleFlag(reportId,containerId,componentId,resultValue);
}

/** 描述：是否允许分页
	参数：
*/
function treeTableSetPagi(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#treeTablePagi").attr("checked")!='checked'){
		resultValue='1';
	}
	TreeTableEvent.setPagiFlag(reportId,containerId,componentId,resultValue);
}

/** 描述：是否允许导出数据
	参数：
*/
function treeTableSetExport(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#treeTableExport").attr("checked")!='checked'){
		resultValue='1';
	}
	treeTableHideColSelectorWin();//关闭指标列表窗口
	TreeTableEvent.setExportFlag(reportId,containerId,componentId,resultValue);
}


/** 描述：维度区域和指标区域的sortable的start事件执行的方法
	参数：
		
*/
function treeTableSortStartFun(event, ui){
	treeTableSortStartArray=[];
	treeTableSortStartTypeArray=[];
	var tempIndex=0;
	var columnLis=null;
	columnLis=$("#treeTableDimColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		treeTableSortStartArray[tempIndex]=$(columnLis[a]).find("span").eq(0).text();
		treeTableSortStartTypeArray[tempIndex]='dim';
		tempIndex++;
	}
	columnLis=$("#treeTableKpiColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		treeTableSortStartArray[tempIndex]=$(columnLis[a]).find("span").eq(0).text();
		treeTableSortStartTypeArray[tempIndex]='kpi';
		tempIndex++;
	}
	columnLis=$("#treeTableDrillColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		treeTableSortStartArray[tempIndex]=$(columnLis[a]).find("span").eq(0).text();
		treeTableSortStartTypeArray[tempIndex]='drill';
		tempIndex++;
	}
}
/** 描述：维度区域和指标区域的sortable的stop事件执行的方法
	参数：
		
*/
function treeTableSortStopFun(event, ui){
	treeTableSortEndArray=[];
	var currentItem=ui.item.find("span").eq(0).text();
	var continueFlag=true;
	var sourceType='';//源li的类型(dim,kpi,drill)
	var targetType='';//目标li的类型(dim,kpi,drill)
	var tempIndex=0;
	var columnLis=null;
	var tempUlLi=null;
	var tempUlLiSpan=null;
	var startNum=0;
	var endNum=0;
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillUlLiList=$("#treeTableDrillColumnDiv>ul>li");
	var dimUlLiList=$("#treeTableDimColumnDiv>ul>li");
	var kpiUlLiList=$("#treeTableKpiColumnDiv>ul>li");
	var columnId,columnColumn,columnName,columnStr;
	
	/*维度*/
	for(var a=0;a<dimUlLiList.length;a++){
		tempUlLi=$(dimUlLiList[a]);
		tempUlLiSpan=tempUlLi.find("span").eq(0)
		if(tempUlLiSpan.text()==currentItem){
			if(tempUlLiSpan.attr("id").indexOf("treeTableDimColumn_")>-1){
				endNum=a;
				targetType='dim';
				sourceType='dim';
			
			}else if(tempUlLiSpan.attr("id").indexOf("treeTableKpiColumn_")>-1){
				endNum=a;
				targetType='dim';
				sourceType='kpi';
				columnId=tempUlLiSpan.attr("id").substring("treeTableKpiColumn_".length);
				columnColumn=tempUlLiSpan.attr("name").substring("treeTableKpiColumn_".length);
				if(columnId == columnColumn){
					$("#treeTableKpiColumnDiv>ul").sortable( 'cancel' );
					$.messager.alert("下钻表格","计算列不能做维度列！","error");
					return;
				}
				columnName=tempUlLiSpan.text();
				columnStr=treeTableGenerationDimColumnHtml(columnId,columnColumn,columnName);
				$("#treeTableKpiColumn_"+columnId).parent().parent().html($(columnStr).html());
				break;
			}else if(tempUlLiSpan.attr("id").indexOf("treeTableDrillColumn_")>-1){
				endNum=a;
				targetType='dim';
				sourceType='drill';
				columnId=tempUlLiSpan.attr("id").substring("treeTableDrillColumn_".length);
				columnColumn=tempUlLiSpan.attr("name").substring("treeTableDrillColumn_".length);
				if(columnId == columnColumn){
					$("#treeTableDrillColumnDiv>ul").sortable( 'cancel' );
					$.messager.alert("下钻表格","计算列不能做维度列！","error");
					return;
				}
				columnName=tempUlLiSpan.text();
				columnStr=treeTableGenerationDimColumnHtml(columnId,columnColumn,columnName);
				
				var dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
				var insertContinueFlag=true;
				
				var lastTrTd=$("#selectable_"+componentId+" tr:last>td:last");
				$('#selectable_'+componentId+' tr>td').removeClass("ui-selected");
				lastTrTd.addClass("ui-selected");
				if(lastTrTd.text()!=''){
					if(!treeTableInsertColumn(componentId,"right")){
						insertContinueFlag=false;
					}
				}
				lastTrTd.removeClass("ui-selected");
				$('#selectable_'+componentId).selectable('refresh');
				
				
				if(insertContinueFlag){
					var tempLastRowCell=null;
					dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
					for(var i=0;i<dataKpiTrTd.length;i++){
						if($.trim($(dataKpiTrTd[i]).text())==''){
							var treeTablerowcode=$(dataKpiTrTd[i]).attr("istt").substring(2);
							$(dataKpiTrTd[i]).text(columnName);
							$(dataKpiTrTd[i]).attr("data-treeTableDataTdType","kpi");
							tempLastRowCell=treeTableFindLastRowCellByTdInd(componentId,$(dataKpiTrTd[i]).attr("tdInd"));
							$(tempLastRowCell).text(columnName);
							break;
						}
					}
					
				}
				
				$("#treeTableDrillColumn_"+columnId).parent().parent().html($(columnStr).html());
				startNum=dimUlLiList.size()+kpiUlLiList.size()-1;
				break;
			}
			
		}
	}
	/*指标*/
	for(var a=0;a<kpiUlLiList.length;a++){
		tempUlLi=$(kpiUlLiList[a]);
		tempUlLiSpan=tempUlLi.find("span").eq(0)
		if(tempUlLiSpan.text()==currentItem){
			if(tempUlLiSpan.attr("id").indexOf("treeTableKpiColumn_")>-1){
				endNum=dimUlLiList.length+a;
				targetType='kpi';
				sourceType='kpi';
			
			}else if(tempUlLiSpan.attr("id").indexOf("treeTableDimColumn_")>-1){
				endNum=dimUlLiList.length+a;
				targetType='kpi';
				sourceType='dim';
				columnId=tempUlLiSpan.attr("id").substring("treeTableDimColumn_".length);
				columnColumn=tempUlLiSpan.attr("name").substring("treeTableDimColumn_".length);
				columnName=tempUlLiSpan.text();
				columnStr=treeTableGenerationKpiColumnHtml(columnId,columnColumn,columnName);
				$("#treeTableDimColumn_"+columnId).parent().parent().html($(columnStr).html());
				break;
			}else if(tempUlLiSpan.attr("id").indexOf("treeTableDrillColumn_")>-1){
				endNum=dimUlLiList.length+a;
				targetType='kpi';
				sourceType='drill';
				columnId=tempUlLiSpan.attr("id").substring("treeTableDrillColumn_".length);
				columnColumn=tempUlLiSpan.attr("name").substring("treeTableDrillColumn_".length);
				columnName=tempUlLiSpan.text();
				columnStr=treeTableGenerationKpiColumnHtml(columnId,columnColumn,columnName);
				
				var dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
				var insertContinueFlag=true;
				
				var lastTrTd=$("#selectable_"+componentId+" tr:last>td:last");
				$('#selectable_'+componentId+' tr>td').removeClass("ui-selected");
				lastTrTd.addClass("ui-selected");
				if(lastTrTd.text()!=''){
					if(!treeTableInsertColumn(componentId,"right")){
						insertContinueFlag=false;
					}
				}
				lastTrTd.removeClass("ui-selected");
				$('#selectable_'+componentId).selectable('refresh');
				
				
				if(insertContinueFlag){
					var tempLastRowCell=null;
					dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
					for(var i=0;i<dataKpiTrTd.length;i++){
						if($.trim($(dataKpiTrTd[i]).text())==''){
							var treeTablerowcode=$(dataKpiTrTd[i]).attr("istt").substring(2);
							$(dataKpiTrTd[i]).text(columnName);
							$(dataKpiTrTd[i]).attr("data-treeTableDataTdType","kpi");
							tempLastRowCell=treeTableFindLastRowCellByTdInd(componentId,$(dataKpiTrTd[i]).attr("tdInd"));
							$(tempLastRowCell).text(columnName);
							break;
						}
					}
					
				}
				
				$("#treeTableDrillColumn_"+columnId).parent().parent().html($(columnStr).html());
				startNum=dimUlLiList.size()+kpiUlLiList.size()-1;
				break;
			}
			
		}
	}
	/*下钻*/
	for(var a=0;a<drillUlLiList.length;a++){
		tempUlLi=$(drillUlLiList[a]);
		tempUlLiSpan=tempUlLi.find("span").eq(0)
		if(tempUlLiSpan.text()==currentItem){
			if(tempUlLiSpan.attr("id").indexOf("treeTableDrillColumn_")>-1){
				endNum=a;
				targetType='drill';
				sourceType='drill';
			
			}else if(tempUlLiSpan.attr("id").indexOf("treeTableDimColumn_")>-1){
				endNum=a;
				targetType='drill';
				sourceType='dim';
				columnId=tempUlLiSpan.attr("id").substring("treeTableDimColumn_".length);
				columnColumn=tempUlLiSpan.attr("name").substring("treeTableDimColumn_".length);
				columnName=tempUlLiSpan.text();
				columnStr=treeTableGenerationDrillColumnHtml(columnId,columnColumn,columnName);
				$("#treeTableDimColumn_"+columnId).parent().parent().html($(columnStr).html());
				treeTableRemoveDimColoumnLi(columnId,columnColumn,columnName);
				break;
			}else if(tempUlLiSpan.attr("id").indexOf("treeTableKpiColumn_")>-1){
				endNum=a;
				targetType='drill';
				sourceType='kpi';
				columnId=tempUlLiSpan.attr("id").substring("treeTableKpiColumn_".length);
				columnColumn=tempUlLiSpan.attr("name").substring("treeTableKpiColumn_".length);
				if(columnId == columnColumn){
					$("#treeTableKpiColumnDiv>ul").sortable( 'cancel' );
					$.messager.alert("下钻表格","计算列不能做下钻列！","error");
					return;
				}
				columnName=tempUlLiSpan.text();
				columnStr=treeTableGenerationDrillColumnHtml(columnId,columnColumn,columnName);
				$("#treeTableKpiColumn_"+columnId).parent().parent().html($(columnStr).html());
				treeTableRemoveKpiColoumnLi(columnId,columnColumn,columnName);
				break;
			}
		}
	}
	columnLis=$("#treeTableDimColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		treeTableSortEndArray[tempIndex]=$(columnLis[a]).find("span").eq(0).text();
		tempIndex++;
	}
	columnLis=$("#treeTableKpiColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		treeTableSortEndArray[tempIndex]=$(columnLis[a]).find("span").eq(0).text();
		tempIndex++;
	}
	columnLis=$("#treeTableDrillColumnDiv>ul>li");
	for(var a=0;a<columnLis.length;a++){
		treeTableSortEndArray[tempIndex]=$(columnLis[a]).find("span").eq(0).text();
		tempIndex++;
	}
	if(targetType=='dim'||targetType=='kpi'){//目标区域是维度或指标
		if(startNum==0){
			for(var b=0;b<treeTableSortStartArray.length;b++){
				if(currentItem==treeTableSortStartArray[b]&&treeTableSortStartTypeArray[b]==sourceType){
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
				
				$(columnTrtds[c]).attr("data-treeTableDataTdType",targetType);
			}
		}
		var insertColNum=0;
		if(endNum>startNum){
			insertColNum=currentColNum+(endNum-startNum);
		}else{
			insertColNum=currentColNum-(startNum-endNum);
		}
		
		var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
		var currentColCode=$(treeTableFirstTrTh[currentColNum]).text();
		var insertColCode=$(treeTableFirstTrTh[insertColNum]).text();
		treeTableMoveCell(componentId,currentRowNum,currentColCode,insertColCode);
		var removeColumnIds=[];
		removeColumnIds.push(columnId);
		
		var colInfo={};
		if(sourceType=='drill'){
			colInfo.datacolid=columnId;
			colInfo.datacolcode=columnColumn;
			colInfo.datacoldesc=columnName;
			colInfo.tablecoldesc=columnName;
		}
		colInfo.datacoltype=targetType;
		TreeTableEvent.moveColPostionAndRemoveDrill(reportId,containerId,componentId,currentRowNum,currentColCode,insertColCode,colInfo,removeColumnIds);
		
	}else if(targetType=='drill'||targetType==''){
		columnLis=$("#treeTableDrillColumnDiv>ul>li");
		var columnDrillInfoList=[];
		for(var a=0;a<columnLis.length;a++){
			tempUlLi=$(columnLis[a]);
			tempUlLiSpan=tempUlLi.find("span").eq(0);
			var drillColumnId=tempUlLiSpan.attr("id").substring("treeTableDrillColumn_".length);
			var drillColumnName=tempUlLiSpan.attr("name").substring("treeTableDrillColumn_".length);
			var drillColumnDesc=tempUlLiSpan.text();
			var info={};
			info.drillcolcodeid=drillColumnId;
			if(sourceType!='drill'){
				info.drillcode=drillColumnName+"";
				info.drillcolcode=drillColumnName+"_CODE";
				info.drillcoltitle=drillColumnDesc;
				info.drillcoldesc=drillColumnName;
				info.datasourceid=LayOutUtil.uuid();
				var drillcolSortcolList=[];
				var drillcolsortcol={};
				drillcolsortcol.colcode=info.drillcolcodeid;
				drillcolSortcolList.push(drillcolsortcol);
				info.drillcolSortcolList=drillcolSortcolList;
			}
			
			columnDrillInfoList.push(info);
			
		}
		if(columnDrillInfoList.length>0){
			TreeTableEvent.overWriteDrillCol(reportId,containerId,componentId,columnDrillInfoList);
		}
	}
	
}


/** 描述：初始化维度区域
	参数：
		
*/
function treeTableInitDimColumnDiv(){
	$('#treeTableDimColumnDiv').droppable({
		onDragEnter:function(e,source){
		},
		onDragLeave:function(e,source){
		},
		onDrop:function (e, source) {
			if($(source).attr("key")==undefined){//计算列窗口指标不能拖动到此div
				return;
			}
			var itemObj = null;
			if($(source).attr("node-id")==undefined){//指标库选择
				 itemObj = treegridKpiSelector.currentItem;
			}else{//计算列选择
				$.messager.alert("下钻表格","计算列不能做维度！","error");
				return;
			}
			var dimId=itemObj.id;
			var dimColumn=itemObj.column;
			var dimName=itemObj.desc;
			var dimKpiType=itemObj.kpiType;
			treeTableInsertKpiStore(dimId,dimColumn,dimName,dimKpiType);
			treeTableInsertDimColumn(dimId,dimColumn,dimName);
		}
	});
	var treeTableKpiColumnUl=$("#treeTableDimColumnDiv>ul");
	treeTableKpiColumnUl.sortable({
		connectWith: "#treeTableKpiColumnDiv>ul,#treeTableDrillColumnDiv>ul",
		start : function(event, ui){treeTableSortStartFun(event, ui);},
		stop:function(event, ui){treeTableSortStopFun(event, ui);	}
	});
	treeTableKpiColumnUl.disableSelection();
}

/** 描述：删除维度区域中维度记录
	参数：
		obj a标签对象
*/
function treeTableRemoveDimColoumnLi(columnId,columnName,columnDesc){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var dataDimTrTd=$("#selectable_"+componentId+" tr:last>td");
	var temptreeTablerowcode="";
	var temptreeTablecolcode="";
	var temptreeTableCellInd="";
	var tempLastRowCell=null;
	var tempReplaceCellColcode='';
	for(var a=0;a<dataDimTrTd.length;a++){
		if($(dataDimTrTd[a]).text()==columnDesc){
			tempReplaceCellColcode=$(treeTableFirstTrTh[dataDimTrTd.length]).text();
			temptreeTablerowcode=$(dataDimTrTd[a]).attr("istt").substring(2);
			temptreeTablecolcode=$(treeTableFirstTrTh[a+1]).text();
			temptreeTableCellInd=$(dataDimTrTd[a]).attr("tdInd");
			treeTableClearCell(componentId,temptreeTablerowcode,temptreeTablecolcode);
			tempLastRowCell=treeTableFindLastRowCellByTdInd(componentId,temptreeTableCellInd);
			treeTableClearCell(componentId,$(tempLastRowCell).attr("istt").substring(2),temptreeTablecolcode);
			treeTableMoveCell(componentId,temptreeTablerowcode,temptreeTablecolcode,tempReplaceCellColcode);
			if($("#treeTableDimColumn_"+columnId).size()>0){
				$("#treeTableDimColumn_"+columnId).parent().parent().remove();
			}
			treeTableRemoveKpiStore(columnId);
			TreeTableEvent.removeDimCol(reportId,containerId,componentId,temptreeTablecolcode);
			break;
		}
	}
	
}


/** 描述：初始化指标区域
	参数：
		
*/
function treeTableInitKpiColumnDiv(){
	$('#treeTableKpiColumnDiv').droppable({
		onDragEnter:function(e,source){
		},
		onDragLeave:function(e,source){
		},
		onDrop:function (e, source) {
			if($(source).attr("key")==undefined){//计算列窗口指标不能拖动到此div
				return;
			}
			var itemObj = null;
			if($(source).attr("node-id")==undefined){//指标库选择
				 itemObj = treegridKpiSelector.currentItem;
			}else{//计算列选择
				itemObj = {
						id:"extcolumn_"+$(source).attr("node-id"),
						column:$(source).attr("node-id"),
						desc:$(source).attr("desc"),
						kpiType:'extcolumn'
				}
			}
			
			var kpiId=itemObj.id;
			var kpiStoreId = kpiId.indexOf("extcolumn_")!=-1?kpiId.substring(10):kpiId;
			var kpiColumn=itemObj.column;
			var kpiName=itemObj.desc;
			var kpiKpiType=itemObj.kpiType;
			treeTableInsertKpiStore(kpiStoreId,kpiColumn,kpiName,kpiKpiType);
			treeTableInsertKpiColumn(kpiId,kpiColumn,kpiName);
		}
	});
	var treeTableKpiColumnUl=$("#treeTableKpiColumnDiv>ul");
	treeTableKpiColumnUl.sortable({
		connectWith: "#treeTableDimColumnDiv>ul,#treeTableDrillColumnDiv>ul",
		start : function(event, ui){treeTableSortStartFun(event, ui);},
		stop:function(event, ui){treeTableSortStopFun(event, ui);	}
	});
	treeTableKpiColumnUl.disableSelection();
}

/** 描述：删除指标区域中指标记录
	参数：
		obj a标签对象
*/
function treeTableRemoveKpiColoumnLi(columnId,columnName,columnDesc){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
	var temptreeTablerowcode="";
	var temptreeTablecolcode="";
	var temptreeTableCellInd="";
	var tempLastRowCell=null;
	var tempReplaceCellColcode='';
	for(var a=0;a<dataKpiTrTd.length;a++){
		if($(dataKpiTrTd[a]).text()==columnDesc){
			tempReplaceCellColcode=$(treeTableFirstTrTh[dataKpiTrTd.length]).text();
			temptreeTablerowcode=$(dataKpiTrTd[a]).attr("istt").substring(2);
			temptreeTablecolcode=$(treeTableFirstTrTh[a+1]).text();
			temptreeTableCellInd=$(dataKpiTrTd[a]).attr("tdInd");
			treeTableClearCell(componentId,temptreeTablerowcode,temptreeTablecolcode);
			tempLastRowCell=treeTableFindLastRowCellByTdInd(componentId,temptreeTableCellInd);
			treeTableClearCell(componentId,$(tempLastRowCell).attr("istt").substring(2),temptreeTablecolcode);
			treeTableMoveCell(componentId,temptreeTablerowcode,temptreeTablecolcode,tempReplaceCellColcode);
			if($("#treeTableKpiColumn_"+columnId).size()>0){
				$("#treeTableKpiColumn_"+columnId).parent().parent().remove();
			}
			treeTableRemoveKpiStore(columnId);
			TreeTableEvent.removeKpiCol(reportId,containerId,componentId,temptreeTablecolcode);
			break;
		}
	}
	
}

/** 描述：初始化默认下钻区域
	参数：
		
*/
function treeTableInitDrillColumnDiv(){
	$('#treeTableDrillColumnDiv').droppable({
		onDragEnter:function(e,source){
		},
		onDragLeave:function(e,source){
		},
		onDrop:function (e, source) {
			var itemObj = null;
			if($(source).attr("key")==undefined){//计算列窗口指标不能拖动到此div
				return;
			}
			if($(source).attr("node-id")==undefined){//指标库选择
				 itemObj = treegridKpiSelector.currentItem;
			}else{//计算列选择
				$.messager.alert("下钻表格","计算列不能做下钻列！","error");
				return;
			}
			var drillId=itemObj.id;
			var drillColumn=itemObj.column;
			var drillName=itemObj.desc;
			var drillKpiType=itemObj.kpiType;
			treeTableInsertKpiStore(drillId,drillColumn,drillName,drillKpiType);
			treeTableInsertDrillColumn(drillId,drillColumn,drillName);
		}
	  }
	);
	var treeTableDrillColumnUl=$("#treeTableDrillColumnDiv>ul");
	treeTableDrillColumnUl.sortable({
		connectWith: "#treeTableDimColumnDiv>ul,#treeTableKpiColumnDiv>ul",
		start : function(event, ui){treeTableSortStartFun(event, ui);},
		stop:function(event, ui){treeTableSortStopFun(event, ui);	}
	}).disableSelection();
}

/** 描述：删除默认下钻区域中默认下钻记录
	参数：
		obj a标签对象
*/
function treeTableRemoveDrillColoumnLi(columnId,columnName,columnDesc){
	if($("#treeTableDrillColumn_"+columnId).size()>0){
		$("#treeTableDrillColumn_"+columnId).parent().parent().remove();
	}
	treeTableRemoveKpiStore(columnId);
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var removeColumnIds=[];
	removeColumnIds.push(columnId);
	TreeTableEvent.removeDrillCol(reportId,containerId,componentId,removeColumnIds);
}

/** 描述：点击被选指标区域中指标时，将选择的指标加到指标区域中
	参数：
		treeTableColumnId 选择的指标编码
		treeTableColumnName 选择的指标字段名称
		treeTableColumnDesc 选择的指标描述
*/
function treeTableChecktreeTableColumn(treeTableColumnId,treeTableColumnName,treeTableColumnDesc){
	var checkboxEle=$("#treeTableColumnCheckbox_"+treeTableColumnId);
	if(checkboxEle.attr("checked")!='checked'){//选中
		treeTableInsertKpiColumn(treeTableColumnId,treeTableColumnName,treeTableColumnDesc);
	}else{//取消
		var talbeDimColumnSpan=$("#treeTableDimColumnDiv>ul>li span[id='treeTableDimColumn_"+treeTableColumnId+"']");
        if(talbeDimColumnSpan.size()>0){
        	//$("#treeTableDimColumnCloseATag_"+treeTableColumnId).click();
        	treeTableRemoveDimColoumnLi(treeTableColumnId,treeTableColumnName,treeTableColumnDesc);
       	}
       	var talbeKpiColumnSpan=$("#treeTableKpiColumnDiv>ul>li span[id='treeTableKpiColumn_"+treeTableColumnId+"']");
       	if(talbeKpiColumnSpan.size()>0){
       		//$("#treeTableKpiColumnCloseATag_"+treeTableColumnId).click();
       		treeTableRemoveKpiColoumnLi(treeTableColumnId,treeTableColumnName,treeTableColumnDesc);
       	}
       	var treeTalbeDrillColumnSpan=$("#treeTableDrillColumnDiv>ul>li span[id='treeTableDrillColumn_"+treeTableColumnId+"']");
       	if(treeTalbeDrillColumnSpan.size()>0){
       		treeTableRemoveDrillColoumnLi(treeTableColumnId,treeTableColumnName,treeTableColumnDesc);
       	}
			
	}
	
}

/** 描述：向维度区域中添加指标
	参数：
		dimColumnId 指标编码
		dimColumnName 指标字段名称
		dimColumnDesc 指标描述
*/
function treeTableInsertDimColumn(dimColumnId,dimColumnName,dimColumnDesc){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var dataDimTrTd=$("#selectable_"+componentId+" tr:last>td");
	var continueFlag=true;
	var lastTrTd=$("#selectable_"+componentId+" tr:last>td:last");
	$('#selectable_'+componentId+' tr>td').removeClass("ui-selected");
	lastTrTd.addClass("ui-selected");
	if(lastTrTd.text()!=''){
		if(!treeTableInsertColumn(componentId,"right")){
			continueFlag=false;
		}
	}
	lastTrTd.removeClass("ui-selected");
	$('#selectable_'+componentId).selectable('refresh');
	
	var freeTrTdColCode=$("#selectable_"+componentId+" tr:first>th:last").text();
	var freeTrtd=$("#selectable_"+componentId+" tr:last>td:last");
	if(continueFlag){
		if(!treeTableInsertDimColumnHtml(dimColumnId,dimColumnName,dimColumnDesc,true)){
			return false;
		}
		dataDimTrTd=$("#selectable_"+componentId+" tr:last>td");
		var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
		var tempLastRowCell=null;
		for(var a=0;a<dataDimTrTd.length;a++){
			if($.trim($(dataDimTrTd[a]).attr("data-treeTableDataTdType"))!='dim'&&$.trim($(dataDimTrTd[a]).attr("data-treeTableDataTdType"))!='drill'){
				var treeTablerowcode=$(dataDimTrTd[a]).attr("istt").substring(2);
				var info={};
				info.datacolid=dimColumnId;
				info.datacolcode=dimColumnName;
				info.datacoldesc=dimColumnDesc;
				info.treeTablecoldesc=dimColumnDesc;
				
				freeTrtd.text(dimColumnDesc);
				freeTrtd.attr("data-treeTableDataTdType","dim");
				tempLastRowCell=treeTableFindLastRowCellByTdInd(componentId,freeTrtd.attr("tdInd"));
				$(tempLastRowCell).text(dimColumnDesc);
				
				treeTableMoveCell(componentId,treeTablerowcode,freeTrTdColCode,$(treeTableFirstTrTh[a+1]).text());
				
				TreeTableEvent.setDimCol(reportId,containerId,componentId,treeTablerowcode,$(treeTableFirstTrTh[a+1]).text(),info,freeTrTdColCode);
				break;
			}
		}
		
	}
}


/** 描述：向维度区域中添加指标的html部分
	参数：
		dimColumnId 指标编码
		dimColumnName 指标字段名称
		dimColumnDesc 指标描述
		checkExist 是否检验存在不存在
*/
function treeTableInsertDimColumnHtml(dimColumnId,dimColumnName,dimColumnDesc,checkExist){
	var treeTableDrillColumnUl=$("#treeTableDrillColumnDiv>ul");
	var treeTableDimColumnUl=$("#treeTableDimColumnDiv>ul");
	var treeTableKpiColumnUl=$("#treeTableKpiColumnDiv>ul");
	if(checkExist){
		if(treeTableDrillColumnUl.find("li span[id='treeTableDrillColumn_"+dimColumnId+"']").size()>0){
			$.messager.alert("下钻表格","选择无效，在下钻区域已存在该指标！","error");
			return false;
		}
		if(treeTableKpiColumnUl.find("li span[id='treeTableKpiColumn_"+dimColumnId+"']").size()>0){
			$.messager.alert("下钻表格","选择无效，在指标区域已存在该指标！","error");
			return false;
		}
		if(treeTableDimColumnUl.find("li span[id='treeTableDimColumn_"+dimColumnId+"']").size()>0){
			$.messager.alert("下钻表格","选择无效，在维度区域已存在该指标！","error");
			return false;
		}
	}else{
		var treeTableDrillColumnUlLiSpan=treeTableDrillColumnUl.find("li span[id='treeTableDrillColumn_"+dimColumnId+"']");
		if(treeTableDrillColumnUlLiSpan.size()>0){
			for(var a=0;a<treeTableDrillColumnUlLiSpan.size();a++){
				$(treeTableDrillColumnUlLiSpan[a]).parent().parent().remove();
			}
		}
		
		var treeTableDimColumnUlLiSpan=treeTableDimColumnUl.find("li span[id='treeTableDimColumn_"+dimColumnId+"']");
		if(treeTableDimColumnUlLiSpan.size()>0){
			for(var a=0;a<treeTableDimColumnUlLiSpan.size();a++){
				$(treeTableDimColumnUlLiSpan[a]).parent().parent().remove();
			}
		}
		
		var treeTableKpiColumnUlLiSpan=treeTableKpiColumnUl.find("li span[id='treeTableKpiColumn_"+dimColumnId+"']");
		if(treeTableKpiColumnUlLiSpan.size()>0){
			for(var a=0;a<treeTableKpiColumnUlLiSpan.size();a++){
				$(treeTableKpiColumnUlLiSpan[a]).parent().parent().remove();
			}
		}
	}

	treeTableDimColumnHtmlStr=treeTableGenerationDimColumnHtml(dimColumnId,dimColumnName,dimColumnDesc);
	treeTableDimColumnUl.append(treeTableDimColumnHtmlStr);
	return true;
}

/** 描述：生成向维度区域中添加指标的html代码（为了保证插入html的js的惟一性而独立出来的）
	参数：
		kpiColumnId 指标编码
		kpiColumnName 指标字段名称
		kpiColumnDesc 指标描述
*/
function treeTableGenerationDimColumnHtml(dimColumnId,dimColumnName,dimColumnDesc){
	dimColumnDesc = $.trim(dimColumnDesc);
	var treeTableDimColumnHtmlStr='';
	treeTableDimColumnHtmlStr+='<li><p class="delBtn">';
	treeTableDimColumnHtmlStr+='<span id="treeTableDimColumn_'+dimColumnId+'" name="treeTableDimColumn_'+dimColumnName+'" class="dropText" title="'+dimColumnDesc+'">'+dimColumnDesc+'</span>';
	treeTableDimColumnHtmlStr+='<span><a href="javascript:void(0);" id="treeTableDimColumnCloseATag_'+dimColumnId+'" class="colbtn" onclick="treeTableRemoveDimColoumnLi(\''+dimColumnId+'\',\''+dimColumnName+'\',\''+dimColumnDesc+'\')">删除</a></span>';
	treeTableDimColumnHtmlStr+='</p></li>';
	treeTableDimColumnHtmlStr+='';
	return treeTableDimColumnHtmlStr;

}

/** 描述：向指标区域中添加指标
	参数：
		kpiColumnId 指标编码
		kpiColumnName 指标字段名称
		kpiColumnDesc 指标描述
*/
function treeTableInsertKpiColumn(kpiColumnId,kpiColumnName,kpiColumnDesc){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
	var continueFlag=true;
	
	var lastTrTd=$("#selectable_"+componentId+" tr:last>td:last");
	$('#selectable_'+componentId+' tr>td').removeClass("ui-selected");
	lastTrTd.addClass("ui-selected");
	if(lastTrTd.text()!=''){
		if(!treeTableInsertColumn(componentId,"right")){
			continueFlag=false;
		}
	}
	lastTrTd.removeClass("ui-selected");
	$('#selectable_'+componentId).selectable('refresh');
	
	kpiColumnDesc = $.trim(kpiColumnDesc);
	if(continueFlag){
		var kpiid = kpiColumnId.indexOf("extcolumn_")!=-1 ? kpiColumnId.substring(10) : kpiColumnId;
		if(!treeTableInsertKpiColumnHtml(kpiid,kpiColumnName,kpiColumnDesc,true)){
			return false;
		}
		var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
		var tempLastRowCell=null;
		dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
		for(var a=0;a<dataKpiTrTd.length;a++){
			if($.trim($(dataKpiTrTd[a]).text())==''){
				var treeTablerowcode=$(dataKpiTrTd[a]).attr("istt").substring(2);
				$(dataKpiTrTd[a]).text(kpiColumnDesc);
				$(dataKpiTrTd[a]).attr("data-treeTableDataTdType","kpi");
				tempLastRowCell=treeTableFindLastRowCellByTdInd(componentId,$(dataKpiTrTd[a]).attr("tdInd"));
				$(tempLastRowCell).text(kpiColumnDesc);
				var info={};
				if(kpiColumnId.indexOf("extcolumn_")!=-1){//计算列拖拽过来的
					info.datacolid="";
					info.datacolcode="";
					info.extcolumnid=kpiColumnId.substring(10);
				}else{
					info.datacolid=kpiColumnId;
					info.datacolcode=kpiColumnName;
					info.extcolumnid="";
				}
				info.datacoldesc=kpiColumnDesc;
				info.treeTablecoldesc=kpiColumnDesc;
				TreeTableEvent.setKpiCol(reportId,containerId,componentId,treeTablerowcode,$(treeTableFirstTrTh[a+1]).text(),info);
				break;
			}
		}
		
	}
	
}
/** 描述：向指标区域中添加指标的html部分
	参数：
		kpiColumnId 指标编码
		kpiColumnName 指标字段名称
		kpiColumnDesc 指标描述
		checkExist 是否检验存在不存在
*/
function treeTableInsertKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc,checkExist){
	var treeTableDrillColumnUl=$("#treeTableDrillColumnDiv>ul");
	var treeTableDimColumnUl=$("#treeTableDimColumnDiv>ul");
	var treeTableKpiColumnUl=$("#treeTableKpiColumnDiv>ul");
	if(checkExist){
		if(treeTableDrillColumnUl.find("li span[id='treeTableDrillColumn_"+kpiColumnId+"']").size()>0){
			$.messager.alert("下钻表格","选择无效，在下钻区域已存在该指标！","error");
			return false;
		}
		if(treeTableKpiColumnUl.find("li span[id='treeTableKpiColumn_"+kpiColumnId+"']").size()>0){
			$.messager.alert("下钻表格","选择无效，在指标区域中已存在该指标！","error");
			return false;
		}
		if(treeTableDimColumnUl.find("li span[id='treeTableDimColumn_"+kpiColumnId+"']").size()>0){
			$.messager.alert("下钻表格","选择无效，在维度区域中已存在该指标！","error");
			return false;
		}
	}else{
		var treeTableDrillColumnUlLiSpan=treeTableDrillColumnUl.find("li span[id='treeTableDrillColumn_"+kpiColumnId+"']");
		if(treeTableDrillColumnUlLiSpan.size()>0){
			for(var a=0;a<treeTableDrillColumnUlLiSpan.size();a++){
				$(treeTableDrillColumnUlLiSpan[a]).parent().parent().remove();
			}
		}
		
		var treeTableDimColumnUlLiSpan=treeTableDimColumnUl.find("li span[id='treeTableDimColumn_"+kpiColumnId+"']");
		if(treeTableDimColumnUlLiSpan.size()>0){
			for(var a=0;a<treeTableDimColumnUlLiSpan.size();a++){
				$(treeTableDimColumnUlLiSpan[a]).parent().parent().remove();
			}
		}
		
		var treeTableKpiColumnUlLiSpan=treeTableKpiColumnUl.find("li span[id='treeTableKpiColumn_"+kpiColumnId+"']");
		if(treeTableKpiColumnUlLiSpan.size()>0){
			for(var a=0;a<treeTableKpiColumnUlLiSpan.size();a++){
				$(treeTableKpiColumnUlLiSpan[a]).parent().rparent().emove();
			}
		}
	}
	var treeTableKpiColumnHtmlStr=treeTableGenerationKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc);//向指标区域中添加指标的html代码
	treeTableKpiColumnUl.append(treeTableKpiColumnHtmlStr);
	
	return true;
	
}
/** 描述：生成向指标区域中添加指标的html代码（为了保证插入html的js的惟一性而独立出来的）
	参数：
		kpiColumnId 指标编码
		kpiColumnName 指标字段名称
		kpiColumnDesc 指标描述
*/
function treeTableGenerationKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc){
	kpiColumnDesc = $.trim(kpiColumnDesc);
	var treeTableKpiColumnHtmlStr='';
	treeTableKpiColumnHtmlStr+='<li><p class="delBtn">';
	treeTableKpiColumnHtmlStr+='<span id="treeTableKpiColumn_'+kpiColumnId+'" name="treeTableKpiColumn_'+kpiColumnName+'" class="dropText" title="'+kpiColumnDesc+'">'+kpiColumnDesc+'</span>';
	treeTableKpiColumnHtmlStr+='<span><a href="javascript:void(0);" class="colbtn" id="treeTableKpiColumnCloseATag_'+kpiColumnId+'" onclick="treeTableRemoveKpiColoumnLi(\''+kpiColumnId+'\',\''+kpiColumnName+'\',\''+kpiColumnDesc+'\')">删除</a></span>';
	treeTableKpiColumnHtmlStr+='</p></li>';
	return treeTableKpiColumnHtmlStr;

}
/** 描述：向指标区域中添加多个指标
	参数：
		columnList 对象数组，每个对象都有columnId,columnName,columnDesc三个属性
*/
function treeTableInsertMoreKpiColumn(columnList){
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	
	var treeTableKpiColumnUl=$("#treeTableKpiColumnDiv>ul");
	var kpiColumnId;
	var kpiColumnName;
	var kpiColumnDesc;
	var continueFlag=true;
	for(var i=0;i<columnList.length;i++){
		kpiColumnId=columnList[i]["columnId"];
		kpiColumnName=columnList[i]["columnName"];
		kpiColumnDesc=columnList[i]["columnDesc"];
		$("input[id^='treeTableColumnCheckbox_"+kpiColumnId+"']").iCheck('check');
		var treeTableKpiColumnHtmlStr=treeTableGenerationKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc);
		treeTableKpiColumnUl.append(treeTableKpiColumnHtmlStr);
	
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
			if(!treeTableInsertColumn(componentId,"right")){
				continueFlag=false;
				break;
			}
			tempLastTrTr.removeClass("ui-selected");
			$('#selectable_'+componentId).selectable('refresh');
			
		}
		
		var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
		var tempLastRowCell=null;
		dataKpiTrTd=$("#selectable_"+componentId+" tr:last>td");
		for(var a=0;a<dataKpiTrTd.length;a++){
			if($.trim($(dataKpiTrTd[a]).text())==''){
				var treeTablerowcode=$(dataKpiTrTd[a]).attr("istt").substring(2);
				$(dataKpiTrTd[a]).text(kpiColumnDesc);
				$(dataKpiTrTd[a]).attr("data-treeTableDataTdType","kpi");
				tempLastRowCell=treeTableFindLastRowCellByTdInd(componentId,$(dataKpiTrTd[a]).attr("tdInd"));
				$(tempLastRowCell).text(kpiColumnDesc);
				
				var cellInfo={};
				cellInfo.datacolid=kpiColumnId;
				cellInfo.datacolcode=kpiColumnName;
				cellInfo.datacoldesc=kpiColumnDesc;
				cellInfo.datacoltype="kpi";
				cellInfo.treeTablecoldesc=kpiColumnDesc;
				cellInfo.treeTablerowcode=treeTablerowcode;
				cellInfo.treeTablecolcode=$(treeTableFirstTrTh[a+1]).text();
				cellInfoList.push(cellInfo);
				break;
			}
		}
	}
	
	if(continueFlag){
		TreeTableEvent.setMoreKpiCol(reportId,containerId,componentId,cellInfoList);
	}
	
	
}


/** 描述：向下钻区域中添加指标
	参数：
		drillColumnId 指标编码
		drillColumnName 指标字段名称
		drillColumnDesc 指标描述
*/
function treeTableInsertDrillColumn(drillColumnId,drillColumnName,drillColumnDesc){
	if(!treeTableInsertDrillColumnHtml(drillColumnId,drillColumnName,drillColumnDesc,true)){
		return false;
	}	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var info={};
	info.drillcolcodeid=drillColumnId;
	info.drillcode=drillColumnName+"";
	info.drillcoltitle=drillColumnDesc;
	info.drillcolcode=drillColumnName+"_CODE";
	info.drillcoldesc=drillColumnName;
	info.drillsortcolcode=info.drillcoldesc;
	
	info.datasourceid=LayOutUtil.uuid();
	
	var drillcolSortcolList=[];
	var drillcolsortcol={};
	drillcolsortcol.colcode=info.drillcolcodeid;
	
	drillcolSortcolList.push(drillcolsortcol);
	info.drillcolSortcolList=drillcolSortcolList;
	
	TreeTableEvent.setDrillCol(reportId,containerId,componentId,info);
}

/** 描述：向下钻区域中添加指标的html部分
	参数：
		drillColumnId 指标编码
		drillColumnName 指标字段名称
		drillColumnDesc 指标描述
		checkExist 是否检验存在不存在
*/
function treeTableInsertDrillColumnHtml(drillColumnId,drillColumnName,drillColumnDesc,checkExist){
	var treeTableDrillColumnUl=$("#treeTableDrillColumnDiv>ul");
	var treeTableDimColumnUl=$("#treeTableDimColumnDiv>ul");
	var treeTableKpiColumnUl=$("#treeTableKpiColumnDiv>ul");
	if(checkExist){
		if(treeTableDrillColumnUl.find("li span[id='treeTableDrillColumn_"+drillColumnId+"']").size()>0){
			$.messager.alert("下钻表格","选择无效，在下钻区域已存在该指标！","error");
			return false;
		}
	
		if(treeTableKpiColumnUl.find("li span[id='treeTableKpiColumn_"+drillColumnId+"']").size()>0){
			$.messager.alert("下钻表格","选择无效，在指标区域中已存在该指标！","error");
			return false;
		}
		if(treeTableDimColumnUl.find("li span[id='treeTableDimColumn_"+drillColumnId+"']").size()>0){
			$.messager.alert("下钻表格","选择无效，在维度区域中已存在该指标！","error");
			return false;
		}
	}else{
		var treeTableDrillColumnUlLiSpan=treeTableDrillColumnUl.find("li span[id='treeTableDrillColumn_"+drillColumnId+"']");
		if(treeTableDrillColumnUlLiSpan.size()>0){
			for(var a=0;a<treeTableDrillColumnUlLiSpan.size();a++){
				$(treeTableDrillColumnUlLiSpan[a]).parent().parent().remove();
			}
		}
		
		var treeTableDimColumnUlLiSpan=treeTableDimColumnUl.find("li span[id='treeTableDimColumn_"+drillColumnId+"']");
		if(treeTableDimColumnUlLiSpan.size()>0){
			for(var a=0;a<treeTableDimColumnUlLiSpan.size();a++){
				$(treeTableDimColumnUlLiSpan[a]).parent().parent().remove();
			}
		}
		
		var treeTableKpiColumnUlLiSpan=treeTableKpiColumnUl.find("li span[id='treeTableKpiColumn_"+drillColumnId+"']");
		if(treeTableKpiColumnUlLiSpan.size()>0){
			for(var a=0;a<treeTableKpiColumnUlLiSpan.size();a++){
				$(treeTableKpiColumnUlLiSpan[a]).parent().rparent().emove();
			}
		}
	}
	var treeTableDrillColumnHtmlStr=treeTableGenerationDrillColumnHtml(drillColumnId,drillColumnName,drillColumnDesc);
	treeTableDrillColumnUl.append(treeTableDrillColumnHtmlStr);
	return true;
}

/** 描述：生成向默认下钻区域中添加指标的html代码（为了保证插入html的js的惟一性而独立出来的）
	参数：
		drillColumnId 指标编码
		drillColumnName 指标字段名称
		drillColumnDesc 指标描述
		checkExist 是否检验存在不存在
*/
function treeTableGenerationDrillColumnHtml(drillColumnId,drillColumnName,drillColumnDesc){
	var treeTableDrillColumnHtmlStr='';
	treeTableDrillColumnHtmlStr+='<li><p class="delBtn">';
	treeTableDrillColumnHtmlStr+='<span id="treeTableDrillColumn_'+drillColumnId+'" name="treeTableDrillColumn_'+drillColumnName+'" class="dropText" title="'+drillColumnDesc+'">'+drillColumnDesc+'</span>';
	treeTableDrillColumnHtmlStr+="<span>";
	treeTableDrillColumnHtmlStr+="		<a href=\"javascript:void(0);\" id=\"treeTableDrillColumnCloseATag_"+drillColumnId+"\" class=\"colbtn\" onclick=\"treeTableRemoveDrillColoumnLi('"+drillColumnId+"','"+drillColumnName+"','"+drillColumnDesc+"')\">删除</a>"
	treeTableDrillColumnHtmlStr+="</span>"
	treeTableDrillColumnHtmlStr+='</p></li>';
	return treeTableDrillColumnHtmlStr;

}

/** 描述：双击指标执行的方法
	参数：
		columnId 	指标id
		columnName	指标字段名称
		columnDesc	指标描述
		type		指标类型(dim/kpi)
*/
function treeTableDbClickKpiListItem(columnId,columnName,columnDesc,type){
	treeTableInsertKpiStore(columnId,columnName,columnDesc,type);
	if(type=='dim'){
		treeTableInsertDimColumn(columnId,columnName,columnDesc);
	}else if(type=='kpi'){
		var isLeafFolder = $("#treeTableColumn_"+columnId).attr("isLeafFolder");
		if("true"==isLeafFolder){
			$.messager.alert("下钻表格","请选择该指标的子指标！","error");
		}else{
			treeTableInsertKpiColumn(columnId,columnName,columnDesc);
		}
	}
	

}


function treeTableDrillInitDrillProperty(reportId,containerId,componentId){
	var subdrillJson=$.ajax({url: appBase+"/getAllSubdrillsJsonJsonX.e?report_id="+reportId+'&containerId='+containerId+'&componentId='+componentId,type:"POST",cache: false,async: false}).responseText;
	subdrillJson=$.parseJSON(subdrillJson);
	for(var a=0;a<subdrillJson.length;a++){
		subdrillJson[a]["id"]=a;
	}
	$("#treeTableDrillColSelector").combobox({
		valueField:'id',
		textField:'drillcoltitle',
		multiple:false,
		editable:false,
		panelHeight:60,
		editable:false,
		onSelect:treeTableDrillColSelectorSelect
	}).combobox('loadData', subdrillJson);
	$("#treeTableDrillCode").combobox({
		valueField:'varname',
		textField:'varname',
		multiple:false,
		panelHeight:60,
		editable:true,
		onChange:treeTableDrillSetCode
	});
	
	$("#treeTableDrillWidth").numberbox({min:1});
	
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	/*设置下钻列*/
	var colSelector=$selectTds.attr("data-treeTableDrillColSelector");
	if(colSelector==undefined||colSelector==null||colSelector==''){
		colSelector=0;
	}
	if(subdrillJson.length>0){
		if(subdrillJson.length>colSelector){//总个数大于当前选择下钻列元素id(下钻列元素id为索引值)
			$("#treeTableDrillColSelector").combobox("setValue",colSelector);
		}else{//总个数大于当前选择下钻列元素id(元素id为索引值),出现的情况为：设置完后删除
			$("#treeTableDrillColSelector").combobox("setValue",0);
		}
		treeTableDrillColSelectorSelect();
		
	}
	
	/*设置下钻宽度*/
	var width=$selectTds.attr("data-treeTableDrillWidth");
	if(width==undefined||width==null){
		width=200;
	}
	$("#treeTableDrillWidth").numberbox("setValue",width);
	
	/*设置显示汇总*/
	var totalShowFlag=$selectTds.attr("data-treeTableDrillTotalShowFlag");
	if(totalShowFlag==undefined||totalShowFlag==null){
		totalShowFlag='0';
	}
	if(totalShowFlag=='0'){
		$("#treeTableDrillTotalShowFlag").iCheck("uncheck");
		$("#treeTableDrillTotalCode").val("");
		$("#treeTableDrillTotalName").val("");
		$("#treeTableDrillTotalCode").attr("disabled","disabled");
		$("#treeTableDrillTotalName").attr("disabled","disabled");
	}else{
		$("#treeTableDrillTotalShowFlag").iCheck("check");
		$("#treeTableDrillTotalCode").removeAttr("disabled");
		$("#treeTableDrillTotalName").removeAttr("disabled");
		
		/*设置汇总编码*/
		var totalCode=$selectTds.attr("data-treeTableDrillTotalCode");
		if(totalCode==undefined||totalCode==null){
			totalCode='all';
		}
		$("#treeTableDrillTotalCode").val(totalCode);
		/*设置汇总名称*/
		var totalName=$selectTds.attr("data-treeTableDrillTotalName");
		if(totalName==undefined||totalName==null){
			totalName='合计';
		}
		$("#treeTableDrillTotalName").val(totalName);
		
	}
}

function treeTableDrillColSelectorSelect(){
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var subdrillJson=$.ajax({url: appBase+"/getAllSubdrillsJsonJsonX.e?report_id="+reportId+'&containerId='+containerId+'&componentId='+componentId,type:"POST",cache: false,async: false}).responseText;
	subdrillJson=$.parseJSON(subdrillJson);
	var datasourceId=$.ajax({url: appBase+"/getDataSourceIdJsonX.e?reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId,type:"POST",cache: false,async: false}).responseText;
	var selectableLastTrTds=$("#selectable_"+componentId+" tr:last>td");
	var subdrillSortTypeJson=[{"id":"asc","text":"正序"},{"id":"desc","text":"倒序"}];
	for(var a=0;a<subdrillJson.length;a++){
		if(drillColSelector==a){
			var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+reportId+'&isTempFile=1',type:"POST",cache: false,async: false}).responseText;
			dimsionsJson=$.parseJSON(dimsionsJson);
			
			var columnsJson=$.ajax({url: appBase+"/getOneKpiStoreColsJsonX.e?report_id="+reportId+"&report_sql_id="+datasourceId,type:"POST",cache: false,async: false}).responseText;
			columnsJson=$.parseJSON(columnsJson);
			var subdrillSortcolJson=[];
			for(var i=0;i<columnsJson.length;i++){
				
				if(columnsJson[i]["kpicolumn"]==subdrillJson[a]["drillcoldesc"]){
					subdrillSortcolJson.push(columnsJson[i]);
				}
				if(selectableLastTrTds.size()>1){
					for(var j=1;j<selectableLastTrTds.size();j++){
						if($(selectableLastTrTds[j]).text()==columnsJson[i]["kpidesc"]){
							subdrillSortcolJson.push(columnsJson[i]);
							break;
						}
					}
				}
			}
			$("#treeTableDrillCode").combobox('loadData', dimsionsJson);
			var subdrillSortcolList=subdrillJson[a]["subdirllsortcols"]["subdirllsortcolList"];
			var subdrillSortcolHtmlStr="";
			var subdrillSortcolDd=$("#treeTableDrillSortcolDd");
			subdrillSortcolDd.html("");
			for(var x=0;x<subdrillSortcolList.length;x++){
				subdrillSortcolHtmlStr+='<p class="treeTableDrillP">';
				subdrillSortcolHtmlStr+='<input id="treeTableDrillSortcolCode'+x+'"  name="treeTableDrillSortcolCode" value="请选择">';
				subdrillSortcolHtmlStr+='<input id="treeTableDrillSortcolType'+x+'"  name="treeTableDrillSortcolType" value="请选择">';
				subdrillSortcolHtmlStr+='</p>';
				subdrillSortcolDd.append(subdrillSortcolHtmlStr);
				var sortcolcode = subdrillSortcolList[x]["colcode"]==""?subdrillSortcolList[x]["extcolumnid"]:subdrillSortcolList[x]["colcode"];
				$("#treeTableDrillSortcolCode"+x).combobox({
					valueField:'kpiid',
					textField:'kpidesc',
					multiple:false,
					editable:false,
					panelWidth:122,
					panelHeight:160,
					onSelect:treeTableDrillSetSortcol
				}).combobox('loadData', subdrillSortcolJson).combobox("setValue",sortcolcode);
				$("#treeTableDrillSortcolType"+x).combobox({
					valueField:'id',
					textField:'text',
					multiple:false,
					editable:false,
					panelWidth:80,
					panelHeight:160,
					onSelect:treeTableDrillSetSortcol
				}).combobox('loadData', subdrillSortTypeJson).combobox("setValue",subdrillSortcolList[x]["sorttype"]);
				
			}
			
			$("#treeTableDrillName").val(subdrillJson[a]["drillcoltitle"]);
			$("#treeTableDrillCode").combobox("setText",subdrillJson[a]["drillcode"]);
			
			$("#treeTableDrillShowLevel").val(subdrillJson[a]["level"]);
			$("#treeTableDrillGroupName").val(subdrillJson[a]["group"]);
			if(subdrillJson[a]["isdefault"]=='1'){
				$("#treeTableDrillDefaulShowFlag").iCheck("check");
			}else{
				$("#treeTableDrillDefaulShowFlag").iCheck("uncheck");
			}
		}
	}
	
}


/** 描述：设置下钻名称
	参数：
		titleValue 下钻名称
*/
function treeTableDrillSetName(nameValue){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	TreeTableEvent.setDrillName(reportId,containerId,componentId,drillColSelector,nameValue);
}

/** 描述：设置下钻编码
	参数：
		
*/
function treeTableDrillSetCode(newValue, oldValue){
	if(treeTableCheckContainChinese(newValue)){
		$("#treeTableDrillCode").combobox("setText",treeTableReplaceChinese2Null(newValue));
		return false;
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	var drillCode=newValue;
	TreeTableEvent.setDrillCode(reportId,containerId,componentId,drillColSelector,drillCode);
} 



/** 描述：设置下钻排序(全量设置)
	参数：
		
*/
function treeTableDrillSetSortcol(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	var drillSorstcolCodesSize=$("input[id^='treeTableDrillSortcolCode']").size();
								
	var drillSortcolList=[];
	for(var a=0;a<drillSorstcolCodesSize;a++){
		var subdrillSortcolInfo={};
		var colCodeValue = $("#treeTableDrillSortcolCode"+a).combobox("getValue");
		var dataArr = $("#treeTableDrillSortcolCode"+a).combobox("getData");
		$.each(dataArr,function(index,item){
			if(item.kpiid==colCodeValue){
				if(item.kpitype=="extcolumn"){//排序列为计算列
					subdrillSortcolInfo.colcode="";
					subdrillSortcolInfo.extcolumnid=colCodeValue;
				}else{
					subdrillSortcolInfo.colcode=colCodeValue;
					subdrillSortcolInfo.extcolumnid="";
				}
				subdrillSortcolInfo.sortkpitype=item.kpitype;
				return false;
			}
		});
		subdrillSortcolInfo.sorttype=$("#treeTableDrillSortcolType"+a).combobox("getValue");
		drillSortcolList.push(subdrillSortcolInfo);
	
	}
	TreeTableEvent.setDrillSortcol(reportId,containerId,componentId,drillColSelector,drillSortcolList);
}
 
/** 描述：设置显示级别
	参数：
		value 级别值
*/
function treeTableDrillSetShowLevel(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	TreeTableEvent.setDrillShowLevel(reportId,containerId,componentId,drillColSelector,value);
}

/** 描述：设置分组名称
	参数：
		value 分组名称
*/
function treeTableDrillSetGroupName(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	TreeTableEvent.setDrillGroupName(reportId,containerId,componentId,drillColSelector,value);
}

/** 描述：设置默认显示
	参数：
		
*/
function treeTableDrillSetDefaulShowFlag(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	var resultValue='0';
	if($("#treeTableDrillDefaulShowFlag").attr("checked")!='checked'){
		resultValue='1';
	}
	
	TreeTableEvent.setDrillDefaulShowFlag(reportId,containerId,componentId,drillColSelector,resultValue);
}

/** 描述：设置下钻列宽度
	参数：
		value 宽度值
*/
function treeTableDrillSetWidth(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	$selectTds.attr("data-treeTableDrillWidth",value);
	
	TreeTableEvent.setDrillWidth(reportId,containerId,componentId,value);
}


/** 描述：设置显示汇总
	参数：
		
*/
function treeTableDrillSetTotalShowFlag(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var resultValue='0';
	if($("#treeTableDrillTotalShowFlag").attr("checked")!='checked'){
		resultValue='1';
	}
	if(resultValue=='0'){
		$("#treeTableDrillTotalCode").val("");
		$("#treeTableDrillTotalName").val("");
		$("#treeTableDrillTotalCode").attr("disabled","disabled");
		$("#treeTableDrillTotalName").attr("disabled","disabled");
	}else{
		$("#treeTableDrillTotalCode").val("all");
		$("#treeTableDrillTotalName").val("合计");
		$("#treeTableDrillTotalCode").removeAttr("disabled");
		$("#treeTableDrillTotalName").removeAttr("disabled");
	}
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	$selectTds.attr("data-treeTableDrillTotalShowFlag",resultValue);
	
	TreeTableEvent.setDrillTotalShowFlag(reportId,containerId,componentId,resultValue);
}

/** 描述：设置汇总编码
	参数：
		value 汇总编码
*/
function treeTableDrillSetTotalCode(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	$selectTds.attr("data-treeTableDrillTotalCode",value);
	
	TreeTableEvent.setDrillTotalCode(reportId,containerId,componentId,value);
}

/** 描述：设置汇总名称
	参数：
		value 汇总名称
*/
function treeTableDrillSetTotalName(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	$selectTds.attr("data-treeTableDrillTotalName",value);
	
	TreeTableEvent.setDrillTotalName(reportId,containerId,componentId,value);
}


/**
 * 计算列改变时更新UI
 */
function tgUpdataDatasetUI(action){
	var columnId = tgCaculateColumn.currentEditColumnObj.id;
	var columnName = tgCaculateColumn.currentEditColumnObj.name;
	//添加计算列成功后更新候选列区域
    if(action=="edit"){
		//下面代码实现，修改了指标时，维度区域指标区域排序区域和候选列区域要跟着联动功能
		var oldName = tgCaculateColumn.getColumnOldName();
		var tablerowcode="";
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
					break;
				}
			}
		}
		if($("span[name='treeTableKpiColumn_"+columnId+"']").size()>0){
			if(oldName!=columnName){
				var columnHtml = treeTableGenerationKpiColumnHtml(columnId,columnId,columnName);
				$("span[name='treeTableKpiColumn_"+columnId+"']").parent().parent().prop('outerHTML',columnHtml);
				
				tablerowcode=$(dataTrTd[a]).attr("istt").substring(2);
				var info={};
				info.datacolid="";
				info.datacolcode="";
				info.datacoldesc=columnName;
				info.tablecoldesc=columnName;
				info.extcolumnid=columnId;
				
				var kpiStoreJson=$("#treeTableKpiStoreDiv").attr("data-kpiStoreJson");
				if(kpiStoreJson==null||kpiStoreJson==undefined){
					kpiStoreJson=[];
				}else{
					kpiStoreJson=$.parseJSON(kpiStoreJson);
				}
				for(var a=0;a<kpiStoreJson.length;a++){
					if(kpiStoreJson[a]!=null&&kpiStoreJson[a]["kpiid"]==columnId){
						kpiStoreJson[a]["kpidesc"]=columnName;
						break;
					}
				}
				$("#treeTableKpiStoreDiv").attr("data-kpiStoreJson",$.toJSON(kpiStoreJson));
				TreeTableEvent.updateKpiStoreCol(StoreData.xid,StoreData.curContainerId,componentId,{tablecoldesc:columnName,extcolumnid:columnId});
				TreeTableEvent.setKpiCol(StoreData.xid,StoreData.curContainerId,componentId,tablerowcode,$(tableFirstTrTh[a+1]).text(),info);
			}
		}
	}else if(action=="remove"){//删除计算列成功后更新候选列区域
		var info = {reportId:StoreData.xid,extcolumnid:columnId};
		cn.com.easy.xbuilder.service.component.TreegridService.removeExtcolumn(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("下钻表格","删除计算列出错！<br/>"+exception,"error");
			}else{
				if($("#treeTableKpiColumn_"+columnId).size()>0){
					treeTableRemoveKpiColoumnLi(columnId,columnId,columnName);
				}
			}
		});
		
	}
}

