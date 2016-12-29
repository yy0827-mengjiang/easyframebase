package cn.com.easy.kpi.util;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.util.StringUtils;

public class Log {

	public static void SaveLog(SqlRunner runner,Object obj) {
		try {
			List<Map<String,Object>> list = getLogInfo(obj);
			String sql = getSql(list);
			Object[] o = getValues(list);
			runner.execute(sql, o);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public static List<Map<String, Object>> getLogInfo(Object obj) throws Exception {

		Class clazz = obj.getClass();
		Field[] fields = clazz.getDeclaredFields();
		List<Map<String, Object>> list = new LinkedList<Map<String, Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		LogAnnotation ano = (LogAnnotation) clazz
				.getAnnotation(LogAnnotation.class);
		map.put("name", ano.tableName());
		map.put("value", "");
		list.add(map);
		for (Field field : fields) {
			Map<String, Object> m = new HashMap<String, Object>();
			LogAnnotation ao = field.getAnnotation(LogAnnotation.class);
			if(null !=ao){
				field.setAccessible(true);
				m.put("name", ao.colnum());
				Object o = field.get(obj);
				m.put("value", o);
				list.add(m);
			}
		}
		map.put("field", list);
		return list;
	}

	public static String getSql(List<Map<String, Object>> list) {
		StringBuffer sql = new StringBuffer("INSERT INTO ");
		StringBuffer where = new StringBuffer(" )VALUES( ");
		for(int i=0;i<list.size();i++){
			Map<String,Object> map = list.get(i);
			if (i==0) {
				sql.append(map.get("name"));
				sql.append(" (");
			} else {
				sql.append(map.get("name"));
				sql.append(",");
				where.append("?,");
			}
		}
		String logSql = sql.toString().substring(0, sql.length() - 1);
		logSql = logSql + where.toString().substring(0, where.length() - 1);
		logSql = logSql + ")";
		return logSql;
	}
	
	public static Object[] getValues(List<Map<String, Object>> list){
		Object[] obj = new Object[list.size()-1];
		for(int i = 1;i<list.size();i++){
			Object o = list.get(i).get("value");
			obj[i-1] = o;
		}
		return obj;
	}
}
