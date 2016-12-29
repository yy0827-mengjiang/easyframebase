<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:if condition="${AcLog != null && AcLog == '1'}">

<e:q4l var="logList">
SELECT USER_ID, to_char(VIEW_TIME,'yyyy-mm-dd hh24:mi:ss') VIEW_TIME FROM SYS_REPORT_VIEW_LOG WHERE SYSDATE - VIEW_TIME < 7 AND MENU_ID IN (SELECT MENU_ID FROM SYS_REPORT_MENU_REL WHERE REPORT_ID = '${param.reportid}') ORDER BY VIEW_TIME DESC
</e:q4l>
	<div class="HBcomments">
        <h3>访问记录
            <ul class="paging">
            	<li id="prevLOG" class="prev"><a href="#this">上一页</a></li>
                <li><span class="num"><span id="current_pageLOG" class="current_page">1</span><span style="padding:0 3px;">/</span><span id="totalLOG" class="total"></span></span></li>
            	<li id="nextLOG" class="next"><a href="#this">下一页</a></li>
            </ul>
        </h3>
        <ul id="LOGUlList" class="recordBox">
        	<e:forEach items="${logList.list}" var="log">
        	<li><strong>${log.USER_ID}</strong>${log.VIEW_TIME}</li>
        	</e:forEach>
        </ul>
    </div>
<script>
$(document).ready(function(){
	$("#LOGUlList li:gt(9)").hide();//初始化，前面5条数据显示，其他的数据隐藏。
	var total_qLOG=$("#LOGUlList>li").index()+1;//总数据
	var current_pageLOG=10;//每页显示的数据
	var current_numLOG=1;//当前页数
	var total_pageLOG = Math.ceil(total_qLOG/current_pageLOG);//总页数  
	var nextLOG=$(".nextLOG");//下一页
	var prevLOG=$(".prevLOG");//上一页
	$("#totalLOG").text(total_pageLOG);//显示总页数
	$("#current_pageLOG").text(current_numLOG);//当前的页数
	
    //下一页
    $("#nextLOG").click(function(){
        if(current_numLOG>=total_pageLOG){
        	return false;//如果大于总页数就禁用下一页
        }else{
            $("#current_pageLOG").text(++current_numLOG);//点击下一页的时候当前页数的值就加1
            $.each($('#LOGUlList li'),function(index,item){
                var start = current_pageLOG * (current_numLOG-1);//起始范围
                var end = current_pageLOG * current_numLOG;//结束范围
                if(index >= start && index < end){//如果索引值是在start和end之间的元素就显示，否则就隐
                    $(this).show();
                }else {
                    $(this).hide(); 
                }
            });
        }
    });
    //上一页方法
    $("#prevLOG").click(function(){
	    if(current_numLOG==1){
	        return false;
	    }else{
	        $("#current_pageLOG").text(--current_numLOG);
	        $.each($('#LOGUlList li'),function(index,item){
	            var start = current_pageLOG * (current_numLOG-1);//起始范围
	            var end = current_pageLOG * current_numLOG;//结束范围
	            if(index >= start && index < end){//如果索引值是在start和end之间的元素就显示，否则就隐藏
	                $(this).show();
	            }else {
	                $(this).hide(); 
	            }
	        });     
	    }
	});
});
function sub(){
		$.ajax({
			type : "post",
			url : '<e:url value="/pages/ebuilder/usepage/common/CommonReportViewLogAction.jsp?eaction=addViewLog"/>',  
			data : {"menuid" : "802"}, 
			async : false,
			success : function(returnStr){
				if($.trim(returnStr) == '1'){
					$.messager.alert('信息提示', '添加成功', 'info');
					$('#viewLogTable').datagrid("load",$("#viewLogTable").datagrid("options").queryParams);
				}else{
					$.messager.alert('信息提示', '添加失败', 'error');
				}
			}
		});
}
</script>
</e:if>

