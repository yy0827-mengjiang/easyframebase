package cn.com.easy.ext;

import java.util.HashMap;
import java.util.Map;

public class CompExtendSxConfig {
	private static final Map<String,Map<String,String>> cfs = new HashMap<String,Map<String,String>>();
	
	//>>配置采用map的形式，其他方式自行扩展
	static {
		Map<String,String> data = new HashMap<String,String>();
		data.put("FileName", "测试");
		data.put("Fields", "地市,区县,指标1,指标2,指标3,指标4");//这个excel的表头，目前不支持复杂，表头和数据是按照位置顺序对应的，需要注意。
		data.put("Sql", "select '长春','长春市','111','222','333','444' from dual where id=#id# and kpiid=#kpiid#");//查询数据的sql，#包含的参数#
		cfs.put("userTable", data);
		
		//重复上面的配置，将多个需要个性导出的配置出来即可。
	}
	public static Map<String,String> getConfig(String id){
		return cfs.get(id);
	}
}