package cn.com.easy.kpi.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;

@Element(name = "formula")
public class Formula {
	
	@Attribute(name = "type")
	private String type;
	
	@Attribute(name="source")
	private String source;
	
	@Text
	private String formula;
	
	//@Attribute(name = "name")
	//private String name;
	
	//@Element(name = "measure")
	//private List<Measure> measure;
	
	//@Element(name = "relation")
	//private Relation relation;

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getFormula() {
		return formula;
	}

	public void setFormula(String formula) {
		this.formula = formula;
	}
}
