package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;


@Element(name = "param")
public class Param {
	
	 @Attribute(name = "name")
	 private String name;
	 
	 @Attribute(name = "value")
	 private String value;

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
