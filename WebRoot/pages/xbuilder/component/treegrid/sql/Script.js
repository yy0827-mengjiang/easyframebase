/** 描述：设置数据源
	参数：
		obj combobox数据对象
*/
function treeTableSetDataSource(obj){
	var info={};
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if(typeof(obj.id)!="undefined"&&obj.id!="请选择"){
		if(obj.attributes.datatype=="2"){//数据集为map类型
			$.messager.alert("系统提示","下钻表格不能使用map类型数据集","error");
			$("#treeTableColumnDiv>ul").html("");
			return;
		}
		var xmlDatasourceId=$.ajax({url: appBase+"/getDataSourceIdJsonX.e?reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId,type:"POST",cache: false,async: false}).responseText;
		if(obj.id==('B'+xmlDatasourceId)){
			return false;
		}
		if($("span[id^='treeTableKpiColumn_']").size()==0&&$("span[id^='treeTableDimColumn_']").size()==0&&$("span[id^='treeTableDrillColumn_']").size()==0){
			var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+reportId+"&report_sql_id="+obj.id;
			var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
			//获得计算列
			var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+reportId+"&report_sql_id="+obj.id;
			var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
			for(var i=0;i<extData.length;i++){
				data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
			}
			var treeTableColumnUl=$("#treeTableColumnDiv>ul");
			var treeTableColumnHtmlStr='';
			for(var i=0;i<data.length;i++){
				if(data[i].isextcolumn==true){
					treeTableColumnHtmlStr+=treeTableGenerationExtColumnDivLiHtml(data[i]["id"],data[i]["text"],data[i]["text"]);
				}else{
					treeTableColumnHtmlStr+=treeTableGenerationColumnDivLiHtml(data[i]["id"],data[i]["text"],data[i]["text"]);
				}
			}
			treeTableColumnUl.html(treeTableColumnHtmlStr);
			$.parser.parse($("#treeTableColumnDiv"));
			$("input[name='treeTableColumn']").iCheck({
			    labelHover : false,
			    cursor : true,
			    checkboxClass : 'icheckbox_square-blue',
			    radioClass : 'iradio_square-blue',
			    increaseArea : '20%'
			}).on('ifClicked', function(event){
			  	var columnId=$(this).attr("data-columnId");
			  	treeTableChecktreeTableColumn($(this).attr("data-columnId"),$(this).attr("data-columnName"),$(this).attr("data-columnDesc"));
			  	window.setTimeout(function(){ treeTableFlushColumnDiv(columnId);},1000); 
			});
			treeTableEnableOrDisabledSelectAllCol();
			treeTableInitColumnDiv();
			treeTableInitDrillColumnDiv();
			treeTableInitKpiColumnDiv();
			treeTableInitDimColumnDiv();
			var sqlId=(obj.id).substring(1);
			TreeTableEvent.setDatasourceId(reportId,containerId,componentId,sqlId);
		}else{
			$.messager.alert("下钻表格","变更数据源失败，下钻区域、维度区域或指标区域已设置相关内容，请清除后再进行操作！","error");
			$("#treeTableDataSource").combobox("setValue",'B'+xmlDatasourceId);
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
function treeTableGenerationColumnDivLiHtml(columnId,columnName,columnDesc){
	var treeTableColumnHtmlStr='';
	treeTableColumnHtmlStr+='<li>';
	treeTableColumnHtmlStr+='<input type="checkbox" id="treeTableColumnCheckbox_'+columnId+'" name="treeTableColumn" data-columnId="'+columnId+'" data-columnName="'+columnDesc+'" data-columnDesc="'+columnDesc+'" /><span id="treeTableColumn_'+columnId+'" name="treeTableColumn_'+columnDesc+'" title="'+columnDesc+'">'+columnDesc+'</span>';
	treeTableColumnHtmlStr+='</li>';
	return treeTableColumnHtmlStr;

}

/** 描述：生成向被选择指标区域中添加指标的html代码(计算列)（为了保证插入html的js的惟一性而独立出来的）
参数：
	columnId 指标编码
	columnName 指标字段名称
	columnDesc 指标描述
*/
function treeTableGenerationExtColumnDivLiHtml(columnId,columnName,columnDesc){
	
	var treeTableColumnHtmlStr='';
	treeTableColumnHtmlStr+='<li>';
	treeTableColumnHtmlStr+='<input type="checkbox" id="treeTableColumnCheckbox_C'+columnName+'" name="treeTableColumn" data-columnId="C'+columnName+'" data-columnName="'+columnDesc+'" data-columnDesc="'+columnDesc+'" />'
							+'<span extcolumnid='+columnId+' id="treeTableColumn_C'+columnName+'" name="treeTableColumn_'+columnDesc+'" title="'+columnDesc+'">'+columnDesc+'</span>'
							+'<a href="javascript:void(0)" onclick="treeTableEditExtcolumn(\''+columnId+'\')" class="edit_col_btn"></a>'
							+'<a href="javascript:void(0)" onclick="treeTableRemoveExtcolumn(\''+columnId+'\')"  class="remove_col_btn"></a>';
	treeTableColumnHtmlStr+='</li>';
	return treeTableColumnHtmlStr;

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
		
		/*设置数据集和被选择指标区域数据*/
		var dateJson=$.ajax({url: appBase+"/getAllDataSourceJsonX.e?report_id="+reportId,type:"POST",cache: false,async: false}).responseText;
		var datasourceData=[];
		if(dateJson!=null&&dateJson!=""&&dateJson!="null"){
			datasourceData = $.evalJSON(dateJson);
			$("#treeTableDataSource").combobox('loadData', datasourceData); 
		}

		var columnDatas=null;
		var datasourceId=jsonObj.datasourceid;
		if(typeof(datasourceId)!="undefined"&&datasourceId!=null&&datasourceId!='null'){
			var useDatasourceId='B'+datasourceId;
			$("#treeTableDataSource").combobox("setValue",useDatasourceId);
			var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+reportId+"&report_sql_id="+useDatasourceId;
			var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
			
			//获得计算列
			var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+reportId+"&report_sql_id="+useDatasourceId;
			var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
			if(extData!=undefined){
				for(var i=0;i<extData.length;i++){
					data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
				}
			}
			
			var treeTableColumnUl=$("#treeTableColumnDiv>ul");
			var treeTableColumnHtmlStr='';
			for(var i=0;i<data.length;i++){
				if(data[i].isextcolumn==true){
					treeTableColumnHtmlStr+=treeTableGenerationExtColumnDivLiHtml(data[i]["id"],data[i]["text"],data[i]["text"]);
				}else{
					treeTableColumnHtmlStr+=treeTableGenerationColumnDivLiHtml(data[i]["id"],data[i]["text"],data[i]["text"]);
				}
			}
			treeTableColumnUl.html(treeTableColumnHtmlStr);
			$.parser.parse($("#treeTableColumnDiv"));
			$("input[name='treeTableColumn']").iCheck({
			    labelHover : false,
			    cursor : true,
			    checkboxClass : 'icheckbox_square-blue',
			    radioClass : 'iradio_square-blue',
			    increaseArea : '20%'
			}).on('ifClicked', function(event){
			  	var columnId=$(this).attr("data-columnId");
			  	treeTableChecktreeTableColumn($(this).attr("data-columnId"),$(this).attr("data-columnName"),$(this).attr("data-columnDesc"));
			  	window.setTimeout(function(){ treeTableFlushColumnDiv(columnId);},1000); 
			});
			treeTableEnableOrDisabledSelectAllCol();
			treeTableInitColumnDiv();
			treeTableInitDrillColumnDiv();
			treeTableInitKpiColumnDiv();
			treeTableInitDimColumnDiv();
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
				for(var i=0;i<=dataColList.length;i++){
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
										treeTableInsertDimColumnHtml(tempDataColId,tempDataColColumn,tempDataColDesc,false);
									}else if(tempDataColType=='kpi'){
										treeTableInsertKpiColumnHtml(tempDataColId,tempDataColColumn,tempDataColDesc,false);
									}
									$("#treeTableColumnCheckbox_"+tempDataColId).iCheck('check');//设置被选择指标区域中指标为选中状态
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
		
		
		/*设置下钻区域和被选择指标区域（部分）*/
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
					subdrillColDesc=subdrillColList[i]["drillcoldesc"];
					tempIsVaildFlag=false;
					for(var b=0;b<columnDatas.length;b++){
						if(subdrillColColumn==columnDatas[b]["text"]){
							tempIsVaildFlag=true;
							break;
						}
					}
					if(tempIsVaildFlag){
						treeTableInsertDrillColumnHtml(subdrillColId,subdrillColColumn,subdrillColDesc,false);//向下钻区域插入数据
						$("#treeTableColumnCheckbox_"+subdrillColId).iCheck('check');//设置被选择指标区域中指标为选中状态
					}
					
				}
			}
		}
		
		
		treeTableEnableOrDisabledSelectAllCol();//设置 全选多选框
		if(tempDeleteDataColArray.length>0){
			treeTableRemoveMoreColumn(tempDeleteDataColArray);
		}
		
				
	}
}

/** 描述：删除维度区域中维度记录
	参数：
		obj a标签对象
*/
function treeTableRemoveMoreColumn(deleteDataColArray){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var dataTrTd=$("#selectable_"+componentId+" tr:last>td");
	var deleteDataColColcodeArray=[];
	for(var a=0;a<deleteDataColArray.length;a++){
		for(var b=0;b<dataTrTd.length;b++){
			if($(dataTrTd[b]).text()==deleteDataColArray[a]["desc"]){
				deleteDataColColcodeArray.push($(treeTableFirstTrTh[b+1]).text());
			}
		
		}
		
	}
	var columnId;
	var columnName;
	var columnDesc;
	var columnType;
	var tempTreeTablerowcode="";
	var tempTreeTablecolcode="";
	var temptreeTableCellInd="";
	var tempLastRowCell=null;
	var tempReplaceCellColcode='';
	for(var i=0;i<deleteDataColArray.length;i++){
		columnId=deleteDataColArray[i]["id"];
		columnName=deleteDataColArray[i]["column"];
		columnDesc=deleteDataColArray[i]["desc"];
		columnType=deleteDataColArray[i]["type"];
		treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
		dataTrTd=$("#selectable_"+componentId+" tr:last>td");
		for(var a=0;a<dataTrTd.length;a++){
			if($(dataTrTd[a]).text()==columnDesc){
				tempReplaceCellColcode=$(treeTableFirstTrTh[dataTrTd.length]).text();
				tempTreeTablerowcode=$(dataTrTd[a]).attr("istt").substring(2);
				tempTreeTablecolcode=$(treeTableFirstTrTh[a+1]).text();
				temptreeTableCellInd=$(dataTrTd[a]).attr("tdInd");
				treeTableClearCell(componentId,tempTreeTablerowcode,tempTreeTablecolcode);
				tempLastRowCell=treeTableFindLastRowCellByTdInd(componentId,temptreeTableCellInd);
				treeTableClearCell(componentId,$(tempLastRowCell).attr("istt").substring(2),tempTreeTablecolcode);
				treeTableMoveCell(componentId,tempTreeTablerowcode,tempTreeTablecolcode,tempReplaceCellColcode);
				if(columnType=='dim'){
					if($("#treeTableDimColumn_"+columnId).size()>0){
						$("#treeTableDimColumn_"+columnId).parent().parent().remove();
					}
				}else if(columnType=='kpi'){
					if($("#treeTableKpiColumn_"+columnId).size()>0){
						$("#treeTableKpiColumn_"+columnId).parent().parent().remove();
					}
				}
				
				treeTableFlushColumnDiv(columnId);
				break;
			}
		}
		
	
	}
	
	TreeTableEvent.removeMoreCol(reportId,containerId,componentId,deleteDataColColcodeArray);
	
	
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
	$("#treeTableDataEventLinkParamCareSpan").html("注意：“对应数据列”中请选择维度字段或维度编码字段，不能选择指标！");
	
	var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+treeTableDataEventLink,type:"POST",cache: false,async: false}).responseText;
	dimsionsJson=$.parseJSON(dimsionsJson);
	
	var datasourceId=$.ajax({url: appBase+"/getDataSourceIdJsonX.e?reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId,type:"POST",cache: false,async: false}).responseText;
	if(datasourceId==''||datasourceId==null||datasourceId=='null'){
		$.messager.alert("下钻表格","请先设置下钻表格的数据源！","error");
		return false;
	}
	var columnsJson=$.ajax({url: appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+reportId+"&report_sql_id=B"+datasourceId,type:"POST",cache: false,async: false}).responseText;
	columnsJson=$.parseJSON(columnsJson);
	
	var subdrillJson=$.ajax({url: appBase+"/getAllSubdrillsJsonJsonX.e?report_id="+reportId+'&containerId='+containerId+'&componentId='+componentId,type:"POST",cache: false,async: false}).responseText;
	subdrillJson=$.parseJSON(subdrillJson);
	
	var info={};
	info['text']='请选择';
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
		var valueField='text';
		var TextField='text';
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
		
		treeTableDataOpenEventLinkParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField);
	}
	
	
	$("#treeTableDataEventLinkParamDialog").dialog("open");
	hideToolsPanel();
}

