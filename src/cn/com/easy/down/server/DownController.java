package cn.com.easy.down.server;

import java.io.File;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import cn.com.easy.core.sql.SqlRunner;
/*单例模式*/
public class DownController{
	private static DownController downController=new DownController();
	private DownController(){
	}
	
	/* 描述：获取实例
	 * 参数：无
	 * 返回：DownController对象
	 * */
	public static DownController getInstance(){
		return downController;
	}
	
	/* 描述：判断并调用生成文件线程
	 * 参数：无
	 * 返回：无
	 * */
	@SuppressWarnings("unchecked")
	public synchronized void tryGenerateFile(){
		if(!DownQueue.getExcuteFlag()){//线程执行标志为假
			DownFileRepeatThread downFileRepeatThread=new DownFileRepeatThread();
			Thread thread=new Thread(downFileRepeatThread);
			thread.start();//启动线程
		}
	}
	
	
	/* 描述：移除生成文件任务的状态信息
	 * 参数：
	 * 		key 生成文件任务的标识
	 * 返回：boolean(true/false)
	 * */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public void stopGenerateFile(String key,SqlRunner runner) throws SQLException{
		String dataQueueType=DownQueue.BIG_DATA_QUEUE_TYPE;
		/*清除队列中元素 开始*/
		List<Map> queueList=DownQueue.getLinkedList(dataQueueType);
		Iterator<Map> iterator=queueList.iterator();
		Map quequeMap=null;
		while(iterator.hasNext()){
			quequeMap=iterator.next();
			if(quequeMap!=null&&key.equals(String.valueOf(quequeMap.get("id")))){
				iterator.remove();
				break;
			}
		}
		/*清除队列中元素 结束*/
		/*清除状态列表中元素并停止生成线程 开始*/
		Map<String,Map> tempMap=DownQueue.getOneStatusMap(dataQueueType, key);//从大数据量任务队列中取状态元素
		if(tempMap==null||tempMap.get("status")==null){
			 tempMap=DownQueue.getOneStatusMap(DownQueue.SMALL_DATA_QUEUE_TYPE, key);//从小数据量任务队列中取状态元素
			 dataQueueType=DownQueue.SMALL_DATA_QUEUE_TYPE;
		}
		if(tempMap!=null&&tempMap.get("status")!=null){
			Thread thread=null;
			if(tempMap.get("thread")!=null){//状态元素中线程实例不为空
				thread=(Thread) tempMap.get("thread");
			}
			if(thread!=null&&thread.isAlive()){
				thread.stop();
			}
			DownQueue.removeStatusMap(dataQueueType, key);//清除队列中元素状态
		}
		/*清除状态列表中元素并停止生成线程 结束*/
		DownLog.getInstance(runner).log(key, "3", null, null,  null,null, null);//记录日志
        DownQueue.outExcuteQueue(dataQueueType,key);//清除执行列表中元素
		DownQueue.saveQueueToDatabase(null, runner);//持久化队列中元素及执行列表中元素

		
	}
	/**
	 * 删除已经生成的文件
	 * @param id:生成文件任务的标识
	 * @param runner
	 */
	public void deleteFile(String id, SqlRunner runner) throws Exception{
		Map<String, String> map = (Map<String, String>)runner.queryForMap("SELECT FILE_NAME as \"FILE_NAME\",FILE_PATH as \"FILE_PATH\" FROM e_exporting_info WHERE ID='"+id+"'");
		if(null==map){
			System.out.println("数据库中无记录！");
		}else{
			String filePath=map.get("FILE_PATH");
			if(null!=filePath&&!"".endsWith(filePath)){
				File file = new File(filePath);
				//文件存在则删除
				if (file.isFile() && file.exists()) {   
					Boolean flag = file.delete();
					if(filePath.endsWith(".xlsx")){
						File file_0 = new File(filePath.substring(0, filePath.lastIndexOf("."))+"_0.xls");
						if(file_0.isFile() && file_0.exists()){
							file_0.delete();
						}
					}
					System.out.println("删除文件"+filePath+"成功！");
					//删除文件成功，删除info和log
					if(flag){
						 StringBuffer sqlBuff = new StringBuffer();
						 sqlBuff.append("delete from e_exporting_info where id='"+id+"';");
						 sqlBuff.append("delete from e_export_log t where t.exporting_id='"+id+"'");
						 int n = runner.executet(String.valueOf(sqlBuff),new HashMap());
						 if(n>0){
							 System.out.println("删除日志和数据记录成功！");
						 }else{
							 System.out.println("数据库中无记录和日志！");
						 }
					}
				}else{
					System.out.println("文件不存在！");
					StringBuffer sqlBuff = new StringBuffer();
					sqlBuff.append("delete from e_exporting_info where id='"+id+"';");
					sqlBuff.append("delete from e_export_log t where t.exporting_id='"+id+"'");
					int n = runner.executet(String.valueOf(sqlBuff),new HashMap());
					if(n>0){
						System.out.println("删除日志和数据记录成功！");
					}else{
						System.out.println("数据库中无记录和日志！");
					}
				}   
			}else{
				StringBuffer sqlBuff = new StringBuffer();
				sqlBuff.append("delete from e_exporting_info where id='"+id+"';");
				sqlBuff.append("delete from e_export_log t where t.exporting_id='"+id+"'");
				int n = runner.executet(String.valueOf(sqlBuff),new HashMap());
				if(n>0){
					System.out.println("删除日志和数据记录成功！");
				}else{
					System.out.println("数据库中无记录和日志！");
				}
			}
		}
	}
	@SuppressWarnings("unchecked")
	public static void main(String []args){
		
		/*
		MaxExcelRow
		MaxPdfRow
		PdfWaterMark=true
		WaterMarkText=login_id(实际值)
		WaterMarkTextAddedTime=true
		WaterMarkPosition=100,400
		WaterMarkColor=blue
		WaterMarkFontSize=30
		WaterMarkRotate=45
		WaterMarkOpacit=0.6f
		
		
		fileType（excel/pdf）
		downSql
		downDb(扩展数据源名称，与服务器端一致)
		id(uuid)
		jsonData
		fileName(title)
		columns
		commentType(table/chart)
		svgCode
		
		downPath
		runner
		markInfo(map)
		
		*/
		
	}

}
