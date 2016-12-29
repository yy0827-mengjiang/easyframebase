package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "kpistores")
public class Kpistores {
	@Element(name = "kpistore")
	private List<Kpistore> kpistoreList;

	public List<Kpistore> getKpistoreList() {
		return kpistoreList;
	}

	public void setKpistoreList(List<Kpistore> kpistoreList) {
		this.kpistoreList = kpistoreList;
	}
	
}
