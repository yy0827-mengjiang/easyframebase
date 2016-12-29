package cn.com.easy.down.server;

import java.sql.Connection;
import java.sql.SQLException;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;


public class CommonToolsUtil {

	public CommonToolsUtil() {

	}

	public static Connection getConnection() throws SQLException {
		return getDataSource("").getConnection();
	}

	public static Connection getConnection(String dataSourceName)
			throws SQLException {
		return getDataSource(dataSourceName).getConnection();
	}

	public static EasyDataSource getDataSource(String dataSourceName) {
		EasyDataSource dataSource = null;
		if (dataSourceName != null && !dataSourceName.trim().equals("")
				&& dataSourceName.trim().length() > 0)
			dataSource = EasyContext.getContext().getDataSource(
					dataSourceName.trim());
		else
			dataSource = EasyContext.getContext().getDataSource();
		return dataSource;
	}

	public static String getDataSourceDB(String dataSourceName) {
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
		}
		else if ("teradata".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
		{
			sqlBuffer.append("select top 10 * from (").append(sql).append(") inits ");
			return sqlBuffer.toString();
		}
		else
		{
			sqlBuffer.append("select * from ( ").append(sql).append(") inits where rownum <=10");
			return sqlBuffer.toString();
		}
	}
	
	public static String getSqlRows(String dataSourceName,String sql,int start,int end)
	{
		StringBuffer sqlBuffer = new StringBuffer();
		if ("oracle".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
		{
			sqlBuffer.append("select * from ( select t.*,rownum num from ( ").append(sql).append(") t where rownum <= ").append(end).append(") where num>").append(start);
			return sqlBuffer.toString();
		}
		else if ("mysql".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
		{
			sqlBuffer.append("select * from (").append(sql).append(") init limit ").append(start).append(" , ").append(end);
			return sqlBuffer.toString();
		}
		else if ("sqlite".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
		{
			sqlBuffer.append("select * from (").append(sql).append(") limit ").append(end).append(" offset ").append(start);
			return sqlBuffer.toString();
		}
		else if("xcloud".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase())){
			sqlBuffer.append("select * from (").append(sql).append(") limit(").append(start).append(",").append(end).append(")");
			return sqlBuffer.toString();
		}
		else if ("sqlserver".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
		{
			sqlBuffer.append("select top "+end+" * from (").append(sql).append(") easyTempTable1 where (ID NOT IN (SELECT TOP "+start+" ID FROM (").append(sql).append(") easyTempTable2 ORDER BY ID)) ORDER BY ID");
			return sqlBuffer.toString();
		}
		else if ("gp".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
		{ 
			sqlBuffer.append(sql).append(" limit "+end+" offset "+start+"");
			return sqlBuffer.toString(); 
		}
		else if ("hive0.91".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
		{
			sqlBuffer.append("select * from (select * from (select * from (").append(sql).append(") t order by ord asc limit "+end+") t1 order by ord desc limit "+start+") t2 order by ord asc");
			return sqlBuffer.toString();
		}
		else if ("hive0.92".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
		{
			sqlBuffer.append("select * from (select * from (").append(sql).append(") t order by ord asc limit "+end+") t1 order by ord desc limit "+start+"");
			return sqlBuffer.toString();
		}else if ("vertica".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
		{
			sqlBuffer.append("select * from (").append(sql).append(") easyTempTable_gp limit "+end+" offset "+start+"");
			return sqlBuffer.toString();
		}
		else if ("teradata".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
		{
			sqlBuffer.append("select top "+end+" * from (").append(sql).append(") easyTempTable1 where (ID NOT IN (SELECT TOP "+start+" ID FROM (").append(sql).append(") easyTempTable2 ORDER BY ID)) ORDER BY ID");
			return sqlBuffer.toString();
		}else if ("db2".equals(getDataSource(dataSourceName).getDataSourceDB().toLowerCase()))
		{
			sqlBuffer.append("select * from ( select t.*,ROW_NUMBER() OVER() as rownum from (").append(sql).append(") t)  where rownum> "+start+" and rownum<="+end);
			return sqlBuffer.toString();
		}
		else
		{
			sqlBuffer.append("select * from ( select t.*,rownum num from ( ").append(sql).append(") t where rownum <= ").append(end).append(") where num>").append(start);
			return sqlBuffer.toString();
		}
	}
}
