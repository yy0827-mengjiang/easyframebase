package cn.com.easy.kpi.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.easy.annotation.Service;
import cn.com.easy.core.EasyContext;
import cn.com.easy.exception.JaxbException;
import cn.com.easy.jaxb.parser.DefaultJaxbParse;
import cn.com.easy.jaxb.parser.JaxbParse;
import cn.com.easy.kpi.element.Condition;
import cn.com.easy.kpi.element.Dimension;
import cn.com.easy.kpi.element.Kpi;
import cn.com.easy.kpi.element.Measure;
import cn.com.easy.taglib.function.Functions;

@Service
public class AcctTypeSubService {
	@SuppressWarnings("unchecked")
	public String subType(String code,String condCode) {
		Connection conn = null;
		Statement state = null;
		ResultSet rs = null;
		Map<String,Object> mapList = new HashMap<String,Object>();
		Map<String, String> map = new HashMap<String, String>();
		Map<String, String> xml = new HashMap<String, String>();
		String version = "";
		String sql = "SELECT T.KPI_BODY FROM X_KPI_INFO T WHERE T.KPI_CODE = '" + code + "'";
		try {
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			rs = state.executeQuery(sql);
			while (rs.next()) {
				xml.put("xml", rs.getString("KPI_BODY"));
			}
		} catch (Exception e) {
			mapList.put("rs", "failed");
			mapList.put("data", "获取扩展属性失败");
			e.printStackTrace();
		}finally{
			try {
				if(null!=rs){
					rs.close();
				}
				if(null!=state){
					state.close();
				}
				if(null!=conn){
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		try {
			Kpi kpi = parseXMLToKpi(xml.get("xml"));
			List<Measure> ldim = kpi.getMeasures().getMeasureList();
			for(Measure dim:ldim){
				if(dim.getId().startsWith(condCode)){
					version = dim.getVersion();
				}
			}
		} catch (Exception e) {
			mapList.put("rs", "failed");
			mapList.put("data", "获取扩展属性失败");
			e.printStackTrace();
		}
		String subType = "SELECT T.ATTR_CODE,T1.ATTR_NAME FROM X_KPI_ATTR_RELATION T,X_KPI_ATTRIBUTE T1 WHERE T.KPI_CODE='"+condCode+"' AND T.KPI_VERSION='"+version+"' AND T.ATTR_CODE=T1.ATTR_CODE AND T.ACCTTYPE = T1.ATTR_TYPE";
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		try {
			conn = EasyContext.getContext().getDataSource().getConnection();
			state = conn.createStatement();
			rs = state.executeQuery(subType);
			while (rs.next()) {
				Map<String,String> map1 = new HashMap<String,String>();
				map1.put("code", rs.getString("ATTR_CODE"));
				map1.put("text", rs.getString("ATTR_NAME"));
				list.add(map1);
			}
			mapList.put("rs", "success");
			mapList.put("data", list);
		} catch (Exception e) {
			mapList.put("rs", "failed");
			mapList.put("data", "获取扩展属性失败");
			e.printStackTrace();
		}finally{
			try {
				if(null!=rs){
					rs.close();
				}
				if(null!=state){
					state.close();
				}
				if(null!=conn){
					conn.close();
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return Functions.java2json(mapList);
	}
	/**
	 * 将衍生指标映射成指标对象
	 * 
	 * @param kpiXml
	 * @throws Exception
	 */
	protected Kpi parseXMLToKpi(String kpiXml) throws Exception {
		JaxbParse jaxb = null;
		Kpi kpi = null;
		try {
			jaxb = new DefaultJaxbParse();
			kpi = jaxb.readXmlStr(Kpi.class, kpiXml);
			return kpi;
		} catch (JaxbException e) {
			throw new Exception(e);
		}

	}
	
}
