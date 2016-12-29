package cn.com.easy.xbuilder.parser;

public class XDirector{
private Builder builder; 
	public XDirector(Builder builder) { 
		this.builder = builder; 
	} 
	public Generate construct(){ 
		builder.buildHtml();
		builder.buildComp();
		builder.buildAction();
		builder.builMeta();
		return builder.getGenerate();
	}
}
