<%@ tag body-content="scriptless"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%@ attribute name="id" required="true" %>                  <e:description>组件ID</e:description>
<%@ attribute name="dbClickFun" required="false" %>         <e:description>双击事件响应函数</e:description>
<%@ attribute name="categories" required="false" %>		    <e:description>显示的类别:kpi,dim,property,mykpi</e:description>
<%@ attribute name="right" required="false" %>		        <e:description>弹出窗距右侧距离</e:description>
<%@ attribute name="top" required="false" %>		        <e:description>弹出窗距顶部距离</e:description>

<e:if condition="${right eq '' || right == null }">
      <e:set var="right" value="380" />
</e:if>

<e:if condition="${top eq '' || top == null }">
      <e:set var="top" value="0" />
</e:if>

<e:if condition="${categories eq '' || categories == null }">
      <e:set var="categories" value="kpi,dim,property,mykpi" />
</e:if>
<script type="text/javascript">
var ${id} = {
	right:${right},
	top:${top},
	currentItem:null,
	kpiExtMap:{},
	cubeId:null,
	currentTooltip:null,
	categoriesArr:['kpi','dim','property','mykpi'],
	init:function(cubeId){//初始化页面UI和数据
		var categories = "${categories}";
		${id}.cubeId=cubeId;
		kpiSelectorService.getDataFromKpiLibrary(cubeId,categories,StoreData.xid,function(data,exception){
			$.each(${id}.categoriesArr,function(index,category){
				if(categories.indexOf(category)!=-1){
					${id}.generateHtml(category,data[category]);
					//自动补全
					var availableTags = new Array();
					var arr = data[category];
					if(category=="kpi"||category=="dim"){
						for(var i=0;i<arr.length;i++){
							var kpiList = arr[i].children;
							if(kpiList!=undefined){
								for(var j=0;j<kpiList.length;j++){
									availableTags.push({value:kpiList[j].desc,data:'1'});
								}
							}
						}
					}else if(category=="property"){
						for(var i=0;i<arr.length;i++){
							availableTags.push({value:arr[i].desc,data:'1'});
						}
					}else{
						for(var i=0;i<arr.length;i++){
							var itemList = arr[i];
							if(itemList!=undefined){
								for(var j=0;j<itemList.length;j++){
									availableTags.push({value:itemList[j].KPI_DESC,data:'1'});
								}
							}
						}
					}
				    $("#"+category+"Keywords_${id}").autocomplete({
				         lookup: availableTags,
				         onSelect: function (suggestion) {}
				    }); 
				}else{
					$("#tabs_${id}").tabs('close', index); 
				}
			});
			
			$("#kpiList_${id}>.category_body").hide();
			$("#kpiList_${id}>.category_body").eq(0).show();
			$("#kpiList_${id} .category_header:gt(0)").children("span:eq(0)").text("︾").toggleClass("span_active"); 
		});
	},
	reload:function(){
		var categories = "${categories}";
		kpiSelectorService.reload(${id}.cubeId,categories,StoreData.xid,function(data,exception){
			$.each(${id}.categoriesArr,function(index,category){
				if(categories.indexOf(category)!=-1){
					${id}.generateHtml(category,data[category]);
				}else{
					$("#tabs_${id}").tabs('close', index); 
				}
			});
		});
	},
	queryData:function(letter,keywords,queryType){//按字母或关键字的查询方法
		var category = ${id}.getCurCategory();
		kpiSelectorService.queryData(${id}.cubeId,keywords,letter,queryType,category,function(data,exception){
			${id}.generateHtml(category,data);
		});
	},
	addFavorite:function(paramObj){//添加收藏
		kpiSelectorService.addFavorite(${id}.cubeId,paramObj,function(data,exception){
			if(data[0]=="0"){
				alert("收藏失败！");
			}else{
				${id}.generateHtml('mykpi',data[1]);
			}
		});
	},
	removeFavorite:function(itemId){//删除收藏
		kpiSelectorService.removeFavorite(${id}.cubeId,itemId,function(data,exception){
			if(data=="0"){
				alert("删除收藏失败！");
			}else{
				$("#myKpiList_${id}").find("li[key='"+itemId+"']").eq(0).remove();
				$("#kpiList_${id} li[key='"+itemId+"']>a").removeClass("starLink_active");
				$("#kpiList_${id} li[key='"+itemId+"']>a").addClass("starLink_default");
			}
		});
	},
	getItemObj:function($li,tabType){//根据编号获得当前操作的指标、维度或属性
			tabType = tabType=='mykpi'?'kpi':tabType;
			${id}.currentItem={
					  id : $li.attr("key"),
					  column : $li.attr("column"),
					  desc : $li.attr("desc"),
					  kpiType:tabType,
					  category : $li.attr("category"),
					  extcolumnid:"",
					  isextcolumn:'false'
			};
		return ${id}.currentItem;
	},
	getCurCategory:function(){//获得当前展示的类别名
		var tab = $('#tabs_${id}').tabs('getSelected');
		var index = $('#tabs_${id}').tabs('getTabIndex',tab);
		var category="";
		switch(index){
			case 0 : category = "kpi";break;
			case 1 : category = "dim";break;
			case 2 : category = "property";break;
			case 3 : category = "mykpi";break;
			default:category = "kpi";
		}
		return category;
	},
	sort:function(sortType){//按字母顺序排序
		var category = ${id}.getCurCategory();
		var letter = $("#"+category+"LetterListDiv_${id}").find(".letterSelected > a").text();
		var keywords = $("#"+category+"Keywords_${id}").val();
		kpiSelectorService.sort(${id}.cubeId,letter,keywords,category,sortType,function(data,exception){
			${id}.generateHtml(category,data);
		});
	},
	open:function(cubeId){//打开组件
		if(cubeId=="-1"){
			$.messager.alert("提示框","请在数据集中选择一个数据魔方！","info",function(){
				$('.tabTiele li').each(function(index,item) {
			    	 if(index == 1) {
				         $(item).addClass('cur').siblings().removeClass('cur');
				         $('.tabBox .tabInner').eq(index).show().siblings(".tabInner").hide();
			    	 }
			     });
			     $(".panel-tool-close").css("display","");
			
			});
			$(".panel-tool-close").css("display","none");
			return;
		}
		${id}.cubeId=cubeId;
		var $dialog = $('#container_${id}');
	    if($dialog.css("display")=="none"){
	    	$dialog.css("position","absolute");
	    	$dialog.css("right",${id}.right+"px").css("top",${id}.top+"px");
			$dialog.show(100);
	    }
	    ${id}.init(cubeId);
	},
	dbClick:function(itemObj){//指标双击事件
		<e:if condition="${dbClickFun != null && dbClickFun != ''}">
			${dbClickFun}(itemObj);
		</e:if>
	},
	initDrag:function(){//初始化拖拽
		$("li[draggable='true']").draggable({
			proxy:function(source){
				var p = $('<div style="border:1px solid #999;padding:3px;background:#eee"></div>');
				p.html($(source).attr("desc")).appendTo('body');
				return p;
			},
			revert:true,
			cursor:'move',
			onStartDrag: function () {
			     ${id}.currentItem=${id}.getItemObj($(this),${id}.getCurCategory());
	             $(this).draggable('options').cursor = 'move';
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
						iconClass = "recombinationKpi";
					}else if(kpiType=="3"){//衍生指标
						iconClass = "deriveKpi";
					}
					html+="<li class='"+iconClass+"' key='"+childItem.id+"' column='"+childItem.column+"' desc='"+childItem.desc+"' category='"+groupItem.title+"' "+draggableAttr+"><b>"+childItem.desc+"</b>";
					if(childItem.children!=null&&childItem.children.length>0){
						${id}.kpiExtMap[childItem.id]=childItem.children;
						html+="<span>▹</span>";
					}
					if(childItem.favorite=='0'){
						html+="<a href='javascript:void(0);' class='starLink_default' title='收藏'></a></li>\n";
					}else{
						html+="<a href='javascript:void(0);' class='starLink_active' title='收藏'></a></li>\n";
					}
				});
				html+="</ul></div>";
			});
			$("#kpiList_${id}").html(html);
			$("#kpiList_${id} .category_header").click(function(){//指标分类点击事件，关闭和打开分类
				$(this).next(".category_body").toggle();
				var text = $(this).find("span:eq(0)").text();
				$(this).find("span:eq(0)").text(text=="︾"?"︽":"︾").toggleClass("span_active");
			});
			//遍历指标，初始化每一项指标扩展指标tooltip
			$("#kpiList_${id}>.category_body>ul>li").each(function(index,item){
				$(item).click(function(event){event.stopPropagation();});
				var categoryTitle = $(this).attr('category');
				var kpiExtArr = ${id}.kpiExtMap[$(this).attr("key")];
				if(kpiExtArr!=undefined&&kpiExtArr.length>0){//生成扩展指标html
					var kpiExtHtml = "<ul>";
					$.each(kpiExtArr,function(index,kpiExtObj){
						kpiExtHtml+="<li key='"+kpiExtObj.id+"' column='"+kpiExtObj.column+"' desc='"+kpiExtObj.desc+"' category='"+categoryTitle+"' draggable='true'>"+kpiExtObj.desc+"</li>\n";
					});
					kpiExtHtml+="</ul>";
					initTooltip_${id}(item,kpiExtHtml);		
					${id}.initDrag();
				}
			});
			$("#kpiList_${id}>.category_body>ul>li>a").click(function(event){//收藏按钮点击事件
				event.stopPropagation();
				var kpiId = $(this).parent().attr("key");
				${id}.currentItem = ${id}.getItemObj($(this).parent(),'kpi');
				if($(this).attr("class")=="starLink_default"){
					${id}.addFavorite(${id}.currentItem);
					$(this).removeClass("starLink_default");
					$(this).addClass("starLink_active");
				}else{
					${id}.removeFavorite(kpiId);
					$(this).removeClass("starLink_active");
					$(this).addClass("starLink_default");
				}
			});
		}else if(category=='dim'){//生成维度html
			//指标库维度选择加入复选框(重庆模式)
			html = "";
			cn.com.easy.xbuilder.service.DimensionService.getDimsions(StoreData.xid,function(data,exception){
				$.each(group,function(groupIndex,groupItem){
					var children = groupItem.children == null ? [] : groupItem.children;
					html+="<div class='category_header' id='dimCategory'><span>︾</span>"+"<em>"+ groupItem.title +"</em>"+"</div>";
					html+="<div class='category_body'><ul>";
	// 				html = "<ul>";
					var dataArr = $.parseJSON(data);
					if(dataArr!=null){
						$.each(children,function(dimIndex,dimItem){
							var checkBox = null;
							$.each(dataArr,function(index,item){
								var varname = item.varname;
								if(varname==dimItem.column){
									checkBox = '<a id="checkBox_${id}" style="cursor:pointer" class="weiLink_active" title="选中添加查询条件" dimId="'+dimItem.id+'" dimCol="'+dimItem.column+'" dimDesc="'+dimItem.desc+'"/>';
								}
							});
							if(checkBox==null){
									checkBox = '<a id="checkBox_${id}" style="cursor:pointer" class="weiLink_default" title="选中添加查询条件" dimId="'+dimItem.id+'" dimCol="'+dimItem.column+'" dimDesc="'+dimItem.desc+'"/>';
							}
							html+="<li class='dimensionality' key='"+dimItem.id+"' column='"+dimItem.column+"' desc='"+dimItem.desc+"' draggable='true'>"+dimItem.desc+checkBox+" </li>\n";
						});
					}else{
						$.each(children,function(dimIndex,dimItem){
							var checkBox = '<a id="checkBox_${id}" style="cursor:pointer" class="weiLink_default" title="选中添加查询条件" dimId="'+dimItem.id+'" dimCol="'+dimItem.column+'" dimDesc="'+dimItem.desc+'"/>';
							html+="<li class='dimensionality' key='"+dimItem.id+"' column='"+dimItem.column+"' desc='"+dimItem.desc+"' draggable='true'>"+dimItem.desc+checkBox+" </li>\n";
						});
					}
					html+="</ul></div>";
				});
				$("#dimList_${id}").html(html);
				$("#dimCategory").click(function(){//指标分类点击事件，关闭和打开分类
					$(this).next(".category_body").toggle();
					var text = $(this).find("span:eq(0)").text();
					$(this).find("span:eq(0)").text(text=="︾"?"︽":"︾").toggleClass("span_active");
				});
				${id}.initDrag();
				$("#dimList_${id}>.category_body>ul>li>a").click(function(event){//维度添加查询按钮
					event.stopPropagation();
					var dimId = $(this).attr('dimId');
					var dimCol = $(this).attr('dimCol');
					var dimDesc = $(this).attr('dimDesc');
					if($(this).attr("class")=="weiLink_default"){
						$(this).removeClass("weiLink_default");
						$(this).addClass("weiLink_active");
						var data = {};
						data.id = dimId;
						data.column = dimCol;
						data.desc = dimDesc;
						data.kpiType = 'dim';
						enterDim([data],'kpi');
					}else{
						$(this).removeClass("weiLink_active");
						$(this).addClass("weiLink_default");
						delDim_cq(dimCol);
					}
				});
			});
		}else if(category=='property'){//生成属性html
			html = "<ul>";
			$.each(group,function(proIndex,proItem){
				html+="<li class='property' key='"+proItem.id+"' column='"+proItem.column+"' desc='"+proItem.desc+"' draggable='true'>"+proItem.desc+"</li>\n";
			});
			html+="</ul>";
			$("#propertyList_${id}").html(html);
		}else if(category=='mykpi'){//生成我的指标html
			html="<div class='category_header'><span>︾</span><em>我的收藏</em></div>";
			html+="<div class='category_body' id='favKpiList_${id}'><ul>";
			var favMapList = group[0];
			var extcolList = group[1];
			$.each(favMapList,function(kpiIndex,kpiItem){
				var draggableAttr = (${id}.kpiExtMap[kpiItem.KPI_ID]!=null&&${id}.kpiExtMap[kpiItem.KPI_ID].length>0)?"":"draggable='true'";
				var kpiType = kpiItem.type;
				var iconClass = "default";//默认样式
				if(kpiType == "1"){//基础指标
					iconClass = "jichu";
				}else if(kpiType=="2"){//复合指标
					iconClass = "deriveKpi";
				}else if(kpiType=="3"){//衍生指标
					iconClass = "recombinationKpi";
				}
				html+="<li class='"+iconClass+"' key='"+kpiItem.KPI_ID+"' column='"+kpiItem.KPI_COLUMN+"' desc='"+kpiItem.KPI_DESC+"' category='"+kpiItem.KPI_CATEGORY+"' "+draggableAttr+"><b>"+kpiItem.KPI_DESC+"</b>";
				if(${id}.kpiExtMap[kpiItem.KPI_ID]!=null&&${id}.kpiExtMap[kpiItem.KPI_ID].length>0){
					html+="<span>▹</span>";
				}
				html+="<a href='javascript:void(0);' class='starLink_close'>×</a></li>\n";
			});
			html+="</ul></div>";
			html+="<div class='category_header'><span>︾</span><em>计算列</em></div>";
			html+="<div class='category_body' id='extcolList_${id}'><ul>";
			$.each(extcolList,function(extIndex,extItem){
				html+="<li class='default' category='extcolumn' key='"+extItem.id+"' column='"+extItem.id+"' node-id='"+extItem.id+"' draggable='true' desc='"+extItem.text+"'><b>"+extItem.text+"</b></li>\n";
			});
			html+="</ul></div>";
			$("#myKpiList_${id}").html(html);
			$("#myKpiList_${id} .category_header").click(function(){//指标分类点击事件，关闭和打开分类
				$(this).next(".category_body").toggle();
				var text = $(this).find("span:eq(0)").text();
				$(this).find("span:eq(0)").text(text=="︾"?"︽":"︾").toggleClass("span_active");
			});
			//遍历我的指标，初始化每一项指标扩展指标tooltip
			$("#favKpiList_${id}>ul>li").each(function(index,item){
				$(item).click(function(event){event.stopPropagation();});
				var categoryTitle = $(this).attr('category');
				if($(item).children("span").size()>0){//生成扩展指标html
					var kpiExtArr = ${id}.kpiExtMap[$(item).attr("key")];
					var kpiExtHtml = "<ul>";
					$.each(kpiExtArr,function(index,kpiExtObj){
						kpiExtHtml+="<li key='"+kpiExtObj.id+"' column='"+kpiExtObj.column+"' desc='"+kpiExtObj.desc+"' category='"+categoryTitle+"' draggable='true'>"+kpiExtObj.desc+"</li>\n";
					});
					kpiExtHtml+="</ul>";
					initTooltip_${id}(item,kpiExtHtml);
				}
			});
			$("#favKpiList_${id}>ul>li>a").click(function(event){//删除收藏按钮点击事件
				event.stopPropagation();
				var kpiId = $(this).parent().attr("key");
				${id}.removeFavorite(kpiId);
			});
		}
		if(category!='dim'){//维度时，调用service，拖动的初始化方法在回调函数中调用
			${id}.initDrag();
		}
	}
};

