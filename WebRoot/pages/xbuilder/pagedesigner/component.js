var curComp;//当前点击的组件
var compClass = {
		"DATAGRID":"tIco01",
		"TREEGRID":"tIco02",
		"CROSSTABLE":"tIco03",
		"COLUMN":"tIco04",
		"COLUMN2":"tIco05",
		"COLUMN3":"tIco06",
		"LINE":"tIco07",
		"LINE2":"tIco08",
		"LINE3":"tIco09",
		"BAR":"tIco010",
		"BAR2":"tIco11",
		"BAR3":"tIco12",
		"PIE":"tIco13",
		"RING":"tIco14",
		"COLUMNLINE":"tIco15",
		"COLUMNLINE2":"tIco16",
		"COLUMNLINE3":"tIco17",
		"SCATTER":"tIco18",
};
/**
 * 选择组件替换类型确定
 */
function selReplaceType(replaceType){
	replaceComponent(StoreData.xid,StoreData.curContainerId,curComp,replaceType);
	closeDialog('conDialog2');
}

/**
 * 关闭弹出的对话框层
 */
function closeDialog(id){
	$("#"+id).fadeOut(300);
	$("#mask").fadeOut(300); 
}

/**
 * 弹出对话框层
 * @param divName
 */
function showDivCenter(divName){ 
	//var top = ($(window).height() - $("#"+divName).height())/2; 
	var left = ($(window).width() - $("#"+divName).width())/2; 
	//var scrollTop = $(document).scrollTop(); 
	var scrollLeft = $(document).scrollLeft(); 
	$("#"+divName).css( { position : 'fixed', 'top' : 250, left : left + scrollLeft } ).show();
	$("#mask").css("height",$(document).height());  
	$("#mask").css("width",$(document).width());  
	$("#mask").show();  
}

/**
 * 打开和关闭组件选择面板
 */
function showCompList() {
	if ($("#showCompLink").val() == "显示组件") {
		$("#compTreeDiv").show(100);
		$("#showCompLink").val("关闭组件");
	} else {
		$("#compTreeDiv").hide(100);
		$("#showCompLink").val("显示组件");
	}
} 

/**
 * 检查容器类型
 */
function checkContainer(id,text,type,url,propertyUrl,className) {
	var myDate = new Date();
	var comId = id+myDate.getTime();
	
	curComp={
				id:LayOutUtil.uuid(),
				compid:comId,
				title:text,
				url:url,
				type:type,
				propertyUrl:propertyUrl,
				createType:"new",
				viewId:StoreData.xid,
				className:className
			};
	StoreData.components[curComp.id] = $.extend({},curComp);
	StoreData.curComponentId=curComp.id;
	if (StoreData.curContainerId ==null||StoreData.curContainerId==undefined||StoreData.curContainerId=="") {
		$.messager.alert('提示信息','请先选择要添加组件的单元格！','info');
		return;
	}
	closeDialog("conDialog1");
	cn.com.easy.xbuilder.service.XComponentService.getContainerAllInfoById(StoreData.xid,StoreData.curContainerId,curComp.id,false,getContainerSuccess);
}

/**
 * 检查容器类型回调
 * @param data
 * @param exception
 */
function getContainerSuccess(data,exception){
	if(data == '1'){
		$.messager.alert('提示信息','报表中已存在该组件,不能重复添加','error');
		return;
	}
	var container=$.parseJSON(data);
	 if(container.type==""){
		 cn.com.easy.xbuilder.service.XComponentService.setContainerType(StoreData.xid,StoreData.curContainerId,"1",function(data,exception){
				if (exception != undefined) {
					$.messager.alert("提示信息！",exception,"error");
				}else{
					addComponent(StoreData.xid, StoreData.curContainerId,curComp,false);
				}
		 });
	  }else if(container.type=="1"){
	     if(container.pop==""){
	    	 openSelTypeDialog(StoreData.xid,StoreData.curContainerId,curComp.id,"conDialog1");
	     }else{
	    	 openSelTypeDialog(StoreData.xid,StoreData.curContainerId,curComp.id,"conDialog2");
	     }
	 }else if(container.type=="2"||container.type=="3"){
		 cn.com.easy.xbuilder.service.XComponentService.checkComponentExist(StoreData.xid,StoreData.curContainerId,curComp.id,function(data,exception){
				if (exception != undefined) {
					$.messager.alert("提示信息！",exception,"error");
				}else{
					if(data=="yes"){
						$.messager.alert('提示信息','容器中已存在该组件,不能重复添加','error');
					}else{
						var componentInfo=curComp;
						componentInfo.compId=curComp.compid;
						addComponentForSwitch(StoreData.xid,StoreData.curContainerId,componentInfo,2,container.type);
					}
				}
			});
		    
	 }
}

