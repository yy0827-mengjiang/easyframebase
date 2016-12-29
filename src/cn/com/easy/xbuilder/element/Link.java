package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "link")
public class Link {

	@Attribute(name = "dimsionid")
	private String dimsionid;

	public String getDimsionid() {
		return dimsionid;
	}

	public void setDimsionid(String dimsionid) {
		this.dimsionid = dimsionid;
	}

}
