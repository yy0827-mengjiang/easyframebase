package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "report")
public class Report {
	@Attribute(name = "id")
	private String id;
	@Attribute(name = "theme")
	private String theme;
	@Element(name = "info")
	private Info info;
	@Element(name = "layout")
	private Layout layout;
	@Element(name = "containers")
	private Containers containers;
	@Element(name = "query")
	private Query query;
	@Element(name = "dimsions")
	private Dimsions dimsions;
	@Element(name = "datasources")
	private Datasources datasources;
	@Element(name = "kpistores")
	private Kpistores kpistores;
	@Element(name = "extcolumns")
	private Extcolumns extcolumns;
	@Element(name = "tmpdatasources")
	private TmpDatasources tmpdatasources;
	
	
	public TmpDatasources getTmpdatasources() {
		return tmpdatasources;
	}
	public void setTmpdatasources(TmpDatasources tmpdatasources) {
		this.tmpdatasources = tmpdatasources;
	}
	public Info getInfo() {
		return info;
	}
	public Report setInfo2(Info info) {
		this.info = info;
		return this;
	}
	public void setInfo(Info info) {
		this.info = info;
	}
	public Layout getLayout() {
		return layout;
	}
	public Report setLayout2(Layout layout) {
		this.layout = layout;
		return this;
	}
	public void setLayout(Layout layout) {
		this.layout = layout;
	}
	public Containers getContainers() {
		return containers;
	}
	
	public Report setContainers2(Containers containers) {
		this.containers = containers;
		return this;
	}
	public void setContainers(Containers containers) {
		this.containers = containers;
	}
	public String getId() {
		return id;
	}
	public Report setId2(String id) {
		this.id = id;
		return this;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTheme() {
		return theme;
	}
	public Report setTheme2(String theme) {
		this.theme = theme;
		return this;
	}
	public void setTheme(String theme) {
		this.theme = theme;
	}
	public Query getQuery() {
		return query;
	}
	public void setQuery(Query query) {
		this.query = query;
	}
	public Dimsions getDimsions() {
		return dimsions;
	}
	public void setDimsions(Dimsions dimsions) {
		this.dimsions = dimsions;
	}
	public Datasources getDatasources() {
		return datasources;
	}
	public void setDatasources(Datasources datasources) {
		this.datasources = datasources;
	}
	public Kpistores getKpistores() {
		return kpistores;
	}
	public void setKpistores(Kpistores kpistores) {
		this.kpistores = kpistores;
	}
	public Extcolumns getExtcolumns() {
		return extcolumns;
	}
	public void setExtcolumns(Extcolumns extcolumns) {
		this.extcolumns = extcolumns;
	}
	
}

