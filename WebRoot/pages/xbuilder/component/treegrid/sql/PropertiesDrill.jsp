<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<style type="text/css">
.down_inp{ width:210px!important;}
.down_sel{ width:210px!important;}
.propertiesPane dl dt{ padding-left:6px!important; padding-right:8px!important;}
dd p span.combo{ width:218px!important;}
dd p span.combo input[type="text"]{ width:188px!important;}
.treeTableDrillP span.combo{ width:95px!important;}
.treeTableDrillP span.combo input[type="text"]{ width:65px!important;}

.treeTableDrillP span.combo:nth-child(4){ width:60px!important;}
.treeTableDrillP span.combo:nth-child(4) input[type="text"]{ width:28px!important;}

.treeTableDrillP span.combo:last-child{ width:60px!important;}
.treeTableDrillP span.combo:last-child input[type="text"]{ width:28px!important;}
</style>

<div class="propertiesPane">
	<h4>下钻列设置</h4>
	<div class="ppInterArea">
		<dl>
			<dt>当前下钻:</dt>
			<dd>
				<p><input class="down_sel wih_212" id="treeTableDrillColSelector"  name="treeTableDrillColSelector"></p>
			</dd>
			<dt title="下钻编码不可以包含汉字">下钻编码:</dt>
			<dd title="下钻编码不可以包含汉字">
				<p><input class="down_sel wih_212" id="treeTableDrillCode"  name="treeTableDrillCode" value="请选择" ></p>
			</dd>
			<dt>下钻名称:</dt>
	   		<dd>
	   			<input type="text" class="down_inp" id="treeTableDrillName" name="treeTableDrillName" onblur="treeTableDrillSetName(this.value)"/>
	   		</dd>
			<dt>数据集:</dt>
			<dd>
				<p><input class="down_sel" id="treeTableDrillDatasourceId"  name="treeTableDrillDatasourceId" value="请选择" ></p>
			</dd>
			<dt>下钻编码列:</dt>
			<dd>
				<p><input class="down_sel" id="treeTableDrillCodecolCode"  name="treeTableDrillCodecolCode" value="请选择"></p>
			</dd>
			<dt>下钻描述列:</dt>
			<dd>
				<p><input class="down_sel" id="treeTableDrillDesccolCode"  name="treeTableDrillDesccolCode" value="请选择"></p>
			</dd>
			<dt>下钻排序列:</dt>
			<dd id="treeTableDrillSortcolDd" >
				<p class="treeTableDrillP">
					<input id="treeTableDrillSortcolCode"  name="treeTableDrillSortcolCode" value="请选择">
					<input id="treeTableDrillSortcolKpiType"  name="treeTableDrillSortcolKpiType" value="请选择">
					<input id="treeTableDrillSortcolType"  name="treeTableDrillSortcolType" value="请选择">
				</p>
			</dd>
			<dt>显示级别:</dt>
	   		<dd>
	   			<input type="text" class="down_inp" id="treeTableDrillShowLevel" name="treeTableDrillShowLevel" onblur="treeTableDrillSetShowLevel(this.value)"/>
	   		</dd>
	   		<dt>分组名称:</dt>
	   		<dd>
	   			<input type="text" class="down_inp" id="treeTableDrillGroupName" name="treeTableDrillGroupName" onblur="treeTableDrillSetGroupName(this.value)"/>
	   		</dd>
	   		<dt>默认显示:</dt>
	   		<dd class="blockDdAuto">
	   			<input type="checkbox" id="treeTableDrillDefaulShowFlag" name="treeTableDrillDefaulShowFlag" />
	   			<label for="treeTableDrillDefaulShowFlag">启用</label>
	   		</dd>
		</dl>
	</div>
	<h4>下钻格式</h4>
	<div class="ppInterArea">
		<dl>
			<dt>宽度:</dt>
	   		<dd>
	   			<input type="text" class="down_inp" id="treeTableDrillWidth" name="treeTableDrillWidth" onblur="treeTableDrillSetWidth(this.value)"/>
	   		</dd>
	   		<dt>显示汇总:</dt>
	   		<dd class="blockDdAuto">
	   			<input type="checkbox" id="treeTableDrillTotalShowFlag" name="treeTableDrillTotalShowFlag" />
	   			<label for="treeTableDrillTotalShowFlag">启用</label>
	   		</dd>
	   		<dt style="display: none;">汇总编码:</dt>
	   		<dd style="display: none;">
	   			<input type="text" class="down_inp" id="treeTableDrillTotalCode" name="treeTableDrillTotalCode" onblur="treeTableDrillSetTotalCode(this.value)" disabled="disabled"/>
	   		</dd>
	   		<dt>汇总名称:</dt>
	   		<dd>
	   			<input type="text" class="down_inp" id="treeTableDrillTotalName" name="treeTableDrillTotalName" onblur="treeTableDrillSetTotalName(this.value)" disabled="disabled"/>
	   		</dd>
	   	</dl>
	</div>
</div>


	
	
	<script type="text/javascript">

	$(function(){
	
		//默认显示
		$("input[name='treeTableDrillDefaulShowFlag']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
		  	treeTableDrillSetDefaulShowFlag();
		});
		
		//显示汇总
		$("input[name='treeTableDrillTotalShowFlag']").iCheck({
		    labelHover : false,
		    cursor : true,
		    checkboxClass : 'icheckbox_square-blue',
		    radioClass : 'iradio_square-blue',
		    increaseArea : '20%'
		}).on('ifClicked', function(event){
			treeTableDrillSetTotalShowFlag();
		});
	});
	</script>