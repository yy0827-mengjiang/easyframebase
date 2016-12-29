package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;
@Element(name = "measure")
public class Measure {

	@Attribute(name = "id")
	private String id;

	@Attribute(name = "name")
	private String name;

	@Attribute(name = "alias")
	private String alias;

	@Attribute(name = "tableLink")
	private String tableLink;

	@Attribute(name = "columnLink")
	private String columnLink;

	@Attribute(name = "aggregator")
	private String aggregator;

	@Element(name = "foreignKeyLink")
	private ForeignKeyLink foreignKeyLink;

	@Attribute(name="datasource")
	private String datasource;
	
	@Attribute(name="version")
	private String version;
	
	@Attribute(name="kpiKey")
	private String kpiKey;
	
	
	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getKpiKey() {
		return kpiKey;
	}

	public void setKpiKey(String kpiKey) {
		this.kpiKey = kpiKey;
	}

	public String getDatasource() {
		return datasource;
	}

	public void setDatasource(String datasource) {
		this.datasource = datasource;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAlias() {
		return alias;
	}

	public void setAlias(String alias) {
		this.alias = alias;
	}

	public String getTableLink() {
		return tableLink;
	}

	public void setTableLink(String tableLink) {
		this.tableLink = tableLink;
	}

	public String getColumnLink() {
		return columnLink;
	}

	public void setColumnLink(String columnLink) {
		this.columnLink = columnLink;
	}

	public String getAggregator() {
		return aggregator;
	}

	public void setAggregator(String aggregator) {
		this.aggregator = aggregator;
	}

	public ForeignKeyLink getForeignKeyLink() {
		return foreignKeyLink;
	}

	public void setForeignKeyLink(ForeignKeyLink foreignKeyLink) {
		this.foreignKeyLink = foreignKeyLink;
	}

}
