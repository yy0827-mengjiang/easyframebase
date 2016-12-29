<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="label" required="true" %>                                              <e:description>维度名称</e:description>
<%@ attribute name="url" required="true" %>                                              <e:description>维度名称</e:description>
<%@ attribute name="group" required="false" %>                                             <e:description>维度组名</e:description>
<e:if condition="${label=='|'}">
	<div class="menu-sep"></div>
</e:if>
<e:if condition="${group==null}">
	<e:set var="group" value="easy_group" />
</e:if>
<e:if condition="${level==null}">
	<e:set var="level" value="0" />
</e:if>
 
<div id="link_id_template" data-field="" data-type="easyMenuItem_id_template" data-group="${group}" data-level="${level}" iconCls="icon-link-menu" onclick="drillCustomPage_id_template('${label}','${url}')" >${label}</div>
 