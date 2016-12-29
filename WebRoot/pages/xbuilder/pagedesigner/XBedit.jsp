<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@page import="cn.com.easy.xbuilder.element.Report"%>
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
	Report view = (Report)request.getAttribute("VIEW_");
	String dsType = view.getInfo().getType();
	String typeExt = view.getInfo().getTypeExt();
	String viewid = view.getId();
	String theme = view.getTheme();
	String vlayout = (String)request.getAttribute("VIEW_LAYOUT_");
	String load_js = (String)request.getAttribute("LOAD_JS_");
	int maxi = Integer.parseInt((String)request.getAttribute("MAX_I_"));
	String slw = (String)request.getAttribute("SCREEN_WIDTH_");
	String contw = String.valueOf(Math.floor(Integer.parseInt(view.getLayout().getWidth())*0.9*0.91/20)).replaceAll("\\.0","");
	//System.out.println(load_js);
%>
<e:set var="dsType"><%=dsType%></e:set>
<e:set var="typeExt"><%=typeExt%></e:set>
<e:if condition="${dsType eq '1'||typeExt eq '3'}">
	 <e:set var="scriptPath">sql</e:set>
</e:if>
<e:if condition="${dsType eq '2'}">
	  <e:set var="scriptPath">kpi</e:set>
</e:if>
<!DOCTYPE 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<base href="<%=request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/"%>">
		<title>报表构建</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="X-UA-Compatible" content="IE=11;IE=10;IE=9;" />
		<e:style value="/pages/xbuilder/resources/component/gridster/jquery.gridster.min.css"/>
		<e:style value="/pages/xbuilder/resources/component/gridster/style.css"/>
		<c:resources type="highchart, easyui" style="${ThemeStyle }"/>
		<e:service/>
		<e:script value="/pages/xbuilder/resources/component/gridster/jquery.gridster.js"/>
		<e:script value="/pages/xbuilder/resources/component/echart/echarts-all.js"/>
		<script> 
			  var typeExt = '${typeExt}';
		</script>
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
		<e:script value="/pages/xbuilder/component/crosstable/ScriptCommon.js" />
		
		<e:script value="/pages/xbuilder/component/datagrid/TableService.js"/>
		<e:script value="/pages/xbuilder/component/datagrid/TableEvent.js"/>
		<e:script value="/pages/xbuilder/component/datagrid/ScriptCommon.js"/>
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
		<script> 
			$(function(){
				LayOutUtil.setEdit('<%=viewid%>',<%=maxi%>,'${sessionScope.UserInfo.USER_ID}',$('#name').val(),'<%=theme%>',$("#selectable_layout_id001").html(),'<%=view.getLayout().getWidth()%>','${dsType}','1','${e:java2json(color_list.list)}','<%=contw%>','${typeExt}');
				LayOutUtil.data.sumControlExpFlag='${sumControlExpFlag}';
				LayOutUtil.data.xDefautlTablePagiNum='${xDefautlTablePagiNum}';
				if(LayOutUtil.data.xDefautlTablePagiNum==''){
					LayOutUtil.data.xDefautlTablePagiNum=10;
				}
			});
		</script>
	    <e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	    <e:style value="/pages/xbuilder/resources/component/icheck/icheck.css"/>
	    <e:script value="/pages/xbuilder/resources/component/icheck/icheck.min.js"/>
    	<script  type="text/javascript">
           $(function(){
               <%=load_js%>
               initEditDataSet();
               initEditComponentData();
               editDim();
               

           	
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
							$.messager.alert("提示信息","报表描述保存成功！","info");
							$("#reportDescDialog").dialog("close");
							$('#reportTable').datagrid("load",$("#reportTable").datagrid("options").queryParams);
						} else {
							$.messager.alert("提示信息！","报表描述保存过程中出现错误，请联系管理员！","error");
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
				$(".tip-bubble").css("right",(rightMenuUlWidth-rightMenuUlLi1Width-60));
				
				//设置点击上方右侧主菜单，隐藏右侧弹出窗口
				$("#rightMenuUl li").click(function(){hideToolsPanel()});
			
			});
			function updMenuName(inname){//修改报表时修改已经上架的报表名称
			 	$.ajax({
		          	type : "post",  
		         	url : appBase+"/pages/frame/menu/menuAction.jsp?eaction=updMenuWhenPublishReport",  
		          	data : {"reportId":StoreData.xid,menuName:inname}
		        });
			}
    	</script>
    	<script>
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
			remainTime();
		</script>
