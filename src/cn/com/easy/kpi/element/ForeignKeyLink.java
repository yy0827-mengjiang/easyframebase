package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "foreignKeyLink")
public class ForeignKeyLink {

	@Attribute(name = "dimension")
	private String dimension;
	
	@Attribute(name = "foreignKeyColumn")
	private String foreignKeyColumn;

	public String getDimension() {
		return dimension;
	}

	public void setDimension(String dimension) {
		this.dimension = dimension;
	}

	public String getForeignKeyColumn() {
		return foreignKeyColumn;
	}

	public void setForeignKeyColumn(String foreignKeyColumn) {
		this.foreignKeyColumn = foreignKeyColumn;
	}
}
