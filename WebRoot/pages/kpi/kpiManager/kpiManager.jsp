<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:q4o var="cube">select t.cube_code,t.cube_name  from x_kpi_cube t where t.cube_code ='${param.cube_code}' </e:q4o>
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources> 
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
	<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/resources/themes/base/boncBase@links.css"/>
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
    <script type="text/javascript" src="kpiManager.js" ></script>
	<script type="text/javascript">
				 
	</script>
 	 </head>
 		 <body class="easyui-layout">
	        <div data-options="region:'west',split:true" style="width:320px;padding:0px;">
	        	<div class="editBase_div_child">
					<dl class="ddLine">
						<dd>
							<input type="hidden" id="cube_code" name="cube_code" value="${cube.cube_code }"/>
							${cube.cube_name}
						</dd>
					</dl>
				</div>
				<div id="container_" class="kpiSelectorCon"  kpiSelectorDiv="true">
				<div id="tab-tools_">
						<a id="reloadDialogBtn_"  href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'"></a>
 				</div>
				<div id="tabs_" class="easyui-tabs" data-options="tools:'#tab-tools_'" style="width:320px;background:#fff;height:550px;">
				    <div title=" 指  标 ">
    			       <div id="kpiTool_" class="pt40">
				    	 <div class="kpiSearchArea">
					      		<span>
							    	<a class="RankText" href="javascript:void(0);" onclick="letterListBtnClick_()">A~Z</a>
							    	<a class="rankBtn" href="javascript:void(0);" sortType="asc" id="dimSortBtn_" title="A~Z正序" onclick="sortBtnClick_()">↑</a>
						    	</span>
						     	<input class="inputBox" type="text" class="fromOne"  id="dimKeywords_"/>
						    	<a class="inputBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="queryBtnClick_()">查询</a>
						    	<a class="foldBtn" href="javascript:void(0)" state="closed" title="折叠指标组">折叠指标组</a>
						  </div> 
						  <div id="kpiLetterListDiv_" class="kpiBoxArea">
							    <ul class="letterList"></ul>
							    <a href="javascript:void(0)" onclick="removeLetterBtnClick_()" title="取消索引">取消索引</a>
					      </div>
					      <div id="kpiList_">
					      	 	<div class='category_header'><span>︾</span><em>移动->发展类</em></div>
					      		<div class='category_body'><ul>
					      			<li class="jichu">通话次数</li>
					      		</ul>
					      		</div>
					      </div>
					    </div>
					</div>
				    <div title=" 维  度 ">
				        <div id="dimTool_" class="pt40">
				    	<div class="kpiSearchArea">
					      		<span>
							    	<a class="RankText" href="javascript:void(0);" onclick="letterListBtnClick_()">A~Z</a>
							    	<a class="rankBtn" href="javascript:void(0);" sortType="asc" id="dimSortBtn_" title="A~Z正序" onclick="sortBtnClick_()">↑</a>
						    	</span>
						     	<input class="inputBox" type="text" class="fromOne"  id="dimKeywords_"/>
						    	<a class="inputBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="queryBtnClick_()">查询</a>
						  </div>
						  <div id="dimLetterListDiv_" class="kpiBoxArea hide">
							    <ul class="letterList"></ul>
							    <a href="javascript:void(0)" onclick="removeLetterBtnClick_()" title="取消索引">取消索引</a>
					      </div>
					      <div id="dimList_" class="category_body"></div>
					      </div>
				    </div>
				    <div title=" 属  性 ">
				         <div id="kpiTool_" class="pt40">
				    	 <div class="kpiSearchArea">
					      		<span>
							    	<a class="RankText" href="javascript:void(0);" onclick="letterListBtnClick_()">A~Z</a>
							    	<a class="rankBtn" href="javascript:void(0);" sortType="asc" id="dimSortBtn_" title="A~Z正序" onclick="sortBtnClick_()">↑</a>
						    	</span>
						     	<input class="inputBox" type="text" class="fromOne"  id="dimKeywords_"/>
						    	<a class="inputBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="queryBtnClick_()">查询</a>
						  </div>
						  <div id="attrLetterListDiv_" class="kpiBoxArea hide">
							    <ul class="letterList"></ul>
							    <a href="javascript:void(0)" onclick="removeLetterBtnClick_()" title="取消索引">取消索引</a>
					      </div>
					      <div id="propertyList_" class="category_body">
					      </div>
					      </div>
				    </div>
			    </div>
			</div> 
			</div>
	        <div data-options="region:'center'">
			  	<div id="kpi">11111</div>	        
	        </div>
  	</body>
</html>
