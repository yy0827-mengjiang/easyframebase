<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction}">
	<e:description>数据集配置完成</e:description>
	<e:case value="DATAFINAL">

			<%
		    	java.sql.Connection con = null;
			    String id = "";
			    java.sql.PreparedStatement stat = null;
			    try {
			        id = "" + request.getParameter("id");//report_sql_id
			        String report_id = "" + request.getParameter("report_id");
			        String data_name = "" + request.getParameter("name");//report_sql_name
			        String data_sql = "" + request.getParameter("data_sql");//report_sql
			        String databaseName = "" + request.getParameter("extds");//REPORT_SQL_TYPE
			        //String uptDataSql = "update x_report_sql set report_sql_name=?,report_sql=?,REPORT_SQL_TYPE=? where report_sql_id=?";
			        String delSql = "delete from x_report_sql where report_sql_id ='"+id+"'" + " and report_id = '" + report_id +"'";
			        con = cn.com.easy.xbuilder.parser.CommonTools.getConnection();
			        con.setAutoCommit(false);
			        java.sql.Statement ps = con.createStatement();
			        //删除
			        ps.executeUpdate(delSql);
			        con.commit();
			        String DBtype = con.getMetaData().getDatabaseProductName().trim();
					if(null!=DBtype&&(DBtype.contains("DB2")||DBtype.toLowerCase().contains("postgre"))){
			        	String intSql = "insert into x_report_sql (report_sql_id, report_id, report_sql_name, report_sql,REPORT_SQL_TYPE)  "+
		  					" values ('"+id+"','"+report_id+"',?,?,'"+databaseName+"')";
				        stat = con.prepareStatement(intSql);
						stat.setString(1, data_name);
						stat.setString(2, data_sql);
						stat.executeUpdate();
					    con.commit();
			        }else{
				        String intSql = "insert into x_report_sql (report_sql_id, report_id, report_sql_name, report_sql,REPORT_SQL_TYPE)  "+
					  					" values ('"+id+"','"+report_id+"',?,empty_clob(),'"+databaseName+"')";
				        stat = con.prepareStatement(intSql);
						stat.setString(1, data_name);
						stat.executeUpdate();
					    con.commit();
				        String clobObj = "select REPORT_SQL from x_report_sql where report_sql_id ='"+id+"' for update";
				        java.sql.ResultSet rs = ps.executeQuery(clobObj);
				        if(rs.next()){  
				            oracle.sql.CLOB clob = (oracle.sql.CLOB)rs.getClob(1) ;  
				            clob.putString(1,data_sql);  
				            String upSql = "update x_report_sql a set a.report_sql = ? where a.report_sql_id ='"+id+"' and a.report_id='"+ report_id +"'"; 
				            java.sql.PreparedStatement psps = con.prepareStatement(upSql) ;  
				            psps.setClob(1, clob);  
				            psps.executeQuery();  
				            psps.close();
				            rs.close();
					        ps.close();
				            con.commit();
				        }else{
				        	rs.close();
					        ps.close();
					        con.commit();
				        }
			        }
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					try {
						if (con != null)
							con.close();
						if (stat != null)
							stat.close();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
		    %>
	
	</e:case>

	<e:case value="CURDIMDATA">
		<e:q4o var="cur" sql="xbuilder.reportSql.CURDIMDATA"></e:q4o>${e:java2json(cur) }
	</e:case>

<e:case value="OTHERDATA">
		<c:tablequery>
			<e:sql name="xbuilder.reportSql.OTHERDATA"/>
   		</c:tablequery>
	</e:case>
	
<e:case value="VARDIMTREE">
		<e:if condition="${param.id==null || param.id eq ''}" var="is_var_null">
			[{
				"id":"-1",
				"text":"维度",
				"state":"closed"
			}]
		</e:if>
		<e:else condition="${is_var_null}">
			<e:q4l var="dims">
				select dim_category_id "id",
				 		dim_category_name "text",
				       'closed' "state"
				  from (select *
				          from x_dimension_category
				         where parent_dim_category_id = #id#
				         order by dim_category_order)
				union all
				select dim_id "id",
				       dim_var_name || '【'|| dim_var_desc||'】' "text",
				       'leaf' "state"
				  from (select *
				          from x_dimension
				         where dim_category_id = #id#
				         order by dim_ord)
			</e:q4l>${e:java2json(dims.list) }
		</e:else>
	</e:case>
	<e:case value="GLOBALDATA">
		<c:tablequery>
			<e:sql name="xbuilder.reportSql.GLOBALDATA"/>
		</c:tablequery>
	</e:case>
	<e:case value="ROLELIST">
		<e:q4l var="role">
			SELECT U.USER_ID, U.USER_NAME, R.ROLE_NAME
		  		FROM E_USER U, E_ROLE R, E_USER_ROLE UR
				WHERE U.USER_ID = UR.USER_ID(+)
		   			AND UR.ROLE_CODE = R.ROLE_CODE(+) AND U.USER_ID='${UserInfo.USER_ID }' 
		   			AND (R.ROLE_NAME like '%信息化%' or R.ROLE_NAME like '%企信部%')
		</e:q4l>${e:java2json(role.list) }
	</e:case>	
</e:switch>