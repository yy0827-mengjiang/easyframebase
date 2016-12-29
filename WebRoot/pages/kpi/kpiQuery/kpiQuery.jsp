<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="managerFlag" value="${param.managerFlag}"></e:set>
<e:set var="isViewBaseKpi" value="${param.isViewBaseKpi}"></e:set>
<e:q4l var="cube">select t.cube_code,t.cube_name  from x_kpi_cube t where t.cube_status ='1'
<e:if condition="${param.account_type != null && param.account_type != ''}">
	and account_type = '${param.account_type}'
</e:if>
 order by t.cube_code</e:q4l>
<e:q4l var="kpi_type">select type_code, type_name,used_type,view_rule,server_class,url,icon from x_kpi_type where type_status='1'
<e:if condition="${param.type_code != null && param.type_code != ''}" var="typeCodeisNull">
	and type_code ='${param.type_code}'
</e:if>
<e:else condition="${typeCodeisNull }">
	and type_code != '5'
</e:else>
order by type_ord </e:q4l>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>指标查询</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
 	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<c:resources type="easyui,app"  style="${ThemeStyle }"/>
	<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/resources/themes/base/boncBase@links.css"/>
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	<e:script value="/pages/kpi/basedim/basedim.js"/>
	<e:script value="/pages/kpi/formulaKpi/formula.js"/>
	<e:script value="/pages/kpi/kpiQuery/kpiQuery.js"/>
	<e:script value="/pages/kpi/jOrgChart/jquery_format.js"/>
  <script>
  	  var expandFlag="2";
  	  var timer;
	  $(function(){
		  var _code = $('#cube_code').val();
		  var treeUrl = "#"; 
		  if(_code != "") {
			  treeUrl = '<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=querynewLoadTree&cube_code="/>'+_code +'&isViewBaseKpi=${isViewBaseKpi}';
		  } 
		  $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp?kpi_category=&cube="/>');
		  $("#tt").tree({
			  url:treeUrl,
			  dnd:true,
			  onClick:function(node){
					if(node.attributes.data_type == '2'){
						  $("#kpi").load('<e:url value="formulaKpiLook.e?kpi_key="/>' + node.id + '&lookUpFlag=1','',function(){
							  kpiDivTitle();
						  });
						  
					} else if(node.attributes.data_type == '3'){
						  $("#kpi").load('<e:url value="lookBaseKpi.e?id="/>' + node.id +'&cube_code='+$('#cube_code').val()+ '&lookUpFlag=1','',function(){
							  kpiDivTitle();
						  });
					} else {
						 $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category='+ node.id +'&cube=' + $("#cube_code").val());
					}
			  },
			  onDragOver:function(){
				  return false;
			  },
			  onExpand:expandNode,
			  onLoadSuccess:function(){
				  if(expandFlag != '1') {
					  var root=$('#tt').tree('getRoot');
					  var children = $('#tt').tree('getChildren',root.target);
					  var loopFlag = true;
					  if(root.state != "open") {
						  $('#tt').tree('expand',root.target);
					  }
					  if(children != null && children.length > 0) {
						  if(children[0].attributes.data_type == '1') {
							  if(children[0].state != "open") {
								  $('#tt').tree('expand',children[0].target);
							  }
							  while(loopFlag) {
								  children = $('#tt').tree('getChildren',children[0].target);
								  if(children != null && children.length > 0) {
									  if(children[0].attributes.data_type == '1') {
										  if(children[0].state != "open") {
											  $('#tt').tree('expand',children[0].target);
										  }
 									  }else {
										  loopFlag = false;
									  }
								  }else {
									  loopFlag = false;
								  }
							  } 
						  } 
					  }  
				  }
			  }
		  });
		  timer = setInterval('loadFirstNode()',100);
	  });
	  function loadFirstNode() {
		  var root=$('#tt').tree('getRoot');
		  var children = $('#tt').tree('getChildren',root.target);
		  var loopFlag = true;
		  var viewFlag = true;
		  if(root.state != "open") {
			  viewFlag = false;
 		  }
		  if(children != null && children.length > 0) {
			  if(children[0].attributes.data_type == '1') {
				  if(children[0].state != "open") {
					  viewFlag = false;
 				  }
				  while(loopFlag) {
					  children = $('#tt').tree('getChildren',children[0].target);
					  if(children != null && children.length > 0) {
						  if(children[0].attributes.data_type == '1') {
							  if(children[0].state != "open") {
								  viewFlag = false;
 							  }
						  }
					  } else {
						  loopFlag = false;
					  }
				  }
			  } 
		  }  
		  if(viewFlag) {
			  expandFlag = "1";
			  clearInterval(timer);
		  }
	  }
	  function loadTree(){
		  var _code = $('#cube_code').val();
		  var sel_cube_code = $("#SEL_CUBE_CODE");
		  var keywords = $("#keywords_").val();
		  if(sel_cube_code != undefined && sel_cube_code.val() != "") {
			  if(_code != sel_cube_code) {
				  expandFlag = "2";
				  $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube=' + _code,'',function(){
					  $("#tt").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=querynewLoadTree&cube_code="/>'+_code+'&isViewBaseKpi=${isViewBaseKpi}'+'&keywords=' + keywords;;
					  $("#tt").tree("reload");
					  timer = setInterval('loadFirstNode()',100);
				  });
// 				  $("#keywords_").val("");
// 				  $.messager.confirm('确认信息','切换数据魔方将清除当前的信息，您确定要进行此操作吗?',function(r){
// 				 		if(r){
// 							  $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube=' + _code,'',function(){
// 								  $("#tt").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=newLoadTree&cube_code="/>'+_code+'&isViewBaseKpi=${isViewBaseKpi}';
// 								  $("#tt").tree("reload");
// 							  });
// 				 		} else {
// 				 			$('#cube_code').val(sel_cube_code.val());
// 				 		}
// 				  });
			  }
		  } else {
			  expandFlag = "2";
			  $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube=' + _code);
			  $("#tt").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=querynewLoadTree&cube_code="/>'+_code+'&isViewBaseKpi=${isViewBaseKpi}'+'&keywords=' + keywords;;
			  $("#tt").tree("reload"); 
			  timer = setInterval('loadFirstNode()',100);
 		  }
	  }
	  function kpiDivTitle(){
		 var browser_width;
		 browser_width = $(".kpi_guide").eq(0).width();
		 $('.tit_div1').css({'width':browser_width,'left':'281px' });
		$(window).resize(function() { 
				$('.tit_div1').css({'width':browser_width,'left':'281px' });
		}); 
	  }
	  function queryBtnClick_(){
		  var keywords = $("#keywords_").val();
		  var _cubeCode = $('#cube_code').val();
		  expandFlag = "2";
		  $("#tt").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=querynewLoadTree&cube_code="/>'+_cubeCode+'&isViewBaseKpi=${isViewBaseKpi}'+'&keywords=' + keywords;
		  $("#tt").tree("reload");
		  timer = setInterval('loadFirstNode()',100);
// 		  if(keywords != null && keywords != "") {
// 			  $("#tt").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=querynewLoadTree&cube_code="/>'+_cubeCode+'&isViewBaseKpi=${isViewBaseKpi}'+'&keywords=' + keywords;
// 			  $("#tt").tree("reload");
// 		  } else {
// 			  $("#tt").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=querynewLoadTree&cube_code="/>'+_cubeCode+'&isViewBaseKpi=${isViewBaseKpi}';
// 			  $("#tt").tree("reload");
// 		  }
	  }
  </script>
<style type="text/css">
.easyui-tabs .tabs-header, .easyui-tabs .tabs-panels{ border:none!important;}
</style>
 </head>
 <body class="easyui-layout">
	<div data-options="region:'west',split:false" style="width:270px;padding:0px;">
		<div class="editBase_div_child">
				<dl class="ddLine">
					<dd style="width:100%;" class="searchDate">
				     	<input class="inputBox" type="text" class="fromOne"  id="keywords_" style="width:192px"/>
			    		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="queryBtnClick_()">查询</a>
					</dd>
					<dd>
						<span class="first-child">
						<select id="cube_code" onchange="loadTree()">
<!-- 						 	<option value="">--请选择--</option> -->
						 	<e:forEach items="${cube.list }" var="c">
						 		<option value="${c.cube_code }">${c.cube_name }</option>
						 	</e:forEach>
						 </select>
						 </span>
					</dd>
				</dl>
			</div>
			<div class="easyui-tabs kpi-easyui-tabs" style="width:267px;height:auto">
				 <div title="指标">
					 <ul id="tt"></ul>
				 </div>
			 </div>
	</div>
	<div data-options="region:'center'">
		<div id="kpi"></div>
	</div>
 </body>
</html>