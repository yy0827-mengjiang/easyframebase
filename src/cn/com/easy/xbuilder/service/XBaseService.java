package cn.com.easy.xbuilder.service;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import cn.com.easy.core.EasyContext;
import cn.com.easy.exception.JaxbException;
import cn.com.easy.jaxb.parser.DefaultJaxbParse;
import cn.com.easy.jaxb.parser.JaxbParse;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.utils.ClobDbUtil;

public class XBaseService {
	private String classPath = this.getClass().getClassLoader().getResource("/").getPath();
	private String TmpPagePath = "pages/xbuilder/usepage/temp/";
	private String FormalPagePath = "pages/xbuilder/usepage/formal/";
	private String datasourceSaveType=EasyContext.getContext().getServletcontext().getAttribute("xdatasourcesavetype")==null?"":String.valueOf(EasyContext.getContext().getServletcontext().getAttribute("xdatasourcesavetype"));
	
	
	/*	描述：从源数据中读取报表对象
	 *  参数：
	 *  	Viewid 报表id
	 *  返回值：报表对象实例
	 * */
	public Report readFromXmlByViewId(String Viewid) {
		
		return readFromXmlByViewId(Viewid,false);
	}
	/*	描述：从源数据中读取报表对象
	 *  参数：
	 *  	Viewid 报表id
	 *  	isFormal 是否正式
	 *  返回值：报表对象实例
	 * */
	public Report readFromXmlByViewId(String ViewId, boolean isFormal) {
		Report View = null;
		if(isFormal){
			View = XContext.getFormalView(ViewId);
		} else {
			View = XContext.getEditView(ViewId);
		}
		if(View==null){
			View = this.readFromXml(ViewId, isFormal);
		}
		return View;
	}
	/*	描述：从源数据中读取报表对象
	 *  参数：
	 *  	Viewid 报表id
	 *  	isFormal 是否正式
	 *  返回值：报表对象实例
	 * */
	public Report readFromXml(String ViewId, boolean isFormal) {
		Report View = null;
		JaxbParse jaxb = new DefaultJaxbParse();
		if("".equals(datasourceSaveType)||"null".equals(datasourceSaveType.toLowerCase())||"1".equals(datasourceSaveType)){//xml文件方式存储源数据
			String path = null;
			if(isFormal){
				path = classPath.replace("WEB-INF/classes/", "") + FormalPagePath+ ViewId + "/";
			} else {
				path = classPath.replace("WEB-INF/classes/", "") + TmpPagePath+ ViewId + "/";
			}
			if((!(new File(path).exists()))){
				return null;
			}
			String moduleXmlPath = path + "Source_" + ViewId + ".xml";
			try {
				View = jaxb.read(Report.class, moduleXmlPath);
				if(isFormal){
					XContext.addFormalView(View);
				} else {
					XContext.addEditView(View);
				}
			} catch (JaxbException e) {
				e.printStackTrace();
			}
				
		}else if ("2".equals(datasourceSaveType)) {//数据库方式存储源数据
			try {
				String reportStr=null;
				ClobDbUtil clobDbUtil=new ClobDbUtil();
				Connection conn = clobDbUtil.openClobConnection();    
				PreparedStatement pstmt =null;
				if(isFormal){
					pstmt=conn.prepareStatement("SELECT SOURCE_DATA_FORMAL FROM X_REPORT_INFO WHERE ID=?");
				}else{
					pstmt=conn.prepareStatement("SELECT SOURCE_DATA_TEMP FROM X_REPORT_INFO WHERE ID=?");
				}	
				pstmt.setString(1, ViewId);
				ResultSet rs = pstmt.executeQuery();
				if(rs.next()){
					reportStr=rs.getString(1);
				}
				clobDbUtil.closeClobConnection();
				if(reportStr!=null&&(!("".equals(reportStr.toLowerCase())))){
					View = jaxb.readXmlStr(Report.class, reportStr);
					if(isFormal){
						XContext.addFormalView(View);
					} else {
						XContext.addEditView(View);
					}
					
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (JaxbException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
			
			
		}else{
			System.err.println("xdatasourcesavetype属性配置的不正确");
		}
	return View;
	}
	public Report readFromXmlNoCatch(String ViewId, boolean isFormal) {
		Report View = null;
		JaxbParse jaxb = new DefaultJaxbParse();
		if("".equals(datasourceSaveType)||"null".equals(datasourceSaveType.toLowerCase())||"1".equals(datasourceSaveType)){//xml文件方式存储源数据
			String path = null;
			if(isFormal){
				path = classPath.replace("WEB-INF/classes/", "") + FormalPagePath+ ViewId + "/";
			} else {
				path = classPath.replace("WEB-INF/classes/", "") + TmpPagePath+ ViewId + "/";
			}
			if((!(new File(path).exists()))){
				return null;
			}
			String moduleXmlPath = path + "Source_" + ViewId + ".xml";
			try {
				View = jaxb.read(Report.class, moduleXmlPath);
			} catch (JaxbException e) {
				e.printStackTrace();
			}
				
		}else if ("2".equals(datasourceSaveType)) {//数据库方式存储源数据
			try {
				String reportStr=null;
				ClobDbUtil clobDbUtil=new ClobDbUtil();
				Connection conn = clobDbUtil.openClobConnection();    
				PreparedStatement pstmt =null;
				if(isFormal){
					pstmt=conn.prepareStatement("SELECT SOURCE_DATA_FORMAL FROM X_REPORT_INFO WHERE ID=?");
				}else{
					pstmt=conn.prepareStatement("SELECT SOURCE_DATA_TEMP FROM X_REPORT_INFO WHERE ID=?");
				}	
				pstmt.setString(1, ViewId);
				ResultSet rs = pstmt.executeQuery();
				if(rs.next()){
					reportStr=rs.getString(1);
				}
				clobDbUtil.closeClobConnection();
				if(reportStr!=null&&(!("".equals(reportStr.toLowerCase())))){
					View = jaxb.readXmlStr(Report.class, reportStr);
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (JaxbException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
			
			
		}else{
			System.err.println("xdatasourcesavetype属性配置的不正确");
		}
	return View;
	}
	
	/*	描述：保存报表到源数据中去，并更新缓存
	 *  参数：
	 *  	View 报表对象实例
	 *  返回值：无
	 * */
	public void saveToXmlByObj(Report View){
		/*PropertyResourceBundle prb = (PropertyResourceBundle) PropertyResourceBundle.getBundle("jdbc");
		System.out.println("EasyContext.getContext().getDataSource().getDataSourceType():"+EasyContext.getContext().getDataSource().getDataSourceType());
		try {
			System.out.println("EasyContext.getContext().getDataSource().getConnection().getMetaData().getDatabaseProductVersion():"+EasyContext.getContext().getDataSource().getConnection().getMetaData().getDatabaseProductVersion());
			System.out.println("jdbc.username:"+prb.getString("jdbc.username"));
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		saveToXmlByObj(View,false);
		/*保存组件到Map中缓存*/
		List<Container> containerList = View.getContainers().getContainerList();
		if(containerList!=null){
			for(Container container : containerList){
				List<Component> componentList = container.getComponents().getComponentList();
				if(componentList!=null){
					for(Component component : componentList){
						XContext.addComponentToCacheMap(View.getId(), component);
					}
				}
			}
		}
	}
	
	/*	描述：保存报表到源数据中去
	 *  参数：
	 *  	View 报表对象实例
	 *  	isFormal 是否正式
	 *  返回值：无
	 * */
	
	@SuppressWarnings("unchecked")
	public void saveToXmlByObj(Report View,boolean isFormal){
		
		String Viewid=View.getId();
		/*保存报表id到缓存中*/
		HttpSession session = EasyContext.getContext().getRequest().getSession();
		if(session.getAttribute("currentEditViewIdMap")==null){
			session.setAttribute("currentEditViewIdMap",new HashMap<String,String>());
		}
		((HashMap<String,String>)session.getAttribute("currentEditViewIdMap")).put(Viewid,Viewid);
		
		/*保存报表对象到缓存中*/
		if(isFormal){
			XContext.addFormalView(View);
		}else{
			XContext.addEditView(View);
		}	
		/*保存数据到源数据中*/
		JaxbParse jaxb = new DefaultJaxbParse();
		if("".equals(datasourceSaveType)||"null".equals(datasourceSaveType.toLowerCase())||"1".equals(datasourceSaveType)){//xml文件方式存储源数据
			String path =null;
			if(isFormal){
				path=classPath.replace("WEB-INF/classes/", "") + FormalPagePath+ Viewid + "/";
			}else{
				path=classPath.replace("WEB-INF/classes/", "") + TmpPagePath+ Viewid + "/";
			}	
			String moduleXmlPath = path + "Source_" + Viewid + ".xml";
			try {
				File file = new File(moduleXmlPath);
				if (!file.exists()){
					if (!file.getParentFile().exists()) {
						file.getParentFile().mkdirs();
					}
					file.createNewFile();
				}
				jaxb.write(Report.class, View, moduleXmlPath);
			} catch (JaxbException e) {
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}else if ("2".equals(datasourceSaveType)) {//数据库方式存储源数据
			try {
				String reportStr=jaxb.getXmlString(Report.class, View);
				ClobDbUtil clobDbUtil=new ClobDbUtil();
				Connection conn = clobDbUtil.openClobConnection();        
				PreparedStatement pstmt =null;
				if(isFormal){
					pstmt=conn.prepareStatement("UPDATE X_REPORT_INFO SET SOURCE_DATA_FORMAL=? WHERE ID=?");
				}else{
					pstmt=conn.prepareStatement("UPDATE X_REPORT_INFO SET SOURCE_DATA_TEMP=? WHERE ID=?");
				}	
				
		        StringReader reader = new StringReader(reportStr); 
		        pstmt.setCharacterStream(1, reader, reportStr.length());  
				pstmt.setString(2, View.getId());
				pstmt.executeUpdate();
				clobDbUtil.closeClobConnection();
			} catch (SQLException e) {
				e.printStackTrace();
			} catch (JaxbException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}else{
			
			System.err.println("xdatasourcesavetype属性配置的不正确");
		}
	}
}