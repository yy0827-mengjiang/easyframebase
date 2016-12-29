<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir='/WEB-INF/tags/app'%>
<e:set var='urlParam' value='&bill_month=${param.bill_month}&cust_manager=${param.cust_manager}&currentId=${param.currentId}&condtype=${param.condtype}' />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="renderer" content="webkit">
<title>yyy</title>
<style>.datagrid-header .datagrid-cell {white-space: normal!important; word-wrap: normal!important; overflow: inherit!important;  height: auto!important; min-height:18px!important;}</style>
<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css"/>
<c:resources type="easyui,highchart" style="b"/>
<script>var compFileDir='formal';var queryParamsStr='${urlParam}';var gridster;</script>
<e:style value="/pages/xbuilder/resources/component/gridster/jquery.gridster.min.css"/>
<e:style value="/pages/xbuilder/resources/component/gridster/style.css"/>
<e:script value="/pages/xbuilder/resources/component/gridster/jquery.gridster.js"/>
<a:autowidth xid="e86f420a39db465aa9997ba4315f40aa" lwidth="1356" cids="e86f420a39db465aa9997ba4315f40aa_1,e86f420a39db465aa9997ba4315f40aa_2" devemodel="${param.deve}"/>
<script>$(function(){setTimeout(function(){
$('#div_body_e86f420a39db465aa9997ba4315f40aa_1').load(appBase+'/pages/xbuilder/usepage/formal/e86f420a39db465aa9997ba4315f40aa/comp_5cc5cfe3_b131_4977_8f14_cf605497bbf9.jsp?a=1${urlParam}');
$('#div_body_e86f420a39db465aa9997ba4315f40aa_2').load(appBase+'/pages/xbuilder/usepage/formal/e86f420a39db465aa9997ba4315f40aa/comp_1c2a5a9f_4902_45ce_81e9_f913e4885b32.jsp?a=1${urlParam}');
var hid = $('.serchIndexInPC').attr('class');if(undefined==hid){$('.bodyPC').css('padding-top','0')}},500); });</script>
</head>
<body class='bodyPC'>
<script type="text/javascript">
function doQuery(){
var form_e86f420a39db465aa9997ba4315f40aa_action=window.location.href;
if(form_e86f420a39db465aa9997ba4315f40aa_action.indexOf("?")){
	$("#form_e86f420a39db465aa9997ba4315f40aa").attr("action",form_e86f420a39db465aa9997ba4315f40aa_action.substring(0,form_e86f420a39db465aa9997ba4315f40aa_action.indexOf("?")));
}
document.getElementById("form_e86f420a39db465aa9997ba4315f40aa").submit();
}
</script>
<div class="serchIndex serchIndexPC"><div class="serchIndexIn serchIndexInPC"><form id="form_e86f420a39db465aa9997ba4315f40aa" method="post" action=""><h3>查询条件 </h3><input type='hidden' id='extdsHidden' value='null' />
<style>
	@-moz-document url-prefix() { .fromFileIframe {margin-top:-5px;} }
	@media screen and (-webkit-min-device-pixel-ratio:0) {.fromFileIframe {margin-top:-5px;}  }
</style>

<script>
   function reportselectfile(reportId,dimname){
   	 var logId=$("#"+dimname).val();
     	 var info = {}; 
		 info.reportId = reportId;
		 info.logId=logId; 
		 info.fieldName = dimname; 
		 $("#uploade86f420a39db465aa9997ba4315f40aa").load("<e:url value ='/pages/xbuilder/usepage/common/CommonReportSelectFile.jsp'/>",info,function(){
			$.parser.parse($("#uploade86f420a39db465aa9997ba4315f40aa"));
			$('#uploade86f420a39db465aa9997ba4315f40aa').window('open');
		 });
	 }
	 function reportdownfile(reportId){
		 window.location.href = "<e:url value='/pages/xbuilder/usepage/common/CommonReportDownModule.jsp'/>";
		 window.returnValue=false;
	 }
	 function showSelectFile(reportId,logId){
		 $("#param2").val(logId);
	 }
