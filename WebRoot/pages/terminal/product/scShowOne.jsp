<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="modelNum111">
	SELECT 
			"ACCT_MONTH",
			sum("NEW_NUM") a,
			sum("ONLINE_NUM") b,
			sum("OFF_NUM") c
	FROM "DM_M_TERM_MARKET_COMPETING"
	WHERE 1=1
	<e:if condition="${param.pronameS != '全国'}">
		and "AREA_NO"='${param.provc_no}'			
		<e:if condition="${param.city_no != null && param.city_no != '' && param.city_no != 'qxz'}">
			and "CITY_NO"='${param.city_no}'			
		</e:if>
	</e:if>	
	<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
		and "ACCT_MONTH" BETWEEN  to_char(to_date('${param.nowMonth}','yyyymm') +INTERVAL '-5' month , 'yyyymm') AND to_char(to_date('${param.nowMonth}','yyyymm'), 'yyyymm')				
	</e:if>								
	AND "BRAND_NO"='${param.br1}'
	AND "MODEL_NO"='${param.brxh1}'
	GROUP BY "ACCT_MONTH"
	ORDER BY "ACCT_MONTH"
</e:q4l>

<e:q4l var="modelNum12">
	SELECT
				"T",
				"sum"("TERMINAL_NUM") TERMINAL_NUM
			FROM "DM_M_TERM_MARKET_TRMNL"
	WHERE 1=1
	<e:if condition="${param.pronameS != '全国'}">
		and "AREA_NO"='${param.provc_no}'			
		<e:if condition="${param.city_no != null && param.city_no != '' && param.city_no != 'qxz'}">
			and "CITY_NO"='${param.city_no}'			
		</e:if>
	</e:if>							
	AND "BRAND_NO"='${param.br1}'
	AND "MODEL_NO"='${param.brxh1}'
	GROUP BY "T","ORD"
	ORDER BY "ORD"
</e:q4l> 
<!-- 循环值 -->
<e:q4l var="cityLL">
SELECT a."ORD" FROM "DIM_CITY_NO" a LIMIT 4
</e:q4l>
<!-- 省份管理员具体地市的数据 -->
<e:if condition="${param.pronameS != '全国'}" var="AllOrCity">
	<e:forEach items="${cityLL.list}" var="for1">
		<e:q4l var="modelNum13${index+1 }">
				SELECT A."CITY_NAME",B.A  from "DIM_CITY_NO" A
				 LEFT JOIN (
				SELECT
					X."CITY_NO" B,
					<e:if condition="${index==0 }">
						"sum" (X."ALL_NUM") A
					</e:if>
					<e:if condition="${index==1 }">
						"sum" (X."NEW_NUM") A
					</e:if>
					<e:if condition="${index==2 }">
						"sum" (X."ONLINE_NUM") A
					</e:if>
					<e:if condition="${index==3 }">
						"sum" (X."OFF_NUM") A
					</e:if>
				FROM
					"DM_M_TERM_MARKET_COMPETING" X
				WHERE
					1 = 1
				AND X ."AREA_NO" = '${param.provc_no}'	
				<e:if condition="${param.city_no != 'qxz'}">
					AND X."CITY_NO" = '${param.city_no}'	
				</e:if>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				AND X."BRAND_NO"='${param.br1}'
				AND X."MODEL_NO"='${param.brxh1}'
				GROUP BY X."CITY_NO"
				) B 
				ON A."CITY_NO" = B.B 
				where 1=1 
				AND A."AREA_NO" = '${param.provc_no}'
				ORDER BY A."ORD"  		
		</e:q4l>
	</e:forEach>	
