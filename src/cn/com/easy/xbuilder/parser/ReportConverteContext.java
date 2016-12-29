package cn.com.easy.xbuilder.parser;
/*
 * 所有转换类的场景类，使用责任链模式，调用所有转换类。
 */
import cn.com.easy.xbuilder.element.Report;

public class ReportConverteContext {
	public Report converter(Report report){
		ReportConverteHandler handlerChangeSql = new ReportConverteHandlerChangeSql();//转换类：转换用户原sql增加扩展查询条件
		
		//ReportConverteHandler handlerXXXX = new ReportConverteHandlerXXXX();//转换类：以后可能会有其他的转换类
		//handlerChangeSql.setNext(handlerXXXX);//把所有的转换类变成责任链模式，自动执行满足条件的所有转换类
		
		return handlerChangeSql.converteHandler(report);//应用final模板模式，简化调用，避免子类的随意覆写造成的不可控
	}
}