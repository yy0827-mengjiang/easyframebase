package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "datasources")
public class Datasources {
	
	@Element(name = "datasource")
	private List<Datasource> datasourceList;

	public List<Datasource> getDatasourceList() {
		return datasourceList;
	}

	public void setDatasourceList(List<Datasource> datasourceList) {
		this.datasourceList = datasourceList;
	}

	
}
