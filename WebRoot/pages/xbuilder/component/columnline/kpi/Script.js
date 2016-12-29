function columnline_initDroppable(){
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
				selectColumnLineKpiSuccess(columnLineKpiSelector.currentItem);
			}else{//计算列选择
				var itemObj = {
						id:"",
						column:"",
						desc:$(source).attr("desc"),
						kpiType:'extcolumn',
						extcolumnid:$(source).attr("node-id"),
						isextcolumn:'true'
				}
				selectColumnLineKpiSuccess(itemObj);
			}
		}
	});
}

/**
 * 选择指标列
 * @param obj
 */
function columnline_selectSer(obj){
	var $ser = $(this);
	var ser_value = $ser.combobox("getText");
	$ser.parent().parent().find(":text[name='columnline_sername']").val(ser_value);
}

/**
 * 添加指标行
 * @returns
 */
function columnline_appendKpiRow(){
	var errMsg = validColumnLineKpiRow();
	if(errMsg!=""){
		$.messager.alert("组合图","添加失败，请先处理以下错误：<br/>"+errMsg,"info");
		return;
	}
	$("#columnline_tb2").append($("#kpiRowHtml").find("tr").eq(0)[0].outerHTML);
	var $row = $("#columnline_tb2 tr:last-child");
	var inputId = "row_" + (new Date()).getTime();
	$row.find("td:eq(0)").find("input:eq(0)").attr("id",inputId);
	$row.find(":text.colorpk").spectrum({
		showPalette: true,
		preferredFormat: "hex",
		showInput: true,
	    palette: [
	        ['#cc0000', '#ff2845', '#e000fc'],
	        ['#fc0088', '#ff4200', '#ffa200'],
	        ['#00bedc', '#00d744', '#acfd00'],
	        ['#e5dc0c', '#006be3', '#00bedc']
	    ],
	    change: function(color) {
	    	columnline_fun_SetKpi();
	    }
	});
	var $ref = $row.find(":text.columnline_ref").combobox();
	var quoteData = columnline_getQuote();
	$ref.combobox({onLoadSuccess:function(){
		$ref.combobox('setValue', quoteData[0].id);
	}});
	$ref.combobox('loadData', quoteData);
	var $type = $row.find(":text.columnline_type").combobox();
	var type_data=[{'id':'column','text': '柱图'},{'id':'line','text': '线图'}];
	$type.combobox('setValue', 'column').combobox('loadData', type_data);
	$row.click(function(){
		$("#columnline_tb2 tr").each(function(index,item){
			$(item).removeClass("kpi_select_row");
		})
		$row.addClass("kpi_select_row");
		$("#columnline_tb2 tr:eq(0)").removeClass("kpi_select_row");
	});
	columnline_initDroppable();
	return $row; 
}

/**
 * 校验指标行
 * @returns {String}
 */
function validColumnLineKpiRow(){
	var errMessage = "";
	var kpiMap = new Object();
	$("#columnline_tb2 tr:gt(0)").each(function(index){
		var ser = $(this).find(":text.columnline_ser").val();
		var ser_name = $(this).find(":text[name='columnline_sername']").val();
		if(typeof(ser)=="undefined"||ser=="请选择"||ser==""){
			errMessage+="第"+(index+1)+"行指标列不能为空;<br/>";
		}
		if(typeof(ser_name)=="undefined"||ser_name=="请选择"||ser_name==""){
			errMessage+="第"+(index+1)+"行指标名称不能为空;<br/>";
		}
	});
	return errMessage;
}
/**
 * 设置排序列
 */
function columnline_fun_SetOrd(){	
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var isextcolumn = $("#columnline_ord").attr("isextcolumn");
	var kpiId = $("#columnline_ord").attr("kpiId");
	var kpiColumn = $("#columnline_ord").attr("kpiColumn");
	var extcolumnid = $("#columnline_ord").attr("extcolumnid");
	var sortType = $("#columnline_sorttype").combobox("getValue");
	if((isextcolumn=="true"&&typeof(extcolumnid)!="undefined"&&extcolumnid!="")||(isextcolumn=="false"&&typeof(kpiColumn)!="undefined"&&kpiColumn!="")){
		info.ord=isextcolumn=="true"?extcolumnid:kpiColumn;
		info.sortType = sortType;
		info.ordKpiId=kpiId;
		info.isextcolumn = isextcolumn;
		cn.com.easy.xbuilder.service.component.ColumnLineService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	}
}

