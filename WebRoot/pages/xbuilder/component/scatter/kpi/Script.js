function scatter_initDroppable(){
	$("input[readonly='readonly']").droppable({
		onDragEnter:function(e,source){
			$(this).css('background','#ccc');
			$(source).draggable('options').cursor='auto';
		},
		onDragLeave:function(e,source){
			$(this).css('background','#fff');
			$(source).draggable('options').cursor='not-allowed';
		},
		onDrop:function(e,source){
			$(this).css('background','#fff');
			if($(source).attr("key")==undefined){//计算列窗口指标不能拖动到此div
				return;
			}
			$("#curSelectInput").val($(this).attr("id"));
			if($(source).attr("node-id")==undefined){//指标库选择
				selectScatterKpiSuccess(scatterKpiSelector.currentItem);
			}else{//计算列选择
				var itemObj = {
						id:"",
						column:"",
						desc:$(source).attr("desc"),
						kpiType:'extcolumn',
						extcolumnid:$(source).attr("node-id"),
						isextcolumn:'true'
				}
				selectScatterKpiSuccess(itemObj);
			}
		}
	});
}

/**
 * 设置维度列
 */
function scatter_fun_SetDim(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var dimension = $("#scatter_dim").attr("kpiColumn");
	if(typeof(dimension)!="undefined"&&dimension!=""){
		info.dimFieldId = $("#scatter_dim").attr("kpiId");
		info.dimension=dimension;
		info.isextcolumn = "false";
		cn.com.easy.xbuilder.service.component.ScatterService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	} 
}

/**
 * 设置最小粒度列
 */
function scatter_fun_SetMinDim(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var dimension = $("#scatter_min_dim").attr("kpiColumn");
	if(typeof(dimension)!="undefined"&&dimension!=""){
		info.minDimId = $("#scatter_min_dim").attr("kpiId");
		info.minDim=dimension;
		info.isextcolumn = "false";
		cn.com.easy.xbuilder.service.component.ScatterService.setMinDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	} 
}

/**
 * 设置指标
 */
function scatter_fun_SetKpi(){
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var isSameKpi=$("#scatter_kpiX").attr("kpiId")==$("#scatter_kpiY").attr("kpiId")&&$("#scatter_kpiX").attr("isextcolumn")=="false"&&$("#scatter_kpiX").attr("isextcolumn")=="false";
	var isSameExtcolumn = $("#scatter_kpiX").attr("extcolumnid")==$("#scatter_kpiY").attr("extcolumnid")&&$("#scatter_kpiX").attr("isextcolumn")=="true"&&$("#scatter_kpiX").attr("isextcolumn")=="true";
	if(isSameKpi||isSameExtcolumn){
		$.messager.alert("散点图","已选择该指标，不能重复选择！","info");
		var curSelectInputId=$("#curSelectInput").val();
		$("#"+curSelectInputId).val("");
		$("#"+curSelectInputId).attr("kpiId","");
		$("#"+curSelectInputId).attr("kpiColumn","");
		$("#"+curSelectInputId).attr("extcolumnid","");
		$("#"+curSelectInputId).attr("isextcolumn","false");
		var type = curSelectInputId.substr(curSelectInputId.length-1,1);
		$("#scatter_kpi"+type+"_title").val("");
		$("#scatter_kpi"+type+"_unit").val("");
		return;
	}
	var kpiList=[{field:$("#scatter_kpiX").attr("kpiColumn"),
				kpiId:$("#scatter_kpiX").attr("kpiId"),
				title:$("#scatter_kpiX_title").val(),
				unit:$("#scatter_kpiX_unit").val(),
				axisType:'X',
				extcolumnid:$("#scatter_kpiX").attr("extcolumnid")
			},{field:$("#scatter_kpiY").attr("kpiColumn"),
				kpiId:$("#scatter_kpiY").attr("kpiId"),
				title:$("#scatter_kpiY_title").val(),
				unit:$("#scatter_kpiY_unit").val(),
				axisType:'Y',
				extcolumnid:$("#scatter_kpiY").attr("extcolumnid")
			}];
	var info={kpiList:kpiList};
	cn.com.easy.xbuilder.service.component.ScatterService.setKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
}

/**
 * 编辑还原
 */