</head>
<body class="easyui-layout" id="xDesignerLayout">
	<div class="tip-bubble tip-bubble-top">描述提示：填写新报表名称、提交人、提交部门、描述等</div>
    <!--header 头部-->
	<div id="header" data-options="region:'north',border:false" style="height:50px;">
         <!-- <div id="alertDivBase" class="component-edit alert-window"></div> -->
        <!--工具栏-->
        <div id="tabTools">
        	<h1>X-Builder</h1>
            <ul class="tabTiele">
                <li><a href="javascript:void(0);"><em>1</em>布局</a></li>
                <e:if condition="${dsType == '1'|| typeExt == '3'}" var="dstv">
                	<li><a href="javascript:void(0);"><em>2</em>数据集</a></li>
                	<li><a href="javascript:void(0);"><em>3</em>模板</a></li>
                </e:if>
                <e:else condition="${dstv}">
                	<li><a href="javascript:void(0);"><em>2</em>数据集</a></li>
                	<li><a href="javascript:void(0);"><em>3</em>模板</a></li>
                </e:else>
                <li><a href="javascript:void(0);">组件</a></li>
                <li><a href="javascript:void(0);">主题</a></li>
            </ul>
            <!--视图切换-->
            <ul class="toggleShow" id="rightMenuUl">
            	<!-- 
            		<e:if condition="${dsType == '2'}">
				  		 <li class="nth1"><input class="easyui-combobox" name="cubeComb" id="cubeComb"></input></li>
				    </e:if>
            	 -->
			    <li class="nth1"><a href="javascript:void(0);" onclick="setDescribe();">描述</a></li>
                <li class="nth2"><a id="publish_a"  href="javascript:void(0);" title="发布">发布</a></li>
                <li class="nth3"></li>
                <li class="nth4"><a href="<e:url value='xGenerate.e'/>?xid=<%=viewid%>&type=0&edit=1&slw=<%=slw%>" target="_blank" title="保存">保存</a></li>
                <li class="nth5"><a href="javascript:void(0);" id="pcToggle">PC端</a></li>
                <li class="nth6"><a href="javascript:void(0);" id="phoneToggle" <e:if condition="${applicationScope['xmobile'] != '1'}">style="display:none"</e:if>>手机端</a></li>
            </ul>
            <!--视图切换-->
        </div>
        <!--//工具栏-->
	</div>
    <!--//header 头部-->
	<div data-options="region:'center'" id="container">
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
                    <li class="tIco10"><a href="javascript:void(0);" onclick="LayOutUtil.changeLayout('layout_04');"><span>2:1布局</span></a></li>
                    <li class="tIco06"><a href="javascript:void(0);" onclick="LayOutUtil.addL();"><span>添加布局块</span></a></li>
                </ul>

            </div>
            <!-- //布局 -->
            <!-- 数据源 -->
            <e:if condition="${dsType == '1'|| typeExt == '3'}" var="kpiModel">
            <div class="tabInner">
				<ul class="guideIcon tabIco02">
					<!-- 
	                <li class="tIco01"><a href="javascript:void(0);" id ="add"   onclick="addDatabase('${dsType}')"><span>添加</span></a></li>
					<li class="tIco02"><a href="javascript:void(0);" id ="search"  onclick="searchDatabase()" ><span>引用</span></a></li> -->
  	 				<jsp:include page="/pages/xbuilder/dataset/XReportSql.jsp"> 
	                	<jsp:param name="report_id" value="<%=viewid%>" />
				   		<jsp:param name="typeExt" value="${typeExt}" />
			    	</jsp:include>
			    </ul>
            </div>
            </e:if>
            <e:else condition="kpiModel">
	            <div class="tabInner">
					<ul class="guideIcon tabIco02">
	  	 				<jsp:include page="/pages/xbuilder/dataset/CqXReportKpi.jsp"> 
		                	<jsp:param name="report_id" value="<%=viewid %>" />
					   		<jsp:param name="typeExt" value="${param.typeExt}" />
				    	</jsp:include>
				    </ul>
	            </div>
            </e:else>
            <!-- 模板 -->
            <div class="tabInner towTools">
             	<ul class="guideIcon tabIco03 group">
	                <jsp:include page="/pages/xbuilder/component/ComponentList.jsp"> 
				   		<jsp:param name="dataType" value="${dsType}" />
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
        <!--操作区-->
        <div id="con_panel">
        	<div class="pc_guide" id="guideOut">
        		<a href="javascript:void();" class="phoneDragger">拖拽器</a>
               <!--搜索区-->
            <div class="serchIndex">
            		<div class="serchIndexIn">
                	<h3>查询条件</h3>
	                <ol class="serchSet">
	                	<%if(dsType!=null && dsType.equals("2")){%>	
	                		<li class="icoAddConditions"><a href="javascript:void(0);" onclick="addDimFromKpi();">条件添加</a></li>
	                    <%}else{%>
	                    	<li class="icoAddConditions"><a href="javascript:void(0);" onclick="addSQLWhere();">条件添加</a></li>
	                    <%}%>
	                	<li class="icoSetContainer"><a href="javascript:void(0);" onclick="setAllDim('1');">容器设置</a></li>
	               </ol>
	                <p id="dimsion" style="width:100%;height:auto;min-height:35px;"></p>
						
					</p>
					<!-- 
                	<ol class="serchSet">
						<li class="icoAddConditions"><a href="javascript:void(0)" onclick="addDimFromKpi();" title="添加条件">添加条件</a></li>
						<li class="icoSetContainer"><a href="javascript:void(0)" onclick="setAllDim('1');" title="容器设置">容器设置</a></li>
					</ol>
	                <p>
	                	<span class="pr_15 down"><select class="easyui-combobox w_150" style="height:26px;" name="language"><option value="ar">地市查询</option></select> <a href="javascript:void(0)" class="easyui-linkbutton icon-newS" data-options="plain:true,iconCls:'icon-setting'"></a></span>
	                    <span class="pr_15 data"><input type="text"  style="height:26px;" value="账期查询" class="easyui-datebox w_150"  /> <a href="javascript:void(0)" class="easyui-linkbutton icon-newS" data-options="plain:true,iconCls:'icon-setting'"></a></span>
	                    <span class="pr_15"><input class="easyui-textbox w_450"  placeholder="请输入查询条件" type="text" name="name" data-options="required:false"></input> <a href="javascript:void(0)" class="easyui-linkbutton icon-newS" data-options="plain:true,iconCls:'icon-setting'"></a></span>
	                    <span class="pr_15"><a href="javascript:void(0);" class="searchBtn">确认查询</a></span>
	                </p>
	                 -->
					<b class="bTl"></b> <b class="bTr"></b> <b class="bBl"></b> <b class="bBr"></b>
				</div>					
            </div>
            <!--//搜索区-->
            <!--视图区-->
            <div class="charInner">
                <!--Pc 端-->
              <div class="group guideBox">
              	  <div class="phoneSorllo group">
		              <%=vlayout%>
				 </div>
            </div>    
                <!--//Pc 端-->
            </div>
            <!--//视图区-->
            </div>
        </div>
	<div id="popdiv" class="easyui-window" title="" data-options="" closed="true" shadow="true" resizable="false" collapsible="false" minimizable="false" maximizable="false" style="width:500px;height:200px;padding:10px;">
	</div>
	
	<form id="resetf" action="<e:url value="/pages/xbuilder/pagedesigner/XBuilder.jsp"/>" method="post">
		<input id="lw" name="lw" type="hidden" value="<%=view.getLayout().getWidth()%>"/>
		<input type="hidden" id="dsType" name="dsType" value="${dsType}" />
		<input type="hidden" id="dsType" name="typeExt" value="${typeExt}" />
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
     <e:if condition="${dsType == '2'}" var="elseval">
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
		                    <input class="reNameText" type="text" value="<%=view.getInfo().getName()%>" id="autoInput" style="width: 90%" size="8" name="words" onkeyup="checkLength(this)" data-options="required:false" onBlur="LayOutUtil.setName(this.value);"></input>
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
							id="user_name" onclick="getUserName()"
							class="easyui-validatebox">
					</td>
				</tr>
				<tr>
					<th>
						提出部门：
					</th>
					<td>
						<input type="hidden" name="department_code" id="department_code">
						<input type="text" style="width: 90%" name="department_desc"
							id="department_desc" onclick="getDepName()"
							class="easyui-validatebox">
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
	
	<div id="reportNamedlg" class="easyui-dialog" title="报表属性"  style="width:400px;height:200px"
			data-options="
				closed:true,
				modal:true,
				buttons: [{
					text:'确定',
					handler:function(){
						var inname = $('#reportSaveName').val();
						if('' == inname || $.trim(inname) == ''){
							$.messager.alert('提示信息','请填写报表名称！','info');
							return false;
						}
						LayOutUtil.setNameAndGenerate(inname,'<%=slw%>');
						updMenuName(inname);
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
</body>
</html>