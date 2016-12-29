package cn.com.easy.xbuilder.kpi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import cn.com.easy.util.StringUtils;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Crosscol;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Datastore;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Kpi;
import cn.com.easy.xbuilder.element.Kpistore;
import cn.com.easy.xbuilder.element.KpistoreCol;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Sortcol;
import cn.com.easy.xbuilder.element.Subdirllsortcol;
import cn.com.easy.xbuilder.element.Subdrill;
import cn.com.easy.xbuilder.element.XAxis;
import cn.com.easy.xbuilder.service.XBaseService;

public class XDataSourceSql extends XBaseService {
	private Report report;
	private String contId;
	private String compid;
	private String SUCCESS = "success"; 
	private List<String> dims = null;
	private List<Map<String,String>> kpis = null;
	private List<Map<String,String>> wheres = null;
	private List<Map<String,String>> orders = null;
	private Map<String,String> alias = null;
	private Map<String,String> kpiStores= null;
	
	public XDataSourceSql(Report report) {
		this.report  = report;
	}
	public Report setAllSql() throws Exception{
		try {
			if(report.getContainers() != null && report.getContainers().getContainerList() != null) {
				for(Container container: report.getContainers().getContainerList()) {
					if(container.getComponents()!= null && container.getComponents().getComponentList()!= null) {
						for (Component component : container.getComponents().getComponentList()) {
							this.contId = container.getId();
							this.compid = component.getId();
							dims = new LinkedList<String>();
							kpis = new LinkedList<Map<String,String>>();
							wheres = new LinkedList<Map<String,String>>();
							orders = new LinkedList<Map<String,String>>();
							kpiStores = new LinkedHashMap<String,String>();
							alias = new HashMap<String,String>();
							if("treegrid".equals(component.getType().toLowerCase())) {
								setDrillSql(null);//修改全部下钻表格的查询条件
							} else {
								setSql();
							}
						}
					}
				}
			}
		} catch(Exception e) {
			throw new Exception(e);
		}
		return report;
	}
	public XDataSourceSql(Report report, String contId,String compid) {
		this.report = report;
		this.contId = contId;
		this.compid = compid;
		dims = new LinkedList<String>();
		kpis = new LinkedList<Map<String,String>>();
		wheres = new LinkedList<Map<String,String>>();
		orders = new LinkedList<Map<String,String>>();
		kpiStores = new LinkedHashMap<String,String>();
		alias = new HashMap<String,String>();
	}
	