function scatter_fun_edit(containerId,componentId){
	/*还原*/
	cn.com.easy.xbuilder.service.component.ScatterService.getComponentJsonData(StoreData.xid,containerId,componentId,$.toJSON({}),function(data,exception){
		var jsonObj=$.parseJSON(data);
		if(jsonObj!=null&&jsonObj!=undefined){
			var kpiColMap=jsonObj.kpiColMap;
			/*设置标题*/
			var title = jsonObj.chartTitle;
			if(typeof(title)=="undefined"){
				$("#scatter_title").val(''); 
			}else{ 
				$("#scatter_title").val(title);
			}if(jsonObj.showTitle=="1"){
				$("#showTitle").iCheck('check');
			}else{
				$("#showTitle").iCheck('uncheck');
			}
			/*设置图例*/
			if(jsonObj.legend != undefined){
				scatter_restoreLegendPosition(jsonObj.legend.position);
			}else{
				scatter_setLegend('bottom');
			}
			
		
			/*刻度设置*/
			var yaxisList=jsonObj.yaxisList;
			if(typeof(yaxisList)!="undefined"&&yaxisList!=null){
				for(var i=0;i<yaxisList.length;i++){
					if(yaxisList[i].id=="X"){
						$("#scatter_kpiX_title").val(yaxisList[i].title);
						$("#scatter_kpiX_unit").val(yaxisList[i].unit);
					}else if(yaxisList[i].id=="Y"){
						$("#scatter_kpiY_title").val(yaxisList[i].title);
						$("#scatter_kpiY_unit").val(yaxisList[i].unit);
					}
				}
			} 
			
			/*指标设置*/
			var kpiList=jsonObj.kpiList;
			if(typeof(kpiList)!="undefined"&&kpiList!=null){
				for(var i=0;i<kpiList.length;i++){
					if(kpiList[i].yaxisid=="X"){
						if(kpiList[i].extcolumnid=="") {//指标库指标
							$("#scatter_kpiX").val(kpiColMap[kpiList[i].kpiId].kpidesc);
							$("#scatter_kpiX").attr("isextcolumn","false");
						}else{//计算列指标
							$("#scatter_kpiX").val(kpiColMap[kpiList[i].extcolumnid].kpidesc);
							$("#scatter_kpiX").attr("isextcolumn","true");
						}
						$("#scatter_kpiX").attr("kpiId",kpiList[i].kpiId);
						$("#scatter_kpiX").attr("kpiColumn",kpiList[i].kpiId);
						$("#scatter_kpiX").attr("extcolumnid",kpiList[i].extcolumnid);
					}else if(kpiList[i].yaxisid=="Y"){
						if(kpiList[i].extcolumnid=="") {//指标库指标
							$("#scatter_kpiY").val(kpiColMap[kpiList[i].kpiId].kpidesc);
							$("#scatter_kpiY").attr("isextcolumn","false");
						}else{//计算列指标
							$("#scatter_kpiY").val(kpiColMap[kpiList[i].extcolumnid].kpidesc);
							$("#scatter_kpiY").attr("isextcolumn","true");
						}
						$("#scatter_kpiY").attr("kpiId",kpiList[i].kpiId);
						$("#scatter_kpiY").attr("kpiColumn",kpiList[i].kpiId);
						$("#scatter_kpiY").attr("extcolumnid",kpiList[i].extcolumnid);
					} 
				}
			} 
			
			/*设置选择的颜色列表*/
			if(jsonObj.colors!=""&&jsonObj.colors!=undefined){
				var rgbaColors = jsonObj.colors.split(";");
				var hexColors = "";
				var tempRgb="";
				for(var i=0;i<rgbaColors.length;i++){
					if(rgbaColors[i]!=""){
						tempRgb = rgbaColors[i].replace(",.5","").replace("rgba","rgb")
						hexColors += tempRgb.colorHex()+",";
					}
				}
				hexColors = hexColors.substring(0,hexColors.length-1);
				selectColorRow(hexColors);//ChartColorList.jsp方法
			}
			
			/*设置维度列*/
			if(jsonObj.xaxis!=null&&jsonObj.xaxis!=undefined){
			    $("#scatter_dim").val(kpiColMap[jsonObj.xaxis.dimFiledId].kpidesc); 
			    $("#scatter_dim").attr("kpiId",jsonObj.xaxis.dimFiledId); 
			    $("#scatter_dim").attr("kpiColumn",jsonObj.xaxis.dimfield); 
			    $("#scatter_min_dim").val(kpiColMap[jsonObj.xaxis.scatterDimFieldId].kpidesc); 
			    $("#scatter_min_dim").attr("kpiId",jsonObj.xaxis.scatterDimFieldId); 
			    $("#scatter_min_dim").attr("kpiColumn",jsonObj.xaxis.scatterDimField);
			}
		}else{
		    
		}
	});
	
}

/**
 * 打开指标库选择对话框
 * @param tabInde
 * @param inputId
 */ 
function openScatterKpiDialog(){
	  var cubeId = StoreData.cubeId;
	  scatterKpiSelector.open(cubeId);
}

