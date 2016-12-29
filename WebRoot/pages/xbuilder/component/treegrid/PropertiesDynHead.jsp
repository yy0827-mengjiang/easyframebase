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
				<input type="radio" id="treeTableDynHeadDynTypeConstant" name="treeTableHeadColDynType" value="1"/><label for="treeTableDynHeadDynTypeConstant">常量</label>
				<input type="radio" id="treeTableDynHeadDynTypeDimsion" name="treeTableHeadColDynType" value="2"/><label for="treeTableHeadColDynType">查询条件</label>
			</dd>
			<dt>数据类型:</dt>
	   		<dd>
	   			<input  id="treeTableDynHeadDataType"  name="treeTableDynHeadDataType" type="text" value="" class="easyui-combobox wih_204" data-options="data:[{'id':'1','text':'日'},{'id':'2','text':'月'}],valueField:'id',textField:'text',multiple:false,panelHeight:160,editable:false,value:'1',onSelect:treeTableHeadSetDynDataType">
	   		</dd>
	   		<dt id="treeTableDynHeadDimsionNameDt" style="display: none;">绑定查询条件:</dt>
	   		<dd id="treeTableDynHeadDimsionNameDd" style="display: none;">
	   			<input  id="treeTableDynHeadDimsionName"  name="treeTableDynHeadDimsionName" type="text" value="请选择" class="easyui-combobox wih_204" data-options="valueField:'id',textField:'text',multiple:false,panelHeight:160,editable:false,onSelect:treeTableHeadSetDynDimsionName">
	   		</dd>
	   		<dt>年偏移量:</dt>
	   		<dd>
	   			<input  id="treeTableDynHeadYearStep"  name="treeTableDynHeadYearStep" type="text" value="" class="easyui-numberbox wih_204"  data-options="value:0,onChange:function(nv,ov){treeTableHeadSetDynYearStep(nv)}" >
	   		</dd>
	   		<dt>月偏移量:</dt>
	   		<dd>
	   			<input  id="treeTableDynHeadMonthStep"  name="treeTableDynHeadMonthStep" type="text" value="" class="easyui-numberbox wih_204"  data-options="value:0,onChange:function(nv,ov){treeTableHeadSetDynMonthStep(nv)}">
	   		</dd>
	   		<dt id="treeTableDynHeadDayStepDt">日偏移量:</dt>
	   		<dd id="treeTableDynHeadDayStepDd">
	   			<input  id="treeTableDynHeadDayStep"  name="treeTableDynHeadDayStep"  type="text" value="" class="easyui-numberbox wih_204" data-options="value:0,onChange:function(nv,ov){treeTableHeadSetDynDayStep(nv)}">
	   		</dd>
	   		<dt>前缀字符:</dt>
	   		<dd>
	   			<input  id="treeTableDynHeadPrefixStr"  name="treeTableDynHeadPrefixStr" type="text" class="wih_204" value="" onblur="treeTableHeadSetDynPrefixStr(this.value)">
	   		</dd>
	   		<dt>后缀字符:</dt>
	   		<dd>
	   			<input  id="treeTableDynHeadSuffixStr"  name="treeTableDynHeadSuffixStr" type="text" class="wih_204" value="" onblur="treeTableHeadSetDynSuffixStr(this.value)">
	   		</dd>
	   	</dl>
	</div>
	
	
</div>


	<script type="text/javascript">

	$(function(){
		//动态类型单选框
		$("input[name='treeTableHeadColDynType']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	treeTableHeadSetDynType(this.value);
		});
	});
	</script>