package cn.com.easy.kpi.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "dimensions")
public class Dimensions {

	@Element(name = "dimension")
	List<Dimension> dimensionList;

	public List<Dimension> getDimensionList() {
		return dimensionList;
	}

	public void setDimensionList(List<Dimension> dimensionList) {
		this.dimensionList = dimensionList;
	}
}
