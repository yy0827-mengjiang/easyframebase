<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:description>某地区型号1的图片URL </e:description>
<e:q4o var="hjOnexlinImg">
			SELECT  DISTINCT
				    Y."IMG_URL"
				FROM "DM_M_TERM_USER_CHANGE" X,"DIM_IMG_NO" Y
				WHERE  1=1
				AND  X."IMG_NO"=Y."IMG_NO"
				AND  X."IMG_TYPE"=Y."IMG_TYPE"
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameH != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				and X."BRAND_NO"='${param.br1}'
				and X."MODEL_NO"='${param.brxh1}'									 
</e:q4o>
<e:description>某地区型号1的换入总销量 </e:description>
<e:q4o var="hjOnexlinSum">
			SELECT
				  "sum"(X."TERMINAL_NUM") xlSumin
				FROM "DM_M_TERM_USER_CHANGE" X
				WHERE  1=1	
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameH != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				and X."IN_BRAND"='${param.br1}'
				and X."IN_MODEL"='${param.brxh1}'										 
</e:q4o>
<e:description> 某地区型号1的换入销量Top3  </e:description>
<e:q4l var="hjOnein">
			SELECT
				  X."TERMINAL_NUM" a,Y."CITY_NAME" b
				FROM "DM_M_TERM_USER_CHANGE" X,"DIM_CITY_NO" Y
				WHERE  1=1	
				AND X."IN_AREA" = Y."CITY_NO"		
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameH != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				and X."IN_BRAND"='${param.br1}'
				and X."IN_MODEL"='${param.brxh1}'	
				ORDER BY   X."TERMINAL_NUM"  DESC
				LIMIT 3									 
</e:q4l>
<e:description> 某地区型号1的迁出总销量  </e:description>
<e:q4o var="hjOnexloutSum">
			SELECT
				  "sum"(X."TERMINAL_NUM") xlSumout
				FROM "DM_M_TERM_USER_CHANGE" X
				WHERE  1=1	
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameH != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				and X."OUT_BRAND"='${param.br1}'
				and X."OUT_MODEL"='${param.brxh1}'									 
</e:q4o>
<e:description> 某地区型号1的迁出销量Top3  </e:description>
<e:q4l var="hjOneout">
			SELECT
				  X."TERMINAL_NUM" a,Y."CITY_NAME" b
				FROM "DM_M_TERM_USER_CHANGE" X,"DIM_CITY_NO" Y
				WHERE  1=1	
				AND X."IN_AREA" = Y."CITY_NO"		
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameH != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				and X."OUT_BRAND"='${param.br1}'
				and X."OUT_MODEL"='${param.brxh1}'	
				ORDER BY   X."TERMINAL_NUM"  DESC
				LIMIT 3									 
</e:q4l>

<e:description> 某地区型号1的(换出的)换机周期 </e:description>
<e:q4l var="hjTwozq">
			SELECT DISTINCT
				   Y."MODEL_NAME" modelname,  
				   X."MODELCHANGE_T" all_num			  
				FROM "DM_M_TERM_USER_CHANGE" X,"TRMNL_DEVINFO" Y
				WHERE  1=1
				AND X."BRAND_NO" = Y."BRAND_NO"	
				AND X."MODEL_NO"=Y."MODEL_NO"
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameH != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>								
				and X."BRAND_NO"='${param.br1}'
				and X."MODEL_NO"='${param.brxh1}'									 
</e:q4l>
<e:description> 某地区某型号的流出sum </e:description>
<e:q4o var="hjThreeoutSum">
			SELECT
					"sum" (Y."TERMINAL_NUM") lcSumin
				FROM
					(SELECT 	
						X."OUT_BRAND",X."OUT_MODEL",X."TERMINAL_NUM"
					 FROM
						"DM_M_TERM_USER_CHANGE" X
					 WHERE
						 1 = 1
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameH != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>	
				and X."BRAND_NO"='${param.br1}'
				and X."MODEL_NO"='${param.brxh1}'								
				) Y						 
</e:q4o>
<e:description> 某地区品牌1的流出Top5</e:description>
<e:q4l var="hjThreeout">
			SELECT
				Z."MODEL_NAME" b,
				Y."TERMINAL_NUM" a
			FROM
				(SELECT 	
					X."OUT_BRAND",X."OUT_MODEL",X."TERMINAL_NUM"
				FROM
					"DM_M_TERM_USER_CHANGE" X
				WHERE
					1 = 1
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameH != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>	
				and X."BRAND_NO"='${param.br1}'
				and X."MODEL_NO"='${param.brxh1}') Y,"TRMNL_DEVINFO" Z
			WHERE 1=1
			AND Y."OUT_MODEL"=Z."MODEL_NO"
			ORDER BY   Y."TERMINAL_NUM"  DESC
			LIMIT 5													 
