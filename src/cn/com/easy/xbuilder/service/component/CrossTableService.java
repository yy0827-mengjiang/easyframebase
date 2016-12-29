package cn.com.easy.xbuilder.service.component;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.beanutils.BeanUtils;

import cn.com.easy.annotation.Service;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Crosscol;
import cn.com.easy.xbuilder.element.Crosscolstore;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Datasources;
import cn.com.easy.xbuilder.element.Datastore;
import cn.com.easy.xbuilder.element.Event;
import cn.com.easy.xbuilder.element.Eventstore;
import cn.com.easy.xbuilder.element.Extcolumn;
import cn.com.easy.xbuilder.element.Extcolumns;
import cn.com.easy.xbuilder.element.Headui;
import cn.com.easy.xbuilder.element.Kpistore;
import cn.com.easy.xbuilder.element.KpistoreCol;
import cn.com.easy.xbuilder.element.Kpistores;
import cn.com.easy.xbuilder.element.Param;
import cn.com.easy.xbuilder.element.Parameter;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Sortcol;
import cn.com.easy.xbuilder.element.SortcolStore;
import cn.com.easy.xbuilder.kpi.XDataSourceSql;
import cn.com.easy.xbuilder.service.DataSetService;

@Service("crossTableService")
public class CrossTableService extends ComponentBaseService {
	private SqlRunner runner;
	/**
	 * 保存列头源码
	 * @param layoutSrc
	 * @return
	 */
	public String setHeadui(Map<String,Object> nodeData){
		
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		String headuiHtml = String.valueOf(nodeData.get("headui"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		
		Headui headui = component.getHeadui();
		if (headui==null){
			headui = new Headui();
			component.setHeadui(headui);
		}
		headui.setText(headuiHtml);
		saveToXmlByObj(report);
		return "1";
	}
	
	/**
	 * 保存组件属性
	 * @param nodeData
	 * @return
	 */
	public String setComponentAttr(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		String attrKey = String.valueOf(nodeData.get("attrKey"));
		String attrValue = String.valueOf(nodeData.get("attrValue"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		try {
			BeanUtils.setProperty(component, attrKey, attrValue);
		} catch (Exception e) {
			e.printStackTrace();
		}
		saveToXmlByObj(report);
		return "1";
	}
	
	public String setDataColDesc(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		String colType = String.valueOf( nodeData.get("colType"));
		String colField = String.valueOf( nodeData.get("colField"));
		String colDesc = String.valueOf( nodeData.get("colDesc"));
		Report report = XContext.getEditView(reportId);
		if(report==null){
		   return "0";
		}
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null){
			return "0";
		}
		if("rowdim".equals(colType)||"columndim".equals(colType)){
			if(component.getCrosscolstore()!=null&&component.getCrosscolstore().getCrosscolList()!=null){
				List<Crosscol> colList = component.getCrosscolstore().getCrosscolList();
				for(Crosscol col : colList){
					if(colField.equals(col.getDimfield())){
						col.setDimdesc(colDesc);
						break;
					}
				}
			}else{
				return "0";
			}
		}else if("kpi".equals(colType)){
			if(component.getDatastore()!=null&&component.getDatastore().getDatacolList()!=null){
				List<Datacol> colList = component.getDatastore().getDatacolList();
				for(Datacol col : colList){
					if(colField.equals(col.getDatacolcode())){
						col.setTablecoldesc(colDesc);
						break;
					}
				}
			}else{
				return "0";
			}
		}
		saveToXmlByObj(report);
		return "1";
	}
	/**
	 * 
	 * @param nodeData
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String saveCrossDimColumns(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		List<Map> dimMapList = (List<Map>)nodeData.get("dimMapList");
		Report report = XContext.getEditView(reportId);
		if(report==null){
		   return "0";
		}
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null){
			return "0";
		} 
		if(component.getCrosscolstore()==null){
			component.setCrosscolstore(new Crosscolstore());
		}
		List<Crosscol> oldCrossColList = component.getCrosscolstore().getCrosscolList();
		Map<String,Crosscol> oldDataColMap = new HashMap<String,Crosscol>();
		if(oldCrossColList!=null&&oldCrossColList.size()>0){
			for(Crosscol col : oldCrossColList){
				oldDataColMap.put(col.getDimid(), col);
			}
		}
		List<Crosscol> crosscolList = new ArrayList<Crosscol>();
		for(Map dimMap : dimMapList){
			Crosscol col = oldDataColMap.get(dimMap.get("dimId"));
			if(col==null){
				col = new Crosscol();
				col.setId(componentId+"_"+dimMap.get("dimType")+"_"+dimMap.get("dimIndex"));//组件id_维度类型_维度顺序
				col.setDimid(dimMap.get("dimId")+"");
				col.setDimfield(String.valueOf(dimMap.get("dimField")));
				col.setType(String.valueOf(dimMap.get("dimType")));
				if(dimMap.get("dimDesc")==null){
					col.setDimdesc(col.getDimfield());
				}else{
					col.setDimdesc(String.valueOf(dimMap.get("dimDesc")));
				}
			}
			col.setIndex(String.valueOf(dimMap.get("dimIndex")));
			col.setType(dimMap.get("dimType")+"");
			crosscolList.add(col);
		}
		component.getCrosscolstore().setCrosscolList(crosscolList);
		saveToXmlByObj(report);
		return "1";
	}
	
	/**
	 * 保存指标区域
	 * @param nodeData
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String saveCrossKpiColumns(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		List<Map> kpiMapList = (List<Map>)nodeData.get("kpiMapList");
		Report report = XContext.getEditView(reportId);
		if(report==null){
		   return "0";
		}
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null){
			return "0";
		} 
		if(component.getDatastore()==null){
			component.setDatastore(new Datastore());
		}
		List<Datacol> oldDataColList = component.getDatastore().getDatacolList();
		Map<String,Datacol> oldDataColMap = new HashMap<String,Datacol>();
		if(oldDataColList!=null&&oldDataColList.size()>0){
			for(Datacol col : oldDataColList){
				oldDataColMap.put("".equals(col.getDatacolcode())?col.getExtcolumnid():col.getDatacolcode(), col);
			}
		}
		List<Datacol> dataColList = new ArrayList<Datacol>();
		for(Map kpiMap : kpiMapList){
			Datacol col = oldDataColMap.get("".equals(kpiMap.get("datacolcode"))?kpiMap.get("extcolumnid"):kpiMap.get("datacolcode"));
			if(col==null){
				col = new Datacol();
				col.setDatacolcode(String.valueOf(kpiMap.get("datacolcode")));
				col.setDatacolid(String.valueOf(kpiMap.get("datacolid")));
				col.setExtcolumnid(String.valueOf(kpiMap.get("extcolumnid")));
				col.setDatafmtalign("right");
				col.setDatacoltype("kpi");
			}
			col.setTablecoldesc(String.valueOf(kpiMap.get("tablecoldesc")));
			dataColList.add(col);
		}
		component.getDatastore().setDatacolList(dataColList);
		saveToXmlByObj(report);
		return "1";
	}
	
	/**
	 * @param nodeData
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String saveCrossSortColumns(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		List<Map> sortMapList = (List<Map>)nodeData.get("sortMapList");
		Report report = XContext.getEditView(reportId);
		if(report==null){
		   return "0";
		}
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null){
			return "0";
		} 
		if(component.getSortcolStore()==null){
			component.setSortcolStore(new SortcolStore());
		}
		List<Sortcol> sortColList = new ArrayList<Sortcol>();
		for(Map kpiMap : sortMapList){
			Sortcol col = new Sortcol();
			col.setId(String.valueOf(kpiMap.get("id")));
			col.setCol(String.valueOf(kpiMap.get("col")));
			col.setDesc(String.valueOf(kpiMap.get("desc")));
			col.setType(String.valueOf(kpiMap.get("type")));
			col.setKpitype(String.valueOf(kpiMap.get("kpitype")));
			col.setExtcolumnid(String.valueOf(kpiMap.get("extcolumnid")));
			sortColList.add(col);
		}
		component.getSortcolStore().setSortcolList(sortColList);
		saveToXmlByObj(report);
		return "1";
	}
	
	/**
	 * 保存组件属性(一次多个)
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String setComponentAttrs(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		
		if(nodeData.get("infoList")!=null){
			List<Map<String, Object>> propertyList=(List<Map<String,Object>>)nodeData.get("infoList");
			for(Map<String, Object> tempCol:propertyList){
				String attrKey = String.valueOf(tempCol.get("attrKey"));
				String attrValue = String.valueOf(tempCol.get("attrValue"));
				try {
					BeanUtils.setProperty(component, attrKey, attrValue);
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			}
		}
		saveToXmlByObj(report);
		return "1";
	}
	
	/**
	 * 保存多个单元格多个属性
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String setMoreDatacolMoreAttrs(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Datastore datastore = component.getDatastore();
		if(datastore==null){
			datastore=new Datastore();
			component.setDatastore(datastore);
		}
		List<Datacol> datacols = datastore.getDatacolList();
		if(datacols==null){
			datacols=new ArrayList<Datacol>();
			datastore.setDatacolList(datacols);
		}
		List<Map<String, Object>> dataColsList=null;
		if(nodeData.get("dataCols")!=null&&(!"".equals(nodeData.get("dataCols")))){
			dataColsList=(List<Map<String, Object>>)nodeData.get("dataCols");
		}
		if(dataColsList==null){
			dataColsList=new ArrayList<Map<String, Object>>();
		}
		String tempDataColCode="";
		for(Map<String, Object> tempDataCol:dataColsList){
			tempDataColCode=String.valueOf(tempDataCol.get("datacolcode"));
			if(tempDataCol.get("dataColAttrs")!=null){
				List<Map<String, Object>> dataColAttrsList=(List<Map<String,Object>>)tempDataCol.get("dataColAttrs");
				if(dataColAttrsList!=null&&dataColAttrsList.size()>0){
					Datacol datacol=null;
					for (Datacol datacolEle : datacols) {
						if (tempDataColCode.equals(datacolEle.getDatacolcode())) {
							datacol = datacolEle;
						}
					}
					if(datacol==null){
						datacol=new Datacol();
						datacols.add(datacol);
					}
					for(Map<String, Object> tempCol:dataColAttrsList){
						String attrKey = String.valueOf(tempCol.get("attrKey"));
						String attrValue = String.valueOf(tempCol.get("attrValue"));
						try {
							BeanUtils.setProperty(datacol, attrKey, attrValue);
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						} catch (InvocationTargetException e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
		saveToXmlByObj(report);
		return "1";
	}
	
	
	
	/**
	 * 保存多个单元格多个属性
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String setMoreDimColumnMoreAttrs(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Crosscolstore crossStore = component.getCrosscolstore();
		if(crossStore==null){
			crossStore=new Crosscolstore();
			component.setCrosscolstore(crossStore);
		}
		List<Crosscol> crosscols = crossStore.getCrosscolList();
		if(crosscols==null){
			crosscols=new ArrayList<Crosscol>();
			crossStore.setCrosscolList(crosscols);
		}
		List<Map<String, Object>> dataColsList=null;
		if(nodeData.get("dataCols")!=null&&(!"".equals(nodeData.get("dataCols")))){
			dataColsList=(List<Map<String, Object>>)nodeData.get("dataCols");
		}
		if(dataColsList==null){
			dataColsList=new ArrayList<Map<String, Object>>();
		}
		String tempDataColCode="";
		for(Map<String, Object> tempDataCol:dataColsList){
			tempDataColCode=String.valueOf(tempDataCol.get("datacolcode"));
			if(tempDataCol.get("dataColAttrs")!=null){
				List<Map<String, Object>> dataColAttrsList=(List<Map<String,Object>>)tempDataCol.get("dataColAttrs");
				if(dataColAttrsList!=null&&dataColAttrsList.size()>0){
					Crosscol crosscol=null;
					for (Crosscol datacolEle : crosscols) {
						if (tempDataColCode.equals(datacolEle.getDimfield())) {
							crosscol = datacolEle;
						}
					}
					if(crosscol==null){
						crosscol=new Crosscol();
						crosscols.add(crosscol);
					}
					for(Map<String, Object> tempCol:dataColAttrsList){
						String attrKey = String.valueOf(tempCol.get("attrKey"));
						String attrValue = String.valueOf(tempCol.get("attrValue"));
						try {
							BeanUtils.setProperty(crosscol, attrKey, attrValue);
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						} catch (InvocationTargetException e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
		saveToXmlByObj(report);
		return "1";
	}
	
	
	@SuppressWarnings("unchecked")
	public String setMoreEventStoreMoreEvent(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Datastore datastore = component.getDatastore();
		if(datastore==null){
			datastore=new Datastore();
			component.setDatastore(datastore);
		}
		List<Datacol> datacols = datastore.getDatacolList();
		if(datacols==null){
			datacols=new ArrayList<Datacol>();
			datastore.setDatacolList(datacols);
		}
		List<Map<String, Object>> eventStoreMapList=null;
		if(nodeData.get("eventStoreList")!=null&&(!"".equals(nodeData.get("eventStoreList")))){
			eventStoreMapList=(List<Map<String, Object>>)nodeData.get("eventStoreList");
		}
		if(eventStoreMapList==null){
			eventStoreMapList=new ArrayList<Map<String, Object>>();
		}
		String tempEventStoreType=null;
		String tempEventStoreDataColCode=null;
		for(Map<String, Object> tempEventStoreMap:eventStoreMapList){
			tempEventStoreType=String.valueOf(tempEventStoreMap.get("type"));
			tempEventStoreDataColCode = String.valueOf(tempEventStoreMap.get("datacolcode"));
			
			Datacol tempEventStoreDataCol=null;
			for(Datacol tempDatacol:datacols){
				if(tempEventStoreDataColCode.equals(tempDatacol.getDatacolcode())){
					tempEventStoreDataCol=tempDatacol;
				}
			}
			if(tempEventStoreDataCol==null){
				tempEventStoreDataCol=new Datacol();
				datacols.add(tempEventStoreDataCol);
			}
			Eventstore tempEventStore=tempEventStoreDataCol.getEventstore();
			if(tempEventStore==null){
				tempEventStore=new Eventstore();
				tempEventStoreDataCol.setEventstore(tempEventStore);
			}
			tempEventStore.setType(tempEventStoreType);
			List<Event> eventList=tempEventStore.getEventList();
			if(eventList==null){
				eventList=new ArrayList<Event>();
				tempEventStore.setEventList(eventList);
			}
			List<Map<String, Object>> tempEventMapList=null;
			if(tempEventStoreMap.get("eventList")!=null&&(!"".equals(tempEventStoreMap.get("eventList")))){
				tempEventMapList=(List<Map<String, Object>>)tempEventStoreMap.get("eventList");
			}
			if(tempEventMapList==null){
				tempEventMapList=new ArrayList<Map<String, Object>>();
			}
			
			for(Map<String, Object> tempEventMap:tempEventMapList){
				
				String tempEventMapId=String.valueOf(tempEventMap.get("id"));
				String tempEventMapSource=String.valueOf(tempEventMap.get("source"));
				String tempEventSourceShow = String.valueOf(tempEventMap.get("sourceShow"));
				String tempEventParameterShow = String.valueOf(tempEventMap.get("parameterShow"));
				if(tempEventMapId.equals("null")||tempEventMapSource.equals("null")){
					continue;
				}
				Event tempDataColEvent=null;
				for(Event tempEvent:eventList){
					if(tempEventMapId.equals(tempEvent.getId())){
						tempDataColEvent=tempEvent;
					}
				}
				if(tempDataColEvent==null){
					tempDataColEvent=new Event();
					tempDataColEvent.setId(tempEventMapId);
					eventList.add(tempDataColEvent);
				}
				tempDataColEvent.setSource(tempEventMapSource);
				List<Map<String, Object>> tempParameterMapList=null;
				if(tempEventMap.get("parameterList")!=null&&(!"".equals(tempEventMap.get("parameterList")))){
					tempParameterMapList=(List<Map<String, Object>>)tempEventMap.get("parameterList");
				}
				if(tempParameterMapList==null){
					tempParameterMapList=new ArrayList<Map<String, Object>>();
				}
				List<Parameter> parameterList=new ArrayList<Parameter>();
				tempDataColEvent.setParameterList(parameterList);
				for(Map<String, Object> tempParameterMap:tempParameterMapList){
					String parameterDimsionId=String.valueOf(tempParameterMap.get("dimsionid"));
					String parameterName=String.valueOf(tempParameterMap.get("name"));
					String parameterValue=String.valueOf(tempParameterMap.get("value"));
					Parameter parameter=new Parameter();
					parameter.setDimsionid(parameterDimsionId);
					parameter.setName(parameterName);
					parameter.setValue(parameterValue);
					parameterList.add(parameter);
				}
				
			}
			Iterator<Event> eventIterator = eventList.iterator(); 
			boolean hasExistEventFlag=false;
			while(eventIterator.hasNext()){
				Event tempEvent=eventIterator.next();
				hasExistEventFlag=false; 
				for(Map<String, Object> tempEventMap:tempEventMapList){
					if(tempEvent.getId()!=null&&tempEvent.getId().equals(String.valueOf(tempEventMap.get("id")))){
						hasExistEventFlag=true;
					}
				}
				if(!hasExistEventFlag){
					eventIterator.remove();
				}
			}
			
		}
		saveToXmlByObj(report);
		return "1";
	}
	
	
	@SuppressWarnings("unchecked")
	public String setRowDimEvents(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Crosscolstore crossStore = component.getCrosscolstore();
		if(crossStore==null){
			crossStore=new Crosscolstore();
			component.setCrosscolstore(crossStore);
		}
		List<Crosscol> crossCols = crossStore.getCrosscolList();
		if(crossCols==null){
			crossCols=new ArrayList<Crosscol>();
			crossStore.setCrosscolList(crossCols);
		}
		List<Map<String, Object>> eventStoreMapList=null;
		if(nodeData.get("eventStoreList")!=null&&(!"".equals(nodeData.get("eventStoreList")))){
			eventStoreMapList=(List<Map<String, Object>>)nodeData.get("eventStoreList");
		}
		if(eventStoreMapList==null){
			eventStoreMapList=new ArrayList<Map<String, Object>>();
		}
		String tempEventStoreType=null;
		String tempEventStoreDataColCode=null;
		for(Map<String, Object> tempEventStoreMap:eventStoreMapList){
			tempEventStoreType=String.valueOf(tempEventStoreMap.get("type"));
			tempEventStoreDataColCode = String.valueOf(tempEventStoreMap.get("datacolcode"));
			
			Crosscol tempEventCrossCol=null;
			for(Crosscol tempCrossCol:crossCols){
				if(tempEventStoreDataColCode.equals(tempCrossCol.getDimfield())){
					tempEventCrossCol=tempCrossCol;
					break;
				}
			}
			if(tempEventCrossCol==null){
				tempEventCrossCol=new Crosscol();
				crossCols.add(tempEventCrossCol);
			}
			Eventstore tempEventStore=tempEventCrossCol.getEventstore();
			if(tempEventStore==null){
				tempEventStore=new Eventstore();
				tempEventCrossCol.setEventstore(tempEventStore);
			}
			tempEventStore.setType(tempEventStoreType);
			List<Event> eventList=tempEventStore.getEventList();
			if(eventList==null){
				eventList=new ArrayList<Event>();
				tempEventStore.setEventList(eventList);
			}
			List<Map<String, Object>> tempEventMapList=null;
			if(tempEventStoreMap.get("eventList")!=null&&(!"".equals(tempEventStoreMap.get("eventList")))){
				tempEventMapList=(List<Map<String, Object>>)tempEventStoreMap.get("eventList");
			}
			if(tempEventMapList==null){
				tempEventMapList=new ArrayList<Map<String, Object>>();
			}
			
			for(Map<String, Object> tempEventMap:tempEventMapList){
				
				String tempEventMapId=String.valueOf(tempEventMap.get("id"));
				String tempEventMapSource=String.valueOf(tempEventMap.get("source"));
				String tempEventSourceShow = String.valueOf(tempEventMap.get("sourceShow"));
				String tempEventParameterShow = String.valueOf(tempEventMap.get("parameterShow"));
				if(tempEventMapId.equals("null")||tempEventMapSource.equals("null")){
					continue;
				}
				Event tempDataColEvent=null;
				for(Event tempEvent:eventList){
					if(tempEventMapId.equals(tempEvent.getId())){
						tempDataColEvent=tempEvent;
					}
				}
				if(tempDataColEvent==null){
					tempDataColEvent=new Event();
					tempDataColEvent.setId(tempEventMapId);
					eventList.add(tempDataColEvent);
				}
				tempDataColEvent.setSource(tempEventMapSource);
				List<Map<String, Object>> tempParameterMapList=null;
				if(tempEventMap.get("parameterList")!=null&&(!"".equals(tempEventMap.get("parameterList")))){
					tempParameterMapList=(List<Map<String, Object>>)tempEventMap.get("parameterList");
				}
				if(tempParameterMapList==null){
					tempParameterMapList=new ArrayList<Map<String, Object>>();
				}
				List<Parameter> parameterList=new ArrayList<Parameter>();
				tempDataColEvent.setParameterList(parameterList);
				for(Map<String, Object> tempParameterMap:tempParameterMapList){
					String parameterDimsionId=String.valueOf(tempParameterMap.get("dimsionid"));
					String parameterName=String.valueOf(tempParameterMap.get("name"));
					String parameterValue=String.valueOf(tempParameterMap.get("value"));
					Parameter parameter=new Parameter();
					parameter.setDimsionid(parameterDimsionId);
					parameter.setName(parameterName);
					parameter.setValue(parameterValue);
					parameterList.add(parameter);
				}
				
			}
			Iterator<Event> eventIterator = eventList.iterator(); 
			boolean hasExistEventFlag=false;
			while(eventIterator.hasNext()){
				Event tempEvent=eventIterator.next();
				hasExistEventFlag=false; 
				for(Map<String, Object> tempEventMap:tempEventMapList){
					if(tempEvent.getId()!=null&&tempEvent.getId().equals(String.valueOf(tempEventMap.get("id")))){
						hasExistEventFlag=true;
					}
				}
				if(!hasExistEventFlag){
					eventIterator.remove();
				}
			}
			
		}
		saveToXmlByObj(report);
		return "1";
	}
	
	
	/*取组件json数据*/
	@SuppressWarnings("unchecked")
	public String getComponentJsonData(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report reportObj=XContext.getEditView(reportId);
		if(reportObj==null){
			reportObj = readFromXmlByViewId(reportId);
		}
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		return Functions.java2json(component);
	}
	

	/*校验组件内各元素有效性
	 * @param report
	 * @param component		
	 * @return String
	 * */
	@SuppressWarnings("unchecked")
	public String validateComponent(Report report,Component component) {
		DataSetService dss=new DataSetService();
		Map selectedDataSetModel=null;
		StringBuilder stringBuilder=new StringBuilder();
		/*Component元素*/
		if(null==component){
			return "||||交叉表格：未配置表格组件。<br/>\n";
		}
		if("".equals(component.getDatasourceid())||component.getDatasourceid()==null){
			stringBuilder.append("||||交叉表格：未配置表格组件“数据源”；<br/>\n");
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
					stringBuilder.append("||||交叉表格：配置的表格组件数据源已不存在；<br/>\n");
				}
			}
			
		}
		/*datacol元素*/
		List<Datacol> datacolList=null;
		List<Crosscol> crossColList = null;
		if(null==component.getDatastore()||null==component.getDatastore().getDatacolList()||component.getDatastore().getDatacolList().size()==0){
			stringBuilder.append("||||交叉表格：未设置表格组件的指标区域；<br/>\n");
		}else{
			datacolList = component.getDatastore().getDatacolList();
		}if(null==component.getCrosscolstore()||null==component.getCrosscolstore().getCrosscolList()||component.getCrosscolstore().getCrosscolList().size()==0){
			stringBuilder.append("||||交叉表格：未设置表格组件的行维度和列维度；<br/>\n");
		}else{
			crossColList = component.getCrosscolstore().getCrosscolList();
			Boolean hasRowDimFlag = false;
			Boolean hasColDimFlag = false;
			for(Crosscol col : crossColList){
				if("1".equals(col.getType())){
					hasRowDimFlag = true;
				}else if("2".equals(col.getType())){
					hasColDimFlag = true;
				}
			}
			if(!hasRowDimFlag){
				stringBuilder.append("||||交叉表格：未设置表格组件的行维度；<br/>\n");
			}
			if(!hasColDimFlag){
				stringBuilder.append("||||交叉表格：未设置表格组件的列维度；<br/>\n");
			}
		}
		
		SortcolStore sortcolStore=component.getSortcolStore();
		if(sortcolStore==null){
			sortcolStore=new SortcolStore();
		}
		List<Sortcol> sortcolList=sortcolStore.getSortcolList();
		if(sortcolList==null){
			sortcolList=new ArrayList<Sortcol>();
		}
		if(datacolList==null){
			datacolList=new ArrayList<Datacol>();
		}
		if(sortcolList.size()>0){
			for(Datacol tempDatacol:datacolList){
				for(Sortcol tempSortcol:sortcolList){
					if(tempDatacol.getDatacolid()!=null&&tempDatacol.getDatacolid().equals(tempSortcol.getId())
							&&tempDatacol.getDatacoltype()!=null&&(!tempDatacol.getDatacoltype().equals(tempSortcol.getKpitype()))){
						stringBuilder.append("||||交叉表格：排序区域中的“"+tempSortcol.getDesc()+"”的类型不正确，应为‘指标’类型；<br/>\n");
					}
				}
			}
		}
		if(crossColList!=null){
			for(Crosscol tempDatacol : crossColList){
				for(Sortcol tempSortcol:sortcolList){
					if(tempDatacol.getDimid() !=null&&tempDatacol.getDimid() .equals(tempSortcol.getId())
							&&tempDatacol.getType()!=null&&(!"dim".equals(tempSortcol.getKpitype()))){
						stringBuilder.append("||||交叉表格：排序区域中的“"+tempSortcol.getDesc()+"”的类型不正确，应为‘维度’类型；<br/>\n");
					}
				}
			}
		}
		return stringBuilder.toString();
	}
	
	
	/**
	 * 清除单元格下动作（事件）
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String setClearMoreEvent(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Datastore datastore = component.getDatastore();
		if(datastore==null){
			datastore=new Datastore();
			component.setDatastore(datastore);
		}
		List<Datacol> datacols = datastore.getDatacolList();
		if(datacols==null){
			datacols=new ArrayList<Datacol>();
			datastore.setDatacolList(datacols);
		}
		
		List<Map<String, Object>> eventStoreMapList=null;
		if(nodeData.get("eventStoreList")!=null&&(!"".equals(nodeData.get("eventStoreList")))){
			eventStoreMapList=(List<Map<String, Object>>)nodeData.get("eventStoreList");
		}
		if(eventStoreMapList==null){
			eventStoreMapList=new ArrayList<Map<String, Object>>();
		}
		String tempEventStoreDataColCode=null;
		
		for(Map<String, Object> tempEventStoreMap:eventStoreMapList){
			tempEventStoreDataColCode=String.valueOf(tempEventStoreMap.get("datacolcode"));
			List<Map<String, Object>> tempEventMapList=null;
			if(tempEventStoreMap.get("eventList")!=null&&(!"".equals(tempEventStoreMap.get("eventList")))){
				tempEventMapList=(List<Map<String, Object>>)tempEventStoreMap.get("eventList");
			}
			for(Datacol tempDatacol:datacols){
				if(tempEventStoreDataColCode.equals(tempDatacol.getDatacolcode())){
					Eventstore eventstore=tempDatacol.getEventstore();
					if(eventstore==null){
						eventstore=new Eventstore();
						tempDatacol.setEventstore(eventstore);
					}
					if("link".equals(eventstore.getType())||tempEventMapList==null){
						tempDatacol.setEventstore(null);
						break;
					}
					List<Event> eventList=eventstore.getEventList();
					if(eventList==null){
						eventList=new ArrayList<Event>();
						eventstore.setEventList(eventList);
					}
					for(Event tempEvent:eventList){
						for(Map<String, Object> tempEventMap:tempEventMapList){
							if(tempEvent.getId().equals(String.valueOf(tempEventMap.get("id")))){
								tempEvent=null;
							}
						}
					}
				}
			}
		}
		saveToXmlByObj(report);
		return "1";
	}
	
	/**
	 * 清除单元格下动作（事件）
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String setClearRowDimEvent(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Crosscolstore crossColStore = component.getCrosscolstore();
		if(crossColStore==null){
			crossColStore=new Crosscolstore();
			component.setCrosscolstore(crossColStore);
		}
		List<Crosscol> crossCols = crossColStore.getCrosscolList();
		if(crossCols==null){
			crossCols=new ArrayList<Crosscol>();
			crossColStore.setCrosscolList(crossCols);
		}
		
		List<Map<String, Object>> eventStoreMapList=null;
		if(nodeData.get("eventStoreList")!=null&&(!"".equals(nodeData.get("eventStoreList")))){
			eventStoreMapList=(List<Map<String, Object>>)nodeData.get("eventStoreList");
		}
		if(eventStoreMapList==null){
			eventStoreMapList=new ArrayList<Map<String, Object>>();
		}
		String tempEventStoreDataColCode=null;
		
		for(Map<String, Object> tempEventStoreMap:eventStoreMapList){
			tempEventStoreDataColCode=String.valueOf(tempEventStoreMap.get("datacolcode"));
			List<Map<String, Object>> tempEventMapList=null;
			if(tempEventStoreMap.get("eventList")!=null&&(!"".equals(tempEventStoreMap.get("eventList")))){
				tempEventMapList=(List<Map<String, Object>>)tempEventStoreMap.get("eventList");
			}
			for(Crosscol tempCrosscol:crossCols){
				if(tempEventStoreDataColCode.equals(tempCrosscol.getDimfield())){
					Eventstore eventstore=tempCrosscol.getEventstore();
					if(eventstore==null){
						eventstore=new Eventstore();
						tempCrosscol.setEventstore(eventstore);
					}
					if("link".equals(eventstore.getType())||tempEventMapList==null){
						tempCrosscol.setEventstore(null);
						break;
					}
					List<Event> eventList=eventstore.getEventList();
					if(eventList==null){
						eventList=new ArrayList<Event>();
						eventstore.setEventList(eventList);
					}
					for(Event tempEvent:eventList){
						for(Map<String, Object> tempEventMap:tempEventMapList){
							if(tempEvent.getId().equals(String.valueOf(tempEventMap.get("id")))){
								tempEvent=null;
							}
						}
					}
				}
			}
		}
		saveToXmlByObj(report);
		return "1";
	}
	
	/**
	 * 保存组件属性
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String addMoreKpiStoreCols(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Datasources datasources=report.getDatasources();
		if( datasources==null){
			datasources=new Datasources();
			report.setDatasources(datasources);
		}
		List<Datasource> datasourceList=datasources.getDatasourceList();
		if( datasourceList==null){
			datasourceList=new ArrayList<Datasource>();
			datasources.setDatasourceList(datasourceList);
		}
		Kpistores kpistores=report.getKpistores();
		if(kpistores==null){
			kpistores=new Kpistores();
			report.setKpistores(kpistores);
			
		}
		List<Kpistore> kpistoreList=kpistores.getKpistoreList();
		if(kpistoreList==null){
			kpistoreList=new ArrayList<Kpistore>();
			kpistores.setKpistoreList(kpistoreList);
		}
		String datasourceId=component.getDatasourceid();
		Datasource datasource=null;
		for(Datasource tempDatasource:datasourceList){
			if(datasourceId!=null&&datasourceId.equals(tempDatasource.getId())){
				datasource=tempDatasource;
			}
		}
		if(datasource==null){
			String dataSequence = new SimpleDateFormat("yyyyMMddHHmmssSSS")
					.format(new Date());
			datasource=new Datasource();
			datasource.setId(dataSequence);
			datasource.setSql("");
			datasourceList.add(datasource);
			component.setDatasourceid(dataSequence);
		}
		String kpistoresId=datasource.getKpistoreId();
		Kpistore kpistore=null;
		for(Kpistore tempKpistore:kpistoreList){
			if(kpistoresId!=null&&kpistoresId.equals(tempKpistore.getId())){
				kpistore=tempKpistore;
			}
		}
		if(kpistore==null){
			String dataSequence = new SimpleDateFormat("yyyyMMddHHmmssSSS")
			.format(new Date());
			kpistore=new Kpistore();
			kpistore.setId(dataSequence);
			datasource.setKpistoreId(dataSequence);
			kpistoreList.add(kpistore);
			
		}
		List<KpistoreCol> kpistoreColList=new ArrayList<KpistoreCol>();
		kpistore.setKpistorecolList(kpistoreColList);
		if(nodeData.get("infoList")!=null){
			List<Map<String, Object>> propertyList=(List<Map<String,Object>>)nodeData.get("infoList");
			for(Map<String, Object> tempCol:propertyList){
				KpistoreCol kpistoreCol=new KpistoreCol();
				kpistoreCol.setKpiid(String.valueOf(tempCol.get("id")));
				kpistoreCol.setKpicolumn(String.valueOf(tempCol.get("column")));
				kpistoreCol.setKpidesc(String.valueOf(tempCol.get("name")));
				kpistoreCol.setKpitype(String.valueOf(tempCol.get("kpiType")));
				kpistoreColList.add(kpistoreCol);
			}
			
		}
		saveToXmlByObj(report);
		XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
		try {
			xdsql.setSql();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "1";
	}	
	/**
	 * 添加计算列
	 * @param nodeData
	 * @return
	 */
	public String addExtcolumn(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		
		if(report.getExtcolumns()==null){
			Extcolumns extcolumns = new Extcolumns();
			report.setExtcolumns(extcolumns);
		}if(report.getExtcolumns().getExtcolumnList()==null){
			List<Extcolumn> extcolumnList = new ArrayList<Extcolumn>(); 
			report.getExtcolumns().setExtcolumnList(extcolumnList);
		}
		Extcolumn extcolumn = new Extcolumn();
		extcolumn.setDatasourceid(String.valueOf( nodeData.get("datasourceId")));
		extcolumn.setId((""+UUID.randomUUID()).replaceAll("-", ""));
		extcolumn.setFormula(String.valueOf( nodeData.get("formula")));
		extcolumn.setFormulaid(String.valueOf( nodeData.get("formulaid")));
		extcolumn.setName(String.valueOf( nodeData.get("name")));
		List paramList = new ArrayList<Param>();
		List tempParamList = (ArrayList)nodeData.get("paramList");
		Map paramMap = null;
		for(Object paramObj : tempParamList){
			Param param = new Param();
			paramMap = (Map)paramObj;
			param.setName(String.valueOf(paramMap.get("name")));
			param.setValue(String.valueOf(paramMap.get("value")));
			paramList.add(param);
		}
		extcolumn.setParamList(tempParamList);
		report.getExtcolumns().getExtcolumnList().add(extcolumn);
		updateFormulateUseTimes("add",extcolumn.getFormulaid());
		saveToXmlByObj(report);
		return extcolumn.getId();
	}
	
	/**
	 * 添加计算列
	 * @param nodeData
	 * @return
	 */
	public String removeExtcolumn(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String extcolumnid = String.valueOf(nodeData.get("extcolumnid"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		if(report.getExtcolumns()!=null&&report.getExtcolumns().getExtcolumnList()!=null){
			List<Extcolumn> extcolumnList = report.getExtcolumns().getExtcolumnList();
			for(Extcolumn extcolumn : extcolumnList){
				if(extcolumnid.equals(extcolumn.getId())){
					extcolumnList.remove(extcolumn);
					updateFormulateUseTimes("minus",extcolumn.getFormulaid());
					break;
				}
			}
		}
		saveToXmlByObj(report);
		return "1";
	}
	
	/**
	 * 获得一个计算列
	 * @param nodeData
	 * @return
	 */
	public String getExtcolumn(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String extcolumnid = String.valueOf(nodeData.get("extcolumnid"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		String resultJSON = "";
		if(report.getExtcolumns()!=null&&report.getExtcolumns().getExtcolumnList()!=null){
			List<Extcolumn> extcolumnList = report.getExtcolumns().getExtcolumnList();
			for(Extcolumn extcolumn : extcolumnList){
				if(extcolumnid.equals(extcolumn.getId())){
					resultJSON = Functions.java2json(extcolumn);
					break;
				}
			}
		}
		return resultJSON;
	}
	
	/**
	 * 编辑计算列
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String editExtcolumn(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String extcolumnid = String.valueOf(nodeData.get("extcolumnid"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		String resultJSON = "";
		if(report.getExtcolumns()!=null&&report.getExtcolumns().getExtcolumnList()!=null){
			List<Extcolumn> extcolumnList = report.getExtcolumns().getExtcolumnList();
			for(Extcolumn extcolumn : extcolumnList){
				if(extcolumnid.equals(extcolumn.getId())){
					extcolumn.setFormula(String.valueOf( nodeData.get("formula")));
					extcolumn.setFormulaid(String.valueOf( nodeData.get("formulaid")));
					extcolumn.setName(String.valueOf( nodeData.get("name")));
					List paramList = new ArrayList<Param>();
					List tempParamList = (ArrayList)nodeData.get("paramList");
					Map paramMap = null;
					for(Object paramObj : tempParamList){
						Param param = new Param();
						paramMap = (Map)paramObj;
						param.setName(String.valueOf(paramMap.get("name")));
						param.setValue(String.valueOf(paramMap.get("value")));
						paramList.add(param);
					}
					extcolumn.setParamList(tempParamList);
					break;
				}
			}
		}
		saveToXmlByObj(report);
		return resultJSON;
	}
	
	@SuppressWarnings("deprecation")
	private String updateFormulateUseTimes(String action,String formulaId){
		String result = "0";
		String sql = "";
		Map<String,String> param=new HashMap<String, String>();
		param.put("formulaId", formulaId);
		if("add".equals(action)){
			sql = runner.sql("xbuilder.component.crossTable.updateFormulateUseTimes.add");
		}else if("minus".equals(action)){
			sql = runner.sql("xbuilder.component.crossTable.updateFormulateUseTimes.minus");
		}
		try {
			result = String.valueOf(runner.execute(sql,param));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
}