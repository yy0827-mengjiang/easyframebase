package cn.com.easy.xbuilder;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Report;

public class XContext {

	private static final Map<String, Report> editViewMap = new ConcurrentHashMap<String, Report>();//编辑中的报表
	private static final Map<String, Report> formalViewMap = new ConcurrentHashMap<String, Report>();//正式的报表
	private static final Map<String,Map<String,Component>> componentCacheMap = new ConcurrentHashMap<String,Map<String,Component>>();//缓存组件
	
	public static Report addEditView(Report View) {
		return editViewMap.put(View.getId(), View);
	}

	public static Report getEditView(String ViewId) {
		return editViewMap.get(ViewId);
	}
	
	public static Report removeEditView(String ViewId) {
		return editViewMap.remove(ViewId);
	}
	
	public static Report addFormalView(Report View) {
		return formalViewMap.put(View.getId(), View);
	}

	public static Report getFormalView(String ViewId) {
		return formalViewMap.get(ViewId);
	}
	
	public static Report removeFormalView(String ViewId) {
		return formalViewMap.remove(ViewId);
	}

	public static void addComponentToCacheMap(String viewId,Component component){
		if(componentCacheMap.get(viewId)==null){
			componentCacheMap.put(viewId, new HashMap<String,Component>());
		}
		componentCacheMap.get(viewId).put(component.getId(), component);
	}
	
	public static Component getComponentFromCacheMap(String viewId,String componentId){
		if(componentCacheMap.get(viewId)==null){
			 return null;
		}else{
			return componentCacheMap.get(viewId).get(componentId);
		}
	}
	
	public static void removeComponentFromCacheMap(String viewId,String componentId){
		if(componentCacheMap.get(viewId)!=null){
			componentCacheMap.get(viewId).remove(componentId);
		}
	}
	public static void removeAllComponentFromCacheMapByViewId(String viewId){
		if(componentCacheMap.get(viewId)!=null){
			componentCacheMap.remove(viewId);
		}
	}
}