</e:if>
<!-- 全国展示省的汇总展示 -->
<e:else condition="${AllOrCity}">
	<e:forEach items="${cityLL.list}"  var="for1">
		<e:q4l var="modelNum14${index+1 }">
				SELECT A."AREA_NAME",B.A  from "DIM_AREA_NO" A
				 LEFT JOIN (
							SELECT
								X."AREA_NO" B,
								<e:if condition="${index==0 }">
								"sum" (X."ALL_NUM") A
								</e:if>
								<e:if condition="${index==1 }">
								"sum" (X."NEW_NUM") A
								</e:if>
								<e:if condition="${index==2 }">
								"sum" (X."ONLINE_NUM") A
								</e:if>
								<e:if condition="${index==3 }">
								"sum" (X."OFF_NUM") A
								</e:if>
							FROM
								"DM_M_TERM_MARKET_COMPETING" X
							WHERE
								1 = 1
							<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
								and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
							</e:if>								
							AND X."BRAND_NO"='${param.br1}'
							AND X."MODEL_NO"='${param.brxh1}'
							GROUP BY X."AREA_NO"
							) B 
				ON A."AREA_NO" = B.B 
				where 1=1   and A."AREA_NAME" != '全国'  ORDER BY A."ORD" 		
		</e:q4l>
	</e:forEach>	
</e:else>
<e:q4o var="phoneNum1">
	SELECT 
			X.*,Y."IMG_URL"
	FROM "TRMNL_DEVINFO" X, "DIM_IMG_NO" Y
	WHERE 1=1	
	AND	X."IMG_NO"=Y."IMG_NO"
	AND	X."IMG_TYPE"=Y."IMG_TYPE"				
	AND X."BRAND_NO"='${param.br1}'
	AND X."MODEL_NO"='${param.brxh1}'
