<%@ tag body-content="empty" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="xid" required="true" %>
<%@ attribute name="cids" required="true" %>
var temSetNum${ xid}=10;
var temKey${xid}=setInterval(function(){
	if(temSetNum${ xid}<0){
		window.clearInterval(temKey${xid});
		return false;
	}
	temSetNum${ xid}--;
	var conts = '${cids}'.split(',');
	var contarr = [];
	for(var c=0;c<conts.length;c++){
		var $cobj = $('#'+conts[c]);
		var ow = $cobj[0].offsetWidth;
		var oh = $cobj[0].offsetHeight;
		var ol = $cobj[0].offsetLeft;
		var ot = $cobj[0].offsetTop;
		ol = ol>=100?(ol+2):ol;
		var cobj = {id:conts[c],width:ow,height:oh,left:ol,top:ot};
		contarr.push(cobj);
	}
	$.post((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/buildwhlt.e',{xid:'${xid}',contjson:$.toJSON(contarr)});
},500);