var appBase='';
$(function(){
	appBase=getContextPath();
});
function getContextPath(){
	if(appBase==''){
		var link = document.getElementsByTagName('script');
	    for (var q = 0; q < link.length; q++) {
	        var h = !!document.querySelector ? link[q].src : link[q].getAttribute("src", 4), i;
	        if (h && (i = h.indexOf('resources/easyResources/scripts/common.js')) >= 0) {
	            var j = h.indexOf('://');
	            appBase = j < 0 ? h.substring(0, i - 1) : h.substring(h.indexOf('/', j + 3), i - 1);
	            break;
	        }
	    }
	}
	return appBase;
}

/*loading start*/
var _commonLoadHeight = window.screen.height-250;
var _commonLoadWidth = window.screen.width;
var _commonLoadLeftW = 300;
if(_commonLoadWidth>1200){
	_commonLoadLeftW = 500;
}else if(_commonLoadWidth>1000){
	_commonLoadLeftW = 350;
}else {
	_commonLoadLeftW = 100;
}
var _commonLoadHtml ="<div id='loading' style='position:absolute;left:0;width:100%;height:"+_commonLoadHeight+"px;top:0;background:#fff;opacity:1;filter:alpha(opacity=100);'><div style='position:absolute;cursor1:wait;left:"+_commonLoadLeftW+"px;top:200px;width:auto;height:16px;padding:10px;background:#fff;color:#666;font-size:14px'>正在加载中，请稍候...</div></div>";
window.onload = function(){
	var _mask = document.getElementById('loading');
	_mask.parentNode.removeChild(_mask);
}
document.write(_commonLoadHtml);

/*loading end*/
