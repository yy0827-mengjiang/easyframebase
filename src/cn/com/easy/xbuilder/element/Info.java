package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "info")
public class Info {
	@Attribute(name = "name")
	private String name;
	@Attribute(name = "type")
	private String type;
	@Attribute(name = "ltype")
	private String ltype;
	@Attribute(name = "url")
	private String url;
	@Attribute(name = "createUser")
	private String createUser;
	@Attribute(name = "createTime")
	private String createTime;
	@Attribute(name = "modifyUser")
	private String modifyUser;
	@Attribute(name = "modifyTime")
	private String modifyTime;
	@Attribute(name = "sizex")
	private String sizex;
	@Attribute(name = "cubeId")
	private String cubeId;
	@Attribute(name = "typeExt")
	private String typeExt;
	
	public String getSizex() {
		return sizex;
	}
	public void setSizex(String sizex) {
		this.sizex = sizex;
	}
	public String getName() {
		return name;
	}
	public Info setName2(String name) {
		this.name = name;
		return this;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	
	public String getLtype() {
		return ltype;
	}
	public void setLtype(String ltype) {
		this.ltype = ltype;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getUrl() {
		return url;
	}
	public Info setUrl2(String url) {
		this.url = url;
		return this;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getCreateUser() {
		return createUser;
	}
	public Info setCreateUser2(String createUser) {
		this.createUser = createUser;
		return this;
	}
	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}
	public String getCreateTime() {
		return createTime;
	}
	public Info setCreateTime2(String createTime) {
		this.createTime = createTime;
		return this;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getModifyUser() {
		return modifyUser;
	}
	public Info setModifyUser2(String modifyUser) {
		this.modifyUser = modifyUser;
		return this;
	}
	public void setModifyUser(String modifyUser) {
		this.modifyUser = modifyUser;
	}
	public String getModifyTime() {
		return modifyTime;
	}
	public Info setModifyTime2(String modifyTime) {
		this.modifyTime = modifyTime;
		return this;
	}
	public void setModifyTime(String modifyTime) {
		this.modifyTime = modifyTime;
	}
	public String getCubeId() {
		return cubeId;
	}
	public void setCubeId(String cubeId) {
		this.cubeId = cubeId;
	}
	public String getTypeExt() {
		return typeExt;
	}
	public void setTypeExt(String typeExt) {
		this.typeExt = typeExt;
	}
}
