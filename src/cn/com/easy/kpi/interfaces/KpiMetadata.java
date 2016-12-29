package cn.com.easy.kpi.interfaces;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.MapListHandler;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.core.sql.SqlRunner;

public class KpiMetadata {
	
//	String queryKpi = "select * from VIEW_KPI_INTERFACE t where t.CUBE_CODE = ? and t.data_type=? order by t.kpi_ord " ;
//	String queryDim = "SELECT T.DIM_CODE \"id\", T1.COLUMN_CODE \"column\", T1.COLUMN_DESC \"desc\",T.DIM_CATEGORY \"pid\" FROM X_KPI_DIM_CODE T,X_KPI_RAL_DIM T1 WHERE T.DIM_CODE = T1.DIM_CODE AND T1.CUBE_CODE =? ORDER BY T1.DIM_ORD ";
//	String queryAttr = "SELECT T.ID \"id\",T.COLUMN_NAME \"column\",T.COLUMN_DESC \"desc\" FROM X_KPI_RAL_ATTR T WHERE T.CUBE_CODE=?";
	public Map<String,Object> getDimKpiData(String cubeId,String userId) {
		Map<String,Object> jsonStr = new HashMap<String,Object>();
		Map<String,String> paraMap = new HashMap<String,String>();
		paraMap.put("cubeId", cubeId);
		paraMap.put("userId", userId);
//		EasyDataSource dataSource = null;
//		dataSource = EasyContext.getContext().getDataSource();
		Connection conn = null;
		Map<String,Object> kpiInfo = new HashMap<String,Object>();
		Map<String,List<Map<String,String>>> dimInfo = new HashMap<String,List<Map<String,String>>>();
		SqlRunner queryRunner = new SqlRunner();
		try {
//			conn = dataSource.getConnection();
			kpiInfo = this.getKpiInfo(paraMap, conn, queryRunner);
			kpiInfo = this.getKpiClass(paraMap,kpiInfo, conn, queryRunner);
			dimInfo = this.getDIM(paraMap, conn, queryRunner);
			List<Map<String,Object>> kpi = this.getKpiCate(paraMap,kpiInfo, conn, queryRunner);
			List<Map<String,Object>> dim = this.getDimCateGory(cubeId, dimInfo, conn, queryRunner);
			List<Map<String,Object>> attr = this.getAttr(paraMap, conn, queryRunner);
	 		jsonStr.put("kpi", kpi);
			jsonStr.put("dim", dim);
			jsonStr.put("property", attr);
		} catch (Exception e1) {
			e1.printStackTrace();
		} 
//		finally {
//			if(conn != null)
//				try {
//					conn.close();
//				} catch (SQLException e) {
//					e.printStackTrace();
//				}
//		}
		return jsonStr;
	}
	private Map<String,Object> getKpiInfo(Map<String,String> paraMap,Connection conn,SqlRunner queryRunner) throws Exception{
		Map<String,Object> kpiInfo = new HashMap<String,Object>();
//		String[] param =new String[2];
//		param[0] = paraMap.get("cubeId");
//		param[1] = "2";
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("cube_code", paraMap.get("cubeId"));
		String sql = queryRunner.sql("kpi.metadatad.queryMetaKpiAttr");
		List<Map<String, Object>> list = (List<Map<String, Object>>) queryRunner.queryForMapList(sql, params);
//		List<Map<String, Object>> list = queryRunner.query(conn, queryKpi, param, new MapListHandler());
		for(Map<String,Object> map:list){
			String PId = map.get("PID").toString();
			Map<String,String> info = new HashMap<String,String>();
			info.put("id", map.get("ID").toString());
			info.put("column", map.get("KPI_FIELD").toString());
			info.put("desc", map.get("NAME").toString());
			List<Map<String,String>> li;
			if(kpiInfo.containsKey(PId)){
				li = (List<Map<String, String>>) kpiInfo.get(PId);
			}else{
				li = new ArrayList<Map<String, String>>();
			}
			li.add(info);
			kpiInfo.put(PId, li);
		}
		return kpiInfo;
	}
	private Map<String,Object> getKpiClass(Map<String,String> paraMap,Map<String,Object> info,Connection conn,SqlRunner queryRunner) throws Exception{
		Map<String,Object> kpiInfo = new HashMap<String,Object>();
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("cube_code", paraMap.get("cubeId"));
//		String[] param =new String[2];
//		param[0] = paraMap.get("cubeId");
//		param[1] = "1"; 
		String sql = queryRunner.sql("kpi.metadata.queryMetaKpi");
		List<Map<String, Object>> list = (List<Map<String, Object>>) queryRunner.queryForMapList(sql, params);
//		List<Map<String, Object>> list = queryRunner.query(conn, queryKpi, param, new MapListHandler());
		for(Map<String,Object> map:list){
			String PId = map.get("PID").toString();
			Map<String,Object> info1 = new HashMap<String,Object>();
			info1.put("id", map.get("ID").toString());
			info1.put("column", map.get("KPI_FIELD").toString());
			info1.put("type", map.get("KPI_TYPE").toString());
			info1.put("desc", map.get("NAME").toString());
			info1.put("children", info.get(map.get("ID").toString()));
			List<Map<String,Object>> li;
			if(kpiInfo.containsKey(PId)){
				li = (List<Map<String, Object>>) kpiInfo.get(PId);
			}else{
				li = new ArrayList<Map<String, Object>>();
			}
			li.add(info1);
			kpiInfo.put(PId, li);
		}
		return kpiInfo;
	}
	private List<Map<String,Object>> getKpiCate(Map<String,String> paraMap,Map<String,Object> cla,Connection conn,SqlRunner queryRunner) throws Exception{
		List<Map<String,Object>> kpiInfo = new ArrayList<Map<String,Object>>();
//		String[] param =new String[2];
//		param[0] = paraMap.get("cubeId");
//		param[1] = "0";
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("cube_code", paraMap.get("cubeId"));
		String sql = queryRunner.sql("kpi.metadata.queryMetaKpiCategory");
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> slist = (List<Map<String, Object>>) queryRunner.queryForMapList(sql,params);
		sql = queryRunner.sql("kpi.metadata.queryMetaCategory");
		List<Map<String, Object>> olist = (List<Map<String, Object>>) queryRunner.queryForMapList(sql,params);
		boolean isResult = true;
		for(Map<String,Object> map:slist){
			String id = map.get("CATEGORY_ID").toString();
			String name = "";
			int i = 0;
			Map<String,Object> category = null;
			while(isResult) {
				for(Map<String,Object> omap: olist) {
					if(id.equals(map.get("ID"))) {
						name += ">>" + omap.get("NAME");
						id = omap.get("PID").toString();
						if(i == 0)
							category = omap;
						i++;
						//获取到一级目录
						if("0".equals(id)) {
							isResult = false;
						}
						break;
					}
				}
			}
			if(category != null) {
				category.put("NAME", name.substring(2));
				list.add(category);
			}
		}
		for(Map<String,Object> map:list){
			String PId = map.get("PID").toString();
			Map<String,Object> info = new HashMap<String,Object>();
			info.put("title", map.get("NAME").toString());
			info.put("children", cla.get(map.get("ID").toString()));
			kpiInfo.add(info);
		}
		return kpiInfo;
	}
	private List<Map<String,Object>> getDimCateGory(String cube_code,Map<String,List<Map<String,String>>> dimInfo,Connection conn,SqlRunner queryRunner) throws Exception {
		List<Map<String,Object>> dim = new ArrayList<Map<String,Object>>();
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("cube_code", cube_code);
		String sql = queryRunner.sql("kpi.metadata.queryMetaDimCategory");
		List<Map<String, Object>> list = (List<Map<String, Object>>) queryRunner.queryForMapList(sql, params);
		for (Map<String,Object> map :list) {
			Map<String,Object> info = new HashMap<String,Object>();
			info.put("title", map.get("CATEGORY_NAME").toString());
			info.put("children", dimInfo.get(map.get("CATEGORY_ID").toString()));
			dim.add(info);
		}
		return dim;
	}
	
