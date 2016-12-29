<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<% 
String companyname=(request.getParameter("proname")==null || request.getParameter("proname").equals("") || request.getParameter("proname").equalsIgnoreCase("NULL"))?"":(new String((request.getParameter("proname")).getBytes("ISO-8859-1"),"UTF-8"));
request.setAttribute("proname",companyname);
%>
<!-- 选取的省份名称 -->
<e:if condition="${proname != '' && proname != null }" var="proMr">
	<e:set var="proname">${proname }</e:set>
</e:if>
<e:else condition="${proMr}">
	<e:if condition="${sessionScope.UserInfo.AREA_NO == '' || sessionScope.UserInfo.AREA_NO eq null }" var="qg">
		<e:set var="proname">全国</e:set>
	</e:if>
</e:else>
<!-- 省份、地市级联 -->
<e:if condition="${sessionScope.UserInfo.AREA_NO == '' || sessionScope.UserInfo.AREA_NO eq null }" var="qg">
	<e:q4l var="areaL">
		SELECT a."AREA_NAME" ,a."AREA_NO" FROM "DIM_AREA_NO" a order by "ORD"
	</e:q4l>
	<e:forEach items="${areaL.list}" var="item">
		<e:if condition="${item.AREA_NAME == '内蒙古' } ">
			<e:set var="area_no">${item.AREA_NO }</e:set>
		</e:if>
	</e:forEach>	
</e:if>
<e:else condition="${qg}">
	<e:q4l var="areaL">
		SELECT a."AREA_NAME" ,a."AREA_NO" FROM "DIM_AREA_NO" a 
		WHERE 1=1
		AND "AREA_NO" = '${sessionScope.UserInfo.AREA_NO }'
	</e:q4l>
	<e:set var="area_no">${sessionScope.UserInfo.AREA_NO }</e:set>
</e:else>
<e:if condition="${param.area != '' && param.area != null }">
	<e:set var="area_no">${param.area }</e:set>
</e:if>
<!-- 地市人员 -->
<e:if condition="${sessionScope.UserInfo.CITY_NO != '' && sessionScope.UserInfo.CITY_NO != null }" var="cityMan">
	<e:q4o var="Onecity">
		SELECT a."CITY_NO",a."CITY_NAME",a."AREA_NO" 
		FROM "DIM_CITY_NO" a
		where 1=1		
	 	and a."AREA_NO"='${area_no}'
	 	and a."CITY_NO"='${sessionScope.UserInfo.CITY_NO}'		
	</e:q4o>
	<e:set var="city_no">${sessionScope.UserInfo.CITY_NO}</e:set>
</e:if>
<e:else condition="${cityMan}">
	<e:set var="city_no">qxz</e:set>
</e:else>
<e:if condition="${param.city != '' && param.city != null }">
	<e:set var="city_no">${param.city }</e:set>
</e:if>
<e:if condition="${param.acct_month != null && param.acct_month ne '' }" var="isNullMonth">
	<e:set var="acct_month">${param.acct_month}</e:set>
</e:if>
<e:else condition="${isNullMonth }">
	<e:set var="acct_month">201608</e:set>
	<e:description><e:set var="acct_month">${e:getDate('yyyyMM')}</e:set></e:description>
</e:else>
<!-- 选取的账期 -->
<e:if condition="${param.cheMon != '' && param.cheMon != null }">
	<e:set var="cheMon">${param.cheMon }</e:set>
</e:if>
<e:description>异常换机分析(按地市异常换机总量排序)</e:description>
<e:if condition="${proname != '全国' || proname ne '全国'}" var="c1">	
	<e:q4l var="city_change">	
			SELECT 	DISTINCT			
				 B."CITY_NAME" a,
				round("sum"(A."EXCEPTION_NUM"),0) b
			from "DM_M_TERM_NM_CHANGE_EXCEPTION" A,"DIM_CITY_NO" B 
			where 1=1	
			AND A ."CITY_NO" = B ."CITY_NO" 						
			AND A ."AREA_NO" = '${area_no}'	
			<e:if condition="${city_no != 'qxz'}">
				AND A ."CITY_NO" = '${city_no}'	
			</e:if>					
			AND a."ACCT_MONTH"  = '${acct_month}'	
			GROUP BY a	
			ORDER BY b DESC
	</e:q4l>	
</e:if>
<e:else condition="${c1}">									
	<e:q4l var="city_change">
				SELECT 	DISTINCT			
					 B."AREA_NAME" a,
					"sum"(A."EXCEPTION_NUM") b
				from "DM_M_TERM_NM_CHANGE_EXCEPTION" A,"DIM_AREA_NO" B 
				where 1=1	
				AND A ."AREA_NO" = B ."AREA_NO" 															
				AND a."ACCT_MONTH"  = '${acct_month}'	
				GROUP BY a
				ORDER BY b DESC		
	</e:q4l>	
</e:else>
<e:description>异常换机分析</e:description>
<e:if condition="${proname != '全国' || proname ne '全国'}" var="c2">	
	<e:q4l var="cityChange">	
			SELECT 	DISTINCT			
				 B."CITY_NAME" a,
				trim(to_char(sum(A."EXCEPTION_NUM"),'999,999,999D')) b
			from "DM_M_TERM_NM_CHANGE_EXCEPTION" A,"DIM_CITY_NO" B 
			where 1=1	
			AND A ."CITY_NO" = B ."CITY_NO" 						
			AND A ."AREA_NO" = '${area_no}'	
			<e:if condition="${city_no != 'qxz'}">
				AND A ."CITY_NO" = '${city_no}'	
			</e:if>					
			AND a."ACCT_MONTH"  = '${acct_month}'	
			GROUP BY a	
			ORDER BY b DESC
	</e:q4l>	
</e:if>
<e:else condition="${c2}">									
	<e:q4l var="cityChange">
				SELECT 	DISTINCT			
					 B."AREA_NAME" a,
					trim(to_char(sum(A."EXCEPTION_NUM"),'999,999,999D')) b
				from "DM_M_TERM_NM_CHANGE_EXCEPTION" A,"DIM_AREA_NO" B 
				where 1=1	
				AND A ."AREA_NO" = B ."AREA_NO" 															
				AND a."ACCT_MONTH"  = '${acct_month}'	
				GROUP BY a
				ORDER BY b DESC		
	</e:q4l>	
