function pie_fun_SetKpiName(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var kpiName = $("#pie_kpi_name").val();
	if(typeof(kpiName)!="undefined"){
		info.kpiName=kpiName;
		cn.com.easy.xbuilder.service.component.PieService.setKpiName(LayOutUtil.data.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	} 
	
}
function pie_fun_SetUnit(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var unit = $("#pie_unit").val();
	info.unit=unit;
	cn.com.easy.xbuilder.service.component.PieService.setUnit(LayOutUtil.data.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
}

/**
 * 设置组件标题
 */
function pie_fun_SetTitle(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var title = $("#pie_title").val();
	if(typeof(title)!="undefined"){
		info.title=title;
		info.showTitle = $("#showTitle").attr("checked")=="checked"?"1":"0";
		cn.com.easy.xbuilder.service.component.PieService.setTitle(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
			//synTitleToOther(containerId,componentId,title);
		});
	}
		
}

/**
 * 设置组件指标颜色列表
 * @param colors
 */
function pie_setColors(colors){
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var info = {"colors":colors};
	cn.com.easy.xbuilder.service.component.PieService.setColors(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){}); 
}

/**
 * 设置图例
 * @param position
 */
function pie_setLegend(position){
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var info = {position:position,isShow:position=="none"?"false":"true"};
	cn.com.easy.xbuilder.service.component.PieService.setLegend(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
}