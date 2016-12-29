function column_showColumn(obj){
	if($("#column_data").attr("oldValue")!=obj.id){
		if(obj.attributes.datatype=="2"){//数据集为map类型
			$.messager.alert("系统提示","柱图不能使用map类型数据集","error");
			$("#column_data").combobox("setValue",$("#column_data").attr("oldValue"));
		}else{
			$("#column_data").attr("oldValue",obj.id);
			var info={};
			var componentId = StoreData.curComponentId;
			var containerId = StoreData.curContainerId;
			var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+obj.id;
			var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
			
			//获得计算列
			var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+obj.id;
			var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
			for(var i=0;i<extData.length;i++){
				data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
			}
			$("#column_dim").combobox('setValue', '请选择').combobox('loadData', data); 
			$("#column_ord").combobox('setValue', '请选择').combobox('loadData', data); 
			$("#column_tb2 tr:gt(0)").remove();
			var $row = column_appendKpiRow();
			if(typeof(obj.id)!="undefined"&&obj.id!="请选择"){
				info.sqlId=(obj.id).substring(1);
				cn.com.easy.xbuilder.service.component.ColumnService.setDataSourceId(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
			}
		}
	}
}

/**
 * 校验指标行
 * @returns {String}
 */
function validColumnKpiRow(){
	var errMessage = "";
	var kpiMap = new Object();
	$("#column_tb2 tr:gt(0)").each(function(index){
		var ser = $(this).find(":text.column_ser").combobox("getText");
		var ser_name = $(this).find(":text[name='column_sername']").val();
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
 * 选择指标列
 */
function column_selectSer(obj){
	var $ser = $(this);
	var ser_value = $ser.combobox("getText");
	var curSer = $("#column_tb2 tr[class='kpi_select_row']").eq(0).find(":text.column_ser");
	curSer.attr("serName",$ser.parent().parent().find(":text[name='column_sername']").val());
	$ser.parent().parent().find(":text[name='column_sername']").val(ser_value);
	curSer.attr("isextcolumn",obj.isextcolumn==true?"true":"false");
	column_fun_SetKpi();
}

/**
 * 添加指标行
 */
function column_appendKpiRow(){
	var errMsg = validColumnKpiRow();
	if(errMsg!=""){
		$.messager.alert("柱图","添加失败，请先处理以下错误：<br/>"+errMsg,"info");
		return;
	}
	$("#column_tb2").append($("#kpiRowHtml").find("tr").eq(0)[0].outerHTML);
	var $row = $("#column_tb2 tr:last-child");
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
	    	column_fun_SetKpi();
	    }
	});
	var $ser = $row.find(":text.column_ser").combobox();
	var $ref = $row.find(":text.column_ref").combobox();
	var ser_data=[];
	try{ 
		ser_data = $("#column_dim").combobox("getData");
	} 
	catch (e){ 
		ser_data = [];
	} 
	$ser.combobox('setValue', '请选择').combobox('loadData', ser_data); 
	var quoteData = column_getQuote();
	$ref.combobox({onLoadSuccess:function(){
		$ref.combobox('setValue', quoteData[0].id);
	}});
	$ref.combobox('loadData', quoteData);
	$row.click(function(){
		$("#column_tb2 tr").each(function(index,item){
			$(item).removeClass("kpi_select_row");
		})
		$row.addClass("kpi_select_row");
		$("#column_tb2 tr:eq(0)").removeClass("kpi_select_row");
	});
	return $row; 
}

/**
 * 保存排序列信息到xml
 */
function column_saveOrder(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var column_ord = $("#column_ord").attr("isextcolumn")=="true"?$("#column_ord").combobox("getValue"):$("#column_ord").combobox("getText");
	var sortType = $("#column_sorttype").combobox("getValue");
	var kpiType = $("#column_kpitype").combobox("getValue");
	if(typeof(column_ord)!="undefined"&&column_ord!="请选择"){
		info.ord=column_ord;
		info.kpiType = kpiType;
		info.sortType = sortType;
		info.isextcolumn=$("#column_ord").attr("isextcolumn");
		cn.com.easy.xbuilder.service.component.ColumnService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	}
}

/**
 * 设置排序列
 */
function column_fun_SetOrd(record){
	var column_ord = $("#column_ord").combobox("getText");
	//判断选择的排序列是否为指标，如果为指标，设置排序列类型为kpi
	$("#column_tb2 tr:gt(0)").each(function(index,item){
		var column_ser = $(this).find(":text.column_ser").combobox("getText");
		if(column_ser==column_ord){
			$("#column_kpitype").combobox("setValue","kpi");
		}
	});
	//判断选择的排序列是否为维度，如果为指标，设置排序列类型为维度
	if($("#column_dim").combobox("getText")==column_ord){
		$("#column_kpitype").combobox("setValue","dim");
	}
	$("#column_ord").attr("isextcolumn",record.isextcolumn);
	column_saveOrder();
}

var column_oldValue;//全局变量,
function column_onShowPanel(){
	column_oldValue = $(this).combobox("getText");
}

/**
 * 设置维度列
 */
function column_fun_SetDim(record){
	var dimension = $("#column_dim").combobox("getText");
	var isextcolumn = record.isextcolumn==true?"true":"false";
	$("#column_dim").attr("isextcolumn",isextcolumn);
	var isSameToKpi = false;
	$("#column_tb2 tr:gt(0)").each(function(index,item){
		var column_ser = $(this).find(":text.column_ser").combobox("getText");
		if(column_ser==dimension){
			isSameToKpi = true;
			return false;
		}
	});
	if(isSameToKpi){
		$.messager.alert("柱图","列“"+dimension+"”已被选择为指标列，不能再选择为维度列！","info");
		$("#column_dim").combobox("setText",column_oldValue);
		return;
	}
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	dimension = isextcolumn=="true"?$("#column_dim").combobox("getValue"):$("#column_dim").combobox("getText");
	if(typeof(dimension)!="undefined"&&dimension!="请选择"){
		info.dimension=dimension;
		info.isextcolumn=isextcolumn;
		cn.com.easy.xbuilder.service.component.ColumnService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
			//如果设置的维度列和排序列相同，修改排序列为维度类型并保存到xml
			if($("#column_ord").combobox("getText")==dimension){
				$("#column_kpitype").combobox("setValue","dim");
				column_saveOrder();
			}
		});
	} 
}


