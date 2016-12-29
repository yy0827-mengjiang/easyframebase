package cn.com.easy.xbuilder.service.component;

import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.util.ArrayList;
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
import cn.com.easy.xbuilder.element.Extcolumn;
import cn.com.easy.xbuilder.element.Extcolumns;
import cn.com.easy.xbuilder.element.Kpistore;
import cn.com.easy.xbuilder.element.KpistoreCol;
import cn.com.easy.xbuilder.element.Param;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Subdirllsortcol;
import cn.com.easy.xbuilder.element.Subdirllsortcols;
import cn.com.easy.xbuilder.element.Subdrill;
import cn.com.easy.xbuilder.element.Subdrills;
import cn.com.easy.xbuilder.kpi.XDataSourceSql;

@Service
public class TreegridService extends DatagridService {
	private SqlRunner runner;
	@Override
	public String removeDatacol(Map<String, Object> nodeData) {
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
		
		if(needGenerateSqlFlag(report,component)){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setDrillSql(null);
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

	@SuppressWarnings("unchecked")
	@Override
	public String removeMoreDatacol(Map<String, Object> nodeData) {
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
		
		if(needGenerateSqlFlag(report,component)){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setDrillSql(null);
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

	@SuppressWarnings("unchecked")
	@Override
	public String setDatacolAttrs(Map<String, Object> nodeData) {
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
		
		if(needGenerateSqlFlag(report,component)){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setDrillSql(null);
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

	@SuppressWarnings("unchecked")
	@Override
	public String setMoreDatacolMoreAttrs(Map<String, Object> nodeData) {
		// TODO Auto-generated method stub
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
		
		if(needGenerateSqlFlag(report,component)){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setDrillSql(null);
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
	public String setMoreSubdrillMoreAttrs(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Subdrills subdrills=component.getSubdrills();
		if(subdrills==null){
			subdrills=new Subdrills();
			component.setSubdrills(subdrills);
		}
		List<Subdrill> subdrillList=subdrills.getSubdrillList();
		if(subdrillList==null){
			subdrillList=new ArrayList<Subdrill>();
			subdrills.setSubdrillList(subdrillList);
		}
		Subdrill subdrillCol=null;
		if(nodeData.get("infoList")!=null){
			List<Map<String, Object>> infoList=(List<Map<String,Object>>)nodeData.get("infoList");
			for(Map<String, Object> tempInfoData:infoList){
				if(tempInfoData.get("attrList")!=null){
					List<Map<String, Object>> attrList=(List<Map<String,Object>>)tempInfoData.get("attrList");
					
					for(Map<String, Object> tempAttrData:attrList){
						String attrKey = String.valueOf(tempAttrData.get("attrKey"));
						String attrValue = String.valueOf(tempAttrData.get("attrValue"));
						if("drillcolcodeid".equals(attrKey)){
							for(Subdrill tempSubdrill:subdrillList){
								if(attrValue.equals(tempSubdrill.getDrillcolcodeid())){
									subdrillCol=tempSubdrill;
									break;
								}
								
							}
							if(subdrillCol==null){
								subdrillCol=new Subdrill();
								subdrillList.add(subdrillCol);
							}
						}
						if("drillcolSortcolList".equals(attrKey)){
							List<Map<String, Object>> drillcolSortcolList=(List<Map<String,Object>>)tempAttrData.get("attrValue");
							Subdirllsortcols subdirllsortcols=new Subdirllsortcols();
							List<Subdirllsortcol> subdirllsortcolList=new ArrayList<Subdirllsortcol>();
							subdirllsortcols.setSubdirllsortcolList(subdirllsortcolList);
							subdrillCol.setSubdirllsortcols(subdirllsortcols);
							String tempSortColCode=null;
							String tempSortColType=null;
							String tempSortColExtcolumnid = null;
							for(Map<String, Object> tempSubdrillSortcolMap:drillcolSortcolList){
								tempSortColCode=String.valueOf(tempSubdrillSortcolMap.get("colcode"));
								tempSortColType=String.valueOf(tempSubdrillSortcolMap.get("sorttype"));
								tempSortColExtcolumnid=tempSubdrillSortcolMap.get("extcolumnid")==null?"":tempSubdrillSortcolMap.get("extcolumnid")+"";
								Subdirllsortcol subdirllsortcol=new Subdirllsortcol();
								subdirllsortcol.setColcode(tempSortColCode);
								subdirllsortcol.setExtcolumnid(tempSortColExtcolumnid);
								if((!("".equals(tempSortColType.toLowerCase())))&&(!("null".equals(tempSortColType.toLowerCase())))&&(!("undefined".equals(tempSortColType.toLowerCase())))){
									subdirllsortcol.setSorttype(tempSortColType);
								}
								subdirllsortcolList.add(subdirllsortcol);
								
							}
							continue;
							
						}
						try {
							BeanUtils.setProperty(subdrillCol, attrKey, attrValue);
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
		
		if(needGenerateSqlFlag(report,component)){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setDrillSql(subdrillCol==null?null:subdrillCol.getDrillcolcodeid());
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
	 * 删除多个下钻列
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String removeMoreDrillcol(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Subdrills subdrills=component.getSubdrills();
		if(subdrills==null){
			subdrills=new Subdrills();
			component.setSubdrills(subdrills);
		}
		List<Subdrill> subdrillList=subdrills.getSubdrillList();
		if(subdrillList==null){
			subdrillList=new ArrayList<Subdrill>();
			subdrills.setSubdrillList(subdrillList);
		}
		Datasources datasources=report.getDatasources();
		if(datasources==null){
			datasources=new Datasources();
			report.setDatasources(datasources);
		}
		
		List<Datasource> datasourceList=datasources.getDatasourceList();
		if(datasourceList==null){
			datasourceList=new ArrayList<Datasource>();
			datasources.setDatasourceList(datasourceList);
		}
		
		if(nodeData.get("romoveIds")!=null){
			List<String> romoveIds=(List<String>)nodeData.get("romoveIds");
			List<String> romoveDatasourceIds=new ArrayList<String>();
			Iterator<Subdrill> subdrillEleItr = subdrillList.iterator();   
			while(subdrillEleItr.hasNext()){
				Subdrill subdrill=subdrillEleItr.next();
				for(String tempColumnId:romoveIds){
					if(tempColumnId!=null&&tempColumnId.equals(subdrill.getDrillcolcodeid())){
						romoveDatasourceIds.add(subdrill.getDatasourceid());
						subdrillEleItr.remove();
						break;
					}
				}
			}
			
			if(report.getInfo()!=null&&"2".equals(report.getInfo().getType())){
				Iterator<Datasource> datasourceEleItr = datasourceList.iterator();   
				while(datasourceEleItr.hasNext()){
					Datasource datasource=datasourceEleItr.next();
					for(String tempDatasourceId:romoveDatasourceIds){
						if(tempDatasourceId.equals(datasource.getId())){
							datasourceEleItr.remove();
							break;
						}
					}
				}
			}
			
			
			
			
		}
		saveToXmlByObj(report);
		return "1";
	}
	
	/**
	 * 保存单元格多个下钻列
	 * @param nodeData
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String overWriteDrillcols(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Subdrills subdrills=component.getSubdrills();
		if(subdrills==null){
			subdrills=new Subdrills();
			component.setSubdrills(subdrills);
		}
		List<Subdrill> oldSubdrillList=subdrills.getSubdrillList();
		
		if(oldSubdrillList==null){
			oldSubdrillList=new ArrayList<Subdrill>();
		}
		
		List<Subdrill> subdrillList=new ArrayList<Subdrill>();
		subdrills.setSubdrillList(subdrillList);
		boolean hasExitFlag=false;
		if(nodeData.get("infoList")!=null){
			List<Map<String, Object>> infoList=(List<Map<String,Object>>)nodeData.get("infoList");
			for(Map<String, Object> tempInfoData:infoList){
				if(tempInfoData.get("attrList")!=null){
					List<Map<String, Object>> attrList=(List<Map<String,Object>>)tempInfoData.get("attrList");
					Subdrill subdrill=null;
					hasExitFlag=false;
					for(Map<String, Object> tempAttrData:attrList){
						String attrKey = String.valueOf(tempAttrData.get("attrKey"));
						String attrValue = String.valueOf(tempAttrData.get("attrValue"));
						for(Subdrill oldSubdrill:oldSubdrillList){
							if("drillcolcodeid".equals(attrKey)&&oldSubdrill.getDrillcolcodeid()!=null&&oldSubdrill.getDrillcolcodeid().equals(attrValue)){
								subdrill=oldSubdrill;
								hasExitFlag=true;
								break;
							}
						}
						if(hasExitFlag){
							break;
						}
					}
					
					if(!hasExitFlag){
						subdrill=new Subdrill();
					}
					subdrillList.add(subdrill);
					for(Map<String, Object> tempAttrData:attrList){
						String attrKey = String.valueOf(tempAttrData.get("attrKey"));
						String attrValue = String.valueOf(tempAttrData.get("attrValue"));
						if("drillcolSortcolList".equals(attrKey)){
							List<Map<String, Object>> drillcolSortcolList=(List<Map<String,Object>>)tempAttrData.get("attrValue");
							Subdirllsortcols subdirllsortcols=new Subdirllsortcols();
							List<Subdirllsortcol> subdirllsortcolList=new ArrayList<Subdirllsortcol>();
							subdirllsortcols.setSubdirllsortcolList(subdirllsortcolList);
							subdrill.setSubdirllsortcols(subdirllsortcols);
							String tempSortColCode=null;
							String tempSortColType=null;
							String tempSortColExtcolumnid = null;
							for(Map<String, Object> tempSubdrillSortcolMap:drillcolSortcolList){
								tempSortColCode=String.valueOf(tempSubdrillSortcolMap.get("colcode"));
								tempSortColType=String.valueOf(tempSubdrillSortcolMap.get("sorttype"));
								tempSortColExtcolumnid=tempSubdrillSortcolMap.get("extcolumnid")==null?"":tempSubdrillSortcolMap.get("extcolumnid")+"";
								Subdirllsortcol subdirllsortcol=new Subdirllsortcol();
								subdirllsortcol.setColcode(tempSortColCode);
								subdirllsortcol.setExtcolumnid(tempSortColExtcolumnid);
								if((!("".equals(tempSortColType.toLowerCase())))&&(!("null".equals(tempSortColType.toLowerCase())))&&(!("undefined".equals(tempSortColType.toLowerCase())))){
									subdirllsortcol.setSorttype(tempSortColType);
								}
								subdirllsortcolList.add(subdirllsortcol);
								
							}
							continue;
							
						}
						try {
							BeanUtils.setProperty(subdrill, attrKey, attrValue);
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
		if(needGenerateSqlFlag(report,component)){
			XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
			try {
				xdsql.setDrillSql(null);
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
	public String setOneSubdrillOneAttr(Map<String,Object> nodeData){
		String reportId=String.valueOf(nodeData.get("reportId"));
		String containerId=String.valueOf( nodeData.get("containerId"));
		String componentId = String.valueOf( nodeData.get("componentId"));
		String subdrillIndex = String.valueOf( nodeData.get("subdrillIndex"));
		String attrKey = String.valueOf( nodeData.get("attrKey"));
		String attrValue = String.valueOf( nodeData.get("attrValue"));
		Report report = XContext.getEditView(reportId);
		if(report==null) return "0";
		Component component = getOrCreateComponet(report,containerId,componentId);
		if(component==null) return "0";
		Subdrills subdrills=component.getSubdrills();
		if(subdrills==null){
			subdrills=new Subdrills();
			component.setSubdrills(subdrills);
		}
		List<Subdrill> subdrillList=subdrills.getSubdrillList();
		if(subdrillList==null){
			subdrillList=new ArrayList<Subdrill>();
			subdrills.setSubdrillList(subdrillList);
		}
		Subdrill subdrillCol=null;
		for(int i=0;i<subdrillList.size();i++){
			if(String.valueOf(i).equals(subdrillIndex)){
				subdrillCol=subdrillList.get(i);
				if("drillcolSortcolList".equals(attrKey)){
					List<Map<String, Object>> drillcolSortcolList=(List<Map<String,Object>>)nodeData.get("attrValue");
					Subdirllsortcols subdirllsortcols=new Subdirllsortcols();
					List<Subdirllsortcol> subdirllsortcolList=new ArrayList<Subdirllsortcol>();
					subdirllsortcols.setSubdirllsortcolList(subdirllsortcolList);
					subdrillCol.setSubdirllsortcols(subdirllsortcols);
					String tempSortColCode=null;
					String tempSortColKpiType=null;
					String tempSortColType=null;
					String tempSortColExtcolumnid=null;
					for(Map<String, Object> tempSubdrillSortcolMap:drillcolSortcolList){
						tempSortColCode=String.valueOf(tempSubdrillSortcolMap.get("colcode"));
						tempSortColKpiType=String.valueOf(tempSubdrillSortcolMap.get("sortkpitype"));
						tempSortColType=String.valueOf(tempSubdrillSortcolMap.get("sorttype"));
						tempSortColExtcolumnid = tempSubdrillSortcolMap.get("extcolumnid")==null?"":tempSubdrillSortcolMap.get("extcolumnid")+"";
						Subdirllsortcol subdirllsortcol=new Subdirllsortcol();
						subdirllsortcol.setColcode(tempSortColCode);
						subdirllsortcol.setSortkpitype(tempSortColKpiType);
						if((!("".equals(tempSortColType.toLowerCase())))&&(!("null".equals(tempSortColType.toLowerCase())))&&(!("undefined".equals(tempSortColType.toLowerCase())))){
							subdirllsortcol.setSorttype(tempSortColType);
						}
						subdirllsortcol.setExtcolumnid(tempSortColExtcolumnid);
						subdirllsortcolList.add(subdirllsortcol);
						
					}
					continue;
				}
				try {
					BeanUtils.setProperty(subdrillCol, attrKey, attrValue);
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				break;
			}
		}
		saveToXmlByObj(report);
		if("drillcolSortcolList".equals(attrKey)){
			if(needGenerateSqlFlag(report,component)){
				XDataSourceSql xdsql = new XDataSourceSql(report, containerId,componentId);
				try {
					xdsql.setDrillSql(subdrillCol==null?null:subdrillCol.getDrillcolcodeid());
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
		StringBuilder stringBuilder=new StringBuilder();
		/*Component元素*/
		if(null==component){
			return "||||下钻表格：未配置下钻表格组件。<br/>\n";
		}
		Subdrills subdrills=component.getSubdrills();
		if(subdrills==null){
			subdrills=new Subdrills();
			component.setSubdrills(subdrills);
		}
		List<Subdrill> subdrillList=subdrills.getSubdrillList();
		if(subdrillList==null){
			subdrillList=new ArrayList<Subdrill>();
			subdrills.setSubdrillList(subdrillList);
		}
		/*下钻区域*/
		if(subdrillList.size()==0){
			stringBuilder.append("||||下钻表格：未设置下钻表格组件的下钻区域；<br/>\n");
		}
		/*指标区域*/
		Map<String, String> datacolColumnsKpiType=new HashMap<String, String>();//检查下钻排序列时使用
		boolean hasKpiFlag=false;//是否拥有指标列标识
		List<Datacol> datacolList=null;
		if(null==component.getDatastore()||null==component.getDatastore().getDatacolList()||component.getDatastore().getDatacolList().size()==0){
			stringBuilder.append("||||下钻表格：未设置下钻表格组件的维度区域或指标区域；<br/>\n");
		}else{
			datacolList=component.getDatastore().getDatacolList();
			boolean hasDataColFlag=false;
			for(Datacol tempDataCol:datacolList){
				datacolColumnsKpiType.put(tempDataCol.getDatacolcode(), tempDataCol.getDatacoltype());
				if(tempDataCol.getDatacolid()!=null&&(!("".equals(tempDataCol.getDatacolid())))
					&&tempDataCol.getDatacolcode()!=null&&(!("".equals(tempDataCol.getDatacolcode())))
					&&tempDataCol.getDatacoldesc()!=null&&(!("".equals(tempDataCol.getDatacoldesc())))){
					hasDataColFlag=true;
				}
				if("kpi".equals(tempDataCol.getDatacoltype())){
					hasKpiFlag=true;
				}
			}
			if(!hasDataColFlag){
				stringBuilder.append("||||下钻表格：下钻表格组件配置的维度区域和指标区域无效；<br/>\n");
			}
		}
		if(!hasKpiFlag){
			stringBuilder.append("||||下钻表格：未设置下钻表格组件的指标区域；<br/>\n");
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
					stringBuilder.append("||||下钻表格：下钻表格组件配置的动态表头中，“动态类型”为查询条件时，“绑定查询条件”无效；<br/>\n");
				}
				
			}
			
		}
		
		/*headui元素*/
		if(null==component.getHeadui()||null==component.getHeadui().getText()||"".equals(component.getHeadui().getText().trim())){
			stringBuilder.append("||||下钻表格：未设置下钻表格组件的表头；<br/>\n");
		}
		
		/*下钻设置*/
		Subdrill tempSubdrill=null;
		Map<String, String> showLevelMap=new HashMap<String, String>();
		int maxShowLevel=0;
		Subdirllsortcols tempSubdirllSortcols=null;
		List<Subdirllsortcol> tempSubdirllsortcolList=null;
		for(int i=0;i<subdrillList.size();i++){
			tempSubdrill=subdrillList.get(i);
			if("".equals(tempSubdrill.getDrillcoltitle())){
				stringBuilder.append("||||下钻表格：配置的下钻表格组件“下钻名称”不能为空；<br/>\n");
			}
			if("".equals(tempSubdrill.getDrillcode())){
				stringBuilder.append("||||下钻表格：配置的下钻表格组件“约束条件”不能为空；<br/>\n");
			}
			if("".equals(tempSubdrill.getLevel())){
				stringBuilder.append("||||下钻表格：配置的下钻表格组件“显示级别”不能为空；<br/>\n");
			}else{
				showLevelMap.put(tempSubdrill.getLevel(), tempSubdrill.getLevel());
				if(maxShowLevel<Integer.parseInt(tempSubdrill.getLevel())){
					maxShowLevel=Integer.parseInt(tempSubdrill.getLevel());
				}
			}
			/*排序列*/
			tempSubdirllSortcols=tempSubdrill.getSubdirllsortcols();
			tempSubdirllsortcolList=tempSubdirllSortcols.getSubdirllsortcolList();
			if(tempSubdirllsortcolList==null||tempSubdirllsortcolList.size()==0){
				continue;
			}
			if("1".equals(report.getInfo().getType())){
				for(int a=0;a<tempSubdirllsortcolList.size();a++){
					if(tempSubdirllsortcolList.get(a)!=null&&tempSubdirllsortcolList.get(a).getSortkpitype()==null){
						if(tempSubdirllsortcolList.get(a).getColcode()!=null&&(tempSubdirllsortcolList.get(a).getColcode().equals(tempSubdrill.getDrillcolcode())||
										tempSubdirllsortcolList.get(a).getColcode().equals(tempSubdrill.getDrillcoldesc()))){
							tempSubdirllsortcolList.get(a).setSortkpitype("dim");
						}
						if(datacolColumnsKpiType.get(tempSubdirllsortcolList.get(a).getColcode())!=null){
							tempSubdirllsortcolList.get(a).setSortkpitype(datacolColumnsKpiType.get(tempSubdirllsortcolList.get(a).getColcode()));
						}
					}
					
					
					if(tempSubdirllsortcolList.get(a)!=null&&("".equals(tempSubdirllsortcolList.get(a).getSortkpitype().trim()))){
						stringBuilder.append("||||下钻表格：配置的下钻表格组件中的下钻（"+tempSubdrill.getDrillcoldesc()+"）时，下钻排序列中的指标类型未设置；<br/>\n");
					}
					
				}
			}
		}
		
		boolean showLevelSortRightFlag=true;
		for(int a=0;a<maxShowLevel;a++){
			if(showLevelMap.get(a+"")==null){
				showLevelSortRightFlag=false;
			}
		}
		if(!showLevelSortRightFlag){
			stringBuilder.append("||||下钻表格：配置的下钻表格组件“显示级别”出现断档，会导致部分下钻不能钻取；<br/>\n");
			
		}
		
		/*下钻格式*/
		if(component.getFieldwidth()==null||component.getFieldwidth().equals("")){
			stringBuilder.append("||||下钻表格：配置的下钻表格组件“宽度”不能为空；<br/>\n");
		}
		if("1".equals(component.getHastotalflag())){
			if(component.getTotalcode()==null||component.getTotalcode().equals("")){
				stringBuilder.append("||||下钻表格：配置的下钻表格组件“汇总编码”不能为空；<br/>\n");
			}
			if(component.getTotaltitle()==null||component.getTotaltitle().equals("")){
				stringBuilder.append("||||下钻表格：配置的下钻表格组件“汇总名称”不能为空；<br/>\n");
			}
		}
		
		return stringBuilder.toString();
	}
	
	
	public boolean needGenerateSqlFlag(Report report,Component component){
		boolean resultFlag=false;
		if("2".equals(report.getInfo().getType())){
			Datastore datastore=component.getDatastore();
			if(datastore==null){
				return resultFlag;
			}
			List<Datacol> datacolList=datastore.getDatacolList();
			if(datacolList==null){
				return resultFlag;
			}
			Subdrills subdrills=component.getSubdrills();
			if(subdrills==null){
				return resultFlag;
			}
			List<Subdrill> subdrillList=subdrills.getSubdrillList();
			if(subdrillList==null){
				return resultFlag;
			}
			boolean kpiExitFlag=false;
			boolean subdrillExitFlag=false;
			for(Datacol tempDatacol:datacolList){
				if("kpi".equals(tempDatacol.getDatacoltype())){
					kpiExitFlag=true;
					break;
				}
			}
			if(subdrillList.size()>0){
				subdrillExitFlag=true;
			}
			
			if(kpiExitFlag&&subdrillExitFlag){
				resultFlag=true;
			}
		}
		return resultFlag;
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
			sql = runner.sql("xbuilder.component.treegrid.updateFormulateUseTimes.add");
		}else if("minus".equals(action)){
			sql = runner.sql("xbuilder.component.treegrid.updateFormulateUseTimes.minus");
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
        						break;
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