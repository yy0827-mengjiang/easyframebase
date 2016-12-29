<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html>
<html>
<head>
<e:set var="start_month">${e:getDate('yyyyMM')}</e:set>
<e:if condition="${param.start_month!=''&&param.start_month!=null }">
	<e:set var="start_month">${param.start_month }</e:set>
</e:if>
<e:set var="stop_month">${e:getDate('yyyyMM')}</e:set>
<e:if condition="${param.stop_month!=''&&param.stop_month!=null }">
	<e:set var="stop_month">${param.stop_month }</e:set>
</e:if>
<e:set var="area_no">qg</e:set>
<e:if condition="${sessionScope.UserInfo.ADMIN == '1'}">
	<e:if condition="${param.area_no!=''&&param.area_no!=null }">
		<e:set var="area_no">${param.area_no }</e:set>
	</e:if>
</e:if>
<e:if
	condition="${sessionScope.UserInfo.ADMIN == '2' || sessionScope.UserInfo.ADMIN == '0' }">
	<e:set var="area_no">${sessionScope.UserInfo.AREA_NO}</e:set>
</e:if>
<e:set var="city_no">qxz</e:set>
<e:if condition="${param.city_no!=''&&param.city_no!=null }">
	<e:set var="city_no">${param.city_no }</e:set>
</e:if>
<e:q4l var="area"> 
	SELECT a."AREA_NAME" ,a."AREA_NO" FROM "DIM_AREA_NO" a  WHERE 1=1 AND a."AREA_NO" NOT IN ('0000')
	<e:if
		condition="${sessionScope.UserInfo.ADMIN == '2' || sessionScope.UserInfo.ADMIN == '0' }">
		AND a."AREA_NO"='${sessionScope.UserInfo.AREA_NO}'
	</e:if>
</e:q4l>
<e:description>品牌销量top5</e:description>
<e:q4l var="brTop5">
SELECT 
    B.b brno,
    B.bn brname,    
    "sum"(A ."TERMINAL_NUM") brsum
  FROM
    "DM_M_TERM_USER_CHANGE" A,(SELECT DISTINCT "BRAND_NO" b,"BRAND_NAME" bn FROM "TRMNL_DEVINFO") B
  WHERE
    1 = 1
  AND A ."BRAND_NO" = B.b
   AND    "ACCT_MONTH" BETWEEN  to_char(to_date('${start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${stop_month}','yyyymm'), 'yyyymm')
<e:if condition="${area_no!='qg' }"> 
 AND   "AREA_NO" = '${area_no}' 
<e:if condition="${city_no!='qxz' }">
AND "CITY_NO" = '${city_no}'
</e:if>
  </e:if> 
  GROUP BY brno,brname
  ORDER BY brsum DESC
  LIMIT 5
</e:q4l>




<e:forEach items="${brTop5.list}" var="brTop5list">
<e:description>品牌销量流入出总数</e:description>
<e:q4l var="br${index+1 }">
SELECT DISTINCT
  B.TERMINAL_NUM IN_NUM,
  C .IMG_URL IMG_URL,
  D.TERMINAL_NUM OUT_NUM,
  E.BRANDCHANGE_T  BRANDCHANGE_T
FROM
  (
    SELECT
      SUM ("TERMINAL_NUM") TERMINAL_NUM
    FROM
      "DM_M_TERM_USER_CHANGE"
    WHERE
      "BRAND_NO" = '${brTop5list.brno}'
    AND "IN_BRAND" != ''
    AND "IN_BRAND" IS NOT NULL
     AND    "ACCT_MONTH" BETWEEN  to_char(to_date('${start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${stop_month}','yyyymm'), 'yyyymm')
<e:if condition="${area_no!='qg' }"> 
 AND   "AREA_NO" = '${area_no}' 
<e:if condition="${city_no!='qxz' }">
AND "CITY_NO" = '${city_no}'
</e:if>
  </e:if> 
  ) B,
  (
    SELECT DISTINCT
      b."IMG_URL" IMG_URL
    FROM
      "DM_M_TERM_USER_CHANGE" A,
      "DIM_IMG_NO" b
    WHERE
      A ."BRAND_NO" = '${brTop5list.brno}'
    AND A ."IMG_NO" = b."IMG_NO"
    AND b."IMG_TYPE" = 'phonelogo'
  ) C,
  (
    SELECT
      SUM ("TERMINAL_NUM") TERMINAL_NUM
    FROM
      "DM_M_TERM_USER_CHANGE"
    WHERE
      "BRAND_NO" = '${brTop5list.brno}'
    AND "OUT_BRAND" != ''
    AND "OUT_BRAND" IS NOT NULL
      AND    "ACCT_MONTH" BETWEEN  to_char(to_date('${start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${stop_month}','yyyymm'), 'yyyymm')
<e:if condition="${area_no!='qg' }"> 
 AND   "AREA_NO" = '${area_no}' 
<e:if condition="${city_no!='qxz' }">
AND "CITY_NO" = '${city_no}'
</e:if>
  </e:if> 
  ) D,
