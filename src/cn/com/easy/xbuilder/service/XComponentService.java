package cn.com.easy.xbuilder.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import cn.com.easy.annotation.Service;
import cn.com.easy.core.EasyContext;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Components;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Datasources;
import cn.com.easy.xbuilder.element.Kpi;
import cn.com.easy.xbuilder.element.Kpistore;
import cn.com.easy.xbuilder.element.KpistoreCol;
import cn.com.easy.xbuilder.element.Kpistores;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.XAxis;
import cn.com.easy.xbuilder.kpi.XDataSourceSql;

@Service
public class XComponentService extends XBaseService {
	
	/**
	 * 检查容器内有几个组件
	 * @param param
	 * @return
	 */
	public String checkComponent(Map<String, String> param) {
		Report viewObj = readFromXmlByViewId(param.get("viewId"));
		List<Component> list = getComponentList(viewObj,param.get("containerId"));
		return String.valueOf(list.size());
	}
	
    /**
     * 添加组件到容器
     * @param viewId
     * @param containerId
     * @param component
     * @param isPop
     */
	public void addComponent(String viewId, String containerId, Map<String, String> component,Boolean isPop) {
		try{
			Report viewObj = readFromXmlByViewId(viewId);
			Component componentObj = parseComponent(component) ;
	        List<Component> compList = getComponentList(viewObj, containerId);
	        
	        compList.add(componentObj);
	        Container container=getContainerById(viewObj,containerId);
	        if(!isPop){//如果是基础组件
	        	container.setTitle2(componentObj.getTitle()).setPop2("");
	        }else{//如果是弹出组件
	        	container.setPop2(componentObj.getId());
	        }
	        //指标库时添加数据源
	        if("2".equals(viewObj.getInfo().getType())&&component.get("createType").equals("new")){
	        	
	        	String type = componentObj.getType();
	        	type = type.toLowerCase();
	        	
	        	String dsId = addDatasource(viewObj,type);
	        	componentObj.setDatasourceid(dsId);
	        }
	        saveToXmlByObj(viewObj);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * 添加指标库类型的数据源
	 * @param viewObj
	 */
	private String addDatasource(Report viewObj){
		if(viewObj.getDatasources()==null){
			viewObj.setDatasources(new Datasources());
		}
		if(viewObj.getDatasources().getDatasourceList()==null){
			viewObj.getDatasources().setDatasourceList(new ArrayList<Datasource>());
		}
		Datasource ds = new Datasource();
		ds.setCreatetime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
		ds.setCreator(((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID")+"");
		ds.setExtds("");
		ds.setId(new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date()));
		ds.setName(ds.getId());
		ds.setSql("");
		String kpistoreId = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
		ds.setKpistoreId(kpistoreId);
		viewObj.getDatasources().getDatasourceList().add(ds);
		
		if(viewObj.getKpistores()==null){
			viewObj.setKpistores(new Kpistores());
		}
		if(viewObj.getKpistores().getKpistoreList()==null){
			viewObj.getKpistores().setKpistoreList(new ArrayList<Kpistore>());
		}
		Kpistore kpistore = new Kpistore();
		kpistore.setId(kpistoreId);
		kpistore.setKpistorecolList(new ArrayList<KpistoreCol>());
		viewObj.getKpistores().getKpistoreList().add(kpistore);
		return ds.getId();
	}
	
	/**
	 * 添加指标库类型的数据源
	 * @param viewObj
	 */
	private String addDatasource(Report viewObj,String type){
		if(viewObj.getDatasources()==null){
			viewObj.setDatasources(new Datasources());
		}
		if(viewObj.getDatasources().getDatasourceList()==null){
			viewObj.getDatasources().setDatasourceList(new ArrayList<Datasource>());
		}
		Datasource ds = new Datasource();
		ds.setCreatetime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
		ds.setCreator(((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID")+"");
		ds.setExtds("");
		ds.setId(new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date()));
		ds.setName(ds.getId());
		if("weblate".equals(type)){
			ds.setSql("select 1 from dual");
		}else{
			ds.setSql("");
		}
		
		String kpistoreId = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
		ds.setKpistoreId(kpistoreId);
		viewObj.getDatasources().getDatasourceList().add(ds);
		
		if(viewObj.getKpistores()==null){
			viewObj.setKpistores(new Kpistores());
		}
		if(viewObj.getKpistores().getKpistoreList()==null){
			viewObj.getKpistores().setKpistoreList(new ArrayList<Kpistore>());
		}
		Kpistore kpistore = new Kpistore();
		kpistore.setId(kpistoreId);
		kpistore.setKpistorecolList(new ArrayList<KpistoreCol>());
		viewObj.getKpistores().getKpistoreList().add(kpistore);
		return ds.getId();
	}
	
	/**
	 * 添加指标库指标到kpistore节点
	 * @param paramMap
	 */
	public void addKpiStoreCol(Map<String,String> paramMap){
			String viewId = paramMap.get("viewId");
			String containerId = paramMap.get("containerId");
			String componentId = paramMap.get("componentId");
			String kpistoreColId = paramMap.get("kpistoreColId");
			String kpistoreColHasAdded = paramMap.get("kpistoreColHasAdded");
			List<String> kpistoreColHasAddedList = Arrays.asList(kpistoreColHasAdded.split(","));
			Report viewObj = readFromXmlByViewId(viewId);
			List<Component> componentList = getComponentList(viewObj, containerId);
			String kpistoreId = "";
			//找到当前编辑组件的kpistoreId
	        for(Component component : componentList){
	        	if(componentId.equals(component.getId())){
	        	   String dsId = component.getDatasourceid();
	        	   for(Datasource ds : viewObj.getDatasources().getDatasourceList()){
	               	if(ds.getId().equals(dsId)){
	               		kpistoreId = ds.getKpistoreId();
	               	}
	               }
	        	   break;
	        	}
	        }
			List<Kpistore> kpistoreList = viewObj.getKpistores().getKpistoreList();
			List<KpistoreCol> colList = new ArrayList<KpistoreCol>();
			List<KpistoreCol> removeColList = new ArrayList<KpistoreCol>();
			//添加指标到kpistore节点（已有的指标不添加）
			for(Kpistore kpistore : kpistoreList){
				if(kpistoreId.equals(kpistore.getId())){
					if(kpistore.getKpistorecolList()==null){
						kpistore.setKpistorecolList(new ArrayList<KpistoreCol>());
					}
					boolean isExist = false;
					colList = kpistore.getKpistorecolList();
					for(KpistoreCol kpiCol : colList){
						if(kpistoreColId.equals(kpiCol.getKpiid())){
							kpiCol.setKpidesc(paramMap.get("kpiDesc"));
							isExist = true;
						}
					}
					if(!isExist){
						KpistoreCol col = new KpistoreCol();
						col.setKpiid(kpistoreColId);
						col.setKpicolumn(paramMap.get("kpiColumn"));
						col.setKpidesc(paramMap.get("kpiDesc"));
						col.setKpitype(paramMap.get("kpiType"));
						colList.add(col);
					}
					break;
				}
			}
			if(!kpistoreColHasAdded.equals("")){
				//删除没有在组件中配置的指标
				for(KpistoreCol kpiCol : colList){
					boolean isKpiColExist = false;
					for(String hasAddedKpiId : kpistoreColHasAddedList){
						if(hasAddedKpiId.equals(kpiCol.getKpiid())){
							isKpiColExist=true;
							break;
						}
					}
					if(!isKpiColExist){
						removeColList.add(kpiCol);
					}
				}
				colList.removeAll(removeColList);
			}
			saveToXmlByObj(viewObj);
			
			//调用接口方法生成sql语句保存到datasource节点
			XDataSourceSql xdsql = new XDataSourceSql(viewObj,containerId,componentId);
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
	
	/**
	 * 删除一条已添加的指标
	 * @param paramMap
	 */
	public void removeKpiRow(Map<String,String> paramMap){
		String viewId = paramMap.get("viewId");
		String containerId = paramMap.get("containerId");
		String componentId = paramMap.get("componentId");
		String kpiId = paramMap.get("kpiId");
		if("".equals(kpiId)||kpiId == null){
			return;
		}
		Report viewObj = readFromXmlByViewId(viewId);
		List<Component> componentList = getComponentList(viewObj, containerId);
		String kpistoreId = "";
		XAxis xaxis = null;
        for(Component component : componentList){
        	if(componentId.equals(component.getId())){
        	   //找到component使用的数据源对应的kpistoreId
        	   String dsId = component.getDatasourceid();
        	   xaxis = component.getXaxis();
        	   for(Datasource ds : viewObj.getDatasources().getDatasourceList()){
               	if(ds.getId().equals(dsId)){
               		kpistoreId = ds.getKpistoreId();
               		break;
               	}
               }
        	   //删除component节点下的kpi节点
        	   Iterator<Kpi> iterator = component.getKpiList().iterator();
               while(iterator.hasNext()){
                   Kpi kpi = iterator.next();
                   if(kpiId.equals(kpi.getKpiId())){
                	   iterator.remove(); 
                	   break;
        		   }
               }
        	   break;
        	}
        }
        List<Kpistore> kpistoreList = viewObj.getKpistores().getKpistoreList();
        for(Kpistore kpistore : kpistoreList){
			if(kpistoreId.equals(kpistore.getId())){
				 //删除kpistore节点下的kpistorecol节点
				 Iterator<KpistoreCol> iterator = kpistore.getKpistorecolList().iterator();
	               while(iterator.hasNext()){
	            	   KpistoreCol col = iterator.next();
	                   if(kpiId.equals(col.getKpiid())&&xaxis!=null&&!kpiId.equals(xaxis.getDimFiledId())&&!kpiId.equals(xaxis.getSortFiledId())){
	                	   iterator.remove(); 
	                	   break;
						}
	               }
				break;
			}
		}
        saveToXmlByObj(viewObj);
	}
	/**
	 * 删除组件时删除数据源（数据源类型为指标库时调用）
	 * @param viewObj
	 * @param component
	 */
	private void removeComponentDatasource(Report viewObj,Component component){
		if(viewObj.getDatasources()!=null&&viewObj.getDatasources().getDatasourceList()!=null){
			for(Datasource ds : viewObj.getDatasources().getDatasourceList()){
				if(ds.getId().equals(component.getDatasourceid())){
					viewObj.getDatasources().getDatasourceList().remove(ds);
					if(viewObj.getKpistores()!=null&&viewObj.getKpistores().getKpistoreList()!=null){
						for(Kpistore kpistore : viewObj.getKpistores().getKpistoreList()){
							if(kpistore.getId().equals(ds.getKpistoreId())){
								viewObj.getKpistores().getKpistoreList().remove(kpistore);
								break;
							}
						}
					}
					break;
				}
			}
			saveToXmlByObj(viewObj);
		}
	}
	/**
     * 清空容器,删除容器中的组件
     * @param viewId
     * @param containerId
     * @param component
     */
	public void setContainerType(String viewId, String containerId,String containerType) {
		try{
			Report viewObj = readFromXmlByViewId(viewId);
	        Container container=getContainerById(viewObj,containerId);
	        container.setType(containerType);
	        saveToXmlByObj(viewObj);
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
	
	/**
     * 清空容器,删除容器中的组件
     * @param viewId
     * @param containerId
     * @param component
     */
	public void clearContainer(String viewId, String containerId) {
		Report viewObj = readFromXmlByViewId(viewId);
        Container container=getContainerById(viewObj,containerId);
        container.setPop2("").setTitle2("").setBgclass2("").setContainerClass2("").setType2("");
        container.getComponents().setComponentList(new ArrayList<Component>());
        saveToXmlByObj(viewObj);
	}
	
	/**
	 * 根据组件编号删除组件
	 * @param viewId
	 * @param componentId
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map removeComponent(String viewId, String componentId) {
		      Map resultMap = new HashMap<String, String>();
			  Report viewObj = readFromXmlByViewId(viewId);
			  List<Container> containerList = viewObj.getContainers().getContainerList();
			  outerLoop:for(Container container : containerList){
				  List<Component> componentList = container.getComponents().getComponentList();
				  if(componentList!=null){
					  for(Component comp : componentList){
						  if(componentId.equals(comp.getId())){
							  String containerType = container.getType();
							  String pop = container.getPop();
							  componentList.remove(comp);
							  if("2".equals(viewObj.getInfo().getType())){
								  //removeComponentDatasource(viewObj, comp);
							  }
							  XContext.removeComponentFromCacheMap(viewId, componentId);
							  if("1".equals(containerType)){//如果布局类型为基础布局
								  if(!componentId.equals(pop)){//如果待删除组件不是弹出组件,清空容器
									  componentList=new ArrayList<Component>();
									  resultMap.put("isPop", "false");
								  }else{
									  resultMap.put("isPop", "true");
								  }
							  }
							  container.getComponents().setComponentList(componentList);
							  if(container.getComponents().getComponentList().size()==0){
								  container.setPop2("").setTitle2("").setBgclass2("").setContainerClass2("").setType2("");
							  }
							  resultMap.put("containerType", containerType);
							  resultMap.put("containerId", container.getId());
							  resultMap.put("componentListSize", componentList.size());
							  resultMap.put("firstComponent", componentList.size()>0?componentList.get(0):null);
							  break outerLoop;
						  }
					  }
				  }
			  }
			  
	          saveToXmlByObj(viewObj);
		      return resultMap;
	}
	
    /**
     * 替换组件中的容器
     * @param viewId
     * @param containerId
     * @param component
     */
	public void replaceComponent(String viewId, String containerId, Map<String, String> component,String replaceType) {
		Report viewObj = readFromXmlByViewId(viewId);
		Container container=getContainerById(viewObj,containerId);
		Component componentObj = parseComponent(component) ;
        List<Component> compList = getComponentList(viewObj, containerId);
        //只有一个组件时直接删除
        if(compList.size()==1){
        	container.setTitle2(componentObj.getTitle());
        	if("2".equals(viewObj.getInfo().getType())){
	        	//removeComponentDatasource(viewObj, compList.get(0));
	        }
        	compList.removeAll(compList);
        }else{ //大于一个组件时
            if("0".equals(replaceType)){//0:删除基础组件
            	for(Component comp : compList){
            		if(!comp.getId().equals(container.getPop())){
            			compList.remove(comp);
            			break;
            		}
            	}
            	container.setTitle2(componentObj.getTitle());
            }else{//1:删除弹出组件
            	for(Component comp : compList){
            		if(comp.getId().equals(container.getPop())){
            			compList.remove(comp);
            			if("2".equals(viewObj.getInfo().getType())){
            	        	//removeComponentDatasource(viewObj, comp);
            	        }
            			break;
            		}
            	}
            	container.setPop2(componentObj.getId());
            }
        }
        compList.add(componentObj);
        if("2".equals(viewObj.getInfo().getType())&&component.get("createType").equals("new")){
        	
        	String type = componentObj.getType();
        	type = type.toLowerCase();
        	
        	String dsId = addDatasource(viewObj,type);
        	componentObj.setDatasourceid(dsId);
        }
		saveToXmlByObj(viewObj);
	}
	
	
	/**
	 * js传递参数转换为组件对象
	 * @param param
	 * @return
	 */
    public Component parseComponent(Map<String,String> param){
    	Component component;
    	if(param.get("createType").equals("new")){
    		component = new Component();
    		component.setCompId(param.get("compid"));
    		component.setTitle(param.get("title"));
    		component.setChartTitle(param.get("title"));
    		component.setUrl(param.get("url"));
    		component.setType(param.get("type"));
    		component.setId(param.get("id"));
    		component.setPropertyUrl(param.get("propertyUrl"));
    	}else{
    		component = XContext.getComponentFromCacheMap(param.get("viewId"), param.get("id"));
    	}
    	return component;
    }
    
    /**
     * 获取容器下的组件列表
     * @param viewObj
     * @param containerId
     * @return
     */
	public List<Component> getComponentList(Report viewObj, String containerId) {
		List<Component> compList = null ;
		List<Container> containerList = viewObj.getContainers().getContainerList();
		if(containerList==null){
			containerList=new ArrayList<Container>();
			viewObj.getContainers().setContainerList(containerList);
		}
		Container selContainer = null ;
		for (Container container : containerList) {
			if (containerId.equals(container.getId())) {
				selContainer=container;
				if(selContainer.getComponents()!=null&&selContainer.getComponents().getComponentList()!=null){
					compList = selContainer.getComponents().getComponentList();
					break;
				}
			}
		}
		if(compList==null){
			compList = new ArrayList<Component>();
			if(selContainer==null){
				selContainer=new Container();
				selContainer.setId2(containerId).setBgclass2("").setTitle2("").setContainerClass2("").setType2("");
				containerList.add(selContainer);
			}
			if(selContainer.getComponents()==null){
				Components comps=new Components();
				comps.setComponentList(compList);
				selContainer.setComponents(comps);
			}if(selContainer.getComponents().getComponentList()==null){
				selContainer.getComponents().setComponentList(compList);
			}
		}
		return compList;
	}
	
	/**
	 * 根据容器编号获取容器
	 * @param viewObj
	 * @param containerId
	 * @return
	 */
	public Container getContainerById(Report viewObj,String containerId){
		Container container = null ;
		if(viewObj.getContainers()!=null&&viewObj.getContainers().getContainerList()!=null){
			for(Container item : viewObj.getContainers().getContainerList()){
	        	if(containerId.equals(item.getId())){
	        		container=item;
	        		break;
	        	}
	        }
		}
		return container;
	}
	
	/**
	 * 检查容器中是否存在指定的组件
	 * @param viewId
	 * @param containerId
	 * @param compId
	 * @return
	 */
	public String checkComponentExist(String viewId,String containerId,String componentId){
		String isExist="no";
		Report viewObj = readFromXmlByViewId(viewId);
		Container container = getContainerById(viewObj,containerId); 
		for(Component tempComponent:container.getComponents().getComponentList()){
			if(componentId.equals(tempComponent.getId())){
				isExist="yes";
				break;
			}
		}
		return isExist;
	}
	
 	/**
     * 获取指定的容器对象
     * @param viewId
     * @param containerId
     */
	public String getContainerAllInfoById(String viewId, String containerId,String compId,boolean check) {
		String resultStr=null;
		Report viewObj = readFromXmlByViewId(viewId);
		 
		if(check){
			List<Container> containers = viewObj.getContainers().getContainerList();
			for(int c=0;c<containers.size();c++){
				Container container = containers.get(c);
				List<Component> components = container.getComponents().getComponentList();
				if(components != null && components.size()>0){
					for(Component comp:components){
						if(comp.getId().equals(compId)){
							return "1";//错误,已经存在
						}
					}
				}
			}
		}

		Container container = getContainerById(viewObj,containerId);
		if(container!=null){
			resultStr= Functions.java2json(container);
		}else{
			
			resultStr= "0";
		}
		return resultStr;
	}
	
 	 /**
     * 获取第一个组件
     * @param viewId
     * @param containerId
     */
	public String getFirstComponent(String viewId, String containerId) {
		Report viewObj = readFromXmlByViewId(viewId);
        List<Component> compList = getComponentList(viewObj, containerId);
        Component component=null;
        if(compList!=null&&compList.size()>0){
        	component=compList.get(0);
        	return Functions.java2json(component);
        }else{
        	return "0";
        }
		
	}
	/**
     * 添加组件到容器(不设置容器类型)
     * @param viewId
     * @param containerId
     * @param component
     */
	public void addComponentWithoutType(String viewId, String containerId, Map<String, String> param) {
		Report viewObj = readFromXmlByViewId(viewId);
		Component componentObj = new Component();
		if(param.get("createType").equals("new")){
			componentObj.setCompId(param.get("compId"));
			componentObj.setTitle(param.get("title"));
			componentObj.setChartTitle(param.get("title"));
			componentObj.setUrl(param.get("url"));
	    	componentObj.setType(param.get("type"));
	    	componentObj.setId(param.get("id"));
	    	componentObj.setPropertyUrl(param.get("propertyUrl"));
		}else{
			componentObj = parseComponent(param) ;
		}
        List<Component> compList = getComponentList(viewObj, containerId);
        compList.add(componentObj);
        
        if("2".equals(viewObj.getInfo().getType())&&param.get("createType").equals("new")){
        	
        	String type = componentObj.getType();
        	type = type.toLowerCase();
        	
        	String dsId = addDatasource(viewObj,type);
        	componentObj.setDatasourceid(dsId);
        }
        saveToXmlByObj(viewObj);
	}
		
	 /**
     * 从组件元素的list集合中找到指定的组件元素
     * @param viewId
     * @param containerId
     * @param jsonString
     */
	private Component getComponentInComponentList(String componentId,List<Component> ComponentList){
		Component component=null;
		for(Component tempComponent:ComponentList){
			if(componentId.equals(tempComponent.getId())){
				component=tempComponent;
				break;
			}
		}
		return component;
	}
	 /**
     * 保存容器属性,包括标题、颜色,各组件的标题和顺序.
     * @param viewId
     * @param containerId
     * @param jsonString
     */
	@SuppressWarnings("unchecked")
	public void saveContainerProperty(String viewId, String containerId,String jsonString){
		Map<String,Object> element=(Map)Functions.json2java(jsonString);
		String paramTitle="";//容器标题 参数
		if(element.get("title")!=null){
			paramTitle=(String)element.get("title");
		}
		String paramBGclass="";//容器样式 参数
		if(element.get("bgclass")!=null){
			paramBGclass=(String)element.get("bgclass");
		}
		List<Map<String,String>> paramComponentList=new ArrayList<Map<String,String>>();//组件集合 参数
		if(element.get("componentList")!=null){
			paramComponentList=(ArrayList<Map<String,String>>)element.get("componentList");
		}
		
		
		Report viewObj = readFromXmlByViewId(viewId);
		Container container = getContainerById(viewObj,containerId); //取到容器对象
		if(container==null){
			return;
		}
		container.setTitle2(paramTitle).setBgclass2(paramBGclass).setStyleclass((String)element.get("styleclass"));//设置容器标题和样式
		
		List<Component> componentList=new ArrayList<Component>();//现有组件集合
		if(container.getComponents()!=null&&container.getComponents().getComponentList()!=null){
			componentList=container.getComponents().getComponentList();
		}
		if("1".equals(container.getType())){//基础容器或弹出容器里，容器标题变，组件标题也跟着改变
			Component tempComponent =componentList.get(0);
			tempComponent.setTitle(paramTitle);
			
		}
		if(("1".equals(container.getType())&&(container.getPop()!=null)&&container.getPop().length()>30)){//弹出时，弹出组件标题改变
			Map<String, String> tempMap=paramComponentList.get(0);
			Component tempComponent =getComponentInComponentList(tempMap.get("id"),componentList);
			tempComponent.setTitle(tempMap.get("title"));
			
		}else if("2".equals(container.getType())||"3".equals(container.getType())){//、切换、选项时，组件改变
			List<Component> newComponentList=new ArrayList<Component>();//修改后的组件集合
			for(Map<String,String> tempMap:paramComponentList){
				Component tempComponent =getComponentInComponentList(tempMap.get("id"),componentList);
				if(tempComponent!=null){
					tempComponent.setTitle(tempMap.get("title"));
					newComponentList.add(tempComponent);
				}
				
			}
			if(container.getComponents()!=null){
				container.getComponents().setComponentList(newComponentList);
			}
			
		}
		
		saveToXmlByObj(viewObj);
		
		
	} 
	
	 /**
     * 从内存中彻底删除组件元素
     * @param viewId
     * @param containerId
     */
	@SuppressWarnings("unused")
	public String removeCacheComment(String viewId, String componentId){
		try {
			XContext.removeComponentFromCacheMap(viewId,componentId);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return "0";
		}
		return "1";
	}
}