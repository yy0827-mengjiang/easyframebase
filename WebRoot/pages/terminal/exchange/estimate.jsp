<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE html>
<html>
<head>
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
<e:set var="acct_month">${e:getDate('yyyyMM')}</e:set>
<e:q4l var="time">
SELECT "ACCT_MONTH" acct_month
FROM public."DM_M_TERM_MARKET_SALES" 
WHERE  "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '-5' month, 'yyyymm') 
AND to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+3' month, 'yyyymm')
GROUP BY acct_month
ORDER BY acct_month
</e:q4l>
<e:description>年龄</e:description>
<e:q4l var="age"> 
    SELECT  "AGE_NAME" age_name ,SUM("TERMINAL_NUM") a
   FROM public."DIM_AGE_PASSAGE" Q , public."DM_M_TERM_MARKET_MAIN"  W  
   WHERE Q."AGE_NO" = W."AGE_NO" AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+1' month, 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+3' month, 'yyyymm')
<e:if condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if condition="${city_no!='qxz'}">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	</e:if> 
   GROUP BY "AGE_NAME" 
   order by "AGE_NAME"
   </e:q4l>
<e:description>性别</e:description>
<e:q4l var="sex">
   (SELECT  '男'  sex ,count("SEX")  sex_num
FROM public."DM_M_TERM_MARKET_MAIN" 
WHERE "SEX" = '男' 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+1' month, 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+3' month, 'yyyymm')
<e:if condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if condition="${city_no!='qxz'}">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	</e:if> 
) UNION ALL 
(SELECT  '女'  sex ,count("SEX") sex_num
FROM public."DM_M_TERM_MARKET_MAIN" 
WHERE "SEX" = '女' 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+1' month, 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+3' month, 'yyyymm')
<e:if condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if condition="${city_no!='qxz'}">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	</e:if> 
)
   </e:q4l>
<e:description>合约</e:description>
<e:q4l var="heyue"> 
   SELECT "CONTRACT_NAME" cuntract_name, SUM("TERMINAL_NUM") terminal_num
  FROM public."DM_M_TERM_MARKET_CONTRACT" A, public."DIM_CONTRACT_NO" B
WHERE A."CONTRACT_NO" = B."CONTRACT_NO" AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+1' month, 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+3' month, 'yyyymm')
<e:if condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if condition="${city_no!='qxz'}">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	</e:if> 
GROUP BY cuntract_name 
</e:q4l>
<e:description>星级</e:description>
<e:q4l var="star"> 
  SELECT "STAT_NAME" stat_name ,SUM("TERMINAL_NUM") terminal 
  FROM public."DM_M_TERM_MARKET_START" A ,public."DIM_START_NO" B
  WHERE A."STAR_NO" = B."STAR_NO" AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+1' month, 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+3' month, 'yyyymm')
<e:if condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if condition="${city_no!='qxz'}">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	</e:if> 
  GROUP BY stat_name  ,"ORD"
  ORDER BY "ORD"
  </e:q4l>
<e:description>ARPU</e:description>
<e:q4l var="arpu"> 
SELECT  "ARPU_NAME" arpu_name,sum("TERMINAL_NUM") terminal_num
  FROM public."DM_M_TERM_MARKET_ARPU" A , public."DIM_ARPU_NO" B 
  WHERE A."ARPU_NO" = B."ARPU_NO" AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+1' month, 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+3' month, 'yyyymm')
<e:if condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if condition="${city_no!='qxz'}">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	</e:if> 
 GROUP BY  arpu_name  ,"SORT_NO"
 ORDER BY "SORT_NO" 
  </e:q4l>
<e:description>套餐</e:description>
<e:q4l var="meal">
 SELECT  "MEAL_NAME" office_name,sum("TERMINAL_NUM") terminal_num
  FROM public."DM_M_TERM_MARKET_OFFICE" A , public."DIM_OFFICE_NO" B 
  WHERE A."OFFICE_NO" = B."MEAL_NO" 
  AND B."IS_MEAL" = '0'
  AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+1' month, 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+3' month, 'yyyymm')