/**
 * 指标库对话框选择事件
 * @param kpiArr
 */
function selectScatterKpiSuccess(itemObj){
	var kpi = itemObj;
	var kpiType = kpi.kpiType;
	var curSelectInputId=$("#curSelectInput").val();
	if($("#"+curSelectInputId).attr("name")=="scatter_dim"||$("#"+curSelectInputId).attr("name")=="scatter_min_dim"){
		if(kpiType=='kpi'||kpiType=="extcolumn"){
			$.messager.alert("散点图","指标不能作为维度使用！","info");
			return;
		}
	}if($("#"+curSelectInputId).attr("name")=="scatter_kpiX"||$("#"+curSelectInputId).attr("name")=="scatter_kpiY"){
		if(kpiType=='dim'||kpiType=='property'){
			$.messager.alert("散点图",(kpiType=='dim'?"维度":"属性")+"不能作为指标使用！","info");
			return;
		}
		if($("#"+curSelectInputId).attr("name")=="scatter_kpiX"){
			if(kpi.id==$("#scatter_kpiY").attr("kpiId")&&$("#scatter_kpiY").attr("isextcolumn")=="false"){
				$.messager.alert("散点图","已选择该指标，不能重复选择！","info");
				return;
			}
			if(kpi.extcolumnid==$("#scatter_kpiY").attr("extcolumnid")&&$("#scatter_kpiY").attr("isextcolumn")=="true"){
				$.messager.alert("散点图","已选择该指标，不能重复选择！","info");
				return;
			}
		}
		if($("#"+curSelectInputId).attr("name")=="scatter_kpiY"){
			if(kpi.id==$("#scatter_kpiX").attr("kpiId")&&$("#scatter_kpiX").attr("isextcolumn")=="false"){
				$.messager.alert("散点图","已选择该指标，不能重复选择！","info");
				return;
			}
			if(kpi.extcolumnid==$("#scatter_kpiX").attr("extcolumnid")&&$("#scatter_kpiX").attr("isextcolumn")=="true"){
				$.messager.alert("散点图","已选择该指标，不能重复选择！","info");
				return;
			}
		}
	}
	$("#"+curSelectInputId).val(kpi.desc);
	$("#"+curSelectInputId).attr("kpiId",kpi.id);
	$("#"+curSelectInputId).attr("kpiColumn",kpi.column);
	$("#"+curSelectInputId).attr("isextcolumn",kpi.isextcolumn);
	$("#"+curSelectInputId).attr("extcolumnid",kpi.extcolumnid);
	if($("#"+curSelectInputId).attr("name")=="scatter_kpiX"){
		$("#scatter_kpiX_title").val(kpi.desc);
		scatter_fun_SetKpi();
	}else if($("#"+curSelectInputId).attr("name")=="scatter_kpiY"){
		$("#scatter_kpiY_title").val(kpi.desc);
		scatter_fun_SetKpi();
	}else if($("#"+curSelectInputId).attr("name")=="scatter_dim"){
			scatter_fun_SetDim();
	}else if($("#"+curSelectInputId).attr("name")=="scatter_min_dim"){
			scatter_fun_SetMinDim();
	}
	var info ={
			    viewId:StoreData.xid,
			    kpistoreColId:kpi.id==""?kpi.extcolumnid:kpi.id,
				kpiColumn:kpi.column==""?kpi.extcolumnid:kpi.column,
			    kpiDesc:kpi.desc,
			    kpiType:kpi.kpiType,
			    componentId : StoreData.curComponentId,
				containerId : StoreData.curContainerId,
				kpistoreColHasAdded : getAllScatterSelectedKpiIds()
	          }
	cn.com.easy.xbuilder.service.XComponentService.addKpiStoreCol(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("散点图","保存指标时发生错误："+exception,"info");
		}
	});
}

/**
 * 获取组件已选择的所有的指标Id的字符串
 * @returns {String}
 */
function getAllScatterSelectedKpiIds(){
	var kpiIds = "";
	if($("#scatter_kpiX").attr("kpiId")!=undefined&&$("#scatter_kpiX").attr("kpiId")!=""){
		kpiIds+=$("#scatter_kpiX").attr("kpiId")+",";
	}
	if($("#scatter_kpiX").attr("extcolumnid")!=undefined&&$("#scatter_kpiX").attr("extcolumnid")!=""){
		kpiIds+=$("#scatter_kpiX").attr("extcolumnid")+",";
	}
	if($("#scatter_kpiY").attr("kpiId")!=undefined&&$("#scatter_kpiY").attr("kpiId")!=""){
		kpiIds+=$("#scatter_kpiY").attr("kpiId")+",";
	}
	if($("#scatter_kpiY").attr("extcolumnid")!=undefined&&$("#scatter_kpiY").attr("extcolumnid")!=""){
		kpiIds+=$("#scatter_kpiY").attr("extcolumnid")+",";
	}
	if($("#scatter_dim").attr("kpiId")!=undefined&&$("#scatter_dim").attr("kpiId")!=""){
		kpiIds+=$("#scatter_dim").attr("kpiId")+",";
	}
	if($("#scatter_min_dim").attr("kpiId")!=undefined&&$("#scatter_min_dim").attr("kpiId")!=""){
		kpiIds+=$("#scatter_min_dim").attr("kpiId")+",";
	}
	kpiIds = kpiIds.substring(0,kpiIds.length-1);
	return kpiIds;
}

