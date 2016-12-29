function bar_initDroppable(){
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
				selectBarKpiSuccess(barKpiSelector.currentItem);
			}else{//计算列选择
				var itemObj = {
						id:"",
						column:"",
						desc:$(source).attr("desc"),
						kpiType:'extcolumn',
						extcolumnid:$(source).attr("node-id"),
						isextcolumn:'true'
				}
				selectBarKpiSuccess(itemObj);
			}
		}
	});
}

/**
 * 选择指标列
 * @param obj
 */
function bar_selectSer(obj){
	var $ser = $(this);
	var ser_value = $ser.combobox("getText");
	$ser.parent().parent().find(":text[name='bar_sername']").val(ser_value);
}

/**
 * 添加指标行
 * @returns
 */
function bar_appendKpiRow(){
	var errMsg = validBarKpiRow();
	if(errMsg!=""){
		$.messager.alert("条形图","添加失败，请先处理以下错误：<br/>"+errMsg,"info");
		return;
	}
	$("#bar_tb2").append($("#kpiRowHtml").find("tr").eq(0)[0].outerHTML);
	var $row = $("#bar_tb2 tr:last-child");
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
	    	bar_fun_SetKpi();
	    }
	});
	var $ref = $row.find(":text.bar_ref").combobox();
	var quoteData = bar_getQuote();
	$ref.combobox({onLoadSuccess:function(){
		$ref.combobox('setValue', quoteData[0].id);
	}});
	$ref.combobox('loadData', quoteData);
	$row.click(function(){
		$("#bar_tb2 tr").each(function(index,item){
			$(item).removeClass("kpi_select_row");
		})
		$row.addClass("kpi_select_row");
		$("#bar_tb2 tr:eq(0)").removeClass("kpi_select_row");
	});
	bar_initDroppable();
	return $row; 
}

/**
 * 校验指标行
 * @returns {String}
 */
