package cn.com.easy.ebuilder.util;

import java.util.ArrayList;
import java.util.List;

public class StringUtil {
	 
	public static List<String> getBind(String arg0,String regex){
		String[] splitRes = arg0.split(regex);
		List<String> res = new ArrayList<String>();
		for(int i = 1; i < splitRes.length;){
			res.add(splitRes[i]);
			i +=2;
		}
		return res;
	}
	
	public static int getCounts(String arg0,String regex){
		if(arg0==""||arg0==null)
			return 0;
		if(arg0.indexOf(regex)<0)
			return 0;
		StringBuffer sb = new StringBuffer(arg0);
		int regex_length = regex.length();
		int count = 0;
		while(sb.indexOf(regex)>=0){
			count++;
			//sb.deleteCharAt(sb.indexOf(regex));
			sb.delete(sb.indexOf(regex),sb.indexOf(regex)+ regex_length);
		}
		return count;
	}
	public static int isSql(String dataSql,String s,String e){
		StringBuffer sb = new StringBuffer(dataSql);
		int start = -1;
		int end = -1;
		while(sb.indexOf(s)>-1){
			start = sb.indexOf(s);
			if((end =sb.indexOf(e,start))>-1){
				sb.deleteCharAt(start);
				sb.deleteCharAt(end-1);
			}else{
				break;
			}
		}
		if(sb.indexOf(s)==-1&&sb.indexOf(e)==-1)
			return -1;
		else
			return sb.indexOf(s)!=-1?sb.indexOf(s):sb.indexOf(e);
	}
	
	public static String formatSql(String dataSql,String s,String e){
		StringBuffer sb = new StringBuffer(dataSql);
		StringBuffer sb_temp = new StringBuffer(" " + dataSql.toUpperCase().replaceAll("[\\s]", " ").replaceAll("[\\(]", "( "));
		int start = -1;
		int end = -1;
		int total = 0;
		int start_where = 0;
		int end_where = 0;
		while(end_where!=-1){
			start_where=sb_temp.indexOf(" WHERE ",end_where+6);
			end_where = sb_temp.indexOf(" SELECT ",start_where+5);
			if(start_where==-1)
				break;
			if(end_where==-1){
				total+= StringUtil.getCounts(sb_temp.substring(start_where), "#");
			}else{
				total+=StringUtil.getCounts(sb_temp.substring(start_where, end_where), "#");
			}
		}
		int count = 0;
		int index = 0;
		while(sb.indexOf(s)>-1){
			start = sb.indexOf(s);
			if((end =sb.indexOf(e,start))>-1){
				index++;
				if(!sb.substring(start+1, end).trim().toUpperCase().matches("(OR|AND)[\\D\\d]+#[\\D\\d]+#[\\D\\d]*"))
					if(!sb.substring(start+1, end).matches("[\\D\\d]+#[\\D\\d]+#[\\D\\d]*")||!sb.substring(0,start).trim().toUpperCase().endsWith("WHERE"))
						return "AND"+index;
				count += getCounts(sb.substring(start+1, end), "#") ;
				sb.replace(end, end+1, " ");
				sb.replace(start, start+1, " ");
			}else{
				break;
			}
		}
		if(count!=total)
			return "COUNT";
		if(sb.indexOf(s)==-1&&sb.indexOf(e)==-1)
			return sb.toString();
		else
			return null;
	}
}
