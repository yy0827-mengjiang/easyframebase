function pie_initDroppable(){
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
				selectPieKpiSuccess(pieKpiSelector.currentItem);
			}else{//计算列选择
				var itemObj = {
						id:$(source).attr("node-id"),
						column:"",
						desc:$(source).attr("desc"),
						kpiType:'extcolumn'
				}
				selectPieKpiSuccess(itemObj);
			}
		}
	});
}

/**
 * 设置指标列
 */
function pie_fun_setSer(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var ser = $("#pie_ser").attr("kpiColumn");
	if($("#pie_ser").attr("isextcolumn")=="true"){
		ser = $("#pie_ser").attr("kpiId");
		info.isextcolumn="true";
	}else{
		info.isextcolumn="false";
	}
	if(typeof(ser)!="undefined"&&ser!=""){
		info.ser=ser;
		info.kpiId = $("#pie_ser").attr("kpiId");
		cn.com.easy.xbuilder.service.component.PieService.setKpiField(LayOutUtil.data.xid,containerId,componentId,$.toJSON(info),function(data,exception){
			$("#pie_kpi_name").val($("#pie_ser").val());
			pie_fun_SetKpiName();
		});
	} 
	
}

/**
 * 设置排序列
 */
function pie_fun_SetOrd(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var pie_ord = $("#pie_ord").attr("kpiColumn");
	if($("#pie_ord").attr("isextcolumn")=="true"){
		pie_ord = $("#pie_ord").attr("kpiId");
		info.isextcolumn="true";
	}else{
		info.isextcolumn="false";
	}
	var sortType = $("#pie_sorttype").combobox("getValue");
	if(typeof(pie_ord)!="undefined"&&pie_ord!=""){
		info.ord=pie_ord;
		info.sortType = sortType;
		info.ordKpiId=$("#pie_ord").attr("kpiId");
		cn.com.easy.xbuilder.service.component.PieService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
		
	}
}

/**
 * 设置维度列
 */
function pie_fun_SetDim(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var dimension = $("#pie_dim").attr("kpiColumn");
	if(typeof(dimension)!="undefined"&&dimension!=""){
		info.dimFieldId = $("#pie_dim").attr("kpiId");
		info.dimension=dimension;
		cn.com.easy.xbuilder.service.component.PieService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	} 
}

