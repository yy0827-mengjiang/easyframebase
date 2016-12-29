package cn.com.easy.ebuilder.parser;

import java.io.IOException;
import java.sql.Connection;
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
				System.out.println(comsqlmap);
				
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
				}else if(comsqlmap.get("type") != null && comsqlmap.get("type").toString().trim().equals("TREETABLE")){
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
							kpiSum += " SUM("+ksum+") "+ksum +",";
						}
						kpiSum = "," +kpiSum.substring(0,kpiSum.length()-1);
						sqlgroupstr = "GROUP BY "+comsqlmap.get("dim");
					}else{
						//单指标
						kpiSum = ",SUM("+comsqlmap.get("kpi")+") "+comsqlmap.get("kpi");
						sqlgroupstr = "GROUP BY "+comsqlmap.get("dim");
					}
					String orderby = "";
					if (comsqlmap.get("sortcol") != null && !comsqlmap.get("sortcol").toString().equals("")
							&& !comsqlmap.get("sortcol").toString().toLowerCase().equals("undefined")
							&& !comsqlmap.get("sortcol").toString().toLowerCase().equals("null")) {
						if(!(comsqlmap.get("dim").toString().toLowerCase().equals(comsqlmap.get("sortcol").toString().toLowerCase()))){
							orderby = " ," + comsqlmap.get("sortcol") + " order by " + comsqlmap.get("sortcol");
						}else{
							orderby = " order by " + comsqlmap.get("sortcol");
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
	          System.out.print(c);  
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
	  
	  public static String getDataSourceDB(String dataSourceName){
		  return getDataSource(dataSourceName).getDataSourceDB().toLowerCase();
	  }
	  public static String getSql(String dataSourceName,String sql)
		{
			StringBuffer sqlBuffer = new StringBuffer();
			if ("oracle".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from ( ").append(sql).append(") inits where rownum <=10");
				return sqlBuffer.toString();
			}
			else if ("mysql".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") init limit 1 , 10");
				return sqlBuffer.toString();
			}
			else if ("sqlite".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select * from (").append(sql).append(") limit 10 offset 1");
				return sqlBuffer.toString();
			}
			else if("xcloud".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase())){
				//sqlBuffer.append(sql);
				sqlBuffer.append("select * from (").append(sql).append(") limit (0,10)");
				return sqlBuffer.toString();
			}
			else if ("sqlserver".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{
				sqlBuffer.append("select top 10 * from (").append(sql).append(") easyTempTable1 ORDER BY ID");
				return sqlBuffer.toString();
			}
			else if ("gp".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
			{ 
				sqlBuffer.append("select * from (").append(sql).append(") inits limit 10 offset 0");
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
				sqlBuffer.append("select top 10 * from (").append(sql).append(") inits ");
				return sqlBuffer.toString();
			}
			else if(getDataSource(dataSourceName).getDataSourceDB().toLowerCase().contains("db2")){
				sqlBuffer.append("select * from ( select ROW_NUMBER() OVER() as rownum,init.* from ("+sql+") init) where rownum <=10 "); 
				return sqlBuffer.toString();
			}
			else
			{
				sqlBuffer.append("select * from ( ").append(sql).append(") inits where rownum <=10");
				return sqlBuffer.toString();
			}
		}
	  
	  public static String getDimSqlFina(String sqlString,HttpServletRequest request){
		  StringBuffer sqlBuffer = new StringBuffer();
		  BuildReportAction build = new BuildReportAction();
			List<Map> truncSql = build.transformSqlVar(sqlString);
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
}