</e:q4l>
<e:description> 某地区型号1的流入sum </e:description>
<e:q4o var="hjThreeinSum">
			SELECT
					"sum" (Y."TERMINAL_NUM") lrSumin
				FROM
					(SELECT 	
						X."IN_BRAND",X."IN_MODEL",X."TERMINAL_NUM"
					 FROM
						"DM_M_TERM_USER_CHANGE" X
					 WHERE
						 1 = 1
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameH != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>	
					and X."BRAND_NO"='${param.br1}'
					and X."MODEL_NO"='${param.brxh1}'								
				) Y						 
</e:q4o>
<e:description> 某地区品牌1的流入Top5</e:description>
<e:q4l var="hjThreein">
			SELECT
				Z."MODEL_NAME" b,
				Y."TERMINAL_NUM" a
			FROM
				(SELECT 	
					X."IN_BRAND",X."IN_MODEL",X."TERMINAL_NUM"
				FROM
					"DM_M_TERM_USER_CHANGE" X
				WHERE
					1 = 1
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameH != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>	
				and X."BRAND_NO"='${param.br1}'
				and X."MODEL_NO"='${param.brxh1}') Y,"TRMNL_DEVINFO" Z
			WHERE 1=1
			AND Y."IN_MODEL"=Z."MODEL_NO"
			ORDER BY   Y."TERMINAL_NUM"  DESC
			LIMIT 5								 
</e:q4l>
<e:description> 换机区域对比图前10</e:description>
<e:q4l var="npie1">
	SELECT
				Z."CITY_NAME",
				Y."TERMINAL_NUM" a
			FROM
				(SELECT 	
					X."OUT_AREA",X."TERMINAL_NUM"
				FROM
					"DM_M_TERM_USER_CHANGE" X
				WHERE
					1 = 1
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameH != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>	
				and X."BRAND_NO"='${param.br1}'
				and X."MODEL_NO"='${param.brxh1}' 
				ORDER BY X."TERMINAL_NUM" DESC
				LIMIT 10 ) Y, "DIM_CITY_NO" Z
			WHERE 1=1
			AND Y."OUT_AREA"=Z."CITY_NO" 
					
</e:q4l>
<e:description> 换机区域对比图前10的总和</e:description>
<e:q4o var="npie11">
SELECT
	"sum"(Y."TERMINAL_NUM") A
FROM
	(
		SELECT
			X."OUT_AREA",
			X."TERMINAL_NUM"
		FROM
			"DM_M_TERM_USER_CHANGE" X
		WHERE
			1 = 1
				<e:if condition="${param.city_no == 'qxz'}" var="AllOrCity">
					<e:if condition="${param.pronameH != '全国'}">
						AND X."AREA_NO"='${param.provc_no}'
					</e:if>	
				</e:if>
				<e:else condition="${AllOrCity }">
					AND X."AREA_NO"='${param.provc_no}'
					AND X."CITY_NO"='${param.city_no}'
				</e:else>	
				<e:if condition="${param.start_month != null && param.start_month != '' && param.stop_month != null && param.stop_month != ''}">
					and X."ACCT_MONTH" BETWEEN  to_char(to_date('${param.start_month}','yyyymm'), 'yyyymm') AND to_char(to_date('${param.stop_month}','yyyymm'), 'yyyymm')				
				</e:if>	
				and X."BRAND_NO"='${param.br1}'
				and X."MODEL_NO"='${param.brxh1}' 
		ORDER BY
			X."TERMINAL_NUM" DESC
		LIMIT 10
	) Y
</e:q4o>
 <e:style value="/pages/terminal/resources/component/easyui/themes/metro/easyui.css"/>
 <e:style value="/pages/terminal/resources/component/easyui/themes/icon.css"/>
 <e:style value="/pages/terminal/resources/themes/base/boncBase@links.css"/>
