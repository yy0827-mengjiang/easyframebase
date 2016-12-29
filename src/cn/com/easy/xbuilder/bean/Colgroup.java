package cn.com.easy.xbuilder.bean;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

public class Colgroup {

	@Element(name = "cols")
	private List<Col> cols;

	public List<Col> getCols() {
		return cols;
	}

	public void setCols(List<Col> cols) {
		this.cols = cols;
	}
	
}