(
SELECT DISTINCT "BRANDCHANGE_T"  BRANDCHANGE_T
FROM public."DM_M_TERM_USER_CHANGE" 
WHERE "BRAND_NO"  = '${brTop5list.brno}'   
) E

</e:q4l>
<e:description>品牌销量1流入Top3</e:description>
<e:q4l var="br${index+1 }in">
SELECT DISTINCT
  C .IMG_URL img_url,
  C .ter terminal_num,
  to_char(
    ROUND(C .ter / D.outnum, 4) * 100,
    '990.0'
  ) || '%' propor_num
FROM
  (
    SELECT
      SUM ("TERMINAL_NUM") outnum
    FROM
      "DM_M_TERM_USER_CHANGE"
    WHERE
      "BRAND_NO" = '${brTop5list.brno}'
    AND "IN_BRAND" != ''
    AND "IN_BRAND" IS NOT NULL
     AND    "ACCT_MONTH" BETWEEN  to_char(to_date('${start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${stop_month}','yyyymm'), 'yyyymm')
<e:if condition="${area_no!='qg' }"> 
 AND   "AREA_NO" = '${area_no}' 
<e:if condition="${city_no!='qxz' }">
AND "CITY_NO" = '${city_no}'
</e:if>
  </e:if>  
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
            "DM_M_TERM_USER_CHANGE" X,(SELECT DISTINCT "BRAND_NO" bn,"BRAND_NAME" bna FROM "TRMNL_DEVINFO") Y
          WHERE
            X."IN_BRAND" = Y.bn
          AND X."BRAND_NO" = '${brTop5list.brno}'
          AND X."IN_BRAND" != ''
          AND X."IN_BRAND" IS NOT NULL
          AND    "ACCT_MONTH" BETWEEN  to_char(to_date('${start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${stop_month}','yyyymm'), 'yyyymm')
<e:if condition="${area_no!='qg' }"> 
 AND   "AREA_NO" = '${area_no}' 
<e:if condition="${city_no!='qxz' }">
AND "CITY_NO" = '${city_no}'
</e:if>
  </e:if> 
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
              AND "BRAND_NO" IN (C.in_no)
              AND "IMG_TYPE" = 'phonelogo'
            )
      AND "IMG_TYPE" = 'phonelogo'
    )
  ) C
ORDER BY
  C .ter DESC
</e:q4l>
<e:description>品牌销量流出Top3</e:description>
<e:q4l var="br${index+1 }out">
SELECT DISTINCT
  C .IMG_URL img_url,
  C .ter terminal_num,
  to_char(
    ROUND(C .ter / D.outnum, 4) * 100,
    '990.0'
  ) || '%' propor_num
