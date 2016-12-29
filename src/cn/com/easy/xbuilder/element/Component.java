package cn.com.easy.xbuilder.element;

import java.util.List;
import java.util.Map;

import cn.com.easy.core.EasyContext;
import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;
@Element(name = "component")
public class Component{
	@Attribute(name = "id")
	private String id="";
	
	@Attribute(name = "type")
	private String type="";
	
	@Attribute(name = "title")
	private String title="";
	
	@Attribute(name = "width")
	private String width="";
	
	@Attribute(name = "height")
	private String height="";
	
	@Attribute(name = "index")
	private String index="";
	
	@Attribute(name = "compId")
	private String compId="";
	
	@Attribute(name = "url")
	private String url="";
	
	@Attribute(name = "attrenable")
	private String attrenable="";
	
	@Attribute(name = "propertyUrl")
	private String propertyUrl="";
	
	@Element(name = "xaxis")
	private XAxis xaxis;
	
	@Element(name = "yaxis")
	private List<YAxis> yaxisList;
	
	@Element(name = "kpi")
	private List<Kpi> kpiList;
	
	@Attribute(name = "tablepagi")
	private String tablepagi="1";

	@Attribute(name = "tablepaginum")
	private String tablepaginum="10";
	@Attribute(name = "tableexport")
	private String tableexport="1";
	
	@Attribute(name = "tableheadlock")
	private String tableheadlock;
	
	@Attribute(name = "tableheadlocknum")
	private String tableheadlocknum;
	
	@Attribute(name = "tablecollock")
	private String tablecollock="0";
	
	@Attribute(name = "tablecollocknum")
	private String tablecollocknum="1";
	
	@Attribute(name = "tableshowrowtotal")
	private String tableshowrowtotal="0";
	
	@Attribute(name = "tableshowtotal")
	private String tableshowtotal="0";
	
	@Attribute(name = "tableshowtotalname")
	private String tableshowtotalname="合计";
	
	@Attribute(name = "tableshowtotalposition")
	private String tableshowtotalposition="top";
	
	@Attribute(name = "tablesetsum")
	private String tablesetsum="1";
	
	@Element(name = "datastore")
	private Datastore datastore;
	
	@Element(name = "dynheadstore")
	private Dynheadstore dynheadstore;
	
	@Element(name = "headui")
	private Headui headui;
	
	@Attribute(name = "datasourceid")
	private String datasourceid;
	
	@Attribute(name = "idfield")
	private String idfield="TREEFILE_ID";
	
	@Attribute(name = "treefield")
	private String treefield="TREEFILE_DESC";
	

	@Attribute(name = "contextmenuwidth")
	private String contextmenuwidth="200";
	
	@Attribute(name = "fieldwidth")
	private String fieldwidth="200";
	
	@Attribute(name = "treefieldtitle")
	private String treefieldtitle="下钻名称";
	
	@Attribute(name = "hastotalflag")
	private String hastotalflag="0";
	
	@Attribute(name = "totaltitle")
	private String totaltitle="合计";
	
	@Attribute(name = "totalcode")
	private String totalcode="all";
	
	@Attribute(name = "layoutid")
	private String layoutid;
	
	@Attribute(name = "colors")
	private String colors;
	
	@Attribute(name = "showTitle")
	private String showTitle="1";
	
	@Element(name = "legend")
	private Legend legend;
	
	@Element(name = "sortcolstore")
	private SortcolStore sortcolStore;
	
	@Element(name = "weblink")
	private Weblink weblink;
	
	@Attribute(name = "userUrl")
	private String userUrl="";
	
	@Element(name = "crosscolstore")
	private Crosscolstore crosscolstore;
	
	private Map<String, Object> kpiColMap;
	
	@Attribute(name = "rowtype")
	private String rowtype="1";
	
	@Attribute(name = "sumtype")
	private String sumtype="0";
	
	@Attribute(name = "rowsumposition")
	private String rowsumposition = "top";
	
	@Attribute(name = "chartTitle")
	private String chartTitle;
	
	@Attribute(name = "stacking")
	private String stacking = "false";
	
	@Attribute(name = "colSumName")
	private String colSumName = "列合计";
	
	@Attribute(name = "rowSumName")
	private String rowSumName = "行合计";
	