</e:else>
<e:description>换机周期（品牌）</e:description>
<e:q4l var="brandCycle">
			SELECT DISTINCT
				B."BRAND_NAME" a,
				ceil(sum(A."USER_NUM"*A."CYCLE_NUM")/sum(A."USER_NUM")) b
			from "DM_M_TERM_NM_CHANGE_CYCLE" A,"TRMNL_DEVINFO" B
			where 1=1
			AND A."BRAND_NO" = B."BRAND_NO"	
			AND A."USER_NUM">1000
			<e:if condition="${city_no == 'qxz'}" var="proOrCity"> 					
				<e:if condition="${proname != '全国'}">
						AND A ."AREA_NO" = '${area_no}'	
				</e:if>									
			</e:if>
			<e:else condition="${proOrCity}">
				AND A ."AREA_NO" = '${area_no}'
				AND A ."CITY_NO" = '${city_no}'
			</e:else>
			AND a."ACCT_MONTH"  = '${acct_month}'			
			GROUP BY a
			ORDER BY b DESC
			LIMIT 10
</e:q4l>
<e:q4l var="priceCycle">
			SELECT DISTINCT
				B."PRICE_NAME" A,
				ceil(sum(A."USER_NUM"*A."CYCLE_NUM")/sum(A."USER_NUM")) b,
				B."ORD" c
			FROM "DM_M_TERM_NM_CHANGE_CYCLE" A,"DIM_PRICES_PERIOD" B
			WHERE 1 = 1
			AND A ."PRICE_NO" = b."PRICE_NO"
			AND A."USER_NUM">1000
			<e:if condition="${city_no == 'qxz'}" var="proOrCity"> 			
				<e:if condition="${proname != '全国'}">
						AND A ."AREA_NO" = '${area_no}'	
				</e:if>			
			</e:if>
			<e:else condition="${proOrCity}">
				AND A ."AREA_NO" = '${area_no}'
				AND A ."CITY_NO" = '${city_no}'
			</e:else>
			AND a."ACCT_MONTH"  = '${acct_month}'
			GROUP BY A,c
			ORDER BY c
</e:q4l>
<e:description>品牌销量top5</e:description>
<e:q4l var="brTop5">
SELECT 
		B.b brno,
		B.bn brname,		
		"sum"(A ."TERMINAL_NUM") brsum
	FROM
		"DM_M_TERM_MARKET_OVERVIEW" A,(SELECT DISTINCT "BRAND_NO" b,"BRAND_NAME" bn FROM "TRMNL_DEVINFO") B
	WHERE
		1 = 1 and "LINE_TYPE"='1' 
	AND A ."BRAND_NO" = B.b
			<e:if condition="${city_no == 'qxz'}" var="proOrCity"> 			
				<e:if condition="${proname != '全国'}">
						AND A ."AREA_NO" = '${area_no}'	
				</e:if>				
			</e:if>
			<e:else condition="${proOrCity}">
				AND A ."AREA_NO" = '${area_no}'
				AND A ."CITY_NO" = '${city_no}'
			</e:else>
			AND a."ACCT_MONTH"  = '${acct_month}'
	GROUP BY brno,brname
	ORDER BY brsum DESC
	LIMIT 5
</e:q4l>
<e:description>55555555</e:description>

<e:forEach items="${brTop5.list}" var="brTop5list">
<e:description>品牌销量1流入出总数</e:description>
<e:q4l var="br${index+1 }">
SELECT DISTINCT
	round(B.TERMINAL_NUM,0) IN_NUM,
	C .IMG_URL IMG_URL,
	round(D.TERMINAL_NUM,0) OUT_NUM  
FROM
	(
		SELECT
			SUM ("TERMINAL_NUM") TERMINAL_NUM
		FROM
			"DM_M_TERM_NM_CHANGE_TRACK"
		WHERE
			"IN_BRAND" = '${brTop5list.brno}'
			<e:if condition="${city_no == 'qxz'}" var="proOrCity"> 			
				<e:if condition="${proname != '全国'}">
						AND "AREA_NO" = '${area_no}'	
				</e:if>				
			</e:if>
			<e:else condition="${proOrCity}">
				AND "AREA_NO" = '${area_no}'
				AND "CITY_NO" = '${city_no}'
			</e:else>
		AND "ACCT_MONTH" ='${acct_month}'
	) B,
	(
		SELECT DISTINCT
			b."IMG_URL" IMG_URL
		FROM
			"DM_M_TERM_NM_CHANGE_TRACK" A,
			"DIM_IMG_NO" b
		WHERE
			A ."IN_BRAND" = '${brTop5list.brno}'
			<e:if condition="${city_no == 'qxz'}" var="proOrCity"> 			
				<e:if condition="${proname != '全国'}">
						AND A ."AREA_NO" = '${area_no}'	
				</e:if>			
			</e:if>
			<e:else condition="${proOrCity}">
				AND A ."AREA_NO" = '${area_no}'
				AND A ."CITY_NO" = '${city_no}'
			</e:else>
			AND  A ."ACCT_MONTH" ='${acct_month}'
		AND A ."IMG_NO" = b."IMG_NO"
		AND b."IMG_TYPE" = 'phonelogo'
	) C,
	(
		SELECT
			SUM ("TERMINAL_NUM") TERMINAL_NUM
		FROM
			"DM_M_TERM_NM_CHANGE_TRACK"
		WHERE
			"OUT_BRAND" = '${brTop5list.brno}'
			<e:if condition="${city_no == 'qxz'}" var="proOrCity"> 					
				<e:if condition="${proname != '全国'}">
						AND "AREA_NO" = '${area_no}'	
				</e:if>									
			</e:if>
			<e:else condition="${proOrCity}">
				AND "AREA_NO" = '${area_no}'
				AND "CITY_NO" = '${city_no}'
			</e:else>
		AND "ACCT_MONTH" ='${acct_month}'
	) D
</e:q4l>
<e:description>品牌销量1流入Top3</e:description>
<e:q4l var="br${index+1 }in">
SELECT DISTINCT
	C.brna brna,
	C .IMG_URL IMG_URL,
	round(C .ter,0) TERMINAL_NUM,
	to_char(
		ROUND(C .ter / D.outnum, 4) * 100,
		'990.0'
	) || '%' PROPOR_NUM
