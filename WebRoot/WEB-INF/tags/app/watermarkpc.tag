<%@ tag body-content="empty" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<!--//属性  -->
<%@ attribute name="id" required="false"%>       <e:description>id</e:description>
<%@ attribute name="content" required="false"%>  <e:description>部门，姓名，时间，联系电话</e:description>
<%@ attribute name="isdata" required="false"%>   <e:description>是否显示日期</e:description>
<%@ attribute name="density" required="false"%>   <e:description>水印密集程度</e:description>
<e:set var="TmpContent" value="" />
<% 
	String isShotCon = "false";
	if(content!=null){
		int len = content.length();
		if(len<4){
			isShotCon = "true";
		}
	}
%>
<e:set var="isShotCon" value="<%=isShotCon %>"></e:set>
<e:switch value="${density}">
	<e:case value="1">
		<e:set var="marginBottom" value="140px"></e:set>
		<e:set var="margin" value="50px"></e:set>
	</e:case>
	<e:case value="2">
		<e:set var="marginBottom" value="80px"></e:set>
		<e:set var="margin" value="10px"></e:set>
	</e:case>
	<e:case value="3">
		<e:set var="marginBottom" value="20px"></e:set>
		<e:if condition="${isShotCon=='true'}" var="margintest">
			<e:set var="margin" value="0px"></e:set>
		</e:if>
		<e:if condition="${!margintest}">
			<e:set var="margin" value="-30px"></e:set>
		</e:if>
	</e:case>
</e:switch>
<e:if condition="${content !=null && content ne ''}" var = "waterelse">
	<e:set var="TmpContent" value="${content}" />
</e:if>
<e:else condition="${waterelse}">
	<e:set var="TmpContent" value="${sessionScope.USER_NAME}" />
	<e:set var="DEPTID">${sessionScope.DEPT_CODE}</e:set>
	<e:if condition="${DEPTID == null || DEPTID eq ''}">
		<e:set var="DEPTID">${sessionScope.UserInfo.DEPT_CODE}</e:set>
	</e:if>
	<e:q4o var="DeptDesc">
		SELECT DEPART_CODE, DEPART_DESC, PARENT_CODE FROM E_DEPARTMENT WHERE DEPART_CODE = '${DEPTID}'
	</e:q4o>
	<e:q4o var="DeptDescCount">
		SELECT nvl(count(1), 0) cnt FROM E_DEPARTMENT WHERE DEPART_CODE = '${DEPTID}'
	</e:q4o>
	<e:if condition="${DeptDescCount.cnt eq '0'}" var ="deptelse">
		<e:set var="TmpContent">未知部门-${TmpContent}</e:set>
	</e:if>
	<e:else condition="${deptelse}">
		<e:set var="TmpContent">${DeptDesc.DEPART_DESC}-${TmpContent}</e:set>
	</e:else>
	
</e:else>
<e:if condition="${isdata !=null && isdata eq 'true'}">
	<e:q4o var="dateDesc">
		SELECT to_char(sysdate,'yyyy/mm/dd hh24:mi:ss') code FROM dual
	</e:q4o>
	<e:set var="TmpContent">${TmpContent}-${dateDesc.code}</e:set>
</e:if>
 <style type="text/css" media="screen">
        .cover {
            position:absolute;
            left:0;
            top:0;
            z-index:999999999999999;
            margin-right:0px;
            margin-left:0px;
            margin-top:5px;
            margin-bottom:${marginBottom};
            color:#fff;
            color:#ccc\0;
            display:block;
            padding:2px 1px;
            font-family:'宋体';
            font-size:16px;
            font-weight:bold;
            white-space:nowrap;
            text-shadow: 1px 0 0 #eee;
            transform:rotate(45deg);
            -ms-transform:rotate(45deg);
            -moz-transform:rotate(45deg);
            -webkit-transform:rotate(45deg);
            -o-transform:rotate(45deg);
            -moz-opacity:0.3; opacity:0.3;
            -ms-filter: "progid:DXImageTransform.Microsoft.Matrix(M11=0.7071067811865474, M12=-0.7071067811865477, M21=0.7071067811865477, M22=0.7071067811865474, SizingMethod='auto expand')";
        }
        .cover-Blink-area{ position:absolute;text-align: center;left:0;top:0;width:100%;height:100%;display:block;z-index:999999999999999; pointer-events: none;overflow: hidden;}
		.cover-Blink{
			display:inline-block;
			margin-right:${margin};
            margin-left:${margin};
            margin-top:${marginBottom};
            margin-bottom:${marginBottom};
            color:rgba(255,255,255,.5);
            padding:2px 1px;
            font-family:'宋体';
            font-size:16px;
            font-weight:bold;
            white-space:nowrap;
            text-shadow: 1px 0 0 rgba(0,0,0,.2);
            transform:rotate(45deg);
            -ms-transform:rotate(45deg);
            -moz-transform:rotate(45deg);
            -webkit-transform:rotate(45deg);
            -o-transform:rotate(45deg);
            
		}
    </style>
    
