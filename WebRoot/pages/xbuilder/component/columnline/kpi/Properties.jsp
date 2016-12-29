<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<div class="propertiesPane">
  <h4>图表元素设置</h4>
  <div class="ppInterArea">
  <dl>
    <dt>标题：</dt>
    <dd>
      <input type="text" class="wih_146" id="columnline_title" name="columnline_title" onblur="columnline_fun_SetTitle()" />&nbsp;
      <input type="checkbox" value="1" id="showTitle" name="showTitle" class="checkN" checked="checked" />&nbsp;显示
    </dd>
  </dl>
  </div>
  <h4>数据设置</h4>
  <div class="ppInterArea">
  <a:kpiSelector id="columnLineKpiSelector"></a:kpiSelector>
  <dl>
    <dt></dt>
    <dd>
        <a class="openKpi" href="javascript:openColumnLineKpiDialog()">打开指标库...</a>
        <a:kpiCaculateColumn id="columnlineCaculateColumn" updateDatasetUiFunction="columnlineUpdataDatasetUI"></a:kpiCaculateColumn>
    </dd>
    <dt>维度列：</dt>
    <dd>
      <input id="columnline_dim"  name="columnline_dim" class="wih_176" readonly="readonly"/>
    </dd>
    <dt>排序列：</dt>
    <dd>
      <input id="columnline_ord"  name="columnline_ord" class="wih_176" readonly="readonly"/>
    </dd>
     <dt>排序方式</dt>
     <dd>
         <select class="easyui-combobox wih_182" id="columnline_sorttype" data-options="onSelect:columnline_fun_SetOrd">
		    <option value="asc">正序</option>
			<option value="desc">倒序</option>
		</select>
    </dd>
    <dd class="blockDd">
      <div class="ppSetItem">
        <table id="columnline_tb2">
          <thead>
            <tr>
              <th width="25%">指标列</th>
              <th width="17%">指标名</th>
              <th width="22%">颜色</th>
              <th width="18%">类别</th>
              <th width="18%">y轴</th>
            </tr>
          </thead>
        </table>
        <ul class="btnItem1">
          <li><a class="addBtn" href="javascript:void(0)" onclick="columnline_appendKpiRow();">添加</a></li>
          <li><a class="deleteBtn" href="javascript:void(0)" onclick="columnline_removeKpiRow();">删除</a></li>
        </ul>
      </div>
    </dd>
  </dl>
  </div>
  <h4>样式设置</h4>
  <div class="ppInterArea">
  <jsp:include page="../../ChartStyleSetter.jsp?chartType=columnline&yAxis=${param.yAxis}"></jsp:include>
  <input type="hidden" id="curSelectInput"/>
  <!-- 添加指标行html模板 -->
  <table id="kpiRowHtml" class="none_dis">
    <tr>
      <td  class="wih_100"><input name="columnline_ser" class="columnline_ser wih_40" value="" readonly="readonly"></td>
      <td><input type="text" name="columnline_sername" class="wih_50" onblur="columnline_fun_SetKpi()"/></td>
      <td><input type="text" name="columnline_colour" class="colorpk" value="#fff"></td>
      <td><input name="columnline_type" class="columnline_type wih_60" data-options="valueField:'id',textField:'text',multiple:false,panelHeight:160,onSelect:columnline_fun_SetKpi"></td>
      <td><input name="columnline_ref" class="columnline_ref wih_40" value="0" data-options="valueField:'id',textField:'text',multiple:false,panelHeight:160,onSelect:columnline_fun_SetKpi"></td>
    </tr>
  </table>
  </div>
</div>

	<script>
	  $(function(){
		 columnline_initDroppable();
	  });
	</script>

