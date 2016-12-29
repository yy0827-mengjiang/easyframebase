var kpiTools = {
	currentItem:null,
	kpiExtMap:{},
	cubeId:null,
	currentTooltip:null,
	categoriesArr:['kpi','dim','property'],
	init:function(cubeId){//初始化页面UI和数据
		var categories = "";
//		cn.com.easy.xbuilder.service.KpiSelectorService.getDataFromKpiLibrary(cubeId,categories,function(data,exception){
//			$.each(kpiTools.categoriesArr,function(index,category){
//				if(categories.indexOf(category)!=-1){
//					kpiTools.generateHtml(category,data[category]);
//					//自动补全
//					var availableTags = new Array();
//					var arr = data[category];
//					if(category=="kpi"){
//						for(var i=0;i<arr.length;i++){
//							var kpiList = arr[i].children;
//							if(kpiList!=undefined){
//								for(var j=0;j<kpiList.length;j++){
//									availableTags.push({value:kpiList[j].desc,data:'1'});
//								}
//							}
//						}
//					}else{
//						var descVar = "mykpi" == category?"KPI_DESC":"desc";
//						for(var i=0;i<arr.length;i++){
//							availableTags.push({value:arr[i][descVar],data:'1'});
//						}
//					}
//				    $("#"+category+"Keywords_").autocomplete({
//				         lookup: availableTags,
//				         onSelect: function (suggestion) {}
//				    }); 
//				}else{
//					$("#tabs_").tabs('close', index); 
//				}
//			});
//			
//			/* $("#kpiList_>.category_body").hide();
//			$("#kpiList_>.category_header").find("span:eq(0)");
//			$("#kpiList_>.category_body").eq(0).show();
//			$("#kpiList_>.category_header").eq(0).find("span:eq(0)"); */
//		});
	},
	reload:function(){
		var categories = "";
		kpiSelectorService.reload(kpiTools.cubeId,categories,function(data,exception){
			$.each(kpiTools.categoriesArr,function(index,category){
				if(categories.indexOf(category)!=-1){
					kpiTools.generateHtml(category,data[category]);
				}else{
					$("#tabs_").tabs('close', index); 
				}
			});
		});
	},
	queryData:function(letter,keywords,queryType){//按字母或关键字的查询方法
		var category = kpiTools.getCurCategory();
		kpiSelectorService.queryData(kpiTools.cubeId,keywords,letter,queryType,category,function(data,exception){
			kpiTools.generateHtml(category,data);
		});
	},
	addFavorite:function(paramObj){//添加收藏
		kpiSelectorService.addFavorite(kpiTools.cubeId,paramObj,function(data,exception){
			if(data[0]=="0"){
				alert("收藏失败！");
			}else{
				kpiTools.generateHtml('mykpi',data[1]);
			}
		});
	},
	removeFavorite:function(itemId){//删除收藏
		kpiSelectorService.removeFavorite(kpiTools.cubeId,itemId,function(data,exception){
			if(data=="0"){
				alert("删除收藏失败！");
			}else{
				$("#myKpiList_").find("li[key='"+itemId+"']").eq(0).remove();
				$("#kpiList_ li[key='"+itemId+"']>a").removeClass("starLink_active");
				$("#kpiList_ li[key='"+itemId+"']>a").addClass("starLink_default");
			}
		});
	},
	getItemObj:function($li,tabType){//根据编号获得当前操作的指标、维度或属性
			tabType = tabType=='mykpi'?'kpi':tabType;
			kpiTools.currentItem={
					  id : $li.attr("key"),
					  column : $li.attr("column"),
					  desc : $li.attr("desc"),
					  kpiType:tabType,
					  category : $li.attr("category")
			};
		return kpiTools.currentItem;
	},
	getCurCategory:function(){//获得当前展示的类别名
		var tab = $('#tabs_').tabs('getSelected');
		var index = $('#tabs_').tabs('getTabIndex',tab);
		var category="";
		switch(index){
			case 0 : category = "kpi";break;
			case 1 : category = "dim";break;
			case 2 : category = "property";break;
			default:category = "kpi";
		}
		return category;
	},
	sort:function(sortType){//按字母顺序排序
		var category = kpiTools.getCurCategory();
		var letter = $("#"+category+"LetterListDiv_").find(".letterSelected > a").text();
		var keywords = $("#"+category+"Keywords_").val();
		kpiSelectorService.sort(kpiTools.cubeId,letter,keywords,category,sortType,function(data,exception){
			kpiTools.generateHtml(category,data);
		});
	},
	open:function(cubeId){//打开组件
		kpiTools.cubeId=cubeId;
		var $dialog = $('#container_');
	    if($dialog.css("display")=="none"){
	    	$dialog.css("position","absolute");
	    	$dialog.css("right",kpiTools.right+"px").css("top",kpiTools.top+"px");
			$dialog.show(100);
	    }
	    kpiTools.init(cubeId);
	},
	initDrag:function(){//初始化拖拽
		$("li[draggable='true']").draggable({
			proxy:function(source){
				var p = $('<div style="border:1px solid #999;padding:3px;background:#eee"></div>');
				p.html($(source).attr("desc")).appendTo('body');
				return p;
			},
			revert:true,
			cursor:'auto',
			onStartDrag: function () {
				kpiTools.currentItem=kpiTools.getItemObj($(this),kpiTools.getCurCategory());
	             $(this).draggable('options').cursor = 'not-allowed';
	             var proxy = $(this).draggable('proxy').css('z-index', 99999);
	             proxy.hide(); 
                 setTimeout(function () {
                     proxy.show();
                 }, 500);
	         },onStopDrag:function(e){
	        	 $(this).removeAttr("style");
	         }
		});
	},
	generateHtml:function(category,group){//根据传入的数据生成指标维度或属性的html代码
		var html = "";
		if(category=='kpi'){//生成指标html
			$.each(group,function(groupIndex,groupItem){
				var children = groupItem.children == null ? [] : groupItem.children;
				html+="<div class='category_header'><span>︾</span>"+"<em>"+groupItem.title+"</em>"+"</div>";
				html+="<div class='category_body'><ul>";
				$.each(children,function(childIndex,childItem){
					var draggableAttr = (childItem.children!=null&&childItem.children.length>0)?"":"draggable='true'";
					var kpiType = childItem.type;
					var iconClass = "default";//默认样式
					if(kpiType == "1"){//基础指标
						iconClass = "jichu";
					}else if(kpiType=="2"){//复合指标
						iconClass = "deriveKpi";
					}else if(kpiType=="3"){//衍生指标
						iconClass = "recombinationKpi";
					}
					html+="<li class='"+iconClass+"' key='"+childItem.id+"' column='"+childItem.column+"' desc='"+childItem.desc+"' category='"+groupItem.title+"' "+draggableAttr+"><b style='display:inline-block;height:38px'>"+childItem.desc+"</b>";
					if(childItem.children!=null&&childItem.children.length>0){
						kpiTools.kpiExtMap[childItem.id]=childItem.children;
						html+="<span>?</span>";
					}
					if(childItem.favorite=='0'){
						html+="<a href='javascript:void(0);' class='starLink_default'></a></li>\n";
					}else{
						html+="<a href='javascript:void(0);' class='starLink_active'></a></li>\n";
					}
				});
				html+="</ul></div>";
			});
			$("#kpiList_").html(html);
			$(".category_header").click(function(){//指标分类点击事件，关闭和打开分类
				$(this).next(".category_body").toggle();
				var text = $(this).find("span:eq(0)").text();
				$(this).find("span:eq(0)").text(text=="︾"?"︽":"︾").toggleClass("span_active");
			});
			//遍历指标，初始化每一项指标扩展指标tooltip
			$("#kpiList_>.category_body>ul>li").each(function(index,item){
				$(item).click(function(event){event.stopPropagation();});
				var categoryTitle = $(this).attr('category');
				var kpiExtArr = kpiTools.kpiExtMap[$(this).attr("key")];
				if(kpiExtArr!=undefined&&kpiExtArr.length>0){//生成扩展指标html
					var kpiExtHtml = "<ul>";
					$.each(kpiExtArr,function(index,kpiExtObj){
						kpiExtHtml+="<li key='"+kpiExtObj.id+"' column='"+kpiExtObj.column+"' desc='"+kpiExtObj.desc+"' category='"+categoryTitle+"' draggable='true'>"+kpiExtObj.desc+"</li>\n";
					});
					kpiExtHtml+="</ul>";
					initTooltip_(item,kpiExtHtml);		
					kpiTools.initDrag();
				}
			});
			$("#kpiList_>.category_body>ul>li>a").click(function(event){//收藏按钮点击事件
				event.stopPropagation();
				var kpiId = $(this).parent().attr("key");
				kpiTools.currentItem = kpiTools.getItemObj($(this).parent(),'kpi');
				if($(this).attr("class")=="starLink_default"){
					kpiTools.addFavorite(kpiTools.currentItem);
					$(this).removeClass("starLink_default");
					$(this).addClass("starLink_active");
				}else{
					kpiTools.removeFavorite(kpiId);
					$(this).removeClass("starLink_active");
					$(this).addClass("starLink_default");
				}
			});
		}else if(category=='dim'){//生成维度html
			html = "<ul>";
			$.each(group,function(dimIndex,dimItem){
				html+="<li key='"+dimItem.id+"' column='"+dimItem.column+"' desc='"+dimItem.desc+"' draggable='true'>"+dimItem.desc+"</li>\n";
			});
			html+="</ul>";
			$("#dimList_").html(html);
		}else if(category=='property'){//生成属性html
			html = "<ul>";
			$.each(group,function(proIndex,proItem){
				html+="<li key='"+proItem.id+"' column='"+proItem.column+"' desc='"+proItem.desc+"' draggable='true'>"+proItem.desc+"</li>\n";
			});
			html+="</ul>";
			$("#propertyList_").html(html);
		}else if(category=='mykpi'){//生成我的指标html
			html = "<ul>";
			$.each(group,function(kpiIndex,kpiItem){
				var draggableAttr = (kpiTools.kpiExtMap[kpiItem.KPI_ID]!=null&& kpiTools.kpiExtMap[kpiItem.KPI_ID].length>0)?"":"draggable='true'";
				var kpiType = kpiItem.type;
				var iconClass = "default";//默认样式
				if(kpiType == "1"){//基础指标
					iconClass = "jichu";
				}else if(kpiType=="2"){//复合指标
					iconClass = "fuhe";
				}else if(kpiType=="3"){//衍生指标
					iconClass = "yansheng";
				}
				html+="<li class='"+iconClass+"' key='"+kpiItem.KPI_ID+"' column='"+kpiItem.KPI_COLUMN+"' desc='"+kpiItem.KPI_DESC+"' category='"+kpiItem.KPI_CATEGORY+"' "+draggableAttr+"><b style='display:inline-block;height:38px'>"+kpiItem.KPI_DESC+"</b>";
				if(kpiTools.kpiExtMap[kpiItem.KPI_ID]!=null&&kpiTools.kpiExtMap[kpiItem.KPI_ID].length>0){
					html+="<span>?</span>";
				}
				html+="<a href='javascript:void(0);' class='starLink_close'>×</a></li>\n";
			});
			html+="</ul>";
			$("#myKpiList_").html(html);
			//遍历我的指标，初始化每一项指标扩展指标tooltip
			$("#myKpiList_>ul>li").each(function(index,item){
				$(item).click(function(event){event.stopPropagation();});
				var categoryTitle = $(this).attr('category');
				if($(item).children("span").size()>0){//生成扩展指标html
					var kpiExtArr = kpiTools.kpiExtMap[$(item).attr("key")];
					var kpiExtHtml = "<ul>";
					$.each(kpiExtArr,function(index,kpiExtObj){
						kpiExtHtml+="<li key='"+kpiExtObj.id+"' column='"+kpiExtObj.column+"' desc='"+kpiExtObj.desc+"' category='"+categoryTitle+"' draggable='true'>"+kpiExtObj.desc+"</li>\n";
					});
					kpiExtHtml+="</ul>";
					initTooltip_(item,kpiExtHtml);
				}
			});
			$("#myKpiList_>ul>li>a").click(function(event){//删除收藏按钮点击事件
				event.stopPropagation();
				var kpiId = $(this).parent().attr("key");
				kpiTools.removeFavorite(kpiId);
			});
		}
		kpiTools.initDrag();
	}
};
$(function(){
	var screenH = window.screen.height;
	$('.easyui-tabs').height(screenH-208);
	setTimeout(function(){$("#tab-tools_").css("height","25px");},1000);
	//kpiTools.init($("#cube_code").val());
	//初始化字母列表UI
	var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var letterLiListHtml="";
	for(var i=0;i<letters.length;i++){
		letterLiListHtml+="<li><a href='javascript:void(0)'>"+letters.charAt(i)+"</a></li>\n";
	}
	$(".letterList").each(function(index,item){
		$(item).html(letterLiListHtml);
		$.parser.parse($(item));
	});
});

//字母列表按钮开关事件
function letterListBtnClick_(){
	$("#kpiLetterListDiv_").toggle();
}