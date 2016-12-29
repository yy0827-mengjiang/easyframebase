package cn.com.easy.xbuilder.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.easy.annotation.Service;
import cn.com.easy.exception.JaxbException;
import cn.com.easy.jaxb.parser.DefaultJaxbParse;
import cn.com.easy.jaxb.parser.JaxbParse;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Dimsions;
import cn.com.easy.xbuilder.element.Link;
import cn.com.easy.xbuilder.element.Query;
import cn.com.easy.xbuilder.element.Report;
/**
 * MBUILDER 恢复编辑
 * @author 
 *
 */
@Service("xbuilderEditService")
public class XEditService  extends XBaseService{
	
	
	
	/**
	 * 得到维度相关信息 得到的当前报表正在使用的
	 * @param reportId
	 * @return 
	 */
	@SuppressWarnings("unchecked")
	public List<Map> getDimsions(String viewId){
		List<Map> dimList = new ArrayList<Map>();
		Report report = this.getReport(viewId);//readFromXmlByReportId(reportId,true);
		Dimsions dimsions = report.getDimsions();
		List<Dimsion> dimsionList = dimsions.getDimsionList();
		if(dimsionList != null && dimsionList.size() > 0)
		for(Dimsion dimsion:dimsionList){
			String id = dimsion.getId();
			if(id != null && getQueryString(viewId,id)){
				Map dimMap = new HashMap();
				dimMap.put("reportId", viewId);
				dimMap.put("dimvar", dimsion.getVarname());
				dimMap.put("type", dimsion.getType());
				dimMap.put("dim_parent_col", dimsion.getParentcol());
				dimMap.put("parent_dim_name", dimsion.getParentcol());
				dimMap.put("dim_table", dimsion.getTable());
				dimMap.put("dim_col_code", dimsion.getCodecolumn());
				dimMap.put("dim_col_desc", dimsion.getDesccolumn());
				dimMap.put("dim_col_ord", dimsion.getOrdercolumn());
				dimMap.put("select_double", dimsion.getIsselectm());
				dimMap.put("dim_create_type", dimsion.getCreatetype());
				dimMap.put("dim_var_desc", dimsion.getDesc());
				dimMap.put("dim_lvl", dimsion.getLevel());
				dimMap.put("defaultvalue", dimsion.getDefaultvalue());
				dimMap.put("dimId", dimsion.getId());
				
				dimMap.put("createType", dimsion.getCreatetype());
				if(dimsion.getSql() != null){
					dimMap.put("dim_sql", dimsion.getSql().getSql());
					dimMap.put("dimsql", dimsion.getSql().getSql());
					dimMap.put("database_name", dimsion.getSql().getExtds());
					dimMap.put("databaseName", dimsion.getSql().getExtds());
				}
				dimMap.put("caslvl", dimsion.getLevel());
				dimList.add(dimMap);
			}
		}
		return dimList;
	}
	
	public List<Component> getComponentList(String viewId){
		List<Component> resultList = new ArrayList<Component>();
		Report viewObj = this.getReport(viewId);
		List<Container> containerList = viewObj.getContainers().getContainerList();
		for(Container container : containerList){
			  List<Component> componentList = container.getComponents().getComponentList();
			  if(componentList!=null){
				  for(Component comp : componentList){
					  //将组件保存到缓存中
					  XContext.addComponentToCacheMap(viewId, comp);
					  resultList.add(comp);
				  }
			  }
		  }
		return resultList;
	}
	
	public Report getReport(String viewId) {
		Report report = readFromXmlByViewId(viewId,false);
		if(XContext.getEditView(viewId) !=null){
			XContext.removeEditView(viewId);
		}
		XContext.addEditView(report);
		return report;
	}
	
	public boolean getQueryString(String viewId,String dimsionId){
		Report report = this.getReport(viewId);//readFromXmlByReportId(reportId,true);
		Query query = report.getQuery();
		List<Link> linkList = query.getLinkList();
		if(linkList != null && linkList.size() > 0){
			for(Link link:linkList){
				if(dimsionId.equals(link.getDimsionid())){
					return true;
				}
			}
		}else{
			return false;
		}
		return false;
	}
	
public static void main(String []args){
		
		JaxbParse jaxb = new DefaultJaxbParse();
		Container container=new Container();
		container.setId("1");
		container.setTitle("title1");
		String str=null;
		String str1=null;
		try {
			str=jaxb.getFormatXmlString(Container.class, container);
			System.out.println(str);
			str1=jaxb.getXmlString(Container.class, container);
			System.out.println(str1);
			Container container2=jaxb.readXmlStr(Container.class, str);
			System.out.println(container2.getTitle());
		} catch (JaxbException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}
}
