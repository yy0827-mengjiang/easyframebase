package cn.com.easy.rest.restful;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;

@Path("rest")
public class RESTful {

	@POST
	public String findAll() {
		return "hello";
	}
	
	@GET
	public String findGET() {
		return "hello GET";
	}
	
	@Path("json")
	@POST
	public Map json(HttpServletRequest request) {
		BufferedReader br;
		try {
			br = new BufferedReader(new InputStreamReader(
			        (ServletInputStream) request.getInputStream()));
			 String line = null;
		        StringBuffer sb = new StringBuffer();
		        while ((line = br.readLine()) != null) {
		            sb.append(line);
		        }
		        String appMsg=sb.toString();
		        System.out.println("====================================================");
		        System.out.println(appMsg);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
       
		System.out.println(request.getParameter("name"));
		Map map = new HashMap();
		map.put("id", 1);
		map.put("name", "zfd");
		map.put("age", 35);
		return map;
	}

	@Path("{id}/{name}")
	@GET
	public Map findById(int id, String name, int age) {
		Map map = new HashMap();
		int a = id;
		map.put("id", id);
		map.put("name", name);
		map.put("age", age);
		System.out.println("id---"+id+" name-----"+name+" >>>>>>>age:"+age);
		int[] arr = { 1, 2, 3, 4, 5, 6, 7, 8 };
		map.put("arr", arr);
		return map;
	}

	@Path("{id}/name/{name}")
	@POST
	public Map findByIdName(int id, String name, int age, String aa,String bb,String[] arr) {
		Map map = new HashMap();
		int a = id;
		map.put("id", id);
		map.put("aa", aa);
		map.put("name", name);
		map.put("age", age);
		map.put("strarr", arr);
		return map;
	}

	@Path("/{id}/name/{name}/ist")
	@GET
	public List findall(int id, String name, int len, int age, String[] arr) {
		System.out.println(name);
		System.out.println(arr);
		List list = new ArrayList();
		for (int i = 0; i < len; i++) {
			Map map = new HashMap();
			int a = id;
			map.put("id", id);
			map.put("name", name + i);
			map.put("age", age);
			map.put("arr", arr);
			list.add(map);
		}
		return list;
	}
	
	@Path("test")
	@POST
	public Map testMap(Map item) {
		Map map1= new HashMap();
		System.out.println(item.get("item"));
		map1.put("result","2");
		return map1;
	}
	
	public static void main(String[] args){
		String str = "/rest";
		System.out.println(str.split("/").length);
	}
}
