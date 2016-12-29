package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "subdrills")
public class Subdrills {
	@Element(name = "subdrill")
	private List<Subdrill> subdrillList;

	public List<Subdrill> getSubdrillList() {
		return subdrillList;
	}

	public void setSubdrillList(List<Subdrill> subdrillList) {
		this.subdrillList = subdrillList;
	}
	
	
}
