package cn.com.easy.xbuilder.rmi;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.PropertyResourceBundle;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpSession;

import cn.com.easy.core.sql.SqlRunner;
//import cn.com.easy.exception.RmiNetworkException;
import cn.com.easy.rmi.EasyRmi;
import cn.com.easy.taglib.function.Functions;

public class SyncJspRmiServer {

	private ExecutorService executorService;
	
	public SyncJspRmiServer() {
		executorService = Executors.newFixedThreadPool(4);
	}
    
	
	/**
	 * 通过rmi调用集群中其他服务器的同步jsp方法
	 * @param runner
	 * @param paramMap
	 */
	@SuppressWarnings({ "deprecation", "rawtypes", "unchecked" })
	public void synUsePageFile(SqlRunner runner, Map<String,Object> paramMap,HttpSession session) {
		String sql = runner.sql("xbuilder.component.clusterList"); // 查询所有的应用服务器地址
		PropertyResourceBundle propertyFileResource = (PropertyResourceBundle) PropertyResourceBundle.getBundle("framework");
		String localRmiLocation = propertyFileResource.getString("localRmiLocation");// 本机rmi地址
		localRmiLocation = localRmiLocation == null ? "" : localRmiLocation.trim();
		List<Map> locationList = null;
		try {
			locationList = (List<Map>) runner.queryForMapList(sql);
		} catch (Exception e) {
			System.err.println("查询集群服务器时地址出错！");
			session.setAttribute("isSyncFinished", "1");
			session.setAttribute("syncErrMsg", "同步失败:查询集群服务器时地址出错！");
			e.printStackTrace();
		}
		String location = "";
		if (locationList != null&&locationList.size()>0) {
			for (Map map : locationList) {
				location = String.valueOf(map.get("LOCATION"));
				if (location.equals(localRmiLocation)&&!"all".equals(paramMap.get("reportId"))) {
					continue;
				}
				EasyRmi rmi = new EasyRmi(location);
				paramMap.put("from", localRmiLocation);
				paramMap.put("to", location);
				Map newMap = new HashMap<String,String>();
				newMap.put("from", paramMap.get("from"));
				newMap.put("to", paramMap.get("to"));
				newMap.put("reportId",paramMap.get("reportId"));
				newMap.put("versionId",paramMap.get("versionId"));
				newMap.put("createUser",paramMap.get("createUser"));
				executorService.execute(new InvokeRmiHandler(rmi, newMap));
			}
			executorService.shutdown();
			try {
				executorService.awaitTermination(Long.MAX_VALUE, TimeUnit.SECONDS);//等待所有子线程执行完毕
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			session.setAttribute("syncErrMsg", "");
			session.setAttribute("isSyncFinished", "1");//设置是否完成同步标识为1
		}else{
			System.err.println("没有配置集群信息表 X_CLUSTER_INFO！");
			session.setAttribute("isSyncFinished", "1");
			session.setAttribute("syncErrMsg", "同步失败：没有配置集群信息表 X_CLUSTER_INFO！");
		}
	}

	/**
	 * 写同步日志
	 * @param paramMap
	 */
	@SuppressWarnings("deprecation")
	public void writeSynLog(Map<String,Object> paramMap){
		try {
			SqlRunner runner = new SqlRunner();
			runner.execute("insert into X_JSP_SYNC_LOG(XID,SYS_FROM,SYS_TO,VERSION,RESULT,CREATE_USER,CREATE_TIME,DEMO) "
					+ "values(#reportId#,#from#,#to#,%{versionId},#result#,#createUser#,'"+Functions.getDate("yyyyMMddHHmmss")+"',#demo#)",paramMap);
		} catch (SQLException e) {
			System.err.println("写日志表时发生错误！");
			e.printStackTrace();
		}
	}
	
	/**
	 * 调用rmi线程
	 */
	class InvokeRmiHandler implements Runnable {
		private EasyRmi rmi;
		private Map<String, Object> paramMap;
		private String METHOD = "xbuilder.rmi.syncJspRmi.syncJsp";
		public InvokeRmiHandler(EasyRmi rmi, Map<String, Object> paramMap) {
			this.rmi = rmi;
			this.paramMap = paramMap;
		}
		@Override
		public void run() {
			try {
				rmi.invoke(this.METHOD, this.paramMap);
			} 
//			catch (RmiNetworkException e) {
//				e.printStackTrace();
//				this.paramMap.put("result", "2");
//				this.paramMap.put("demo", e.getMessage());
//				writeSynLog(this.paramMap);//保存错误日志，错误类型为2，与网络相关错误
//			} 
			catch(Exception e){
				e.printStackTrace();
				this.paramMap.put("result", "3");
				this.paramMap.put("demo", e.getMessage());
				writeSynLog(this.paramMap);//保存错误日志，错误类型为3，其他错误
			}
		}
	}
	
}
