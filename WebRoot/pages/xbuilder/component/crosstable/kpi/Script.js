/**
 * 打开指标库选择对话框
 */ 
function openCrossTableKpiDialog(){
	  var cubeId = StoreData.cubeId;
	  crossTableKpiSelector.open(cubeId);
}

/** 描述：点击指标库树目录时执行的方法
	参数：
		node 节点元素
*/
function crossTableShowKpiList(node){
	var rootNode=node;
	var nodeType="kpi";
	var rootNodeId=null;
	while($(this).tree("getParent",rootNode.target)!=null){
		rootNode=$(this).tree("getParent",rootNode.target);
	}
	rootNodeId=rootNode.id;
	if(rootNodeId==node.id){
		$("#tableKpiColSelectorWinTool").html("");
		$("#tableKpiColSelectorUl").html("");
		tableShowColSelectorWin();
		return false;
	}
	nodeType = node.attributes.kpiType;
	var winToolElement=$("#tableKpiColSelectorWinTool");
	var winToolHtmlStr='';
	if(nodeType=='dim'){
		winToolHtmlStr+='<p>';
		winToolHtmlStr+='维度名称：';
		winToolHtmlStr+='<input type="text" id="tableKpiColSelectorWinKpiName" name="tableKpiColSelectorWinKpiName"/>';
		winToolHtmlStr+='<input type="button" value="查询" class="setw_button" onclick="crossTableQueryKpiList(\''+nodeType+'\',\''+node.id+'\',\'2\')" />';
		winToolHtmlStr+='</p>';
	}else{//kpi
		winToolHtmlStr+='<p>';
		winToolHtmlStr+='指标名称：';
		winToolHtmlStr+='<input type="text" id="tableKpiColSelectorWinKpiName" name="tableKpiColSelectorWinKpiName"/>';
		winToolHtmlStr+='<input type="button" value="查询" class="setw_button"  onclick="crossTableQueryKpiList(\''+nodeType+'\',\''+node.id+'\',\'2\')" />';
		winToolHtmlStr+='</p>';
	}
	winToolElement.html(winToolHtmlStr);
	crossTableQueryKpiList(nodeType,node.id,'1');
	tableShowColSelectorWin();
}

