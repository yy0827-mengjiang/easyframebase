<%@ page language="java" import="java.util.UUID" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<e:q4l var="theme_list">
	select ID AS "ID",NAME AS "NAME",ord AS "CLASS_NUM" from x_theme order by ord
</e:q4l>
<e:q4l var="color_list">
	select b.THEME_ID AS "THEME_ID",a.css AS "THEME_FILE_PATH",b.CLASS AS "ID",b.NAME AS "NAME" from x_theme a,x_theme_color b where a.id=b.theme_id order by b.THEME_ID,b.ord
</e:q4l>

<%
	String xid = UUID.randomUUID().toString().replaceAll("-","");
	String contw = String.valueOf(Math.floor(Integer.parseInt(request.getParameter("lw"))*0.9*0.91/20)).replaceAll("\\.0","");
%>
<e:if condition="${param.dsType eq '1'||param.typeExt eq '3'}">
	 <e:set var="scriptPath">sql</e:set>
</e:if>
<e:if condition="${param.dsType eq '2'}">
	  <e:set var="scriptPath">kpi</e:set>
</e:if>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<base href="<%=request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"%>">
		<title>报表构建</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta name="renderer" content="webkit"/> 
		<meta http-equiv = "X-UA-Compatible" content = "IE=edge,chrome=1" />
		<e:style value="/pages/xbuilder/resources/component/gridster/jquery.gridster.min.css"/>
		<e:style value="/pages/xbuilder/resources/component/gridster/style.css"/>
		<c:resources type="highchart, easyui" style="${ThemeStyle }"/>
		<e:service/>
		<e:script value="/resources/easyResources/component/easyui/jquery.easyui.min.js" />
		<e:script value="/resources/easyResources/component/easyui/locale/easyui-lang-zh_CN.js" />
		<e:script value="/resources/easyResources/component/easyui/plugins/datagrid-detailview.js" />
		<script> 
			  var dsType = '${param.dsType}';
			  var typeExt = '${param.typeExt}';
		</script>
		<e:script value="/pages/xbuilder/resources/component/gridster/jquery.gridster.js" />
		<e:script value="/pages/xbuilder/resources/component/echart/echarts-all.js"/>
		
		<!-- jquery ui中的selectable和sortable -->
		<e:script value="/pages/xbuilder/resources/component/jqueryui/ui/jquery.ui.core.js" />
		<e:script value="/pages/xbuilder/resources/component/jqueryui/ui/jquery.ui.widget.js" />
		<e:script value="/pages/xbuilder/resources/component/jqueryui/ui/jquery.ui.mouse.js" />
		<e:script value="/pages/xbuilder/resources/component/jqueryui/ui/jquery.ui.selectable.js" />
		<e:script value="/pages/xbuilder/resources/component/jqueryui/ui/jquery.ui.resizable.js" />
		<e:script value="/pages/xbuilder/resources/component/jqueryui/ui/jquery.ui.sortable.js" />
		<e:script value="/pages/xbuilder/resources/scripts/jquery.autocomplete.js" />
		
		<e:script value="/pages/xbuilder/pagedesigner/StoreData.js" />
		<e:script value="/pages/xbuilder/pagedesigner/layout.js" />
		<e:script value="/pages/xbuilder/pagedesigner/component.js" />
		<e:script value="/pages/xbuilder/pagedesigner/Script_property.js" />
		<e:script value="/pages/xbuilder/dataset/Script.js" />
		<e:script value="/pages/xbuilder/dimension/Script.js" />
		
		<!-- 颜色选择器插件 spectrum -->
		<e:style value="/pages/xbuilder/resources/component/spectrum/spectrum.css"/>
		<e:script value="/pages/xbuilder/resources/component/spectrum/spectrum.js"/>
		
		<!-- 组件js -->
		<e:script value="/pages/xbuilder/component/column/ScriptCommon.js" />
		<e:script value="/pages/xbuilder/component/line/ScriptCommon.js" />
		<e:script value="/pages/xbuilder/component/columnline/ScriptCommon.js" />
		<e:script value="/pages/xbuilder/component/bar/ScriptCommon.js" />
		<e:script value="/pages/xbuilder/component/pie/ScriptCommon.js" />
		<e:script value="/pages/xbuilder/component/scatter/ScriptCommon.js" />
		
		<e:script value="/pages/xbuilder/component/datagrid/TableService.js"/>
		<e:script value="/pages/xbuilder/component/datagrid/TableEvent.js"/>
		<e:script value="/pages/xbuilder/component/datagrid/ScriptCommon.js"/>
		<e:script value="/pages/xbuilder/component/crosstable/ScriptCommon.js"/>
		<e:script value="/pages/xbuilder/component/treegrid/TreeTableService.js"/>
		<e:script value="/pages/xbuilder/component/treegrid/TreeTableEvent.js"/>
		<e:script value="/pages/xbuilder/component/treegrid/ScriptCommon.js"/>
		
		<e:script value="/pages/xbuilder/component/pie/${scriptPath}/Script.js"/>
		<e:script value="/pages/xbuilder/component/line/${scriptPath}/Script.js" />
		<e:script value="/pages/xbuilder/component/column/${scriptPath}/Script.js" />
		<e:script value="/pages/xbuilder/component/columnline/${scriptPath}/Script.js" />
		<e:script value="/pages/xbuilder/component/bar/${scriptPath}/Script.js" />
		<e:script value="/pages/xbuilder/component/scatter/${scriptPath}/Script.js" />
		<e:script value="/pages/xbuilder/component/datagrid/${scriptPath}/Script.js" />
		<e:script value="/pages/xbuilder/component/crosstable/${scriptPath}/Script.js" />
		<e:script value="/pages/xbuilder/component/treegrid/${scriptPath}/Script.js" />
		<e:script value="/pages/xbuilder/component/weblate/Script.js" />
		
		<e:script value="/resources/easyResources/component/jqueryui/ui/jquery.ui.core.js"/>
		<e:script value="/resources/easyResources/component/jqueryui/ui/jquery.ui.widget.js"/>
		<e:script value="/resources/easyResources/component/jqueryui/ui/jquery.ui.mouse.js"/>
		<e:script value="/resources/easyResources/component/jqueryui/ui/jquery.ui.selectable.js"/>
		<e:style value="/pages/xbuilder/resources/component/jqueryui/themes/base/jquery.ui.selectable.css"/>
		<e:script value="/pages/xbuilder/resources/scripts/base64.js"/>
		<e:script value="/pages/xbuilder/resources/scripts/jquery_format.js"/>
		
		<e:style value="/resources/component/pagewalkthrough/jquery.pagewalkthrough.css"/>
		<e:script value="/resources/component/pagewalkthrough/jquery.pagewalkthrough.min.js"/>
		<e:script value="/resources/component/jquery/plugins/jquery.cookie.js"/>
		<script> 
			$(function(){//dsType:1为自定义sql，2为指标库，3位全局sql，与1相同
				LayOutUtil.init('<%=xid%>','${sessionScope.UserInfo.USER_ID}',$('#name').val(),$('#theme').val(),$("#selectable_layout_id001").html(),'${param.lw}','${param.dsType}','1','${e:java2json(color_list.list)}','<%=contw%>','${param.typeExt}');
				LayOutUtil.data.sumControlExpFlag='${sumControlExpFlag}';
				LayOutUtil.data.xDefautlTablePagiNum='${xDefautlTablePagiNum}';
				if(LayOutUtil.data.xDefautlTablePagiNum==''){
					LayOutUtil.data.xDefautlTablePagiNum=10;
				}
				openCubeTabPanel();
				//描述弹出框
				$('#reportDescForm').form({
					url:appBase+"/pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=INSERTREPORT",
				    onSubmit: function(){  
				        return $(this).form('validate');
				    },
				    success:function(data){  
				    	$("#report_id").val("");
				        var temp = $.trim(data);
						if(temp>0) {
							$.messager.alert("信息","报表描述保存成功！","info");
							$("#reportDescDialog").dialog("close");
							$('#reportTable').datagrid("load",$("#reportTable").datagrid("options").queryParams);
						} else {
							$.messager.alert("报表描述保存过程中出现错误，请联系管理员！");
						}
					}
				});
				$("#reportDescDialog").dialog({
					width:450,
					height:360,
					modal:true,
					closed:true,
					top:200,
					buttons:[{
						text:'提交',
						handler:saveReport
					}]
				});
				//用户信息弹出框
				$("#userInfoDialog").dialog({
					width:450,
					height:415,
					modal:true,
					closed:true,
					top:20,
					buttons:[{
						text:'确认',
						handler:saveUser
					}]
				});
				
				$("#depTreeDialog").dialog({
				 	width:400,
					height:400,
					modal:true,
					closed:true,
					top:20
					 });
					 
				//设置描述提示框位置
				var rightMenuUlWidth=($("#rightMenuUl").width());
				var rightMenuUlLi1Width=$("#rightMenuUl li:eq(0)").width();
				var rightMenuUlLi2Width=$("#rightMenuUl li:eq(1)").width();
				var rightMenuPositionValue=rightMenuUlWidth-rightMenuUlLi1Width-60;
				var xShowGuideWhenAddPage="${xShowGuideWhenAddPage}";
				if(xShowGuideWhenAddPage=='1'){
					rightMenuPositionValue=rightMenuUlWidth-rightMenuUlLi1Width-rightMenuUlLi2Width-60;
				}
				$(".tip-bubble").css("right",rightMenuPositionValue);
				//设置点击上方右侧主菜单，隐藏右侧弹出窗口
				$("#rightMenuUl li:not(:eq(0))").click(function(){hideToolsPanel()});
			});
			
			var i = 3;  
			function remainTime(){  
			    if(i==0){  
			        $(".tip-bubble").fadeOut(1200);
			        i = 3;
			        return;
			    }  
			    i--;  
			    setTimeout("remainTime()",1000);  
			}  
			/**
			  *默认打开数据集
			  */
			function openCubeTabPanel(){
				if(LayOutUtil.data.dstype=='2'){
				    $('.tabTiele li').each(function(index,item) {
				    	 if(index == 1) {
		 			         $(item).addClass('cur').siblings().removeClass('cur');
		 			         $('.tabBox .tabInner').eq(index).show().siblings(".tabInner").hide();
				    	 }
				     });
			     }
			 }
		</script>
		<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	    <e:style value="/pages/xbuilder/resources/component/icheck/icheck.css"/>
	    <e:script value="/pages/xbuilder/resources/component/icheck/icheck.min.js"/>