</e:q4o>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
   
  	  <script>
  	  //第二块tab切换js
  	 $(function(){		  
  	   $("li").click(function(){
  		    var index=$("li").index(this);
  		   $(".bigdiv").hide();
  		   $("li").removeClass("white");
  		   $($(".bigdiv")[index]).show();
  		   $($("li")[index]).addClass("white");
  		   })
  	   })
  	 
  	  	//第一块左图双柱数据
  	  	$(function(){
  	  		var brType01='${param.brname1}'+"-"+'${param.brxhname1}';//品牌-型号
  	  		var brType1=brType01+"(新增)";//品牌-型号
  	  		var brType2=brType01+"(在网)";//品牌-型号
  	  		var brType3=brType01+"(离网)";//品牌-型号
  	  		var xhType=[];
  	  		xhType.push(brType1);xhType.push(brType2);xhType.push(brType3);
  	  		var x1=[];//账期
  	  		var y11=[];//数据11
  	  		var y21=[];//数据21
  	  		var y31=[];//数据31 
  	  		<e:if condition="${e:length(modelNum111.list)>0}" var="check1">	
		  		<e:forEach items="${modelNum111.list}" var="item" indexName="index">
			       x1.push('${item.ACCT_MONTH}');
			       y11.push('${item.a}');
			       y21.push('${item.b}');
			       y31.push('${item.c}');
				</e:forEach>			
				chartpic1(xhType,x1,y11,y21,y31); 	
			</e:if>																
			<e:else condition="${check1}">
				 $("#picleft").html("暂无数据！");
			</e:else>
  	  	});
  	  	function chartpic1(xhType,x1,y11,y21,y31){
  	  		var siteChart1 = echarts.init(document.getElementById('picleft'));
  	  		var option1 = {
  	  			 
  	  		tooltip : {
  	  	        trigger: 'axis',
  	  	    },
  	  	    legend: {
  	  	        data:xhType
  	  	    },
  	  	 	grid: {
	  	        left: '3%',
	  	        right: '4%',
	  	        bottom: '3%',
	  	        containLabel: true
	  	    },
  	  	    xAxis : [
  	  	        {
	  	  	        axisLabel: {
			         	interval:0,
			            rotate: 0,
			        },
  	  	            type : 'category',
  	  	            data : x1
  	  	        }
  	  	    ],
  	  	    yAxis : [
  	  	        {
  	  	            type : 'value'
  	  	        }
  	  	    ],
  	  	    series : [
  	  	        
  	  	        {
  	  	            name:xhType[0],
  	  	            type:'bar',
  	  	            stack: '1',
  	  	            data:y11
  	  	        },
  	  	        {
  	  	            name:xhType[1],
  	  	            type:'bar',
  	  	            stack: '1',
  	  	            data:y21
  	  	        },
  	  	        {
  	  	            name:xhType[2],
  	  	            type:'bar',
  	  	            stack: '1',
  	  	            data:y31
  	  	        }
  	  	    ]
  	  	};
  	  		siteChart1.setOption(option1);
  	  	}
  	  	//第一块右图线图数据
  		$(function(){
  			var brType='${param.brname1}'+"-"+'${param.brxhname1}';//品牌-型号
  			var xhType=[];
  			xhType.push(brType);
  			var x1=[];//图2-维度
  			var y1=[];//图2-指标
  	  		<e:if condition="${e:length(modelNum12.list)>0}" var="check2">	
	  			<e:forEach items="${modelNum12.list}" var="item" indexName="index">
			       x1.push('${item.T}');
			       y1.push('${item.TERMINAL_NUM}');
				</e:forEach>		
	  			chartpic2(xhType,x1,y1);
  			</e:if>																
			<e:else condition="${check2}">
				 $("#picright").html("暂无数据！");
			</e:else>
		});				
  		function chartpic2(xhType,x1,y1){
  			var siteChart = echarts.init(document.getElementById('picright'));	
  				var option = {
  					    tooltip: {
  					        trigger: 'axis'
  					    },
  					    legend: {
  					        data:xhType
  					    },
  					    grid: {
  					        left: '3%',
  					        right: '4%',
  					        bottom: '3%',
  					        containLabel: true
  					    },
  					    
  					    xAxis: {
  					    	axisLabel: {
  					         	interval:0,
  					            rotate: 0,
  					        },
  					        type: 'category',
  					        boundaryGap: false,
  					        data:x1
  					    },
  					    yAxis: {
  					        type: 'value'
  					    },
  					    series: [
  					        {
  					            name:xhType[0],
  					            type:'line',
  					         	smooth:true,
  					            stack: '销量',
  					            data:y1
  					        }
  					    ]
  					};
  		 	 	siteChart.setOption(option);
  			} 			
  			//第二块切换柱图数据
  			$(function(){
  				var brType='${param.brname1}'+"-"+'${param.brxhname1}';//品牌-型号
  	  			var xhType=[];
  	  			xhType.push(brType);
  	  			var x1=[];  var x2=[]; var x3=[]; var x4=[];//维度
	  			var y1=[];var y2=[];var y3=[];var y4=[];//指标
	  			<e:if condition="${param.pronameS != '全国'}"   var="AllOrCityPic">
		  	  			<e:if condition="${modelNum131.list[0].a !='' && modelNum131.list[0].a != null}" var="check3">								
		  	  			<e:forEach items="${modelNum131.list}" var="item" indexName="index">
						       x1.push('${item.CITY_NAME}');
						       y1.push('${item.a}');					      
							</e:forEach>
							 var siteChart3 = echarts.init(document.getElementById('pic211'));
						     chartpic3(xhType,x1,y1,siteChart3);
						</e:if>																
						<e:else condition="${check3}">
								$("#pic211").html("暂无数据！");
						</e:else>
		  	  			<e:if condition="${modelNum132.list[0].a !='' && modelNum132.list[0].a != null}" var="check4">	
							<e:forEach items="${modelNum132.list}" var="item" indexName="index">
								x2.push('${item.CITY_NAME}');
						       	y2.push('${item.a}');					      
							</e:forEach>
							var siteChart4 = echarts.init(document.getElementById('pic212'));
						    chartpic3(xhType,x2,y2,siteChart4);
						</e:if>																
						<e:else condition="${check4}">
								$("#pic212").html("暂无数据！");
						</e:else>
		  	  			<e:if condition="${modelNum133.list[0].a !='' && modelNum133.list[0].a != null}" var="check5">	
							<e:forEach items="${modelNum133.list}" var="item" indexName="index">
								x3.push('${item.CITY_NAME}');
						       y3.push('${item.a}');  
							</e:forEach>
							var siteChart5 = echarts.init(document.getElementById('pic213'));
						    chartpic3(xhType,x3,y3,siteChart5);
						</e:if>																
						<e:else condition="${check5}">
								$("#pic213").html("暂无数据！");
						</e:else>
		  	  			<e:if condition="${modelNum134.list[0].a !='' && modelNum134.list[0].a != null}" var="check6">	
							<e:forEach items="${modelNum134.list}" var="item" indexName="index">
								x4.push('${item.CITY_NAME}');
						       y4.push('${item.a}');				      
							</e:forEach>
							 var siteChart6 = echarts.init(document.getElementById('pic214'));
						     chartpic3(xhType,x4,y4,siteChart6);
						</e:if>																
						<e:else condition="${check6}">
								$("#pic214").html("暂无数据！");
						</e:else>
				</e:if>
				<e:else condition="${AllOrCityPic}">
					<e:if condition="${modelNum141.list[0].a !='' && modelNum141.list[0].a != null}" var="check3">	
					<e:forEach items="${modelNum141.list}" var="item" indexName="index">
				       x1.push('${item.AREA_NAME}');
				       y1.push('${item.a}');					      
					</e:forEach>
					 var siteChart3 = echarts.init(document.getElementById('pic211'));
				     chartpic3(xhType,x1,y1,siteChart3);
					</e:if>																
					<e:else condition="${check3}">
							$("#pic211").html("暂无数据！");
					</e:else>
			  			<e:if condition="${modelNum142.list[0].a !='' && modelNum142.list[0].a != null}" var="check4">	
						<e:forEach items="${modelNum142.list}" var="item" indexName="index">
							x2.push('${item.AREA_NAME}');
					       y2.push('${item.a}');					      
						</e:forEach>
						var siteChart4 = echarts.init(document.getElementById('pic212'));
					    chartpic3(xhType,x2,y2,siteChart4);
					</e:if>																
					<e:else condition="${check4}">
							$("#pic212").html("暂无数据！");
					</e:else>
			  			<e:if condition="${modelNum143.list[0].a !='' && modelNum143.list[0].a != null}" var="check5">	
						<e:forEach items="${modelNum143.list}" var="item" indexName="index">
						x3.push('${item.AREA_NAME}');
					       y3.push('${item.a}');  
						</e:forEach>
						var siteChart5 = echarts.init(document.getElementById('pic213'));
					    chartpic3(xhType,x3,y3,siteChart5);
					</e:if>																
					<e:else condition="${check5}">
							$("#pic213").html("暂无数据！");
					</e:else>
			  			<e:if condition="${modelNum144.list[0].a !='' && modelNum144.list[0].a != null}" var="check6">	
						<e:forEach items="${modelNum144.list}" var="item" indexName="index">
							x4.push('${item.AREA_NAME}');
					       y4.push('${item.a}');				      
						</e:forEach>
						 var siteChart6 = echarts.init(document.getElementById('pic214'));
					     chartpic3(xhType,x4,y4,siteChart6);
					</e:if>																
					<e:else condition="${check6}">
							$("#pic214").html("暂无数据！");
					</e:else> 			
				</e:else>
	  			
			});	
  			function chartpic3(lengthTyep,x1,y1,siteChart3){
  	  			var option = {
  	  			    tooltip : {
  	  		        trigger: 'axis',
  	  		    },
  	  		    legend: {
  	  		        data:lengthTyep
  	  		    },
  	  		    grid: {
  	  		        left: '3%',
  	  		        right: '4%',
  	  		        bottom: '3%',
  	  		        containLabel: true
  	  		    },
  	  		    xAxis : [
  	  		        {
  	  		            type : 'category',
  	  		            data : x1
  	  		        }
  	  		    ],
  	  		    yAxis : [
  	  		        {
  	  		            type : 'value'
  	  		        }
  	  		    ],
  	  		    series : [
  	  		        {
  	  		            name:lengthTyep,
  	  		            type:'bar',
  	  		            data:y1
  	  		        }
  	  		    ]
  	  		};
  		 	 	siteChart3.setOption(option);
  			}
  	</script>  
  </head> 
  <body>  
   	<div>
  		<!-- 第一部分与所选时间无关 -->
		<div class="overflow-h" >
		            <div style="width:100%;height:30px;">
		              <p style="float:left;width:50%;text-align:left;color: #000;font-size: 18px;margin: 0px;">竞品数据量对比</p>
		              <p style="float:left;width:50%;text-align:left;color: #000;font-size: 18px;margin: 0px;">竞品上市趋势</p>
					
		            </div>
		            <div id="picleft" class="left-charts" style="height:376px;width:590px;">
					  	<!-- echarts柱堆叠图展示区 -->
					</div>
					<div id="picright" class="right-charts" style="height:376px;width:590px;">
						<!-- echarts线堆叠图展示区 -->
					</div>
					<div style="clear:both"></div>
					<div style="width:590px;height:30px;float:right">
						T:终端机型发布的起始月 
					</div>
		</div>
		<!-- 第二部分 -->
			<div  style="width:100%;height:auto;">
		      <ul  class=" ggul" style="width:100%;text-align:left">
		          <li class="white">总量</li>
				  <li>新增</li>
		          <li>在网</li>
		          <li>离网</li>
		      </ul>
				 <div id="pic211" class="bigdiv" style="width:1200px;height:400px;">
				 </div>
		         <div id="pic212" class="bigdiv" style="display:none;width:1200px;height:400px;">					
				 </div>
		         <div id="pic213" class="bigdiv" style="display:none;width:1200px;height:400px;">		         
				 </div>
		         <div id="pic214" class="bigdiv" style="display:none;width:1200px;height:400px;">		         	
				</div>
			 </div>
					
	    <!-- 第三部分 -->
					<div class="overflow-h">
						<div class="fhuidiv">
							<div class="phone app">
