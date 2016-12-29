package cn.com.easy.xbuilder.service;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import cn.com.easy.annotation.Service;
import cn.com.easy.ebuilder.util.ListUtil;
import cn.com.easy.ebuilder.util.StringUtil;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.util.SqlUtils;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Datasources;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Dimsions;
import cn.com.easy.xbuilder.element.Link;
import cn.com.easy.xbuilder.element.Query;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Sql;
import cn.com.easy.xbuilder.element.TmpDatasource;
import cn.com.easy.xbuilder.element.TmpDatasources;
import cn.com.easy.xbuilder.parser.CommonTools;

@Service
public class DataSetService extends XBaseService {
	private String classPath = this.getClass().getClassLoader().getResource("/").getPath();
	private String FormalPagePath = "pages/xbuilder/usepage/formal/";
	
	//删除临时dataSource
	public String delTmpDataSource(String id,String reportId){
		String res="success";
		Report reportObj=XContext.getEditView(reportId);
		if(reportObj.getTmpdatasources()!=null && reportObj.getTmpdatasources().getTmpdatasourceList()!=null){
			List<TmpDatasource> tmpList = reportObj.getTmpdatasources().getTmpdatasourceList();
			if(tmpList.size()>0){
				Iterator<TmpDatasource> iterator = tmpList.iterator();
				while(iterator.hasNext()){
					TmpDatasource tmp = iterator.next();
					if(id.equals(tmp.getId())){
						iterator.remove();
					}else if(id.equals(tmp.getReference())){
						iterator.remove();
					}
				}
			}
		}
		saveToXmlByObj(reportObj);
		return res;
	}
	
