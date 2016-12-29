package cn.com.easy.down.server.action;

import java.io.File;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.ext.DownLoad;

@Controller
public class DownServerAction {
	private SqlRunner runner;
	/**
	 * 下载文件
	 * @param request
	 * @param response
	 * @param filePath
	 * @param fileName
	 */
	@SuppressWarnings("unchecked")
	@Action("downFileServerAction")
	public void downFile(HttpServletRequest request, HttpServletResponse response,String id){
		try{
			Map<String, String> map=(Map<String, String>)runner.queryForMap("SELECT FILE_NAME,FILE_PATH FROM e_exporting_info WHERE ID='"+id+"'");
			String fileName=map.get("FILE_NAME");
			String filePath=map.get("FILE_PATH");
			File file=new File(filePath);
			if(!(file.exists())){
				System.err.println("要下载的文件不在在，文件路径为:"+filePath+"，id为:"+id);
				response.getWriter().write("<script>alert('File is not existed!');history.back(-1);</script>");
				return ;
			}
			DownLoad down = new DownLoad();
			down.downloadFile(request, response, filePath, fileName);
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
