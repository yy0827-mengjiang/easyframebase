package cn.com.easy.xt.logic;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.easy.annotation.Service;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.exception.DataConversionException;
import cn.com.easy.exception.NetworkException;
import cn.com.easy.exception.NotFoundException;
import cn.com.easy.exception.ResourceAccessException;
import cn.com.easy.restful.client.Client;
import cn.com.easy.restful.client.WebResource;
import cn.com.easy.web.taglib.function.Functions;
public class WorkBenchLogic {
	private WebResource resource;
	
	/**
	 * 获取所有活动，活动概览
	 * @param params
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getActives(Map<String,Object> params){
		resource=Client.resource("http://localhost:8080/eframe_oracle/restful/restServ/getActives");
		Map<String,Object> result=null;
				String data=Functions.java2json(params);
				try {
					result=(Map) resource.addParameter("data",data).post(Map.class);
				} catch (NetworkException | NotFoundException | ResourceAccessException | DataConversionException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			return result;
	}
	
	/**
	 * 获取工单列表
	 * @param params
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String,Object> getOrders(Map<String,Object> params){
		return null;
	}
	

	/**
	 * 处理前台选中得查询条件 
	 * @param params 查询条件得对象
	 * @return 返回一个sql能用得条件字符串 如" ext1='1' and ext2 = '2' "
	 */
	private String processParams(Map<String,Object> params){
		return "";
	}
	
	
	/**
	 * 查询用户信息
	 * @param param
	 * @return Map<String,String>
	 */
	@SuppressWarnings("unchecked")
	public Map<String,String> getUsrInfo(Map<String,String> param){
		
		SqlRunner runner = new SqlRunner();
		//定义SQL
		StringBuffer sql = new StringBuffer();
		sql.append("select userid, username, sex, tel, zwsc, zhye, jf, ");
		sql.append("qfje, ywlx, qfzzsc, jzdj, hjll, yhzt, yhxj, arpu, tcmc,");
		sql.append(" hylx, hymc, hyksrq, hyjsrq, hysyyf, zdpp, zdjx, wlzs ");
		sql.append("from emp_usertmp t ");
		sql.append("where 1=1 ");
		sql.append("{and t.userid = #userid#} ");
		//返回值
		Map<String,String> resMap = new HashMap<String,String>();
		try{
			//执行SQL
			resMap = (Map<String, String>) runner.queryForMap(sql.toString(), param);
		}catch(Exception e){
			e.printStackTrace();
		}
		return resMap;
		
	}
	
	/**
	 * 查询执行工单
	 * @param param
	 * @return
	 */
	public Map getTaskList(Map<String,String> param){
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		Map<String,String> map = new HashMap<String,String>();
		Map<String,Object>resMap = new HashMap<String,Object>();
		map.put("orderId", "10001");
		map.put("activeName", "4G登网活动");
		map.put("activeLevel", "高");
		map.put("custName", "目标用户换4G手机并更换4G卡，可一次性赠300元话费，赠费有效期至12月底");
		map.put("verbal", "10月换机且换卡送300话费+60G流量");
		map.put("successCriteria", "成功标准名称：郑州市四季度流量包推荐，成功标准类型：推荐流量包");
		map.put("awardDesc", "积分描述");
		map.put("awardNum", "100");
		map.put("recommendInfo", "订购流量包-省内半年流量包，日包");
		map.put("visitTime", "2016-09-10 12:20");
		map.put("vistState", "1");
		map.put("activeId", "20001");
		map.put("sms", "输入短信模板内容");
		list.add(0,map);
		map = new HashMap<String,String>();
		map.put("orderId", "10002");
		map.put("activeName", "4G登网活动");
		map.put("activeLevel", "中");
		map.put("custName", "目标用户换4G手机并更换4G卡，可一次性赠300元话费，赠费有效期至12月底");
		map.put("verbal", "10月换机且换卡送300话费+60G流量");
		map.put("successCriteria", "成功标准名称：郑州市四季度流量包推荐，成功标准类型：推荐流量包");
		map.put("awardDesc", "积分描述");
		map.put("awardNum", "80");
		map.put("recommendInfo", "订购流量包-省内半年流量包，日包");
		map.put("visitTime", "2016-09-11 12:20");
		map.put("vistState", "1");
		map.put("activeId", "20002");
		map.put("sms", "输入短信模板内容");
		list.add(1,map);
		
		map = new HashMap<String,String>();
		map.put("orderId", "10003");
		map.put("activeName", "4G登网活动");
		map.put("activeLevel", "低");
		map.put("custName", "目标用户换4G手机并更换4G卡，可一次性赠300元话费，赠费有效期至12月底");
		map.put("verbal", "10月换机且换卡送300话费+60G流量");
		map.put("successCriteria", "成功标准名称：郑州市四季度流量包推荐，成功标准类型：推荐流量包");
		map.put("awardDesc", "积分描述");
		map.put("awardNum", "50");
		map.put("recommendInfo", "订购流量包-省内半年流量包，日包");
		map.put("visitTime", "2016-09-12 12:20");
		map.put("vistState", "1");
		map.put("activeId", "20003");
		map.put("sms", "输入短信模板内容");
		list.add(1,map);
		resMap.put("items", list);
		
		return resMap;
		
	}
	
	/**
	 * 保存工单
	 * @param param
	 * @return
	 */
	public Map insTaskExecute(Map<String,String> param){
		
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		Map<String,String> map = new HashMap<String,String>();
		Map<String,Object>resMap = new HashMap<String,Object>();
		
		map.put("orderId", "A0001");
		map.put("orderName", "工单名称1");
		map.put("errorMsg", "工单不存在1");
		list.add(0,map);
		map = new HashMap<String,String>();
		map.put("orderId", "A0002");
		map.put("orderName", "工单名称2");
		map.put("errorMsg", "工单不存在2");
		list.add(1,map);
		map = new HashMap<String,String>();
		map.put("orderId", "A0003");
		map.put("orderName", "工单名称3");
		map.put("errorMsg", "工单不存在3");
		list.add(2,map);
		
		resMap.put("code", "000001");
		resMap.put("errorList", list);
		
		return resMap;
		
	}
	
	public Map taskHistoryList(Map<String,String> param){
		
		Map resMap = new HashMap();
		List<Map> list = new ArrayList<Map>();
		Map map = new HashMap();
		map.put("orderId", "工单ID");
		map.put("activeId", "活动ID");
		map.put("activeName", "活动名称");
		map.put("channel", "接触渠道");
		map.put("visitDesc", "回访结果");
		map.put("visitDate", "回访时间");
		map.put("backMsg", "备注");
		list.add(0,map);
		
		map = new HashMap();
		map.put("orderId", "工单ID1");
		map.put("activeId", "活动ID1");
		map.put("activeName", "活动名称1");
		map.put("channel", "接触渠道1");
		map.put("visitDesc", "回访结果1");
		map.put("visitDate", "回访时间1");
		map.put("backMsg", "备注1");
		list.add(1,map);
		
		map = new HashMap();
		map.put("orderId", "工单ID2");
		map.put("activeId", "活动ID2");
		map.put("activeName", "活动名称2");
		map.put("channel", "接触渠道2");
		map.put("visitDesc", "回访结果2");
		map.put("visitDate", "回访时间2");
		map.put("backMsg", "备注2");
		list.add(2,map);
		
		resMap.put("rows", list);
		
		return resMap;
	}
	
}
