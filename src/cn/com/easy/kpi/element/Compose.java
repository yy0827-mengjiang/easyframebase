package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "compose")
public class Compose {

	@Attribute(name = "paramsType")
	private String paramsType;
	
	@Attribute(name = "operator")
	private String operator;
	
	@Attribute(name = "paramsValue")
	private String paramsValue;
	
	@Attribute(name = "dataType")
	private String dataType;

	public String getParamsType() {
		return paramsType;
	}

	public void setParamsType(String paramsType) {
		this.paramsType = paramsType;
	}

	public String getOperator() {
		return operator;
	}

	public void setOperator(String operator) {
		this.operator = operator;
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
	
}
