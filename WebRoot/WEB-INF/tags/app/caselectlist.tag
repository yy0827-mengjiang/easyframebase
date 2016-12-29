<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="id" required="true"%>                                        <e:description>id</e:description>
<%@ attribute name="name" required="true"%>                                      <e:description>name</e:description>
<%@ attribute name="curdesc" required="true"%>                                   <e:description>curdesc</e:description>
<%@ attribute name="curdimname" required="true"%>                                <e:description>当前维度的变量名称</e:description>
<%@ attribute name="defaultValue" required="true"%>                             <e:description>默认值 如果多选 取(request.getParameterValues("b") != null? java.util.Arrays.asList(request.getParameterValues("b")) : "[]")</e:description>
<%@ attribute name="multiple" required="true"%>                                 <e:description>是否支持多选 true or false(1 or 0)</e:description>
<%@ attribute name="parentmultiple" required="false"%>                           <e:description>上级是否支持多选 true or false(1 or 0)</e:description>
<%@ attribute name="showtype" required="false"%>                                 <e:description>0和空是正常显示，1为平铺</e:description>
<%@ attribute name="table" required="false"%>                                     <e:description>维表数据表</e:description>
<%@ attribute name="codecol" required="false"%>                                   <e:description>维表编码列</e:description>
<%@ attribute name="desccol" required="false"%>                                   <e:description>维表描述列</e:description>
<%@ attribute name="ordcol" required="false"%>                                    <e:description>维表排序列</e:description>
<%@ attribute name="parentcodecol" required="false"%>                             <e:description>联动上级维度字段</e:description>
<%@ attribute name="parentdimname" required="false"%>                             <e:description>联动上级维度变量名称</e:description>
<%@ attribute name="level" required="false"%>                                     <e:description>联动级别</e:description>
<%@ attribute name="sql" required="false"%>                                       <e:description>当手动型配置时，使用这个参数</e:description>
<%@ attribute name="onclick" required="false"%>                                  <e:description>单点事件</e:description>
<%@ attribute name="extds" required="false"%>                                    <e:description>扩展数据源</e:description>
<jsp:doBody var="bodyRes" />
<e:if condition="${sql == null || sql eq '' }">
	<e:set var="sql" value="${bodyRes}" />