/**
 * 更新数据集UI
 */
function scatterUpdataDatasetUI(action){
	var info ={
		    viewId:StoreData.xid,
		    kpiType:"extcolumn",
		    componentId : StoreData.curComponentId,
			containerId : StoreData.curContainerId,
			kpistoreColHasAdded : getAllColumnSelectedKpiIds()
     }
	if(action=="edit"){
		if(scatterCaculateColumn.getColumnOldName()==$("#scatter_kpiX").val()){
			$("#scatter_kpiX").val(scatterCaculateColumn.currentEditColumnObj.name);
			$("#scatter_kpiX_title").val(scatterCaculateColumn.currentEditColumnObj.name);
			info.kpistoreColId=$("#scatter_kpiX").attr("extcolumnid");
			info.kpiColumn=$("#scatter_kpiX").attr("extcolumnid");
			info.kpiDesc=$("#scatter_kpiX").val();
			cn.com.easy.xbuilder.service.XComponentService.addKpiStoreCol(info,function(data,exception){
					if(exception!=undefined){
						$.messager.alert("散点图","保存指标时发生错误："+exception,"info");
					}else{
						scatter_fun_SetKpi();
					}
		    });
		}
		if(scatterCaculateColumn.getColumnOldName()==$("#scatter_kpiY").val()){
			$("#scatter_kpiY").val(scatterCaculateColumn.currentEditColumnObj.name);
			$("#scatter_kpiY_title").val(scatterCaculateColumn.currentEditColumnObj.name);
			info.kpistoreColId=$("#scatter_kpiY").attr("extcolumnid");
			info.kpiColumn=$("#scatter_kpiY").attr("extcolumnid");
			info.kpiDesc=$("#scatter_kpiY").val();
			cn.com.easy.xbuilder.service.XComponentService.addKpiStoreCol(info,function(data,exception){
					if(exception!=undefined){
						$.messager.alert("散点图","保存指标时发生错误："+exception,"info");
					}else{
						scatter_fun_SetKpi();
					}
		    });
		}
	}else if(action=="remove"){
		var componentId = StoreData.curComponentId;
		var containerId = StoreData.curContainerId;
		if(scatterCaculateColumn.currentEditColumnObj.name==$("#scatter_kpiX").val()){
			var info={extcolumnid:scatterCaculateColumn.currentEditColumnObj.id,type:"X"};
			cn.com.easy.xbuilder.service.component.ScatterService.removeExtKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#scatter_kpiX").val("");
				$("#scatter_kpiX").attr("isextcolumn","false");
				$("#scatter_kpiX").attr("kpiId","");
				$("#scatter_kpiX").attr("kpiColumn","");
				$("#scatter_kpiX").attr("extcolumnid","");
				$("#scatter_kpiX_title").val("");
				$("#scatter_kpiX_unit").val("");
				cn.com.easy.xbuilder.service.component.ScatterService.deleteKpiStoreCol(StoreData.xid,scatterCaculateColumn.currentEditColumnObj.id,function(data,exception){});
			});
		}
		if(scatterCaculateColumn.currentEditColumnObj.name==$("#scatter_kpiY").val()){
			var info={extcolumnid:scatterCaculateColumn.currentEditColumnObj.id,type:"Y"};
			cn.com.easy.xbuilder.service.component.ScatterService.removeExtKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#scatter_kpiY").val("");
				$("#scatter_kpiY").attr("isextcolumn","false");
				$("#scatter_kpiY").attr("kpiId","");
				$("#scatter_kpiY").attr("kpiColumn","");
				$("#scatter_kpiY").attr("extcolumnid","");
				$("#scatter_kpiY_title").val("");
				$("#scatter_kpiY_unit").val("");
				cn.com.easy.xbuilder.service.component.ScatterService.deleteKpiStoreCol(StoreData.xid,scatterCaculateColumn.currentEditColumnObj.id,function(data,exception){});
			});
		}
	}
}