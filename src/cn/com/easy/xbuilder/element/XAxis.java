package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "xaxis")
public class XAxis {
	
	@Attribute(name = "sortfield")
	private String sortfield="";
	
	@Attribute(name = "dimfield")
	private String dimfield="";
	
	@Attribute(name = "sortFiledId")
	private String sortFiledId="";
	
	@Attribute(name = "dimFiledId")
	private String dimFiledId="";
	
	@Attribute(name = "sortType")
	private String sortType="";
	
	@Attribute(name = "sortkpitype")
	private String sortkpitype="";
	
	@Attribute(name = "scatterDimField")
	private String scatterDimField;
	
	@Attribute(name = "scatterDimFieldId")
	private String scatterDimFieldId;
	
	@Attribute(name = "sortExtField")
	private String sortExtField="";
	
	@Attribute(name = "dimExtField")
	private String dimExtField="";
	
	@Attribute(name = "scatterDimExtField")
	private String scatterDimExtField="";
	
	public String getSortfield() {
		return sortfield;
	}

	public void setSortfield(String sortfield) {
		this.sortfield = sortfield;
	}

	public String getDimfield() {
		return dimfield;
	}

	public void setDimfield(String dimfield) {
		this.dimfield = dimfield;
	}

	public String getSortFiledId() {
		return sortFiledId;
	}

	public void setSortFiledId(String sortFiledId) {
		this.sortFiledId = sortFiledId;
	}

	public String getDimFiledId() {
		return dimFiledId;
	}

	public void setDimFiledId(String dimFiledId) {
		this.dimFiledId = dimFiledId;
	}

	public String getSortType() {
		return sortType;
	}

	public void setSortType(String sortType) {
		this.sortType = sortType;
	}

	public String getSortkpitype() {
		return sortkpitype;
	}

	public void setSortkpitype(String sortkpitype) {
		this.sortkpitype = sortkpitype;
	}

	public String getScatterDimField() {
		return scatterDimField;
	}

	public void setScatterDimField(String scatterDimField) {
		this.scatterDimField = scatterDimField;
	}

	public String getScatterDimFieldId() {
		return scatterDimFieldId;
	}

	public void setScatterDimFieldId(String scatterDimFieldId) {
		this.scatterDimFieldId = scatterDimFieldId;
	}

	public String getSortExtField() {
		return sortExtField;
	}

	public void setSortExtField(String sortExtField) {
		this.sortExtField = sortExtField;
	}

	public String getDimExtField() {
		return dimExtField;
	}

	public void setDimExtField(String dimExtField) {
		this.dimExtField = dimExtField;
	}

	public String getScatterDimExtField() {
		return scatterDimExtField;
	}

	public void setScatterDimExtField(String scatterDimExtField) {
		this.scatterDimExtField = scatterDimExtField;
	}
}
