package cn.com.easy.rest.restful;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.ws.rs.POST;
import javax.ws.rs.Path;

import cn.com.easy.web.taglib.function.Functions;

@Path("restServ")
public class RestServ {
	@Path("getActives")
	@POST
	public Map testMap(String data) {
		System.out.println("rest data>>>>"+data);
		Map params=(Map) Functions.json2java(data);
		System.out.println(">>>>页码"+params.get("pageNum"));
		System.out.println(">>>>条数"+params.get("pageSize"));
		System.out.println(">>>>cellId"+params.get("cellId"));
		System.out.println(">>>>参数"+params.get("pama"));
		List list = new ArrayList();
		Random rand = new Random();
		
		for(int i=0;i<5;i++){
			int t = rand.nextInt(300)+200;
			Map item = new HashMap();
			item.put("activeName", i+"G任务");
			item.put("validNums", t+"");
			int v = rand.nextInt(200)+100;
			item.put("visitNums_today", v+"");
			item.put("visitNums_total", v+34+"");
			item.put("visitRate", "40%");
			item.put("noVisitNums", (t-v)+"");
			item.put("item1", (t-1)+"");
			item.put("item2", (t-3)+"");
			item.put("item3", (t-4)+"");
			item.put("item4", (t-5)+"");
			item.put("item5", (t-6)+"");
			item.put("item6", (t-7)+"");
			item.put("item7", (t-8)+"");
			item.put("item8", (t-9)+"");
			list.add(item);
		}
		Map pama = new HashMap();
		pama.put("items", list);
		pama.put("total", "5");
		return pama;
		
	}
}
