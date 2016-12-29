<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="label" required="true" %>                                              <e:description>维度名称</e:description>
<%@ attribute name="field" required="true" %>                                              <e:description>维度类型</e:description>
<%@ attribute name="group" required="false" %>                                             <e:description>维度组名</e:description>
<%@ attribute name="level" required="false" %>                                             <e:description>维度级别</e:description>
<%@ attribute name="showChart" required="false" %>                                         <e:description>是否显示图表下钻菜单</e:description>

<e:if condition="${label=='|'}">
	<div class="menu-sep"></div>
</e:if>
<e:if condition="${group==null}">
	<e:set var="group" value="easy_group" />
</e:if>
<e:if condition="${level==null}">
	<e:set var="level" value="0" />
</e:if>
<e:if condition="${LayyerExport!='true'}">
	<div id="${field}_id_template" data-field="${field}" data-type="easyMenuItem_id_template" data-group="${group}" data-level="${level}" iconCls="icon-cube-blue" onclick="reload_id_template('${field}')" >
	            <span>${label}</span>
	             <e:if condition="${showChart}">
		             <div style="width:150px;">
						<div onclick="drillChart_id_template('${field}','column','${label}柱图展示')" iconCls="icon-bar-menu">柱图展示</div>
					    <div onclick="drillChart_id_template('${field}','line','${label}线图展示')" iconCls="icon-line-menu">线图展示</div>
					 </div>
				</e:if>
   </div>
</e:if>
<e:if condition="${LayyerExport=='true'}">
	<div id="${field}_id_template" data-field="${field}" data-type="easyMenuItem_id_template" data-group="${group}" data-level="${level}" iconCls="icon-cube-blue"><span onclick="reload_id_template('${field}')" >${label}</span><span style="padding-left:10px;"></span><img src="<e:url value="/resources/easyResources/theme/telecom/images/icons/excel3.png"/>" border="0" width="14" height="16" onclick="downExcel_exprot_field('${field}','excel')"/></span><span style="padding-left:10px;"></span><img src="<e:url value="/resources/easyResources/theme/telecom/images/icons/pdf3.png"/>" border="0" width="14" height="16" style="padding-top:2px;"onclick="downExcel_exprot_field('${field}','pdf')"/></span>
	     <e:if condition="${showChart}">
	            <div style="width:150px;">
					<div onclick="drillChart_id_template('${field}','column','${label}柱图展示')" iconCls="icon-bar-menu">柱图展示</div>
					<div onclick="drillChart_id_template('${field}','line','${label}线图展示')" iconCls="icon-line-menu">线图展示</div>
				</div>
		 </e:if>
	</div>
</e:if>