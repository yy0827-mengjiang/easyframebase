<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>SQL DEVELOPER</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
    <e:style value="/pages/kpi/jOrgChart/css/styles.css"/>
    <e:style value="/pages/kpi/jOrgChart/css/icheck.css"/>
    <e:script value="/pages/kpi/jOrgChart/jquery.min.js"/>
    <e:script value="/pages/kpi/jOrgChart/jquery.easyui.min.js"/>
    <e:script value="/pages/kpi/jOrgChart/icheck.min.js"/>
    <e:script value="/pages/kpi/jOrgChart/jquery_format.js"/>
    <script type="text/javascript">
    $(function(){
        $('#tt3').tabs({
                   
        });
    });
    
    function toUpper(){
    	var index = $('#tt3').tabs('getTabIndex',$('#tt3').tabs('getSelected'));
    	var txt = $("#textarea"+index).val();
    	$("#textarea"+index).val("");
    	$("#textarea"+index).val(txt.toUpperCase());
    }
    
    function toLower(){
    	var index = $('#tt3').tabs('getTabIndex',$('#tt3').tabs('getSelected'));
    	var txt = $("#textarea"+index).val();
    	$("#textarea"+index).val("");
    	$("#textarea"+index).val(txt.toLowerCase() );
    }
    
    
    function formatSql(){
    	var index = $('#tt3').tabs('getTabIndex',$('#tt3').tabs('getSelected'));
    	$("#textarea"+index).format({
    		method: 'sql'
    	});
    }
    
    function addTNotes(){
    	var index = $('#tt3').tabs('getTabIndex',$('#tt3').tabs('getSelected'));
    	var txt = $("#textarea"+index).val();
    	$("#textarea"+index).val("");
    	$("#textarea"+index).val("/*"+txt+"*/");
    }
    </script>
  </head>
  <body class="easyui-layout">
	<div data-options="region:'north',border:false" style="height:70px;background:#2b579a;padding:14px 0 0 14px;">
		<ul class="ul-head">
			<li class="toolicon06"><a href="javascript:void(0)">新建</a></li>
			<li class="toolicon07"><a href="javascript:void(0)">打开</a></li>
			<li class="toolicon01"><a href="javascript:void(0)">保存</a></li>
			<li class="toolicon02"><a href="javascript:void(0)">执行</a></li>
			<li class="toolicon03"><a href="javascript:void(0);" onclick="toUpper()">转大写</a></li>
			<li class="toolicon04"><a href="javascript:void(0);" onclick="toLower()">转小写</a></li>
			<li class="toolicon05"><a href="javascript:void(0);" onclick="formatSql()">美化器</a></li>
			<li class="toolicon08"><a href="javascript:void(0);" onclick="addTNotes()">注释</a></li>
			<li class="toolicon09"><a href="javascript:void(0)">取消注释</a></li>
		</ul>
	</div>
	<!-- 左侧树 -->
	<div data-options="region:'west',split:true" style="width:200px;padding:10px;">
		<p class="title-left">My objects</p>
		<div id="tt">
			<ul class="easyui-tree">
				<li>
					<span>资源库</span>
					<ul>
						<li>
							<span>192.168.199.175</span>
							<ul>
								<li><span>X_KPI_CATEGORY</span>
										<ul>
											<li>
												<span>KPI_KEY</span>
											</li>
											<li>
												<span>KPI_CODE</span>
											</li>
											<li>
												<span>KPI_NAME</span>
											</li>
											<li>
												<span>KPI_CATEGORY</span>
											</li>
											<li>
												<span>KPI_UNIT</span>
											</li>
											<li>
												<span>KPI_VERSION</span>
											</li>
										</ul>
									</li>
								<li><span>X_KPI_INFO_TMP</span></li>
								<li><span>X_KPI_SOURCE_TMP</span></li>
							</ul>
						</li>
						<li>192.168.199.174</span></li>
						<li>192.168.199.173</span></li>
					</ul>
				</li>
			</ul> 
		</div>
	</div>
	
	
	<div data-options="region:'center',border:'true'" style="padding:10px;">
		<div id="tt3" style="width:98% !important;height:200px;">
			<div title="SQL" style="padding:10px 0;">
				<textarea class="textarea" id="textarea0"></textarea>
			</div>
			<div title="输出" style="padding:10px 0;" cache="false">
				<textarea class="textarea" id="textarea1"></textarea>
			</div>
			<div title="统计表" style="padding:10px 0;">
				<textarea class="textarea" id="textarea2"></textarea>
			</div>
		</div>
		
		<div class="component-area">
			<div class="component-head">
				<h3><span>基础表格</span></h3> 
			</div>
			<!-- 表格 -->

			 <table class="easyui-datagrid">   
				<thead>   
					<tr>   
						<th data-options="field:'code'">编码</th>   
						<th data-options="field:'name'">名称</th>   
						<th data-options="field:'price'">价格</th>   
					</tr>   
				</thead>   
				<tbody>   
					<tr>   
						<td>001</td><td>name1</td><td>2323</td>   
					</tr>   
					<tr>   
						<td>002</td><td>name2</td><td>4612</td>   
					</tr>   
				</tbody>   
			</table>  
		</div>
	</div>
</body>
</html>
