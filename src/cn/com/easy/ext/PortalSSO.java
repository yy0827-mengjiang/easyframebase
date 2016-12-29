package cn.com.easy.ext;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.util.InvokeUtil;

@Controller
public class PortalSSO {
	private SqlRunner runner;

	public String invokSubsystem(HttpServletRequest request, HttpServletResponse response,String user,String url) {
		try {
			Map<String,String> info = this.getSubSysInfo(url);
			StringBuilder callUrl = new StringBuilder();
			callUrl.append(info.get("PREURL"));
			callUrl.append(info.get("JSIDURL"));
			String tmp = "user="+user+"&token="+MD5.MD5Crypt(info.get("IP"));
			if(info.get("JSIDURL").indexOf("?") > 0){
				callUrl.append("&"+tmp);
			}else{
				callUrl.append("?"+tmp);
			}
			
			//测试
			//callUrl.append("?user=admin&pwd=bonc&encrypt=0");
			String jsid = InvokeUtil.invokeStr(callUrl.toString());
			
			if(jsid !=null && jsid.length()>0 && !jsid.equals("fail")){
				TicketStore.jsidMap.put(user+"_"+info.get("ID"),jsid);
				return "{\"jsid\":\""+jsid+"\",\"preurl\":\""+info.get("PREURL")+"\"}";
			}else{
				return "{\"jsid\":\"fail\",\"preurl\":\"fail\"}";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "{\"jsid\":\"fail\",\"preurl\":\"fail\"}";
		}
	}
	
	@Action("getJsid")
	public void getJsid(HttpServletRequest request, HttpServletResponse response,String user,String murl) {
		String json = "";
		try {
			Map<String,String> info = this.getSubSysInfo(murl);
			
			String jsid = TicketStore.jsidMap.get(user+"_"+info.get("ID"));
			if(jsid != null){
				json = "{\"jsid\":\""+jsid+"\",\"preurl\":\""+info.get("PREURL")+"\"}";
			}else{
				json = this.invokSubsystem(request, response, user, murl);
			}
		} catch (Exception e) {
			e.printStackTrace();
			json = "{\"jsid\":\"fail\",\"preurl\":\"fail\"}";
		}finally{
	        StringBuilder sb = new StringBuilder(64);
	        sb.append("text/html").append(";charset=").append("UTF-8");
	        response.setContentType(sb.toString());
	        PrintWriter pw = null;
			try {
				pw = response.getWriter();
			} catch (IOException e) {
				e.printStackTrace();
			}
	        pw.write(json);
	        pw.flush();
	        pw.close();
		}
	}
	
	@Action("noticeOffline")
	public void noticeUserOffline(HttpServletRequest request, HttpServletResponse response,String jsid) {
		for(String key : TicketStore.jsidMap.keySet()){
			if(TicketStore.jsidMap.get(key).equals(jsid)){
				TicketStore.jsidMap.remove(key);
			}
			break;
		}
		
		try{
			DefaultLogin dLogin = new DefaultLogin();
			dLogin.logout(request, runner);
			response.setContentType("text/html");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().println("success");
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	private Map<String,String> getSubSysInfo(String url) throws SQLException {
		Map<String,String> info = (Map<String,String>)runner.queryForMap("select a.EXT1 ID,b.SUBSYSTEM_ADDRESS PREURL,b.SIMULATION_ADDRESS JSIDURL,b.SUBSYSTEM_IP IP from e_menu a,d_subsystem b where a.ext1 = b.subsystem_id and a.url='"+url+"'");
		return info;
	}
}