	public Component(){
		Object paginumObject=EasyContext.getContext().get("xDefautlTablePagiNum");
		if(paginumObject!=null&&(!(String.valueOf(paginumObject).trim().equals("")))&&(!(String.valueOf(paginumObject).trim().toLowerCase().equals("null")))){
			tablepaginum=String.valueOf(paginumObject).trim();
			
		}
	}
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getWidth() {
		return width;
	}

	public void setWidth(String width) {
		this.width = width;
	}

	public String getHeight() {
		return height;
	}

	public void setHeight(String height) {
		this.height = height;
	}

	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	public String getCompId() {
		return compId;
	}

	public void setCompId(String compId) {
		this.compId = compId;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getLayoutid() {
		return layoutid;
	}

	public void setLayoutid(String layoutid) {
		this.layoutid = layoutid;
	}

	public String getTreefieldtitle() {
		return treefieldtitle;
	}

	public void setTreefieldtitle(String treefieldtitle) {
		this.treefieldtitle = treefieldtitle;
	}

	public String getHastotalflag() {
		return hastotalflag;
	}

	public void setHastotalflag(String hastotalflag) {
		this.hastotalflag = hastotalflag;
	}

	public String getTotaltitle() {
		return totaltitle;
	}

	public void setTotaltitle(String totaltitle) {
		this.totaltitle = totaltitle;
	}

	public String getTotalcode() {
		return totalcode;
	}

	public void setTotalcode(String totalcode) {
		this.totalcode = totalcode;
	}

	public String getContextmenuwidth() {
		return contextmenuwidth;
	}

	public void setContextmenuwidth(String contextmenuwidth) {
		this.contextmenuwidth = contextmenuwidth;
	}

	public String getFieldwidth() {
		return fieldwidth;
	}

	public void setFieldwidth(String fieldwidth) {
		this.fieldwidth = fieldwidth;
	}

	@Element(name = "subdrills")
	private Subdrills subdrills;
	
	public Subdrills getSubdrills() {
		return subdrills;
	}

	public void setSubdrills(Subdrills subdrills) {
		this.subdrills = subdrills;
	}

	
	public String getAttrenable() {
		return attrenable;
	}

	public void setAttrenable(String attrenable) {
		this.attrenable = attrenable;
	}

	public XAxis getXaxis() {
		return xaxis;
	}

	public void setXaxis(XAxis xaxis) {
		this.xaxis = xaxis;
	}

	public List<YAxis> getYaxisList() {
		return yaxisList;
	}

	public void setYaxisList(List<YAxis> yaxisList) {
		this.yaxisList = yaxisList;
	}

	public List<Kpi> getKpiList() {
		return kpiList;
	}

	public void setKpiList(List<Kpi> kpiList) {
		this.kpiList = kpiList;
	}

	public String getTablepagi() {
		return tablepagi;
	}

	public void setTablepagi(String tablepagi) {
		this.tablepagi = tablepagi;
	}

	public String getTablepaginum() {
		return tablepaginum;
	}

	public void setTablepaginum(String tablepaginum) {
		this.tablepaginum = tablepaginum;
	}

	public String getTableexport() {
		return tableexport;
	}

	public void setTableexport(String tableexport) {
		this.tableexport = tableexport;
	}

	public String getTableheadlock() {
		return tableheadlock;
	}

	public void setTableheadlock(String tableheadlock) {
		this.tableheadlock = tableheadlock;
	}

	public String getTableheadlocknum() {
		return tableheadlocknum;
	}

	public void setTableheadlocknum(String tableheadlocknum) {
		this.tableheadlocknum = tableheadlocknum;
	}

	public String getTablecollock() {
		return tablecollock;
	}

	public void setTablecollock(String tablecollock) {
		this.tablecollock = tablecollock;
	}

	public String getTablecollocknum() {
		return tablecollocknum;
	}

	public void setTablecollocknum(String tablecollocknum) {
		this.tablecollocknum = tablecollocknum;
	}
	
	public String getTableshowrowtotal() {
		return tableshowrowtotal;
	}

	public void setTableshowrowtotal(String tableshowrowtotal) {
		this.tableshowrowtotal = tableshowrowtotal;
	}
	
	public String getTableshowtotal() {
		return tableshowtotal;
	}

	public void setTableshowtotal(String tableshowtotal) {
		this.tableshowtotal = tableshowtotal;
	}

	public String getTableshowtotalname() {
		return tableshowtotalname;
	}
	
	public void setTableshowtotalname(String tableshowtotalname) {
		this.tableshowtotalname = tableshowtotalname;
	}
	
	public String getTableshowtotalposition() {
		return tableshowtotalposition;
	}

	public void setTableshowtotalposition(String tableshowtotalposition) {
		this.tableshowtotalposition = tableshowtotalposition;
	}

	public String getTablesetsum() {
		return tablesetsum;
	}

	public void setTablesetsum(String tablesetsum) {
		this.tablesetsum = tablesetsum;
	}

	public Datastore getDatastore() {
		return datastore;
	}

	public void setDatastore(Datastore datastore) {
		this.datastore = datastore;
	}

	public Dynheadstore getDynheadstore() {
		return dynheadstore;
	}

	public void setDynheadstore(Dynheadstore dynheadstore) {
		this.dynheadstore = dynheadstore;
	}

	public Headui getHeadui() {
		return headui;
	}

	public void setHeadui(Headui headui) {
		this.headui = headui;
	}

	public String getDatasourceid() {
		return datasourceid;
	}

	public void setDatasourceid(String datasourceid) {
		this.datasourceid = datasourceid;
	}

	public String getIdfield() {
		return idfield;
	}

	public void setIdfield(String idfield) {
		this.idfield = idfield;
	}

	public String getTreefield() {
		return treefield;
	}

	public void setTreefield(String treefield) {
		this.treefield = treefield;
	}

	public String getPropertyUrl() {
		return propertyUrl;
	}

	public void setPropertyUrl(String propertyUrl) {
		this.propertyUrl = propertyUrl;
	}

	public String getColors() {
		return colors;
	}

	public void setColors(String colors) {
		this.colors = colors;
	}

	public Legend getLegend() {
		return legend;
	}

	public void setLegend(Legend legend) {
		this.legend = legend;
	}

	public Map<String, Object> getKpiColMap() {
		return kpiColMap;
	}

	public void setKpiColMap(Map<String, Object> kpiColMap) {
		this.kpiColMap = kpiColMap;
	}

	public String getShowTitle() {
		return showTitle;
	}

	public void setShowTitle(String showTitle) {
		this.showTitle = showTitle;
	}

	public SortcolStore getSortcolStore() {
		return sortcolStore;
	}

	public void setSortcolStore(SortcolStore sortcolStore) {
		this.sortcolStore = sortcolStore;
	}

	public Weblink getWeblink() {
		return weblink;
	}

	public void setWeblink(Weblink weblink) {
		this.weblink = weblink;
	}

	public String getUserUrl() {
		return userUrl;
	}

	public void setUserUrl(String userUrl) {
		this.userUrl = userUrl;
	}

	public Crosscolstore getCrosscolstore() {
		return crosscolstore;
	}

	public void setCrosscolstore(Crosscolstore crosscolstore) {
		this.crosscolstore = crosscolstore;
	}

	public String getRowtype() {
		return rowtype;
	}

	public void setRowtype(String rowtype) {
		this.rowtype = rowtype;
	}

	public String getSumtype() {
		return sumtype;
	}

	public void setSumtype(String sumtype) {
		this.sumtype = sumtype;
	}

	public String getRowsumposition() {
		return rowsumposition;
	}

	public void setRowsumposition(String rowsumposition) {
		this.rowsumposition = rowsumposition;
	}

	public String getChartTitle() {
		return chartTitle;
	}

	public void setChartTitle(String chartTitle) {
		this.chartTitle = chartTitle;
	}

	public String getStacking() {
		return stacking;
	}

	public void setStacking(String stacking) {
		this.stacking = stacking;
	}
	public String getColSumName() {
		return colSumName;
	}
	public void setColSumName(String colSumName) {
		this.colSumName = colSumName;
	}
	public String getRowSumName() {
		return rowSumName;
	}
	public void setRowSumName(String rowSumName) {
		this.rowSumName = rowSumName;
	}
	
	
	
}
