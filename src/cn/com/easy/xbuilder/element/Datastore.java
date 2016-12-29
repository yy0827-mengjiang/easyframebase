package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "datastore")
public class Datastore {

	@Element(name = "datacol")
	private List<Datacol> datacolList;

	public List<Datacol> getDatacolList() {
		return datacolList;
	}

	public void setDatacolList(List<Datacol> datacolList) {
		this.datacolList = datacolList;
	}

	
	

}
