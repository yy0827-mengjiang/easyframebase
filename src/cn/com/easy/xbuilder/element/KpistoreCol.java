package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "kpistorecol")
public class KpistoreCol {
	
	@Attribute(name = "kpiid")
	private String kpiid;
	@Attribute(name = "kpicolumn")
	private String kpicolumn;
	@Attribute(name = "kpidesc")
	private String kpidesc;
	@Attribute(name = "kpitype")
	private String kpitype;
	public String getKpiid() {
		return kpiid;
	}
	public void setKpiid(String kpiid) {
		this.kpiid = kpiid;
	}
	public String getKpicolumn() {
		return kpicolumn;
	}
	public void setKpicolumn(String kpicolumn) {
		this.kpicolumn = kpicolumn;
	}
	public String getKpidesc() {
		return kpidesc;
	}
	public void setKpidesc(String kpidesc) {
		this.kpidesc = kpidesc;
	}
	public String getKpitype() {
		return kpitype;
	}
	public void setKpitype(String kpitype) {
		this.kpitype = kpitype;
	}
	
	
}
