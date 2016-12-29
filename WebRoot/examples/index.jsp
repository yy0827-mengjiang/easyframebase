<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>例子主页</title>
    <c:resources type="easyui" style="b"></c:resources>
  	<script>
  		var lastHeight=0;
  		var stepSize=0;
  		var goUpCount=0;
  		var goUpSize=0;
  		function openUrl(url){
  			lastHeight=0;
	  		stepSize=0;
			goUpCount=0;
  			$("#pageIframe").attr("src",url);
  		}
  		
		function reinitIframe(){
			var iframe = document.getElementById("pageIframe");
			try{
			var bHeight = iframe.contentWindow.document.body.scrollHeight;
			if((bHeight-lastHeight)==stepSize&&goUpSize==stepSize){
				goUpCount=goUpCount+1;
				if(goUpCount>2){
					//alert(1);
					return false;
				}
			}else{
				goUpSize=stepSize;
				goUpCount=0;
			}
			stepSize=bHeight-lastHeight;
			lastHeight=bHeight;
			$("#bodyEle").css("height",(bHeight+100));
			$("#iframeDiv").css("height",(bHeight+50));
			
		}catch (ex){}
		
		}
	</script>
    <e:style value="resources/themes/base/boncBase@links.css"/>
	<e:style value="resources/themes/blue/boncBlue.css"/>
	</head>
	<body id="bodyEle">
	<table id="indexTable" class="layout-grid" width="100%">
		<tr>
			<td class="left-nav" style="width:170px" valign="top">
				<dl class="demoMav" id="mydiv">
					<dt>c标签</dt>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/datagrid/datagrid.jsp"/>')">晋通表格</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/treegrid/t1.jsp"/>')">下钻表格</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/datebox/dateboxManager.jsp"/>')">日账期</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/month/monthManager.jsp"/>')">月账期（单选）</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/month/nmonthManager.jsp"/>')">月账期（复选）</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/drillsubgrid/drillsubgrid.jsp"/>')">下钻子表格</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/bar/nbar.jsp"/>')">条形图</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/column/ncolumn.jsp"/>')">柱形图</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/columnLine/ncolumnline.jsp"/>')">柱线组合图</a></dd>
						
						<dd><a href="#" onclick="openUrl('<e:url value="examples/line/nline.jsp"/>')">线形图</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/pie/npie.jsp"/>')">饼形图</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/point/point.jsp"/>')">散点图</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/pie/ndonutpie.jsp"/>')">父子双维度饼形图</a></dd>
						
						<dd><a href="#" onclick="openUrl('<e:url value="examples/rotate/t1.jsp"/>')">旋转组件</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/rotate/nrotate.jsp"/>')">新旋转组件</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/speedMeter/speedmeter.jsp"/>')">仪表盘组件</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/combinechart/combinechart.jsp"/>')">图表组合组件</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/scatter/scatter.jsp"/>')">多维散点图</a></dd>
						
						<dt>e标签</dt>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/function/sql.jsp"/>')">sql标签</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/function/json.jsp"/>')">json函数</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/function/split.jsp"/>')">split函数</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/function/join.jsp"/>')">join函数</a></dd>
						
						
						<dd><a href="#" onclick="openUrl('<e:url value="examples/function/function.jsp"/>')">其他函数</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/fileUploard/upload.jsp"/>')">copy标签</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/ls/ls.jsp"/>')">ls标签</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/set/set.jsp"/>')">变量存储</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/ejudge/judge.jsp"/>')">判断语法</a></dd>
						<dd><a href="#" onclick="openUrl('<e:url value="examples/forEach/ForEach.jsp"/>')">循环语法</a></dd>
						
				</dl>
			</td>
			<td class="normal">
				<div id="iframeDiv">
					<iframe id="pageIframe" name="pageIframe" src="datagrid/datagrid.jsp" width="100%" height="1000px" frameBorder="0" ></iframe>
				</div>
	
			</td>
		</tr>
	</table>
	</body>
</html>
