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
public class PieService  extends ComponentBaseService{
	
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
	
	/*设置指标列*/
	@SuppressWarnings("unchecked")
	public void setKpiField(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		List<Kpi> componentKpiList=getOrCreateKpiList(component);
		Kpi kpi=null;
		if(componentKpiList.size()==0){
			kpi=new Kpi();
			componentKpiList.add(kpi);
		}else{
			kpi=componentKpiList.get(0);
		}
		kpi.setType("pie");
		kpi.setIndex("0");
		if ("true".equals(element.get("isextcolumn"))) {
			kpi.setField("");
			kpi.setKpiId("");
			kpi.setExtcolumnid(element.get("ser"));
		} else {
			kpi.setKpiId(element.get("kpiId"));
			kpi.setField(element.get("ser"));
			kpi.setExtcolumnid("");
		}
		saveToXmlByObj(reportObj);
	}
	
	/*设置指标名*/
	@SuppressWarnings("unchecked")
	public void setKpiName(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		List<Kpi> componentKpiList=getOrCreateKpiList(component);
		Kpi kpi=null;
		if(componentKpiList.size()==0){
			kpi=new Kpi();
			componentKpiList.add(kpi);
		}else{
			kpi=componentKpiList.get(0);
		}
		kpi.setType("pie");
		kpi.setIndex("0");
		
		kpi.setName(element.get("kpiName"));
		saveToXmlByObj(reportObj);
	}
	/*设置单位*/
	@SuppressWarnings("unchecked")
	public void setUnit(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		List<YAxis> componentYAxisList=getOrCreateYaxisList(component);
		YAxis yAxis=null;
		if(componentYAxisList.size()==0){
			yAxis=new YAxis();
			componentYAxisList.add(yAxis);
		}else{
			yAxis=componentYAxisList.get(0);
		}
		yAxis.setUnit(element.get("unit"));
		yAxis.setIndex("0");
		//component.setType("pie");
		saveToXmlByObj(reportObj);
		
		//System.out.println(getComponentTagCode(reportId,componentId,"/fdsa/fs/fds.action"));
	}
	
	/*取组件json数据*/
	@SuppressWarnings("unchecked")
	public String getComponentJsonData(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		return Functions.java2json(component);
	}
	
	public String validateComponentById(String reportId,String containerId,String componentId){
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		return validateComponent(reportObj,component);
	}
	
	/*校验组件内各元素有效性*/
	@SuppressWarnings("unchecked")
	public String validateComponent(Report report,Component component) {
		String commentName=component.getType().toLowerCase().equals("pie")?"饼图：":"环图：";
		DataSetService dss=new DataSetService();
		Map selectedDataSetModel=null;
		String dsType = report.getInfo().getType();
		StringBuilder stringBuilder=new StringBuilder();
		/*Component元素*/
		if(null==component){
			return "||||"+commentName+":组件未配置。<br/>\n";
		}
		if("".equals(component.getTitle())){
			stringBuilder.append("||||"+commentName+":未配置组件“标题”；<br/>\n");
		}
		if("".equals(component.getDatasourceid())||component.getDatasourceid()==null){
			stringBuilder.append("||||"+commentName+":未配置组件“数据源”；<br/>\n");
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
					stringBuilder.append("||||"+commentName+":组件配置的数据源已不存在；<br/>\n");
				}
			}
			
		}
		/*Xaxis元素*/
		if(null==component.getXaxis()){
			stringBuilder.append("||||"+commentName+":未设置组件的“排序列”和“维度列”；<br/>\n");
		}else{
			if("".equals(component.getXaxis().getSortfield())&&"".equals(component.getXaxis().getSortExtField())){
				stringBuilder.append("||||"+commentName+":未设置组件的“排序列”；<br/>\n");
			}
			
			if("".equals(component.getXaxis().getDimfield())&&"".equals(component.getXaxis().getDimExtField())){
				stringBuilder.append("||||"+commentName+":未设置组件的“维度列”；<br/>\n");
			}
			
			if("1".equals(dsType)&&selectedDataSetModel!=null){
				if((!validateDatasourceField(selectedDataSetModel, component.getXaxis().getSortfield()))&&(!("".equals(component.getXaxis().getSortfield())))){
					stringBuilder.append("||||"+commentName+":组件的排序列“"+component.getXaxis().getSortfield()+"”已不存在；<br/>\n");
				}
				if((!validateDatasourceField(selectedDataSetModel, component.getXaxis().getDimfield()))&&(!("".equals(component.getXaxis().getDimfield())))){
					stringBuilder.append("||||"+commentName+":组件的维度列“"+component.getXaxis().getDimfield()+"”已不存在；<br/>\n");
				}
			}
		}
		
		/*Kpi元素*/
		List<Kpi> kpiList=component.getKpiList();
		if(null==kpiList){
			stringBuilder.append("||||"+commentName+":组件未设置指标；<br/>\n");
		}else{
			for(Kpi tempKpi:kpiList){
				if("".equals(tempKpi.getField())&&"".equals(tempKpi.getExtcolumnid())){
					stringBuilder.append("||||"+commentName+":未对组件的“指标设置”下的“指标列”进行设置；<br/>\n");
				}
				
				if(null!=selectedDataSetModel&&"1".equals(dsType)){
					if((!validateDatasourceField(selectedDataSetModel, tempKpi.getField()))&&(!("".equals(tempKpi.getField())))){
						stringBuilder.append("||||"+commentName+":组件的指标列“"+tempKpi.getField()+"”已不存在；<br/>\n");
					}
				}
				if("".equals(tempKpi.getName())){
					stringBuilder.append("||||"+commentName+":未设置组件的“指标名”；<br/>\n");
				}
			}
		}
		
		return stringBuilder.toString();
	}
	
	/**
	 * 删除kpistorecol
	 * @param reportId
	 * @param containerId
	 * @param componentId
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