/** 描述：打开数据单元格的联动的设置参数的面板
	参数：
	
*/
function treeTableDataOpenEventActiveDialog(eventComponetId,eventEventId){
	$("#treeTableDataEventActiveParamCareSpan").html("注意：“对应数据列”中请选择维度字段或维度编码字段，不能选择指标！");
	treeTableCurrentEvnetCompenentId=eventComponetId;
	treeTableCurrentEvnetEventId=eventEventId;
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+reportId+'&isTempFile=1',type:"POST",cache: false,async: false}).responseText;
	dimsionsJson=$.parseJSON(dimsionsJson);
	
	var datasourceId=$.ajax({url: appBase+"/getDataSourceIdJsonX.e?reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId,type:"POST",cache: false,async: false}).responseText;
	if(datasourceId==''||datasourceId==null||datasourceId=='null'){
		$.messager.alert("下钻表格","请先设置下钻表格的数据源！","error");
		return false;
	}
	var columnsJson=$.ajax({url: appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+reportId+"&report_sql_id=B"+datasourceId,type:"POST",cache: false,async: false}).responseText;
	columnsJson=$.parseJSON(columnsJson);
	
	var subdrillJson=$.ajax({url: appBase+"/getAllSubdrillsJsonJsonX.e?report_id="+reportId+'&containerId='+containerId+'&componentId='+componentId,type:"POST",cache: false,async: false}).responseText;
	subdrillJson=$.parseJSON(subdrillJson);
	
	var info={};
	info['text']='请选择';
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
		var valueField='text';
		var TextField='text';
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
		treeTableDataOpenEventActiveParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField);
	}
	
	$("#treeTableDataEventActiveParamDialog").dialog("open");
	hideToolsPanel();
}


/** 描述：设置标题
	参数：
		titleValue 标题内容
*/
function treeTableSetTitle(titleValue){
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
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
	TreeTableEvent.setExportFlag(reportId,containerId,componentId,resultValue);
}


/** 描述：启用或禁用 全选多选框
	参数：
*/
function treeTableEnableOrDisabledSelectAllCol(){
	if($("span[id^='treeTableKpiColumn_']").size()!=0||$("span[id^='treeTableDimColumn_']").size()!=0||$("span[id^='treeTableDrillColumn_']").size()!=0||$("input[id^='treeTableColumnCheckbox_']").size()==0){
		$("#treeTableSelectAllCol").iCheck('disable');
		$("#treeTableSelectAllCol").iCheck('check');
	}else{
		$("#treeTableSelectAllCol").iCheck('uncheck');
		$("#treeTableSelectAllCol").iCheck('enable');
	}
}