/**
 * 打开容器类型选择对话框，打开前先判断容器中有无相同组件，有就不打开
 * @param viewId
 * @param containerId
 * @param compid
 * @param dialogId
 */
function openSelTypeDialog(viewId,containerId,componentId,dialogId){
	cn.com.easy.xbuilder.service.XComponentService.checkComponentExist(viewId,containerId,componentId,function(data,exception){
		if (exception != undefined) {
			$.messager.alert("提示信息！",exception,"error");
		}else{
			if(data=="yes"){
				$.messager.alert("提示信息！","容器中已存在该组件,不能重复添加！","error");
			}else{
				showDivCenter(dialogId);
			}
		}
	});
}
/**
 * 设置容器类型
 */
function setContainerType(viewId,containerId,containerType){
	cn.com.easy.xbuilder.service.XComponentService.setContainerType(viewId,containerId,containerType,function(data,exception){
		if (exception != undefined) {
			$.messager.alert("提示信息！",exception,"error");
		} 
	});
}
/**
 * 添加组件
 */
function addComponent(viewId, containerId, component,isPop) {
		
		cn.com.easy.xbuilder.service.XComponentService.addComponent(viewId,containerId,component,isPop,
				function(data, exception) {
						if (exception != undefined) {
							$.messager.alert("提示信息！",exception,"error");
						} else {
							if(isPop){
								var popInfo="<span id='popup_"+component.id+"' data-titile='"+component.title+"' onclick=\"popup('"+component.url+"','"+containerId+"','"+component.id+"','"+component.propertyUrl+"','"+viewId+"','"+component.type+"')\" class='pop-links'>"+component.title+"</span>";
								$("#div_head_" + containerId).html($("#div_head_title_" + containerId).prop("outerHTML")+popInfo);
							}else{
								$("#div_head_title_" + containerId).html("<span onclick=\"LayOutUtil.openEditePropertyView('"+StoreData.curContainerId+"');return false;\">"+component.title+"</span>");
								var linkSymbol = component.url.indexOf("?")==-1?"?":"&";
								$("#div_body_" + containerId).load(appBase+"/"+component.url+linkSymbol+"reportId="+StoreData.xid+"&componentId="+component.id+"&containerId="+containerId,function(){
									$.parser.parse($("#div_body_" + containerId));
									LayOutUtil.setComponent(containerId,component.id);
									LayOutUtil.componentEdit(containerId);
								});
							}
							LayOutUtil.setLHtml($("#selectable_layout_id001").html());
							//新建组件时，添加到组件树
							if(curComp.createType=="new"){
								appendToComponent();
							}
						}
				});
}

/**
 * 替换组件
 * replaceType:0替换基础组件，1替换弹出组件
 */
