<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
	String Ip = request.getLocalAddr();
	request.setAttribute("ip",Ip);
%>
<e:switch value="${param.eaction }">
	<e:case value="kpitree">
		<e:if condition="${param.id==null||param.id==''}">
			[{
				"id":"0",
				"text":"指标库",
				"state":"closed",
				"attributes":{"type":"compositeKpiCategory","kpi_parent_id":"-1"}
			}]
		</e:if>
		<e:if condition="${param.id!=null && param.id!=''}">
			<e:q4l var="kpiCategory" sql="kpi.view.kpitree"/>
			[<e:forEach items="${kpiCategory.list}" var="item">
					<e:if condition="${index>0}">,</e:if>	
					{
						"id":${item.id},
						"text":"${item.name}",
						"attributes":{"data_type":"${item.data_type }","node_type":"KPI","type":"${item.type}","code":"${item.kpi_code }","version":"${item.kpi_version }","account":"${item.account_type }","kpi_type":"${item.kpi_type}","kpi_parent_id":"${item.parent_id}","dim_attr":"${item.dim_attr}"}
						<e:if condition="${item.type == 'compositeKpiRoot' || item.type == 'compositeKpiCategory' || item.type == 'baseKpiRoot' || item.type == 'baseLabelRoot' || item.type == 'baseDimRoot'} ">
							,"state":"closed"
						</e:if>
					}
			</e:forEach>]
		</e:if>
	</e:case>

	<e:case value="querynewLoadTree">
		<e:if condition="${param.id==null||param.id==''}">
			[{
				"id":"0",
				"text":"指标库",
				"state":"closed",
				"attributes":{"type":"compositeKpiCategory","kpi_parent_id":"-1"}
			}]
		</e:if>
		<e:if condition="${param.id!=null && param.id!=''}">
			<e:q4l var="kpiCategory" sql="kpi.view.kpiCategory"/>
			[<e:forEach items="${kpiCategory.list}" var="item">
					<e:if condition="${index>0}">,</e:if>	
					{
						"id":${item.id},
						<e:if condition="${item.kpi_type!=0} ">
							<e:q4o var="icon">SELECT ICON AS "ICON" FROM X_KPI_TYPE T WHERE T.TYPE_STATUS='1' AND CAST(T.TYPE_CODE AS INTEGER)=${item.kpi_type}</e:q4o>
							"iconCls":"${icon.ICON }",
						</e:if>
						"text":"${item.name}",
						"attributes":{"data_type":"${item.data_type }","node_type":"KPI","type":"${item.type}","code":"${item.kpi_code }","version":"${item.kpi_version }","account":"${item.account_type }","kpi_type":"${item.kpi_type}","kpi_parent_id":"${item.parent_id}","dim_attr":"${item.dim_attr}","kpi_ord":"${item.ord}"}
						<e:if condition="${item.type == 'compositeKpiRoot' || item.type == 'compositeKpiCategory' || item.type == 'baseKpiRoot' || item.type == 'baseLabelRoot' || item.type == 'baseDimRoot'} ">
							,"state":"closed"
						</e:if>
					}
			</e:forEach>]
		</e:if>
	</e:case>
	<e:case value="kpiManagerListTree">
		<e:if condition="${param.id==null||param.id==''}">
			[{
				"id":"0",
				"text":"指标库",
				"state":"closed",
				"attributes":{"parent_id":"-1"}
			}]
		</e:if>
		<e:if condition="${param.id!=null && param.id!=''}">
			<e:q4l var="kpiCategory">
					 select t.category_id as id,
					        t.category_parent_id as parent_id,
					        category_name as name,
					        (select count(1)
					          from x_kpi_category
					         where category_parent_id = t.category_id) cnt
			  			from x_kpi_category t 
				  	   where t.category_parent_id = '${param.id }' 
					  	 and t.cube_code='${param.cube_code}' 
					order by t.ord
			</e:q4l> 
			[<e:forEach items="${kpiCategory.list}" var="item" >
					<e:if condition="${index>0}">,</e:if>	
					{
						"id":${item.id},
						"text":"${item.name}",
						"attributes":{"parent_id":"${item.parent_id}"}
						<e:if condition="${item.cnt> 0} ">
							,"state":"closed"
						</e:if>
					}
			</e:forEach>]
		</e:if>
	</e:case>
	<e:case value="loadBaseTree">
		<e:if condition="${param.id==null||param.id==''}">
			[{
				"id":"0",
				"text":"指标库",
				"state":"closed",
				"attributes":{"type":"kpiResource"}
			}]
			<e:q4o var="baseKpi">
				select * from view_kpi t where t.kpi_type='4' and t.account_type='${param.account_type }' and t.parent_id='0'
			</e:q4o>
			[
				{	
					
					"id":"${baseKpi.ID }",
					"text":"${baseKpi.NAME }",
					"state":"closed",
					"attributes":{"type":"dimResource","kpi_type": "4"}
				}
			]
		</e:if>
		<e:if condition="${param.id!=null&&param.id!=''}">
			<e:q4l var="kpiCategory">
				select id,
					   parent_id,
					   name,
					   kpi_code,
					   kpi_version,
					   kpi_type,
					   account_type,
					   type,
					   dim_attr
				from view_kpi where parent_id = '${param.id }' and (account_type='${param.account_type}' or account_type is null )  order by id
			</e:q4l> 
			[<e:forEach items="${kpiCategory.list}" var="item">
					<e:if condition="${index>0}">,</e:if>	
					{
						"id":${item.id},
						"text":"${item.name}",
						"attributes":{"type":"${item.type}","code":"${item.kpi_code }","version":"${item.kpi_version }","account":"${item.account_type }","kpi_type":"${item.kpi_type}","kpi_parent_id":"${item.parent_id}","dim_attr":"${item.dim_attr}"}
						<e:if condition="${item.type == 'baseKpiRoot' || item.type == 'baseLabelRoot'}">
							,"state":"closed"
						</e:if>
					}
			</e:forEach>]
		</e:if>
	</e:case>
	<e:case value="baseDimStore">
		<e:if condition="${param.id==''||param.id==null}">
			[{
				"id":"0",
				"text":"维度",
				"state":"closed",
				"attributes":{"type":"compositeKpiCategory","kpi_parent_id":"-1"}
			}]
		</e:if>
		<e:if condition="${param.id!=null&&param.id!=''}">
			<e:q4l var="kpiCategory" sql="kpi.view.dimCategory"/>
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
	<e:case value="baseAttrStore">
		<e:if condition="${param.id==''||param.id==null}">
			[{
				"id":"0",
				"text":"属性",
				"state":"closed",
				"attributes":{"type":"compositeKpiCategory","kpi_parent_id":"-1"}
			}]
		</e:if>
		<e:if condition="${param.id!=null && param.id!=''}">
			<e:q4l var="kpiCategory" sql="kpi.view.attrCategory"/> 
			[<e:forEach items="${kpiCategory.list}" var="item">
					<e:if condition="${index>0}">,</e:if>	
					{
						"id":${item.id},
						"text":"${item.name}",
						"iconCls":"ico11_kpi",
						"attributes":{"node_type":"ATTR","code":"${item.dim_code }","account":"${item.account_type }","kpi_type":"${item.dim_type}","kpi_parent_id":"${item.parent_id}","dim_attr":"${item.dim_attr}"}
					}
			</e:forEach>]
		</e:if>
	</e:case>
	<e:case value="kpiList">
		<e:if condition="${param.id !=null && param.id !=''}">
			<c:tablequery>
				SELECT T.KPI_KEY V0,T.KPI_NAME V1,T.KPI_CATEGORY V2,C.CATEGORY_NAME V9,T.KPI_NUIT V3,T.KPI_VERSION V4,DECODE(KPI_ISCURR,'1','是','0','否') V5,DECODE(KPI_FLAG,'I','新增','U','修改','D','删除') V6,DECODE(KPI_STATUS,'0','待发布','1','待审核','2','审核通过','3','审核未通过','4','编辑模式')V7,KPI_CODE V8,T.KPI_ISCURR V10,T.KPI_CALIBER V11,U.USER_NAME V12,TO_CHAR(T.CREATE_DATETIME,'YYYY-MM-DD') V13, T.KPI_STATUS V14 FROM X_KPI_INFO T, X_KPI_CATEGORY C,E_USER U WHERE 1=1
					AND T.CREATE_USER=U.USER_ID
					AND T.KPI_CATEGORY=C.CATEGORY_ID
					AND T.KPI_ISCURR='1' AND T.KPI_FLAG!='D'
					AND T.KPI_CATEGORY IN (SELECT CATEGORY_ID FROM X_KPI_CATEGORY START WITH CATEGORY_ID = '${param.id}' CONNECT BY PRIOR CATEGORY_ID = CATEGORY_PARENT_ID)
					<e:if condition="${param.name!=''&&param.name!=null}">
						AND UPPER(T.KPI_NAME) LIKE UPPER('%${param.name}%')
					</e:if>
					<e:if condition="${null!=param.status&&''!=param.status}">
						AND T.KPI_STATUS='${param.status}'
					</e:if>
					ORDER BY T.CREATE_DATETIME DESC
			</c:tablequery>
		</e:if>
	</e:case>
	<e:case value="createCategory">
		<e:update var="insert" sql="kpi.view.insertCategory"/>${insert}
	</e:case>
	<e:case value="validateName">
		<e:q4o var="count" sql="kpi.view.countCategory" />${count.num}
	</e:case>
	<e:case value="beforeEditCategory">
		<e:q4o var="bec" sql="kpi.view.becCategory"/>${e:java2json(bec)}
	</e:case>
	<e:case value="editCategory">
		<e:update var="ec" sql="kpi.view.editCategory"/>${ec}
	</e:case>
	<e:case value="beforeDeleteCategory">
		<e:q4o var="bdc" sql="kpi.view.beforeDeleteCategory"/>${bdc.num}
	</e:case>
	<e:case value="deleteCategory">
		<e:update var="dc" sql="kpi.view.deleteCategory"/>${dc}
	</e:case>
	<e:case value="vaildDelKpi">
		<e:q4l var="kpiSource" sql="kpi.view.vaildDelKpi"/>${e:java2json(kpiSource.list) }
	</e:case>
	<e:case value="deleteKpi">
		<e:update var="delete" transaction="true" sql="kpi.view.deleteKpi"/>${delete}
	</e:case>
	<e:case value="editKpiOrder">
	    <e:update var="uptOrder" sql="kpi.view.editKpiOrder"/>${uptOrder}
	</e:case>
	<e:case value="editKpiCategory">
		<e:update var="uptCategory" transaction="true" sql="kpi.view.uptKpiCategory"/>${uptCategory}
	</e:case>
	<e:case value="newLoadTree">
		<e:if condition="${param.id==null||param.id==''}">
			[{
				"id":"0",
				"text":"指标库",
				"state":"closed",
				"attributes":{"type":"compositeKpiCategory","kpi_parent_id":"-1"}
			}]
		</e:if>
		<e:if condition="${param.id!=null && param.id!=''}">
			<e:q4l var="kpiCategory">
				select id,
					   parent_id,
					   name,
					   kpi_code,
					   kpi_version,
					   kpi_type,
					   account_type,
					   type,
					   dim_attr,
					   data_type 
				from view_kpi where parent_id = '${param.id }' and cube_code='${param.cube_code}' 
				 <e:if condition="${param.data_type != null && param.data_type != ''}">
				 		and data_type in('1','${param.data_type}')
				 </e:if>
				 <e:if condition="${param.isViewBaseKpi == '1' }">
				 	    and data_type != '3'
				 </e:if>
				order by id
			</e:q4l> 
			[<e:forEach items="${kpiCategory.list}" var="item">
					<e:if condition="${index>0}">,</e:if>	
					{
						"id":${item.id},
						"text":"${item.name}",
						"attributes":{"data_type":"${item.data_type }","node_type":"KPI","type":"${item.type}","code":"${item.kpi_code }","version":"${item.kpi_version }","account":"${item.account_type }","kpi_type":"${item.kpi_type}","kpi_parent_id":"${item.parent_id}","dim_attr":"${item.dim_attr}"}
						<e:if condition="${item.type == 'compositeKpiRoot' || item.type == 'compositeKpiCategory' || item.type == 'baseKpiRoot' || item.type == 'baseLabelRoot' || item.type == 'baseDimRoot'} ">
							,"state":"closed"
						</e:if>
					}
			</e:forEach>]
		</e:if>
	</e:case>
</e:switch>