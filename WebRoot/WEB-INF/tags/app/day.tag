<%@ tag body-content="empty" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="id" required="true" %>    <e:description>id（必选）</e:description>
<%@ attribute name="name" required="true" %>    <e:description>name（必选）</e:description>
<%@ attribute name="defaultValue" required="false" %>    <e:description>默认值</e:description>
<%@ attribute name="view" required="false" %>    <e:description>显示类型</e:description>
<%@ attribute name="width" required="false" %>    <e:description>日期控件宽度</e:description>
<%@ attribute name="height" required="false" %>    <e:description>日期控件高度</e:description>
<%@ attribute name="labelWidth" required="false" %>    <e:description>日期变迁宽度</e:description>
<%@ attribute name="label" required="false"%>      <e:description>标签文字</e:description>
<%@ attribute name="format" required="false"%>      <e:description>格式化字符串</e:description>
<%@ attribute name="getValueMethod" required="false"%>      <e:description>取值方法名</e:description>
<%@ attribute name="onChange" required="false"%>       <e:description>日期改变事件</e:description>
  
    
<e:if condition="${defaultValue!=null&&defaultValue ne ''}">
  <e:if condition="${e:indexOf(defaultValue,'-')>0}">
     <e:set var="year" value="${e:split(defaultValue,'-')[0]}" /> 
     <e:set var="month" value="${e:split(defaultValue,'-')[1]}" /> 
     <e:set var="date" value="${e:split(defaultValue,'-')[2]}" /> 
  </e:if>
  <e:if condition="${e:indexOf(defaultValue,'/')>0}">
     <e:set var="year" value="${e:split(defaultValue,'/')[0]}" /> 
     <e:set var="month" value="${e:split(defaultValue,'/')[1]}" /> 
     <e:set var="date" value="${e:split(defaultValue,'/')[2]}" /> 
  </e:if>
  <e:if condition="${e:length(defaultValue)==8}">
     <e:set var="year" value="${e:substring(defaultValue,0,4)}" /> 
     <e:set var="month" value="${e:substring(defaultValue,4,6)}" /> 
     <e:set var="date" value="${e:substring(defaultValue,6,8)}" /> 
  </e:if>
</e:if>  
 
<e:if condition="${format == null||format eq ''}">
  <e:set var="format">%Y-%m-%d</e:set>
</e:if>  
   
<e:if condition="${getValueMethod == null||getValueMethod eq ''}">
  <e:set var="getValueMethod">getSelectDate_${id}</e:set>
</e:if>     
                         
<script type="text/javascript">

webix.ready(function(){
	  webix.i18n.locales["zh-cn"]={
			calendar:{
				monthFull:["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
				monthShort:["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
				dayFull:["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
				dayShort:["日", "一", "二", "三", "四", "五", "六"]
			}
		};
	 var dateWidth=document.body.clientWidth-120;
	 <e:if condition="${view!=null&&view eq 'datepicker'}">
		 webix.ui({
			    id:'day_${id}',
		        view:"datepicker", 
		        container:"cal_${id}",
		        <e:if condition="${defaultValue!=null&&defaultValue ne ''}">
		        value:new Date(${year}, ${month-1}, ${date}),
		        </e:if>
		        label:'${label}',
		        <e:if condition="${width!=null&&width ne ''}" var="widthIf">
		        width:${width},
		        </e:if>
		        <e:else condition="${widthIf}">
		        width:dateWidth,
		        </e:else>
		        format:"${format}"
		  });
		 $$("day_${id}").attachEvent("onChange", function(date){
			 document.getElementById("${name}").value=getFullDate(date);
	      });
		 webix.i18n.setLocale("zh-cn");
	 </e:if>
	 
	 <e:if condition="${view!=null&&view eq 'calendar'}">
		  webix.i18n.setLocale("zh-cn");
		  var cal=webix.ui({
			    id:'day_${id}',
		        view:"calendar", 
		        container:"cal_${id}",
		        weekHeader:true,
		        <e:if condition="${width!=null&&width ne ''}">
		        	width:${width},
		        </e:if>
		        <e:if condition="${height!=null&&height ne ''}">
		       	    height:${height},
			    </e:if>
				events:webix.Date.isHoliday
		  });
		  <e:if condition="${defaultValue!=null&&defaultValue ne ''}">
	        cal.setValue(new Date(${year}, ${month-1}, ${date}));
	      </e:if>
		   <e:if condition="${onChange!=null&&onChange ne ''}">
	         $$("day_${id}").attachEvent("onChange", ${onChange});
	      </e:if>
	      $$("day_${id}").attachEvent("onDateselect", function(date){
	    	  document.getElementById("${name}").value=getFullDate(date);
	      });
	 </e:if>
	 
	 webix.Touch.limit(true);
});

function ${getValueMethod}(){
	var selectDate=getFullDate($$('day_${id}').getValue());
	return selectDate;
}

function getFullDate(date){
	var selectDate="";
	if(date!=null&&date!=""){
		var year=date.getFullYear();
		var month=date.getMonth()+1;
		var date=date.getDate();
		month=month<10?"0"+month:month;
		date=date<10?"0"+date:date;
		selectDate=year+""+month+""+date;
	}
	return selectDate;
}

</script>

<div id="cal_${id}"></div>
<input type="hidden" name="${name}" id="${name}" <e:if condition="${defaultValue!=null&&defaultValue ne ''}">value="${year}${month}${date}"</e:if>/>