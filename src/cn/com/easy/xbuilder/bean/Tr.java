package cn.com.easy.xbuilder.bean;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "tr")
public class Tr {

	@Element(name = "th")
	private List<Th> ths; 
	
	@Element(name = "td")
	private List<Td> tds;

	public List<Th> getThs() {
		return ths;
	}

	public void setThs(List<Th> ths) {
		this.ths = ths;
	}

	public List<Td> getTds() {
		return tds;
	}

	public void setTds(List<Td> tds) {
		this.tds = tds;
	}
	
}