FROM
	(
		SELECT
			SUM ("TERMINAL_NUM") outnum
		FROM
			"DM_M_TERM_NM_CHANGE_TRACK"
		WHERE
			"IN_BRAND" = '${brTop5list.brno}'
			<e:if condition="${city_no == 'qxz'}" var="proOrCity"> 					
				<e:if condition="${proname != '全国'}">
						AND "AREA_NO" = '${area_no}'	
				</e:if>									
			</e:if>
			<e:else condition="${proOrCity}">
				AND "AREA_NO" = '${area_no}'
				AND "CITY_NO" = '${city_no}'
			</e:else>
		AND "ACCT_MONTH" = '${acct_month}'
	) D,
	(
		(
			SELECT
				C .ter ter,
				C.brna brna,
				"IMG_URL" IMG_URL
			FROM
				"DIM_IMG_NO",
				(
					SELECT DISTINCT
						X."OUT_BRAND" in_no,
						Y.bna brna,
						SUM (X."TERMINAL_NUM") ter
					FROM
						"DM_M_TERM_NM_CHANGE_TRACK" X,(SELECT DISTINCT "BRAND_NO" bn,"BRAND_NAME" bna FROM "TRMNL_DEVINFO") Y
					WHERE
						X."OUT_BRAND" = Y.bn
				  AND X."IN_BRAND" = '${brTop5list.brno}'
				  <e:if condition="${city_no == 'qxz'}" var="proOrCity"> 					
						<e:if condition="${proname != '全国'}">
								AND X."AREA_NO" = '${area_no}'	
						</e:if>									
					</e:if>
					<e:else condition="${proOrCity}">
						AND X."AREA_NO" = '${area_no}'
						AND X."CITY_NO" = '${city_no}'
					</e:else>
					AND X."ACCT_MONTH" = '${acct_month}'
					GROUP BY
						in_no,brna
					ORDER BY
						ter DESC
					LIMIT 3
				) C
			WHERE
				"IMG_NO" IN (
							SELECT DISTINCT
								"IMG_NO"
							FROM
								"TRMNL_DEVINFO" A
							WHERE 1=1
							AND	"BRAND_NO" IN (C.in_no)
							AND "IMG_TYPE" = 'phonelogo'
						)
			AND "IMG_TYPE" = 'phonelogo'
		)
	) C
ORDER BY
	round(C .ter,0) DESC
</e:q4l>
<e:description>品牌销量流出Top3</e:description>
<e:q4l var="br${index+1 }out">
SELECT DISTINCT
C.brna brna,
	C .IMG_URL IMG_URL,
	round(C .ter,0) TERMINAL_NUM,
	to_char(
		ROUND(C .ter / D.outnum, 4) * 100,
		'990.0'
	) || '%' PROPOR_NUM
FROM
	(
			SELECT
				SUM ("TERMINAL_NUM") outnum
			FROM
				"DM_M_TERM_NM_CHANGE_TRACK"
			WHERE
				"OUT_BRAND" = '${brTop5list.brno}'
				<e:if condition="${city_no == 'qxz'}" var="proOrCity"> 					
					<e:if condition="${proname != '全国'}">
							AND "AREA_NO" = '${area_no}'	
					</e:if>									
				</e:if>
				<e:else condition="${proOrCity}">
					AND "AREA_NO" = '${area_no}'
					AND "CITY_NO" = '${city_no}'
				</e:else>
			AND "ACCT_MONTH" = '${acct_month}'
	) D,
	(
		(
			SELECT
				C .ter ter,
				C.brna brna,
				"IMG_URL" IMG_URL
			FROM
				"DIM_IMG_NO",
				(
					SELECT DISTINCT
						X."IN_BRAND" in_no,
						Y.bna brna,
						SUM (X."TERMINAL_NUM") ter
					FROM
						"DM_M_TERM_NM_CHANGE_TRACK" X,(SELECT DISTINCT "BRAND_NO" bn,"BRAND_NAME" bna FROM "TRMNL_DEVINFO") Y
					WHERE
						X."IN_BRAND" = Y.bn
				  AND X."OUT_BRAND" = '${brTop5list.brno}'
				  <e:if condition="${city_no == 'qxz'}" var="proOrCity"> 					
						<e:if condition="${proname != '全国'}">
								AND X."AREA_NO" = '${area_no}'	
						</e:if>									
					</e:if>
					<e:else condition="${proOrCity}">
						AND X."AREA_NO" = '${area_no}'
						AND X."CITY_NO" = '${city_no}'
					</e:else>
					AND X."ACCT_MONTH" = '${acct_month}'
					GROUP BY
						in_no,brna
					ORDER BY
						ter DESC
					LIMIT 3
				) C
			WHERE
				"IMG_NO" IN (
						SELECT DISTINCT
							"IMG_NO"
						FROM
							"TRMNL_DEVINFO" A
						WHERE 1=1
						AND	"BRAND_NO" IN (C.in_no)
						AND "IMG_TYPE" = 'phonelogo'
					)
			AND "IMG_TYPE" = 'phonelogo'
		)
	) C
ORDER BY
	round(C .ter,0) DESC
</e:q4l>
</e:forEach>



<html>
  <head>
	<a:base/>
<meta http-equiv="Content-Type" content="textml; charset=utf-8" />

<c:resources type="easyui,highchart" style="b"/>
<!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<!--声明以360极速模式进行渲染 -->
<meta name=”renderer” content=”webkit” />
<!--系统名称文本 -->
<title>终端指标分析系统－行为</title>
<!-- 系统ICON图标（注:路径为TomCat根目录） -->
<link rel ="Shortcut Icon" href="" />
<e:style value="/pages/terminal/resources/component/easyui/themes/metro/easyui.css"/>
<e:style value="/pages/terminal/resources/component/easyui/themes/icon.css"/>
<!-- 独立Js脚本 -->
<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/boncCommon.js"/>'></script>
<!-- 圆形统计图js -->
<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/jquery.circliful.min.js"/>'></script>
<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/echarts.min.js"/>'></script>
	
 <!-- 独立Css层叠样式表 -->
<e:style value="/pages/terminal/resources/themes/base/boncBase@links.css"/>
<e:style value="resources/themes/base/boncBase@links.css"/>
<%-- <e:style value="resources/themes/blue/boncBlue.css"/> --%>
	