<SCRIPT>
	$(function(){		
			//迁入in		
			<e:forEach items="${hjOnein.list}" var="item" indexName="index">
				<e:if condition="${item.a != null && item.a != ''}">
					var inVal11span =(Math.round(Number('${item.a}') / Number('${hjOnexlinSum.xlSumin}') * 10000) / 100.00 + "%");
					$("#s1"+${index}).html(inVal11span); 				
				</e:if>
			</e:forEach>
			
			//迁出out
			<e:forEach items="${hjOneout.list}" var="item" indexName="index">
				<e:if condition="${item.a != null && item.a != ''}">
					var inVal21span =(Math.round(Number('${item.a}') / Number('${hjOnexloutSum.xlSumout}') * 10000) / 100.00 + "%");
					$("#s2"+${index}).html(inVal21span); 				
				</e:if>
			</e:forEach>
	
		
		//流出
		<e:forEach items="${hjThreeout.list}" var="item" indexName="index">
			<e:if condition="${item.a != null && item.a != ''}">
				var inVal31span =(Math.round(Number('${item.a}') / Number('${hjThreeoutSum.lcSumin}') * 10000) / 100.00 + "%");
				$("#s3"+${index}).html(inVal31span); 				
			</e:if>
		</e:forEach>
		
		//流入
		<e:forEach items="${hjThreein.list}" var="item" indexName="index">
			<e:if condition="${item.a != null && item.a != ''}">
				var inVal41span =(Math.round(Number('${item.a}') / Number('${hjThreeinSum.lrSumin}') * 10000) / 100.00 + "%");
				$("#s4"+${index}).html(inVal41span); 				
			</e:if>
		</e:forEach>	
	});
	
	//饼图数据
	  	$(function(){
	  		var brType01='${param.brname1}'+"-"+'${param.brxhname1}';//品牌-型号
	  		var lczl= Number('${hjThreeoutSum.lcSumin }');//该型号的流出总量
	  		var lcTop10zl= Number('${npie11.a }');//该型号Top10的总量
	  		var qtzb = lczl-lcTop10zl+"";
	  		var x1=[];//地市	  		
	  		var ser=[];//数据
	  		<e:if condition="${e:length(npie1.list)>0}" var="check1">
	  			if(lcTop10zl == lczl){
	  				<e:forEach items="${npie1.list}" var="item" indexName="index">			
				  		x1.push('${item.CITY_NAME}');	
				  		ser.push({
								value: '${item.a}',
				                name: '${item.CITY_NAME}'	               
				            });
					</e:forEach>
					chartpic1(brType01,x1,ser);
	  			}else{
	  				<e:forEach items="${npie1.list}" var="item" indexName="index">			
			  		x1.push('${item.CITY_NAME}');	
			  		ser.push({
							value: '${item.a}',
			                name: '${item.CITY_NAME}'	               
			            });
					</e:forEach>
					x1.push('其它');
					ser.push({
						value: qtzb,
		                name: '其它'	               
		            });
					chartpic1(brType01,x1,ser);
	  			}  		
			</e:if>																
			<e:else condition="${check1}">
					 $("#pie1Chart").html("暂无数据！");
			</e:else>		
	  	});
		//饼图
	  	function chartpic1(brType,x1,ser){
  	  		var siteChart1 = echarts.init(document.getElementById('pie1Chart'));
  	  		var option1 = {
  	  			 title : {
  	  		        text: brType,
  	  		        x:'center'
  	  		    },		
  	  		    tooltip : {
	  	  	        trigger: 'item',
	  	  	        formatter: "{b} : {c} ({d}%)"
	  	  	    },
	  	  	    legend: {
	  	  	        orient: 'vertical',
	  	  	        left: 'left',
	  	  	        data: x1
	  	  	    },
	  	  	    series : [
	  	  	        {
	  	  	            name: '',
	  	  	            type: 'pie',
	  	  	            radius : '30%',
	  	  	            center: ['50%', '50%'],
	  	  	            data:ser
	  	  	        }
	  	  	    ]
	  	  	};	
  	  		siteChart1.setOption(option1);
  	  	}
	
	
  </SCRIPT> 
  	
    	<div>
					<div class="AdminProduct phonechange">						
						<div class="halfchange">
							<h2 class="place">换机迁移地</h2>
							<!-- 品牌1 -->
							 <e:if condition="${e:length(hjOnein.list)>0 || e:length(hjOneout.list)>0}" var="check1"> 
							<div class="placebox">
								<ul class="UlCompare">
									<e:forEach items="${hjOnein.list}" var="item" indexName="index">
										<li>
											<span>${index+1 }</span>
											<span>${item.b}</span>
											<span  id ="s1${index}" class="red"></span>
										</li>
									</e:forEach>
								</ul>
								<p class="arrow01"></p>															
									<e:if condition="${param.city_no ne 'qxz'}" var="check111">
									 	<div class="city">	${param.city_name } </div>
									</e:if>
									<e:else condition="${check111 }">
								 		<div class="city"> ${param.pronameH}</div>
								 	</e:else>									
								<div class="app"><img src='<e:url value="${hjOnexlinImg.IMG_URL}"/>'></div>								
									<e:if condition="${param.city_no ne 'qxz'}" var="check112">
									 	<div class="city">	${param.city_name } </div>
									</e:if>
									<e:else condition="${check112 }">
								 		<div class="city"> ${param.pronameH}</div>
								 	</e:else>									
								<p class="arrow02"></p>
								<ul class="UlCompare">
									<e:forEach items="${hjOneout.list}" var="item" indexName="index">
										<li>
											<span>${index+1 }</span>
											<span>${item.b}</span>
											<span  id ="s2${index}" class="red"></span>
										</li>
									</e:forEach>
								</ul>							
							</div>
							 </e:if> 
							 <e:else condition="${check1 }">
							 	<div class="placebox">
									暂无数据！
								</div>
							 </e:else>							
							<div style="width:100%;text-align:center;">${param.brname1}-${param.brxhname1}</div>
							<!-- //品牌1 -->
						</div>
						<div class="halfchange">
							<h2 class="time">换机周期</h2>
							<!-- 换机周期echarts预留位置 -->
							<div style="margin:0 auto;width:95%;">	
							   <e:if condition="${e:length(hjTwozq.list)>0}" var="check2"> 												
								<c:nbar id="picbar1" height="300"  width="550" 
										showexport="false" all_num="name:换机周期,type:spline" yaxis="title:,unit:月,min:1"
										dimension="modelname" 
										items="${hjTwozq.list}"  legend="false"
										colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>
							</e:if> 
							<e:else condition="${check2}">
								暂无数据！
							</e:else>							 	
							</div>
						</div>
					</div>
					<div class="AdminProduct">
						<h2 class="compare">流入流出对比图</h2>
						<div class="fldiv">
							<div style="width:100%;height:45%;">
								<div class="lout">流出</div>
								<div class="loutright">
									<div class="lediv">
										<img src='<e:url value="${hjOnexlinImg.IMG_URL}"/>'>
										<p>${param.brname1}-${param.brxhname1}</p>
										<p style="color: red;">(${hjThreeoutSum.lcSumin })</p>
									</div>
									<div class="arrow01-compare"></div>
									<div class="tabdiv">
										<table cellpadding="0" cellspacing="0" class="TableMarket normal">
											<colgroup>
												<col width="15%">
												<col width="57%">
												<col width="*">
											</colgroup>
											<tbody>
												<e:if condition="${e:length(hjThreeout.list)>0}" var="check3"> 
													<e:forEach items="${hjThreeout.list}" var="item" indexName="index">											
														<tr>
															<th><span class="thead0${index+1 }">${index+1 }</span></th>
															<td>${item.b}</td>
															<td><span id="s3${index}"></span></td>
														</tr>
													</e:forEach>												
												</e:if>
												<e:else condition="${check3}">
													<tr>
														<td>暂无数据！</td>
													</tr>
												</e:else>
												
											</tbody>
										</table>
									</div>
									<div style="clear: both"></div>
								</div>
								<div style="clear: both"></div>
							</div>
							<div style="width:100%;height:45%;margin: 34px 0">
								<div class="lout">流入</div>
								<div class="loutright">
									<div class="lediv">
										<img src='<e:url value="${hjOnexlinImg.IMG_URL}"/>'>
										<p>${param.brname1}-${param.brxhname1}</p>
										<p style="color: red;">(${hjThreeinSum.lrSumin })</p>
									</div>
									<div class="arrow02-compare"></div>
									<div class="tabdiv">
										<table cellpadding="0" cellspacing="0" class="TableMarket normal">
											<colgroup>
												<col width="15%">
												<col width="57%">
												<col width="*">
											</colgroup>
											<tbody>
												<e:if condition="${e:length(hjThreein.list)>0}" var="check4"> 																							
												<e:forEach items="${hjThreein.list}" var="item" indexName="index">											
													<tr>
														<th><span class="thead0${index+1 }">${index+1 }</span></th>
														<td>${item.b}</td>
														<td><span id="s4${index}"></span></td>
													</tr>
												</e:forEach>
												</e:if>
												<e:else condition="${check4 }">
													<tr>
														<td>暂无数据！</td>
													</tr>
												</e:else>
											</tbody>
										</table>
									</div>
									<div style="clear: both"></div>
								</div>
								<div style="clear: both"></div>
							</div>
						</div>
					</div>
					<div class="AdminProduct">
						<h2>换机区域对比图</h2>
						<div class="overflow-h">
							<!-- echarts显示位置 -->
							<%-- <div class="chartAdmin">
								<e:if condition="${e:length(npie1.list)>0}" var="check5"> 																															
								<c:npie  id='pie1' 
									 width='350'
								 	 height='350' 
								 	 title="${param.brname1 }-${param.brxhname1 }"
									 dataLabels="false"	
									 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"							
									 items="${npie1.list}"
									 a="占比"
									 dimension="CITY_NAME"
									 tipfmt="2"
									 legend="true"
									 showexport="false"
									 unit="个"
									 distance="5"/>	
								</e:if>
								<e:else condition="${check5}">
								暂无数据！
								</e:else>
							</div> --%>
							<div id="pie1Chart" class="chartAdmin" style="width:500px;height:500px"></div>
							<!-- //echarts显示位置 -->
						</div>
					</div>
				</div>
