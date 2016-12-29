<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4l var="testlist">
SELECT
	"sum"(A ."ALL_NUM") all_num,
	 B."MODEL_NAME" modelname
FROM
	"DM_M_TERM_MARKET_COMPETING" A,
	"TRMNL_DEVINFO" B
WHERE 1=1
AND	A ."BRAND_NO" = B."BRAND_NO"
AND A ."MODEL_NO" = B."MODEL_NO"
<e:if condition="${sessionScope.UserInfo.ADMIN == '2' || sessionScope.UserInfo.ADMIN == '0'}">
	 AND "AREA_NO" = '${sessionScope.UserInfo.AREA_NO }'
</e:if>
AND A."ACCT_MONTH" = '201611'
GROUP BY B."MODEL_NAME"
ORDER BY all_num DESC
LIMIT 10
</e:q4l>
<e:q4l var="testlist1">
SELECT
	"sum"(A ."NEW_NUM") new_num,
	B."MODEL_NAME" modelname
FROM
	"DM_M_TERM_MARKET_COMPETING" A,
	"TRMNL_DEVINFO" B
WHERE 1=1
AND	A ."BRAND_NO" = B."BRAND_NO"
AND A ."MODEL_NO" = B."MODEL_NO"
<e:if condition="${sessionScope.UserInfo.ADMIN == '2' || sessionScope.UserInfo.ADMIN == '0'}">
	 AND "AREA_NO" = '${sessionScope.UserInfo.AREA_NO }'
</e:if>
AND A."ACCT_MONTH" = '201611'
GROUP BY B."MODEL_NAME"
ORDER BY new_num DESC
LIMIT 10
</e:q4l>
<e:q4l var="testlist2">
SELECT
	"sum"(A ."ONLINE_NUM") online_num,
	B."MODEL_NAME" modelname
FROM
	"DM_M_TERM_MARKET_COMPETING" A,
	"TRMNL_DEVINFO" B
WHERE 1=1
AND	A ."BRAND_NO" = B."BRAND_NO"
AND A ."MODEL_NO" = B."MODEL_NO"
<e:if condition="${sessionScope.UserInfo.ADMIN == '2' || sessionScope.UserInfo.ADMIN == '0'}">
	 AND "AREA_NO" = '${sessionScope.UserInfo.AREA_NO }'
</e:if>
AND A."ACCT_MONTH" = '201611'
GROUP BY B."MODEL_NAME"
ORDER BY online_num DESC
LIMIT 10
</e:q4l>
<e:q4l var="testlist3">
SELECT
	"sum"(A ."OFF_NUM") off_num,
	B."MODEL_NAME" modelname
FROM
	"DM_M_TERM_MARKET_COMPETING" A,
	"TRMNL_DEVINFO" B
WHERE 1=1
AND	A ."BRAND_NO" = B."BRAND_NO"
AND A ."MODEL_NO" = B."MODEL_NO"
<e:if condition="${sessionScope.UserInfo.ADMIN == '2' || sessionScope.UserInfo.ADMIN == '0'}">
	 AND "AREA_NO" = '${sessionScope.UserInfo.AREA_NO }'
</e:if>
AND A."ACCT_MONTH" = '201611'
GROUP BY B."MODEL_NAME"
ORDER BY off_num DESC
LIMIT 10
</e:q4l>
<e:set var="start_month">201611</e:set>
<e:if condition="${param.start_month!=''&&param.start_month!=null }">
	<e:set var="start_month">${param.start_month }</e:set>
</e:if>
<e:set var="stop_month">201611</e:set>
<e:if condition="${param.stop_month!=''&&param.stop_month!=null }">
	<e:set var="stop_month">${param.stop_month }</e:set>
</e:if>
<!-- 品牌、型号联动 -->
<e:q4l var="brandlist1">
select DISTINCT "BRAND_NO","BRAND_NAME" from "TRMNL_DEVINFO" ORDER BY "BRAND_NO" DESC
</e:q4l>
<!-- 省份、地市级联-->
<e:q4l var="areaL">
SELECT a."AREA_NAME" ,a."AREA_NO" FROM "DIM_AREA_NO" a 
WHERE 1=1
<e:if condition="${sessionScope.UserInfo.ADMIN == '2' || sessionScope.UserInfo.ADMIN == '0'}">
	 AND "AREA_NO" = '${sessionScope.UserInfo.AREA_NO }'
</e:if>

</e:q4l>
<!-- 初始化品牌型号展示 -->
<e:forEach items="${brandlist1.list}" var="item">
	<e:if condition="${index } == 0">
		<e:set var="oncebrNo">${item.BRAND_NO}</e:set>
	</e:if>
</e:forEach>
<e:q4l var="xhlist1">
			select DISTINCT "MODEL_NO","MODEL_NAME" 
			from "TRMNL_DEVINFO" 
			WHERE  1=1
			<e:if condition="${oncebrNo!=null && oncebrNo!=''}">
				and "BRAND_NO"='${oncebrNo}'			
			</e:if>			 
			 ORDER BY "MODEL_NO"
</e:q4l>

<!DOCTYPE html>
<html>
<head>
<a:base/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

 <c:resources type="easyui,highchart" style="b"/>
    <!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <!--声明以360极速模式进行渲染 -->
    <meta name=”renderer” content=”webkit” />
    <!--系统名称文本 -->
    <title>终端指标分析系统－竞品分析</title> 
    <!-- 系统ICON图标（注:路径为TomCat根目录） -->
    <link rel ="Shortcut Icon" href="" />
    <e:style value="/pages/terminal/resources/component/easyui/themes/metro/easyui.css"/>
    <e:style value="/pages/terminal/resources/component/easyui/themes/icon.css"/>
    <!-- 独立Js脚本 -->
    <script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/boncCommon.js"/>'></script>
    
    <!-- 独立Css层叠样式表 -->
    <e:style value="/pages/terminal/resources/themes/base/boncBase@links.css"/>
    
	<script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/product.js"/>'></script>
    <!-- echarts -->
    <script type="text/javascript" src='<e:url value="/pages/terminal/resources/themes/base/js/echarts.min.js"/>'></script>
