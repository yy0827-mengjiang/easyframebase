package cn.com.easy.xbuilder.service.component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Components;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Containers;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Kpi;
import cn.com.easy.xbuilder.element.Kpistore;
import cn.com.easy.xbuilder.element.KpistoreCol;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Sortcol;
import cn.com.easy.xbuilder.element.Subdirllsortcol;
import cn.com.easy.xbuilder.element.Subdrill;
import cn.com.easy.xbuilder.element.XAxis;
import cn.com.easy.xbuilder.element.YAxis;
import cn.com.easy.xbuilder.kpi.XDataSourceSql;
import cn.com.easy.xbuilder.service.XBaseService;


public class ComponentBaseService extends XBaseService{
	
	/*	描述：从报表对象实例中读取或创建组件对象实例
	 *  参数：
	 *  	report 报表对象实例
	 *  	componentId 组件id
	 *  返回值：组件对象实例
	 * */
	public Component getOrCreateComponet(Report report,String containerId,String componentId) {
		Component component=null;
		Containers containers=report.getContainers();
		if(containers==null){
			containers=new Containers();
			report.setContainers(containers);
		}
		List<Container> containerList=containers.getContainerList();
		if(containerList==null){
			containerList=new ArrayList<Container>();
			containers.setContainerList(containerList);
			
		}
		for(Container tempContainer:containerList){
			if(tempContainer.getId()==null||(!(tempContainer.getId().equals(containerId)))){
				continue;
				
			}
			Components components =tempContainer.getComponents();
			if(components==null){
				components=new Components();
				tempContainer.setComponents(components);
			}
			List<Component> componentList=components.getComponentList();
			if(componentList==null){
				componentList=new ArrayList<Component>();
				components.setComponentList(componentList);
				
			}
			for(Component tempComponet:componentList){
				if(componentId.equals(tempComponet.getId())){
					component=tempComponet;
					break;
				}
			}
			if(component==null){
				component=new Component();
				component.setId(componentId);
				componentList.add(component);
			}
		}
		
		component.setKpiColMap(getComponentKpiColMap(report,component));
		return component;
	}
	/**
	 * 将组件选择的指标库信息转成Map
	 * @param report
	 * @param component
	 * @return
	 */
	public Map<String,Object> getComponentKpiColMap(Report report,Component component){
		Map<String,Object> kpiColMap = new HashMap<String,Object>();
		if(component.getDatasourceid()!=null&&!"".equals(component.getDatasourceid())){
			if(report.getDatasources()!=null&&report.getDatasources().getDatasourceList()!=null){
				List<Datasource> dsList = report.getDatasources().getDatasourceList();
				for(Datasource ds : dsList){
					if(component.getDatasourceid().equals(ds.getId())){
						String kpiStoreId = ds.getKpistoreId();
						if(report.getKpistores()!=null&&report.getKpistores().getKpistoreList()!=null){
							List<Kpistore> storeList = report.getKpistores().getKpistoreList();
							for(Kpistore kpistore : storeList){
								if(kpiStoreId.equals(kpistore.getId())){
									List<KpistoreCol> colList = kpistore.getKpistorecolList();
									if(colList!=null){
										for(KpistoreCol col : colList){
											kpiColMap.put(col.getKpiid(),col);
										}
									}
									break;
								}
							}
						}
						break;
					}
				}
			}
		}
		return kpiColMap;
	}
	/*	描述：从xml文件中读取或创建组件对象实例(未使用)
	 *  参数：
	 *  	reportId 报表id
	 *  	componentId 组件id
	 *  返回值：组件对象实例
	 * */
//	public Component getOrCreateComponet(String reportId,String componentId) {
//		Component component=null;
//		Report report=readFromXmlByReportId(reportId);
//		report.setId(reportId);
//		Components components =report.getComponentsObj();
//		if(components==null){
//			components=new Components();
//			report.setComponentsObj(components);
//		}
//		List<Component> componentList=components.getComponentList();
//		if(componentList==null){
//			componentList=new ArrayList<Component>();
//			components.setComponentList(componentList);
//			
//		}
//		for(Component tempComponet:componentList){
//			if(componentId.equals(tempComponet.getId())){
//				component=tempComponet;
//				break;
//			}
//		}
//		if(component==null){
//			component=new Component();
//			componentList.add(component);
//		}
//		return component;
//	}
//	
	/*	描述：从组件实例中获取或创建XAxis实例
	 *  参数：
	 *  	component 组件实例
	 *  返回值：XAxis实例
	 * */
	public XAxis getOrCreateXaxis(Component component) {
		XAxis xaxis=component.getXaxis();
		if(xaxis==null){
			xaxis=new XAxis();
			component.setXaxis(xaxis);
		}
		return xaxis;
		
	}
	
