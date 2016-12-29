package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "parameter")
public class Parameter {

	@Attribute(name = "dimsionid")
	private String dimsionid;
	
	@Attribute(name = "name")
	private String name;
	
	@Attribute(name = "value")
	private String value;
	
	
	public String getDimsionid() {
		return dimsionid;
	}
	public void setDimsionid(String dimsionid) {
		this.dimsionid = dimsionid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
}
