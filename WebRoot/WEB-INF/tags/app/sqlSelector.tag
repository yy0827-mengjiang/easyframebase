<%@ tag body-content="scriptless"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%@ attribute name="id" required="true" %>                  <e:description>组件ID</e:description>
<%@ attribute name="dbClickFun" required="false" %>         <e:description>双击事件响应函数</e:description>
<%@ attribute name="categories" required="false" %>		    <e:description>显示的类别:kpi</e:description>
<%@ attribute name="right" required="false" %>		        <e:description>弹出窗距右侧距离</e:description>
<%@ attribute name="top" required="false" %>		        <e:description>弹出窗距顶部距离</e:description>

<e:if condition="${right eq '' || right == null }">
      <e:set var="right" value="405" />
</e:if>

<e:if condition="${top eq '' || top == null }">
      <e:set var="top" value="0" />
</e:if>

<e:if condition="${categories eq '' || categories == null }">
      <e:set var="categories" value="kpi" />
</e:if>
<script type="text/javascript">

var ${id} = {
	right:${right},
	top:${top},
	currentItem:null,
	kpiExtMap:{},
	cubeId:null,
	currentTooltip:null,
	categoriesArr:['kpi'],
	init:function(xid){//初始化页面UI和数据
		var categories = "${categories}";
		${id}.cubeId=xid;
		sqlSelectorService.getMetadataDataSource(xid,function(data,exception){
			jsonData = JSON.parse(data);
			${id}.generateHtml(categories,jsonData);
		});
	},
	reload:function(){
		var categories = "${categories}";
		xid = ${id}.cubeId;
		sqlSelectorService.getMetadataDataSource(xid,function(data,exception){
			jsonData = JSON.parse(data);
			${id}.generateHtml(categories,jsonData);
		});
	},
	getItemObj:function($li,tabType){//根据编号获得当前操作的指标、维度或属性
			tabType = "";//tabType=='mykpi'?'kpi':tabType;
			category ="";
			${id}.currentItem={
					  id : $li.attr("colstr"),
					  column : $li.attr("colstr"),
					  desc : $li.attr("desc"),
					  vardesc:$li.attr("column"),
					  datasourceid:$li.attr("datasource"),
					  conditiontype:"1",
					  category : category//$li.attr("category")
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
	open:function(xid){//打开组件
		sqlSelectorService.isDataSources(xid,function(data,exception){
			if(data){
				${id}.cubeId=xid;
				var $dialog = $('#container_${id}');
			    if($dialog.css("display")=="none"){
			    	$dialog.css("position","absolute");
			    	$dialog.css("right",${id}.right+"px").css("top",${id}.top+"px");
					$dialog.show(100);
			    }
		    	${id}.init(xid);
				}else{
					$.messager.alert('提示信息',"没有选择数据集","info");
					return;
				}
			});
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
	           //  $(this).draggable('options').cursor = 'not-allowed';
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
	generateHtml:function(category,jsonData){//根据传入的数据生成指标维度或属性的html代码
		var html = "";
		if(category=='kpi'){//生成指标html.
			for(var i=0;i<jsonData.length;i++){
				var map = jsonData[i];
				for(var key in map){
					var srouname = key.split(";");
					var col = map[key];
					html+="<div class='category_header'><span>︾</span>"+"<em>"+srouname[1]+"</em>"+"</div>";
					html+="<div class='category_body'><ul>";
					for(var j=0;j<col.length;j++){
						html+="<li class='jichu' colstr='str"+j+"' key='"+col[j]+"' column='"+col[j]+"' desc='参数("+col[j]+")' datasource='"+srouname[0]+"' draggable='true'>";
						html+=col[j];
					}
					html+="</ul></div>";
				}
			}
			$("#kpiList_${id}").html(html);
			$(".category_header").click(function(){//指标分类点击事件，关闭和打开分类
				$(this).next(".category_body").toggle();
				var text = $(this).find("span:eq(0)").text();
				$(this).find("span:eq(0)").text(text=="︾"?"︽":"︾").toggleClass("span_active");
			});
		}
		${id}.initDrag();
	}
};
$(function(){
   		var screenH = $("#container").height();
   		var minusHeight=40;
		if(${id}.top!=0){
			screenH -= 40;
			minusHeight = 60;
		}
		$('#tabs_${id}').tabs({
			height:screenH
		}); 
		$("#kpiList_conditionSqlSelector").height(screenH-60);
		//alert($('#tabs_${id}').height());
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

</script>
<div id="container_${id}" class="kpiSelectorCon" kpiSelectorDiv="true">
	<div id="tab-tools_${id}">
		<a id="reloadDialogBtn_${id}"  href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'"></a>
		<a id="closeDialogBtn_${id}"  href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-cancel'"></a>
	</div>
	<div id="tabs_${id}" class="easyui-tabs" data-options="tools:'#tab-tools_${id}'" style="width:320px;">
		    <div title="查询条件">
			    <div id="kpiList_${id}"></div>
			</div>
	</div>
</div>
