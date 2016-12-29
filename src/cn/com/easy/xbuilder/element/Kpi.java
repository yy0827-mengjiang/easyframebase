package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "kpi")
public class Kpi {
	//name="指标名称" type="line" field="指标列" color="颜色" yaxisid="yaxis编码" index="0"
	@Attribute(name = "name")
	private String name="";
	
	@Attribute(name = "type")
	private String type="";
	
	@Attribute(name = "field")
	private String field="";
	
	@Attribute(name = "kpiId")
	private String kpiId="";
	
	@Attribute(name = "color")
	private String color="";
	
	@Attribute(name = "yaxisid")
	private String yaxisid="";
	
	@Attribute(name = "index")
	private String index="";
	
	@Attribute(name = "extcolumnid")
	private String extcolumnid="";

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getField() {
		return field;
	}

	public void setField(String field) {
		this.field = field;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getYaxisid() {
		return yaxisid;
	}

	public void setYaxisid(String yaxisid) {
		this.yaxisid = yaxisid;
	}

	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getKpiId() {
		return kpiId;
	}

	public void setKpiId(String kpiId) {
		this.kpiId = kpiId;
	}

	public String getExtcolumnid() {
		return extcolumnid;
	}

	public void setExtcolumnid(String extcolumnid) {
		this.extcolumnid = extcolumnid;
	}

}
