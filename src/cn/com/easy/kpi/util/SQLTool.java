package cn.com.easy.kpi.util;

import java.util.HashMap;
import java.util.Map;

import cn.com.easy.core.EasyContext;

public class SQLTool {

	public static String getSql(String dataBase,String Sql){
		StringBuffer sqlBuffer = new StringBuffer();
		if(null==dataBase||"".equals(dataBase)){
			sqlBuffer.append("select * from ( ").append(Sql).append(") inits where rownum <=1");
			return sqlBuffer.toString();
		}
		if ("oracle".equals(dataBase.toLowerCase()))
		{
			sqlBuffer.append("select * from ( ").append(Sql).append(") inits where rownum <=1");
			return sqlBuffer.toString();
		}
		else if ("mysql".equals(dataBase.toLowerCase()))
		{
			sqlBuffer.append("select * from (").append(Sql).append(") init limit 1 , 2");
			return sqlBuffer.toString();
		}
		else if ("sqlite".equals(dataBase.toLowerCase()))
		{
			sqlBuffer.append("select * from (").append(Sql).append(") limit 10 offset 1");
			return sqlBuffer.toString();
		}
		else if ("sqlserver".equals(dataBase.toLowerCase()))
		{
			sqlBuffer.append("select top 10 * from (").append(Sql).append(") easyTempTable1 ORDER BY ID");
			return sqlBuffer.toString();
		}
		else if ("gp".equals(dataBase.toLowerCase()))
		{ 
			sqlBuffer.append("select * from (").append(Sql).append(") inits limit 10 offset 0");
			return sqlBuffer.toString();
		}
		else if ("hive0.91".equals(dataBase.toLowerCase()))
		{
			sqlBuffer.append("select * from (").append(Sql).append(") t  limit 10");
			return sqlBuffer.toString();
		}
		else if ("hive0.92".equals(dataBase.toLowerCase()))
		{
			sqlBuffer.append("select * from (").append(Sql).append(") t  limit 10");
			return sqlBuffer.toString();
		}else if ("vertica".equals(dataBase.toLowerCase()))
		{
			sqlBuffer.append("select * from (").append(Sql).append(") inits limit 10 offset 0");
			return sqlBuffer.toString();
		}else if ("teradata".equals(dataBase.toLowerCase()))
		{
			sqlBuffer.append("select top 10 * from (").append(Sql).append(") inits ");
			return sqlBuffer.toString();
		}else if("xcloud".equals(dataBase.toLowerCase())){
			sqlBuffer.append("select * from (").append(Sql).append(") limit(0,1) ");
			return sqlBuffer.toString();
		}else
		{
			sqlBuffer.append("select * from ( ").append(Sql).append(") inits where rownum <=1");
			return sqlBuffer.toString();
		}
	}
	//jndi,java:/comp/env/jndi/datasource3,oracle
	public static String getDBType(String dataSourceName){
		String[] dataSource = EasyContext.getContext().getServletcontext().getInitParameter("easyExtDataSource").split(";");
		Map<String,String> map = new HashMap<String,String>();
		for(int i=0;i<dataSource.length;i++){
			String dataSourceName1 = dataSource[i].split(",")[1];
			String dbType = dataSource[i].split(",")[2];
			map.put(dataSourceName1,dbType);
		}
		return map.get(dataSourceName);
	}
	
}