/** 描述：点击指标库树目录时执行的方法
参数：
	node 节点元素
*/
function crossTableQueryKpiList(type,nodeId,flag){
		var params = {};
		params.parentId=nodeId;
		params.searchName=$("#tableKpiColSelectorWinKpiName").val();
		params.treeType = type ;
		var url="";
		if(flag=="1"){
			url = (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/selectTreeNode.e';
		}else{
			url = (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/queryTreeData.e'
		}
		var dataJson=$.ajax({url: url,data:params,type:"POST",cache: false,async: false}).responseText;
		dataJson=$.parseJSON(dataJson);
		var rowsList=dataJson["rows"];
		if(rowsList==''||rowsList==null||rowsList=='null'){
			rowsList=[];
		}
		var ulElement=$("#tableKpiColSelectorUl");
		ulElement.html("");
		var htmlStr="";
		var dbClickStr="";
		for(var a=0;a<rowsList.length;a++){
			dbClickStr="";
			if(type=='dim'){
				htmlStr+='<li><span id="tableColumn_'+rowsList[a]["id"]+'" name="tableColumn_'+rowsList[a]["column"]+'" title="'+rowsList[a]["name"]+'" >'+rowsList[a]["name"]+'</span></li>';
			}else if(type=='kpi'){
				htmlStr+='<li'+" ondblclick=\"crossTableInsertKpiColumn('"+rowsList[a]["id"]+"','"+rowsList[a]["column"]+"','"+rowsList[a]["name"]+"')\""+'><span id="tableColumn_'+rowsList[a]["id"]+'" name="tableColumn_'+rowsList[a]["column"]+'" isLeafFolder="'+rowsList[a]["isLeafFolder"]+'"  title="'+rowsList[a]["name"]+'" >'+rowsList[a]["name"]+'</span></li>';
			}
			
			if(a%100==0){
				ulElement.append(htmlStr);
				htmlStr="";
			}
		}
		ulElement.append(htmlStr);
		crossTableInitKpiColumnDiv();
}

/**
 * 初始化被选指标区域
 */
function crossTableInitKpiColumnDiv(){
		$('#tableKpiColSelectorWinContent li').draggable({
			//proxy:'clone',
			proxy:function(source){
				var p = $('<div style="border:1px solid #ccc;width:80px"></div>');
				p.html($(source).text()).appendTo('body');
				return p;
			},
			revert:true,
			cursor:'move',
			onBeforeDrag : function (e){
				if($(this).find("span:eq(0)").attr("isleaffolder")=="true"){
					return false;
				}else{
					return true;
				}
			},
			onStartDrag: function () {
		         $(this).draggable('options').cursor = 'allowed';
		         var proxy = $(this).draggable('proxy').css('z-index', 99999);
		         proxy.hide();
		     },
		     onDrag: function(){
		     	var thisEle=$(this);
		     	if($(this).draggable('proxy')!=null){
		     		setTimeout(function(){thisEle.draggable('proxy').show();},"300");
		     		
		     	}
		    	
		     },
		     onStopDrag: function () {
		         $(this).draggable('options').cursor = 'move';
		     }
		});
}
/**
 * 双击指标选择区域时向指标区域添加指标
 * @param kpiId
 * @param kpiColumn
 * @param kpiName
 */
function crossTableInsertKpiColumn(kpiId,kpiColumn,kpiName){
	var isLeafFolder = $("#tableColumn_"+kpiId).attr("isLeafFolder");
	if("true"==isLeafFolder){
		$.messager.alert("交叉表格","请选择该指标的子指标！","error");
	}else{
		if(insertCrossKpiColumnHtml(kpiId,kpiColumn,kpiName)){
			saveCrossKpiColumns();
		}
	}
	
	
}


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
					var datacolid = "";
					var datacolcode = "";
					if(col.extcolumnid!=""){
						datacolid = col.extcolumnid;
						datacolcode = col.extcolumnid;
					}else{
						datacolid = col.datacolid;
						datacolcode = col.datacolcode;
					}
					insertCrossKpiColumnHtml(datacolid,datacolcode,col.tablecoldesc);
					allSelectedColumns.push(col.datacolcode);
				});
			}
			
			//还原排序区域
			if(jsonObj.sortcolStore!=null&&jsonObj.sortcolStore!=undefined&&jsonObj.sortcolStore.sortcolList!=null&&jsonObj.sortcolStore.sortcolList!=undefined){
				$.each(jsonObj.sortcolStore.sortcolList,function(index,col){
					var sortcolid="";
					var sortcolcode="";
					if(col.extcolumnid!=undefined&&col.extcolumnid!=""){
						sortcolid = col.extcolumnid;
						sortcolcode = col.extcolumnid;
					}else{
						sortcolid = col.id;
						sortcolcode = col.col;
					}
					
					insertCrossSortColumnHtml(sortcolid,sortcolcode,col.desc);
					var kpiType='dim';
					if(col.kpitype!=undefined&&col.kpitype!=""){
						kpiType = col.kpitype;
					}
					$("#tableSortColumnATag_"+col.type+"_"+sortcolid).show().siblings("a[id^='tableSortColumnATag_']").hide();
					$("#tableSortColumnTypeATag_"+kpiType+"_"+sortcolid).show().siblings("a[id^='tableSortColumnTypeATag_']").hide();
					allSelectedColumns.push(sortcolcode);
				});
			}
			
			//还原行维度显示方式图标
			var showType = jsonObj.rowtype;//1:列表，2：树形
			if(showType=="1"){
				$("#gridDisplay").removeClass("grid_normal").addClass("grid_active");
				$("#treeDisplay").removeClass("tree_active").addClass("tree_normal");
			}else{
				$("#treeDisplay").removeClass("tree_normal").addClass("tree_active");
				$("#gridDisplay").removeClass("grid_active").addClass("grid_normal");
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
		}
}



