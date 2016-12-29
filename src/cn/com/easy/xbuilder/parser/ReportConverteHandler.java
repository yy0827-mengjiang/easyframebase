package cn.com.easy.xbuilder.parser;
/*
 * 生成jsp时，需要对report对象进行转换，此类为所有转换类的父类
 * 使用责任链模式+模板模式，且模板方法为final，避免子类的随意覆写造成的不可控
 */
import cn.com.easy.xbuilder.element.Report;

public abstract class ReportConverteHandler {
	private ReportConverteHandler nextHandler;

	public final Report converteHandler(Report report) {
		if (this.getHandlerCondition(report)) {
			report = this.converte(report);
		}
		
		if (this.nextHandler != null) {
			report = this.nextHandler.converteHandler(report);
		}
		
		return report;
	}

	public void setNext(ReportConverteHandler _handler) {
		this.nextHandler = _handler;
	}
	protected abstract Boolean getHandlerCondition(Report report);
	protected abstract Report converte(Report report);
}