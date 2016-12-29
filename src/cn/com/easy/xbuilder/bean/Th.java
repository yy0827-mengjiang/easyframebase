package cn.com.easy.xbuilder.bean;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;

@Element(name = "th")
public class Th {

	@Attribute(name = "istt")
	private String istt;
	
	@Attribute(name = "ishead")
	private String ishead;
	
	@Text
	private String text;

	public String getIstt() {
		return istt;
	}

	public void setIstt(String istt) {
		this.istt = istt;
	}

	public String getIshead() {
		return ishead;
	}

	public void setIshead(String ishead) {
		this.ishead = ishead;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}
	
}
