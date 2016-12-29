package cn.com.easy.xbuilder.bean;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "table")
public class Table {

	@Element(name = "thead")
	private Thead thead;
	
	@Element(name = "tbody")
	private Tbody tbody;

	public Thead getThead() {
		return thead;
	}

	public void setThead(Thead thead) {
		this.thead = thead;
	}

	public Tbody getTbody() {
		return tbody;
	}

	public void setTbody(Tbody tbody) {
		this.tbody = tbody;
	}
	
}
