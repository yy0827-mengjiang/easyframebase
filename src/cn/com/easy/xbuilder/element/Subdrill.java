package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "subdrill")
public class Subdrill {
	
	@Attribute(name="drillcolcodeid")
	private String drillcolcodeid="";
	
	@Attribute(name="drillcode")
	private String drillcode="";
	
	@Attribute(name="drillcolcode")
	private String drillcolcode="";
	
	@Attribute(name="drillcoldesc")
	private String drillcoldesc="";
	
	@Attribute(name="drillsortcolcode")
	private String drillsortcolcode="";
	
	@Attribute(name="drillsorttype")
	private String drillsorttype="asc";
	
	@Attribute(name="drillcoltitle")
	private String drillcoltitle="";
	
	@Attribute(name="level")
	private String level="0";
	
	@Attribute(name="group")
	private String group="";
	
	@Attribute(name="isdefault")
	private String isdefault="0";
	
	@Attribute(name="datasourceid")
	private String datasourceid="";
	
	@Attribute(name="index")
	private String index="";

	@Element(name = "subdirllsortcols")
	private Subdirllsortcols subdirllsortcols;
	public String getDrillcolcodeid() {
		return drillcolcodeid;
	}

	public void setDrillcolcodeid(String drillcolcodeid) {
		this.drillcolcodeid = drillcolcodeid;
	}

	public String getDrillcode() {
		return drillcode;
	}

	public void setDrillcode(String drillcode) {
		this.drillcode = drillcode;
	}

	public String getDrillcolcode() {
		return drillcolcode;
	}

	public void setDrillcolcode(String drillcolcode) {
		this.drillcolcode = drillcolcode;
	}

	public String getDrillcoldesc() {
		return drillcoldesc;
	}

	public void setDrillcoldesc(String drillcoldesc) {
		this.drillcoldesc = drillcoldesc;
	}
	
	public String getDrillsortcolcode() {
		return drillsortcolcode;
	}

	public void setDrillsortcolcode(String drillsortcolcode) {
		this.drillsortcolcode = drillsortcolcode;
	}

	public String getDrillsorttype() {
		return drillsorttype;
	}

	public void setDrillsorttype(String drillsorttype) {
		this.drillsorttype = drillsorttype;
	}

	public String getDrillcoltitle() {
		return drillcoltitle;
	}

	public void setDrillcoltitle(String drillcoltitle) {
		this.drillcoltitle = drillcoltitle;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public String getGroup() {
		return group;
	}

	public void setGroup(String group) {
		this.group = group;
	}

	public String getIsdefault() {
		return isdefault;
	}

	public void setIsdefault(String isdefault) {
		this.isdefault = isdefault;
	}

	public String getDatasourceid() {
		return datasourceid;
	}

	public void setDatasourceid(String datasourceid) {
		this.datasourceid = datasourceid;
	}

	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	public Subdirllsortcols getSubdirllsortcols() {
		return subdirllsortcols;
	}

	public void setSubdirllsortcols(Subdirllsortcols subdirllsortcols) {
		this.subdirllsortcols = subdirllsortcols;
	}
	
}