/** 描述：初始化被选指标区域
	参数：
		
*/
function treeTableInitColumnDiv(){
	$('#treeTableColumnDiv li').draggable({
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
				var liSpan=$("span[id='treeTableColumn_"+columnId+"']");
				if($(liSpan).attr("extcolumnid")!=undefined){
					$.messager.alert("下钻表格","计算列不能用做维度！","error");
					$("#treeTableKpiColumnDiv>ul").sortable('cancel');
					return false;
				}
				columnColumn=tempUlLiSpan.attr("name").substring("treeTableKpiColumn_".length);
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
				var liSpan=$("span[id='treeTableColumn_"+columnId+"']");
				if($(liSpan).attr("extcolumnid")!=undefined){
					$.messager.alert("下钻表格","计算列不能用做下钻列！","error");
					$("#treeTableKpiColumnDiv>ul").sortable('cancel');
					return false;
				}
				columnColumn=tempUlLiSpan.attr("name").substring("treeTableKpiColumn_".length);
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
			var datasourceId=$("#treeTableDataSource").combobox("getValue");
			var info={};
			info.drillcolcodeid=drillColumnId;
			if(sourceType!='drill'){
				info.drillcolcode=treeTableFindCodeColumByColumn(drillColumnName);
				var tempDrillcolcode=null;
				for(var x=0;x<treeTableDrillKeyValueArray.length;x++){
					if(drillColumnName.indexOf(treeTableDrillKeyValueArray[x]["value"])>-1){
						tempDrillcolcode=treeTableFindCodeColumByColumn(treeTableDrillKeyValueArray[x]["key"]);
						if(tempDrillcolcode!=""){
							info.drillcolcode=tempDrillcolcode;
						}
						break;
					}
				
				}
				
				
				info.drillcode=treeTableFindDimsionCodeByColumn(info.drillcolcode);
				if(treeTableCheckContainChinese(info.drillcode)){
					info.drillcode="C"+LayOutUtil.uuid();
				}
				info.drillcoltitle=treeTableFindDescByColumn(drillColumnName);
				//info.drillcolcode=treeTableFindCodeColumByColumn(drillColumnName);
				info.drillcoldesc=drillColumnName;
				info.datasourceid=datasourceId.substring(1);
				var drillcolSortcolList=[];
				var drillcolsortcol={};
				drillcolsortcol.colcode=info.drillcolcode;
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

/** 描述：是否全选到指标区域中
	参数：
*/
function treeTableCheckAllTreeTableColumn(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if($("#treeTableSelectAllCol").attr("checked")!='checked'){
		var treeTableColumnObjArray=[];
		var treeTableColumns=$("#treeTableColumnDiv>ul>li span[id^='treeTableColumn_']");
		var subIndex='treeTableColumn_'.length;
		for(var a=0;a<treeTableColumns.length;a++){
			var info={};
			info.columnId=$(treeTableColumns[a]).attr("id").substring(subIndex);
			info.columnName=$(treeTableColumns[a]).attr("name").substring(subIndex);
			info.columnDesc=$(treeTableColumns[a]).text();
			info.extcolumnid = $(treeTableColumns[a]).attr("extcolumnid")==undefined?"":$(treeTableColumns[a]).attr("extcolumnid");
			treeTableColumnObjArray.push(info);
		}
		
		treeTableInsertMoreKpiColumn(treeTableColumnObjArray);

	}
	//TreeTableEvent.setPagiFlag(reportId,containerId,componentId,resultValue);
}

/** 描述：初始化维度区域
	参数：
		
*/
function treeTableInitDimColumnDiv(){
	$('#treeTableDimColumnDiv').droppable({
		accept:'#treeTableColumnDiv li',
		onDragEnter:function(e,source){
		},
		onDragLeave:function(e,source){
		},
		onDrop:function (e, source) {
			var liSpan=$(source).find("span[id^='treeTableColumn_']");
			if($(liSpan).attr("extcolumnid")!=undefined){
				$.messager.alert("下钻表格","计算列不能用做维度列！","error");
				return;
			}
			var liCheckBox=$(source).find("input[type='checkbox']");
			liCheckBox.iCheck('check');
			treeTableEnableOrDisabledSelectAllCol();
			var liSpan=$(source).find("span[id^='treeTableColumn_']");
			
			var subIndex='treeTableColumn_'.length;
			var dimId=liSpan.attr("id").substring(subIndex);
			var dimColumn=liSpan.attr("name").substring(subIndex);
			var dimName=liSpan.text();
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
	var tempTreeTablerowcode="";
	var tempTreeTablecolcode="";
	var temptreeTableCellInd="";
	var tempLastRowCell=null;
	var tempReplaceCellColcode='';
	for(var a=0;a<dataDimTrTd.length;a++){
		if($(dataDimTrTd[a]).text()==columnDesc){
			tempReplaceCellColcode=$(treeTableFirstTrTh[dataDimTrTd.length]).text();
			tempTreeTablerowcode=$(dataDimTrTd[a]).attr("istt").substring(2);
			tempTreeTablecolcode=$(treeTableFirstTrTh[a+1]).text();
			temptreeTableCellInd=$(dataDimTrTd[a]).attr("tdInd");
			treeTableClearCell(componentId,tempTreeTablerowcode,tempTreeTablecolcode);
			tempLastRowCell=treeTableFindLastRowCellByTdInd(componentId,temptreeTableCellInd);
			treeTableClearCell(componentId,$(tempLastRowCell).attr("istt").substring(2),tempTreeTablecolcode);
			treeTableMoveCell(componentId,tempTreeTablerowcode,tempTreeTablecolcode,tempReplaceCellColcode);
			if($("#treeTableDimColumn_"+columnId).size()>0){
				$("#treeTableDimColumn_"+columnId).parent().parent().remove();
			}
			treeTableFlushColumnDiv(columnId);
			TreeTableEvent.removeDimCol(reportId,containerId,componentId,tempTreeTablecolcode);
			break;
		}
	}
	
}


/** 描述：初始化指标区域
	参数：
		
*/
function treeTableInitKpiColumnDiv(){
	$('#treeTableKpiColumnDiv').droppable({
		accept:'#treeTableColumnDiv li',
		onDragEnter:function(e,source){
		},
		onDragLeave:function(e,source){
		},
		onDrop:function (e, source) {
			var liCheckBox=$(source).find("input[type='checkbox']");
			liCheckBox.iCheck('check');
			treeTableEnableOrDisabledSelectAllCol();

			var liSpan=$(source).find("span[id^='treeTableColumn_']");
			var subIndex='treeTableColumn_'.length;
			var kpiId=liSpan.attr("id").substring(subIndex);
			var kpiColumn=liSpan.attr("name").substring(subIndex);
			var kpiName=liSpan.text();
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
	var tempTreeTablerowcode="";
	var tempTreeTablecolcode="";
	var temptreeTableCellInd="";
	var tempLastRowCell=null;
	var tempReplaceCellColcode='';
	for(var a=0;a<dataKpiTrTd.length;a++){
		if($(dataKpiTrTd[a]).text()==columnDesc){
			tempReplaceCellColcode=$(treeTableFirstTrTh[dataKpiTrTd.length]).text();
			tempTreeTablerowcode=$(dataKpiTrTd[a]).attr("istt").substring(2);
			tempTreeTablecolcode=$(treeTableFirstTrTh[a+1]).text();
			temptreeTableCellInd=$(dataKpiTrTd[a]).attr("tdInd");
			treeTableClearCell(componentId,tempTreeTablerowcode,tempTreeTablecolcode);
			tempLastRowCell=treeTableFindLastRowCellByTdInd(componentId,temptreeTableCellInd);
			treeTableClearCell(componentId,$(tempLastRowCell).attr("istt").substring(2),tempTreeTablecolcode);
			treeTableMoveCell(componentId,tempTreeTablerowcode,tempTreeTablecolcode,tempReplaceCellColcode);
			if($("#treeTableKpiColumn_"+columnId).size()>0){
				$("#treeTableKpiColumn_"+columnId).parent().parent().remove();
			}
			treeTableFlushColumnDiv(columnId);
			TreeTableEvent.removeKpiCol(reportId,containerId,componentId,tempTreeTablecolcode);
			break;
		}
	}
	
}

/** 描述：初始化下钻区域
	参数：
		
*/
function treeTableInitDrillColumnDiv(){
	$('#treeTableDrillColumnDiv').droppable({
		accept:'#treeTableColumnDiv li',
		onDragEnter:function(e,source){
		},
		onDragLeave:function(e,source){
		},
		onDrop:function (e, source) {
			var liSpan=$(source).find("span[id^='treeTableColumn_']");
			if($(liSpan).attr("extcolumnid")!=undefined){
				$.messager.alert("下钻表格","计算列不能做下钻列！","error");
				return;
			}
			
			var liCheckBox=$(source).find("input[type='checkbox']");
			liCheckBox.iCheck('check');
			treeTableEnableOrDisabledSelectAllCol();
			
			var liSpan=$(source).find("span[id^='treeTableColumn_']");
			
			
			var subIndex='treeTableColumn_'.length;
			var drillId=liSpan.attr("id").substring(subIndex);
			var drillColumn=liSpan.attr("name").substring(subIndex);
			var drillName=liSpan.text();
			
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

/** 描述：删除下钻区域中下钻记录
	参数：
		obj a标签对象
*/
function treeTableRemoveDrillColoumnLi(columnId,columnName,columnDesc){
	if($("#treeTableDrillColumn_"+columnId).size()>0){
		$("#treeTableDrillColumn_"+columnId).parent().parent().remove();
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	treeTableFlushColumnDiv(columnId);
	var removeColumnIds=[];
	removeColumnIds.push(columnId);
	TreeTableEvent.removeDrillCol(reportId,containerId,componentId,removeColumnIds);
}

/** 描述：根据维度区域、指标区域和下钻区域中指标来更改被选中区域指标的选中状态
	参数：
		指标id
		
*/
function treeTableFlushColumnDiv(columnId){
	if($("#treeTableDimColumnDiv>ul>li span[id='treeTableDimColumn_"+columnId+"']").size()==0
	   &&$("#treeTableKpiColumnDiv>ul>li span[id='treeTableKpiColumn_"+columnId+"']").size()==0
	   &&$("#treeTableDrillColumnDiv>ul>li span[id='treeTableDrillColumn_"+columnId+"']").size()==0){
	 	$("#treeTableColumnCheckbox_"+columnId).iCheck('uncheck');
	 	treeTableEnableOrDisabledSelectAllCol();
	}else{
		$("#treeTableColumnCheckbox_"+columnId).iCheck('check');
	}
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
       	var treeTableDrillColumnSpan=$("#treeTableDrillColumnDiv>ul>li span[id='treeTableDrillColumn_"+treeTableColumnId+"']");
       	if(treeTableDrillColumnSpan.size()>0){
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
				info.tablecoldesc=dimColumnDesc;
				
				freeTrtd.text(dimColumnDesc);
				freeTrtd.attr("data-treeTableDataTdType","dim");
				tempLastRowCell=treeTableFindLastRowCellByTdInd(componentId,freeTrtd.attr("tdInd"));
				$(tempLastRowCell).text(dimColumnDesc);
				
				treeTableMoveCell(componentId,treeTablerowcode,freeTrTdColCode,$(treeTableFirstTrTh[a+1]).text());
				
				TreeTableEvent.setDimCol(reportId,containerId,componentId,treeTablerowcode,$(treeTableFirstTrTh[a+1]).text(),info,freeTrTdColCode);
				break;
			}
		}
		treeTableEnableOrDisabledSelectAllCol();
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
	
	
	if(continueFlag){
		if(!treeTableInsertKpiColumnHtml(kpiColumnId,kpiColumnName,kpiColumnDesc,true)){
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
				info.datacolid=kpiColumnId;
				info.datacolcode=kpiColumnName;
				info.datacoldesc=kpiColumnDesc;
				info.tablecoldesc=kpiColumnDesc;
				var extcolumnid = $("#treeTableColumn_"+info.datacolid).attr("extcolumnid");
				extcolumnid = extcolumnid==undefined?"":extcolumnid;
				info.extcolumnid=extcolumnid;
				TreeTableEvent.setKpiCol(reportId,containerId,componentId,treeTablerowcode,$(treeTableFirstTrTh[a+1]).text(),info);
				break;
			}
		}
		treeTableEnableOrDisabledSelectAllCol();
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
	var extcolumnid;
	var continueFlag=true;
	for(var i=0;i<columnList.length;i++){
		kpiColumnId=columnList[i]["columnId"];
		kpiColumnName=columnList[i]["columnName"];
		kpiColumnDesc=columnList[i]["columnDesc"];
		extcolumnid = columnList[i]["extcolumnid"];
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
				cellInfo.tablecoldesc=kpiColumnDesc;
				cellInfo.tablerowcode=treeTablerowcode;
				cellInfo.tablecolcode=$(treeTableFirstTrTh[a+1]).text();
				cellInfo.extcolumnid = extcolumnid;
				cellInfoList.push(cellInfo);
				break;
			}
		}
	}
	treeTableEnableOrDisabledSelectAllCol();
	if(continueFlag){
		TreeTableEvent.setMoreKpiCol(reportId,containerId,componentId,cellInfoList);
	}
	
	
}
/** 描述：通过字段名称找编码字段名称，未找到时返回字段名称
	参数：
		datasourceId 数据源id
		nameColumn 字段名称
*/
function treeTableFindCodeColumByColumn(nameColumn){
	var codeColumn=nameColumn;
	var datasourceId=$("#treeTableDataSource").combobox("getValue");
	var columns=$.ajax({url: appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+datasourceId,type:"POST",cache: false,async: false}).responseText;
	columns=$.parseJSON(columns);
	var tempDrillCodeColumn='';
	for(var a=0;a<columns.length;a++){
		tempDrillCodeColumn=nameColumn+"_CODE";
		if(columns[a]["text"]==tempDrillCodeColumn){
			codeColumn=tempDrillCodeColumn;
			break;
		}
		tempDrillCodeColumn=nameColumn+"_NO";
		if(columns[a]["text"]==tempDrillCodeColumn){
			codeColumn=tempDrillCodeColumn;
			break;
		}
		tempDrillCodeColumn=nameColumn+"_ID";
		if(columns[a]["text"]==tempDrillCodeColumn){
			codeColumn=tempDrillCodeColumn;
			break;
		}
		tempDrillCodeColumn=nameColumn.replace(/_DESC$/g,"_CODE");
		if(tempDrillCodeColumn!=nameColumn&&columns[a]["text"]==tempDrillCodeColumn){
			codeColumn=tempDrillCodeColumn;
			break;
		}
		tempDrillCodeColumn=nameColumn.replace(/_DESC$/g,"_NO");
		if(tempDrillCodeColumn!=nameColumn&&columns[a]["text"]==tempDrillCodeColumn){
			codeColumn=tempDrillCodeColumn;
			break;
		}
		tempDrillCodeColumn=nameColumn.replace(/_DESC$/g,"_ID");
		if(tempDrillCodeColumn!=nameColumn&&columns[a]["text"]==tempDrillCodeColumn){
			codeColumn=tempDrillCodeColumn;
			break;
		}
		tempDrillCodeColumn=nameColumn.replace(/_NAME$/g,"_CODE");
		if(tempDrillCodeColumn!=nameColumn&&columns[a]["text"]==tempDrillCodeColumn){
			codeColumn=tempDrillCodeColumn;
			break;
		}
		tempDrillCodeColumn=nameColumn.replace(/_NAME$/g,"_NO");
		if(tempDrillCodeColumn!=nameColumn&&columns[a]["text"]==tempDrillCodeColumn){
			codeColumn=tempDrillCodeColumn;
			break;
		}
		tempDrillCodeColumn=nameColumn.replace(/_NAME$/g,"_ID");
		if(tempDrillCodeColumn!=nameColumn&&columns[a]["text"]==tempDrillCodeColumn){
			codeColumn=tempDrillCodeColumn;
			break;
		}
	}
	var exitFlag=false;
	for(var b=0;b<columns.length;b++){
		if(codeColumn==columns[b]["text"]){
			exitFlag=true;
		}
	}
	
	if(!exitFlag){
		codeColumn="";
	}
	return codeColumn;
}

/** 描述：通过字段名称猜测字段描述，未找到时返回字段名称
	参数：
		nameColumn 字段名称
*/
function treeTableFindDescByColumn(nameColumn){
	var columnDesc=nameColumn;
	for(var x=0;x<treeTableDrillKeyValueArray.length;x++){
		if(treeTableDrillKeyValueArray[x]["key"]!=null&&
			treeTableDrillKeyValueArray[x]["key"]!=undefined
			&&nameColumn.toLowerCase().indexOf(treeTableDrillKeyValueArray[x]["key"].toLowerCase())>-1){
			columnDesc=treeTableDrillKeyValueArray[x]["value"];
			break;
		}
	
	}
	return columnDesc;
}

/** 描述：通过字段名称猜测约束编码，未找到时返回字段名称
	参数：
		nameColumn 字段名称
*/
function treeTableFindDimsionCodeByColumn(nameColumn){
	var dimsionCode='';
	var dimsionCode=nameColumn;
	var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+StoreData.xid+'&isTempFile=1',type:"POST",cache: false,async: false}).responseText;
	dimsionsJson=$.parseJSON(dimsionsJson);
	var codeColumn=nameColumn;
	dimsionCode=codeColumn;
	for(var a=0;a<dimsionsJson.length;a++){
		if(dimsionsJson[a]["varname"]!=null){
			if(dimsionsJson[a]["varname"].toLowerCase()==codeColumn.toLowerCase()||dimsionsJson[a]["varname"].toLowerCase().replace(/_/g,"")==codeColumn.toLowerCase()){
				dimsionCode=dimsionsJson[a]["varname"];
				break;
			}else if(dimsionsJson[a]["varname"].toLowerCase()==nameColumn.toLowerCase()||dimsionsJson[a]["varname"].toLowerCase().replace(/_/g,"")==nameColumn.toLowerCase()){
				dimsionCode=nameColumn;
			}
			
		}
	}
	return dimsionCode;
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
	var datasourceId=$("#treeTableDataSource").combobox("getValue");
	var info={};
	info.drillcolcodeid=drillColumnId;
	info.drillcolcode=treeTableFindCodeColumByColumn(drillColumnName);
	var tempDrillcolcode=null;
	for(var x=0;x<treeTableDrillKeyValueArray.length;x++){
		if(drillColumnName.indexOf(treeTableDrillKeyValueArray[x]["value"])>-1){
			tempDrillcolcode=treeTableFindCodeColumByColumn(treeTableDrillKeyValueArray[x]["key"]);
			if(tempDrillcolcode!=""){
				info.drillcolcode=tempDrillcolcode;
			}
			break;
		}
	
	}
	info.drillcode=treeTableFindDimsionCodeByColumn(info.drillcolcode);
	if(treeTableCheckContainChinese(info.drillcode)){
		info.drillcode="C"+LayOutUtil.uuid();
	}
	info.drillcoltitle=treeTableFindDescByColumn(drillColumnName);
	info.drillcoldesc=drillColumnName;
	info.datasourceid=datasourceId.substring(1);
	
	//info.drillsortcolcode=info.drillcolcode;
	var drillcolSortcolList=[];
	var drillcolsortcol={};
	drillcolsortcol.colcode=info.drillcolcode;//colcode sorttype kpitype
	
	drillcolSortcolList.push(drillcolsortcol);
	info.drillcolSortcolList=drillcolSortcolList;
	
	treeTableEnableOrDisabledSelectAllCol();
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

/** 描述：生成向下钻区域中添加指标的html代码（为了保证插入html的js的惟一性而独立出来的）
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

function treeTableDrillInitDrillProperty(reportId,containerId,componentId){
	var subdrillJson=$.ajax({url: appBase+"/getAllSubdrillsJsonJsonX.e?report_id="+reportId+'&containerId='+containerId+'&componentId='+componentId,type:"POST",cache: false,async: false}).responseText;
	subdrillJson=$.parseJSON(subdrillJson);
	for(var a=0;a<subdrillJson.length;a++){
		subdrillJson[a]["id"]=a;
	}
	
	$("#treeTableDrillColSelector").combobox({
		valueField:'id',
		textField:'drillcoldesc',
		multiple:false,
		editable:false,
		panelHeight:160,
		editable:false,
		onSelect:treeTableDrillColSelectorSelect
	}).combobox('loadData', subdrillJson);
	$("#treeTableDrillCode").combobox({
		valueField:'varname',
		textField:'varname',
		multiple:false,
		panelHeight:160,
		editable:true,
		onChange:treeTableDrillSetCode
	});
	$("#treeTableDrillDatasourceId").combobox({
		valueField:'id',
		textField:'text',
		multiple:false,
		editable:false,
		panelHeight:160,
		editable:false,
		onSelect:treeTableDrillSetDatasourceId
	});
	
	$("#treeTableDrillCodecolCode").combobox({
		valueField:'text',
		textField:'text',
		multiple:false,
		editable:false,
		panelHeight:160,
		editable:false,
		onSelect:treeTableDrillSetCodecolCode
	});
	$("#treeTableDrillDesccolCode").combobox({
		valueField:'text',
		textField:'text',
		multiple:false,
		editable:false,
		panelHeight:160,
		disabled:true,
		onSelect:treeTableDrillSetDesccolCode
	});
	$("#treeTableDrillSortcolCode").combobox({
		valueField:'id',
		textField:'text',
		multiple:false,
		editable:false,
		panelWidth:220,
		panelHeight:160,
		onSelect:treeTableDrillSetChangeSortcol
	});
	$("#treeTableDrillSortcolKpiType").combobox({
		valueField:'id',
		textField:'text',
		multiple:false,
		editable:false,
		panelWidth:60,
		panelHeight:160,
		onSelect:treeTableDrillSetSaveSortcol
	});
	$("#treeTableDrillSortcolType").combobox({
		valueField:'id',
		textField:'text',
		multiple:false,
		editable:false,
		panelWidth:60,
		panelHeight:160,
		onSelect:treeTableDrillSetSaveSortcol
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
	
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	$selectTds.attr("data-treeTableDrillColSelector",drillColSelector);
	
	var subdrillJson=$.ajax({url: appBase+"/getAllSubdrillsJsonJsonX.e?report_id="+reportId+'&containerId='+containerId+'&componentId='+componentId,type:"POST",cache: false,async: false}).responseText;
	subdrillJson=$.parseJSON(subdrillJson);
	
	var selectableLastTrTds=$("#selectable_"+componentId+" tr:last>td");
	var subdrillSortTypeJson=[{"id":"asc","text":"正序"},{"id":"desc","text":"倒序"}];
	var subdrillSortKpiTypeJson=[{"id":"dim","text":"维度"},{"id":"kpi","text":"指标"}];
	for(var a=0;a<subdrillJson.length;a++){
		if(drillColSelector==a){
			var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+reportId+'&isTempFile=1',type:"POST",cache: false,async: false}).responseText;
			dimsionsJson=$.parseJSON(dimsionsJson);
			var datasourceJson=$.ajax({url: appBase+"/getAllDataSourceJsonX.e?report_id="+reportId,type:"POST",cache: false,async: false}).responseText;
			datasourceJson = $.evalJSON(datasourceJson);
			var datasourceId=subdrillJson[a]["datasourceid"]
			var columnsJson=$.ajax({url: appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+reportId+"&report_sql_id=B"+datasourceId,type:"POST",cache: false,async: false}).responseText;
			columnsJson=$.parseJSON(columnsJson);
			
			//获得计算列
			var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+reportId+"&report_sql_id=B"+datasourceId;
			var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
			for(var i=0;i<extData.length;i++){
				columnsJson.push({id:"C"+extData[i].name,text:extData[i].name,extcolumnid:extData[i].id});
			}
			
			var subdrillSortcolJson=[];
			
			for(var i=0;i<columnsJson.length;i++){
				if(columnsJson[i]["text"]==subdrillJson[a]["drillcolcode"]){
					var subdrillSortcolInfo={};
					subdrillSortcolInfo["id"]=columnsJson[i]["id"]+"&&&"+"dim";
					subdrillSortcolInfo["text"]=columnsJson[i]["text"];
					subdrillSortcolJson.push(subdrillSortcolInfo);
					break;
				}
			}
			
			for(var i=0;i<columnsJson.length;i++){
				if(columnsJson[i]["text"]==subdrillJson[a]["drillcoldesc"]&&subdrillJson[a]["drillcolcode"]!=subdrillJson[a]["drillcoldesc"]){
					var subdrillSortcolInfo={};
					subdrillSortcolInfo["id"]=columnsJson[i]["id"]+"&&&"+"dim";
					subdrillSortcolInfo["text"]=columnsJson[i]["text"];
					subdrillSortcolJson.push(subdrillSortcolInfo);
					break;
				}
			}
			
			for(var i=0;i<columnsJson.length;i++){
				if(selectableLastTrTds.size()>1){
					for(var j=1;j<selectableLastTrTds.size();j++){
						if($(selectableLastTrTds[j]).text()==columnsJson[i]["text"]){
							var subdrillSortcolInfo={};
							subdrillSortcolInfo["id"]=columnsJson[i]["id"]+"&&&"+$(selectableLastTrTds[j]).attr("data-treetabledatatdtype");
							if(columnsJson[i]["extcolumnid"]!=''&&columnsJson[i]["extcolumnid"]!=null&&columnsJson[i]["extcolumnid"]!=undefined&&columnsJson[i]["extcolumnid"]!='null'){
								subdrillSortcolInfo["id"]=subdrillSortcolInfo["id"]+"&&&"+columnsJson[i]["extcolumnid"];
							}
							subdrillSortcolInfo["text"]=columnsJson[i]["text"];
							subdrillSortcolJson.push(subdrillSortcolInfo);
							break;
						}
					}
				}
			}
			for(var i=0;i<columnsJson.length;i++){
				var isExitFlagInJson=false;
				for(var j=0;j<subdrillSortcolJson.length;j++){
					if(subdrillSortcolJson[j]["text"]==columnsJson[i]["text"]){
						isExitFlagInJson=true;
						break;
					}
				}
				if(!isExitFlagInJson){
					var subdrillSortcolInfo={};
					if(columnsJson[i]["extcolumnid"]!=''&&columnsJson[i]["extcolumnid"]!=null&&columnsJson[i]["extcolumnid"]!=undefined&&columnsJson[i]["extcolumnid"]!='null'){
						subdrillSortcolInfo["id"]=columnsJson[i]["id"]+"&&&"+"kpi"+"&&&"+columnsJson[i]["extcolumnid"];;
					}else{
						subdrillSortcolInfo["id"]=columnsJson[i]["id"]+"&&&"+"none";
					}
					subdrillSortcolInfo["text"]=columnsJson[i]["text"];
					subdrillSortcolJson.push(subdrillSortcolInfo);
				}
			}
			
			$("#treeTableDrillCode").combobox('loadData', dimsionsJson);
			$("#treeTableDrillDatasourceId").combobox('loadData', datasourceJson);
			$("#treeTableDrillCodecolCode").combobox('loadData', columnsJson);
			$("#treeTableDrillDesccolCode").combobox('loadData', columnsJson);
			var subdrillSortcolList=subdrillJson[a]["subdirllsortcols"]["subdirllsortcolList"];
			var subdrillSortcolHtmlStr="";
			var subdrillSortcolDd=$("#treeTableDrillSortcolDd");
			subdrillSortcolDd.html("");
			for(var x=0;x<subdrillSortcolList.length;x++){
				subdrillSortcolHtmlStr+='<p class="treeTableDrillP">';
				subdrillSortcolHtmlStr+='<input id="treeTableDrillSortcolCode'+x+'"  name="treeTableDrillSortcolCode" value="请选择">';
				subdrillSortcolHtmlStr+='<input id="treeTableDrillSortcolKpiType'+x+'"  name="treeTableDrillSortcolKpiType" value="请选择">';
				subdrillSortcolHtmlStr+='<input id="treeTableDrillSortcolType'+x+'"  name="treeTableDrillSortcolType" value="请选择">';
				subdrillSortcolHtmlStr+='</p>';
				subdrillSortcolDd.append(subdrillSortcolHtmlStr);
				$("#treeTableDrillSortcolCode"+x).combobox({
					valueField:'id',
					textField:'text',
					multiple:false,
					editable:false,
					panelWidth:220,
					panelHeight:160,
					onSelect:treeTableDrillSetChangeSortcol
				}).combobox('loadData', subdrillSortcolJson).combobox("setText",subdrillSortcolList[x]["colcode"]);
				
				var treeTableDrillSortcolCodeKpiType='none';
				var treeTableDrillSortcolCodeIdArray=[];
				for(var y=0;y<subdrillSortcolJson.length;y++){
					if(subdrillSortcolJson[y]["text"]==subdrillSortcolList[x]["colcode"]){
						treeTableDrillSortcolCodeIdArray=subdrillSortcolJson[y]["id"].split("&&&");
						break;
					}
				}
				if(treeTableDrillSortcolCodeIdArray.length>1){
					treeTableDrillSortcolCodeKpiType=treeTableDrillSortcolCodeIdArray[1];
				}
				$("#treeTableDrillSortcolKpiType"+x).combobox({
					valueField:'id',
					textField:'text',
					multiple:false,
					editable:false,
					panelWidth:60,
					panelHeight:160,
					onSelect:treeTableDrillSetSaveSortcol
				}).combobox('loadData', subdrillSortKpiTypeJson);
				if(treeTableDrillSortcolCodeKpiType!='none'){
					$("#treeTableDrillSortcolKpiType"+x).combobox("setValue",treeTableDrillSortcolCodeKpiType).combobox("disable");
				}else{
					if(subdrillSortcolList[x]["sortkpitype"]==''||subdrillSortcolList[x]["sortkpitype"]==null){
						$("#treeTableDrillSortcolKpiType"+x).combobox("setValue","请选择").combobox("enable");
					}else{
						$("#treeTableDrillSortcolKpiType"+x).combobox("setValue",subdrillSortcolList[x]["sortkpitype"]).combobox("enable");
					}
					
				}
				
				$("#treeTableDrillSortcolType"+x).combobox({
					valueField:'id',
					textField:'text',
					multiple:false,
					editable:false,
					panelWidth:60,
					panelHeight:160,
					onSelect:treeTableDrillSetSaveSortcol
				}).combobox('loadData', subdrillSortTypeJson).combobox("setValue",subdrillSortcolList[x]["sorttype"]);
			}
			
			$("#treeTableDrillName").val(subdrillJson[a]["drillcoltitle"]);
			$("#treeTableDrillCode").combobox("setText",subdrillJson[a]["drillcode"]);
			$("#treeTableDrillDatasourceId").combobox("setValue",'B'+datasourceId);
			$("#treeTableDrillCodecolCode").combobox("setValue",subdrillJson[a]["drillcolcode"]);
			$("#treeTableDrillDesccolCode").combobox("setValue",subdrillJson[a]["drillcoldesc"]);
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

/** 描述：设置数据集
	参数：
		
*/
function treeTableDrillSetDatasourceId(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	var drillDatasourceId=$("#treeTableDrillDatasourceId").combobox("getValue");
	var columnsJson=$.ajax({url: appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+reportId+"&report_sql_id="+drillDatasourceId,type:"POST",cache: false,async: false}).responseText;
	columnsJson=$.parseJSON(columnsJson);
	var drillCodecolCode=$("#treeTableDrillCodecolCode").combobox("getValue");
	var drillDesccolCode=$("#treeTableDrillDesccolCode").combobox("getValue");
	$("#treeTableDrillCodecolCode").combobox('loadData', columnsJson);//
	$("#treeTableDrillDesccolCode").combobox('loadData', columnsJson);//.combobox("setValue",drillDesccolCode);
	var tempDrillCodecolCode=null;
	var tempDrillDesccolCode=null;
	for(var i=0;i<columnsJson.length;i++){
		if(drillCodecolCode!=""&&drillCodecolCode!=undefined&&drillCodecolCode==columnsJson[i]["text"]){
			tempDrillCodecolCode=drillCodecolCode;
		}
		if(drillDesccolCode!=""&&drillDesccolCode!=undefined&&drillDesccolCode==columnsJson[i]["text"]){
			tempDrillDesccolCode=drillDesccolCode;
		}
	}
	
	
	if(tempDrillDesccolCode==null){
		$.messager.alert("下钻表格","修改数据集失败，该数据集中不存在下钻描述列“"+drillDesccolCode+"”","error");
		var oldDatasourceId=$.ajax({url: appBase+"/getDataSourceIdJsonX.e?reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId,type:"POST",cache: false,async: false}).responseText;
		$("#treeTableDrillDatasourceId").combobox("setValue","B"+oldDatasourceId);
		
		return false;
	}else{
		$("#treeTableDrillDesccolCode").combobox("setValue",tempDrillDesccolCode);
	}
	
	if(tempDrillCodecolCode==null){
		$("#treeTableDrillCodecolCode").combobox("setValue",tempDrillDesccolCode);
	}else{
		$("#treeTableDrillCodecolCode").combobox("setValue",tempDrillCodecolCode);
	}
	
	drillDatasourceId=drillDatasourceId.substring(1);
	TreeTableEvent.setDrillDatasourceId(reportId,containerId,componentId,drillColSelector,drillDatasourceId);
}

/** 描述：设置下钻编码列
	参数：
		
*/
function treeTableDrillSetCodecolCode(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	var drillCodecolCode=$("#treeTableDrillCodecolCode").combobox("getValue");
	TreeTableEvent.setDrillCodecolCode(reportId,containerId,componentId,drillColSelector,drillCodecolCode);
}
/** 描述：设置下钻描述列
	参数：
		
*/
function treeTableDrillSetDesccolCode(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	var drillDesccolCode=$("#treeTableDrillDesccolCode").combobox("getValue");
	TreeTableEvent.setDrillDesccolCode(reportId,containerId,componentId,drillColSelector,drillDesccolCode);
}

/** 描述：设置下钻编码和下钻描述
	参数：
		
*/
function treeTableDrillSetCodecolAndDesccolCode(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	var drillCodecolCode=$("#treeTableDrillCodecolCode").combobox("getValue");
	var drillDesccolCode=$("#treeTableDrillDesccolCode").combobox("getValue");
	if(drillCodecolCode=='请选择'){
		drillCodecolCode="";
	}
	if(drillDesccolCode=='请选择'){
		drillDesccolCode="";
	}
	TreeTableEvent.setDrillCodecolAndDesccolCode(reportId,containerId,componentId,drillColSelector,drillCodecolCode,drillDesccolCode);
}

/** 描述：设置下钻排序列后，指标类型的变动并保存下钻排序指标(全量设置)
	参数：
		
*/
function treeTableDrillSetChangeSortcol(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	var drillSorstcolCodesSize=$("input[id^='treeTableDrillSortcolCode']").size();
								
	var drillSortcolList=[];
	for(var a=0;a<drillSorstcolCodesSize;a++){
		var subdrillSortcolKpiType='none';
		var subdrillSortcolIdArray=($("#treeTableDrillSortcolCode"+a).combobox("getValue")).split("&&&");
		if(subdrillSortcolIdArray!=undefined&&subdrillSortcolIdArray.length>1){
			subdrillSortcolKpiType=subdrillSortcolIdArray[1];
		}
		if(subdrillSortcolKpiType!=null&&subdrillSortcolKpiType!='none'){
			$("#treeTableDrillSortcolKpiType"+a).combobox("setValue",subdrillSortcolKpiType).combobox("disable");
		}else{
			$("#treeTableDrillSortcolKpiType"+a).combobox("setValue","请选择").combobox("enable");
		}
	}
	treeTableDrillSetSaveSortcol();
}

/** 描述：设置下钻排序指标(全量设置)
	参数：
		
*/
function treeTableDrillSetSaveSortcol(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	var drillSorstcolCodesSize=$("input[id^='treeTableDrillSortcolCode']").size();
								
	var drillSortcolList=[];
	for(var a=0;a<drillSorstcolCodesSize;a++){
		var subdrillSortcolInfo={};
		subdrillSortcolInfo.colcode=$("#treeTableDrillSortcolCode"+a).combobox("getText");
		subdrillSortcolInfo.sortkpitype=$("#treeTableDrillSortcolKpiType"+a).combobox("getValue");
		if(subdrillSortcolInfo.sortkpitype=='请选择'){
			subdrillSortcolInfo.sortkpitype='';
		}
		subdrillSortcolInfo.sorttype=$("#treeTableDrillSortcolType"+a).combobox("getValue");
		var colcodeValue=$("#treeTableDrillSortcolCode"+a).combobox("getValue");
		var colcodeValueArray=colcodeValue.split("&&&");
		if(colcodeValueArray!=null&&colcodeValueArray.length>2){
			subdrillSortcolInfo.extcolumnid = colcodeValueArray[2];
		}
		drillSortcolList.push(subdrillSortcolInfo);
	}
	TreeTableEvent.setDrillSortcol(reportId,containerId,componentId,drillColSelector,drillSortcolList);
}

/** 描述：设置下钻编码列后同步设置下钻排序列
	参数：
		
*/
function treeTableSynDrillSetSortcolCode(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var drillColSelector=$("#treeTableDrillColSelector").combobox("getValue");
	var drillCodecolCodeValue=$("#treeTableDrillCodecolCode").combobox("getValue");
	var drillCodecolCodeText=$("#treeTableDrillCodecolCode").combobox("getText");
	var drillDesccolCodeText=$("#treeTableDrillDesccolCode").combobox("getText");
	var selectableLastTrTds=$("#selectable_"+componentId+" tr:last>td");
	var datasourceId=$("#treeTableDrillDatasourceId").combobox("getValue");
	var columnsJson=$.ajax({url: appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+reportId+"&report_sql_id="+datasourceId,type:"POST",cache: false,async: false}).responseText;
	columnsJson=$.parseJSON(columnsJson);
	//获得计算列
	var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+reportId+"&report_sql_id="+datasourceId;
	var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
	for(var i=0;i<extData.length;i++){
		columnsJson.push({id:"C"+extData[i].name,text:extData[i].name,extcolumnid:extData[i].id});
	}
	var subdrillSortcolJson=[];
	for(var i=0;i<columnsJson.length;i++){
		
		if(columnsJson[i]["text"]==drillCodecolCodeText){
			var subdrillSortcolInfo={};
			subdrillSortcolInfo["id"]=columnsJson[i]["id"]+"&&&"+"dim";
			subdrillSortcolInfo["text"]=columnsJson[i]["text"];
			subdrillSortcolJson.push(subdrillSortcolInfo);
			break;
		}
	}
	for(var i=0;i<columnsJson.length;i++){
		if(columnsJson[i]["text"]==drillDesccolCodeText&&drillCodecolCodeText!=drillDesccolCodeText){
			var subdrillSortcolInfo={};
			subdrillSortcolInfo["id"]=columnsJson[i]["id"]+"&&&"+"dim";
			subdrillSortcolInfo["text"]=columnsJson[i]["text"];
			subdrillSortcolJson.push(subdrillSortcolInfo);
			break;
		}
	}
	
	for(var i=0;i<columnsJson.length;i++){
		if(selectableLastTrTds.size()>1){
			for(var j=1;j<selectableLastTrTds.size();j++){
				if($(selectableLastTrTds[j]).text()==columnsJson[i]["text"]){
					var subdrillSortcolInfo={};
					subdrillSortcolInfo["id"]=columnsJson[i]["id"]+"&&&"+"kpi";
					if(columnsJson[i]["extcolumnid"]!=''&&columnsJson[i]["extcolumnid"]!=null&&columnsJson[i]["extcolumnid"]!=undefined&&columnsJson[i]["extcolumnid"]!='null'){
						subdrillSortcolInfo["id"]=subdrillSortcolInfo["id"]+"&&&"+columnsJson[i]["extcolumnid"];
					}
					subdrillSortcolInfo["text"]=columnsJson[i]["text"];
					subdrillSortcolJson.push(subdrillSortcolInfo);
					break;
				}
			}
		}
	}
	for(var i=0;i<columnsJson.length;i++){
		var isExitFlagInJson=false;
		for(var j=0;j<subdrillSortcolJson.length;j++){
			if(subdrillSortcolJson[j]["text"]==columnsJson[i]["text"]){
				isExitFlagInJson=true;
				break;
			}
		}
		if(!isExitFlagInJson){
			var subdrillSortcolInfo={};
			if(columnsJson[i]["extcolumnid"]!=''&&columnsJson[i]["extcolumnid"]!=null&&columnsJson[i]["extcolumnid"]!=undefined&&columnsJson[i]["extcolumnid"]!='null'){
				subdrillSortcolInfo["id"]=columnsJson[i]["id"]+"&&&"+"kpi"+"&&&"+columnsJson[i]["extcolumnid"];;
			}else{
				subdrillSortcolInfo["id"]=columnsJson[i]["id"]+"&&&"+"none";
			}
			subdrillSortcolInfo["text"]=columnsJson[i]["text"];
			subdrillSortcolJson.push(subdrillSortcolInfo);
		}
	}
		

	
	var subdrillSortcolSize=$("input[id^='treeTableDrillSortcolCode']").size();
	for(var a=0;a<subdrillSortcolSize;a++){
		var tempDrillSortcollCode=$("#treeTableDrillSortcolCode"+a).combobox("getText");
		$("#treeTableDrillSortcolCode"+a).combobox('loadData', subdrillSortcolJson).combobox("setText",tempDrillSortcollCode);
	}
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

/**---------------------------------------------------------计算列开始-------------------------------------------------------*/


/**
 * 更新数据集UI
 */
function treeTableUpdataDatasetUI(action){
	var columnId = treeTableCaculateColumn.currentEditColumnObj.id;
	var columnName = treeTableCaculateColumn.currentEditColumnObj.name;
	//添加计算列成功后更新候选列区域
	if(action=="add"){
		var tableColumnUl=$("#treeTableColumnDiv>ul");
		var tableColumnHtmlStr=treeTableGenerationExtColumnDivLiHtml(columnId,columnName,columnName);
		tableColumnUl.append(tableColumnHtmlStr);
		treeTableInitColumnDiv();
		$("input[name='treeTableColumn']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	var columnId=$(this).attr("data-columnId");
		  	treeTableChecktreeTableColumn($(this).attr("data-columnId"),$(this).attr("data-columnName"),$(this).attr("data-columnDesc"));
		  	window.setTimeout(function(){ treeTableFlushColumnDiv(columnId);},1000); 
		});
		$("#treeTableColumn_C"+columnName).attr("extcolumnid",columnId);
		$.parser.parse($("#treeTableColumnDiv"));
	}else if(action=="edit"){//编辑计算列成功后更新候选列区域
		$("#treeTableColumnDiv span[extcolumnid="+columnId+"]").parent().prop('outerHTML', treeTableGenerationExtColumnDivLiHtml(columnId,columnName,columnName));
		treeTableInitColumnDiv();
		$("input[name='treeTableColumn']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	var columnId=$(this).attr("data-columnId");
		  	treeTableChecktreeTableColumn($(this).attr("data-columnId"),$(this).attr("data-columnName"),$(this).attr("data-columnDesc"));
		  	window.setTimeout(function(){ treeTableFlushColumnDiv(columnId);},1000); 
		});
		$.parser.parse($("#treeTableColumnDiv"));
		//下面代码实现，修改了指标时，维度区域指标区域排序区域和候选列区域要跟着联动功能
		var oldName = treeTableCaculateColumn.getColumnOldName();
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
					if($("span[name='treeTableKpiColumn_"+oldName+"']").size()>0){
						var tablerowcode=$(dataTrTd[a]).attr("istt").substring(2);
						var info={};
						info.datacolid="C"+columnName;
						info.datacolcode=columnName;
						info.datacoldesc=columnName;
						info.tablecoldesc=columnName;
						var extcolumnid = $("#treeTableColumn_C"+columnName).attr("extcolumnid");
						extcolumnid = extcolumnid==undefined?"":extcolumnid;
						info.extcolumnid=extcolumnid;
						TreeTableEvent.setKpiCol(StoreData.xid,StoreData.curContainerId,componentId,tablerowcode,$(tableFirstTrTh[a+1]).text(),info);
					}
				}
			}
		}
		if($("span[name='treeTableKpiColumn_"+oldName+"']").size()>0){
			$("#treeTableColumnCheckbox_C"+columnName).iCheck("check");
			if(oldName!=columnName){
				var columnHtml = treeTableGenerationKpiColumnHtml("C"+columnName,columnName,columnName);
				$("span[name='treeTableKpiColumn_"+oldName+"']").parent().parent().prop('outerHTML',columnHtml);
				
			}
		}
	}else if(action=="remove"){//删除计算列成功后更新候选列区域
		var info = {reportId:StoreData.xid,extcolumnid:columnId};
		cn.com.easy.xbuilder.service.component.TreegridService.removeExtcolumn(info,function(data,exception){
			if(exception!=undefined){
				$.messager.alert("下钻表格","删除计算列出错！<br/>"+exception,"error");
			}else{
				var columnName = $("span[extcolumnid="+columnId+"]").text();
				$("span[extcolumnid="+columnId+"]").parent().remove();
				if($("#treeTableKpiColumn_C"+columnName).size()>0){
					treeTableRemoveKpiColoumnLi("C"+columnName,columnName,columnName);
				}
			}
		});
		
	}
}

/**
 * 删除计算列
 * @param extcolumnid
 */
function treeTableRemoveExtcolumn(extcolumnid){
	treeTableCaculateColumn.removeCaculateCol(extcolumnid);
}

/**
 * 修改计算列
 * @param extcolumnid
 */
function treeTableEditExtcolumn(extcolumnid){
	treeTableCaculateColumn.init();
	treeTableCaculateColumn.open();
	treeTableCaculateColumn.currentAction="edit";
	treeTableCaculateColumn.switchEnable(true);
	treeTableCaculateColumn.closeWhenEditFinish=true;
	treeTableCaculateColumn.restoreCaculateColumn(extcolumnid);//回显计算列
}

/**-------------------------------------------------------计算列结束----------------------------------------------------------------------------------*/


