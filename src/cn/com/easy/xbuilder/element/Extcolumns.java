package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "extcolumns")
public class Extcolumns {
	
	@Element(name = "extcolumn")
	private List<Extcolumn> extcolumnList;

	public List<Extcolumn> getExtcolumnList() {
		return extcolumnList;
	}

	public void setExtcolumnList(List<Extcolumn> extcolumnList) {
		this.extcolumnList = extcolumnList;
	}
	
}
