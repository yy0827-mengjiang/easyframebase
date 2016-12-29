package cn.com.easy.down.server;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.down.server.export.ArgsBean;
import cn.com.easy.down.server.export.StrategyFacade;

public class DownFileGenerateThread implements Runnable{
	private final ArgsBean bean;
	private String queueType;
	private String userId;
	private String downParamsStr;
	private String systemFlag;
	@SuppressWarnings("unchecked")
	public DownFileGenerateThread(Map<String,Object> args) {
		this.queueType= args.get("queueType")==null?null:String.valueOf(args.get("queueType"));
		this.userId= args.get("userId")==null?null:String.valueOf(args.get("userId"));
		this.systemFlag= args.get("userId")==null?null:String.valueOf(args.get("systemFlag"));
		this.downParamsStr=args.get("downParams")==null?null:String.valueOf(args.get("downParams"));
		this.bean = new ArgsBean((SqlRunner)args.get("runner"),
			args.get("maxRow")==null?null:String.valueOf(args.get("maxRow")),
			args.get("downPath")==null?null:String.valueOf(args.get("downPath")),
			args.get("downSql")==null?null:String.valueOf(args.get("downSql")),
			args.get("downDb")==null?null:String.valueOf(args.get("downDb")),
			args.get("parameters")==null?null:(Map<String,String>)args.get("parameters"),
			(HashMap)args.get("markInfo"),
			args.get("dataType")==null?null:String.valueOf(args.get("dataType")),
			args.get("fileType")==null?null:String.valueOf(args.get("fileType")),
			args.get("jsonData")==null?null:String.valueOf(args.get("jsonData")),
			args.get("fileName")==null?null:String.valueOf(args.get("fileName")),
			args.get("columns")==null?null:String.valueOf(args.get("columns")),
			args.get("commentType")==null?null:String.valueOf(args.get("commentType")),
			args.get("svgCode")==null?null:String.valueOf(args.get("svgCode")),
			(String)args.get("id"));
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void run(){
		try {
			StrategyFacade facade = new StrategyFacade();
			String code = facade.service(this.bean);
			
			if(null != code){
				finishNotice();
				DownLog.getInstance(this.bean.getRunner()).log(this.bean.getUuid(), "4", this.bean.getFileName(),code,  userId, downParamsStr,systemFlag);
			}else{
				errorNotice();
				DownLog.getInstance(this.bean.getRunner()).log(this.bean.getUuid(), "99", this.bean.getFileName(), null,  userId, downParamsStr,systemFlag);//记录错误日志
			}
		} catch (Exception e) {
			try {
				errorNotice();
				DownLog.getInstance(this.bean.getRunner()).log(this.bean.getUuid(), "99", this.bean.getFileName(), null,  userId, downParamsStr,systemFlag);//记录错误日志
			} catch (SQLException e1) {
				e1.printStackTrace();
				System.err.println("生成文件时记录错误日志出错（cn.com.easy.down.server.DownFileGenerateThread）");
			}
			e.printStackTrace();
		}
	}

	/**
	 * 通知下载队列，文件生成完成
	 * @throws SQLException 
	 */
	@SuppressWarnings("unchecked")
	private void finishNotice() throws SQLException{
		Map statusValueMap = DownQueue.getOneStatusMap(queueType,this.bean.getUuid());
		if(statusValueMap==null){
			statusValueMap=new HashMap();
		}
        statusValueMap.put("status", "-1");
        DownQueue.putStatusMap(queueType,this.bean.getUuid(),statusValueMap);
        DownQueue.outExcuteQueue(queueType,this.bean.getUuid());
        DownQueue.saveQueueToDatabase(null, this.bean.getRunner());
        
	}
	/**
	 * 通知队列，发生错误
	 * @throws SQLException 
	 */
	@SuppressWarnings("unchecked")
	private void errorNotice() throws SQLException{
		Map statusValueMap = DownQueue.getOneStatusMap(queueType,this.bean.getUuid());
		if(statusValueMap==null){
			statusValueMap=new HashMap();
		}
        statusValueMap.put("status", "-2");
        DownQueue.putStatusMap(queueType,this.bean.getUuid(),statusValueMap);
        DownQueue.outExcuteQueue(queueType,this.bean.getUuid());
        DownQueue.saveQueueToDatabase(null, this.bean.getRunner());
        
	}
}