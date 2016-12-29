package cn.com.easy.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Map;

import net.sf.ezmorph.bean.MorphDynaBean;
import net.sf.json.JSONObject;

public class InvokeUtil {
	//method=get
	public static String invokeStr(String url) throws IOException {
		URL ser_url = new URL(url);
		HttpURLConnection httpConn = (HttpURLConnection) ser_url.openConnection();
		httpConn.connect();
		BufferedReader returnBr = new BufferedReader(new InputStreamReader(httpConn.getInputStream()));
		StringBuffer authBuf = new StringBuffer();
		String temp = null;
		while ((temp = returnBr.readLine()) != null) {
			authBuf.append(temp);
		}
		returnBr.close();
		return authBuf.toString();
	}
	
	//method=post
	public static String invokeStr(String url,String params) throws IOException {
		URL ser_url = new URL(url);
		HttpURLConnection httpConn = (HttpURLConnection) ser_url.openConnection();
		httpConn.setRequestMethod("POST");
		httpConn.setConnectTimeout(0);
		httpConn.setInstanceFollowRedirects(true);
		httpConn.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
		httpConn.setDefaultUseCaches(false);
		httpConn.setDoOutput(true);
		
		OutputStream out = httpConn.getOutputStream();
		//byte[] b = URLEncoder.encode(params,"UTF-8").getBytes("UTF-8");
		byte[] b = params.getBytes("UTF-8");
		out.write(b, 0, b.length);
		out.close();
		httpConn.connect();
		BufferedReader returnBr = new BufferedReader(new InputStreamReader(httpConn.getInputStream()));
		StringBuffer authBuf = new StringBuffer();
		String temp = null;
		while ((temp = returnBr.readLine()) != null) {
			authBuf.append(temp);
		}
		returnBr.close();
		return authBuf.toString();
	}
	
	//method=get
	public static Map<String,MorphDynaBean> invokeMap(String url) throws IOException {
		URL ser_url = new URL(url);
		HttpURLConnection httpConn = (HttpURLConnection) ser_url.openConnection();
		httpConn.connect();
		BufferedReader returnBr = new BufferedReader(new InputStreamReader(httpConn.getInputStream()));
		StringBuffer strBuf = new StringBuffer();
		String temp = null;
		while ((temp = returnBr.readLine()) != null) {
			strBuf.append(temp);
		}
		returnBr.close();
		JSONObject jsonObject = JSONObject.fromObject(strBuf.toString());
		Map<String, MorphDynaBean> dataMap = (Map) JSONObject.toBean(jsonObject,Map.class);
		return dataMap;
	}
	
	//method=post
	public static Map<String,MorphDynaBean> invokeMap(String url,String params) throws IOException {
		URL ser_url = new URL(url);
		HttpURLConnection httpConn = (HttpURLConnection) ser_url.openConnection();
		httpConn.setRequestMethod("POST");
		httpConn.setConnectTimeout(0);
		httpConn.setInstanceFollowRedirects(true);
		httpConn.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
		httpConn.setDefaultUseCaches(false);
		httpConn.setDoOutput(true);
		PrintWriter out = new PrintWriter(httpConn.getOutputStream());
		out.print(params);
		out.close();
		httpConn.connect();
		BufferedReader returnBr = new BufferedReader(new InputStreamReader(httpConn.getInputStream()));
		StringBuffer strBuf = new StringBuffer();
		String temp = null;
		while ((temp = returnBr.readLine()) != null) {
			strBuf.append(temp);
		}
		returnBr.close();
		JSONObject jsonObject = JSONObject.fromObject(strBuf.toString());
		Map<String, MorphDynaBean> dataMap = (Map) JSONObject.toBean(jsonObject,Map.class);
		return dataMap;
	}
}