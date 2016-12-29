package cn.com.easy.ebuilder.util;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import cn.com.easy.util.SqlUtils;


public class ListUtil {
	
	public static List<Map> delNullRow(List<Map> lm){
		List<Map> new_list = new ArrayList<Map>();
		for(Map m : lm){
			boolean isNull = true;
			if(m==null||(m!=null&&m.size()==0))
				continue;
			for(Object o : m.keySet())
				if(m.get(o)!=null){
					isNull = false;
					break;
				}
			if(isNull)
				continue;
			new_list.add(m);
		}
		return new_list;
	}
	/**
	 * 
	 * @param arg0 全部
	 * @param arg1 部分
	 * @return
	 */
	public static boolean isEq(List<String> arg0,List<String> arg1){
		boolean isEq = true;
		for(String s : arg1)
			if(!arg0.contains(s.toUpperCase()))
				isEq = false;
		return isEq;
	}
	


	public static List removeDuplicateWithOrder(List list) {
			Set set = new HashSet();
	        List newList = new ArrayList();
	        for (Iterator iter = list.iterator(); iter.hasNext();){ 
		        	Object element = iter.next();
		        	if (set.add(element))
		        		newList.add(element);
	        	} 
	        return newList;
	    }
	public static void main(String[] args) {
		List<String> parameterNames = new ArrayList<String>();
		String tempSql = "select tt from df where a=#a# and b=#b# and c=#a# and d=#b#";
		StringBuffer sqlBuf = new StringBuffer("select tt from df where a=#a# and b=#b# and c=#a# and d=#b#");
		SqlUtils.parseParameter("select tt from df where a=#a# and b=#b# and c=#a# and d=#b#", parameterNames);
		parameterNames=removeDuplicateWithOrder(parameterNames);
		String[] value = new String[]{"1","3"};
		String temp = "";
		for(int i = 0;i < parameterNames.size(); i++){
			tempSql=tempSql.replaceAll("#"+parameterNames.get(i)+"#", value[i]);
		}
		System.out.println(tempSql);
		//System.out.println(JSONArray.fromObject(parameterNames));
		//System.out.println(JSONArray.fromObject(removeDuplicateWithOrder(parameterNames)));
	}
}
