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
	   			<input type="text" id="tableDataWidth" name="tableDataWidth" value="" class="easyui-numberbox wih_204" data-options="min:1,onChange:function(nv,ov){tableDataSetWidth(nv)}" />
	   		</dd>
	        <dt>类型:</dt>
	   		<dd>
				<input type="radio" id="tableDataTypeCommon" name="tableDataType" value="common"/><label for="tableDataTypeCommon">常规</label>
				<input type="radio" id="tableDataTypeNumber" name="tableDataType" value="number"/><label for="tableDataTypeNumber">数值</label>
				<input type="radio" id="tableDataTypePercent" name="tableDataType" value="percent"/><label for="tableDataTypePercent">百分数</label>
			</dd>
			<dt>小数位:</dt>
	   		<dd>
	   			<p><input type="text" id="tableDataNumberStep" name="tableDataNumberStep" value="0" class="easyui-numberbox wih_204" data-options="min:0,onChange:function(nv,ov){tableDataSetNumberStep(nv)}"/></p>
	   			<input type="checkbox" id="tableDataThousand" name="tableDataThousand"/><label for="tableDataThousand">使用千分符(,)</label>
	   		</dd>
	   		<dt>对齐:</dt>
	   		<dd>
				<p>
					<span id="tableDataAlignLeft" name="tableDataAlign" class="positionIcon positionLeft"  onclick="tableDataSetAlign('left');"></span>
					<span id="tableDataAlignCenter" name="tableDataAlign" class="positionIcon positionRight"  onclick="tableDataSetAlign('center');"></span>
					<span id="tableDataAlignRight" name="tableDataAlign" class="positionIcon positionRight" onclick="tableDataSetAlign('right');"></span>
				</p>
				<p id="tableDataRowMergePTag"><input type="checkbox" id="tableDataRowMerge" name="tableDataRowMerge"/><label for="tableDataRowMerge">行间相邻相同数据合并</label></p>
	   		</dd>
	   		<dt>边界设置:</dt>
	   		<dd class="blockDdAuto"><input type="checkbox" id="tableDataBorderSetFlag" name="tableDataBorderSetFlag" /><label for="tableDataBorderSetFlag">启用</label> </dd>
	   		<dt>边界值:</dt>
	   		<dd><input type="text" id="tableDataBorderValue" name="tableDataBorderValue" value="" class="easyui-numberbox wih_204" data-options="onChange:function(nv,ov){tableDataSetBorderValue(nv)}"/></dd>
	   		<dd class="blockDdAuto">
		   		<p class="pro_data">大于<input type="text" id="tableDataBorderGtColor" name="tableDataBorderGtColor" value="#5cd18b"/>小于<input type="text" id="tableDataBorderLtColor" name="tableDataBorderLtColor" value="#d34737"/></p>
		   		<p><input type="checkbox" id="tableDataBorderShowUpDown" name="tableDataBorderShowUpDown"/><label for="tableDataBorderShowUpDown">显示升降序符号</label></p>
	   		</dd>
	   		
	   	</dl>
	</div>
   	<div id="tableDataEventDiv">
		<h4>动作</h4>
		<div class="ppInterArea">
			<dl>
				<dt></dt>
				<dd>
					<input type="radio" id="tableDataEventRadioNone" name="tableDataEvent" value="none" checked="checked" /><label for="tableDataEventRadioNone">无</label>
					<input type="radio" id="tableDataEventRadioLink" name="tableDataEvent" value="link" /><label for="tableDataEventRadioLink">链接</label>
					<input type="radio" id="tableDataEventRadioActive" name="tableDataEvent" value="active" /><label for="tableDataEventRadioActive">联动</label>
				
				</dd>
			</dl>
		
			<div id="tableDataEventLinkDiv" class="none_dis">
				<dl>
					<dt>报表：</dt>
					<dd>
						<input type="hidden" id="tableDataEventLink" name="tableDataEventLink" value=""/>
						<input type="text" id="tableDataEventLinkShow" name="tableDataEventLinkShow" value="" readonly="readonly" style="width:130px;" />
						<!-- <input type="button" class="set_button" value="选择" onclick="tableDataOpenEventLinkDialog()"/> -->
						<a href="javascript:void(0)" class="easyui-linkbutton" onclick="tableDataOpenEventLinkDialog()">选择</a>
					</dd>
					<dt>参数：</dt>
					<dd>
						<input type="text" id="tableDataEventLinkParamShow" name="tableDataEventLinkShow" value="" readonly="readonly" style="width:130px;" />
						<!-- <input type="button" class="set_button" value="设置" onclick="tableDataOpenEventLinkParamDialog()"/> -->
						<a href="javascript:void(0)" class="easyui-linkbutton" onclick="tableDataOpenEventLinkParamDialog()">设置</a>
					</dd>
				</dl>	
			</div>
			<div id="tableDataEventActiveDiv" class="none_dis">
				<dl>
				</dl>	
			</div>
		</div>
	</div>
	
	