function changeDim${id}(obj,dimId,dimCol,dimDesc){
	var isChecked = $(obj).is(':checked');
	if(isChecked){
		var data = {};
		data.id = dimId;
		data.column = dimCol;
		data.desc = dimDesc;
		data.kpiType = 'dim';
		enterDim([data],'kpi');
	}else{
		delDim(dimCol);
	}
}
$(function(){
   		var screenH = $("#container").height();
   		var minusHeight=40;
		if(${id}.top!=0){
			screenH -= 40;
			minusHeight = 120;
		}
		$('#tabs_${id}').tabs({
			height:screenH
		}); 
		$('#tabs_${id}').tabs({onSelect:function(title,index){
			$('#tabs_${id}').tabs('getTab',index).panel('resize',{height:screenH-minusHeight});
		}});
   	})
$(function(){
	$("#container_${id}").hide();
	setTimeout(function(){$("#tab-tools_${id}").css("height","25px");},1000);
	//窗口关闭事件
	$("#closeDialogBtn_${id}").click(function(){
		$("#container_${id}").hide();
	});
	//刷新指标库事件
	$("#reloadDialogBtn_${id}").click(function(){
		${id}.reload();
	});
	//全部展开或全部关闭
	$("#openClosePanelBtn_${id}").click(function(){
		var state = $(this).attr("state");
		if(state =="closed"){
			$(".foldBtn").addClass("foldBtn_active").attr("title","展开指标组").removeClass("foldBtn_default");
			$(this).attr("state","opened");
			//全部展开
			$("#kpiList_${id}>.category_body").hide();
			$("#kpiList_${id}>.category_header").find("span:eq(0)").addClass("span_active");
		}else{
			$(".foldBtn").removeClass("foldBtn_active").attr("title","折叠指标组").addClass("foldBtn_default");
			$(this).attr("state","closed");
			//全部关闭
			$("#kpiList_${id}>.category_body").show();
			var text = $(this).find("span:eq(0)").text();
			$("#kpiList_${id}>.category_header").find("span:eq(0)").removeClass("span_active");
		}
	});
	
	
	
	//初始化字母列表UI
	var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var letterLiListHtml="";
	for(var i=0;i<letters.length;i++){
		letterLiListHtml+="<li><a href='javascript:void(0)'>"+letters.charAt(i)+"</a></li>\n";
	}
	$("#container_${id}").find(".letterList").html(letterLiListHtml);
	//字母点击事件
	$("#container_${id}").find(".letterList > li").click(function(){
		var category = ${id}.getCurCategory();
		$(this).addClass("letterSelected");
		$(this).siblings().removeClass("letterSelected");
		var letter = $(this).find("a").text();
		var keywords = $("#"+category+"Keywords_${id}").val();
		${id}.queryData(letter,keywords,"letter");
	});
	
	$(".kpiBoxArea").mouseleave(function(){
		$(this).hide();
		if($(this).find(".letterSelected").length>0){
			var letter = $(this).find(".letterSelected").find("a").eq(0).text();
			//$(this).prev("div").find(".RankText").text(letter);
		}
	});
	
	//点击页面空白处时隐藏已经显示的扩展指标
	$(document).click(function(){
		if(${id}.currentTooltip!=null){
			${id}.currentTooltip.tooltip('hide');
		}else{
			$(".tooltip-right").hide();
		}
	});
	$(".panel-body").scroll(function(){
		if(${id}.currentTooltip!=null){
			${id}.currentTooltip.tooltip('hide');
		}else{
			$(".tooltip-right").hide();
		}
	});
});


