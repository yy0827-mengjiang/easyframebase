package cn.com.easy.xbuilder.service;

import java.io.StringReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import oracle.sql.CLOB;
import cn.com.easy.core.EasyContext;
import net.sf.json.JSONObject;
import net.sf.jsqlparser.parser.CCJSqlParserManager;
import net.sf.jsqlparser.statement.select.Select;
import cn.com.easy.annotation.Service;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.xbuilder.utils.StringUtil;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.parser.CommonTools;
@Service
public class SQLVaildata implements ISQLVaildata {
	private SqlRunner runner;
	static String[] sqlKeyWord = {"INSERT","DELETE","UPDATE","CREATE","DROP","ALTER","GRANT","DENY","REVOKE","COMMIT","ROLLBACK","FOR"};
	static Map keywordsMap = new HashMap<String,String>();
	static {
		 for(String word : sqlKeyWord){
			 keywordsMap.put(word, word);
		 }
    }
	/**
	 * 解where条件是否符合规范
	 * 规范：{ and test = #test#}
	 * @param dataSourceName
	 * @param sql
	 * @return json字符串 正确[falg:true,res:and a=#a#;and b=#b#] 错误[falg:false,res:错误信息]
	 */
	public String firstSqlVail(String dataSourceName,String sql){
		Map<String,String> resMap = new HashMap<String,String>();
		String falg = "true";
		String res = "";
		String dataSql = "";
		String jsonStr = "";
		try{
			dataSql = new String(org.apache.commons.codec.binary.Base64.decodeBase64(sql), "UTF-8");
			dataSql = StringUtil.formatSql(dataSql, "{", "}");
			if (dataSql.indexOf("AND") == 0){
				falg = "false";
				res = "第" + dataSql.substring(3)+ "个{}对内的应该存在AND|OR或者##不配对！";
			}else if ("COUNT".equals(dataSql)){
				falg = "false";
				res = "有部分##对没有被｛｝包含或者｛｝不配对！";
			}else if (dataSql == null){
				falg = "false";
				res = "SQL格式拼写错误:｛｝没有成对出现或不正确的对！";
			}
		}catch(Exception e){
			falg = "false";
			res = "Base64转码错误，请联系管理员！";
			//e.printStackTrace();
		}
		
		//如要以上验证没有问取where条件值
		if("true".equals(falg)){
			List<String> measures = new ArrayList<String>();
			measures = getMeasuresInFormulaByFirst(sql);
			if(measures!=null && measures.size()>0){
				for(String str:measures){
					res += str+";";
				}
			}
			if(!"".equals(res)){
				res = res.substring(0,res.length()-1);
			}
		}
		
		resMap.put("falg", falg);
		resMap.put("res", res);
		JSONObject json = JSONObject.fromObject(resMap); 
		jsonStr = json.toString();
		return jsonStr;
	}

