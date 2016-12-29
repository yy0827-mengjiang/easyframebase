package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "datacol")
public class Datacol {
	
	@Attribute(name = "tableheadwidth")
	private String tableheadwidth="100";
	@Attribute(name = "tableheadalign")
	private String tableheadalign="center";
	
	@Attribute(name = "tablerowcode")
	private String tablerowcode;
	
	@Attribute(name = "tablecolcode")
	private String tablecolcode="";
	
	@Attribute(name = "tablecoldesc")
	private String tablecoldesc="";
	
	@Attribute(name = "datacolid")
	private String datacolid="";	
	
	@Attribute(name = "datacoltype")
	private String datacoltype="";	
	
	@Attribute(name = "datacolcode")
	private String datacolcode="";
	
	@Attribute(name = "datacoldesc")
	private String datacoldesc="";
	
	@Attribute(name = "datafmtrowmerge")
	private String datafmtrowmerge="0";
	
	@Attribute(name = "datafmttype")
	private String datafmttype="common";
	
	@Attribute(name = "datafmtthousand")
	private String datafmtthousand="0";
	
	@Attribute(name = "datafmtisbd")
	private String datafmtisbd="0";
	
	@Attribute(name = "datafmtisbdvalue")
	private String datafmtisbdvalue="0";
	
	@Attribute(name = "datafmtbdup")
	private String datafmtbdup="#ff0000";
	
	@Attribute(name = "datafmtbddown")
	private String datafmtbddown="00ff00";
	
	@Attribute(name = "datafmtisarrow")
	private String datafmtisarrow="0";
	
	@Attribute(name = "datafmtalign")
	private String datafmtalign="";
	
	@Attribute(name = "datadecimal")
	private String datadecimal="0";
	
	@Attribute(name = "index")
	private String index="";
	
	@Attribute(name = "extcolumnid")
	private String extcolumnid="";
	
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
	public String getTablerowcode() {
		return tablerowcode;
	}
	public void setTablerowcode(String tablerowcode) {
		this.tablerowcode = tablerowcode;
	}
	public String getTablecolcode() {
		return tablecolcode;
	}
	public void setTablecolcode(String tablecolcode) {
		this.tablecolcode = tablecolcode;
	}
	public String getTablecoldesc() {
		return tablecoldesc;
	}
	public void setTablecoldesc(String tablecoldesc) {
		this.tablecoldesc = tablecoldesc;
	}
	public String getDatacolid() {
		return datacolid;
	}
	public void setDatacolid(String datacolid) {
		this.datacolid = datacolid;
	}
	public String getDatacoltype() {
		return datacoltype;
	}
	public void setDatacoltype(String datacoltype) {
		this.datacoltype = datacoltype;
	}
	public String getDatacolcode() {
		return datacolcode;
	}
	public void setDatacolcode(String datacolcode) {
		this.datacolcode = datacolcode;
	}
	public String getDatacoldesc() {
		return datacoldesc;
	}
	public void setDatacoldesc(String datacoldesc) {
		this.datacoldesc = datacoldesc;
	}
	
	public String getDatafmtrowmerge() {
		return datafmtrowmerge;
	}
	public void setDatafmtrowmerge(String datafmtrowmerge) {
		this.datafmtrowmerge = datafmtrowmerge;
	}
	public String getDatafmttype() {
		return datafmttype;
	}
	public void setDatafmttype(String datafmttype) {
		this.datafmttype = datafmttype;
	}
	public String getDatafmtthousand() {
		return datafmtthousand;
	}
	public void setDatafmtthousand(String datafmtthousand) {
		this.datafmtthousand = datafmtthousand;
	}
	public String getDatafmtisbd() {
		return datafmtisbd;
	}
	public void setDatafmtisbd(String datafmtisbd) {
		this.datafmtisbd = datafmtisbd;
	}
	public String getDatafmtbdup() {
		return datafmtbdup;
	}
	public void setDatafmtbdup(String datafmtbdup) {
		this.datafmtbdup = datafmtbdup;
	}
	public String getDatafmtbddown() {
		return datafmtbddown;
	}
	public void setDatafmtbddown(String datafmtbddown) {
		this.datafmtbddown = datafmtbddown;
	}
	public String getDatafmtisarrow() {
		return datafmtisarrow;
	}
	public void setDatafmtisarrow(String datafmtisarrow) {
		this.datafmtisarrow = datafmtisarrow;
	}
	public String getDatafmtalign() {
		return datafmtalign;
	}
	public void setDatafmtalign(String datafmtalign) {
		this.datafmtalign = datafmtalign;
	}
	public String getIndex() {
		return index;
	}
	public void setIndex(String index) {
		this.index = index;
	}
	public String getDatadecimal() {
		return datadecimal;
	}
	public void setDatadecimal(String datadecimal) {
		this.datadecimal = datadecimal;
	}
	public String getDatafmtisbdvalue() {
		return datafmtisbdvalue;
	}
	public void setDatafmtisbdvalue(String datafmtisbdvalue) {
		this.datafmtisbdvalue = datafmtisbdvalue;
	}
	public Eventstore getEventstore() {
		return eventstore;
	}
	public void setEventstore(Eventstore eventstore) {
		this.eventstore = eventstore;
	}
	public String getExtcolumnid() {
		return extcolumnid;
	}
	public void setExtcolumnid(String extcolumnid) {
		this.extcolumnid = extcolumnid;
	}
	
	
}
