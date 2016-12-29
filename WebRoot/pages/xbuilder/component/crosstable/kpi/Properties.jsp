<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<div id="COMPONENT-TABLE" class="propertiesPane">
    
	<h4>指标设置</h4>
	<div class="ppInterArea">
	    <p class="distance_txt">
		    <a class="openKpi" href="javascript:openCrossTableKpiDialog()">打开指标库...</a>
		    <a:kpiCaculateColumn id="ctCaculateColumn" updateDatasetUiFunction="ctUpdataDatasetUI"></a:kpiCaculateColumn>
		</p>
		<!-- scrollBox--> 
		<div class="scrollBox group">
			<div class="scrollLeft">
				<div>
					<p class="textTit textTit2">
					<span title="请拖动维度到下方">行维度：</span>
     				      <a href="javascript:setCrossVerticalDimShowType('1');" class="grid_active" id="gridDisplay" >列表</a> 
 						  <a href="javascript:setCrossVerticalDimShowType('2');" class="tree_normal" id="treeDisplay">树形</a> 
 					</p>
					
					<div id="verticalDimColumnDiv"  class="scrollN columnArea heih_150">
							<ul class="min_heih_100"></ul>
					</div>			
				</div>
				<div>
					<p class="textTit" title="请拖动指标到下方">指标列：</p>
					<div id="tableKpiColumnDiv" class="scrollN columnArea heih_150">
						<ul class="min_heih_100"></ul>
					</div>				
			    </div>
			</div>
			<div class="scrollRight">
			    <div>
					<p class="textTit" title="请拖动维度到下方">列维度：</p>
					<div id="horizontalDimColumnDiv" class="scrollN columnArea heih_150">
						<ul class="min_heih_100"></ul>
					</div>
				</div>
			    <div>
					<p class="textTit" title="请拖动维度或指标到下方">排序列：</p>
					<div id="tableSortColumnDiv" class="scrollN columnArea heih_150">
						<ul class="min_heih_100"></ul>
					</div>
				</div>
			
		</div>
		<!-- //scrollBox--> 
		</div>
	</div>
	<h4>表格元素设置</h4>
	<div class="ppInterArea">
		<dl>
			<!-- 没有用了20160126 start -->
			<dt style="display: none;">标题：</dt>
			<dd style="display: none;">
				<input type="text" id="tableTitle" style="width:120px;" name="tableTitle" onblur="setCrossTableTitle(this.value)">
				<input type="checkbox" id="tableShowTitle" name="tableShowTitle" value="1"  class="checkN01">&nbsp;显示
			</dd>
			<!-- 没有用了20160126 end -->
			<dt id="tablePagiDt">分页：</dt>		
			<dd id="tablePagiDd">
				<input type="checkbox" class="checkN01"  id="tablePagi" name="tablePagi" value="" >是，每页显示
				<input type="text" id="tablePagiNum" name="tablePagiNum" value="10" class="easyui-numberbox wih_60" data-options="min:1" onblur="tableSetPagiNum(this.value)">
				条记录
			</dd>
			<dt id="tableExportDt">导出：</dt>		
			<dd id="tableExportDd">
				<input type="checkbox" class="checkN01"  id="tableExport" name="tableExport" value="">是
			</dd>
			<!-- <dt>锁定列：</dt>
			<dd><input type="checkbox" id="tableColLock" name="tableColLock" value="1"> 前 <input type="text" name="tableColLockNum" id="tableColLockNum" size="2" style="width:60px;"  class="easyui-numberbox" data-options="min:1,disabled:true" onblur="setCrossTableColLockNum(this.value)"></dd> -->
			<dt>合计：</dt>
			<dd>
			   <input type="checkbox" class="checkN01"  id="tableRowSum" name="tableSum" value="1">
			   <input type="text" id="colSumName" name="" style="width: 80px" value="列合计" onblur="setColSumName(this.value)"/>&nbsp;&nbsp;
			   <input type="checkbox" class="checkN01"  id="tableColumnSum" name="tableSum" value="2">
			   <input type="text" id="rowSumName" name="" style="width: 80px" value="行合计" onblur="setRowSumName(this.value)"/>
			</dd>
			<dt>行合计位置：</dt>
			<dd>
			   <input type="radio" id="tableRowSumPositionTop" name="rowSumPosition" value="top" checked="checked"><label for="tableRowSumPositionTop">顶部</label>
			   <input type="radio" id="tableRowSumPositionBottom" name="rowSumPosition" value="bottom"><label for="tableRowSumPositionBottom">底部</label>&nbsp;&nbsp;
			</dd>
		</dl>	
	</div>
</div>

<a:kpiSelector id="crossTableKpiSelector"></a:kpiSelector>

<script type="text/javascript">
<!--
	$(function(){
		if(($(window).height()-290)/2>150){
			$(".columnArea").css("height",(($(window).height()-290)/2)+"px");
		}
		//是否显示标题
		$('#tableShowTitle').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	setCrossTableShowTitle();
		});
		//导出多选框
		$('#tableExport').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	setCrossTableExport();
		});
		
		//分页多选框
		$('#tablePagi').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	setCrossTablePagination();
		});
		
		$('#tableRowSum').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	setTimeout(setCrossTableSumType,200);
		});
		
		$('#tableColumnSum').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
			setTimeout(setCrossTableSumType,200);
		});
		
		$("input[name='rowSumPosition']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
			crossTableSetRowSumPosition(this.value)
		});
		$("input[name='rowSumPosition']").iCheck('disable');
		crossTableSwitchLType(StoreData.ltype);
		initCrossDimColumnDiv('horizontalDimColumnDiv','kpi');//初始化横向维度区域
		initCrossDimColumnDiv('verticalDimColumnDiv','kpi');//初始化纵向维度区域
		initCrossKpiColumnDiv('kpi');//初始化指标区域
		initCrossSortColumnDiv('kpi');//初始化排序区域
	});
	

//-->
</script>

