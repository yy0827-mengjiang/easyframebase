package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;

@Element(name = "sql")
public class Sql {
	
	@Attribute(name = "extds")
	private String extds = "";
	
	@Text
	private String sql;
	
	public String getExtds() {
		return extds;
	}

	public void setExtds(String extds) {
		this.extds = extds;
	}

	public String getSql() {
		return sql;
	}

	public void setSql(String sql) {
		this.sql = sql;
	}

}
