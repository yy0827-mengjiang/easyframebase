package cn.com.easy.xbuilder.bean;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "thead")
public class Thead {

	@Element(name = "tr")
	private List<Tr> trs;

	public List<Tr> getTrs() {
		return trs;
	}

	public void setTrs(List<Tr> trs) {
		this.trs = trs;
	}
	
}
