package cn.com.easy.kpi.element;

import cn.com.easy.jaxb.annotation.Element;
import cn.com.easy.jaxb.annotation.Text;

@Element(name = "condstr")
public class Condstr {
	@Text
	private String condStr;

	public String getCondStr() {
		return condStr;
	}

	public void setCondStr(String condStr) {
		this.condStr = condStr;
	}
	
}