<e:if condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if condition="${city_no!='qxz'}">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	</e:if> 
 GROUP BY  office_name   
  </e:q4l>
<e:description>终端</e:description>
<e:q4l var="zhongduan"> 
	SELECT "IMG_URL" IMG_URL , SUM("TERMINAL_NUM") TERMINAL_NUM 
FROM public."DM_M_TERM_MARKET_USER" a ,public."DIM_IMG_NO" b
WHERE a."IMG_NO" = b."IMG_NO" AND a."IMG_TYPE" = b."IMG_TYPE" 
AND "ACCT_MONTH" BETWEEN  to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+1' month, 'yyyymm') AND to_char(to_date('${acct_month}','yyyymm')+INTERVAL '+3' month, 'yyyymm')
<e:if condition="${area_no!='qg' }">
     AND 	 "AREA_NO" = '${area_no}' 
     <e:if condition="${city_no!='qxz'}">
      AND "CITY_NO" = '${city_no}'
  	 </e:if>
	</e:if> 
GROUP BY IMG_URL 
ORDER BY TERMINAL_NUM DESC LIMIT 5
</e:q4l>
<a:base />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<c:resources type="easyui highchart" style="b" />

<!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<!--声明以360极速模式进行渲染 -->
<meta name=”renderer” content=”webkit” />
<!--系统名称文本 -->
<title>终端指标分析系统－换机分析</title>
<!-- 系统ICON图标（注:路径为TomCat根目录） -->
<link rel="Shortcut Icon" href="" />
<!--EasyUI1.5 Js脚本 -->
<!--EasyUI1.5 Css层叠样式表 -->
<!--EasyUI1.5 Css层叠样式表 -->
<!-- 独立Js脚本 -->
<script type="text/javascript"
	src='<e:url value="/pages/terminal/resources/themes/base/js/boncCommon.js"/>'></script>
<!-- 圆形统计图js -->
<script type="text/javascript"
	src='<e:url value="/pages/terminal/resources/themes/base/js/jquery.circliful.min.js"/>'></script>
<script type="text/javascript"
	src='<e:url value="/pages/terminal/resources/themes/base/js/echarts.min.js"/>'></script>
<!-- 独立Css层叠样式表 -->
<e:style
	value="/pages/terminal/resources/themes/base/boncBase@links.css" />
<style type="text/css">
#age rect {
	fill: #f3f8fb
}

#sex rect {
	fill: #f3f8fb
}

#heyue1 rect {
	fill: #f3f8fb
}

#columnline rect {
	fill: #f3f8fb !important;
}

#columnline .highcharts-series>rect {
	fill: #7cb5ec !important
}

#star rect {
	fill: #f3f8fb !important;
}

#star	.highcharts-series>rect {
	fill: #7cb5ec !important
}

#meal1 rect {
	fill: #f3f8fb !important;
}

