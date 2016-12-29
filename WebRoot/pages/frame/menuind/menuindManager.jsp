<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<base href="<%=basePath%>">
		<title>菜单</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<c:resources type="easyui"  style="${ThemeStyle }"/>
		<e:style value="/resources/themes/base/boncBase@links.css"/>
	<script>
		var currentLevel=1;
		var extendLevel=2;//树初始展开级数
		$(window).resize(function(){
		 	$('#index').treegrid('resize');
		 });
		 
		function myFormatt(value){
			return '<span style="color:#024d9f; font-weight:bold;">'+value+'</span>';
		}
		
		function myFormatter(value,rowData){
			var page_id = rowData.id;
			return '<form id="indLink" method="post"><a id="oper" href="javascript:void(0)" style="text-decoration:none;" onclick="indOper(\''+page_id+'\')">'+value+'</a></form>';             
		}
		
		function indOper(value){
			var $form = $("#indLink");
			$form.attr("action","<e:url value='/pages/frame/menuind/menuindOper.jsp?' />"+"page_id="+value);
			$form.submit();
		}
		function expandNode(row){
			var treeOnlyExpandOneNode='${treeOnlyExpandOneNode}';
   			if(treeOnlyExpandOneNode!='0'){
		   		var parentNode=$(this).treegrid('getParent',row.RESOURCES_ID);
		   		var childrenNode=null;
		   		if(parentNode!=null){
		   			childrenNode=$(this).treegrid('getChildren',parentNode.RESOURCES_ID);
		   		}else{
		   			childrenNode=$(this).treegrid('getRoots',row.RESOURCES_ID);
		   		}
		   		
		   		
		   		if(childrenNode!=null){
		   			for(var i=0;i<childrenNode.length;i++){
		   				if(childrenNode[i].RESOURCES_ID!=row.RESOURCES_ID){
		   					
		   					$(this).treegrid('collapse',childrenNode[i].RESOURCES_ID);
		   				}
		   			}
		   		}
	   		}
	   	}
	   	
	   	function clickCell(field,row){
	   		if(field=='name'){
	   			var isleaf = $(this).treegrid('isLeaf',row.id);
				if(!isleaf){
					$(this).treegrid('toggle',row.id);     //当是目录的时候 弹出叶子节点
				}
	   		}
	   	}
	   	
	    function loadNodeSuccess(row, data){
	   		var rootNodes=$(this).treegrid("getRoots");
	   		$(this).treegrid("expand",rootNodes[0].id);
	   		
	   	}
	</script>
</head>
<body>
		<div class="contents-head" id="tb">
  			<h2>发布指标解释</h2>
  		</div>
		<table id="index" class="easyui-treegrid" width="100%" url="<e:url value="/pages/frame/menuind/menuindAction.jsp?eaction=MENUSELECT"/>" idField="id" border="false" treeField="name"
			pagination="false" fitColumns="true" title="" data-options="onExpand:expandNode,onClickCell:clickCell,onLoadSuccess:loadNodeSuccess">
		<thead>
			<tr>
				<th field="name" width="40%" editor="text">页面名称</th>
				<th field="url" width="30%" editor="text">页面链接</th>
				<th field="oper" width="30%" editor="text"  formatter="myFormatter" align="center" valign="middle">页面操作</th>
			</tr>
		</thead>
	</table>
</body>
</html>