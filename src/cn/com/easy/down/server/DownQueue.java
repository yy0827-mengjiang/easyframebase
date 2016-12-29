package cn.com.easy.down.server;

import java.sql.SQLException;
import java.util.LinkedList;
import java.util.Map;

import cn.com.easy.core.sql.SqlRunner;

public class DownQueue {
	
	public static final String BIG_DATA_QUEUE_TYPE="1";
	public static final String SMALL_DATA_QUEUE_TYPE="2";
	/*线程执行标志*/
	public static boolean dataQueueExcuteFlag=false;
	/*任务执行日期（8位）*/
	public static String lastExcuteDateStr=null;
	/*
	 * 描述：获取全部队列
	 * 参数：
	 * 		queueType 队列类型
	 * 返回：LinkedList<Map>
	 * */
	@SuppressWarnings("unchecked")
	public static LinkedList<Map> getLinkedList(String queueType){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueBigData.getLinkedList();
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueSmallData.getLinkedList();
		}else{
			System.err.println("未找到指定的队列类型");
			return null;
		}
	}
	
	/*
	 * 描述：销毁队列
	 * 参数：queueType 队列类型
	 * 返回：无
	 * */
	public static void clear(String queueType){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			DownQueueBigData.clear();
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			DownQueueSmallData.clear();
		}else{
			System.err.println("未找到指定的队列类型");
		}
	}
	
	/*
	 * 描述：判断队列是否为空
	 * 参数：queueType 队列类型
	 * 返回：布尔类型（true/false）
	 * */
	public static boolean QueueEmpty(String queueType){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueBigData.QueueEmpty();
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueSmallData.QueueEmpty();
		}else{
			System.err.println("未找到指定的队列类型");
			return false;
		}
	}
	
	/*
	 * 描述：从队尾进入队列
	 * 参数：
	 * 		queueType 队列类型
	 * 		obj 对象
	 * 返回：无
	 * */
	@SuppressWarnings("unchecked")
	public static void enterQueue(Map map)// 
	{
		String commentType=String.valueOf(map.get("commentType"));
		String downSql=String.valueOf(map.get("downSql"));
		if("table".equals(commentType.toLowerCase())&&(!("".equals(downSql)))){
			map.put("queueType",BIG_DATA_QUEUE_TYPE);
			enterQueue(BIG_DATA_QUEUE_TYPE,map);
		}else{
			map.put("queueType",SMALL_DATA_QUEUE_TYPE);
			enterQueue(SMALL_DATA_QUEUE_TYPE,map);
		}
	}
	
	/*
	 * 描述：从队尾进入队列
	 * 参数：
	 * 		queueType 队列类型
	 * 		obj 对象
	 * 返回：无
	 * */
	@SuppressWarnings("unchecked")
	public static void enterQueue(String queueType,Map map)// 
	{
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			DownQueueBigData.enterQueue(map);
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			DownQueueSmallData.enterQueue(map);
		}else{
			System.err.println("未找到指定的队列类型");
		}
	}
	
	/*
	 * 描述：从队头出队
	 * 参数：queueType 队列类型
	 * 返回：Object
	 * */
	@SuppressWarnings("unchecked")
	public static Map outQueue(String queueType){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueBigData.outQueue();
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueSmallData.outQueue();
		}else{
			System.err.println("未找到指定的队列类型");
			return null;
		}
	}
	
	/*
	 * 描述：获取队列长度
	 * 参数：queueType 队列类型
	 * 返回：int
	 * */
	public static int QueueLength(String queueType){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueBigData.QueueLength();
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueSmallData.QueueLength();
		}else{
			System.err.println("未找到指定的队列类型");
			return 0;
		}
	}

	/*
	 * 描述：查看队首元素
	 * 参数：queueType 队列类型
	 * 返回：Map
	 * */
	@SuppressWarnings("unchecked")
	public static Map QueuePeek(String queueType){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueBigData.QueuePeek();
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueSmallData.QueuePeek();
		}else{
			System.err.println("未找到指定的队列类型");
			return null;
		}
	}
	
	/*
	 * 描述：获取某一个状态
	 * 参数：
	 * 		queueType 队列类型
	 * 		key 键
	 * 返回：Map
	 * */
	@SuppressWarnings("unchecked")
	public static Map getOneStatusMap(String queueType,String key){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueBigData.getOneStatusMap(key);
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueSmallData.getOneStatusMap(key);
		}else{
			System.err.println("未找到指定的队列类型");
			return null;
		}
	}
	
	/*
	 * 描述：获取所有状态
	 * 参数：queueType 队列类型
	 * 返回：Map
	 * */
	@SuppressWarnings("unchecked")
	public static Map<String,Map> getStatusMap(String queueType){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueBigData.getStatusMap();
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueSmallData.getStatusMap();
		}else{
			System.err.println("未找到指定的队列类型");
			return null;
		}
	}
	
	/*
	 * 描述：添加（更新）一个状态
	 * 参数：
	 * 		queueType 队列类型
	 * 		key 键
	 * 		valueMap 值，包括status:-1(生成完成)、1（生成中）、-2(错误)，thread（线程）
	 * 返回：Map
	 * */
	@SuppressWarnings("unchecked")
	public static Map putStatusMap(String queueType,String key,Map valueMap){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueBigData.putStatusMap(key,valueMap);
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueSmallData.putStatusMap(key,valueMap);
		}else{
			System.err.println("未找到指定的队列类型");
			return null;
		}
	}
	
	/*
	 * 描述：删除一个状态
	 * 参数：
	 * 		queueType 队列类型
	 * 		key 键
	 * 返回：Map
	 * */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public static Map removeStatusMap(String queueType,String key){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueBigData.removeStatusMap(key);
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueSmallData.removeStatusMap(key);
		}else{
			System.err.println("未找到指定的队列类型");
			return null;
		}
	}
	
	/*
	 * 描述：向执行的队列添加对象
	 * 参数：
	 * 		map 对象
	 * 返回：无
	 * */
	@SuppressWarnings("unchecked")
	public static void enterExcuteQueue(String queueType,Map map)// 
	{
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			DownQueueBigData.enterExcuteQueue(map);
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			DownQueueSmallData.enterExcuteQueue(map);
		}else{
			System.err.println("未找到指定的队列类型");
		}
	}
	
	/*
	 * 描述：从执行的队列中移除
	 * 参数：key 惟一标识
	 * 返回：boolean
	 * */
	@SuppressWarnings("unchecked")
	public static boolean outExcuteQueue(String queueType,String key){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueBigData.outExcuteQueue(key);
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueSmallData.outExcuteQueue(key);
		}else{
			System.err.println("未找到指定的队列类型");
			return false;
		}
	}
	
	
	/*
	 * 描述：获取正在执行的任务个数
	 * 参数：
	 * 		queueType 队列类型
	 * 		key 键
	 * 返回：int
	 * */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public static int getExcuteCountFromStatusMap(String queueType){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueBigData.getExcuteCountFromStatusMap();
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueSmallData.getExcuteCountFromStatusMap();
		}else{
			System.err.println("未找到指定的队列类型");
			return 0;
		}
	}
	/*
	 * 描述：是否允许执行
	 * 参数：queueType 队列类型
	 * 返回：boolean
	 * */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public static boolean getAllowExcuteFlag(String queueType){
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueBigData.getAllowExcuteFlag();
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			return DownQueueSmallData.getAllowExcuteFlag();
		}else{
			System.err.println("未找到指定的队列类型");
			return false;
		}
	}
	/*
	 * 描述：获取递归方法执行状态
	 * 参数：
	 * 返回：boolean
	 * */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public static boolean getExcuteFlag(){
		return dataQueueExcuteFlag;
	}
	
	/*
	 * 描述：设置递归方法执行状态
	 * 参数：
	 * 		excuteFlag 执行状态
	 * 返回：无
	 * */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public static void setExcuteFlag(boolean excuteFlag){
		dataQueueExcuteFlag=excuteFlag;
	}
	
	/*
	 * 描述：保存队列信息到数据库中
	 * 参数：	
	 * 		queueType 队列类型
	 * 		runner
	 * 返回：无
	 * */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public static synchronized void saveQueueToDatabase(String queueType,SqlRunner runner) throws SQLException{
		if(BIG_DATA_QUEUE_TYPE.equals(queueType)){
			DownQueueBigData.saveQueueToDatabase(runner);
		}else if(SMALL_DATA_QUEUE_TYPE.equals(queueType)){
			DownQueueSmallData.saveQueueToDatabase(runner);
		}else{
			DownQueueBigData.saveQueueToDatabase(runner);
			DownQueueSmallData.saveQueueToDatabase(runner);
		}
	}
	
	public static void main(String []args) throws SQLException{
	}
}