FROM
  (
      SELECT
        SUM ("TERMINAL_NUM") outnum
      FROM
        "DM_M_TERM_USER_CHANGE"
      WHERE
        "BRAND_NO" = '${brTop5list.brno}'
      AND "OUT_BRAND" != ''
      AND "OUT_BRAND" IS NOT NULL
       AND    "ACCT_MONTH" BETWEEN  to_char(to_date('${start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${stop_month}','yyyymm'), 'yyyymm')
<e:if condition="${area_no!='qg' }"> 
 AND   "AREA_NO" = '${area_no}' 
<e:if condition="${city_no!='qxz' }">
AND "CITY_NO" = '${city_no}'
</e:if>
  </e:if> 
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
            "DM_M_TERM_USER_CHANGE" X,(SELECT DISTINCT "BRAND_NO" bn,"BRAND_NAME" bna FROM "TRMNL_DEVINFO") Y
          WHERE
            X."OUT_BRAND" = Y.bn
          AND X."BRAND_NO" = '${brTop5list.brno}'
          AND X."OUT_BRAND" != ''
          AND X."OUT_BRAND" IS NOT NULL
          AND    "ACCT_MONTH" BETWEEN  to_char(to_date('${start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${stop_month}','yyyymm'), 'yyyymm')
<e:if condition="${area_no!='qg' }"> 
 AND   "AREA_NO" = '${area_no}' 
<e:if condition="${city_no!='qxz' }">
AND "CITY_NO" = '${city_no}'
</e:if>
  </e:if> 
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
            AND "BRAND_NO" IN (C.in_no)
            AND "IMG_TYPE" = 'phonelogo'
          )
      AND "IMG_TYPE" = 'phonelogo'
    )
  ) C
ORDER BY
  C .ter DESC
</e:q4l>
</e:forEach>



<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<c:resources type="easyui" />
<!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<!--声明以360极速模式进行渲染 -->
<meta name=”renderer” content=”webkit” />
<!--系统名称文本 -->
<title>终端指标分析系统－换机分析</title>
<!-- 系统ICON图标（注:路径为TomCat根目录） -->
<link rel="Shortcut Icon" href="" />
<script type="text/javascript"
	src='<e:url value="/pages/terminal/resources/themes/base/js/echarts.min.js"/>'></script>
<!--EasyUI1.5 Css层叠样式表 -->
<e:style value="/pages/terminal/resources/component/easyui/themes/metro/easyui.css" />
<e:style value="/pages/terminal/resources/component/easyui/themes/icon.css" />
<!-- 独立Js脚本 -->
<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/boncCommon.js"/>'></script>
<!-- 圆形统计图js -->
<script type="text/javascript"
	src='<e:url value="/pages/terminal/resources/themes/base/js/jquery.circliful.min.js"/>'></script>
<!-- 独立Css层叠样式表 -->
<e:style value="/pages/terminal/resources/themes/base/boncBase@links.css" />

