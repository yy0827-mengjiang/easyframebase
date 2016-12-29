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
	   			<input type="text" id="tableDataWidth" name="tableDataWidth" value="" class="easyui-numberbox wih_204" data-options="min:1,onChange:function(nv,ov){setCrossDataColumnWidth(nv)}"/>
	   		</dd>
	        <dt>类型</dt>
	   		<dd>
				<input type="radio" id="tableDataTypeCommon" name="tableDataType" value="common"/><label for="tableDataTypeCommon">常规</label>
				<input type="radio" id="tableDataTypeNumber" name="tableDataType" value="number"/><label for="tableDataTypeNumber">数值</label>
				<input type="radio" id="tableDataTypePercent" name="tableDataType" value="percent"/><label for="tableDataTypePercent">百分数</label>
			</dd>
			<dt>小数位</dt>
	   		<dd>
	   			<p><input type="text" id="tableDataNumberStep" name="tableDataNumberStep" value="0" class="easyui-numberbox wih_204" data-options="min:0,onChange:function(nv,ov){setCrossTableNumberStep(nv)}"/></p>
	   			<input type="checkbox" id="tableDataThousand" name="tableDataThousand"/><label for="tableDataThousand">使用千分符(,)</label>
	   		</dd>
	   		<dt>对齐</dt>
	   		<dd>
				<p>
					<span id="tableDataAlignLeft" name="tableDataAlign" class="positionIcon positionLeft"  onclick="setCrossTableDataAlign('left');"></span>
					<span id="tableDataAlignCenter" name="tableDataAlign" class="positionIcon positionCenter"  onclick="setCrossTableDataAlign('center');"></span>
					<span id="tableDataAlignRight" name="tableDataAlign" class="positionIcon positionRight" onclick="setCrossTableDataAlign('right');"></span>
				</p>
				<p id="crossTableDataRowMergePTag"><input type="checkbox" id="crossTableDataRowMerge" name="crossTableDataRowMerge"/><label for="crossTableDataRowMerge">行间相邻相同数据合并</label></p>
	   		</dd>
	   		<dt>边界设置</dt>
	   		<dd class="blockDdAuto"><input type="checkbox" id="tableDataBorderSetFlag" name="tableDataBorderSetFlag" /><label for="tableDataBorderSetFlag">启用</label> </dd>
	   		<dt>边界值</dt>
	   		<dd><input type="text" id="tableDataBorderValue" name="tableDataBorderValue" value="" class="easyui-numberbox wih_204" data-options="onChange:function(nv,ov){setCrossTableBorderValue(nv)}"/></dd>
	   		<dd class="blockDdAuto">
		   		<p class="pro_data">大于<input type="text" id="tableDataBorderGtColor" name="tableDataBorderGtColor" value="#5cd18b"/>小于<input type="text" id="tableDataBorderLtColor" name="tableDataBorderLtColor" value="#d34737"/></p>
		   		<p><input type="checkbox" id="tableDataBorderShowUpDown" name="tableDataBorderShowUpDown"/><label for="tableDataBorderShowUpDown">显示升降序符号</label></p>
	   		</dd>
	   		
	   	</dl>
	</div>
   	<div id="crossTableDataEventDiv">
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
						<input type="text" id="tableDataEventLinkShow" name="tableDataEventLinkShow" value="" readonly="readonly" style="width:130px;"/>
						<a href="javascript:void(0)" class="easyui-linkbutton" onclick="crossTableDataOpenEventLinkDialog()">选择</a>
					</dd>
					<dt>参数：</dt>
					<dd>
						<input type="text" id="tableDataEventLinkParamShow" name="tableDataEventLinkShow" value="" readonly="readonly" style="width:130px;"/>
						<a href="javascript:void(0)" class="easyui-linkbutton" onclick="crossTableDataOpenEventLinkParamDialog()">设置</a>
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


