<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="id" required="true"%>                                        <e:description>id</e:description>
<%@ attribute name="name" required="true"%>                                      <e:description>name</e:description>
<%@ attribute name="desc" required="true"%>                                      <e:description>desc</e:description>
<%@ attribute name="curdimname" required="false"%>                               <e:description>当前维度的变量名称</e:description>
<%@ attribute name="isdg" required="false"%>                                     <e:description>是否为设计状态1为true</e:description>
<%@ attribute name="defaultValue" required="false"%>                             <e:description>默认值 如果多选 取(request.getParameterValues("b") != null? java.util.Arrays.asList(request.getParameterValues("b")) : "[]")</e:description>
<%@ attribute name="defaultEcho" required="false"%>                              <e:description>默认值 如果多选 取(request.getParameterValues("b") != null? java.util.Arrays.asList(request.getParameterValues("b")) : "[]")</e:description>
<%@ attribute name="multiple" required="false"%>                                 <e:description>是否支持多选 true or false(1 or 0)</e:description>
<%@ attribute name="showtype" required="false"%>                                 <e:description>0和空是正常显示，1为平铺</e:description>
<%@ attribute name="sql" required="false"%>                                       <e:description>遍历SQL</e:description>
<%@ attribute name="onclick" required="false"%>                                  <e:description>单点事件</e:description>
<%@ attribute name="extds" required="false"%>                                    <e:description>扩展数据源</e:description>
<style type="text/css">
ul.distance_${id}{  width:95%; min-height:50px;}
ul.distance_${id} li{font-size:14px; color:#eee; position:relative; padding-left:95px;}
ul.distance_${id} li em{ font-weight:normal; color:#999;}
ul.distance_${id} li span{font-weight:normal;  line-height:1; font-size:14px;}
ul.distance_${id} li span.nomal_${id}{ background:transparent; color:#199ed8; cursor:pointer;white-space:nowrap;}
ul.distance_${id} li span.del_${id}{background:#FF3333; color:#fff; cursor:pointer;}
ul.distance_${id} li span.stop_${id}{  background:#4c70b1; color:#fff; cursor:pointer;}
ul.distance_${id} li span.dialog_${id}{position: relative; margin:0 5px 10px; padding:3px 22px 3px 6px;  background:#199ee2; color:#fff; line-height:1.4; display:inline-block;}
ul.distance_${id} li span.dialog_${id} strong{position: absolute; top:15px; right:5px; line-height:9px; display:block;height:9px; width:9px; font-weight:normal; text-align:center; font-size:4px; cursor:pointer;}
</style>
<jsp:doBody var="bodyRes" />
<e:script value="/pages/xbuilder/resources/scripts/base64.js"/>
<e:if condition="${sql == null || sql eq '' }">
	<e:set var="sql" value="${bodyRes}" />
</e:if>
<e:set var="onclick_desc_fun"> </e:set>
<e:if condition="${onclick != null && onclick ne '' }">
	<e:set var="onclick_desc_fun"> onclick = "${onclick }"</e:set>
</e:if>
<e:if condition="${extds !=null && extds ne '' && extds ne 'undefined' }" var = "extdsselectlistelse">
	<e:q4l var="selectSqlList" extds = "${extds }">
		${sql }
	</e:q4l>
</e:if>
<e:else condition="${extdsselectlistelse }">
	<e:q4l var="selectSqlList">
		${sql }
	</e:q4l>
</e:else>
<e:set var="selectSqlListLen">${e:length(selectSqlList.list)}</e:set>
<e:if condition="${showtype == '2'}">
	<ul class="distance_${id}">
	  <li id="li_${id}"><strong class="titList">${desc}</strong>
	    <input type="hidden" id="${id }" name="${name }" value="${defaultValue}"/> 
	    <input type="hidden" id="mode${id }" name="mode${name }" value="${defaultEcho}" />
	    <span id="_sel_${id}_all"class="nomal_${id}" onclick="selectOption${id}${name}(this);">请选择【${selectSqlListLen }】</span>
  		<span id="_span_${id}_del"class="del_${id}" onclick="removeAllOption${id}${name}();" style="display:none;">全部清除</span>
	  	<span id="ui${id }descui" name="ui${name }descui" initvar="${curdimname }"></span>
	  	<div id="w${id }${name }selectList" class="easyui-window"
			title="${desc }&nbsp;请选择【记录数：${selectSqlListLen }】"
			data-options="iconCls:'icon-search',closed:true,maximizable:false,minimizable:false,collapsible:false,modal:true,resizable:false,draggable:true"
			style="width:600px;height:346px;padding:1px;overflow:hidden;">
		</div>
	  </li>
	</ul>
	<script>
		function selectOption${id}${name}(obj){
			//addConditionValue${id}${name}('431','长春市');
			<e:if condition="${isdg !=null && (isdg eq 'true' || isdg == true || isdg eq '1')}" var="selectlist_elseisdg">
				top.$.messager.alert("提示信息","请预览或保存再进行操作！","error");
				return false;
			</e:if>
			<e:else condition="${selectlist_elseisdg }">
				var info${id}${name}param = {};
				info${id}${name}param.id = "${id }";
				info${id}${name}param.name = "${name }";
				info${id}${name}param.datasql = base64encode(utf16to8("${sql}"));
				info${id}${name}param.multiple = "${multiple }";
				info${id}${name}param.actionstate = "dom";
				info${id}${name}param.extds="${extds}";
				info${id}${name}param.path = (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/pages/xbuilder/dimension/CommonQuerySelectData.jsp';
				$w${id }${name }selectList = $("#w${id }${name }selectList");
				$w${id }${name }selectList.load(info${id}${name}param.path,info${id}${name}param,function(){
					$w${id }${name }selectList.window("open");
					$.parser.parse($w${id }${name }selectList);
				});
			</e:else>
		}
		function selectOption${id}${name}wrt(code,codedesc){
			if(code == null || code == undefined || code ==''){
				return false;
			}
			var selectoption${id}${name}val = code;
			var $ui${id }descui = $("#ui${id }descui");
			$ui${id }descui.html(codedesc + "<strong onclick=\"optionRemove${id}${name}('1','"+ code +"')\">x</strong>");
			$ui${id }descui.addClass("dialog_${id}");
			$("#${id}").val(code);
		}
		function selectOption${id}${name}wrtValues(values){
			var $ui${id }descui = $("#ui${id }descui");
			if(values == null || values == undefined || values.length == 0){
				return false;
			}
			var value = "";
			$.each(values,function(index,item){
				if(index == 0) {
					$ui${id }descui.html(item.codedesc + "<strong onclick=\"optionRemove${id}${name}('1','"+ item.code +"')\">x</strong>");
					$ui${id }descui.addClass("dialog_${id}");
				} else {
					$ui${id }descui.after("<span id=\"_${id}_span"+ item.code +"\" class=\"dialog_${id}\">"+ item.codedesc+ "<strong onclick=\"optionRemove${id}${name}('0','"+ item.code +"')\">x</strong>" +"</span>");
				}
				if(index == values.length-1) {
					value += item.code;
				} else {
					value += item.code + ",";
				}
			});
			$("#${id}").val(value);
			$("#_span_${id}_del").show();
		}
		function optionRemove${id}${name}(obj,removeValue){
			if(obj == "1") {
				$("#ui${id }descui").html("");
				$("#ui${id }descui").removeClass("dialog_${id}");
			} else {
				$("#_${id}_span" + removeValue).remove();
			}
			<e:if condition="${multiple !=null && (multiple eq 'true' || multiple == true || multiple eq '1')}" var="selectlist_elsennoa">
				var _${id}_value = $("#${id}").val().split(",");
				var _${id}_tmp_value = "";
				var _${id}_mode = $("#mode${id}").val().split(",");
				var _${id}_mode_value = "";
				for(var _i_${id}_index = 0;_i_${id}_index < _${id}_value.length; _i_${id}_index++) {
					if(_${id}_value[_i_${id}_index] != removeValue) {
						_${id}_tmp_value += _${id}_value[_i_${id}_index] + ",";
					}
				}
				//回显删除
				for(var i=0;i<_${id}_mode.length;i++){
					var modetmp = _${id}_value[i].split("!");
					if(modetmp[0] != removeValue){
						_${id}_mode_value += _${id}_mode[i]+",";
					}
				}
				if(_${id}_tmp_value != "") {
					_${id}_tmp_value = _${id}_tmp_value.substring(0, _${id}_tmp_value.length-1);
					_${id}_mode_value = _${id}_mode_value.substring(0,_${id}_mode_value.length-1);
				}
				$("#${id}").val(_${id}_tmp_value);
				$("#mode${id}").val(_${id}_mode_value);
				if(_${id}_tmp_value == "") {
					$("#_span_${id}_del").hide();
				}
			</e:if>
			<e:else condition="${selectlist_elsennoa }">
			 	$("#${id}").val("");
			 	$("#mode${id}").val("");
			</e:else>
		}
		function removeAllOption${id}${name}(){
			$("#${id}").val("");
			$("#mode${id}").val("");
			$("#ui${id }descui").html("");
			$("#ui${id }descui").removeClass("dialog_${id}");
			$("#li_${id}").find("span").each(function(_span_index,_span_item) {
				var _span_${id}_id = $(_span_item).attr("id");
				if(_span_${id}_id != "_sel_${id}_all" && _span_${id}_id !="_span_${id}_del" && _span_${id}_id !="ui${id }descui") {
					$(_span_item).remove();
				}
			});
			$("#_span_${id}_del").hide();
		}
		function colseWin${id}${name}(){
			var $ui${id }descuiObj = $("#ui${id }descui");
			$("#cltbtn${id }").empty();
			var $text${id}state = $("<font color=\"red\">【记录数：${selectSqlListLen }】</font>");
			var $sting${id}state = $("<pl>点击查看更多</p1>");
			if($ui${id }descuiObj.find("pi").length ==0){
				$sting${id}state = $("<pl>点击查看更多</p1>");
			}else{
				$sting${id}state = $("<pl>重新选择</p1>");
			}
			$text${id}state.appendTo($sting${id}state);
			$sting${id}state.appendTo($("#cltbtn${id }"));
			$.parser.parse($("#cltbtn${id }"));
		}
		$(function(){
			var selectlist_${id}_${name}_dfv = '${defaultValue}';
			var info${id}${name}paramdft = {};
			info${id}${name}paramdft.id = "${id }";
			info${id}${name}paramdft.name = "${name }";
			info${id}${name}paramdft.datasqlquery = "${sql }";
			info${id}${name}paramdft.actionstate = "dataBean";
			info${id}${name}paramdft.extds="${extds}";
			info${id}${name}paramdft.path = (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}')+'/pages/xbuilder/dimension/CommonQuerySelectData.jsp'
			var info${id}${name}Array = new Array();
			<e:forEach items="${selectSqlList.list }" var="item">
				info${id}${name}Array.push({code:"${item.code}",codedesc:"${item.codedesc}"});
 			</e:forEach>
			if(selectlist_${id}_${name}_dfv != null && selectlist_${id}_${name}_dfv !="" && selectlist_${id}_${name}_dfv != "undefined") {
				<e:if condition="${multiple !=null && (multiple eq 'true' || multiple == true || multiple eq '1')}" var="selectlist_elsennoa">
					var temp${id}${name}Array = new Array();
					var strs_${id}_${name}Array = selectlist_${id}_${name}_dfv.split(",");
					for(var __i=0; __i < strs_${id}_${name}Array.length; __i++) {
						for(var __j=0; __j < info${id}${name}Array.length; __j++) {
							if(strs_${id}_${name}Array[__i]==info${id}${name}Array[__j].code){
								temp${id}${name}Array.push(info${id}${name}Array[__j]);
								break;
							}
						}
					}
					selectOption${id}${name}wrtValues(temp${id}${name}Array);
				</e:if>
				<e:else condition="${selectlist_elsennoa }">
					for(var __j=0; __j < info${id}${name}Array.length; __j++) {
						if(selectlist_${id}_${name}_dfv == info${id}${name}Array[__j].code){
							selectOption${id}${name}wrt(info${id}${name}Array[__j].code,info${id}${name}Array[__j].codedesc);
 							break;
						}
					}
				</e:else>
			}
		});
	</script>
</e:if>
<e:if condition="${showtype == '1'}">
 <ul class="distance_${id}">
	<e:if condition="${multiple !=null && (multiple eq 'true' || multiple == true || multiple eq '1')}" var="selectlist_else">
		<li id="li_${id}"><strong class="titList">${desc}</strong><input 
			type="hidden" id="${id }" name="${name }" value=""><span id="selb_${id}_" 
			class="stop_${id} icoReset" onclick="changeClass_${id}_${name}(this);" attrValue="">不限</span>|
			<e:forEach items="${selectSqlList.list }" var="item" indexName="i">
			    <span id="selb_${id}_${item.code }" class="nomal_${id}" onclick="changeClass_${id}_${name}(this);" attrValue="${item.code }">${item.codedesc }</span><e:if condition="${i < selectSqlListLen-1 }">|</e:if>
			</e:forEach>
		</li>
	</e:if>
	<e:else condition="${selectlist_else }">
		<li id="li_${id}"><strong class="titList">${desc}</strong><input 
		type="hidden" id="${id }" name="${name }" value=""><span id="selb_${id}_" 
		class="stop_${id} icoReset" onclick="changeClass_${id}_${name}(this);" attrValue="">不限</span>|
			<e:forEach items="${selectSqlList.list}" var="item" indexName="i">
				<span id="selb_${id}_${item.code}" class="nomal_${id}" 
					onclick="changeClass_${id}_${name}(this);" attrValue="${item.code}">${item.codedesc }</span><e:if condition="${i < selectSqlListLen-1 }">|</e:if>
			</e:forEach>
		</li>
	</e:else>
	</ul>
	<script language="javascript">
		$(function(){
			var selectlist_dfv_${id}_${name} = "${defaultValue}";
			<e:if condition="${multiple !=null && (multiple eq 'true' || multiple == true || multiple eq '1')}" var="selectlist_else">
				if(selectlist_dfv_${id}_${name} != null && selectlist_dfv_${id}_${name} != undefined && selectlist_dfv_${id}_${name} != ''){
					var selectlist_str_${id}_${name} = selectlist_dfv_${id}_${name};//.replace(/\'/g,""); //替换单引号
					var strs_${id}_${name} = new Array();
					strs_${id}_${name} = selectlist_str_${id}_${name}.split(",");
					$("#selb_${id}_").removeClass("stop_${id}");
					$("#selb_${id}_").addClass("nomal_${id}");
					$.each(strs_${id}_${name}, function (index, tx) {
						$("#selb_${id}_" + tx).removeClass("nomal_${id}");
						$("#selb_${id}_" + tx).addClass("stop_${id}");
					});
				} else {
					 $("#selb_${id}_").removeClass("nomal_${id}");
					 $("#selb_${id}_").addClass("stop_${id}");
				}
			</e:if>
			<e:else condition="${selectlist_else}">
				$("#li_${id}>span").removeClass("stop_${id}");
				$("#li_${id}>span").addClass("nomal_${id}");
				if(selectlist_dfv_${id}_${name} != null && selectlist_dfv_${id}_${name} != undefined && selectlist_dfv_${id}_${name} != ''){
					$("#selb_${id}_" + selectlist_dfv_${id}_${name}).removeClass("nomal_${id}");
					$("#selb_${id}_" + selectlist_dfv_${id}_${name}).addClass("stop_${id}");
				} else {
					$("#selb_${id}_").removeClass("nomal_${id}");
					$("#selb_${id}_").addClass("stop_${id}");
				}
			
			</e:else>
			$("#${id}").val(selectlist_dfv_${id}_${name});
		});
// 		function selelct_${id}_fun_select(obj){mm
// 			chanck_${id}_${name}(obj);
// 			var sallObj_${id} = $("input[name=${name }]");
// 			var selelct_${id}all = sallObj_${id}.attr("checked");
// 			if(selelct_${id}all != null && selelct_${id}all != undefined && (selelct_${id}all == 'checked' || selelct_${id}all == 'true')){
// 				$("input[name=${name }]").attr("checked",'checked'); 
// 				$(obj).parents("li").siblings("li").addClass("TheClick");
// 			}else{
// 				$("input[name=${name }]").removeAttr("checked");
// 				$(obj).parents("li").siblings("li").removeClass("TheClick");
// 			}
// 		}
		function changeClass_${id}_${name}(obj) {
			<e:if condition="${multiple !=null && (multiple eq 'true' || multiple == true || multiple eq '1')}" var="selectlist_else">
				if($(obj).hasClass("nomal_${id}")) {
					 $(obj).removeClass("nomal_${id}");
					 $(obj).addClass("stop_${id}");
				 } else {
					 $(obj).removeClass("stop_${id}");
					 $(obj).addClass("nomal_${id}");
				 }
// 				 var values = $(obj).attr("id").split("_");
				 var value = $(obj).attr("attrValue");//values[values.length-1];//$(obj).attr("id").substring(5);
				 if(value == "") {
					 $("#li_${id}>span").removeClass("stop_${id}");
					 $("#li_${id}>span").addClass("nomal_${id}");
					 $("#selb_${id}_").removeClass("nomal_${id}");
					 $("#selb_${id}_").addClass("stop_${id}");
				 } else {
					 value = "";
					 $("#selb_${id}_").removeClass("stop_${id}");
					 $("#selb_${id}_").addClass("nomal_${id}");
					 $("#li_${id}>span").each(function(index,item) {
						 if($(item).hasClass("stop_${id}")) {
							 var values = $(item).attr("attrValue");//.split("_");
							 value += values + ",";
						 }
					 });
					 if(value != "") {
						 value =  value.substring(0,value.length -1);
					 }
				 }
				 $("#${id}").val(value);
			</e:if>
			<e:else condition="${selectlist_else}">
				 $("#li_${id}>span").removeClass("stop_${id}");
				 $("#li_${id}>span").addClass("nomal_${id}");
				 if($(obj).hasClass("nomal_${id}")) {
					 $(obj).removeClass("nomal_${id}");
					 $(obj).addClass("stop_${id}");
					 var values = $(obj).attr("attrValue");//.split("_");
					 $("#${id}").val(values);
				 } else {
					 $(obj).removeClass("stop_${id}");
					 $(obj).addClass("nomal_${id}");
					 $("#selb_${id}_").removeClass("nomal_${id}");
					 $("#selb_${id}_").addClass("stop_${id}");
					 $("#${id}").val("");
				 }
			</e:else>
		}
// 	    function chanck_${id}_${name}(obj){
// 	    	var ckstate_${id}_${name} = $(obj).parent().find("input").attr("checked");
// 	    	if(ckstate_${id}_${name} == 'checked'){
// 	    		$(obj).parent().find("input").removeAttr("checked");
// 	    		$(obj).parents("li").removeClass("TheClick");
// 	    	}else{
// 	    		$(obj).parent().find("input").attr("checked","checked");
// 	    		$(obj).parents("li").addClass("TheClick");
// 	    		<e:if condition="${multiple !=null && (multiple eq 'true' || multiple == true || multiple eq '1')}" var="selectlist_else">
// 	    		$(obj).parents("li").addClass("TheClick");
// 	    		</e:if>
// 	    		<e:else condition="${selectlist_else }">
// 	    		$(obj).parents("li").addClass("TheClick"), $(obj).parents("li").siblings("li").removeClass("TheClick");
// 	    		</e:else>
// 	    	}
// 	    } 
	</script> 
</e:if>
<e:if condition="${showtype == '0'}">
	<span class='searchItemName'>${desc}</span><e:select id="${id}" name="${curdimname}" items="${selectSqlList.list}" 
		label="CODEDESC" value="CODE" style="width:140px" 
		defaultValue="${defaultValue}"
		headLabel="--请选择--" headValue=""/>
</e:if>