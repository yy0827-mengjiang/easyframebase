package cn.com.easy.kpi.service;

import java.lang.reflect.Field;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import cn.com.easy.annotation.Service;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.kpi.element.KpiInfo;
import cn.com.easy.kpi.element.KpiSource;
@Service
public class KpiDbService {
	//private String addInfo="insert into x_kpi_info_tmp (kpi_key,kpi_code,kpi_name,kpi_category,kpi_nuit,kpi_version,kpi_iscurr,kpi_caliber,kpi_explain,kpi_flag,kpi_status,kpi_body,create_user,create_datetime) values(to_number(#kpi_key#),#kpi_code#,#kpi_name#,to_number(#kpi_category#),#kpi_nuit#,#kpi_version#,#kpi_iscurr#,#kpi_caliber#,#kpi_explain#,#kpi_flag#,#kpi_status#,#kpi_body#,#create_user#,now())";
	//private String addSource="insert into x_kpi_source_tmp (source_key,kpi_code,kpi_version,source_kpi,source_dim,source_table,source_column,source_condition,source_type) values(to_number(#source_key#),#kpi_code#,to_number(#kpi_version#),#source_kpi#,#source_dim#,#source_table#,#source_column#,#source_condition#,#source_type#)";
	private static String addSourceSql="insert into x_kpi_source_tmp (#Field#) values(#Value#)";
	private static String source;
	private static String addInfoSql="insert into x_kpi_info_tmp (#Field#) values (#Value#)";
	private static String info;
	public int kpiUpdate2Db(KpiInfo ki,KpiSource ks,SqlRunner runner) throws IllegalArgumentException, IllegalAccessException, SQLException{
		String infoSql=updateSql(ki);
		String sourceSql=updateSql(ks);
		int i=1;
		int s=1;
		if(infoSql.length()>0&&ki.getKpi_key()!=0){
			String updateInfo="update x_kpi_info_tmp set "+infoSql+" where kpi_key="+ki.getKpi_key();
			i=runner.execute(updateInfo);
		}
		if(sourceSql.length()>0&&ks.getSource_key()!=0){
			String updateSource="update x_kpi_source_tmp set "+updateSql(ks)+" where source_key="+ks.getSource_key();
			s=runner.execute(updateSource);			
		}
		return i&s;
	}
	public int kpiAdd2Db(List<KpiInfo> infoList,List<KpiSource> sourceList,SqlRunner runner) throws SQLException{
		Map map=addSql(infoList,sourceList);
		String sql=source+info;
		int i=runner.executet(sql,map);
		return i;
	}
	private static Map addSql(List<KpiInfo> infoList,List<KpiSource> sourceList){
		Map parameterMap=new HashMap();
		StringBuffer ks_sb=new StringBuffer();
		for(int i=0;i<sourceList.size();i++){
			Map temp=new HashMap();
			temp.put("source_key_"+i,sourceList.get(i).getSource_key());
			temp.put("kpi_code_"+i,sourceList.get(i).getKpi_code());
			temp.put("kpi_version_"+i,sourceList.get(i).getKpi_version());
			temp.put("source_kpi_"+i,sourceList.get(i).getSource_kpi());
			temp.put("source_code_"+i,sourceList.get(i).getSource_code());
			temp.put("source_table_"+i,sourceList.get(i).getSource_table());
			temp.put("source_column_"+i,sourceList.get(i).getSource_column());
			temp.put("source_condition_"+i,sourceList.get(i).getSource_condition());
			temp.put("source_type_"+i,sourceList.get(i).getSource_type());
			temp.put("source_name_"+i,sourceList.get(i).getSource_name());
			temp.put("source_version_"+i, sourceList.get(i).getSource_version());
			formSql(ks_sb,temp,addSourceSql,i);
			parameterMap.putAll(temp);
		}
		source=new String(ks_sb);
		/////
		StringBuffer ki_sb=new StringBuffer();
		for(int i=0;i<infoList.size();i++){
			Map temp=new HashMap();
			temp.put("cube_code_"+i, infoList.get(i).getCube_code());
			temp.put("kpi_type_"+i, infoList.get(i).getKpi_type());
			temp.put("acctType_"+i, infoList.get(i).getAcctType());
			temp.put("service_key_"+i, infoList.get(i).getService_Key());
			temp.put("kpi_key_"+i,infoList.get(i).getKpi_key());
			temp.put("kpi_code_"+i,infoList.get(i).getKpi_code());
			temp.put("kpi_name_"+i,infoList.get(i).getKpi_name());
			temp.put("kpi_version_"+i,infoList.get(i).getKpi_version());
			temp.put("kpi_category_"+i,infoList.get(i).getKpi_category());
			temp.put("kpi_nuit_"+i,infoList.get(i).getKpi_nuit());
			temp.put("kpi_iscurr_"+i,infoList.get(i).getKpi_iscurr());
			temp.put("kpi_caliber_"+i,infoList.get(i).getKpi_caliber());
			temp.put("kpi_explain_"+i,infoList.get(i).getKpi_explain());
			temp.put("kpi_flag_"+i,infoList.get(i).getKpi_flag());
			temp.put("kpi_status_"+i,infoList.get(i).getKpi_status());
			temp.put("kpi_body_"+i,infoList.get(i).getKpi_body());
			if(infoList.get(i).getCreate_user_old() == null || "".equals(infoList.get(i).getCreate_user_old())) {
				temp.put("create_user_"+i,infoList.get(i).getCreate_user());
				temp.put("create_datetime_"+i,"");	
				temp.put("update_user_" + i, "");
				temp.put("update_datetime_"+i,"");	
			} else {
				temp.put("create_user_"+i,infoList.get(i).getCreate_user_old());
				temp.put("create_datetime_"+i,infoList.get(i).getCreate_datetime_old());	
				temp.put("update_user_" + i, infoList.get(i).getCreate_user());
				temp.put("update_datetime_"+i,"");	
			}
			temp.put("kpi_user_"+i, infoList.get(i).getKpi_user());
			temp.put("kpi_dept_"+i, infoList.get(i).getKpi_dept());
			temp.put("explain_"+i, infoList.get(i).getExplain());
			temp.put("kpi_file_"+i, infoList.get(i).getKpi_file());
			formSql(ki_sb,temp,addInfoSql,i);
			parameterMap.putAll(temp);			
		}
		info=new String(ki_sb);
		return parameterMap;
	}
	
