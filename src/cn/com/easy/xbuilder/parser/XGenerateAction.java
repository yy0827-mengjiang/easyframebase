package cn.com.easy.xbuilder.parser;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.ArrayUtils;

import cn.com.easy.core.EasyContext;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.util.StringUtils;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Components;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Datasources;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Dimsions;
import cn.com.easy.xbuilder.element.Event;
import cn.com.easy.xbuilder.element.Eventstore;
import cn.com.easy.xbuilder.element.Extcolumn;
import cn.com.easy.xbuilder.element.Extcolumns;
import cn.com.easy.xbuilder.element.Kpi;
import cn.com.easy.xbuilder.element.Param;
import cn.com.easy.xbuilder.element.Parameter;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Sortcol;
import cn.com.easy.xbuilder.element.SortcolStore;
import cn.com.easy.xbuilder.element.Subdirllsortcol;
import cn.com.easy.xbuilder.element.Subdrill;
import cn.com.easy.xbuilder.element.Subdrills;

public class XGenerateAction {
	private final Report report;
	private final String type;
	private final boolean isaction;
	private final String remoteSort,remoteOrder,compid;
	String actionPage;
	public XGenerateAction(Report report,String type,boolean isaction) {
		this.report = report;
		this.type = type;
		this.isaction = isaction;
		this.remoteSort="";
		this.remoteOrder="";
		this.compid="";
	}
	public XGenerateAction(Report report,String type,boolean isaction,String sort,String order,String compid) {
		this.report = report;
		this.type = type;
		this.isaction = isaction;
		this.remoteSort=sort;
		this.remoteOrder=order;
		this.compid=compid;
	}
	public String action(){
		try{
			String code = this.newFile(this.build());
			if(!code.equals("success")){
				return code;
			}
		}catch(Exception e){
			e.printStackTrace();
			return e.getMessage();
		}
		return "success";
	}
	
