<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<div id="COMPONENT-TREETABLE" class="propertiesPane">

	<!-- <input type="button" value="还原" onclick="treeTableComponentEditButton()"> -->
	<h4>指标设置</h4>
	<div class="ppInterArea">
		<div class="scrollBox group">
			<div>
				<p class="textTit">
					<input type="checkbox" id="treeTableSelectAllCol" name="treeTableSelectAllCol" value="1"  class="checkN01" title="将全部指标置入拖拽区域">
					<input  id="treeTableDataSource"  name="treeTableDataSource" value="请选择数据集" class="easyui-combobox" data-options="url:appBase+'/getAllDataSourceJsonX.e?report_id=${param.report_id }',valueField:'id',textField:'text',multiple:false,panelHeight:160,width:212,editable:false,onSelect:treeTableSetDataSource">	
				    <a:caculateColumn dataSetCombId="treeTableDataSource" id="treeTableCaculateColumn" updateDatasetUiFunction="treeTableUpdataDatasetUI"></a:caculateColumn>
				</p>
				<div id="treeTableColumnDiv" class="scrollN" >
					<ul>
					
					</ul>
				</div>
			</div>
			<div class="scrollLeft">
				<div>
					<p class="textTit" title="请拖动描述字段到下方">下钻：</p>
					<div id="treeTableDrillColumnDiv"  class="scrollN">
							<ul>					
								
							</ul>
					</div>			
				</div>
				<div >
					<p class="textTit" title="请拖动编码字段或描述字段到下方">维度：</p>
					<div id="treeTableDimColumnDiv" class="scrollN" style="height:60px; ">
						<ul>
						</ul>
					</div>
				</div>
			</div>
			<div class="scrollRight">
					<p class="textTit" title="请拖动指标字段到下方">指标：</p>
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
				<input type="text" id="treeTableTitle" class="wih_140" name="treeTableTitle" onblur="treeTableSetTitle(this.value)">&nbsp;
				<input type="checkbox" id="treeTableShowTitle" name="treeTableShowTitle" value="1"  class="checkN01">&nbsp;显示
				<input type="checkbox" class="checkN01"  id="treeTablePagi" name="treeTablePagi" value="" > 分页
			</dd>
			<!-- 没有用了20160126 end -->
			<dt id="treeTablePagiDt">操作：</dt>		
			<dd id="treeTablePagiDd">
				<input type="checkbox" class="checkN01"  id="treeTableExport" name=""treeTableExport"" value=""> 导出
			</dd>
		</dl>	
	</div>
</div>

<script type="text/javascript">
<!--
	$(function(){
		$("#treeTableDrillColumnDiv").css("height",($(window).height()-415)*8/14+'px');
		$("#treeTableDrillColumnDiv>ul").css("min-height",($(window).height()-415-7)*8/14+'px');
		$("#treeTableKpiColumnDiv").css("height",($(window).height()-415)+'px');
		$("#treeTableKpiColumnDiv>ul").css("min-height",($(window).height()-415-4)+'px');
		$("#treeTableDimColumnDiv").css("height",(($(window).height()-415)*6/14-37)+'px');
		$("#treeTableDimColumnDiv>ul").css("min-height",(($(window).height()-415)*6/14-37-4)+'px');
		/*
		if($(window).height()>=643&&$(window).height()<775){//1366*768
			$("#treeTableDrillColumnDiv").css("height",'132px');
			$("#treeTableDrillColumnDiv>ul").css("min-height",'132px');
			$("#treeTableKpiColumnDiv").css("height",'230px');
			$("#treeTableKpiColumnDiv>ul").css("min-height",'230px');
			$("#treeTableDimColumnDiv").css("height",'60px');
			$("#treeTableDimColumnDiv>ul").css("min-height",'60px');
		}else if($(window).height()>=775){//1440*900
			$("#treeTableDrillColumnDiv").css("height",'212px');
			$("#treeTableDrillColumnDiv>ul").css("min-height",'212px');
			$("#treeTableKpiColumnDiv").css("height",'360px');
			$("#treeTableKpiColumnDiv>ul").css("min-height",'360px');
			$("#treeTableDimColumnDiv").css("height",'110px');
			$("#treeTableDimColumnDiv>ul").css("min-height",'110px');
			
		}
		*/
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
		
		//将全部指标置入拖拽区域 多选框
		$("#treeTableSelectAllCol").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	treeTableCheckAllTreeTableColumn();
		});
		
		treeTableSwitchLType(StoreData.ltype);
	});
//-->
</script>