function replaceComponent(viewId,containerId,component,replaceType){
	
				cn.com.easy.xbuilder.service.XComponentService.replaceComponent(viewId,containerId,component,replaceType,
						function(data, exception) {
							if (exception != undefined) {
								$.messager.alert("提示信息！",exception,"error");
							} else {
								var linkSymbol = component.url.indexOf("?")==-1?"?":"&";
								var fullUrl = appBase+"/"+component.url+linkSymbol+"reportId="+StoreData.xid+"&componentId="+component.id+"&containerId="+containerId;								
								if(replaceType=="0"){//替换基础组件时，更新容器标题和组件
									$("#div_head_title_" + containerId).html("<span onclick=\"LayOutUtil.openEditePropertyView('"+StoreData.curContainerId+"');return false;\">"+component.title+"</span>");
									$("#div_body_" + containerId).load(fullUrl,function(){
										$.parser.parse($("#div_body_" + containerId));
										LayOutUtil.setComponent(containerId,component.id);
										LayOutUtil.componentEdit(containerId);
									});
								}else{
									var popInfo="<span id='popup_"+component.id+"' data-titile='"+component.title+"' onclick=\"popup('"+component.url+"','"+containerId+"','"+component.id+"','"+component.propertyUrl+"','"+viewId+"','"+component.type+"')\" class='pop-links'>"+component.title+"</span>";
									$("#div_head_" + containerId).html($("#div_head_title_" + containerId).prop("outerHTML")+popInfo);
								}
								LayOutUtil.setLHtml($("#selectable_layout_id001").html());
								//新建组件时，添加到组件树
								if(curComp.createType=="new"){
									appendToComponent();
								}
							}
						});
}

/**
 * 向已包含组件的容器中添加组件
 * fillType添加类型，0：替换，1、弹出、2：切换，3：选项卡
 */
function fillContainer(fillType){
	//替换基础组件
	if(fillType=="0"){
		cn.com.easy.xbuilder.service.XComponentService.setContainerType(StoreData.xid,StoreData.curContainerId,"1",function(data,exception){
			if (exception != undefined) {
				$.messager.alert("提示信息！",exception,"error");
			}else{
				replaceComponent(StoreData.xid,StoreData.curContainerId,curComp,"0");
			}
		});
	}
	//添加弹出组件
	if(fillType=="1"){
		cn.com.easy.xbuilder.service.XComponentService.setContainerType(StoreData.xid,StoreData.curContainerId,"1",function(data,exception){
			if (exception != undefined) {
				$.messager.alert("提示信息！",exception,"error");
			}else{
				addComponent(StoreData.xid,StoreData.curContainerId,curComp,true);
			}
		});
	}
    if(fillType=="2"||fillType=="3"){
    	cn.com.easy.xbuilder.service.XComponentService.checkComponentExist(StoreData.xid,StoreData.curContainerId,curComp.id,function(data,exception){
    		if (exception != undefined) {
    			$.messager.alert("提示信息！",exception,"error");
    		}else{
    			if(data=="yes"){
    				$.messager.alert("提示信息！","容器中已存在该组件,不能重复添加！","error");
    			}else{
    				var componentInfo=curComp;
					componentInfo.compId=curComp.compid;
    				cn.com.easy.xbuilder.service.XComponentService.setContainerType(StoreData.xid,StoreData.curContainerId,fillType,function(data,exception){
    					if (exception != undefined) {
    						$.messager.alert("提示信息！",exception,"error");
    					}else{
    						addComponentForSwitch(StoreData.xid,StoreData.curContainerId,componentInfo,1,fillType);
    					}
    				});
    			}
    		}
    	});
	}
	closeDialog("conDialog1");
}
function closeCompTree(){
	$("#compTreeDiv").hide(100);
}

function showPropertyPage(containerId,componentId,properyUrl){
    $("#propertiesPage").empty();
    setProPageTitle("组件属性设置");
    $("#tools_panel").css("width","380px");
    var linkSymbol = properyUrl.indexOf("?")==-1?"?":"&";
	$("#propertiesPage").load(appBase+"/"+properyUrl+linkSymbol+"report_id="+StoreData.xid+"&t="+(new Date().getTime()),function(){
		$.parser.parse($("#propertiesPage"));
		if($('#comp_'+componentId).attr("data-fun_edit") !=undefined){
		 	window[$('#comp_'+componentId).attr("data-fun_edit")](containerId,componentId);
		}
		toolsPanel();//显示属性
		toolsAddHideEvent();//属性文件中添加隐藏事件（类似手风琴）
		if(window["tableHideColSelectorWin"]!=undefined){
			tableHideColSelectorWin();//指标库类型时，关闭指标列表窗口
		}
		
	});
}

