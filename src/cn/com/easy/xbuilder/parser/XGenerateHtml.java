package cn.com.easy.xbuilder.parser;
public interface XGenerateHtml{
	public String html(XGenerateComp comp);
	public boolean saveToFile();
	public String getJsp();
	public StringBuffer getPage();
}