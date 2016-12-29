package cn.com.easy.xbuilder.action;

import java.io.IOException;
import java.io.PrintWriter;
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
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Info;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.parser.Generate;
import cn.com.easy.xbuilder.parser.XBuilder;
import cn.com.easy.xbuilder.parser.XDirector;
import cn.com.easy.xbuilder.parser.XGenerateDgst;
import cn.com.easy.xbuilder.rmi.SyncJspRmiServer;
import cn.com.easy.xbuilder.service.XBaseService;

@Controller
public class XController extends XBaseService{
	private SqlRunner runner;
	private final String errjsp = "/pages/xbuilder/pagedesigner/error.jsp";
	private HttpSession gSession;
	// 生成jsp文件
	@Action("xGenerate")
	public void xGenerate(String xid,String slw, String type,String edit,HttpServletRequest request, HttpServletResponse response) {
		String err = request.getContextPath()+this.errjsp;
		HttpSession session = request.getSession();
		session.removeAttribute("ErrorMessage");
		
		try {
			if (xid == null || xid.equals("")) {
				session.setAttribute("ErrorMessage", "报表编号参数为空");
				response.sendRedirect(err);
			}
			if (type == null || type.equals("")) {
				session.setAttribute("ErrorMessage", "类型参数为空");
				response.sendRedirect(err);
			}
			Report report = readFromXmlNoCatch(xid,false);
			if(null != slw && !"".equals(slw)){
				report.getLayout().setWidth(slw);
			}
			//Report report = readFromXmlByViewId(xid);

			if (report == null) {
				session.setAttribute("ErrorMessage", "没有找到编号为" + xid
						+ "的报表");
				response.sendRedirect(err);
			}
			
			if(type.equals("1")){
				this.save(report, request);
			}else{
/*				String xsavedmode = String.valueOf(EasyContext.getContext().getServletcontext().getAttribute("xsavedmode"));
				if(null == xsavedmode || "0".equals(xsavedmode)){*/
					this.upeState4(report,edit);
				//}
			}
			XDirector director = new XDirector(new XBuilder(report,type,runner));
			Generate generate = director.construct();
			String jsp = generate.getJsp();

			if (jsp != null && !jsp.equals("")) {
				String deplyMode = String.valueOf(request.getSession().getServletContext().getAttribute("xbuilderDeployMode"));
				if("cluster".equals(deplyMode)&&"1".equals(type)){//集群模式时同步生成的jsp文件
					String versionId="1";
					String versionSql = "select max(t.version) \"VERSION\" from x_JSP_VERSION t where t.xid='"+xid+"'";
					Map versionMap = runner.queryForMap(versionSql);
					if(versionMap!=null){
						versionId = String.valueOf(versionMap.get("VERSION"));
					}
					gSession = request.getSession();
					saveJspSyncTable(xid);
					synUsePage(xid,versionId);
				}
				response.sendRedirect(jsp+"?deve=1");
			} else {
				String errorStr=generate.getError();
				StringBuilder sBuilder=new StringBuilder();
				int index=0;
				for(String tempStr:errorStr.split("\\|\\|\\|\\|")){
					if("".equals(tempStr.trim())){
						sBuilder.append(tempStr);
						continue;
						
					}
					sBuilder.append((++index)+"、").append(tempStr);
				}
				session.setAttribute("ErrorMessage", sBuilder.toString());
				response.sendRedirect(err);
			}
		} catch (Exception e) {
			e.printStackTrace();
			try {
				session.setAttribute("ErrorMessage",e.getMessage());
				response.sendRedirect(err);
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}
	@Action("buildwhlt")
	public void buildwhlt(String xid, String contjson,HttpServletRequest request, HttpServletResponse response) {
		String sql = "UPDATE x_report_info SET CONTJSON='"+contjson+"' WHERE ID='"+xid+"'";
		try {
			runner.execute(sql);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@Action("getDLWidth")
	public void getDLWidth(String xid,HttpServletRequest request, HttpServletResponse response) {
		try {
			String w = "0";
			Report report = readFromXmlByViewId(xid);
			if(report != null){
				w = report.getLayout().getWidth();
			}
			response.getWriter().print(w);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 
	 * 更新报表为预览状态
	 */
	public boolean upeState4(Report view,String state) throws SQLException{
		String stateFiled = (null != state && "1".equals(state))?"":",STATE='"+state+"'";
		
		String select = "select STATE \"STATE\" from x_report_info where id='"+view.getId()+"'";
		Map record = runner.queryForMap(select);
		if(record != null){
			String statetmp = String.valueOf(record.get("STATE"));
			if(statetmp.equals("1")){
				stateFiled = "";
			}
		}
		
		String saveSql = "UPDATE x_report_info SET NAME =#name#"+stateFiled+",MODIFY_USER=#MODIFY_USER#,MODIFY_TIME='"+Functions.getDate("yyyyMMddHHmmss")+"' WHERE ID=#xid#";
		Info info = view.getInfo();
		Map<String,String> paramMap = new HashMap<String,String>();
		paramMap.put("xid", view.getId());
		paramMap.put("name",info.getName());
		paramMap.put("CREATE_TIME",info.getCreateTime());
		paramMap.put("MODIFY_USER",info.getModifyUser());
		
		int n = runner.execute(saveSql, paramMap);
		if(n >0){
			return true;
		}else{
			return false;
		}
	}
	/**
	 * 
	 * 保存视图到表
	 */
	public boolean save(Report view,HttpServletRequest request) throws SQLException{
		String saveSql = "UPDATE x_report_info SET NAME=#NAME#,THEME=#THEME#,URL=#URL#,AREA_NO=#AREA_NO#,STATE='3',CREATE_USER=#CREATE_USER#,MODIFY_USER=#MODIFY_USER#,MODIFY_TIME='"+Functions.getDate("yyyyMMddHHmmss")+"' WHERE ID=#xid#";
		String select = "select STATE \"STATE\" from x_report_info where id='"+view.getId()+"'";
		
		Map record = runner.queryForMap(select);
		if(record == null){
			saveSql = "insert into x_report_info(ID,NAME,THEME,URL,AREA_NO,STATE,CREATE_USER,CREATE_TIME,MODIFY_USER,MODIFY_TIME) values(#xid#,#NAME#,#THEME#,#URL#,#AREA_NO#,'3',#CREATE_USER#,'"+Functions.getDate("yyyyMMddHHmmss")+"',#MODIFY_USER#,'"+Functions.getDate("yyyyMMddHHmmss")+"')";
		}else{
			String state = String.valueOf(record.get("STATE"));
			if(state.equals("1")){
				saveSql = "UPDATE x_report_info SET NAME=#NAME#,THEME=#THEME#,URL=#URL#,AREA_NO=#AREA_NO#,CREATE_USER=#CREATE_USER#,MODIFY_USER=#MODIFY_USER#,MODIFY_TIME='"+Functions.getDate("yyyyMMddHHmmss")+"' WHERE ID=#xid#";
			}
		}
		
		Info info = view.getInfo();
		Map<String,String> paramMap = new HashMap<String,String>();
		paramMap.put("xid", view.getId());
		paramMap.put("NAME", info.getName());
		paramMap.put("THEME",view.getTheme());
		paramMap.put("URL",info.getUrl());
		paramMap.put("AREA_NO",(String)request.getSession().getAttribute("AREA_NO"));
		paramMap.put("CREATE_USER",info.getCreateUser());
		paramMap.put("MODIFY_USER",info.getModifyUser());
		
		int n = runner.execute(saveSql, paramMap);
		if(n >0){
			return true;
		}else{
			return false;
		}
	}
	
	//编辑
	@Action("xLiEdit")
	public String xLiEdit(String xid,String slw,HttpServletRequest request, HttpServletResponse response){
		String url = this.errjsp;
		String datasourceSaveType=EasyContext.getContext().getServletcontext().getAttribute("xdatasourcesavetype")==null?"":String.valueOf(EasyContext.getContext().getServletcontext().getAttribute("xdatasourcesavetype"));
		Report view = null;
		if("".equals(datasourceSaveType)||"null".equals(datasourceSaveType.toLowerCase())||"1".equals(datasourceSaveType)){
			view = readFromXmlByViewId(xid,false);
		}else if ("2".equals(datasourceSaveType)) {
			view = readFromXml(xid,false);
		}
		
		if(view!=null){
			
			StringBuffer layout = new StringBuffer();
			layout.append("<div id=\"selectable_layout_id001\" class=\"gridster ready\">");
			String html = new String(Base64.decodeBase64(view.getLayout().getValue()));
			
			List<Component> comps = new ArrayList<Component>();
			Map<String,Component> maps = new HashMap<String,Component>();
			StringBuffer javaScript = new StringBuffer();
			List<Container> containers = view.getContainers().getContainerList();
			
			String ltype = view.getInfo().getLtype();
			if(ltype.equals("2")){
				javaScript.append("$('#phoneToggle').click();").append("\n");
			}
			int tmpI = 0;
/*			Document doc = Jsoup.parse(html);
			
			Elements trs = doc.select("ul").eq(0);
			for (Element tr : trs) {

				Elements tds = tr.children();
				for (Element td : tds) {
					td.removeAttr("data-sizex");
					String ustl = tr.attr("style");
					if(null != ustl && ustl.indexOf("width")==-1){
						tr.attr("style",ustl+"width: 1872px;");
					}
				}
			}*/
			
			for(int c=0;c<containers.size();c++){
				Container container = containers.get(c);
				List<Component> components = container.getComponents().getComponentList();
				int size = (components == null || components.size()<=0)?0:components.size();
				
				String cid = container.getId();
				int cidI = Integer.parseInt(cid.substring(cid.lastIndexOf("_")+1));
				tmpI = cidI>tmpI?cidI:tmpI;
				
				String type = container.getType();
				if(size != 0){
					if(type.equals("1")){
						String temurl = components.get(0).getUrl();
						String symbol = temurl.indexOf("?")==-1?"?":"&";
						temurl+=symbol+"reportId="+xid+"&containerId="+cid+"&componentId="+components.get(0).getId()+"&ispop=";
						temurl=temurl.substring(temurl.indexOf("pages/xbuilder/component/"));//为防止源数据模板的路径中有项目名称
						javaScript.append("$('#div_body_"+cid+"').load(appBase+'/"+temurl+"',function(data){").append("\n");
						javaScript.append("$.parser.parse($('#div_body_"+cid+"'));").append("\n");
						javaScript.append("});").append("\n");
					}else if(type.equals("2") || type.equals("3")){
						javaScript.append("$('#div_head_li_"+cid+"_"+components.get(0).getId()+"_value').click();").append("\n");
					}
				}
				if(components!=null){
					comps.addAll(components);
				}
				
				//doc.getElementsByAttributeValue("id","div_body_"+container.getId()).first().attr("style","width:"+container.getWidth()+"px;height:"+container.getHeight()+"px;");
			}
			
			for(Component comp:comps){
				maps.put(comp.getId(), comp);
			}
			javaScript.append("StoreData.components = "+Functions.java2json(maps));
			
			layout.append(html);
			layout.append("</div>");
			request.setAttribute("VIEW_",view);
			request.setAttribute("VIEW_LAYOUT_",layout.toString());
			request.setAttribute("LOAD_JS_",javaScript.toString());
			request.setAttribute("MAX_I_",String.valueOf(tmpI));
			request.setAttribute("SCREEN_WIDTH_",slw);
			
			url = "pages/xbuilder/pagedesigner/XBedit.jsp";
		}else{
			request.getSession().setAttribute("ErrorMessage", "页面源数据不存在，无法恢复<br/>");
			url = "/pages/xbuilder/pagedesigner/error.jsp";
		}
		return url;
	}
	
	//编辑
	@Action("getXContainerInfo")
	public void getXContainerInfo(String vd,HttpServletRequest request, HttpServletResponse response){
		String vid = vd.substring(0, vd.lastIndexOf("_"));
		Report view = readFromXmlByViewId(vid);
		StringBuffer javaScript = new StringBuffer();
		List<Container> containers = view.getContainers().getContainerList();
		for(int c=0;c<containers.size();c++){
			Container container = containers.get(c);
			String cid = container.getId();
			if(cid.equals(vd)){
				List<Component> components = container.getComponents().getComponentList();
				int size = (components == null || components.size()<=0)?0:components.size();
				String type = container.getType();
				if(size != 0){
					if(type.equals("1")){
						Component baseComponent = null;
						if(container.getPop()!=null&&!"".equals(container.getPop())){
							for(Component comp : components){
								if(!comp.getId().equals(container.getPop())){
									baseComponent = comp;
									break;
								}
							}
						}else{
							baseComponent = components.get(0);
						}
						String fullUrl = "";
						if(baseComponent.getUrl().indexOf("?")==-1){
							fullUrl = baseComponent.getUrl()+"?reportId="+vid+"&componentId="+components.get(0).getId()+"&containerId="+cid;
						}else{
							fullUrl = baseComponent.getUrl()+"&reportId="+vid+"&componentId="+components.get(0).getId()+"&containerId="+cid;
						}
						javaScript.append("$('#div_body_"+cid+"').load(appBase+'/"+fullUrl+"',function(data){$.parser.parse($('#div_body_"+cid+"'));});").append("\n");
					}else if(type.equals("2") || type.equals("3")){
						javaScript.append("$('#div_head_li_"+cid+"_"+components.get(0).getId()+"_value').click();").append("\n");
					}
				}
				break;
			}
		}
		try {
			response.getWriter().print(javaScript.toString());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	//复制
	@Action("copyReport")
	public String copyReport(String xid,String slw,HttpServletRequest request, HttpServletResponse response){
		String url = this.errjsp;
		Connection conn = null;
		Statement state = null;
		try {
			Report report = readFromXmlByViewId(xid);
			if(report!=null){
				String nid = UUID.randomUUID().toString().replaceAll("-","");
				XContext.removeEditView(xid);
				XContext.removeEditView(nid);
				XContext.removeFormalView(xid);
				XContext.removeFormalView(nid);
				report.setId(nid);
				String time = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
				String userid = String.valueOf(request.getSession().getAttribute("USER_ID"));
				String areano = String.valueOf(request.getSession().getAttribute("AREA_NO"));
				report.getInfo().setName2(report.getInfo().getName()+"_复制").setUrl2("pages/xbuilder/usepage/formal/"+nid+"/formal_"+nid+".jsp").setCreateUser2(userid).setCreateTime2(time);
					
				String oly = new String(Base64.decodeBase64(report.getLayout().getValue()));
				String nly = oly.replaceAll(xid, nid);
				report.getLayout().setValue(Base64.encodeBase64String(nly.getBytes()));
				
				List<Container> containers = report.getContainers().getContainerList();
				for(int c=0;c<containers.size();c++){
					Container container = containers.get(c);
					String ocid = container.getId();
					String ncid = ocid.replaceAll(xid, nid);
					containers.get(c).setId(ncid);
				}
				
				try {
					conn = EasyContext.getContext().getDataSource().getConnection();
					state = conn.createStatement();
					ResultSet rs = state.executeQuery("select * from x_report_info where id='"+nid+"'");
					if(!rs.next()){
						String saveSql = "insert into x_report_info(ID,NAME,THEME,URL,AREA_NO,STATE,CREATE_USER,CREATE_TIME,MODIFY_USER,MODIFY_TIME) values('"+nid+"','"+report.getInfo().getName()+"','','pages/xbuilder/usepage/formal/"+ nid + "/formal_"+nid+".jsp','"+areano+"','4','"+userid+"','"+Functions.getDate("yyyyMMddHHmmss")+"','"+userid+"','"+Functions.getDate("yyyyMMddHHmmss")+"')";
						state.executeUpdate(saveSql);
					}
					rs.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}finally{
					try {
						state.close();
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
				saveToXmlByObj(report);
				url = this.xLiEdit(nid,slw, request, response);
			}else{
				request.getSession().setAttribute("ErrorMessage", "页面源数据不存在，无法复制<br/>");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return url;
	}
	
	//删除
	@Action("xRemove")
	public void xRemove(String xid,HttpServletRequest request, HttpServletResponse response){
		try {
			int record = runner.execute("delete from x_report_info where id='"+xid+"'");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Action("datagridsubtotal")
	public void datagridsubtotal(Map args,HttpServletRequest request, HttpServletResponse response){
		PrintWriter out = null;
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			
			Map<String,String> params = null;
			String xidtype = args.get("xid").getClass().toString();
			if("class [Ljava.lang.String;".equals(xidtype)){
				params = new HashMap<String,String>();
				for(Object key:args.keySet()){
					Object v = args.get(key);
					String val = v.getClass().toString().equals("class [Ljava.lang.String;")?String.valueOf(((String[])v)[0]):String.valueOf(v);
					params.put(String.valueOf(key), val);
				}
			}else{
				params = (Map<String,String>)args;
			}
			
			String err = request.getContextPath()+this.errjsp;
			HttpSession session = request.getSession();
			session.removeAttribute("ErrorMessage");
			if (params.get("xid") == null || params.get("xid").equals("")) {
				session.setAttribute("ErrorMessage", "报表编号参数为空");
				response.sendRedirect(err);
			}
			if (params.get("type") == null || params.get("type").equals("")) {
				session.setAttribute("ErrorMessage", "类型参数为空");
				response.sendRedirect(err);
			}
			Report report = readFromXmlNoCatch(params.get("xid"),false);
			XGenerateDgst dgst = new XGenerateDgst(report,params,runner,request);
			String datajson = dgst.getJson();
			
			String isdown = params.get("is_down_table");
			if(!"true".equals(isdown)){
				out = response.getWriter();
				out.print(datajson);
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
     * 同步生成的jsp文件到集群其他tomcat
     */
	private void synUsePage(final String reportId,final String versionId){
	   new Thread(new Runnable(){
			@SuppressWarnings({ "unchecked", "rawtypes" })
			@Override
			public void run() {
				String createUser = ((Map)gSession.getAttribute("UserInfo")).get("USER_ID")+"";
				SyncJspRmiServer rmi = new SyncJspRmiServer();
				try {
					Map paramMap = new HashMap<String,Object>();
					paramMap.put("reportId", reportId);
					paramMap.put("versionId", versionId);
					paramMap.put("createUser", createUser);
					gSession.setAttribute("isSyncFinished", "0");
					rmi.synUsePageFile(runner,paramMap,gSession);
				} catch (Exception e) {
					System.out.println("同步jsp文件到其他服务器时发生异常！");
					e.printStackTrace();
				}
			}
		}).start();
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void saveJspSyncTable(String xid){
		String sysid = (String)EasyContext.getContext().getServletcontext().getAttribute("localRmiLocation");
		String sql = runner.sql("xbuilder.syncJsp.getJspSyncInfo");
		try {
			Map paramMap = new HashMap();
			paramMap.put("xid",xid);
			paramMap.put("sysid", sysid);
			List<Map> list = (List<Map>)runner.queryForMapList(sql,paramMap);
			if(list!=null&&list.size()>0){
				Map map = list.get(0);
				String version = map.get("VERSION")+"";
				sql = runner.sql("xbuilder.syncJsp.updateJspSyncInfo");
				paramMap.put("version", ""+(Integer.parseInt(version)+1));
			}else{
				sql = runner.sql("xbuilder.syncJsp.insertJspSyncInfo");
			}
			runner.execute(sql, paramMap);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 同步集群中所有tomcat的文件
	 * @param request
	 * @param response
	 */
	@Action("syncAllJspPage")
	public void syncAllJspPage(HttpServletRequest request, HttpServletResponse response){
		PrintWriter out = null;
		response.setContentType("text/html");
		response.setHeader("Cache-Control", "no-cache");
		try {
			out = response.getWriter();
			try{
				gSession = request.getSession();
				synUsePage("all","");
				out.print("1");
			}catch(Exception e){
				e.printStackTrace();
				out.print("0");
			}
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 获得是否完成同步
	 * @param request
	 * @param response
	 */
	@Action("isSyncFinished")
	public void isSyncFinished(HttpServletRequest request, HttpServletResponse response){
		PrintWriter out = null;
		response.setContentType("text/html");
		response.setHeader("Cache-Control", "no-cache");
		try {
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			String errMsg = request.getSession().getAttribute("syncErrMsg")+"";
			if(!"null".equals(errMsg)&&!"".equals(errMsg)){
				out.print(request.getSession().getAttribute("syncErrMsg"));
			}else{
				out.print(request.getSession().getAttribute("isSyncFinished"));
			}
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}