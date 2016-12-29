package cn.com.easy.down.server.export;

/*
 * 层级架构模式：
 * 划分5层结构：视图层，输入层，传输层，队列层，导出层5层。调用顺序为依次向下，返回也是依次向上，不能越级访问，每一层只关心上层的输入和自己得输出。
 * 
 * 每层具体实现：
 * 视图层：图表组件显示导出按钮，任务页面，收集参数，提醒，跳转到任务页面。
 * 输入层：获得参数，初始化配置（如数据源），恢复任务（重启tomcat），过滤重复的请求（重复下载请求），保存到数据库，获得当前用户下载信息，取消下载，删除文件，打包信息调用传输层。
 * 传输层：客户端、服务端、压缩信息、传输信息、调用队列层。
 * 队列层：解压信息、维护双队列
 * 导出层：导出文件。以门面+策略+工厂模式实现。
 * 	1、将多种文件的导出定义为多种策略，根据用户的选择，执行相应的策略。
 *  2、共有10种策略，用工厂模式来管理策略的创建。
 *  3、以门面模式封装策略的创建、执行过程，为上层提供简单唯一的接口。
 */

public class StrategyFacade {
	public String service(ArgsBean args){
		Strategy strategy = StrategyFactory.build(args);
		if(null == strategy){
			return null;
		}
		StrategyContext context = new StrategyContext(strategy);
		try {
			return context.export(args);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}