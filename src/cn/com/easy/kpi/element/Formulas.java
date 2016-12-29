package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Element;

@Element(name = "formulas")
public class Formulas {

	@Element(name = "formula")
	private Formula formula;

	public Formula getFormula() {
		return formula;
	}

	public void setFormula(Formula formula) {
		this.formula = formula;
	}
}
