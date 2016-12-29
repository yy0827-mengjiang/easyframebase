<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<div id="COMPONENT-TABLE" class="propertiesPane">
	<!-- <input type="button" value="还原" onclick="tableComponentEditButton()"> -->
	<h4>指标设置</h4>
	<div class="ppInterArea">
		<!-- scrollBox--> 
		<div class="scrollBox group">
			<div>
				<p>
					<a class="openKpi" href="javascript:openTableKpiDialog()">&lt;&nbsp;&nbsp;打开指标库...</a>
					<a:kpiCaculateColumn id="dgCaculateColumn" updateDatasetUiFunction="dgUpdataDatasetUI"></a:kpiCaculateColumn>
				</p>
			</div>
			<div class="scrollLeft">
				<div >
					<p class="textTit" title="请拖动维度到下方">维度：</p>
					<div id="tableDimColumnDiv" class="scrollN">
						<ul>
						</ul>
					</div>
				</div>
				<div>
					<p class="textTit"  title="请拖动维度或指标到下方">默认排序列：</p>
					<div id="tableSortColumnDiv"  class="scrollN">
							<ul>					
								
							</ul>
					</div>			
				</div>
			</div>
			<div class="scrollRight">
					<p class="textTit" title="请拖动指标到下方">指标：</p>
					<div id="tableKpiColumnDiv" class="scrollN">
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
				<input type="text" id="tableTitle" name="tableTitle" class="wih_140" onblur="tableSetTitle(this.value)">&nbsp;
				<input type="checkbox" id="tableShowTitle" name="tableShowTitle" value="1"  class="checkN01">&nbsp;显示
			</dd>
			<!-- 没有用了20160126 end -->
			
			<dt id="tablePagiDt">分页：</dt>		
			<dd id="tablePagiDd">
				<input type="checkbox" class="checkN01"  id="tablePagi" name="tablePagi" value="" >是，每页显示
				<input type="text" id="tablePagiNum" name="tablePagiNum" value="" class="easyui-numberbox wih_60" data-options="min:1,onChange:function(nv,ov){tableSetPagiNum(nv)}">
				条记录
			</dd>
			<dt id="tableExportDt">导出：</dt>		
			<dd id="tableExportDd">
				<input type="checkbox" class="checkN01"  id="tableExport" name=""tableExport"" value="">是
			</dd>
			<dt>锁定列：</dt>
			<dd><input type="checkbox" id="tableColLock" name="tableColLock" value="1"> 前 <input type="text" name="tableColLockNum" id="tableColLockNum" size="2" style="width:60px;"  class="easyui-numberbox" data-options="min:1,disabled:true,onChange:function(nv,ov){tableSetColLockNum(nv)}"></dd>
			<dt>行小计：</dt>
			<dd>
				<input type="checkbox" id="tableShowRowTotal" name="tableShowRowTotal" value="1"  class="checkN01">&nbsp;显示
			</dd>
			<dt>合计：</dt>
			<dd>
				<input type="checkbox" id="tableShowTotal" name="tableShowTotal" value="1"  class="checkN01">&nbsp;显示的位置为：
				<select class="easyui-combobox wih_65" id="tableShowTotalPosition" data-options="disabled:true,editable:false,panelHeight:60,onSelect:tableSetShowTotalPosition"><!-- onSelect:column_fun_SetOrd -->
						<option value="top">顶部</option>
						<option value="bottom">底部</option>
				</select> 
			</dd>
			<dt></dt>
			<dd>显示的合计名称为<input type="text" name="tableShowTotalName" id="tableShowTotalName" value="合计" class="wih_60" disabled="disabled" onblur="tableSetShowTotalName(this.value)"></dd>
	
			<dt >指标聚合：</dt>
			<dd none">
				<input type="checkbox" id="tableSetNum" name="tableSetNum" value="1"  class="checkN01">&nbsp;是
			</dd>
		</dl>	
	</div>
</div>
<div id="tableKpiStoreDiv" class="none_dis"></div>
<a:kpiSelector id="tableKpiSelector"></a:kpiSelector>
<script type="text/javascript">
<!--
	$(function(){
		$("#tableDimColumnDiv").css("height",($(window).height()-255)*8/14+'px');
		$("#tableDimColumnDiv>ul").css("min-height",($(window).height()-255-7)*8/14+'px');
		$("#tableKpiColumnDiv").css("height",($(window).height()-255)+'px');
		$("#tableKpiColumnDiv>ul").css("min-height",($(window).height()-255-4)+'px');
		$("#tableSortColumnDiv").css("height",(($(window).height()-255)*6/14-37)+'px');
		$("#tableSortColumnDiv>ul").css("min-height",(($(window).height()-255)*6/14-37-4)+'px');
		/*
		if($(window).height()>=643&&$(window).height()<775){//1366*768
			$("#tableDimColumnDiv").css("height",'200px');
			$("#tableDimColumnDiv>ul").css("min-height",'200px');
			$("#tableKpiColumnDiv").css("height",'390px');
			$("#tableKpiColumnDiv>ul").css("min-height",'390px');
			$("#tableSortColumnDiv").css("height",'152px');
			$("#tableSortColumnDiv>ul").css("min-height",'152px');
		}else if($(window).height()>=775){//1440*900
			$("#tableDimColumnDiv").css("height",'270px');
			$("#tableDimColumnDiv>ul").css("min-height",'270px');
			$("#tableKpiColumnDiv").css("height",'520px');
			$("#tableKpiColumnDiv>ul").css("min-height",'520px');
			$("#tableSortColumnDiv").css("height",'212px');
			$("#tableSortColumnDiv>ul").css("min-height",'212px');
			
		}
		*/
		
		/* var url = (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/getTreeData.e?treeType=all';
		$("#tableKpiTree").combotree({
			width:300,
			panelHeight:300,
			url: url,
			onSelect:tableShowKpiList,
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
							tableHideColSelectorWin();
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
		$('#tableShowTitle').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableSetShowTitle();
		});
		
		//指标聚合多选框
		$('#tableSetNum').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableSetSetSum();
		});
		
		//是否显示行小计
		$('#tableShowRowTotal').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableSetShowRowTotal();
		});
		
		//是否显示合计
		$('#tableShowTotal').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableSetShowTotal();
		});
		
		//分页多选框
		$('#tablePagi').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableSetPagi();
		});
		//导出多选框
		$('#tableExport').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableSetExport();
		});
		
		//锁定列多选框
		$('#tableColLock').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableSetColLock();
		});
		tableSwitchLType(StoreData.ltype);
		
	});
//-->
		//刷新指标树和维度树，与指标库数据做同步
		/* function table_synchDimKpiTree(){
			var url = (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/getTreeData.e?treeType=all';
			$("#tableKpiTree").combotree({
				url: url+'&reload=true',
				onSelect:tableShowKpiList,
				onLoadSuccess:function(node,data){
					$('#tableKpiTree').combotree('setText', "请选择指标"); 
					var url = $('#tableKpiTree').combotree("tree").tree("options").url;
					if(url!=""&&url.indexOf("&reload=true")>-1){
						url = url.substring(0,url.indexOf("&reload=true"));
						$('#tableKpiTree').combotree("tree").tree({url:url});
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
</script>
	