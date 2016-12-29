var bar_oldValue;
function bar_onShowPanel(){
	bar_oldValue = $(this).combobox("getText");
}

function bar_saveOrder(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var bar_ord = $("#bar_ord").attr("isextcolumn")=="true"?$("#bar_ord").combobox("getValue"):$("#bar_ord").combobox("getText");
	var sortType = $("#bar_sorttype").combobox("getValue");
	var kpiType = $("#bar_kpitype").combobox("getValue");
	if(typeof(bar_ord)!="undefined"&&bar_ord!="请选择"){
		info.ord=bar_ord;
		info.kpiType = kpiType;
		info.sortType = sortType;
	    info.isextcolumn=$("#bar_ord").attr("isextcolumn");;
		cn.com.easy.xbuilder.service.component.BarService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	}
}

function bar_showColumn(obj){
	if($("#bar_data").attr("oldValue")!=obj.id){
		if(obj.attributes.datatype=="2"){//数据集为map类型
			$.messager.alert("系统提示","条形图不能使用map类型数据集","error");
			$("#bar_data").combobox("setValue",$("#bar_data").attr("oldValue"));
		}else{
			$("#bar_data").attr("oldValue",obj.id);
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
			$("#bar_dim").combobox('setValue', '请选择').combobox('loadData', data); 
			$("#bar_ord").combobox('setValue', '请选择').combobox('loadData', data); 
			$("#bar_tb2 tr:gt(0)").remove();
			var $row = bar_appendKpiRow();
			if(typeof(obj.id)!="undefined"&&obj.id!="请选择"){
				info.sqlId=(obj.id).substring(1);
				cn.com.easy.xbuilder.service.component.BarService.setDataSourceId(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
			}
		}
	}
}

/**
 * 校验指标行
 * @returns {String}
 */
function validBarKpiRow(){
	var errMessage = "";
	var kpiMap = new Object();
	$("#bar_tb2 tr:gt(0)").each(function(index){
		var ser = $(this).find(":text.bar_ser").combobox("getText");
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
 * 选择指标列
 */
function bar_selectSer(obj){
	var $ser = $(this);
	var ser_value = $ser.combobox("getText");
	var curSer = $("#bar_tb2 tr[class='kpi_select_row']").eq(0).find(":text.bar_ser");
	curSer.attr("serName",$ser.parent().parent().find(":text[name='bar_sername']").val());
	$ser.parent().parent().find(":text[name='bar_sername']").val(ser_value);
	curSer.attr("isextcolumn",obj.isextcolumn==true?"true":"false");
	bar_fun_SetKpi();
}

/**
 * 添加指标行
 */
function bar_appendKpiRow(){
	var errMsg = validBarKpiRow();
	if(errMsg!=""){
		$.messager.alert("条形图","添加失败，请先处理以下错误：<br/>"+errMsg,"info");
		return;
	}
	$("#bar_tb2").append($("#kpiRowHtml").find("tr").eq(0)[0].outerHTML);
	var $row = $("#bar_tb2 tr:last-child");
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
	var $ser = $row.find(":text.bar_ser").combobox();
	var $ref = $row.find(":text.bar_ref").combobox();
	var ser_data=[];
	try{ 
		ser_data = $("#bar_dim").combobox("getData");
	} 
	catch (e){ 
		ser_data = [];
	} 
	$ser.combobox('setValue', '请选择').combobox('loadData', ser_data); 
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
	return $row; 
}

/**
 * 设置排序列
 */
function bar_fun_SetOrd(record){
	var bar_ord = $("#bar_ord").combobox("getText");
	//判断选择的排序列是否为指标，如果为指标，设置排序列类型为kpi
	$("#bar_tb2 tr:gt(0)").each(function(index,item){
		var bar_ser = $(this).find(":text.bar_ser").combobox("getText");
		if(bar_ser==bar_ord){
			$("#bar_kpitype").combobox("setValue","kpi");
		}
	});
	//判断选择的排序列是否为维度，如果为指标，设置排序列类型为维度
	if($("#bar_dim").combobox("getText")==bar_ord){
		$("#bar_kpitype").combobox("setValue","dim");
	}
	$("#bar_ord").attr("isextcolumn",record.isextcolumn);
	bar_saveOrder();
}

/**
 * 设置维度列
 */
function bar_fun_SetDim(record){
	var dimension = $("#bar_dim").combobox("getText");
	var isextcolumn = record.isextcolumn==true?"true":"false";
	$("#bar_dim").attr("isextcolumn",isextcolumn);
	var isSameToKpi = false;
	$("#bar_tb2 tr:gt(0)").each(function(index,item){
		var bar_ser = $(this).find(":text.bar_ser").combobox("getText");
		if(bar_ser==dimension){
			isSameToKpi = true;
			return false;
		}
	});
	if(isSameToKpi){
		$.messager.alert("条形图","列“"+dimension+"”已被选择为指标列，不能再选择为维度列！","info");
		$("#bar_dim").combobox("setText",bar_oldValue);
		return;
	}
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	dimension = isextcolumn=="true"?$("#bar_dim").combobox("getValue"):$("#bar_dim").combobox("getText");
	if(typeof(dimension)!="undefined"&&dimension!="请选择"){
		info.dimension=dimension;
		info.isextcolumn=isextcolumn;
		cn.com.easy.xbuilder.service.component.BarService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
			//如果设置的维度列和排序列相同，修改排序列为维度类型并保存到xml
			if($("#bar_ord").combobox("getText")==dimension){
				$("#bar_kpitype").combobox("setValue","dim");
				bar_saveOrder();
			}
		});
	} 
}


/**
 * 设置指标列
 */
function bar_fun_SetKpi(){
	var curSer = $("#bar_tb2 tr[class='kpi_select_row']").eq(0).find(":text.bar_ser");//当前选择的行
	var kpiMap = new Object();
	var dimension = $("#bar_dim").combobox("getText");
	//将维度列也放到kpiMap中检查，因为指标列不能和维度列重复
	if(dimension!=""&&dimension!=undefined){
		kpiMap[dimension]=dimension;
	}
	var hasRepeatKpi = false;
	$("#bar_tb2 tr:gt(0)").each(function(index,item){
		var bar_ser = $(this).find(":text.bar_ser").combobox("getText");
		if(kpiMap[bar_ser]==undefined){
			kpiMap[bar_ser]=bar_ser;
		}else{
			hasRepeatKpi = true;
			if(dimension == bar_ser){
				$.messager.alert("条形图","列“"+bar_ser+"”已被选择为维度列，不能再选择为指标列！","info");
			}else{
				$.messager.alert("条形图","指标"+bar_ser+"已添加，不能重复添加！","info");
			}
			return false;
		}
	});
	if(hasRepeatKpi){
		curSer.combobox("setText",bar_oldValue);//恢复原来的指标列
		curSer.parent().next("td").find("input:eq(0)").val(curSer.attr("serName"));//恢复原来的名字
		return;
	}
	bar_fun_SetScale();//初始化刻度设置
	var errMsg="";
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var info={};
	var serfd = [];
	var changeOrder=false;
	$("#bar_tb2 tr:gt(0)").each(function(i){
		var cols = {};
		var ser = $(this).find(":text.bar_ser").combobox("getText");
		var ref = $(this).find(":text.bar_ref").combobox("getValue");
		var color = $(this).find(":text.colorpk").spectrum("get").toHexString();
		var ser_name = $(this).find(":text[name='bar_sername']").val();
		//如果设置的指标列和排序列相同，修改排序列为指标类型并保存到xml
		if($("#bar_ord").combobox("getText")==ser){
			$("#bar_kpitype").combobox("setValue","kpi");
			changeOrder = true;
		}
		if(typeof(ser)!="undefined"&&ser!="请选择"&&ser!=""){
			cols.isextcolumn=$(this).find(":text.bar_ser").attr("isextcolumn");
			cols.ser = cols.isextcolumn=="true"?$(this).find(":text.bar_ser").combobox("getValue"):$(this).find(":text.bar_ser").combobox("getText");
			if(typeof(ref)!="undefined"&&ref!=""){
				cols.ref = ref;
			}
			if(typeof(color)!="undefined"&&color!=""){
				cols.color = color;
			}
			cols.type = "bar";
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
	cn.com.easy.xbuilder.service.component.BarService.setKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
		if(changeOrder){
			bar_saveOrder();
		}
	});
}

/**
 * 编辑还原
 */
function bar_fun_edit(containerId,componentId){
	/*还原*/
	cn.com.easy.xbuilder.service.component.BarService.getComponentJsonData(StoreData.xid,containerId,componentId,$.toJSON({}),function(data,exception){
		var jsonObj=$.parseJSON(data);
		if(jsonObj!=null&&jsonObj!=undefined){
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
			/*设置数据集、维度列、排序列*/
			var dateJson=$.ajax({url: appBase+"/getAllDataSourceJsonX.e?report_id="+StoreData.xid,type:"POST",cache: false,async: false}).responseText;
			var data=[];
			if(dateJson!=null&&dateJson!=""){
				data = $.evalJSON(dateJson);
				$("#bar_data").combobox('loadData', data); 
			}
			var sql_id = jsonObj.datasourceid;
			var columnData=[];
			if(typeof(sql_id)!="undefined"&&sql_id!=null){
				sql_id='B'+sql_id;
				$("#bar_data").combobox("setValue",sql_id);
				$("#bar_data").attr("oldValue",sql_id);
				var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+sql_id;
				columnData = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
				var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+sql_id;
				var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
				for(var i=0;i<extData.length;i++){
					columnData.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
				}
				$("#bar_dim").combobox('loadData', columnData).combobox('setText', '请选择');
				$("#bar_ord").combobox('loadData', columnData).combobox('setText', '请选择'); 
			}
			if(jsonObj.xaxis!=null&&jsonObj.xaxis!=undefined){
				var dimension = jsonObj.xaxis.dimfield==""?jsonObj.xaxis.dimExtField:jsonObj.xaxis.dimfield;
				var ord = jsonObj.xaxis.sortfield==""?jsonObj.xaxis.sortExtField:jsonObj.xaxis.sortfield;
				var kpiType = jsonObj.xaxis.sortkpitype;
				var sortType = jsonObj.xaxis.sortType;
				if(jsonObj.xaxis.dimExtField!=""){
			   		 $("#bar_dim").combobox("setValue",dimension);
			   		 $("#bar_dim").attr("isextcolumn","true");
			    }else{
			   		 $("#bar_dim").combobox("setText",dimension);
			   		 $("#bar_dim").attr("isextcolumn","false");
			    }
				if(jsonObj.xaxis.sortExtField!=""){
			   		 $("#bar_ord").combobox("setValue",ord);
			   		 $("#bar_ord").attr("isextcolumn","true");
			    }else{
			   		 $("#bar_ord").combobox("setText",ord);
			   		 $("#bar_ord").attr("isextcolumn","false");
			    }
				if(typeof(kpiType)!="undefined"&&kpiType!=""){
					$("#bar_kpitype").combobox("setValue",kpiType); 
				}
				if(typeof(sortType)!="undefined"&&sortType!=""){
					$("#bar_sorttype").combobox("setValue",sortType); 
				}
			}
			
			/*刻度设置*/
			var yaxisList=jsonObj.yaxisList;
			if(typeof(yaxisList)!="undefined"&&yaxisList!=null){
				for(var i=0;i<yaxisList.length;i++){
					var $row =$("#bar_tb1").find("tr").eq(i+1);
					if(yaxisList[i].title) $row.find(":text[name='bar_title']").val(yaxisList[i].title);
					if(yaxisList[i].color) $row.find(":text.colorpk").spectrum("set",yaxisList[i].color);
					if(yaxisList[i].unit) $row.find(":text[name='bar_unit']").val(yaxisList[i].unit);
				}
			} 
			
			/*指标设置*/
			var kpiList=jsonObj.kpiList;
			if(typeof(kpiList)!="undefined"&&kpiList!=null){
				$("#bar_tb2 tr:gt(0)").remove();
				for(var i=0;i<kpiList.length;i++){
					var $row = bar_appendKpiRow();
					if(kpiList[i].extcolumnid!=""){
				   		$row.find(":text.bar_ser").combobox("setValue",kpiList[i].extcolumnid);
						$row.find(":text.bar_ser").attr("isextcolumn","true");
					}else{
					   	$row.find(":text.bar_ser").combobox("setText",kpiList[i].field);
						$row.find(":text.bar_ser").attr("isextcolumn","false");
				    }
					if(kpiList[i].name) $row.find(":text[name='bar_sername']").val(kpiList[i].name);
					if(kpiList[i].color) $row.find(":text.colorpk").spectrum("set",kpiList[i].color);
					if(kpiList[i].yaxisid) $row.find(":text.bar_ref").combobox("setValue",kpiList[i].yaxisid);
				}
			}else{
				$("#bar_tb2 tr:gt(0)").remove();
				var $row = bar_appendKpiRow();
				$row.find(":text.bar_ser").combobox("loadData",columnData);
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
function bar_removeKpiRow(obj){
	var obj = $(".kpi_select_row").eq(0);
	if(obj[0]==undefined){
		$.messager.alert("条形图","请选择要删除的指标!","info");
	}else if(obj[0]!=undefined&&$("#bar_tb2 tr:gt(0)").length>1){
		$(obj).remove();
		bar_fun_SetKpi();
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
	var reportSqlId = $("#bar_data").combobox('getValue');
	var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+reportSqlId;
	var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
	
	//获得计算列
	var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+reportSqlId;
	var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
	for(var i=0;i<extData.length;i++){
		data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
	}
	
	var dimValue = $("#bar_dim").combobox('getText');
	var orderValue = $("#bar_ord").combobox('getText');
	$("#bar_dim").combobox('loadData', data).combobox('setText',dimValue); 
	$("#bar_ord").combobox('loadData', data).combobox('setText',orderValue); 
	var kpiTrs = $("#bar_tb2>tbody>tr");
	$.each(kpiTrs,function(index,item){
		$ser = $(item).find(":text.bar_ser").combobox();
		var kpiText = $ser.combobox('getText');
		$ser.combobox('loadData', data).combobox('setText',kpiText); 
	});
	
	if(action=="edit"){
		if(barCaculateColumn.getColumnOldName()==$("#bar_dim").combobox("getText")){
			$("#bar_dim").combobox("select",barCaculateColumn.currentEditColumnObj.id);
		}
		if(barCaculateColumn.getColumnOldName()==$("#bar_ord").combobox("getText")){
			$("#bar_ord").combobox("select",barCaculateColumn.currentEditColumnObj.id);
		}
		$("#bar_tb2 tr:gt(0)").each(function(index,item){
			if(barCaculateColumn.getColumnOldName()==$(this).find(":text.bar_ser").combobox("getText")){
				$(this).find(":text.bar_ser").combobox("select",barCaculateColumn.currentEditColumnObj.id);
			}
		});
	}else if(action=="remove"){
		var componentId = StoreData.curComponentId;
		var containerId = StoreData.curContainerId;
		
		if(barCaculateColumn.currentEditColumnObj.name==$("#bar_dim").combobox("getText")){
			var info={dimension:"",isextcolumn:"true"};
			cn.com.easy.xbuilder.service.component.BarService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#bar_dim").combobox("setText",'请选择');
			});
		}
		if(barCaculateColumn.currentEditColumnObj.name==$("#bar_ord").combobox("getText")){
			var sortType = $("#bar_sorttype").combobox("getValue");
			var kpiType = $("#bar_kpitype").combobox("getValue");
			var info={ord:"",isextcolumn:"true",kpiType:kpiType,sortType:sortType};
			cn.com.easy.xbuilder.service.component.BarService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#bar_ord").combobox("setText",'请选择');
			});
		}
		$("#bar_tb2 tr:gt(0)").each(function(index,item){
			if(barCaculateColumn.currentEditColumnObj.name==$(this).find(":text.bar_ser").combobox("getText")){
				var info={extcolumnid:barCaculateColumn.currentEditColumnObj.id};
				cn.com.easy.xbuilder.service.component.BarService.removeExtKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
					$(item).remove();
					if($("#bar_tb2>tbody>tr").size()==0){
						bar_appendKpiRow();
					}
				});
				return false;
			}
		});
	}
	
}