<%-- 							<img src='<e:url value="/pages/terminal/resources/themes/base/images/boncLayout/img/iphone.jpg"/>' alt="">
 --%>							
							<img src='<e:url value="${phoneNum1.IMG_URL }"/>' alt="">
 							</div>
							<p>${phoneNum1.BRAND_NAME}-${phoneNum1.MODEL_NAME}</p>
							<ul class="ul2">
								<li>                            
									<div class="biaodiv biao"></div>
									<div class="zidiv">
										<p><span>cpu型号：</span><span>${phoneNum1.CPU }</span></p>
									</div>
								</li>
								<li>
									<div class="biaodiv biao1"></div>
									<div class="zidiv">
										<p><span>主屏尺寸：</span><span>${phoneNum1.MAIN_SIZE }</span><span>英寸</span></p>
										<p><span>主屏分辨率：</span><span>${phoneNum1.MAIN_RESOLTION }</span><span>像素</span></p>
									</div>
								</li>
								<li>
									<div class="biaodiv biao2"></div>
									<div class="zidiv">
										<p><span>后置摄像头：</span><span>${phoneNum1.REAR_CAMCRA}</span><span>像素</span></p>
										<p><span>前置摄像头：</span><span>${phoneNum1.FRONT_CAMCR }</span><span>像素</span></p>
									</div>
								</li>
								<li>
									<div class="biaodiv biao3"></div>
									<div class="zidiv">
										<p><span>内存：</span><span>${phoneNum1.INTERNAL_MEMORY }</span><span>B</span></p>
									</div>
								</li>
							</ul>
						</div>
					</div>
				</div> 
 </body>
</html>
