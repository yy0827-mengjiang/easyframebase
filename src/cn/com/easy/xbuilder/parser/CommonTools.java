package cn.com.easy.xbuilder.parser;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.taglib.function.Functions;

public class CommonTools {
	private SqlRunner runner;

	public CommonTools() {

	}

	public CommonTools(SqlRunner runner) {
		this.runner = runner;
	}
	
	/**
	 * 
	 * @param reportid 报表ID
	 * @param pageGetComponentInfo 组件与数据集的对应关系
	 * @return 
	 * @throws SQLException 
	 */
	private String dataSetSql = "SELECT REPORT_SQL_ID, REPORT_ID, REPORT_SQL_NAME, REPORT_SQL,REPORT_SQL_TYPE  FROM SYS_REPORT_SQL T WHERE REPORT_SQL_ID=#sqlId#";
	public List<Map<String, String>> getReportDataSet(String reportid,String pageGetComponentInfo) throws SQLException, IOException {		List<Map<String, String>> DataSetSql = new ArrayList<Map<String, String>>();
		if(pageGetComponentInfo != null){
			String [] pageComponentInfo = pageGetComponentInfo.split("@");//得到页面几个组件
			Map sqlRs = new HashMap();
			for(String component:pageComponentInfo){
				Map comsqlmap = (Map)Functions.json2java(component);//把JSON转成MAP
				//System.out.println(comsqlmap);
				
				if(comsqlmap.get("type") != null && comsqlmap.get("type").toString().trim().equals("TABLE")){
					/**表格组件相关操作**/
					//每个组件的对象MAP
					Map DataSetSqlMap = new HashMap();
					//插入生成后的eaction 对应的变量值  
					DataSetSqlMap.put("id", "RS"+comsqlmap.get("com_id"));
					DataSetSqlMap.put("desc", comsqlmap.get("type")+"数据集");
					
					Map paramMap = new HashMap();//SQL参数
					paramMap.put("sqlId", comsqlmap.get("sql_id"));
					sqlRs = runner.queryForMap(dataSetSql, paramMap);//执行SQL取出数据集SQL
					//存放字段与group by后的变量
					String kpiSum = "";
					String sqlgroupstr = "";
					if(comsqlmap.get("kpi") !=null && comsqlmap.get("kpi").toString().indexOf("#") != -1){
						//维度 + 多指标 根据前台传过来的KPI串（kpi1,kpi2,kpi3）动态拼成一个带有SUM和别名的串 sum(kpi1) kpi,sum(kpi2) kpi
						kpiSum = "," + comsqlmap.get("kpi").toString().replace("#", ",");
					}else if(comsqlmap.get("kpi") !=null &&!comsqlmap.get("kpi").toString().trim().equals("")&& comsqlmap.get("kpi").toString().indexOf("#") == -1){
						//维度 + 单个指标 根据前台传过来的KPI串（kpi1)
						kpiSum = "," + comsqlmap.get("kpi").toString().trim();
					}else{
						//单指标
						kpiSum = "";
					}
					//再次拼一个SQL
					String dataset = " SELECT "+comsqlmap.get("dim")+kpiSum+" FROM ("+Functions.toString(sqlRs.get("REPORT_SQL"))+") inits " + sqlgroupstr;
					//放入组件的对象MAP中
					DataSetSqlMap.put("type", "datagrid");
					DataSetSqlMap.put("sql", dataset);
					DataSetSqlMap.put("dataSourceName", sqlRs.get("REPORT_SQL_TYPE"));
					//最后放入到对象LIST中
					DataSetSql.add(DataSetSqlMap);
				}else if(comsqlmap.get("type") != null && comsqlmap.get("type").toString().trim().toLowerCase().equals("treegrid")){
					/**下钻表格相关操作**/
					Map paramMap = new HashMap();//SQL参数
					String sqlCodeStr = comsqlmap.get("sql_id")+"";//数据集S	QL id
					String fieldcolNameStr = comsqlmap.get("fieldcol") + "";//下钻field
					String dimcodeStr = comsqlmap.get("dim") + ""; //:固定的那个ID 这两个不是数组
					String dimdescStr = comsqlmap.get("dimdesc") + ""; //:固定的那个desc 这两个不是数组
					String drillcolcodeStr = comsqlmap.get("drillcolcode") + ""; //:固定的那个ID 对应SQL的字段
					String drillcoldescStr = comsqlmap.get("drillcoldesc") + ""; //:固定的那个DESC 对应SQL的字段
					String kpiStr = comsqlmap.get("kpi") + "";//所有绑定的列
					String []sqlCodes = sqlCodeStr.split("#");//下钻存在多个SQL
					String []fieldcolNames = fieldcolNameStr.split("#");//下钻field数组
					String []drillcolcodes = drillcolcodeStr.split("#");//:固定的那个ID 对应SQL的字段
					String []drillcoldescs = drillcoldescStr.split("#");//:固定的那个DESC 对应SQL的字段
					//String []kpis = kpiStr.split("#");////所有绑定的列
					//根据数据集个数进行循环 拼SQL
					for (int i = 0; i < sqlCodes.length; i++) {
						//每个组件的对象MAP
						Map DataSetSqlMap = new HashMap();
						//插入生成后的eaction 对应的变量值  
						DataSetSqlMap.put("id", "RS"+comsqlmap.get("com_id"));
						DataSetSqlMap.put("desc", comsqlmap.get("type")+"数据集");
						
						paramMap.put("sqlId", sqlCodes[i]);
						sqlRs = runner.queryForMap(dataSetSql, paramMap);//执行SQL取出数据集SQL
						String kpiColmuns = "";
						//根据绑定的所有列进行设置
//						for(String kpicol:kpis){
//							//判断ID对应的列
//							if(kpicol!=null&& kpicol.trim().equals(drillcolcodes[i].toString().trim())){
//								kpiColmuns += (kpicol + "  " + dimcodeStr+",");
//							}else if(kpicol!=null&& kpicol.trim().equals(drillcoldescs[i].toString().trim())){
//								kpiColmuns += (kpicol + "  " + dimdescStr+",");
//							}else{
//								kpiColmuns += kpicol +",";
//							}
//						}
						kpiColmuns += drillcolcodes[i] + " \"" + "_idField\"," + drillcoldescs[i] + " \"" + dimdescStr.trim() + "_treeField\",";
						kpiColmuns += kpiStr.replace("#", ",");
						if(kpiColmuns.trim().endsWith(","))
							kpiColmuns = kpiColmuns.substring(0, kpiColmuns.length() -1);
						String dataset = " select "+kpiColmuns+" from ("+Functions.toString(sqlRs.get("REPORT_SQL"))+") inits";
						//放入组件的对象MAP中
						DataSetSqlMap.put("type", "treegrid");
						DataSetSqlMap.put("dimField", fieldcolNames[i]);
						DataSetSqlMap.put("sql", dataset);
						DataSetSqlMap.put("dataSourceName", sqlRs.get("REPORT_SQL_TYPE"));
						//最后放入到对象LIST中
						DataSetSql.add(DataSetSqlMap);
					}
				}else{
					/**图形组件相关操作**/
					//每个组件的对象MAP
					Map DataSetSqlMap = new HashMap();
					//插入生成后的eaction 对应的变量值  
					DataSetSqlMap.put("id", "RS"+comsqlmap.get("com_id"));
					DataSetSqlMap.put("desc", comsqlmap.get("type")+"数据集");
					
					Map paramMap = new HashMap();//SQL参数
					paramMap.put("sqlId", comsqlmap.get("sql_id"));
					sqlRs = runner.queryForMap(dataSetSql, paramMap);//执行SQL取出数据集SQL
					//存放字段与group by后的变量
					String kpiSum = "";
					String sqlgroupstr = "";
					if(comsqlmap.get("kpi") !=null && comsqlmap.get("kpi").toString().indexOf("#") != -1){
						//多指标 根据前台传过来的KPI串（kpi1,kpi2,kpi3）动态拼成一个带有SUM和别名的串 sum(kpi1) kpi,sum(kpi2) kpi
						for(String ksum:comsqlmap.get("kpi").toString().split("#")){
							kpiSum += " SUM("+ksum+") as \""+ksum +"\",";
						}
						kpiSum = "," +kpiSum.substring(0,kpiSum.length()-1);
						sqlgroupstr = "GROUP BY "+comsqlmap.get("dim");
					}else{
						//单指标
						kpiSum = ",SUM("+comsqlmap.get("kpi")+") as \""+comsqlmap.get("kpi")+"\"";
						sqlgroupstr = "GROUP BY "+comsqlmap.get("dim");
					}
					String orderby = "";
					if (comsqlmap.get("sortcol") != null && !comsqlmap.get("sortcol").toString().equals("")
							&& !comsqlmap.get("sortcol").toString().toLowerCase().equals("undefined")
							&& !comsqlmap.get("sortcol").toString().toLowerCase().equals("null")) {
						if(!(comsqlmap.get("dim").toString().toLowerCase().equals(comsqlmap.get("sortcol").toString().toLowerCase()))){
							orderby = " ," + comsqlmap.get("sortcol") + " order by \"" + comsqlmap.get("sortcol")+"\"";
						}else{
							orderby = " order by \"" + comsqlmap.get("sortcol")+"\"";
						}
					}
					
					//再次拼一个SQL
					String dataset = " SELECT "+comsqlmap.get("dim")+kpiSum+" FROM ("+Functions.toString(sqlRs.get("REPORT_SQL"))+") inits " + sqlgroupstr + orderby;
					//放入组件的对象MAP中
					DataSetSqlMap.put("type", "echart");
					DataSetSqlMap.put("sql", dataset);
					DataSetSqlMap.put("dataSourceName", sqlRs.get("REPORT_SQL_TYPE"));
					//最后放入到对象LIST中
					DataSetSql.add(DataSetSqlMap);
				}
			}
		}
		return DataSetSql;
	}
	/**
	 * 判断是否为汉字
	 * @param c
	 * @return
	 */
	public static boolean isChinese(char c) {  
	    Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);  
	    if (ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS  
	        || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS  
	        || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A  
	        || ub == Character.UnicodeBlock.GENERAL_PUNCTUATION  
	        || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION  
	        || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS) {  
	      return true;  
	    }  
	    return false;  
	  }  
	
	public static boolean isLetterOrDigit(char chr){
		if(chr<32||chr>126){
			return false;
		}
		return true;
	}
	/**
	 * 判断是否为乱码
	 * @param strName
	 * @return
	 */
	  public static boolean isMessyCode(String strName) {  
	    Pattern p = Pattern.compile("\\s*|\t*|\r*|\n*");  
	    Matcher m = p.matcher(strName);  
	    String after = m.replaceAll("");  
	    String temp = after.replaceAll("\\p{P}", "");  
	    char[] ch = temp.trim().toCharArray();  
	    float chLength = ch.length;  
	    float count = 0;  
	    for (int i = 0; i < ch.length; i++) {  
	      char c = ch[i]; 
	      if (!isLetterOrDigit(c)) {
	  
	        if (!isChinese(c)) {  
	          count = count + 1;  
	          //System.out.print(c);  
	        }  
	      }  
	    }  
	    float result = count / chLength;  
	    if (result > 0) {  
	      return true;  
	    } else {  
	      return false;  
	    }  
	  }
	  public boolean cisMessyCode(String strName) {  
		    Pattern p = Pattern.compile("\\s*|\t*|\r*|\n*");  
		    Matcher m = p.matcher(strName);  
		    String after = m.replaceAll("");  
		    String temp = after.replaceAll("\\p{P}", "");  
		    char[] ch = temp.trim().toCharArray();  
		    float chLength = ch.length;  
		    float count = 0;  
		    for (int i = 0; i < ch.length; i++) {  
		      char c = ch[i]; 
		      if (!isLetterOrDigit(c)) {
		  
		        if (!isChinese(c)) {  
		          count = count + 1;  
		          //System.out.print(c);  
		        }  
		      }  
		    }  
		    float result = count / chLength;  
		    if (result > 0) {  
		      return true;  
		    } else {  
		      return false;  
		    }  
		  }
	   
	  public static Connection getConnection() throws SQLException{
		  return getDataSource("").getConnection();
	  }
	  
	  public static Connection getConnection(String dataSourceName) throws SQLException{
		  return getDataSource(dataSourceName).getConnection();
	  }
	  
	  public static EasyDataSource getDataSource(String dataSourceName){
		  EasyDataSource dataSource = null;
		  if(dataSourceName!= null && !dataSourceName.trim().equals("") && dataSourceName.trim().length() > 0)
			  dataSource = EasyContext.getContext().getDataSource(dataSourceName.trim());
		  else 
			  dataSource = EasyContext.getContext().getDataSource();
		  return dataSource;
	  }
	  public EasyDataSource getDBName(String dataSourceName){
		  EasyDataSource dataSource = null;
		  if(dataSourceName!= null && !dataSourceName.trim().equals("") && dataSourceName.trim().length() > 0)
			  dataSource = EasyContext.getContext().getDataSource(dataSourceName.trim());
		  else 
			  dataSource = EasyContext.getContext().getDataSource();
		  return dataSource;
	  }
	  
	  public static String getDataSourceDB(String dataSourceName){
		  return getDataSource(dataSourceName).getDataSourceDB().toLowerCase();
	  }
	  public static String getSql(String dataSourceName,String sql)
		{
		  	//System.out.println("111:"+getDataSource(dataSourceName).getDataSourceDB().toLowerCase());
			StringBuffer sqlBuffer = new StringBuffer();
			if ("oracle".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from ( ").append(sql).append(") inits where rownum <=10");
				return sqlBuffer.toString();
			}
			else if ("mysql".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") init limit 0 , 10");
				return sqlBuffer.toString();
			}
			else if("xcloud".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase())){
				//sqlBuffer.append(sql);
				sqlBuffer.append("select * from (").append(sql).append(") limit (0,10)");
				return sqlBuffer.toString();
			}
			else if ("sqlite".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") limit 10 offset 1");
				return sqlBuffer.toString();
			}
			else if ("sqlserver".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select top 10 * from (").append(sql).append(") easyTempTable1 ORDER BY ID");
				return sqlBuffer.toString();
			}
			else if ("gp".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{ 
				//sqlBuffer.append("select * from (").append(sql).append(") inits limit 10 offset 0");
				sqlBuffer.append(sql).append(" limit 10 offset 0");
				return sqlBuffer.toString();
			}
			else if ("hive0.91".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") t  limit 10");
				return sqlBuffer.toString();
			}
			else if ("hive0.92".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") t  limit 10");
				return sqlBuffer.toString();
			}else if ("vertica".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") inits limit 10 offset 0");
				return sqlBuffer.toString();
			}else if ("teradata".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				//qualify row_number() over(order by id) >= 0 and row_number() over(order by id) <= 10
				sqlBuffer.append("select top 10 * from (").append(sql).append(") inits ");
				return sqlBuffer.toString();
			}else if ("db2".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") inits fetch first 10 rows only");
				return sqlBuffer.toString();
			}
			else if (getDataSource(dataSourceName).getDataSourceDB().toLowerCase().contains("postgre"))
			{
				sqlBuffer.append("select * from ( "+sql+") inits limit 10 offset 0");
				return sqlBuffer.toString();
			}
			else
			{
				sqlBuffer.append("select * from ( ").append(sql).append(") inits where rownum <=10");
				return sqlBuffer.toString();
			}
		}
	  public String getPageSql(String dataSourceName,String sql,int start,int end){
			StringBuffer sqlBuffer = new StringBuffer();
			if ("oracle".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (select rownum num, init.* from("+ sql + ") init where rownum <= " + end+ ") dgst where num > " + start);
				return sqlBuffer.toString();
			}
			else if ("mysql".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") init limit "+start+" ,"+end);
				return sqlBuffer.toString();
			}
			else if("xcloud".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase())){
				//sqlBuffer.append(sql);
				//sqlBuffer.append("select * from (").append(sql).append(") limit (0,"+end+")");
				sqlBuffer.append(sql).append(" limit ("+start+","+end+")");
				return sqlBuffer.toString();
			}
			else if ("sqlite".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") limit "+end+" offset 1");
				return sqlBuffer.toString();
			}
			else if ("sqlserver".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select top "+end+" * from (").append(sql).append(") easyTempTable1 ORDER BY ID");
				return sqlBuffer.toString();
			}
			else if ("gp".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{ 
				sqlBuffer.append(sql).append(" limit "+end+" offset "+start);
				return sqlBuffer.toString();
			}
			else if ("hive0.91".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") t  limit "+end);
				return sqlBuffer.toString();
			}
			else if ("hive0.92".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") t  limit "+end);
				return sqlBuffer.toString();
			}else if ("vertica".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") inits limit "+end+" offset "+start);
				return sqlBuffer.toString();
			}else if ("teradata".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select top "+end+" * from (").append(sql).append(") inits ");
				return sqlBuffer.toString();
			}
			else if (getDataSource(dataSourceName).getDataSourceDB().toLowerCase().contains("db2"))
			{
				  sqlBuffer.append("select * from ( select ROW_NUMBER() OVER() as rownum,inits.* from ("+sql+") inits) where rownum > "+start+" and rownum <= "+end);
				  return sqlBuffer.toString();
			}
			else if (getDataSource(dataSourceName).getDataSourceDB().toLowerCase().contains("postgresql"))
			{
				sqlBuffer.append("select * from ( "+sql+") inits limit "+end+" offset "+start);
				return sqlBuffer.toString();
			}
			else
			{
				sqlBuffer.append("select * from (select rownum num, init.* from("+ sql + ") init where rownum <= " + end+ ") dgst where num > " + start);
				return sqlBuffer.toString();
			}
		}
	  /**
		 * 
		 * @param sqlStatement
		 * @return 返回字段 与 变量  如;  and area_no = #area#  map.get("col") = " and area_no = "; map.get("var") = "area"
		 */
		@SuppressWarnings("unused")
		public static List<Map> transformSqlVar(String sqlStatement) {
			List<Map> transList = new ArrayList<Map>();
			StringBuffer sqlBuffer = new StringBuffer("");
			String sql = sqlStatement;
			sql = sql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\\{", "<f>").replaceAll("\\}", "<f>");
			String []sqlStr = sql.split("<f>");
			if(sqlStr.length <=1 || sql.indexOf("#") == -1){
				Map varTem = new HashMap();
				varTem.put("sql", sqlStatement);
				transList.add(varTem);
			}
			for(int i=0;i<sqlStr.length;i++){
				Map varTem = new HashMap();
				if (i % 2 != 1) {
					//SQL体
					sqlBuffer.append(sqlStr[i]);
				}else{
					//WHERE体
					StringBuffer ifTag = new StringBuffer("");
					if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
						ifTag.append("\n").append("  ");
					}else{
						ifTag.append(" 1=1 ").append(" ");
					}
					String [] b= sqlStr[i].trim().split("#");
					int step = 0;
					if(b.length >= 2){
						if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
							varTem.put("col", b[0]);
							varTem.put("var", b[1]);
						}else{
							varTem.put("col", " and "+b[0]);
							varTem.put("var", b[1]);
						}
					}
					sqlBuffer.append(ifTag.toString());
					varTem.put("sql", sqlBuffer.toString());
					transList.add(varTem);
				}
			}
			return transList;
		}
		
	  public static String getDimSqlFina(String sqlString,HttpServletRequest request){
		  StringBuffer sqlBuffer = new StringBuffer();
			List<Map> truncSql = transformSqlVar(sqlString);
			int step = 0;
			for(Map sqlVar : truncSql){
				if(step == 0){
					sqlBuffer.append("" + sqlVar.get("sql"));
				}
				if(sqlVar.get("var") != null && 
				   !sqlVar.get("var").equals("")&& 
				   !sqlVar.get("var").toString().toLowerCase().equals("null")&&
				   !sqlVar.get("var").toString().toUpperCase().equals("AREA_NO")&& 
				   !sqlVar.get("var").toString().toUpperCase().equals("CITY_NO")){
					if(request.getParameter(""+sqlVar.get("var")) != null && 
					    !((String)request.getParameter(""+sqlVar.get("var"))).equals("")&& 
					    !((String)request.getParameter(""+sqlVar.get("var"))).toLowerCase().equals("null")){
						sqlBuffer.append(" ").append(sqlVar.get("col")).append(" '").append(request.getParameter(""+sqlVar.get("var"))).append("' ");
					}else if(request.getAttribute(""+sqlVar.get("var")) != null && 
							!((String)request.getAttribute(""+sqlVar.get("var"))).equals("")&& 
							!((String)request.getAttribute(""+sqlVar.get("var"))).toLowerCase().equals("null")){
						sqlBuffer.append(" ").append(sqlVar.get("col")).append(" '").append(request.getAttribute(""+sqlVar.get("var"))).append("' ");
					}else if(request.getSession().getAttribute(""+sqlVar.get("var")) != null && 
							!((String)request.getSession().getAttribute(""+sqlVar.get("var"))).equals("")&& 
							!((String)request.getSession().getAttribute(""+sqlVar.get("var"))).toLowerCase().equals("null")){
						sqlBuffer.append(" ").append(sqlVar.get("col")).append(" '").append(request.getSession().getAttribute(""+sqlVar.get("var"))).append("' ");
					}
				}else if(sqlVar.get("var") != null && 
						!sqlVar.get("var").equals("")&& 
						!sqlVar.get("var").toString().toLowerCase().equals("null")&&
						(sqlVar.get("var").toString().toUpperCase().equals("AREA_NO")|| sqlVar.get("var").toString().toUpperCase().equals("CITY_NO"))){
					if(request.getParameter(""+sqlVar.get("var")) != null && 
					   !((String)request.getParameter(""+sqlVar.get("var"))).equals("")&& 
					   !((String)request.getParameter(""+sqlVar.get("var"))).equals("-1")&& 
					   !((String)request.getParameter(""+sqlVar.get("var"))).toLowerCase().equals("null")){
						sqlBuffer.append(" ").append(sqlVar.get("col")).append(" '").append(request.getParameter(""+sqlVar.get("var"))).append("' ");
					}else if(request.getAttribute(""+sqlVar.get("var")) != null && 
							!((String)request.getAttribute(""+sqlVar.get("var"))).equals("")&& 
							!((String)request.getAttribute(""+sqlVar.get("var"))).equals("-1")&& 
							!((String)request.getAttribute(""+sqlVar.get("var"))).toLowerCase().equals("null")){
						sqlBuffer.append(" ").append(sqlVar.get("col")).append(" '").append(request.getAttribute(""+sqlVar.get("var"))).append("' ");
					}else if(request.getSession().getAttribute(""+sqlVar.get("var")) != null && 
							!((String)request.getSession().getAttribute(""+sqlVar.get("var"))).equals("")&& 
							!((String)request.getSession().getAttribute(""+sqlVar.get("var"))).equals("-1")&& 
							!((String)request.getSession().getAttribute(""+sqlVar.get("var"))).toLowerCase().equals("null")){
						sqlBuffer.append(" ").append(sqlVar.get("col")).append(" '").append(request.getSession().getAttribute(""+sqlVar.get("var"))).append("' ");
					}
				}
				step ++;
			}
		  return sqlBuffer.toString();
	  }
	  
	  @SuppressWarnings("unused")
		public static String transformSqlForDim(String dimSqlStatement) {
			StringBuffer sqlBuffer = new StringBuffer();
			String sql = dimSqlStatement;
			sql = sql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\\{", "<f>").replaceAll("\\}", "<f>");
			String []sqlStr = sql.split("<f>");
			for(int i=0;i<sqlStr.length;i++){
				if (i % 2 != 1) {
					//SQL体
					sqlBuffer.append(sqlStr[i]);
				}else{
					//WHERE体
					StringBuffer ifTagSessionScope = new StringBuffer("");//sessionScope
					if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
						ifTagSessionScope.append("\n").append("      <e:if condition=\"${");
					}else{
						ifTagSessionScope.append(" 1=1 ").append("\n").append("      <e:if condition=\"${");
					}
					String [] b= sqlStr[i].trim().split("#");
					int step = 0;
					for(int c = 0;c<b.length;c++){
						if (c % 2 == 1) {
							step ++;

							ifTagSessionScope.append("(");
							ifTagSessionScope.append("(");
							ifTagSessionScope.append("(sessionScope.").append(b[c]).append(" != null)");
							ifTagSessionScope.append("&&");
							ifTagSessionScope.append("(sessionScope.").append(b[c]).append(" != '')");
							ifTagSessionScope.append("&&");
							ifTagSessionScope.append("(sessionScope.").append(b[c]).append(" != 'null')");
							if(b[c].toUpperCase().equals("CITY_NO")||b[c].toUpperCase().equals("AREA_NO")){
								ifTagSessionScope.append("&&");
								ifTagSessionScope.append("(sessionScope.").append(b[c]).append(" != '-1')");
							}
							ifTagSessionScope.append(")");
							ifTagSessionScope.append(")");
							if(c!=b.length-2&&c!=b.length-1){
								ifTagSessionScope.append("&&");
							}
						}
					}
					if(step ==0){
						ifTagSessionScope.append("true");
					}
					ifTagSessionScope.append("}\">").append("\n");
					if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
						/*for(int m = 0;m<b.length;m++){
							
							if (m % 2 != 1) {
								ifTagSessionScope.append("        "+b[m]);
							}else{
								ifTagSessionScope.append("'${sessionScope."+b[m]).append("}'\n");
							}
						}*/
						ifTagSessionScope.append("        "+b[0]+"'${sessionScope."+b[1]).append("}'\n");
					}else{
						/*for(int m = 0;m<b.length;m++){
							if(m==0){
								ifTagSessionScope.append("       and "+b[m]);
							}else{
								if (m % 2 != 1) {
									ifTagSessionScope.append("        "+b[m]);
								}else{
									ifTagSessionScope.append("'${sessionScope."+b[m]).append("}'\n");
								}
							}
						}*/
						ifTagSessionScope.append("        and "+b[0]+"'${sessionScope."+b[1]).append("}'\n");
					}
					ifTagSessionScope.append("      </e:if>").append("\n      ");
					sqlBuffer.append(ifTagSessionScope.toString());
				}
			}
			return sqlBuffer.toString();
		}
	  
	  /**
		 * 过滤查询条件[如果有Session中的值为 “” 替换掉]
		 * @param sqlString
		 * @param request
		 * @return
		 * @throws SQLException 
		 */
		public static String getDimSqlFilterWhere(String sqlString,
				HttpServletRequest request) throws SQLException {
			Map<String, String> sessionMap = setSessionMap(request);
			List<String> measures = new ArrayList<String>();
			Pattern p = Pattern.compile("\\{(.*?)\\}");
			Matcher m = p.matcher(sqlString);  
			while(m.find()){  
				measures.add(m.group(1));  
			}
			if(measures!=null&&measures.size()>0){
				for(int i=0;i<measures.size();i++){
					String andVal = measures.get(i);
					String key = andVal.split("#")[1];
					String seVal = sessionMap.get(key)+"";
					if("".equals(seVal) || null==seVal){
						sqlString = sqlString.replaceAll("\\{"+andVal+"\\}", "");
					}
				}
			}
			
			String sql = "";
			/**
			 * 大小
			 * **/
			if(sqlString.indexOf("PARENT_COL")!=-1){
				sql = "select code as \"CODE\" , codedesc as \"CODEDESC\" , parent_col as \"PARENT_COL\" from ("+sqlString+") bb ";
			}else{
				sql = "select code as \"CODE\" , codedesc as \"CODEDESC\"  from ("+sqlString+") aa ";
			}
			
			
			return sql;
		}

		/**
		 * 存入扩展属性表中不存在 Session 中的对象
		 * @param request
		 * @return
		 * @throws SQLException 
		 */
		@SuppressWarnings("unchecked")
		public static Map<String, String> setSessionMap(HttpServletRequest request){
			Map<String, String> sessionMap = (Map<String, String>) request.getSession().getAttribute("UserInfo");
			Connection conn = null;
			PreparedStatement stat = null;
			try{
				EasyDataSource dataSource  = EasyContext.getContext().getDataSource();
				String sql = "select t.attr_code,t.attr_name from e_user_attr_dim t ";
				conn = dataSource.getConnection();
				stat = conn.prepareStatement(sql);
				ResultSet rs = stat.executeQuery();
				while(rs.next()){
					String key = rs.getString("ATTR_CODE")+"";
					String value = "";
					String tmpKey = sessionMap.get(key);
					if(tmpKey==null){
						sessionMap.put(key, value);
					}
				}
				rs.close();
			}catch(Exception e){
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
			return sessionMap;
		}
}
