package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Attribute;
import cn.com.easy.jaxb.annotation.Element;

@Element(name = "kpi")
public class Kpi {
	
	@Attribute(name = "id")
	private String id;
	
	@Attribute(name = "version")
	private String version;
	
	@Element(name = "dimensions")
	private Dimensions dimensions;
	
	@Element(name = "measures")
	private Measures measures;
	
	@Element(name = "formulas")
	private Formulas formulas;
	
	@Element(name = "conditions")
	private Conditions conditions;

	@Element(name = "selfwhere")
	private SelfWhere selfWhere;
	
	@Element(name = "formulastr")
	private Formulastr formulastr;
	
	@Element(name = "condstr")
	private Condstr condstr;
	

	public Formulastr getFormulastr() {
		return formulastr;
	}

	public void setFormulastr(Formulastr formulastr) {
		this.formulastr = formulastr;
	}

	public Condstr getCondstr() {
		return condstr;
	}

	public void setCondstr(Condstr condstr) {
		this.condstr = condstr;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public Dimensions getDimensions() {
		return dimensions;
	}

	public void setDimensions(Dimensions dimensions) {
		this.dimensions = dimensions;
	}

	public Measures getMeasures() {
		return measures;
	}

	public void setMeasures(Measures measures) {
		this.measures = measures;
	}

	public Formulas getFormulas() {
		return formulas;
	}

	public void setFormulas(Formulas formulas) {
		this.formulas = formulas;
	}

	public Conditions getConditions() {
		return conditions;
	}

	public void setConditions(Conditions conditions) {
		this.conditions = conditions;
	}
	
	public SelfWhere getSelfWhere() {
		return selfWhere;
	}

	public void setSelfWhere(SelfWhere selfWhere) {
		this.selfWhere = selfWhere;
	}
}
