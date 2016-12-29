package cn.com.easy.xbuilder.bean;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;

@Element(name = "td")
public class Td {

	@Attribute(name = "istt")
	private String istt;
	
	@Attribute(name = "tdind")
	private String tdind;
	
	@Attribute(name = "ishead")
	private String ishead;
	
	@Attribute(name = "data-data_col")
	private String data_col;
	
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

	public String getTdind() {
		return tdind;
	}

	public void setTdind(String tdind) {
		this.tdind = tdind;
	}

	public String getData_col() {
		return data_col;
	}

	public void setData_col(String data_col) {
		this.data_col = data_col;
	}
	
	
	
}