/**
 * 设置指标列
 */
function column_fun_SetKpi(){
	var curSer = $("#column_tb2 tr[class='kpi_select_row']").eq(0).find(":text.column_ser");//当前选择的行
	var kpiMap = new Object();
	var dimension = $("#column_dim").combobox("getText");
	//将维度列也放到kpiMap中检查，因为指标列不能和维度列重复
	if(dimension!=""&&dimension!=undefined){
		kpiMap[dimension]=dimension;
	}
	var hasRepeatKpi = false;
	$("#column_tb2 tr:gt(0)").each(function(index,item){
		var column_ser = $(this).find(":text.column_ser").combobox("getText");
		if(kpiMap[column_ser]==undefined){
			kpiMap[column_ser]=column_ser;
		}else{
			hasRepeatKpi = true;
			if(dimension == column_ser){
				$.messager.alert("柱图","列“"+column_ser+"”已被选择为维度列，不能再选择为指标列！","info");
			}else{
				$.messager.alert("柱图","指标"+column_ser+"已添加，不能重复添加！","info");
			}
			return false;
		}
	});
	if(hasRepeatKpi){
		curSer.combobox("setText",column_oldValue);//恢复原来的指标列
		curSer.parent().next("td").find("input:eq(0)").val(curSer.attr("serName"));//恢复原来的名字
		return;
	}
	column_fun_SetScale();//初始化刻度设置
	var errMsg="";
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var info={};
	var serfd = [];
	var changeOrder=false;
	$("#column_tb2 tr:gt(0)").each(function(i){
		var cols = {};
		var ser = $(this).find(":text.column_ser").combobox("getText");
		var ref = $(this).find(":text.column_ref").combobox("getValue");
		var color = $(this).find(":text.colorpk").spectrum("get").toHexString();
		var ser_name = $(this).find(":text[name='column_sername']").val();
		//如果设置的指标列和排序列相同，修改排序列为指标类型并保存到xml
		if($("#column_ord").combobox("getText")==ser){
			$("#column_kpitype").combobox("setValue","kpi");
			changeOrder = true;
		}
		if(typeof(ser)!="undefined"&&ser!="请选择"&&ser!=""){
			cols.isextcolumn=$(this).find(":text.column_ser").attr("isextcolumn");
			cols.ser = cols.isextcolumn=="true"?$(this).find(":text.column_ser").combobox("getValue"):$(this).find(":text.column_ser").combobox("getText");
			if(typeof(ref)!="undefined"&&ref!=""){
				cols.ref = ref;
			}
			if(typeof(color)!="undefined"&&color!=""){
				cols.color = color;
			}
			cols.type = "column";
			if(typeof(ser_name)!="undefined"&&ser_name!=""){
				cols.ser_name = ser_name;
			}else{
				errMsg=errMsg+"指标名不能为空！";
				return false;
			}
			serfd.push(cols);
		}else{
			errMsg=errMsg+"指标列不能为空！";
			return false;
		
		}
	});
	if(errMsg!=""){
		return;
	}
	info.kpiList=serfd;
	cn.com.easy.xbuilder.service.component.ColumnService.setKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
		if(changeOrder){
			column_saveOrder();
		}
	});
}

