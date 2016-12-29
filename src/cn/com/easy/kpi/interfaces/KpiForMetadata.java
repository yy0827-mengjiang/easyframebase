package cn.com.easy.kpi.interfaces;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.MapListHandler;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.kpi.parser.GenerateFormKpiSQL;
import cn.com.easy.kpi.parser.GenerateKpiSQL;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.kpi.KpiInterface;

public class KpiForMetadata implements KpiInterface {

	/**
	 * 获取指标库的维度和指标数据
	 * 
	 * @param paramMap
	 *            ：pid：父节点编码[虚拟根-1]，userid：用户编码session.user_id，type：dim为维度，
	 *            kpi为指标，keyword：查询条件
	 * @return List<Map<String, String>>:map中应包含
	 *         id，pid，name，column，isleaf，type：1日/基础、2月/组合、3其他
	 *         
	 */
	@Override
	public List<Map<String, String>> getDimKpiData(Map<String, String> paramMap) {
		EasyDataSource dataSource = null;
		dataSource = EasyContext.getContext().getDataSource();
		Connection conn = null;
		try {
			conn = dataSource.getConnection();
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
		QueryRunner queryRunner = new QueryRunner();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		String type = paramMap.get("type");
		String pid = paramMap.get("pid");
		
		list = this.getKpi(pid, conn, queryRunner);
		list.addAll(this.getComplexKpi(pid, conn, queryRunner));
		this.colseConn(conn);
//		if ("kpi".equals(type)) {
//			list = this.getKpi(pid, conn, queryRunner);
//			list.addAll(this.getComplexKpi(pid, conn, queryRunner));
//			this.colseConn(conn);
//		} else {
//			list = this.getDim(pid, conn, queryRunner);
//		}
		this.colseConn(conn);
		List<Map<String, String>> rList = new ArrayList<Map<String, String>>();
		for (Map<String, Object> map : list) {
			Map<String, String> rMap = new HashMap<String, String>();
			Iterator itor = map.entrySet().iterator();
			while (itor.hasNext()) {
				Map.Entry<String, Object> entry = (Map.Entry<String, Object>) itor.next();
				String key = entry.getKey();
				String value = "";
				if(null!=entry.getValue()){
					value = entry.getValue().toString();
				}
				rMap.put(key, value);
			}
			rList.add(rMap);
		}
		return rList;
	}

	/**
	 * 根据选择的维度和指标生成SQL语句
	 * 
	 * @param paramMap
	 *            :dim：维度list<id>；kpi：指标list<id>；where：list<Map<String,String>>
	 *            其中key为：id，formula即维度id和条件表达式，如>=，like等；orders：list<Map<String,
	 *            String>>其中key为：id，ord：desc/asc
	 * @return map：[result:'success or fail',content:'sql语句 or 错误信息']
	 */
	public Map<String, String> getSql(List<String> dims, List<String> kpis,
			List<Map<String, String>> wheres, List<Map<String, String>> orders,Map<String,String> alias) {
		Map<String, String> map = new HashMap<String, String>();
		try {
//			GenerateKpiRuleSQL kpiSql = new GenerateKpiRuleSQL(dims,kpis,wheres,orders,alias);
			GenerateFormKpiSQL kpiSql = new GenerateFormKpiSQL(dims,kpis,wheres,orders,alias);
			map = kpiSql.getSqlForBuilder();
		} catch(Exception e) {
			map.put("result", "failed");
			map.put("content", e.getMessage());
		}
		return map;
	}

	/**
	 * 根据选择的维度和指标生成SQL语句
	 * 
	 * @param paramMap
	 *            :dim：维度list<id>；kpi：指标list<id>；where：list<Map<String,String>>
	 *            其中key为：id，formula即维度id和条件表达式，如>=，like等；orders：list<Map<String,
	 *            String>>其中key为：id，ord：desc/asc
	 * @return map：[result:'success or fail',content:'sql语句 or 错误信息']
	 */
	public Map<String, String> getSql(List<String> dims, List<Map<String,String>> kpis,
			List<Map<String, String>> wheres, List<Map<String, String>> orders,Map<String,String> alias,Report report,Component component) {
		Map<String, String> map = new HashMap<String, String>();
		try {
//			GenerateKpiRuleSQL kpiSql = new GenerateKpiRuleSQL(dims,kpis,wheres,orders,alias);
			GenerateKpiSQL kpiSql = new GenerateKpiSQL(dims,kpis,wheres,orders,alias,report,component);
			map = kpiSql.getSqlForBuilder();
		} catch(Exception e) {
			map.put("result", "failed");
			map.put("content", e.getMessage());
		}
		return map;
	}
	
	public List<Map<String, Object>> getDim(String pid, Connection conn,
			QueryRunner queryRunner) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		String querySql = "SELECT T.ID,T.KPI_CODE,decode(T.PID,'0','t0',t.pid) pid,T.NAME TEXT,T.KPI_FIELD  \"COLUMN\",T.ISLEAF STATE,T.ACCTTYPE TYPE,T.KPITYPE FROM VIEW_KPI_INTERFACE T START WITH T.ID= '8' CONNECT BY PRIOR T.ID = T.PID";
		try {
			list = queryRunner
					.query(conn, querySql, null, new MapListHandler());
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<Map<String, Object>> getKpi(String pid, Connection conn,
			QueryRunner queryRunner) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		String querySql = "select '0' id, '' kpi_code, 't0' pid, '日账指标' TEXT, '' \"COLUMN\", 'folder' STATE, '1' type from dual union select t.id, t.kpi_code, t.pid, t.name TEXT, t.kpi_field \"COLUMN\", case when t.isleaf=0 and t.iskpi=0 then 'kpi_folder' when t.isleaf=0 and t.iskpi=1 then 'kpi_leaf_folder' else 'kpi_leaf' end STATE, t.accttype type from view_kpi_interface t where (t.accttype = '1' OR T.ACCTTYPE IS NULL) and id not in (select id from view_kpi_interface start with id = '8' or id='14' connect by PRIOR id = pid) union select t.id, t.kpi_code, t.pid, t.name TEXT, t.kpi_field \"COLUMN\", case when t.isleaf=0 and t.iskpi=0 then 'dim_folder' when t.isleaf=1 and t.iskpi=1 then 'dim_leaf' end STATE, t.accttype  type from view_kpi_interface t where  (t.accttype = '1' OR T.ACCTTYPE IS NULL) start with id = '8' connect by PRIOR id = pid";
		try {
			list = queryRunner
					.query(conn, querySql, null, new MapListHandler());
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<Map<String, Object>> getComplexKpi(String pid, Connection conn,
			QueryRunner queryRunner) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		String querySql = "select '-1' id, '' kpi_code, 't0' pid, '月账指标' TEXT, '' \"COLUMN\", 'folder' STATE, '2' type from dual union select t.id, t.kpi_code, case when t.pid=0 then '-1' else t.pid end pid, t.name TEXT, t.kpi_field \"COLUMN\", case when t.isleaf=0 and t.iskpi=0 then 'kpi_folder' when t.isleaf=0 and t.iskpi=1 then 'kpi_leaf_folder' else 'kpi_leaf' end STATE, t.accttype type from view_kpi_interface t where (t.accttype = '2' OR T.ACCTTYPE IS NULL) and id not in (select id from view_kpi_interface start with id = '14' or id='8' connect by PRIOR id = pid) union select t.id, t.kpi_code, case when t.pid=0 then '-1' else t.pid end pid, t.name TEXT, t.kpi_field \"COLUMN\", case when t.isleaf=0 and t.iskpi=0 then 'dim_folder' when t.isleaf=1 and t.iskpi=1 then 'dim_leaf' end STATE, t.accttype  type from view_kpi_interface t where  (t.accttype = '2' OR T.ACCTTYPE IS NULL) start with id = '14' connect by PRIOR id = pid";
		try {
			list = queryRunner
					.query(conn, querySql, null, new MapListHandler());
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public void colseConn(Connection conn){
		if(null!=conn){
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
