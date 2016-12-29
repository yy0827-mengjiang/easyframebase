package cn.com.easy.xbuilder.action;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.taglib.util.TreeheadHelper;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Components;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Containers;
import cn.com.easy.xbuilder.element.Crosscol;
import cn.com.easy.xbuilder.element.Crosscolstore;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Datasources;
import cn.com.easy.xbuilder.element.Datastore;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Dimsions;
import cn.com.easy.xbuilder.element.Extcolumn;
import cn.com.easy.xbuilder.element.Info;
import cn.com.easy.xbuilder.element.Kpistore;
import cn.com.easy.xbuilder.element.KpistoreCol;
import cn.com.easy.xbuilder.element.Kpistores;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Subdrill;
import cn.com.easy.xbuilder.element.Subdrills;
import cn.com.easy.xbuilder.parser.ReportConverteContext;
import cn.com.easy.xbuilder.service.DataCrossService;
import cn.com.easy.xbuilder.service.DataSetService;
import cn.com.easy.xbuilder.service.XBaseService;
import cn.com.easy.xbuilder.service.component.ComponentBaseService;

@Controller
public class ComponentJsonAction extends ComponentBaseService{
	
	private SqlRunner runner ;
	/**
	 * 交叉表Action
	 * @param request
	 * @param response
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	@Action("crossDataJson")
	public String crossDataJson(HttpServletRequest request, HttpServletResponse response,Map<String,String> paramMap) throws Exception{
		
		String reportId = paramMap.get("reportId");
		String containerId = paramMap.get("containerId");
		String componentId = paramMap.get("componentId");
		String type = paramMap.get("TitleType");
		Report report = new Report();
		report.setId(reportId);
		
		StringBuilder downParamsStringBuilder=new StringBuilder();
		//获得源数据对象
		//XBaseService base = new XBaseService();
		ComponentBaseService serv = new ComponentBaseService();
		//report = base.readFromXmlByViewId(reportId);
		report = readFromXmlNoCatch(reportId,false);
		ReportConverteContext reportConverter = new ReportConverteContext();
		report = reportConverter.converter(report);
		Component comp = serv.getOrCreateComponet(report,containerId,componentId);
		List<Container> containerList = report.getContainers().getContainerList();
		Info info = report.getInfo();
		
		//查询条件：如果为1的话，你就先从request取 如果没有就从session去
		Dimsions dimsions = report.getDimsions();
		if(dimsions!=null&&dimsions.getDimsionList()!=null){
			List<Dimsion> dimsionList = dimsions.getDimsionList();
			for(Dimsion dim:dimsionList){
				String ispar = dim.getIsparame();
				String varname = dim.getVarname();
				if("1".equals(ispar)){
					for(Map.Entry<String, String> map : paramMap.entrySet()){
						if(varname.equals(map.getKey())){
							String sionKey = map.getKey();
							String sionVal = (String)request.getSession().getAttribute(sionKey.toUpperCase());
							paramMap.put(sionKey, sionVal);
						}
					}
				}else{
					downParamsStringBuilder.append(","+dim.getDesc()+"="+String.valueOf(paramMap.get(varname)).trim().toLowerCase());
				}
			}
		}
		
		
		
		DataCrossService cross = new DataCrossService(comp,reportId,type,paramMap,runner,report);
		
		Map<String,String> map = cross.generateCrossTableTag(comp);//pc.generateCrossTableTag(comp,sql,notNullParamMap,reportId);
		
		String title = (String)map.get("title");
		String jsonData = (String)map.get("jsonData");
		String rowsData = (String)map.get("rowsData");
		String rowType = (String)map.get("rowType");
		String style = (String)map.get("style");
		String script = (String)map.get("script");
		String height = (String)map.get("height");
		String tablepagi = comp.getTablepagi();
		String tableexport = comp.getTableexport();
		String pageSize = comp.getTablepaginum();
		String download="";
		//判断是否有导出
		if("1".equals(tableexport)){
			download="交叉表数据";
		}else{
			download="";
		}
		
		//判断是否有分页
		if("1".equals(tablepagi)){
			tablepagi="true";
		}else{
			tablepagi="false";
		}
		
		//计算当前容器高度
		for(Container c:containerList){
			if(containerId.equals(c.getId())){
				int a = Integer.valueOf(c.getHeight());
				a = a-50;
				String h = String.valueOf(a);
				style="width:auto;height:"+h+"px;";
			}
		}
		String pageListStr = "10,15,20,25,30,40,50";
		String[] pageNumArr= pageListStr.split(",");
		int i=0;
		for(;i<pageNumArr.length;i++){
			if(pageSize.equals(pageNumArr[i])){
				break;
			}
		}
		if(i==pageNumArr.length){
			pageListStr = pageSize+","+pageListStr;
		}
		
		request.setAttribute("downParams", downParamsStringBuilder.toString());
		request.setAttribute("style", style);
		request.setAttribute("rowsData", rowsData);
		request.setAttribute("script", script);
		request.setAttribute("tablepagi", tablepagi);
		request.setAttribute("download", download);
		request.setAttribute("tableid", componentId);
		request.setAttribute("pageSize", pageSize);
		request.setAttribute("pageList", pageListStr);
		if("temp".equals(type)){
			request.setAttribute("allowDown", "1");
		}else{
			request.setAttribute("allowDown", "0");
		}
		String url = "";
		//判断ltype还是手机 pc是1，手机是2
		//判断rowType非1树形
		String ltype = info.getLtype();
		if("1".equals(ltype)){
			request.setAttribute("title", title);
			if("1".equals(rowType)){
				request.setAttribute("jsonData", jsonData);
				url="pages/xbuilder/pagemanager/crossDataManager.jsp";
			}else{
				request.setAttribute("jsonData", jsonData);
				url="pages/xbuilder/pagemanager/crossTreeManager.jsp";
			}
		}else if("2".equals(ltype)){
			title = title.replaceAll("<th", "<td");
			title = title.replaceAll("th>", "td>");
			request.setAttribute("title", title);
			request.setAttribute("height", height);
			if("1".equals(rowType)){
				request.setAttribute("jsonData", jsonData);
				url="pages/xbuilder/pagemanager/crossMobileDataManager.jsp";
			}else{
				title = "<table>"+title+"</table>";
				String columns = TreeheadHelper.getTreeColumnJson(title);
				jsonData = jsonData.replaceAll("children", "data");
				request.setAttribute("jsonData", jsonData);
				request.setAttribute("columns", columns);
				url="pages/xbuilder/pagemanager/crossMobileTreeManager.jsp";
			}
		}
		return url;
		
	}
	
	@Action("getAllDataSourceJsonX")
	public void allDataSourceJson(HttpServletRequest request, HttpServletResponse response) {
		String reportId=request.getParameter("report_id");
		PrintWriter out = null;
		DataSetService dataSetService=null;
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			if(reportId==null||"".equals(reportId)){
				out.print("[]");
				return;
			}
			dataSetService=new DataSetService();
			String jsonStr=dataSetService.getTreeData(reportId);
			Map map = (Map)Functions.json2java(jsonStr);
			List dsList = (ArrayList)map.get("yes");
			jsonStr = Functions.java2json(dsList);
			out.print("".equals(jsonStr)?"[]":jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	@SuppressWarnings("unchecked")
	@Action("getOneDataSourceColumnsJsonX")
	public void oneDataSourceColumnsJson(HttpServletRequest request, HttpServletResponse response) {
		String reportId=request.getParameter("report_id");
		String reportSqlId=request.getParameter("report_sql_id");
		PrintWriter out = null;
		DataSetService dataSetService=null;
		String jsonStr="";
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			if(reportId==null||"".equals(reportId)){
				out.print("[]");
				return;
			}
			if(reportSqlId==null||"".equals(reportSqlId)){
				out.print("[]");
				return;
			}
			dataSetService=new DataSetService();
			@SuppressWarnings("unused")
			List<Map> modelList=dataSetService.getTreeDataObj(reportId);
			if(modelList==null){
				modelList=new ArrayList<Map>();
			}
			for(Map tempDataMap:modelList){
				if(reportSqlId.equals(tempDataMap.get("id"))){
					jsonStr=Functions.java2json(tempDataMap.get("children"));
				}
				
			}
			out.print(jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	@Action("getOneDataSourceExtColumnsJsonX")
	public void oneDataSourceExtColumnsJson(HttpServletRequest request, HttpServletResponse response) {
		String reportId=request.getParameter("report_id");
		String reportSqlId=request.getParameter("report_sql_id");
		PrintWriter out = null;
		String jsonStr="[]";
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			if(reportId==null||"".equals(reportId)){
				out.print("[]");
				return;
			}
			if(reportSqlId==null||"".equals(reportSqlId)){
				out.print("[]");
				return;
			}
			Report report=XContext.getEditView(reportId);
			List<Extcolumn> extColumnList=null;
			if(report.getExtcolumns()!=null&&report.getExtcolumns().getExtcolumnList()!=null){
				extColumnList = report.getExtcolumns().getExtcolumnList();
				List<Extcolumn> resultList = new ArrayList<Extcolumn>();
				for(Extcolumn extcol : extColumnList){
					if(reportSqlId.equals(extcol.getDatasourceid())){
						resultList.add(extcol);
					}
				}
				jsonStr = Functions.java2json(resultList);
			}
			out.print(jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Action("checkRepeatColumns")
	public void checkRepeatColumns(HttpServletRequest request, HttpServletResponse response) {
		String reportId=request.getParameter("report_id");
		String reportSqlId=request.getParameter("report_sql_id");
		String columnName = request.getParameter("columnName");
		PrintWriter out = null;
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			//比较原始列
			DataSetService dataSetService=new DataSetService();
			List<Map> modelList=dataSetService.getTreeDataObj(reportId);
			modelList = modelList==null ?  new ArrayList<Map>() : modelList;
			List<Map> columnList=null;
			for(Map tempDataMap:modelList){
				if(reportSqlId.equals(tempDataMap.get("id"))){
					columnList = (List<Map>)tempDataMap.get("children");
				}
			}
			//比较计算列
			Report report=XContext.getEditView(reportId);
			List<Extcolumn> extColumnList=null;
			if(report.getExtcolumns()!=null&&report.getExtcolumns().getExtcolumnList()!=null){
				extColumnList = report.getExtcolumns().getExtcolumnList();
			}
			
			if(columnList!=null){
				for(Map colMap : columnList){
					if(columnName.equals(colMap.get("text"))){
						out.print("0");
						return;
					}
				}
			}
			if(extColumnList!=null){
				for(Extcolumn extcol : extColumnList){
					if(reportSqlId.equals(extcol.getDatasourceid())&&columnName.equals(extcol.getName())){
						out.print("0");
						return;
					}
				}
			}
			out.print("1");
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	@Action("getDataSourceIdJsonX")
	public void getDataSourceIdJsonX(HttpServletRequest request, HttpServletResponse response) {
		String reportId=String.valueOf(request.getParameter("reportId"));
		String containerId=String.valueOf(request.getParameter("containerId"));
		String componentId=String.valueOf(request.getParameter("componentId"));
		PrintWriter out = null;
		String jsonStr="";
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			if(reportId==null||"".equals(reportId)){
				out.print("");
				return;
			}
			Report report=XContext.getEditView(reportId);
			if(report==null){
				out.print("");
				return;
			}
			Containers containers=report.getContainers();
			if(containers==null){
				out.print("");
				return;
			}
			List<Container> containerList=containers.getContainerList();
			if(containerList==null){
				out.print("");
				return;
			}
			for(Container tempContainer:containerList){
				if(containerId.equals(tempContainer.getId())){
					Components components=tempContainer.getComponents();
					if(components==null){
						out.print("");
						return;
					}
					List<Component> componentList=components.getComponentList();
					if(componentList==null){
						out.print("");
						return;
					}
					for(Component tempComponent:componentList){
						if(componentId.equals(tempComponent.getId())){
							jsonStr=tempComponent.getDatasourceid();
							break;
						}
						
					}
					break;
				}
			}
			
			out.print(jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	@Action("getOneKpiStoreColsJsonX")
	public void oneKpiStoreColsJson(HttpServletRequest request, HttpServletResponse response) {
		String reportId=request.getParameter("report_id");
		String reportSqlId=request.getParameter("report_sql_id");
		PrintWriter out = null;
		String jsonStr="";
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			if(reportId==null||"".equals(reportId)){
				out.print("[]");
				return;
			}
			if(reportSqlId==null||"".equals(reportSqlId)){
				out.print("[]");
				return;
			}
			Report report=XContext.getEditView(reportId);
			Datasources datasources=report.getDatasources();
			if( datasources==null){
				out.print("[]");
				return;
			}
			List<Datasource> datasourceList=datasources.getDatasourceList();
			if( datasourceList==null){
				out.print("[]");
				return;
			}
			String kpiStoreId=null;
			for(Datasource tempDatasource:datasourceList){
				if(reportSqlId.equals(tempDatasource.getId())){
					kpiStoreId=tempDatasource.getKpistoreId();
				}
			}
			if(kpiStoreId==null){
				out.print("[]");
				return;
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
			List<KpistoreCol> kpiStoreCoList=null;
			for(Kpistore tempKpistore:kpistoreList){
				if(kpiStoreId.equals(tempKpistore.getId())){
					kpiStoreCoList=tempKpistore.getKpistorecolList();
				}
				
			}
			if(kpiStoreCoList==null){
				kpiStoreCoList=new ArrayList<KpistoreCol>();
				
			}
			jsonStr=Functions.java2json(kpiStoreCoList);
			out.print(jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	@Action("getOneKpiStoreHasSetDimColsJsonX")
	public void oneKpiStoreHasSetDimColsJson(HttpServletRequest request, HttpServletResponse response) {
		String reportId=request.getParameter("report_id");
		String reportSqlId=request.getParameter("report_sql_id");
		String containerId=request.getParameter("containerId");
		String componentId=request.getParameter("componentId");
		String componentType = request.getParameter("componentType");
		PrintWriter out = null;
		String jsonStr="";
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			if(reportId==null||"".equals(reportId)){
				out.print("[]");
				return;
			}
			if(reportSqlId==null||"".equals(reportSqlId)){
				out.print("[]");
				return;
			}
			
			Report report=XContext.getEditView(reportId);
			if(report==null){
				out.print("[]");
				return;
			}
			Component component = getOrCreateComponet(report,containerId,componentId);
			if(component==null){
				out.print("[]");
				return;
			}
			Datastore datastore = component.getDatastore();
			if(datastore==null){
				datastore=new Datastore();
				component.setDatastore(datastore);
			}
			Crosscolstore crossColStore = component.getCrosscolstore();
			if(crossColStore==null){
				crossColStore=new Crosscolstore();
				component.setCrosscolstore(crossColStore);
			}
			List<Datacol> datacols = datastore.getDatacolList();
			if(datacols==null){
				datacols=new ArrayList<Datacol>();
				datastore.setDatacolList(datacols);
			}
			
			List<Crosscol> crosscolList = crossColStore.getCrosscolList();
			if(crosscolList==null){
				crosscolList=new ArrayList<Crosscol>();
				crossColStore.setCrosscolList(crosscolList);
			}
			
			Datasources datasources=report.getDatasources();
			if( datasources==null){
				out.print("[]");
				return;
			}
			List<Datasource> datasourceList=datasources.getDatasourceList();
			if( datasourceList==null){
				out.print("[]");
				return;
			}
			String kpiStoreId=null;
			for(Datasource tempDatasource:datasourceList){
				if(reportSqlId.equals(tempDatasource.getId())){
					kpiStoreId=tempDatasource.getKpistoreId();
				}
			}
			if(kpiStoreId==null){
				out.print("[]");
				return;
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
			List<KpistoreCol> kpiStoreColList=null;
			for(Kpistore tempKpistore:kpistoreList){
				if(kpiStoreId.equals(tempKpistore.getId())){
					kpiStoreColList=tempKpistore.getKpistorecolList();
				}
				
			}
			if(kpiStoreColList==null){
				kpiStoreColList=new ArrayList<KpistoreCol>();
			}
			List<KpistoreCol> kpiStoreHasSetDimColsList=new ArrayList<KpistoreCol>();
			if(componentType!=null&&"CROSSTABLE".equals(componentType)){
				for(Crosscol crossCol:crosscolList){
						for(KpistoreCol tempKpistoreCol:kpiStoreColList){
							if(crossCol.getDimid()!=null&&crossCol.getDimid().equals(tempKpistoreCol.getKpiid())){
								kpiStoreHasSetDimColsList.add(tempKpistoreCol);
								break;
							}
						}
				}
			}else{
				for(Datacol tempDatacol:datacols){
					if(tempDatacol.getDatacoltype()!=null&&tempDatacol.getDatacoltype().equals("dim")){
						for(KpistoreCol tempKpistoreCol:kpiStoreColList){
							if(tempDatacol.getDatacolid()!=null&&tempDatacol.getDatacolid().equals(tempKpistoreCol.getKpiid())){
								kpiStoreHasSetDimColsList.add(tempKpistoreCol);
								break;
							}
						}
					}
				}
			}
			jsonStr=Functions.java2json(kpiStoreHasSetDimColsList);
			out.print(jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	@Action("getAllSubdrillsJsonJsonX")
	public void allSubdrillsJson(HttpServletRequest request, HttpServletResponse response) {
		String reportId=request.getParameter("report_id");
		String containerId=request.getParameter("containerId");
		String componentId=request.getParameter("componentId");
		PrintWriter out = null;
		String jsonStr="";
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			if(reportId==null||"".equals(reportId)){
				out.print("[]");
				return;
			}
			
			Report report=XContext.getEditView(reportId);
			if(report==null){
				out.print("[]");
				return;
			}
			Component component = getOrCreateComponet(report,containerId,componentId);
			if(component==null){
				out.print("[]");
				return;
			}
			Subdrills subdrills = component.getSubdrills();
			if(subdrills==null){
				subdrills=new Subdrills();
				component.setSubdrills(subdrills);
			}
			List<Subdrill> subdrillList = subdrills.getSubdrillList();
			if(subdrillList==null){
				subdrillList=new ArrayList<Subdrill>();
				subdrills.setSubdrillList(subdrillList);
			}
			jsonStr=Functions.java2json(subdrillList);
			out.print(jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	@Action("getAllDimsionsJsonX")
	public void allDimsionsJson(HttpServletRequest request, HttpServletResponse response) {
		String reportId=request.getParameter("report_id");
		String isTempFile=request.getParameter("isTempFile");
		PrintWriter out = null;
		String jsonStr="";
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			if(reportId==null||"".equals(reportId)){
				out.print("[]");
				return;
			}
			XBaseService xBaseService=new XBaseService();
			Report report=null;
			if("1".equals(isTempFile)){
				report=xBaseService.readFromXmlByViewId(reportId, false);
			}else{
				report=xBaseService.readFromXmlByViewId(reportId, true);
			}
			
			Dimsions dimsions=report.getDimsions();
			if(dimsions==null){
				out.print("[]");
				return;
			}
			List<Dimsion> dimsionList=dimsions.getDimsionList();
			if(dimsionList==null){
				out.print("[]");
				return;
			}
			
			jsonStr=Functions.java2json(dimsionList);
			out.print(jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	@Action("getAllContainersJsonX")
	public void allContainersJson(HttpServletRequest request, HttpServletResponse response) {
		String reportId=request.getParameter("report_id");
		PrintWriter out = null;
		String jsonStr="";
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			if(reportId==null||"".equals(reportId)){
				out.print("[]");
				return;
			}
			Report report=XContext.getEditView(reportId);
			Containers containers=report.getContainers();
			if(containers==null){
				out.print("[]");
				return;
			}
			List<Container> containerList=containers.getContainerList();
			if(containerList==null){
				out.print("[]");
				return;
			}
			
			jsonStr=Functions.java2json(containerList);
			out.print(jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	@Action("getKpiExtColumnsJson")
	public void getKpiExtColumnsJson(HttpServletRequest request, HttpServletResponse response) {
		String reportId=request.getParameter("report_id");
		PrintWriter out = null;
		String jsonStr="[]";
		try {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			if(reportId==null||"".equals(reportId)){
				out.print("[]");
				return;
			}
			Report report=XContext.getEditView(reportId);
			List<Extcolumn> extColumnList=null;
			if(report.getExtcolumns()!=null&&report.getExtcolumns().getExtcolumnList()!=null){
				jsonStr = Functions.java2json(report.getExtcolumns().getExtcolumnList());
			}
			out.print(jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(out != null){
				out.close();
			}
		}
	}
}

