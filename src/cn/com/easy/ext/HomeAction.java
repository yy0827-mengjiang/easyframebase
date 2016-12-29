package cn.com.easy.ext;

import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;

@Controller
public class HomeAction {
	private SqlRunner runner;
	
	@SuppressWarnings("unchecked")
	@Action("getcaldata")
	public void calendarData(Map args,HttpServletRequest request,HttpServletResponse response) {
		PrintWriter out = null;
		
		try {
			response.setHeader("Expires","-1");
			response.setHeader("Pragma","no-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setContentType("text/html");
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			out = response.getWriter();
			
			String[] cld = new String[31];
			StringBuffer result = new StringBuffer("指标名" + "::");
			StringBuffer sql = new StringBuffer();
			
			Map exprInfo = runner.queryForMap("select b.EXT_FIELD FIELDS,b.KPI_EXT_EXPR EXPR,b.FORMATTER,b.RATIO,b.SUFFIX from e_home_kpi_info a,E_KPI_EXT_EXPR b where a.kpi_code=b.kpi_code and a.is_ext='1' and a.kpi_code='"+args.get("kpi_code")+"'");
			if(exprInfo !=null){
				String expr = (String)exprInfo.get("EXPR");
				String fields = (String)exprInfo.get("FIELDS");
				String formatter = (String)exprInfo.get("FORMATTER");
				String ratio = (String)exprInfo.get("RATIO");
				String suffix = (String)exprInfo.get("SUFFIX");
				for(String field:fields.split(",")){
					expr = expr.replaceAll(field, "sum("+field+"_1)");
				}
				if(ratio != null){
					expr = expr+"*"+ratio;
				}
				if(formatter != null){
					expr = "to_char("+expr+","+"'"+formatter+"')";
				}
				if(suffix != null){
					expr = expr+"||'"+suffix+"'";
				}
				sql.append("select substr(DAY_ID,7,2) DAYID,"+expr+" KPIVALUE from HOME_DM_USER_KPI_COMPOSITE a where a.kpi_id='"+args.get("kpi_code")+"' ");
			}else{
				sql.append("SELECT substr(DAY_ID,7,2) DAYID,round(SUM(DAY_VALUE)) KPIVALUE FROM ");
				if(args.get("kpi_code").toString().startsWith("01")){
					sql.append("HOME_DM_USER_KPI ");
				}else if(args.get("kpi_code").toString().startsWith("02")){
					sql.append("HOME_DM_INCO_KPI ");
				}else if(args.get("kpi_code").toString().startsWith("03")){
					sql.append("HOME_DM_APPLY_KPI ");
				}else{
					out.print("FAIL");
					return;
				}
				sql.append("where 1=1 ");
			}
			sql.append("and substr(DAY_ID,0,6) = substr('"+args.get("acct_day")+"',0,6)");
			sql.append("AND KPI_ID='"+args.get("kpi_code")+"'");
			Map userInfo=request.getSession().getAttribute("UserInfo")==null?null:((Map)request.getSession().getAttribute("UserInfo"));
			if(userInfo!=null&&userInfo.get("AREA_ECODE")!=null&&(!(userInfo.get("AREA_ECODE").toString().equals("")))&&(!(userInfo.get("AREA_ECODE").toString().equals("null")))&&(!(userInfo.get("AREA_ECODE").toString().equals("-1")))){
				sql.append("AND AREA_NO='"+userInfo.get("AREA_ECODE").toString()+"'");
			}
			
			if(args.get("area_no") != null && !args.get("area_no").equals("")){
				sql.append("AND AREA_NO='"+args.get("area_no")+"'");
			}
			if(args.get("city_no") != null && !args.get("city_no").equals("")){
				sql.append("AND city_no='"+args.get("city_no")+"'");
			}
			if(args.get("city_no") == null || args.get("city_no").equals("")){
				if(userInfo!=null&&userInfo.get("CITY_ECODE")!=null&&(!(userInfo.get("CITY_ECODE").toString().equals("")))&&(!(userInfo.get("CITY_ECODE").toString().equals("null")))&&(!(userInfo.get("CITY_ECODE").toString().equals("-1")))){
					sql.append("AND city_no='"+userInfo.get("CITY_ECODE").toString()+"'");
				}
				
			}
			if(args.get("customer_no") != null && !args.get("customer_no").equals("")){
				sql.append("AND MARKET_TYPE='"+args.get("customer_no")+"'");
			}
			if(args.get("channel_no") != null && !args.get("channel_no").equals("")){
				sql.append("AND channel_type_id='"+args.get("channel_no")+"'");
			}
			sql.append("group by DAY_ID order by DAY_ID asc");
			
			
			List<Map<String,Object>> caldata = (List<Map<String,Object>>)runner.queryForMapList(sql.toString());
			
			for(Map<String,Object> map : caldata){
				int day=Integer.parseInt(map.get("DAYID").toString());
				String kpivalue=String.valueOf(map.get("KPIVALUE"));
				if(kpivalue==null){
					cld[day-1]=null;
				}else{
					cld[day-1]=kpivalue;
				}
			}
			for(int i=0;i<31;i++)
				if(cld[i]==null){
					result.append("!");
				}else{
					result.append(cld[i] + "!");
				}
			out.print(result.toString());
		} catch (Exception e) {
			out.print("FAIL");
			e.printStackTrace();
		}finally{
			if(out != null){
				out.flush();
				out.close();
			}
		}
	}
}