#meal1	.highcharts-series>rect {
	fill: #7cb5ec !important
}
</style>

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
        	$(function(){

    			$($(".tabs li")[0]).click(function(){
                      
    				location.href='<e:url value="/pages/terminal/exchange/exchange.jsp"/>'

    			})
    			$($(".tabs li")[2]).click(function(){

    				location.href='<e:url value="/pages/terminal/exchange/estimation.jsp"/>'

    			})
    			//alert();
    			 if('${sessionScope.UserInfo.ADMIN}'!='1'){
 			        $('#area option[value="qg"]').remove();
 			        }
 				 		$("#area").val("${area_no}");
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
    			 change(1); 			
        })
        
        function change(val,time){
    	 			    //alert("change");
    	 			    var index = ' ';
    	        		var info={};
    	        	    info.area_no= '${area_no }';   //${area_no }   ;                   //$('#area').val();
    	        	   // info.city_no= '${city_no }';   //${city_no }   ;                  //$('#city').val();
    	        	if(val == 1){
   	        	    	 info.index = 'ZL_NUM';
   	        	    	 $(".hspan").removeClass("onup");
   	        	    	 $($(".hspan")[0]).addClass("onup");
   	        	    }
   	        	    if(val == 2){
   	        	    	 info.index = 'HZ_NUM';
   	        	    	 $(".hspan").removeClass("onup");
   	        	    	 $($(".hspan")[1]).addClass("onup");
   	        	    }
   	        	    if(val == 3){
   	        	    	 info.index = 'TS_NUM';
   	        	    	 $(".hspan").removeClass("onup");
   	        	    	 $($(".hspan")[2]).addClass("onup");
   	        	    }
    	        	    info.eaction = 1
    	        	    info.acct_month = ${acct_month}
    	 				$.post('<e:url value="/pages/terminal/exchange/exchangeAction.jsp"/>',info,function(data){	
    	 					//alert("post");
							var dataJson=$.parseJSON(data);	    						
    	     				var series1=[];  	
    	     				var series2=[];
    	     				var series3=[];
    	     				var series4=[];  	
    	     				var series5=[];
    	     				var series6=[];
    	     				for(var b=0 ;b<5;b++){
    	     					series4.push({
    								value: ''
    				 			});
    	     					series5.push({
    								value: ''
    				 			});
    	     					series6.push({
    								value: ''
    				 			});
    	     				}	
    	     				
    	        			for(var a=0;a<dataJson.length;a++){
    	        				if(dataJson[a]["islev"] == 1){	
    	        						series1.push({
	        								value: dataJson[a]["x"]
	        				 			});
    	        				
    	        					}
    	        				if(dataJson[a]["islev"] == 2){
    	        						series2.push({
    	        							value: dataJson[a]["x"]
	        				 			});
    	        					}
    	        				if(dataJson[a]["islev"] == 3){
    	        						series3.push({
    	        							value: dataJson[a]["x"]
	        				 			});
    	        					} 
    	        				if(dataJson[a]["islev"] == 4){
	        						series4.push({
	        							value: dataJson[a]["x"]
        				 			});
	        					
	        						}
	        				    if(dataJson[a]["islev"] == 5){
	        						series5.push({
	        							value: dataJson[a]["x"]
        				 				});
	        						} 
	        				    if(dataJson[a]["islev"] == 6){
	        						series6.push({
	        							value: dataJson[a]["x"]
        				 			});
	        					}  				
    	        			}   
    	        		sanji(series1,series2,series3,series4,series5,series6);   	        		
    	        	});
}
  
        	
        	
        	
        	 function  sanji(b,c,d,e,f,g){     	   
           	  //alert();
        		 var time=[];
	    			var dataJson2=$.parseJSON('${e:java2json(time.list)}');
	    			for(var a=0;a<dataJson2.length;a++){
	    				time.push({
	    					value: dataJson2[a]["acct_month"]
	    	 			});					
	    			}
           	   var myChart = echarts.init(document.getElementById('sanji'));
                  myChart.setOption(option = {
                		 
                		    title : {
                		        text: '',
                		        subtext: ''
                		    },
                		    tooltip : {
                		        trigger: 'axis'
                		    },
                		    legend: {
                		    	show:false,
                		        data:['一级','二级','三级']
                		    },
                		    toolbox: {
                		      
                		       
                		    },
                		    calculable : true,
                		    xAxis : [
                		        {
                		            type : 'category',
                		            boundaryGap : false,
                		            data : time
                		        }
                		    ],
                		    yAxis : [
                		        {
                		            type : 'value'
                		        }
                		    ],
                		    series : [
                		        {
                		            name:'一级',
                		            type:'line',
                		            smooth:true,
                		            itemStyle: {normal: {areaStyle: {type: 'default'}}},
                		            data:b
                		        },
                		        {
                		            name:'二级',
                		            type:'line',
                		            smooth:true,
                		            itemStyle: {normal: {areaStyle: {type: 'default'}}},
                		            data:c
                		        },
                		        {
                		            name:'三级',
                		            type:'line',
                		            smooth:true,
                		            itemStyle: {normal: {areaStyle: {type: 'default'}}},
                		            data:d
                		        },
                		       {
                		         itemStyle:{
                		           normal:{
                		             lineStyle:{
                		             type:'dotted'
                		             }
                		           }
                		         },
                		            name:'一级',
                		            type:'line',
                		            smooth:false,
                		           
                		           data:e
                		        },
                		        {
                		        	itemStyle:{
                     		           normal:{
                     		             lineStyle:{
                     		             type:'dotted'
                     		             }
                     		           }
                     		         },
                		            name:'二级',
                		            type:'line',
                		            smooth:false,
                		           
                		            data:f
                		        },
                		       {
                		         itemStyle:{
                		           normal:{
                		             lineStyle:{
                		             type:'dotted'
                		             }
                		           }
                		         },
                		            name:'三级',
                		            type:'line',
                		            smooth:false,
                		           
                		           data:g
                		        }
                		    ]
                		});
          	myChart.hideLoading();		  
              }
        
        
        	  
             function doSearch(){   	      	  
         	    var area_no=$('#area').val();
         	    //    alert(area_no);
         	    var city_no=$('#city').val();
         	    //   alert(city_no);
         	
         	 
         		window.location.href='<e:url value='/pages/terminal/exchange/estimate.jsp'/>?area_no='+area_no+'&city_no='+city_no;	
         	 
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
			</select> <a href="javascript:void(0)" class="easyui-linkbutton"
				data-options="iconCls:'icon-search'" style="width: 80px"
				onclick="doSearch()">查询</a>
		</div>
		<!-- //查询条件 -->
		<!-- 市场预估 -->
		<div class="userarea">
			<div class="exchangebox" style="width: 29%;">
				<div class="userbox">
					<h2>
						年龄<span>（单位：岁）</span>
					</h2>
					<!-- charts图表预留位置 -->
					<div class="charts">
						<e:if condition="${e:length(age.list)<=0}" var="list1">
					暂无数据
					</e:if>
						<e:else condition="${list1 }">
							<c:npie id="age"  distance="1" width="430px" height="210px" title="" unit=""
								backgroundColor="#F3F8FB" a="数量" showexport="false"
								dimension="age_name" percentage="false" tipfmt="1"
								items="${age.list}" />
						</e:else>
					</div>
					<!-- //charts图表预留位置 -->
				</div>
				<div class="userbox">
					<h2>性别</h2>
					<!-- charts图表预留位置 -->
					<div class="charts">
						<e:if condition="${e:length(sex.list)<=0}" var="list2">
					暂无数据！
					</e:if>
						<e:else condition="${list2 }">
							<c:npie id="sex" distance="1" width="440px" height="200px" title="" unit=""
								backgroundColor="#F3F8FB" sex_num="数量" showexport="false"
								dimension="sex" percentage="false" tipfmt="1"
								items="${sex.list}" />
						</e:else>


					</div>
					<!--     //charts图表预留位置  -->
				</div>
			</div>
			<div class="exchangebox market" style="width: 41%;">

				<h2>三级市场（销量）</h2>
				<span><a href="javascript:void(0)" class="hspan"
					onclick="change(1)">战略机型</a></span> <span><a
					href="javascript:void(0)" class="hspan" onclick="change(2)">特色终端</a></span>
				<span><a href="javascript:void(0)" class="hspan"
					onclick="change(3)">合作品牌</a></span>

				<!-- charts图表预留位置 -->
				<div class="charts" id="sanji" style="width: 550px; height: 430px">

				</div>
				<!-- //charts图表预留位置 -->

			</div>
			<div class="exchangebox" style="width: 29%;">
				<div class="userbox">
					<h2>终端</h2>
					<!-- 排行 -->
					<ul class="ulrank">
						<e:if condition="${e:length(zhongduan.list)<=0}" var="list3">
					暂无数据
					</e:if>
						<e:else condition="${list3 }">
							<e:forEach items="${zhongduan.list}" var="item">
								<li><e:if condition="${index } == 0">
										<span class="icon-first">${index+1 }</span>
									</e:if> <e:if condition="${index } == 1">
										<span class="icon-second">${index+1 }</span>
									</e:if> <e:if condition="${index } == 2">
										<span class="icon-third">${index+1 }</span>
									</e:if> <e:if condition="${index } == 3">
										<span class="icon-other">${index+1 }</span>
									</e:if> <e:if condition="${index } == 4">
										<span class="icon-other">${index+1 }</span>
									</e:if>
									<div class="txtrank">
										<p>
											<img width="36" height="36"
												src='<e:url value="${item.img_url}"/>' />
										</p>
										<p>
											销量：<span>${item.terminal_num}</span>
										</p>
									</div></li>
							</e:forEach>
						</e:else>
					</ul>
					<!-- 排行 -->
				</div>
				<div class="userbox">
					<h2>星级</h2>
					<!-- charts图表预留位置 -->
					<div class="charts">
						<e:if condition="${e:length(star.list)<=0}" var="list4">
					暂无数据
					</e:if>
						<e:else condition="${list4 }">
							<c:ncolumnline id="star" width="416px" height="195px"
								yaxis="title:,unit:" backgroundColor="#F3F8FB"
								terminal="name:数量  ,type:column" showexport="false"
								dimension="stat_name" items="${star.list}" title=" "
								legend="false" dataLabel="true" fontsize="10px" rotation="0" />
						</e:else>
					</div>
					<!-- //charts图表预留位置 -->
				</div>
			</div>
		</div>
		<div class="userarea">
			<div class="userbox" style="width: 29%;">
				<h2>合约</h2>
				<!-- charts图表预留位置 -->
				<div class="charts">
					<e:if condition="${e:length(heyue.list)<=0}" var="list5">
				暂无数据
				</e:if>
					<e:else condition="${list5 }">
						<c:npie id="heyue1" distance="1" width="410" height="203px" showexport="false"
							title="" unit="" terminal_num="数量" dimension="cuntract_name"
							backgroundColor="#F3F8FB" percentage="false" tipfmt="1"
							items="${heyue.list}" />
					</e:else>
				</div>
				<!-- //charts图表预留位置 -->
			</div>
			<div class="userbox" style="width: 41%;">
				<h2>ARPU</h2>
				<!-- charts图表预留位置 -->
				<div class="charts">
					<e:if condition="${e:length(arpu.list)<=0}" var="list6">
				暂无数据
				</e:if>
					<e:else condition="${list6 }">
						<c:ncolumnline id="columnline" width="450px" height="190px"
							yaxis="title:,unit:" backgroundColor="#F3F8FB" showexport="false"
							terminal_num="name:ARPU值,type:column" dimension="arpu_name"
							items="${arpu.list}" title=" " legend="false" dataLabel="true"
							fontsize="10px" rotation="0" />
					</e:else>
				</div>
				<!-- //charts图表预留位置 -->
			</div>
			<div class="userbox" style="width: auto">
				<h2>套餐</h2>
				<!-- charts图表预留位置 -->
				<div class="charts">
					<e:if condition="${e:length(meal.list)<=0}" var="list7">
					暂无数据
					</e:if>
					<e:else condition="${list7 }">
						<c:ncolumnline id="meal1" items="${meal.list}" width="400px"
							height="170px" yaxis="title:,unit:" backgroundColor="#F3F8FB"
							colors="['#01d6ff','#fff','#ffcf13','#86d438','#8945fe']"
							terminal_num="name:套餐,type:column" showexport="false"
							dimension="office_name" title=" " legend="false" dataLabel="true"
							fontsize="10px" rotation="0" />
					</e:else>
				</div>
				<!-- //charts图表预留位置 -->
			</div>

		</div>
	</div>

	<script type="text/javascript"
		src='<e:url value="/pages/terminal/resources/themes/base/js/main.js"/>'></script>


</body>
</html>
