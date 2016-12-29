package cn.com.easy.xbuilder.service.component;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import cn.com.easy.annotation.Service;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Kpi;
import cn.com.easy.xbuilder.element.Legend;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.XAxis;
import cn.com.easy.xbuilder.element.YAxis;
import cn.com.easy.xbuilder.service.DataSetService;
@Service
public class LineService  extends ComponentBaseService{
	
	/* 删除指标列 */
	@SuppressWarnings("unchecked")
	public void removeExtKpi(String reportId, String containerId,String componentId, String jsonString) {
		Report reportObj = XContext.getEditView(reportId);
		Component component = getOrCreateComponet(reportObj, containerId,componentId);
		Map<String, String> element = (Map) Functions.json2java(jsonString);
		String extcolumnid = element.get("extcolumnid");
		List<Kpi> kpiList = component.getKpiList();
		if (kpiList != null && kpiList.size() > 0) {
			Iterator<Kpi> iterator = kpiList.iterator();
			while (iterator.hasNext()) {
				Kpi kpi = iterator.next();
				if (kpi.getExtcolumnid().equals(extcolumnid)) {
					iterator.remove();
					break;
				}
			}
		}
		saveToXmlByObj(reportObj);
	}
	/*设置标题*/
	@SuppressWarnings("unchecked")
	public void setTitle(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		component.setChartTitle(element.get("title"));
		component.setShowTitle(element.get("showTitle"));
		saveToXmlByObj(reportObj);
		//System.out.println(validateAllChartComponent(reportObj,component));
	}
	/*设置图例*/
	@SuppressWarnings("unchecked")
	public void setLegend(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		if (component.getLegend()==null) {
			component.setLegend(new Legend());
		}
		component.getLegend().setIsShow(element.get("isShow"));
		component.getLegend().setPosition(element.get("position"));
		saveToXmlByObj(reportObj);
	}
	/*设置图标指标的颜色*/
	@SuppressWarnings("unchecked")
	public void setColors(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		component.setColors(element.get("colors"));
		saveToXmlByObj(reportObj);
	}
	/*是否设置宽高*/
	@SuppressWarnings("unchecked")
	public void showSetHW(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		component.setAttrenable(element.get("attrenable"));
		component.setWidth("auto");
		component.setHeight("225");
		saveToXmlByObj(reportObj);
	}
	/*设置宽度*/
	@SuppressWarnings("unchecked")
	public void setWidth(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		component.setWidth(element.get("width"));
		saveToXmlByObj(reportObj);
	}
	/*设置高度*/
	@SuppressWarnings("unchecked")
	public void setHeight(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		component.setHeight(element.get("height"));
		saveToXmlByObj(reportObj);
	}
	
	/*设置数据集*/
	@SuppressWarnings("unchecked")
	public void setDataSourceId(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		XAxis xaxis=getOrCreateXaxis(component);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		component.setDatasourceid(element.get("sqlId"));
		component.setKpiList(null);
		component.setXaxis(null);
		saveToXmlByObj(reportObj);
	}
	
	/*设置排序列*/
	@SuppressWarnings("unchecked")
	public void setSortField(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		XAxis xaxis=getOrCreateXaxis(component);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		if ("true".equals(element.get("isextcolumn"))) {
			xaxis.setSortExtField(element.get("ord"));
			xaxis.setSortfield("");
			xaxis.setSortFiledId("");
		} else {
			xaxis.setSortExtField("");
			xaxis.setSortfield(element.get("ord"));
			xaxis.setSortFiledId(element.get("ordKpiId"));
		}
		xaxis.setSortkpitype(element.get("kpiType"));
		String oldSortType = xaxis.getSortType();
		xaxis.setSortType(element.get("sortType"));
		saveToXmlByObj(reportObj);
		//设置排序方式时调用生成sql方法
		if(element.get("ordKpiId")!=null&&oldSortType!=null&&!oldSortType.equals(element.get("sortType"))){
			setComponentSqlString(reportObj,containerId,componentId);
		}
	}
	
	/*设置维度列*/
	@SuppressWarnings("unchecked")
	public void setDimField(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		XAxis xaxis=getOrCreateXaxis(component);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		if ("true".equals(element.get("isextcolumn"))) {
			xaxis.setDimExtField(element.get("dimension"));
			xaxis.setDimfield("");
			xaxis.setDimFiledId("");
		} else {
			xaxis.setDimExtField("");
			xaxis.setDimfield(element.get("dimension"));
			xaxis.setDimFiledId(element.get("dimFieldId"));
		}
		saveToXmlByObj(reportObj);
	}
	