	private static void formSql(StringBuffer sb,Map map,String sql,int index){
		Set ks=map.keySet();
		Iterator ir=ks.iterator();
		StringBuffer sqlValue=new StringBuffer();
		StringBuffer sqlField=new StringBuffer();
		boolean first=true;
		while(ir.hasNext()){
			String irStr=ir.next().toString();
			String irSubStr=irStr.substring(0, irStr.lastIndexOf("_"));
			if(first){
				//if(temp.get(irStr).getClass().getSimpleName().equals("Date")){
				//sqlValue.append("to_date(#"+irStr+"#,'yyyy-MM-dd')");
				//}
				if(irSubStr.equals("create_datetime")){
					String value = (String)map.get(irStr);
					if(!"".equals(value)) {
						sqlValue.append(" to_timestamp(#"+ irStr +"#,'dd-MON-yy hh:mi:ss.ff AM') ");
					} else {
						sqlValue.append(" now() ");
					}
				} else if (irSubStr.equals("update_datetime")) {
					if("I".equals(map.get("kpi_flag_"+index))) {
						sqlValue.append("  ");
					} else {
						sqlValue.append(" now() ");
					}
				} else{
					sqlValue.append("#"+irStr+"#");
				}
				sqlField.append(irSubStr);
				first=false;
			}else{
				if(irSubStr.equals("create_datetime")){
					String value = (String)map.get(irStr);
					if(!"".equals(value)) {
						sqlValue.append(" ,to_timestamp(#"+ irStr +"#,'dd-MON-yy hh:mi:ss.ff AM') ");
					} else {
						sqlValue.append(" ,now() ");
					}
				} else if (irSubStr.equals("update_datetime")) {
					if("I".equals(map.get("kpi_flag_"+index))) {
						sqlValue.append(" ,null ");
					} else {
						sqlValue.append(" ,now() ");
					}				
				} else{
					sqlValue.append(",#"+irStr+"#");
				}
				sqlField.append(","+irSubStr);
			}
		}
		String s=sql.replaceAll("#Field#",sqlField.toString()).replaceAll("#Value#",sqlValue.toString());
		sb.append(s+";");		
	}
	private static String updateSql(Object obj) throws IllegalArgumentException, IllegalAccessException{
		Field field[]=obj.getClass().getDeclaredFields();
		StringBuffer update=new StringBuffer();
		boolean first=true;
		for(int i=0;i<field.length;i++){
			field[i].setAccessible(true);
			if(field[i].get(obj)!=null&&(!field[i].getName().equals("kpi_key")&&!field[i].getName().equals("source_key"))){
				Class clazz=field[i].getType();
				String c=clazz.getSimpleName();
				String v = null;
				if (c.equals("int")){
					v=field[i].get(obj).toString();
				}
				else if(c.equals("String")){
					v="'"+field[i].get(obj)+"'";
				}
				else if(c.equals("Date")){
					SimpleDateFormat sdf=new SimpleDateFormat("MMdd");
					String date=sdf.format(field[i].get(obj));

					v="to_date("+date+",'MM-dd')";
				}
				if(first){
					update.append(field[i].getName()+"="+v);
					first=false;
				}
				else{
					update.append(","+field[i].getName()+"="+v);

				}
			}
		}
		StringBuffer sql=new StringBuffer();
		sql.append(update);		
		return sql.toString();  
	}
	public static void main(String args[]) throws IllegalArgumentException, IllegalAccessException{
		KpiInfo ki=new KpiInfo();
		Field[] f=ki.getClass().getDeclaredFields();
		for(int i=0;i<f.length;i++){
			f[i].setAccessible(true);
			if(f[i].getType().getSimpleName().equals("Date")){
				f[i].set(ki,new Date());
			}
			else
				f[i].set(ki,String.valueOf(i));
			System.out.println("name:"+f[i].getName()+"___value:"+f[i].get(ki));
		}
	}
}
