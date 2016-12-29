package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;

@Element(name = "headui")
public class Headui {

	@Text
	private String text="";

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}
}