	//添加临时数据集
	public String addTmpDataSource(String reportId,Map<String,String> dsMap){
		String res="";
		Report reportObj=XContext.getEditView(reportId);
		TmpDatasources Datasources = reportObj.getTmpdatasources();
		
		TmpDatasource datasource = new TmpDatasource();
		datasource.setId(dsMap.get("id"));
		datasource.setName(dsMap.get("name"));
		datasource.setExtds(dsMap.get("extds"));
		datasource.setCreatetime(dsMap.get("createtime"));
		datasource.setCreator(dsMap.get("creator"));
		datasource.setIndex(dsMap.get("index"));
		datasource.setReference(dsMap.get("reference"));
		datasource.setSql(dsMap.get("sql"));
		datasource.setDatatype(dsMap.get("datatype"));
		
		if(Datasources==null){
			TmpDatasources tds = new TmpDatasources();
			List<TmpDatasource> tdList = new ArrayList<TmpDatasource>();
			tdList.add(datasource);
			tds.setTmpdatasourceList(tdList);
			reportObj.setTmpdatasources(tds);
		}else{
			List<TmpDatasource> tdList = new ArrayList<TmpDatasource>();
			tdList.add(datasource);
			reportObj.getTmpdatasources().setTmpdatasourceList(tdList);
		}
		saveToXmlByObj(reportObj);
		return res;
	}
	
	
	// 添加数据集
	public Datasource addDataSource(String reportId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Datasources dsList = reportObj.getDatasources();
		if(dsList==null){
			Datasources ds=new Datasources();
			ds.setDatasourceList(new ArrayList<Datasource>());
			reportObj.setDatasources(ds);
		}else{
			if(dsList.getDatasourceList()==null){
				dsList.setDatasourceList(new ArrayList<Datasource>());
			}
		}
		Map element=(Map)Functions.json2java(jsonString);
		
		Boolean isAdd=true;
		Datasource datasource=null;
		for(Datasource ds : reportObj.getDatasources().getDatasourceList()){
			if(ds.getId().equals(element.get("id"))){
				isAdd=false;
				//getReference();
				datasource=ds;
				break;
			}
		}
		if(isAdd){
			datasource=new Datasource();
			datasource.setId(element.get("id")+"");
			//datasource.setId(cn.com.easy.xbuilder.utils.StringUtil.getDataSequence());
		}		    
		datasource.setName("" + element.get("name"));
		datasource.setExtds("" + element.get("extds"));
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		datasource.setCreatetime("" + sdf.format(new Date()));
		datasource.setCreator("" + element.get("creator"));
		datasource.setIndex("" + element.get("index"));
		String dataSql=element.get("data_sql")+"";
		try {
			dataSql = new String(org.apache.commons.codec.binary.Base64.decodeBase64(element.get("data_sql")+""), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		datasource.setSql("" + dataSql);
		datasource.setDatatype(element.get("datatype")+"");
		//datasource.setReference(""+element.get("reference"));
		if(isAdd)
			reportObj.getDatasources().getDatasourceList().add(datasource);
		saveToXmlByObj(reportObj);
		return datasource;
	}
	
	
	// 添加数据集
	public Datasource addDataSet(String reportId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Datasources dsList = reportObj.getDatasources();
		if(dsList==null){
			Datasources ds=new Datasources();
			ds.setDatasourceList(new ArrayList<Datasource>());
			reportObj.setDatasources(ds);
		}else{
			if(dsList.getDatasourceList()==null){
				dsList.setDatasourceList(new ArrayList<Datasource>());
			}
		}
		Map element=(Map)Functions.json2java(jsonString);
		
		Boolean isAdd=true;
		Datasource datasource=null;
		for(Datasource ds : reportObj.getDatasources().getDatasourceList()){
			if(ds.getId().equals(element.get("id"))){
				isAdd=false;
				datasource=ds;
				break;
			}
		}
		if(isAdd){
			datasource=new Datasource();
			//datasource.setId(element.get("id")+"");
			datasource.setId(cn.com.easy.xbuilder.utils.StringUtil.getDataSequence());
		}		    
		datasource.setName("" + element.get("name"));
		datasource.setExtds("" + element.get("extds"));
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		datasource.setCreatetime("" + sdf.format(new Date()));
		datasource.setCreator("" + element.get("creator"));
		datasource.setIndex("" + element.get("index"));
		String dataSql=element.get("data_sql")+"";
		try {
			dataSql = new String(org.apache.commons.codec.binary.Base64.decodeBase64(element.get("data_sql")+""), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		datasource.setSql("" + dataSql);
		datasource.setReference(""+element.get("reference"));
		if(isAdd)
			reportObj.getDatasources().getDatasourceList().add(datasource);
		saveToXmlByObj(reportObj);
		return datasource;
	}
	/**
	 * 修改数据集之前的操作，验证SQL中那些字段被使用了
	 * @param reportId
	 * @param datasetId
	 * @return
	 */
	public String beforeUptDataSet(String reportId, String datasetId) {
		Report reportObj=XContext.getEditView(reportId);
		if(reportObj.getDatasources()!=null&&reportObj.getDatasources().getDatasourceList()!=null){
			List<Container> containers = reportObj.getContainers().getContainerList();
			if(containers != null && containers.size()>0){
				for(int c=0;c<containers.size();c++){
					Container container = containers.get(c);
					List<Component> components = container.getComponents().getComponentList();
					if(components != null && components.size()>0){
						for(int p=0;p<components.size();p++){
							if(datasetId.equals(components.get(p).getDatasourceid())){
								return "数据集已经被组件使用，请先删除这些组件！";
							}
						}
					}
				}
			}
		}
		return "success";
	}
	
	//删除数据集
	public String removeDataSet(String reportId,String datasetId){
		Report reportObj=XContext.getEditView(reportId);
		StringBuffer message = new StringBuffer();
		if(reportObj.getDatasources()!=null&&reportObj.getDatasources().getDatasourceList()!=null){
			List<Container> containers = reportObj.getContainers().getContainerList();
			if(containers != null && containers.size()>0){
				for(int c=0;c<containers.size();c++){
					Container container = containers.get(c);
					List<Component> components = container.getComponents().getComponentList();
					if(components != null && components.size()>0){
						for(int p=0;p<components.size();p++){
							if(datasetId.equals(components.get(p).getDatasourceid())){
								return "数据集已经被组件使用，请先删除这些组件！";
							}
						}
					}
				}
			}

			List<Datasource> dsList =reportObj.getDatasources().getDatasourceList();
			for(Datasource ds : dsList){
				if(ds.getId().equals(datasetId)){
					dsList.remove(ds);
					break;
				}
			}
			Dimsions dimsions = new Dimsions();
			reportObj.setDimsions(dimsions);
		}
		saveToXmlByObj(reportObj);
		return "success";
	}
	//删除数据集
	public String removeTmpDataSet(String reportId,String datasetId){
		Report reportObj=XContext.getEditView(reportId);
		StringBuffer message = new StringBuffer();
		if(reportObj.getTmpdatasources()!=null&&reportObj.getTmpdatasources().getTmpdatasourceList()!=null){
//			List<Container> containers = reportObj.getContainers().getContainerList();
//			if(containers != null && containers.size()>0){
//				for(int c=0;c<containers.size();c++){
//					Container container = containers.get(c);
//					List<Component> components = container.getComponents().getComponentList();
//					if(components != null && components.size()>0){
//						for(int p=0;p<components.size();p++){
//							if(datasetId.equals(components.get(p).getDatasourceid())){
//								return "数据集已经被组件使用，请先删除这些组件！";
//							}
//						}
//					}
//				}
//			}
			List<TmpDatasource> dsList =reportObj.getTmpdatasources().getTmpdatasourceList();
			for(TmpDatasource ds : dsList){
				if(ds.getId().equals(datasetId)){
					dsList.remove(ds);
					break;
				}
			}
			TmpDatasources tmpdatasources = new TmpDatasources();
			tmpdatasources.setTmpdatasourceList(dsList);
			reportObj.setTmpdatasources(tmpdatasources);
//			Dimsions dimsions = new Dimsions();
//			reportObj.setDimsions(dimsions);
		}
		saveToXmlByObj(reportObj);
		return "success";
	}
    //获取数据集数据
	@SuppressWarnings("unchecked")
	public String getTreeData(String reportId){
		String json="";
		Report reportObj = XContext.getEditView(reportId);
		Map<String,Object> map = new HashMap<String,Object>();
		if(reportObj.getDatasources()!=null&&reportObj.getDatasources().getDatasourceList()!=null){
			List<Datasource> dsList=reportObj.getDatasources().getDatasourceList();
			List<Map> modelList=new ArrayList<Map>();
			for(Datasource ds:dsList){
				Map model=new HashMap();
				model.put("id","B"+ds.getId());
				model.put("text",ds.getName());
				model.put("iconCls","icon-dataset02");
				Map attrModel = new HashMap();
				attrModel.put("extds",ds.getExtds());
				attrModel.put("sql",ds.getSql());
				attrModel.put("reference",ds.getReference());
				attrModel.put("datatype", ds.getDatatype());
				model.put("attributes",attrModel);
				List<String> fields=getfield(ds.getSql(),ds.getExtds());
				List<Map> children=new ArrayList<Map>();
				for(int i=0;i<fields.size();i++){
					Map dsObj = new HashMap();
					dsObj.put("id","C"+fields.get(i));
					dsObj.put("text",fields.get(i));
					dsObj.put("iconCls","icon-dataset03");
					children.add(dsObj);
				}
				model.put("children",children);
				modelList.add(model);
			}
			map.put("yes", modelList);
		}
		if(reportObj.getTmpdatasources() != null && reportObj.getTmpdatasources().getTmpdatasourceList() != null && reportObj.getTmpdatasources().getTmpdatasourceList().size()>0) {
			List<TmpDatasource> tmpList= reportObj.getTmpdatasources().getTmpdatasourceList();
			List<Map> modelList=new ArrayList<Map>();
			for(TmpDatasource ds: tmpList) {
				Map model=new HashMap();
				model.put("id","B"+ds.getId());
				model.put("text",ds.getName());
				model.put("extds", ds.getExtds());
				model.put("referenceId", ds.getReference());
				model.put("sql", ds.getSql());
				model.put("iconCls","icon-dataset02");
				modelList.add(model);
			}
			map.put("no", modelList);
		}
		json=Functions.java2json(map);
		return json;
	}
	
	
	//获取数据集数据,组件设计时用到
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List<Map> getTreeDataObj(String reportId){
		Report reportObj=XContext.getEditView(reportId);
		List<Datasource> dsList=reportObj.getDatasources().getDatasourceList();
		List<Map> modelList=new ArrayList<Map>();
		for(Datasource ds:dsList){
			Map model=new HashMap();
			model.put("id","B"+ds.getId());
			model.put("text",ds.getName());
			model.put("iconCls","icon-dataset02");
			if(ds.getSql()!=null&&!"".equals(ds.getSql())){
				List<String> fields=getfield(ds.getSql(),ds.getExtds());
				List<Map> children=new ArrayList<Map>();
				for(int i=0;i<fields.size();i++){
					Map dsObj = new HashMap();
					dsObj.put("id","C"+fields.get(i));
					dsObj.put("text",fields.get(i));
					dsObj.put("iconCls","icon-dataset03");
					dsObj.put("isextcolumn", "false");
					children.add(dsObj);
				}
				model.put("children",children);
			}
			modelList.add(model);
		}
		return modelList;
	}
	//获取约束数据
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String getTreeRestrain(String reportId){
		String json="";
		try{
			Report reportObj=XContext.getEditView(reportId);
			List<Datasource> dsList=new ArrayList<Datasource>();
			if(reportObj.getDatasources()!=null)
				dsList=reportObj.getDatasources().getDatasourceList();
			List<Map> modelList=new ArrayList<Map>();
			Map<String,Datasource> restrainMap=new HashMap<String,Datasource>();
			if(dsList!=null){
				for(Datasource ds:dsList){
					List<String> restrainList=getRestrain(ds.getSql());
					for(int i=0;i<restrainList.size();i++){
						restrainMap.put(restrainList.get(i),ds);
					}
				}
			}
			Iterator iterator = restrainMap.keySet().iterator();
			int i=0;
			Datasource ds=null;
			while(iterator.hasNext()) {
				Map model=new HashMap();
			    String key=iterator.next().toString();
			    ds=(Datasource)restrainMap.get(key);
				model.put("id","S"+ds.getId()+(i++));
				model.put("text",key);
				model.put("iconCls","icon-constraint02");

				if(reportObj.getDimsions()!=null&&reportObj.getDimsions().getDimsionList()!=null){
					List<Dimsion> dimList=reportObj.getDimsions().getDimsionList();
					for(Dimsion dim : dimList){
						if(key.equals(dim.getVarname())){
							Map da=new HashMap();
							da.put("dim_col_code",dim.getCodecolumn() );
							da.put("dim_col_desc",dim.getDesccolumn());
							da.put("dim_col_ord",dim.getOrdercolumn());
							da.put("dim_create_type",dim.getCreatetype());
							da.put("dim_parent_col",dim.getParentcol());
							da.put("dim_sql",dim.getSql().getSql());
							da.put("dim_table",dim.getTable());
							da.put("parent_dim_name",dim.getParentcol());
							da.put("select_double",dim.getIsselectm());
							da.put("text",dim.getVarname());
							da.put("type",dim.getType());
							da.put("database_name",dim.getSql().getExtds());
							da.put("dim_var_desc",dim.getDesc());
							da.put("dim_lvl",dim.getLevel());
							da.put("dimId",dim.getId());
							model.put("text",key+"【"+getDimTypeName(dim.getType())+"】");
							model.put("attributes",da);
							break;
						}
					}
				}
				modelList.add(model);
			}
			
			json=Functions.java2json(modelList);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return json;
	}
	
	private String getDimTypeName(String type){
		String cnName="";
		if("INPUT".equals(type)){
			cnName="文本";
		}else if("DAY".equals(type)){
			cnName="日账期";
		}else if("MONTH".equals(type)){
			cnName="月账期";
		}else if("SELECT".equals(type)){
			cnName="下拉框";
		}else if("CASELECT".equals(type)){
			cnName="多级联动";
		}else if("HIDDEN".equals(type)){
            cnName="隐藏域";
        }else if("UPLOAD".equals(type)){
			cnName="上传";
		}
		return cnName;
	}
	 	
	//获取所有的查询字段
	public List<String> getfield(String dataSql,String databaseName) {
		List<String> fields=new ArrayList<String>();
		Connection con =  null;PreparedStatement ps = null;
		try {
			dataSql = StringUtil.formatSql(dataSql, "{", "}");
			List<String> parameterNames = new ArrayList<String>();
			String sql = SqlUtils.parseParameter(dataSql, parameterNames);
			dataSql = CommonTools.getSql(databaseName,sql);
			con =  CommonTools.getConnection(databaseName);//runner.getDataSource().getConnection();
			ps = con.prepareStatement(dataSql);
			String dataSourceType = CommonTools.getDataSource(databaseName).getDataSourceType();
			for (int i = 0; i < parameterNames.size(); i++) {
				ps.setString(i + 1, null);//支持td数据，td数据库不支持null和''。
			}
			ResultSet rs = ps.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			int cols = rsmd.getColumnCount();
			
			for (int i = 1; i <= cols; i++) {
				fields.add(rsmd.getColumnName(i));
			}
			
			rs.close();
		} catch (Exception e) { 
			e.printStackTrace();
		}finally{
			try{
				if(ps != null)
					ps.close();
				if(con != null)
					con.close();
			}catch(Exception e){
				e.printStackTrace();
				System.err.println("ReportSql.getfield方法释放连接时，出错:"+e.getMessage());
			}
		}
		return fields;
	}
	
	//获取约束列表
	public List<String> getRestrain(String dataSql) {
		
			dataSql = StringUtil.formatSql(dataSql, "{", "}");
			List<String> parameterNames = new ArrayList<String>();
			SqlUtils.parseParameter(dataSql, parameterNames);
			parameterNames = ListUtil.removeDuplicateWithOrder(parameterNames);
			return parameterNames;
	}
	
	   //添加(修改)维度
		public String addDimsion(String reportId,String jsonString) {
			Report reportObj=XContext.getEditView(reportId);
			
			Dimsions dimList = reportObj.getDimsions();
			Dimsion dimsion=null;
			Map element=(Map)Functions.json2java(jsonString);
			Boolean isAdd=true;
			if(dimList==null){
				Dimsions dimsions=new Dimsions();
				dimsions.setDimsionList(new ArrayList<Dimsion>());
				reportObj.setDimsions(dimsions);
			}else{
				List<Dimsion> dimsionList=reportObj.getDimsions().getDimsionList();
				if(dimsionList!=null){
					for(Dimsion dim : dimsionList){
						if(dim.getVarname().equals(element.get("var_name"))){
							dimsion=dim;
							isAdd=false;
							break;
						}
					}
				}else{
					reportObj.getDimsions().setDimsionList(new ArrayList<Dimsion>());
				}
			}
			
			if(dimsion==null){
				dimsion=new Dimsion();
			}
			if(isAdd)
				dimsion.setId("DIM_"+new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date()));
			dimsion.setCodecolumn(""+element.get("codecolumn"));
			dimsion.setDesc(""+element.get("desc"));
			dimsion.setDesccolumn(""+element.get("desccolumn"));
			dimsion.setField("");
			dimsion.setIndex("");
			dimsion.setIsselectm(""+element.get("isselectm"));
			dimsion.setLevel(""+element.get("level"));
			dimsion.setOrdercolumn(""+element.get("ordercolumn"));
			dimsion.setParentcol(""+element.get("parentcol"));
			dimsion.setTable(""+element.get("table"));
			dimsion.setType(""+element.get("type"));
			dimsion.setVarname(""+element.get("var_name"));
			dimsion.setCreatetype(""+element.get("createtype"));
			dimsion.setDefaultvalue(""+element.get("defaultvalue"));
			Sql sql=new Sql();
			sql.setExtds(""+element.get("extds"));
			sql.setSql(""+element.get("sql"));
			dimsion.setSql(sql);
			if(isAdd){
				reportObj.getDimsions().getDimsionList().add(dimsion);
			}
			saveToXmlByObj(reportObj);
			return dimsion.getId();
		}
		
		//获取编辑的维度(用于回显约束条件属性)
		public String getEditDimsion(String reportId,String dimVarName){
			String result="";
			Report reportObj=XContext.getEditView(reportId);
			if(reportObj.getDimsions()!=null&&reportObj.getDimsions().getDimsionList()!=null){
				for(Dimsion dim : reportObj.getDimsions().getDimsionList()){
					if(dim.getVarname().equals(dimVarName)){
						result=Functions.java2json(dim);
						break;
					}
				}
			}
			return result;
		}
		
		//获取上级维度(SELECT和CASELECT)
		@SuppressWarnings("unchecked")
		public String getParentDims(String reportId,String varName){
			List parentColList = new ArrayList<Map>();
			Report reportObj=XContext.getEditView(reportId);
			if(reportObj.getDimsions()!=null&&reportObj.getDimsions().getDimsionList()!=null){
				List<Dimsion> dimList=reportObj.getDimsions().getDimsionList();
				String type="";
				for(Dimsion dim : dimList){
					type=dim.getType();
					if((type.equals("SELECT")||type.equals("CASELECT"))&&!varName.equals(dim.getVarname())){
						//result+=dim.getVarname()+":"+type+",";
						Map parentColMap = new HashMap();
						parentColMap.put("varName", dim.getVarname());
						parentColMap.put("codeColumn", dim.getCodecolumn());
						parentColMap.put("type", type);
						parentColList.add(parentColMap);
					}
				}
			}
			return Functions.java2json(parentColList);
		}
		
		//添加查询条件
		public void addQueryLink(String reportId,String dimsionId){
			Report reportObj=XContext.getEditView(reportId);
			if(reportObj.getQuery()==null){
				Query queryObj=new Query();
				queryObj.setLinkList(new ArrayList<Link>());
				reportObj.setQuery(queryObj);
			}else{
				if(reportObj.getQuery().getLinkList()==null){
					reportObj.getQuery().setLinkList(new ArrayList<Link>());
				}
			}
			Link link=new Link();
			removeQueryLink(reportId,dimsionId);
			link.setDimsionid(dimsionId);
			reportObj.getQuery().getLinkList().add(link);
			saveToXmlByObj(reportObj);
		}
		
		//删除查询条件
		public void removeQueryLink(String reportId,String dimsionId){
			Report reportObj=XContext.getEditView(reportId);
			List<Link> linkList=reportObj.getQuery().getLinkList();
			if(linkList!=null&&linkList.size()>0){
				Link link=null;
				for(int i=0;i<linkList.size();i++){
					link=linkList.get(i);
					if(link.getDimsionid().equals(dimsionId)){
						linkList.remove(i);
						break;
					}
				}
			}
			saveToXmlByObj(reportObj);
		}
		
		//获取数据集引用
		public String getAllReports(String reportId,String reportName,String datasetName) {
			String json="";
			String path = classPath.replace("WEB-INF/classes/", "") + FormalPagePath;	
			File file = new File(path);
		    File[] fileList = file.listFiles();
		    
		    List<Map> mapList=new ArrayList<Map>();
		    Boolean isReference=false;
		    for(File f : fileList){
		    	if(f.isDirectory() && f.getName().startsWith("R")){
		    		//不引用本报表下的数据集
		    		if(f.getName().equals(reportId)){
		    			continue;
		    		}
		    		Report currReport = XContext.getEditView(reportId);
		    		Report report = readFromXmlByViewId(f.getName(), true);
		    		
		    		if(report.getDatasources()!=null&&report.getDatasources().getDatasourceList()!=null){
		    			for(Datasource ds : report.getDatasources().getDatasourceList()){
		    				isReference=false;
		    				//当前编辑的报表下的datasource的reference属性等于其他报表datasource的id的不能引用
		    				if(currReport.getDatasources()!=null&&currReport.getDatasources().getDatasourceList()!=null){
		    					for(Datasource currDs : currReport.getDatasources().getDatasourceList()){
			    					if(!"".equals(currDs.getReference())&&currDs.getReference().equals(ds.getId())){
			    						isReference=true;
			    						break;
			    					}
			    				}
			    				if(isReference){
			    					continue;
			    				}
		    				}
		    				
		    				 Map<String,String> dsMap = new HashMap<String,String>();
		    				 dsMap.put("REPORT_NAME", report.getInfo().getName());
		    				 dsMap.put("REPORT_SQL_ID", ds.getId());
		    				 dsMap.put("REPORT_SQL_NAME", ds.getName());
		    				 dsMap.put("REPORT_SQL", ds.getSql());
		    				 dsMap.put("EXTDS", ds.getExtds());
		    				 if(reportName.length()>0&&datasetName.length()==0&&report.getInfo().getName().indexOf(reportName)>-1){
		    					 mapList.add(dsMap);
		    				 }else if(reportName.length()==0&&datasetName.length()>0&&ds.getName().indexOf(datasetName)>-1){
		    					 mapList.add(dsMap);
		    				 }else if(reportName.length()>0&&datasetName.length()>0){
		    					 if(report.getInfo().getName().indexOf(reportName)>-1&&ds.getName().indexOf(datasetName)>-1){
		    						 mapList.add(dsMap);
		    					 }
		    				 }else if(reportName.length()==0&&datasetName.length()==0){
		    					 mapList.add(dsMap);
		    				 }
		    				 
		    			}
		    		}
		    	}
		    }// end for
		    json=Functions.java2json(mapList);
            return json;	    
		}
		
		//获取查询条件字符串
		public String getParamString(String reportId){
			Report report = XContext.getEditView(reportId);
			StringBuilder result=new StringBuilder("");
			StringBuilder paramstr=new StringBuilder("&");
			String[] varSuffixs = {""};
			if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null&&report.getDimsions().getDimsionList().size()>0){
				Pattern pattern = Pattern.compile("[\u4e00-\u9fa5]");
			   for(Dimsion dim : report.getDimsions().getDimsionList()){
				   String varnameTmp = dim.getVarname();
					if(null != dim.getConditiontype() && "1".equals(dim.getConditiontype()) && null != dim.getDatasourceid()){
					       Matcher matcher = pattern.matcher(dim.getVardesc()); 
					       if(!matcher.find()){
					    	   varnameTmp = dim.getVardesc();
					       }
					}
				   
				   
				   //if (dim.getIsparame().equals("0")) {
					   if("2".equals(report.getInfo().getType())) {//指标库模式 between and
							if("06".equals(dim.getFormula()) //>=...<=
									||"10".equals(dim.getFormula()) //>...<
									||"11".equals(dim.getFormula()) //>=...<
									||"12".equals(dim.getFormula())) {//>...<=
								varSuffixs = new String[2];
								varSuffixs[0] = "_1";
								varSuffixs[1] = "_2";
							} 
					   }
					   for(int i= 0; i < varSuffixs.length; i++) {
							String varName = varnameTmp + varSuffixs[i];
							if (dim.getType().equalsIgnoreCase("day")) {
								   result.append("<e:q4o var='defaultAcct_"+ varName +"'>select CONST_VALUE from sys_const_table t where t.const_name='calendar.curdate'</e:q4o>\n");
								   result.append("<e:set var='param_"+varName+"' value='${param."+varName +"}'/>\n");
								   result.append("<e:if condition=\"${param."+varName+"==null || param."+varName+" eq ''}\">\n");
								   result.append("<e:set var='param_"+varName +"' value='${defaultAcct_"+ varName +".CONST_VALUE}'/>\n");
								   result.append("</e:if>\n");
								   paramstr.append(varName+"=${param_"+varName+"}&");
							} else if (dim.getType().equalsIgnoreCase("month")) {
								   result.append("<e:q4o var='defaultAcct_"+ varName +"'>select CONST_VALUE from sys_const_table t where t.const_name='calendar.maxmonth'</e:q4o>\n");
								   result.append("<e:set var='param_"+varName+"' value='${param."+varName+"}'/>\n");
								   result.append("<e:if condition=\"${param."+varName+"==null || param."+varName+" eq ''}\">\n");
								   result.append("<e:set var='param_"+varName +"' value='${defaultAcct_"+ varName +".CONST_VALUE}'/>\n");
								   result.append("</e:if>\n");
								   paramstr.append(varName+"=${param_"+varName+"}&");
							}else{
								   paramstr.append(varName+"=${param."+varName+"}&");
							}
					   }
				   //}
			   }
			}
			paramstr.append("currentId=${param.currentId}&condtype=${param.condtype}");
			result.append("<e:set var='urlParam' value='"+paramstr.toString()+"' />");
			//System.out.println(result.toString());
			return result.toString();
		}
		public String getResDimsionString(String reportId){
			Report report = XContext.getEditView(reportId);
			StringBuilder paramstr=new StringBuilder();
			String[] varSuffixs = {""};
			if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null&&report.getDimsions().getDimsionList().size()>0){
				Pattern pattern = Pattern.compile("[\u4e00-\u9fa5]");
			   for(Dimsion dim : report.getDimsions().getDimsionList()){
				   String varnameTmp = dim.getVarname();
				   String descTmp= dim.getDesc();
					if(null != dim.getConditiontype() && "1".equals(dim.getConditiontype()) && null != dim.getDatasourceid()){
					       Matcher matcher = pattern.matcher(dim.getVardesc()); 
					       if(!matcher.find()){
					    	   varnameTmp = dim.getVardesc();
					       }
					}
				   if("2".equals(report.getInfo().getType())) {//指标库模式 between and
						if("06".equals(dim.getFormula()) //>=...<=
								||"10".equals(dim.getFormula()) //>...<
								||"11".equals(dim.getFormula()) //>=...<
								||"12".equals(dim.getFormula())) {//>...<= 
							varSuffixs = new String[2];
							varSuffixs[0] = "_1";
							varSuffixs[1] = "_2";
						} 
				   }
				   for(int i= 0; i < varSuffixs.length; i++) {
					   String varName = varnameTmp + varSuffixs[i];
					   String desc= descTmp+ varSuffixs[i];
					   if (dim.getIsparame().equals("1")) {
						   paramstr.append(desc+"=${(requestScope."+varName+"==null || param."+varName+" eq '')?sessionScope."+varName+":requestScope."+varName+"},");
					   }else{
						   paramstr.append(desc+"=${requestScope."+varName+"},");
					   }
				   }
				}
				paramstr.deleteCharAt(paramstr.length()-1);
			}
			return paramstr.toString();
		}
		//获取查询条件字符串
		public String getResString(String reportId){
			StringBuilder result=new StringBuilder();
			Report report = XContext.getEditView(reportId);
			StringBuilder paramstr=new StringBuilder("&");
			String[] varSuffixs = {""};
			if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null&&report.getDimsions().getDimsionList().size()>0){
				Pattern pattern = Pattern.compile("[\u4e00-\u9fa5]");
			   for(Dimsion dim : report.getDimsions().getDimsionList()){
				   String varnameTmp = dim.getVarname();
					if(null != dim.getConditiontype() && "1".equals(dim.getConditiontype()) && null != dim.getDatasourceid()){
					       Matcher matcher = pattern.matcher(dim.getVardesc()); 
					       if(!matcher.find()){
					    	   varnameTmp = dim.getVardesc();
					       }
					}
				   if("2".equals(report.getInfo().getType())) {//指标库模式 between and
						if("06".equals(dim.getFormula()) //>=...<=
								||"10".equals(dim.getFormula()) //>...<
								||"11".equals(dim.getFormula()) //>=...<
								||"12".equals(dim.getFormula())) {//>...<= 
							varSuffixs = new String[2];
							varSuffixs[0] = "_1";
							varSuffixs[1] = "_2";
						} 
				   }
				   for(int i= 0; i < varSuffixs.length; i++) {
					   String varName = varnameTmp + varSuffixs[i];
					   if (dim.getIsparame().equals("1")) {
						   paramstr.append(varName+"=${(requestScope."+varName+"==null || param."+varName+" eq '')?sessionScope."+varName+":requestScope."+varName+"}&");
					   }else{
						   paramstr.append(varName+"=${requestScope."+varName+"}&");
					   }
				   }
				}
				paramstr.deleteCharAt(paramstr.length()-1);
			}
			String urlParam = paramstr.toString()+"&condtype=${param.condtype}";
			result.append("<e:set var=\"urlParam\" value=\""+urlParam+"\"/>");
			return result.toString();
			
		}
		
		//获取查询条件为js对象
		public Map<String,String> getResObj(String reportId){
			Report report = XContext.getEditView(reportId);
			Map<String,String> parammap = new HashMap<String,String>();
			if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null&&report.getDimsions().getDimsionList().size()>0){
			   for(Dimsion dim : report.getDimsions().getDimsionList()){
				   if (dim.getIsparame().equals("0")) {
					   parammap.put(dim.getVarname(),"'${requestScope."+dim.getVarname()+"}'");
				   }
			   }
			}
			return parammap;
		}
		
		
		/**
		 * 验证数据集和维度
		 * @param reportId
		 * @return
		 */
		public String validate(Report report){
			StringBuffer info=new StringBuffer("");
			/*********************验证数据集******************/
			Datasources datasources=report.getDatasources();
			List<Datasource> dsList = null;
			if(datasources==null){
				info.append("没有配置数据集<br/>\n");
			}else{
				dsList=datasources.getDatasourceList();
				if(dsList==null||dsList.size()==0){
					info.append("没有配置数据集<br/>\n");
				}else{
					for(Datasource ds : dsList){
						if(report.getContainers()!=null&&report.getContainers().getContainerList()!=null){
							List<Container> containerList = report.getContainers().getContainerList();
							for(Container container : containerList){
								if(container.getComponents()!=null&&container.getComponents().getComponentList()!=null){
									List<Component> compList = container.getComponents().getComponentList();
									for(Component comp : compList){
										if(ds.getId().equals(comp.getDatasourceid())){
											info.append(validateSql(ds.getName(), ds.getSql(), ds.getExtds()));
											break;
										}
									}
								}
							}
						}
						
					}
				}
			}
			/*********************验证维度******************/
			Query query=report.getQuery();
			Dimsion dim = null;
			if(query!=null){
				List<Link> linkList = query.getLinkList();
				if(linkList!=null){
					for(Link link : linkList){
					    dim=getDimsion(report, link.getDimsionid());
					    if(dim==null){
					    	info.append("编号为"+link.getDimsionid()+"的维度不存在<br/>\n");
					    }else{
					    	if(dim.getType().equals("SELECT")||dim.getType().equals("CASELECT")){
					    		info.append(validateDimSql(dim));
					    		if(dim.getType().equals("CASELECT")){
					    			if("0".equals(dim.getLevel())){
					    				Dimsion childDim = getChildDimsion(report, dim.getVarname());
					    				if(childDim==null){
					    					info.append("查询条件：多级联动“"+dim.getDesc()+"”没有配置子级<br/>\n");
					    				}else{
					    					int i=0;
					    					for(Link lk : linkList){
					    						if(lk.getDimsionid().equals(childDim.getId())){
					    							break;
					    						}else{
					    							i++;
					    						}
					    					}
					    					if(i==linkList.size()){
					    						info.append("查询条件：多级联动“"+dim.getDesc()+"”没有配置子级<br/>\n");
					    					}
					    				}
					    			}else{
					    				Dimsion parentDim = getParentDimsion(report, dim.getParentcol());
					    				if(parentDim==null){
					    					info.append("查询条件：多级联动“"+dim.getDesc()+"”没有配置父级<br/>\n");
					    				}else{
					    					int i=0;
					    					for(Link lk : linkList){
					    						if(lk.getDimsionid().equals(parentDim.getId())){
					    							break;
					    						}else{
					    							i++;
					    						}
					    					}
					    					if(i==linkList.size()){
					    						info.append("查询条件：多级联动“"+dim.getDesc()+"”没有配置父级<br/>\n");
					    					}
					    				}
					    			}
					    		}
					    	}else{
					    		if("".equals(dim.getDesc())||"null".equals(dim.getDesc())){
					    			info.append("维度"+dim.getId()+"显示名称不能为空<br/>\n");
					    		}
					    		if(dim.getVarname().equals("")||dim.getVarname().equals("null")){
					    			info.append("维度"+dim.getDesc()+"变量编码varname不能为空<br/>\n");
					    		}
					    	}
					    	   
					    }
					}
				}
			}

			return info.toString();
		}
		
	
		