<script type="text/javascript">
	$(function(){
		waterMark$();
	});
	function waterMark$(){
		if(navigator.appName == "Microsoft Internet Explorer"&& navigator.appVersion.match(/11./i)!="11."){
			$("p[name='p1$']").remove();
			var winwidth$ = document.body.scrollWidth-17;
			var winheight$ = document.body.scrollHeight;
		    $("body").append("<p id='waterSum_11' name='p1$' class='cover_through cover js-click-to-alert'>${TmpContent}</p>");
		    var fleft = Number($('#waterSum_11').css("margin-left").substring(0,$('#waterSum_11').css("margin-left").indexOf('p')));
		    var ftop = Number($('#waterSum_11').css("margin-top").substring(0,$('#waterSum_11').css("margin-top").indexOf('p')));
		    var perWidth = $("#waterSum_11").width();
		    var perHeight = Number('${marginBottom}'.substring(0,'${marginBottom}'.indexOf('p')))+100;
			var lines = parseInt(winwidth$/(perWidth+fleft));
			var rows = Math.round(winheight$/(perHeight+ftop));
		    var totalPWidth = perWidth*lines;
		    var totalSpace = winwidth$-totalPWidth;
		    var perSpace = parseInt(totalSpace/(lines+1));
			$('#waterSum_11').css("margin-left",perSpace);
			for(var i=1;i<=rows;i++) {
				for(var j=1;j<=lines;j++){
					if(i==1){
						if(j<=lines-1){
							var p = "<p id='waterSum_"+i+""+(j+1)+"' name='p1$' class='cover_through cover js-click-to-alert'>${TmpContent}</p>";
							var ileft = $('#waterSum_'+i+''+j).css("margin-left").substring(0,$('#waterSum_'+i+''+j).css("margin-left").indexOf('p'));
							var itop = $('#waterSum_11').css("margin-top").substring(0,$('#waterSum_11').css("margin-top").indexOf('p'));
							$("body").append(p);
							$('#waterSum_'+i+''+(j+1)).css("margin-left",Number(ileft)+Number(perWidth)+perSpace);
							$('#waterSum_'+i+''+(j+1)).css('margin-top',itop);
						}
					}else{
						var p = "<p id='waterSum_"+i+""+j+"' name='p1$' class='cover_through cover js-click-to-alert'>${TmpContent}</p>";
						var ileft = $('#waterSum_'+(i-1)+''+j).css("margin-left").substring(0,$('#waterSum_'+(i-1)+''+j).css("margin-left").indexOf('p'));
						var itop =  $('#waterSum_'+(i-1)+''+j).css("margin-top").substring(0,$('#waterSum_'+(i-1)+''+j).css("margin-top").indexOf('p'));
						$("body").append(p);
						$('#waterSum_'+i+''+j).css("margin-left",Number(ileft));
						$('#waterSum_'+i+''+j).css('margin-top',Number(itop)+Number(perHeight));
					}
				}
			}
			passThrough();
		}else{
			waterMarkNotIe$();
		}
	}
	function waterMarkNotIe$(){
		var winwidth$ = document.body.clientWidth;
		var winheight$ = document.body.scrollHeight;
		var waterSum$ = 100;
		var oldleft$=0;
		var maxI$=0;
		var k$=0;
		$("body").append("<div class='cover-Blink-area'> </div>");
		$('.cover-Blink-area').css('height',winheight$-30);
		for( var i=1;i<=waterSum$;i++) {
		    $(".cover-Blink-area").append("<p id='waterSum_" +i+"' class='cover_through cover-Blink js-click-to-alert'>${TmpContent}</p>");
		    var left = Number(document.getElementById("waterSum_" +i).offsetLeft);
		    if(left>oldleft$) {
			    oldleft$ = left;
			    maxI$ = i;
		    }
		    if (left<oldleft$&&k$==0){
			   	var top = $("#waterSum_1").css("margin-top").substring(0,$("#waterSum_1").css("margin-top").indexOf('p'));
			    var bottom = $("#waterSum_1").css("margin-bottom").substring(0,$("#waterSum_1").css("margin-bottom").indexOf('p'));
			    var pHeight = $("#waterSum_1").height();
			    var totalHeight = Number(top)+Number(pHeight)+Number(bottom);
			    var Hnum = Math.round(winheight$/(totalHeight/1.3));
			    waterSum$ = Hnum*maxI$;
			    k$++;
		    }
		}
	}
	window.onresize = function(){
		waterMark$();
	}
	function passThrough() {
		$(".cover").mouseenter(function(){
			$(this).stop(true).fadeOut().delay(1500).fadeIn(50);
		});
	}
</script>