//字母列表按钮开关事件
function letterListBtnClick_${id}(){
	var category = ${id}.getCurCategory();
	$("#"+category+"LetterListDiv_${id}").toggle();
}
//排序按钮点击事件
function sortBtnClick_${id}(){
	var category = ${id}.getCurCategory();
	var sortBtn = $("#"+category+"SortBtn_${id}");
	if(sortBtn.attr("sortType")=="asc"){
		sortBtn.attr("sortType","desc");
		sortBtn.addClass("rankBtn_active").removeClass("rankBtn_default").attr("title","Z~A倒序");
		$(".RankText").text("A~Z");
		${id}.sort("asc");
	}else{
		sortBtn.attr("sortType","asc");
		sortBtn.addClass("rankBtn_default").removeClass("rankBtn_active").attr("title","A~Z正序");
		$(".RankText").text("Z~A");
		${id}.sort("desc");
	}
}
//查询按钮点击事件
function queryBtnClick_${id}(){
	var category = ${id}.getCurCategory();
	var letter = $("#"+category+"LetterListDiv_${id}").find(".letterSelected > a").text();
	var keywords = $("#"+category+"Keywords_${id}").val();
	${id}.queryData(letter,keywords,"keywords");
}
//删除当前字母查询条件
function removeLetterBtnClick_${id}(){
	var category = ${id}.getCurCategory();
	$("#"+category+"LetterListDiv_${id}").find(".letterSelected").removeClass("letterSelected");
	var letter = '';
	var keywords = $("#"+category+"Keywords_${id}").val();
	${id}.queryData(letter,keywords,"letter");
	$("#"+category+"LetterListDiv_${id}").prev("div").find(".RankText").text("A~Z");
	
}
//初始化tooltip
function initTooltip_${id}(liItem,htmlStr){
	$(liItem).find("b:eq(0)").tooltip({
		content: $(htmlStr),
		showEvent: 'click',
		position:'right',
		showDelay:0,
		hideDelay:0,
		onShow: function(){
			$(this).tooltip('tip').css({
				backgroundColor: '#888',
				borderColor: '#888',
				color:'#fff'
			});

			if(${id}.currentTooltip!=null){
				if(${id}.currentTooltip["context"]!=$(this)["context"]){
					${id}.currentTooltip.tooltip('hide');
				}
			}
			${id}.currentTooltip=$(this);
			var t = $(this);
			t.tooltip('tip').unbind().bind('mouseenter', function(){t.tooltip('show')}).bind('mouseleave', function(){}).bind('click', function(event){event.stopPropagation();});
			$(".tooltip-right").css("z-index","999999999");
			${id}.initDrag();
		}
	});
	
}
</script>
<div id="container_${id}" class="kpiSelectorCon" kpiSelectorDiv="true">
	<div id="tab-tools_${id}">
		<a id="reloadDialogBtn_${id}"  href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'"></a>
		<a id="closeDialogBtn_${id}"  href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-cancel'"></a>
	</div>
	<div id="tabs_${id}" class="easyui-tabs" data-options="tools:'#tab-tools_${id}'" style="width:320px;background:#fff; ">
		    <div title="指标">
			    <div id="kpiTool_${id}" class="pt40">
			         <div class="kpiSearchArea">
					    	<span>
					    		<a class="RankText" href="javascript:void(0);" onclick="letterListBtnClick_${id}()" title="索引">A~Z</a>
					    		<a class="rankBtn"  href="javascript:void(0);" sortType="asc" id="kpiSortBtn_${id}" title="A~Z正序" onclick="sortBtnClick_${id}()">↑</a>
					    	</span>
					    	<input class="inputBox" type="text" id="kpiKeywords_${id}"/>
					    	<a class="inputBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="queryBtnClick_${id}()">查询</a>
					    	<a class="foldBtn" href="javascript:void(0)" id="openClosePanelBtn_${id}" state="closed" title="折叠指标组">折叠指标组</a>
					  </div>
					  <div id="kpiLetterListDiv_${id}" class="kpiBoxArea hide">
						    <ul class="letterList"></ul>
						    <a href="javascript:void(0)" onclick="removeLetterBtnClick_${id}()" title="取消索引">取消索引</a>
				      </div>
			    </div>
			    <div id="kpiList_${id}"></div>
			</div>
		
		    <div title="维度">
				<div id="dimTool_${id}" class="pt40">
				      <div class="kpiSearchArea">
				      		<span>
						    	<a class="RankText" href="javascript:void(0);" onclick="letterListBtnClick_${id}()">A~Z</a>
						    	<a class="rankBtn" href="javascript:void(0);" sortType="asc" id="dimSortBtn_${id}" title="A~Z正序" onclick="sortBtnClick_${id}()">↑</a>
					    	</span>
					    	<input class="inputBox" type="text" class="fromOne"  id="dimKeywords_${id}"/>
					    	<a class="inputBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="queryBtnClick_${id}()">查询</a>
					  </div>
					  <div id="dimLetterListDiv_${id}" class="kpiBoxArea hide">
						    <ul class="letterList"></ul>
						    <a href="javascript:void(0)" onclick="removeLetterBtnClick_${id}()" title="取消索引">取消索引</a>
				      </div>
				</div>
				<div id="dimList_${id}" class="category_body"></div>
			</div>
		
		    <div title="属性">
				<div id="propertyTool_${id}" class="pt40">
				      <div class="kpiSearchArea">
					    	<span>
					    		<a class="RankText" href="javascript:void(0);" onclick="letterListBtnClick_${id}()">A~Z</a>
					    		<a class="rankBtn" href="javascript:void(0);"  sortType="asc" id="propertySortBtn_${id}" title="A~Z正序" onclick="sortBtnClick_${id}()">↑</a>
					    	</span>
					    	<input class="inputBox" type="text" id="propertyKeywords_${id}"/>
					    	<a class="inputBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="queryBtnClick_${id}()">查询</a>
					  </div>
					  <div id="propertyLetterListDiv_${id}" class="kpiBoxArea hide">
						    <ul class="letterList"></ul>
						    <a href="javascript:void(0)" onclick="removeLetterBtnClick_${id}()" title="取消索引">取消索引</a>
				      </div>
				</div>
				<div id="propertyList_${id}" class="category_body"></div>
			</div>
			
			<div title="我的指标">
				<div id="mykpiTool_${id}" class="pt40">
				    <div class="kpiSearchArea">
				    		<span>
						    	<a class="RankText" href="javascript:void(0);" onclick="letterListBtnClick_${id}('kpi')">A~Z</a>
						    	<a class="rankBtn"  href="javascript:void(0);" sortType="asc" id="mykpiSortBtn_${id}" title="A~Z正序" onclick="sortBtnClick_${id}()">↑</a>
					    	</span>
					    	<input class="inputBox" type="text" id="mykpiKeywords_${id}"/>
					    	<a class="inputBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="queryBtnClick_${id}()">查询</a>
					  </div>
					  <div id="mykpiLetterListDiv_${id}" class="kpiBoxArea hide">
						    <ul class="letterList"></ul>
						    <a href="javascript:void(0)" onclick="removeLetterBtnClick_${id}()" title="取消索引">取消索引</a>
				      </div>
				</div>
				<div id="myKpiList_${id}" class="category_body"></div>
			</div>
			
	</div>
	
</div>
