package cn.com.easy.rest.rest;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import cn.com.easy.restful.client.Client;
import cn.com.easy.restful.client.WebResource;
import cn.com.easy.util.CodecUtils;

public class RestClient {

	public static void main(String[] args) throws Exception {
		WebResource resource = Client.resource("http://localhost:8080/eframe_oracle/restful/etljob/startJob/66/77");
//		
		String time = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
		
		HashMap<String,String> signParam = new HashMap<String,String>();
		signParam.put("appkey", "EASYETL");
		signParam.put("timestamp", time);
		signParam.put("jobId", "123");
		signParam.put("etlAccountId", "456");
		
		resource.addParameter("appkey", "EASYETL");
		//resource.addParameter("timestamp", "20161026084853");
		resource.addParameter("jobId", "123");
		resource.addParameter("etlAccountId", "456");
		resource.addParameter("sign", RestClient.sign(signParam,"BONCETL"));
		
		System.out.println(time);
		System.out.println(RestClient.sign(signParam,"BONCETL"));
		Person str = resource.get(Person.class);
		
		System.out.println(str.getPname()+"__________"+str.getPid());
	}
	
	
	
	public static String sign(Map<String, String> params, String secret) throws IOException {
		// 第一步：检查参数是否已经排序
		String[] keys = params.keySet().toArray(new String[0]);
		Arrays.sort(keys);
		// 第二步：把所有参数名和参数值串在一起
		StringBuilder query = new StringBuilder();
		query.append(secret);
		for (String key : keys) {
			String value = params.get(key);
			if (key!=null && !"".equals(key) && value!=null && !"".equals(value)) {
				query.append(key).append(value);
			}
		}
		query.append(secret);
		
		// 第三步：使用MD5加密
		byte[] bytes = CodecUtils.md5(query.toString());

		// 第四步：把二进制转化为大写的十六进制
		return CodecUtils.encodeHexString(bytes);
	}


}