</e:if>
<style type="text/css">
ul.distance_${id}{ width:97%;  min-height:50px;}
ul.distance_${id} li{font-size:14px; color:#eee; margin-top:2px; position:relative; padding-left:95px;}
ul.distance_${id} li em{ font-weight:normal; color:#999;}
ul.distance_${id} li span{  font-weight:normal; font-size:14px; padding:4px 20px;}
ul.distance_${id} li span.nomal_${id}{ background:transparent; color:#199ed8; cursor:pointer; display:inline-block;}
ul.distance_${id} li span.stop_${id}{  background:#199ee2; color:#fff; cursor:pointer;}
</style>
<e:script value="/pages/xbuilder/resources/scripts/base64.js"/>
<script>
	 var casDft_${id}_${name} = '';
     $(document).ready(function() {
    	 casDft_${id}_${name} = '${defaultValue}';
		initCas_${id}_${name}('');
		<e:if condition="${parentdimname !=null && parentdimname ne 'undefined' && parentdimname ne '' }">
			setInterval(casOnchangeListener_${id}_${name}, 100); // 定时器句柄
		</e:if>
	});
	<e:if condition="${parentdimname !=null && parentdimname ne 'undefined' && parentdimname ne '' }">
    function casOnchangeListener_${id}_${name}() {
    	var state_${id}_${name} = $("#${parentdimname}").val();
    	if(state_${id}_${name} == '') {
    		var $spaninit_${id}_${name} = $("#spaninit_${id}_${name}");
			var $checkBox_${id}_${name} = "<li id=\"li_${id}\">${curdesc}<input type=\"hidden\" id=\"${id }\" name=\"${name }\" value=\"\"/><span id=\"selb_${id}_\" class=\"stop_${id} icoReset\" onclick=\"changeCasCode${id}${name}(this);\" attrValue=\"\">不限</span>|</li>";
			$spaninit_${id}_${name}.html($checkBox_${id}_${name});
			$.parser.parse($spaninit_${id}_${name});
    	} 
    }
    </e:if>
	function casDftInit_${id}_${name}(){
		if(casDft_${id}_${name} != null && casDft_${id}_${name} != undefined && casDft_${id}_${name} != ''){
			<e:if condition="${multiple !=null && (multiple eq 'true' || multiple == true || multiple eq '1')}" var="caselectlist_elseone">
				var casDft_casDft_strs_${id}_${name} = new Array();
				casDft_strs_${id}_${name} = casDft_${id}_${name}.split(",");
				$("#selb_${id}_").removeClass("stop_${id}");
				$("#selb_${id}_").addClass("nomal_${id}");
				$.each(casDft_strs_${id}_${name}, function (index, tx) {
					$("#selb_${id}_" + tx).removeClass("nomal_${id}");
					$("#selb_${id}_" + tx).addClass("stop_${id}");
				});	
			</e:if>
			<e:else condition="${caselectlist_elseone }">
				$("#li_${id}>span").removeClass("stop_${id}");
				$("#li_${id}>span").addClass("nomal_${id}");
				$("#selb_${id}_" + casDft_${id}_${name}).removeClass("nomal_${id}");
				$("#selb_${id}_" + casDft_${id}_${name}).addClass("stop_${id}");
			</e:else>
			$("#${id}").val(casDft_${id}_${name});
		} else {
			 $("#selb_${id}_").removeClass("nomal_${id}");
			 $("#selb_${id}_").addClass("stop_${id}");
		}
	}
	function initCas_${id}_${name}(key){
		var $spaninit_${id}_${name} = $("#spaninit_${id}_${name}");
		var $ul_${id}_${name} ="<ul class=\"distance_${id}\">";
		$spaninit_${id}_${name}.html('');
		var param_${id}_${name} = {};
		var path = (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/pages/xbuilder/dimension/reportDesigner-dim-data.jsp';
		param_${id}_${name}.CODE_TABLE = '${table}';
		param_${id}_${name}.CODE_KEY = '${codecol}';
		param_${id}_${name}.CODE_DESC = '${desccol}';
		param_${id}_${name}.CODE_ORD = '${ordcol}';
		param_${id}_${name}.PARENT_CODE = '';
		param_${id}_${name}.CODE_PARENT_KEY = '${parentcodecol}';
		param_${id}_${name}.CODE_SQL = base64encode(utf16to8('${sql}'));
		param_${id}_${name}.DIM_LVL = '${level }';
		param_${id}_${name}.DATABASE_NAME = '${extds}';
		param_${id}_${name}.SELECT_DOUBLE = '${multiple}';
		param_${id}_${name}.PARENT_KEY = key;
		param_${id}_${name}.eaction = 'extCascade';
		param_${id}_${name}.multiple = '${multiple}';
		$.ajax({
		      type : "post",  
		      url : path,  
		      data : param_${id}_${name},  
		      async : false,  
		      dataType:"text",
		      success : function(data){
		    	    data = data.replace(/\r\n/g,'');
					data = data.replace(/(^\s*)|(\s*$)/g, "");
					var checkBoxBegin_${id}_${name} = "<li id=\"li_${id}\">${curdesc}<input type=\"hidden\" id=\"${id }\" name=\"${name }\" value=\"\"/><span id=\"selb_${id}_\" class=\"stop_${id} icoReset\" onclick=\"changeCasCode${id}${name}(this);\" attrValue=\"\">不限</span>|";
					var checkBoxEnd_${id}_${name} = "</li>";
					var $checkBox_${id}_${name} = "";
					var jsonList_${id}_${name} = $.parseJSON(data);
					for(var step =0;step<jsonList_${id}_${name}.length;step++){
						if(step > 0){
							if(step  == jsonList_${id}_${name}.length -1) {
								checkBoxBegin_${id}_${name} += "<span id=\"selb_${id}_"+ jsonList_${id}_${name}[step].CODE +"\" class=\"nomal_${id}\" onclick=\"changeCasCode${id}${name}(this);\" attrValue=\""+ jsonList_${id}_${name}[step].CODE +"\">"+ jsonList_${id}_${name}[step].CODEDESC +"</span>";
							} else {
								checkBoxBegin_${id}_${name} += "<span id=\"selb_${id}_"+ jsonList_${id}_${name}[step].CODE +"\" class=\"nomal_${id}\" onclick=\"changeCasCode${id}${name}(this);\" attrValue=\""+ jsonList_${id}_${name}[step].CODE +"\">"+ jsonList_${id}_${name}[step].CODEDESC +"</span>|";
							}
						} 
					}
					$checkBox_${id}_${name} =  checkBoxBegin_${id}_${name} + checkBoxEnd_${id}_${name};
					$spaninit_${id}_${name}.html($checkBox_${id}_${name});
					$.parser.parse($spaninit_${id}_${name});
		      },
		      complete : function(){
		    	//注入默认值
				casDftInit_${id}_${name}();
		      }
		});
	}
	//中间FUN
	function casOnchange_${id}_${name}(obj){
		if(typeof(casOnchange_ctl_${curdimname})!='undefined'){
			casOnchange_ctl_${curdimname}(obj);
		}
	}
	//实现联动体
	<e:if condition="${parentdimname !=null && parentdimname ne 'undefined' && parentdimname ne '' }">
		function casOnchange_ctl_${parentdimname}(obj){
			casDft_${id}_${name} = '';
			var caskey_${id}_${parentdimname} = $(obj).val(); 
			initCas_${id}_${name}(caskey_${id}_${parentdimname});
		}
	</e:if>
		function casOnchangeall_${id}_${name}(obj){
			if(typeof(casOnchange_ctl_${name})!='undefined'){
				casOnchange_ctl_${name}(obj);
			}
		}
	 
	//通过点击LABEL 触发checkbox 或者 radio
 function changeCasCode${id}${name}(obj){
	<e:if condition="${multiple !=null && (multiple eq 'true' || multiple == true || multiple eq '1')}" var="selectlist_else">
		if($(obj).hasClass("nomal_${id}")) {
			 $(obj).removeClass("nomal_${id}");
			 $(obj).addClass("stop_${id}");
		 } else {
			 $(obj).removeClass("stop_${id}");
			 $(obj).addClass("nomal_${id}");
		 }
// 		 var values = $(obj).attr("attrValue").split("_");
		 var value = $(obj).attr("attrValue");//values[values.length-1];
		 if(value == "") {
			 $("#li_${id}>span").removeClass("stop_${id}");
			 $("#li_${id}>span").addClass("nomal_${id}");
			 $("#selb_${id}_").removeClass("nomal_${id}");
			 $("#selb_${id}_").addClass("stop_${id}");
			 $("#${id}").val("");
		 } else {
			 value = "";
			 $("#selb_${id}_").removeClass("stop_${id}");
			 $("#selb_${id}_").addClass("nomal_${id}");
			 $("#li_${id}>span").each(function(index,item) {
				 if($(item).hasClass("stop_${id}")) {
					 var values = $(item).attr("attrValue");//$(item).attr("id").split("_");
					 value += values + ",";
				 }
			 });
			 if(value != "") {
				 value = value.substring(0,value.length -1);
			 }
			 $("#${id}").val(value);
		 }
	</e:if>
	<e:else condition="${selectlist_else}">
		 $("#li_${id}>span").removeClass("stop_${id}");
		 $("#li_${id}>span").addClass("nomal_${id}");
		 if($(obj).hasClass("nomal_${id}")) {
			 $(obj).removeClass("nomal_${id}");
			 $(obj).addClass("stop_${id}");
			 var values = $(obj).attr("attrValue");//$(obj).attr("id").split("_");
			 $("#${id}").val(values);
		 } else {
			 $(obj).removeClass("stop_${id}");
			 $(obj).addClass("nomal_${id}");
			 $("#selb_${id}_").removeClass("nomal_${id}");
			 $("#selb_${id}_").addClass("stop_${id}");
			 $("#${id}").val("");
		 }
	</e:else>
	var state_${id}_${name} = $(obj).parent().find("input").val();
	if(state_${id}_${name} == ''){
		casOnchangeall_${id}_${name}($(obj).parent().find("input"));
	}else{
		casOnchange_${id}_${name}($(obj).parent().find("input"));
	}
  }
</script>
<ul class="distance_${id}" id="spaninit_${id}_${name}">
</ul>
