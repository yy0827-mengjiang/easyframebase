package cn.com.easy.xbuilder.service;


public interface ISQLVaildata {

	/**
	 * 解where条件是否符合规范
	 * 规范：{ and test = #test#}
	 * @param dataSourceName
	 * @param sql
	 * @return json字符串 正确[falg:true,res:and a=#a#;and b=#b#] 错误[falg:false,res:错误信息]
	 */
	public String firstSqlVail(String dataSourceName,String sql);
	
	/**
	 * sql语句中是否包含关键字
	 * @param dataSourceName
	 * @param sql
	 * @return json字符串 正确[falg:true,res:成功] 错误[falg:false,res:错误信息]
	 */
	public String secondSqlVail(String dataSourceName,String sql);
	
	/**
	 * 执行sql
	 * @param dataSourceName
	 * @param sql
	 * @return json字符串 正确[falg:true,colume:[列名],data:[数据]] 错误[falg:false,res:错误信息]
	 */
	public String thirdSqlExeucte(String dataSourceName,String sql,String page,String jsonString);
	
	/**
	 * 存入临时xml
	 * @param dataSourceName
	 * @param sql
	 * @param uid
	 * @param name
	 * @return json字符串 正确[falg:true] 错误[falg:false]
	 */
	public String addTmpDataSourceXml(String dataSourceName,String sql,String uid,String name,String reportId,String datatype);
	
	/**
	 * 存入正式xml加数据库
	 * @param dataSourceName
	 * @param sql
	 * @param uid
	 * @param name
	 * @return
	 */
	public String addDataSourceXml(String tmp,String id,String dataSourceName,String sql,String reference,String name,String reportId,String datatype);
}
