package cn.com.easy.down.server;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
/*单例模式*/
public class DownLog{
	private static DownLog downLog=new DownLog();
	private SqlRunner runner;
	private DownLog(){
	}
	
	/* 描述：获取实例
	 * 参数：无
	 * 返回：DownLog对象
	 * */
	public static DownLog getInstance(SqlRunner runner){
		downLog.runner=runner;
		return downLog;
	}
	
	/* 描述：记录导出相关日志信息
	 * 参数：
	 * 		id 导出标识
	 * 		status 状态
	 * 		fileName 导出时默认名称
	 * 		filePath 生成文件的路径
	 * 		userId 操作人编码
	 * 		systemFlag 客户端标识
	 * 返回：无
	 * */
	public void log(String id,String status,String fileName,String filePath,String userId,String downParamsStr,String systemFlag){
			Map<String, String> paramMap=new HashMap<String, String>();
			paramMap.put("id", id);
			paramMap.put("fileName", fileName);
			paramMap.put("status", status);
			paramMap.put("filePath", filePath);
			paramMap.put("userId", userId);
			paramMap.put("downParamsStr", downParamsStr);
			paramMap.put("systemFlag", systemFlag);
			log(paramMap);

	}
	
	/* 描述：记录导出相关日志信息
	 * 参数：
	 * 		paramMap 参数键值对，内容如下：
	 * 							id 导出标识
	 * 							status 状态
	 * 							fileName 导出时默认名称
	 * 							filePath 生成文件的路径
	 * 							userId 操作人编码
	 * 							systemFlag 客户端标识
	 * 返回：无
	 * */
	@SuppressWarnings("unchecked")
	public void log(Map paramMap){
		try {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			Date date = new Date();
			String currentTime=formatter.format(date);
			String qSql = "";
			String dbType = (String)EasyContext.getContext().getServletcontext().getAttribute("DBSource");
			switch(dbType){
			case "oracle":
				qSql = "SELECT E_EXPORT_LOG_SEQ.nextval||'' as \"NEXT_LOG_ID\" FROM DUAL";
				break;
			case "postgreSql":
				qSql = "SELECT nextval('E_EXPORT_LOG_SEQ')||'' as \"NEXT_LOG_ID\" FROM DUAL";
				break;
			default:
				qSql = "SELECT E_EXPORT_LOG_SEQ.nextval||'' as \"NEXT_LOG_ID\" FROM DUAL";
			}
			Map<String, String> initMap = (Map<String,String> ) runner.queryForMap(qSql);
			String nextLogId=initMap.get("NEXT_LOG_ID");
			paramMap.put("currentTime", currentTime);
			paramMap.put("logId", nextLogId);
			String status=String.valueOf(paramMap.get("status"));
			if("1".equals(status.trim())){//队列中
				runner.execute("DELETE FROM  E_EXPORTING_INFO WHERE ID=#id#", paramMap);
				runner.execute("DELETE FROM  E_EXPORT_LOG WHERE EXPORTING_ID=#id#", paramMap);
				runner.execute("INSERT INTO E_EXPORTING_INFO(ID,FILE_NAME,STATUS_ID,FILE_TYPE,OPT_USER,OPT_TIME,DOWN_PARAM_STR,SYSTEM_FLAG) VALUES(#id#,#fileName#,#status#,#filePath#,#userId#,#currentTime#,#downParamsStr#,#systemFlag#)", paramMap);
			}else if("2".equals(status.trim())){//生成中
				runner.execute("UPDATE E_EXPORTING_INFO SET STATUS_ID=#status# WHERE ID=#id#", paramMap);
			}else if("3".equals(status.trim())){//取消生成
				runner.execute("UPDATE E_EXPORTING_INFO SET STATUS_ID=#status# WHERE ID=#id#", paramMap);
			}else if("99".equals(status.trim())){//发生错误
				runner.execute("UPDATE E_EXPORTING_INFO SET STATUS_ID=#status# WHERE ID=#id#", paramMap);
			}else{
				runner.execute("UPDATE E_EXPORTING_INFO SET STATUS_ID=#status#,FILE_PATH=#filePath# WHERE ID=#id#", paramMap);
			}
			runner.execute("INSERT INTO E_EXPORT_LOG(ID,EXPORTING_ID,STATUS_ID,OPT_TIME) VALUES(#logId#,#id#,#status#,#currentTime#)", paramMap);
		} catch (SQLException e) {
			System.err.println("记录导出日志异常，id为"+paramMap.get("id"));
			e.printStackTrace();
		}
		
		
	}
	

}
