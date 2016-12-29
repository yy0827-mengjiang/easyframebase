package cn.com.easy.rest.restful;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.easy.exception.DataConversionException;
import cn.com.easy.exception.NetworkException;
import cn.com.easy.exception.NotFoundException;
import cn.com.easy.exception.ResourceAccessException;
import cn.com.easy.restful.client.Client;
import cn.com.easy.restful.client.WebResource;

public class RestClient {

	public static void main(String[] args) {
		WebResource resource = Client.resource("http://localhost:8080/eframe_oracle/restful/rest/123/zfd");
		try {
			/*
		HashMap map = resource.addParameter("age", 2008).get(HashMap.class);
			System.out.println(map.get("id"));
			System.out.println(map.get("name"));
			System.out.println(map.get("age"));
			ArrayList list = (ArrayList) map.get("arr");
			System.out.println("result>>>>>"+list.get(2));
			
			UserInfo user = resource.addParameter("age", 2009).get(UserInfo.class);
			System.out.println(user.getId());
			System.out.println(user.getName());
			System.out.println(user.getAge());
			System.out.println(user.getArr().get(2));

			UserInfoArr userarr = resource.addParameter("age", 2010).get(UserInfoArr.class);
			System.out.println(userarr.getId());
			System.out.println(userarr.getName());
			System.out.println(userarr.getAge());
			System.out.println(userarr.getArr()[2]);
			
			resource = Client.resource("http://localhost:8081/easyframework/restful/rest/123/name/zfd");
			userarr = resource.addParameter("age", 2012).addParameter("arr", new int[]{123,456,789}).post(UserInfoArr.class);
			System.out.println(userarr.getId());
			System.out.println(userarr.getName());
			System.out.println(userarr.getAge());
			System.out.println(userarr.getStrarr()[2]);*/
			List list = new ArrayList();
			Map item = new HashMap();
			
			item.put("orderId", "10001");
			item.put("backCode", "1");
			item.put("bakMsg", "很不错1");
			list.add(0,item);
			
			item = new HashMap();
			item.put("orderId", "10002");
			item.put("backCode", "2");
			item.put("bakMsg", "很不错2");
			list.add(item);
			
			item = new HashMap();
			item.put("orderId", "10003");
			item.put("backCode", "3");
			item.put("bakMsg", "很不错3");
			list.add(item);
			
			Map pama = new HashMap();
			pama.put("pama", list);
			
			resource = Client.resource("http://localhost:8080/eframe_oracle/restful/rest/test");
			Map result=(Map) resource.addParameter("data",pama).post(Map.class);
			System.out.println(">>>>"+result);
			/*UserInfoArr userarr = resource.addParameter("age", 123456789).addParameter("aa","我").addParameter("age", 123456789).addParameter("arr", "123").addParameter("arr", "abc").addParameter("arr", "edf").removeParameter("arr").post(UserInfoArr.class);
			System.out.println(userarr.getId());
			System.out.println(userarr.getName());
			System.out.println(userarr.getAge());
			System.out.println(userarr.getAa());
			System.out.println(userarr.getStrarr());*/
			
			/*resource = Client.resource("http://localhost:8080/easy7/restful/rest/123/name/bonc/ist");
			Map para = new HashMap();
			para.put("age", 12);
			para.put("len", 15);
			para.put("arr", new int[]{1,2,3,4,5});
			para.put(123, 345);
			List<UserInfoArr>users = resource.addParameter(para).get(List.class,UserInfoArr.class);
			for(UserInfoArr us:users){
				System.out.println(us.getName());
				System.out.println(us.getArr()[2]);*/
			
			
			/*resource = Client.resource("http://localhost:8080/easy7/restful/rest/123/name/bonc/ist");
			userarr.setAge(22228888);
			userarr.setArr(new int[]{12,23,35554,45});
			users = resource.addParameter(userarr).addParameter("len", 5).get(List.class,UserInfoArr.class);
			for(UserInfoArr us:users){
				System.out.println(us.getName()+":"+us.getAge());
				System.out.println(us.getArr()[2]);
			}
			
			resource = Client.resource("http://localhost:8080/easy7/pages/example/rest.jsp");
			resource.clearParameter();
			resource.addParameter("title", "标题").addParameter("text", "正文");
			resource.addFile("file1", "/Users/zfd/server/aa.xml").addFile("file", "aaaa").addFile("file2", "/Users/zfd/server/中文.log");
//			map = resource.upload(HashMap.class);
			System.out.println(map.get("name"));
			System.out.println(map.get("title"));
			System.out.println(map.get("file1"));
			
			resource = Client.resource("http://localhost:8080/easy7/restful/rest/json");
			resource.setJson("{\"name\":\"zfd\"}");
			map = resource.postJson(HashMap.class);
			System.out.println(map.get("name"));
			List<Map> paras = new ArrayList<Map>();
			paras.add(map);
			resource.setJson(paras);
			resource.postJson(HashMap.class);*/
			
		} catch (NetworkException e) {
			e.printStackTrace();
		} catch (NotFoundException e) {
			e.printStackTrace();
		} catch (ResourceAccessException e) {
			e.printStackTrace();
		} catch (DataConversionException e) {
			e.printStackTrace();
		}
	}

}