function toolsAddHideEvent(){
	$(".propertiesPane h4").click(function(){
    	$(this).next("div.ppInterArea").slideToggle("fast");
    	$(this).toggleClass("ot");
    })
}
function hidePropertyPage(){
	$("#xDesignerLayout").layout("collapse","south");
}


/**
 * 删除单个组件，组件树上右键删除组件时调用
 * @param viewId
 * @param containerId
 * @param componentId
 */
function removeSingleComponent(viewId,componentId){
	cn.com.easy.xbuilder.service.XComponentService.removeComponent(StoreData.xid,componentId,function(data,exception){
	   	 var containerType = data.containerType;
	     var containerId = data.containerId;
	     var isPop = data.isPop;
	     var firstComponent = data.firstComponent;
	     if(parseInt(data.componentListSize)==0){
	    	 $("#div_body_" + containerId).empty();
			 $("#div_head_title_" + containerId).html("标题[未命名]");
			 $("#div_head_" + containerId).html($("#div_head_title_" + containerId).prop("outerHTML"));
			 $("#div_head_title_" + containerId).show();
		 }
		 if(containerType=="1"){
			 if(isPop=="true"){
				 $("#div_head_" + containerId).find("span").remove();
			 }
		 }else if((containerType=="2"||containerType=="3")&&parseInt(data.componentListSize)>0){
			 $("#div_head_li_"+containerId+'_'+componentId).remove();
			 if(firstComponent!=null){
				 changeSwitchPage(viewId,containerId,firstComponent);
			 }
		 }
		 LayOutUtil.setLHtml($("#selectable_layout_id001").html());
	});
}
/**
 * 添加使用的组件
 */
function appendToComponent() {
	var component_tab = $("#component_tab").html();
	$("#component_tab").html(component_tab + compontentHtmL());
	$("#component_tab>li").each(function(index,item) {
		$(item).find("a").eq(0).click(appendComponentToContainer);
	});
}
/**
 * 生成组件的HTML元素
 * @returns {String}
 */
function compontentHtmL() {
	var tmpComp = "<li id=\"cacheComment"+curComp.id+"\" class=\""+ curComp.className +" \"><a href=\"javascript:void(0);\"><span id=\""+ curComp.id +"\"";
	tmpComp += "title=\""+ curComp.title +"\"";
	tmpComp += "url=\""+ curComp.url +"\"";
	tmpComp += "propertyUrl=\""+ curComp.propertyUrl +"\"";
	tmpComp += "type=\""+ curComp.type +"\"";
	tmpComp += "curClass=\""+ curComp.className +"\"";
	tmpComp += "compid=\""+ curComp.compid +"\">";
	tmpComp +=  curComp.title +"</span></a>";
	tmpComp += "<a class=\"icoclose\" href=\"javascript:void(0);\" title=\"删除\" onclick=\"removeCacheComment('"+curComp.id+"')\">删除</a></li>";
	return tmpComp;
}
function removeCacheComment(componentId){
	if($("#comp_"+componentId).size()>0){
		$.messager.alert('提示信息','组件中已使用本组件，不可删除！','info');
		return false;
	}
	$.messager.confirm('确认信息', '删除组件后将不可找回，是否继续?', function(r){
		if (r){
			$("#cacheComment"+componentId).remove();
			cn.com.easy.xbuilder.service.XComponentService.removeCacheComment(StoreData.xid,componentId,function(data,exception){
				if($.trim(data)=='1'){
					$.messager.alert('提示信息','删除组件成功！','info');
				}else{
					$.messager.alert('提示信息','删除组件失败！','error');
				}
			});
		}
	});
}
/**
 * 添加组件到容器中
 */