function pie_fun_edit(containerId,componentId){	
	cn.com.easy.xbuilder.service.component.PieService.getComponentJsonData(LayOutUtil.data.xid,containerId,componentId,$.toJSON({}),function(data,exception){
		var jsonObj=$.parseJSON(data);
		if(jsonObj!=null&&jsonObj!=undefined){
			var kpiColMap=jsonObj.kpiColMap;
			var title = jsonObj.chartTitle;
			/*设置标题*/
			if(typeof(title)=="undefined"){
				$("#pie_title").val(''); 
			}else{ 
				$("#pie_title").val(title);
			}if(jsonObj.showTitle=="1"){
				$("#showTitle").iCheck('check');
			}else{
				$("#showTitle").iCheck('uncheck');
			}
			
			/*设置图例*/
			if(jsonObj.legend != undefined){
				pie_restoreLegendPosition(jsonObj.legend.position);
			}else{
				pie_setLegend('bottom');
			}
			/*设置维度列和排序列*/
			if(jsonObj.xaxis!=null&&jsonObj.xaxis!=undefined){
				var dimId = jsonObj.xaxis.dimFiledId==""?jsonObj.xaxis.dimExtField:jsonObj.xaxis.dimFiledId;
				var sortId = jsonObj.xaxis.sortFiledId==""?jsonObj.xaxis.sortExtField:jsonObj.xaxis.sortFiledId;
				if(kpiColMap[dimId]!=undefined){
					$("#pie_dim").val(kpiColMap[dimId].kpidesc); 
				}
				if(kpiColMap[sortId]!=undefined){
					$("#pie_ord").val(kpiColMap[sortId].kpidesc);
				}
			    $("#pie_dim").attr("kpiId",dimId); 
			    $("#pie_ord").attr("kpiId",sortId);
			    $("#pie_ord").attr('isextcolumn',jsonObj.xaxis.sortExtField==""?"false":"true");
			    
			    $("#pie_dim").attr("kpiColumn",jsonObj.xaxis.dimfield); 
			    $("#pie_ord").attr("kpiColumn",jsonObj.xaxis.sortfield);
			    $("#pie_sorttype").combobox("setValue",jsonObj.xaxis.sortType);
			}
			
			/*指标列、指标名　设置*/
			var kpiList=jsonObj.kpiList;
			if(typeof(kpiList)!="undefined"&&kpiList!=null){
				for(var i=0;i<kpiList.length;i++){
					if(i==0){
						if(kpiList[i].kpiId==""){
							$("#pie_ser").val(kpiColMap[kpiList[i].extcolumnid].kpidesc); 
						    $("#pie_ser").attr("kpiId",kpiList[i].extcolumnid); 
						    $("#pie_ser").attr("kpiColumn",""); 
						    $("#pie_ser").attr('isextcolumn',"true");
						}else{
							$("#pie_ser").val(kpiColMap[kpiList[i].kpiId].kpidesc); 
						    $("#pie_ser").attr("kpiId",kpiList[i].kpiId); 
						    $("#pie_ser").attr("kpiColumn",kpiList[i].field); 
						    $("#pie_ser").attr('isextcolumn',"false");
						}
						$("#pie_kpi_name").val(kpiList[i].name);
					}
				}
			}
			
			/*设置选择的颜色列表*/
			if(jsonObj.colors!=""&&jsonObj.colors!=undefined){
				selectColorRow(jsonObj.colors);//ChartColorList.jsp方法
			}
			
			/*单位*/
			$("#pie_unit").val("");
			var yaxisList=jsonObj.yaxisList;
			if(typeof(yaxisList)!="undefined"&&yaxisList!=null){
				for(var i=0;i<yaxisList.length;i++){
					if(i==0&&yaxisList[i].unit){
						$("#pie_unit").val(yaxisList[i].unit);
					}
						
				}
			} 
		}
	});
}

/**
 * 打开指标库选择对话框
 * @param tabInde
 * @param inputId
 */ 
function openPieKpiDialog(){
	  var cubeId = StoreData.cubeId;
	  pieKpiSelector.open(cubeId);
}

/**
 * 指标库对话框选择事件
 * @param kpiArr
 */
function selectPieKpiSuccess(itemObj){
	var kpi = itemObj;
	var kpiType = kpi.kpiType;
	var curSelectInputId=$("#curSelectInput").val();
	if($("#"+curSelectInputId).attr("name")=="pie_dim"){
		if(kpiType=='kpi'||kpiType=='extcolumn'){
			$.messager.alert("饼（环）图","指标不能作为维度使用！","info");
			return;
		}
	}if($("#"+curSelectInputId).attr("name")=="pie_ser"){
		if(kpiType=='dim'||kpiType=='property'){
			$.messager.alert("饼（环）图",(kpiType=='dim'?"维度":"属性")+"不能作为指标使用！","info");
			return;
		}
	}
	$("#"+curSelectInputId).val(kpi.desc);
	$("#"+curSelectInputId).attr("kpiId",kpi.id);
	$("#"+curSelectInputId).attr("kpiColumn",kpi.column);
	$("#"+curSelectInputId).attr("isextcolumn",kpi.kpiType=='extcolumn'?"true":"false");
	if(curSelectInputId=="pie_ser"){
		pie_fun_setSer();
	}else if(curSelectInputId=="pie_ord"){
		pie_fun_SetOrd();
	}else if(curSelectInputId=="pie_dim"){
		pie_fun_SetDim();
	}
	var info ={
			    viewId:StoreData.xid,
			    kpistoreColId:kpi.id,
			    kpiColumn:kpi.column,
			    kpiDesc:kpi.desc,
			    kpiType:kpi.kpiType,
			    componentId : StoreData.curComponentId,
				containerId : StoreData.curContainerId,
				kpistoreColHasAdded : getAllPieSelectedKpiIds()
	          }
	cn.com.easy.xbuilder.service.XComponentService.addKpiStoreCol(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("饼（环）图","保存指标时发生错误："+exception,"info");
		}
	});
}
/**
 * 获取组件已选择的所有的指标Id的字符串
 * @returns {String}
 */
