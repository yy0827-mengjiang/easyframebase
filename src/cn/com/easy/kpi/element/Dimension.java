/**
 * <!--基础维度定义-->
 *	<dimensions>
 *			<dimension id="维度ID" name="维度名称" alias="别名（可选）" tableLink="来源表" columnLink="来源列" formatType="维度类型 0日/1月/2其他">
 *				 <dictionary key="主键" name="显示文本">
 *							<![CDATA[
 *							 select key, value from dual
 *							]]> 
 *					</dictionary>
 *			</dimension>
 *	</dimensions>
 */
package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "dimension")
public class Dimension {

	@Attribute(name = "id")
	private String id;
	
	@Attribute(name = "name")
	private String name;
	
	@Attribute(name = "alias")
	private String alias;
	
	@Attribute(name = "tableLink")
	private String tableLink;
	
	@Attribute(name = "columnLink")
	private String columnLink;
	
	@Attribute(name = "formatType")
	private String formatType;
	
	@Element(name="dictionary")
	private Dictionary dictionary;
	
	@Attribute(name="conftype")
	private String confType;
	
	@Attribute(name="datasource")
	private String dataSource;
	
	@Attribute(name = "dimType")
	private String dimType;
	
	public String getDimType() {
		return dimType;
	}

	public void setDimType(String dimType) {
		this.dimType = dimType;
	}

	public String getDataSource() {
		return dataSource;
	}

	public void setDataSource(String dataSource) {
		this.dataSource = dataSource;
	}

	public String getConfType() {
		return confType;
	}

	public void setConfType(String confType) {
		this.confType = confType;
	}

	public Dictionary getDictionary() {
		return dictionary;
	}

	public void setDictionary(Dictionary dictionary) {
		this.dictionary = dictionary;
	}

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

	public String getAlias() {
		return alias;
	}

	public void setAlias(String alias) {
		this.alias = alias;
	}

	public String getTableLink() {
		return tableLink;
	}

	public void setTableLink(String tableLink) {
		this.tableLink = tableLink;
	}

	public String getColumnLink() {
		return columnLink;
	}

	public void setColumnLink(String columnLink) {
		this.columnLink = columnLink;
	}

	public String getFormatType() {
		return formatType;
	}

	public void setFormatType(String formatType) {
		this.formatType = formatType;
	}
}
