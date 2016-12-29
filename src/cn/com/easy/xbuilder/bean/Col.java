package cn.com.easy.xbuilder.bean;

import cn.com.easy.jaxb.annotation.Attribute;

public class Col {

	@Attribute(name = "width")
	private String width;

	public String getWidth() {
		return width;
	}

	public void setWidth(String width) {
		this.width = width;
	}
	
}