	/**
	 * sql语句中是否包含关键字
	 * @param dataSourceName
	 * @param sql
	 * @return json字符串 正确[falg:true,res:成功] 错误[falg:false,res:错误信息]
	 */
	public String secondSqlVail(String dataSourceName, String sql) {
		Map<String,String> resMap = new HashMap<String,String>();
		String dataSql = "";
		String falg = "true";
		String res = "成功!";
		String jsonStr = "";
		try{
			dataSql = new String(org.apache.commons.codec.binary.Base64.decodeBase64(sql), "UTF-8");
			dataSql = dataSql.toUpperCase();
			Pattern pattern = Pattern.compile("\\w+");
			Matcher matcher = pattern.matcher(dataSql);
			while(matcher.find()){
				if(keywordsMap.containsKey(matcher.group())){
					falg = "false";
					res = "SQL中不能包含关键字："+matcher.group();
					break;
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			falg = "false";
			res = "Base64转码错误，请联系管理员！";
		}
		resMap.put("falg", falg);
		resMap.put("res", res);
		JSONObject json = JSONObject.fromObject(resMap); 
		jsonStr = json.toString();
		return jsonStr;
	}

	/**
	 * 执行sql
	 * @param dataSourceName
	 * @param sql
	 * @return json字符串 正确[falg:true,res:[colume:列名],[data:数据]] 错误[falg:false,res:错误信息]
	 */
	public String thirdSqlExeucte(String dataSourceName, String sql,String page,String jsonString) {
		Map<String,Object> resMap = new HashMap<String,Object>();
		String dataSql = "";
		String falg = "true";
		String res = "";
		String jsonStr = "";
		List<Map<String,String>> listColumn = new ArrayList<Map<String,String>>();
		List<Map<String,String>> listData = new ArrayList<Map<String,String>>();
		
		//jdbc连接对象
		Connection conn = null;
		PreparedStatement stat = null;
		try{
			dataSql =  new String(org.apache.commons.codec.binary.Base64.decodeBase64(sql), "UTF-8");
			//替换where条件
			dataSql = replaceWhere(dataSql,jsonString);
			CommonTools tools = new CommonTools();
			dataSql = tools.getPageSql(dataSourceName, dataSql,0,Integer.valueOf(page));
			//获得数据库连接
			EasyDataSource datasource = CommonTools.getDataSource(dataSourceName);
			//数据库连接对象
			conn = datasource.getConnection();
			stat = conn.prepareStatement(dataSql);
			boolean allowTableError = false;
			
			String xsqlDataSource = String.valueOf(EasyContext.getContext().getServletcontext().getAttribute("xsqlDataSource"));
			
			if("0".equals(xsqlDataSource)){
				if(!"".equals(dataSourceName)){
					//查询数据源下允许查询的所有的表
					String allowedTableSql = "select table_name from x_extds_info t where t.ext_datasource=? ";
					List<Map> tbList = (List<Map>)runner.queryForMapList(allowedTableSql, dataSourceName);
					Map tmpTableMap = new HashMap();
					for(Map tbMap : tbList){
						tmpTableMap.put(tbMap.get("TABLE_NAME"), tbMap.get("TABLE_NAME"));
					}
					
					//解析出SQL中的所有表名,循环判断表是否可以执行查询。
					CCJSqlParserManager pm = new CCJSqlParserManager();
					net.sf.jsqlparser.statement.Statement statement = pm.parse(new StringReader(replaceWhere(new String(org.apache.commons.codec.binary.Base64.decodeBase64(sql), "UTF-8"),jsonString)));
					if (statement instanceof Select) {
						Select selectStatement = (Select) statement;
						TablesNamesFinder tablesNamesFinder = new TablesNamesFinder();
						List tableList = tablesNamesFinder.getTableList(selectStatement);
						String tmpTableName = "";
						for(Iterator iter = tableList.iterator(); iter.hasNext();) {
							 tmpTableName = String.valueOf(iter.next());
							 if(tmpTableMap.get(tmpTableName)==null){
								 allowTableError = true;
								 falg = "false";
								 res = "您没有查询“"+tmpTableName+"”表的权限！";
								 break;
							 }  
						}
					}
				}
			}
			
			if(!allowTableError){
				//执行语句
				//System.out.println("JDBCSQL==>>"+dataSql);
				ResultSet rs = stat.executeQuery();
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCnt  = rsmd.getColumnCount();
				//先取列名
				for(int i=1;i<=columnCnt;i++){
					Map<String,String> mapColumn = new HashMap<String,String>();
					mapColumn.put("field", toHexString(rsmd.getColumnName(i)));
					mapColumn.put("title", rsmd.getColumnName(i));
					mapColumn.put("width", "150");
					listColumn.add(mapColumn);
				}
				//取数据
				while(rs.next()){
					Map<String,String> dataMap = new HashMap<String,String>();
					for(int j=1;j<=columnCnt;j++){
						dataMap.put(toHexString(rsmd.getColumnName(j)), rs.getString(rsmd.getColumnName(j)));
					}
					listData.add(dataMap);
				}
				rs.close();
			}
		}catch(Exception e){
			e.printStackTrace();
			falg = "false";
			if(e.getMessage()!=null){
				res = e.getMessage()+"或where条件值输入错误！";
			}else{
				res = "未知的错误";
			}
		}finally{
			try{
				if(stat != null){
					stat.close();
				}
				if(conn != null){
					conn.close();
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		if("true".equals(falg)){
			resMap.put("falg", falg);
			resMap.put("column", listColumn);
			resMap.put("data", listData);
		}else{
			resMap.put("falg", falg);
			resMap.put("res", res);
		}
		JSONObject json = JSONObject.fromObject(resMap); 
		jsonStr = json.toString();
		return jsonStr;
	}
	
	/**
	 * 用于加密datagrid的列和数据，避免列名有特殊字符引起的列宽对不上
	 * @param s
	 * @return
	 */
	public static String toHexString(String s) {
		String str = "";
		for (int i = 0; i < s.length(); i++) {
			int ch = (int) s.charAt(i);
			String s4 = Integer.toHexString(ch);
			str = str + s4;
		}
		return str;//0x表示十六进制
	}

	/**
	 * 存入临时xml
	 * @param dataSourceName
	 * @param sql
	 * @param uid
	 * @param name
	 * @return json字符串 正确[falg:true] 错误[falg:false]
	 */
	public String addTmpDataSourceXml(String dataSourceName,String sql,String uid,String name,String reportId,String datatype){
		Map<String,Object> resMap = new HashMap<String,Object>();
		String falg = "true";
		String jsonStr="";
		String res = "存入成功";
		String dataSql = "";
		try{
			String id=java.util.UUID.randomUUID().toString().replace("-", "");
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
			String createtime = ""+sdf.format(new Date());
			String creator = ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID")+"";
			String index = "0";
			String reference=uid;
			dataSql =  new String(org.apache.commons.codec.binary.Base64.decodeBase64(sql), "UTF-8");
			Map<String,String> dsMap = new HashMap<String,String>();
			dsMap.put("id", id);
			dsMap.put("name", name);
			dsMap.put("extds", dataSourceName);
			dsMap.put("createtime", createtime);
			dsMap.put("creator", creator);
			dsMap.put("index", index);
			dsMap.put("reference", reference);
			dsMap.put("sql", dataSql);
			dsMap.put("datatype", datatype);
			
			DataSetService xmlService = new DataSetService();
			//删除临时数据源
			xmlService.delTmpDataSource(id, reportId);
			//添加临时数据源
			xmlService.addTmpDataSource(reportId, dsMap);
			
		}catch(Exception e){
			falg = "false";
			res = "存入xml异常";
			e.printStackTrace();
		}
		
		resMap.put("falg", falg);
		resMap.put("res", res);
		JSONObject json = JSONObject.fromObject(resMap); 
		jsonStr = json.toString();
		return jsonStr;
	}
	
	/**
	 * 存入正式xml加数据库
	 * @param dataSourceName
	 * @param sql
	 * @param uid
	 * @param name
	 * @return
	 */
	public String addDataSourceXml(String tmp,String id,String dataSourceName,String sql,String reference,String name,String reportId,String datatype){
		Map<String,Object> resMap = new HashMap<String,Object>();
		String falg = "true";
		String jsonStr="";
		String res = "存入成功";
		String dataSql="";
		Map<String,String> insMap = new HashMap<String,String>();
		try{
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
			String createtime = ""+sdf.format(new Date());
			String creator = ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID")+"";
			String index = "0";
			Map<String,String> dsMap = new HashMap<String,String>();
			if("1".equals(tmp)){
				dsMap.put("id", reference);
			}else{
				dsMap.put("id", id);
			}
			dsMap.put("name", name);
			dsMap.put("extds", dataSourceName);
			dsMap.put("createtime", createtime);
			dsMap.put("creator", creator);
			dsMap.put("index", index);
			dsMap.put("reference", reference);
			dsMap.put("data_sql", sql);
			dsMap.put("datatype", datatype);
			JSONObject json = JSONObject.fromObject(dsMap); 
			DataSetService xmlService = new DataSetService();
			String jsonString = json.toString();
			//删除临时数据源
			xmlService.delTmpDataSource(id, reportId);
			
			//添加正式数据源
			Datasource ds = xmlService.addDataSource(reportId, jsonString);
			//入库 x_report_sql表
			dataSql =  new String(org.apache.commons.codec.binary.Base64.decodeBase64(sql), "UTF-8");
			
			Map<String,String> reportMap = new HashMap<String,String>();
			
			reportMap.put("report_sql_id", ds.getId());
			reportMap.put("report_id", reportId);
			reportMap.put("report_sql_name", ds.getName());
			reportMap.put("report_sql", dataSql);
			reportMap.put("report_sql_type", dataSourceName);
			//保存数据库
			insMap = insReportSql(reportMap);
			
		}catch(Exception e){
			falg = "false";
			res = "XML操作异常";
			e.printStackTrace();
		}
		JSONObject json = new JSONObject();
		resMap.put("falg", falg);
		resMap.put("res", res);
		if("false".equals(insMap.get(falg))){
			json = JSONObject.fromObject(insMap); 
		}else{
			json = JSONObject.fromObject(resMap); 
		}
		jsonStr = json.toString();
		return jsonStr;
	}
	
	//存入x_report_sql表
	public static Map<String,String> insReportSql(Map<String,String> reportMap){
		String falg = "true";
		String res = "存入成功!";
		Map<String,String> resMap = new HashMap<String,String>();
		String dataSourceName="";
		String id = "";
		//jdbc连接对象
		Connection conn = null;
		PreparedStatement stat = null;
		
		String report_sql_id = reportMap.get("report_sql_id");
		String report_id = reportMap.get("report_id");
		String report_sql_name = reportMap.get("report_sql_name");
		String report_sql = reportMap.get("report_sql");
		String report_sql_type = reportMap.get("report_sql_type");
		
		try{
			EasyDataSource datasource = CommonTools.getDataSource(dataSourceName);
			//数据库连接对象
			conn = datasource.getConnection();
			conn.setAutoCommit(false);
			String delSql = "delete from x_report_sql where report_sql_id ='"+report_sql_id+"'" + " and report_id = '" + report_id +"'";
			//删除
			stat = conn.prepareStatement(delSql);
			stat.executeUpdate();
			String DBtype = conn.getMetaData().getDatabaseProductName().trim();
			if(null!=DBtype&&(DBtype.toLowerCase().contains("db2")||DBtype.toLowerCase().contains("postgre"))){
				String insSql = "insert into x_report_sql (report_sql_id, report_id, report_sql_name, report_sql,REPORT_SQL_TYPE) " +
				"values ('"+report_sql_id+"','"+report_id+"',?,?,'"+report_sql_type+"')";
				//添加
				stat = conn.prepareStatement(insSql);
				stat.setString(1, report_sql_name);
				stat.setString(2, report_sql);
				stat.executeUpdate();
			}else{
				String insSql = "insert into x_report_sql (report_sql_id, report_id, report_sql_name, report_sql,REPORT_SQL_TYPE) " +
						"values ('"+report_sql_id+"','"+report_id+"',?,empty_clob(),'"+report_sql_type+"')";
				//添加
				stat = conn.prepareStatement(insSql);
				stat.setString(1, report_sql_name);
				stat.executeUpdate();
				String clobObj = "select REPORT_SQL from x_report_sql where report_sql_id ='"+report_sql_id+"' and report_id = '" + report_id +"' for update";
				stat = conn.prepareStatement(clobObj);
				ResultSet rs = stat.executeQuery(clobObj);
				if(rs.next()){
					CLOB clob = (CLOB) rs.getClob(1); 
					clob.setString(1, report_sql);
					String upSql = "update x_report_sql a set a.report_sql = ? where a.report_sql_id ='"+report_sql_id+"' and a.report_id = '" + report_id +"' "; 
					stat = conn.prepareStatement(upSql);
					stat.setClob(1, clob);
					stat.executeQuery();
					rs.close();
				}
			}
			conn.commit();
		}catch(Exception e){
			falg = "false";
			if(e.getMessage().indexOf("\n")==-1){
				res = e.getMessage();
			}else{
				res = e.getMessage().substring(e.getMessage().indexOf(":")+1,e.getMessage().indexOf("\n"));
			}
			e.printStackTrace();
		}finally{
			try{
				if(stat != null){
					stat.close();
				}
				if(conn != null){
					conn.close();
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		resMap.put("falg", falg);
		resMap.put("res", res);
		return resMap;
	}
	
	//查询条件去掉特殊符
	public static String replaceBlank(String sql){
		String s="";
		Pattern p = Pattern.compile("\t|\r|\n");
		Matcher m = p.matcher(sql);	
		s = m.replaceAll("");
		return s;
	}
	
	//获得sql语句中{}的部分 替换为空
	public static List<String> getMeasuresInFormula(String formula) {
		List<String> measures = new ArrayList<String>();
		try{
			String sqlData = new String(org.apache.commons.codec.binary.Base64.decodeBase64(formula), "UTF-8");
			Pattern p = Pattern.compile("\\{(.*?)\\}");  
			//替换回车，制表符
			String sql = replaceBlank(sqlData);
			Matcher m = p.matcher(sql.replaceAll("\r\n", ""));  
			while(m.find()){  
				measures.add(m.group(1));  
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return measures;
	}
	
	//获得字符串的##包含的部分
	public static List<String> getMeasuresInFormulaByFirst(String formula){
		List<String> measures = new ArrayList<String>();
		try{
			String sqlData = new String(org.apache.commons.codec.binary.Base64.decodeBase64(formula), "UTF-8");
			Pattern p = Pattern.compile("\\#(.*?)\\#");  
			//替换回车，制表符
			String sql = replaceBlank(sqlData);
			Matcher m = p.matcher(sql.replaceAll("\r\n", ""));  
			while(m.find()){  
				measures.add(m.group(1));  
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return measures;
	}
	
	//解析sql
	public static String analysisSql(String formula,Map<String,String> paramMap){
		List<String> measures = new ArrayList<String>();
		Pattern p = Pattern.compile("\\{(.*?)\\}");  
		//替换回车，制表符
		//String sql = replaceBlank(formula);
		String sql = formula.replaceAll("\n", "\t");
		//System.out.println(sql);
		Matcher m = p.matcher(sql);  
		while(m.find()){  
			measures.add(m.group(1));  
		}
		if(measures!=null&&measures.size()>0){
			for(int i=0;i<measures.size();i++){
				String condition = measures.get(i);
				for(Map.Entry<String, String> map : paramMap.entrySet()){
					String key = "#"+map.getKey()+"#";
					String val = map.getValue();
					if(condition.indexOf(key)!=-1){
						if(!"".equals(val)){
							sql = sql.replace(key, "'"+val+"'");
						}else{
							sql = sql.replace(condition, "");
						}
						
					}
				}
			}
		}
		return sql;
	}
	
	//sql分词
	public static List<String> getSqlKenizer(String sql){
		List<String> resList = new ArrayList<String>();
		StringTokenizer st = new StringTokenizer(sql); 
		while(st.hasMoreTokens()){
			 resList.add(st.nextToken());
		}
		return resList;
	}
	
	//替换where条件{and type=#a#} 
	public static String replaceWhere(String sql,String jsonString){
		String res="";
		Map<String,String> element = new HashMap<String,String>();
		if(!"".equals(jsonString)){
			element=(Map<String,String>)Functions.json2java(jsonString);
		}
		res = analysisSql(sql,element);
		res = res.replaceAll("\\{", "").replaceAll("\\}", "");
		return res;
	}
	
}