	private String newFile(String content) {
		String path = this.getClass().getClassLoader().getResource("/").getPath().replace("WEB-INF/classes/", "/")+"pages/xbuilder/usepage/" + this.type + "/" + this.report.getId() + "/" + this.type + "_" + this.report.getId() + "Action.jsp";
		FileOutputStream fos = null;
		try {
			File file = new File(path);
			if (file.exists()) {
				file.delete();
			} else {
				if (!file.getParentFile().exists()) {
					file.getParentFile().mkdirs();
				}
			}

			fos = new FileOutputStream(path);
			OutputStreamWriter osw = new OutputStreamWriter(fos, "UTF-8");
			osw.write(content);
			osw.flush();
			this.actionPage = content;
			return "success";
		} catch (Exception e) {
			e.printStackTrace();
			return e.getMessage();
		} finally {
			if (fos != null) {
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	public Map<String, Map<String,?>> getDataSetSqlByCompid(String compid){
		String reportid = this.report.getId();
		String type = this.report.getInfo().getType();
		String reportId = this.getStringValue(reportid);
		Map<String, Map<String,?>> infoMap = new HashMap<String, Map<String,?>>();
		Map<String, String> DataSetSqlMap = new HashMap<String, String>();
		Map<String, Map<String,String>> ExtColMap = new HashMap<String, Map<String,String>>();
		
		List<Container> containers = this.report.getContainers().getContainerList();
		Extcolumns extcolumns = this.report.getExtcolumns();
		List<Extcolumn> extcolumnlst = null != extcolumns?extcolumns.getExtcolumnList():null;
		XExtColumn xec = new XExtColumn(this.report);
		for(int c=0;c<containers.size();c++){
			Container container = containers.get(c);
			Components components = container.getComponents();
			if(components != null){
				List<Component> componentList = container.getComponents().getComponentList();
				if(componentList != null && componentList.size()>0)
					for(Component component:componentList){
						if(!component.getId().equals(compid)){
							continue;
						}
						
						final String pos = component.getTableshowtotalposition();
						final String isTotal0 = component.getTableshowtotal();
						infoMap.put("IsTotal",new HashMap<String, String>(){{put("Total",isTotal0.toString());put("Pos",pos);}});
						
						String cmcpType = this.getCompKind(component.getType().toLowerCase());
						if (cmcpType != null && cmcpType.equals("datagrid")) {
							 Datasource datasource = getDatasource(reportId,component.getDatasourceid());
							 StringBuffer sqlString = new StringBuffer(datasource.getSql());
							//初合化MAP对象
							 DataSetSqlMap.put("id", component.getId().trim());
							 if(type.equals("2")){
								 DataSetSqlMap.put("type","datagrid");
								 DataSetSqlMap.put("desc", datasource.getName()+"数据集");
								 DataSetSqlMap.put("sql", sqlString.toString());
								 DataSetSqlMap.put("dataSourceName", datasource.getExtds());
								 infoMap.put("DataSetSqlMap", DataSetSqlMap);
								 return infoMap;
							 }
							
							 Map<String,String> extcoldimmap = new HashMap<String,String>();//计算列
							 Map<String,String> extcolkpimap = new HashMap<String,String>();//计算列中，使用的指标
							 Map<String,String> usecolkpimap = new HashMap<String,String>();//用户选择的指标(指标和排序指标)
/*							 StringBuffer extsortBuf = new StringBuffer();//计算列,非汇聚表格时使用
							 Map<String,String> extcolmap = new HashMap<String,String>();//计算列,非汇聚表格时使用
*/							
							 Map<String,String> selcolkpimap = new HashMap<String,String>();
							 //1、得到排序字段
							StringBuffer sortBuf = new StringBuffer();
							List<String> sortAllList = new ArrayList<String>();
							Map<String,String> sortcoldimmap = new HashMap<String,String>();
							Map<String,String> sortcolkpimap = new HashMap<String,String>();
							SortcolStore sortcolstore = component.getSortcolStore();
							if(sortcolstore != null && sortcolstore.getSortcolList() != null){
								List<Sortcol> sortcols = sortcolstore.getSortcolList();
								for(int s=0;s<sortcols.size();s++){
									Sortcol sortcol = sortcols.get(s);
									if(sortcol.getKpitype() == null || sortcol.getKpitype().equals("") || sortcol.getKpitype().equals("dim")){
										sortBuf.append("\""+sortcol.getCol()+"\" "+sortcol.getType()+",");
										sortcoldimmap.put(sortcol.getCol(), sortcol.getCol());
										sortAllList.add(sortcol.getCol()+","+sortcol.getType());
									}else{
										//sortBuf.append("SUM("+sortcol.getCol()+") "+sortcol.getType()+",");
										String extcool = sortcol.getExtcolumnid();
										if(null != extcool && extcool.length()>0 && extcolumnlst != null){
											for(Extcolumn extcolumn:extcolumnlst){
												if(extcolumn.getId().equals(extcool)){
													//String name = extcolumn.getName().toUpperCase();
													String name = extcolumn.getName();
													String formula = extcolumn.getFormula();
													
													Map<String,String> ParamMap = new HashMap<String,String>();
													List<?> params = extcolumn.getParamList();
													for(int p=0;p<params.size();p++){
														Object param = params.get(p);
														if(param instanceof Param){
															ParamMap.put(((Param)param).getName(),((Param)param).getValue());
															extcolkpimap.put(((Param)param).getValue(), ((Param)param).getValue());
															selcolkpimap.put(((Param)param).getValue(),((Param)param).getValue());
														}else{
															ParamMap.put(((Map<String,String>)param).get("name"),((Map<String,String>)param).get("value"));
															extcolkpimap.put(((Map<String,String>)param).get("value"),((Map<String,String>)param).get("value"));
															selcolkpimap.put(((Map<String,String>)param).get("value"),((Map<String,String>)param).get("value"));
														}
													}
													
													StringBuffer formulaKpi = xec.divisor2decode(formula, ParamMap,true,name);
													sortBuf.append("\""+name+"\" "+sortcol.getType()+",");
													extcoldimmap.put(name,formulaKpi.toString());
													sortAllList.add(name+","+sortcol.getType());
												}
											}
										}else{
											if("kpi".equals(sortcol.getKpitype())){
												sortBuf.append("\""+sortcol.getCol()+"\" "+sortcol.getType()+",");
												sortAllList.add(sortcol.getCol()+","+sortcol.getType()+",kpi");
												usecolkpimap.put(sortcol.getCol(), sortcol.getCol());
											}else{
												sortBuf.append("\""+sortcol.getCol()+"\" "+sortcol.getType()+",");
												sortAllList.add(sortcol.getCol()+","+sortcol.getType());
											}
											
											sortcolkpimap.put(sortcol.getCol(), sortcol.getCol());
										}
									}
								}
							}
							
							if(this.remoteOrder != "" && this.remoteSort != "" && this.compid != ""){
								for(int sal=0;sal<sortAllList.size();sal++){
									String sortStr = sortAllList.get(sal);
									if(sortStr.startsWith(this.remoteSort+",")){
										sortAllList.remove(sortStr);
									}
								}
							}
							
							
							
							//2、得到所有指标列表包括维度 拼串
							String colString = "";
							String groupString = ""; 
							List<Datacol> datacolList = component.getDatastore().getDatacolList();//找到所有的的eventstore
							
							Map<String,String> paramcolmap = new HashMap<String,String>();
							Map<String,String> selcolmap = new HashMap<String,String>();
							
							/*Map<String,String> extselcolkpimap = new HashMap<String,String>();//计算列，非聚合表格
*/							for(Datacol datacol:datacolList){
								if(!this.getStringValue(datacol.getDatacolcode()).equals("")){
									String strtype = datacol.getDatacoltype();
									if("kpi".equals(strtype)){
										String extcool = datacol.getExtcolumnid();
										if(null != extcool && extcool.length()>0 && extcolumnlst != null){
											for(Extcolumn extcolumn:extcolumnlst){
												if(extcolumn.getId().equals(extcool)){
													//String name = extcolumn.getName().toUpperCase();
													String name = extcolumn.getName();
													String formula = extcolumn.getFormula();
													
													if(this.remoteOrder != "" && this.remoteSort != "" && this.compid != "" && this.remoteSort.equals(name)){
														sortAllList.add(this.remoteSort+","+this.remoteOrder+",kpi");
													}
													
													StringBuffer extcolbuff = new StringBuffer();
													Map<String,String> ParamMap = new HashMap<String,String>();
													List<?> params = extcolumn.getParamList();
													for(int p=0;p<params.size();p++){
														Object param = params.get(p);
														if(param instanceof Param){
															ParamMap.put(((Param)param).getName(),((Param)param).getValue());
															extcolbuff.append(((Param)param).getValue()).append(",");
															extcoldimmap.put(((Param)param).getValue(),"SUM("+((Param)param).getValue()+")");
															//extcolkpimap.put(((Param)param).getValue(),"SUM("+((Param)param).getValue()+")");
															extcolkpimap.put(((Param)param).getValue(),((Param)param).getValue());
															selcolkpimap.put(((Param)param).getValue(),((Param)param).getValue());
														}else{
															ParamMap.put(((Map<String,String>)param).get("name"),((Map<String,String>)param).get("value"));
															extcolbuff.append(((Map<String,String>)param).get("value")).append(",");
															extcoldimmap.put(((Map<String,String>)param).get("value"),"SUM("+((Map<String,String>)param).get("value")+")");
															extcolkpimap.put(((Map<String,String>)param).get("value"),((Map<String,String>)param).get("value"));
															selcolkpimap.put(((Map<String,String>)param).get("value"),((Map<String,String>)param).get("value"));
														}
													}
													
											        StringBuffer formulaKpi = xec.divisor2decode(formula, ParamMap,true,name);
											        StringBuffer formulaKpi2 = xec.formulaNoSumNoDecode(formula, ParamMap);
											        extcolbuff.deleteCharAt(extcolbuff.length()-1);
													
											        colString += formulaKpi.toString()+",";
											        selcolkpimap.put(name,formulaKpi.toString());
													
/*											        StringBuffer formulaKpi3 = this.divisor2decode(formula, ParamMap,false);
													extselcolkpimap.put(name,formulaKpi3.toString());*/
											        
													Map<String,String> extinfo = new HashMap<String,String>();
													extinfo.put("formula", formulaKpi2.toString());
													extinfo.put("kpi", extcolbuff.toString());
													ExtColMap.put(name, extinfo);
													infoMap.put("ExtColMap", ExtColMap);

												}
											}
										}else{
											colString += "SUM("+datacol.getDatacolcode() + ") as \""+datacol.getDatacolcode()+"\",";
											selcolkpimap.put(datacol.getDatacolcode(),datacol.getDatacolcode());
											usecolkpimap.put(datacol.getDatacolcode(),datacol.getDatacolcode());
											if(this.remoteOrder != "" && this.remoteSort != "" && this.compid != "" && this.remoteSort.equals(datacol.getDatacolcode())){
												sortAllList.add(this.remoteSort+","+this.remoteOrder+",kpi");
											}
										}
										
										Eventstore eventstore = datacol.getEventstore();
										if(eventstore != null && eventstore.getEventList() != null){
											List<Event> events = eventstore.getEventList();
											for(int e=0;e<events.size();e++){
												Event event = events.get(e);
												if(event != null && event.getParameterList() != null){
													List<Parameter> parameters= event.getParameterList();
													for(int p=0;p<parameters.size();p++){
														Parameter parameter = parameters.get(p);
														paramcolmap.put(parameter.getValue(), parameter.getValue());
													}
												}
											}
										}
									}else{
										if(this.remoteOrder != "" && this.remoteSort != "" && this.compid != "" && this.remoteSort.equals(datacol.getDatacolcode())){
											sortAllList.add(this.remoteSort+","+this.remoteOrder);
										}
										colString += "\""+datacol.getDatacolcode()+"\",";
										groupString+="\""+datacol.getDatacolcode()+"\",";
										selcolmap.put(datacol.getDatacolcode(), datacol.getDatacolcode());
										
										Eventstore eventstore = datacol.getEventstore();
										if(eventstore != null && eventstore.getEventList() != null){
											List<Event> events = eventstore.getEventList();
											for(int e=0;e<events.size();e++){
												Event event = events.get(e);
												if(event != null && event.getParameterList() != null){
													List<Parameter> parameters= event.getParameterList();
													for(int p=0;p<parameters.size();p++){
														Parameter parameter = parameters.get(p);
														paramcolmap.put(parameter.getValue(), parameter.getValue());
													}
												}
											}
										}
									}
								}
							}

							String orderString = "";
							if(sortBuf.length()>0){
								if(this.remoteOrder != "" && this.remoteSort != "" && this.compid != ""){
									sortBuf = null;
									sortBuf = new StringBuffer();
									for(String sortStr:sortAllList){
										String[] strArr = sortStr.split(",");
										if(strArr.length == 3){
											sortBuf.append("\""+strArr[0]+"\" "+strArr[1]+",");
										}else{
											sortBuf.append("\""+strArr[0]+"\" "+strArr[1]+",");
										}
									}
								}
								sortBuf.deleteCharAt(sortBuf.length()-1);
								orderString = " ORDER BY " +sortBuf.toString();
							}else{
								if(this.remoteOrder != "" && this.remoteSort != "" && this.compid != ""){
									orderString = " ORDER BY \""+this.remoteSort+"\" "+this.remoteOrder+" ";
								}
							}
							
/*							 //指标是否自动聚合,0no
							//extcoldimmap排序计算列
							//extselcolkpimap指标计算列
							 if(component.getTablesetsum().equals("0")){
								 DataSetSqlMap.put("type","datagrid");
								 DataSetSqlMap.put("desc", datasource.getName()+"数据集");
								 DataSetSqlMap.put("dataSourceName", datasource.getExtds());
								 
								 extcolmap.putAll(extselcolkpimap);
								 int edl = extsortBuf.length();
								 int edkl = extcolmap.size();
								 
								 if(edkl>0){
									//需要拼接sql
									String newSql = " t.* from("+sqlString.toString()+") t ";
									StringBuffer extcolbuf = new StringBuffer();
									for(String key:extcolmap.keySet()){
										extcolbuf.append(extcolmap.get(key)).append(" as ").append(key).append(",");
									}
									newSql = extcolbuf.toString()+newSql;
									if(edl>0){
										 extsortBuf.deleteCharAt(extsortBuf.length()-1);
										 newSql += " order by "+extsortBuf.toString();
									}
									DataSetSqlMap.put("sql","select "+newSql);
								 }else{
									 DataSetSqlMap.put("sql", sqlString.toString());
								 }
								 infoMap.put("DataSetSqlMap", DataSetSqlMap);
								 continue;
							 }*/
							
							/////维度---------////////
							//首先合并联动参数和排序参数的MAP
							paramcolmap.putAll(sortcoldimmap);
							
							//判断联动参数和排序参数的字段是否在sql中的select后面
							if(selcolmap.keySet().size()>0){
								if(extcoldimmap.size()>0){//计算列
									Map<String,String> tmpmap = new HashMap<String,String>(extcoldimmap);
									for(String key:tmpmap.keySet()){
										if(selcolkpimap.get(key) != null){
											extcoldimmap.remove(key);
										}
									}
								}
								for(String key:selcolmap.keySet()){
									if(paramcolmap.get(key) != null){
										paramcolmap.remove(key);
									}
									if(extcolkpimap.get(key) != null){
										extcolkpimap.remove(key);
									}
									
								}
							}
							
							if(paramcolmap.keySet().size()>0){
								for(String key:paramcolmap.keySet()){
									colString += "\""+paramcolmap.get(key)+"\",";
									groupString+="\""+paramcolmap.get(key)+"\",";
								}
							}
							
							/////维度---------////////
							/////指标---------////////
							if(selcolkpimap.keySet().size()>0){
								for(String key:selcolkpimap.keySet()){
									if(sortcolkpimap.get(key) != null){
										sortcolkpimap.remove(key);
									}
								}
							}
							if(sortcolkpimap.keySet().size()>0){
								for(String key:sortcolkpimap.keySet()){
									colString += "SUM("+sortcolkpimap.get(key) + ") as \""+sortcolkpimap.get(key)+"\",";
								}
							}
							//计算列
							if(extcoldimmap.size()>0){
								for(String key:extcoldimmap.keySet()){
									//colString += extcoldimmap.get(key) + " as \""+key+"\",";
									colString += extcoldimmap.get(key)+",";
								}
							}
							
							//计算列中用到的指标
							if(extcolkpimap.size()>0){
								infoMap.put("ExtColKpimap", extcolkpimap);
								for(String key:extcolkpimap.keySet()){
									if(usecolkpimap.get(key) == null){
										colString += "SUM("+extcolkpimap.get(key) + ") as \""+key+"\",";
									}
								}
							}
							/////指标---------////////
							colString = colString.substring(0,colString.length()-1);
							if(!"".equals(groupString)&&groupString!=null){
								groupString = groupString.substring(0,groupString.length()-1);
								groupString =" GROUP BY "+groupString;
							}
							//3、得指标指标以后直接在原有的SQL 包个SQl即可
							if(datasource !=null && datasource.getSql() !=null){
								sqlString.insert(0, " SELECT " + colString + " FROM (");
								sqlString.append(") inits").append(groupString).append(orderString);
								
								String sql = sqlString.toString();
								//20160602增加普通表格合计
								String isTotal = component.getTableshowtotal();
								if(null != isTotal && !"".equals(isTotal) && isTotal.trim().equals("1")){
									String cols = colString;
									String dims = groupString.replace(" GROUP BY ", "");
									String[] dimArr = dims.split(",");
									for(int d=0;d<dimArr.length;d++){
										String dim = dimArr[d].trim();
										if(d ==0){
											//20160907添加，合计名字可自定义
											cols = cols.replace(dim, "'"+component.getTableshowtotalname()+"' "+dim);
										}else{
											cols = cols.replace(dim, "'' "+dim);
										}
									}
									
									boolean sqlIsConcatUnion=false;
									String dsname = CommonTools.getDataSource(datasource.getExtds()).getDataSourceDB();
									if(null != dsname && "" != dsname && dsname.length()>0 ){
										if(dsname.toLowerCase().equalsIgnoreCase("db2")){
											sqlIsConcatUnion=true;
											if("top".equals(pos)){
												sql = " select * from ("+sql+") dtbl  union all "+sqlString.insert(0, " SELECT " + cols + " FROM (").append(") totals").toString();
											}else{
												sql = sqlString.insert(0, " SELECT " + cols + " FROM (").append(") totals union all ").toString()+" select * from ("+sql+") dtbl";
											}
										}
									}
									
									if(!sqlIsConcatUnion){
										sql = sqlString.insert(0, " SELECT " + cols + " FROM (").append(") totals union all ").toString()+" select * from ("+sql+") dtbl";
										
										if("top".equals(pos)){
											sql = sqlString.insert(0, " SELECT " + cols + " FROM (").append(") totals union all ").toString()+" select * from ("+sql+") dtbl";
											
										}else{
											sql = " select * from ("+sql+") dtbl  union all "+sqlString.insert(0, " SELECT " + cols + " FROM (").append(") totals").toString();
										}
									}
									
								
									/*if(null != dsname && "" != dsname && dsname.length()>0 && dsname.equalsIgnoreCase("xcloud")){
										existsKey = " in ";
									}*/
								}
								
								DataSetSqlMap.put("desc", datasource.getName()+"数据集");
								DataSetSqlMap.put("type",cmcpType);
								DataSetSqlMap.put("sql", sql);
								DataSetSqlMap.put("totalname", component.getTableshowtotalname());
								DataSetSqlMap.put("dataSourceName", datasource.getExtds());
							}
							
							 infoMap.put("DataSetSqlMap", DataSetSqlMap);
							 return infoMap;
						}
					}
			}
		}
		 infoMap.put("DataSetSqlMap", DataSetSqlMap);
		 return infoMap;
	}
	public List<Map<String, String>> getReportDataSet(){
		String reportid = this.report.getId();
		String type = this.report.getInfo().getType();
		List<Map<String, String>> DataSetSql = new ArrayList<Map<String, String>>();
		String reportId = this.getStringValue(reportid);
		
		List<Container> containers = this.report.getContainers().getContainerList();
		Extcolumns extcolumns = this.report.getExtcolumns();
		List<Extcolumn> extcolumnlst = null != extcolumns?extcolumns.getExtcolumnList():null;
		
		XExtColumn xec = new XExtColumn(this.report);
		
		for(int c=0;c<containers.size();c++){
			Container container = containers.get(c);
			Components components = container.getComponents();
			if(components != null){
				List<Component> componentList = container.getComponents().getComponentList();
				if(componentList != null && componentList.size()>0)
					for(Component component:componentList){
						String cmcpType = this.getCompKind(component.getType().toLowerCase());
						if (cmcpType != null && 
								( cmcpType.equals("line") ||  
								  cmcpType.equals("bar")||
								  cmcpType.equals("column")||
								  cmcpType.equals("pie")||  
								  cmcpType.equals("columnline")) || 
								  cmcpType.equals("scatter")) {
						     
							 Datasource datasource = getDatasource(reportId,component.getDatasourceid());
							 StringBuffer sqlString = new StringBuffer(datasource.getSql());
							//初合化MAP对象
							 Map DataSetSqlMap = new HashMap();
							 DataSetSqlMap.put("id", component.getId().trim());
							 if(type.equals("2")){
								 DataSetSqlMap.put("type","chart");
								 DataSetSqlMap.put("desc", datasource.getName()+"数据集");
								 DataSetSqlMap.put("sql", sqlString.toString());
								 DataSetSqlMap.put("dataSourceName", datasource.getExtds());
								 DataSetSql.add(DataSetSqlMap);
								 continue;
							 }
							 Map<String,String> extCols = new HashMap<String,String>();//排序和维度扩展列
							 Map<String,String> kpiCols = new HashMap<String,String>();//所有的指标列
							 String sortfield = this.getStringValue(component.getXaxis().getSortfield());
							 String sortextfield = this.getStringValue(component.getXaxis().getSortExtField());
							 if(!"".equals(sortextfield)){
								 String[] extcol = xec.getExtCol(sortextfield);
								 sortfield = "\""+extcol[0]+"\"";
								 extCols.put("\""+extcol[0]+"\"", extcol[1]);
							 }
							 
							 String dimfield = this.getStringValue(component.getXaxis().getDimfield());
							 String dimfieldgrp = dimfield;
							 String dimextfield = this.getStringValue(component.getXaxis().getDimExtField());
							 if(!"".equals(dimextfield)){
								 String[] extcol = xec.getExtCol(dimextfield);
								 dimfield = extcol[1];
								 dimfieldgrp = "\""+extcol[0]+"\"";
								 extCols.put("\""+extcol[0]+"\"", extcol[1]);
							 }
							 
							 String scatterDimField = this.getStringValue(component.getXaxis().getScatterDimField());
							 String scatterDimFieldgrp = scatterDimField;
							 String scatterextDimField = this.getStringValue(component.getXaxis().getScatterDimExtField());
							 if(!"".equals(scatterextDimField)){
								 String[] extcol = xec.getExtCol(scatterextDimField);
								 scatterDimField = extcol[1];
								 scatterDimFieldgrp = "\""+extcol[0]+"\"";
								 extCols.put("\""+extcol[0]+"\"", extcol[1]);
							 }
							 
							 String sortKpiType = this.getStringValue(component.getXaxis().getSortkpitype());
							 String sortType = this.getStringValue(component.getXaxis().getSortType());
							 String sortString = "";
							 if(sortfield !=null && !sortfield.trim().equals("")){
								 sortString = " ORDER BY " + sortfield;
							 }else{
								 sortString = " ORDER BY " + dimfieldgrp;
							 }
							 if(sortType!=null &&!sortType.trim().equals("")){
								 sortString += " "+sortType;
							 }
							 String groupString = " ";

							 if(dimfield != null && !dimfield.equals("")){
								 groupString = " GROUP BY " + dimfield;
							 }
							 if(!sortfield.equals("") && !dimfield.equals("") && !dimfield.equals(sortfield)&&"dim".equals(sortKpiType)){
								 groupString = " GROUP BY " + sortfield + "," + dimfield;
							 }
							 if(cmcpType.equals("scatter")){
								 if(!scatterDimField.equals(dimfield)){
									 groupString = " GROUP BY " + dimfield + "," + scatterDimFieldgrp;
								 }else{
									 groupString = " GROUP BY " + dimfieldgrp;
								 }
							 }
							 
							 
							 List<Kpi> kpiList = component.getKpiList();
							 String kpiString = "";
							 for(Kpi kpi:kpiList){
								if(null != kpi.getExtcolumnid() && !"".equals(kpi.getExtcolumnid())){
									String name = xec.getExtColName(kpi.getExtcolumnid());
									kpiCols.put("\""+name+"\"",name);
								}else{
									kpiCols.put(kpi.getField(),kpi.getField());
								}
								 
								 String extcolid = this.getStringValue(kpi.getExtcolumnid());
								 if(!"".equals(extcolid)){
									 String[] extcol = xec.getExtCol(extcolid);
									 kpiString += " "+extcol[1] + ",";
									 
								 }else{
									 kpiString += " SUM("+kpi.getField()+") as "+kpi.getField() + ",";
								 }
							 }
							 
							 if(sortfield != null && !sortfield.equals("")&&"kpi".equals(sortKpiType)){
								 String tmpKpi = kpiCols.get(sortfield);
								 if(null == tmpKpi || "".equals(tmpKpi)){
									 if(null != extCols.get(sortfield) && !"".equals(extCols.get(sortfield))){
										 kpiString += "  "+extCols.get(sortfield) + ",";
									 }else{
										 kpiString += " SUM("+sortfield+") as "+sortfield + ",";
									 }
								 }
							 }
							 kpiString = kpiString.substring(0,kpiString.length()-1);
							 
							 if(cmcpType.equals("scatter")){
								 if(!scatterDimField.equals(dimfield)){
									 sqlString.insert(0, " SELECT " + dimfield+"," + scatterDimField+"," + kpiString + " FROM (");
								 }else{
									 sqlString.insert(0, " SELECT " + dimfield+"," + kpiString + " FROM (");
								 }
							 }else{
								 sqlString.insert(0, " SELECT " + dimfield+"," + kpiString + " FROM (");
							 }
							 sqlString.append(") ct ").append(groupString).append(sortString);
							 
							 DataSetSqlMap.put("type","chart");
							 DataSetSqlMap.put("desc", datasource.getName()+"数据集");
							 DataSetSqlMap.put("sql", sqlString.toString());
							 DataSetSqlMap.put("dataSourceName", datasource.getExtds());
							 DataSetSql.add(DataSetSqlMap);
						} else if (cmcpType != null && cmcpType.equals("datagrid")) {
							 Datasource datasource = getDatasource(reportId,component.getDatasourceid());
							 StringBuffer sqlString = new StringBuffer(datasource.getSql());
							//初合化MAP对象
							 Map DataSetSqlMap = new HashMap();
							 DataSetSqlMap.put("id", component.getId().trim());
							 
							 if(type.equals("2")){
								 DataSetSqlMap.put("type","datagrid");
								 DataSetSqlMap.put("desc", datasource.getName()+"数据集");
								 DataSetSqlMap.put("sql", sqlString.toString());
								 DataSetSqlMap.put("dataSourceName", datasource.getExtds());
								 DataSetSql.add(DataSetSqlMap);
								 continue;
							 }
							 
							 Map<String,String> extcoldimmap = new HashMap<String,String>();//计算列
							 StringBuffer extsortBuf = new StringBuffer();//计算列,非汇聚表格时使用
							 Map<String,String> extcolmap = new HashMap<String,String>();//计算列,非汇聚表格时使用
							 
							 Map<String,String> selcolkpimap = new HashMap<String,String>();
							 Map<String,String> formula2KpiMap = new HashMap<String,String>();
							 
							//1、得到排序字段
							StringBuffer sortBuf = new StringBuffer();
							Map<String,String> sortcoldimmap = new HashMap<String,String>();
							Map<String,String> sortcolkpimap = new HashMap<String,String>();
							SortcolStore sortcolstore = component.getSortcolStore();
							if(sortcolstore != null && sortcolstore.getSortcolList() != null){
								List<Sortcol> sortcols = sortcolstore.getSortcolList();
								for(int s=0;s<sortcols.size();s++){
									Sortcol sortcol = sortcols.get(s);
									if(sortcol.getKpitype() == null || sortcol.getKpitype().equals("") || sortcol.getKpitype().equals("dim")){
										sortBuf.append("\""+sortcol.getCol()+"\" "+sortcol.getType()+",");
										sortcoldimmap.put(sortcol.getCol(), sortcol.getCol());
									}else{
										String extcool = sortcol.getExtcolumnid();
										if(null != extcool && extcool.length()>0 && extcolumnlst != null){
											for(Extcolumn extcolumn:extcolumnlst){
												if(extcolumn.getId().equals(extcool)){
													//String name = extcolumn.getName().toUpperCase();
													String name = extcolumn.getName();
													String formula = extcolumn.getFormula().toUpperCase();
													
													//StringBuffer formulaKpi = new StringBuffer();
													Map<String,String> ParamMap = new HashMap<String,String>();
													List<?> params = extcolumn.getParamList();
													for(int p=0;p<params.size();p++){
														Object param = params.get(p);
														if(param instanceof Param){
															ParamMap.put(((Param)param).getName(),((Param)param).getValue());
															formula2KpiMap.put(((Param)param).getValue(),((Param)param).getValue());
														}else{
															ParamMap.put(((Map<String,String>)param).get("name"),((Map<String,String>)param).get("value"));
															formula2KpiMap.put(((Map<String,String>)param).get("value"),((Map<String,String>)param).get("value"));
														}
													}
													
													StringBuffer formulaKpi = xec.divisor2decode(formula, ParamMap,true,name);
													StringBuffer formulaKpi2 = xec.divisor2decode(formula, ParamMap,false,name);
													sortBuf.append("\""+name+"\" "+sortcol.getType()+",");
													extsortBuf.append("\""+name+"\" "+sortcol.getType()+",");
													extcoldimmap.put(name,formulaKpi.toString());
													extcolmap.put(name,formulaKpi2.toString());
												}
											}
										}else{
/*											if("kpi".equals(sortcol.getKpitype())){
												sortBuf.append("\""+sortcol.getCol()+"\" "+sortcol.getType()+",");
											}else{
												sortBuf.append("\""+sortcol.getCol()+"\" "+sortcol.getType()+",");
											}*/
											sortBuf.append("\""+sortcol.getCol()+"\" "+sortcol.getType()+",");
											sortcolkpimap.put(sortcol.getCol(), sortcol.getCol());
											//extsortBuf.append(sortcol.getCol()+" "+sortcol.getCol()+",");
										}
									}
								}
							}
							String orderString = "";
							if(sortBuf.length()>0){
								sortBuf.deleteCharAt(sortBuf.length()-1);
								orderString = " ORDER BY " +sortBuf.toString();
							}
							//2、得到所有指标列表包括维度 拼串
							String colString = "";
							String groupString = ""; 
							List<Datacol> datacolList = component.getDatastore().getDatacolList();//找到所有的的eventstore
							
							Map<String,String> paramcolmap = new HashMap<String,String>();
							Map<String,String> selcolmap = new HashMap<String,String>();
							
							Map<String,String> extselcolkpimap = new HashMap<String,String>();//计算列，非聚合表格
							for(Datacol datacol:datacolList){
								if(!this.getStringValue(datacol.getDatacolcode()).equals("")){
									String strtype = datacol.getDatacoltype();
									if("kpi".equals(strtype)){
										String extcool = datacol.getExtcolumnid();
										if(null != extcool && extcool.length()>0 && extcolumnlst != null){
											for(Extcolumn extcolumn:extcolumnlst){
												if(extcolumn.getId().equals(extcool)){
													//String name = extcolumn.getName().toUpperCase();
													String name = extcolumn.getName();
													String formula = extcolumn.getFormula().toUpperCase();
													
													//StringBuffer formulaKpi = new StringBuffer();
													Map<String,String> ParamMap = new HashMap<String,String>();
													List<?> params = extcolumn.getParamList();
													for(int p=0;p<params.size();p++){
														Object param = params.get(p);
														if(param instanceof Param){
															ParamMap.put(((Param)param).getName(),((Param)param).getValue());
															formula2KpiMap.put(((Param)param).getValue(),((Param)param).getValue());
														}else{
															ParamMap.put(((Map<String,String>)param).get("name"),((Map<String,String>)param).get("value"));
															formula2KpiMap.put(((Map<String,String>)param).get("value"),((Map<String,String>)param).get("value"));
														}
													}
													
											        StringBuffer formulaKpi = xec.divisor2decode(formula, ParamMap,true,name);
											        StringBuffer formulaKpi2 = xec.divisor2decode(formula, ParamMap,false,name);
													colString += formulaKpi.toString() + ",";
													selcolkpimap.put(name,formulaKpi.toString());
													extselcolkpimap.put(name,formulaKpi2.toString());
												}
											}
										}else{
											colString += "SUM("+datacol.getDatacolcode() + ") as \""+datacol.getDatacolcode()+"\",";
											selcolkpimap.put(datacol.getDatacolcode(),datacol.getDatacolcode());
										}
										Eventstore eventstore = datacol.getEventstore();
										if(eventstore != null && eventstore.getEventList() != null){
											List<Event> events = eventstore.getEventList();
											for(int e=0;e<events.size();e++){
												Event event = events.get(e);
												if(event != null && event.getParameterList() != null){
													List<Parameter> parameters= event.getParameterList();
													for(int p=0;p<parameters.size();p++){
														Parameter parameter = parameters.get(p);
														paramcolmap.put(parameter.getValue(), parameter.getValue());
													}
												}
											}
										}
									}else{
										colString += "\""+datacol.getDatacolcode()+"\",";
										groupString+="\""+datacol.getDatacolcode()+"\",";
										selcolmap.put(datacol.getDatacolcode(), datacol.getDatacolcode());
										
										Eventstore eventstore = datacol.getEventstore();
										if(eventstore != null && eventstore.getEventList() != null){
											List<Event> events = eventstore.getEventList();
											for(int e=0;e<events.size();e++){
												Event event = events.get(e);
												if(event != null && event.getParameterList() != null){
													List<Parameter> parameters= event.getParameterList();
													for(int p=0;p<parameters.size();p++){
														Parameter parameter = parameters.get(p);
														paramcolmap.put(parameter.getValue(), parameter.getValue());
													}
												}
											}
										}
									}
								}
							}
							
							 //指标是否自动聚合,0no
							//extcoldimmap排序计算列
							//extselcolkpimap指标计算列
							 if(component.getTablesetsum().equals("0")){
								 DataSetSqlMap.put("type","datagrid");
								 DataSetSqlMap.put("desc", datasource.getName()+"数据集");
								 DataSetSqlMap.put("dataSourceName", datasource.getExtds());
								 
								 extcolmap.putAll(extselcolkpimap);
								 int edl = extsortBuf.length();
								 int edkl = extcolmap.size();
								 int edsl = orderString.length();
								 
								 if(edkl>0 || edsl>0){
									//需要拼接sql
									String newSql = " t.* from("+sqlString.toString()+") t ";
									StringBuffer extcolbuf = new StringBuffer();
									if(edkl>0){
										for(String key:extcolmap.keySet()){
											if(extcolmap.get(key).trim().endsWith("end \""+key+"\"") || extcolmap.get(key).trim().endsWith("as \""+key+"\"")){
												extcolbuf.append(extcolmap.get(key)).append(",");
											}else{
												extcolbuf.append(extcolmap.get(key)).append(" as \"").append(key).append("\",");
											}
										}
									}
									newSql = extcolbuf.toString()+newSql;
									if(edsl>0){
										 //extsortBuf.deleteCharAt(extsortBuf.length()-1);
										 newSql += orderString;//" order by "+extsortBuf.toString();
									}
									DataSetSqlMap.put("sql","select "+newSql);
								 }else{
									 DataSetSqlMap.put("sql", sqlString.toString());
								 }
								 DataSetSql.add(DataSetSqlMap);
								 continue;
							 }
							 
							/////维度---------////////
							//首先合并联动参数和排序参数的MAP
							paramcolmap.putAll(sortcoldimmap);
							
							//判断联动参数和排序参数的字段是否在sql中的select后面
							if(selcolmap.keySet().size()>0){
								for(String key:selcolmap.keySet()){
									if(paramcolmap.get(key) != null){
										paramcolmap.remove(key);
									}
								}
							}
							
							if(paramcolmap.keySet().size()>0){
								for(String key:paramcolmap.keySet()){
									String v = paramcolmap.get(key);
									if(v.indexOf("\"")<=-1){
										colString += "\""+v+"\",";
									}else{
										colString += v + ",";
									}
									groupString+="\""+paramcolmap.get(key)+"\",";
								}
							}
							
							/////维度---------////////
							/////指标---------////////
							if(selcolkpimap.keySet().size()>0){
								if(extcoldimmap.size()>0){//计算列
									for(String key:extcoldimmap.keySet()){
										if(selcolkpimap.get(key) != null){
											extcoldimmap.remove(key);
										}
									}
								}
								for(String key:selcolkpimap.keySet()){
									if(sortcolkpimap.get(key) != null){
										sortcolkpimap.remove(key);
									}
								}
							}
							
							if(sortcolkpimap.keySet().size()>0){
								for(String key:sortcolkpimap.keySet()){
									colString += "SUM("+sortcolkpimap.get(key) + ") as \""+sortcolkpimap.get(key)+"\",";
								}
							}
							
							//计算列
							if(extcoldimmap.size()>0){
								for(String key:extcoldimmap.keySet()){
									colString += extcoldimmap.get(key)+",";
								}
							}
							
							//将所有计算列中的指标添加到sql里
							if(formula2KpiMap.size()>0){
								Map<String,String> tmpAll = new HashMap<String,String>();
								tmpAll.putAll(selcolkpimap);
								tmpAll.putAll(sortcolkpimap);
								for(String key:tmpAll.keySet()){
									if(formula2KpiMap.get(key) != null){
										formula2KpiMap.remove(key);
									}
								}
								if(formula2KpiMap.size()>0){
									for(String key:formula2KpiMap.keySet()){
										colString += "SUM("+formula2KpiMap.get(key) + ") as \""+formula2KpiMap.get(key)+"\",";
									}
								}
							}
							/////指标---------////////

							colString = colString.substring(0,colString.length()-1);
							if(!"".equals(groupString)&&groupString!=null){
								groupString = groupString.substring(0,groupString.length()-1);
								groupString =" GROUP BY "+groupString;
							}
							//3、得指标指标以后直接在原有的SQL 包个SQl即可
							if(datasource !=null && datasource.getSql() !=null){
								sqlString.insert(0, " SELECT " + colString + " FROM (");
								sqlString.append(") inits").append(groupString).append(orderString);
								
								String sql = sqlString.toString();
								//20160602增加普通表格合计
								String isTotal = component.getTableshowtotal();
								if(null != isTotal && !"".equals(isTotal) && isTotal.trim().equals("1")){
									String cols = colString;
									String dims = groupString.replace(" GROUP BY ", "");
									String[] dimArr = dims.split(",");
									for(int d=0;d<dimArr.length;d++){
										String dim = dimArr[d].trim();
										if(d ==0){
											//20160907添加，合计名称可自定义
											cols = cols.replace(dim, "'"+component.getTableshowtotalname()+"' "+dim);
										}else{
											cols = cols.replace(dim, "'' "+dim);
										}
									}
									String pos = component.getTableshowtotalposition();
									
									boolean sqlIsConcatUnion=false;
									String dsname = CommonTools.getDataSource(datasource.getExtds()).getDataSourceDB();
									if(null != dsname && "" != dsname && dsname.length()>0 ){
										if(dsname.toLowerCase().equalsIgnoreCase("db2")){
											sqlIsConcatUnion=true;
											if("top".equals(pos)){
												sql = " select * from ("+sql+") dtbl union all " +sqlString.insert(0, " SELECT " + cols + " FROM (").append(") totals ").toString();
											}else{
												sql = sqlString.insert(0, " SELECT " + cols + " FROM (").append(") totals union all").toString()+" select * from ("+sql+") dtbl";
												
											}
											
										}
									}
									if(!sqlIsConcatUnion){
										if("top".equals(pos)){
											sql = sqlString.insert(0, " SELECT " + cols + " FROM (").append(") totals union all").toString()+" select * from ("+sql+") dtbl";
										}else{
											sql = " select * from ("+sql+") dtbl union all " +sqlString.insert(0, " SELECT " + cols + " FROM (").append(") totals ").toString();
										}
									}
									
/*									if("" != orderString){
										sql = "select * from("+sql+") "+orderString;
									}*/
								}
								
								DataSetSqlMap.put("desc", datasource.getName()+"数据集");
								DataSetSqlMap.put("type",cmcpType);
								DataSetSqlMap.put("sql", sql);
								DataSetSqlMap.put("dataSourceName", datasource.getExtds());
							}
							DataSetSql.add(DataSetSqlMap);
						} else if (cmcpType != null && cmcpType.toLowerCase().equals("treegrid")) {
							//初合化MAP对象
							Map<String,String> extcoldimmap = new HashMap<String,String>();//计算列
							Map<String,String> allDimMap = new HashMap<String,String>();
							Map<String,String> allKpiMap = new HashMap<String,String>();
							Map<String,String> allSortDimMap = new HashMap<String,String>();
							Map<String,String> allSortKpiMap = new HashMap<String,String>();
							
							 Datasource datasource = null;//第一个下钻的数据集
							 String idFieldCol = "",treeFieldCol = "",orderString1 = " order by ";//第一个下钻的维度，按照他排序
							 boolean hasHeJi = false;
							 String isField = component.getIdfield();
							 String treeField = component.getTreefield();
							 //0、有合计时，构造合计sql，不用走123.
							 //1、subdrill中用户设置了Isdefault=1
							 //2、未设置Isdefault，则取第一个subdrill，且level=0
							 //3、1、2不满足时，顺序查找subdrill中，第一个level为0的
							
							Subdrills subdrills = component.getSubdrills();
							String hasHeJiDim = component.getHastotalflag();//是否为虚拟合计
							
							
							if(hasHeJiDim != null && hasHeJiDim.equals("1")){
								datasource = getDatasource(reportId,subdrills.getSubdrillList().get(0).getDatasourceid());
								orderString1 = "";
								idFieldCol = "";
								hasHeJi = true;
								treeFieldCol = component.getTotaltitle();
							}else{
								List<Subdirllsortcol> sortcols = null;
								if(subdrills != null && subdrills.getSubdrillList().size()>0){
									List<Subdrill> drills = subdrills.getSubdrillList();
									Subdrill subdrill0 = drills.get(0);
									String firstLevel = subdrill0.getLevel();
									boolean flag = true;
									for(int d=0;d<drills.size();d++){
										Subdrill subdrill = drills.get(d);
										String dft= subdrill.getIsdefault();
										if(dft != null && dft.equals("1")){
											datasource = getDatasource(reportId,subdrill.getDatasourceid());
											//orderString1 += subdrill.getDrillcolcode();
											sortcols = subdrill.getSubdirllsortcols().getSubdirllsortcolList();
											idFieldCol = subdrill.getDrillcolcode();
											treeFieldCol = subdrill.getDrillcoldesc();
											break;
										}
										if(!firstLevel.equals("0") && flag){
											flag = false;
											String tempLevel = subdrill.getLevel();
											if(tempLevel.equals("0")){
												//orderString1 += subdrill.getDrillcolcode();
												sortcols = subdrill.getSubdirllsortcols().getSubdirllsortcolList();
												datasource = getDatasource(reportId,subdrill.getDatasourceid());
												idFieldCol = subdrill.getDrillcolcode();
												treeFieldCol = subdrill.getDrillcoldesc();
											}
										}
									}
									if(datasource == null){
										datasource = getDatasource(reportId,subdrill0.getDatasourceid());
										//orderString1 += subdrill0.getDrillcolcode();
										sortcols = subdrill0.getSubdirllsortcols().getSubdirllsortcolList();
										idFieldCol = subdrill0.getDrillcolcode();
										treeFieldCol = subdrill0.getDrillcoldesc();
									}
								}
								if(sortcols !=null && sortcols.size()>0){
									StringBuffer sortcolsbuff = new StringBuffer();
									sortcolsbuff.append(" ORDER BY ");
									for(Subdirllsortcol sortcol:sortcols){
										
										String extcool = sortcol.getExtcolumnid();
										if(null != extcool && extcool.length()>0 && !extcool.equalsIgnoreCase("null") && extcolumnlst != null){
											for(Extcolumn extcolumn:extcolumnlst){
												if(extcolumn.getId().equals(extcool)){
													//String name = extcolumn.getName().toUpperCase();
													String name = extcolumn.getName();
													String formula = extcolumn.getFormula().toUpperCase();
													
													//StringBuffer formulaKpi = new StringBuffer();
													Map<String,String> ParamMap = new HashMap<String,String>();
													List<?> params = extcolumn.getParamList();
													for(int p=0;p<params.size();p++){
														Object param = params.get(p);
														if(param instanceof Param){
															ParamMap.put(((Param)param).getName(),((Param)param).getValue());
														}else{
															ParamMap.put(((Map<String,String>)param).get("name"),((Map<String,String>)param).get("value"));
														}
													}
													StringBuffer formulaKpi = xec.divisor2decode(formula, ParamMap,true,name);
													sortcolsbuff.append("\""+name).append("\" ").append(sortcol.getSorttype()).append(",");
													extcoldimmap.put(name,formulaKpi.toString());
												}
											}
										}else{
											String stype = sortcol.getSortkpitype();
											if("kpi".equals(stype)){
												sortcolsbuff.append("\""+sortcol.getColcode()+"\"").append(" ").append(sortcol.getSorttype()).append(",");
												allSortKpiMap.put(sortcol.getColcode(), sortcol.getColcode());
											}else{
												sortcolsbuff.append("\""+sortcol.getColcode()).append("\" ").append(sortcol.getSorttype()).append(",");
												allSortDimMap.put(sortcol.getColcode(), sortcol.getColcode());
											}
										}
									}
									sortcolsbuff.deleteCharAt(sortcolsbuff.length()-1);
									orderString1 = sortcolsbuff.toString();
								}
							}
							
							StringBuffer sqlString = new StringBuffer(datasource.getSql());
							//初合化MAP对象
							 Map DataSetSqlMap = new HashMap();
							
							/***下钻默认数据集设置***/
							//2、找到IDFIELD & TREEFIELD
//							String isField = component.getIdfield();
//							String treeField = component.getTreefield();

							
							//3、得到所有指标列表包括维度 拼串
							String colString = "";
							String kpiString = "";
							String groupString = "group by "; 
							List<Datacol> datacolList = component.getDatastore().getDatacolList();
							if(datacolList == null)
								System.out.println("下钻表格未成功绑定数据列！");
							
							Map<String,String> paramcolmap = new HashMap<String,String>();
							Map<String,String> selcolmap = new HashMap<String,String>();
							Map<String,String> hejiextcolmap = new HashMap<String,String>();//20160512修改有合计时，没有计算列的bug

							for(Datacol datacol:datacolList){
								//kpiString += datacol.getDatacolcode() + ",";
								String strtype = datacol.getDatacoltype();
								if("kpi".equals(strtype)){
									
									String extcool = datacol.getExtcolumnid();
									if(null != extcool && extcool.length()>0 && extcolumnlst != null){
										for(Extcolumn extcolumn:extcolumnlst){
											if(extcolumn.getId().equals(extcool)){
												//String name = extcolumn.getName().toUpperCase();
												String name = extcolumn.getName();
												String formula = extcolumn.getFormula().toUpperCase();
												
												//StringBuffer formulaKpi = new StringBuffer();
												Map<String,String> ParamMap = new HashMap<String,String>();
												List<?> params = extcolumn.getParamList();
												for(int p=0;p<params.size();p++){
													Object param = params.get(p);
													if(param instanceof Param){
														ParamMap.put(((Param)param).getName(),((Param)param).getValue());
														allKpiMap.put(((Param)param).getValue(),((Param)param).getValue());
													}else{
														ParamMap.put(((Map<String,String>)param).get("name"),((Map<String,String>)param).get("value"));
														allKpiMap.put(((Map<String,String>)param).get("value"),((Map<String,String>)param).get("value"));
													}
												}
												StringBuffer formulaKpi = xec.divisor2decode(formula, ParamMap,true,name);
												colString += formulaKpi.toString() +  ",";
												selcolmap.put(name,formulaKpi.toString());
												hejiextcolmap.put(name,formulaKpi.toString());
											}
										}
									}else{
										kpiString += "SUM("+datacol.getDatacolcode() + ") as \""+datacol.getDatacolcode()+"\",";
										allKpiMap.put(datacol.getDatacolcode(), datacol.getDatacolcode());
									}
									
									Eventstore eventstore = datacol.getEventstore();
									if(eventstore != null && eventstore.getEventList() != null){
										List<Event> events = eventstore.getEventList();
										for(int e=0;e<events.size();e++){
											Event event = events.get(e);
											if(event != null && event.getParameterList() != null){
												List<Parameter> parameters= event.getParameterList();
												for(int p=0;p<parameters.size();p++){
													Parameter parameter = parameters.get(p);
													paramcolmap.put(parameter.getValue(), parameter.getValue());
												}
											}
										}
									}
								}else{
									colString += "\""+datacol.getDatacolcode()+"\",";
									groupString+="\""+datacol.getDatacolcode()+"\",";
									allDimMap.put(datacol.getDatacolcode(), datacol.getDatacolcode());
									selcolmap.put(datacol.getDatacolcode(), datacol.getDatacolcode());
									
									Eventstore eventstore = datacol.getEventstore();
									if(eventstore != null && eventstore.getEventList() != null){
										List<Event> events = eventstore.getEventList();
										for(int e=0;e<events.size();e++){
											Event event = events.get(e);
											if(event != null && event.getParameterList() != null){
												List<Parameter> parameters= event.getParameterList();
												for(int p=0;p<parameters.size();p++){
													Parameter parameter = parameters.get(p);
													paramcolmap.put(parameter.getValue(), parameter.getValue());
												}
											}
										}
									}
								}
							}
							
							if(extcoldimmap.size()>0){//排序列中的计算列
								for(String key:extcoldimmap.keySet()){
									if(selcolmap.get(key) != null){
										extcoldimmap.remove(key);
									}
								}
							}
							//计算列
							if(extcoldimmap.size()>0){
								for(String key:extcoldimmap.keySet()){
									colString += extcoldimmap.get(key)+",";
								}
							}
							
							//判断联动参数和排序参数的字段是否在sql中的select后面
							if(selcolmap.keySet().size()>0){
								for(String key:selcolmap.keySet()){
									if(paramcolmap.get(key) != null){
										paramcolmap.remove(key);
									}
								}
							}
							
							if(paramcolmap.keySet().size()>0){
								for(String key:paramcolmap.keySet()){
									colString += "\""+paramcolmap.get(key)+"\",";
									groupString+="\""+paramcolmap.get(key)+"\",";
								}
							}
							
							kpiString = kpiString.substring(0,kpiString.length()-1);
							
							String baseColString = colString;
							String basegroupString = groupString;
							
							allDimMap.put(idFieldCol,idFieldCol);
							allDimMap.put(treeFieldCol,treeFieldCol);
							
							//排序中所有的维度和指标，是否是被选择的；是否是参数里边的，都不是需要添加到sql中。
							for(String key:allDimMap.keySet()){
								if(allSortDimMap.get(key) != null){
									allSortDimMap.remove(key);
								}
							}
							for(String key:allKpiMap.keySet()){
								if(allSortKpiMap.get(key) != null){
									allSortKpiMap.remove(key);
								}
							}
							if(paramcolmap.keySet().size()>0){
								for(String key:paramcolmap.keySet()){
									if(allSortDimMap.get(key) != null){
										allSortDimMap.remove(key);
									}
									if(allSortKpiMap.get(key) != null){
										allSortKpiMap.remove(key);
									}
								}
							}
							
							StringBuffer selSortBuf = new StringBuffer();
							StringBuffer gupSortBuf = new StringBuffer();
							
							if(allSortDimMap.keySet().size()>0){
								for(String key:allSortDimMap.keySet()){
									selSortBuf.append("\""+key).append("\",");
									gupSortBuf.append("\""+key).append("\",");
								}
							}
							if(allSortKpiMap.keySet().size()>0){
								for(String key:allSortKpiMap.keySet()){
									selSortBuf.append("SUM("+key+") as \"").append(key).append("\",");
								}
							}
							
							colString += idFieldCol + " "+isField+"," + treeFieldCol + " "+treeField+"," + kpiString;
							if(selSortBuf.length()>0){
								selSortBuf.deleteCharAt(selSortBuf.length()-1);
								colString += ","+selSortBuf.toString();
							}
							groupString +=idFieldCol +"," + treeFieldCol;
							if(gupSortBuf.length()>0){
								gupSortBuf.deleteCharAt(gupSortBuf.length()-1);
								groupString += ","+gupSortBuf.toString();
							}


							//4、得指标指标以后直接在原有的SQL 包个SQl即可
							if(datasource == null){
								System.out.println("组件中未找到绑定的数据源ID={datasource}");
							}
							if(hasHeJi){
								//20160512修改有合计时，没有计算列的bug
								if(hejiextcolmap.keySet().size()>0){
									for(String key:hejiextcolmap.keySet()){
										kpiString += ","+hejiextcolmap.get(key);
									}
								}
								sqlString.insert(0, " SELECT '-1' as \""+isField+"\",'"+treeFieldCol+"' as \""+treeField+"\"," + kpiString + " FROM (");
								sqlString.append(") inits ");
								 DataSetSqlMap.put("id", component.getId().trim());
								 DataSetSqlMap.put("type",cmcpType);
								 DataSetSqlMap.put("desc", datasource.getName()+"数据集");
								 DataSetSqlMap.put("sql", sqlString.toString());
								 DataSetSqlMap.put("dataSourceName", datasource.getExtds());
								 DataSetSqlMap.put("dimField", "all");//component.getDimrootcode()
								 DataSetSql.add(DataSetSqlMap);
							}else{
								 if(type.equals("2")){
									 DataSetSqlMap.put("id", component.getId().trim());
									 DataSetSqlMap.put("type",cmcpType);
									 DataSetSqlMap.put("desc", datasource.getName()+"数据集");
									 DataSetSqlMap.put("sql", sqlString.toString());
									 DataSetSqlMap.put("dataSourceName", datasource.getExtds());
									 DataSetSqlMap.put("dimField", "all");//component.getDimrootcode()
									 DataSetSql.add(DataSetSqlMap);
									 //continue;
								 }else{
									sqlString.insert(0, " SELECT " + colString + " FROM (");
									sqlString.append(") inits ").append(groupString).append(orderString1);
									DataSetSqlMap.put("desc", datasource.getName()+"数据集");
									DataSetSqlMap.put("dimField", "all");//component.getDimrootcode()
									DataSetSqlMap.put("type",cmcpType);
									DataSetSqlMap.put("sql", sqlString.toString());
									DataSetSqlMap.put("dataSourceName", datasource.getExtds());
									DataSetSql.add(DataSetSqlMap);
								 }
							}
							
/*							DataSetSqlMap.put("desc", datasource.getName()+"数据集");
							DataSetSqlMap.put("dimField", "all");//component.getDimrootcode()
							DataSetSqlMap.put("type",cmcpType);
							DataSetSqlMap.put("sql", sqlString.toString());
							DataSetSqlMap.put("dataSourceName", datasource.getExtds());
							DataSetSql.add(DataSetSqlMap);*/
							/***下钻设置***/
							List<Subdrill> subdrillList = component.getSubdrills().getSubdrillList();
							for(Subdrill subdrill:subdrillList){
								//初合化MAP对象
								Map<String,String> extcoldimmapsub = new HashMap<String,String>();//计算列
								Map<String,String> allDrillSortDimMap = new HashMap<String,String>();
								Map<String,String> allDrillSortKpiMap = new HashMap<String,String>();
								
								Map DataSetSqlMapSub = new HashMap();
								DataSetSqlMapSub.put("id", component.getId().trim());
								//1、获取数据集
								Datasource dbsource = getDatasource(reportId,subdrill.getDatasourceid());
								//2、找到IDFIELD & TREEFIELD
								String subDrillIsField = subdrill.getDrillcolcode();
								String subDrillTreeField = subdrill.getDrillcoldesc();
								
								//
								String groupfield = " "+basegroupString+""+subDrillIsField+","+subDrillTreeField;
								//1、得到排序字段
								String sortfield = subDrillIsField;//component.getSortcol();
								String sorttype = "asc";//component.getSorttype();
								String orderString = "";
								List<Subdirllsortcol> sortcols = subdrill.getSubdirllsortcols().getSubdirllsortcolList();
								
								if(sortcols !=null && sortcols.size()>0){
									StringBuffer sortcolsbuff = new StringBuffer();
									sortcolsbuff.append(" ORDER BY ");
									for(Subdirllsortcol sortcol:sortcols){
										String extcool = sortcol.getExtcolumnid();
										if(null != extcool && extcool.length()>0 && !"null".toUpperCase().equals(extcool.toUpperCase()) && extcolumnlst != null){
											for(Extcolumn extcolumn:extcolumnlst){
												if(extcolumn.getId().equals(extcool)){
													//String name = extcolumn.getName().toUpperCase();
													String name = extcolumn.getName();
													String formula = extcolumn.getFormula().toUpperCase();
													
													//StringBuffer formulaKpi = new StringBuffer();
													Map<String,String> ParamMap = new HashMap<String,String>();
													List<?> params = extcolumn.getParamList();
													for(int p=0;p<params.size();p++){
														Object param = params.get(p);
														if(param instanceof Param){
															ParamMap.put(((Param)param).getName(),((Param)param).getValue());
															allDrillSortKpiMap.put(((Param)param).getValue(),((Param)param).getValue());
														}else{
															ParamMap.put(((Map<String,String>)param).get("name"),((Map<String,String>)param).get("value"));
															allDrillSortKpiMap.put(((Map<String,String>)param).get("value"),((Map<String,String>)param).get("value"));
														}
													}
													StringBuffer formulaKpi = xec.divisor2decode(formula, ParamMap,true,name);
													sortcolsbuff.append("\""+name).append("\" ").append(sortcol.getSorttype()).append(",");
													extcoldimmapsub.put(name,formulaKpi.toString());
												}
											}
										}else{
											
											String stype = sortcol.getSortkpitype();
											if("kpi".equals(stype)){
												sortcolsbuff.append("\""+sortcol.getColcode()+"\"").append(" ").append(sortcol.getSorttype()).append(",");
												allDrillSortKpiMap.put(sortcol.getColcode(), sortcol.getColcode());
											}else{
												sortcolsbuff.append("\""+sortcol.getColcode()).append("\" ").append(sortcol.getSorttype()).append(",");
												allDrillSortDimMap.put(sortcol.getColcode(), sortcol.getColcode());
											}
										}
									}
									sortcolsbuff.deleteCharAt(sortcolsbuff.length()-1);
									//orderString = " ORDER BY " +sortfield +" "+ this.getStringValue(sorttype);
									orderString = sortcolsbuff.toString();
								}
								
								//计算列
								if(extcoldimmapsub.size()>0){
									for(String key:extcoldimmapsub.keySet()){
										if(selcolmap.get(key) == null && extcoldimmap.get(key) == null){
											kpiString += ","+extcoldimmapsub.get(key)+",";
										}
									}
								}
								
								
								String tmpgroupfield = groupfield.replaceAll(" group by ", "");
								String[] grps = null != tmpgroupfield?tmpgroupfield.trim().split(","):null; 
								if(null != grps && grps.length>0){
									for(int g=0;g<grps.length;g++){
										if(allDrillSortDimMap.get(grps[g].trim()) != null){
											allDrillSortDimMap.remove(grps[g].trim());
										}
									}
								}
								
								StringBuffer sortDimBuf = new StringBuffer();
								if(allDrillSortDimMap.keySet().size()>0){
									for(String key:allDrillSortDimMap.keySet()){
										if(groupfield.endsWith(",")){
											groupfield += "\""+key+"\",";
										}else{
											groupfield += ",\""+key+"\",";
										}
										sortDimBuf.append("\""+key).append("\",");
									}
								}
								if(groupfield.endsWith(",")){
									groupfield = groupfield.substring(0,groupfield.length()-1);
								}
								
								Map<String,String> allDrillSortKpiMapBak = new HashMap<String,String>(allDrillSortKpiMap);
								for(String key:allKpiMap.keySet()){
									if(allDrillSortKpiMap.get(key) != null){
										allDrillSortKpiMap.remove(key);
									}
								}
								
								if(allDrillSortKpiMap.keySet().size()>0){
									for(String key:allDrillSortKpiMap.keySet()){
										if(kpiString.endsWith(",")){
											kpiString += "SUM("+key+") as \""+key+"\",";
										}else{
											kpiString += ",SUM("+key+") as \""+key+"\",";
										}
									}
								}
								
								if(kpiString.endsWith(",")){
									kpiString = kpiString.substring(0,kpiString.length()-1);
								}
								String[] bcss = baseColString.split(",");
								String[] kpicols = kpiString.split(",");
								
								Map<String,String> tmpmapbak = new HashMap<String,String>();
								if(baseColString.length()>0){
									for(int a=0;a<bcss.length;a++){
										tmpmapbak.put(bcss[a], bcss[a]);
									}
								}
								if(kpiString.length()>0){
									for(int a=0;a<kpicols.length;a++){
										tmpmapbak.put(kpicols[a], kpicols[a]);
									}
								}

								String baseColString_kpiString = "";
								for(String key:tmpmapbak.keySet()){
									baseColString_kpiString+=key+",";
								}
								
								if(sortDimBuf.length()>0){
									sortDimBuf.deleteCharAt(sortDimBuf.length()-1);
									sortDimBuf.insert(0,",");
								}
								
								//String subColString = baseColString+subDrillIsField + " "+isField+"," + subDrillTreeField + " "+treeField+","+sortDimBuf.toString()+ kpiString;
								String subColString = baseColString_kpiString+subDrillIsField + " as \""+isField+"\"," + subDrillTreeField + " as \""+treeField+"\""+sortDimBuf.toString();
								if(sortDimBuf.toString().length()>0 && (baseColString+subDrillIsField+",").indexOf(sortDimBuf.toString())>-1){
									subColString = baseColString+subDrillIsField + " "+isField+"," + subDrillTreeField + " "+treeField+","+ kpiString;
								}
								
								StringBuffer subSqlString = new StringBuffer(dbsource.getSql());
								subSqlString.insert(0, " SELECT " + subColString + " FROM (");
								subSqlString.append(") inits").append(groupfield).append(orderString);
								 if(type.equals("2")){
									 DataSetSqlMapSub.put("type",cmcpType);
									 DataSetSqlMapSub.put("desc", datasource.getName()+"数据集");
									 DataSetSqlMapSub.put("sql", dbsource.getSql());
									 DataSetSqlMapSub.put("dataSourceName", datasource.getExtds());
									 DataSetSqlMapSub.put("dimField", subdrill.getDrillcode());
								 }else{
									DataSetSqlMapSub.put("desc", dbsource.getName()+"数据集");
									DataSetSqlMapSub.put("dimField", subdrill.getDrillcode());
									DataSetSqlMapSub.put("type",cmcpType);
									DataSetSqlMapSub.put("sql", subSqlString.toString());
									DataSetSqlMapSub.put("dataSourceName", dbsource.getExtds());
								 }
								DataSetSql.add(DataSetSqlMapSub);
							}
						} else {
							continue;
						}
					}
			}
		}
		return DataSetSql;
	}
	
	private Datasource getDatasource(String reportId,String datasourceId){
		Datasources datasources = report.getDatasources();
		List<Datasource> datasourceList = datasources.getDatasourceList();
		for(Datasource datasource:datasourceList){
			if(datasource != null && datasource.getId().equals(datasourceId)){
				return datasource;
			}else{
				continue;
			}
		}
		return null;
	}

	private String parseFragmentEnd(String sqlStatement, StringBuffer expression) {
		sqlStatement = StringUtils.stripEnd(sqlStatement, null);
		expression.insert(0, sqlStatement.substring(sqlStatement.lastIndexOf(" ") + 1)).insert(0, " ");
		sqlStatement = sqlStatement.substring(0, sqlStatement.lastIndexOf(" "));
		return StringUtils.stripEnd(sqlStatement, null);
	}

	private int isFunctionLeft(String fragment) {
		int i = StringUtils.lastIndexOf(fragment, "(", ")");
		if ((i != -1) && Character.isWhitespace(fragment.charAt(i - 1))) {
			i = -1;
		}
		return i;
	}

	private int isFunctionRight(String fragment) {
		int i = StringUtils.indexOf(fragment, ")", "(");
		return i;
	}
	
	private int isBeginLeft(String fragment) {
		int i = StringUtils.lastIndexOf(fragment.toLowerCase(), "between", "and");
		if ((i != -1) && Character.isWhitespace(fragment.charAt(i - 1))) {
			i = -1;
		}
		return i;
	}
	private int isBeginRight(String fragment) {
		int i = StringUtils.indexOf(fragment, "and", "between");
		return i;
	}
	private String getDimsionVarType (String dimsionvartype,String varName){
		String varType = " | ";
		if(dimsionvartype != null && !dimsionvartype.equals("")&& !dimsionvartype.equals("{}")){
			List<Map> dimsionVarTypeList = (List<Map>)Functions.json2java(""+dimsionvartype+"");
			for(Map dimsionMap : dimsionVarTypeList){
				if(dimsionMap != null && dimsionMap.get("dimname") != null && dimsionMap.get("dimname").equals(varName)){
					varType = "" + dimsionMap.get("dimtype") + "|" + dimsionMap.get("reportId");
					return varType;
				}
			}
		}
		return varType;
	}
	private String getDimsionVarType(String varName){
		List<Dimsion> dims = null;
		if( this.report.getDimsions()!=null){
			dims=this.report.getDimsions().getDimsionList();
		}
		if(dims==null){
			dims=new ArrayList<Dimsion>();
		}
		for (Dimsion dim : dims) {
			if(dim.getConditiontype().equals("1")){//用户自定义条件
				Pattern pattern = Pattern.compile("[\u4e00-\u9fa5]");
			    Matcher matcher = pattern.matcher(dim.getVardesc()); 
			    if(matcher.find()){//中文
					if(dim.getVarname().trim().equalsIgnoreCase(varName.trim())){
						return dim.getType().trim();
					}
			    }else{//英文
					if(dim.getVardesc().trim().equalsIgnoreCase(varName.trim())){
						return dim.getType().trim();
					}
			    }

			}else{//sql中的
				if(dim.getVarname().trim().equalsIgnoreCase(varName.trim())){
					return dim.getType().trim();
				}
			}
		}
		return null;
	}
	public String buildSqlByParam(String sqlStatement,String dimsionvartype,Map<String,String> params) {
		StringBuffer sqlBuffer = new StringBuffer();
		String sql = sqlStatement;

		sql = sql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\\{", "<f>").replaceAll("\\}", "<f>");
		String []sqlStr = sql.split("<f>");
		
		for(int i=0;i<sqlStr.length;i++){
			if (i % 2 != 1) {
				//SQL体				
				sqlBuffer.append(sqlStr[i]);				
			}else{
				//WHERE体
				StringBuffer ifTag = new StringBuffer("");
/*				if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
					ifTag.append("\n").append("      <e:if condition=\"${");
				}else{
					ifTag.append(" 1=1 ").append("\n").append("      <e:if condition=\"${");
				}*/
				String [] b= sqlStr[i].trim().split("#");
				int step = 0;
				boolean uploadstate = false;
				String reportId = "";
				for(int c = 0;c<b.length;c++){
					
					if (c % 2 == 1) {
						step ++;
/*						String varStr =  getDimsionVarType(dimsionvartype, b[c]).toUpperCase().trim();
						String varTypeStr = varStr.substring(0, varStr.indexOf("|"));
						if(varTypeStr != null && varTypeStr.equals("UPLOAD")) {
							uploadstate = true;
							reportId = varStr.substring(varStr.indexOf("|")+1,varStr.length());
						}*/
						//System.out.println(uploadstate+"=!!!!!!!!"+reportId);
						String v = params.get(b[c]);
						if(v != null && v != "" && !v.trim().equals("null") && !v.trim().equals("undefined") && !v.trim().equals("") && !v.trim().equals("-1")){
							if(b.length == 3 && b[2].trim().equals(")")){
								ifTag.append(" "+b[0]+"#"+b[c]+"#"+")");
							}else{
								ifTag.append(" "+b[0]+"#"+b[c]+"# ");
							}
							
						}else{
							//20160520增加查询条件默认值
							//continue;
							String dv = this.dimDefaultValue(b[c].trim(),"2");
							if(null != dv){
								if(!dv.equalsIgnoreCase("NO_PIN_JIE_ME")){
									ifTag.append(" "+b[0]+dv+" ");
								}
								if(b.length>2 && "" != b[2]){
									ifTag.append(b[2]).append(" ");
								}
							}
						}
/*						ifTag.append("(");
						ifTag.append("(");
						ifTag.append("(param.").append(b[c]).append(" != null)");
						ifTag.append("&&");
						ifTag.append("(e:trim(param.").append(b[c]).append(") != '')");
						ifTag.append("&&");
						ifTag.append("(param.").append(b[c]).append(" != 'null')");
						ifTag.append(")");
						ifTag.append("||");
						ifTag.append("(");
						ifTag.append("(").append(b[c]).append(" != null)");
						ifTag.append("&&");
						ifTag.append("(e:trim(").append(b[c]).append(") != '')");
						ifTag.append("&&");
						ifTag.append("(").append(b[c]).append(" != 'null')");
						ifTag.append(")");
						ifTag.append(")");
						if(c!=b.length-2&&c!=b.length-1){
							ifTag.append("&&");
						}*/
					}
					sqlBuffer.append(ifTag.toString());
				}
			}
		}
		return sqlBuffer.toString();
	}
	private String transformSql(String sqlStatement,String dimsionvartype,String dataSourceName) {
		String existsKey = " exists ";
		String dsname = CommonTools.getDataSource(dataSourceName).getDataSourceDB();
		if(null != dsname && "" != dsname && dsname.length()>0 && dsname.equalsIgnoreCase("xcloud")){
			existsKey = " in ";
		}
		StringBuffer sqlBuffer = new StringBuffer();
		String sql = sqlStatement;
		
		sql = sql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\\{", "<f>").replaceAll("\\}", "<f>");
		String []sqlStr = sql.split("<f>");
		
		for(int i=0;i<sqlStr.length;i++){
			
			if (i % 2 != 1) {
				//SQL体				
				sqlBuffer.append(sqlStr[i]);				
			}else{
				//WHERE体
				StringBuffer ifTag = new StringBuffer("");
				if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
					ifTag.append("\n").append("      <e:if condition=\"${");
				}else{
					ifTag.append(" 1=1 ").append("\n").append("      <e:if condition=\"${");
				}
				String [] b= sqlStr[i].trim().split("#");
				int step = 0;
				boolean uploadstate = false;
				String reportId = "";
				for(int c = 0;c<b.length;c++){
					
					if (c % 2 == 1) {
						step ++;
						String dimtype =  getDimsionVarType(b[c]);
						if(null != dimtype && dimtype.trim().equalsIgnoreCase("upload")) {
							uploadstate = true;
							reportId = this.report.getId();
						}
						//System.out.println(uploadstate+"=!!!!!!!!"+reportId);
						ifTag.append("(");
						ifTag.append("(");
						ifTag.append("(param.").append(b[c]).append(" != null)");
						ifTag.append("&&");
						ifTag.append("(e:trim(param.").append(b[c]).append(") != '')");
						ifTag.append("&&");
						ifTag.append("(param.").append(b[c]).append(" != 'null')");
						ifTag.append(")");
						ifTag.append("||");
						ifTag.append("(");
						ifTag.append("(").append(b[c]).append(" != null)");
						ifTag.append("&&");
						ifTag.append("(e:trim(").append(b[c]).append(") != '')");
						ifTag.append("&&");
						ifTag.append("(").append(b[c]).append(" != 'null')");
						ifTag.append(")");
						ifTag.append(")");
						if(c!=b.length-2&&c!=b.length-1){
							ifTag.append("&&");
						}
					}
				}				
				if(step ==0)
					ifTag.append("true");
				ifTag.append("}\" var=\"elsev"+i+"\">").append("\n");
				String[] exitStrTemp = sqlStr[i].split("#");
				if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
					if(existsKey.equals(" exists ")){
						if(uploadstate){
							String varString = "";
							//暂时处理字段带 sql 关键字问题
							varString = " "+exitStrTemp[0]+"";
							varString = varString.toUpperCase().replaceAll(" OR ", "").replaceAll(" AND ", "").replaceAll("=", " ");
							ifTag.append("        "+sqlStr[i].trim().substring(0, 3)).append(existsKey+"(SELECT a.DATA_CON UUCOLDV FROM x_report_upload_data a WHERE a.log_id = #"+exitStrTemp[1].trim()+"# and a.DATA_CON = ").append(varString).append(")").append("\n");					
						}else{									
							if(exitStrTemp[0].replaceAll(" ", "").toUpperCase().indexOf("IN(")>0&&exitStrTemp.length==3){
								ifTag.append("<e:if condition=\"${("+exitStrTemp[1]+" != null)&&("+exitStrTemp[1]+" != '')&&(area_no != 'null')}\">");							
								ifTag.append("        "+exitStrTemp[0]+"'${"+exitStrTemp[1]+"}'"+exitStrTemp[2]).append("\n");							
								ifTag.append("</e:if>");
							}else{							
								ifTag.append("        "+sqlStr[i]).append("\n");
							}
						}
					}else{
						String varString1 = exitStrTemp[0].toUpperCase().trim().replaceAll("=", " ");
						String varString = "";
						varString = varString1.replaceAll(" OR", "").replaceAll("AND", "");
						if(uploadstate){
							ifTag.append("        "+varString1).append(" in ").append("(SELECT a.DATA_CON UUCOLDV FROM x_report_upload_data a WHERE a.log_id = #"+exitStrTemp[1].trim()+"# ").append(")").append("\n");					
						}else{						
							if(exitStrTemp[0].replaceAll(" ", "").toUpperCase().indexOf("IN(")>0&&exitStrTemp.length==3){
								ifTag.append("<e:if condition=\"${("+exitStrTemp[1]+" != null)&&("+exitStrTemp[1]+" != '')&&(area_no != 'null')}\">");							
								ifTag.append("        "+exitStrTemp[0]+"'${"+exitStrTemp[1]+"}'"+exitStrTemp[2]).append("\n");							
								ifTag.append("</e:if>");
							}else{							
								ifTag.append("        "+sqlStr[i]).append("\n");
							}
						}
					}
				}else{
					if(uploadstate){
						ifTag.append("        and"+existsKey+"(SELECT a.DATA_CON UUCOLDV FROM x_report_upload_data a WHERE a.log_id = #"+exitStrTemp[1].trim()+"# and a.DATA_CON = ").append(sqlStr[i].trim().replaceAll("=", " ")).append(")").append("\n");
					}else{
						ifTag.append("        and "+sqlStr[i]).append("\n");
					}
				}
				ifTag.append("      </e:if>").append("\n      ");
				
				//20160519增加默认值
				String[] names = sqlStr[i].split("#");
				String dv = this.dimDefaultValue(names[1],"1");
				if(null != dv){
					ifTag.append("<e:else condition=\"${elsev"+i+"}\">");
					String condtype = "<e:if condition=\"${param.condtype ne '1'}\" var=\"cond_if\">";
					ifTag.append(condtype);
					
					String tmpEif= "";
					if(dv.startsWith("'${sessionScope")){
						//160822判断session里的值是否为空
						String dvNew = dv.replaceAll("'","").replace("${", "").replace("}","");
						dvNew = "<e:if condition=\"${sessionScope."+ names[1] +" != null && sessionScope."+names[1]+" ne ''}\">"+names[0]+dv;
						dv = dvNew;
						tmpEif= "</e:if>";
					}else{
						dv = names[0]+dv;
					}
					
					ifTag.append(dv);
					condtype = "</e:if>"+tmpEif;
					if(names.length>2 && "" != names[2]){
						ifTag.append(names[2]).append(condtype);
					}else{
						ifTag.append(condtype);
					}
					ifTag.append("</e:else>");
				}
				sqlBuffer.append(ifTag.toString());
			}
		}
		return sqlBuffer.toString();
	}
	private String dimDefaultValue(String name,String type){
		HttpServletRequest request = EasyContext.getContext().getRequest();
		Dimsions dimsions = this.report.getDimsions();
		List<Dimsion> dims = null != dimsions?dimsions.getDimsionList():null;
		if(null == dims || dims.size()<=0){
			return null;
		}
		for(int a=0;a<dims.size();a++){
			Dimsion dim = dims.get(a);
			String dv = dim.getDefaultvalue();
			
			//中文字段
			String varName = dim.getVarname();
			Pattern pattern = Pattern.compile("[\u4e00-\u9fa5]");
			if(null!=dim.getConditiontype() && "1".equals(dim.getConditiontype())){
				Matcher matcher = pattern.matcher(dim.getVardesc()); 
				if(!matcher.find()){
					varName = dim.getVardesc();
				}
			}
			
			
			if(varName.equals(name) && null != dv && "" != dv && !dv.trim().equals("")){
				dv = dv.trim();
				if(dim.getDefaultValueType().equals("2")){
					if(type.equals("2")){
						String namev = this.isNull(request.getSession().getAttribute(dv));
						if(namev.equals("")){
							return "NO_PIN_JIE_ME";
						}
						return "#"+dv+"#";
					}else{
						return "'${sessionScope."+dv+"}'";
					}
				}else{
					if(dv.indexOf(",")>-1){
						dv = dv.replaceAll(",","','");
					}
					return "'"+dv+"'";
				}
			}
		}
		return null;
	}
	
	private String isNull(Object v){
		String namev = String.valueOf(v);
		if(null == namev || "NULL".equals(namev.toUpperCase().trim()) || "UNDEFINED".equals(namev.toUpperCase().trim()) || namev.trim().length()<=0){
			return "";
		}
		return namev.trim();
	}
	@SuppressWarnings("unused")
	private String transformSqlForDim(String dimSqlStatement) {
		StringBuffer sqlBuffer = new StringBuffer();
		String sql = dimSqlStatement;
		sql = sql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\\{", "<f>").replaceAll("\\}", "<f>");
		String []sqlStr = sql.split("<f>");
		for(int i=0;i<sqlStr.length;i++){
			if (i % 2 != 1) {
				//SQL体
				sqlBuffer.append(sqlStr[i]);
			}else{
				//WHERE体
				StringBuffer ifTagSessionScope = new StringBuffer("");//sessionScope
				if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
					ifTagSessionScope.append("\n").append("      <e:if condition=\"${");
				}else{
					ifTagSessionScope.append(" 1=1 ").append("\n").append("      <e:if condition=\"${");
				}
				String [] b= sqlStr[i].trim().split("#");
				int step = 0;
				for(int c = 0;c<b.length;c++){
					if (c % 2 == 1) {
						step ++;

						ifTagSessionScope.append("(");
						ifTagSessionScope.append("(");
						ifTagSessionScope.append("(sessionScope.").append(b[c]).append(" != null)");
						ifTagSessionScope.append("&&");
						ifTagSessionScope.append("(sessionScope.").append(b[c]).append(" != '')");
						ifTagSessionScope.append("&&");
						ifTagSessionScope.append("(sessionScope.").append(b[c]).append(" != 'null')");
						if(b[c].toUpperCase().equals("CITY_NO")||b[c].toUpperCase().equals("AREA_NO")){
							ifTagSessionScope.append("&&");
							ifTagSessionScope.append("(sessionScope.").append(b[c]).append(" != '-1')");
						}
						ifTagSessionScope.append(")");
						ifTagSessionScope.append(")");
						if(c!=b.length-2&&c!=b.length-1){
							ifTagSessionScope.append("&&");
						}
					}
				}
				if(step ==0){
					ifTagSessionScope.append("true");
				}
				ifTagSessionScope.append("}\">").append("\n");
				if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
					ifTagSessionScope.append("        "+b[0]+"'${sessionScope."+b[1]).append("}'\n");
				}else{
					ifTagSessionScope.append("        and "+b[0]+"'${sessionScope."+b[1]).append("}'\n");
				}
				ifTagSessionScope.append("      </e:if>").append("\n      ");
				sqlBuffer.append(ifTagSessionScope.toString());
			}
		}
		return sqlBuffer.toString();
	}
	/**
	 * 
	 * @param sqlStatement
	 * @return 返回字段 与 变量  如;  and area_no = #area#  map.get("col") = " and area_no = "; map.get("var") = "area"
	 */
	@SuppressWarnings("unused")
	private List<Map> transformSqlVar(String sqlStatement) {
		List<Map> transList = new ArrayList<Map>();
		StringBuffer sqlBuffer = new StringBuffer("");
		String sql = sqlStatement;
		sql = sql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\\{", "<f>").replaceAll("\\}", "<f>");
		String []sqlStr = sql.split("<f>");
		if(sqlStr.length <=1 || sql.indexOf("#") == -1){
			Map varTem = new HashMap();
			varTem.put("sql", sqlStatement);
			transList.add(varTem);
		}
		for(int i=0;i<sqlStr.length;i++){
			Map varTem = new HashMap();
			if (i % 2 != 1) {
				//SQL体
				sqlBuffer.append(sqlStr[i]);
			}else{
				//WHERE体
				StringBuffer ifTag = new StringBuffer("");
				if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
					ifTag.append("\n").append("  ");
				}else{
					ifTag.append(" 1=1 ").append(" ");
				}
				String [] b= sqlStr[i].trim().split("#");
				int step = 0;
				if(b.length >= 2){
					if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
						varTem.put("col", b[0]);
						varTem.put("var", b[1]);
					}else{
						varTem.put("col", " and "+b[0]);
						varTem.put("var", b[1]);
					}
				}
				sqlBuffer.append(ifTag.toString());
				varTem.put("sql", sqlBuffer.toString());
				transList.add(varTem);
			}
		}
		return transList;
	}
	@SuppressWarnings("unchecked")
	public String transformSqlParamURI(List<Map<String, String>> ResultSets) {
		String paramUrlCode = "";
		for (Map<String, String> ResultSet : ResultSets) {
			String[] sqlArray = formatSql(ResultSet.get("sql")).split("#");
			int sqlArrayLength = sqlArray.length;
			for (int i = 1; i <= sqlArrayLength; i++) {
				if (i % 2 != 1) {
					paramUrlCode += sqlArray[i - 1]+"#";
				}
			}
		}
		XTranscode xtc = new XTranscode(this.report,this.isaction);
		StringBuffer SqlParamURI = xtc.compTc(paramUrlCode);
		return SqlParamURI.toString();
	}
	private String formatSql(String sqlStatement) {
		sqlStatement = sqlStatement.replaceAll(">=", " &ge ");
		sqlStatement = sqlStatement.replaceAll("<=", " &le ");
		sqlStatement = sqlStatement.replaceAll("<>", " &ne ");
		sqlStatement = sqlStatement.replaceAll("!=", " &ne ");
		sqlStatement = sqlStatement.replaceAll("=", " = ");
		sqlStatement = sqlStatement.replaceAll(">", " > ");
		sqlStatement = sqlStatement.replaceAll("<", " < ");
		return sqlStatement;
	}

	private String formatToSql(String sqlStatement) {
		sqlStatement = sqlStatement.replaceAll("&ge",">=");
		sqlStatement = sqlStatement.replaceAll("&le","<=");
		sqlStatement = sqlStatement.replaceAll("&ne","<>");
		sqlStatement = sqlStatement.replaceAll("&ne","!=");
		return sqlStatement;
	}
	private String sqlSort(){
		StringBuffer sourceCode = new StringBuffer(); 
		sourceCode.append("<e:if condition=\"${param.sort!=null&&param.sort!=''&&param.sort!='null'&&param.sort!='undefined'}\">").append("\n");
		sourceCode.append("        ORDER BY nvl(\"${param.sort }\",0) ");
		sourceCode.append("		 <e:if condition=\"${param.order!=null&&param.order!=''&&param.order!='null'&&param.order!='undefined'}\">");
		sourceCode.append("  ${param.order } ").append("</e:if>\n");
		sourceCode.append("      </e:if>").append("\n");
      return sourceCode.toString();
	}
	private String build() {
		String ltype = this.report.getInfo().getLtype();
		List<Map<String, String>> ResultSets = this.getReportDataSet();
		String dimsionvartype = "{}";
		StringBuffer sourceCode = new StringBuffer();
		sourceCode.append("<%@ page language=\"java\" pageEncoding=\"UTF-8\"%>").append("\n");
		sourceCode.append("<%@page import=\"cn.com.easy.ebuilder.parser.CommonTools\"%>").append("\n");
		sourceCode.append("<%@ taglib prefix=\"e\" uri=\"http://www.bonc.com.cn/easy/taglib/e\"%>").append("\n");
		sourceCode.append("<%@ taglib prefix=\"m\" uri=\"http://www.bonc.com.cn/easy/taglib/m\" %>").append("\n");
		sourceCode.append("<%@ taglib prefix=\"c\" uri=\"http://www.bonc.com.cn/easy/taglib/c\"%>").append("\n");
		sourceCode.append(transformSqlParamURI(ResultSets)).append("\n");
		sourceCode.append("<e:switch value=\"${param.eaction}\">").append("\n");
		for (Map<String, String> ResultSet : ResultSets) {
			sourceCode.append("  ").append("<e:case value=\"").append(ResultSet.get("id")).append("\">").append("\n");
			sourceCode.append("    ").append("<e:description>").append(ResultSet.get("desc")).append("</e:description>").append("\n");
			if (ResultSet.get("type").equals("datagrid")) {
				String lableStart = ltype.equals("1")?"<c:tablequery ":"<e:q4l  var=\"L\" ";
				String lableEnd = ltype.equals("1")?"</c:tablequery>":"</e:q4l>";
				sourceCode.append("    ").append(lableStart).append(getExtDsStr(ResultSet.get("dataSourceName"))).append(" >").append("\n");
				sourceCode.append("      ").append(transformSql(ResultSet.get("sql"),dimsionvartype,(String)ResultSet.get("dataSourceName"))).append("\n");
				//表格加一个后台排序的功能 MBUILER 先去掉
				//sourceCode.append("      ").append(sqlSort()).append("\n");
				sourceCode.append("    ").append(lableEnd).append("\n");
				if(ltype.equals("2")){
					sourceCode.append("${e:java2json(L.list)}").append("\n");
				}
			} else if (ResultSet.get("type").equals("treegrid")) {
				String lableStart = ltype.equals("1")?"<c:treegridquery ":"<m:treegridquery ";
				String lableEnd = ltype.equals("1")?"</c:treegridquery>":"</m:treegridquery>";
				sourceCode.append("    ").append(lableStart).append(getExtDsStr(ResultSet.get("dataSourceName"))).append(" dimField=\"").append(ResultSet.get("dimField")).append("\">").append("\n");
				sourceCode.append("      ").append(transformSql(ResultSet.get("sql"),dimsionvartype,(String)ResultSet.get("dataSourceName"))).append("\n");
				sourceCode.append("    ").append(lableEnd).append("\n");
			} else if (ResultSet.get("type").equals("chart")) {
				sourceCode.append("    ").append("<e:q4l var=\"L").append(ResultSet.get("id")+"\"").append(getExtDsStr(ResultSet.get("dataSourceName"))).append(" >").append("\n");
				sourceCode.append("      ").append(transformSql(ResultSet.get("sql"),dimsionvartype,(String)ResultSet.get("dataSourceName"))).append("\n");
				sourceCode.append("    ").append("</e:q4l>").append("${e:java2json(").append("L"+ResultSet.get("id")).append(".list)}").append("\n");
			}
			sourceCode.append("  ").append("</e:case>").append("\n");
		}
		sourceCode.append("</e:switch>").append("\n");
		return sourceCode.toString();
	}
	public String getCompSql(String compid){
		String dimsionvartype = "{}";
		String ltype = this.report.getInfo().getLtype();
		List<Map<String, String>> ResultSets = this.getReportDataSet();
		String sql = "";
		for (Map<String, String> ResultSet : ResultSets) {
			if (ResultSet.get("id").equals(compid)) {
			String dataSourceName = getExtDsStr(ResultSet.get("dataSourceName"));
			sql = transformSql(ResultSet.get("sql"),dimsionvartype,(String)ResultSet.get("dataSourceName"));
			}
		}
		return sql;
	}
	
	private String getExtDsStr(String dataSourceName){
		String getExtDsStr = "";
			if (dataSourceName != null && !dataSourceName.equals("")
				&& !dataSourceName.trim().equals("")
				&& !dataSourceName.trim().toUpperCase().equals("NULL"))
				getExtDsStr = " extds = \""+dataSourceName+"\"";
		return getExtDsStr;
	}
	private String getStringValue(String string) {
		if (string != null && !string.equals("")
				&& !string.toLowerCase().equals("undefined")
				&& !string.toLowerCase().equals("null")) {
			return string.trim();
		} else {
			return "";
		}
	}
	// 工具方法，处理多余的逗号
	private String getCompKind(String name){
		String[] pies = {"pie","ring"};
		String[] lines = {"line","line2","line3"};
		String[] bars = {"bar","bar2","bar3"};
		String[] columns = {"column","column2","column3"};
		String[] columnline = {"columnline","columnline2","columnline3"};
		String[] scatters = {"scatter"};
		String kind = ArrayUtils.contains(pies, name)?"pie":ArrayUtils.contains(lines, name)?"line":ArrayUtils.contains(columns, name)?"column":ArrayUtils.contains(columnline, name)?"columnline":ArrayUtils.contains(bars, name)?"bar":ArrayUtils.contains(scatters, name)?"scatter":name;
		return kind;
	}
}