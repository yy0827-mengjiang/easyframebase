<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<script src="pages/cusview/resources/component/jqueryui/ui/jquery.ui.core.js"></script>
<script src="pages/cusview/resources/component/jqueryui/ui/jquery.ui.widget.js"></script>
<script src="pages/cusview/resources/component/jqueryui/ui/jquery.ui.mouse.js"></script>
<script src="pages/cusview/resources/component/jqueryui/ui/jquery.ui.selectable.js"></script>
<script src="pages/cusview/resources/component/jqueryui/ui/jquery.ui.resizable.js"></script>
<script src="pages/cusview/resources/component/jqueryui/ui/jquery.ui.sortable.js"></script>
<script>
function toolsAddHideEvent(){
	$(".propertiesPane h4").click(function(){
    	$(this).next("div.ppInterArea").slideToggle("fast");
    	$(this).toggleClass("ot");
    })
}
</script>
<div class="propertiesPane">
	<div id="containerPropertyBaseInfoDiv">
		<input type="hidden" id="oldContainerTitle" value="">
		<input type="hidden" id="currentContainerTypeForEditeProperty" value="">
		<input type="hidden" id="currentContainerPopForEditeProperty" value="">
		<input type="hidden" id="selfComponentId" value="">
		<div id="containerTitleArea">
			<h4>标题编辑</h4>
			<div class="ppInterArea">
			<dl>
				<dt>标题名称</dt>
				<dd><input type="text" class="wih_214" id="containerTitle" name="containerTitle" value=""/></dd>
			</dl>
			</div>
		</div>
		<div id="containerTitleArea">
		
			<h4>标题字体设置</h4>
			<div class="ppInterArea">
			<div class="textSet">
				<script>
					$(function(){
					$("#titleBold, #titleItalics").click(function(){
						$(this).toggleClass('active');
					})	
				})
				</script>
				<input type="button" id="titleBold" name="titleBold" value="B" tbold="normal" onclick="setTitleBold(this);"/>
				<input type="button" id="titleItalics" name="titleItalics" value="I" titalics="normal" onclick="setTitleItalics(this);"/>
				<select id="titleFont" class="wih_130">
					<option value="宋体">宋体</option>
					<option value="微软雅黑">微软雅黑</option>
				</select>
				<select id="titleFontSize" class="wih_100">
					<option value="10px">10px</option>
					<option value="12px">12px</option>
					<option value="14px" selected>14px</option>
					<option value="16px">16px</option>
					<option value="18px">18px</option>
				</select>
			</div>
			<div class="textSet">
			<input type="text" id="titleColor" name="titleColor" class="colorpk" value="#199ed8">
			</div>
			</div>
		</div>
	</div>
	<div id="containerPropertyExtInfoDiv">
		<h4>页签编辑</h4>
		<div class="ppInterArea">
		<ul id="containerPropertyExtInfoUl">
		</ul>
		</div>
	</div>
	<div id="containerPropertyButtonDiv">
		<ul class="btnItem1 mr_10">
			<li><a href="javascript:void(0);" class="easyui-linkbutton" onclick="saveContainerProperty();return false;">确定</a></li>
		</ul>
		<ul class="btnItem1 mr_10">
			<li><span id="savemsg"></span></li>
		</ul>
	</div>
