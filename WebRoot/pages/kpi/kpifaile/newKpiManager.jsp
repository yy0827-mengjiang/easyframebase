<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:set var="managerFlag" value="${param.managerFlag}"></e:set>
<e:q4l var="cube">
	SELECT T.cube_code,T.cube_name FROM X_KPI_CUBE T WHERE T.CUBE_CODE = '${param.cube_code }'
</e:q4l>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>指标管理</title>
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
	<e:script value="/pages/kpi/kpifaile/formula.js"/>
  <script>
	  var  flag=true ,dimFlag=true , reloadFlag , baseKpiNode , current_node , baseDimNode ;
	  $(function(){
		  $("#kpi").load('<e:url value="faileKpiList.e?kpi_key="/>${param.kpi_key}&version=${param.version}','',function(){
			  kpiDivTitle();
		  });
		  var _code = $('#cube_code').val();
		  var treeUrl = "#";
		  var dimUrl = "#";
		  var attrUrl = "#";
		  if(_code != "") {
			  treeUrl = '<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=newLoadTree&cube_code="/>'+${param.cube_code};
			  dimUrl = '<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=baseDimStore&cube_code="/>'+${param.cube_code};
			  attrUrl = '<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=baseAttrStore&cube_code="/>'+${param.cube_code};
		  } 
		  $("#tt").tree({
			  url:treeUrl,
			  dnd:true,
			  onDragOver:function(){
				  return false;
			  },
			  onLoadSuccess:function(){
				  var root=$('#tt').tree('getRoot');
				  $('#tt').tree('expand',root.target);
			  },
		  });
		  <e:if condition="${managerFlag == 'manager' }">
			  $("#dim").tree({
				  url:dimUrl,
				  dnd:true,
				  onDragOver:function(target,source){
					  return false;
				  },
				  onLoadSuccess:function(){
					  var root=$('#dim').tree('getRoot');
					  $('#dim').tree('expand',root.target);
				  }
			  });
			  $("#attr").tree({
				  url:attrUrl,
				  dnd:true,
				  onDragOver:function(target,source){
					  return false;
				  },
				  onLoadSuccess:function(){
					  var root=$('#attr').tree('getRoot');
					  $('#attr').tree('expand',root.target);
				  }
	 		  });
		  </e:if>
		  });


	  function createCatalog(){
		  $('#c_name').val("");
		  $('#c_desc').val("");
		  $('#c_ord').val("");
		  $('#createCatalogDlg').dialog('open');
	  }
	  function queryBtnClick_(){
		  var keywords = $("#keywords_").val();
		  var _cubeCode = $('#cube_code').val();
		  if(keywords != null && keywords != "") {
			  $("#tt").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=querynewLoadTree&cube_code="/>'+${param.cube_code}+'&keywords=' + keywords;
			  $("#tt").tree("reload");
		  } else {
			  $("#tt").tree("options").url='<e:url value="/pages/kpi/kpiManager/newKpiManagerAction.jsp?eaction=newLoadTree&cube_code="/>'+${param.cube_code};
			  $("#tt").tree("reload");
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
  </script>
<style type="text/css">
.easyui-tabs .tabs-header, .easyui-tabs .tabs-panels{ border:none!important;}
</style>
 </head>
	 <body class="easyui-layout">
		<<div data-options="region:'west',split:false" style="width:270px;padding:0px;">
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
			<e:if condition="${managerFlag == 'manager' }" var="elseManager">
				<div id="treeTabs" class="easyui-tabs kpi-easyui-tabs" style="width:267px;height:auto">
					 <div title="指标">
						 <ul id="tt"></ul>
					 </div>
					 <div title="维度">
						 <ul id="dim"></ul>
					 </div>
		 			 <div title="属性">
						 <ul id="attr"></ul>
					 </div>
				 </div>
			</e:if>
			<e:else condition="${elseManager}">
			 	 <div id="treeTabs" class="easyui-tabs kpi-easyui-tabs" style="width:267px;height:auto">
					<div title="指标">
					<ul id="tt"></ul>
					</div>
				 </div>
			</e:else>
		</div>
		<div data-options="region:'center'">
			<div id="kpi"></div>
		</div>
<!-- 		<div data-options="region:'south'" style="height: 180px;"> -->
<!-- 			<div style="width: 100%"> -->
<!-- 				<c:datagrid url="pages/kpi/kpifaile/kpiFaileAction.jsp?eaction=queryAudit&kpi_key=${param.kpi_key }" id="audit" style="height:175px;"> -->
<!-- 					<thead> -->
<!-- 			    		<tr> -->
<!-- 							<th field="V3" width="10%" >指标编码</th> -->
<!-- 			    			<th field="V4" width="10%">指标名称</th> -->
<!-- 			    			<th field="V5" width="6%" >指标版本</th> -->
<!-- 			    			<th field="V6" width="6%">指标类型</th> -->
<!-- 			   				<th field="V7" width="6%">指标分类</th> -->
<!-- 			   				<th field="V11" width="10%">审核类型</th> -->
<!-- 			    			<th field="V10" width="30%">审核意见</th> -->
<!-- 			    			<th field="V13" width="10%">审核人</th> -->
<!-- 			    			<th field="V8" width="10%">审核时间</th> -->
<!-- 		    			</tr> -->
<!-- 	    			</thead> -->
<!-- 				</c:datagrid> -->
<!-- 			</div> -->
<!-- 		</div> -->
	 </body>
</html>