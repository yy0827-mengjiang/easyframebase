var line_oldValue;
function line_onShowPanel(){
	line_oldValue = $(this).combobox("getText");
}

function line_saveOrder(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var line_ord = $("#line_ord").attr("isextcolumn")=="true"?$("#line_ord").combobox("getValue"):$("#line_ord").combobox("getText");
	var sortType = $("#line_sorttype").combobox("getValue");
	var kpiType = $("#line_kpitype").combobox("getValue");
	if(typeof(line_ord)!="undefined"&&line_ord!="请选择"){
		info.ord=line_ord;
		info.kpiType = kpiType;
		info.sortType = sortType;
		info.isextcolumn=$("#line_ord").attr("isextcolumn");
		cn.com.easy.xbuilder.service.component.LineService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	}
}

function line_showColumn(obj){
	if($("#line_data").attr("oldValue")!=obj.id){
		if(obj.attributes.datatype=="2"){//数据集为map类型
			$.messager.alert("系统提示","线图不能使用map类型数据集","error");
			$("#line_data").combobox("setValue",$("#line_data").attr("oldValue"));
		}else{
			$("#line_data").attr("oldValue",obj.id);
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
			$("#line_dim").combobox('setValue', '请选择').combobox('loadData', data); 
			$("#line_ord").combobox('setValue', '请选择').combobox('loadData', data); 
			$("#line_tb2 tr:gt(0)").remove();
			var $row = line_appendKpiRow();
			if(typeof(obj.id)!="undefined"&&obj.id!="请选择"){
				info.sqlId=(obj.id).substring(1);
				cn.com.easy.xbuilder.service.component.LineService.setDataSourceId(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
			}
		}
	}
}

/**
 * 校验指标行
 * @returns {String}
 */
function validLineKpiRow(){
	var errMessage = "";
	var kpiMap = new Object();
	$("#line_tb2 tr:gt(0)").each(function(index){
		var ser = $(this).find(":text.line_ser").combobox("getText");
		var ser_name = $(this).find(":text[name='line_sername']").val();
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
function line_selectSer(obj){
	var $ser = $(this);
	var ser_value = $ser.combobox("getText");
	var curSer = $("#line_tb2 tr[class='kpi_select_row']").eq(0).find(":text.line_ser");
	curSer.attr("serName",$ser.parent().parent().find(":text[name='line_sername']").val());
	$ser.parent().parent().find(":text[name='line_sername']").val(ser_value);
	curSer.attr("isextcolumn",obj.isextcolumn==true?"true":"false");
	line_fun_SetKpi();
}

/**
 * 添加指标行
 */
function line_appendKpiRow(){
	var errMsg = validLineKpiRow();
	if(errMsg!=""){
		$.messager.alert("线图","添加失败，请先处理以下错误：<br/>"+errMsg,"info");
		return;
	}
	$("#line_tb2").append($("#kpiRowHtml").find("tr").eq(0)[0].outerHTML);
	var $row = $("#line_tb2 tr:last-child");
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
	    	line_fun_SetKpi();
	    }
	});
	var $ser = $row.find(":text.line_ser").combobox();
	var $ref = $row.find(":text.line_ref").combobox();
	var ser_data=[];
	try{ 
		ser_data = $("#line_dim").combobox("getData");
	} 
	catch (e){ 
		ser_data = [];
	} 
	$ser.combobox('setValue', '请选择').combobox('loadData', ser_data); 
	var quoteData = line_getQuote();
	$ref.combobox({onLoadSuccess:function(){
		$ref.combobox('setValue', quoteData[0].id);
	}});
	$ref.combobox('loadData', quoteData);
	$row.click(function(){
		$("#line_tb2 tr").each(function(index,item){
			$(item).removeClass("kpi_select_row");
		})
		$row.addClass("kpi_select_row");
		$("#line_tb2 tr:eq(0)").removeClass("kpi_select_row");
	});
	return $row; 
}

/**
 * 设置排序列
 */
function line_fun_SetOrd(record){
	var line_ord = $("#line_ord").combobox("getText");
	//判断选择的排序列是否为指标，如果为指标，设置排序列类型为kpi
	$("#line_tb2 tr:gt(0)").each(function(index,item){
		var line_ser = $(this).find(":text.line_ser").combobox("getText");
		if(line_ser==line_ord){
			$("#line_kpitype").combobox("setValue","kpi");
		}
	});
	//判断选择的排序列是否为维度，如果为指标，设置排序列类型为维度
	if($("#line_dim").combobox("getText")==line_ord){
		$("#line_kpitype").combobox("setValue","dim");
	}
	$("#line_ord").attr("isextcolumn",record.isextcolumn);
	line_saveOrder();
	
}

/**
 * 设置维度列
 */
function line_fun_SetDim(record){
	var dimension = $("#line_dim").combobox("getText");
	var isextcolumn = record.isextcolumn==true?"true":"false";
	$("#line_dim").attr("isextcolumn",isextcolumn);
	var isSameToKpi = false;
	$("#line_tb2 tr:gt(0)").each(function(index,item){
		var line_ser = $(this).find(":text.line_ser").combobox("getText");
		if(line_ser==dimension){
			isSameToKpi = true;
			return false;
		}
	});
	if(isSameToKpi){
		$.messager.alert("线图","列“"+dimension+"”已被选择为指标列，不能再选择为维度列！","info");
		$("#line_dim").combobox("setText",line_oldValue);
		return;
	}
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	dimension = isextcolumn=="true"?$("#line_dim").combobox("getValue"):$("#line_dim").combobox("getText");
	if(typeof(dimension)!="undefined"&&dimension!="请选择"){
		info.dimension=dimension;
		info.isextcolumn=isextcolumn;
		cn.com.easy.xbuilder.service.component.LineService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
			//如果设置的维度列和排序列相同，修改排序列为维度类型并保存到xml
			if($("#line_ord").combobox("getText")==dimension){
				$("#line_kpitype").combobox("setValue","dim");
				line_saveOrder();
			}
		});
	} 
}


