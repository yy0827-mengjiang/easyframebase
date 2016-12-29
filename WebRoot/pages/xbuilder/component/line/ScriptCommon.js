
/**
 * 获取y轴下拉列表数据
 * @returns {Array}
 */
function line_getQuote(){
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var data = [];
	var idx = $("#line_tb1 tr").length;
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
function line_fun_SetTitle(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var title = $("#line_title").val();
	if(typeof(title)!="undefined"){
		info.title=title;
		info.showTitle = $("#showTitle").attr("checked")=="checked"?"1":"0";
		cn.com.easy.xbuilder.service.component.LineService.setTitle(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
			//synTitleToOther(containerId,componentId,title);
		});
	}
		
}

/**
 * 设置Y轴刻度信息
 */
function line_fun_SetScale(){
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var info={};
	var yaxis = [];
	$("#line_tb1 tr:gt(0)").each(function(i){
		var cols = {};
		var title = $(this).find(":text[name='line_title']").val();
		var color = $(this).find(":text.colorpk").spectrum("get").toHexString();
		var unit = $(this).find(":text[name='line_unit']").val();
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
	cn.com.easy.xbuilder.service.component.LineService.setYaxis(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
}

/**
 * 设置组件指标颜色列表
 * @param colors
 */
function line_setColors(colors){
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var info = {"colors":colors};
	cn.com.easy.xbuilder.service.component.LineService.setColors(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){}); 
}

/**
 * 设置图例
 * @param position
 */
function line_setLegend(position){
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var info = {position:position,isShow:position=="none"?"false":"true"};
	cn.com.easy.xbuilder.service.component.LineService.setLegend(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
}