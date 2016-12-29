package cn.com.easy.kpi.element;

import java.util.List;

import cn.com.easy.jaxb.annotation.Element;


@Element(name = "conditions")
public class Conditions {

	@Element(name = "condition")
	private List<Condition> conditionList;

	@Element(name = "expression")
	private Expression expression;
	
	public Expression getExpression() {
		return expression;
	}

	public void setExpression(Expression expression) {
		this.expression = expression;
	}

	public List<Condition> getConditionList() {
		return conditionList;
	}

	public void setConditionList(List<Condition> conditionList) {
		this.conditionList = conditionList;
	}

	
	
}