function getAllPieSelectedKpiIds(){
	var kpiIds = "";
	if($("#pie_ord").attr("kpiId")!=undefined&&$("#pie_ord").attr("kpiId")!=""){
		kpiIds+=$("#pie_ord").attr("kpiId")+",";
	}
	if($("#pie_dim").attr("kpiId")!=undefined&&$("#pie_dim").attr("kpiId")!=""){
		kpiIds+=$("#pie_dim").attr("kpiId")+",";
	}
	if($("#pie_ser").attr("kpiId")!=undefined&&$("#pie_ser").attr("kpiId")!=""){
		kpiIds+=$("#pie_ser").attr("kpiId")+",";
	}
	kpiIds = kpiIds.substring(0,kpiIds.length-1);
	return kpiIds;
}

/**
 * 更新数据集UI
 */
function pieUpdataDatasetUI(action){
	var info ={
		    viewId:StoreData.xid,
		    kpiType:"extcolumn",
		    componentId : StoreData.curComponentId,
			containerId : StoreData.curContainerId,
			kpistoreColHasAdded : getAllPieSelectedKpiIds()
     }
	if(action=="edit"){
		if(pieCaculateColumn.getColumnOldName()==$("#pie_ord").val()){
			$("#pie_ord").val(pieCaculateColumn.currentEditColumnObj.name);
			info.kpistoreColId=$("#pie_ord").attr("kpiId");
			info.kpiColumn=$("#pie_ord").attr("kpiColumn");
			info.kpiDesc=$("#pie_ord").val();
			cn.com.easy.xbuilder.service.XComponentService.addKpiStoreCol(info,function(data,exception){
				if(exception!=undefined){
					$.messager.alert("饼（环）图","保存指标时发生错误："+exception,"info");
				}else{
					pie_fun_SetOrd();
				}
			});
		}
		if(pieCaculateColumn.getColumnOldName()==$("#pie_ser").val()){
			$("#pie_ser").val(pieCaculateColumn.currentEditColumnObj.name);
			$("#pie_kpi_name").val(pieCaculateColumn.currentEditColumnObj.name);
			info.kpistoreColId=$("#pie_ser").attr("kpiId");
			info.kpiColumn=$("#pie_ser").attr("kpiColumn");
			info.kpiDesc=$("#pie_ser").val();
			cn.com.easy.xbuilder.service.XComponentService.addKpiStoreCol(info,function(data,exception){
					if(exception!=undefined){
						$.messager.alert("饼（环）图","保存指标时发生错误："+exception,"info");
					}else{
						pie_fun_setSer();
					}
		    });
			
		}
	}else if(action=="remove"){
		var componentId = StoreData.curComponentId;
		var containerId = StoreData.curContainerId;
		if(pieCaculateColumn.currentEditColumnObj.name==$("#pie_ord").val()){
			var sortType = $("#pie_sorttype").combobox("getValue");
			var info={ord:"",isextcolumn:"true",kpiType:"kpi",sortType:sortType};
			cn.com.easy.xbuilder.service.component.PieService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#pie_ord").val("");
				$("#pie_ord").attr("kpiId","");
				$("#pie_ord").attr("kpiColumn","");
				$("#pie_ord").attr("isextcolumn","");
				//调用删除kpistore方法
				cn.com.easy.xbuilder.service.component.PieService.deleteKpiStoreCol(StoreData.xid,pieCaculateColumn.currentEditColumnObj.id,function(data,exception){});
			});
		}
		if(pieCaculateColumn.currentEditColumnObj.name==$("#pie_ser").val()){
			var info={extcolumnid:pieCaculateColumn.currentEditColumnObj.id};
			cn.com.easy.xbuilder.service.component.PieService.removeExtKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#pie_ser").val("");
				$("#pie_kpi_name").val("");
				$("#pie_ser").attr("kpiId","");
				$("#pie_ser").attr("kpiColumn","");
				$("#pie_ser").attr("isextcolumn","");
				//调用删除kpistore方法
				cn.com.easy.xbuilder.service.component.PieService.deleteKpiStoreCol(StoreData.xid,pieCaculateColumn.currentEditColumnObj.id,function(data,exception){});
			});
		}
	}
	
}