<!--市场tab切换  -->
<style type="text/css">
  .ggul{width:199%;background:#F1F6F9;height:40px;line-style:none;}
  .ggul li{margin-left: 10px;display:inline-block;width:64px;height:34px;background:#5a94f0;color:#fff;border-top-left-radius:5px;border-top-right-radius:5px;text-decoration:none;text-align:center;line-height:34px;margin-top:6px;font-size:12px;}
  .white{background:#fff!important;color:#000!important;font-weight:600;}
  .ggul li:not(.white):hover{background:#fff;color:#999;cursor:pointer;}
  .bigdiv{width:100%;height:500px;}
</style>
<script type="text/javascript">
$(function(){ 	
	$("#brandSxh1").empty();
	$("#brandxh1").empty();
	$("#brandHxh1").empty();
	<e:forEach items="${xhlist1.list}" var="item" indexName="index">
		<e:if condition="${item.MODEL_NO != null && item.MODEL_NO != ''}">
			$("#brandSxh1").append("<option value='${item.MODEL_NO}'>${item.MODEL_NAME}</option>");
			$("#brandxh1").append("<option value='${item.MODEL_NO}'>${item.MODEL_NAME}</option>");
			$("#brandHxh1").append("<option value='${item.MODEL_NO}'>${item.MODEL_NAME}</option>");
		</e:if>
	</e:forEach>	
});
</script>
<!-- 市场查询条件区域 -->
<script type="text/javascript">
/*  月历start    */
$(function(){  
    var mydate = new Date();
	   var str = "" + mydate.getFullYear() + "-";
	   str += (mydate.getMonth()-8);
	//市场起始月份
	$("#startS").val(str);
    $('#startS').datebox({  
 	    editable:false ,
         onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层  
             span.trigger('click'); //触发click事件弹出月份层  
             if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔  
                 tds = p.find('div.calendar-menu-month-inner td');  
                 tds.click(function (e) {  
                     e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件  
                     var year = /\d{4}/.exec(span.html())[0]//得到年份  
                             , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1  
                     $('#startS').datebox('hidePanel')//隐藏日期对象  
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
     var p = $('#startS').datebox('panel'), //日期选择对象  
         tds = false, //日期选择对象中月份  
         span = p.find('span.calendar-text'); //显示月份层的触发控件     
 });  
$(function () {  
    var mydate = new Date();
	   var str = "" + mydate.getFullYear() + "-";
	   str += (mydate.getMonth()+1);
	 //市场停止月份
	$("#stopS").val(str);
    $('#stopS').datebox({  
 	    editable:false ,
         onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层  
             span.trigger('click'); //触发click事件弹出月份层  
             if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔  
                 tds = p.find('div.calendar-menu-month-inner td');  
                 tds.click(function (e) {  
                     e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件  
                     var year = /\d{4}/.exec(span.html())[0]//得到年份  
                             , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1  
                     $('#stopS').datebox('hidePanel')//隐藏日期对象  
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
     var p = $('#stopS').datebox('panel'), //日期选择对象  
             tds = false, //日期选择对象中月份  
             span = p.find('span.calendar-text'); //显示月份层的触发控件          
             
 });
/*  月历 end   */
/* 联动条件查询   */
//省份、地市级联 操作
function findCityS(){
	$("#cityS").empty();
	$("#cityS").append("<option value='qxz'>--请选择--</option>");
	var AREA_NO = $("#provinceS").val();
	$.post('<e:url value="/pages/terminal/product/productAction.jsp?eaction=seleCityList"/>',{ qdValue: AREA_NO},function(data){
		var city =eval(data.trim());
      	for(var i = 0;i<city.length;i++){
 			$("#cityS").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
 		}
    });
}
//品牌型号联动
function linkageS21(qdVal){
	$("#brandSxh1").empty();
	var obj ='';
	 $.post(
			 '<e:url value="/pages/terminal/product/productAction.jsp?eaction=ordersList"/>',
			 {qdValue:qdVal}, 
			 function(data){
			 	obj = $.parseJSON($.trim(data));
			 	for(var i = 0;i < obj.length;i++){
					 var w =new Option(obj[i].MODEL_NAME,obj[i].MODEL_NO);
					 document.getElementById("brandSxh1").options.add(w);
			 	}
			 });
}
function linkageS22(qdVal){
	var pp2 = $("#brandtwoS").val();
	if(pp2==''){
		$("#brandSxh2").empty();
		$("#brandSxh2").append("<option value=''>--请选择--</option>");
	}else{
		$("#brandSxh2").empty();
		var obj ='';
		 $.post(
				 '<e:url value="/pages/terminal/product/productAction.jsp?eaction=ordersList"/>',
				 {qdValue:qdVal}, 
				 function(data){
				 	obj = $.parseJSON($.trim(data));
				 	for(var i = 0;i < obj.length;i++){
						 var w =new Option(obj[i].MODEL_NAME,obj[i].MODEL_NO);
						 document.getElementById("brandSxh2").options.add(w);
				 	}
				 });	
	}

}
function linkageS23(qdVal){
	var pp3 = $("#brandthreeS").val();
	if(pp3==''){
		$("#brandSxh3").empty();
		$("#brandSxh3").append("<option value=''>--请选择--</option>");
	}else{		
		$("#brandSxh3").empty();
		var obj ='';
		 $.post(
				 '<e:url value="/pages/terminal/product/productAction.jsp?eaction=ordersList"/>',
				 {qdValue:qdVal}, 
				 function(data){
				 	obj = $.parseJSON($.trim(data));
				 	for(var i = 0;i < obj.length;i++){
						 var w =new Option(obj[i].MODEL_NAME,obj[i].MODEL_NO);
						 document.getElementById("brandSxh3").options.add(w);
				 	}
				 });
		
	}
	
	
}
//初始化市场页面
$(function(){
	findCityS(); 	
	var getnowMonth=201611;
 	var info={};
 	info.nowMonth=getnowMonth; 
 	info.start_month=$('#startS').datebox('getValue').replace("-", "");//起始月
 	info.stop_month=$('#stopS').datebox('getValue').replace("-", "");//结束月 	
 	info.provc_no=$('#provinceS').val();//省份
 	info.pronameS=$("#provinceS").find("option:selected").text();//省份的name
 	info.city_no=$('#cityS').val(); 
	info.br1=$("#brandoneS").val();//品牌1
	info.brxh1=$("#brandSxh1").val();//品牌型号1
	info.brname1=$("#brandoneS").find("option:selected").text();//品牌1name
	info.brxhname1=$("#brandSxh1").find("option:selected").text();//型号name 
	$("#sc").load('pages/terminal/product/scShowOne.jsp',info,function(){});
	$("#sc").show();
	$($("#sc .yidiv")[0]).show();
});
</script>

<!-- 用户查询条件区域 -->  
<script type="text/javascript">

/*  月历start    */
$(function(){  
    var mydate = new Date();
	   var str = "" + mydate.getFullYear() + "-";
	   str += (mydate.getMonth()-8);	
   //用户起始月份
 	$("#start").val(str);
     $('#start').datebox({  
  	    editable:false ,
          onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层  
              span.trigger('click'); //触发click事件弹出月份层  
              if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔  
                  tds = p.find('div.calendar-menu-month-inner td');  
                  tds.click(function (e) {  
                      e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件  
                      var year = /\d{4}/.exec(span.html())[0]//得到年份  
                              , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1  
                      $('#start').datebox('hidePanel')//隐藏日期对象  
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
      var p = $('#start').datebox('panel'), //日期选择对象  
          tds = false, //日期选择对象中月份  
          span = p.find('span.calendar-text'); //显示月份层的触发控件   
           
 });  
$(function () {  
    var mydate = new Date();
	   var str = "" + mydate.getFullYear() + "-";
	   str += (mydate.getMonth()+1);	
   //用户停止月份
	$("#stop").val(str);
    $('#stop').datebox({  
 	    editable:false ,
         onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层  
             span.trigger('click'); //触发click事件弹出月份层  
             if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔  
                 tds = p.find('div.calendar-menu-month-inner td');  
                 tds.click(function (e) {  
                     e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件  
                     var year = /\d{4}/.exec(span.html())[0]//得到年份  
                             , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1  
                     $('#stop').datebox('hidePanel')//隐藏日期对象  
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
     var p = $('#stop').datebox('panel'), //日期选择对象  
             tds = false, //日期选择对象中月份  
             span = p.find('span.calendar-text'); //显示月份层的触发控件              
 
 });
/*  月历 end   */
/* 联动条件查询   */
//省份、地市级联 操作
function findCityY(){	
	$("#cityY").empty();
	$("#cityY").append("<option value='qxz'>--请选择--</option>");
	var AREA_NO = $("#provinceY").val();
	$.post('<e:url value="/pages/terminal/product/productAction.jsp?eaction=seleCityList"/>',{ qdValue: AREA_NO},function(data){
		var city =eval(data.trim());
      	for(var i = 0;i<city.length;i++){
 			$("#cityY").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
 		}
    });
}

//品牌型号联动
function linkage21(qdVal){
	$("#brandxh1").empty();
	var obj ='';
	 $.post(
			 '<e:url value="/pages/terminal/product/productAction.jsp?eaction=ordersList"/>',
			 {qdValue:qdVal}, 
			 function(data){
			 	obj = $.parseJSON($.trim(data));
			 	for(var i = 0;i < obj.length;i++){
					 var w =new Option(obj[i].MODEL_NAME,obj[i].MODEL_NO);
					 document.getElementById("brandxh1").options.add(w);//用户
			 	}
			 });
}
function linkage22(qdVal){
	var pp4 = $("#brandtwoY").val();
	if(pp4==''){
		$("#brandxh2").empty();
		$("#brandxh2").append("<option value=''>--请选择--</option>");
	}else{		
		$("#brandxh2").empty();
		var obj ='';
	 $.post(
			 '<e:url value="/pages/terminal/product/productAction.jsp?eaction=ordersList"/>',
			 {qdValue:qdVal}, 
			 function(data){
			 	obj = $.parseJSON($.trim(data));
			 	for(var i = 0;i < obj.length;i++){
					 var w =new Option(obj[i].MODEL_NAME,obj[i].MODEL_NO);
					 document.getElementById("brandxh2").options.add(w);//用户
			 	}
			 });
	}
}
function linkage23(qdVal){
	var pp5 = $("#brandthreeY").val();
	if(pp5==''){
		$("#brandxh3").empty();
		$("#brandxh3").append("<option value=''>--请选择--</option>");
	}else{		
		$("#brandxh3").empty();
	var obj ='';
	 $.post(
			 '<e:url value="/pages/terminal/product/productAction.jsp?eaction=ordersList"/>',
			 {qdValue:qdVal}, 
			 function(data){
			 	obj = $.parseJSON($.trim(data));
			 	for(var i = 0;i < obj.length;i++){
					 var w =new Option(obj[i].MODEL_NAME,obj[i].MODEL_NO);
					 document.getElementById("brandxh3").options.add(w);//用户
			 	}
			 });
	}
}

//初始化用户页面
$(function(){
	findCityY(); 	
 	var info={};
 	info.start_month=$("#start").val().replace("-", "");
	info.stop_month=$("#stop").val().replace("-", "");
	info.provc_no=$('#provinceY').val();//省份
	info.pronameY=$("#provinceY").find("option:selected").text();//省份的name
	info.city_no=$('#cityY').val();
	info.br1=$("#brandoneY").val();//品牌1
	info.brxh1=$("#brandxh1").val();//品牌型号1
	info.brname1=$("#brandoneY").find("option:selected").text();//品牌1name
	info.brxhname1=$("#brandxh1").find("option:selected").text();//型号name
	$("#yh").load('pages/terminal/product/showOne.jsp',info,function(){});
	$("#yh").show();			
	$($("#yh .yidiv")[0]).show();
});
</script>

<!--换机查询条件区域 -->
<script type="text/javascript">
/*  月历start    */
$(function(){  
    var mydate = new Date();
	   var str = "" + mydate.getFullYear() + "-";
	   str += (mydate.getMonth()-8);
	//市场起始月份
	$("#startH").val(str);
    $('#startH').datebox({  
 	    editable:false ,
         onShowPanel: function () {//显示日趋选择对象后再触发弹出月份层的事件，初始化时没有生成月份层  
             span.trigger('click'); //触发click事件弹出月份层  
             if (!tds) setTimeout(function () {//延时触发获取月份对象，因为上面的事件触发和对象生成有时间间隔  
                 tds = p.find('div.calendar-menu-month-inner td');  
                 tds.click(function (e) {  
                     e.stopPropagation(); //禁止冒泡执行easyui给月份绑定的事件  
                     var year = /\d{4}/.exec(span.html())[0]//得到年份  
                             , month = parseInt($(this).attr('abbr'), 10); //月份，这里不需要+1  
                     $('#startH').datebox('hidePanel')//隐藏日期对象  
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
     var p = $('#startH').datebox('panel'), //日期选择对象  
         tds = false, //日期选择对象中月份  
         span = p.find('span.calendar-text'); //显示月份层的触发控件     
 });  
$(function () {  
    var mydate = new Date();
	   var str = "" + mydate.getFullYear() + "-";
	   str += (mydate.getMonth()+1);
	 //市场停止月份
	$("#stopH").val(str);
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
             
 });
/*  月历 end   */
/* 联动条件查询   */
//省份、地市级联 操作
function findCityH(){	
	$("#cityH").empty();
	$("#cityH").append("<option value='qxz'>--请选择--</option>");
	var AREA_NO = $("#provinceH").val();
	$.post('<e:url value="/pages/terminal/product/productAction.jsp?eaction=seleCityList"/>',{ qdValue: AREA_NO},function(data){
		var city =eval(data.trim());
      	for(var i = 0;i<city.length;i++){
 			$("#cityH").append("<option value='"+city[i].CITY_NO+"'>"+city[i].CITY_NAME+"</option>");
 		}
    });
}

//品牌型号联动
function linkageH21(qdVal){
	$("#brandHxh1").empty();
	var obj ='';
	 $.post(
			 '<e:url value="/pages/terminal/product/productAction.jsp?eaction=ordersList"/>',
			 {qdValue:qdVal}, 
			 function(data){
			 	obj = $.parseJSON($.trim(data));
			 	for(var i = 0;i < obj.length;i++){
					 var w =new Option(obj[i].MODEL_NAME,obj[i].MODEL_NO);
					 document.getElementById("brandHxh1").options.add(w);
			 	}
			 });
}
function linkageH22(qdVal){
	
	var pp6 = $("#brandtwoH").val();
	if(pp6==''){
		$("#brandHxh2").empty();
		$("#brandHxh2").append("<option value=''>--请选择--</option>");
	}else{		
		$("#brandHxh2").empty();	
	var obj ='';
	 $.post(
			 '<e:url value="/pages/terminal/product/productAction.jsp?eaction=ordersList"/>',
			 {qdValue:qdVal}, 
			 function(data){
			 	obj = $.parseJSON($.trim(data));
			 	for(var i = 0;i < obj.length;i++){
					 var w =new Option(obj[i].MODEL_NAME,obj[i].MODEL_NO);
					 document.getElementById("brandHxh2").options.add(w);
			 	}
			 });
	}
}
function linkageH23(qdVal){	
	var pp7 = $("#brandthreeH").val();
	if(pp7==''){
		$("#brandHxh3").empty();
		$("#brandHxh3").append("<option value=''>--请选择--</option>");
	}else{		
		$("#brandHxh3").empty();	
	var obj ='';
	 $.post(
			 '<e:url value="/pages/terminal/product/productAction.jsp?eaction=ordersList"/>',
			 {qdValue:qdVal}, 
			 function(data){
			 	obj = $.parseJSON($.trim(data));
			 	for(var i = 0;i < obj.length;i++){
					 var w =new Option(obj[i].MODEL_NAME,obj[i].MODEL_NO);
					 document.getElementById("brandHxh3").options.add(w);
			 	}
			 });
	}
}
//初始化换机页面
$(function(){
	findCityH();
	var getnowMonth=201611;
 	var info={};
 	info.start_month=$('#startH').datebox('getValue').replace("-", "");//起始月
 	info.stop_month=$('#stopH').datebox('getValue').replace("-", "");//结束月
	info.provc_no=$('#provinceH').val();//省份
	info.pronameH=$("#provinceH").find("option:selected").text();//省份的name
	info.city_name=$("#cityH").find("option:selected").text();//地市name
	info.city_no=$('#cityH').val();
	info.br1=$("#brandoneH").val();//品牌1
	info.brxh1=$("#brandHxh1").val();//品牌型号1
	info.brname1=$("#brandoneH").find("option:selected").text();//品牌1name
	info.brxhname1=$("#brandHxh1").find("option:selected").text();//型号name
	$("#hj").load('pages/terminal/product/hjShowOne.jsp',info,function(){});
	$("#hj").show();
	$($("#hj .yidiv")[0]).show();
});
</script>

</head>
<body>
<div id="boncEntry">
	

	<div class="cd-secondary-nav">
		<div class="containerWraper">
			<div class="navbox current">
				<a href="javascript:void(0)" class="nav01 ">竞品首页</a>
			</div>
			<div class="navbox">
				<a href="javascript:void(0)" class="nav02">市场</a>
			</div>
			<div class="navbox">
				<a href="javascript:void(0)" class="nav03">用户</a>
			</div>
			<div class="navbox">
				<a href="javascript:void(0)" class="nav04">换机</a>
			</div>
			<div style="margin:0 auto;widht:1024px;">
				<span class="line"></span>
			</div>
		</div>
	</div>
	<div class="cd-main-content sub-nav-hero">
		<!-- 竞品首页 -->
		<div class="cd-zd-tabitem" style="padding:50px 0 0 0">
			<div class="box01Product">
				<!-- echarts预留位置 -->
				<c:nbar height="200px" id='testlist' width="300" 
				   showexport="false" all_num="name:总量,type:spline" yaxis="title: ,unit:台,min:0"
				  dimension="modelname" 
				 items="${testlist.list}"  legend="false"
				 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>
				<!-- echarts预留位置 -->
				<p class="p1">总量</p>
			</div>
			<div class="box01Product">
				<!-- echarts预留位置 -->
				<c:nbar height="200px" id='testlist1' width="300" 
				  new_num="name:新增,type:spline" yaxis="title: ,unit:台,min:0"
				  dimension="modelname"  showexport="false"
				 items="${testlist1.list}"  legend="false"
				 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>
				<!-- echarts预留位置 -->
				<p class="p2">新增</p>
			</div>
			<div class="box01Product">
				<!-- echarts预留位置 -->
				<c:nbar height="200px" id='testlist2' width="300" 
				online_num="name:在网,type:spline" yaxis="title: ,unit:台,min:0"
				  dimension="modelname"  showexport="false"
				 items="${testlist2.list}"  legend="false"
				 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>
				<!-- echarts预留位置 -->
				<p class="p3">在网</p>
			</div>
			<div class="box01Product">
				<!-- echarts预留位置 -->
					<c:nbar height="200px" id='testlist3' width="300" 
				off_num="name:离网,type:spline" yaxis="title: ,unit:台,min:0"
				  dimension="modelname"  showexport="false"
				 items="${testlist3.list}"  legend="false"
				 colors="['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe']"/>
				<!-- echarts预留位置 -->
				<p class="p4">离网</p>
			</div>
		</div>
		<!-- //竞品首页 -->
		<!-- 市场 -->
		<div class="cd-zd-tabitem">
			<!-- 查询条件 -->
			<div class="search">
				<div class="searcharea">
					<div class="line">
					 <dl class="dlsearch">
							<dt>省级</dt>
							<dd>							
								<select name="provinceS" id="provinceS" style="width:150px;"  onchange="findCityS();">
									<e:forEach items="${areaL.list}" var="item">
									<option value="${item.AREA_NO }">${item.AREA_NAME }</option>
									</e:forEach>
								</select>																			
							</dd>
					</dl>
						<dl class="dlsearch">
							<dt>地市</dt>
							<dd>
							<select name="cityS"  id="cityS" style="width:150px;"></select>														
							</dd>
						</dl>													
						<dl class="dlsearch">															
							<dt><span class="spantext">时间</span></dt>
							<dd><input id="startS" style="width:100px;"></dd>
							<dt><span class="spantext">至</span></dt>
							<dd><input id="stopS" style="width:100px;"></dd>						
						</dl> 		
					</div>
					<div class="line2">
						<dl class="dlsearch">
							<dt>品牌1</dt>
							<e:select id="brandoneS" name="brandoneS" items="${brandlist1.list}" label="BRAND_NAME" value="BRAND_NO" defaultValue="${param.BRAND_NO}" onchange="linkageS21(this.value);"/>
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>型号</dt>
							<dd>
								<select id="brandSxh1" name="brandSxh1" style="width:100px">
															
								</select>																	
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>品牌2</dt>
							<dd>
								<e:select id="brandtwoS" name="brandtwoS" items="${brandlist1.list}" label="BRAND_NAME" value="BRAND_NO" headLabel="请选择" headValue="" defaultValue="${param.BRAND_NO}" onchange="linkageS22(this.value);"/>
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>型号</dt>
							<dd>
								<select id="brandSxh2" name="brandSxh2" style="width:100px">
								<option value="">--请选择--</option>								
								</select>
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>品牌3</dt>
							<dd>
								<e:select id="brandthreeS" name="brandthreeS" items="${brandlist1.list}" label="BRAND_NAME" value="BRAND_NO" headLabel="请选择" headValue=""  defaultValue="${param.BRAND_NO}" onchange="linkageS23(this.value);"/>
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>型号</dt>
							<dd>
								<select id="brandSxh3" name="brandSxh3" style="width:100px">
								<option value="">--请选择--</option>								
								</select>
							</dd>
						</dl>
						<span class=" btncompare"><span class="span" onclick="compareBut('S');">对比</span></span>
					</div>
				</div>
			</div>
			<!-- //查询条件 -->
			<!-- 市场图片展示区-->
			<div id="sc" style="display: none"></div>
			<!-- //市场图片展示区-->	
		</div>
		<!-- //市场 -->
		<!-- 用户 -->
		<div class="cd-zd-tabitem">
			<!-- 查询条件 -->
			<div class="search">
				<div class="searcharea">
					<div class="line">
					 <dl class="dlsearch">
							<dt>省级</dt>
							<dd>
								<select name="provinceY" id="provinceY" style="width:150px;"  onchange="findCityY();">
									<e:forEach items="${areaL.list}" var="item">
									<option value="${item.AREA_NO }">${item.AREA_NAME }</option>
									</e:forEach>
								</select>								
							</dd>
					</dl>
						<dl class="dlsearch">
							<dt>地市</dt>
							<dd>
							<select name="cityY"  id="cityY" style="width:150px;"></select>																					
							</dd>
						</dl>													
						<dl class="dlsearch">															
							<dt><span class="spantext">时间</span></dt>
							<dd><input id="start" style="width:100px;"></dd>
							<dt><span class="spantext">至</span></dt>
							<dd><input id="stop" style="width:100px;"></dd>						
						</dl> 		
					</div>
					<div class="line2">
						<dl class="dlsearch">
							<dt>品牌1</dt>
							<e:select id="brandoneY" name="brandoneY" items="${brandlist1.list}" label="BRAND_NAME" value="BRAND_NO" defaultValue="${param.BRAND_NO}" onchange="linkage21(this.value);"/>
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>型号</dt>
							<dd>
								<select id="brandxh1" name="brandxh1" style="width:100px">															
								</select>																	
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>品牌2</dt>
							<dd>
								<e:select id="brandtwoY" name="brandtwoY" items="${brandlist1.list}" label="BRAND_NAME" value="BRAND_NO" headLabel="请选择" headValue="" defaultValue="${param.BRAND_NO}" onchange="linkage22(this.value);"/>
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>型号</dt>
							<dd>
								<select id="brandxh2" name="brandxh2" style="width:100px">
								<option value="">--请选择--</option>								
								</select>
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>品牌3</dt>
							<dd>
								<e:select id="brandthreeY" name="brandthreeY" items="${brandlist1.list}" label="BRAND_NAME" value="BRAND_NO" headLabel="请选择" headValue=""  defaultValue="${param.BRAND_NO}" onchange="linkage23(this.value);"/>
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>型号</dt>
							<dd>
								<select id="brandxh3" name="brandxh3" style="width:100px">
								<option value="">--请选择--</option>								
								</select>
							</dd>
						</dl>
						<span class=" btncompare"><span class="span" onclick="compareBut('Y');">对比</span></span>
					</div>
				</div>
			</div>
			<!-- //查询条件 -->
			<!-- 用户饼图展示区 -->
			<div id="yh" style="display: none"></div>
			<!-- //用户饼图展示区 -->	
		</div>		
		<!-- //用户 -->		
		<!-- 换机 -->
		<div class="cd-zd-tabitem">
			<!-- 查询条件 -->
			<div class="search">
				<div class="searcharea">
					<div class="line">
					 <dl class="dlsearch">
							<dt>省级</dt>
							<dd>
								<select name="provinceH" id="provinceH" style="width:150px;"  onchange="findCityH();">
									<e:forEach items="${areaL.list}" var="item">
									<option value="${item.AREA_NO }">${item.AREA_NAME }</option>
									</e:forEach>
								</select>	
							</dd>
					</dl>
						<dl class="dlsearch">
							<dt>地市</dt>
							<dd>
							<select name="cityH"  id="cityH" style="width:150px;"></select>																																	
							</dd>
						</dl>													
						<dl class="dlsearch">															
							<dt><span class="spantext">时间</span></dt>
							<dd><input id="startH" style="width:100px;"></dd>
							<dt><span class="spantext">至</span></dt>
							<dd><input id="stopH" style="width:100px;"></dd>						
						</dl> 		
					</div>
					<div class="line2">
						<dl class="dlsearch">
							<dt>品牌1</dt>
							<e:select id="brandoneH" name="brandoneH" items="${brandlist1.list}" label="BRAND_NAME" value="BRAND_NO" defaultValue="${param.BRAND_NO}" onchange="linkageH21(this.value);"/>
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>型号</dt>
							<dd>
								<select id="brandHxh1" name="brandHxh1" style="width:100px">							
								</select>																	
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>品牌2</dt>
							<dd>
								<e:select id="brandtwoH" name="brandtwoH" items="${brandlist1.list}" label="BRAND_NAME" value="BRAND_NO" headLabel="请选择" headValue="" defaultValue="${param.BRAND_NO}" onchange="linkageH22(this.value);"/>
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>型号</dt>
							<dd>
								<select id="brandHxh2" name="brandHxh2" style="width:100px">
									<option value="">--请选择--</option>							
								</select>
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>品牌3</dt>
							<dd>
								<e:select id="brandthreeH" name="brandthreeH" items="${brandlist1.list}" label="BRAND_NAME" value="BRAND_NO" headLabel="请选择" headValue=""  defaultValue="${param.BRAND_NO}" onchange="linkageH23(this.value);"/>
							</dd>
						</dl>
						<dl class="dlsearch">
							<dt>型号</dt>
							<dd>
								<select id="brandHxh3" name="brandHxh3" style="width:100px">
										<option value="">--请选择--</option>						
								</select>
							</dd>
						</dl>
						<span class=" btncompare"><span class="span" onclick="compareBut('H');">对比</span></span>
					</div>
				</div>
			</div>
			<!-- //查询条件 -->
			<div id="hj" style="display: none">
				<!-- 换机展示区 -->
			</div>
		</div>
		<!-- //换机 -->


<script type="text/javascript">
//市场条件参数判断
function sccheckOpt(){		
	var getnowMonth=201611;
	var start_mon= $('#startS').datebox('getValue').replace("-", "");//起始月
 	var stop_mon=$('#stopS').datebox('getValue').replace("-", "");//结束月
 	if(start_mon.length==5){
		start_mon =start_mon.substr(0,4)+"0"+start_mon.substr(4);
	}
	if(stop_mon.length==5){
		stop_mon =stop_mon.substr(0,4)+"0"+stop_mon.substr(4);
	}
 	var provc_no=$('#provinceS').val();//省份
 	var pronameS=$("#provinceS").find("option:selected").text();//省份的name
 	var city_no=$('#cityS').val();//地市
 	var br1=$("#brandoneS").val();//品牌1
	var br2=$("#brandtwoS").val();//品牌2
	var br3=$("#brandthreeS").val();//品牌3
	var brxh1=$("#brandSxh1").val();//品牌型号1
	var brxh2=$("#brandSxh2").val();//品牌型号2
	var brxh3=$("#brandSxh3").val();//品牌型号3
	
	 var info={};
		info.nowMonth=getnowMonth;
		info.start_month=start_mon;
		info.stop_month=stop_mon;
		info.provc_no=provc_no;
		info.pronameS=pronameS;
		info.city_no=city_no;
		info.br1=br1;
		info.br2=br2;
		info.br3=br3;
		info.brxh1=brxh1;
		info.brxh2=brxh2;
		info.brxh3=brxh3;
		info.brname1=$("#brandoneS").find("option:selected").text();//品牌1name
		info.brxhname1=$("#brandSxh1").find("option:selected").text();//型号1name
		info.brname2=$("#brandtwoS").find("option:selected").text();//品牌2name
		info.brxhname2=$("#brandSxh2").find("option:selected").text();//型号2name
		info.brname3=$("#brandthreeS").find("option:selected").text();//品牌3name
		info.brxhname3=$("#brandSxh3").find("option:selected").text();//型号3name 
	  if(parseInt(stop_mon) >= parseInt(start_mon)){
		  if(br1 != '' && br1.length != 0 && br1 != null){
			  if(brxh1=='' || brxh1.length == 0){
				  $.messager.alert("提示", "请选择到品牌1的具体型号，再进行比对！","info",function(){});
			  }else{				  
				  if(br2 != '' && br2.length != 0 && br2 != null){					  
						 if(brxh2 == '' || brxh2.length == 0){
							 $.messager.alert("提示", "请选择到品牌2的具体型号，再进行比对！","info",function(){});
				 		  }else{
				 			 if(br1 == br2 && brxh2 == brxh1){
				 				$.messager.alert("提示", "该型号已选取，请选取不同型号进行比对！","info",function(){});
							 }else{
								 if(br3 != '' && br3.length != 0 && br3 != null){
						 				if(brxh3=='' || brxh3.length == 0){
						 					$.messager.alert("提示", "请选择到品牌3的具体型号，再进行比对！","info",function(){});
							 	 		  }else{
							 	 			if((br2 == br3 && brxh3 == brxh2) ||( br1 == br3 && brxh3 == brxh1)){
							 	 				$.messager.alert("提示", "该型号已选取，请选取不同型号进行比对！","info",function(){});
											  }else{
									 	 			$("#sc").load('pages/terminal/product/scShowThree.jsp',info,function(){});	 			 				 
											  }   
							 	 		  } 				 				 
						 			 }else{				 	 			
						 	 			$("#sc").load('pages/terminal/product/scShowTwo.jsp',info,function(){});	 			 				 
						 			 }		
							 }  				 			 		 			
				 		  }					  
				  }else{
					  if(br3 != '' && br3.length != 0 && br3 != null){						  
						  $.messager.alert("提示", "品牌2尚为空，请按序选取!","info",function(){});
					  }else{
						  $("#sc").load('pages/terminal/product/scShowOne.jsp',info,function(){});	
					  }	 	 				 	 							  
				  }  		
			  }	
		  }		 	  		 		
	  }else {
		  $.messager.alert("提示", "请选择正确的时间间隔！","info",function(){});		   
	  }
	
}

//用户条件参数判断
function yhcheckOpt(){
	var start_mon= $('#start').datebox('getValue').replace("-", "");//起始月
 	var stop_mon=$('#stop').datebox('getValue').replace("-", "");//结束月
 	if(start_mon.length==5){
		start_mon =start_mon.substr(0,4)+"0"+start_mon.substr(4);
	}
	if(stop_mon.length==5){
		stop_mon =stop_mon.substr(0,4)+"0"+stop_mon.substr(4);
	}
 	var provc_no=$('#provinceY').val();//省份
 	var pronameY=$("#provinceY").find("option:selected").text();//省份的name
 	var city_no=$('#cityY').val();//地市
 	var br1=$("#brandoneY").val();//品牌1
	var br2=$("#brandtwoY").val();//品牌2
	var br3=$("#brandthreeY").val();//品牌3
	var brxh1=$("#brandxh1").val();//品牌型号1
	var brxh2=$("#brandxh2").val();//品牌型号2
	var brxh3=$("#brandxh3").val();//品牌型号3
	var info={};			 	 		 	
		info.start_month=start_mon;
		info.stop_month=stop_mon;
		info.provc_no=provc_no;
		info.pronameY=pronameY;
		info.city_no=city_no;
		info.br1=br1;
		info.br2=br2;
		info.br3=br3;
		info.brxh1=brxh1;
		info.brxh2=brxh2;
		info.brxh3=brxh3;
		info.brname1=$("#brandoneY").find("option:selected").text();//品牌1name
		info.brxhname1=$("#brandxh1").find("option:selected").text();//型号1name
		info.brname2=$("#brandtwoY").find("option:selected").text();//品牌2name
		info.brxhname2=$("#brandxh2").find("option:selected").text();//型号2name
		info.brname3=$("#brandthreeY").find("option:selected").text();//品牌3name
		info.brxhname3=$("#brandxh3").find("option:selected").text();//型号3name
	
	  if(parseInt(stop_mon) >= parseInt(start_mon)){
		  if(br1 != '' && br1.length != 0 && br1 != null){
			  if(brxh1=='' || brxh1.length == 0){
				  $.messager.alert("提示", "请选择到品牌1的具体型号，再进行比对！","info",function(){});
			  }else{				  
				  if(br2 != '' && br2.length != 0 && br2 != null){					  
						 if(brxh2 == '' || brxh2.length == 0){
							 $.messager.alert("提示", "请选择到品牌2的具体型号，再进行比对！","info",function(){});
				 		  }else{
				 			 if(br1 == br2 && brxh2 == brxh1){
				 				$.messager.alert("提示", "该型号已选取，请选取不同型号进行比对！","info",function(){});
							 }else{
								 if(br3 != '' && br3.length != 0 && br3 != null){
						 				if(brxh3=='' || brxh3.length == 0){
						 					$.messager.alert("提示", "请选择到品牌3的具体型号，再进行比对！","info",function(){});
							 	 		  }else{
							 	 			if((br2 == br3 && brxh3 == brxh2) ||( br1 == br3 && brxh3 == brxh1)){
							 	 				$.messager.alert("提示", "该型号已选取，请选取不同型号进行比对！","info",function(){});
											  }else{
									 	 			$("#yh").load('pages/terminal/product/showThree.jsp',info,function(){});	 			 				  
											  }
							 	 		  } 				 				 
						 			 }else{						 	 						 	 		
						 	 			$("#yh").load('pages/terminal/product/showTwo.jsp',info,function(){});	 			 				 
						 			 }									 
							 }		 						 			
				 		  }					  
				  }else{
					  if(br3 != '' && br3.length != 0 && br3 != null){						  
						  $.messager.alert("提示", "品牌2尚为空，请按序选取!","info",function(){});
					  }else{
						  $("#yh").load('pages/terminal/product/showOne.jsp',info,function(){});		
					  }	 		 	 			 	 								  
				  }  		
			  }	
		  }		 	  		 		
	  }else {
		  $.messager.alert("提示", "请选择正确的时间间隔！","info",function(){});		   
	  }
	
}
	

//换机条件参数判断
function hjcheckOpt(){
	var getnowMonth=201611;
	var start_mon= $('#startH').datebox('getValue').replace("-", "");//起始月
 	var stop_mon=$('#stopH').datebox('getValue').replace("-", "");//结束月
 	if(start_mon.length==5){
		start_mon =start_mon.substr(0,4)+"0"+start_mon.substr(4);
	}
	if(stop_mon.length==5){
		stop_mon =stop_mon.substr(0,4)+"0"+stop_mon.substr(4);
	}
 	var provc_no=$('#provinceH').val();//省份
 	var pronameH=$("#provinceH").find("option:selected").text();//省份的name
 	var city_no=$('#cityH').val();//地市
 	var br1=$("#brandoneH").val();//品牌1
	var br2=$("#brandtwoH").val();//品牌2
	var br3=$("#brandthreeH").val();//品牌3
	var brxh1=$("#brandHxh1").val();//品牌型号1
	var brxh2=$("#brandHxh2").val();//品牌型号2
	var brxh3=$("#brandHxh3").val();//品牌型号3
	
	var info={};
		info.nowMonth=getnowMonth;
		info.start_month=start_mon;
		info.stop_month=stop_mon;
		info.provc_no=provc_no;
		info.pronameH=pronameH;//用到的
		info.city_no=city_no;
	 	//info.provc_name=$("#provinceH").find("option:selected").text();//省份name
		info.city_name=$("#cityH").find("option:selected").text();//地市name
		info.br1=br1;
		info.br2=br2;
		info.br3=br3;
		info.brxh1=brxh1;
		info.brxh2=brxh2;
		info.brxh3=brxh3;
		info.brname1=$("#brandoneH").find("option:selected").text();//品牌1name
		info.brxhname1=$("#brandHxh1").find("option:selected").text();//型号1name
		info.brname2=$("#brandtwoH").find("option:selected").text();//品牌2name
		info.brxhname2=$("#brandHxh2").find("option:selected").text();//型号2name
		info.brname3=$("#brandthreeH").find("option:selected").text();//品牌3name
		info.brxhname3=$("#brandHxh3").find("option:selected").text();//型号3name
	
	  if(parseInt(stop_mon) >= parseInt(start_mon)){
		  if(br1 != '' && br1.length != 0 && br1 != null){
			  if(brxh1=='' || brxh1.length == 0){
				  $.messager.alert("提示", "请选择到品牌1的具体型号，再进行比对！","info",function(){});
			  }else{				  
				  if(br2 != '' && br2.length != 0 && br2 != null){					  
						 if(brxh2 == '' || brxh2.length == 0){
							 $.messager.alert("提示", "请选择到品牌2的具体型号，再进行比对！","info",function(){});
				 		  }else{
				 			 if(br1 == br2 && brxh2 == brxh1){
				 				$.messager.alert("提示", "该型号已选取，请选取不同型号进行比对！","info",function(){});
							 }else{
								 if(br3 != '' && br3.length != 0 && br3 != null){
						 				if(brxh3=='' || brxh3.length == 0){
						 					$.messager.alert("提示", "请选择到品牌3的具体型号，再进行比对！","info",function(){});
							 	 		  }else{
							 	 			if((br2 == br3 && brxh3 == brxh2) ||( br1 == br3 && brxh3 == brxh1)){
							 	 				$.messager.alert("提示", "该型号已选取，请选取不同型号进行比对！","info",function(){});
											  }else{
									 	 			$("#hj").load('pages/terminal/product/hjShowThree.jsp',info,function(){});	 			 				  
											  }
							 	 		  } 				 				 
						 			 }else{						 	 			
						 	 			$("#hj").load('pages/terminal/product/hjShowTwo.jsp',info,function(){});	 			 				 
						 			 }	 								 
							 }				 						 			
				 		  }					  
				  }else{
					  if(br3 != '' && br3.length != 0 && br3 != null){						  
						  $.messager.alert("提示", "品牌2尚为空，请按序选取!","info",function(){});
					  }else{
						  $("#hj").load('pages/terminal/product/hjShowOne.jsp',info,function(){});		
					  }	 		 	 				 	 				 	 							  
				  }  		
			  }	
		  }		 	  		 		
	  }else {
		  $.messager.alert("提示", "请选择正确的时间间隔！","info",function(){});	   
	  }
	
}

	//终端比较
	function compareBut(sym){
		//市场的条件判断操作
		if(sym=='S'){
			sccheckOpt();			
		}
		//用户的条件判断操作
		if(sym=='Y'){
			yhcheckOpt();			
		}
		//换机的条件判断操作
		if(sym=='H'){
			hjcheckOpt();			
		}
		//判断用户比对几个品牌
		var n='1';
		var brandone = $("#brandone"+sym).val();
		var brandtwo = $("#brandtwo"+sym).val();
		var brandthree = $("#brandthree"+sym).val();			
		if(brandtwo.length == 0 && brandthree.length==0){
			n='1';
		}
		if(brandtwo.length != 0 && brandthree.length==0){
			n='2';
		}
		if(brandtwo.length != 0 && brandthree.length!=0){
			n='3';
		}
		
		if(n=='3' ){//选择3个品牌型号时
			if(sym=='S'){
				$("#sc").show();
				$("#sc .yidiv").hide();
				$($("#sc .yidiv")[2]).show();
			}
			if(sym=='Y'){
				$("#yh").show();
				$("#yh .yidiv").hide();
				$($("#yh .yidiv")[2]).show();				
			}
			if(sym=='H'){
				$("#hj").show();
				$("#hj .yidiv").hide();
				$($("#hj .yidiv")[2]).show();
			}
		}else if(n=='2' ){//选择2个品牌型号时
			if(sym=='S'){
				$("#sc").show();
				$("#sc .yidiv").hide();
				$($("#sc .yidiv")[1]).show();
			}
			if(sym=='Y'){
				$("#yh").show();
				$("#yh .yidiv").hide();				
				$($("#yh .yidiv")[1]).show();
			}
			if(sym=='H'){
				$("#hj").show();
				$("#hj .yidiv").hide();
				$($("#hj .yidiv")[1]).show();
			}

		}else if(n=='1' ){//选择1个品牌型号时
			if(sym=='S'){
				$("#sc").show();
				$($("#sc .yidiv")[0]).show();
			}
			if(sym=='Y'){
				$("#yh").show();			
				$($("#yh .yidiv")[0]).show();
			}
			if(sym=='H'){
				$("#hj").show();
				$($("#hj .yidiv")[0]).show();
			}
		}else if(n=='0' ){
			alert("请至少选择一个品牌型号！");
			return false;
		}

	}
	var boxwidth = $(".containerWraper").width();
	var boxitemwidth = boxwidth / $(".navbox").length;
	$(".cd-zd-tabitem").eq(0).show();
	$(".navbox").eq(0).show();
	$(".navbox").hover(function(){
		$(".line").stop(true,true).animate({'left':$(this).index()*200},'fast');
	});
	$(".navbox").click(function(){
		var tabIndex = $(this).index();
		$(this).addClass("current").siblings().removeClass("current");
		$(".cd-zd-tabitem").eq(tabIndex).show().siblings().hide();
	});	
	
	
</script>

</body>
</html>
