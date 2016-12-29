package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "subdirllsortcols")
public class Subdirllsortcols {
	@Element(name = "subdirllsortcol")
	private List<Subdirllsortcol> subdirllsortcolList;

	public List<Subdirllsortcol> getSubdirllsortcolList() {
		return subdirllsortcolList;
	}

	public void setSubdirllsortcolList(List<Subdirllsortcol> subdirllsortcolList) {
		this.subdirllsortcolList = subdirllsortcolList;
	}
	
}