		/**
		 * 根据维度编号获取维度
		 * @param reportId
		 * @param dimsionId
		 * @return
		 */
		public Dimsion getDimsion(Report report,String dimsionId){
			Dimsion dm = null;
			if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null){
				for(Dimsion dim : report.getDimsions().getDimsionList()){
					if(dim.getId().equals(dimsionId)){
						dm = dim;
						break;
					}
				}
			}
			return dm;
		}
		
		/**
		 * 根据维度变量名获取下级维度
		 * @param report
		 * @param dimVarname
		 * @return
		 * 1204修改 董一伯 添加 .toLowerCase()，仅修改此处
		 */
		public Dimsion getChildDimsion(Report report,String dimVarname){
			Dimsion dm = null;
			if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null){
				for(Dimsion dim : report.getDimsions().getDimsionList()){
					if(dim.getType().equals("CASELECT")&&dim.getParentdimname().toLowerCase().equals(dimVarname.toLowerCase())
							&&"1".equals(dim.getLevel())){
						dm = dim;
						break;
					}
				}
			}
			return dm;
		}
		
		public Dimsion getParentDimsion(Report report,String dimVarname){
			Dimsion dm = null;
			if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null){
				for(Dimsion dim : report.getDimsions().getDimsionList()){
					if(dim.getType().equals("CASELECT")&&dim.getVarname().equals(dimVarname)
							&&"0".equals(dim.getLevel())){
						dm = dim;
						break;
					}
				}
			}
			return dm;
		}
		
		/**
		 * 根据维度变量名获取下级维度
		 * @param report
		 * @param dimVarname
		 * @return
		 * 1204修改 董一伯 添加 .toLowerCase()，仅修改此处
		 */
		public Dimsion getChildDimsion(Report report,Dimsion dim){
			Dimsion dm = null;
			if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null){
				for(Dimsion tempDim : report.getDimsions().getDimsionList()){
					if(tempDim.getType().equals("CASELECT")&&tempDim.getParentdimname().toLowerCase().equals(dim.getVarname().toLowerCase())){
						dm = tempDim;
						break;
					}
				}
			}
			return dm;
		}
		
		public Dimsion getParentDimsion(Report report,Dimsion dim){
			Dimsion dm = null;
			if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null){
				for(Dimsion tempDim : report.getDimsions().getDimsionList()){
					if(tempDim.getType().equals("CASELECT")&&tempDim.getVarname().equals(dim.getParentdimname())){
						dm = tempDim;
						break;
					}
				}
			}
			return dm;
		}
		
		
		/**
		 * 验证数据集SQL方法
		 * @param datasetName
		 * @param dataSql
		 * @param databaseName
		 * @return
		 */
		public String validateSql(String datasetName,String dataSql,String databaseName){
			StringBuffer info = new StringBuffer("");
			Connection con =  null;
			PreparedStatement ps = null;
			try {
				dataSql = StringUtil.formatSql(dataSql, "{", "}");
				if (dataSql == null) {
					info.append("数据集【"+datasetName+"】:SQL格式拼写错误:｛｝没有成对出现或不正确的对！<br/>\n");
				}else if (dataSql.indexOf("AND") == 0) {
					info.append("数据集【"+datasetName+"】:第" + dataSql.substring(3)+ "个{}对内的应该存在AND|OR，请检查SQL拼写！<br/>\n");
				} else if ("COUNT".equals(dataSql)) {
					info.append("数据集【"+datasetName+"】:有部分##对没有被｛｝格式或者｛｝格式内不存在##对！<br/>\n");
				} 
				// 获得##对的变量名称集合
				List<String> parameterNames = new ArrayList<String>();
				String sql=SqlUtils.parseParameter(dataSql, parameterNames);
				try{
					dataSql = CommonTools.getSql(databaseName,sql);
				}catch(Exception e){
					info.append("数据集【"+datasetName+"】:获取数据源错误,请检查扩展数据源<br/>\n");
					e.printStackTrace();
				}
				
				int reg = StringUtil.getCounts(dataSql, "#");
				Map reqMap = new HashMap();
				// 判断#的数量。是否成对出现
				if (reg % 2 != 0) {
					info.append("数据集【"+datasetName+"】:请检查#是否成对出现！<br/>\n");
				}
				for (String s : parameterNames) {
					//System.out.println(s);
					reqMap.put(s, null);
				}
				con =  CommonTools.getConnection(databaseName);
				ps = con.prepareStatement(dataSql);
				for (int i = 0; i < parameterNames.size(); i++) {
					ps.setString(i + 1, null);//支持td数据，td数据库不支持null和''
				}
				ps.executeQuery();
			} catch (Exception e) {
				if(e.getMessage().indexOf("\n") == -1)
					info.append("数据集【"+datasetName+"】:"+e.getMessage()+"<br/>\n");
				else
					info.append("数据集【"+datasetName+"】:"+e.getMessage().substring(e.getMessage().indexOf(":") + 1, e.getMessage().indexOf("\n"))+"<br/>\n");
				e.printStackTrace();
			}finally{
				try {
					if(ps != null)
						ps.close();
					if(con != null)
						con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			return info.toString();
		}
		
		/**
		 * 验证维度SQL方法
		 * @param dim
		 * @return
		 */
		public String validateDimSql(Dimsion dim) {
			StringBuffer info = new StringBuffer("");
			String dim_col_code = dim.getCodecolumn();
			String dim_col_desc = dim.getDesccolumn();
			String dim_table = dim.getTable();
			String dim_col_ord = dim.getOrdercolumn();
			String createType = dim.getCreatetype();
			String dimsql = dim.getSql().getSql();
			String databaseName = dim.getSql().getExtds();
			String caslvl = dim.getLevel();
			String desc = "维度【"+dim.getDesc()+"】:";
			String dataSql = "select " + dim_col_code + " CODE,"+dim_col_desc + "  CODEDESC from " + dim_table+	" order by "+ dim_col_ord ;//where rownum=1
			StringBuffer sql = new StringBuffer("");
			try{
				sql = new StringBuffer(CommonTools.getSql(databaseName, dataSql));
			}catch(Exception e){
				info.append(desc+"获取数据源错误,请检查数据源<br/>\n");
				e.printStackTrace();
			}
			
			Connection con = null;PreparedStatement ps = null;
			try {
				if("1".equals(dim.getLevel())&&dim.getParentcol().equals("")){
					info.append(desc+"上级编码不能为空<br/>\n");
				}
				if(createType != null && createType.equals("2")){
					String sqltmp = StringUtil.formatSql(dimsql.toString(), "{", "}");
					if("".equals(dimsql)){
						info.append(desc+"维度SQL不能为空<br/>\n");
					}else if (sqltmp == null) {
						info.append(desc+"SQL格式拼写错误:｛｝没有成对出现或不正确的对！<br/>\n");
					}else if (sqltmp.indexOf("AND") == 0) {
						info.append(desc+"请检查##号是否成对出现，或者{}对内的应该存在AND|OR，请检查SQL拼写！<br/>\n");//+ dimsql.substring(3)
					} else if ("COUNT".equals(sqltmp)) {
						info.append(desc+"有部分##对没有被｛｝格式或者｛｝格式内不存在##对！<br/>\n");
					} 
					sql = new StringBuffer("");
					if(dimsql!=null && dimsql.indexOf("#")!= -1){
						dimsql=dimsql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\\{", "").replaceAll("\\}", "");
						String sqlStrs[] = dimsql.split("#");
						for(int i = 0; i < sqlStrs.length;i++){
							if (i % 2 != 1) {
								sql.append(sqlStrs[i]);
							}else{
								sql.append("''");
							}
						}
					}else{
						sql = new StringBuffer(dimsql);
					}
				}
				int reg = StringUtil.getCounts(dimsql, "#");
				// 判断#的数量。是否成对出现
				if (reg % 2 != 0) {
					info.append(desc+"#号请成对出现！<br/>\n");
				}
				// 判断该码表是否存在
				int tmp = 0;String str = "";

				con =  CommonTools.getConnection(databaseName);
				ps = con.prepareStatement(sql.toString());
				ResultSet rs1 = ps.executeQuery();
				ResultSetMetaData rsmd = rs1.getMetaData();
				int cols = rsmd.getColumnCount();
				for (int i = 1; i <= cols; i++) {
					String o = rsmd.getColumnName(i);
					if(o!=null && "CODE".equals(((String) o).toUpperCase())){
						tmp ++;
					}
					if(o!=null && "CODEDESC".equals(((String) o).toUpperCase())){
						tmp ++;
					}
					if(caslvl!=null && !caslvl.equals("0")){
						if(o!=null && "PARENT_COL".equals(((String) o).toUpperCase())){
							tmp ++;
						}
					}
					str += o;
				}

				if(caslvl!=null && !caslvl.equals("") && !caslvl.equals("0") && createType != null && createType.equals("2")){
					if(tmp>=3){
					}else{
						info.append(desc+"SQL字段别名一定为: 编码列：code | 描述列：codedesc  |  上级字段：parent_col<br/>\n");
					}
				}else if((caslvl==null || caslvl.equals("0") || caslvl.equals("")) && createType != null && createType.equals("2")){
					if(tmp>=2){
					}else{
						info.append(desc+"SQL字段别名一定为:code 和 codedesc<br/>\n");
					}
				}
				rs1.close();
			} catch (Exception e) {
				if(e.getMessage()!=null)
					info.append(desc+e.getMessage().substring(e.getMessage().indexOf(":") + 1,e.getMessage().indexOf("\n"))+"<br/>\n");
				e.printStackTrace();
			}finally{
				try{
					con.close();
					ps.close();
				}catch(Exception e){
					e.printStackTrace();
					System.err.println("ReportSql.otherVarJudge方法释放连接时，出错:"+e.getMessage());
				}
			}
			return info.toString();
		}
}