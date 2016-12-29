package cn.com.easy.down.server;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import cn.com.easy.core.sql.SqlRunner;


public class DownFileRepeatThread implements Runnable{
	@SuppressWarnings("unchecked")
	@Override
	public void run(){
		try {
			generateFile();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			DownQueue.setExcuteFlag(false);
			e.printStackTrace();
			System.err.println("调用tryGenerateFile出错InterruptedException！");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			DownQueue.setExcuteFlag(false);
			e.printStackTrace();
			System.err.println("调用tryGenerateFile出错SQLException！");
		}
	}
	/* 描述：判断并调用生成文件
	 * 参数：无
	 * 返回：无
	 * */
	@SuppressWarnings("unchecked")
	private void generateFile() throws InterruptedException, SQLException{
		Map taskMap=null;
		/*大数据量队列出队调用 开始*/
		String bigQueueType=DownQueue.BIG_DATA_QUEUE_TYPE;
		if(!DownQueue.QueueEmpty(bigQueueType)){//生成文件队列不为空
			if(DownQueue.getAllowExcuteFlag(bigQueueType)){//允许执行（未达到最大并发数）
				taskMap=DownQueue.outQueue(bigQueueType);//出队
				DownQueue.enterExcuteQueue(bigQueueType,taskMap);//放入正在执行的队列中
				if(taskMap.get("id")!=null){//参数id不为null
					System.out.println("执行："+bigQueueType+"："+taskMap.get("id"));
					DownLog.getInstance((SqlRunner)taskMap.get("runner")).log(String.valueOf(taskMap.get("id")), "2", null, String.valueOf(taskMap.get("downPath")),  String.valueOf(taskMap.get("userId")),String.valueOf(taskMap.get("downParams")), String.valueOf(taskMap.get("systemFlag")));
					DownFileGenerateThread downThread=new DownFileGenerateThread(taskMap);
					Thread thread=new Thread(downThread);
					thread.setName(taskMap.get("id").toString());
					thread.start();
					/*向状态列表中添加元素 开始*/
					Map statusValueMap=new HashMap();
					statusValueMap.put("status", "1");
					statusValueMap.put("thread", thread);
					DownQueue.putStatusMap(bigQueueType,taskMap.get("id").toString(),statusValueMap);
					/*向状态列表中添加元素 结束*/
					DownQueue.saveQueueToDatabase(null, (SqlRunner)taskMap.get("runner"));
				}else{
					System.err.println("参数id为null!");
				}
			}
		}
		/*大数据量队列出队调用 结束*/
		
		/*小数据量队列出队调用 开始*/
		String smallQueueType=DownQueue.SMALL_DATA_QUEUE_TYPE;
		if(!DownQueue.QueueEmpty(smallQueueType)){//生成文件队列不为空
			if(DownQueue.getAllowExcuteFlag(smallQueueType)){//允许执行（未达到最大并发数）
				taskMap=DownQueue.outQueue(smallQueueType);//出队
				DownQueue.enterExcuteQueue(smallQueueType,taskMap);//放入正在执行的列表中
				if(taskMap.get("id")!=null){//参数id不为null
					DownLog.getInstance((SqlRunner)taskMap.get("runner")).log(String.valueOf(taskMap.get("id")), "2", null, String.valueOf(taskMap.get("downPath")),  String.valueOf(taskMap.get("userId")), String.valueOf(taskMap.get("downParams")), String.valueOf(taskMap.get("systemFlag")));//记录日志
					DownFileGenerateThread downThread=new DownFileGenerateThread(taskMap);
					Thread thread=new Thread(downThread);
					thread.setName(taskMap.get("id").toString());
					thread.start();
					/*向状态列表中添加元素 开始*/
					Map statusValueMap=new HashMap();
					statusValueMap.put("status", "1");
					statusValueMap.put("thread", thread);
					DownQueue.putStatusMap(smallQueueType,taskMap.get("id").toString(),statusValueMap);
					/*向状态列表中添加元素 结束*/
					DownQueue.saveQueueToDatabase(null, (SqlRunner)taskMap.get("runner"));//持久化队列中元素及执行列表中元素
				}else{
					System.err.println("参数id为null!");
				}
			}
			
		}
		/*小数据量队列出队调用 结束*/
		
		/*设置后续执行动作 开始*/
		if(DownQueue.QueueEmpty(bigQueueType)&&DownQueue.QueueEmpty(smallQueueType)){//队列都为空
			DownQueue.setExcuteFlag(false);//设置线程执行标志为false
		}else{//有队列不为空
			Thread.sleep(1000);
			generateFile();//再次执行本方法（递归）
		}
		/*设置后续执行动作 结束*/
	}
	
	
}