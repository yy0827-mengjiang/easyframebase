<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<script>
	var SelectedMenuId = '${param.SelectedMenuId}';
	var MenuExpandLvl = '${param.MenuExpandLvl}';
		$(function(){
			$('#LeftMenu').tree({
				checkbox: false,
				url:'pages/frame/portal/menu/menuAction.jsp?eaction=LoadLeftTree&pid='+SelectedMenuId,
				onClick:function(node){
					var url = node.attributes.url;
					if(url != null && url != '' && url != 'null'){
						//判断是否弹出
						if(node.attributes.menuType == '3'){
							if(url.indexOf("http://")==0)
							{
								window.open(url,"", 'width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)+', top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
							}else{
								window.open('<%=request.getContextPath()%>/'+url,"", 'width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)+', top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
							}
							
							return;
						}
						if(node.attributes.menuState=='1'){
							open1(node.id,node.text,'pages/frame/menu/menuDeveloping_sj.jsp');
						}else if(node.attributes.menuState=='2'){
							open1(node.id,node.text,'pages/frame/menu/menuDeveloping_cx.jsp');
						}else if(node.attributes.menuState=='3'){
							open1(node.id,node.text,node.attributes.url);
						}else{
							open1(node.id,node.text,node.attributes.url);
						}
						
					}else{
						var isleaf = $(this).tree('isLeaf',node.target);
						if(!isleaf){
							$(this).tree('toggle',node.target);
						}
					}
				},
				onExpand:function(node){
					var treeOnlyExpandOneNode='${treeOnlyExpandOneNode}';
   					if(treeOnlyExpandOneNode!='0'){
						var parentNode=$(this).tree('getParent',node.target);
						var childrenNode=null;
						if(parentNode!=null){
							childrenNode=$(this).tree('getChildren',parentNode.target);
						}else{
							childrenNode=$(this).tree('getRoots',node.target);
						}
						if(childrenNode!=null){
							for(var i=0;i<childrenNode.length;i++){
								if(childrenNode[i].id!=node.id){
									$(this).tree('collapse',childrenNode[i].target);
								}
							}
						}
					}
				},
				onBeforeLoad: function(node, param){
					$(this).tree('options').url = 'pages/frame/portal/menu/menuAction.jsp?eaction=LoadLeftTree&pid='+SelectedMenuId;
				},
		        onLoadSuccess:function (node, data){
			        if(node == null || node == ''){
						var fnode = $('#LeftMenu').tree('find', extnote);
						if(fnode != null && fnode !=''){
							if(fnode.target != null && fnode.target !=''){
								if(MenuExpandLvl != null && MenuExpandLvl !='' && MenuExpandLvl =='1'){//是否打开全部菜单层级
									$('#LeftMenu').tree('expand', fnode.target);
								}else{
									$('#LeftMenu').tree('expandAll', fnode.target);
								}
							}
						}
			    	}else{
			    		if(MenuExpandLvl != null && MenuExpandLvl !='' && MenuExpandLvl =='1'){
							$('#LeftMenu').tree('expand', node.target);
						}else{
							$('#LeftMenu').tree('expandAll', node.target);
						}
			    	}
		    	}
			});
	})
</script>
<ul id="LeftMenu"></ul>