</div>
<span id="comp_container" data-fun_edit="container_fun_edit" style="display:none"></<span>
<script type="text/javascript">
	function setTitleBold(obj){
		var v = $(obj).attr('tbold') == 'normal'?'bold':'normal';
		$(obj).attr('tbold',v);
	}
	function setTitleItalics(obj){
		var v = $(obj).attr('titalics') == 'normal'?'italic':'normal';
		$(obj).attr('titalics',v);
	}
	function closeAllEditingStatus(){
		inputBlurFunction($("input[id^='editingStatus_']")[0]);
	}
	function clickLiItem(valueId){
		var oldContainerTitle=$("#"+valueId).text();
		$("#oldContainerTitle").val(oldContainerTitle);
		$("#"+valueId).html('<input type="text" id="editingStatus_'+valueId+'" value="'+'" onblur="inputBlurFunction(this)"/>');
		$("#editingStatus_"+valueId).focus().val(oldContainerTitle);
		
	}
	function inputBlurFunction(inputObj){
		var $inputObj=$(inputObj);
		if($.trim($inputObj.val())==''){
			$inputObj.focus().val($("#oldContainerTitle").val());
		}else{
			$inputObj.parent().html($inputObj.val());
		}
		
	}
	function closeAllEditingInput(){
		var editingStatusInput=$("input[id^='editingStatus_']");
		if(editingStatusInput.size()>0){
			for(var a=0;a<editingStatusInput.size();a++){
				inputBlurFunction(editingStatusInput[a]);
				//editingStatusInput.eq(a).parent().html(editingStatusInput.eq(a).val());
			}
		}
	}
	function removeLiItem(obj,compid){
		cn.com.easy.xbuilder.service.XService.hasEvents(StoreData.xid,'',compid,function(data,exception){
			if(data == ''){
				$(obj).parent().remove();
			}else{
				var dataarr = data.split(',');
				$.messager.alert('提示信息','我们发现该组件，被"'+dataarr[0]+'"设置了动作"'+dataarr[1]+'"，请先删除"'+dataarr[1]+'"(设置动作为无)。','error');
			}
		});
	}
	
	function getItemsData(){
		var itemsDataList=[];
		var liList=$("#sortable li");
		for(var i=0;i<liList.size();i++){
			var info={};
			info.componentId=$(liList[i]).attr("name");
			info.title=$(liList[i]).children().eq(0).text();
			itemsDataList.push(info);
		}
		return itemsDataList;
	}
	function saveContainerProperty(){
		closeAllEditingInput();
		var viewId="${param.viewId }";
		var containerId="${param.containerId }";
		var liList=$("#containerPropertyExtInfoUl").find("li");
		
		var param={};//参数对象
		param.title=$('#containerTitle').val();
		
		var containerType=$('#currentContainerTypeForEditeProperty').val();
		if(containerType=='1'){
			if(param.title==undefined||param.title==null||$.trim(param.title)==''){
				$.messager.alert("提示信息！","标题不能为空","error");
				return false;
			}
		}else if(containerType=='2'){
			if(param.title==undefined||param.title==null){
				param.title='';
			}
			
		}else if(containerType=='3'){
			param.title='';
		}else{
			return false;
		}
		if(containerType=='2'||containerType=='3'){
			if(liList.size()==0){
				$.messager.alert("提示信息！","保存失败：至少要保留一个组件！请重新编辑！","error");
				return false;
			}
		
		}
		
		var titleCss = {};
		titleCss['font-weight'] = $('#titleBold').attr('tbold');
		titleCss['font-style'] = $('#titleItalics').attr('titalics');
		titleCss['font-family']=$('#titleFont').val();
		
		titleCss.color = $('#titleColor').spectrum("get").toHexString();
		
		titleCss['font-size'] = $('#titleFontSize').val();
		param.styleclass = titleCss['font-weight']+','+titleCss['font-style']+','+titleCss['font-family']+','+titleCss.color+','+titleCss['font-size'];
		param.bgclass=$('input[name="containerColor"]:checked').val();
		
		
		var componentList=[];
		for(var i=0;i<liList.size();i++){
			var componentInfo={};
			componentInfo.id=liList.eq(i).attr("name");
			componentInfo.title=liList.eq(i).find("#value_"+componentInfo.id).eq(0).text();
			componentList.push(componentInfo);
		}
		param.componentList=componentList;
		
		
		$('#div_head_title_'+containerId).css(titleCss).html('<span id="div_head_title_'+containerId+'_span" style="font-size:'+titleCss['font-size']+'">'+param.title+'</span>');
		var containerColorArray=$("input[name='containerColor']");
		for(var i=0;i<containerColorArray.size();i++){
			$('#div_area_'+containerId).removeClass($(containerColorArray[i]).val());
		}
		$('#div_area_'+containerId).addClass(param.bgclass);
		
		var componentTabLi=$("#component_tab>li");
		if(containerType=='1'){
			var selfComponentId=$("#selfComponentId").val();
			for(var b=0;b<componentTabLi.size();b++){
				if($(componentTabLi[b]).find("span").eq(0).attr("id") == selfComponentId) {
					$(componentTabLi[b]).find("span").eq(0).attr("title",param.title);
					$(componentTabLi[b]).find("span").eq(0).html(param.title);
				}
			}
		}
		
		var newShowComponentLiList=[];
		var newShowComponentLiListIndex=0;
		var showComponentLiList=$("#div_head_ul_"+containerId).find("li");
		for(var b=0;b<componentList.length;b++){
			for(var a=0;a<showComponentLiList.size();a++){
				var liId="div_head_li_"+containerId+"_"+componentList[b].id;
				if(showComponentLiList.eq(a).attr("id")==liId){
					showComponentLiList.eq(a).find("a").eq(0).html(componentList[b].title);
					newShowComponentLiList[newShowComponentLiListIndex]=showComponentLiList.eq(a);
					newShowComponentLiListIndex++;
				}
			}
		}
		var box = $('<div></div>');
		for(var c=0;c<newShowComponentLiList.length;c++){
			box.append(newShowComponentLiList[c]);
		}
		$("#div_head_ul_"+containerId).html(box.html());
		
		showComponentLiList=$("#div_head_ul_"+containerId).find("li");
		if(showComponentLiList.size()>0){
			showComponentLiList.eq(showComponentLiList.size()-1).find("a").eq(0).click();
		}
		
		
		
		var popValue=$('#currentContainerPopForEditeProperty').val();
		var popFlag=true;
		if(popValue==''||popValue==null||popValue==undefined||popValue=='null'){
			popFlag=false;
		}
		if(popFlag||containerType=='2'||containerType=='3'){
			for(var a=0;a<componentList.length;a++){
				for(var b=0;b<componentTabLi.size();b++){
					if($(componentTabLi[b]).find("span").eq(0).attr("id") == componentList[a]["id"]) {
						if(popFlag){
							$("#popup_"+componentList[a]["id"]).attr("data-titile",componentList[a]["title"]);
						}
						$(componentTabLi[b]).find("span").eq(0).attr("title",componentList[a]["title"]);
						$(componentTabLi[b]).find("span").eq(0).html(componentList[a]["title"]);
					}
				}
			}
		}
		
		
		LayOutUtil.setLHtml($("#selectable_layout_id001").html());
		cn.com.easy.xbuilder.service.XComponentService.saveContainerProperty(viewId,containerId,$.toJSON(param),function(data,e){
			$('#savemsg').html("属性已保存");
		});
	}
	$(function(){
		var viewId="${param.viewId }";
		var containerId="${param.containerId }";
		cn.com.easy.xbuilder.service.XComponentService.getContainerAllInfoById(viewId,containerId,'',false,
				function(data, exception) {
					if (exception != undefined) {
						$.messager.alert("提示信息！",exception,"error");
					} else {
						if (data != "0") {//没有组件,直接load
							var containerObj=$.parseJSON(data);//取到容器对象
							var containerTitleObj=$('#containerTitle');
							if(containerObj.title!=undefined&&containerObj.title!=null&&containerObj.title!=''&&containerObj.title!='null'){
							
							var stylecls = containerObj.styleclass;
							if(stylecls){
								var cssArr = stylecls.split(',');
								$('#titleBold').attr('tbold',cssArr[0]);
								$('#titleItalics').attr('titalics',cssArr[1]);
								$('#titleFont').val(cssArr[2]);
								$('#titleFontSize').val(cssArr[4]);
							}
							containerTitleObj.val(containerObj.title);
							}else{
								containerTitleObj.val("");
							}
							if(containerObj.type=='3'){
								$('#containerTitleArea').hide();
							}else{
								$('#containerTitleArea').show();
							}
							$('#currentContainerTypeForEditeProperty').val(containerObj.type);
							$('#currentContainerPopForEditeProperty').val(containerObj["pop"]);
							
							var popFlag=true;
							if(containerObj["pop"]==''||containerObj["pop"]==null||containerObj["pop"]==undefined||containerObj["pop"]=='null'){
								popFlag=false;
							}
							if(containerObj.type=='2'||containerObj.type=='3'){
								$("#selfComponentId").val("");
								var containerPropertyExtInfoUl=$("#containerPropertyExtInfoUl");
								containerPropertyExtInfoUl.html("");
								var containerPropertyExtInfoLiStr='';
								if(containerObj.components&&containerObj.components.componentList){
									for(var a=0;a<containerObj.components.componentList.length;a++){
										var componentTitle='组件'+(a+1);
										if(containerObj.components.componentList[a].title!=undefined&&containerObj.components.componentList[a].title!=''&&containerObj.components.componentList[a].title!=null){
											componentTitle=containerObj.components.componentList[a].title
										}
										//containerPropertyExtInfoLiStr=containerPropertyExtInfoLiStr+'<li name="'+containerObj.components.componentList[a].id+'" ondblclick="clickLiItem(\'value_'+containerObj.components.componentList[a].id+'\')"><span id="value_'+containerObj.components.componentList[a].id+'" style="position: relative">'+componentTitle+'</span><a href="javascript:void(0);" onclick="removeLiItem(this,\''+containerObj.components.componentList[a].id+'\');return false;">&times;</a></li>';
										containerPropertyExtInfoLiStr=containerPropertyExtInfoLiStr+'<li name="'+containerObj.components.componentList[a].id+'" ondblclick="clickLiItem(\'value_'+containerObj.components.componentList[a].id+'\')"><span id="value_'+containerObj.components.componentList[a].id+'" style="position: relative">'+componentTitle+'</span><a href="javascript:void(0);" onclick="removeLiItem(this,\''+containerObj.components.componentList[a].id+'\');return false;">&times;</a></li>';
									}
									containerPropertyExtInfoUl.html(containerPropertyExtInfoLiStr);
								}
								$("#containerPropertyExtInfoUl").sortable();
								$("#containerPropertyExtInfoUl").disableSelection()
								$("#containerPropertyExtInfoDiv").show();
							}else if(popFlag){
								
								var containerPropertyExtInfoUl=$("#containerPropertyExtInfoUl");
								containerPropertyExtInfoUl.html("");
								var containerPropertyExtInfoLiStr='';
								if(containerObj.components&&containerObj.components.componentList){
									for(var a=0;a<containerObj.components.componentList.length;a++){
										if(containerObj["pop"]!=containerObj.components.componentList[a].id){
											$("#selfComponentId").val(containerObj.components.componentList[a].id);
											continue;
										}
										var componentTitle='组件'+(a+1);
										if(containerObj.components.componentList[a].title!=undefined&&containerObj.components.componentList[a].title!=''&&containerObj.components.componentList[a].title!=null){
											componentTitle=containerObj.components.componentList[a].title
										}
										containerPropertyExtInfoLiStr=containerPropertyExtInfoLiStr+'<li name="'+containerObj.components.componentList[a].id+'" ondblclick="clickLiItem(\'value_'+containerObj.components.componentList[a].id+'\')"><span id="value_'+containerObj.components.componentList[a].id+'" style="position: relative">'+componentTitle+'</span></li>';
									}
									containerPropertyExtInfoUl.html(containerPropertyExtInfoLiStr);
								}
								$("#containerPropertyExtInfoUl").sortable();
								$("#containerPropertyExtInfoUl").disableSelection()
								$("#containerPropertyExtInfoDiv").show();
							}else{
								if(containerObj.components!=null&&containerObj.components.componentList!=null&&containerObj.components.componentList[0]!=null){
									$("#selfComponentId").val(containerObj.components.componentList[0].id);
								}
								$("#containerPropertyExtInfoDiv").hide();
							}
							
						}
					}
				}
			);
	});
</script>