function appendComponentToContainer() {
	var node = $(this).find("span").eq(0);
	if (StoreData.curContainerId !=null&&StoreData.curContainerId!=undefined&&StoreData.curContainerId!="") {
		curComp={
				id:node.attr("id"),
				title:node.attr("title"),
				url:node.attr("url"),
				type:node.attr("type"),
				propertyUrl:node.attr("propertyUrl"),
				compid:node.attr("compid"),
				createType:"restore",
				className:node.attr("curClass"),
				viewId:StoreData.xid
		};
		StoreData.components[curComp.id] = $.extend({},curComp);
		StoreData.curComponentId=curComp.id;		
		cn.com.easy.xbuilder.service.XComponentService.getContainerAllInfoById(StoreData.xid,StoreData.curContainerId,curComp.id,true,getContainerSuccess);
		closeDialog("conDialog1");
	}
}

/**
 * 删除组件树上的节点,同时删除布局上的相应组件
 * @param item
 */
function removeCompTreeNode(item){
	if(item.id!=null&&item.id!=undefined){
		if(item.id=='rm_div'){
			var node = $('#comp_tree').tree('getSelected');
			$('#comp_tree').tree('remove',node.target);
			removeSingleComponent(StoreData.xid,node.id);
			//layoutXml();
		}
	}
}

/**
 * 修改节点名称(各组件设置组件标题文本框onblur事件时调用)
 * @param comp_id
 * @param comp_title
 */
function updateNodeName(comp_id,comp_title){
	LayOutUtil.setLHtml($("#selectable_layout_id001").html());
	$("#component_tab>li").each(function(index,item) {
		if($(item).find("span").eq(0).attr("id") == comp_id) {
			$(item).find("span").eq(0).attr("title",comp_title);
			$(item).find("span").eq(0).html(comp_title);
		}
	});
}

/**
 * 删除组件树节点(组件编辑区注销组件时调用)
 * @param comp_id
 */
function removeCompNode(comp_id){
	var node=$('#comp_tree').tree('find',comp_id);
	$('#comp_tree').tree('remove',node.target);
}

function popup(url,containerId,componentId,propertyUrl,viewId,type){
	if(url.indexOf("pages/xbuilder/component")>2){
		url=url.substring(url.indexOf("pages/xbuilder/component"));
	}
	var title=$("#popup_"+componentId).attr("data-titile");
	var linkSymbol = propertyUrl.indexOf("?")==-1?"?":"&";
	$("#popdiv").window({title: title,height:500,width:800, modal:false}).window("open").window("center");
	$('#popdiv').load(appBase+"/"+url+linkSymbol+"reportId="+viewId+"&componentId="+componentId+"&containerId="+containerId+"&ispop=true",null,function(){
		LayOutUtil.setComponent(containerId,componentId);
		LayOutUtil.componentEdit(containerId);
		var tempName = url.split('/');
		$("#"+tempName[tempName.length-2]+"_panel_"+componentId).prepend("<div class=\"component-set2\"><ol><li class=\"icoComponentEditor\"><a href=\"javascript:void(0)\" onclick=\"LayOutUtil.componentEdit('"+containerId+"');return false;\" title=\"组件编辑\">组件编辑</a></li></ol></div>");
	});
		
		
}

//还原组件树
function initEditComponentData(){
		xbuilderEditService.getComponentList(StoreData.xid,function(data,exception){
			var component_tab = $("#component_tab").html();
			$.each(data,function(index,component){
				component_tab += compontentDataHtmL(component);
			});	
			$("#component_tab").html(component_tab);
			$("#component_tab>li").each(function(index,item) {
				$(item).find("a").eq(0).click(appendComponentToContainer);
			});
		});
}
/**
 * 生成组件的HTML元素
 * @returns {String}
 */
function compontentDataHtmL(component) {
	var tmpComp = "<li class=\""+ compClass[component.type] +" \"><a href=\"javascript:void(0);\"><span id=\""+ component.id +"\"";
	tmpComp += "title=\""+ component.title +"\"";
	tmpComp += "url=\""+ component.url +"\"";
	tmpComp += "propertyUrl=\""+ component.propertyUrl +"\"";
	tmpComp += "type=\""+ component.type +"\"";
	tmpComp += "curClass=\""+ compClass[component.type] +"\"";
	tmpComp += "compid=\""+ component.compid +"\">";
	tmpComp +=  component.title +"</span></a></li>";
	return tmpComp;
}