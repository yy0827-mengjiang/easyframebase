package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "event")
public class Event {
	@Attribute(name = "id")
	private String id;
	
	@Attribute(name = "source")
	private String source;
	
	@Element(name = "parameter")
	private List<Parameter> parameterList;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public List<Parameter> getParameterList() {
		return parameterList;
	}
	public void setParameterList(List<Parameter> parameterList) {
		this.parameterList = parameterList;
	}
}
