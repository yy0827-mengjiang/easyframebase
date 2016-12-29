<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<div class="propertiesPane">
	<h4>单元格格式</h4>
	<div class="ppInterArea">
		<dl>
			<dt>宽度:</dt>
	   		<dd>
	   			<input type="text" style="width:204px;" id="treeTableDataWidth" name="treeTableDataWidth" value="" class="easyui-numberbox" data-options="min:1,onChange:function(nv,ov){treeTableDataSetWidth(nv)}"/>
	   		</dd>
	        <dt>类型:</dt>
	   		<dd>
				<input type="radio" id="treeTableDataTypeCommon" name="treeTableDataType" value="common"/><label for="treeTableDataTypeCommon">常规</label>
				<input type="radio" id="treeTableDataTypeNumber" name="treeTableDataType" value="number"/><label for="treeTableDataTypeNumber">数值</label>
				<input type="radio" id="treeTableDataTypePercent" name="treeTableDataType" value="percent"/><label for="treeTableDataTypePercent">百分数</label>
			</dd>
			<dt>小数位:</dt>
	   		<dd>
	   			<p><input type="text" id="treeTableDataNumberStep" style="width:204px;" name="treeTableDataNumberStep" value="0" class="easyui-numberbox" data-options="min:0,onChange:function(nv,ov){treeTableDataSetNumberStep(nv)}"/></p>
	   			<input type="checkbox" id="treeTableDataThousand" name="treeTableDataThousand"/><label for="treeTableDataThousand">使用千分符(,)</label>
	   		</dd>
	   		<dt>对齐:</dt>
	   		<dd>
				<p>
					<span id="treeTableDataAlignLeft" name="treeTableDataAlign" class="positionIcon positionLeft"  onclick="treeTableDataSetAlign('left');"></span>
					<span id="treeTableDataAlignCenter" name="treeTableDataAlign" class="positionIcon positionRight"  onclick="treeTableDataSetAlign('center');"></span>
					<span id="treeTableDataAlignRight" name="treeTableDataAlign" class="positionIcon positionRight" onclick="treeTableDataSetAlign('right');"></span>
				</p>
				<!-- <p id="treeTableDataRowMergePTag"><input type="checkbox" id="treeTableDataRowMerge" name="treeTableDataRowMerge"/><label for="treeTableDataRowMerge">行间相邻相同数据合并</label></p> -->
	   		</dd>
	   		<dt>边界设置:</dt>
	   		<dd class="blockDdAuto"><input type="checkbox" id="treeTableDataBorderSetFlag" name="treeTableDataBorderSetFlag" /><label for="treeTableDataBorderSetFlag">启用</label> </dd>
	   		<dt>边界值:</dt>
	   		<dd><input type="text" style="width:204px;" id="treeTableDataBorderValue" name="treeTableDataBorderValue" value="" class="easyui-numberbox" data-options="onChange:function(nv,ov){treeTableDataSetBorderValue(nv)}"/></dd>
	   		<dd class="blockDdAuto">
		   		<p style="margin-left:-4px;">大于<input type="text" id="treeTableDataBorderGtColor" name="treeTableDataBorderGtColor" value="#7bd101"/>小于<input type="text" id="treeTableDataBorderLtColor" name="treeTableDataBorderLtColor" value="#ef0e1e"/></p>
		   		<p><input type="checkbox" id="treeTableDataBorderShowUpDown" name="treeTableDataBorderShowUpDown"/><label for="treeTableDataBorderShowUpDown">显示升降序符号</label></p>
	   		</dd>
	   		
	   	</dl>
	</div>
   	<div id="treeTableDataEventDiv">
		<h4>动作</h4>
		<div class="ppInterArea">
			<dl>
				<dt></dt>
				<dd>
					<input type="radio" id="treeTableDataEventRadioNone" name="treeTableDataEvent" value="none" checked="checked" /><label for="treeTableDataEventRadioNone">无</label>
					<input type="radio" id="treeTableDataEventRadioLink" name="treeTableDataEvent" value="link" /><label for="treeTableDataEventRadioLink">链接</label>
					<input type="radio" id="treeTableDataEventRadioActive" name="treeTableDataEvent" value="active" /><label for="treeTableDataEventRadioActive">联动</label>
				
				</dd>
			</dl>
		
			<div id="treeTableDataEventLinkDiv" style="display: none;">
				<dl>
					<dt>报表：</dt>
					<dd>
						<input type="hidden" id="treeTableDataEventLink" name="treeTableDataEventLink" value=""/>
						<input type="text" id="treeTableDataEventLinkShow" name="treeTableDataEventLinkShow" value="" readonly="readonly" style="width: 140px"/>
						<input type="button" class="set_button" value="选择" onclick="treeTableDataOpenEventLinkDialog()"/>
					</dd>
					<dt>参数：</dt>
					<dd>
						<input type="text" id="treeTableDataEventLinkParamShow" name="treeTableDataEventLinkShow" value="" readonly="readonly" style="width: 140px"/>
						<input type="button" class="set_button" value="设置" onclick="treeTableDataOpenEventLinkParamDialog()"/>
					</dd>
				</dl>	
			</div>
			<div id="treeTableDataEventActiveDiv" style="display: none;">
				<dl>
					<!-- 
					<dt></dt>
					<dd>
						<p>
							<span><input type="checkbox" id="treeTableDataEventActiveCheckbox" name="treeTableDataEventActiveCheckbox" value="4569ae07_866d_4074_8f61_4c7bacdc3f38" eventId="4bcdf5d7_79fe_45fc_8658_3c77a882893a"/><strong class="eventActive_COLUMN">柱图</strong></span>
							<span><input type="button" value="设置" class="eventActiveSetButtonClass" name="treeTableDataEventActiveButton" onclick="treeTableDataOpenEventActiveDialog('4569ae07_866d_4074_8f61_4c7bacdc3f38','4bcdf5d7_79fe_45fc_8658_3c77a882893a')" disabled="disabled"/></span>
						</p>
					</dd>
					 -->
				</dl>	
			</div>
		</div>
	</div>
	
	