	/*	描述：从组件实例中获取或创建YAxis实例集合
	 *  参数：
	 *  	component 组件实例
	 *  返回值：XAxis实例
	 * */
	public List<YAxis>  getOrCreateYaxisList(Component component) {
		List<YAxis> yaxisList=component.getYaxisList();
		if(yaxisList==null){
			yaxisList=new ArrayList<YAxis>();
			component.setYaxisList(yaxisList);
		}
		return yaxisList;
		
	}
	
	/*	描述：从组件实例中获取或创建指标实例集合
	 *  参数：
	 *  	component 组件实例
	 *  返回值：指标实例集合
	 * */
	public List<Kpi> getOrCreateKpiList(Component component) {
		List<Kpi> kpiList=component.getKpiList();
		if(kpiList==null){
			kpiList=new ArrayList<Kpi>();
			component.setKpiList(kpiList);
		}
		return kpiList;
		
	}
	
	/*	描述：校验数据集中是否存在某字段
	 *  参数：
	 *  	dataSetModel 数据集对象
	 *  	field 字段名称
	 *  返回值：布尔类型（true/false）
	 * */
	public boolean validateDatasourceField(Map dataSetModel,String field){
		boolean resultFlag=false;
		List<Map> fieldList=(List<Map>)dataSetModel.get("children");
		if(fieldList==null){
			return false;
		}
		for(Map tempField:fieldList){
			if(field.equals(tempField.get("text"))){
				resultFlag=true;
			}
		}
		return resultFlag;
	}
	
	/*	描述：校验组件内各元素有效性
	 *  参数：
	 *  	report 报表对象
	 *  	component 组件对象
	 *  返回值：字符串（错误信息）
	 * */
	@SuppressWarnings("unchecked")
	public String validateAllChartComponent(Report report,Component component) {
		StringBuilder stringBuilder=new StringBuilder();
		String type = component.getType().toLowerCase();
		if(type.indexOf("columnline")==0){
			stringBuilder.append(new ColumnLineService().validateComponent(report,component));
		/*	if(stringBuilder.length()!=0){
				stringBuilder.insert(0,"||||组合图："+component.getTitle()+"<br/>\n");
			}*/
		}else if(type.indexOf("column")==0){
			stringBuilder.append(new ColumnService().validateComponent(report,component));
			/*if(stringBuilder.length()!=0){
				stringBuilder.insert(0,"||||柱图："+component.getTitle()+"<br/>\n");
			}*/
		}else if(type.indexOf("line")==0){
			stringBuilder.append(new LineService().validateComponent(report,component));
			/*if(stringBuilder.length()!=0){
				stringBuilder.insert(0,"||||线图："+component.getTitle()+"<br/>\n");
			}*/
		}else if(type.indexOf("bar")==0){
			stringBuilder.append(new BarService().validateComponent(report,component));
			/*if(stringBuilder.length()!=0){
				stringBuilder.insert(0,"||||条形图："+component.getTitle()+"<br/>\n");
			}*/
		}else if(type.equals("pie")||type.equals("ring")){
			stringBuilder.append(new PieService().validateComponent(report,component));
			/*if(stringBuilder.length()!=0){
				stringBuilder.insert(0,"||||"+(type.equals("pie")?"饼图：":"环图：")+component.getTitle()+"<br/>\n");
			}*/
		}else if(type.equals("scatter")){
			stringBuilder.append(new ScatterService().validateComponent(report,component));
			/*if(stringBuilder.length()!=0){
				stringBuilder.insert(0,"||||散点图："+component.getTitle()+"<br/>\n");
			}*/
		}else if(type.equals("weblate")){
			stringBuilder.append(new WebLateService().validateWebLate(report, component));
			/*if(stringBuilder.length()!=0){
				stringBuilder.insert(0,"||||页面模版："+component.getTitle()+"<br/>\n");
			}*/
		}  
		return stringBuilder.toString();
	}
	
