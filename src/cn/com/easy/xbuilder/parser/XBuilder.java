package cn.com.easy.xbuilder.parser;
/*
 * 使用访问者模式，生成电脑和手机两平台的的jsp代码。
 * 思路：定义2个接口XGenerateHtml和XGenerateComp，用来生成页面代码和组件jsp。
 * 分别实现为电脑和手机，这样前台设计不同的类型，只需创建不同的实现类，组合后就可以了。
 * 
 * chenfuquan
 */
import java.io.StringReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.web.taglib.function.Functions;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.meta.XMeta;

public class XBuilder implements Builder {
	private final Report report;
	private final String type;//
	private final SqlRunner runner;
	private XGenerateHtml xghtml;
	private XGenerateComp xgcomp;
	private XMeta xmeta;
	private XGenerateAction xgAction;//action文件电脑和手机都一样，没有定义接口
	public XBuilder(Report report,String type,SqlRunner runner){
		ReportConverteContext reportConverter = new ReportConverteContext();
		this.report = reportConverter.converter(report);
		this.type = type.equals("0")?"temp":"formal";
		this.runner = runner;
	}
	@Override
	public void buildHtml() {
		if(this.report.getInfo().getLtype().equals("1")){
			this.xghtml = new XGenerateHtmlPC(this.report,this.type,this.runner);
		}else{
			this.xghtml = new XGenerateHtmlMobile(this.report,this.type,this.runner);
		}
	}

	@Override
	public void buildComp() {
		if(this.report.getInfo().getLtype().equals("1")){
			this.xgcomp = new XGenerateCompPC(this.report,this.type,this.runner);
		}else{
			this.xgcomp = new XGenerateCompMobile(this.report,this.type,this.runner);
		}
	}
	
	@Override
	public void buildAction() {
		this.xgAction = new XGenerateAction(this.report,this.type,true);
	}

	@Override
	public void builMeta(){
		xmeta = new XMeta(this.report,this.type,this.runner);
	}
	
	@Override
	public Generate getGenerate() {
		final XBuilder self = this;
		return new Generate(){
			private String error = "";
			public String getJsp(){
				String code = xghtml.html(xgcomp);
				if(!code.equals("success")){
					this.error = code;
					return "";
				}
				String result = xgAction.action();
				if(result.equals("success")){
					xmeta.meta();
					String jsp = xghtml.getJsp();
					if (jsp != null && !jsp.equals("") && type.equals("formal")) {
						Map<String,String> info = self.saveJsp2Db();
						if(info.get("result").equalsIgnoreCase("1")){
							self.saveDbErr(info);
						}
					}
					return jsp;
				}else{
					this.error = result;
					return "";
				}
			}
			public String getError(){
				return this.error;
			}
		};
	}
	private Map<String,String> saveJsp2Db(){
		Connection conn = null;
		PreparedStatement stmt = null;
		int ver = 1;
		Map<String,String> info = new HashMap<String,String>();
		Map<String,Object> user = (Map<String,Object>)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo");
		try {
			String xid = report.getId();
			String sql = "insert into x_jsp_version(xid,file_name,jsp_data,version,create_user,create_time) values('"+xid+"',?,?,"+ver+",'"+String.valueOf(user.get("USER_ID"))+"','"+Functions.getDate("yyyyMMddHHmmss")+"')";
			
			Map<String,Object> record = null;
			List<Map> vList = (List<Map>)runner.queryForMapList("select (case when version is null then 0 else version end) as \"VERSION\" from x_jsp_version t where xid='"+xid+"'");
			if(vList!=null&&vList.size()>0){
				record = vList.get(0);
			}
			if(null != record){
				ver = Integer.parseInt(String.valueOf(record.get("VERSION")))+1;
				sql = "update x_jsp_version set jsp_data=?,version="+ver+",create_user='"+String.valueOf(user.get("USER_ID"))+"',create_time='"+Functions.getDate("yyyyMMddHHmmss")+"' where xid='"+xid+"' and file_name=?";
			}
			
			Map<String,String> fileData = this.xgcomp.compList;
			fileData.put("formal_"+xid+".jsp", this.xghtml.getPage().toString());
			fileData.put("formal_"+xid+"Action.jsp", xgAction.actionPage);
			
			EasyDataSource datasource = EasyContext.getContext().getDataSource();
			conn = datasource.getConnection();
			conn.setAutoCommit(false);
			stmt = conn.prepareStatement(sql);
			
			for(String key:fileData.keySet()){
				String content = fileData.get(key);
				StringReader reader = new StringReader(content);
				if(null != record){
					stmt.setCharacterStream(1, reader, content.length());
					stmt.setString(2,key); 
				}else{
					stmt.setString(1,key); 
					stmt.setCharacterStream(2, reader, content.length()); 
				}
				stmt.executeUpdate();
			}
			conn.commit();
			info.put("result","0");
			info.put("demo","保存成功");
			return info;
		} catch (Exception e) {
			e.printStackTrace();
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			info.put("result","1");
			info.put("demo",e.getMessage());
			return info;
		}finally {
			info.put("version",String.valueOf(ver));
			info.put("user_id",String.valueOf(user.get("USER_ID")));
			try {
				if(stmt!=null)
					stmt.close();
				if(conn!=null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	private void saveDbErr(Map<String,String> info){
		Object sysid = EasyContext.getContext().getServletcontext().getAttribute("localRmiLocation");
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("xid", report.getId());
		params.put("sys_from",sysid);
		params.put("sys_to",sysid);
		params.put("version",info.get("version"));
		params.put("result",info.get("result"));
		params.put("create_user",info.get("user_id"));
		try {
			int num = runner.execute("insert into x_jsp_sync_log(xid,sys_from,sys_to,version,result,create_user,create_time) values(#xid#,#sys_from#,#sys_to#,#version#,#result#,#create_user#,'"+Functions.getDate("yyyyMMddHHmmss")+"')", params);
			if(num<=0){
				System.err.println("系统"+sysid+"保存jsp内容到数据库时时出错。在保存日志时，同样发生错误。请查看tomcat日志排查。");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}