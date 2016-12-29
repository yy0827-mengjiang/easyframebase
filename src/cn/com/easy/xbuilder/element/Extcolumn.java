package cn.com.easy.xbuilder.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;


@Element(name = "extcolumn")
public class Extcolumn {
	
	 @Attribute(name = "id")
	 private String id="";
	 
	 @Attribute(name = "datasourceid")
	 private String datasourceid;
	 
	 @Attribute(name = "formulaid")
	 private String formulaid;
	 
	 @Attribute(name = "name")
	 private String name;
	 
	 @Attribute(name = "formula")
	 private String formula;
	 
	 @Element(name = "param")
	 private List<Param> paramList;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getDatasourceid() {
		return datasourceid;
	}

	public void setDatasourceid(String datasourceid) {
		this.datasourceid = datasourceid;
	}

	public String getFormulaid() {
		return formulaid;
	}

	public void setFormulaid(String formulaid) {
		this.formulaid = formulaid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getFormula() {
		return formula;
	}

	public void setFormula(String formula) {
		this.formula = formula;
	}

	public List<Param> getParamList() {
		return paramList;
	}

	public void setParamList(List<Param> paramList) {
		this.paramList = paramList;
	}
	 

	 
}
