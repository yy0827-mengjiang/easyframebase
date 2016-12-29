package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;

@Element(name = "tmpdatasource")
public class TmpDatasource {

	@Attribute(name = "id")
	 private String id="";
	 
	 @Attribute(name = "name")
	 private String name;
	 
	 @Attribute(name = "extds")
	 private String extds;
	 
	 @Attribute(name = "createtime")
	 private String createtime;
	 
	 @Attribute(name = "creator")
	 private String creator;
	 
	 @Attribute(name = "index")
	 private String index;
	 
	 @Attribute(name="reference")
	 private String reference="";
	 
	 @Attribute(name="kpistoreid")
	 private String kpistoreId="";
	 
	 @Attribute(name="datatype")
	 private String datatype="list";
	 
	 @Text
	 private String sql;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getExtds() {
		return extds;
	}

	public void setExtds(String extds) {
		this.extds = extds;
	}

	public String getCreatetime() {
		return createtime;
	}

	public void setCreatetime(String createtime) {
		this.createtime = createtime;
	}

	public String getCreator() {
		return creator;
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	public String getReference() {
		return reference;
	}

	public void setReference(String reference) {
		this.reference = reference;
	}

	public String getKpistoreId() {
		return kpistoreId;
	}

	public void setKpistoreId(String kpistoreId) {
		this.kpistoreId = kpistoreId;
	}

	public String getSql() {
		return sql;
	}

	public void setSql(String sql) {
		this.sql = sql;
	}

	public String getDatatype() {
		return datatype;
	}

	public void setDatatype(String datatype) {
		this.datatype = datatype;
	}
	 
	 
}
