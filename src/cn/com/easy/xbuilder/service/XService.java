package cn.com.easy.xbuilder.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.ArrayUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import cn.com.easy.core.EasyContext;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.annotation.Service;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Components;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Containers;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Datastore;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Event;
import cn.com.easy.xbuilder.element.Eventstore;
import cn.com.easy.xbuilder.element.Info;
import cn.com.easy.xbuilder.element.Kpistore;
import cn.com.easy.xbuilder.element.Layout;
import cn.com.easy.xbuilder.element.Report;

@Service
public class XService extends XBaseService{
	@SuppressWarnings("unchecked")
	public void setView(Map<String,String> data) {
		Connection conn = null;
		Statement state = null;
		String time = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
		String xid = data.get("xid");
		Report viewObj = new Report();
		
		Info info = new Info();
		info.setName2("未命名").setUrl2("pages/xbuilder/usepage/formal/"+ xid + "/formal_"+data.get("xid")+".jsp").setCreateUser2(data.get("userId")).setCreateTime2(time);
		info.setType(data.get("dstype"));
		info.setTypeExt(data.get("typeExt"));
		info.setLtype(data.get("ltype"));
		info.setSizex(data.get("contw"));
		Layout layout = new Layout();
		layout.setWidth2(data.get("lwidth")).setValue2(Base64.encodeBase64String(data.get("lhtml").getBytes()));
		
		Containers containers = new Containers();
		List<Container> containerList = new ArrayList<Container>();
		
		Document doc = Jsoup.parse(data.get("lhtml"));
		Elements trs = doc.select("ul");
		for (Element tr : trs) {
			Elements tds = tr.select("li");
			for (Element td : tds) {
				String id = td.attr("id");
				if(id != null && id.length()>0){
					Container container = new Container();
					container.setWidth(String.valueOf(Integer.parseInt(data.get("contw"))*20));
					container.setHeight("480");
					Components components = new Components();
					container.setId2(id).setType2("").setTitle2("").setBgclass2("").setPop2("").setComponents2(components);
					containerList.add(container);
				}
			}
		}
		containers.setContainerList(containerList);
		viewObj.setId2(data.get("xid")).setTheme2(data.get("theme")).setInfo2(info).setLayout2(layout).setContainers2(containers);
		saveToXmlByObj(viewObj);
/*		String xsavedmode = String.valueOf(EasyContext.getContext().getServletcontext().getAttribute("xsavedmode"));
		if(null == xsavedmode || "0".equals(xsavedmode)){*/
			try {
				conn = EasyContext.getContext().getDataSource().getConnection();
				state = conn.createStatement();
				ResultSet rs = state.executeQuery("select * from x_report_info where id='"+xid+"'");
				if(!rs.next()){
					String areano = String.valueOf(EasyContext.getContext().getRequest().getSession().getAttribute("AREA_NO"));
					String saveSql = "insert into x_report_info(ID,NAME,THEME,URL,AREA_NO,STATE,CREATE_USER,CREATE_TIME,MODIFY_USER,MODIFY_TIME) values('"+xid+"','未命名','','pages/xbuilder/usepage/formal/"+ xid + "/formal_"+data.get("xid")+".jsp','"+areano+"','4','"+data.get("userId")+"','"+Functions.getDate("yyyyMMddHHmmss")+"','"+data.get("userId")+"','"+Functions.getDate("yyyyMMddHHmmss")+"')";
					state.executeUpdate(saveSql);
				}
				rs.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				try {
					state.close();
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		//}
	}
	
	@SuppressWarnings("unchecked")
	public void setLType(Map<String,String> data) {
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		viewObj.getInfo().setLtype(data.get("ltype"));
		saveToXmlByObj(viewObj);
	}
	
	@SuppressWarnings("unchecked")
	public void setName(Map<String,String> data){
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		viewObj.getInfo().setName(data.get("name"));
		saveToXmlByObj(viewObj);
		
		Connection conn = null;
		Statement state = null;
		String xsavedmode = String.valueOf(EasyContext.getContext().getServletcontext().getAttribute("xsavedmode"));
		if(null == xsavedmode || "0".equals(xsavedmode)){
			try {
				conn = EasyContext.getContext().getDataSource().getConnection();
				state = conn.createStatement();
				String saveSql = "UPDATE x_report_info SET NAME ='"+data.get("name")+"' WHERE ID='"+data.get("xid")+"'";
				state.executeUpdate(saveSql);
			} catch (SQLException e) {
				e.printStackTrace();
			}finally{
				try {
					state.close();
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}
	@SuppressWarnings("unchecked")
	public void setNameSave(Map<String,String> data){
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		viewObj.getInfo().setName(data.get("name"));
		saveToXmlByObj(viewObj);
		
		Connection conn = null;
		Statement state = null;
		try {
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			String saveSql = "UPDATE x_report_info SET NAME ='"+data.get("name")+"' WHERE ID='"+data.get("xid")+"'";
			state.executeUpdate(saveSql);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			try {
				state.close();
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	public void setCubeId(Map<String,String> data){
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		viewObj.getInfo().setCubeId(data.get("cubeId"));
		saveToXmlByObj(viewObj);
	}
	
	@SuppressWarnings("unchecked")
	public String getCubeId(Map<String,String> data){
		String cubeId="-1";
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		if(viewObj!=null&&viewObj.getInfo()!=null){
			cubeId = viewObj.getInfo().getCubeId();
		}
		cubeId = cubeId==null ? "-1":cubeId;
		return cubeId;
	}
	
	@SuppressWarnings("unchecked")
	public int getComponentsListSize(Map<String,String> data){
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		int size = 0;
		if(viewObj.getContainers()!=null){
			List<Container> containerList = viewObj.getContainers().getContainerList();
			List<Component> compList = null;
			if(containerList!=null){
				for(Container container : containerList){
					if(container.getComponents()!=null){
						compList = container.getComponents().getComponentList();
						if(compList!=null){
							for(Component comp : compList){
								size++;
							}
						}
					}
				}
			}
		}
		
		if(viewObj.getDimsions()!=null){
			List<Dimsion> dimList = viewObj.getDimsions().getDimsionList();
			if(dimList!=null){
				for(Dimsion dim : dimList){
					size++;
				}
			}
		}
		return size;
	}
	
	/**
	 * 删除所有的查询条件和组件，返回删除的id列表map
	 * @param data
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String,Object> removeComponentsAndDimsions(Map<String,String> data){
		Map resultMap = new HashMap<String,Object>();
		List<String> containerIdList = new ArrayList<String>();
		List<String> dimIdList = new ArrayList<String>();
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		if(viewObj.getContainers()!=null){
			List<Container> containerList = viewObj.getContainers().getContainerList();
			List<Component> compList = null;
			if(containerList!=null){
				for(Container container : containerList){
					if(container.getComponents()!=null){
						containerIdList.add(container.getId());
						container.setPop2("").setTitle2("").setBgclass2("").setContainerClass2("").setType2("");
						container.getComponents().setComponentList(new ArrayList<Component>());
					}
				}
			}
		}
		if(viewObj.getDimsions()!=null){
			List<Dimsion> dimList = viewObj.getDimsions().getDimsionList();
			if(dimList!=null){
				for(Dimsion dim : dimList){
					dimIdList.add(dim.getVarname());
				} 
			}
			viewObj.getDimsions().setDimsionList(new ArrayList<Dimsion>());
		}
		if(viewObj.getDatasources()!=null){
			viewObj.getDatasources().setDatasourceList(new ArrayList<Datasource>());
		}
		if(viewObj.getKpistores()!=null){
			viewObj.getKpistores().setKpistoreList(new ArrayList<Kpistore>());
		}
		resultMap.put("containerIdList", containerIdList);
		resultMap.put("dimIdList", dimIdList);
		saveToXmlByObj(viewObj);
		return resultMap;
	}
	
	
	@SuppressWarnings("unchecked")
	public void setTheme(Map<String,String> data){
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		String theme=data.get("theme");
		String currentColor=data.get("currentColor");
		viewObj.setTheme(theme);
		List<Container> containerList=viewObj.getContainers().getContainerList();
		if(containerList!=null){
			for(Container tempContainer:containerList){
				tempContainer.setBgclass(currentColor);
			}
		}
		saveToXmlByObj(viewObj);
	}
	
	@SuppressWarnings("unchecked")
	public void setLHtml(Map<String,String> data){
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		viewObj.getLayout().setValue(Base64.encodeBase64String(data.get("lhtml").getBytes()));
		
		if(data.get("cid") != null && data.get("width") != null && data.get("height") != null){
			String id = data.get("cid");
			List<Container> containers = viewObj.getContainers().getContainerList();
			for(int c=0;c<containers.size();c++){
				if(containers.get(c).getId().equals(id)){
					containers.get(c).setWidth(data.get("width"));
					containers.get(c).setHeight(data.get("height"));
				}
			}
		}
		saveToXmlByObj(viewObj);
	}
	
	@SuppressWarnings("unchecked")
	public void addLayoutLi(Map<String,String> data){
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		List<Container> containers = viewObj.getContainers().getContainerList();
		Container container = new Container();
		container.setId2(data.get("lid")).setType2("").setTitle2("").setBgclass2("").setPop2("").setComponents2(new Components());
		container.setWidth("334");
		container.setHeight("334");
		containers.add(container);
		viewObj.getLayout().setValue(Base64.encodeBase64String(data.get("lhtml").getBytes()));
		saveToXmlByObj(viewObj);
	}
	@SuppressWarnings("unchecked")
	public void addLayoutMultiLi(Map<String,String> data){
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		viewObj.getLayout().setValue(Base64.encodeBase64String(data.get("lhtml").getBytes()));
		
		Containers containers = new Containers();
		List<Container> containerList = new ArrayList<Container>();
		
		String[] contwArr = data.get("contws").split(",");
		Document doc = Jsoup.parse(data.get("lhtml"));
		Elements trs = doc.select("ul");
		for (Element tr : trs) {
			Elements tds = tr.select("li");
			int i=0;
			for (Element td : tds) {
				
				String id = td.attr("id");
				if(id != null && id.length()>0){
					String contw = contwArr[i];
					Container container = new Container();
					Components components = new Components();
					container.setId2(id).setType2("").setTitle2("").setBgclass2("").setPop2("").setComponents2(components);
					container.setWidth(contw);
					container.setHeight("334");
					containerList.add(container);
					i++;
				}
			}
		}
		containers.setContainerList(containerList);
		viewObj.setContainers(containers);
		saveToXmlByObj(viewObj);
		
	}
	
	@SuppressWarnings("unchecked")
	public void removeLayoutLi(Map<String,String> data){
		String lid = data.get("lid");
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		List<Container> containers = viewObj.getContainers().getContainerList();
		for(int c=0;c<containers.size();c++){
			String id = containers.get(c).getId();
			if(id.equals(lid)){
				containers.remove(c);
				break;
			}
		}
		viewObj.getLayout().setValue(Base64.encodeBase64String(data.get("lhtml").getBytes()));
		saveToXmlByObj(viewObj);
	}
	
	@SuppressWarnings("unchecked")
	public String hasEvents(String xid,String contid,String compid){
		Report report = readFromXmlByViewId(xid);
		List<Container> containers = report.getContainers().getContainerList();
		
		Map<String,String> hasEvents = new HashMap<String,String>();
		Map<String,String[]> allComps = new HashMap<String,String[]>();
		for(int c=0;c<containers.size();c++){
			Container container = containers.get(c);
			List<Component> components = container.getComponents().getComponentList();
			if(components != null && components.size()>0){
				String[] ids = new String[components.size()];
				for(int m=0;m<components.size();m++){
					Component component = components.get(m);
					Datastore datastore = component.getDatastore();
					ids[m] = component.getId()+","+component.getTitle();
					if(datastore != null && datastore.getDatacolList() !=null && datastore.getDatacolList().size()>0){
						List<Datacol> datacols = datastore.getDatacolList();
						for(int d=0;d<datacols.size();d++){
							Datacol datacol = datacols.get(d);
							Eventstore eventstore = datacol.getEventstore();
							if(eventstore != null && eventstore.getEventList() != null && eventstore.getEventList().size()>0){
								List<Event> events = eventstore.getEventList();
								String name = eventstore.getType().equals("link")?"连接":"联动";
								for(int e=0;e<events.size();e++){
									Event event = events.get(e);
									if(event != null && event.getSource() != null){
										hasEvents.put(event.getSource(),component.getTitle()+","+name);
									}else{
										continue;
									}
								}
							}else{
								continue;
							}
						}
					}else{
						continue;
					}
				}
				allComps.put(container.getId(),ids);
			}else{
				continue;
			}
		}
		if(hasEvents.size()<=0){
			return "";
		}
		if(compid != null && !compid.equals("")){
			String v = hasEvents.get(compid);
			if(v != null && !v.equals("")){
				return v;
			}
		}
		if(contid != null && !contid.equals("")){
			String[] comps = allComps.get(contid);
			if(comps == null || comps.length<=0){
				return "";
			}
			StringBuffer content = new StringBuffer();
			for(String tmpComp : comps){
				String[] data = tmpComp.split(",");
				String v = hasEvents.get(data[0]);
				if(v != null && !v.equals("")){
					String[] vArr = v.split(",");
					content.append(data[1]+"\"被\""+vArr[0]+"\"设置了\""+vArr[1]+",");
				}
			}
			return content.length()>0?content.deleteCharAt(content.length()-1).toString():"";
		}
		return "";
	}
	
	@SuppressWarnings("unchecked")
	public String removeAllLayoutLi(String xid){
		Report viewObj = readFromXmlByViewId(xid);
		viewObj.getContainers().getContainerList().clear();
		viewObj.getLayout().setValue("");
		saveToXmlByObj(viewObj);
		return "success";
	}
	
	@SuppressWarnings("unchecked")
	public void setModifyUser(Map<String,String> data){
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		viewObj.getInfo().setModifyUser2(data.get("userId")).setModifyTime(new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));
		saveToXmlByObj(viewObj);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String,String> seacherComp(Map<String,String> data){
		Report viewObj = readFromXmlByViewId(data.get("xid"));
		List<Container> containers = viewObj.getContainers().getContainerList();
		for(int c=0;c<containers.size();c++){
			if(containers.get(c).getId().equals(data.get("conid"))){
				Container container = containers.get(c);
				List<Component> components = container.getComponents().getComponentList();
				if(components != null && components.size()==1){
					Map<String,String> infoMap = new HashMap<String,String>();
					infoMap.put("type", container.getType());
					infoMap.put("compid", components.get(0).getId());
					infoMap.put("propurl", components.get(0).getPropertyUrl());
					infoMap.put("temurl", components.get(0).getUrl());
					return infoMap;
				}
			}else{
				continue;
			}
		}
		return null;
	}
}