</div>


<div id="tableDataEventLinkDialog" class="easyui-dialog" title="选择页面" data-options="closed:true,top:30,modal:true,onClose:function(){showToolsPanel();}" style="width:1100px;height:600px;padding-top:10px;">
	<div id="tableDataEventLinkDialogBar" class="contents-head">
		<div class="search-area textLeft">
				报表ID：<input type="text" id="tableDataEventLinkReportId" name="tableDataEventLinkReportId" style="width:200px">
				报表名称：<input type="text" id="tableDataEventLinkReportName" name="tableDataEventLinkReportName" style="width:200px">
				<a href="javascript:void(0);"  onclick="tableDataEventLinkReportQuery()" class="easyui-linkbutton">查询</a>
			</div>
	</div>
	<c:datagrid id="tableDataEventLinkReportDatagrid" url="pages/xbuilder/component/datagrid/Action.jsp?eaction=DataReportList" pageSize="15"  style="width:auto;height:auto"  download="true" nowrap="false" toolbar="#tableDataEventLinkDialogBar">
		<thead>
			<tr>
				<th field="ID" width="45%">报表ID</th>
				<th field="NAME" width="45%">报表名称</th>
				<th field="cz" width="10%"  formatter="tableDataEventLinkReportFormatter">操作</th>
			</tr>
		</thead>
	</c:datagrid>
</div>


<div id="tableDataEventLinkParamDialog" class="easyui-dialog" title="设置参数" data-options="closed:true,top:200,modal:true,onClose:function(){showToolsPanel();}" style="width:600px;height:420px;">
	<div class="easyui-layout"  data-options="fit:true">
		<div data-options="region:'center', border:false">
		<div class="txt_centern">
			<table id="tableDataEventLinkParamTable" class="pageTable">
				<!-- <tr>
					<td width="50%">参数名:&nbsp;<input type="text" id="" name="tableDataEventLinkParamName" style="width:120px;" value="" readonly="readonly"></td>
					<td>对应数据列:&nbsp;<input name="tableDataEventLinkParamValue" value="请选择"  style="width:120px"></td>
				</tr>
				 -->
			</table> 
		</div>
	</div>
	<div data-options="region:'south', border:false" style=" height:60px;padding:10px 0 0 10px;">
		<div id="tableDataEventLinkParamDialogButtonDiv">
			<span class="easyui-font-red" id="tableDataEventLinkParamCareSpan">打开时注入</span><a href="javascript:void(0);" class="easyui-linkbutton"   onclick="tableDataOpenEventLinkParamCommit();">完 成</a>
		</div>
	</div>
	</div>
</div>


<div id="tableDataEventActiveParamDialog" class="easyui-dialog" title="设置参数" data-options="closed:true,top:200,modal:true,onClose:function(){showToolsPanel();}" style="width:600px;height:420px;">
	<div class="easyui-layout"  data-options="fit:true">
		<div data-options="region:'center', border:false">
		<div class="txt_centern">
			<table id="tableDataEventActiveParamTable" class="pageTable">
				<!-- <tr>
					<td width="50%">参数名:&nbsp;<input type="text" id="" name="tableDataEventLinkParamName" style="width:120px;" value="" readonly="readonly"></td>
					<td>对应数据列:&nbsp;<input name="tableDataEventLinkParamValue" value="请选择"  style="width:120px"></td>
				</tr>
				 -->
			</table> 
		</div>
	</div>
	<div data-options="region:'south', border:false" style=" height:60px;padding:10px 0 0 10px;">
		<div id="tableDataEventActiveParamDialogButtonDiv">
			<span class="easyui-font-red" id="tableDataEventActiveParamCareSpan">打开时注入</span><a href="javascript:void(0);" class="easyui-linkbutton"   onclick="tableDataOpenEventActiveParamCommit();">完 成</a>
		</div>
	</div>
</div>
	
	
	<script type="text/javascript">

	$(function(){
		$("#tableDataBorderGtColor").spectrum({
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
				tableDataSetBorderGtColor(color);
			}
		});
		$("#tableDataBorderLtColor").spectrum({
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
				tableDataSetBorderLtColor(color);
			}
		});
		
		//数据类型单选框
		$("input[name='tableDataType']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableDataSetType(this.value);
		});
		
		//千分符多选框
		$("#tableDataThousand").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableDataSetThousand();
		});
		
		//行间相邻相同数据合并多选框
		$("#tableDataRowMerge").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableDataSetRowMerge();
		});
		
		//设置边界 多选框
		$("#tableDataBorderSetFlag").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableDataSetBorderSetFlag();
		});
		
		//显示上下箭头 多选框
		$("#tableDataBorderShowUpDown").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableDataSetBorderShowUpDown();
		});
		
		
		//动作类型多选框
		$("input[name='tableDataEvent']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableDataSetEvent(this.value)
		});
		
	});
	</script>