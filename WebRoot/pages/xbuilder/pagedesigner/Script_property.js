/*向切换容器中添加组件*/
function addComponentForSwitch(viewId,containerId,componentInfo,exitComponentNum,containerType){
	if(exitComponentNum==1){
		if($("#div_head_ul_"+containerId).size()>0){
			$("#div_head_ul_"+containerId).remove();
		}
		if(containerType=='2'){
			$("#div_head_"+containerId).append('<ul id="div_head_ul_'+containerId+'" ultype="r" class="tab-item-r"></ul>');
		}else if(containerType=='3'){
			$("#div_head_"+containerId).append('<ul id="div_head_ul_'+containerId+'" ultype="l" class="tab-item-l"></ul>');
			$("#div_head_title_"+containerId).hide();
		}
		cn.com.easy.xbuilder.service.XComponentService.getFirstComponent(viewId,containerId,
			function(data, exception) {
				if (exception != undefined) {
					$.messager.alert("提示信息！",exception,"error");
				} else {
					if (data == "0") {// 没有组件
						$.messager.alert("提示信息！","没有组件!","error");
					} else {// 有组件
						var firstComponentInfo=$.parseJSON(data);
						addSwitchForSwitch(viewId,containerId,firstComponentInfo,false);
						addSwitchForSwitch(viewId,containerId,componentInfo,true);
					}
				}
			}
		);
	}else{
		addSwitchForSwitch(viewId,containerId,componentInfo,true);
	}
		
	
}
function addSwitchForSwitch(viewId,containerId,componentInfo,operateXmlFlag){
	//alert("向容器中添加组件!");
	//alert($.toJSON(componentInfo));
	var existNum=$("#"+containerId+" li[name='"+componentInfo.compId+"']").size();
	if(existNum==0){
		if(operateXmlFlag){
			cn.com.easy.xbuilder.service.XComponentService.addComponentWithoutType(viewId,containerId,componentInfo,function(data, exception) {
				insertSwitchLiForSwitch(viewId,containerId,componentInfo);
				changeSwitchPage(viewId,containerId,componentInfo);
				if(componentInfo.createType=="new"){
					//appendToComponentTree();
					appendToComponent();
				}
			});
		}else{
			insertSwitchLiForSwitch(viewId,containerId,componentInfo);
			changeSwitchPage(viewId,containerId,componentInfo);
		}
	}else{
		changeSwitchPage(viewId,containerId,componentInfo);
	}
	
	
}

function insertSwitchLiForSwitch(viewId,containerId,componentInfo){
	
	var titleHtml='<li id="div_head_li_'+containerId+'_'+componentInfo.id+'" name="'+componentInfo.compId+'"><a id="div_head_li_'+containerId+'_'+componentInfo.id+'_value" href="javascript:void(0)" onclick="changeSwitchPageWhenATag(';
	titleHtml=titleHtml+"'"+viewId+"','"+containerId+"','"+componentInfo.id+"','"+componentInfo.compId+"','"+componentInfo.url+"','"+componentInfo.title+"','"+componentInfo.type+"','"+componentInfo.parentId+"','"+componentInfo.state+"','"+componentInfo.img+"','"+componentInfo.propertyUrl+"'";
	titleHtml=titleHtml+');return false;">';
	titleHtml=titleHtml+componentInfo.title+'</a></li>';
	$("#div_head_ul_"+containerId).append(titleHtml);
	LayOutUtil.setLHtml($("#selectable_layout_id001").html());
	  	$("#div_head_li_"+containerId+"_"+componentInfo.id+"_value").addClass('active');
	  	$("#div_head_li_"+containerId+"_"+componentInfo.id+"_value").parent().siblings("li").find("a").removeClass("active");
		$('.tab-item-r li').click(function(){
			$(this).find("a").addClass('active');
			$(this).siblings("li").find("a").removeClass('active');
		})
}


