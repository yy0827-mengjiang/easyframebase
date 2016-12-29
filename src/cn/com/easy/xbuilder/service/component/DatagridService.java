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
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Datasources;
import cn.com.easy.xbuilder.element.Datastore;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Dimsions;
import cn.com.easy.xbuilder.element.Dynheadcol;
import cn.com.easy.xbuilder.element.Dynheadstore;
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

@Service
public class DatagridService extends ComponentBaseService {
	
	private SqlRunner runner;
	
	public static void main(String[] args) throws Exception{
		Map<Integer,String> numLetterMap=new HashMap<Integer,String>();
		Map<String,Integer> letterNumMap=new HashMap<String, Integer>();
		String thHeadStrArray[]={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
		for(int x=1;x<=thHeadStrArray.length;x++){
			numLetterMap.put(x, thHeadStrArray[x-1]);
			letterNumMap.put(thHeadStrArray[x-1],x);
		}
		for(int i=1;i<=5;i++){
			for(int j=1;j<=thHeadStrArray.length;j++){
				numLetterMap.put(thHeadStrArray.length*i+j, thHeadStrArray[i-1]+thHeadStrArray[j-1]);
				letterNumMap.put(thHeadStrArray[i-1]+thHeadStrArray[j-1],thHeadStrArray.length*i+j);
			}
		}
	}
	
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
	 * 保存多个动态单元格多个属性
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String setMoreDynheadcolMoreAttrs(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Dynheadstore dynheadstore = component.getDynheadstore();
		if(dynheadstore==null){
			dynheadstore=new Dynheadstore();
			component.setDynheadstore(dynheadstore);
		}
		List<Dynheadcol> dynheadcols = dynheadstore.getDynheadcolList();
		if(dynheadcols==null){
			dynheadcols=new ArrayList<Dynheadcol>();
			dynheadstore.setDynheadcolList(dynheadcols);
		}
		List<Map<String, Object>> dynHeadColsList=null;
		if(nodeData.get("dynHeadCols")!=null&&(!"".equals(nodeData.get("dynHeadCols")))){
			dynHeadColsList=(List<Map<String, Object>>)nodeData.get("dynHeadCols");
		}
		if(dynHeadColsList==null){
			dynHeadColsList=new ArrayList<Map<String, Object>>();
		}
		for(Map<String, Object> tempDataCol:dynHeadColsList){
			Dynheadcol dynheadcol=null;
			if(tempDataCol.get("dynHeadColId")!=null){
				for (Dynheadcol dynheadcolEle : dynheadcols) {
					if (dynheadcolEle.getId().equals(String.valueOf(tempDataCol.get("dynHeadColId")))) {
						dynheadcol = dynheadcolEle;
					}
				}
				if(dynheadcol==null){
					dynheadcol=new Dynheadcol();
					dynheadcols.add(dynheadcol);
				}
				
			}
				
			if(tempDataCol.get("dynHeadColAttrs")!=null){
				List<Map<String, Object>> dynHeadColAttrsList=(List<Map<String,Object>>)tempDataCol.get("dynHeadColAttrs");
				if(dynHeadColAttrsList!=null&&dynHeadColAttrsList.size()>0){
					for(Map<String, Object> tempCol:dynHeadColAttrsList){
						String attrKey = String.valueOf(tempCol.get("attrKey"));
						String attrValue = String.valueOf(tempCol.get("attrValue"));
						try {
							BeanUtils.setProperty(dynheadcol, attrKey, attrValue);
						} catch (IllegalAccessException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (InvocationTargetException e) {
							// TODO Auto-generated catch block
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
	 * 删除多个动态单元格多个属性
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String removeMoreDynheadcol(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Dynheadstore dynheadstore = component.getDynheadstore();
		if(dynheadstore==null){
			dynheadstore=new Dynheadstore();
			component.setDynheadstore(dynheadstore);
		}
		List<Dynheadcol> dynheadcols = dynheadstore.getDynheadcolList();
		if(dynheadcols==null){
			dynheadcols=new ArrayList<Dynheadcol>();
			dynheadstore.setDynheadcolList(dynheadcols);
		}
		List<Map<String, Object>> dynHeadColsList=null;
		if(nodeData.get("dynHeadCols")!=null&&(!"".equals(nodeData.get("dynHeadCols")))){
			dynHeadColsList=(List<Map<String, Object>>)nodeData.get("dynHeadCols");
		}
		if(dynHeadColsList==null){
			dynHeadColsList=new ArrayList<Map<String, Object>>();
		}
		for(Map<String, Object> tempDataCol:dynHeadColsList){
			if(tempDataCol.get("dynHeadColId")!=null){
				Iterator<Dynheadcol> dynheadcolEleItr = dynheadcols.iterator();   
				while(dynheadcolEleItr.hasNext()){
					Dynheadcol dynheadcol=dynheadcolEleItr.next();
					if (dynheadcol.getId().equals(String.valueOf(tempDataCol.get("dynHeadColId")))) {
						dynheadcolEleItr.remove();
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
		if("tablesetsum".equals(attrKey)||"tableshowtotal".equals(attrKey)||"tableshowtotalposition".equals(attrKey)){//设置聚合
			boolean setSqlFlag=true;
			if(report.getKpistores()==null||report.getKpistores().getKpistoreList()==null){
				setSqlFlag=false;
			}
			if(setSqlFlag){
				XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
				try {
					xdsql.setSql();
				} catch (InstantiationException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (ClassNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
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
				if("sortcolid".equals(attrKey)){//设置排序时，更新sql标识
				}
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
	 * 删除多个排序单元格
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String removeMoreSortcol(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		SortcolStore sortcolStore=component.getSortcolStore();
		if(sortcolStore==null){
			sortcolStore=new SortcolStore();
			component.setSortcolStore(sortcolStore);
		}
		List<Sortcol> sortcolList=sortcolStore.getSortcolList();
		if(sortcolList==null){
			sortcolList=new ArrayList<Sortcol>();
			sortcolStore.setSortcolList(sortcolList);
		}
		if(nodeData.get("romoveIds")!=null){
			List<String> romoveIds=(List<String>)nodeData.get("romoveIds");
			Iterator<Sortcol> sortcolEleItr = sortcolList.iterator();   
			String sortcolId = "";
			while(sortcolEleItr.hasNext()){
				Sortcol sortcol=sortcolEleItr.next();
				sortcolId = sortcol.getId().isEmpty() ? sortcol.getExtcolumnid() : sortcol.getId();
				for(String tempColumnId:romoveIds){
					if(tempColumnId.equals(sortcolId)){
						sortcolEleItr.remove();
						break;
					}
				}
			}
			
			
		}
		saveToXmlByObj(report);
		boolean setSqlFlag=true;
		if(report.getKpistores()==null||report.getKpistores().getKpistoreList()==null){
			setSqlFlag=false;
		}
		if(setSqlFlag){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setSql();
			} catch (InstantiationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return "1";
	}
	
	/**
	 * 保存单元格多个排序单元格
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String overWriteSortcols(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		SortcolStore sortcolStore=component.getSortcolStore();
		if(sortcolStore==null){
			sortcolStore=new SortcolStore();
			component.setSortcolStore(sortcolStore);
		}
		
		List<Sortcol> sortcolList=new ArrayList<Sortcol>();
		sortcolStore.setSortcolList(sortcolList);
		if(nodeData.get("infoList")!=null){
			List<Map<String, Object>> infoList=(List<Map<String,Object>>)nodeData.get("infoList");
			for(Map<String, Object> tempInfoData:infoList){
				if(tempInfoData.get("attrList")!=null){
					List<Map<String, Object>> attrList=(List<Map<String,Object>>)tempInfoData.get("attrList");
					Sortcol sortcol=new Sortcol();
					sortcolList.add(sortcol);
					for(Map<String, Object> tempAttrData:attrList){
						String attrKey = String.valueOf(tempAttrData.get("attrKey"));
						String attrValue = String.valueOf(tempAttrData.get("attrValue"));
						try {
							BeanUtils.setProperty(sortcol, attrKey, attrValue);
						} catch (IllegalAccessException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (InvocationTargetException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}
			}
			
		}
		saveToXmlByObj(report);
		boolean setSqlFlag=true;
		if(report.getKpistores()==null||report.getKpistores().getKpistoreList()==null){
			setSqlFlag=false;
		}
		if(setSqlFlag){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setSql();
			} catch (InstantiationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return "1";
	}
	

	
	/**
	 * 保存单元格多个属性
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String setDatacolAttrs(Map<String,Object> nodeData){
		boolean setSqlFlag=false;
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		String tableRowCode = String.valueOf( nodeData.get("tablerowcode"));
		String tableColCode=String.valueOf( nodeData.get("tablecolcode"));
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
		Datacol datacol=null;
		for (Datacol datacolEle : datacols) {
			if (tableRowCode.equals(datacolEle.getTablerowcode()) && tableColCode.equals(datacolEle.getTablecolcode())) {
				datacol = datacolEle;
			}
		}
		if(datacol==null){
			setSqlFlag=true;
			datacol=new Datacol();
			datacol.setTablerowcode(tableRowCode);
			datacol.setTablecolcode(tableColCode);
			datacols.add(datacol);
		}
		if(nodeData.get("infoList")!=null){
			List<Map<String, Object>> propertyList=(List<Map<String,Object>>)nodeData.get("infoList");
			for(Map<String, Object> tempCol:propertyList){
				String attrKey = String.valueOf(tempCol.get("attrKey"));
				String attrValue = String.valueOf(tempCol.get("attrValue"));
				try {
					BeanUtils.setProperty(datacol, attrKey, attrValue);
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
		}
		saveToXmlByObj(report);
		if(report.getKpistores()==null||report.getKpistores().getKpistoreList()==null){
			setSqlFlag=false;
		}
		if(setSqlFlag){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setSql();
			} catch (InstantiationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		
		return "1";
	}
	

	
	/**
	 * 保存多个单元格多个属性
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String setMoreDatacolMoreAttrs(Map<String,Object> nodeData){
		boolean setSqlFlag=false;
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
		String tempDataColRowCode="";//tablerowcode
		String tempDataColColCode="";//tablecolcode
		for(Map<String, Object> tempDataCol:dataColsList){
			tempDataColRowCode=String.valueOf(tempDataCol.get("tablerowcode"));
			tempDataColColCode=String.valueOf(tempDataCol.get("tablecolcode"));
			if(tempDataCol.get("dataColAttrs")!=null){
				List<Map<String, Object>> dataColAttrsList=(List<Map<String,Object>>)tempDataCol.get("dataColAttrs");
				if(dataColAttrsList!=null&&dataColAttrsList.size()>0){
					Datacol datacol=null;
					for (Datacol datacolEle : datacols) {
						if (tempDataColRowCode.equals(datacolEle.getTablerowcode()) && tempDataColColCode.equals(datacolEle.getTablecolcode())) {
							datacol = datacolEle;
						}
					}
					if(datacol==null){
						setSqlFlag=true;////新增指标列时，更新sql标识
						datacol=new Datacol();
						datacol.setTablerowcode(tempDataColRowCode);
						datacol.setTablecolcode(tempDataColColCode);
						datacols.add(datacol);
					}
					for(Map<String, Object> tempCol:dataColAttrsList){
						String attrKey = String.valueOf(tempCol.get("attrKey"));
						String attrValue = String.valueOf(tempCol.get("attrValue"));
						try {
							BeanUtils.setProperty(datacol, attrKey, attrValue);
						} catch (IllegalAccessException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (InvocationTargetException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}
				
				
			}
		}
		saveToXmlByObj(report);
		if(report.getKpistores()==null||report.getKpistores().getKpistoreList()==null){
			setSqlFlag=false;
		}
		if(setSqlFlag){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setSql();
			} catch (InstantiationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return "1";
	}
	
	
	/**
	 * 横向移动数据列(维度、指标)位置
	 * @param nodeData{
	 * 		reportId	报表id
	 * 		containerId 容器id
	 * 		componentId	组件id
	 * 		rowcode 	行位置
	 * 		colcode 	原来的列位置
	 * 		insertcolcode 新（插入）的列位置
	 * 	}
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String moveDatacolColPosition(Map<String,Object> nodeData){
		Map<Integer,String> numLetterMap=new HashMap<Integer,String>();
		Map<String,Integer> letterNumMap=new HashMap<String, Integer>();
		String thHeadStrArray[]={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
		for(int x=1;x<=thHeadStrArray.length;x++){
			numLetterMap.put(x, thHeadStrArray[x-1]);
			letterNumMap.put(thHeadStrArray[x-1],x);
		}
		for(int i=1;i<=thHeadStrArray.length;i++){
			for(int j=1;j<=thHeadStrArray.length;j++){
				numLetterMap.put(thHeadStrArray.length*i+j, thHeadStrArray[i-1]+thHeadStrArray[j-1]);
				letterNumMap.put(thHeadStrArray[i-1]+thHeadStrArray[j-1],thHeadStrArray.length*i+j);
			}
		}
		
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf(nodeData.get("componentId"));
		
		String rowCode=String.valueOf( nodeData.get("tablerowcode"));
		String colCode = String.valueOf( nodeData.get("tablecolcode"));
		String insertColCode = String.valueOf( nodeData.get("inserttablecolcode"));
		int colCodeNum=Integer.valueOf(letterNumMap.get(colCode)).intValue();
		int insertColCodeNum=Integer.valueOf(letterNumMap.get(insertColCode)).intValue();
		
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
		int tempColNum=0;
		if(insertColCodeNum>colCodeNum){
			for (Datacol datacolEle : datacols) {
				if (rowCode.equals(datacolEle.getTablerowcode())) {
					tempColNum=letterNumMap.get(datacolEle.getTablecolcode()).intValue();
					if(tempColNum>colCodeNum&&tempColNum<=insertColCodeNum){
						datacolEle.setTablecolcode(numLetterMap.get(tempColNum-1));
					}else if(tempColNum==colCodeNum){
						datacolEle.setTablecolcode(numLetterMap.get(insertColCodeNum));
					}
					
					
				}
			}
		}else if(insertColCodeNum<colCodeNum){
			for (Datacol datacolEle : datacols) {
				if (rowCode.equals(datacolEle.getTablerowcode())) {
					tempColNum=letterNumMap.get(datacolEle.getTablecolcode()).intValue();
					if(tempColNum>=insertColCodeNum&&tempColNum<colCodeNum){
						datacolEle.setTablecolcode(numLetterMap.get(tempColNum+1));
					}else if(tempColNum==colCodeNum){
						datacolEle.setTablecolcode(numLetterMap.get(insertColCodeNum));
					}
					
				}
			}
		}
		
		saveToXmlByObj(report);
		return "1";
	}
	/**
	 * 删除数据列(维度、指标)
	 * @param nodeData{
	 * 		reportId	报表id
	 * 		containerId 容器id
	 * 		componentId	组件id
	 * 		tablecolcode 列位置
	 * 	}
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String removeDatacol(Map<String,Object> nodeData){
		boolean setSqlFlag=true;
		Map<Integer,String> numLetterMap=new HashMap<Integer,String>();
		Map<String,Integer> letterNumMap=new HashMap<String, Integer>();
		String thHeadStrArray[]={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
		for(int x=1;x<=thHeadStrArray.length;x++){
			numLetterMap.put(x, thHeadStrArray[x-1]);
			letterNumMap.put(thHeadStrArray[x-1],x);
		}
		for(int i=1;i<=thHeadStrArray.length;i++){
			for(int j=1;j<=thHeadStrArray.length;j++){
				numLetterMap.put(thHeadStrArray.length*i+j, thHeadStrArray[i-1]+thHeadStrArray[j-1]);
				letterNumMap.put(thHeadStrArray[i-1]+thHeadStrArray[j-1],thHeadStrArray.length*i+j);
			}
		}
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf(nodeData.get("componentId"));
		String colCode = String.valueOf( nodeData.get("tablecolcode"));
		int colCodeNum=Integer.valueOf(letterNumMap.get(colCode)).intValue();
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
		int tempColNum=0;
		Iterator<Datacol> datacolEleItr = datacols.iterator();   
		while(datacolEleItr.hasNext()){
			Datacol datacolEle=datacolEleItr.next();
			tempColNum=letterNumMap.get(datacolEle.getTablecolcode()).intValue();
			if (tempColNum>colCodeNum) {
				datacolEle.setTablecolcode(numLetterMap.get(tempColNum-1));
			}else if(tempColNum==colCodeNum){
				datacolEleItr.remove();
			}
		}
		saveToXmlByObj(report);
		if(report.getKpistores()==null||report.getKpistores().getKpistoreList()==null){
			setSqlFlag=false;
		}
		if(setSqlFlag){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setSql();
			} catch (InstantiationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return "1";
	}
	/**
	 * 删除数据列(维度、指标)
	 * @param nodeData{
	 * 		reportId	报表id
	 * 		containerId 容器id
	 * 		componentId	组件id
	 * 		tablecolcode 列位置
	 * 	}
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String removeMoreDatacol(Map<String,Object> nodeData){
		boolean setSqlFlag=true;
		Map<Integer,String> numLetterMap=new HashMap<Integer,String>();
		Map<String,Integer> letterNumMap=new HashMap<String, Integer>();
		String thHeadStrArray[]={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
		for(int x=1;x<=thHeadStrArray.length;x++){
			numLetterMap.put(x, thHeadStrArray[x-1]);
			letterNumMap.put(thHeadStrArray[x-1],x);
		}
		for(int i=1;i<=thHeadStrArray.length;i++){
			for(int j=1;j<=thHeadStrArray.length;j++){
				numLetterMap.put(thHeadStrArray.length*i+j, thHeadStrArray[i-1]+thHeadStrArray[j-1]);
				letterNumMap.put(thHeadStrArray[i-1]+thHeadStrArray[j-1],thHeadStrArray.length*i+j);
			}
		}
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf(nodeData.get("componentId"));
		List<String> colCodeArray = null;//String.valueOf( nodeData.get("colCodeArray"));
		if(nodeData.get("colCodeArray")!=null){
			colCodeArray=(List<String>)nodeData.get("colCodeArray");
		}
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
		for(String colCode:colCodeArray){
			int colCodeNum=Integer.valueOf(letterNumMap.get(colCode)).intValue();
			int tempColNum=0;
			Iterator<Datacol> datacolEleItr = datacols.iterator();   
			while(datacolEleItr.hasNext()){
				Datacol datacolEle=datacolEleItr.next();
				tempColNum=letterNumMap.get(datacolEle.getTablecolcode()).intValue();
				if (tempColNum>colCodeNum) {
					datacolEle.setTablecolcode(numLetterMap.get(tempColNum-1));
				}else if(tempColNum==colCodeNum){
					datacolEleItr.remove();
				}
			}
			
		}
		
		saveToXmlByObj(report);
		if(report.getKpistores()==null||report.getKpistores().getKpistoreList()==null){
			setSqlFlag=false;
		}
		if(setSqlFlag){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setSql();
			} catch (InstantiationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
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

		return "1";
	}	
	
	/*取组件json数据*/
	@SuppressWarnings("unchecked")
	public String getComponentJsonData(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		return Functions.java2json(component);
	}
	
	
	/**
	 * 保存多个单元格多个属性
	 * @param nodeData
	 * {
	 * 	"reportId":"reportId1",
	 * 	"containerId":"containerId1",
	 * 	"componentId":"componentId1",
	 *  "eventStoreList":[
	 *  	{
	 *  		"type":"link",
	 *  		"tablerowcode":"1",
	 *  		"tablecolcode":"B",
	 *  		"eventList":[
	 *  			{
	 *  				"id":"aa",
	 *  				"source":"bb",
	 *  				"parameterList":[
	 *  					{
	 *  						"dimsionid":"dimsionid1",
	 *  						"name":"name1",
	 *  						"value":"COLUMN1"
	 *  					}
	 *  				]
	 *  			}
	 *  		]
	 *  	}
	 *  ]
	 * }
	 * @return
	 */
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
		String tempEventStoreDataColRowCode=null;
		String tempEventStoreDataColColCode=null;
		for(Map<String, Object> tempEventStoreMap:eventStoreMapList){
			
			tempEventStoreType=String.valueOf(tempEventStoreMap.get("type"));
			tempEventStoreDataColRowCode=String.valueOf(tempEventStoreMap.get("tablerowcode"));
			tempEventStoreDataColColCode=String.valueOf(tempEventStoreMap.get("tablecolcode"));
			
			Datacol tempEventStoreDataCol=null;
			for(Datacol tempDatacol:datacols){
				if(tempEventStoreDataColRowCode.equals(tempDatacol.getTablerowcode())&&tempEventStoreDataColColCode.equals(tempDatacol.getTablecolcode())){
					tempEventStoreDataCol=tempDatacol;
				}
			}
			if(tempEventStoreDataCol==null){
				tempEventStoreDataCol=new Datacol();
				tempEventStoreDataCol.setTablerowcode(tempEventStoreDataColRowCode);
				tempEventStoreDataCol.setTablecolcode(tempEventStoreDataColColCode);
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
		String tempEventStoreDataColRowCode=null;
		String tempEventStoreDataColColCode=null;
		
		for(Map<String, Object> tempEventStoreMap:eventStoreMapList){
			
			tempEventStoreDataColRowCode=String.valueOf(tempEventStoreMap.get("tablerowcode"));
			tempEventStoreDataColColCode=String.valueOf(tempEventStoreMap.get("tablecolcode"));
			List<Map<String, Object>> tempEventMapList=null;
			if(tempEventStoreMap.get("eventList")!=null&&(!"".equals(tempEventStoreMap.get("eventList")))){
				tempEventMapList=(List<Map<String, Object>>)tempEventStoreMap.get("eventList");
			}
			for(Datacol tempDatacol:datacols){
				if(tempEventStoreDataColRowCode.equals(tempDatacol.getTablerowcode())&&tempEventStoreDataColColCode.equals(tempDatacol.getTablecolcode())){
					Eventstore eventstore=tempDatacol.getEventstore();
					if(eventstore==null){
						eventstore=new Eventstore();
						tempDatacol.setEventstore(eventstore);
					}
					if("link".equals(eventstore.getType())||tempEventMapList==null){//类型为链接（只有一个事件）或未指定要删除哪个事件
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
	/*校验组件内各元素有效性
	 * @param reportId
	 * @param containerId		
	 * @param componentId		
	 * @return String
	 * */
	public String validateComponentById(String reportId,String containerId,String componentId){
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		return validateComponent(reportObj,component);
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
			return "||||普通表格：未配置表格组件。<br/>\n";
		}
		if("".equals(component.getDatasourceid())||component.getDatasourceid()==null){
			stringBuilder.append("||||普通表格：未配置表格组件“数据源”；<br/>\n");
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
					stringBuilder.append("||||普通表格：表格组件配置的数据源已不存在；<br/>\n");
				}
			}
			
		}
		/*datacol元素*/
		boolean hasKpiFlag=false;//是否拥有指标列标识
		boolean hasDimFlag=false;//是否拥有维度列标识
		List<Datacol> datacolList=null;
		if(null==component.getDatastore()||null==component.getDatastore().getDatacolList()||component.getDatastore().getDatacolList().size()==0){
			stringBuilder.append("||||普通表格：未设置表格组件的维度区域或指标区域；<br/>\n");
		}else{
			datacolList=component.getDatastore().getDatacolList();
			boolean hasDataColFlag=false;
			for(Datacol tempDataCol:datacolList){
				if(tempDataCol.getDatacolid()!=null&&(!("".equals(tempDataCol.getDatacolid())))
					&&tempDataCol.getDatacolcode()!=null&&(!("".equals(tempDataCol.getDatacolcode())))
					&&tempDataCol.getDatacoldesc()!=null&&(!("".equals(tempDataCol.getDatacoldesc())))){
					hasDataColFlag=true;
				}
				if("kpi".equals(tempDataCol.getDatacoltype())){
					hasKpiFlag=true;
				}
				if("dim".equals(tempDataCol.getDatacoltype())){
					hasDimFlag=true;
				}
			}
			if(!hasDataColFlag){
				stringBuilder.append("||||普通表格：表格组件配置的维度区域和指标区域无效；<br/>\n");
			}
			
		}
		if(!hasKpiFlag){
			stringBuilder.append("||||普通表格：未设置表格组件的指标区域；<br/>\n");
		}
		if(!hasDimFlag){
			stringBuilder.append("||||普通表格：未设置表格组件的维度区域；<br/>\n");
		}
		/*Dynheadcol元素*/
		Dynheadstore dynheadstore=component.getDynheadstore();
		if(dynheadstore==null){
			dynheadstore=new Dynheadstore();
		}
		List<Dynheadcol> dynheadcolList=dynheadstore.getDynheadcolList();
		if(dynheadcolList==null){
			dynheadcolList=new ArrayList<Dynheadcol>();
		}
		Dimsions dimsions=report.getDimsions();
		if (dimsions==null) {
			dimsions=new Dimsions();
		}
		List<Dimsion> dimsionsList=dimsions.getDimsionList();
		if(dimsionsList==null){
			dimsionsList=new ArrayList<Dimsion>();
		}
		boolean existIndimsionFlag=false;
		for(Dynheadcol tempDynheadcol:dynheadcolList){
			if("2".equals(tempDynheadcol.getBindingtype())){
				existIndimsionFlag=false;
				for(Dimsion tempDimsion:dimsionsList){
					if("0".equals(tempDimsion.getIsparame())&&("DAY".equals(tempDimsion.getType())||"MONTH".equals(tempDimsion.getType()))){
						if(tempDynheadcol.getDimsionname()!=null&&(!(tempDynheadcol.getDimsionname().equals("")))&&tempDynheadcol.getDimsionname().equals(tempDimsion.getVarname())){
							existIndimsionFlag=true;
							break;
						}
						
					}
				}
				if(!existIndimsionFlag){
					stringBuilder.append("||||普通表格：表格组件配置的动态表头中，“动态类型”为查询条件时，“绑定查询条件”无效；<br/>\n");
				}
				
			}
			
		}
		
		/*headui元素*/
		if(null==component.getHeadui()||null==component.getHeadui().getText()||"".equals(component.getHeadui().getText().trim())){
			stringBuilder.append("||||普通表格：未设置表格组件的表头；<br/>\n");
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
						stringBuilder.append("||||普通表格：组件配置的维度区域中的“"+tempSortcol.getDesc()+"”的类型不正确；<br/>\n");
					}
					
				}
				
			}
			
		}
		return stringBuilder.toString();
	}
	
	/**
	 * 保存单元格多个排序单元格
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String setMoreSortcolMoreAttrs(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		SortcolStore sortcolStore=component.getSortcolStore();
		if(sortcolStore==null){
			sortcolStore=new SortcolStore();
			component.setSortcolStore(sortcolStore);
		}
		List<Sortcol> sortcolList=sortcolStore.getSortcolList();
		if(sortcolList==null){
			sortcolList=new ArrayList<Sortcol>();
			sortcolStore.setSortcolList(sortcolList);
		}
		if(nodeData.get("infoList")!=null){
			List<Map<String, Object>> infoList=(List<Map<String,Object>>)nodeData.get("infoList");
			for(Map<String, Object> tempInfoData:infoList){
				if(tempInfoData.get("attrList")!=null){
					List<Map<String, Object>> attrList=(List<Map<String,Object>>)tempInfoData.get("attrList");
					Sortcol sortcol=null;
					
					for(Map<String, Object> tempAttrData:attrList){
						String attrKey = String.valueOf(tempAttrData.get("attrKey"));
						String attrValue = String.valueOf(tempAttrData.get("attrValue"));
						if("id".equals(attrKey)&&!"".equals(attrValue)){
							for(Sortcol tempSortcol:sortcolList){
								if(attrValue.equals(tempSortcol.getId())){
									sortcol=tempSortcol;
									break;
								}
								
							}
						}
						if("extcolumnid".equals(attrKey)&&!"".equals(attrValue)){
							for(Sortcol tempSortcol:sortcolList){
								if(attrValue.equals(tempSortcol.getExtcolumnid())){
									sortcol=tempSortcol;
									break;
								}
							}
						}
						if(sortcol==null){
							sortcol=new Sortcol();
							sortcolList.add(sortcol);
						}
						try {
							if("newid".equals(attrKey)){
								sortcol.setId(attrValue);
							}else{
								BeanUtils.setProperty(sortcol, attrKey, attrValue);
							}
						} catch (IllegalAccessException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (InvocationTargetException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}
			}
			
		}
		saveToXmlByObj(report);
		
		boolean setSqlFlag=true;
		if(report.getKpistores()==null||report.getKpistores().getKpistoreList()==null){
			setSqlFlag=false;
		}
		if(setSqlFlag){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setSql();
			} catch (InstantiationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
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
					super.removeKpiStoreCol(reportId , extcolumnid);
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
			sql = runner.sql("xbuilder.component.datagrid.updateFormulateUseTimes.add");
		}else if("minus".equals(action)){
			sql = runner.sql("xbuilder.component.datagrid.updateFormulateUseTimes.minus");
		}
		try {
			result = String.valueOf(runner.execute(sql,param));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 更新kpiStoreCol
	 * @param nodeData
	 * @return
	 */
	public String updateKpiStoreCol(Map<String,Object> nodeData){
		String result = "1";
        try{
        	Report reportObj=XContext.getEditView(nodeData.get("reportId")+"");
        	Map kpiMap = (Map)nodeData.get("kpiMap");
    		if(reportObj.getKpistores()!=null&&reportObj.getKpistores().getKpistoreList()!=null){
    			List<Kpistore> kpiStoreList = reportObj.getKpistores().getKpistoreList();
    			for(Kpistore kpistore : kpiStoreList){
    				List<KpistoreCol> storeColList = kpistore.getKpistorecolList();
    				if(storeColList!=null){
    					for(KpistoreCol col : storeColList){
        					if(col.getKpiid().equals(kpiMap.get("extcolumnid"))){
        						col.setKpidesc(kpiMap.get("tablecoldesc")+"");
        					}
        				}
    				}
    			}
    			saveToXmlByObj(reportObj);
    		}
        }catch(Exception e){
        	result = "0";
        	e.printStackTrace();
        }
		return result;
	}
}