</div>


<div id="treeTableDataEventLinkDialog" class="easyui-dialog" title="选择页面" data-options="closed:true,top:30,modal:true,onClose:function(){showToolsPanel();}" style="width:1100px;height:600px;padding-top:10px;">
	<div id="treeTableDataEventLinkDialogBar"class="contents-head">
		<div class="search-area textLeft">
			    报表ID：<input type="text" id="treeTableDataEventLinkReportId" name="treeTableDataEventLinkReportId" style="width:200px">
				报表名称：<input type="text" id="treeTableDataEventLinkReportName" name="treeTableDataEventLinkReportName" style="width:200px">
				<a href="javascript:void(0);"  onclick="treeTableDataEventLinkReportQuery()" class="easyui-linkbutton">查询</a>	
		</div>
	</div>
	<c:datagrid id="treeTableDataEventLinkReportDatagrid" url="pages/xbuilder/component/treegrid/Action.jsp?eaction=DataReportList" pageSize="15"  style="width:auto;height:auto"  download="true" nowrap="false" toolbar="#treeTableDataEventLinkDialogBar">
		<thead>
			<tr>
				<th field="ID" width="45%">报表ID</th>
				<th field="NAME" width="45%">报表名称</th>
				<th field="cz" width="10%"  formatter="treeTableDataEventLinkReportFormatter">操作</th>
			</tr>
		</thead>
	</c:datagrid>
</div>


