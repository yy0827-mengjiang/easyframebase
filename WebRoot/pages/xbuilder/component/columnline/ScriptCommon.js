
/**
 * 获取y轴下拉列表数据
 * @returns {Array}
 */
function columnline_getQuote(){
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var data = [];
	var idx = $("#columnline_tb1 tr").length;
	for(var i=0;i<idx-1;i++){
		var obj = {};
		obj.id = 'Y'+componentId+i;
		obj.text = i;
		data.push(obj);
	}
	return data;
}



/**
 * 设置组件标题
 */
function columnline_fun_SetTitle(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var title = $("#columnline_title").val();
	if(typeof(title)!="undefined"){
		info.title=title;
		info.showTitle = $("#showTitle").attr("checked")=="checked"?"1":"0";
		cn.com.easy.xbuilder.service.component.ColumnLineService.setTitle(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
			//synTitleToOther(containerId,componentId,title);
		});
	}
		
}

/**
 * 设置是否堆叠显示
 */
function columnline_fun_SetStacking(){
	var ref = "";
	var stacking = $("#stacking").attr("checked")=="checked"?"true":"false";
	var isvalid = true;
	if(stacking=="true"){
		$("#columnline_tb2 tr:gt(0)").each(function(index,item){
			var type = $(this).find(":text.columnline_type").combobox("getValue");
			if(type=="column"){
				if(ref!=""&&$(this).find(":text.columnline_ref").combobox("getValue")!=ref){
					setTimeout(function(){$("#stacking").iCheck('uncheck');},50);
					$.messager.alert("错误信息","柱图参照的Y轴必须统一，否则不能堆叠显示！","info");
					isvalid = false;
					return false;
				}
				ref = $(this).find(":text.columnline_ref").combobox("getValue");
			}
		});
	}
	if(isvalid){
		var info={};
		var componentId = StoreData.curComponentId;
		var containerId = StoreData.curContainerId;
		info.stacking = stacking;
		cn.com.easy.xbuilder.service.component.ColumnLineService.setStacking(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
			//synTitleToOther(containerId,componentId,title);
		});
	}
	
}

/**
 * 设置Y轴刻度信息
 */
function columnline_fun_SetScale(){
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var info={};
	var yaxis = [];
	$("#columnline_tb1 tr:gt(0)").each(function(i){
		var cols = {};
		var title = $(this).find(":text[name='columnline_title']").val();
		var color = $(this).find(":text.colorpk").spectrum("get").toHexString();
		var unit = $(this).find(":text[name='columnline_unit']").val();
			cols.id="Y"+componentId+i;
			if(typeof(unit)!="undefined"&&unit!=""){
				cols.unit = unit;
			}else{
				cols.unit = "";
			}
			if(typeof(title)!="undefined"){
				cols.title = title;
			}else{
				cols.title = "";
			}
			if(typeof(color)!="undefined"){
				cols.color = color;
			}else{
				cols.color = "";
			}
			yaxis.push(cols);
		
	});
	info.yaxis=yaxis;
	cn.com.easy.xbuilder.service.component.ColumnLineService.setYaxis(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
}

/**
 * 设置组件指标颜色列表
 * @param colors
 */
function columnline_setColors(colors){
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var info = {"colors":colors};
	cn.com.easy.xbuilder.service.component.ColumnLineService.setColors(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){}); 
}

/**
 * 设置图例
 * @param position
 */
function columnline_setLegend(position){
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var info = {position:position,isShow:position=="none"?"false":"true"};
	cn.com.easy.xbuilder.service.component.ColumnLineService.setLegend(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
}