	/*刻度设置*/
	@SuppressWarnings("unchecked")
	public void setYaxis(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		
		Map<String,Object> element=(Map)Functions.json2java(jsonString);
		List yaxisList=new ArrayList();
		if(element.get("yaxis")!=null){
			yaxisList=(ArrayList)element.get("yaxis");
		}
		
		List<YAxis> componentYaxisList=getOrCreateYaxisList(component);
		componentYaxisList.clear();
		for(int i=0;i<yaxisList.size();i++){
			Map<String,String> tempMap=(Map<String,String>)yaxisList.get(i);
			YAxis yaxis=new YAxis();
			yaxis.setIndex(""+i);
			yaxis.setId(tempMap.get("id"));
			yaxis.setTitle(tempMap.get("title"));
			yaxis.setColor(tempMap.get("color"));
			yaxis.setUnit(tempMap.get("unit"));
//			yaxis.setMin(tempMap.get("min"));
			componentYaxisList.add(yaxis);
			
		}
		saveToXmlByObj(reportObj);
	}
	
	/*指标设置*/
	@SuppressWarnings("unchecked")
	public void setKpi(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,Object> element=(Map)Functions.json2java(jsonString);
		List kpiList=new ArrayList();
		if(element.get("kpiList")!=null){
			kpiList=(ArrayList)element.get("kpiList");
		}
		List<Kpi> componentKpiList=getOrCreateKpiList(component);
		componentKpiList.clear();
		for(int i=0;i<kpiList.size();i++){
			Map<String,String> tempMap=(Map<String,String>)kpiList.get(i);
			Kpi kpi=new Kpi();
			kpi.setIndex(""+i);
			if ("true".equals(tempMap.get("isextcolumn"))) {
				kpi.setField("");
				kpi.setKpiId("");
				kpi.setExtcolumnid(tempMap.get("ser"));
			} else {
				kpi.setField(tempMap.get("ser"));
				kpi.setKpiId(tempMap.get("kpiId"));
				kpi.setExtcolumnid("");
			}
			kpi.setName(tempMap.get("ser_name"));
			kpi.setColor(tempMap.get("color"));
			kpi.setType(tempMap.get("type"));
			kpi.setYaxisid(tempMap.get("ref"));
			componentKpiList.add(kpi);
		}
		//component.setType("line");
		saveToXmlByObj(reportObj);
		
		//System.out.println(getComponentTagCode(reportId,componentId,"/fdsa/fs/fds.action"));
	}
	
