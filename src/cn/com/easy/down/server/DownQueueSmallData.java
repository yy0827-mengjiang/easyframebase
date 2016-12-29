package cn.com.easy.down.server;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.taglib.function.Functions;

public class DownQueueSmallData {
	/*队列*/
	@SuppressWarnings("unchecked")
	private static LinkedList<Map> list = new LinkedList();
	/*状态列表*/
	@SuppressWarnings("unchecked")
	private static Map<String,Map> statusMap=new HashMap<String, Map>();
	/*执行列表*/
	@SuppressWarnings("unchecked")
	private static LinkedList<Map> excutelist = new LinkedList();
	/*最大并发数*/
	public static int maxTaskNum=2;
	static{
		if(EasyContext.getContext().get("maxSmallDataThreadNum")!=null){
			maxTaskNum=Integer.parseInt(String.valueOf(EasyContext.getContext().get("maxSmallDataThreadNum")));
		}
	}
	/*
	 * 描述：获取全部队列
	 * 参数：无
	 * 返回：LinkedList<Map>
	 * */
	@SuppressWarnings("unchecked")
	public static LinkedList<Map> getLinkedList(){
		return list;
	}
	
	/*
	 * 描述：销毁队列
	 * 参数：无
	 * 返回：无
	 * */
	public static void clear(){
		list.clear();
	}
	
	/*
	 * 描述：判断队列是否为空
	 * 参数：无
	 * 返回：布尔类型（true/false）
	 * */
	public static boolean QueueEmpty(){
		return list.isEmpty();
	}

	/*
	 * 描述：从队尾进入队列
	 * 参数：
	 * 		obj 对象
	 * 返回：无
	 * */
	@SuppressWarnings("unchecked")
	public static void enterQueue(Map map)// 
	{
		list.addLast(map);
	}
	
	/*
	 * 描述：从队头出队
	 * 参数：无
	 * 返回：Object
	 * */
	@SuppressWarnings("unchecked")
	public static Map outQueue(){
		if (!list.isEmpty()) {
			return list.removeFirst();
		}
		return null;
	}
	
	/*
	 * 描述：获取队列长度
	 * 参数：无
	 * 返回：int
	 * */
	public static int QueueLength(){
		return list.size();
	}

	/*
	 * 描述：查看队首元素
	 * 参数：无
	 * 返回：Map
	 * */
	@SuppressWarnings("unchecked")
	public static Map QueuePeek(){
		return list.getFirst();
	}
	
	/*
	 * 描述：获取某一个状态
	 * 参数：
	 * 		key 键
	 * 返回：Map
	 * */
	@SuppressWarnings("unchecked")
	public static Map getOneStatusMap(String key){
		return statusMap.get(key);
	}
	
	/*
	 * 描述：获取所有状态
	 * 参数：
	 * 返回：Map
	 * */
	@SuppressWarnings("unchecked")
	public static Map<String,Map> getStatusMap(){
		return statusMap;
	}
	
	/*
	 * 描述：添加（更新）一个状态
	 * 参数：
	 * 		key 键
	 * 		valueMap 值，包括status:-1(生成完成)、1（生成中）、-2(错误)，thread（线程）
	 * 返回：Map
	 * */
	@SuppressWarnings("unchecked")
	public static Map putStatusMap(String key,Map valueMap){
		return statusMap.put(key, valueMap);
	}
	
	/*
	 * 描述：删除一个状态
	 * 参数：
	 * 		key 键
	 * 返回：Map
	 * */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public static Map removeStatusMap(String key){
		return statusMap.remove(key);
	}
	/*
	 * 描述：向执行的队列添加对象
	 * 参数：
	 * 		map 对象
	 * 返回：无
	 * */
	@SuppressWarnings("unchecked")
	public static void enterExcuteQueue(Map map)// 
	{
		excutelist.addLast(map);
	}
	
	/*
	 * 描述：从执行的队列中移除
	 * 参数：key 惟一标识
	 * 返回：boolean
	 * */
	@SuppressWarnings("unchecked")
	public static boolean outExcuteQueue(String key){
		boolean resultFlag=false;
		Iterator<Map> iterator=excutelist.iterator();
		Map quequeMap=null;
		while(iterator.hasNext()){
			quequeMap=iterator.next();
			if(quequeMap!=null&&key.equals(String.valueOf(quequeMap.get("id")))){
				iterator.remove();
				resultFlag=true;
				break;
			}
		}
		return resultFlag;
	}
	/*
	 * 描述：获取正在执行的任务个数
	 * 参数：无
	 * 返回：Map
	 * */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public static int getExcuteCountFromStatusMap(){
		int excuteNum=0;
		Set<String> set=statusMap.keySet();
		Iterator<String> iterator= set.iterator();
		Map tempMap=new HashMap();
		while(iterator.hasNext()){
			tempMap=statusMap.get(iterator.next());
			if("1".equals(String.valueOf(tempMap.get("status")).trim())){
				excuteNum++;
			}
		}
		return excuteNum;
	}
	/*
	 * 描述：是否允许执行
	 * 参数：无
	 * 返回：Map
	 * */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public static boolean getAllowExcuteFlag(){
		return (getExcuteCountFromStatusMap()<maxTaskNum);
	}
	/*
	 * 描述：保存队列信息到数据库中
	 * 参数：runner
	 * 返回：无
	 * */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public static void saveQueueToDatabase(SqlRunner runner) throws SQLException{
		List allList=new LinkedList<Map>();
		for(Map queueMap:getLinkedList()){
			allList.add(queueMap);
		}
		for(Map excuteMap:excutelist){
			allList.add(excuteMap);
		}
		String queueListJsonStr=Functions.java2json(allList);
		String id="SMALL_DATA_QUEUE_TYPE";
		Map<String,String> paramMap=new HashMap<String, String>();
		paramMap.put("id", id);
		paramMap.put("queueListJsonStr", queueListJsonStr);
		runner.execute("DELETE FROM E_EXPORT_QUEUE_DATA WHERE ID=#id#",paramMap);
		runner.execute("INSERT INTO E_EXPORT_QUEUE_DATA(ID,QUEUE_DATA) VALUES(#id#,#queueListJsonStr#)",paramMap);
	}
}
