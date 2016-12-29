package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;

@Element(name= "dictionary")
public class Dictionary {
	
	@Attribute(name="key")
	private String key;
	
	@Attribute(name="name")
	private String name;
	
	@Attribute(name="tableLink")
	private String tableLink;
	
	@Text
	private String dictionary;
	
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDictionary() {
		return dictionary;
	}
	public void setDictionary(String dictionary) {
		this.dictionary = dictionary;
	}
	public String getTableLink() {
		return tableLink;
	}
	public void setTableLink(String tableLink) {
		this.tableLink = tableLink;
	}
}