	public Report setDrillSql(String drillid) throws InstantiationException, IllegalAccessException, ClassNotFoundException{
		parseKpiStores();
		createSqlElement();
		parseQueryTerms();
		Component component = getCurrComponent();
		addSubDrillWhere(component);
		if (kpis.size() > 0
				&& (dims.size() > 0 || (component.getSubdrills() != null && component
						.getSubdrills().getSubdrillList().size() > 0))) {
			alias.put("code", component.getIdfield());
			alias.put("name", component.getTreefield());
			KpiInterface kpi = KpiFactory.getCls();
			if(drillid != null && !"".equals(drillid)) {
				alias.put("id", drillid);
				addSubDrillDim(component, drillid);
				Map<String ,String> sql = kpi.getSql(dims, kpis, wheres, orders,alias,this.report,component);
				if(this.SUCCESS.equals(sql.get("result"))) {
					addCurrDataSource(sql.get("content"),sql.get("datasource"));
					addCurrSubdrillDataSource(sql.get("content"),drillid,sql.get("datasource"));
					saveToXml(this.report);
				} else {
					throw new InstantiationException(sql.get("content"));
				}
			} else {
				List<Subdrill> subdrillList = component.getSubdrills().getSubdrillList();
				if(subdrillList != null && subdrillList.size() > 0) {
					for(Subdrill subdrill : subdrillList) {
						alias.put("id", subdrill.getDrillcolcodeid());
						addSubDrillDim(component, subdrill.getDrillcolcodeid());
						Map<String ,String> sql = kpi.getSql(dims, kpis, wheres, orders,alias,this.report,component);
						//dims.remove(subdrill.getDrillcolcodeid());
						if(this.SUCCESS.equals(sql.get("result"))) {
							addCurrDataSource(sql.get("content"),sql.get("datasource"));
							addCurrSubdrillDataSource(sql.get("content"),subdrill.getDrillcolcodeid(),sql.get("datasource"));
							saveToXml(this.report);
						} else {
							throw new InstantiationException(sql.get("content"));
						}
					}
				}  
			}
		}
		return report;
	}
	public Report setSql() throws InstantiationException, IllegalAccessException, ClassNotFoundException{
		parseKpiStores();
		createSqlElement();
		parseQueryTerms();
		Component component = getCurrComponent();
		boolean flag = false;
		if ("DATAGRID".equals(component.getType())) {
			if (!"1".equals(component.getTablesetsum())) {
				flag = true;
 			} else {
 				if(dims.size() > 0 && kpis.size() > 0) {
 					flag = true;
 				}
 			}
		} else {
			if(dims.size() > 0 && kpis.size() > 0) {
				flag = true;
			}
		}
		if(flag) {
			KpiInterface kpi = KpiFactory.getCls();
			Map<String ,String> sql = kpi.getSql(dims, kpis, wheres, orders,alias,this.report,component);
			if(this.SUCCESS.equals(sql.get("result"))) {
				addCurrDataSource(sql.get("content"),sql.get("datasource"));
				saveToXml(this.report);
			} else {
				throw new InstantiationException(sql.get("content"));
			}
		}
		return report;
	}
	protected void createSqlElement() {
		Component component = getCurrComponent();
		if(component != null) {
			if("datagrid".equals(component.getType().toLowerCase())) {
				parseDataGrid(component);
			} else if("treegrid".equals(component.getType().toLowerCase())) {
				parseTreeGrid(component);
			} else if("crosstable".equals(component.getType().toLowerCase())) {
				parseCrossTable(component);
			} else {
				parseChart(component);
			}
		}
	}
	/**
	 * 交叉表格
	 * @param component
	 */
	protected void parseCrossTable(Component component) {
		parseDataGrid(component);
		List<Crosscol> crosscolList = component.getCrosscolstore().getCrosscolList();
		if(crosscolList != null && crosscolList.size() > 0) {
			for(Crosscol crosscol : crosscolList) {
				addDims(crosscol.getDimid());
			}
		}
	}
	/**
	 *  下钻表格
	 * @param component
	 */
	protected void parseTreeGrid(Component component) {
		parseDataGrid(component);
	}

