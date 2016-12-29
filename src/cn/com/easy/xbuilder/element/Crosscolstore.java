package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "crosscolstore")
public class Crosscolstore {
	@Attribute(name = "show")
	private String show="";
	
	@Attribute(name = "total")
	private String total="";
	
	@Element(name = "crosscol")
	List<Crosscol> crosscolList;

	public String getShow() {
		return show;
	}

	public void setShow(String show) {
		this.show = show;
	}

	public String getTotal() {
		return total;
	}

	public void setTotal(String total) {
		this.total = total;
	}

	public List<Crosscol> getCrosscolList() {
		return crosscolList;
	}

	public void setCrosscolList(List<Crosscol> crosscolList) {
		this.crosscolList = crosscolList;
	}

	
	
	
	
}