<div id="treeTableDataEventLinkParamDialog" class="easyui-dialog" title="设置参数" data-options="closed:true,top:30,modal:true,onClose:function(){showToolsPanel();}" style="width:600px;height:400px;">
	<div data-options="region:'north'" style="height:88%">
		<div style="text-align: center;">
			<treeTable id="treeTableDataEventLinkParamtreeTable">
				<!-- <tr>
					<td width="50%">参数名:&nbsp;<input type="text" id="" name="treeTableDataEventLinkParamName" style="width:120px;" value="" readonly="readonly"></td>
					<td>对应数据列:&nbsp;<input name="treeTableDataEventLinkParamValue" value="请选择"  style="width:120px"></td>
				</tr>
				 -->
			</treeTable> 
		</div>
	</div>
	<div data-options="region:'center'">
		<div id="treeTableDataEventLinkParamDialogButtonDiv">
			<span style="color: #f00" id="treeTableDataEventLinkParamCareSpan">打开时注入</span><a href="javascript:void(0);" class="easyui-linkbutton"   onclick="treeTableDataOpenEventLinkParamCommit();">完 成</a>
		</div>
	</div>
	
	
</div>


<div id="treeTableDataEventActiveParamDialog" class="easyui-dialog" title="设置参数" data-options="closed:true,top:180,modal:true,onClose:function(){showToolsPanel();}" style="width:600px;height:400px;">
	<div data-options="region:'north'" style="height:88%">
		<div style="text-align: center;">
			<treeTable id="treeTableDataEventActiveParamtreeTable">
				 <!-- 
				 <tr>
					<td width="50%">参数名:&nbsp;<input type="text" id="" name="treeTableDataEventActiveParamName" style="width:120px;" value="" readonly="readonly"></td>
					<td>对应数据列:&nbsp;<input name="treeTableDataEventActiveParamValue" value="请选择"  style="width:120px"></td>
				</tr>
				 -->
			</treeTable> 
		</div>
	</div>
	<div data-options="region:'center'">
		<div id="treeTableDataEventActiveParamDialogButtonDiv">
			<span style="color: #f00" id="treeTableDataEventActiveParamCareSpan">打开时注入</span><a href="javascript:void(0);" class="easyui-linkbutton"   onclick="treeTableDataOpenEventActiveParamCommit();">完 成</a>
		</div>
	</div>
	
	
</div>
	
	
	<script type="text/javascript">

	$(function(){
		$("#treeTableDataBorderGtColor").spectrum({
			showPalette: true,
			preferredFormat: "hex",
			showInput: true,
			palette: [
		        ['#cc0000', '#ff2845', '#e000fc'],
		        ['#fc0088', '#ff4200', '#ffa200'],
		        ['#00bedc', '#00d744', '#acfd00'],
		        ['#e5dc0c', '#006be3', '#00bedc']
		    ],
			change: function(color) {
				treeTableDataSetBorderGtColor(color);
			}
		});
		$("#treeTableDataBorderLtColor").spectrum({
			showPalette: true,
			preferredFormat: "hex",
			showInput: true,
			palette: [
		        ['#cc0000', '#ff2845', '#e000fc'],
		        ['#fc0088', '#ff4200', '#ffa200'],
		        ['#00bedc', '#00d744', '#acfd00'],
		        ['#e5dc0c', '#006be3', '#00bedc']
		    ],
			change: function(color) {
				treeTableDataSetBorderLtColor(color);
			}
		});
		
		//数据类型单选框
		$("input[name='treeTableDataType']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	treeTableDataSetType(this.value);
		});
		
		//千分符多选框
		$("#treeTableDataThousand").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	treeTableDataSetThousand();
		});
		
		//行间相邻相同数据合并多选框
		$("#treeTableDataRowMerge").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	treeTableDataSetRowMerge();
		});
		
		//设置边界 多选框
		$("#treeTableDataBorderSetFlag").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	treeTableDataSetBorderSetFlag();
		});
		
		//显示上下箭头 多选框
		$("#treeTableDataBorderShowUpDown").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	treeTableDataSetBorderShowUpDown();
		});
		
		
		//动作类型多选框
		$("input[name='treeTableDataEvent']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	treeTableDataSetEvent(this.value)
		});
		
	});
	</script>