/** 描述：打开数据单元格的链接的设置参数的面板
参数：

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
			alert("请先设置表格的数据源！");
			return false;
		}
		var columnsJson=$.ajax({url: appBase+"/getOneKpiStoreHasSetDimColsJsonX.e?report_id="+reportId+"&report_sql_id="+datasourceId+'&containerId='+containerId+'&componentId='+componentId+'&componentType=CROSSTABLE',type:"POST",cache: false,async: false}).responseText;
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
			var valueField='kpicolumn';
			var TextField='kpidesc';
			if(parameterList.length==0){
				for(var x=0;x<columnsJson.length;x++){
					if(columnsJson[x]['kpicolumn']!=undefined&&columnsJson[x]['kpicolumn'].toLowerCase()==name.toLowerCase()){
						value=columnsJson[x]['kpicolumn'];
						break;
					}
					if(columnsJson[x]['kpicolumn']!=undefined&&columnsJson[x]['kpicolumn'].replace(/_/g,"").toLowerCase()==name.toLowerCase()){
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
			alert("请先设置表格的数据源！");
			return false;
		}
		var columnsJson=$.ajax({url: appBase+"/getOneKpiStoreHasSetDimColsJsonX.e?report_id="+reportId+"&report_sql_id="+datasourceId+'&containerId='+containerId+'&componentId='+componentId+'&componentType=CROSSTABLE',type:"POST",cache: false,async: false}).responseText;
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
			var valueField='kpicolumn';
			var TextField='kpidesc';
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
			crossTableOpenEventActiveParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField);
		}
		$("#crossTableDataEventActiveParamDialog").dialog("open");
		hideToolsPanel();
}


/** 描述：向可被选择的指标区域添加记录
参数：
	columnColList 指标对象数组
	operateXmlFlag 是否操作xml源数据
*/
function crossTableInsertMoreKpiStoreColumn(operateXmlFlag){
		var info={};
		var reportId=StoreData.xid;
		var containerId=StoreData.curContainerId;
		var componentId=StoreData.curComponentId;
		var tableeAddColumnArray=[];
		var tempUlLiSpan;
		var columnLis=$("#verticalDimColumnDiv>ul>li");
		var category = crossTableKpiSelector.getCurCategory();
		category = category == "mykpi" ? "kpi" : category;
		for(var a=0;a<columnLis.length;a++){
			tempUlLiSpan=$(columnLis[a]).find("span").eq(0);
			var info={};
			info["id"]=tempUlLiSpan.attr("id").substring("tableDimColumn_".length);
			info["column"]=tempUlLiSpan.attr("name").substring("tableDimColumn_".length);
			info["name"]=tempUlLiSpan.text();
			info["kpiType"]=category;
			tableeAddColumnArray.push(info);
		}
		columnLis=$("#horizontalDimColumnDiv>ul>li");
		for(var a=0;a<columnLis.length;a++){
			tempUlLiSpan=$(columnLis[a]).find("span").eq(0);
			var info={};
			info["id"]=tempUlLiSpan.attr("id").substring("tableDimColumn_".length);
			info["column"]=tempUlLiSpan.attr("name").substring("tableDimColumn_".length);
			info["name"]=tempUlLiSpan.text();
			info["kpiType"]=category;
			tableeAddColumnArray.push(info);
		}
		columnLis=$("#tableKpiColumnDiv>ul>li");
		for(var a=0;a<columnLis.length;a++){
			tempUlLiSpan=$(columnLis[a]).find("span").eq(0);
			var info={};
			info["id"]=tempUlLiSpan.attr("id").substring("tableKpiColumn_".length);
			info["column"]=tempUlLiSpan.attr("name").substring("tableKpiColumn_".length);
			info["name"]=tempUlLiSpan.text();
			info["kpiType"]= tempUlLiSpan.attr("extcolumnid")==undefined?category:"extcolumn";
			tableeAddColumnArray.push(info);
		}
		columnLis=$("#tableSortColumnDiv>ul>li");
		for(var a=0;a<columnLis.length;a++){
			tempUlLiSpan=$(columnLis[a]).find("span").eq(0);
			var info={};
			info["id"]=tempUlLiSpan.attr("id").substring("tableSortColumn_".length);
			info["column"]=tempUlLiSpan.attr("name").substring("tableSortColumn_".length);
			info["name"]=tempUlLiSpan.text();
			if($("#tableDimColumn_"+info["id"]).size()!=0||$("#tableKpiColumn_"+info["id"]).size()!=0){
				continue;
			}
			info["kpiType"]=tempUlLiSpan.attr("extcolumnid")==undefined?category:"extcolumn";
			tableeAddColumnArray.push(info);
		}
		if(operateXmlFlag){
			//if(tableeAddColumnArray.length>0){
				 var info={};
				 info.reportId=reportId;
				 info.containerId=containerId;
				 info.componentId=componentId;
				 info.infoList=tableeAddColumnArray;
				 
				 crossTableService.addMoreKpiStoreCols(info,function(data,exception){
					 if(exception!=undefined){
							$.messager.alert("交叉表格","保存时指标库指标时出错！<br/>"+exception,"error");
					 }
				 });
			//}
		}
}


/**
 * 更新数据集UI
 */
function ctUpdataDatasetUI(action){
	var columnId = ctCaculateColumn.currentEditColumnObj.id;
	var columnName = ctCaculateColumn.currentEditColumnObj.name;
	//添加计算列成功后更新候选列区域
	if(action=="edit"){//编辑计算列成功后更新候选列区域
		$.parser.parse($("#tableColumnDiv"));
		var oldName = ctCaculateColumn.getColumnOldName();
		if($("span[name='tableKpiColumn_"+columnId+"']").size()>0){
			if(oldName!=columnName){
				var columnHtml = generateKpiColumnHtml(columnId,columnId,columnName);
				$("#tableKpiColumnDiv span[name='tableKpiColumn_"+columnId+"']").parent().parent().prop('outerHTML',columnHtml);
				saveCrossKpiColumns();
			}
		}
		if($("span[name='tableSortColumn_"+columnId+"']").size()>0){
			if(oldName!=columnName){
				$("span[name='tableSortColumn_"+columnId+"']").text(columnName);
				saveCrossSortColumns();
			}
		}
	}else if(action=="remove"){//删除计算列成功后更新候选列区域
		var info = {reportId:StoreData.xid,extcolumnid:columnId};
		crossTableService.removeExtcolumn(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("交叉表格","删除计算列出错！<br/>"+exception,"error");
			}else{
				if($("#tableKpiColumn_"+columnId).size()>0){
					removeCrossKpiColumn(columnId);
				}
				if($("#tableSortColumn_"+columnId).size()>0){
					removeCrossSortColumn(columnId);
				}
			}
		});
		
	}
}

