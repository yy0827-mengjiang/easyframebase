package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "dynheadstore")
public class Dynheadstore {
	@Element(name = "dynheadcol")
	private List<Dynheadcol> dynheadcolList;

	public List<Dynheadcol> getDynheadcolList() {
		return dynheadcolList;
	}

	public void setDynheadcolList(List<Dynheadcol> dynheadcolList) {
		this.dynheadcolList = dynheadcolList;
	}
	
}