	protected void addSubDrillDim(Component component,String subdillid) {
		List<Datacol> datacolList=null;
		Datastore datastore=component.getDatastore();
		if(datastore!=null){
			datacolList=datastore.getDatacolList();
		}
		if(datacolList==null){
			datacolList=new ArrayList<Datacol>();
		}
		boolean datacolExistFlag=false;
		List<Subdrill> subdrillList = component.getSubdrills().getSubdrillList();
		if(subdrillList != null && subdrillList.size() >0) {
			for (Subdrill subdrill : subdrillList) {
				if(subdillid.equals(subdrill.getDrillcolcodeid())) {
					addDims(subdrill.getDrillcolcodeid());
					if(null != subdrill.getSubdirllsortcols()){
						List<Subdirllsortcol> subdirllsortcol = subdrill.getSubdirllsortcols().getSubdirllsortcolList();
						if(!subdirllsortcol.isEmpty()){
							for(Subdirllsortcol subdirll:subdirllsortcol){
								if(!subdirll.getColcode().isEmpty()){
									Map<String,String> order = new HashMap<String,String>();
									order.put("id", subdirll.getColcode());
									order.put("ord", subdirll.getSorttype());
									for(Datacol tempDatacol:datacolList){
										if(tempDatacol.getDatacolid().equals(subdirll.getColcode())){
											datacolExistFlag=true;
											order.put("type", tempDatacol.getDatacoltype());
										}
									}
									if(!datacolExistFlag){
										order.put("type", "dim");
									}
									addOrders(order);
								}
							}
						}
					}
					break;
				}
			}
		}
	}
	protected void addSubDrillWhere(Component component) {
		List<Subdrill> subdrillList = component.getSubdrills().getSubdrillList();
		if(subdrillList != null && subdrillList.size() >0) {
			for (Subdrill subdrill : subdrillList) {
				Map<String,String> where = new HashMap<String,String>();
				where.put("id", subdrill.getDrillcolcodeid());
				where.put("formula", "05"); //默认等号
				where.put("type", kpiStores.get(subdrill.getDrillcolcodeid()));
				where.put("varname", subdrill.getDrillcode());
				where.put("varnametype", "INPUT");
				addWheres(where);
			}
		}
	}
	/**
	 * 基础表格
	 * @param component
	 */
	protected void parseDataGrid(Component component) {
//		Map<String,String> where = new HashMap<String,String>();
		//排序
		if(component.getSortcolStore() != null) {
			List<Sortcol> sortcolList = component.getSortcolStore().getSortcolList();
			if(sortcolList  != null && sortcolList.size() > 0) {
				for(Sortcol sortcol: sortcolList) {
					Map<String,String> order = new HashMap<String,String>();
					Map<String,String> kpi = new HashMap<String,String>();
					order.put("id", sortcol.getId());
					order.put("ord", sortcol.getType());
					if(kpiStores.containsKey(sortcol.getId())) {
						order.put("type", kpiStores.get(sortcol.getId()));
					} else {
						order.put("type", sortcol.getKpitype());
					}
					order.put("col", sortcol.getCol());
					addOrders(order);
					if(sortcol.getCol().startsWith("BK_")||sortcol.getCol().startsWith("FK_")) {
						kpi.put("COLUMN_ID", sortcol.getId());
						kpi.put("COLUMN_CODE", sortcol.getCol());
						addKpis(kpi);
					} else {
						addDims(sortcol.getId());
					}
					
				}
			}
		}
		if(component.getDatastore() != null) {
			List<Datacol> dataColList = component.getDatastore().getDatacolList();
			for (Datacol datacol: dataColList) {
				Map<String,String> kpi = new HashMap<String,String>();
				if(datacol.getDatacolcode().startsWith("BK_")||datacol.getDatacolcode().startsWith("FK_")) {
					kpi.put("COLUMN_ID", datacol.getDatacolid());
					kpi.put("COLUMN_CODE", datacol.getDatacolcode());
					addKpis(kpi);
				} else {
					addDims(datacol.getDatacolid());
				}
			}
		}
//		addWheres(where);
	}
	protected void parseChart(Component component) {
		Map<String,String> order = new HashMap<String,String>();
		XAxis xaxis = component.getXaxis();
		if(null!=xaxis){
			if(StringUtils.isNotEmpty(kpiStores.get(xaxis.getSortFiledId()))){
				if("kpi".equals(kpiStores.get(xaxis.getSortFiledId()))){
					if(xaxis.getSortfield().startsWith("FK_")) {
//						order.put("id", xaxis.getSortfield());
						order.put("id", xaxis.getSortFiledId());//最新版指标库的支持
					} else {
						order.put("id", xaxis.getSortFiledId());
					}
					order.put("col", xaxis.getSortfield());
				} else {
					order.put("id", xaxis.getSortFiledId());
				}
			}
			order.put("ord", xaxis.getSortType());
			order.put("type", kpiStores.get(xaxis.getSortFiledId()));
			addOrders(order);
			addDims(xaxis.getSortFiledId());
			addDims(xaxis.getDimFiledId());
			List<Kpi> kpiList = component.getKpiList();
			if(kpiList!=null){
				for(Kpi kpi : kpiList) {
					Map<String,String> map = new HashMap<String,String>();
					map.put("COLUMN_ID", kpi.getKpiId());
					map.put("COLUMN_CODE", kpi.getField());
					addKpis(map);
				}
			}
		}
	}
	/**
	 * 解析查询条件
	 */
	protected void parseQueryTerms() {
		if(null !=report.getDimsions()){
			List <Dimsion> dimsions = report.getDimsions().getDimsionList();
			for(Dimsion dimsion :dimsions) {
				Map<String,String> where = new HashMap<String,String>();
				where.put("id", dimsion.getFieldid());
				where.put("formula", dimsion.getFormula());
				where.put("type", dimsion.getFieldtype());
				where.put("varname", dimsion.getVarname());
				where.put("varnametype", dimsion.getType());
				where.put("multiple", dimsion.getIsselectm());
				addWheres(where);
				if(dimsion.getFieldid().startsWith("FK_")) {
					Map<String,String> map = new HashMap<String,String>();
					map.put("COLUMN_ID", dimsion.getFieldid());
					map.put("COLUMN_CODE", dimsion.getVarname());
					addKpis(map);
				}
			}
		}
	}
	protected Container getCurrContainer() {
		if(contId == null || "".equals(contId)) 
			return null;
		List<Container> containers = this.report.getContainers().getContainerList();
		for(Container container: containers) {
			if(contId.equals(container.getId())) {
				return container;
			}
		}
		return null;
	}
	
