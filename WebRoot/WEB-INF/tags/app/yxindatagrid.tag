<%@ tag body-content="scriptless" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="id" required="true" %>                                               	<e:description>表格id</e:description>
<%@ attribute name="url" required="true" %>                                              	<e:description>数据路径</e:description>
<%@ attribute name="width" required="true" %>                                              	<e:description>表格宽，值是数字</e:description>
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
</style>
<div id="${id}" style="width:${width}px;margin-left:auto;margin-right:auto;"></div>
<e:if condition="${pager=='true'}">
<div id="paging_here"></div>
</e:if>

<e:if var="fc" condition="${frozenColumn!=null && frozenColumn!=''}">
	<e:set var="frozenColumn" value="${frozenColumn}"/>
</e:if>
<e:else condition="${fc}">
	<e:set var="frozenColumn" value=""/>
</e:else>

<e:invoke var="columns" objectClass="cn.com.easy.taglib.util.TagHelper" method="getColumnJson">
	<e:param value="<table>${bodyRes}</table>"/>
	<e:param value="${frozenColumn}"/>
</e:invoke>

<script type="text/javascript"><!--
webix.Touch.disable();//webix.Touch.limit(true);
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
	width:${width},
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

if (window.orientation == 0 || window.orientation == 180) {
	var obj = document.getElementById('${id}');
	var divw = 0;
	grida_${id}.eachColumn( 
	    function (col){ 
	    	var colJson = grida_${id}.getColumnConfig( col );
	        divw += colJson.width;
	    }
	)
	//var divw = ${width};//obj.offsetWidth;
	var sw = window.screen.width;
	var sw2 = window.innerWidth;
	sw = sw<=sw2?sw:sw2;
	if(divw>sw){
		obj.style.zoom=sw/divw;
	}
	//else if(divw<sw){
		//发大
		//obj.style.zoom=sw/divw;
	//}
}

webix.attachEvent("onRotate", function(orientation){
	if(orientation){
		var obj1 = document.getElementById('${id}');
		obj1.style.zoom=1;
	}else{
		setTimeout(function() {
		var divw = 0;
		
		grida_${id}.eachColumn( 
		    function (col){ 
		    	var colJson = grida_${id}.getColumnConfig( col );
		        divw += colJson.width;
		    }
		)
		var w_${id} = window.screen.width;
		var w_${id}2 = window.innerWidth;
		 w_${id} =  w_${id}<=w_${id}2?w_${id}:w_${id}2;
		if(divw>w_${id}){
			var obj2 = document.getElementById('${id}');
			obj2.style.zoom=w_${id}/divw;
		}
		},500);
	}
});
--></script>