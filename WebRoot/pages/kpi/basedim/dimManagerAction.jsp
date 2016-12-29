<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
	String Ip = request.getLocalAddr();
	request.setAttribute("ip",Ip);
%>
<e:switch value="${param.eaction }">
	
	<e:case value="baseDimStore">
		<e:if condition="${param.id==''||param.id==null}">
			[{
				"id":"0",
				"text":"维度",
				"state":"closed",
				"attributes":{"type":"dim","kpi_parent_id":"-1"}
			}]
		</e:if>
		<e:if condition="${param.id!=null&&param.id!=''}">
			<e:q4l var="kpiCategory">
			select * from (
			  select id,dim_code,parent_id,name,dim_type,account_type,dim_attr,dim_ord,data_type from (
				  select  c.category_id as id, 
				          '' as dim_code,
				          0 as parent_id,
				          c.category_name  as name,
				          '6' as dim_type,
				          '' as account_type,
				          'R' as dim_attr,
				           c.ord as dim_ord,
				           '1' as data_type
	  				from x_kpi_category c 
	  				where c.category_type='6'
	  				and c.category_flag is null
					) t where 1=1
		         <e:if condition="${param.id == '0'}" var="isFloder">
		         	and 1=1
		         </e:if>
		         <e:else condition="${isFloder }">
		         	and 1=2
		         </e:else>
			    union all
				select a.id,
					   a.dim_code,
				       a.dim_category as parent_id,
				       a.CODE_TABLE_DESC as name,
				       '6' as dim_type,
				       '',
				       'T' as dim_attr,
				       '',
				       '2' as data_type
				  from  x_kpi_dim_code a
				 where a.dim_category = '${param.id }'
				   <e:if condition="${param.keywords != null && param.keywords ne '' }">
							and UPPER(a.code_table_desc) like UPPER('%'||'${param.keywords}'||'%')
					</e:if>
				   ) order by dim_ord
			</e:q4l> 
			[<e:forEach items="${kpiCategory.list}" var="item">
					<e:if condition="${index>0}">,</e:if>	
					{
						"id":${item.id},
						"text":"${item.name}",
						<e:if condition="${item.parent_id > 0}">
						"iconCls":"ico10_kpi",
						</e:if>
						"attributes":{"node_type":"DIM","code":"${item.dim_code }","account":"${item.account_type }","kpi_type":"${item.dim_type}","kpi_parent_id":"${item.parent_id}","dim_attr":"${item.dim_attr}","data_type":"${item.data_type }"}
						<e:if condition="${item.parent_id == 0}">
							,"state":"closed"
						</e:if>
					}
			</e:forEach>]
		</e:if>
	</e:case>
	
	<e:case value="dimStore">
		<e:if condition="${param.id==''||param.id==null}">
			[{
				"id":"0",
				"text":"维度",
				"state":"closed",
				"attributes":{"type":"baseDimCategory","dim_parent_id":"-1"}
			}]
		</e:if>
		<e:if condition="${param.id!=null && param.id!=''}">
			<e:q4l var="dimCategory">
				select id,
					   parent_id,
					   name 
				from (
				 select to_char(category_id) as id, category_parent_id as parent_id, category_name as name  from x_kpi_category
				 union all
				 select dim_code as id , decode(dim_category,null,0) as parent_id, CODE_TABLE_DESC from X_KPI_DIM_CODE
				 )
				 where parent_id = '${param.id }' 
				 <e:if condition="${param.data_type != null && param.data_type != ''}">
				 		and data_type in('1','${param.data_type}')
				 </e:if>
				 <e:if condition="${param.isViewBaseKpi == '1' }">
				 	    and data_type != '3'
				 </e:if>
				order by id
			</e:q4l>
			[<e:forEach items="${dimCategory.list}" var="item">
					<e:if condition="${index>0}">,</e:if>	
					{
						"id":${item.id},
						<e:if condition="${item.KPI_TYPE!=0} ">
							<e:q4o var="icon">SELECT * FROM X_KPI_TYPE T WHERE T.TYPE_STATUS='1' AND T.TYPE_CODE=${item.KPI_TYPE}</e:q4o>
							"iconCls":"${icon.ICON }",
						</e:if>
						"text":"${item.name}",
						"attributes":{"data_type":"${item.data_type }","node_type":"KPI","type":"${item.type}","code":"${item.kpi_code }","version":"${item.kpi_version }","account":"${item.account_type }","kpi_type":"${item.kpi_type}","kpi_parent_id":"${item.parent_id}","dim_attr":"${item.dim_attr}"}
						<e:if condition="${item.type == 'compositeKpiRoot' || item.type == 'compositeKpiCategory' || item.type == 'baseKpiRoot' || item.type == 'baseLabelRoot' || item.type == 'baseDimRoot'} ">
							,"state":"closed"
						</e:if>
					}
			</e:forEach>]
		</e:if>
	</e:case>
	<e:case value="createCategory">
		<e:update var="insert">
			begin
			INSERT INTO X_KPI_CATEGORY
			  (CATEGORY_ID,
			   CATEGORY_PARENT_ID,
			   CATEGORY_ISLEAF,
			   CATEGORY_NAME,
			   CATEGORY_DESC,
			   CATEGORY_CREATETIME,
			   CATEGORY_CREATEUSER,
			   CATEGORY_FLAG,
			   CATEGORY_TYPE,
			   CUBE_CODE,
			   ORD,
			   ACCOUNT_TYPE) VALUES
			  (X_KPI_INFO_SEQ.nextval,
			   '${param.category_parent_id}',
			   '${param.c_leaf}',
			   '${param.c_name}',
			   '${param.c_desc}',
			    sysdate,
			   '${UserInfo.USER_ID}',
			   '',
			   '${param.category_type}',
			   '${param.cube_code_s}',
			   '${param.c_ord}',
			   '');
			end;
		</e:update>${insert}
	</e:case>
	<e:case value="validateName">
		<e:q4o var="count">
			select count(0) num from x_kpi_category t where t.category_parent_id='${param.category_id}' and  t.category_name='${param.category_name}' and t.category_flag !='D'
		</e:q4o>${count.num}
	</e:case>
	<e:case value="queryCategoryInfo">
		<e:q4o var="categoryInfo">
			SELECT T.CATEGORY_ID,T.CATEGORY_PARENT_ID,T.CATEGORY_ISLEAF,T.CATEGORY_NAME,T.CATEGORY_DESC,T.ORD,T.CUBE_CODE FROM X_KPI_CATEGORY T WHERE T.CATEGORY_ID = '${param.id }'
		</e:q4o>
		${e:java2json(categoryInfo) }
	</e:case>
	<e:case value="updateCategory">
		<e:update var="update">
			UPDATE X_KPI_CATEGORY T
			   SET T.CATEGORY_NAME = '${param.c_name }', 
			       T.CATEGORY_DESC = '${param.c_desc }', 
			       T.ORD = '${param.c_ord }'
			 WHERE T.CATEGORY_ID = '${param.category_id }'
		</e:update>
		${update }
	</e:case>
	<e:case value="validChildren">
		<e:q4o var="children">
			SELECT COUNT(0) C FROM X_KPI_DIM_CODE T WHERE T.DIM_CATEGORY=${param.id }
		</e:q4o>${children.C }
	</e:case>
	<e:case value="delCategory">
		<e:update var="del">
			UPDATE X_KPI_CATEGORY T SET T.CATEGORY_FLAG='D' WHERE T.CATEGORY_ID = ${param.id }
		</e:update>${del }
	</e:case>
	<e:case value="addDim">
		<e:q4o var="checkE">
			select DIM_CODE from X_KPI_DIM_CODE where DIM_CODE=#dim_code#
		</e:q4o>
		<e:if condition="${checkE.DIM_CODE eq '' || checkE.DIM_CODE == null }" var="isHave">
			<e:update var="insert">
				begin
				insert into X_KPI_DIM_CODE(DIM_CODE,CODE_TABLE,CODE_TABLE_DESC,COLUMN_CODE,COLUMN_DESC,COLUMN_ORD,
				                           COLUMN_PARENT,CONF_TYPE,CONDITION,CREATE_USER,CREATE_DATETIME,DIM_PARENT_CODE,DIM_LEVEL,
				                           DIM_DEFAULT,DIM_RIGHT,DIM_TYPE,DIM_CATEGORY,ID) 
				                    values(#dim_code#,#code_table#,#code_table_desc#,#column_code#,#column_desc#,#column_ord#,
				                          #column_parent#,#conf_type#,#condition#,'${sessionScope.UserInfo.USER_ID}',sysdate,#dim_parent_code#,#dim_level#,
				                          #dim_default#,#dim_right#,#dim_type#,#dim_category#,X_KPI_INFO_SEQ.nextval);
			    end;
			</e:update>${insert }
		</e:if>
		<e:else condition="${isHave }">
			isHave
		</e:else>
	</e:case>
	<e:case value="editDim">
			<e:update var="updateDim">
				update X_KPI_DIM_CODE set 
							CODE_TABLE=#code_table#,
							CODE_TABLE_DESC=#code_table_desc#,
							COLUMN_CODE=#column_code#,
							COLUMN_DESC=#column_desc#,
							COLUMN_ORD=#column_ord#,
							COLUMN_PARENT=#column_parent#,
							CONF_TYPE=#conf_type#,
							CONDITION=#condition#,
							UPDATE_USER='${sessionScope.UserInfo.USER_ID}',
  							UPDATE_DATETIME=sysdate,
  							DIM_PARENT_CODE=#dim_parent_code#,
  							DIM_LEVEL=#dim_level#,
  							DIM_DEFAULT=#dim_default#,
  							DIM_RIGHT=#dim_right#,
  							DIM_TYPE=#dim_type#,
  							DIM_CATEGORY=#dim_category#
  				where DIM_CODE =#dim_code#
			</e:update>${updateDim}
	</e:case>
	<e:case value="delDim">
		<e:update var="deleteDim">
			begin
				delete from X_KPI_DIM_CODE where DIM_CODE =#dim_code#;
			end;
		</e:update>${deleteDim}
	</e:case>
</e:switch>