<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/main.js"/>'></script>

     <script language="JavaScript">
        $(function(){
        	<e:if condition="${sessionScope.UserInfo.CITY_NO != '' && sessionScope.UserInfo.CITY_NO != null }" var="checs">
	        	$("#proH").val('${param.area}');	
	        	$("#cityH").empty();
	    		$("#cityH").append("<option value='${sessionScope.UserInfo.CITY_NO}'>${Onecity.CITY_NAME}</option>");
	    		getMon();
        	</e:if>
        	<e:else condition="${checs}">  
        		$("#proH").val('${param.area}');
        		findCityH();
        		getMon();
        	</e:else>
        	$(".EntryGroupLine input").bind("hover focus", function() {
	            $(this).parent('.EntryGroupLine').addClass('onFocus');
	            $(this).parent('.EntryGroupLine').parent('.EntryBox').siblings('.EntryBox').find('.EntryGroupLine').removeClass('onFocus')
            });
        })
        //省份、地市级联 操作
		function findCityH(){       	
        	$("#cityH").empty();
    		$("#cityH").append("<option value='qxz'>--请选择--</option>");		
			var AREA_NO = $("#proH").val();
			$.post('<e:url value="/pages/terminal/nmexchange/exchangeAction.jsp?eaction=seleCityList"/>',{ qdValue: AREA_NO},function(data){
				var city =eval(data.trim());
		      	for(var i = 0;i<city.length;i++){
		 			$("#cityH").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
		 		}
		      	$("#cityH").val("${param.city}");
		    });
		} 
        function getMon(){
        	var getCheMon = '${cheMon}';
        	if(getCheMon != ''){
        		$("#stopH").val(getCheMon);
        	}else{
        		var mydate = new Date();
         	   var str = "" + mydate.getFullYear() + "-";
         	   str += (mydate.getMonth()+1);
         	   //市场停止月份
         	   $("#stopH").val('2016-08');
         	   //$("#stopH").val(str);
        	}
            $('#stopH').datebox({  
         	    editable:false ,
                 onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层  
                     span.trigger('click'); //触发click事件弹出月份层  
                     if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔  
                         tds = p.find('div.calendar-menu-month-inner td');  
                         tds.click(function (e) {  
                             e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件  
                             var year = /\d{4}/.exec(span.html())[0]//得到年份  
                                     , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1  
                             $('#stopH').datebox('hidePanel')//隐藏日期对象  
                                     .datebox('setValue', year + '-' + month); //设置日期的值  
                         });  
                     }, 0)  
                 },  
                 parser: function (s) {  
                     if (!s) return new Date();  
                     var arr = s.split('-');  
                     return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);  
                 },  
                 formatter: function (d) { return d.getFullYear() + '-' + (d.getMonth()+1);/*getMonth返回的是0开始的，忘记了。。已修正*/ }  
             });  
             var p = $('#stopH').datebox('panel'), //日期选择对象  
                     tds = false, //日期选择对象中月份  
                     span = p.find('span.calendar-text'); //显示月份层的触发控件          
                     
         }
        function doSerch(){
        	/* var info={};
        	info.area=$('#proH').val();
        	info.proname=$("#proH").find("option:selected").text();//省份的name
        	info.city=$('#cityH').val();
        	info.cheMon = $('#stopH').datebox('getValue');//日历控件显示值
        	info.acct_month=$('#stopH').datebox('getValue').replace("-", "");        	
        	if(info.acct_month.length==5){
        		info.acct_month =acct_month.substr(0,4)+"0"+acct_month.substr(4);
        	}  
        	$.post('<e:url value="pages/terminal/nmexchange/exchange.jsp"/>',
        			info,
        			function(data){
        		
        	});
        	 */
        	var area=$('#proH').val();
        	var proname=$("#proH").find("option:selected").text();//省份的name
        	var city=$('#cityH').val();
        	var cheMon = $('#stopH').datebox('getValue');//日历控件显示值
        	var acct_month=$('#stopH').datebox('getValue').replace("-", "");        	
        	if(acct_month.length==5){
        		acct_month =acct_month.substr(0,4)+"0"+acct_month.substr(4);
        	}  
      		window.location.href = '<e:url value="/pages/terminal/nmexchange/exchange.jsp"/>?area=' + area+'&proname='+proname + '&city=' + city +'&acct_month='+acct_month+'&cheMon='+cheMon;	    		
        }
    </script>
			
  </head>
  
  <body>
   
   <div id="boncEntry">

	<div class=" searcharea" style="width:100%;height:auto;margin-top:15px;">
		<!-- 历史换机 -->
		<div title="历史换机">
			<!-- 查询条件 -->
			<div class="searchbox">
				<span class="spantext">省级</span>				
					<select name="proH" id="proH" style="width:150px;"  onchange="findCityH();">
						<e:forEach items="${areaL.list}" var="item">
								<option value="${item.AREA_NO }">${item.AREA_NAME }</option>
						</e:forEach>
					</select>					
				<span class="spantext">地市</span>
					<select name="cityH"  id="cityH" style="width:150px;"></select>	
				<span class="spantext">月份</span>
				<input id="stopH" style="width:150px;">
				<a href="javascript:doSerch();" class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width:80px">查询</a>
			</div>
			<!-- //查询条件 -->
			<!--上  -->
			<div class="AdminProduct">
				<div style="float:left;width: 100%;">
					<h2 class="time"><div title="当月≥3次换机的用户，且套餐额度连续3个月≤30元，且近3个月出账金额≤套餐金额">异常换机用户-按地市异常换机用户数排序</div></h2>
					<!-- echarts图表位置 -->
					<div>
					<e:if condition="${e:length(city_change.list)>0}" var="check3">
						<e:if condition="${city_no == 'qxz'}" var="check4"> 
							<c:ncolumnline id="brChan" 
										width="1000" height="300"
								        yaxis="title:,unit:"
								        b = "name:数量  ,type:column" 
								        showexport="false"
								        dimension="a"
								        items="${city_change.list}" 
										title=" " legend = "false" dataLabel = "true"
								        fontsize = "10px" rotation = "0"  
							    />
						</e:if>
						<e:else condition="${check4}">	
							<div class="salearea">					
								 <table cellpadding="0" cellspacing="0" class="TableMarket">
									<colgroup>
										<col width="10%" />
										<col width="25%" />										
									</colgroup>
									<tbody>
										<tr>
											<td>${cityChange.list[0].a}</td>
											<td><span><e:if condition="${cityChange.list[0].b !='' && cityChange.list[0].b !=null}" var="newuser">${cityChange.list[0].b }</e:if><e:else condition="${newuser}">0</e:else> </span></td>																	
										</tr>							
									</tbody>
								</table> 
							</div>	
						</e:else>
					</e:if>
					<e:else condition="${check3}">
						 暂无数据！
					</e:else> 								
					</div>
					<!-- //echarts图表位置 -->
				</div>
			</div>
			<!--//上  -->
			<!--中  -->
			<div class="AdminProduct">
				<div style="float:left;width: 50%;">
					<h2 class="time"><div title="换机周期=用户在网时长/累计换机次数">换机周期-品牌(按品牌终端用户数排序，单位：月)</div></h2>
					<!-- echarts图表位置 -->
					<div>
					<e:if condition="${e:length(brandCycle.list)>0}" var="check1">
						<c:ncolumnline id="brCycle" 
								width="600" height="300"
						        yaxis="title:,unit:"
						        b = "name:数量  ,type:column" 
						        showexport="false"
						        dimension="a"
						        items="${brandCycle.list}" 
								title=" " legend = "false" dataLabel = "true"
						        fontsize = "10px" rotation = "0"  
					    /> 
					</e:if>
					<e:else condition="${check1}">
						 暂无数据！
					</e:else> 						
					</div>
					<!-- //echarts图表位置 -->
				</div>
				<div style="float:left;width: 50%;">
					<h2  class="time"><div title="换机周期=用户在网时长/累计换机次数">换机周期(价格段)-(按价格段排序，单位：月)</div></h2>
					<!-- echarts图表位置 -->
					<div>
					<e:if condition="${e:length(priceCycle.list)>0}" var="check2">
						<c:ncolumnline id="prCycle" 
								width="600" height="300"
						        yaxis="title:,unit:"
						        b = "name:数量  ,type:column" 
						        showexport="false"
						        dimension="a"
						        items="${priceCycle.list}" 
								title=" " legend = "false" dataLabel = "true"
						        fontsize = "10px" rotation = "0"  
					    />
					</e:if>
					<e:else condition="${check2}">
						 暂无数据！
					</e:else> 	
					</div>
					<!-- //echarts图表位置 -->
				</div>
			</div>
			<!-- //中  -->
			<!-- 下  -->
			<div class="exchangearea exchangearea_new">
				<!-- 标题 -->
				<h2 style="width: 33%;">换入TOP3份额占比</h2>
				<h2 style="width: 33%;"><span class="into">换入总数</span><div title="新增品牌终端TOP5"><span>品牌<br /><em>（销量TOP5）</em></span></div><span class="out">换出总数</span></h2>
				<h2 style="width: 34%;">换出TOP3份额占比</h2>
				<!-- //标题 -->
			</div>
			<!-- 品牌1 -->
			<%-- <e:forEach items="${brTop5.list }" var="item"> --%>
				<div class="exchangearea exchangearea_new">
					<div class="exchangebox" style="width: 36%;">
						<div class="">
							<!-- 排行 -->	
							<e:if condition="${e:length(br1in.list)>0 || e:length(brTop5.list) >= 1}" var="check11">					
								<ul class="ulrank">						
									<e:forEach items="${br1in.list }" var="br1inlist">
										<li>
											<span class="icon-exchange0${index+1 }">${index+1 }</span>
											<div class="txtrank">
												<h3><img src="${br1inlist.IMG_URL }" width="36" height="36">${br1inlist.brna }</h3>
												<p>换入量：<span>${br1inlist.TERMINAL_NUM } 部</span></p>
												<div title="占比=换入量/换入总数"><p>占比：<span>${br1inlist.PROPOR_NUM }</span></p></div>
											</div>
										</li>
									</e:forEach>																	
								</ul>
							</e:if>
							<e:else condition="${check11}">
							 	暂无数据！
							</e:else> 
							<!-- 排行 -->
						</div>
					</div>
					<div class="exchangebox middle " style="width: 31%;">
						<e:if condition="${e:length(br1.list)>0 || e:length(brTop5.list) >= 1}" var="check12">
							<div class="arrow-left">${br1.list[0].IN_NUM } 部</div>
							<div class="brand"><img src="${br1.list[0].IMG_URL }" alt="iPhone"></div>
							<div class="arrow-right">${br1.list[0].OUT_NUM } 部</div>
						</e:if>
						<e:else condition="${check12}">
								 暂无数据！
						</e:else> 					
					</div>
					<div class="exchangebox " style="width: 33%;">
						<div class="exchange">
							<!-- 排行 -->
							<e:if condition="${e:length(br1out.list)>0 || e:length(brTop5.list) >= 1}" var="check13">	
								<ul class="ulrank">
									<e:forEach items="${br1out.list }" var="br1outlist">
										<li>
											<span class="icon-exchange0${index+1 }">${index+1 }</span>
											<div class="txtrank">
												<h3><img src="${br1outlist.IMG_URL }" width="36" height="36">${br1outlist.brna }</h3>
												<p>换出量：<span>${br1outlist.TERMINAL_NUM } 部</span></p>
												<div title="占比=换出量/换出总数"><p>占比：<span>${br1outlist.PROPOR_NUM }</span></p></div>
											</div>
										</li>
									</e:forEach>
								</ul>
							</e:if>
							<e:else condition="${check13}">
							 	暂无数据！
							</e:else>
							<!-- 排行 -->
						</div>
					</div>
				</div>
			<%-- </e:forEach> --%>
			<!-- //品牌1 -->
			<!-- 品牌2 -->
			<div class="exchangearea exchangearea_new">
				<div class="exchangebox" style="width: 36%;">
					<div class="">
						<!-- 排行 -->
						<e:if condition="${e:length(br2in.list)>0 || e:length(brTop5.list) >= 2}" var="check21">	
							<ul class="ulrank">
								<e:forEach items="${br2in.list }" var="br2inlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br2inlist.IMG_URL }" width="36" height="36">${br2inlist.brna }</h3>
											<p>换入量：<span>${br2inlist.TERMINAL_NUM } 部</span></p>
											<div title="占比=换入量/换入总数"><p>占比：<span>${br2inlist.PROPOR_NUM }</span></p></div>
										</div>
									</li>
								</e:forEach>											
							</ul>
						</e:if>
						<e:else condition="${check21}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
				<div class="exchangebox middle " style="width: 31%;">
					<e:if condition="${e:length(br2.list)>0 || e:length(brTop5.list) >= 2}" var="check22">
						<div class="arrow-left">${br2.list[0].IN_NUM } 部</div>
						<div class="brand"><img src="${br2.list[0].IMG_URL }" alt="iPhone"></div>
						<div class="arrow-right">${br2.list[0].OUT_NUM } 部</div>					
					</e:if>
					<e:else condition="${check22}">
					 	暂无数据！
					</e:else>
				</div>
				<div class="exchangebox " style="width: 33%;">
					<div class="exchange">
						<!-- 排行 -->
						<e:if condition="${e:length(br2out.list)>0 || e:length(brTop5.list) >= 2}" var="check23">
							<ul class="ulrank">
								<e:forEach items="${br2out.list }" var="br2outlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br2outlist.IMG_URL }" width="36" height="36">${br2outlist.brna }</h3>
											<p>换出量：<span>${br2outlist.TERMINAL_NUM } 部</span></p>
											<div title="占比=换出量/换出总数"><p>占比：<span>${br2outlist.PROPOR_NUM }</span></p></div>
										</div>
									</li>
								</e:forEach>
							</ul>
						</e:if>
						<e:else condition="${check23}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
			</div>
			<!-- //品牌2 -->
			<!-- 品牌3 -->
			<div class="exchangearea exchangearea_new">
				<div class="exchangebox" style="width: 36%;">
					<div class="">
						<!-- 排行 -->
						<e:if condition="${e:length(br3in.list)>0 || e:length(brTop5.list) >= 3}" var="check31">
							<ul class="ulrank">						
								<e:forEach items="${br3in.list }" var="br3inlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br3inlist.IMG_URL }" width="36" height="36">${br3inlist.brna }</h3>
											<p>换入量：<span>${br3inlist.TERMINAL_NUM } 部</span></p>
											<div title="占比=换入量/换入总数"><p>占比：<span>${br3inlist.PROPOR_NUM }</span></p></div>
										</div>
									</li>
								</e:forEach>																	
							</ul>
						</e:if>
						<e:else condition="${check31}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
				<div class="exchangebox middle" style="width: 31%;">
					<e:if condition="${e:length(br3.list)>0 || e:length(brTop5.list) >= 3}" var="check32">
						<div class="arrow-left">${br3.list[0].IN_NUM } 部</div>
						<div class="brand"><img src="${br3.list[0].IMG_URL }" alt="iPhone"></div>
						<div class="arrow-right">${br3.list[0].OUT_NUM } 部</div>		
					</e:if>
					<e:else condition="${check32}">
					 	暂无数据！
					</e:else>
				</div>
				<div class="exchangebox" style="width: 33%;">
					<div class="exchange">
						<!-- 排行 -->
						<e:if condition="${e:length(br3out.list)>0 || e:length(brTop5.list) >= 3}" var="check33">
							<ul class="ulrank">
								<e:forEach items="${br3out.list }" var="br3outlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br3outlist.IMG_URL }" width="36" height="36">${br3outlist.brna }</h3>
											<p>换出量：<span>${br3outlist.TERMINAL_NUM } 部</span></p>
											<div title="占比=换出量/换出总数"><p>占比：<span>${br3outlist.PROPOR_NUM }</span></p></div>
										</div>
									</li>
								</e:forEach>
							</ul>
						</e:if>
						<e:else condition="${check33}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
			</div>
			<!-- //品牌3 -->
			<!-- 品牌4 -->
			<div class="exchangearea exchangearea_new">
				<div class="exchangebox" style="width: 36%;">
					<div class="">
						<!-- 排行 -->
						<e:if condition="${e:length(br4in.list)>0 || e:length(brTop5.list) >= 4}" var="check41">
							<ul class="ulrank">						
								<e:forEach items="${br4in.list }" var="br4inlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br4inlist.IMG_URL }" width="36" height="36">${br4inlist.brna }</h3>
											<p>换入量：<span>${br4inlist.TERMINAL_NUM } 部</span></p>
											<div title="占比=换入量/换入总数"><p>占比：<span>${br4inlist.PROPOR_NUM }</span></p></div>
										</div>
									</li>
								</e:forEach>																	
							</ul>
						</e:if>
						<e:else condition="${check41}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
				<div class="exchangebox middle" style="width: 31%;">
					<e:if condition="${e:length(br4.list)>0 || e:length(brTop5.list) >= 4}" var="check42">
						<div class="arrow-left">${br4.list[0].IN_NUM } 部</div>
						<div class="brand"><img src="${br4.list[0].IMG_URL }" alt="iPhone"></div>
						<div class="arrow-right">${br4.list[0].OUT_NUM } 部</div>		
					</e:if>
					<e:else condition="${check42}">
					 	暂无数据！
					</e:else>
				</div>
				<div class="exchangebox" style="width: 33%;">
					<div class="exchange">
						<!-- 排行 -->
						<e:if condition="${e:length(br4out.list)>0 || e:length(brTop5.list) >= 4}" var="check43">
							<ul class="ulrank">
								<e:forEach items="${br4out.list }" var="br4outlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br4outlist.IMG_URL }" width="36" height="36">${br4outlist.brna }</h3>
											<p>换出量：<span>${br4outlist.TERMINAL_NUM } 部</span></p>
											<div title="占比=换出量/换出总数"><p>占比：<span>${br4outlist.PROPOR_NUM }</span></p></div>
										</div>
									</li>
								</e:forEach>
							</ul>
						</e:if>
						<e:else condition="${check43}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
			</div>
			<!-- //品牌4 -->
			<!-- 品牌5 -->
			<div class="exchangearea exchangearea_new">
				<div class="exchangebox" style="width: 36%;">
					<div class="">
						<!-- 排行 -->
						<e:if condition="${e:length(br5in.list)>0  || e:length(brTop5.list)>=5}" var="check51">
							<ul class="ulrank">						
								<e:forEach items="${br5in.list }" var="br5inlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br5inlist.IMG_URL }" width="36" height="36">${br5inlist.brna }</h3>
											<p>换入量：<span>${br5inlist.TERMINAL_NUM } 部</span></p>
											<div title="占比=换入量/换入总数"><p>占比：<span>${br5inlist.PROPOR_NUM }</span></p></div>
										</div>
									</li>
								</e:forEach>																	
							</ul>
						</e:if>
						<e:else condition="${check51}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
				<div class="exchangebox middle" style="width: 31%;">
					<e:if condition="${e:length(br5.list)>0  || e:length(brTop5.list)>=5 }" var="check52">
						<div class="arrow-left">${br5.list[0].IN_NUM } 部</div>
						<div class="brand"><img src="${br5.list[0].IMG_URL }" alt="iPhone"></div>
						<div class="arrow-right">${br5.list[0].OUT_NUM } 部</div>		
					</e:if>
					<e:else condition="${check52}">
					 	暂无数据！
					</e:else>
				</div>
				<div class="exchangebox" style="width: 33%;">
					<div class="exchange">
						<!-- 排行 --> 
						<e:if condition="${e:length(brTop5.list)>=5 || e:length(br5out.list)>0}" var="check53">
							<ul class="ulrank">
								<e:forEach items="${br5out.list }" var="br5outlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br5outlist.IMG_URL }" width="36" height="36">${br5outlist.brna }</h3>
											<p>换出量：<span>${br5outlist.TERMINAL_NUM } 部</span></p>
											<div title="占比=换出量/换出总数"><p>占比：<span>${br5outlist.PROPOR_NUM }</span></p></div>
										</div>
									</li>
								</e:forEach>
							</ul>
						</e:if>
						<e:else condition="${check53}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
			</div>
			<!-- //品牌5 -->
			
			
			
			
