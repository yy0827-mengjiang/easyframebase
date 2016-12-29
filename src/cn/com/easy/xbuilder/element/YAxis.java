package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "yaxis")
public class YAxis {
	//id="编码" title="标题" color="颜色" unit="单位" min="最小值" max="最大值" index="顺序" 
	@Attribute(name = "id")
	private String id="";

	@Attribute(name = "title")
	private String title="";
	
	@Attribute(name = "color")
	private String color="";
	
	@Attribute(name = "unit")
	private String unit="";
	
	@Attribute(name = "min")
	private String min="";
	
	@Attribute(name = "max")
	private String max="";
	
	@Attribute(name = "index")
	private String index="";

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getMin() {
		return min;
	}

	public void setMin(String min) {
		this.min = min;
	}

	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	public String getMax() {
		return max;
	}

	public void setMax(String max) {
		this.max = max;
	}
	
	
}
