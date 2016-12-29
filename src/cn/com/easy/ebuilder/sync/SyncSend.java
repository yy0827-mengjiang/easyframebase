package cn.com.easy.ebuilder.sync;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;

import cn.com.easy.core.sql.SqlRunner;

public class SyncSend implements Runnable {

	private final String path;
	private final String name;
	private final List<Map<String,String>> clusters;
	private final SqlRunner runner;
	private final String me;
	private String code;
	public SyncSend(String path,String name,String code,List<Map<String,String>> clusters,SqlRunner runner,HttpServletRequest request){
			this.path = path.substring(path.indexOf("/pages/ebuilder/usepage/"));
			this.name = name;
			this.code = code;
			this.clusters = clusters;
			this.runner = runner;
			this.me = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
	}
	@Override
	public void run() {
		try {
			this.code = URLEncoder.encode(this.code.replaceAll("%","★").replaceAll("\\+","☆"),"UTF-8");
			for(Map<String,String> cluster : clusters){
				String remoteUrl = cluster.get("URL");
				if(!remoteUrl.startsWith(me)){
					System.out.println("调用同步接收端"+remoteUrl+"syncReceiv.e"+",path="+this.path+",name="+this.name+",from="+me);
					String params="path="+this.path+"&name="+this.name+"&code="+this.code+"&from="+me;
					InvokeUtil.invokeStr(remoteUrl+"syncReceiv.e", params);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			try {
				runner.execute("insert into sys_sync_log(fromurl,tourl,status,path,message,create_time) values('"+me+"','所有节点','失败','"+this.path+this.name+"','"+e.getMessage()+"',sysdate)");
			} catch (SQLException e1) {
				e1.printStackTrace();
				System.err.println("来自"+me+"，同步到所有节点的文件"+this.path+this.name+"发生错误,错误如上");
			}
		}
	}
}