/**
 * 设置指标列
 */
function line_fun_SetKpi(){
	var curSer = $("#line_tb2 tr[class='kpi_select_row']").eq(0).find(":text.line_ser");//当前选择的行
	var kpiMap = new Object();
	var dimension = $("#line_dim").combobox("getText");
	//将维度列也放到kpiMap中检查，因为指标列不能和维度列重复
	if(dimension!=""&&dimension!=undefined){
		kpiMap[dimension]=dimension;
	}
	var hasRepeatKpi = false;
	$("#line_tb2 tr:gt(0)").each(function(index,item){
		var line_ser = $(this).find(":text.line_ser").combobox("getText");
		if(kpiMap[line_ser]==undefined){
			kpiMap[line_ser]=line_ser;
		}else{
			hasRepeatKpi = true;
			if(dimension == line_ser){
				$.messager.alert("线图","列“"+line_ser+"”已被选择为维度列，不能再选择为指标列！","info");
			}else{
				$.messager.alert("线图","指标"+line_ser+"已添加，不能重复添加！","info");
			}
			return false;
		}
	});
	if(hasRepeatKpi){
		curSer.combobox("setText",line_oldValue);//恢复原来的指标列
		curSer.parent().next("td").find("input:eq(0)").val(curSer.attr("serName"));//恢复原来的名字
		return;
	}
	line_fun_SetScale();//初始化刻度设置
	var errMsg="";
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var info={};
	var serfd = [];
	var changeOrder=false;
	$("#line_tb2 tr:gt(0)").each(function(i){
		var cols = {};
		var ser = $(this).find(":text.line_ser").combobox("getText");
		var ref = $(this).find(":text.line_ref").combobox("getValue");
		var color = $(this).find(":text.colorpk").spectrum("get").toHexString();
		var ser_name = $(this).find(":text[name='line_sername']").val();
		//如果设置的指标列和排序列相同，修改排序列为指标类型并保存到xml
		if($("#line_ord").combobox("getText")==ser){
			$("#line_kpitype").combobox("setValue","kpi");
			changeOrder = true;
		}
		if(typeof(ser)!="undefined"&&ser!="请选择"&&ser!=""){
			cols.isextcolumn=$(this).find(":text.line_ser").attr("isextcolumn");
			cols.ser = cols.isextcolumn=="true"?$(this).find(":text.line_ser").combobox("getValue"):$(this).find(":text.line_ser").combobox("getText");
			if(typeof(ref)!="undefined"&&ref!=""){
				cols.ref = ref;
			}
			if(typeof(color)!="undefined"&&color!=""){
				cols.color = color;
			}
			cols.type = "line";
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
	cn.com.easy.xbuilder.service.component.LineService.setKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
		if(changeOrder){
			line_saveOrder();
		}
	});
}

/**
 * 编辑还原
 */
function line_fun_edit(containerId,componentId){
	/*还原*/
	cn.com.easy.xbuilder.service.component.LineService.getComponentJsonData(StoreData.xid,containerId,componentId,$.toJSON({}),function(data,exception){
		var jsonObj=$.parseJSON(data);
		if(jsonObj!=null&&jsonObj!=undefined){
			/*设置标题*/
			var title = jsonObj.chartTitle;
			if(typeof(title)=="undefined"){
				$("#line_title").val(''); 
			}else{ 
				$("#line_title").val(title);
			}if(jsonObj.showTitle=="1"){
				$("#showTitle").iCheck('check');
			}else{
				$("#showTitle").iCheck('uncheck');
			}
			/*设置图例*/
			if(jsonObj.legend != undefined){
				line_restoreLegendPosition(jsonObj.legend.position);
			}else{
				line_setLegend('bottom');
			}
			/*设置数据集、维度列、排序列*/
			var dateJson=$.ajax({url: appBase+"/getAllDataSourceJsonX.e?report_id="+StoreData.xid,type:"POST",cache: false,async: false}).responseText;
			var data=[];
			if(dateJson!=null&&dateJson!=""){
				data = $.evalJSON(dateJson);
				$("#line_data").combobox('loadData', data); 
			}
			var sql_id = jsonObj.datasourceid;
			var columnData = [];
			if(typeof(sql_id)!="undefined"&&sql_id!=null){
				sql_id='B'+sql_id;
				$("#line_data").combobox("setValue",sql_id);
				$("#line_data").attr("oldValue",sql_id);
				var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+sql_id;
				columnData = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
				var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+sql_id;
				var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
				for(var i=0;i<extData.length;i++){
					columnData.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
				}
				$("#line_dim").combobox('loadData', columnData).combobox('setText', '请选择');
				$("#line_ord").combobox('loadData', columnData).combobox('setText', '请选择');
			}
			if(jsonObj.xaxis!=null&&jsonObj.xaxis!=undefined){
				var dimension = jsonObj.xaxis.dimfield==""?jsonObj.xaxis.dimExtField:jsonObj.xaxis.dimfield;
				var ord = jsonObj.xaxis.sortfield==""?jsonObj.xaxis.sortExtField:jsonObj.xaxis.sortfield;
				var kpiType = jsonObj.xaxis.sortkpitype;
				var sortType = jsonObj.xaxis.sortType;
				if(jsonObj.xaxis.dimExtField!=""){
			   		 $("#line_dim").combobox("setValue",dimension);
			   		 $("#line_dim").attr("isextcolumn","true");
			    }else{
			   		 $("#line_dim").combobox("setText",dimension);
			   		 $("#line_dim").attr("isextcolumn","false");
			    }

			    if(jsonObj.xaxis.sortExtField!=""){
			   		 $("#line_ord").combobox("setValue",ord);
			   		 $("#line_ord").attr("isextcolumn","true");
			    }else{
			   		 $("#line_ord").combobox("setText",ord);
			   		 $("#line_ord").attr("isextcolumn","false");
			    }
				if(typeof(kpiType)!="undefined"&&kpiType!=""){
					$("#line_kpitype").combobox("setValue",kpiType); 
				}
				if(typeof(sortType)!="undefined"&&sortType!=""){
					$("#line_sorttype").combobox("setValue",sortType); 
				}
			}
			
			/*刻度设置*/
			var yaxisList=jsonObj.yaxisList;
			if(typeof(yaxisList)!="undefined"&&yaxisList!=null){
				for(var i=0;i<yaxisList.length;i++){
					var $row =$("#line_tb1").find("tr").eq(i+1);
					if(yaxisList[i].title) $row.find(":text[name='line_title']").val(yaxisList[i].title);
					if(yaxisList[i].color) $row.find(":text.colorpk").spectrum("set",yaxisList[i].color);
					if(yaxisList[i].unit) $row.find(":text[name='line_unit']").val(yaxisList[i].unit);
				}
			} 
			
			/*指标设置*/
			var kpiList=jsonObj.kpiList;
			if(typeof(kpiList)!="undefined"&&kpiList!=null){
				$("#line_tb2 tr:gt(0)").remove();
				for(var i=0;i<kpiList.length;i++){
					var $row = line_appendKpiRow();
					if(kpiList[i].extcolumnid!=""){
				   		$row.find(":text.line_ser").combobox("setValue",kpiList[i].extcolumnid);
						$row.find(":text.line_ser").attr("isextcolumn","true");
					}else{
					   	$row.find(":text.line_ser").combobox("setText",kpiList[i].field);
						$row.find(":text.line_ser").attr("isextcolumn","false");
				    }
					if(kpiList[i].name) $row.find(":text[name='line_sername']").val(kpiList[i].name);
					if(kpiList[i].color) $row.find(":text.colorpk").spectrum("set",kpiList[i].color);
					if(kpiList[i].yaxisid) $row.find(":text.line_ref").combobox("setValue",kpiList[i].yaxisid);
				}
			}else{
				$("#line_tb2 tr:gt(0)").remove();
				var $row = line_appendKpiRow();
				$row.find(":text.line_ser").combobox("loadData",columnData);
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
function line_removeKpiRow(obj){
	var obj = $(".kpi_select_row").eq(0);
	if(obj[0]==undefined){
		$.messager.alert("线图","请选择要删除的指标!","info");
	}else if(obj[0]!=undefined&&$("#line_tb2 tr:gt(0)").length>1){
		$(obj).remove();
		line_fun_SetKpi();
	}else if(obj[0]!=undefined&&$("#line_tb2 tr:gt(0)").length==1){
		$.messager.alert("线图","不能删除,请至少保留一个指标!","info");
	}else{
		$.messager.alert("线图","删除失败","info");
	}
	
}

/**
 * 更新数据集UI
 */
function lineUpdataDatasetUI(action){
	var reportSqlId = $("#line_data").combobox('getValue');
	var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+reportSqlId;
	var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
	
	//获得计算列
	var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+reportSqlId;
	var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
	for(var i=0;i<extData.length;i++){
		data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
	}
	
	var dimValue = $("#line_dim").combobox('getText');
	var orderValue = $("#line_ord").combobox('getText');
	$("#line_dim").combobox('loadData', data).combobox('setText',dimValue); 
	$("#line_ord").combobox('loadData', data).combobox('setText',orderValue); 
	var kpiTrs = $("#line_tb2>tbody>tr");
	$.each(kpiTrs,function(index,item){
		$ser = $(item).find(":text.line_ser").combobox();
		var kpiText = $ser.combobox('getText');
		$ser.combobox('loadData', data).combobox('setText',kpiText); 
	});
	
	if(action=="edit"){
		if(lineCaculateColumn.getColumnOldName()==$("#line_dim").combobox("getText")){
			$("#line_dim").combobox("select",lineCaculateColumn.currentEditColumnObj.id);
		}
		if(lineCaculateColumn.getColumnOldName()==$("#line_ord").combobox("getText")){
			$("#line_ord").combobox("select",lineCaculateColumn.currentEditColumnObj.id);
		}
		$("#line_tb2 tr:gt(0)").each(function(index,item){
			if(lineCaculateColumn.getColumnOldName()==$(this).find(":text.line_ser").combobox("getText")){
				$(this).find(":text.line_ser").combobox("select",lineCaculateColumn.currentEditColumnObj.id);
			}
		});
	}else if(action=="remove"){
		var componentId = StoreData.curComponentId;
		var containerId = StoreData.curContainerId;
		
		if(lineCaculateColumn.currentEditColumnObj.name==$("#line_dim").combobox("getText")){
			var info={dimension:"",isextcolumn:"true"};
			cn.com.easy.xbuilder.service.component.LineService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#line_dim").combobox("setText",'请选择');
			});
		}
		if(lineCaculateColumn.currentEditColumnObj.name==$("#line_ord").combobox("getText")){
			var sortType = $("#line_sorttype").combobox("getValue");
			var kpiType = $("#line_kpitype").combobox("getValue");
			var info={ord:"",isextcolumn:"true",kpiType:kpiType,sortType:sortType};
			cn.com.easy.xbuilder.service.component.LineService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#line_ord").combobox("setText",'请选择');
			});
		}
		$("#line_tb2 tr:gt(0)").each(function(index,item){
			if(lineCaculateColumn.currentEditColumnObj.name==$(this).find(":text.line_ser").combobox("getText")){
				var info={extcolumnid:lineCaculateColumn.currentEditColumnObj.id};
				cn.com.easy.xbuilder.service.component.LineService.removeExtKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
					$(item).remove();
					if($("#line_tb2>tbody>tr").size()==0){
						line_appendKpiRow();
					}
				});
				return false;
			}
		});
	}
	
}