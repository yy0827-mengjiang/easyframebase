package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "kpistore")
public class Kpistore {
	
	@Attribute(name = "id")
	private String id;
	
	@Element(name = "kpistorecol")
	private List<KpistoreCol> kpistorecolList;

	public List<KpistoreCol> getKpistorecolList() {
		return kpistorecolList;
	}

	public void setKpistorecolList(List<KpistoreCol> kpistorecolList) {
		this.kpistorecolList = kpistorecolList;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	

}
