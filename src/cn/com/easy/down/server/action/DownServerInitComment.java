package cn.com.easy.down.server.action;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import cn.com.easy.annotation.Component;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.down.server.DownController;
import cn.com.easy.down.server.DownQueue;
import cn.com.easy.taglib.function.Functions;
@Component
public class DownServerInitComment{
	private SqlRunner runner;

	@SuppressWarnings({ "deprecation", "unchecked" })
	public void init() {
		try {
			List<?> tempDataMapList=runner.queryForMapList("SELECT ID,QUEUE_DATA  FROM E_EXPORT_QUEUE_DATA T WHERE T.ID IN('BIG_DATA_QUEUE_TYPE','SMALL_DATA_QUEUE_TYPE')");
			List<Map> dataMapList=new ArrayList<Map>();
			if(tempDataMapList!=null&&tempDataMapList.size()>0){
				dataMapList=(List<Map>) tempDataMapList;
			}
			StringBuilder quequeIdStr=new StringBuilder();
			for(Map dataMap:dataMapList){
				if(dataMap.get("QUEUE_DATA")!=null&&(!"".equals(String.valueOf(dataMap.get("QUEUE_DATA"))))){
					List<Map> queueMapList=(List<Map>) Functions.json2java(String.valueOf(dataMap.get("QUEUE_DATA")));
					for(Map queueMap:queueMapList){
						quequeIdStr.append(",'").append(String.valueOf(queueMap.get("id"))).append("'");
						queueMap.put("runner", runner);
						DownQueue.enterQueue(queueMap);
					}
				}
			}
			if((!("".equals(quequeIdStr.toString())))){
				runner.execute("delete from e_export_log t where t.exporting_id in("+quequeIdStr.substring(1).toString()+") and t.status_id !='1'");
				runner.execute("update e_exporting_info t set t.status_id='1' where t.id in("+quequeIdStr.substring(1).toString()+")");
				DownController.getInstance().tryGenerateFile();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.err.println("下载服务器初始化方法出错（DownServerInitComment.init）");
		}
	}
}
