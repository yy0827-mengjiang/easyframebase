package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "dimsions")
public class Dimsions {
	
	@Element(name = "dimsion")
	private List<Dimsion> dimsionList;

	public List<Dimsion> getDimsionList() {
		return dimsionList;
	}

	public void setDimsionList(List<Dimsion> dimsionList) {
		this.dimsionList = dimsionList;
	}
}
