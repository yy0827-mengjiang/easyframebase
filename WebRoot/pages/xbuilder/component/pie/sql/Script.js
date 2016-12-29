var pie_oldValue;
function pie_onShowPanel(){
	pie_oldValue = $(this).combobox("getText");
}

function pie_saveOrder(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var pie_ord = $("#pie_ord").attr("isextcolumn")=="true"?$("#pie_ord").combobox("getValue"):$("#pie_ord").combobox("getText");
	var sortType = $("#pie_sorttype").combobox("getValue");
	var kpiType = $("#pie_kpitype").combobox("getValue");
	if(typeof(pie_ord)!="undefined"&&pie_ord!="请选择"){
		info.ord=pie_ord;
		info.kpiType = kpiType;
		info.sortType = sortType;
		info.isextcolumn=$("#pie_ord").attr("isextcolumn");
		cn.com.easy.xbuilder.service.component.PieService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	}
}

function pie_showColumn(obj){
	if($("#pie_data").attr("oldValue")!=obj.id){
		if(obj.attributes.datatype=="2"){//数据集为map类型
			$.messager.alert("系统提示","饼图不能使用map类型数据集","error");
			$("#pie_data").combobox("setValue",$("#pie_data").attr("oldValue"));
		}else{
			$("#pie_data").attr("oldValue",obj.id);
			var info={};
			var componentId = StoreData.curComponentId;
			var containerId = StoreData.curContainerId;
			var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+LayOutUtil.data.xid+"&report_sql_id="+obj.id;
			var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);

			//获得计算列
			var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+obj.id;
			var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
			for(var i=0;i<extData.length;i++){
				data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
			}
			
			$("#pie_dim").combobox('setValue', '请选择').combobox('loadData', data); 
			$("#pie_ord").combobox('setValue', '请选择').combobox('loadData', data); 
			$("#pie_ser").combobox('setValue', '请选择').combobox('loadData', data);
			$("#pie_kpi_name").val("")
			
			if(typeof(obj.id)!="undefined"&&obj.id!="请选择"){
				info.sqlId=(obj.id).substring(1);
				cn.com.easy.xbuilder.service.component.PieService.setDataSourceId(LayOutUtil.data.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
			}
		}
	}
}
 
function pie_fun_SetOrd(record){
	var pie_ord = $("#pie_ord").combobox("getText");
	//判断选择的排序列是否为指标，如果为指标，设置排序列类型为kpi
	var pie_ser = $("#pie_ser").combobox("getText");
	if(pie_ser==pie_ord){
		$("#pie_kpitype").combobox("setValue","kpi");
	}
	//判断选择的排序列是否为维度，如果为指标，设置排序列类型为维度
	if($("#pie_dim").combobox("getText")==pie_ord){
		$("#pie_kpitype").combobox("setValue","dim");
	}
	$("#pie_ord").attr("isextcolumn",record.isextcolumn);
	pie_saveOrder();
}

function pie_fun_SetDim(record){
	var dimension = $("#pie_dim").combobox("getText");
	var pie_ser = $("#pie_ser").combobox("getText");
	if(pie_ser==dimension){
		$.messager.alert("饼（环）图","列“"+dimension+"”已被选择为指标列，不能再选择为维度列！","info");
		$("#pie_dim").combobox("setText",pie_oldValue);
		return;
	}
	var isextcolumn = record.isextcolumn==true?"true":"false";
	$("#pie_dim").attr("isextcolumn",isextcolumn);
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	dimension = isextcolumn=="true"?$("#pie_dim").combobox("getValue"):$("#pie_dim").combobox("getText");
	if(typeof(dimension)!="undefined"&&dimension!="请选择"){
		info.dimension=dimension;
		info.isextcolumn=isextcolumn;
		cn.com.easy.xbuilder.service.component.PieService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
			//如果设置的维度列和排序列相同，修改排序列为维度类型并保存到xml
			if($("#pie_ord").combobox("getText")==dimension){
				$("#pie_kpitype").combobox("setValue","dim");
				pie_saveOrder();
			}
		});
	} 
}

function pie_fun_setSer(obj){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var ser = $("#pie_ser").combobox("getText");
	$("#pie_ser").attr("isextcolumn",obj.isextcolumn==true?"true":"false");
	if(typeof(ser)!="undefined"&&ser!="请选择"){
		if(ser==$("#pie_dim").combobox("getText")){
			$.messager.alert("饼（环）图","指标列不能与维度列相同！","info");
			$("#pie_ser").combobox("setText",pie_oldValue);
			return;
		}
		info.ser = obj.isextcolumn==true?$("#pie_ser").combobox("getValue"):$("#pie_ser").combobox("getText");
		info.isextcolumn=$("#pie_ser").attr("isextcolumn");
		cn.com.easy.xbuilder.service.component.PieService.setKpiField(LayOutUtil.data.xid,containerId,componentId,$.toJSON(info),function(data,exception){
			$("#pie_kpi_name").val(ser);
			pie_fun_SetKpiName();
			//如果设置的指标列和排序列相同，修改排序列为指标类型并保存到xml
			if($("#pie_ord").combobox("getText")==ser){
				$("#pie_kpitype").combobox("setValue","kpi");
				pie_saveOrder();
			}
		});
	} 
	
}


