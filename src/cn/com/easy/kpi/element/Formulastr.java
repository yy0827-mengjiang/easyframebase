package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;

@Element(name = "formulastr")
public class Formulastr {
	@Text
	private String formulaStr;

	public String getFormulaStr() {
		return formulaStr;
	}

	public void setFormulaStr(String formulaStr) {
		this.formulaStr = formulaStr;
	}
	
}
