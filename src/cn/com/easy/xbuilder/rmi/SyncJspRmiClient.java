package cn.com.easy.xbuilder.rmi;

import java.util.HashMap;
import java.util.Map;

import cn.com.easy.annotation.Rmi;
import cn.com.easy.xbuilder.parser.XGenerateSync;

@Rmi("xbuilder.rmi.syncJspRmi")
public class SyncJspRmiClient {
	
	/**
	 * 同步jsp文件方法
	 * @param reportId
	 * @param versionId
	 * @param createUser
	 * @param from
	 * @param to
	 */
	public void syncJsp(String reportId,String versionId,String createUser,String from,String to) {
        //调用同步文件的action
		Map<String,String> map = new HashMap<String,String>();
		map.put("reportId",reportId);
		map.put("versionId",versionId);
		map.put("createUser",createUser);
		map.put("from",from);
		map.put("to",to);
		XGenerateSync xgenerateSync = new XGenerateSync();
		xgenerateSync.syncEvt(map);
	}
}
