package cn.com.easy.kpi.baseKpi.service;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.sql.DataSource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.dbutils.DbUtils;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.MapHandler;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.EasyDataSource;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.kpi.baseKpi.domain.BaseFile;
import cn.com.easy.kpi.baseKpi.domain.BaseKpi;
import cn.com.easy.kpi.baseKpi.domain.KpiInfo;
import cn.com.easy.kpi.baseKpi.domain.KpiSelect;
import cn.com.easy.kpi.util.SQLTool;
import cn.com.easy.xbuilder.parser.CommonTools;

public class BaseKpiService {
	private  static DataSource dataSource=(DataSource) new ClassPathXmlApplicationContext("classpath:applicationContext.xml").getBean("dataSource");
	final static String KPI_UNIT_SQL="SELECT * FROM kpi_unit";
	final static String KPI_BASE_KPI_SQL="SELECT base_key, kpi_version kpi_version, kpi_name, kpi_unit,(select name from x_kpi_code where type='0' and code=t.kpi_unit) as kpi_unit_name, kpi_origin_schema, kpi_origin_table, kpi_origin_column, kpi_proposer, kpi_proposer_dept, kpi_state, kpi_origin_desc, type as baseType, create_user_id, create_time, edit_user_id, edit_time, upload_file_name,kpi_eds,kpi_category,kpi_condition,account_type,kpi_code,cube_code FROM x_base_kpi t WHERE id=?";//base_key= ? AND kpi_version=?";
	private KpiInfo kpiInfo=new KpiInfo();
	private static Logger logger= Logger.getLogger(BaseKpiService.class);
	private ThreadLocal<Map> eds=new ThreadLocal<Map>();
	private SqlRunner sqlRunner = null;
	
	public BaseKpiService() {
		
	}
	public BaseKpiService(SqlRunner sqlRunner) {
		this.sqlRunner = sqlRunner;
	}
	
	public KpiInfo addBaseKpi() throws SQLException{
		BaseKpi baseKpi=new BaseKpi();
		//baseKpi.setKpi_category(parentId);
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmss");
		String kpiKey=sdf.format(new Date()).toString();
		baseKpi.setBase_key("BK_"+kpiKey);
		baseKpi.setKpi_version("1");
		SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String date=simpleDateFormat.format(new Date());
        baseKpi.setCreate_time(date);
//		List<KpiSelect> kpiUnitList=this.getKpiUnit();
		List<KpiSelect> kpiSelectList=this.getKpiEds();
		kpiInfo.setEds(kpiSelectList);
		kpiInfo.setBaseKpi(baseKpi);
//		kpiInfo.setKpiUnit(kpiUnitList);
		return kpiInfo;
	}

	private Map xdbauth(){
		Map map=new HashMap();
		Properties properties=new Properties();
		FileInputStream fileInputStream=null;
		try{
			fileInputStream=new FileInputStream(this.getClass().getResource("/").getPath()+"framework.properties");
			properties.load(fileInputStream);
			map.put("xdbauth",properties.getProperty("xdbauth"));
		}catch (IOException e){
			e.printStackTrace();
		}
		return map;
	}

