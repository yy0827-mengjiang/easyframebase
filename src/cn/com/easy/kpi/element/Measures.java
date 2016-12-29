package cn.com.easy.kpi.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "measures")
public class Measures {

	@Element(name= "measure")
	private List<Measure> measureList;

	public List<Measure> getMeasureList() {
		return measureList;
	}

	public void setMeasureList(List<Measure> measureList) {
		this.measureList = measureList;
	}
}
