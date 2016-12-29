<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<div id="COMPONENT-TABLE" class="propertiesPane">

	<h4>指标设置</h4>
	<div class="ppInterArea">
	    <p class="distance_txt">
	    	<input id="tableDataSource"  name="tableDataSource" value="请选择数据集" class="easyui-combobox" 
	          data-options="url:appBase+'/getAllDataSourceJsonX.e?report_id=${param.report_id }',valueField:'id',textField:'text',multiple:false,panelHeight:60,width:212,editable:false,onSelect:setCrossDataSource" />
	          <a:caculateColumn dataSetCombId="tableDataSource" id="crossTableCaculateColumn" updateDatasetUiFunction="crossTableUpdataDatasetUI"></a:caculateColumn>
	    </p>
		<div class="scrollBox group">
			<div>
				<div id="tableColumnDiv" class="scrollN" >
					<ul>
					
					</ul>
				</div>
			</div>
			<div class="scrollLeft">
				<div>
					<p class="textTit textTit2">
					
					<span title="请拖动编码字段或描述字段到下方">行维度：</span>
     				      <a href="javascript:setCrossVerticalDimShowType('1');" class="grid_active" id="gridDisplay" >列表</a> 
 						  <a href="javascript:setCrossVerticalDimShowType('2');" class="tree_normal" id="treeDisplay">树形</a> 
 					</p>
					
					<div id="verticalDimColumnDiv"  class="scrollN columnArea heih_100">
							<ul class="min_heih_100"></ul>
					</div>			
				</div>
				<div>
					<p class="textTit"  title="请拖动指标字段到下方">指标列：</p>
					<div id="tableKpiColumnDiv" class="scrollN columnArea heih_100">
						<ul class="min_heih_100"></ul>
					</div>				
			    </div>
			</div>
			<div class="scrollRight">
			    <div>
					<p class="textTit" title="请拖动描述字段到下方">列维度：</p>
					<div id="horizontalDimColumnDiv" class="scrollN columnArea heih_100">
						<ul class="min_heih_100"></ul>
					</div>
				</div>
			    <div>
					<p class="textTit" title="请拖动任意字段到下方">排序列：</p>
					<div id="tableSortColumnDiv" class="scrollN columnArea heih_100">
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
				<input type="text" id="tableTitle" class="wih_140" name="tableTitle" onblur="setCrossTableTitle(this.value)">&nbsp;
				<input type="checkbox" id="tableShowTitle" name="tableShowTitle" value="1"  class="checkN01">&nbsp;显示
			</dd>
			<!-- 没有用了20160126 end -->

			<dt id="tablePagiDt">分页：</dt>		
			<dd id="tablePagiDd">
				<input type="checkbox" class="checkN01"  id="tablePagi" name="tablePagi" value="" >是，每页显示
				<input type="text" id="tablePagiNum" name="tablePagiNum" value="10" class="easyui-numberbox wih_60" data-options="min:1,onChange:function(nv,ov){tableSetPagiNum(nv)}"/>
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
			   <input type="text" id="colSumName" name="" style="width: 60px" value="列合计" onblur="setColSumName(this.value)"/>&nbsp;&nbsp;
			   <input type="checkbox" class="checkN01"  id="tableColumnSum" name="tableSum" value="2">
			   <input type="text" id="rowSumName" name="" style="width: 60px" value="行合计" onblur="setRowSumName(this.value)"/>
			</dd>
			<dt>行合计位置：</dt>
			<dd>
			   <input type="radio" id="tableRowSumPositionTop" name="rowSumPosition" value="top" checked="checked"><label for="tableRowSumPositionTop">顶部</label>
			   <input type="radio" id="tableRowSumPositionBottom" name="rowSumPosition" value="bottom"><label for="tableRowSumPositionBottom">底部</label>&nbsp;&nbsp;
			</dd>
		</dl>	
	</div>
</div>

<script type="text/javascript">
	$(function(){
		if(($(window).height()-460)/2>100){
			$(".columnArea").css("height",(($(window).height()-460)/2)+"px");
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
		
		//锁定列多选框
		$('#tableColLock').iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	setCrossTableColLock();
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
		
	});
</script>