	private List getKpiEds(){
		Map xdbauth=this.xdbauth();
		String user_id=((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_ID").toString();
		String extDB="SELECT  DB_ID AS \"DB_ID\", DB_NAME AS \"TEXT\", DB_SOURCE AS \"ID\" FROM X_EXT_DB_SOURCE";
		if(xdbauth.get("xdbauth").equals(1)){
			extDB="SELECT X.DB_ID, DB_NAME TEXT, DB_SOURCE ID\n" +
					"        FROM X_EXT_DB_SOURCE  X,\n" +
					"             X_DB_ACCOUNT  A\n" +
					"        WHERE X.DB_ID=A.DB_ID\n" +
					"          AND A.ACCOUNT_CODE in (\n" +
					"              select ACCOUNT_CODE \n" +
					"                 FROM E_USER_ACCOUNT\n" +
					"               WHERE \n" +
					"                   USER_ID = '"+user_id+"'";
		}
		Connection conn= null;
		QueryRunner queryRunner=new QueryRunner();
		try {
			conn = this.dataSource.getConnection();
			return (List<KpiSelect>) queryRunner.query(conn, extDB, new BeanListHandler(KpiSelect.class));
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				DbUtils.close(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return null;

	}
	public KpiInfo editBaseKpi(){
		BaseKpi baseKpi=this.getBaseKpi();
		baseKpi.setKpi_origin_stc(baseKpi.getKpi_origin_schema()+"."+baseKpi.getKpi_origin_table()+"."+baseKpi.getKpi_origin_column());
		
//		List<KpiSelect> kpiUnitList=this.getKpiUnit();
//		kpiInfo.setKpiUnit(kpiUnitList);
		kpiInfo.setBaseKpi(baseKpi);
		kpiInfo.setEds(this.getKpiEds());
		return kpiInfo;
	}

	private  List<KpiSelect> getKpiUnit(){
		Connection conn= null;
		QueryRunner queryRunner=new QueryRunner();
		try {
			conn = this.dataSource.getConnection();
			return (List<KpiSelect>) queryRunner.query(conn, KPI_UNIT_SQL, new BeanListHandler(KpiSelect.class));
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				DbUtils.close(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	private BaseKpi getBaseKpi() {
		Connection conn= null;
		try {
			BaseKpi baseKpi= new BaseKpi();
			conn = this.dataSource.getConnection();
			String sql = sqlRunner.sql("kpi.basekpi.queryBaseKpiDetail");
			Map<String,Object> params = new HashMap<String,Object>();
			params.put("kpi_id", kpiInfo.getBaseKpi().getId());
			Map<String,Object> result = sqlRunner.queryForMap(sql,params);
//			BaseKpi baseKpi= (BaseKpi) sqlRunner.query(conn,sql,new BeanHandler(BaseKpi.class),kpiInfo.getBaseKpi().getId());//kpiInfo.getBaseKpi().getBase_key(),kpiInfo.getBaseKpi().getKpi_version());//
            BeanUtils.populate(baseKpi,result);
			System.out.println(baseKpi);
			return  baseKpi;
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				DbUtils.close(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return  null;
	}

	public int publishBaseKpi(){
		int i=0;
		try {
			Map version=this.getVersion();
			BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
			baseKpi.setKpi_version(version.get("VERSION").toString());
			this.updateKpiState();
			baseKpi.setKpi_state("1");
			i=this.insertBaseKpi();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		return i;
	}

	private void updateKpiState(){
		try {
			Connection conn=this.dataSource.getConnection();
			QueryRunner queryRunner=new QueryRunner();
			queryRunner.update(conn,"update X_BASE_KPI t set t.kpi_state='0' where t.base_key='"+this.getKpiInfo().getBaseKpi().getBase_key()+"'");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	private Map getVersion(){
		Map version=new HashMap();
		Connection conn = null;
		try {
			conn=this.dataSource.getConnection();
			String sql = this.sqlRunner.sql("kpi.basekpi.maxVersion");
 			version=this.sqlRunner.query(conn, sql,new MapHandler(),this.getKpiInfo().getBaseKpi().getBase_key());
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return version;
	}
	public int insertBaseKpi(String id) throws Exception {
		Connection conn = null;
		int i = 0;
		try {
			BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("kpi_id", id);
			map.put("base_key", baseKpi.getBase_key());
			map.put("kpi_version", baseKpi.getKpi_version());
			map.put("kpi_name", baseKpi.getKpi_name());
			map.put("kpi_unit", baseKpi.getKpi_unit());
			map.put("kpi_origin_schema", baseKpi.getKpi_origin_schema());
			map.put("kpi_origin_table", baseKpi.getKpi_origin_table());
			map.put("kpi_origin_column", baseKpi.getKpi_origin_column());
			map.put("kpi_origin_regular", sss(baseKpi.getKpi_origin_regular()));
			map.put("kpi_explain", sss(baseKpi.getKpi_explain())); 
			map.put("kpi_proposer", baseKpi.getKpi_proposer()); 
			map.put("kpi_proposer_dept", baseKpi.getKpi_proposer_dept()); 
			map.put("kpi_state", baseKpi.getKpi_state()); 
			map.put("kpi_origin_desc", baseKpi.getKpi_origin_desc()); 
			map.put("type", baseKpi.getBaseType()); 
			map.put("create_user_id", baseKpi.getCreate_user_id());
			SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	        String date=simpleDateFormat.format(new Date());
			map.put("create_time", date); 
			map.put("kpi_eds", baseKpi.getKpi_eds()); 
			map.put("kpi_category", baseKpi.getKpi_category()); 
			map.put("account_type", baseKpi.getAccount_type()); 
			map.put("cube_code", baseKpi.getCube_code()); 
			map.put("kpi_code", baseKpi.getKpi_code()); 
			map.put("kpi_ord", baseKpi.getBase_key().substring(3,11)); 
//			conn = this.dataSource.getConnection();
//			conn.setAutoCommit(false);
			String baseKpiSql = this.sqlRunner.sql("kpi.basekpi.saveBaseKpi");
			String baseHisKpiSql = this.sqlRunner.sql("kpi.basekpi.saveHisBaseKpi");
//			Map<String,Object> map = ibks(id);
 			i = this.sqlRunner.executet(baseKpiSql + ";" + baseHisKpiSql, map);
//			conn.commit();
		} catch (Exception e) {
//			conn.rollback();
			e.printStackTrace();
		} 
//		finally {
//			try {
//				DbUtils.close(conn);
//			} catch (SQLException e) {
//				e.printStackTrace();
//			}
//		}
		return i;
	}
	public int insertBaseKpi() throws IllegalAccessException, NoSuchMethodException, InvocationTargetException {
		Connection conn = null;
		QueryRunner queryRunner = new QueryRunner();
		int i = 0;
		try {
			conn = this.dataSource.getConnection();
			i = queryRunner.update(conn, ibks());
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				DbUtils.close(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return i;
	}
	public int insertBaseKpiHis(String id) throws IllegalAccessException, NoSuchMethodException, InvocationTargetException {
		Connection conn = null;
		QueryRunner queryRunner = new QueryRunner();
		int i = 0;
		try {
			conn = this.dataSource.getConnection();
			Map<String,Object> map= ibksHis(id);
			i = queryRunner.update(conn, map.get("sql").toString(),(Object[])map.get("param"));
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				DbUtils.close(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return i;
	}


	public int updateBaseKpi() throws Exception{
		Connection conn= null;
		int i=0;
		try {
			conn=this.dataSource.getConnection();
			BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("base_key", baseKpi.getBase_key());
			map.put("kpi_version", baseKpi.getKpi_version());
			map.put("kpi_name", baseKpi.getKpi_name());
			map.put("kpi_unit", baseKpi.getKpi_unit());
			map.put("kpi_origin_schema", baseKpi.getKpi_origin_schema());
			map.put("kpi_origin_table", baseKpi.getKpi_origin_table());
			map.put("kpi_origin_column", baseKpi.getKpi_origin_column());
			map.put("kpi_origin_regular", sss(baseKpi.getKpi_origin_regular()));
			map.put("kpi_explain", sss(baseKpi.getKpi_explain())); 
			map.put("kpi_proposer", baseKpi.getKpi_proposer()); 
			map.put("kpi_proposer_dept", baseKpi.getKpi_proposer_dept()); 
			map.put("kpi_state", baseKpi.getKpi_state()); 
			map.put("kpi_origin_desc", baseKpi.getKpi_origin_desc()); 
			map.put("type", baseKpi.getBaseType()); 
			map.put("edit_user_id", baseKpi.getEdit_user_id());
			SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	        String date=simpleDateFormat.format(new Date());
			map.put("edit_time", date); 
			map.put("kpi_eds", baseKpi.getKpi_eds()); 
			map.put("kpi_category", baseKpi.getKpi_category()); 
			map.put("account_type", baseKpi.getAccount_type()); 
			map.put("cube_code", baseKpi.getCube_code()); 
			map.put("kpi_code", baseKpi.getKpi_code()); 
			map.put("kpi_ord", baseKpi.getBase_key().substring(3,11)); 
//			conn = this.dataSource.getConnection();
//			conn.setAutoCommit(false);
			String updateHisKpiStatusSql = this.sqlRunner.sql("kpi.basekpi.updateHisBaseKpiStatus");
			String baseKpiSql = this.sqlRunner.sql("kpi.basekpi.updateBaseKpi");
			String baseHisKpiSql = this.sqlRunner.sql("kpi.basekpi.updateHisBaseKpi");
			i = this.sqlRunner.executet(updateHisKpiStatusSql + ";" +baseKpiSql+";" + baseHisKpiSql ,map);
//			i = this.sqlRunner.executet(baseKpiSql,map);
//			i = this.sqlRunner.execute(baseHisKpiSql,map);
//			conn.commit();
		} catch (SQLException e) {
//			conn.rollback();
			e.printStackTrace();
		}
//		finally {
//			try {
//				DbUtils.close(conn);
//			} catch (SQLException e) {
//				e.printStackTrace();
//			}
//		}
		return i;
	}
	public int updateBaseKpiHis(){
		Connection conn= null;
		QueryRunner queryRunner=new QueryRunner();
		int i=0;
		try {
			conn=this.dataSource.getConnection();
			BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
			i=queryRunner.update(conn,this.updateSqlHis());
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				DbUtils.close(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return i;
	}
	public int updateHis(){
		Connection conn= null;
		QueryRunner queryRunner=new QueryRunner();
		int i=0;
		try {
			conn=this.dataSource.getConnection();
			BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
			i=queryRunner.update(conn,this.insertKpi());
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				DbUtils.close(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return i;
	}
	private String ibks(){
		BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
		StringBuilder sb=new StringBuilder("INSERT INTO x_base_kpi (id,base_key, kpi_version, kpi_name, kpi_unit, kpi_origin_schema, kpi_origin_table, kpi_origin_column, kpi_origin_regular, kpi_explain, kpi_proposer, kpi_proposer_dept,kpi_state, kpi_origin_desc, type, create_user_id, create_time,kpi_eds,kpi_category,account_type,cube_code,KPI_CODE,kpi_ord) VALUES (Nextval('X_KPI_INFO_SEQ'),");
		sb.append("'"+baseKpi.getBase_key());
		sb.append("','"+baseKpi.getKpi_version());
		sb.append("','"+baseKpi.getKpi_name());
		sb.append("','"+baseKpi.getKpi_unit());
		sb.append("','"+baseKpi.getKpi_origin_schema());
		sb.append("','"+baseKpi.getKpi_origin_table());
		sb.append("','"+baseKpi.getKpi_origin_column());
		sb.append("','"+sss(baseKpi.getKpi_origin_regular()));
		sb.append("','"+sss(baseKpi.getKpi_explain()));
		sb.append("','"+baseKpi.getKpi_proposer());
		sb.append("','"+baseKpi.getKpi_proposer_dept());
		sb.append("','"+baseKpi.getKpi_state());
		sb.append("','"+baseKpi.getKpi_origin_desc());
		sb.append("','"+baseKpi.getBaseType());
		sb.append("','"+baseKpi.getCreate_user_id());
		sb.append("','"+baseKpi.getCreate_time());
		sb.append("','"+baseKpi.getKpi_eds());
		sb.append("','"+baseKpi.getKpi_category());
		sb.append("','"+baseKpi.getAccount_type());
		sb.append("','" + baseKpi.getCube_code());
		sb.append("','"+baseKpi.getKpi_code());
		sb.append("','"+baseKpi.getBase_key().substring(3)+"')");

		//sb.append("','"+baseKpi.getEdit_user_id());
		//sb.append("','"+baseKpi.getEdit_time()+"')");
		//sb.append("','"+baseKpi.getUpload_file_name());
		//sb.append("','"+baseKpi.getUpload_file_dir()+"')");
		logger.debug("SQL:"+sb);
		return  sb.toString();
	}
	private Map<String,Object> ibks(String id){
		BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		StringBuilder sb=new StringBuilder("INSERT INTO x_base_kpi (id,base_key, kpi_version, kpi_name, kpi_unit, kpi_origin_schema, kpi_origin_table, kpi_origin_column, kpi_origin_regular, kpi_explain, kpi_proposer, kpi_proposer_dept,kpi_state, kpi_origin_desc, type, create_user_id, create_time,kpi_eds,kpi_category,account_type,cube_code,KPI_CODE,kpi_ord) VALUES ("+id+",");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?)");
		//sb.append("','"+baseKpi.getEdit_user_id());
		//sb.append("','"+baseKpi.getEdit_time()+"')");
		//sb.append("','"+baseKpi.getUpload_file_name());
		//sb.append("','"+baseKpi.getUpload_file_dir()+"')");
		Object[] o = new Object[22];
		o[0] = baseKpi.getBase_key();
		o[1] = baseKpi.getKpi_version();
		o[2] = baseKpi.getKpi_name();
		o[3] = baseKpi.getKpi_unit();
		o[4] = baseKpi.getKpi_origin_schema();
		o[5] = baseKpi.getKpi_origin_table();
		o[6] = baseKpi.getKpi_origin_column();
		o[7] = sss(baseKpi.getKpi_origin_regular());
		o[8] = sss(baseKpi.getKpi_explain());
		o[9] = baseKpi.getKpi_proposer();
		o[10] = baseKpi.getKpi_proposer_dept();
		o[11] = baseKpi.getKpi_state();
		o[12] = baseKpi.getKpi_origin_desc();
		o[13] = baseKpi.getBaseType();
		o[14] = baseKpi.getCreate_user_id();
		o[15] = sdf.format(new Date()).toString();
		o[16] = baseKpi.getKpi_eds();
		o[17] = baseKpi.getKpi_category();
		o[18] = baseKpi.getAccount_type();
		o[19] = baseKpi.getCube_code();
		o[20] = baseKpi.getKpi_code();
		o[21] = baseKpi.getBase_key().substring(3);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("sql", sb.toString());
		map.put("params", o);
		logger.debug("SQL:"+sb);
//		return  sb.toString();
		return map;
	}
	private Map<String,Object> ibksHis(String id){
		BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
		StringBuilder sb=new StringBuilder("INSERT INTO x_base_kpi_his (his_id,id,base_key, kpi_version, kpi_name, kpi_unit, kpi_origin_schema, kpi_origin_table, kpi_origin_column, kpi_origin_regular, kpi_explain, kpi_proposer, kpi_proposer_dept,kpi_state, kpi_origin_desc, type, create_user_id, create_time,kpi_eds,kpi_category,account_type,cube_code,KPI_CODE) VALUES ("+id+",");
		sb.append("Nextval('X_KPI_INFO_SEQ'),");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("to_char(now(),'yyyy-mm-dd hh24:mi:ss'),");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?,");
		sb.append("?)");
		//sb.append("','"+baseKpi.getEdit_user_id());
		//sb.append("','"+baseKpi.getEdit_time()+"')");
		//sb.append("','"+baseKpi.getUpload_file_name());
		//sb.append("','"+baseKpi.getUpload_file_dir()+"')");
		Object[] o = new Object[20];
		o[0] = baseKpi.getBase_key();
		o[1] = baseKpi.getKpi_version();
		o[2] = baseKpi.getKpi_name();
		o[3] = baseKpi.getKpi_unit();
		o[4] = baseKpi.getKpi_origin_schema();
		o[5] = baseKpi.getKpi_origin_table();
		o[6] = baseKpi.getKpi_origin_column();
		o[7] = baseKpi.getKpi_origin_regular();
		o[8] = baseKpi.getKpi_explain();
		o[9] = baseKpi.getKpi_proposer();
		o[10] = baseKpi.getKpi_proposer_dept();
		o[11] = baseKpi.getKpi_state();
		o[12] = baseKpi.getKpi_origin_desc();
		o[13] = baseKpi.getBaseType();
		o[14] = baseKpi.getCreate_user_id();
		o[15] = baseKpi.getKpi_eds();
		o[16] = baseKpi.getKpi_category();
		o[17] = baseKpi.getAccount_type();
		o[18] = baseKpi.getCube_code();
		o[19] = baseKpi.getKpi_code();
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("sql", sb.toString());
		map.put("param", o);
		logger.debug("SQL:"+sb);
//		return  sb.toString();
		return map;
	}
	public String insertKpi(){
		BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
//		String insert ="insert into x_base_kpi_his value (select X_KPI_INFO_SEQ.Nextval,t.* from x_base_kpi t where t.base_key = '"+baseKpi.getBase_key()+"')";
		String insert = "insert into x_base_kpi_his (his_id,base_key, kpi_version, kpi_name, kpi_unit, kpi_origin_schema, kpi_origin_table, kpi_origin_column, kpi_origin_regular, kpi_explain, kpi_proposer, kpi_proposer_dept, kpi_state, kpi_origin_desc, type, create_user_id, create_time, edit_user_id, edit_time, upload_file_name, upload_file_dir, kpi_eds, kpi_category, id, account_type, kpi_condition, kpi_type, cube_code, kpi_code)";
			   insert += "(select Nextval('X_KPI_INFO_SEQ'),base_key, kpi_version, kpi_name, kpi_unit, kpi_origin_schema, kpi_origin_table, kpi_origin_column, kpi_origin_regular, kpi_explain, kpi_proposer, kpi_proposer_dept, kpi_state, kpi_origin_desc, type, create_user_id, create_time, edit_user_id, edit_time, upload_file_name, upload_file_dir, kpi_eds, kpi_category, id, account_type, kpi_condition, kpi_type, cube_code, kpi_code ";
			   insert +=  "from x_base_kpi  where base_key = '"+ baseKpi.getBase_key() +"')";
		return insert;
	}
	public Map<String,Object> updateSql(){
		BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
		StringBuilder sb=new StringBuilder("UPDATE X_BASE_KPI SET");
		sb.append(" kpi_name =?");
		sb.append(", kpi_unit =?");
		sb.append(", kpi_origin_schema =?");
		sb.append(", kpi_origin_table =?");
		sb.append(", kpi_origin_column =?");
		sb.append(", kpi_origin_regular =?");
		sb.append(", kpi_explain =?");
		sb.append(", kpi_proposer =?");
		sb.append(", kpi_proposer_dept =?");
		//sb.append("', kpi_state ='"+baseKpi.getKpi_state());
		sb.append(", kpi_origin_desc =?");
		//sb.append("', type ='"+baseKpi.getBaseType());
		sb.append(", edit_user_id =?");
		sb.append(", edit_time =to_char(now(),'yyyy-mm-dd hh24:mi:ss')");
		sb.append(", kpi_eds=?");
		sb.append(", kpi_category=?");
		sb.append(",account_type=?");
		sb.append(",cube_code=?");
		sb.append(",kpi_code=?");
		sb.append(",kpi_version=?");
		sb.append(" WHERE base_key=?");
		
		Object[] o = new Object[18];
		o[0] = baseKpi.getKpi_name();
		o[1] = baseKpi.getKpi_unit();
		o[2] = baseKpi.getKpi_origin_schema();
		o[3] = baseKpi.getKpi_origin_table();
		o[4] = baseKpi.getKpi_origin_column();
		o[5] = sss(baseKpi.getKpi_origin_regular());
		o[6] = sss(baseKpi.getKpi_explain());
		o[7] = baseKpi.getKpi_proposer();
		o[8] = baseKpi.getKpi_proposer_dept();
		o[9] = baseKpi.getKpi_origin_desc();
		o[10] = baseKpi.getCreate_user_id();
		o[11] = baseKpi.getKpi_eds();
		o[12] = baseKpi.getKpi_category();
		o[13] = baseKpi.getAccount_type();
		o[14] = baseKpi.getCube_code();
		o[15] = baseKpi.getKpi_code();
		o[16] = baseKpi.getKpi_version();
		o[17] = baseKpi.getBase_key();
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("sql", sb.toString());
		map.put("params", o);
		
		logger.debug(sb);
//		return sb.toString();
		return map;
	}
	public String updateSqlHis(){
		BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
		StringBuilder sb=new StringBuilder("UPDATE X_BASE_KPI_HIS SET");
		sb.append(" kpi_state ='"+"0");
		sb.append("' WHERE base_key='"+baseKpi.getBase_key()+"'");
		
		logger.debug(sb);
		return sb.toString();

	}
	public KpiInfo getKpiInfo() {
		return kpiInfo;
	}

	public void setKpiInfo(KpiInfo kpiInfo) {
		this.kpiInfo = kpiInfo;
	}
	private void fileInsert(BaseFile baseFile,String source){
		Connection conn= null;
		PreparedStatement ps=null;
		BaseKpiService baseKpiService=new BaseKpiService();
		try {
			conn=baseKpiService.dataSource.getConnection();
			String sql="INSERT INTO x_base_file_info (id, code, file_name, source, file_size, type,file_path) VALUES(Nextval('X_BFINFO_SEQ'),?,?,?,?,?,?)";
			ps=conn.prepareStatement(sql);
			ps.setString(1,baseFile.getCode());
			ps.setString(2,baseFile.getFileName());
			if(source.equals("1")){
				ps.setBytes(3,new byte[]{});
			}
			else
				ps.setBytes(3,this.inputStream2ByteArray(baseFile.getSource()));
			ps.setString(4,String.valueOf(baseFile.getFileSize()));
			ps.setString(5,baseFile.getType());
			ps.setString(6,baseFile.getFilePath());
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				DbUtils.close(ps);
				DbUtils.close(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	private void fileUpdate(BaseFile baseFile,String source){
		Connection conn= null;
		PreparedStatement ps=null;
		BaseKpiService baseKpiService=new BaseKpiService();
		try {
			conn=baseKpiService.dataSource.getConnection();
			String sql="UPDATE x_base_file_info SET file_name=?,file_size=?,source=?, type=?,file_path=? WHERE code=?";
			ps=conn.prepareStatement(sql);
			ps.setString(1,baseFile.getFileName());
			ps.setString(2,String.valueOf(baseFile.getFileSize()));
			if(source.equals("1")){
				ps.setBytes(3,new byte[]{});
			}
			else
				ps.setBytes(3,this.inputStream2ByteArray(baseFile.getSource()));
			ps.setString(4,baseFile.getType());
			ps.setString(5,baseFile.getFilePath());
			ps.setString(6,baseFile.getId());
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				DbUtils.close(ps);
				DbUtils.close(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public  void file2DB(BaseFile baseFile,String action,String source)  {
		if(action.equals("insert"))
			fileInsert(baseFile,source);
		else
			fileUpdate(baseFile,source);
	}

	public Map queryFile(String kpiCode){
		Map<String,String> map = null;
		Connection conn= null;
		PreparedStatement ps=null;
		BaseKpiService baseKpiService=new BaseKpiService();
		try {
			conn=baseKpiService.dataSource.getConnection();
			String sql="SELECT file_name, file_path from x_base_file_info where code=? ";
			ps=conn.prepareStatement(sql);
			ps.setString(1,kpiCode);
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				map = new HashMap<String,String>();
				map.put("fileName", rs.getString("file_name"));
				map.put("filePath", rs.getString("file_path").replaceAll("\\\\", "/"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				DbUtils.close(ps);
				DbUtils.close(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return map;
	}
	
	private byte[] inputStream2ByteArray(InputStream in) throws Exception {
		if (in == null) {
			return null;
		}
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		try {
			int buf_size = 1024;
			byte[] buffer = new byte[buf_size];
			int len = 0;
			while (-1 != (len = in.read(buffer, 0, buf_size))) {
				bos.write(buffer, 0, len);
			}
			return bos.toByteArray();
		} catch (Exception e) {
			throw new Exception(e);
		} finally {
			in.close();
			bos.close();
		}

	}
	
	public Map<String,String> validateBaseKpiName(){
		Map<String,String> map=new HashMap<String,String>();
		Connection conn= null;
		PreparedStatement preparedStatement=null;
		ResultSet resultSet=null;
		BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
		String sql="SELECT COUNT(1) FROM X_BASE_KPI WHERE KPI_NAME=?  AND CUBE_CODE=? AND KPI_STATE='1' ";
		try {
			conn = dataSource.getConnection();
			preparedStatement = conn.prepareStatement(sql);
			preparedStatement.setString(1, baseKpi.getKpi_name());
			preparedStatement.setString(2, baseKpi.getCube_code());
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()) {
				if(resultSet.getInt(1) > 0) {
					map.put("msg","1");
				} else {
					map.put("msg","0");
				}
			}
		} catch (SQLException e) {
			map.put("msg",StringUtils.trim(e.getMessage()));
			logger.debug(e.getMessage());
		}finally {
			try {
				DbUtils.close(resultSet);
				DbUtils.close(preparedStatement);
				DbUtils.close(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}		
		return map;
	}
	public Map<String,String> deleteBaseKpi() throws Exception{
		Map<String,String> map=new HashMap<String,String>();
		Connection conn= null;
		Statement statement=null;
		BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
		String delSql = " update X_BASE_KPI set kpi_state='0' WHERE base_key= '"+ baseKpi.getBase_key() +"' ";
		String insHis = "insert into x_base_kpi_his (his_id,base_key, kpi_version, kpi_name, kpi_unit, kpi_origin_schema, kpi_origin_table, kpi_origin_column, kpi_origin_regular, kpi_explain, kpi_proposer, kpi_proposer_dept, kpi_state, kpi_origin_desc, type, create_user_id, create_time, edit_user_id, edit_time, upload_file_name, upload_file_dir, kpi_eds, kpi_category, id, account_type, kpi_condition, kpi_type, cube_code, kpi_code)";
			   insHis += "(select NEXTVAL('X_KPI_INFO_SEQ'),base_key, kpi_version, kpi_name, kpi_unit, kpi_origin_schema, kpi_origin_table, kpi_origin_column, kpi_origin_regular, kpi_explain, kpi_proposer, kpi_proposer_dept, '-1', kpi_origin_desc, type, create_user_id, create_time, '"+ baseKpi.getEdit_user_id() +"', to_char(now(),'yyyy-mm-dd HH24:mi:ss'), upload_file_name, upload_file_dir, kpi_eds, kpi_category, id, account_type, kpi_condition, kpi_type, cube_code, kpi_code ";
			   insHis +=  "from x_base_kpi  where base_key = '"+ baseKpi.getBase_key() +"')";
	    String uptSql = " update x_base_kpi_his set kpi_state ='0' where base_key = '"+ baseKpi.getBase_key() +"' ";
	    String delMyKPI="DELETE FROM X_REPORT_MYKPI WHERE KPI_COLUMN = '" + baseKpi.getBase_key() + "'";
		try {
			Map<String,Object> params = new HashMap<String,Object>();
			params.put("base_key", baseKpi.getBase_key());
//			conn = dataSource.getConnection();
			insHis = this.sqlRunner.sql("kpi.basekpi.updateBaseKpiStatus");
			delSql = this.sqlRunner.sql("kpi.basekpi.updateHisBaseKpi");
			uptSql = this.sqlRunner.sql("kpi.basekpi.updateHisBaseKpiStatus");
			delMyKPI = this.sqlRunner.sql("kpi.basekpi.delMykpi");
//			conn.setAutoCommit(false);
			this.sqlRunner.executet(uptSql + ";" + insHis+";" + delSql +";" + delMyKPI, params);
//			this.sqlRunner.update(conn,insHis, params);
//			this.sqlRunner.update(conn,delSql, params);
//			this.sqlRunner.update(conn,delMyKPI, params);
//			statement = conn.createStatement();
//			statement.execute(uptSql);
//			statement.execute(insHis);
//			statement.execute(delSql);
//			statement.execute(delMyKPI);
//			conn.commit();
			map.put("msg", "1");
		} catch (Exception e) {
//			conn.rollback();
			map.put("msg",StringUtils.trim(e.getMessage()));
			logger.debug(e.getMessage());
		}
//		finally {
//			try {
//				DbUtils.close(statement);
//				DbUtils.close(conn);
//			} catch (SQLException e) {
//				e.printStackTrace();
//			}
//		}		
		return map;
	}
	public Map validateSTC(){
		Map map=new HashMap();
		Connection conn= null;
		PreparedStatement preparedStatement=null;
		ResultSet resultSet=null;
		BaseKpi baseKpi=this.getKpiInfo().getBaseKpi();
		String sql="SELECT * FROM "+baseKpi.getKpi_origin_schema()+"."+baseKpi.getKpi_origin_table();
		String dataBase ="";
		logger.debug(sql);
		try {
			if(!"spring".equals(baseKpi.getKpi_eds())){
				String dataSourceName = baseKpi.getKpi_eds();//this.eds.get().get(baseKpi.getKpi_eds()).toString();
				EasyDataSource dataSource= CommonTools.getDataSource(dataSourceName);
				dataBase = dataSource.getDataSourceDB();
				if(dataSource==null){
					map.put("msg","数据源不存在!");
					return map;
				}
				conn=dataSource.getConnection();
			}else{
				conn=this.dataSource.getConnection();
			}
			sql = SQLTool.getSql(dataBase, sql);
			preparedStatement=conn.prepareStatement(sql);
			resultSet=preparedStatement.executeQuery();
			ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
			int length=resultSetMetaData.getColumnCount();
			for(int i=1;i<length+1;i++){
				String value=resultSetMetaData.getColumnName(i);
				if(value.equals(StringUtils.upperCase(baseKpi.getKpi_origin_column()))){
					map.put("msg","success");
				}
			}
		} catch (SQLException e) {
			map.put("msg",StringUtils.trim(e.getMessage()));
			logger.debug(e.getMessage());
		}finally {
			try {
				DbUtils.close(resultSet);
				DbUtils.close(preparedStatement);
				DbUtils.close(conn);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}		
		return map;
	}
	public static String sss(String myString){  
        String newString=null;  
        Pattern CRLF = Pattern.compile("(\r\n|\r|\n|\n\r|\t)");  
        Matcher m = CRLF.matcher(myString);  
        if (m.find()) {  
          newString = m.replaceAll("   ");  
        } else {
        	newString = myString;
        }
        return newString;  
    }  
	public static void main(String args[]){
		System.out.println(Thread.currentThread());
	}
}
