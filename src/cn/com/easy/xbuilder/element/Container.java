package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "container")
public class Container {
// id="唯一id" type="基础/切换/选项卡" title="标题" class="" pop="id"
	@Attribute(name = "id")
	private String id;
	@Attribute(name = "type")
	private String type;
	@Attribute(name = "title")
	private String title;
	@Attribute(name = "class")
	private String containerClass;
	@Attribute(name = "pop")
	private String pop;
	@Attribute(name = "bgclass")
	private String bgclass;
	@Attribute(name = "styleclass")
	private String styleclass;
	@Attribute(name = "width")
	private String width;
	@Attribute(name = "height")
	private String height;
	
	@Element(name = "components")
	private Components components;
	public String getId() {
		return id;
	}
	public Container setId2(String id) {
		this.id = id;
		return this;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getType() {
		return type;
	}
	public Container setType2(String type) {
		this.type = type;
		return this;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getTitle() {
		return title;
	}
	public Container setTitle2(String title) {
		this.title = title;
		return this;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContainerClass() {
		return containerClass;
	}
	public Container setContainerClass2(String containerClass) {
		this.containerClass = containerClass;
		return this;
	}
	public void setContainerClass(String containerClass) {
		this.containerClass = containerClass;
	}
	public String getPop() {
		return pop;
	}
	public Container setPop2(String pop) {
		this.pop = pop;
		return this;
	}
	public void setPop(String pop) {
		this.pop = pop;
	}
	public Components getComponents() {
		return components;
	}
	public Container setComponents2(Components components) {
		this.components = components;
		return this;
	}
	public void setComponents(Components components) {
		this.components = components;
	}
	public String getBgclass() {
		return bgclass;
	}
	public Container setBgclass2(String bgclass) {
		this.bgclass = bgclass;
		return this;
	}
	
	public String getStyleclass() {
		return styleclass;
	}
	public void setStyleclass(String styleclass) {
		this.styleclass = styleclass;
	}
	public void setBgclass(String bgclass) {
		this.bgclass = bgclass;
	}
	public String getWidth() {
		return width;
	}
	public void setWidth(String width) {
		this.width = width;
	}
	public String getHeight() {
		return height;
	}
	public void setHeight(String height) {
		this.height = height;
	}
}
