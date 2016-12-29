package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "condition")
public class Condition {
	
	@Attribute(name = "varname")
	private String varname;
	
	@Attribute(name = "desname")
	private String desname;
	
	@Attribute(name = "id")
	private String id;
	
	@Attribute(name = "cond")
	private String cond;
	
	public String getVarname() {
		return varname;
	}

	public void setVarname(String varname) {
		this.varname = varname;
	}

	public String getDesname() {
		return desname;
	}

	public void setDesname(String desname) {
		this.desname = desname;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCond() {
		return cond;
	}

	public void setCond(String cond) {
		this.cond = cond;
	}
	
	
	
}