</head>
<body class="easyui-layout" id="xDesignerLayout">
	<!-- Tip提示  className = Wap | unWap -->
	<div class="tip-bubble tip-bubble-top hide" >描述提示：填写新报表名称、提交人、提交部门、描述等</div>
    <!--header 头部-->
	<div id="header" data-options="region:'north',border:false" style="height:50px;">
        <!--工具栏-->
        <div id="tabTools">
        	<!-- <div id="alertDivBase" class="component-edit alert-window"></div> -->
        	<h1>X-Builder</h1>
            <ul class="tabTiele">
                <li><a href="javascript:void(0);"><em>1</em>布局</a></li>
                <e:if condition="${param.dsType == '1'|| param.typeExt == '3'}" var="dstv">
                	<li class="reportResultClass"><a href="javascript:void(0);"><em>2</em>数据集</a></li>
                	<li id="templeteIdLi"><a href="javascript:void(0);"><em>3</em>模板</a></li>
                </e:if>
                <e:else condition="${dstv}">
                	<li class="reportResultClass"><a href="javascript:void(0);"><em>2</em>数据集</a></li>
                	<li id="templeteIdLi"><a href="javascript:void(0);"><em>3</em>模板</a></li>
                </e:else>
                <li><a href="javascript:void(0);">组件</a></li>
                <li><a href="javascript:void(0);">主题</a></li>
            </ul>
            <!--视图切换-->
            <ul class="toggleShow" id="rightMenuUl">
            	<e:if condition="${xShowGuideWhenAddPage=='1'}">
            		<li class="nth0"><a href="javascript:void(0);" onclick="doGuide();">向导</a></li>
            	</e:if>
		    	<li class="nth1"><a href="javascript:void(0);" onclick="setDescribe();">描述</a></li>
                <li class="nth2"><a id="publish_a" href="javascript:void(0);" title="发布">发布</a></li>
                <li class="nth3"><a href="javascript:void(0);" onclick="LayOutUtil.resetPage();">刷新</a></li>
                <li class="nth4"><a href="<e:url value='xGenerate.e'/>?xid=<%=xid%>&type=0&edit=0" target="_blank" title="保存">保存</a></li>
                <li class="nth5 cur"><a href="javascript:void(0);" id="pcToggle">PC端</a></li>
                <li class="nth6"><a href="javascript:void(0);" id="phoneToggle" <e:if condition="${applicationScope['xmobile'] != '1'}">style="display:none"</e:if>>手机端</a></li>
            </ul>
            <!--视图切换-->
        </div>
        <!--//工具栏-->
	</div>
    <!--//header 头部-->
    <!-- 弹出菜单 -->
    <div class="tabBox">
        	<!-- 布局 -->
            <div class="tabInner">
                <ul class="guideIcon tabIco01">
                    <li class="tIco01"><a href="javascript:void(0);" onclick="LayOutUtil.changeLayout('layout_01');"><span>基础布局</span></a></li>
                    <li class="tIco02"><a href="javascript:void(0);" onclick="LayOutUtil.changeLayout('layout_05');"><span>1:1布局</span></a></li>
                    <li class="tIco03"><a href="javascript:void(0);" onclick="LayOutUtil.changeLayout('layout_02');"><span>1:1:1布局</span></a></li>
                    <li class="tIco04"><a href="javascript:void(0);" onclick="LayOutUtil.changeLayout('layout_03');"><span>1:2:1布局</span></a></li>
                    <li class="tIco07"><a href="javascript:void(0);" onclick="LayOutUtil.changeLayout('layout_06');"><span>2:1:1布局</span></a></li>
                    <li class="tIco08"><a href="javascript:void(0);" onclick="LayOutUtil.changeLayout('layout_07');"><span>2:2:1布局</span></a></li>
                    <li class="tIco09"><a href="javascript:void(0);" onclick="LayOutUtil.changeLayout('layout_08');"><span>2:2:2布局</span></a></li>
                    <li class="tIco10"><a href="javascript:void(0);" onclick="LayOutUtil.changeLayout('layout_04');"><span>1:2布局</span></a></li>
                    <li class="tIco06"><a href="javascript:void(0);" onclick="LayOutUtil.addL();"><span>添加布局块</span></a></li>
                </ul>
            </div>
            <!-- //布局 -->
            <!-- 数据源 -->
            <e:if condition="${param.dsType == '1'|| param.typeExt == '3'}" var="kpiModel">
            <div class="tabInner">
				<ul class="guideIcon tabIco02">
					<!-- 
	                <li class="tIco01"><a href="javascript:void(0);" id ="add"   onclick="addDatabase('${param.dsType}')"><span>添加</span></a></li>
					<li class="tIco02"><a href="javascript:void(0);" id ="search"  onclick="searchDatabase()" ><span>引用</span></a></li> -->
  	 				<jsp:include page="/pages/xbuilder/dataset/XReportSql.jsp"> 
	                	<jsp:param name="report_id" value="<%=xid %>" />
				   		<jsp:param name="typeExt" value="${param.typeExt}" />
			    	</jsp:include>
			    </ul>
			  
            </div>
            </e:if>
            <e:else condition="kpiModel">
	            <div class="tabInner">
					<ul class="guideIcon tabIco02">
						<!-- 
		                <li class="tIco01"><a href="javascript:void(0);" id ="add"   onclick="addDatabase('${param.dsType}')"><span>添加</span></a></li>
						<li class="tIco02"><a href="javascript:void(0);" id ="search"  onclick="searchDatabase()" ><span>引用</span></a></li> -->
	  	 				<jsp:include page="/pages/xbuilder/dataset/CqXReportKpi.jsp"> 
		                	<jsp:param name="report_id" value="<%=xid %>" />
					   		<jsp:param name="typeExt" value="${param.typeExt}" />
				    	</jsp:include>
				    </ul>
	            </div>
            </e:else>
            <!-- 模板 -->
            <div class="tabInner towTools">
             	<ul class="guideIcon tabIco03 group">
	                <jsp:include page="/pages/xbuilder/component/ComponentList.jsp"> 
				   		<jsp:param name="dataType" value="${param.dsType}" />
				    </jsp:include>
			    </ul>
            </div>
            <!-- //模板 -->
            <!-- 组件 -->
            <div class="tabInner">
                <ul id="component_tab" class="guideIcon tabIco03">
                	
                </ul>
            </div>
            <!-- //组件 -->
            <!-- 主题 -->
            <div class="tabInner">
				<ul id="theme_tab" class="guideIcon tabIco05">
					<e:forEach items="${theme_list.list}" var="item">
						<li class="tIco0${item.CLASS_NUM }"><a href="javascript:void(0)" value="${item.ID }"><span>${item.name }</span></a></li>
					</e:forEach>
				</ul>
            </div>
			<!-- //主题 -->
 			</div>
 <!-- 弹出菜单 -->
    
	<div data-options="region:'center'" id="container" >
        <!--操作区 pc_guide-->
        <div id="con_panel">
        	<div class="pc_guide" id="guideOut">
         	<!-- <a href="javascript:void();" class="phoneDragger">拖拽器</a> -->
               <!--搜索区-->
            <div class="serchIndex">
                <div class="serchIndexIn">
                	<h3>查询条件</h3>
	                <ol class="serchSet">
	                	<%String dsType = request.getParameter("dsType"); 
	                	  if(dsType!=null && dsType.equals("2")){
	                	%>	
	                		<li class="icoAddConditions"><a href="javascript:void(0);" onclick="addDimFromKpi();">条件添加</a></li>
	                    <%}else{%>
	                    	<li class="icoAddConditions"><a href="javascript:void(0);" onclick="addSQLWhere();">条件添加</a></li>
	                	 <%}%>
	                	<li class="icoSetContainer"><a href="javascript:void(0);" onclick="setAllDim('1');">容器设置</a></li>
	               </ol>
	                <p id="dimsion" style="width:100%;height:auto;min-height:35px;"></p>
					 <!-- 
                	<ol class="serchSet">
						<li class="icoAddConditions"><a href="javascript:void(0)" onclick="addDimFromKpi();" title="添加条件">添加条件</a></li>
						<li class="icoSetContainer"><a href="javascript:void(0)" onclick="setAllDim('1');" title="容器设置">容器设置</a></li>
					</ol>
	                <p>
	                	<span class="pr_15 down"><select class="easyui-combobox w_150" style="height:26px;" name="language"><option value="ar">地市查询</option></select> <a href="javascript:void(0)" class="easyui-linkbutton icon-newS" data-options="plain:true,iconCls:'icon-setting'"></a></span>
	                    <span class="pr_15 data"><input type="text"  style="height:26px;" value="账期查询" class="easyui-datebox w_150"  /> <a href="javascript:void(0)" class="easyui-linkbutton icon-newS" data-options="plain:true,iconCls:'icon-setting'"></a></span>
	                    <span class="pr_15"><input class="easyui-textbox w_450"  placeholder="请输入查询条件" type="text" name="name" data-options="required:false"></input> <a href="javascript:void(0)" class="easyui-linkbutton icon-newS" data-options="plain:true,iconCls:'icon-setting'"></a></span>
	                    <span class="pr_15"><a href="javascript:void(0);" class="easyui-linkbutton">确认查询</a></span>
	                </p>
	                 -->
					<b class="bTl"></b> <b class="bTr"></b> <b class="bBl"></b> <b class="bBr"></b>
                </div>
            </div>
            <!--//搜索区-->
            <!--视图区-->
            <div class="charInner">
                <!--Pc 端-->
              <div class=" group guideBox">
              	  <div class="phoneSorllo group">
		              <div id="selectable_layout_id001" class="gridster ready">
					  <ul style="position: relative;margin:0; z-index:1;">
						<li id="<%=xid%>_1" data-row="1" data-col="1" data-sizex="<%=contw%>" data-sizey="20" class="gs-w" style="position: absolute; min-width:440px; min-height: 140px;">
							<b class="bTl"></b> <b class="bTr"></b> <b class="bBl"></b> <b class="bBr"></b>
							<div id="div_set_<%=xid%>_1" class="component-set">
								<ol>
									<li class="icoComponentEditor"><a href="javascript:void(0)" onclick="LayOutUtil.componentEdit('<%=xid%>_1');return false;" title="组件编辑">组件编辑</a></li>
									<li class="icoSetContainer"><a href="javascript:void(0)" onclick="LayOutUtil.openEditePropertyView('<%=xid%>_1');return false;" title="容器设置">容器设置</a></li>
									<li class="icoEmptyContainer"><a href="javascript:void(0)" onclick="LayOutUtil.removeComponents('<%=xid%>_1');return false;" title="容器清空">容器清空</a></li>
									<li class="icoDeleteContainer"><a href="javascript:void(0)" onclick="LayOutUtil.removeL('<%=xid%>_1');return false;" title="容器删除">容器删除</a></li>
								</ol>
							</div>
							<div  id="div_area_<%=xid%>_1" class="component-area">
							    <div id="div_head_<%=xid%>_1" class="component-head">
							        <h3 id="div_head_title_<%=xid%>_1">
							        	<span id="div_head_title_<%=xid%>_1_span">未命名标题</span>
							        </h3>
							    </div>
							    <div id="div_body_<%=xid%>_1" class="component-con">
							    </div>
							</div>
						</li>
					  </ul>
					</div>
				 </div>
            </div>    
                <!--//Pc 端-->
            
            </div>
            <!--//视图区-->
           
            </div>
           
        </div>
		<div id="popdiv" class="easyui-window" title=""  data-options="modal:true"  closed="true" shadow="true" resizable="false" collapsible="false" minimizable="false" maximizable="false" style="width:600px;height:200px;padding:10px; z-index:10;"></div>
	
	<form id="resetf" action="<e:url value="/pages/xbuilder/pagedesigner/XBuilder.jsp"/>" method="post">
		<input id="lw" name="lw" type="hidden" value="${param.lw}"/>
		<input type="hidden" id="dsType" name="dsType" value="${param.dsType}" />
		<input type="hidden" id="typeExt" name="typeExt" value="${param.typeExt}" />
		<input type="hidden" id="cubeid" name="cubeid" value="${param.cubeid}" />
	</form>
	</div>
	 <!--tools panel-->
      <div id="tools_panel">
          <a class="closeTools" href="javascript:void(0);">关闭</a>
          <h3>组件属性设置</h3>
          <div id="propertiesPage" class="inTools">
          	<div id="dimproall"></div>
          	<div id="dimproperties"></div>
          	<div id="dimtemplateview"></div>
          </div>
           <div id="propertiesCache" class="inTools" style="display:none">
          	 <div id="dimproallCache" objtype = 'containerCache'></div>;
          	 <div id="dimpropertiesCache" objtype = 'containerCache'></div>;
          	 <div id="dimtemplateviewCache" objtype = 'containerCache'></div>;
          </div>
      </div>
      <!--//tools panel-->
	 <e:if condition="${param.dsType == '2'}" var="elseval">
	  	<a:kpiSelector id="conditionKpiSelector" right="25" top="115"></a:kpiSelector>
	 </e:if>
	 <e:else condition="${elseval}">
		<a:sqlSelector id="conditionSqlSelector" right="25" top="115"></a:sqlSelector>
	 </e:else>
	<!--//操作区-->
       <div id="mask" class="mask hide"></div>  
	   <div id="conDialog1" title="选择容器" class="switch-mode-window">
	        <a href="javascript:void(0);"onclick="closeDialog('conDialog1');" class="close">&times;</a>
			<ul class="switch-mode-group">
	   			<li class="switch-num1-item"><a href="javascript:void(0);" onclick="fillContainer('0')"></a><span>替换组件</span></li>
	   			<li class="switch-num2-item"><a href="javascript:void(0);" onclick="fillContainer('1')"></a><span>弹出显示</span></li>
	   			<li class="switch-num3-item"><a href="javascript:void(0);" onclick="fillContainer('2')"></a><span>切换显示</span></li>
	   			<li class="switch-num4-item"><a href="javascript:void(0);" onclick="fillContainer('3')"></a><span>选项卡显示</span></li>
	   		</ul>
	   </div> 
	   <div id="conDialog2" class="switch-mode-window" title="选择替换项"> 
	   		 <a href="javascript:void(0);"onclick="closeDialog('conDialog2');" class="close">&times;</a>
			<ul class="switch-mode-group">
	   			<li class="switch-num1-item"><a href="javascript:void(0);" onclick="selReplaceType('0')"></a><span>替换基础组件</span></li>
	   			<li class="switch-num2-item"><a href="javascript:void(0);" onclick="selReplaceType('1')"></a><span>替换弹出组件</span></li>
	   		</ul>
	   </div> 
	<!--//描述--> 
	 
	 <div id="reportDescDialog" title="报表描述">
		<form action="" method="post" id="reportDescForm">
			<table width="100%" class="windowsTable">
				<colgroup>
					<col width="25%">
					<col width="*">
				</colgroup>
				<tr>
					<th>
					   报表名称：
					</th>
					<td>
						<p class="xHeadTop">
			                <input name="words" class="reNameText" id="autoInput" type="text" size="20" value="未命名报表"  style="width: 90%" onfocus="focusWords(this)" onkeyup="checkLength(this)" data-options="required:false" onBlur="blurWords(this)"/> 
							<span id="char" class="hide">0</span>
		                </p>
					</td>
				</tr>
				<tr>	
					<th>
						提出人：
					</th>
					<td>
						<input type="hidden" name="user_id" id="user_id">
						<input type="text" style="width: 90%" name="user_name"
							id="user_name" onclick="getUserName()">
					</td>
				</tr>
				<tr>
					<th>
						提出部门：
					</th>
					<td>
						<input type="hidden" name="department_code" id="department_code">
						<input type="text" style="width: 90%" name="department_desc"
							id="department_desc" onclick="getDepName()">
					</td>
				</tr>
				<tr>
					<th>
						描述：
					</th>
					<td>
						<textarea style="width: 91%; height: 100px;" id="report_desc" name="report_desc"></textarea>
					</td>
				</tr>
				<input type="hidden" name="report_id" id="report_id">
			</table>
		</form>
	</div>
	<div id="reportNamedlg" class="easyui-dialog" title="报表属性" style="width:400px;height:200px"
			data-options="
				closed:true,
				modal:true,
				cls:'easyui-linkbutton-gray',
				buttons: [{
					text:'确定',
					handler:function(){
						var inname = $('#reportSaveName').val();
						if('' == inname || $.trim(inname) == ''){
							alert('请填写报表名称！');
							return false;
						}
						savaDimToTemplate();
						LayOutUtil.setNameAndGenerate(inname,'');
					}
				},{
					text:'取消',
					handler:function(){
						$('#reportNamedlg').dialog('close');
					}
				}]
			">
			
		<div class="dialogAddIco">
			<div class="dialogIcoEdit"></div>
			<table width="100%" class="windowsTable dialogForm">
				<colgroup>
					<col width="25%">
					<col width="*">
				</colgroup>
				<tr>
					<th>
					   报表名称：
					</th>
					<td>
						<p class="xHeadTop">
			                <input name="reportSaveName" class="reNameText" id="reportSaveName" type="text" size="20"  style="width: 90%"/> 
		                </p>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="userInfoDialog" title="用户信息">
			<form action="" method="post" id="userInfoForm">
				<div id="tbaru">
					<table>
						<tr>
							<td>
								用户名称：
								<input type="text" id="userName" name="userName">
							</td>
							<td>
								<a href="javascript:void(0);" class="easyui-linkbutton"
									onclick="doQueryUser()">查询</a>
							</td>
						</tr>
					</table>
				</div>
				<c:datagrid
					url="/pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=USERLIST"
					id="userTable" singleSelect="true" toolbar="#tbaru">
					<thead>
						<tr>
							<th field="ck" checkbox="true"></th>
							<th field="USER_ID" width="100">
								用户ID
							</th>
							<th field="USER_NAME" width="100">
								用户名称
							</th>
						</tr>
					</thead>
				</c:datagrid>
			</form>
		</div>
		
		<div id="depTreeDialog" title="局方部门">
			<a:tree id="depTree"
				url="pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=DEPTREE"
				onSelect="slectDep" />
		</div>
		<!-- 向导面页 -->
		<e:if condition="${xShowGuideWhenAddPage!='1'}">
			<script type="text/javascript">
				$(function(){
						$(".tip-bubble").show();
						remainTime();
				});
				function doGuide()
						{
							$.cookie(operateCookie, "1"); 
							$('body').pagewalkthrough('show');
						}
			</script>
		</e:if>
		<e:if condition="${xShowGuideWhenAddPage=='1'}">
			<script type="text/javascript">
				var operateCookie="xbuiler_user_operate_guide_state";
				$(function(){
					initGuide();
				});
				function doGuide()
				{
					$.cookie(operateCookie, "1"); 
					$('body').pagewalkthrough('show');
				}
			</script>
			<e:if condition="${param.dsType == '2'}">
				<script type="text/javascript">
					function initGuide()
					{
						$('body').pagewalkthrough({
		                    name: 'introduction',
		                    onAfterShow:function()
		                    	{$("#tools_panel").show();},
		                    onClose:function(e){
		                    	$.cookie(operateCookie, "0", { expires: 365 }); 
		                    	$(".tip-bubble").show();
								remainTime();
		                    },
		                    buttons : {
		            			jpwClose : {
		            				i18n : "不再提示",
		            				show : true
		            			},
		            			jpwNext : {
		            				//i18n : "下一步 &rarr;"
		            				i18n : "继续"
		            			},
		            			jpwPrevious : {
		            				i18n : "上一步"
		            			},
		            			jpwFinish : {
		            				i18n : "我知道了 &#10004;"
		            			}
		                    },
		                    steps: [{
		                            popup: { //定义弹出提示引导层
		                                content: '#walkthrough-welcom',
		                                type: 'modal'
		                            }
		                       }, {
		                            wrapper: '.reportResultClass',
		                            popup: {
		                                content: '#walkthrough-reportResultClass',
		                                type: 'tooltip',
		                                position: 'bottom'
		                            }
		                        }, {
		                            wrapper: '.openKpi',//当前引导对应的元素位置
		                            popup: {
		                                content: '#walkthrough-openKpi',//关联的内容元素
		                                type: 'tooltip',//弹出方式（tooltip和modal以及nohighlight）
		                                position: 'bottom'//弹出层位置（top,left, right or bottom）
		                            } 
		                        
		                        }, {
		                            wrapper: '#tools_panel',
		                            popup: {
		                                content: '#walkthrough-tools_panel',
		                                type: 'tooltip',
		                                position: 'left'
		                            }
		                        }, 
		                        {
		                            wrapper: '.nth4',
		                            popup: {
		                                content: '#walkthrough-nth4',
		                                type: 'tooltip',
		                                position: 'bottom',
		                                offsetHorizontal:-100
		                                
		                            }
		                        }]
		                });
						if($.cookie(operateCookie)=="1" || $.cookie(operateCookie)==undefined)
						{
							$('body').pagewalkthrough('show');
						}else{
							$(".tip-bubble").show();
							remainTime();
						}
					}
				
				</script>
			    <div id="walkthrough-content">
		           <div id="walkthrough-welcom" style="backgroud:url('/xbuilder/resources/component/pagewalkthrough/images/bg.png')">
		               <h3>欢迎使用自助报表向导</h3>
		               <p>本向导将带您浏览报表主要操作步骤</p>
		           </div>
		           <div id="walkthrough-reportResultClass">
		           	<h3>第一步：选定数据源</h3>
		           	<p>我们已将常用统计分析指标分类汇总，请根据实际需求在【数据集】中选择相应的数据源表</p>
		           </div>
		           <div id="walkthrough-openKpi">
		           	<h3>装载指标</h3>
		               <p>点击【打开指标库】，选择统计维度及指标</p>    
		           </div>
		           <div id="walkthrough-tools_panel">
		               <h3>拖拽选择</h3>
		               <p>把您所需的指标拖入指标框内、维度拖入维度框</p> 
		           </div>
		           
		           <div id="walkthrough-nth4">
		               <h3>预览效果</h3>
		               <p>点击【保存】，对您前几步的操作进行预览</p> 
		           </div>
		       </div>
		    </e:if>
       </e:if>
       <e:if condition="${param.dsType == '1'|| param.typeExt == '3'}">
       		<script type="text/javascript">
				function initGuide()
				{
					$('body').pagewalkthrough({
	                    name: 'introduction',
	                    onAfterShow:function()
	                    	{},
	                    onClose:function(e){
	                    	$.cookie(operateCookie, "0", { expires: 365 }); 
	                    	$(".tip-bubble").show();
							remainTime();
	                    },
	                    buttons : {
	            			jpwClose : {
	            				i18n : "不再提示",
	            				show : true
	            			},
	            			jpwNext : {
	            				//i18n : "下一步 &rarr;"
	            				i18n : "继续"
	            			},
	            			jpwPrevious : {
	            				i18n : "上一步"
	            			},
	            			jpwFinish : {
	            				i18n : "我知道了 &#10004;"
	            			}
	                    },
	                    steps: [{
	                            popup: { //定义弹出提示引导层
	                                content: '#walkthrough-welcom',
	                                type: 'modal'
	                            }
	                       }, {
	                            wrapper: '.reportResultClass',
	                            popup: {
	                                content: '#walkthrough-reportResultClass',
	                                type: 'tooltip',
	                                position: 'bottom'
	                            },
	                             onEnter: function(){
					                return true;
					            },
					             onLeave: function(){
					             	return true;
					             }
	                        }, {
	                            wrapper: '#templeteIdLi',//当前引导对应的元素位置
	                            popup: {
	                                content: '#walkthrough-templeteIdLi',//关联的内容元素
	                                type: 'tooltip',//弹出方式（tooltip和modal以及nohighlight）
	                                position: 'bottom'//弹出层位置（top,left, right or bottom）
	                            } 
	                        
	                        }, {
	                            wrapper: '.nth4',
	                            popup: {
	                                content: '#walkthrough-nth4',
	                                type: 'tooltip',
	                                position: 'bottom',
	                                offsetHorizontal:-100
	                            }
	                        }]
	                });
					if($.cookie(operateCookie)=="1" || $.cookie(operateCookie)==undefined)
					{
						$('body').pagewalkthrough('show');
					}else{
						$(".tip-bubble").show();
						remainTime();
					}
				}
			
			</script>
		    <div id="walkthrough-content">
	           <div id="walkthrough-welcom" style="backgroud:url('/xbuilder/resources/component/pagewalkthrough/images/bg.png')">
	               <h3>欢迎使用取数向导</h3>
	               <p>本向导将带您浏览取数步骤</p>
	           </div>
	           <div id="walkthrough-reportResultClass">
	           	<h3>选定源头</h3>
	           	<p>自助取数第一步，数据从哪里来？</p>
	            <p>请在【数据集】中添加或引用数据sql</p>                 
	           </div>
	           <div id="walkthrough-templeteIdLi">
	           	<h3>选择模板</h3>
	               <p>选中布局块后，点击【模板】，选择所需模板，然后配置模板</p>    
	           </div>
	           <div id="walkthrough-nth4">
	               <h3>预览效果</h3>
	               <p>点击【保存】，对您前几步的操作进行预览</p> 
	           </div>
	       </div>
       </e:if>
</body>
</html>