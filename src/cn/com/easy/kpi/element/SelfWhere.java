package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;
@Element(name = "selfwhere")
public class SelfWhere {
	@Text
	private String seflCondition;

	public String getSeflCondition() {
		return seflCondition;
	}

	public void setSeflCondition(String seflCondition) {
		this.seflCondition = seflCondition;
	}
	
}