	protected Component getCurrComponent() {
		if(compid == null || "".equals(compid))
			return null;
		if(getCurrContainer() != null) {
			List<Component> components = getCurrContainer().getComponents().getComponentList();
			for (Component component : components) {
				if(compid.equals(component.getId())) {
					return component;
				}
			}
		}
		return null;
	}
	/**
	 * 获取当前的subdrill
	 * @param subdrillId
	 * @return
	 */
	protected Subdrill getCurrSubdrill(String subdrillId) {
		List<Subdrill> subdrillList = null;
		if(getCurrComponent() != null) {
			subdrillList = getCurrComponent().getSubdrills().getSubdrillList();
			if(subdrillList != null && subdrillList.size() > 0) {
				for(Subdrill subdrill : subdrillList) {
					if(subdrillId.equals(subdrill.getDrillcolcodeid())) {
						return subdrill;
					}
				}
			}  
		} 
		return null;
	}
	/**
	 * 获取当前subdrill的datasource
	 * @param sqlText
	 * @param subdrillId
	 */
	protected void addCurrSubdrillDataSource(String sqlText,String subdrillId,String data_source) {
		if(getCurrContainer() != null) {
			List<Datasource> datasources = this.report.getDatasources().getDatasourceList();
			Subdrill subdrill = getCurrSubdrill(subdrillId);
			if(subdrill != null) {
				boolean flag = false;
				for(Datasource datasource : datasources) {
					if(subdrill.getDatasourceid().equals(datasource.getId())) {
						flag = true;
						datasource.setExtds(data_source);
						datasource.setSql(sqlText);
						break;
					}
				}
				if(!flag) { //如果当前subdrill下没有datasource
					Datasource datasource = new Datasource();
					datasource.setId(subdrill.getDatasourceid());
					datasource.setExtds(data_source);
					datasource.setSql(sqlText);
					this.report.getDatasources().getDatasourceList().add(datasource);
				}
			}
		}
	}
	
	protected void addCurrDataSource(String sqlText,String ext_ds) {
		if(getCurrContainer() != null) {
			List<Datasource> datasources = this.report.getDatasources().getDatasourceList();
			for(Datasource datasource : datasources) {
				if(getCurrComponent() != null) {
					if(getCurrComponent().getDatasourceid().equals(datasource.getId())) {
						datasource.setExtds(ext_ds);
						datasource.setSql(sqlText);
						break;
					}
				}
			}
		}
	}
	
	protected void addDims(String dim) {
		if(dim != null && !"".equals(dim) && ! this.dims.contains(dim)){
			if(dims.size() > 0 ) {
				this.dims.add(dims.size(),dim);
			} else {
				this.dims.add(0,dim);
			}
		}
	}
	
	protected void addKpis(Map<String,String> kpi) {
		if(!this.kpis.contains(kpi)){
			if(kpis.size() > 0) {
				this.kpis.add(kpis.size(),kpi);
			} else {
				this.kpis.add(0,kpi);
			}
		}
	}
	
	protected void addWheres(Map<String,String> map) { 
		if(this.wheres.size() > 0) {
			boolean flag = false;
			for(Map<String,String> whereMap : this.wheres) {
				if(whereMap.get("id").equals(map.get("id"))) {
					flag = true;
					break;
				}
			}
			if(!flag) {
				this.wheres.add(wheres.size(),map);
			}
		}
		else
			this.wheres.add(0,map);
		
	}
	
	protected void addOrders(Map<String, String> map) {
		if(orders.size() > 0) {
			this.orders.add(orders.size(),map);
		} else {
			this.orders.add(0,map);
		}
		
	}
	
	protected void parseKpiStores() {
		List<Kpistore> kpistores = report.getKpistores().getKpistoreList();
		if(!kpistores.isEmpty()){
			for(Kpistore kpistore : kpistores) {
				if(kpistore.getKpistorecolList()!=null){
					for(KpistoreCol kpistorecol : kpistore.getKpistorecolList()) {
						kpiStores.put(kpistorecol.getKpiid(), kpistorecol.getKpitype());
					}
				}
			}
		}
	}
	protected void saveToXml(Report View){
		super.saveToXmlByObj(View,false);
	}
	

}