function pie_fun_edit(containerId,componentId){	
	cn.com.easy.xbuilder.service.component.PieService.getComponentJsonData(LayOutUtil.data.xid,containerId,componentId,$.toJSON({}),function(data,exception){
		var jsonObj=$.parseJSON(data);
		if(jsonObj!=null&&jsonObj!=undefined){
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
			/*设置数据集、维度列、排序列*/
			var dateJson=$.ajax({url: appBase+"/getAllDataSourceJsonX.e?report_id="+LayOutUtil.data.xid,type:"POST",cache: false,async: false}).responseText;
			var data=[];
			if(dateJson!=null&&dateJson!=""){
				data = $.evalJSON(dateJson);
				$("#pie_data").combobox('loadData', data); 
			}
			var sql_id = jsonObj.datasourceid;
			if(typeof(sql_id)!="undefined"&&sql_id!=null){
				sql_id='B'+sql_id;
				$("#pie_data").combobox("setValue",sql_id);
				$("#pie_data").attr("oldValue",sql_id);
				var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+LayOutUtil.data.xid+"&report_sql_id="+sql_id;
				var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
				var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+sql_id;
				var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
				for(var i=0;i<extData.length;i++){
					data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
				}
				$("#pie_dim").combobox('loadData', data).combobox('setText', '请选择') 
				$("#pie_ord").combobox('loadData', data).combobox('setText', '请选择'); 
				$("#pie_ser").combobox('loadData', data).combobox('setText', '请选择'); 
			}
			if(jsonObj.xaxis!=null&&jsonObj.xaxis!=undefined){
				var dimension = jsonObj.xaxis.dimfield==""?jsonObj.xaxis.dimExtField:jsonObj.xaxis.dimfield;
				var ord = jsonObj.xaxis.sortfield==""?jsonObj.xaxis.sortExtField:jsonObj.xaxis.sortfield;
				var kpiType = jsonObj.xaxis.sortkpitype;
				var sortType = jsonObj.xaxis.sortType;
				if(jsonObj.xaxis.dimExtField!=""){
			   		 $("#pie_dim").combobox("setValue",dimension);
			   		 $("#pie_dim").attr("isextcolumn","true");
			    }else{
			   		 $("#pie_dim").combobox("setText",dimension);
			   		 $("#pie_dim").attr("isextcolumn","false");
			    }

				if(jsonObj.xaxis.sortExtField!=""){
			   		 $("#pie_ord").combobox("setValue",ord);
			   		 $("#pie_ord").attr("isextcolumn","true");
			    }else{
			   		 $("#pie_ord").combobox("setText",ord);
			   		 $("#pie_ord").attr("isextcolumn","false");
			    }
				
				if(typeof(kpiType)!="undefined"&&kpiType!=""){
					$("#pie_kpitype").combobox("setValue",kpiType); 
				}
				if(typeof(sortType)!="undefined"&&sortType!=""){
					$("#pie_sorttype").combobox("setValue",sortType); 
				}
			}
			
			/*指标列、指标名　设置*/
			$("#pie_kpi_name").val("");
			var kpiList=jsonObj.kpiList;
			if(typeof(kpiList)!="undefined"&&kpiList!=null){
				for(var i=0;i<kpiList.length;i++){
					if(i==0){
						if(kpiList[i].extcolumnid!=""){
					   		$("#pie_ser").combobox("setValue",kpiList[i].extcolumnid);
					   		$("#pie_ser").attr("isextcolumn","true");
						}else{
							$("#pie_ser").combobox("setText",kpiList[i].field);
							$("#pie_ser").attr("isextcolumn","false");
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
 * 更新数据集UI
 */
function pieUpdataDatasetUI(action){
	var reportSqlId = $("#pie_data").combobox('getValue');
	var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+reportSqlId;
	var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
	
	//获得计算列
	var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+reportSqlId;
	var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
	for(var i=0;i<extData.length;i++){
		data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
	}
	var dimValue = $("#pie_dim").combobox('getText');
	var orderValue = $("#pie_ord").combobox('getText');
	var kpiText = $("#pie_ser").combobox('getText');
	$("#pie_dim").combobox('loadData', data).combobox('setText',dimValue); 
	$("#pie_ord").combobox('loadData', data).combobox('setText',orderValue); 
	$("#pie_ser").combobox('loadData', data).combobox('setText',kpiText); 
	
	
	if(action=="edit"){
		if(pieCaculateColumn.getColumnOldName()==$("#pie_dim").combobox("getText")){
			$("#pie_dim").combobox("select",pieCaculateColumn.currentEditColumnObj.id);
		}
		if(pieCaculateColumn.getColumnOldName()==$("#pie_ord").combobox("getText")){
			$("#pie_ord").combobox("select",pieCaculateColumn.currentEditColumnObj.id);
		}
		if(pieCaculateColumn.getColumnOldName()==$("#pie_ser").combobox("getText")){
			$("#pie_ser").combobox("select",pieCaculateColumn.currentEditColumnObj.id);
		}
	}else if(action=="remove"){
		var componentId = StoreData.curComponentId;
		var containerId = StoreData.curContainerId;
		
		if(pieCaculateColumn.currentEditColumnObj.name==$("#pie_dim").combobox("getText")){
			var info={dimension:"",isextcolumn:"true"};
			cn.com.easy.xbuilder.service.component.PieService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#pie_dim").combobox("setText",'请选择');
			});
		}
		if(pieCaculateColumn.currentEditColumnObj.name==$("#pie_ord").combobox("getText")){
			var sortType = $("#pie_sorttype").combobox("getValue");
			var kpiType = $("#pie_kpitype").combobox("getValue");
			var info={ord:"",isextcolumn:"true",kpiType:kpiType,sortType:sortType};
			cn.com.easy.xbuilder.service.component.PieService.setSortField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#pie_ord").combobox("setText",'请选择');
			});
		}
		if(pieCaculateColumn.currentEditColumnObj.name==$("#pie_ser").combobox("getText")){
			var info={extcolumnid:pieCaculateColumn.currentEditColumnObj.id};
			cn.com.easy.xbuilder.service.component.PieService.removeExtKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#pie_ser").combobox("setText",'请选择');
				$("#pie_kpi_name").val("")
			});
		}
	}
	
}