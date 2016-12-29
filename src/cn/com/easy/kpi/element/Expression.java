package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;
@Element(name = "expression")
public class Expression {

	@Text
	private String expression;

	public String getExpression() {
		return expression;
	}

	public void setExpression(String expression) {
		this.expression = expression;
	}
}
