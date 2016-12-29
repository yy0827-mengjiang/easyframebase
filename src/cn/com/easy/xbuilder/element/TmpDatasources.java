package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "tmpdatasources")
public class TmpDatasources {

	@Element(name = "tmpdatasource")
	private List<TmpDatasource> tmpdatasourceList;

	public List<TmpDatasource> getTmpdatasourceList() {
		return tmpdatasourceList;
	}

	public void setTmpdatasourceList(List<TmpDatasource> tmpdatasourceList) {
		this.tmpdatasourceList = tmpdatasourceList;
	}
	
	
}
