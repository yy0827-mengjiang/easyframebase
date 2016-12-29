package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "crosscol")
public class Crosscol {

	@Attribute(name = "id")
	private String id = "";

	@Attribute(name = "dimdesc")
	private String dimdesc = "";

	@Attribute(name = "dimid")
	private String dimid = "";

	@Attribute(name = "dimfield")
	private String dimfield = "";

	@Attribute(name = "index")
	private String index = "";
	
	@Attribute(name = "type")
	private String type = "";
	
	@Attribute(name = "tableheadwidth")
	private String tableheadwidth="100";
	
	@Attribute(name = "tableheadalign")
	private String tableheadalign="left";
	
	@Attribute(name = "datafmtrowmerge")
	private String datafmtrowmerge = "0";
	
	@Element(name = "eventstore")
	private Eventstore eventstore;
	
	public String getTableheadwidth() {
		return tableheadwidth;
	}

	public void setTableheadwidth(String tableheadwidth) {
		this.tableheadwidth = tableheadwidth;
	}

	public String getTableheadalign() {
		return tableheadalign;
	}

	public void setTableheadalign(String tableheadalign) {
		this.tableheadalign = tableheadalign;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getDimdesc() {
		return dimdesc;
	}

	public void setDimdesc(String dimdesc) {
		this.dimdesc = dimdesc;
	}

	public String getDimid() {
		return dimid;
	}

	public void setDimid(String dimid) {
		this.dimid = dimid;
	}

	public String getDimfield() {
		return dimfield;
	}

	public void setDimfield(String dimfield) {
		this.dimfield = dimfield;
	}

	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Eventstore getEventstore() {
		return eventstore;
	}

	public void setEventstore(Eventstore eventstore) {
		this.eventstore = eventstore;
	}

	public String getDatafmtrowmerge() {
		return datafmtrowmerge;
	}

	public void setDatafmtrowmerge(String datafmtrowmerge) {
		this.datafmtrowmerge = datafmtrowmerge;
	}

	
}