</script>

<div id="uploade86f420a39db465aa9997ba4315f40aa" class="easyui-window" title="&nbsp;选择文件" data-options="modal:true,closed:true,resizable:false,minimizable:false,maximizable:false,collapsible:false" 	style="width: 603px; height: 300px; padding: 1px; overflow: hidden;">
</div>

<div style="padding:0;"><span class="pr_16 data"><span class='searchItemName'>参数(bill_month)</span><e:if condition="${param.bill_month != null && param.bill_month ne '' &&param.bill_month !='undefined' && param.bill_month != 'null' }" var='bill_month_if' ><e:set var='default_bill_month' value='${param.bill_month}'/></e:if><e:else condition='${bill_month_if}'><e:set var='default_bill_month' value=''/></e:else><input type="text" id="bill_month" name="bill_month" style='width:145px;' value='${default_bill_month}'/>
</span><span class="pr_16 data"><span class='searchItemName'>参数(cust_manager)</span><e:if condition="${param.cust_manager != null && param.cust_manager ne '' &&param.cust_manager !='undefined' && param.cust_manager != 'null' }" var='cust_manager_if' ><e:set var='default_cust_manager' value='${param.cust_manager}'/></e:if><e:else condition='${cust_manager_if}'><e:set var='default_cust_manager' value=''/></e:else><input type="text" id="cust_manager" name="cust_manager" style='width:145px;' value='${default_cust_manager}'/>
</span><span class="pr_15"><input id="condtype" name="condtype" type="hidden" value="1"/><a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">确认查询</a></span></div></form></div></div><div id="selectable_layout_id001" class="gridster ready"><ul style="margin: 0px; "> 
 <li class="gs-w default-border" id="e86f420a39db465aa9997ba4315f40aa_1" style="position: absolute; min-height: 20px; min-width: 19.72px;" data-row="1" data-col="1" data-sizex="38" data-sizey="15"> <b class="bTl"></b> <b class="bTr"></b> <b class="bBl"></b> <b class="bBr"></b> 
  <div class="component-set" id="div_set_e86f420a39db465aa9997ba4315f40aa_1" style="display:none;"> 
   <ol style="display: none;"> 
    <li class="icoComponentEditor default-border"><a title="组件编辑" onclick="LayOutUtil.componentEdit('e86f420a39db465aa9997ba4315f40aa_1');return false;" href="javascript:void(0)">组件编辑</a></li> 
    <li class="icoSetContainer default-border"><a title="容器设置" onclick="LayOutUtil.openEditePropertyView('e86f420a39db465aa9997ba4315f40aa_1');return false;" href="javascript:void(0)">容器设置</a></li> 
    <li class="icoEmptyContainer default-border"><a title="容器清空" onclick="LayOutUtil.removeComponents('e86f420a39db465aa9997ba4315f40aa_1');return false;" href="javascript:void(0)">容器清空</a></li> 
    <li class="icoDeleteContainer default-border" style="display: block;"><a title="容器删除" onclick="LayOutUtil.removeL('e86f420a39db465aa9997ba4315f40aa_1');return false;" href="javascript:void(0)">容器删除</a></li> 
   </ol> 
  </div> 
  <div class="component-area" id="div_area_e86f420a39db465aa9997ba4315f40aa_1"> 
   <div class="component-head" id="div_head_e86f420a39db465aa9997ba4315f40aa_1"> 
    <h3 id="div_head_title_e86f420a39db465aa9997ba4315f40aa_1"><span onclick="LayOutUtil.openEditePropertyView('e86f420a39db465aa9997ba4315f40aa_1');return false;">基础表格</span></h3> 
   </div> 
   <div class="component-con" id="div_body_e86f420a39db465aa9997ba4315f40aa_1" style="height: 308px; overflow: auto;"> 
    <!-- style="display: none;" -->  
   </div> 
  </div> </li> 
 <li class="gs-w default-border selected-border" id="e86f420a39db465aa9997ba4315f40aa_2" style="display: list-item; position: absolute; min-height: 20px; min-width: 19.72px;" data-row="16" data-col="1" data-sizex="38" data-sizey="13"><b class="bTl"></b> <b class="bTr"></b> <b class="bBl"></b> <b class="bBr"></b>
  <div class="component-set" id="div_set_e86f420a39db465aa9997ba4315f40aa_2" style="display:none;">
   <ol style="display: none;">
    <li class="icoComponentEditor default-border" style="display: none;"><a title="模板编辑" onclick="LayOutUtil.componentEdit('e86f420a39db465aa9997ba4315f40aa_2');return false;" href="javascript:void(0)">模板编辑</a></li>
    <li class="icoSetContainer default-border" style="display: none;"><a title="布局设置" onclick="LayOutUtil.openEditePropertyView('e86f420a39db465aa9997ba4315f40aa_2');return false;" href="javascript:void(0)">布局设置</a></li>
    <li class="icoEmptyContainer default-border" style="display: none;"><a title="布局清空" onclick="LayOutUtil.removeComponents('e86f420a39db465aa9997ba4315f40aa_2');return false;" href="javascript:void(0)">布局清空</a></li>
    <li class="icoDeleteContainer default-border" style="display: block;"><a title="布局删除" onclick="LayOutUtil.removeL('e86f420a39db465aa9997ba4315f40aa_2');return false;" href="javascript:void(0)">布局删除</a></li>
   </ol>
  </div>
  <div class="component-area" id="div_area_e86f420a39db465aa9997ba4315f40aa_2">
   <div class="component-head" id="div_head_e86f420a39db465aa9997ba4315f40aa_2">
    <h3 id="div_head_title_e86f420a39db465aa9997ba4315f40aa_2"><span onclick="LayOutUtil.openEditePropertyView('e86f420a39db465aa9997ba4315f40aa_2');return false;">柱图</span></h3>
   </div>
   <div class="component-con" id="div_body_e86f420a39db465aa9997ba4315f40aa_2" style="overflow: hidden;"></div>
  </div></li>
