package cn.com.easy.xbuilder.parser;

import java.util.HashMap;
import java.util.Map;

public interface XGenerateComp {
	public Map<String,String> compList = new HashMap<String,String>();
	public String comp(XGenerateHtml xhtml);
}