function scatter_showColumn(obj){
	if($("#scatter_data").attr("oldValue")!=obj.id){
		if(obj.attributes.datatype=="2"){//数据集为map类型
			$.messager.alert("系统提示","散点图不能使用map类型数据集","error");
			$("#scatter_data").combobox("setValue",$("#scatter_data").attr("oldValue"));
		}else{
			$("#scatter_data").attr("oldValue",obj.id);
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
			$("#scatter_dim").combobox('setValue', '请选择').combobox('loadData', data); 
			$("#scatter_min_dim").combobox('setValue', '请选择').combobox('loadData', data); 
			$("#scatter_kpiX").combobox('setValue', '请选择').combobox('loadData', data); 
			$("#scatter_kpiY").combobox('setValue', '请选择').combobox('loadData', data);
			$("#scatter_kpiX_title").val("");
			$("#scatter_kpiY_title").val("");
			$("#scatter_kpiX_unit").val("");
			$("#scatter_kpiY_unit").val("");
			
			if(typeof(obj.id)!="undefined"&&obj.id!="请选择"){
				info.sqlId=(obj.id).substring(1);
				cn.com.easy.xbuilder.service.component.ScatterService.setDataSourceId(LayOutUtil.data.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
			}
		}
	}
}

/**
 * 设置维度列
 */
function scatter_fun_SetDim(record){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var dimension = $("#scatter_dim").combobox("getText");
	var isextcolumn = record.isextcolumn==true?"true":"false";
	$("#scatter_dim").attr("isextcolumn",isextcolumn);
	if(typeof(dimension)!="undefined"&&dimension!="请选择"){
		if(dimension==$("#scatter_kpiX").combobox("getText")||dimension==$("#scatter_kpiY").combobox("getText")){
			$.messager.alert("散点图","维度列不能与指标列相同！","info");
			$("#scatter_dim").combobox("setText","请选择");
			dimension="";
		}
		info.dimension=isextcolumn=="true"?$("#scatter_dim").combobox("getValue"):$("#scatter_dim").combobox("getText");
		info.isextcolumn=isextcolumn;
		cn.com.easy.xbuilder.service.component.ScatterService.setDimField(LayOutUtil.data.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	} 
}

/**
 * 设置维度列
 */
function scatter_fun_SetMinDim(record){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var dimension = $("#scatter_min_dim").combobox("getText");
	if(typeof(dimension)!="undefined"&&dimension!="请选择"){
		if(dimension==$("#scatter_kpiX").combobox("getText")||dimension==$("#scatter_kpiY").combobox("getText")){
			$.messager.alert("散点图","最小粒度列不能与指标列相同！","info");
			$("#scatter_min_dim").combobox("setText","请选择");
			dimension="";
		}
		var isextcolumn = record.isextcolumn==true?"true":"false";
		$("#scatter_min_dim").attr("isextcolumn",isextcolumn);
		info.minDim=isextcolumn=="true"?$("#scatter_min_dim").combobox("getValue"):$("#scatter_min_dim").combobox("getText");
		info.isextcolumn=isextcolumn;
		cn.com.easy.xbuilder.service.component.ScatterService.setMinDimField(LayOutUtil.data.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	} 
}

function scatter_fun_SelectKpi(obj){
	var id = $(this).attr("id");
	if($("#scatter_kpiX").combobox("getText")==$("#scatter_kpiY").combobox("getText")){
		$.messager.alert("散点图","X轴指标和Y轴指标不能重复！","info");
		$("#"+id).combobox("setText","请选择");
		$("#"+id+"_title").val("");
	}else if($("#"+id).combobox("getText")==$("#scatter_dim").combobox("getText")){
		$.messager.alert("散点图","指标列和维度列不能相同！","info");
		$("#"+id).combobox("setText","请选择");
		$("#"+id+"_title").val("");
	}else{
		$("#"+id+"_title").val($("#"+id).combobox("getText"));
	}
	$("#"+id).attr("isextcolumn",obj.isextcolumn==true?"true":"false");
	scatter_fun_SetKpi();
}

/**
 * 设置指标
 */
function scatter_fun_SetKpi(){
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var kpiList=[{field:$("#scatter_kpiX").attr("isextcolumn")=="true"?"":$("#scatter_kpiX").combobox("getText"),
			    kpiId:"",
				title:$("#scatter_kpiX_title").val(),
				unit:$("#scatter_kpiX_unit").val(),
				axisType:'X',
				extcolumnid:$("#scatter_kpiX").attr("isextcolumn")=="true"?$("#scatter_kpiX").combobox("getValue"):""
			},{field:$("#scatter_kpiY").attr("isextcolumn")=="true"?"":$("#scatter_kpiY").combobox("getText"),
				kpiId:"",
				title:$("#scatter_kpiY_title").val(),
				unit:$("#scatter_kpiY_unit").val(),
				axisType:'Y',
				extcolumnid:$("#scatter_kpiY").attr("isextcolumn")=="true"?$("#scatter_kpiY").combobox("getValue"):""
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
			
			var dateJson=$.ajax({url: appBase+"/getAllDataSourceJsonX.e?report_id="+LayOutUtil.data.xid,type:"POST",cache: false,async: false}).responseText;
			var data=[];
			
			if(dateJson!=null&&dateJson!=""){
				data = $.evalJSON(dateJson);
				$("#scatter_data").combobox('loadData', data); 
			}
			var sql_id = jsonObj.datasourceid;
			if(typeof(sql_id)!="undefined"&&sql_id!=null){
				sql_id='B'+sql_id;
				$("#scatter_data").combobox("setValue",sql_id);
				$("#scatter_data").attr("oldValue",sql_id);
				var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+LayOutUtil.data.xid+"&report_sql_id="+sql_id;
				var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
				var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+sql_id;
				var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
				for(var i=0;i<extData.length;i++){
					data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
				}
				$("#scatter_dim").combobox('loadData', data).combobox('setValue', '请选择'); 
				$("#scatter_min_dim").combobox('loadData', data).combobox('setValue', '请选择'); 
				$("#scatter_kpiX").combobox('loadData', data).combobox('setValue', '请选择'); 
				$("#scatter_kpiY").combobox('loadData', data).combobox('setValue', '请选择'); 
			}
			if(jsonObj.xaxis!=null&&jsonObj.xaxis!=undefined){
				var dimension = jsonObj.xaxis.dimfield==""?jsonObj.xaxis.dimExtField:jsonObj.xaxis.dimfield;
				var minDim = jsonObj.xaxis.scatterDimField==""?jsonObj.xaxis.scatterDimExtField:jsonObj.xaxis.scatterDimField;
				if(jsonObj.xaxis.dimExtField!=""){
			   		 $("#scatter_dim").combobox("setValue",dimension);
			   		 $("#scatter_dim").attr("isextcolumn","true");
			    }else{
			   		 $("#scatter_dim").combobox("setText",dimension);
			   		 $("#scatter_dim").attr("isextcolumn","false");
			    }
				
				if(jsonObj.xaxis.scatterDimExtField!=""){
			   		 $("#scatter_min_dim").combobox("setValue",minDim);
			   		 $("#scatter_min_dim").attr("isextcolumn","true");
			    }else{
			   		 $("#scatter_min_dim").combobox("setText",minDim);
			   		 $("#scatter_min_dim").attr("isextcolumn","false");
			    }
			}
		

			/*指标设置*/
			var kpiList=jsonObj.kpiList;
			if(typeof(kpiList)!="undefined"&&kpiList!=null){
				for(var i=0;i<kpiList.length;i++){
					if(kpiList[i].yaxisid=="X"){
						if(kpiList[i].extcolumnid!=""){
							$("#scatter_kpiX").combobox("setValue",kpiList[i].extcolumnid);
							$("#scatter_kpiX").attr("isextcolumn","true"); 
						}else{
							$("#scatter_kpiX").combobox("setText",kpiList[i].field);
							$("#scatter_kpiX").attr("isextcolumn","false"); 
					    }
					}else if(kpiList[i].yaxisid=="Y"){
						if(kpiList[i].extcolumnid!=""){
							$("#scatter_kpiY").combobox("setValue",kpiList[i].extcolumnid);
							$("#scatter_kpiY").attr("isextcolumn","true"); 
						}else{
							$("#scatter_kpiY").combobox("setText",kpiList[i].field);
							$("#scatter_kpiY").attr("isextcolumn","false"); 
					    }
					} 
				}
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
		}else{
		    
		}
	});
	
}


/**
 * 更新数据集UI
 */
function scatterUpdataDatasetUI(action){
	var reportSqlId = $("#scatter_data").combobox('getValue');
	var path = appBase+"/getOneDataSourceColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+reportSqlId;
	var data = $.evalJSON($.ajax({url: path,type: "GET",cache: false,async: false}).responseText);
	
	//获得计算列
	var extPath = appBase+"/getOneDataSourceExtColumnsJsonX.e?report_id="+StoreData.xid+"&report_sql_id="+reportSqlId;
	var extData = $.evalJSON($.ajax({url: extPath,type: "GET",cache: false,async: false}).responseText);
	for(var i=0;i<extData.length;i++){
		data.push({id:extData[i].id,text:extData[i].name,isextcolumn:true});
	}
	
	var dimValue = $("#scatter_dim").combobox('getText');
	$("#scatter_dim").combobox('loadData', data).combobox('setText',dimValue); 
	
    var minDimValue = $("#scatter_min_dim").combobox('getText');
	$("#scatter_min_dim").combobox('loadData', data).combobox('setText',minDimValue); 
	
	var kpiXValue = $("#scatter_kpiX").combobox('getText');
	$("#scatter_kpiX").combobox('loadData', data).combobox('setText',kpiXValue); 
	
	var kpiYValue = $("#scatter_kpiY").combobox('getText');
	$("#scatter_kpiY").combobox('loadData', data).combobox('setText',kpiYValue); 
	
	
	if(action=="edit"){
		if(scatterCaculateColumn.getColumnOldName()==$("#scatter_dim").combobox("getText")){
			$("#scatter_dim").combobox("select",scatterCaculateColumn.currentEditColumnObj.id);
		}
		if(scatterCaculateColumn.getColumnOldName()==$("#scatter_min_dim").combobox("getText")){
			$("#scatter_min_dim").combobox("select",scatterCaculateColumn.currentEditColumnObj.id);
		}
		if(scatterCaculateColumn.getColumnOldName()==$("#scatter_kpiX").combobox("getText")){
			$("#scatter_kpiX").combobox("select",scatterCaculateColumn.currentEditColumnObj.id);
		}
		if(scatterCaculateColumn.getColumnOldName()==$("#scatter_kpiY").combobox("getText")){
			$("#scatter_kpiY").combobox("select",scatterCaculateColumn.currentEditColumnObj.id);
		}
	}else if(action=="remove"){
		var componentId = StoreData.curComponentId;
		var containerId = StoreData.curContainerId;
		
		if(scatterCaculateColumn.currentEditColumnObj.name==$("#scatter_dim").combobox("getText")){
			var info={dimension:"",isextcolumn:"true"};
			cn.com.easy.xbuilder.service.component.ScatterService.setDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#scatter_dim").combobox("setText",'请选择');
			});
		}
		if(scatterCaculateColumn.currentEditColumnObj.name==$("#scatter_min_dim").combobox("getText")){
		    var info = {minDim:"",isextcolumn:"true"}
			cn.com.easy.xbuilder.service.component.ScatterService.setMinDimField(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
				$("#scatter_min_dim").combobox("setText",'请选择');
			});
		}
					
		if(scatterCaculateColumn.currentEditColumnObj.name==$("#scatter_kpiX").combobox("getText")){
			var info={extcolumnid:scatterCaculateColumn.currentEditColumnObj.id,type:'X'};
				cn.com.easy.xbuilder.service.component.ScatterService.removeExtKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
					$("#scatter_kpiX").combobox("setText",'请选择');
					$("#scatter_kpiX_title").val("");
				});
		}
		if(scatterCaculateColumn.currentEditColumnObj.name==$("#scatter_kpiY").combobox("getText")){
			var info={extcolumnid:scatterCaculateColumn.currentEditColumnObj.id,type:'Y'};
				cn.com.easy.xbuilder.service.component.ScatterService.removeExtKpi(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
					$("#scatter_kpiY").combobox("setText",'请选择');
					$("#scatter_kpiY_title").val("");
			});
		}
	}
	
}

