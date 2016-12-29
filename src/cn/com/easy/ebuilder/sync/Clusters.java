package cn.com.easy.ebuilder.sync;

import java.util.List;
import java.util.Map;

import cn.com.easy.core.sql.SqlRunner;

public class Clusters {
	private Clusters(){};
	public static Clusters cls = new Clusters();
	private static List<Map<String,String>> clusters;
	public List<Map<String,String>> getClusters(SqlRunner runner){
		try {
			if(clusters == null){
				clusters = (List<Map<String,String>>)runner.queryForMapList("select * from SYS_CLUSTERS");
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("查询负载均衡节点时失败，请确认有表SYS_CLUSTERS");
		}
		return clusters;
	}
}