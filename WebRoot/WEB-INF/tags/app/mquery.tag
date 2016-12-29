<%@ tag body-content="empty" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="id" required="true" %>                                                  
<%@ attribute name="queryPath" required="false" %> 
<%@ attribute name="defaultDate" required="false" %>    <e:description>默认日期</e:description>
<%@ attribute name="defaultArea" required="false" %>    <e:description>默认地市</e:description>
<%@ attribute name="contentId" required="false" %>    <e:description>默认地市</e:description>
<style>
.webix_view.webix_grouplist { height:510px!important;}
.webix_list_item { height:42px!important; line-height:42px!important;}
.webix_list_item:before {content:''!important; margin-right:0px!important;}
</style>

<div id="queryBtn" style="position:fixed;top:5px;right:5px;z-index:1000">
	<a href="javascript:void(0)" onclick="queryReport()">
	   <img id="searchImg" width="39px" height="39px" src="<e:url value='/pages/mbuilder/resources/images/searchIcon.png'/>" />
	</a>
</div>


<script type="text/javascript">
var tip = document.getElementById("searchImg");

tip.addEventListener('touchstart',function(){
    tip.src="<e:url value='/pages/mbuilder/resources/images/searchIcon_.png'/>";
});

tip.addEventListener('touchend',function(){
    tip.src="<e:url value='/pages/mbuilder/resources/images/searchIcon.png'/>";
});
function queryReport(){
				 document.getElementById("${contentId}").style.display="block";
				 webix.ui({
					view:"window",
		            id:"win3", 
		            fullscreen:true,
					height:240,
				    width:240,
				     head:{
						view:"toolbar", cols:[
							{view:"label", label: "页面查询" }
							],height:30
					},
				    position:"center",
					body:{
		                view:"form", scroll:false,
						width:240,
						elements:[
						    {
						        view:"htmlform",
						        content: "${contentId}",
						        height:"auto",
						        width:"auto"
						    },                                       
							{ margin:5, cols:[
								{ view:"button", label:"确定" , type:"form",click:doQuery },
								{ view:"button", label:"取消" , click:closeWindows}
							]}
						]				
				   }
					
				}).show();
				tip.style.display="none"; 
			}

            function closeWindows(){
                $$('win3').hide();
            	tip.style.display="block";
            	document.getElementById("${contentId}").style.display="none";
            	document.getElementById("${contentId}").reset();
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
				tip.style.display="block";
				document.getElementById("${contentId}").style.display="none";
				document.getElementById("${contentId}").submit();
				$$('win3').close();
			}
</script>







