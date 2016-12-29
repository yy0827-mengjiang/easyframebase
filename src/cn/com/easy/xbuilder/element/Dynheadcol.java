package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "dynheadcol")
public class Dynheadcol {
	@Attribute(name = "id")
	private String id="";
	@Attribute(name = "bindingtype")
	private String bindingtype="1";
	@Attribute(name = "datatype")
	private String datatype="1";
	@Attribute(name = "dimsionname")
	private String dimsionname="";
	@Attribute(name = "yearstep")
	private String yearstep="0";
	@Attribute(name = "monthstep")
	private String monthstep="0";
	@Attribute(name = "daystep")
	private String daystep="0";
	@Attribute(name = "prefixstr")
	private String prefixstr="";
	@Attribute(name = "suffixstr")
	private String suffixstr="";
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBindingtype() {
		return bindingtype;
	}
	public void setBindingtype(String bindingtype) {
		this.bindingtype = bindingtype;
	}
	public String getDatatype() {
		return datatype;
	}
	public void setDatatype(String datatype) {
		this.datatype = datatype;
	}
	public String getDimsionname() {
		return dimsionname;
	}
	public void setDimsionname(String dimsionname) {
		this.dimsionname = dimsionname;
	}
	public String getYearstep() {
		return yearstep;
	}
	public void setYearstep(String yearstep) {
		this.yearstep = yearstep;
	}
	public String getMonthstep() {
		return monthstep;
	}
	public void setMonthstep(String monthstep) {
		this.monthstep = monthstep;
	}
	public String getDaystep() {
		return daystep;
	}
	public void setDaystep(String daystep) {
		this.daystep = daystep;
	}
	public String getPrefixstr() {
		return prefixstr;
	}
	public void setPrefixstr(String prefixstr) {
		this.prefixstr = prefixstr;
	}
	public String getSuffixstr() {
		return suffixstr;
	}
	public void setSuffixstr(String suffixstr) {
		this.suffixstr = suffixstr;
	}
	
}
