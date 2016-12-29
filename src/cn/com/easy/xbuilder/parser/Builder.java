package cn.com.easy.xbuilder.parser;
/*
 * 使用建造者模式，屏蔽生成jsp时，访问者模式中类创建的复杂情况。
 * chenfuquan
 */
public interface Builder {
	public void buildHtml();
	public void buildComp();
	public void buildAction(); 
	public Generate getGenerate();
	public void builMeta();
}