/**
 * 编辑还原
 */
function column_fun_edit(containerId,componentId){
	/*还原*/
	cn.com.easy.xbuilder.service.component.ColumnService.getComponentJsonData(StoreData.xid,containerId,componentId,$.toJSON({}),function(data,exception){
		var jsonObj=$.parseJSON(data);
		if(jsonObj!=null&&jsonObj!=undefined){
			/*设置标题*/
			var title = jsonObj.chartTitle;
			if(typeof(title)=="undefined"){
				$("#column_title").val(''); 
			}else{ 
				$("#column_title").val(title);
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
				column_restoreLegendPosition(jsonObj.legend.position);
			}else{
				column_setLegend('bottom');
			}
			/*设置数据集、维度列、排序列*/
			var dateJson=$.ajax({url: appBase+"/getAllDataSourceJsonX.e?report_id="+StoreData.xid,type:"POST",cache: false,async: false}).responseText;
			var data=[];
			if(dateJson!=null&&dateJson!=""){
				data = $.evalJSON(dateJson);
				$("#column_data").combobox('loadData', data); 
			}
			var sql_id = jsonObj.datasourceid;
			var columnData = [];
			if(typeof(sql_id)!="undefined"&&sql_id!=null){
				sql_id='B'+sql_id;
				$("#column_data").combobox("setValue",sql_id);
				$("#column_data").attr("oldValue",sql_id);
				var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+sql_id;
				columnData = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
				var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+sql_id;
				var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
				for(var i=0;i<extData.length;i++){
					columnData.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
				}
				$("#column_dim").combobox('loadData', columnData).combobox('setText', '请选择');
				$("#column_ord").combobox('loadData', columnData).combobox('setText', '请选择'); 
			}
			if(jsonObj.xaxis!=null&&jsonObj.xaxis!=undefined){
				var dimension = jsonObj.xaxis.dimfield==""?jsonObj.xaxis.dimExtField:jsonObj.xaxis.dimfield;
				var ord = jsonObj.xaxis.sortfield==""?jsonObj.xaxis.sortExtField:jsonObj.xaxis.sortfield;
				var kpiType = jsonObj.xaxis.sortkpitype;
				var sortType = jsonObj.xaxis.sortType;
				if(typeof(dimension)!="undefined"&&dimension!=""){
				    if(jsonObj.xaxis.dimExtField!=""){
				   		 $("#column_dim").combobox("setValue",dimension);
				   		 $("#column_dim").attr("isextcolumn","true");
				    }else{
				   		 $("#column_dim").combobox("setText",dimension);
				   		 $("#column_dim").attr("isextcolumn","false");
				    }
				}
				if(typeof(ord)!="undefined"&&ord!=""){
					 if(jsonObj.xaxis.sortExtField!=""){
				   		 $("#column_ord").combobox("setValue",ord);
				   		 $("#column_ord").attr("isextcolumn","true");
				    }else{
				   		 $("#column_ord").combobox("setText",ord);
				   		 $("#column_ord").attr("isextcolumn","false");
				    }
				}
				if(typeof(kpiType)!="undefined"&&kpiType!=""){
					$("#column_kpitype").combobox("setValue",kpiType); 
				}
				if(typeof(sortType)!="undefined"&&sortType!=""){
					$("#column_sorttype").combobox("setValue",sortType); 
				}
			}
			
			/*刻度设置*/
			var yaxisList=jsonObj.yaxisList;
			if(typeof(yaxisList)!="undefined"&&yaxisList!=null){
				for(var i=0;i<yaxisList.length;i++){
					var $row =$("#column_tb1").find("tr").eq(i+1);
					if(yaxisList[i].title) $row.find(":text[name='column_title']").val(yaxisList[i].title);
					if(yaxisList[i].color) $row.find(":text.colorpk").spectrum("set",yaxisList[i].color);
					if(yaxisList[i].unit) $row.find(":text[name='column_unit']").val(yaxisList[i].unit);
				}
			} 
			
			/*指标设置*/
			var kpiList=jsonObj.kpiList;
			if(typeof(kpiList)!="undefined"&&kpiList!=null){
				$("#column_tb2 tr:gt(0)").remove();
				for(var i=0;i<kpiList.length;i++){
					var $row = column_appendKpiRow();
					if(kpiList[i].extcolumnid!=""){
				   		$row.find(":text.column_ser").combobox("setValue",kpiList[i].extcolumnid);
						$row.find(":text.column_ser").attr("isextcolumn","true");
					}else{
					   	$row.find(":text.column_ser").combobox("setText",kpiList[i].field);
						$row.find(":text.column_ser").attr("isextcolumn","false");
				    }
					if(kpiList[i].name) $row.find(":text[name='column_sername']").val(kpiList[i].name);
					if(kpiList[i].color) $row.find(":text.colorpk").spectrum("set",kpiList[i].color);
					if(kpiList[i].yaxisid) $row.find(":text.column_ref").combobox("setValue",kpiList[i].yaxisid);
				}
			}else{
				$("#column_tb2 tr:gt(0)").remove();
				var $row = column_appendKpiRow();
				$row.find(":text.column_ser").combobox("loadData",columnData);
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
 * 删除指标行
 * @param obj
 */
function column_removeKpiRow(obj){
	var obj = $(".kpi_select_row").eq(0);
	if(obj[0]==undefined){
		$.messager.alert("柱图","请选择要删除的指标!","info");
	}else if(obj[0]!=undefined&&$("#column_tb2 tr:gt(0)").length>1){
		$(obj).remove();
		column_fun_SetKpi();
	}else if(obj[0]!=undefined&&$("#column_tb2 tr:gt(0)").length==1){
		$.messager.alert("柱图","不能删除,请至少保留一个指标!","info");
	}else{
		$.messager.alert("柱图","删除失败","info");
	}
	
}

/**
 * 更新数据集UI
 */
function columnUpdataDatasetUI(action){
	var reportSqlId = $("#column_data").combobox('getValue');
	var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+reportSqlId;
	var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
	
	//获得计算列
	var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+reportSqlId;
	var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
	for(var i=0;i<extData.length;i++){
		data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
	}
	
	var dimValue = $("#column_dim").combobox('getText');
	var orderValue = $("#column_ord").combobox('getText');
	$("#column_dim").combobox('loadData', data).combobox('setText',dimValue); 
	$("#column_ord").combobox('loadData', data).combobox('setText',orderValue); 
	var kpiTrs = $("#column_tb2>tbody>tr");
	$.each(kpiTrs,function(index,item){
		$ser = $(item).find(":text.column_ser").combobox();
		var kpiText = $ser.combobox('getText');
		$ser.combobox('loadData', data).combobox('setText',kpiText); 
	});
	
	if(action=="edit"){
		if(columnCaculateColumn.getColumnOldName()==$("#column_dim").combobox("getText")){
			$("#column_dim").combobox("select",columnCaculateColumn.currentEditColumnObj.id);
		}
		if(columnCaculateColumn.getColumnOldName()==$("#column_ord").combobox("getText")){
			$("#column_ord").combobox("select",columnCaculateColumn.currentEditColumnObj.id);
		}
		$("#column_tb2 tr:gt(0)").each(function(index,item){
			if(columnCaculateColumn.getColumnOldName()==$(this).find(":text.column_ser").combobox("getText")){
				$(this).find(":text.column_ser").combobox("select",columnCaculateColumn.currentEditColumnObj.id);
			}
		});
	}else if(action=="remove"){
		var componentId = StoreData.curComponentId;
		var containerId = StoreData.curContainerId;
		
		if(columnCaculateColumn.currentEditColumnObj.name==$("#column_dim").combobox("getText")){
				var info={dimension:"",isextcolumn:"true"};
				cn.com.easy.xbuilder.service.component.ColumnService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
							$("#column_dim").combobox("setText",'请选择');
				});
		}
		
		if(columnCaculateColumn.currentEditColumnObj.name==$("#column_ord").combobox("getText")){
				var sortType = $("#column_sorttype").combobox("getValue");
				var kpiType = $("#column_kpitype").combobox("getValue");
				var info={ord:"",isextcolumn:"true",kpiType:kpiType,sortType:sortType};
				cn.com.easy.xbuilder.service.component.ColumnService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
							$("#column_ord").combobox("setText",'请选择');
				});
		}
		
		$("#column_tb2 tr:gt(0)").each(function(index,item){
				if(columnCaculateColumn.currentEditColumnObj.name==$(this).find(":text.column_ser").combobox("getText")){
						var info={extcolumnid:columnCaculateColumn.currentEditColumnObj.id};
						cn.com.easy.xbuilder.service.component.ColumnService.removeExtKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
							$(item).remove();
							if($("#column_tb2>tbody>tr").size()==0){
								column_appendKpiRow();
							}
						});
						return false;
				}
		});
	}
	
}