	/*取组件json数据*/
	@SuppressWarnings("unchecked")
	public String getComponentJsonData(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=readFromXmlByViewId(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		return Functions.java2json(component);
	}
	
	/*校验组件内各元素有效性*/
	@SuppressWarnings("unchecked")
	public String validateComponent(Report report,Component component) {
		DataSetService dss=new DataSetService();
		Map selectedDataSetModel=null;
		String dsType = report.getInfo().getType();
		StringBuilder stringBuilder=new StringBuilder();
		/*Component元素*/
		if(null==component){
			return "||||线图：组件未配置。<br/>\n";
		}
		if("".equals(component.getTitle())){
			stringBuilder.append("||||线图：未配置组件“标题”；<br/>\n");
		}	
		if("".equals(component.getDatasourceid())||component.getDatasourceid()==null){
			stringBuilder.append("||||线图：未配置组件“数据源”；<br/>\n");
		}else{
			if(report.getDatasources()!=null&&report.getDatasources().getDatasourceList()!=null){
				List<Map> dataSetModelList=dss.getTreeDataObj(report.getId());
				if(dataSetModelList==null){
					dataSetModelList=new ArrayList<Map>();
				}
				for(Map tempDataSetModel:dataSetModelList){
					if(String.valueOf(tempDataSetModel.get("id")).substring(1).equals(component.getDatasourceid())){
						selectedDataSetModel=tempDataSetModel;
					}
				}
				if(selectedDataSetModel==null){
					stringBuilder.append("||||线图：组件配置的数据源已不存在；<br/>\n");
				}
			}
			
		}
		/*Xaxis元素*/
		if(null==component.getXaxis()){
			stringBuilder.append("||||线图：未设置组件的“排序列”和“维度列”；<br/>\n");
		}else{
			if("".equals(component.getXaxis().getSortfield())&&"".equals(component.getXaxis().getSortExtField())){
				stringBuilder.append("||||线图：未设置组件的“排序列”；<br/>\n");
			}
			
			if("".equals(component.getXaxis().getDimfield())&&"".equals(component.getXaxis().getDimExtField())){
				stringBuilder.append("||||线图：未设置组件的“维度列”；<br/>\n");
			}
			
			if("1".equals(dsType)&&selectedDataSetModel!=null){
				if((!validateDatasourceField(selectedDataSetModel, component.getXaxis().getSortfield()))&&(!("".equals(component.getXaxis().getSortfield())))){
					stringBuilder.append("||||线图：组件的排序列“"+component.getXaxis().getSortfield()+"”已不存在；<br/>\n");
				}
				if((!validateDatasourceField(selectedDataSetModel, component.getXaxis().getDimfield()))&&(!("".equals(component.getXaxis().getDimfield())))){
					stringBuilder.append("||||线图：组件的维度列“"+component.getXaxis().getDimfield()+"”已不存在；<br/>\n");
				}
			}
		}
		
		/*YAxis元素*/
		List<YAxis> yaxisList=component.getYaxisList();
		if(null==yaxisList){
			stringBuilder.append("||||线图：未设置组件的“刻度”；<br/>\n");
		}else{
//			int i=0;
//			for(YAxis y : yaxisList){
//				if(y.getTitle()==null||"".equals(y.getTitle())){
//					stringBuilder.append("未设置组件“刻度y"+(i++)+"”的标题；<br/>\n");
//				}
//			}
		}
		

		/*Kpi元素*/
		List<Kpi> kpiList=component.getKpiList();
		if(null==kpiList){
			stringBuilder.append("||||线图：组件未设置任何指标；<br/>\n");
		}else{
			for(Kpi tempKpi:kpiList){
				if("".equals(tempKpi.getField())&&"".equals(tempKpi.getExtcolumnid())){
					stringBuilder.append("||||线图：未对组件的“指标设置”下的“指标列”进行设置；<br/>\n");
				}
				if(null!=selectedDataSetModel&&"1".equals(dsType)){
					if((!validateDatasourceField(selectedDataSetModel, tempKpi.getField()))&&(!("".equals(tempKpi.getField())))){
						stringBuilder.append("||||线图：组件的指标列“"+tempKpi.getField()+"”已不存在；<br/>\n");
					}
				}
				if("".equals(tempKpi.getName())){
					stringBuilder.append("||||线图：未设置组件的“指标名”；<br/>\n");
				}
				if("".equals(tempKpi.getType())){
					stringBuilder.append("||||线图：未设置组件的“指标类型”；<br/>\n");
				}
			}
		}
		return stringBuilder.toString();
	}
	
	
	/*生成组件标签代码*/
	@SuppressWarnings("unchecked")
	public String getComponentTagCode(String reportId,String containerId,String componentId,String actionUrl) {
//		if(!validateComponent(reportId, componentId)){
//			return "";
//		}
		StringBuilder stringBuilder=new StringBuilder();
		StringBuilder tempStringBuilder=new StringBuilder();
		stringBuilder.append("<m:nline id=\"comp_"+componentId+"\" ");
		stringBuilder.append("url=\""+actionUrl+"\" ");
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		if(!("".equals(component.getTitle()))){
			stringBuilder.append("title=\""+component.getTitle()+"\" ");
		}
		
		if(!("".equals(component.getAttrenable()))&&"true".equals(component.getAttrenable())){
			if(!("".equals(component.getWidth()))){
				stringBuilder.append("width=\""+component.getWidth()+"\" ");
			}
			if(!("".equals(component.getHeight()))){
				stringBuilder.append("height=\""+component.getHeight()+"\" ");
			}
		}else{
			stringBuilder.append("width=\"auto\" height=\"225\" ");
		}
		XAxis xAxis=component.getXaxis();
		if(!("".equals(xAxis.getDimfield()))){
			stringBuilder.append("dimension=\""+xAxis.getDimfield()+"\" ");
		}

		
		List<YAxis> yaxisList=component.getYaxisList();
		stringBuilder.append("yaxis=\"");
		for(YAxis tempYAxis:yaxisList){
			tempStringBuilder.delete(0, tempStringBuilder.length());
			if(!("".equals(tempYAxis.getTitle()))){
				tempStringBuilder.append("title:"+tempYAxis.getTitle()+",");
			}
			if(!("".equals(tempYAxis.getColor())||"#fff".equals(tempYAxis.getColor()))){
				tempStringBuilder.append("yColor:"+tempYAxis.getColor()+",");
			}
			if(!("".equals(tempYAxis.getUnit()))){
				tempStringBuilder.append("unit:"+tempYAxis.getUnit()+",");
			}
			/*if(!("".equals(tempYAxis.getMin()))){
				tempStringBuilder.append("min:"+tempYAxis.getMin()+",");
			}*/
			stringBuilder.append(tempStringBuilder.substring(0, tempStringBuilder.length()-1));
			stringBuilder.append(";");
		}

		stringBuilder.append("\" ");
		
		
		List<Kpi> kpiList=component.getKpiList();
		for(@SuppressWarnings("unused")
		Kpi tempKpi:kpiList){
			
			if(!("".equals(tempKpi.getField()))){
				stringBuilder.append(tempKpi.getField()+"=\"");
				tempStringBuilder.delete(0, tempStringBuilder.length());
				if(!("".equals(tempKpi.getName()))){
					tempStringBuilder.append("name:"+tempKpi.getName()+",");
				}
				if(!("".equals(tempKpi.getColor())||"#fff".equals(tempKpi.getColor()))){
					tempStringBuilder.append("color:"+tempKpi.getColor()+",");
				}
				stringBuilder.append(tempStringBuilder.substring(0,tempStringBuilder.length()-1));
				stringBuilder.append("\" ");
				
			}
		}
		
		stringBuilder.append("/>");
		return stringBuilder.toString();
	}
	
	
	/**
	 * 删除kpistorecol
	 * @param reportId
	 * @param extcolumnid
	 * @return
	 */
	public String deleteKpiStoreCol(String reportId, String extcolumnid){
		try{
			super.removeKpiStoreCol(reportId , extcolumnid);
			return "1";
		}catch(Exception e){
			e.printStackTrace();
			return "0";
		}
	}
	
}
