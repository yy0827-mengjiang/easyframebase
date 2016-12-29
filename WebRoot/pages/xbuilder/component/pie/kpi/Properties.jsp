<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<div class="propertiesPane">
  <h4>图表元素设置</h4>
  <div class="ppInterArea">
  <dl>
    <dt>标题：</dt>
    <dd>
      <input type="text" class="wih_146" id="pie_title" name="pie_title" onblur="pie_fun_SetTitle()" />&nbsp;
      <input type="checkbox" value="1" id="showTitle" name="showTitle" class="checkN" checked="checked" />&nbsp;显示
    </dd>
  </dl>
  </div>
  <h4>数据设置</h4>
  <div class="ppInterArea">
  <a:kpiSelector id="pieKpiSelector"></a:kpiSelector>
  <dl>
    <dt></dt>
    <dd>
        <a class="openKpi" href="javascript:openPieKpiDialog()">打开指标库...</a>
        <a:kpiCaculateColumn id="pieCaculateColumn" updateDatasetUiFunction="pieUpdataDatasetUI"></a:kpiCaculateColumn>
    </dd>
    <dt> 维度列：</dt>
    <dd>
       <input id="pie_dim" style="width:120px;" name="pie_dim" readonly="readonly"/>
    </dd>
    <dt> 指标列：</dt>
    <dd>
       <input name="pie_ser" style="width:120px;" id="pie_ser"  readonly="readonly"/>
    </dd>
    <dt> 指标名：</dt>
    <dd>
    	<input type="text" style="width:120px;" id="pie_kpi_name" name="pie_kpi_name"  onblur="pie_fun_SetKpiName()"/>
    </dd>
    
    <dt>排序列：</dt>
    <dd>
      <input id="pie_ord" style="width:120px;"  name="pie_ord" readonly="readonly"/>
    </dd>
    <dt>排序方式</dt>
     <dd>
         <select class="easyui-combobox" style="width:180px;" id="pie_sorttype" data-options="onSelect:pie_fun_SetOrd">
		    <option value="asc">正序</option>
			<option value="desc">倒序</option>
		</select>
    </dd>
    
    <dt> 单&nbsp;&nbsp;位：</dt>
    <dd>
      <input type="text" style="width:120px;" name="pie_unit" id="pie_unit" onblur="pie_fun_SetUnit()"/>
    </dd>
  </dl>
  </div>
  <h4>样式设置</h4>
  <div class="ppInterArea">
  <jsp:include page="../../ChartStyleSetter.jsp?chartType=pie"></jsp:include>
</div>
<input type="hidden" id="curSelectInput"/>
</div>
</div>

<script>
	$(function(){
		 pie_initDroppable();
	});
</script>