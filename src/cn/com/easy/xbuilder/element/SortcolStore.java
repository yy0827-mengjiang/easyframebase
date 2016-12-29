package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "sortcolstore")
public class SortcolStore {
	@Element(name = "sortcol")
	List<Sortcol> sortcolList;

	public List<Sortcol> getSortcolList() {
		return sortcolList;
	}

	public void setSortcolList(List<Sortcol> sortcolList) {
		this.sortcolList = sortcolList;
	}
	
}
