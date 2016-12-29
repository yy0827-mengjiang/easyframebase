<%@ tag body-content="scriptless" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="id" required="true" %>                                               	<e:description>表格id</e:description>
<%@ attribute name="url" required="true" %>                                              	<e:description>数据路径</e:description>
<%@ attribute name="width" required="true" %>                                              	<e:description>表格宽，值可以是数字或者'auto'，auto是自动宽</e:description>
<%@ attribute name="height" required="true" %>                                              <e:description>表格高，值可以是数字或者'auto'，auto是自动高</e:description>


<%@ attribute name="pager" required="false" %>                                             	<e:description>是否分页</e:description>
<%@ attribute name="pageSize" required="false" %>                                           <e:description>每页行数</e:description>
<%@ attribute name="pageGroup" required="false" %>                                          <e:description>显示几个按钮</e:description>
<%@ attribute name="select" required="false" %>                                             <e:description>选中单元格（可选值：row,cell,column）</e:description>
<%@ attribute name="clickCell" required="false" %>                                        	<e:description>点击单元格事件（可选值：row,cell,column）</e:description>
<%@ attribute name="download" required="false" %>                          	        		<e:description>导出文件的名称，不为空时下载</e:description>
<%@ attribute name="frozenColumn" required="false" %>                          	        	<e:description>锁定列，int型，锁定最左侧几列</e:description>
<%@ attribute name="reloadUrl" required="false" %>                          	        	<e:description>重新加载</e:description>
<jsp:doBody var="bodyRes" />

<div id="${id}"></div>
<e:if condition="${pager=='true'}">
<div id="paging_here"></div>
</e:if>

<e:set var="frozenColumn" value=""/>
<e:if var="fcVar" condition="${frozenColumn!=null && frozenColumn!=''}">
	<e:set var="frozenColumn" value="${frozenColumn}"/>
</e:if>
<e:invoke var="columns" objectClass="cn.com.easy.taglib.util.TagHelper" method="getColumnJson">
	<e:param value="<table>${bodyRes}</table>"/>
	<e:param value="${frozenColumn}"/>
</e:invoke>

<script type="text/javascript">
webix.Touch.limit(true);
var grida_${id};
function datagridReload( wid, url ){
	var dg = eval('grida_'+wid);
	$$( dg ).clearAll();
	$$( dg ).load(url);
}
var options_${id} = {
	view : 'datatable',
	container : '${id}',
	url : (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'),
	columns : ${columns},
	<e:if var="autoTmp" condition="${width=='auto'}">
		autowidth:true,
	</e:if>
	<e:else condition="${autoTmp}">
		width : ${width},
	</e:else>
	<e:if var="autoTmp" condition="${height=='auto'}">
		autoheight:true,
	</e:if>
	<e:else condition="${autoTmp}">
		height : ${height},
	</e:else>
	<e:if condition="${pager=='true'}">
		pager : {
			template : "{common.first()} {common.prev()} {common.pages()} {common.next()} {common.last()}",
			container : "paging_here",
			size : <e:if var="tmp" condition="${pageSize!=null && pageSize!=''}">${pageSize}</e:if><e:else condition="${tmp}">10</e:else>,
			group : <e:if var="tmp" condition="${pageGroup!=null && pageGroup!=''}">${pageGroup}</e:if><e:else condition="${tmp}">5</e:else>
		},
	</e:if>
	<e:if condition="${select!=null && select!=''}">
		select : '${select}',
	</e:if>
	<e:if condition="${frozenColumn!=null && frozenColumn!=''}">
		leftSplit : ${frozenColumn},
	</e:if>
	"export" : true,
	on : {
		<e:if condition="${ clickCell!=null }">
			"onItemClick" : '${clickCell}'
		</e:if>
	}
};
grida_${id} = new webix.ui( options_${id} );
</script>