<script type="text/javascript">
	//省份、地市级联 
	//省份、地市级联 操作
	function findCity(){
		$("#city").empty();
		$("#city").append("<option value='qxz'>--请选择--</option>");
		var AREA_NO = $("#area").val();
		$.post('<e:url value="/pages/terminal/common/cityAction.jsp"/>',{ AREA_NO: AREA_NO},function(data){
			var city =eval(data.trim());
	      	for(var i = 0;i<city.length;i++){
	 			$("#city").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
	 		}
	       });
	}   
	   //月份控件
     $(function () {
     		var mydate = new Date();
       	    var str = "" + mydate.getFullYear() + "-";
       	    str += (mydate.getMonth()+1);
       	    if('${param.acct_monthbefore}'==''){	
       	    	$('#acct_monthbefore').val(str);
       	    }else{
       	   		var varmonth='${param.acct_monthbefore}';
       	    	if(varmonth.length==5){
       	    		var month =varmonth.substr(0,4)+"-0"+varmonth.substr(4);
					$('#acct_monthbefore').val(month);
				}
				if(varmonth.length==6){
       	    		var month =varmonth.substr(0,4)+"-"+varmonth.substr(4,5);
					$('#acct_monthbefore').val(month);
				}
			}
            $('#acct_monthbefore').datebox({  
        	    editable:false ,
                onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层  
                    span.trigger('click'); //触发click事件弹出月份层  
                    if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔  
                        tds = p.find('div.calendar-menu-month-inner td');  
                        tds.click(function (e) {  
                            e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件  
                            var year = /\d{4}/.exec(span.html())[0]//得到年份  
                                    , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1  
                            $('#acct_monthbefore').datebox('hidePanel')//隐藏日期对象  
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
            var p = $('#acct_monthbefore').datebox('panel'), //日期选择对象  
                    tds = false, //日期选择对象中月份  
                    span = p.find('span.calendar-text'); //显示月份层的触发控件              
        });  

    	$(function () {
    		var mydate = new Date();
       	    var str = "" + mydate.getFullYear() + "-";
       	    str += (mydate.getMonth()+1);
       	 	if('${param.acct_monthbefore}'==''){	
       	   		$("#acct_month").val(str);
       	 	}else{
        	    var varmonth='${param.acct_month}';
           	    if(varmonth.length==5){
           	    	var month =varmonth.substr(0,4)+"-0"+varmonth.substr(4);
    				$('#acct_month').val(month);
    			}
    			if(varmonth.length==6){
           	    	var month =varmonth.substr(0,4)+"-"+varmonth.substr(4,5);
    				$('#acct_month').val(month);
    			}
   			} 
            $('#acct_month').datebox({  
        	    editable:false ,
                onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层  
                    span.trigger('click'); //触发click事件弹出月份层  
                    if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔  
                        tds = p.find('div.calendar-menu-month-inner td');  
                        tds.click(function (e) {  
                            e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件  
                            var year = /\d{4}/.exec(span.html())[0]//得到年份  
                                    , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1  
                            $('#acct_month').datebox('hidePanel')//隐藏日期对象  
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
            var p = $('#acct_month').datebox('panel'), //日期选择对象  
                    tds = false, //日期选择对象中月份  
                    span = p.find('span.calendar-text'); //显示月份层的触发控件              
        }); 
	
		$(function(){
   //alert('${sessionScope.UserInfo.CITY_NO}');
			$($(".tabs li")[1]).click(function(){

				location.href='<e:url value="/pages/terminal/exchange/estimate.jsp"/>'

			})
			$($(".tabs li")[2]).click(function(){

				location.href='<e:url value="/pages/terminal/exchange/estimation.jsp"/>'
			})
			
			   if('${sessionScope.UserInfo.ADMIN}'!='1'){
			        $('#area option[value="qg"]').remove();
			      // $("#area").val("${area_no}");
			        }			
						$("#area").val("${area_no}");
				 		//alert($("#area").val());
						$("#city").empty();
						$("#city").append("<option value='qxz'>--请选择--</option>");
						var AREA_NO = $("#area").val();
						$.post('<e:url value="/pages/terminal/common/cityAction.jsp"/>',{ AREA_NO: AREA_NO},function(data){
							var city =eval(data.trim());
					      	for(var i = 0;i<city.length;i++){
					 			$("#city").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
					 		}
					 		$("#city").val("${param.city_no}");
					    });

		})
		
		

		 function doSearch(){   	
    	    var start_month= $('#start').datebox('getValue').replace("-", "");
    	    var stop_month=$('#stop').datebox('getValue').replace("-", "");
    	   if(start_month.length==5){
    		   var start_month =start_month.substr(0,4)+"0"+start_month.substr(4);
    	   }
    	   if(stop_month.length==5){
    		   var stop_month =stop_month.substr(0,4)+"0"+stop_month.substr(4);
    	   }   	  
    	    var area_no=$('#area').val();
    	    var city_no=$('#city').val();
    	  if(parseInt(stop_month) >= parseInt(start_month)){
    		window.location.href='<e:url value='/pages/terminal/exchange/exchange.jsp'/>?start_month='+start_month+'&stop_month='+stop_month+'&area_no='+area_no+'&city_no='+city_no;	
    	  }else {
    		   alert("请您选择正确的时间间隔！！！");
    		   
    	  }
    	}
    	
	</script>
<script language="JavaScript">
        $(function(){
        $(".EntryGroupLine input").bind("hover focus", function() {
            $(this).parent('.EntryGroupLine').addClass('onFocus');
            $(this).parent('.EntryGroupLine').parent('.EntryBox').siblings('.EntryBox').find('.EntryGroupLine').removeClass('onFocus')
            });
            })   
    </script>


</head>
<body>
	<div id="boncEntry">


		<!-- 查询条件 -->
		<div class="searchbox">
			<span class="spantext">省级</span> <select name="state"
				style="width: 150px;" id="area" onchange="findCity();">
				<option value="qg">全国</option>
				<e:forEach items="${area.list}" var="item">
					<option value="${item.AREA_NO }">${item.AREA_NAME }</option>
				</e:forEach>
			</select> <span class="spantext">地市</span> <select name="state"
				style="width: 150px;" id="city">
			</select> <span class="spantext">时间</span><input id="acct_monthbefore"
			required="true" /> <span class="spantext">至</span><input
			id="acct_month" required="true" /> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				data-options="iconCls:'icon-search'" style="width: 85px"
				onclick="doSearch()">查询</a>
		</div>
		<!-- //查询条件 -->

		<div class="exchangearea">
			<!-- 标题 -->
			<h2 style="width: 33%;">转入组成份额占比</h2>
			<h2 style="width: 33%;">
				<span class="into">换入</span><span>品牌<br /> <em>（销量TOP5）</em></span><span
					class="out">换出</span>
			</h2>
			<h2 style="width: 34%;">转出组成份额占比</h2>
			<!-- //标题 -->
		</div>
		<!-- 品牌1 -->
		<div class="exchangearea">
			<div class="exchangebox" style="width: 33%;">
				<div class="">
					<!-- 排行 -->
  <e:if condition="${e:length(br1in.list)>0 || e:length(brTop5.list) >= 1}" var="check11">  
					<ul class="ulrank">
						<e:forEach items="${br1in.list}" var="item">
							<li><span class="icon-exchange0${index+1}">${index+1}</span>
								<div class="txtrank">
									<img width="36" height="36"
										src='<e:url value="${item.img_url}"/>' />
									<p>
										销量：<span>${item.terminal_num}</span>
									</p>
									<p>
										占比：<span>${item.propor_num}</span>
									</p>
								</div></li>
						</e:forEach>
					</ul>
  </e:if>
  <e:else condition="${check11}">
                暂无数据！
  </e:else> 
					<!-- 排行 -->
				</div>
			</div>
			<div class="exchangebox middle" style="width: 33%;">
			<e:if condition="${e:length(br1.list)>0 || e:length(brTop5.list) >= 1}" var="check12">
      	<e:forEach items="${br1.list}" var="item">
					<div class="arrow-left">${item.in_num}</div>
					<div class="brand">
						<img src='<e:url value="${item.img_url}"/>' />
					</div>
					<div class="arrow-right">${item.out_num}</div>
					<div class="cycle" style="margin-top: 0px">
						<p>${item.BRANDCHANGE_T }<span>个月</span>
						</p>
						<h3>换机周期</h3>
					</div>
				</e:forEach>
        </e:if>
        <e:else condition="${check12}">
                 暂无数据！
            </e:else>   
			</div>
			<div class="exchangebox" style="width: 33%;">
				<div class="exchange">
					<!-- 排行 -->
        <e:if condition="${e:length(br1out.list)>0 || e:length(brTop5.list) >= 1}" var="check13"> 
					<ul class="ulrank">
						<e:forEach items="${br1out.list}" var="item">
							<li><span class="icon-exchange0${index+1}">${index+1}</span>
								<div class="txtrank">
									<img width="36" height="36"
										src='<e:url value="${item.img_url}"/>' />
									<p>
										销量：<span>${item.terminal_num}</span>
									</p>
									<p>
										占比：<span>${item.propor_num}</span>
									</p>
								</div></li>
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
		<!-- //品牌1 -->

 <!-- //品牌2 -->   
<div class="exchangearea">
      <div class="exchangebox" style="width: 33%;">
        <div class="">
          <!-- 排行 -->
  <e:if condition="${e:length(br2in.list)>0 || e:length(brTop5.list) >= 1}" var="check21">  
          <ul class="ulrank">
            <e:forEach items="${br2in.list}" var="item">
              <li><span class="icon-exchange0${index+1}">${index+1}</span>
                <div class="txtrank">
                  <img width="36" height="36"
                    src='<e:url value="${item.img_url}"/>' />
                  <p>
                    销量：<span>${item.terminal_num}</span>
                  </p>
                  <p>
                    占比：<span>${item.propor_num}</span>
                  </p>
                </div></li>
            </e:forEach>
          </ul>
  </e:if>
  <e:else condition="${check21}">
                暂无数据！
  </e:else> 
          <!-- 排行 -->
        </div>
      </div>
      <div class="exchangebox middle" style="width: 33%;">
      <e:if condition="${e:length(br2.list)>0 || e:length(brTop5.list) >= 1}" var="check22">
        <e:forEach items="${br2.list}" var="item">
          <div class="arrow-left">${item.in_num}</div>
          <div class="brand">
            <img src='<e:url value="${item.img_url}"/>' />
          </div>
          <div class="arrow-right">${item.out_num}</div>
          <div class="cycle" style="margin-top: 0px">
            <p>${item.BRANDCHANGE_T }<span>个月</span>
            </p>
            <h3>换机周期</h3>
          </div>
        </e:forEach>
        </e:if>
        <e:else condition="${check22}">
                 暂无数据！
            </e:else>   
      </div>
      <div class="exchangebox" style="width: 33%;">
        <div class="exchange">
          <!-- 排行 -->
        <e:if condition="${e:length(br2out.list)>0 || e:length(brTop5.list) >= 1}" var="check23"> 
          <ul class="ulrank">
            <e:forEach items="${br2out.list}" var="item">
              <li><span class="icon-exchange0${index+1}">${index+1}</span>
                <div class="txtrank">
                  <img width="36" height="36"
                    src='<e:url value="${item.img_url}"/>' />
                  <p>
                    销量：<span>${item.terminal_num}</span>
                  </p>
                  <p>
                    占比：<span>${item.propor_num}</span>
                  </p>
                </div></li>
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


<!-- //品牌3 -->   
<div class="exchangearea">
      <div class="exchangebox" style="width: 33%;">
        <div class="">
          <!-- 排行 -->
  <e:if condition="${e:length(br3in.list)>0 || e:length(brTop5.list) >= 1}" var="check31">  
          <ul class="ulrank">
            <e:forEach items="${br3in.list}" var="item">
              <li><span class="icon-exchange0${index+1}">${index+1}</span>
                <div class="txtrank">
                  <img width="36" height="36"
                    src='<e:url value="${item.img_url}"/>' />
                  <p>
                    销量：<span>${item.terminal_num}</span>
                  </p>
                  <p>
                    占比：<span>${item.propor_num}</span>
                  </p>
                </div></li>
            </e:forEach>
          </ul>
  </e:if>
  <e:else condition="${check31}">
                暂无数据！
  </e:else> 
          <!-- 排行 -->
        </div>
      </div>
      <div class="exchangebox middle" style="width: 33%;">
      <e:if condition="${e:length(br3.list)>0 || e:length(brTop5.list) >= 1}" var="check32">
        <e:forEach items="${br3.list}" var="item">
          <div class="arrow-left">${item.in_num}</div>
          <div class="brand">
            <img src='<e:url value="${item.img_url}"/>' />
          </div>
          <div class="arrow-right">${item.out_num}</div>
          <div class="cycle" style="margin-top: 0px">
            <p>${item.BRANDCHANGE_T }<span>个月</span>
            </p>
            <h3>换机周期</h3>
          </div>
        </e:forEach>
        </e:if>
        <e:else condition="${check32}">
                 暂无数据！
            </e:else>   
      </div>
      <div class="exchangebox" style="width: 33%;">
        <div class="exchange">
          <!-- 排行 -->
        <e:if condition="${e:length(br3out.list)>0 || e:length(brTop5.list) >= 1}" var="check33"> 
          <ul class="ulrank">
            <e:forEach items="${br3out.list}" var="item">
              <li><span class="icon-exchange0${index+1}">${index+1}</span>
                <div class="txtrank">
                  <img width="36" height="36"
                    src='<e:url value="${item.img_url}"/>' />
                  <p>
                    销量：<span>${item.terminal_num}</span>
                  </p>
                  <p>
                    占比：<span>${item.propor_num}</span>
                  </p>
                </div></li>
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

<!-- //品牌4 -->   
<div class="exchangearea">
      <div class="exchangebox" style="width: 33%;">
        <div class="">
          <!-- 排行 -->
  <e:if condition="${e:length(br4in.list)>0 || e:length(brTop5.list) >= 1}" var="check41">  
          <ul class="ulrank">
            <e:forEach items="${br4in.list}" var="item">
              <li><span class="icon-exchange0${index+1}">${index+1}</span>
                <div class="txtrank">
                  <img width="36" height="36"
                    src='<e:url value="${item.img_url}"/>' />
                  <p>
                    销量：<span>${item.terminal_num}</span>
                  </p>
                  <p>
                    占比：<span>${item.propor_num}</span>
                  </p>
                </div></li>
            </e:forEach>
          </ul>
  </e:if>
  <e:else condition="${check41}">
                暂无数据！
  </e:else> 
          <!-- 排行 -->
        </div>
      </div>
      <div class="exchangebox middle" style="width: 33%;">
      <e:if condition="${e:length(br4.list)>0 || e:length(brTop5.list) >= 1}" var="check42">
        <e:forEach items="${br4.list}" var="item">
          <div class="arrow-left">${item.in_num}</div>
          <div class="brand">
            <img src='<e:url value="${item.img_url}"/>' />
          </div>
          <div class="arrow-right">${item.out_num}</div>
          <div class="cycle" style="margin-top: 0px">
            <p>${item.BRANDCHANGE_T }<span>个月</span>
            </p>
            <h3>换机周期</h3>
          </div>
        </e:forEach>
        </e:if>
        <e:else condition="${check42}">
                 暂无数据！
            </e:else>   
      </div>
      <div class="exchangebox" style="width: 33%;">
        <div class="exchange">
          <!-- 排行 -->
        <e:if condition="${e:length(br4out.list)>0 || e:length(brTop5.list) >= 1}" var="check43"> 
          <ul class="ulrank">
            <e:forEach items="${br4out.list}" var="item">
              <li><span class="icon-exchange0${index+1}">${index+1}</span>
                <div class="txtrank">
                  <img width="36" height="36"
                    src='<e:url value="${item.img_url}"/>' />
                  <p>
                    销量：<span>${item.terminal_num}</span>
                  </p>
                  <p>
                    占比：<span>${item.propor_num}</span>
                  </p>
                </div></li>
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


<!-- //品牌5 -->   
<div class="exchangearea">
      <div class="exchangebox" style="width: 33%;">
        <div class="">
          <!-- 排行 -->
  <e:if condition="${e:length(br5in.list)>0 || e:length(brTop5.list) >= 1}" var="check51">  
          <ul class="ulrank">
            <e:forEach items="${br5in.list}" var="item">
              <li><span class="icon-exchange0${index+1}">${index+1}</span>
                <div class="txtrank">
                  <img width="36" height="36"
                    src='<e:url value="${item.img_url}"/>' />
                  <p>
                    销量：<span>${item.terminal_num}</span>
                  </p>
                  <p>
                    占比：<span>${item.propor_num}</span>
                  </p>
                </div></li>
            </e:forEach>
          </ul>
  </e:if>
  <e:else condition="${check51}">
                暂无数据！
  </e:else> 
          <!-- 排行 -->
        </div>
      </div>
      <div class="exchangebox middle" style="width: 33%;">
      <e:if condition="${e:length(br5.list)>0 || e:length(brTop5.list) >= 1}" var="check52">
        <e:forEach items="${br5.list}" var="item">
          <div class="arrow-left">${item.in_num}</div>
          <div class="brand">
            <img src='<e:url value="${item.img_url}"/>' />
          </div>
          <div class="arrow-right">${item.out_num}</div>
          <div class="cycle" style="margin-top: 0px">
            <p>${item.BRANDCHANGE_T }<span>个月</span>
            </p>
            <h3>换机周期</h3>
          </div>
        </e:forEach>
        </e:if>
        <e:else condition="${check52}">
                 暂无数据！
            </e:else>   
      </div>
      <div class="exchangebox" style="width: 33%;">
        <div class="exchange">
          <!-- 排行 -->
        <e:if condition="${e:length(br5out.list)>0 || e:length(brTop5.list) >= 1}" var="check53"> 
          <ul class="ulrank">
            <e:forEach items="${br5out.list}" var="item">
              <li><span class="icon-exchange0${index+1}">${index+1}</span>
                <div class="txtrank">
                  <img width="36" height="36"
                    src='<e:url value="${item.img_url}"/>' />
                  <p>
                    销量：<span>${item.terminal_num}</span>
                  </p>
                  <p>
                    占比：<span>${item.propor_num}</span>
                  </p>
                </div></li>
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
    <!-- //品牌5-->





		

	</div>

	<script type="text/javascript"
		src='<e:url value="/pages/terminal/resources/themes/base/js/main.js"/>'></script>


</body>
</html>
