<%@ tag body-content="empty" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="id" required="true" %>                                                  
<%@ attribute name="queryPath" required="true" %> 
<%@ attribute name="defaultDate" required="true" %>    <e:description>默认日期</e:description>
<%@ attribute name="defaultArea" required="true" %>    <e:description>默认地市</e:description>
<%@ attribute name="tsrq" required="true" %>    <e:description>推送日期</e:description>
<style>
			.webix_view.webix_grouplist { height:510px!important;}
.webix_list_item { height:42px!important; line-height:42px!important;}
.webix_list_item:before {content:''!important; margin-right:0px!important;}
</style>
<e:set var="areaParam" value="${sessionScope.UserInfo.AREA_ECODE}"/>
<e:q4l var="areaList">
	select area_no id,area_desc value from DIM.DIM_AREA_NO_NEW 
	where 1=1 
	<e:if condition="${null!=areaParam&&''!=areaParam&&'-1'!=areaParam}">
	and area_no='${areaParam}'
	</e:if>
	ORDER BY KPI_INDEX
</e:q4l>


<div id="queryBtn" style="position:fixed;top:5px;right:5px;z-index:1000">
	<a href="javascript:void(0)" onclick="query()">
	   <img id="searchImg" width="39px" height="39px" src="<e:url value='/pages/mbuilder/resources/images/searchIcon.png'/>" />
	</a>
	
</div>

<div id="areaA" style="display:none;">
      地市：<e:select items="${areaList.list}" label="VALUE" value="ID"  name="areaComb" id="areaComb" required="true" defaultValue="${defaultArea}" style="width:80%" />
</div>

<script type="text/javascript">
var tip = document.getElementById("searchImg");

tip.addEventListener('touchstart',function(){
    tip.src="<e:url value='/pages/mbuilder/resources/images/searchIcon_.png'/>";
});

tip.addEventListener('touchend',function(){
    tip.src="<e:url value='/pages/mbuilder/resources/images/searchIcon.png'/>";
});
function query(){
	            document.getElementById("areaA").style.display="block";
	            /* var areaItems = '${e:java2json(areaList.list)}';
	            areaItems=areaItems.replace(/ID/g,"id");
	            areaItems=areaItems.replace(/VALUE/g,"value");
	            areaItems=eval('(' + areaItems + ')'); */
	            
	            var date="${defaultDate}";
	 			var year = parseInt(date.substr(0,4));
	 			var month = parseInt(date.substr(4,2))-1;
	 			var day = parseInt(date.substr(6,2));
	 			
	 			var acct_date = '${tsrq}';
		        var acct_year = acct_date.substring(0, 4);
		        var acct_month = acct_date.substring(4, 6)-1;
		        var acct_day = acct_date.substring(6, 8);
				webix.i18n.locales["acct_date"]={
						calendar:{
							monthFull:["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
							monthShort:["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
							dayFull:["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
							dayShort:["日", "一", "二", "三", "四", "五", "六"]
							
						}
					};
				webix.ui({
					view:"window",
		            id:"win3", 
		            fullscreen:true,
					height:200,
				    width:240,
				     head:{
						view:"toolbar", cols:[
							{view:"label", label: "页面查询" }
							],height:20
					},
				    position:"center",
					body:{
		                view:"form", scroll:false,
						width:240,
						elements:[
						    /* { view:"combo", id:'areaCombo', label: '地市：', value:"${defaultArea}",
						    	  options:areaItems
						    }, */
						    {
						        view:"htmlform",
						        content: "areaA",
						        height:40,
						        width:"auto"
						    },
							{   view:"calendar",
							    id:"acct_date",
							    date:new Date(year,month,day),
							    blockDates:function(date){
			                	    if (date.getFullYear() < acct_year ){
			                	    	return false
			                        }else if(date.getFullYear() <= acct_year && date.getMonth() < acct_month){
			                        	return false	  
			                        }else if(date.getFullYear() <= acct_year && date.getMonth() <= acct_month && date.getDate() <= acct_day){
			                			return false
			                        }else{
			                        	return true;
			                        }
			                    },
							    weekHeader:true,
							    view:"calendar",
							    events:webix.Date.isHoliday, 
							    calendarDateFormat: "%Y-%m-%d",
							    width:300,
							    height:230},                                        
							{ margin:5, cols:[
								{ view:"button", label:"确定" , type:"form",click:doQuery },
								{ view:"button", label:"取消",click:closeWin}
							]}
						]				
				   }
					
				}).show();
				webix.i18n.setLocale("acct_date");
				$$("acct_date").setValue(new Date(year,month,day));
				tip.style.display="none";
			}

            function closeWin(){
            	$$('win3').hide();
            	tip.style.display="block";
            }
			function formatDateStr(date){
				
				var year = date.getFullYear();
				var month = date.getMonth()+1;
				var day = date.getDate();
				if(month<10){
					month='0'+month;
				}
				if(day<10){
					day='0'+day;
				}
				return (""+year+month+day);
			}
			function doQuery(){
				var dateObj=new Date($$("acct_date").getValue());
				var acct_date = formatDateStr(dateObj);
				var area_no=document.getElementById("areaComb").options[document.getElementById("areaComb").selectedIndex].value;
				document.getElementById("areaA").style.display="none";
				window.location.href="${queryPath}"+"?acct_date="+acct_date+"&area_no="+area_no+"&tsrq=${tsrq}";
				$$('win3').close();
				tip.style.display="block";
			}
</script>
