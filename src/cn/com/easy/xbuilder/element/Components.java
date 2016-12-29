package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;
@Element(name = "components")
public class Components {
	@Element(name = "component")
	private List<Component> componentList;

	public List<Component> getComponentList() {
		return componentList;
	}

	public void setComponentList(List<Component> componentList) {
		this.componentList = componentList;
	}

	
}