<div id="crossTableDataEventLinkDialog" class="easyui-dialog" title="选择页面" data-options="closed:true,top:30,modal:true,onClose:function(){showToolsPanel();}" style="width:1100px;height:620px;">
	<div id="crossTableDataEventLinkDialogBar" class="contents-head">
				<div class="search-area textLeft">
					报表ID：<input type="text" id="crossTableDataEventLinkReportId" name="crossTableDataEventLinkReportId" style="width:200px;"> 
				    报表名称：<input type="text" id="crossTableDataEventLinkReportName" name="crossTableDataEventLinkReportName" style="width:200px;"> 
				<a id="ss" name="ss" href="javascript:void(0)" onclick="crossTableDataEventLinkReportQuery()"   class="easyui-linkbutton" data-options="plain:true">查询</a>
				</div>
	</div>
	<c:datagrid id="crossTableDataEventLinkReportDatagrid" url="pages/xbuilder/component/crosstable/Action.jsp?eaction=DataReportList" fit="true" pageSize="20"  style="width:auto;height:auto"  download="false" nowrap="false" toolbar="#crossTableDataEventLinkDialogBar">
		<thead>
			<tr>
				<th field="ID" width="45%">报表ID</th>
				<th field="NAME" width="45%">报表名称</th>
				<th field="cz" width="10%"  formatter="crossTableDataEventLinkFormatter">操作</th>
			</tr>
		</thead>
	</c:datagrid>
</div>


<div id="crossTableDataEventLinkParamDialog" class="easyui-dialog" title="设置参数" data-options="closed:true,top:30,modal:true,buttons:'#crossTableDataEventLinkParamDialogButtonDiv',onClose:function(){showToolsPanel();}" style="width:600px;height:400px;">
	<div id="crossTableDataEventLinkParamDialogButtonDiv">
		<span style="color: #f00">注意：“对应数据列”中请选择维度或维度编码，不能选择指标！</span><a href="javascript:void(0);" class="easyui-linkbutton"   onclick="crossTableDataEventLinkParamCommit();">完 成</a>
	</div>
	<div class="txt_centern">
		<table id="crossTableDataEventLinkParamTable">
			<!-- <tr>
				<td width="50%">参数名:&nbsp;<input type="text" id="" name="tableDataEventLinkParamName" style="width:120px;" value="" readonly="readonly"></td>
				<td>对应数据列:&nbsp;<input name="tableDataEventLinkParamValue" value="请选择"  style="width:120px"></td>
			</tr>
			 -->
		</table> 
	</div>
</div>


<div id="crossTableDataEventActiveParamDialog" class="easyui-dialog" title="设置参数" data-options="closed:true,top:180,modal:true,buttons:'#crossTableDataEventActiveParamDialogButtonDiv',onClose:function(){showToolsPanel();}" style="width:600px;height:400px;">
	<div id="crossTableDataEventActiveParamDialogButtonDiv">
		<span class="easyui-font-red">注意：“对应数据列”中请选择维度或维度编码，不能选择指标！</span><a href="javascript:void(0);" class="easyui-linkbutton"   onclick="crossTableDataEventActiveParamCommit();">完 成</a>
	</div>
	<div class="txt_centern">
		
		<table id="crossTableDataEventActiveParamTable">
			 <!-- 
			 <tr>
				<td width="50%">参数名:&nbsp;<input type="text" id="" name="tableDataEventActiveParamName" style="width:120px;" value="" readonly="readonly"></td>
				<td>对应数据列:&nbsp;<input name="tableDataEventActiveParamValue" value="请选择"  style="width:120px"></td>
			</tr>
			 -->
		</table> 
	</div>
</div>

<div id="propertiesStoreDiv" style="display:none" 
     datafmtisarrow="0" datafmtbdup='#5cd18b' datafmtbddown='#d34737' 
     tableheadalign="center" datafmttype="common" datadecimal="0" datafmtisbdvalue="0"
     tableheadwidth="100" datafmtisbd="0" datafmtthousand="0" datafmtrowmerge="0"></div>
	
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
				setCrossTableBorderGtColor(color);
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
				setCrossTableBorderLtColor(color);
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
		  	setCrossColumnDataType(this.value);
		});
		
		//千分符多选框
		$("#tableDataThousand").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	setCrossTableThousand();
		});
		
		//设置边界 多选框
		$("#tableDataBorderSetFlag").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	setCrossTableBorderFlag();
		});
		
		//显示上下箭头 多选框
		$("#tableDataBorderShowUpDown").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	setCrossTableShowUpDownArraw();
		});
		
		
		//动作类型多选框
		$("input[name='tableDataEvent']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
			crossTableDataSetEvent(this.value)
		});
		
		//行间相邻相同数据合并多选框
		$("#crossTableDataRowMerge").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	crossTableDataSetRowMerge();
		});
	});
	</script>