/*加切换页(点切换容器下标题时用到)*/
function changeSwitchPage(viewId,containerId,componentInfo){
	curComp=componentInfo;
	var id=componentInfo.id;
	var compId=componentInfo.compId;
	var url=componentInfo.url;
	var title=componentInfo.title;
	var type=componentInfo.type;
	var parentId=componentInfo.parentId;
	var state=componentInfo.state;
	var img=componentInfo.img;
	var propertyUrl=componentInfo.propertyUrl;
	var divHeadLi=$('#div_head_li_'+containerId+'_'+id);
	if(divHeadLi.parent().attr("ultype")=='r'){//切换
		$('#div_head_li_'+containerId+'_'+id).addClass("selected-tab-r").attr("selectLi","true").siblings("li").removeClass("selected-tab-r").removeAttr("selectLi");
	}else if(divHeadLi.parent().attr("ultype")=='l'){//选项卡
		$('#div_head_li_'+containerId+'_'+id).attr("selectLi","true").find("a").addClass("selected-tab-l").parent().siblings("li").removeAttr("selectLi").find("a").removeClass("selected-tab-l");
	}
	
	$('#div_body_'+containerId).html("");
	var tempUrl=null;
	if(typeof(compFileDir) != "undefined"){//compFileDir
		if(type=='CROSSTABLE'){
			tempUrl=appBase+"/crossDataJson.e?TitleType="+compFileDir+"&reportId="+viewId+"&containerId="+containerId+"&componentId="+id+(typeof(queryParamsStr) == "undefined"?"":"&"+queryParamsStr.substring(1));
		}else{
			tempUrl=appBase+"/pages/xbuilder/usepage/"+compFileDir+"/"+viewId+"/comp_"+id+".jsp"+"?componentId="+id+"&containerId="+containerId+(typeof(queryParamsStr) == "undefined"?"":"&"+queryParamsStr.substring(1));
		}
		$('#div_body_'+containerId).load(tempUrl,function(data){
			$.parser.parse($("#div_body_" + containerId));
		});
		return;
	}
	if(url.indexOf("pages/xbuilder/component")>2){
		url=url.substring(url.indexOf("pages/xbuilder/component"));
	}
	tempUrl=url;
	$("#xDesignerLayout").attr("data-containerid",containerId);
	$("#xDesignerLayout").attr("data-componentid",id);
	
	
	$('#div_body_'+containerId).load(appBase+"/"+strJoiner(tempUrl)+"reportId="+LayOutUtil.data.xid+"&componentId="+id+"&containerId="+containerId,function(data){
		$.parser.parse($("#div_body_" + containerId));
		LayOutUtil.setComponent(containerId,id);
		LayOutUtil.componentEdit(containerId);
	});
	
}

function changeSwitchPageWhenATag(viewId,containerId,componetId,compId,url,title,type,parentId,state,img,propertyUrl){
	$("input:focus").blur();
	var componentInfo={};
	componentInfo.id=componetId;
	compId=componentInfo.compId;
	componentInfo.url=url;
	componentInfo.title=title;
	componentInfo.type=type;
	componentInfo.parentId=parentId;
	componentInfo.state=state;
	componentInfo.img=img;
	componentInfo.propertyUrl=propertyUrl;
	changeSwitchPage(viewId,containerId,componentInfo)
}

function synTitleToOther(containerId,componentId,title){
	if($('#div_head_li_'+containerId+'_'+componentId+'_value').size()>0){
		$('#div_head_li_'+containerId+'_'+componentId+'_value').html(title);//修改tab页（切换、选项卡）上的显示名称
	}
	updateNodeName(componentId,title);//修改组件树上组件的名称
	
	
}
function strJoiner(url){
	url += url.lastIndexOf('?')>-1?'&':'?';
	return url;
}

$(function(){
	$('.tab-item-r li').eq(0).find("a").addClass('active');
	$('.tab-item-r li').click(function(){
		$(this).find("a").addClass('active');
		$(this).siblings("li").find("a").removeClass('active');
	})
})