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
public class ScatterService  extends ComponentBaseService{
	
	/* 删除指标列 */
	@SuppressWarnings("unchecked")
	public void removeExtKpi(String reportId, String containerId,String componentId, String jsonString) {
		Report reportObj = XContext.getEditView(reportId);
		Component component = getOrCreateComponet(reportObj, containerId,componentId);
		Map<String, String> element = (Map) Functions.json2java(jsonString);
		String extcolumnid = element.get("extcolumnid");
		String type = element.get("type");
		List<Kpi> kpiList = component.getKpiList();
		if (kpiList != null && kpiList.size() > 0) {
			Iterator<Kpi> iterator = kpiList.iterator();
			while (iterator.hasNext()) {
				Kpi kpi = iterator.next();
				if (kpi.getExtcolumnid().equals(extcolumnid)) {
					iterator.remove();
					List<YAxis> yaxisList = component.getYaxisList();
					if(yaxisList!=null){
						for(YAxis yaxis : yaxisList){
							if(yaxis.getId().equals(type)){
								yaxis.setTitle("");
								yaxis.setUnit("");
							}
						}
					}
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
	/*设置数据集*/
	@SuppressWarnings("unchecked")
	public void setDataSourceId(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		component.setDatasourceid(element.get("sqlId"));
		component.setKpiList(null);
		component.setXaxis(null);
		if(component.getYaxisList()!=null){
			for(YAxis yaxis : component.getYaxisList()){
				yaxis.setTitle("");
				yaxis.setUnit("");
			}
		}
		saveToXmlByObj(reportObj);
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
	
	/*设置最小粒度列*/
	@SuppressWarnings("unchecked")
	public void setMinDimField(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		XAxis xaxis=getOrCreateXaxis(component);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		if ("true".equals(element.get("isextcolumn"))) {
			xaxis.setScatterDimExtField(element.get("minDim"));
			xaxis.setScatterDimField("");
			xaxis.setScatterDimFieldId("");
		} else {
			xaxis.setScatterDimExtField("");
			xaxis.setScatterDimField(element.get("minDim"));
			xaxis.setScatterDimFieldId(element.get("minDimId"));
		}
		saveToXmlByObj(reportObj);
	}
	
	/*设置指标列*/
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
		List<YAxis> componentYaxisList=getOrCreateYaxisList(component);
		componentYaxisList.clear();
		for(int i=0;i<kpiList.size();i++){
			Map<String,String> tempMap=(Map<String,String>)kpiList.get(i);
			Kpi kpi=new Kpi();
			kpi.setIndex(""+i);
			kpi.setField(tempMap.get("field"));
			kpi.setKpiId(tempMap.get("kpiId"));
			kpi.setExtcolumnid(tempMap.get("extcolumnid"));
			kpi.setYaxisid(tempMap.get("axisType"));
			componentKpiList.add(kpi);
			
			YAxis yaxis=new YAxis();
			yaxis.setIndex(""+i);
			yaxis.setId(tempMap.get("axisType"));
			yaxis.setTitle(tempMap.get("title"));
			yaxis.setUnit(tempMap.get("unit"));
			componentYaxisList.add(yaxis);
		}
		saveToXmlByObj(reportObj);
	}

	/*取组件json数据*/
	@SuppressWarnings("unchecked")
	public String getComponentJsonData(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
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
			return "||||散点图：组件未配置。<br/>\n";
		}
		if("".equals(component.getTitle())){
			stringBuilder.append("||||散点图：未配置组件“标题”；<br/>\n");
		}
		if("".equals(component.getDatasourceid())||component.getDatasourceid()==null){
			stringBuilder.append("||||散点图：未配置组件“数据源”；<br/>\n");
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
					stringBuilder.append("||||散点图：组件配置的数据源已不存在；<br/>\n");
				}
			}
			
		}
		/*Xaxis元素*/
		if(null==component.getXaxis()){
			stringBuilder.append("||||散点图：未设置组件的“维度列”；<br/>\n");
		}else{
			
			if("".equals(component.getXaxis().getDimfield())&&"".equals(component.getXaxis().getDimExtField())){
				stringBuilder.append("||||散点图：未设置组件的“维度列”；<br/>\n");
			}
			
			if("1".equals(dsType)&&selectedDataSetModel!=null){
				if((!validateDatasourceField(selectedDataSetModel, component.getXaxis().getDimfield()))&&(!("".equals(component.getXaxis().getDimfield())))){
					stringBuilder.append("||||散点图：组件的维度列“"+component.getXaxis().getDimfield()+"”已不存在；<br/>\n");
				}
			}
		}
		
		/*Kpi元素*/
		List<Kpi> kpiList=component.getKpiList();
		if(null==kpiList){
			stringBuilder.append("||||散点图：组件未设置指标；<br/>\n");
		}else{
			for(Kpi tempKpi:kpiList){
				if("".equals(tempKpi.getField())&&"".equals(tempKpi.getExtcolumnid())){
					stringBuilder.append("||||散点图：未设置“"+tempKpi.getYaxisid()+"轴指标”<br/>\n");
				}
				
				if(null!=selectedDataSetModel&&"1".equals(dsType)){
					if((!validateDatasourceField(selectedDataSetModel, tempKpi.getField()))&&(!("".equals(tempKpi.getField())))){
						stringBuilder.append("||||散点图：组件的指标列“"+tempKpi.getField()+"”已不存在；<br/>\n");
					}
				}
				if(component.getYaxisList()!=null){
					for(YAxis y : component.getYaxisList()){
						if(tempKpi.getYaxisid().equals(y.getId())&&y.getTitle().equals("")){
							stringBuilder.append("||||散点图：未设置“"+tempKpi.getYaxisid()+"轴标题”<br/>\n");
							break;
						}
					}
				}
			}
		}
		return stringBuilder.toString();
	}
	
	
	/*生成组件标签代码*/
	@SuppressWarnings("unchecked")
	public String getComponentTagCode(String reportId,String componentId,String actionUrl) {
//		if(!validateComponent(reportId, componentId)){
//			return "";
//		}
//		StringBuilder stringBuilder=new StringBuilder();
//		stringBuilder.append("<m:npie id=\"comp_"+componentId+"\" ");
//		stringBuilder.append("type=\"pie\" ");
//		
//		stringBuilder.append("url=\""+actionUrl+"\" ");
//		Report reportObj=XContext.getEditView(reportId);
//		Component component=getOrCreateComponet(reportObj,componentId);
//		if(!("".equals(component.getTitle()))){
//			stringBuilder.append("title=\""+component.getTitle()+"\" ");
//		}
//		
//		if(!("".equals(component.getAttrenable()))&&"true".equals(component.getAttrenable())){
//			if(!("".equals(component.getWidth()))){
//				stringBuilder.append("width=\""+component.getWidth()+"\" ");
//			}
//			if(!("".equals(component.getHeight()))){
//				stringBuilder.append("height=\""+component.getHeight()+"\" ");
//			}
//		}else{
//			stringBuilder.append("width=\"auto\" height=\"225\" ");
//		}
//		XAxis xAxis=component.getXaxis();
//		if(!("".equals(xAxis.getDimfield()))){
//			stringBuilder.append("dimension=\""+xAxis.getDimfield()+"\" ");
//		}
//
//		
//		List<Kpi> kpiList=component.getKpiList();
//		for(int i=0;i<kpiList.size();i++){
//			if(i==0){
//				Kpi tempKpi=kpiList.get(i);
//				if(!("".equals(tempKpi.getField()))){
//					stringBuilder.append("value=\""+tempKpi.getField()+"\" ");
//				}
//				if(!("".equals(tempKpi.getName()))){
//					stringBuilder.append("kpiName=\""+tempKpi.getName()+"\" ");
//				}
//				break;
//				
//			}
//			
//		}
//		
//		
//		List<YAxis> yaxisList=component.getYaxisList();
//		for(int j=0;j<kpiList.size();j++){
//			if(j==0){
//				YAxis tempYAxis=yaxisList.get(j);
//				if(!("".equals(tempYAxis.getUnit()))){
//					stringBuilder.append("unit=\""+tempYAxis.getUnit()+"\" ");
//				}
//				break;
//				
//			}
//			
//		}
//		stringBuilder.append("/>");
//		return stringBuilder.toString();
		return "";
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
