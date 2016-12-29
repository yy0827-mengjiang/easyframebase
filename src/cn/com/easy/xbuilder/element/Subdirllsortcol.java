package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "subdirllsortcol")
public class Subdirllsortcol {
	
	@Attribute(name = "colcode")
	private String colcode = "";
	
	@Attribute(name = "sortkpitype")
	private String sortkpitype = "dim";
	
	@Attribute(name = "sorttype")
	private String sorttype = "asc";
	
	@Attribute(name = "extcolumnid")
	private String extcolumnid = "";

	public String getColcode() {
		return colcode;
	}

	public void setColcode(String colcode) {
		this.colcode = colcode;
	}

	public String getSortkpitype() {
		return sortkpitype;
	}

	public void setSortkpitype(String sortkpitype) {
		this.sortkpitype = sortkpitype;
	}

	public String getSorttype() {
		return sorttype;
	}

	public void setSorttype(String sorttype) {
		this.sorttype = sorttype;
	}

	public String getExtcolumnid() {
		return extcolumnid;
	}

	public void setExtcolumnid(String extcolumnid) {
		this.extcolumnid = extcolumnid;
	}

}