function validBarKpiRow(){
	var errMessage = "";
	var kpiMap = new Object();
	$("#bar_tb2 tr:gt(0)").each(function(index){
		var ser = $(this).find(":text.bar_ser").val();
		var ser_name = $(this).find(":text[name='bar_sername']").val();
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
function bar_fun_SetOrd(){	
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var isextcolumn = $("#bar_ord").attr("isextcolumn");
	var kpiId = $("#bar_ord").attr("kpiId");
	var kpiColumn = $("#bar_ord").attr("kpiColumn");
	var extcolumnid = $("#bar_ord").attr("extcolumnid");
	var sortType = $("#bar_sorttype").combobox("getValue");
	if((isextcolumn=="true"&&typeof(extcolumnid)!="undefined"&&extcolumnid!="")||(isextcolumn=="false"&&typeof(kpiColumn)!="undefined"&&kpiColumn!="")){
		info.ord=isextcolumn=="true"?extcolumnid:kpiColumn;
		info.sortType = sortType;
		info.ordKpiId=kpiId;
		info.isextcolumn = isextcolumn;
		cn.com.easy.xbuilder.service.component.BarService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	}
}

/**
 * 设置维度列
 */
function bar_fun_SetDim(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var dimension = $("#bar_dim").attr("kpiColumn");
	if(typeof(dimension)!="undefined"&&dimension!=""){
		info.dimFieldId = $("#bar_dim").attr("kpiId");
		info.dimension=dimension;
		info.isextcolumn = "false";
		cn.com.easy.xbuilder.service.component.BarService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	} 
}

/**
 * 设置指标列
 */
function bar_fun_SetKpi(){
	var kpiMap = new Object(); 
	var hasRepeatKpi = false;
	$("#bar_tb2 tr:gt(0)").each(function(index,item){
		var bar_ser = $(this).find(":text.bar_ser").attr("kpiId")==""?$(this).find(":text.bar_ser").attr("extcolumnid"):$(this).find(":text.bar_ser").attr("kpiId");
		if(kpiMap[bar_ser]==undefined){
			kpiMap[bar_ser]=bar_ser;
		}else{
			hasRepeatKpi = true;
			$.messager.alert("条形图","指标"+$(this).find(":text.bar_ser").val()+"已添加，不能重复添加！","info");
			return false;
		}
	});
	if(hasRepeatKpi){
		return;
	}
	bar_fun_SetScale();//初始化刻度设置
	var errMsg="";
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var kpiArr = [];
	$("#bar_tb2 tr:gt(0)").each(function(i){
		var kpiItem = {};
		var $serInput = $(this).find(":text.bar_ser");
		var kpiId = $serInput.attr("kpiId");
		var kpiColumn = $serInput.attr("kpiColumn");
		var extcolumnid = $serInput.attr("extcolumnid");
		var isextcolumn = $serInput.attr("isextcolumn");
		
		var yaxisid = $(this).find(":text.bar_ref").combobox("getValue");
		var color = $(this).find(":text.colorpk").spectrum("get").toHexString();
		var ser_name = $(this).find(":text[name='bar_sername']").val();
		if(isextcolumn=='false'&&kpiId!=undefined&&kpiId!=""||isextcolumn=='true'&&extcolumnid!=undefined&&extcolumnid!=""){//指标列为指标库列时kpiId不能为空，为计算列时extcolumnid不能为空
			kpiItem.kpiId = kpiId;
			kpiItem.ser = isextcolumn=="true"?extcolumnid:kpiColumn;
			kpiItem.extcolumnid=extcolumnid;
			kpiItem.isextcolumn=isextcolumn;
			kpiItem.ref = yaxisid;
			kpiItem.color = color;
			kpiItem.type = "column";
			kpiItem.ser_name = ser_name;
			kpiArr.push(kpiItem);
		}else{
			errMsg=errMsg+"指标列不能为空！";
			return false;
		}
	});
	if(errMsg!=""){
		//$.messager.alert("柱图",errMsg,"info");
		return;
	}
	$('#bar_dialog2').dialog('close');
	cn.com.easy.xbuilder.service.component.BarService.setKpi(StoreData.xid,containerId,componentId,$.toJSON({kpiList:kpiArr}),function(data,exception){});
}

/**
 * 编辑还原
 */
function bar_fun_edit(containerId,componentId){
	/*还原*/
	cn.com.easy.xbuilder.service.component.BarService.getComponentJsonData(StoreData.xid,containerId,componentId,$.toJSON({}),function(data,exception){
		var jsonObj=$.parseJSON(data);
		if(jsonObj!=null&&jsonObj!=undefined){
			var kpiColMap=jsonObj.kpiColMap;
			/*设置标题*/
			var title = jsonObj.chartTitle;
			if(typeof(title)=="undefined"){
				$("#bar_title").val(''); 
			}else{ 
				$("#bar_title").val(title);
			}if(jsonObj.showTitle=="1"){
				$("#showTitle").iCheck('check');
			}else{
				$("#showTitle").iCheck('uncheck');
			}
			/*设置图例*/
			if(jsonObj.legend != undefined){
				bar_restoreLegendPosition(jsonObj.legend.position);
			}else{
				bar_setLegend('bottom');
			}
			/*设置维度列和排序列*/
			if(jsonObj.xaxis!=null&&jsonObj.xaxis!=undefined){
				var sortColId = jsonObj.xaxis.sortFiledId==""?jsonObj.xaxis.sortExtField:jsonObj.xaxis.sortFiledId;
				if(jsonObj.xaxis.dimFiledId!=""){
					  $("#bar_dim").val(kpiColMap[jsonObj.xaxis.dimFiledId].kpidesc); 
					  $("#bar_dim").attr("kpiId",jsonObj.xaxis.dimFiledId);
					  $("#bar_dim").attr("kpiColumn",jsonObj.xaxis.dimfield); 
				}
			    $("#bar_ord").val(kpiColMap[sortColId].kpidesc);
			    $("#bar_ord").attr("kpiId",jsonObj.xaxis.sortFiledId);
			    $("#bar_ord").attr("kpiColumn",jsonObj.xaxis.sortfield);
			    $("#bar_ord").attr("isextcolumn",jsonObj.xaxis.sortExtField!=""?"true":"false");
			    $("#bar_ord").attr("extcolumnid",jsonObj.xaxis.sortExtField);
				$("#bar_sorttype").combobox("setValue",jsonObj.xaxis.sortType); 
			}
			
			/*刻度设置*/
			var yaxisList=jsonObj.yaxisList;
			if(typeof(yaxisList)!="undefined"&&yaxisList!=null){
				for(var i=0;i<yaxisList.length;i++){
			        var $row=$("#bar_tb1").find("tr").eq(i+1);
					if(yaxisList[i].title) $row.find(":text[name='bar_title']").val(yaxisList[i].title);
					if(yaxisList[i].color) $row.find(":text.colorpk").spectrum("set",yaxisList[i].color);
					if(yaxisList[i].unit) $row.find(":text[name='bar_unit']").val(yaxisList[i].unit);
				}
			} 
			
			/*指标设置*/
			var kpiList=jsonObj.kpiList;
			if(typeof(kpiList)!="undefined"&&kpiList!=null){
				$("#bar_tb2 tr:gt(0)").remove();
				var kpiId="";
				for(var i=0;i<kpiList.length;i++){
					var $row = bar_appendKpiRow();
					var $serInput=$row.find(":text.bar_ser");
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
					if(kpiList[i].name)  $row.find(":text[name='bar_sername']").val(kpiList[i].name);
					if(kpiList[i].color) $row.find(":text.colorpk").spectrum("set",kpiList[i].color);
					if(kpiList[i].yaxisid) $row.find(":text.bar_ref").combobox("setValue",kpiList[i].yaxisid);
				}
				if($("#bar_tb2 tr:gt(0)").length==0){
					var $row = bar_appendKpiRow();
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
function openBarKpiDialog(){
	  var cubeId = StoreData.cubeId;
	  barKpiSelector.open(cubeId);
}

/**
 * 指标库对话框选择事件
 * @param kpiArr
 */
function selectBarKpiSuccess(itemObj){
	var kpi = itemObj;
	var kpiType = kpi.kpiType;
	var curSelectInputId=$("#curSelectInput").val();
	if($("#"+curSelectInputId).attr("name")=="bar_dim"){
		if(kpiType=='kpi'||kpiType=="extcolumn"){
			$.messager.alert("条形图","指标不能作为维度使用！","info");
			return;
		}
	}if($("#"+curSelectInputId).attr("name")=="bar_ser"){
		if(kpiType=='dim'||kpiType=='property'){
			$.messager.alert("条形图",(kpiType=='dim'?"维度":"属性")+"不能作为指标使用！","info");
			return;
		}
	}
	$("#"+curSelectInputId).val(kpi.desc);
	$("#"+curSelectInputId).attr("kpiId",kpi.id);
	$("#"+curSelectInputId).attr("kpiColumn",kpi.column);
	$("#"+curSelectInputId).attr("isextcolumn",kpi.isextcolumn);
	$("#"+curSelectInputId).attr("extcolumnid",kpi.extcolumnid);
	if($("#"+curSelectInputId).attr("name")=="bar_ser"){
		$("#"+curSelectInputId).parent().next("td").find("input").val(kpi.desc);
		bar_fun_SetKpi();
	}
	else if(curSelectInputId=="bar_ord"){
		bar_fun_SetOrd();
	}else if(curSelectInputId=="bar_dim"){
		if(kpi.isextcolumn=="true"){
			$.messager.alert("条形图","计算列不能作维度！","error");
		}else{
			bar_fun_SetDim();
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
				kpistoreColHasAdded : getAllBarSelectedKpiIds()
	          }
	cn.com.easy.xbuilder.service.XComponentService.addKpiStoreCol(info,function(data,exception){
		if(exception!=undefined){
			$.messager.alert("条形图","保存指标时发生错误："+exception,"info");
		}
	});
}

/**
 * 获取组件已选择的所有的指标Id的字符串
 * @returns {String}
 */
function getAllBarSelectedKpiIds(){
	var kpiIds = "";
	if($("#bar_ord").attr("kpiId")!=undefined&&$("#bar_ord").attr("kpiId")!=""){
		kpiIds+=$("#bar_ord").attr("kpiId")+",";
	}
	if($("#bar_ord").attr("extcolumnid")!=undefined&&$("#bar_ord").attr("extcolumnid")!=""){
		kpiIds+=$("#bar_ord").attr("extcolumnid")+",";
	}
	if($("#bar_dim").attr("kpiId")!=undefined&&$("#bar_dim").attr("kpiId")!=""){
		kpiIds+=$("#bar_dim").attr("kpiId")+",";
	}
	$("#bar_tb2 tr:gt(0)").each(function(index,item){
		var bar_ser = $(this).find(":text.bar_ser");
		if($(bar_ser).attr("kpiId")!=undefined&&$(bar_ser).attr("kpiId")!=""){
			kpiIds+=$(bar_ser).attr("kpiId")+",";
		}
		if($(bar_ser).attr("extcolumnid")!=undefined&&$(bar_ser).attr("extcolumnid")!=""){
			kpiIds+=$(bar_ser).attr("extcolumnid")+",";
		}
	});
	kpiIds = kpiIds.substring(0,kpiIds.length-1);
	return kpiIds;
}

/**
 * 删除指标行
 * @param obj
 */
function bar_removeKpiRow(){
	var obj = $(".kpi_select_row").eq(0);
	if(obj[0]==undefined){
		$.messager.alert("条形图","请选择要删除的指标!","info");
	}else if(obj[0]!=undefined&&$("#bar_tb2 tr:gt(0)").length>1){
		var info = {
				    viewId:StoreData.xid,
				    componentId:StoreData.curComponentId,
				    containerId:StoreData.curContainerId,
				    kpiId:$(obj).find("td:eq(0)").find("input:eq(0)").attr("kpiId")
		};
		cn.com.easy.xbuilder.service.XComponentService.removeKpiRow(info,function(data,exception){
			 if(exception!=undefined){
				 $.messager.alert("条形图","删除指标发生错误："+exception,"info");
			 }else{
				 $(obj).remove();
			 }
		});
	}else if(obj[0]!=undefined&&$("#bar_tb2 tr:gt(0)").length==1){
		$.messager.alert("条形图","不能删除,请至少保留一个指标!","info");
	}else{
		$.messager.alert("条形图","删除失败","info");
	}
}

/**
 * 更新数据集UI
 */
function barUpdataDatasetUI(action){
	var info ={
		    viewId:StoreData.xid,
		    kpiType:"extcolumn",
		    componentId : StoreData.curComponentId,
			containerId : StoreData.curContainerId,
			kpistoreColHasAdded : getAllBarSelectedKpiIds()
     }
	if(action=="edit"){
		if(barCaculateColumn.getColumnOldName()==$("#bar_ord").val()){
			$("#bar_ord").val(barCaculateColumn.currentEditColumnObj.name);
			info.kpistoreColId=$("#bar_ord").attr("extcolumnid");
			info.kpiColumn=$("#bar_ord").attr("extcolumnid");
			info.kpiDesc=$("#bar_ord").val();
			cn.com.easy.xbuilder.service.XComponentService.addKpiStoreCol(info,function(data,exception){
				if(exception!=undefined){
					$.messager.alert("柱图","保存指标时发生错误："+exception,"info");
				}
			});
		}
		$("#bar_tb2 tr:gt(0)").each(function(index,item){
			if(barCaculateColumn.getColumnOldName()==$(this).find(":text.bar_ser").val()){
				$(this).find(":text.bar_ser").val(barCaculateColumn.currentEditColumnObj.name);
				$(this).find("input[name='bar_sername']").val(barCaculateColumn.currentEditColumnObj.name);
				info.kpistoreColId=$(this).find(":text.bar_ser").attr("extcolumnid");
				info.kpiColumn=$(this).find(":text.bar_ser").attr("extcolumnid");
				info.kpiDesc=$(this).find(":text.bar_ser").val();
				cn.com.easy.xbuilder.service.XComponentService.addKpiStoreCol(info,function(data,exception){
						if(exception!=undefined){
							$.messager.alert("柱图","保存指标时发生错误："+exception,"info");
						}else{
							bar_fun_SetKpi();
						}
			    });
			}
		});
	}else if(action=="remove"){
		var componentId = StoreData.curComponentId;
		var containerId = StoreData.curContainerId;
		if(barCaculateColumn.currentEditColumnObj.name==$("#bar_ord").val()){
				var sortType = $("#bar_sorttype").combobox("getValue");
				var kpiType = $("#bar_ord").attr("kpiType");
				var info={ord:"",isextcolumn:"true",kpiType:kpiType,sortType:sortType};
				cn.com.easy.xbuilder.service.component.BarService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
					$("#bar_ord").val("");
					$("#bar_ord").attr("kpiId","");
					$("#bar_ord").attr("kpiColumn","");
					$("#bar_ord").attr("isextcolumn","false");
					$("#bar_ord").attr("extcolumnid","");
					//调用删除kpistore方法
					cn.com.easy.xbuilder.service.component.BarService.deleteKpiStoreCol(StoreData.xid,barCaculateColumn.currentEditColumnObj.id,function(data,exception){});
				});
		}
		
		$("#bar_tb2 tr:gt(0)").each(function(index,item){
				if(barCaculateColumn.currentEditColumnObj.name==$(this).find(":text.bar_ser").val()){
						var info={extcolumnid:barCaculateColumn.currentEditColumnObj.id};
						cn.com.easy.xbuilder.service.component.BarService.removeExtKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
							$(item).remove();
							cn.com.easy.xbuilder.service.component.BarService.deleteKpiStoreCol(StoreData.xid,barCaculateColumn.currentEditColumnObj.id,function(data,exception){});
							if($("#bar_tb2>tbody>tr").size()==0){
								bar_appendKpiRow();
							}
						});
						return false;
				}
		});
	}
}