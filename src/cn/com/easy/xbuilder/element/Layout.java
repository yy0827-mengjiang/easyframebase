package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;

@Element(name = "layout")
public class Layout {
	@Text
	private String value;

	@Attribute(name = "type")
	private String type;
	
	@Attribute(name = "width")
	private String width;
	
	public String getValue() {
		return value;
	}

	public Layout setValue2(String value) {
		this.value = value;
		return this;
	}
	public void setValue(String value) {
		this.value = value;
	}

	public String getType() {
		return type;
	}

	public Layout setType2(String type) {
		this.type = type;
		return this;
	}
	public void setType(String type) {
		this.type = type;
	}
	
	public String getWidth() {
		return width;
	}
	
	public Layout setWidth2(String width) {
		this.width = width;
		return this;
	}
	public void setWidth(String width) {
		this.width = width;
	}
}