	public void setComponentSqlString(Report reportObj,String containerId,String componentId){
		XDataSourceSql xdsql = new XDataSourceSql(reportObj,containerId,componentId);
		try {
			xdsql.setSql();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	/* 删除计算列前检查计算列是否已经被其他组件使用 */
	@SuppressWarnings("unchecked")
	public String checkCaculateColumnReference(String reportId, String containerId,String componentId, String extcolumnid) {
		Report reportObj = XContext.getEditView(reportId);
		List<Container> containerList = reportObj.getContainers().getContainerList();
		String isUsed="false";
		if(containerList!=null){
			label:for(Container container : containerList){
				if(container.getComponents()!=null){
					List<Component> componentList = container.getComponents().getComponentList();
					for(Component component : componentList){
						if(component.getId().equals(componentId)){
							continue;
						}
						if(component.getXaxis()!=null){
							XAxis axis = component.getXaxis();
							if(extcolumnid.equals(axis.getDimExtField()) || extcolumnid.equals(axis.getScatterDimExtField()) ||extcolumnid.equals(axis.getSortExtField())){
								isUsed = "true";
								break label;
							}
						}
						
						if(component.getKpiList()!=null){
							List<Kpi> kpiList = component.getKpiList();
							for(Kpi kpi : kpiList){
								if(extcolumnid.equals(kpi.getExtcolumnid())){
									isUsed = "true";
									break label;
								}
							}
						}
						
						if(component.getSortcolStore()!=null){
							List<Sortcol> sortColList = component.getSortcolStore().getSortcolList();
							if(sortColList!=null){
								for(Sortcol sortcol : sortColList){
									if(extcolumnid.equals(sortcol.getExtcolumnid())){
										isUsed = "true";
										break label;
									}
								}
							}
						}
						
						if(component.getDatastore()!=null){
							List<Datacol> datacolList = component.getDatastore().getDatacolList();
							if(datacolList!=null){
								for(Datacol datacol : datacolList){
									if(extcolumnid.equals(datacol.getExtcolumnid())){
										isUsed = "true";
										break label;
									}
								}
							}
						}
						
						if(component.getSubdrills()!=null){
							List<Subdrill> subdrillList = component.getSubdrills().getSubdrillList();
							if(subdrillList!=null){
								for(Subdrill subdrill : subdrillList){
									if(subdrill.getSubdirllsortcols()!=null){
										List<Subdirllsortcol> sortcolList = subdrill.getSubdirllsortcols().getSubdirllsortcolList();
										if(sortcolList!=null){
											for(Subdirllsortcol col : sortcolList){
												if(extcolumnid.equals(col.getExtcolumnid())){
													isUsed = "true";
													break label;
												}
											}
										}
									}
								}
							}
						}
						
					}
				}
			}
		}
		return isUsed;
	}
	
	/**
	 * 删除kpistorecol
	 * @param reportId
	 * @param containerId
	 * @param componentId
	 * @param extcolumnid
	 * @return
	 */
	public void removeKpiStoreCol(String reportId , String extcolumnid){
		Report reportObj=XContext.getEditView(reportId);
//		Component component=getOrCreateComponet(reportObj,containerId,componentId);
//		String datasourceid = component.getDatasourceid();
//		String kpistoreid = "";
//		if(reportObj.getDatasources()!=null&&reportObj.getDatasources().getDatasourceList()!=null){
//			List<Datasource> dsList = reportObj.getDatasources().getDatasourceList();
//			for(Datasource ds : dsList){
//				if(ds.getId().equals(datasourceid)){
//					kpistoreid = ds.getKpistoreId();
//					break;
//				}
//			}
//		}
		List<KpistoreCol> storeColList = null;
		if(reportObj.getKpistores()!=null&&reportObj.getKpistores().getKpistoreList()!=null){
			List<Kpistore> kpiStoreList = reportObj.getKpistores().getKpistoreList();
			KpistoreCol col4Delete = null;
			for(Kpistore kpistore : kpiStoreList){
				storeColList = kpistore.getKpistorecolList();
				if(storeColList!=null){
					for(KpistoreCol col : storeColList){
						if(extcolumnid.equals(col.getKpiid())){
							col4Delete = col;
							break;
						}
					}
					if(col4Delete!=null){
						storeColList.remove(col4Delete);
					}
				}
			}
			saveToXmlByObj(reportObj);
		}
	}
}