/**
 * 设置维度列
 */
function columnline_fun_SetDim(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var dimension = $("#columnline_dim").attr("kpiColumn");
	if(typeof(dimension)!="undefined"&&dimension!=""){
		info.dimFieldId = $("#columnline_dim").attr("kpiId");
		info.dimension=dimension;
		info.isextcolumn = "false";
		cn.com.easy.xbuilder.service.component.ColumnLineService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	} 
}

/**
 * 设置指标列
 */
function columnline_fun_SetKpi(){
	var kpiMap = new Object(); 
	var hasRepeatKpi = false;
	$("#columnline_tb2 tr:gt(0)").each(function(index,item){
		var columnline_ser = $(this).find(":text.columnline_ser").attr("kpiId")==""?$(this).find(":text.columnline_ser").attr("extcolumnid"):$(this).find(":text.columnline_ser").attr("kpiId");
		if(kpiMap[columnline_ser]==undefined){
			kpiMap[columnline_ser]=columnline_ser;
		}else{
			hasRepeatKpi = true;
			$.messager.alert("组合图","指标"+$(this).find(":text.columnline_ser").val()+"已添加，不能重复添加！","info");
			return false;
		}
	});
	if(hasRepeatKpi){
		return;
	}
	//如果参照轴或图形类型发生变化导致线图参照的y轴不统一，是否堆叠显示设置为否
	var stacking = $("#stacking").attr("checked")=="checked"?"true":"false";
	var ref = "";
	$("#columnline_tb2 tr:gt(0)").each(function(index,item){
		var type = $(this).find(":text.columnline_type").combobox("getValue");
		if(type=="column"){
			if(ref!=""&&$(this).find(":text.columnline_ref").combobox("getValue")!=ref){
				setTimeout(function(){$("#stacking").iCheck('uncheck');},500);
				return false;
			}
			ref = $(this).find(":text.columnline_ref").combobox("getValue");
		}
	});
	
	columnline_fun_SetScale();//初始化刻度设置
	var errMsg="";
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var kpiArr = [];
	$("#columnline_tb2 tr:gt(0)").each(function(i){
		var kpiItem = {};
		var $serInput = $(this).find(":text.columnline_ser");
		var kpiId = $serInput.attr("kpiId");
		var kpiColumn = $serInput.attr("kpiColumn");
		var extcolumnid = $serInput.attr("extcolumnid");
		var isextcolumn = $serInput.attr("isextcolumn");
		
		var yaxisid = $(this).find(":text.columnline_ref").combobox("getValue");
		var color = $(this).find(":text.colorpk").spectrum("get").toHexString();
		var ser_name = $(this).find(":text[name='columnline_sername']").val();
		var type = $(this).find(":text.columnline_type").combobox("getValue");
		if(isextcolumn=='false'&&kpiId!=undefined&&kpiId!=""||isextcolumn=='true'&&extcolumnid!=undefined&&extcolumnid!=""){//指标列为指标库列时kpiId不能为空，为计算列时extcolumnid不能为空
			kpiItem.kpiId = kpiId;
			kpiItem.ser = isextcolumn=="true"?extcolumnid:kpiColumn;
			kpiItem.extcolumnid=extcolumnid;
			kpiItem.isextcolumn=isextcolumn;
			kpiItem.ref = yaxisid;
			kpiItem.color = color;
			kpiItem.type = type;
			kpiItem.ser_name = ser_name;
			kpiArr.push(kpiItem);
		}else{
			errMsg=errMsg+"指标列不能为空！";
			return false;
		
		}
		
	});
	if(errMsg!=""){
		//$.messager.alert("线图",errMsg,"info");
		return;
	}
	$('#columnline_dialog2').dialog('close');
	cn.com.easy.xbuilder.service.component.ColumnLineService.setKpi(StoreData.xid,containerId,componentId,$.toJSON({kpiList:kpiArr}),function(data,exception){});
}

/**
 * 编辑还原
 */
