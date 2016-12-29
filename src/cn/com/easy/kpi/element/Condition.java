package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;
@Element(name = "condition")
public class Condition {
	
	@Attribute(name = "source")
	private String source;
	
	@Attribute(name = "type")
	private String type;
	
	@Attribute(name = "prepend")
	private String prepend;

	@Attribute(name="operator")
	private String operator;
	
	@Attribute(name="paramsType")
	private String paramsType;
	
	@Attribute(name="paramsValue")
	private String paramsValue;
	
	@Attribute(name="dataType")
	private String dataType;
	
	@Attribute(name="paramId")
	private String paramId;
	
	@Element(name = "relation")
	private Relation relation;

	@Text
	private String condition;
	//@Element(name = "compose")
	//private Compose compose;
	
	public String getCondition() {
		return condition;
	}

	public void setCondition(String condition) {
		this.condition = condition;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getPrepend() {
		return prepend;
	}

	public void setPrepend(String prepend) {
		this.prepend = prepend;
	}

	public Relation getRelation() {
		return relation;
	}

	public void setRelation(Relation relation) {
		this.relation = relation;
	}

	public String getOperator() {
		return operator;
	}

	public void setOperator(String operator) {
		this.operator = operator;
	}

	public String getParamsType() {
		return paramsType;
	}

	public void setParamsType(String paramsType) {
		this.paramsType = paramsType;
	}

	public String getParamsValue() {
		return paramsValue;
	}

	public void setParamsValue(String paramsValue) {
		this.paramsValue = paramsValue;
	}

	public String getDataType() {
		return dataType;
	}

	public void setDataType(String dataType) {
		this.dataType = dataType;
	}

	public String getParamId() {
		return paramId;
	}

	public void setParamId(String paramId) {
		this.paramId = paramId;
	}
}
