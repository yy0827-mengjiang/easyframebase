package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "sortcol")
public class Sortcol {
	@Attribute(name = "id")
	private String id = "";
	@Attribute(name = "col")
	private String col = "";
	@Attribute(name = "desc")
	private String desc = "";
	@Attribute(name = "type")
	private String type = "asc";
	@Attribute(name = "kpitype")
	private String kpitype = "dim";
	@Attribute(name = "extcolumnid")
	private String extcolumnid = "";
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCol() {
		return col;
	}
	public void setCol(String col) {
		this.col = col;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getKpitype() {
		return kpitype;
	}
	public void setKpitype(String kpitype) {
		this.kpitype = kpitype;
	}
	public String getExtcolumnid() {
		return extcolumnid;
	}
	public void setExtcolumnid(String extcolumnid) {
		this.extcolumnid = extcolumnid;
	}
	
}