	private Map<String,List<Map<String,String>>> getDIM(Map<String,String> paraMap,Connection conn,SqlRunner queryRunner){
		Map<String,List<Map<String,String>>> dimInfo = new HashMap<String,List<Map<String,String>>>();
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("cube_code", paraMap.get("cubeId"));
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			String sql = queryRunner.sql("kpi.metadata.queryMetaDim");
			list = (List<Map<String, Object>>) queryRunner.queryForMapList(sql, params);
			for(Map<String,Object> map : list) {
				String pid = map.get("PID").toString();
				Map<String,String> info = new HashMap<String,String>();
				info.put("id", map.get("ID").toString());
				info.put("column", map.get("COLUMN").toString());
				info.put("desc", map.get("DESC").toString());
				List<Map<String,String>> li;
				if(dimInfo.containsKey(pid)){
					li = (List<Map<String, String>>) dimInfo.get(pid);
				}else{
					li = new ArrayList<Map<String, String>>();
				}
				li.add(info);
				dimInfo.put(pid, li);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return dimInfo;
	}
	
	private List<Map<String,Object>> getAttr(Map<String,String> paraMap,Connection conn,SqlRunner queryRunner) throws Exception{
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("cube_code", paraMap.get("cubeId"));
		String sql = queryRunner.sql("kpi.metadata.queryMetaAttr");
		List<Map<String, Object>> list = (List<Map<String, Object>>) queryRunner.queryForMapList(sql, params);
 		return list;
	}

	public List<Map<String,Object>> getDim(String dimIds) throws Exception {
//		String sql = "SELECT DIM_CODE,CODE_TABLE,CODE_TABLE_DESC,COLUMN_CODE,COLUMN_DESC,COLUMN_ORD,COLUMN_PARENT,CONF_TYPE,CONDITION,DIM_PARENT_CODE,DIM_LEVEL,DIM_TYPE,DIM_RIGHT FROM X_KPI_DIM_CODE WHERE DIM_CODE =? ";
//		EasyDataSource dataSource = null;
//		Connection conn = null;
//		dataSource = EasyContext.getContext().getDataSource();
//		conn = dataSource.getConnection();
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("dim_code", dimIds);
		SqlRunner queryRunner = new SqlRunner();
		String sql = queryRunner.sql("kpi.metadata.queryMetaDimDetail");
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		list = (List<Map<String, Object>>) queryRunner.queryForMapList(sql,params);
		return list;
	}
	public Map<String,Object> getCubeDataBase(String cube_id) throws Exception {
		Map<String,Object> cubeMap = new HashMap<String,Object>();
//		String sql = "SELECT CUBE_DATASOURCE FROM X_KPI_CUBE WHERE CUBE_CODE=? ";
//		EasyDataSource dataSource = null;
//		Connection conn = null;
//		dataSource = EasyContext.getContext().getDataSource();
//		conn = dataSource.getConnection();
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("cube_code", cube_id);
		SqlRunner queryRunner = new SqlRunner();
		String sql = queryRunner.sql("kpi.metadata.queryMetaCubeDetail");
		List<Map<String, Object>> list = (List<Map<String, Object>>) queryRunner.queryForMapList(sql,params);
		if(list != null && list.size() > 0) {
			cubeMap = list.get(0);
		}
		return cubeMap;
	}
	public List<Map<String,Object>> getAttr(String attrIds) throws Exception {
//		String sql = "SELECT ID,COLUMN_NAME,COLUMN_DESC,ATTR_TYPE FROM X_KPI_RAL_ATTR WHERE ATTR_TYPE IN ('D','M') AND ID=? ";
//		EasyDataSource dataSource = null;
//		Connection conn = null;
//		dataSource = EasyContext.getContext().getDataSource();
//		conn = dataSource.getConnection();
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("attr_id", attrIds);
		SqlRunner queryRunner = new SqlRunner();
		String sql = queryRunner.sql("kpi.metadata.queryMetaAttrDetail");
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		list = (List<Map<String, Object>>) queryRunner.queryForMapList(sql,params);
		return list;
	}
	/**
	 * 
	 * @param cube_id
	 * @param dim_code
	 * @return
	 * @throws Exception
	 */
	public Map<String,Object> getCubeDim(String cube_id,String dim_code) throws Exception {
		Map<String,Object> dimMap = new HashMap<String,Object>();
//		String sql = "SELECT COLUMN_CODE FROM X_KPI_RAL_DIM WHERE CUBE_CODE=? AND DIM_CODE=?";
//		EasyDataSource dataSource = null;
//		Connection conn = null;
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("cube_code", cube_id);
		params.put("dim_code", dim_code);
//		dataSource = EasyContext.getContext().getDataSource();
//		conn = dataSource.getConnection();
		
		SqlRunner queryRunner = new SqlRunner();
		String sql = queryRunner.sql("kpi.metadata.queryMetaCubeDim");
		List<Map<String, Object>> list = (List<Map<String, Object>>) queryRunner.queryForMapList(sql,params);
		if(list != null && list.size() > 0) {
			dimMap = list.get(0);
		}
		return dimMap;
	}
	public List<Map<String,Object>> getCubeDim(String cubeId) throws Exception {
//		String sql = "SELECT A.DIM_CODE,A.CODE_TABLE,A.CODE_TABLE_DESC,A.COLUMN_CODE,A.COLUMN_DESC,A.COLUMN_ORD,A.COLUMN_PARENT,A.CONF_TYPE,A.CONDITION,A.DIM_PARENT_CODE,A.DIM_LEVEL,A.DIM_TYPE,A.DIM_RIGHT,B.COLUMN_CODE AS DIM_COLUMN_CODE,B.COLUMN_DESC AS DIM_COLUMN_DESC FROM X_KPI_DIM_CODE A, X_KPI_RAL_DIM B WHERE A.DIM_CODE = B.DIM_CODE AND A.DIM_DEFAULT='1' AND B.CUBE_CODE =? ORDER BY B.DIM_ORD ";
//		EasyDataSource dataSource = null;
//		Connection conn = null;
//		dataSource = EasyContext.getContext().getDataSource();
//		conn = dataSource.getConnection();
		SqlRunner queryRunner = new SqlRunner();
		String sql = queryRunner.sql("kpi.metadata.queryMetaCubeDimRel");
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("cube_code", cubeId);
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		list = (List<Map<String, Object>>) queryRunner.queryForMapList(sql, params);
		return list;
	}
}