<e:description>			
			
			<!-- 品牌6 -->
			<div class="exchangearea exchangearea_new">
				<div class="exchangebox" style="width: 33%;">
					<div class="">
						<!-- 排行 -->
						<e:if condition="${e:length(br6in.list)>0  || e:length(brTop5.list)>=6}" var="check61">
							<ul class="ulrank">						
								<e:forEach items="${br6in.list }" var="br6inlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br6inlist.IMG_URL }" width="36" height="36">${br6inlist.brna }</h3>
											<p>销量：<span>${br6inlist.TERMINAL_NUM } 部</span></p>
											<p>占比：<span>${br6inlist.PROPOR_NUM }</span></p>
										</div>
									</li>
								</e:forEach>																	
							</ul>
						</e:if>
						<e:else condition="${check61}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
				<div class="exchangebox middle" style="width: 33%;">
					<e:if condition="${e:length(br6.list)>0  || e:length(brTop5.list)>=6 }" var="check62">
						<div class="arrow-left">${br6.list[0].IN_NUM } 部</div>
						<div class="brand"><img src="${br6.list[0].IMG_URL }" alt="iPhone"></div>
						<div class="arrow-right">${br6.list[0].OUT_NUM } 部</div>		
					</e:if>
					<e:else condition="${check62}">
					 	暂无数据！
					</e:else>
				</div>
				<div class="exchangebox" style="width: 33%;">
					<div class="exchange">
						<!-- 排行 --> 
						<e:if condition="${e:length(brTop5.list)>=6 || e:length(br6out.list)>0}" var="check63">
							<ul class="ulrank">
								<e:forEach items="${br6out.list }" var="br6outlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br6outlist.IMG_URL }" width="36" height="36">${br6outlist.brna }</h3>
											<p>销量：<span>${br6outlist.TERMINAL_NUM } 部</span></p>
											<p>占比：<span>${br6outlist.PROPOR_NUM }</span></p>
										</div>
									</li>
								</e:forEach>
							</ul>
						</e:if>
						<e:else condition="${check63}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
			</div>
			<!-- //品牌6 -->
			<!-- 品牌7 -->
			<div class="exchangearea exchangearea_new">
				<div class="exchangebox" style="width: 33%;">
					<div class="">
						<!-- 排行 -->
						<e:if condition="${e:length(br7in.list)>0  || e:length(brTop5.list)>=7}" var="check71">
							<ul class="ulrank">						
								<e:forEach items="${br7in.list }" var="br7inlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br7inlist.IMG_URL }" width="37" height="37">${br7inlist.brna }</h3>
											<p>销量：<span>${br7inlist.TERMINAL_NUM } 部</span></p>
											<p>占比：<span>${br7inlist.PROPOR_NUM }</span></p>
										</div>
									</li>
								</e:forEach>																	
							</ul>
						</e:if>
						<e:else condition="${check71}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
				<div class="exchangebox middle" style="width: 33%;">
					<e:if condition="${e:length(br7.list)>0  || e:length(brTop5.list)>=7 }" var="check72">
						<div class="arrow-left">${br7.list[0].IN_NUM } 部</div>
						<div class="brand"><img src="${br7.list[0].IMG_URL }" alt="iPhone"></div>
						<div class="arrow-right">${br7.list[0].OUT_NUM } 部</div>		
					</e:if>
					<e:else condition="${check72}">
					 	暂无数据！
					</e:else>
				</div>
				<div class="exchangebox" style="width: 33%;">
					<div class="exchange">
						<!-- 排行 --> 
						<e:if condition="${e:length(brTop5.list)>=7 || e:length(br7out.list)>0}" var="check73">
							<ul class="ulrank">
								<e:forEach items="${br7out.list }" var="br7outlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br7outlist.IMG_URL }" width="37" height="37">${br7outlist.brna }</h3>
											<p>销量：<span>${br7outlist.TERMINAL_NUM } 部</span></p>
											<p>占比：<span>${br7outlist.PROPOR_NUM }</span></p>
										</div>
									</li>
								</e:forEach>
							</ul>
						</e:if>
						<e:else condition="${check73}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
			</div>
			<!-- //品牌7 -->
			<!-- 品牌8 -->
			<div class="exchangearea exchangearea_new">
				<div class="exchangebox" style="width: 33%;">
					<div class="">
						<!-- 排行 -->
						<e:if condition="${e:length(br8in.list)>0  || e:length(brTop5.list)>=8}" var="check81">
							<ul class="ulrank">						
								<e:forEach items="${br8in.list }" var="br8inlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br8inlist.IMG_URL }" width="38" height="38">${br8inlist.brna }</h3>
											<p>销量：<span>${br8inlist.TERMINAL_NUM } 部</span></p>
											<p>占比：<span>${br8inlist.PROPOR_NUM }</span></p>
										</div>
									</li>
								</e:forEach>																	
							</ul>
						</e:if>
						<e:else condition="${check81}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
				<div class="exchangebox middle" style="width: 33%;">
					<e:if condition="${e:length(br8.list)>0  || e:length(brTop5.list)>=8 }" var="check82">
						<div class="arrow-left">${br8.list[0].IN_NUM } 部</div>
						<div class="brand"><img src="${br8.list[0].IMG_URL }" alt="iPhone"></div>
						<div class="arrow-right">${br8.list[0].OUT_NUM } 部</div>		
					</e:if>
					<e:else condition="${check82}">
					 	暂无数据！
					</e:else>
				</div>
				<div class="exchangebox" style="width: 33%;">
					<div class="exchange">
						<!-- 排行 --> 
						<e:if condition="${e:length(brTop5.list)>=8 || e:length(br8out.list)>0}" var="check83">
							<ul class="ulrank">
								<e:forEach items="${br8out.list }" var="br8outlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br8outlist.IMG_URL }" width="38" height="38">${br8outlist.brna }</h3>
											<p>销量：<span>${br8outlist.TERMINAL_NUM } 部</span></p>
											<p>占比：<span>${br8outlist.PROPOR_NUM }</span></p>
										</div>
									</li>
								</e:forEach>
							</ul>
						</e:if>
						<e:else condition="${check83}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
			</div>
			<!-- //品牌8 -->
			<!-- 品牌9 -->
			<div class="exchangearea exchangearea_new">
				<div class="exchangebox" style="width: 33%;">
					<div class="">
						<!-- 排行 -->
						<e:if condition="${e:length(br9in.list)>0  || e:length(brTop5.list)>=9}" var="check91">
							<ul class="ulrank">						
								<e:forEach items="${br9in.list }" var="br9inlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br9inlist.IMG_URL }" width="39" height="39">${br9inlist.brna }</h3>
											<p>销量：<span>${br9inlist.TERMINAL_NUM } 部</span></p>
											<p>占比：<span>${br9inlist.PROPOR_NUM }</span></p>
										</div>
									</li>
								</e:forEach>																	
							</ul>
						</e:if>
						<e:else condition="${check91}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
				<div class="exchangebox middle" style="width: 33%;">
					<e:if condition="${e:length(br9.list)>0  || e:length(brTop5.list)>=9 }" var="check92">
						<div class="arrow-left">${br9.list[0].IN_NUM } 部</div>
						<div class="brand"><img src="${br9.list[0].IMG_URL }" alt="iPhone"></div>
						<div class="arrow-right">${br9.list[0].OUT_NUM } 部</div>		
					</e:if>
					<e:else condition="${check92}">
					 	暂无数据！
					</e:else>
				</div>
				<div class="exchangebox" style="width: 33%;">
					<div class="exchange">
						<!-- 排行 --> 
						<e:if condition="${e:length(brTop5.list)>=9 || e:length(br9out.list)>0}" var="check93">
							<ul class="ulrank">
								<e:forEach items="${br9out.list }" var="br9outlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br9outlist.IMG_URL }" width="39" height="39">${br9outlist.brna }</h3>
											<p>销量：<span>${br9outlist.TERMINAL_NUM } 部</span></p>
											<p>占比：<span>${br9outlist.PROPOR_NUM }</span></p>
										</div>
									</li>
								</e:forEach>
							</ul>
						</e:if>
						<e:else condition="${check93}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
			</div>
			<!-- //品牌9 -->
			<!-- 品牌10 -->
			<div class="exchangearea exchangearea_new">
				<div class="exchangebox" style="width: 33%;">
					<div class="">
						<!-- 排行 -->
						<e:if condition="${e:length(br10in.list)>0  || e:length(brTop5.list)>=10}" var="check101">
							<ul class="ulrank">						
								<e:forEach items="${br10in.list }" var="br10inlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br10inlist.IMG_URL }" width="39" height="39">${br10inlist.brna }</h3>
											<p>销量：<span>${br10inlist.TERMINAL_NUM } 部</span></p>
											<p>占比：<span>${br10inlist.PROPOR_NUM }</span></p>
										</div>
									</li>
								</e:forEach>																	
							</ul>
						</e:if>
						<e:else condition="${check101}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
				<div class="exchangebox middle" style="width: 33%;">
					<e:if condition="${e:length(br10.list)>0  || e:length(brTop5.list)>=10 }" var="check102">
						<div class="arrow-left">${br10.list[0].IN_NUM } 部</div>
						<div class="brand"><img src="${br10.list[0].IMG_URL }" alt="iPhone"></div>
						<div class="arrow-right">${br10.list[0].OUT_NUM } 部</div>		
					</e:if>
					<e:else condition="${check102}">
					 	暂无数据！
					</e:else>
				</div>
				<div class="exchangebox" style="width: 33%;">
					<div class="exchange">
						<!-- 排行 --> 
						<e:if condition="${e:length(brTop5.list)>=10 || e:length(br10out.list)>0}" var="check103">
							<ul class="ulrank">
								<e:forEach items="${br10out.list }" var="br10outlist">
									<li>
										<span class="icon-exchange0${index+1 }">${index+1 }</span>
										<div class="txtrank">
											<h3><img src="${br10outlist.IMG_URL }" width="39" height="39">${br10outlist.brna }</h3>
											<p>销量：<span>${br10outlist.TERMINAL_NUM } 部</span></p>
											<p>占比：<span>${br10outlist.PROPOR_NUM }</span></p>
										</div>
									</li>
								</e:forEach>
							</ul>
						</e:if>
						<e:else condition="${check103}">
						 	暂无数据！
						</e:else>
						<!-- 排行 -->
					</div>
				</div>
			</div>
			<!-- //品牌10 -->
			
	</e:description>		
			
			
			<!-- //下 -->
		</div>
	  <!-- 历史换机 -->
	</div>	
</div>

<script type="text/javascript" src="<%=path %>/pages/terminal/resources/themes/base/js/main.js"></script>
  </body>
</html>
