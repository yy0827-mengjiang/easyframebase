<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<div id="COMPONENT-TREETABLE" class="propertiesPane">
	<!-- <input type="button" value="还原" onclick="treeTableComponentEditButton()"> -->
	<h4>指标设置</h4>
	<div class="ppInterArea">
		<!-- scrollBox--> 
		<div class="scrollBox group">
			<div>
				<p class="textTit">
					<a class="openKpi" href="javascript:openTreegridKpiDialog()">打开指标库...</a>
					<a:kpiCaculateColumn id="tgCaculateColumn" updateDatasetUiFunction="tgUpdataDatasetUI"></a:kpiCaculateColumn>
				</p>
			</div>
			<div class="scrollLeft">
				<div>
					<p class="textTit" title="请拖动维度到下方">下钻：</p>
					<div id="treeTableDrillColumnDiv"  class="scrollN">
							<ul>					
								
							</ul>
					</div>			
				</div>
				<div >
					<p class="textTit" title="请拖动维度到下方">维度：</p>
					<div id="treeTableDimColumnDiv" class="scrollN">
						<ul>
						</ul>
					</div>
				</div>
				
			</div>
			<div class="scrollRight">
					<p class="textTit" title="请拖动指标到下方">指标：</p>
					<div id="treeTableKpiColumnDiv" class="scrollN">
						<ul>
						</ul>
					</div>				
			</div>
			
		</div>
		<!-- //scrollBox--> 
	</div>
	<h4>表格元素设置</h4>
	<div class="ppInterArea">
		<dl>
			<!-- 没有用了20160126 start -->
			<dt style="display: none;">标题：</dt>
			<dd style="display: none;">
				<input type="text" id="treeTableTitle" name="treeTableTitle" class="wih_140" onblur="treeTableSetTitle(this.value)">&nbsp;
				<input type="checkbox" id="treeTableShowTitle" name="treeTableShowTitle" value="1"  class="checkN01">&nbsp;显示
				<input type="checkbox" class="checkN01"  id="treeTablePagi" name="treeTablePagi" value="" > 分页
			</dd>
			<!-- 没有用了20160126 end -->
			<dt id="treeTablePagiDt">操作：</dt>		
			<dd id="treeTablePagiDd">
				
				<input type="checkbox" class="checkN01"  id="treeTableExport" name="treeTableExport" value=""> 导出
			</dd>
		</dl>	
	</div>
</div>
<div id="treeTableKpiStoreDiv" class="none_dis"></div>
<a:kpiSelector id="treegridKpiSelector"></a:kpiSelector>
<script type="text/javascript">
<!--
	$(function(){
		$("#treeTableDrillColumnDiv").css("height",($(window).height()-255)*8/14+'px');
		$("#treeTableDrillColumnDiv>ul").css("min-height",($(window).height()-255-7)*8/14+'px');
		$("#treeTableKpiColumnDiv").css("height",($(window).height()-255)+'px');
		$("#treeTableKpiColumnDiv>ul").css("min-height",($(window).height()-255-4)+'px');
		$("#treeTableDimColumnDiv").css("height",(($(window).height()-255)*6/14-37)+'px');
		$("#treeTableDimColumnDiv>ul").css("min-height",(($(window).height()-255)*6/14-37-4)+'px');
		/*
		if($(window).height()>=643&&$(window).height()<775){//1366*768
			$("#treeTableDrillColumnDiv").css("height",'200px');
			$("#treeTableDrillColumnDiv>ul").css("mini-height",'200px');
			$("#treeTableKpiColumnDiv").css("height",'390px');
			$("#treeTableKpiColumnDiv>ul").css("mini-height",'390px');
			$("#treeTableDimColumnDiv").css("height",'152px');
			$("#treeTableDimColumnDiv>ul").css("mini-height",'152px');
		}else if($(window).height()>=775){//1440*900
			$("#treeTableDrillColumnDiv").css("height",'270px');
			$("#treeTableDrillColumnDiv>ul").css("mini-height",'270px');
			$("#treeTableKpiColumnDiv").css("height",'520px');
			$("#treeTableKpiColumnDiv>ul").css("mini-height",'520px');
			$("#treeTableDimColumnDiv").css("height",'212px');
			$("#treeTableDimColumnDiv>ul").css("mini-height",'212px');
			
		}
		*/
		/* var url = (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/getTreeData.e?treeType=all';
		$("#treeTableKpiTree").combotree({
			width:300,
			panelHeight:300,
			url: url,
			onSelect:treeTableShowKpiList,
			onExpand:function(node){
				var childrenNodes=$(this).tree("getChildren",node.target);
				if(childrenNodes!=null&&childrenNodes.length==0){
					$(this).tree("select",node.target);
				}
				
			},
			onCollapse:function(node){
				var selectNode=$(this).tree("getSelected");
				var childrenNodes=$(this).tree("getChildren",node.target);
				if(childrenNodes!=null&&childrenNodes.length==0){
					//$(this).tree("collapse",node.target);
					if(selectNode!=null){
						if(selectNode["id"]!=node["id"]){
							$(this).tree("select",node.target);
							$(this).tree("expand",node.target);
						}else{
							treeTableHideColSelectorWin();
						}
					}
				}
			},
			onLoadSuccess:function(node,data){
				if(node==null){
					var rootNodes=$(this).tree("getRoots");
					for(var a=0;a<rootNodes.length;a++){
						$(this).tree("expand",rootNodes[a].target);
					}
				}
			}
		}); */
		//是否显示标题
		$('#treeTableShowTitle').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	treeTableSetShowTitle();
		});
		
		//分页多选框
		$('#treeTablePagi').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	treeTableSetPagi();
		});	
		
		//导出多选框
		$('#treeTableExport').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	treeTableSetExport();
		});
		treeTableSwitchLType(StoreData.ltype);
	});
	
//刷新指标树和维度树，与指标库数据做同步
/* function treeTable_synchDimKpiTree(){
	var url = (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/getTreeData.e?treeType=all';
	$("#treeTableKpiTree").combotree({
		url: url+'&reload=true',
		onSelect:treeTableShowKpiList,
		onLoadSuccess:function(node,data){
			$('#treeTableKpiTree').combotree('setText', "请选择指标"); 
			var url = $('#treeTableKpiTree').combotree("tree").tree("options").url;
			if(url!=""&&url.indexOf("&reload=true")>-1){
				url = url.substring(0,url.indexOf("&reload=true"));
				$('#treeTableKpiTree').combotree("tree").tree({url:url});
			}
			if(node==null){
				var rootNodes=$(this).tree("getRoots");
				for(var a=0;a<rootNodes.length;a++){
					$(this).tree("expand",rootNodes[a].target);
				}
			}
		}
	});
} */
//-->
</script>
	