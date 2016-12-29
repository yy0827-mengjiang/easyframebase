package cn.com.easy.xbuilder.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "dimsion")
public class Dimsion {
	@Attribute(name = "id")
	private String id = "";

	@Attribute(name = "type")
	private String type;

	@Attribute(name = "varname")
	private String varname;

	@Attribute(name = "table")
	private String table;

	

	@Attribute(name = "desc")
	private String desc;

	@Attribute(name = "codecolumn")
	private String codecolumn;

	@Attribute(name = "desccolumn")
	private String desccolumn;

	@Attribute(name = "level")
	private String level;

	@Attribute(name = "ordercolumn")
	private String ordercolumn;

	@Attribute(name = "parentcol")
	private String parentcol;
	@Attribute(name = "parentdimname")
	private String parentdimname;

	@Attribute(name = "isselectm")
	private String isselectm;

	@Attribute(name = "index")
	private String index;

	@Element(name = "sql")
	private Sql sql;
	
	@Attribute(name = "createtype")
	private String createtype;
	
	@Attribute(name = "defaultvaluetype")
	private String defaultValueType;
	
	@Attribute(name = "defaultvalue")
	private String defaultvalue;
	
	@Attribute(name = "datasourceid")
	private String datasourceid="";
	
	@Attribute(name = "conditiontype")
	private String conditiontype = "";
	
	@Attribute(name = "vardesc")
	private String vardesc="";
	
	/**
	 * 是否为参数
	 */
	@Attribute(name = "isparame")
	private String isparame;
	/**
	 * 逻辑运算符
	 */
	@Attribute(name = "formula")
	private String formula;
	/**
	 * 显示类型
	 */
	@Attribute(name = "showtype")
	private String showtype;
	/**
	 * fieldid
	 */
	@Attribute(name = "fieldid")
	private String fieldid;
	
	@Attribute(name = "field")
	private String field;
	/**
	 * fieldtype
	 */
	@Attribute(name = "fieldtype")
	private String fieldtype;

	public String getIsparame() {
		return isparame;
	}

	public void setIsparame(String isparame) {
		this.isparame = isparame;
	}

	public String getFormula() {
		return formula;
	}

	public void setFormula(String formula) {
		this.formula = formula;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getVarname() {
		return varname;
	}

	public void setVarname(String varname) {
		this.varname = varname;
	}

	public String getTable() {
		return table;
	}

	public void setTable(String table) {
		this.table = table;
	}

	public String getField() {
		return field;
	}

	public void setField(String field) {
		this.field = field;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public String getCodecolumn() {
		return codecolumn;
	}

	public void setCodecolumn(String codecolumn) {
		this.codecolumn = codecolumn;
	}

	public String getDesccolumn() {
		return desccolumn;
	}

	public void setDesccolumn(String desccolumn) {
		this.desccolumn = desccolumn;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public String getOrdercolumn() {
		return ordercolumn;
	}

	public void setOrdercolumn(String ordercolumn) {
		this.ordercolumn = ordercolumn;
	}

	public String getParentcol() {
		return parentcol;
	}

	public void setParentcol(String parentcol) {
		this.parentcol = parentcol;
	}

	public String getIsselectm() {
		return isselectm;
	}

	public void setIsselectm(String isselectm) {
		this.isselectm = isselectm;
	}

	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	public Sql getSql() {
		return sql;
	}

	public void setSql(Sql sql) {
		this.sql = sql;
	}

	public String getCreatetype() {
		return createtype;
	}

	public void setCreatetype(String createtype) {
		this.createtype = createtype;
	}

	public String getDefaultValueType() {
		return defaultValueType;
	}

	public void setDefaultValueType(String defaultValueType) {
		this.defaultValueType = defaultValueType;
	}

	public String getDefaultvalue() {
		return defaultvalue;
	}

	public void setDefaultvalue(String defaultvalue) {
		this.defaultvalue = defaultvalue;
	}

	public String getShowtype() {
		return showtype;
	}

	public void setShowtype(String showtype) {
		this.showtype = showtype;
	}

	public String getFieldid() {
		return fieldid;
	}

	public void setFieldid(String fieldid) {
		this.fieldid = fieldid;
	}

	public String getFieldtype() {
		return fieldtype;
	}

	public void setFieldtype(String fieldtype) {
		this.fieldtype = fieldtype;
	}

	public String getParentdimname() {
		return parentdimname;
	}

	public void setParentdimname(String parentdimname) {
		this.parentdimname = parentdimname;
	}

	public String getDatasourceid() {
		return datasourceid;
	}

	public void setDatasourceid(String datasourceid) {
		this.datasourceid = datasourceid;
	}

	public String getConditiontype() {
		return conditiontype;
	}

	public void setConditiontype(String conditiontype) {
		this.conditiontype = conditiontype;
	}

	public String getVardesc() {
		return vardesc;
	}

	public void setVardesc(String vardesc) {
		this.vardesc = vardesc;
	}

	
	

}