</ul></div><e:if condition="${applicationScope['xpageinfo'] == '1'}">
<div id = "xpageinfo_e86f420a39db465aa9997ba4315f40aa" class="popbtn easyui-draggable" >
<a id = "xpageinfo_a_e86f420a39db465aa9997ba4315f40aa" href="javascript:void(0)" class="easyui-linkbutton" onclick="showDialogDesc()">页面描述</a>
<div id="dialog_e86f420a39db465aa9997ba4315f40aa"></div></div><script type="text/javascript">
$(function() {$('#xpageinfo_e86f420a39db465aa9997ba4315f40aa').draggable({disabled:false,cursor:"move", onStartDrag:function(e){$('#xpageinfo_a_e86f420a39db465aa9997ba4315f40aa').linkbutton('disable');},onStopDrag:function(e){$('#xpageinfo_a_e86f420a39db465aa9997ba4315f40aa').linkbutton('enable'); return false;} }); });function showDialogDesc(){var left = document.body.clientWidth-505;var top = document.body.scrollHeight-305;$('#dialog_e86f420a39db465aa9997ba4315f40aa').dialog({title: '页面描述',width: 500,height: 300,closed: false,cache: false,maximizable: true,minimizable: false,href:appBase+'/pages/xbuilder/usepage/common/reportInfo.jsp?reportid=e86f420a39db465aa9997ba4315f40aa',resizable: true, shadow: true, left: left, top: top });}</script>
</e:if>
<div id="popdiv" style="width: 650px; padding: 10px;" closed="true" shadow="true" resizable="false" collapsible="true" minimizable="false" maximizable="false"></div>
</body>
</html>