function columnline_fun_edit(containerId,componentId){
	/*还原*/
	cn.com.easy.xbuilder.service.component.ColumnLineService.getComponentJsonData(StoreData.xid,containerId,componentId,$.toJSON({}),function(data,exception){
		var jsonObj=$.parseJSON(data);
		if(jsonObj!=null&&jsonObj!=undefined){
			var kpiColMap=jsonObj.kpiColMap;
			/*设置标题*/
			var title = jsonObj.chartTitle;
			if(typeof(title)=="undefined"){
				$("#columnline_title").val(''); 
			}else{ 
				$("#columnline_title").val(title);
			}if(jsonObj.showTitle=="1"){
				$("#showTitle").iCheck('check');
			}else{
				$("#showTitle").iCheck('uncheck');
			}
			if(jsonObj.stacking=="true"){
				$("#stacking").iCheck('check');
			}else{
				$("#stacking").iCheck('uncheck');
			}
			/*设置图例*/
			if(jsonObj.legend != undefined){
				columnline_restoreLegendPosition(jsonObj.legend.position);
			}else{
				columnline_setLegend('bottom');
			}
			/*设置维度列和排序列*/
			if(jsonObj.xaxis!=null&&jsonObj.xaxis!=undefined){
				var sortColId = jsonObj.xaxis.sortFiledId==""?jsonObj.xaxis.sortExtField:jsonObj.xaxis.sortFiledId;
				if(jsonObj.xaxis.dimFiledId!=""){
					  $("#columnline_dim").val(kpiColMap[jsonObj.xaxis.dimFiledId].kpidesc); 
					  $("#columnline_dim").attr("kpiId",jsonObj.xaxis.dimFiledId);
					  $("#columnline_dim").attr("kpiColumn",jsonObj.xaxis.dimfield); 
				}
			  
			    $("#columnline_ord").val(kpiColMap[sortColId].kpidesc);
			    $("#columnline_ord").attr("kpiId",jsonObj.xaxis.sortFiledId);
			    $("#columnline_ord").attr("kpiColumn",jsonObj.xaxis.sortfield);
			    $("#columnline_ord").attr("isextcolumn",jsonObj.xaxis.sortExtField!=""?"true":"false");
			    $("#columnline_ord").attr("extcolumnid",jsonObj.xaxis.sortExtField);
				$("#columnline_sorttype").combobox("setValue",jsonObj.xaxis.sortType); 
				
			}
			
			/*刻度设置*/
			var yaxisList=jsonObj.yaxisList;
			if(typeof(yaxisList)!="undefined"&&yaxisList!=null){
				for(var i=0;i<yaxisList.length;i++){
			        var $row=$("#columnline_tb1").find("tr").eq(i+1);
					if(yaxisList[i].title) $row.find(":text[name='columnline_title']").val(yaxisList[i].title);
					if(yaxisList[i].color) $row.find(":text.colorpk").spectrum("set",yaxisList[i].color);
					if(yaxisList[i].unit) $row.find(":text[name='columnline_unit']").val(yaxisList[i].unit);
				}
			} 
			
			/*指标设置*/
			var kpiList=jsonObj.kpiList;
			if(typeof(kpiList)!="undefined"&&kpiList!=null){
				$("#columnline_tb2 tr:gt(0)").remove();
				var kpiId="";
				for(var i=0;i<kpiList.length;i++){
					var $row = columnline_appendKpiRow();
					var $serInput=$row.find(":text.columnline_ser");
					if(kpiList[i].extcolumnid=="") {//指标库指标
						$serInput.val(kpiColMap[kpiList[i].kpiId].kpidesc);
						$serInput.attr("isextcolumn","false");
					}else{//计算列指标
						$serInput.val(kpiColMap[kpiList[i].extcolumnid].kpidesc);
						$serInput.attr("isextcolumn","true");
					}
					if(kpiList[i].kpiId) $serInput.attr("kpiId",kpiList[i].kpiId);
					if(kpiList[i].field) $serInput.attr("kpiColumn",kpiList[i].field);
					if(kpiList[i].extcolumnid) $serInput.attr("extcolumnid",kpiList[i].extcolumnid);
					if(kpiList[i].name)  $row.find(":text[name='columnline_sername']").val(kpiList[i].name);
					if(kpiList[i].color) $row.find(":text.colorpk").spectrum("set",kpiList[i].color);
					if(kpiList[i].yaxisid) $row.find(":text.columnline_ref").combobox("setValue",kpiList[i].yaxisid);
					if(kpiList[i].type) $row.find(":text.columnline_type").combobox("setValue",kpiList[i].type);
				}
				if($("#columnline_tb2 tr:gt(0)").length==0){
					var $row = columnline_appendKpiRow();
				}
			} 
			
			/*设置选择的颜色列表*/
			if(jsonObj.colors!=""&&jsonObj.colors!=undefined){
				selectColorRow(jsonObj.colors);//ChartColorList.jsp方法
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
function openColumnLineKpiDialog(){
	  var cubeId = StoreData.cubeId;
	  columnLineKpiSelector.open(cubeId);
}

/**
 * 指标库对话框选择事件
 * @param kpiArr
 */
function selectColumnLineKpiSuccess(itemObj){
	var kpi = itemObj;
	var kpiType = kpi.kpiType;
	var curSelectInputId=$("#curSelectInput").val();
	if($("#"+curSelectInputId).attr("name")=="columnline_dim"){
		if(kpiType=='kpi'||kpiType=="extcolumn"){
			$.messager.alert("组合图","指标不能作为维度使用！","info");
			return;
		}
	}if($("#"+curSelectInputId).attr("name")=="columnline_ser"){
		if(kpiType=='dim'||kpiType=='property'){
			$.messager.alert("组合图",(kpiType=='dim'?"维度":"属性")+"不能作为指标使用！","info");
			return;
		}
	}
	$("#"+curSelectInputId).val(kpi.desc);
	$("#"+curSelectInputId).attr("kpiId",kpi.id);
	$("#"+curSelectInputId).attr("kpiColumn",kpi.column);
	$("#"+curSelectInputId).attr("isextcolumn",kpi.isextcolumn);
	$("#"+curSelectInputId).attr("extcolumnid",kpi.extcolumnid);
	if($("#"+curSelectInputId).attr("name")=="columnline_ser"){
		$("#"+curSelectInputId).parent().next("td").find("input").val(kpi.desc);
		columnline_fun_SetKpi();
	}
	else if(curSelectInputId=="columnline_ord"){
		columnline_fun_SetOrd();
	}else if(curSelectInputId=="columnline_dim"){
		if(kpi.isextcolumn=="true"){
			$.messager.alert("组合图","计算列不能作维度！","error");
		}else{
			columnline_fun_SetDim();
		}
	}
	var info ={
			    viewId:StoreData.xid,
			    kpistoreColId:kpi.id==""?kpi.extcolumnid:kpi.id,
				kpiColumn:kpi.column==""?kpi.extcolumnid:kpi.column,
			    kpiDesc:kpi.desc,
			    kpiType:kpi.kpiType,
			    componentId : StoreData.curComponentId,
				containerId : StoreData.curContainerId,
				kpistoreColHasAdded : getAllColumnLineSelectedKpiIds()
	          }
	cn.com.easy.xbuilder.service.XComponentService.addKpiStoreCol(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("组合图","保存指标时发生错误："+exception,"info");
		}
	});
}

/**
 * 获取组件已选择的所有的指标Id的字符串
 * @returns {String}
 */
function getAllColumnLineSelectedKpiIds(){
	var kpiIds = "";
	if($("#columnline_ord").attr("kpiId")!=undefined&&$("#columnline_ord").attr("kpiId")!=""){
		kpiIds+=$("#columnline_ord").attr("kpiId")+",";
	}
	if($("#columnline_ord").attr("extcolumnid")!=undefined&&$("#columnline_ord").attr("extcolumnid")!=""){
		kpiIds+=$("#columnline_ord").attr("extcolumnid")+",";
	}
	if($("#columnline_dim").attr("kpiId")!=undefined&&$("#columnline_dim").attr("kpiId")!=""){
		kpiIds+=$("#columnline_dim").attr("kpiId")+",";
	}
	$("#columnline_tb2 tr:gt(0)").each(function(index,item){
		var columnline_ser = $(this).find(":text.columnline_ser");
		if($(columnline_ser).attr("kpiId")!=undefined&&$(columnline_ser).attr("kpiId")!=""){
			kpiIds+=$(columnline_ser).attr("kpiId")+",";
		}
		if($(columnline_ser).attr("extcolumnid")!=undefined&&$(columnline_ser).attr("extcolumnid")!=""){
			kpiIds+=$(columnline_ser).attr("extcolumnid")+",";
		}
	});
	kpiIds = kpiIds.substring(0,kpiIds.length-1);
	return kpiIds;
}

/**
 * 删除指标行
 * @param obj
 */
function columnline_removeKpiRow(){
	var obj = $(".kpi_select_row").eq(0);
	if(obj[0]==undefined){
		$.messager.alert("组合图","请选择要删除的指标!","info");
	}else if(obj[0]!=undefined&&$("#columnline_tb2 tr:gt(0)").length>1){
		var info = {
				    viewId:StoreData.xid,
				    componentId:StoreData.curComponentId,
				    containerId:StoreData.curContainerId,
				    kpiId:$(obj).find("td:eq(0)").find("input:eq(0)").attr("kpiId")
		};
		cn.com.easy.xbuilder.service.XComponentService.removeKpiRow(info,function(data,exception){
			 if(exception!=undefined){
				 $.messager.alert("组合图","删除指标发生错误："+exception,"info");
			 }else{
				 $(obj).remove();
			 }
		});
	}else if(obj[0]!=undefined&&$("#columnline_tb2 tr:gt(0)").length==1){
		$.messager.alert("组合图","不能删除,请至少保留一个指标!","info");
	}else{
		$.messager.alert("组合图","删除失败","info");
	}
}


/**
 * 更新数据集UI
 */
function columnlineUpdataDatasetUI(action){
	var info ={
		    viewId:StoreData.xid,
		    kpiType:"extcolumn",
		    componentId : StoreData.curComponentId,
			containerId : StoreData.curContainerId,
			kpistoreColHasAdded : getAllColumnLineSelectedKpiIds()
     }
	if(action=="edit"){
		if(columnlineCaculateColumn.getColumnOldName()==$("#columnline_ord").val()){
			$("#columnline_ord").val(columnlineCaculateColumn.currentEditColumnObj.name);
			info.kpistoreColId=$("#columnline_ord").attr("extcolumnid");
			info.kpiColumn=$("#columnline_ord").attr("extcolumnid");
			info.kpiDesc=$("#columnline_ord").val();
			cn.com.easy.xbuilder.service.XComponentService.addKpiStoreCol(info,function(data,exception){
				if(exception!=undefined){
					$.messager.alert("组合图","保存指标时发生错误："+exception,"info");
				}
			});
		}
		$("#columnline_tb2 tr:gt(0)").each(function(index,item){
			if(columnlineCaculateColumn.getColumnOldName()==$(this).find(":text.columnline_ser").val()){
				$(this).find(":text.columnline_ser").val(columnlineCaculateColumn.currentEditColumnObj.name);
				$(this).find("input[name='columnline_sername']").val(columnlineCaculateColumn.currentEditColumnObj.name);
				info.kpistoreColId=$(this).find(":text.columnline_ser").attr("extcolumnid");
				info.kpiColumn=$(this).find(":text.columnline_ser").attr("extcolumnid");
				info.kpiDesc=$(this).find(":text.columnline_ser").val();
				cn.com.easy.xbuilder.service.XComponentService.addKpiStoreCol(info,function(data,exception){
						if(exception!=undefined){
							$.messager.alert("组合图","保存指标时发生错误："+exception,"info");
						}else{
							columnline_fun_SetKpi();
						}
			    });
			}
		});
	}else if(action=="remove"){
		var componentId = StoreData.curComponentId;
		var containerId = StoreData.curContainerId;
		if(columnlineCaculateColumn.currentEditColumnObj.name==$("#columnline_ord").val()){
				var sortType = $("#columnline_sorttype").combobox("getValue");
				var kpiType = $("#columnline_ord").attr("kpiType");
				var info={ord:"",isextcolumn:"true",kpiType:kpiType,sortType:sortType};
				cn.com.easy.xbuilder.service.component.ColumnLineService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
					$("#columnline_ord").val("");
					$("#columnline_ord").attr("kpiId","");
					$("#columnline_ord").attr("kpiColumn","");
					$("#columnline_ord").attr("isextcolumn","false");
					$("#columnline_ord").attr("extcolumnid","");
					//调用删除kpistore方法
					cn.com.easy.xbuilder.service.component.ColumnLineService.deleteKpiStoreCol(StoreData.xid,columnlineCaculateColumn.currentEditColumnObj.id,function(data,exception){});
				});
		}
		
		$("#columnline_tb2 tr:gt(0)").each(function(index,item){
				if(columnlineCaculateColumn.currentEditColumnObj.name==$(this).find(":text.columnline_ser").val()){
						var info={extcolumnid:columnlineCaculateColumn.currentEditColumnObj.id};
						cn.com.easy.xbuilder.service.component.ColumnLineService.removeExtKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
							$(item).remove();
							cn.com.easy.xbuilder.service.component.ColumnLineService.deleteKpiStoreCol(StoreData.xid,columnlineCaculateColumn.currentEditColumnObj.id,function(data,exception){});
							if($("#columnline_tb2>tbody>tr").size()==0){
								columnline_appendKpiRow();
							}
						});
						return false;
				}
		});
	}
}