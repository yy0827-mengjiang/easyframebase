package cn.com.easy.ext;

import java.util.HashMap;
import java.util.Map;

public class TicketStore {
	public static Map<String,String> jsidMap = new HashMap<String,String>();
	public static Map<String,Map> ticket = new HashMap<String,Map>();
/*	public static void pri(){
		for(String key : jsidMap.keySet()){
			System.out.println("jsidMap key="+key+","+jsidMap.get(key));
		}
		for(String key : ticket.keySet()){
			System.out.println("ticket key="+key+","+ticket.get(key));
		}
	}*/
}
