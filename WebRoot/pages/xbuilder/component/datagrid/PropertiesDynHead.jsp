<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<div class="propertiesPane">
	<h4>动态单元格格式</h4>
	<div class="ppInterArea">
		<dl>
			
	        <dt>动态类型:</dt>
	   		<dd>
				<input type="radio" id="tableDynHeadDynTypeConstant" name="tableHeadColDynType" value="1"/><label for="tableDynHeadDynTypeConstant">常量</label>
				<input type="radio" id="tableDynHeadDynTypeDimsion" name="tableHeadColDynType" value="2"/><label for="tableHeadColDynType">查询条件</label>
			</dd>
			<dt>数据类型:</dt>
	   		<dd>
	   			<input  id="tableDynHeadDataType"  name="tableDynHeadDataType" type="text" value="" class="easyui-combobox wih_204" data-options="data:[{'id':'1','text':'日'},{'id':'2','text':'月'}],valueField:'id',textField:'text',multiple:false,panelHeight:160,editable:false,value:'1',onSelect:tableHeadSetDynDataType">
	   		</dd>
	   		<dt id="tableDynHeadDimsionNameDt" style="display: none;">绑定查询条件:</dt>
	   		<dd id="tableDynHeadDimsionNameDd" style="display: none;">
	   			<input  id="tableDynHeadDimsionName"  name="tableDynHeadDimsionName" type="text" value="请选择" class="easyui-combobox wih_204" data-options="valueField:'id',textField:'text',multiple:false,panelHeight:160,editable:false,onSelect:tableHeadSetDynDimsionName">
	   		</dd>
	   		<dt>年偏移量:</dt>
	   		<dd>
	   			<input  id="tableDynHeadYearStep"  name="tableDynHeadYearStep" type="text" value="" class="easyui-numberbox wih_204"  data-options="value:0,onChange:function(nv,ov){tableHeadSetDynYearStep(nv)}">
	   		</dd>
	   		<dt>月偏移量:</dt>
	   		<dd>
	   			<input  id="tableDynHeadMonthStep"  name="tableDynHeadMonthStep" type="text" value="" class="easyui-numberbox wih_204"  data-options="value:0,onChange:function(nv,ov){tableHeadSetDynMonthStep(nv)}"  >
	   		</dd>
	   		<dt id="tableDynHeadDayStepDt">日偏移量:</dt>
	   		<dd id="tableDynHeadDayStepDd">
	   			<input  id="tableDynHeadDayStep"  name="tableDynHeadDayStep"  type="text" value="" class="easyui-numberbox wih_204" data-options="value:0,onChange:function(nv,ov){tableHeadSetDynDayStep(nv)}"  >
	   		</dd>
	   		<dt>前缀字符:</dt>
	   		<dd>
	   			<input  id="tableDynHeadPrefixStr"  name="tableDynHeadPrefixStr" type="text" class="wih_204" value="" onblur="tableHeadSetDynPrefixStr(this.value)">
	   		</dd>
	   		<dt>后缀字符:</dt>
	   		<dd>
	   			<input  id="tableDynHeadSuffixStr"  name="tableDynHeadSuffixStr" type="text" class="wih_204" value="" onblur="tableHeadSetDynSuffixStr(this.value)">
	   		</dd>
	   	</dl>
	</div>
	
	
</div>


	<script type="text/javascript">

	$(function(){
		//动态类型单选框
		$("input[name='tableHeadColDynType']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	tableHeadSetDynType(this.value);
		});
	});
	</script>