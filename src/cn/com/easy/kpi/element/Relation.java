package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;

@Element(name = "relation")
public class Relation {

	@Text
	private String relation;

	public String getRelation() {
		return relation;
	}

	public void setRelation(String relation) {
		this.relation = relation;
	}
	
}
