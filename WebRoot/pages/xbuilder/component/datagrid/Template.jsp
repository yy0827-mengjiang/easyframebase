<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="cn.com.easy.xbuilder.service.component.ComponentBaseService"%>
<%@page import="cn.com.easy.xbuilder.element.Report"%>
<%@page import="cn.com.easy.xbuilder.element.Component"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%> 
<%
    String reportId = request.getParameter("reportId");
    String containerId = request.getParameter("containerId");
    String componentId = request.getParameter("componentId");
	ComponentBaseService cbs=new ComponentBaseService();
	Report report= cbs.readFromXmlByViewId(reportId);
	Component component= cbs.getOrCreateComponet(report,containerId,componentId);
	String tabHead = "";
	if(component!=null&&component.getHeadui()!=null){
		tabHead=component.getHeadui().getText();
	}
	//System.out.println("tabHead:"+tabHead);

%>
<!-- style="display: none;" -->
<div class="core-panel" onmouseover="LayOutUtil.setComponent('${param.containerId}','${param.componentId}','${param.ispop}');">
	<div id="comp_${param.componentId}" style="display: none"  data-fun_edit="tableComponentEdit"></div>
	<div id="datagrid_panel_${param.componentId}">
		<div id="editorDiv_${param.componentId}"  style="width:auto;height:auto;padding:0px;margin: 0px;">
			<span style=" padding:4px 0 4px 4px; margin-top:4px; display:block;">
				<span>
					<a href="javascript:void(0);" onclick="LayOutUtil.componentEdit('${param.containerId}');return false;" class="icoTableData">数据修改</a>
					<input type="text" style="text-align: center; width:9%; margin-right:0.1%; border:2px solid #199ed8; height:14px; color:#777;" readonly="readonly" id="tableHeadColName_${param.componentId}" name="tableHeadColName_${param.componentId}" value=""/>
					<select id="tableHeadColType_${param.componentId}" disabled="disabled" onchange="tableHeadColTypeValue(this.options[this.options.selectedIndex].value)">
						<option value="1">静态</option>
						<option value="2">动态</option>
					</select>
					<input type="text" style="width:25%;"  disabled="disabled" id="tableHeadColValue_${param.componentId}" name="tableHeadColValue_${param.componentId}" value="" onkeyup="tableHeadColValue(this.value)"/>
					<a id="tableHeadMergeCellButton_${param.componentId}"  herf="javascript:void(0);" name="tableHeadMergeCellButton_${param.componentId}" onclick="tableHeadMergeCell()" title="合并" class="margerSplit margerBtnDisable" disabled="disabled"></a>
					<a id="tableHeadSplitCellButton_${param.componentId}"  herf="javascript:void(0);" name="tableHeadSplitCellButton_${param.componentId}" onclick="tableHeadSplitCell()" title="拆分" class="margerSplit splitBtnDisable" disabled="disabled"></a>
				</span>
					
			</span>
			<div id="comp_main_scoll_${param.componentId}" style="overflow:auto;">
				<div id="comp_scoll_${param.componentId}">
				<table id="selectable_${param.componentId}" border="1"  class="reportTable" >
					<%
					if(tabHead!=null&&!(tabHead.equals(""))){
					%>
						<%=tabHead%>
					<%		
						}else{
					%>
						<thead>
							<tr class="ui-th-head">
								<th class="ui-state-default" istt="th1" style="background:#f8f8f8;"></th>
								<th class="ui-state-default" istt="th1">A</th>
								<th class="ui-state-default" istt="th1" >B</th>
								<th class="ui-state-default" istt="th1">C</th>
								<th class="ui-state-default" istt="th1" >D</th>
								<th class="ui-state-default" istt="th1">E</th>
								<th class="ui-state-default" istt="th1" >F</th>
								<th class="ui-state-default" istt="th1" >G</th>
							</tr>
						</thead>
						<tbody>
							<tr class="ui-th">
								<th class="ui-state-default" istt="td2"  ishead="1" >1</th>
								<td class="ui-state-default" istt="td2" tdInd="1"  ishead="1"></td>
								<td class="ui-state-default" istt="td2" tdInd="2"  ishead="1"></td>
								<td class="ui-state-default" istt="td2" tdInd="3"  ishead="1"></td>
								<td class="ui-state-default" istt="td2" tdInd="4"  ishead="1"></td>
								<td class="ui-state-default" istt="td2" tdInd="5"  ishead="1"></td>
								<td class="ui-state-default" istt="td2" tdInd="6"  ishead="1"></td>
								<td class="ui-state-default" istt="td2" tdInd="7"  ishead="1"></td>
							</tr>
							<tr class="ui-th">
								<th class="ui-state-default" istt="td3"  ishead="1" >2</th>
								<td class="ui-state-default" istt="td3" tdInd="1"  ishead="1"></td>
								<td class="ui-state-default" istt="td3" tdInd="2"  ishead="1"></td>
								<td class="ui-state-default" istt="td3" tdInd="3"  ishead="1"></td>
								<td class="ui-state-default" istt="td3" tdInd="4"  ishead="1"></td>
								<td class="ui-state-default" istt="td3" tdInd="5"  ishead="1"></td>
								<td class="ui-state-default" istt="td3" tdInd="6"  ishead="1"></td>
								<td class="ui-state-default" istt="td3" tdInd="7"  ishead="1"></td>
							</tr>
							<tr class="ui-th">
								<th class="ui-state-default" istt="td4"  ishead="1" >3</th>
								<td class="ui-state-default" istt="td4" tdInd="1"  ishead="1"></td>
								<td class="ui-state-default" istt="td4" tdInd="2"  ishead="1"></td>
								<td class="ui-state-default" istt="td4" tdInd="3"  ishead="1"></td>
								<td class="ui-state-default" istt="td4" tdInd="4"  ishead="1"></td>
								<td class="ui-state-default" istt="td4" tdInd="5"  ishead="1"></td>
								<td class="ui-state-default" istt="td4" tdInd="6"  ishead="1"></td>
								<td class="ui-state-default" istt="td4" tdInd="7"  ishead="1"></td>
							</tr>
							<tr class="ui-th">
								<th class="ui-state-default" istt="td5"  ishead="1" >4</th>
								<td class="ui-state-default" istt="td5" tdInd="1"  ishead="1"></td>
								<td class="ui-state-default" istt="td5" tdInd="2"  ishead="1"></td>
								<td class="ui-state-default" istt="td5" tdInd="3"  ishead="1"></td>
								<td class="ui-state-default" istt="td5" tdInd="4"  ishead="1"></td>
								<td class="ui-state-default" istt="td5" tdInd="5"  ishead="1"></td>
								<td class="ui-state-default" istt="td5" tdInd="6"  ishead="1"></td>
								<td class="ui-state-default" istt="td5" tdInd="7"  ishead="1"></td>
							</tr>
							<tr class="ui-th">
								<th class="ui-state-default" istt="td6"  ishead="1" >5</th>
								<td class="ui-state-default" istt="td6" tdInd="1"  ishead="1" style="width:100;"></td>
								<td class="ui-state-default" istt="td6" tdInd="2"  ishead="1" style="width:100;"></td>
								<td class="ui-state-default" istt="td6" tdInd="3"  ishead="1" style="width:100;"></td>
								<td class="ui-state-default" istt="td6" tdInd="4"  ishead="1" style="width:100;"></td>
								<td class="ui-state-default" istt="td6" tdInd="5"  ishead="1" style="width:100;"></td>
								<td class="ui-state-default" istt="td6" tdInd="6"  ishead="1" style="width:100;"></td>
								<td class="ui-state-default" istt="td6" tdInd="7"  ishead="1" style="width:100;"></td>
							</tr>
							<tr class="ui-th">
								<th class="ui-state-default" istt="td7">6</th>
								<td class="ui-state-default" istt="td7" tdInd="1" ></td>
								<td class="ui-state-default" istt="td7" tdInd="2" ></td>
								<td class="ui-state-default" istt="td7" tdInd="3" ></td>
								<td class="ui-state-default" istt="td7" tdInd="4" ></td>
								<td class="ui-state-default" istt="td7" tdInd="5" ></td>
								<td class="ui-state-default" istt="td7" tdInd="6" ></td>
								<td class="ui-state-default" istt="td7" tdInd="7" ></td>
							</tr>
						</tbody>
						<%		
							}
						%>
				</table>
				</div>
			</div>
		</div>
		
		
	</div>
</div>
<script>
var hasExcuteSeleted${param.componentId}=true;
var beginSelectTd${param.componentId}={};
var endSelectTd${param.componentId}={};
var isFirstSelectTdFlag${param.componentId}=true;	
var th_show = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
$(function() {
	/*初始表格*/
	for(var th_i=0;th_i<26;th_i++){
		for(var th_j=0;th_j<26;th_j++){
			th_show[(th_i+1)*26+th_j]=th_show[th_i]+th_show[th_j];
		}
	}
	document.getElementById("selectable_${param.componentId}").style.display = "block";
	
	$( "#selectable_${param.componentId}").selectable({ 
		filter:'td',
		autoRefresh: false,
		unselecting:function(event,ui){
			event.stopPropagation();
			event.preventDefault();
			
		},
		selecting:function(event,ui){
			event.stopPropagation();
			event.preventDefault();
			hasExcuteSeleted${param.componentId}=false;//重置 是否是已经执行过选中 标识
			var $selecteds=$('#selectable_${param.componentId}').find('.ui-selecting').eq(0);
			if(isFirstSelectTdFlag${param.componentId}){//初始 开始单元格
				beginSelectTd${param.componentId}.row=parseInt($($selecteds).attr("istt").substring(2)-1);
				beginSelectTd${param.componentId}.col=parseInt($($selecteds).attr("tdInd"));
				isFirstSelectTdFlag${param.componentId}=false;
			}
			var compMainScollDiv=$("#comp_main_scoll_${param.componentId}");
			var scollLeft=compMainScollDiv.scrollLeft();//滚动条已向右滚动的位移
			var divWidth=compMainScollDiv.width();//组件可见区域宽度
			var tdWidth=$selecteds.width();//单元格宽度
			var pageXVal=event.pageX-compMainScollDiv.offset().left;//鼠标x轴相对坐标
			var firstThWidth=$('#selectable_${param.componentId}').find("th:first").eq(0).width();//行序号单元格宽度
			if((pageXVal+tdWidth)>=divWidth){//选中单元格超出可见区域右边界
				$("#comp_main_scoll_${param.componentId}").scrollLeft(scollLeft+((pageXVal-firstThWidth-2)/(tdWidth+1)+1)*(tdWidth+1)+firstThWidth+2-pageXVal);
			}
			if(scollLeft!=0&&(pageXVal-tdWidth<=(firstThWidth+2))){//滚动条已向右滚动过并且选中单元格超出可见区域左边界
				if(scollLeft-tdWidth>0){//滚动条能满足想要向左滚动的距离
					$("#comp_main_scoll_${param.componentId}").scrollLeft(scollLeft-tdWidth);
				}else{//滚动条不能满足想要向左滚动的距离
					$("#comp_main_scoll_${param.componentId}").scrollLeft(0);
				}
			}
			
			$('#selectable_${param.componentId}').selectable('refresh');
			
		},
		selected: function(event, ui){
			event.stopPropagation();
			event.preventDefault();
		},
		start: function(event, ui) {
			event.stopPropagation();
			event.preventDefault();
			$("input:focus").blur();
		},
		stop: function(event, ui) {
			event.stopPropagation();
			event.preventDefault();
			tdSelected${param.componentId}();
		}
	});
});

function tdSelected${param.componentId}(){
	if(window["tableHideColSelectorWin"]!=undefined){
		tableHideColSelectorWin();//指标库类型时，关闭指标列表窗口
	}
	StoreData.curContainerId='${param.containerId}';
	StoreData.curComponentId='${param.componentId}';
	isFirstSelectTdFlag${param.componentId}=true;//重置是否是第一个选择的单元格的标志
	if(!hasExcuteSeleted${param.componentId}){//是否是已经执行过选中（选中多个单元格时用到，只执行一次）
		$("#comp_scoll_${param.componentId}").parent().click();
		hasExcuteSeleted${param.componentId}=true;//设置 是否是已经执行过选中 标识为 已执行过
	}
	var $selectedsShow=$('#selectable_${param.componentId}').find('.ui-selected');//取所有选中单元格（可见区域）
	var $selectTable = $selectedsShow.eq(0).parent().parent().parent();
	var selectTableTrNum=$selectTable.find("tr").size();
	/*取最后选择的单元格*/
	var maxRow=0;//行最大位移（开始单元格行号与结束单元格的行号的差的绝对值）
	var maxCol=0;//列最大位移
	$selectedsShow.each(function(inda,doma){
		var tempRow=parseInt($(doma).attr("istt").substring(2)-1);//单元格行号
		var tempCol=parseInt($(doma).attr("tdInd"));////单元格列号
		if(inda==0){//为结束单元格赋初值
			endSelectTd${param.componentId}.row=tempRow;
			endSelectTd${param.componentId}.col=tempCol;
		}
		if(Math.abs(tempRow-beginSelectTd${param.componentId}.row)>=maxRow){//获取结束单元格的行号（取已选单元格中行位移最大的单元格的行号）
			maxRow=Math.abs(tempRow-beginSelectTd${param.componentId}.row);
			endSelectTd${param.componentId}.row=tempRow;
		}
		if(Math.abs(tempCol-beginSelectTd${param.componentId}.col)>=maxCol){//获取结束单元格的列号
			maxCol=Math.abs(tempCol-beginSelectTd${param.componentId}.col);
			endSelectTd${param.componentId}.col=tempCol;
		}
		
	});
	var judType=(((endSelectTd${param.componentId}.row-beginSelectTd${param.componentId}.row)>=0)?"1":"0")+(((endSelectTd${param.componentId}.col-beginSelectTd${param.componentId}.col)>=0)?"1":"0");//开始单元格和结束单元格的关系，分为四种，详见下面
	$selectTable.find("td").each(function(tdInd,tdDom){
		var tempRow=parseInt($(tdDom).attr("istt").substring(2)-1);
		var tempCol=parseInt($(tdDom).attr("tdInd"));
		if(judType=='00'){//结束单元格行号小于开始单元格的行号并且结束单元格列号也小于开始单元格的列号，相当于结束单元格在以开始单元格为原点的坐标轴的第四象限内
			if(tempRow>=endSelectTd${param.componentId}.row&&tempRow<=beginSelectTd${param.componentId}.row&&tempCol>=endSelectTd${param.componentId}.col&&tempCol<=beginSelectTd${param.componentId}.col){//判断当前单元格是否在开始单元格与结束单元格组成的矩形区域内
				$(tdDom).css("background","#eb792c");//设置当前单元格背景色为选中颜色
				$(tdDom).addClass("ui-selected");//设置当前单元格class为选中class
			} 
		}else if(judType=='01'){//结束单元格行号小于开始单元格的行号并且结束单元格列号大于开始单元格的列号，相当于结束单元格在以开始单元格为原点的坐标轴的第三象限内
			if(tempRow>=endSelectTd${param.componentId}.row&&tempRow<=beginSelectTd${param.componentId}.row&&tempCol>=beginSelectTd${param.componentId}.col&&tempCol<=endSelectTd${param.componentId}.col){
				$(tdDom).css("background","#eb792c");
				$(tdDom).addClass("ui-selected");
			} 
		}else if(judType=='10'){//结束单元格行号大于开始单元格的行号并且结束单元格列号小于开始单元格的列号，相当于结束单元格在以开始单元格为原点的坐标轴的第二象限内
			if(tempRow>=beginSelectTd${param.componentId}.row&&tempRow<=endSelectTd${param.componentId}.row&&tempCol>=endSelectTd${param.componentId}.col&&tempCol<=beginSelectTd${param.componentId}.col){
				$(tdDom).css("background","#eb792c");
				$(tdDom).addClass("ui-selected");
			}
		}else if(judType=='11'){//结束单元格行号大于开始单元格的行号并且结束单元格列号大于开始单元格的列号，相当于结束单元格在以开始单元格为原点的坐标轴的第一象限内
			if(tempRow>=beginSelectTd${param.componentId}.row&&tempRow<=endSelectTd${param.componentId}.row&&tempCol>=beginSelectTd${param.componentId}.col&&tempCol<=endSelectTd${param.componentId}.col){
				$(tdDom).css("background","#eb792c");
				$(tdDom).addClass("ui-selected");
			}
		}
	});
	$selectedsShow=$selectTable.find('.ui-selected');//取所有选中单元格（所有区域，包可见区域和非可见区域）
	var $selecteds=$selectedsShow.eq(0);
	var isSameSelects=true;
	var isHeadForSame=0;
	var selectedsRowSpan=1;
	$selectedsShow.each(function(indexForSame,domForSame){
		if(indexForSame==0){
			isHeadForSame=$(domForSame).attr("ishead");
			isSameSelects=true;
		}
		if(isHeadForSame!=$(domForSame).attr("ishead")){
			isSameSelects=false;
		}
	});
	
	var tdInd=parseInt($selecteds.attr("tdInd"));
	$("#tableHeadColName_${param.componentId}").val(th_show[tdInd-1]+""+($selecteds.attr("istt").substring(2)-1));		
	$("#tableHeadColValue_${param.componentId}").val(tableRestoreHtml($selecteds.html()));	
	/*设置编辑表头内容区域*/
	if($selectedsShow.size()>1){
		$("#tableHeadColType_${param.componentId}").val(1);
	}
	if($selectedsShow.size()==1){
		if($selectedsShow.attr("ishead")=='1'){
			if($selectedsShow.attr("data-dynheadid")==undefined||$selectedsShow.attr("data-dynheadid")==null){
				$("#tableHeadColType_${param.componentId}").removeAttr("disabled").val(1);
				$("#tableHeadColValue_${param.componentId}").removeAttr("disabled");
			}else{
				$("#tableHeadColType_${param.componentId}").removeAttr("disabled").val(2);
				$("#tableHeadColValue_${param.componentId}").attr("disabled","disabled");
			}
			
			
		}else{
			$("#tableHeadColType_${param.componentId}").attr("disabled","disabled");
			$("#tableHeadColValue_${param.componentId}").attr("disabled","disabled");
		}
	}else{
		$("#tableHeadColType_${param.componentId}").attr("disabled","disabled");
		$("#tableHeadColValue_${param.componentId}").attr("disabled","disabled");
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if(isSameSelects){//选中的所有单元格是同类单元格
		if($selecteds.attr("ishead")=='1'){//是表头单元格
				hideToolsPanel();
				/*还原表头属性开始*/
				var isHasMergeCellFlag=false;//是否是有合并的单元格
				var isDynHeadCellFlag=false;//是否是全部为动态表头
				var isContainDynHeadCellFlag=false;//是否是包含动态表头
				for(var a=0;a<$selectedsShow.size();a++){
					/*判断是否是倒数第二行*/
					if((selectTableTrNum-1)!=parseInt($($selectedsShow[a]).attr("istt").substring(2))){
						isLastSecondRowFlag=false;
					}
					/*判断是否有合并*/
					if(($($selectedsShow[a]).attr("colspan")!=null&&$($selectedsShow[a]).attr("colspan")!=undefined&&$($selectedsShow[a]).attr("colspan")!=''&&parseInt($($selectedsShow[a]).attr("colspan"))>1)
					||($($selectedsShow[a]).attr("rowspan")!=null&&$($selectedsShow[a]).attr("rowspan")!=undefined&&$($selectedsShow[a]).attr("rowspan")!=''&&parseInt($($selectedsShow[a]).attr("rowspan"))>1)
					){
						isHasMergeCellFlag=true;
					}
					
					if(a==0){//初始化临时变量
						if($($selectedsShow[a]).attr("data-dynheadid")==undefined||$($selectedsShow[a]).attr("data-dynheadid")==null){
							isDynHeadCellFlag=false;
						}else{
							isDynHeadCellFlag=true;
						}
					}
					
					/*判断是否是全部为动态表头*/
					if((($($selectedsShow[a]).attr("data-dynheadid")==undefined||$($selectedsShow[a]).attr("data-dynheadid")==null)&&isDynHeadCellFlag==true)
					||($($selectedsShow[a]).attr("data-dynheadid")!=undefined&&$($selectedsShow[a]).attr("data-dynheadid")!=null&&isDynHeadCellFlag==false)){
						isDynHeadCellFlag='';
					}
					/*判断是否是包含动态表头*/
					if($($selectedsShow[a]).attr("data-dynheadid")!=undefined&&$($selectedsShow[a]).attr("data-dynheadid")!=null){
						isContainDynHeadCellFlag=true;
					}
					
				}
				/*设置合并、拆分是否可点击*/
				if($selectedsShow.size()==1&&isHasMergeCellFlag&&(!isContainDynHeadCellFlag)){//拆分可点击
					$("#tableHeadMergeCellButton_"+componentId).attr("disabled","disabled");
					$("#tableHeadMergeCellButton_"+componentId).addClass("margerBtnDisable").removeClass("margerBtn");
					$("#tableHeadSplitCellButton_"+componentId).removeAttr("disabled");
					$("#tableHeadSplitCellButton_"+componentId).addClass("splitBtn").removeClass("splitBtnDisable");
				}else if($selectedsShow.size()>1&&(!isHasMergeCellFlag)&&(!isContainDynHeadCellFlag)){//合并可点击
					$("#tableHeadMergeCellButton_"+componentId).removeAttr("disabled");
			    	$("#tableHeadMergeCellButton_"+componentId).addClass("margerBtn").removeClass("margerBtnDisable");
					$("#tableHeadSplitCellButton_"+componentId).attr("disabled","disabled");
					$("#tableHeadSplitCellButton_"+componentId).addClass("splitBtnDisable").removeClass("splitBtn");
				}else{
					$("#tableHeadMergeCellButton_"+componentId).attr("disabled","disabled");
					$("#tableHeadSplitCellButton_"+componentId).attr("disabled","disabled");
					$("#tableHeadMergeCellButton_"+componentId).addClass("margerBtnDisable").removeClass("margerBtn");
					$("#tableHeadSplitCellButton_"+componentId).addClass("splitBtnDisable").removeClass("splitBtn");
				}
				
				
				
				if(isDynHeadCellFlag==true){
					tableHeadColOpenProperties();
					$("#tableHeadColValue_"+componentId).blur();
					return;
				}else{
					hideToolsPanel();
					$("#tableHeadColValue_"+componentId).focus();
				}
				/*还原表头属性结束*/
				
				
		}else{//是数据单元格
			
			var tempTableDataHasTextFlag=false;//选中单元格是否已绑定指标
			var tempTableDataText='';
			for(var a=0;a<$selectedsShow.size();a++){
				tempTableDataText=$($selectedsShow[a]).text();
				if(tempTableDataText!=null&&tempTableDataText!=undefined&&tempTableDataText!=''){
					tempTableDataHasTextFlag=true;
				}
			}
			if(!tempTableDataHasTextFlag){
				//alert("请对当前数据单元格绑定指标后再做操作！");
				LayOutUtil.componentEdit('${param.containerId}');
				return false;
			}
			var url=appBase+'/pages/xbuilder/component/datagrid/PropertiesData.jsp';
			setProPageTitle("组件属性设置");
			$("#propertiesPage").load(url+"?report_id="+reportId+"&t="+(new Date().getTime()),function(){
				
				$.parser.parse($("#propertiesPage"));
				toolsPanel();
				toolsAddHideEvent();
				tableSwitchLType(StoreData.ltype);
				/*还原数据单元格属性开始*/
				var tempTableDataWidth='';//单元格宽度
				var tempTableDataType='';//数据类型 
				var tempTableDataNumberStep='';//小数位 
				var tempTableDataThousand='';//使用千分符(,) 
				var tempTableDataTdType='';//数据类型，维度：dim,指标：kpi
				var tempTableDataAlign='';//对齐方式 
				var tempTableDataRowMerge='';//行间相邻相同数据合并 
				var tempTableDataBorderSetFlag='';//设置边界 
				var tempTableDataBorderValue='';//边界值 
				var tempTableDataBorderGtColor='';//大于颜色 
				var tempTableDataBorderLtColor='';//小于颜色 
				var tempTableDataBorderShowUpDown='';//显示上下箭头 
				var tempTableDataEvent='';//事件类型 
				var tempTableDataEventSelectJson='';//事件json数据 
				for(var a=0;a<$selectedsShow.size();a++){
					tempTableDataText=$($selectedsShow[a]).text();
					if(tempTableDataText!=null&&tempTableDataText!=undefined&&tempTableDataText!=''){
						tempTableDataHasTextFlag=true;
					}
					if(a==0){//初始化临时变量
						tempTableDataWidth=$($selectedsShow[a]).attr("data-tableHeadWidth");
						tempTableDataTdType=$($selectedsShow[a]).attr("data-tableDataTdType");
						tempTableDataNumberStep=$($selectedsShow[a]).attr("data-tableDataNumberStep");
						tempTableDataThousand=$($selectedsShow[a]).attr("data-tableDataThousand");
						tempTableDataType=$($selectedsShow[a]).attr("data-tableDataType");
						tempTableDataAlign=$($selectedsShow[a]).attr("data-tableDataAlign");
						tempTableDataRowMerge=$($selectedsShow[a]).attr("data-tableDataRowMerge");
						tempTableDataBorderSetFlag=$($selectedsShow[a]).attr("data-tableDataBorderSetFlag");
						tempTableDataBorderValue=$($selectedsShow[a]).attr("data-tableDataBorderValue");
						tempTableDataBorderGtColor=$($selectedsShow[a]).attr("data-tableDataBorderGtColor");
						tempTableDataBorderLtColor=$($selectedsShow[a]).attr("data-tableDataBorderLtColor");
						tempTableDataBorderShowUpDown=$($selectedsShow[a]).attr("data-tableDataBorderShowUpDown");
						tempTableDataEvent=$($selectedsShow[a]).attr("data-tableDataEvent");
						tempTableDataEventSelectJson=$($selectedsShow[a]).attr("data-tableEventSelectJson");
					}
					
					
					if(tempTableDataWidth!=$($selectedsShow[a]).attr("data-tableHeadWidth")){
						tempTableDataWidth='';
					}
					if(tempTableDataTdType!=$($selectedsShow[a]).attr("data-tableDataTdType")){
						tempTableDataTdType='';
					}
					if(tempTableDataNumberStep!=$($selectedsShow[a]).attr("data-tableDataNumberStep")){
						tempTableDataNumberStep='';
					}
					if(tempTableDataThousand!=$($selectedsShow[a]).attr("data-tableDataThousand")){
						tempTableDataThousand='';
					}
					if(tempTableDataType!=$($selectedsShow[a]).attr("data-tableDataType")){
						tempTableDataType='';
					}
					if(tempTableDataAlign!=$($selectedsShow[a]).attr("data-tableDataAlign")){
						tempTableDataAlign='';
					}
					if(tempTableDataRowMerge!=$($selectedsShow[a]).attr("data-tableDataRowMerge")){
						tempTableDataRowMerge='';
					}
					if(tempTableDataBorderSetFlag!=$($selectedsShow[a]).attr("data-tableDataBorderSetFlag")){
						tempTableDataBorderSetFlag='';
					}
					if(tempTableDataBorderValue!=$($selectedsShow[a]).attr("data-tableDataBorderValue")){
						tempTableDataBorderValue='';
					}
					if(tempTableDataBorderGtColor!=$($selectedsShow[a]).attr("data-tableDataBorderGtColor")){
						tempTableDataBorderGtColor='';
					}
					if(tempTableDataBorderLtColor!=$($selectedsShow[a]).attr("data-tableDataBorderLtColor")){
						tempTableDataBorderLtColor='';
					}
					if(tempTableDataBorderShowUpDown!=$($selectedsShow[a]).attr("data-tableDataBorderShowUpDown")){
						tempTableDataBorderShowUpDown='';
					}
					if(tempTableDataEvent!=$($selectedsShow[a]).attr("data-tableDataEvent")){
						tempTableDataEvent='';
					}
					if(tempTableDataEventSelectJson!=$($selectedsShow[a]).attr("data-tableEventSelectJson")){
						tempTableDataEventSelectJson='';
					}
				}
				
				/*还原数据单元格宽度*/
				if(tempTableDataWidth==''){
					$("#tableDataWidth").numberbox("setValue",'');
				}else{
					if(tempTableDataWidth!=null&&tempTableDataWidth!=undefined){
						$("#tableDataWidth").numberbox("setValue",tempTableDataWidth);
					}else{
						$("#tableDataWidth").numberbox("setValue",'100');
					}
				}
				/*还原 数据类型、小数位数和千分符*/
				if(tempTableDataType==''){
					$("input[name='tableDataType']").iCheck('uncheck');
					$("#tableDataNumberStep").numberbox("setValue",'');
					$("#tableDataNumberStep").numberbox("disable");
					$("#tableDataThousand").iCheck('uncheck');
					$("#tableDataThousand").iCheck('disable');
				}else{
					if(tempTableDataType!=null&&tempTableDataType!=undefined){
						$("input[name='tableDataType'][value='"+tempTableDataType+"']").iCheck('check');
						if(tempTableDataType!='common'){
						
							if(tempTableDataNumberStep==''){
								$("#tableDataNumberStep").numberbox("setValue",'');
								$("#tableDataNumberStep").numberbox("disable");
							}else{
								if(tempTableDataNumberStep!=null&&tempTableDataNumberStep!=undefined){
									$("#tableDataNumberStep").numberbox("setValue",tempTableDataNumberStep);
									$("#tableDataNumberStep").numberbox("enable");
								}else{
									$("#tableDataNumberStep").numberbox("setValue",0);
									$("#tableDataNumberStep").numberbox("enable");
								}
							}
							
							if(tempTableDataThousand==''){
								$("#tableDataThousand").iCheck('uncheck');
								$("#tableDataThousand").iCheck('disable');
							}else{
								if(tempTableDataThousand!=null&&tempTableDataThousand!=undefined&&tempTableDataThousand!='0'){
									$("#tableDataThousand").iCheck('check');
									$("#tableDataThousand").iCheck('enable');
								}else{
									$("#tableDataThousand").iCheck('uncheck');
									$("#tableDataThousand").iCheck('enable');
								}
							}
							
						}else{
							$("#tableDataNumberStep").numberbox("setValue",'');
							$("#tableDataNumberStep").numberbox("disable");
							$("#tableDataThousand").iCheck('uncheck');
							$("#tableDataThousand").iCheck('disable');
						}
					}else{
						$("input[name='tableDataType'][value='common']").iCheck('check');
						$("#tableDataNumberStep").numberbox("setValue",'');
						$("#tableDataNumberStep").numberbox("disable");
						$("#tableDataThousand").iCheck('uncheck');
						$("#tableDataThousand").iCheck('disable');
					}
				}
				
							
				/*还原 对齐方式*/
				if(tempTableDataAlign==''){
					$("#tableDataAlignLeft").addClass("positionLeft").removeClass("positionSelect");
					$("#tableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
					$("#tableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
				}else{
					if(tempTableDataAlign!=null&&tempTableDataAlign!=undefined){
						if(tempTableDataAlign=='left'){
							$("#tableDataAlignLeft").addClass("positionLeftSelect").removeClass("positionLeft");
							$("#tableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
							$("#tableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
						}else if(tempTableDataAlign=='center'){
							$("#tableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
							$("#tableDataAlignCenter").addClass("positionCenterSelect").removeClass("positionCenter");
							$("#tableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
					
						}else if(tempTableDataAlign=='right'){
							$("#tableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
							$("#tableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
							$("#tableDataAlignRight").addClass("positionRightSelect").removeClass("positionRight");
						}
					}else{
						if(tempTableDataTdType==''||tempTableDataTdType==null||tempTableDataTdType==undefined){
							$("#tableDataAlignLeft").addClass("positionLeft").removeClass("positionSelect");
							$("#tableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
							$("#tableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
						}else{
							if(tempTableDataTdType=='dim'){
								$("#tableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
								$("#tableDataAlignCenter").addClass("positionCenterSelect").removeClass("positionCenter");
								$("#tableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
							}else if(tempTableDataTdType=='kpi'){
								$("#tableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
								$("#tableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
								$("#tableDataAlignRight").addClass("positionRightSelect").removeClass("positionRight");
							}
						}
					}
				}
				
				
				/*还原 行间相邻相同数据合并*/
				if(tempTableDataRowMerge==''){
					$("#tableDataRowMerge").iCheck('uncheck');
				}else{
					if(tempTableDataRowMerge!=null&&tempTableDataRowMerge!=undefined&&tempTableDataRowMerge!='0'){
						$("#tableDataRowMerge").iCheck('check');
					}else{
						$("#tableDataRowMerge").iCheck('uncheck');
					}
				}
				
				
				/*还原 设置边界、边界值、大于颜色、小于颜色、显示上下箭头*/
				if(tempTableDataBorderSetFlag==''){
					$("#tableDataBorderSetFlag").iCheck('uncheck');
					$("#tableDataBorderValue").numberbox("setValue",'');
					$("#tableDataBorderValue").numberbox("disable");
					$("#tableDataBorderGtColor").spectrum("set","#00ff00");
					$("#tableDataBorderGtColor").spectrum("disable");
					$("#tableDataBorderLtColor").spectrum("set","#ff0000");
					$("#tableDataBorderLtColor").spectrum("disable");
					$("#tableDataBorderShowUpDown").iCheck('uncheck');
					$("#tableDataBorderShowUpDown").iCheck('disable');
				}else{
					if(tempTableDataBorderSetFlag!=null&&tempTableDataBorderSetFlag!=undefined&&tempTableDataBorderSetFlag!='0'){
						$("#tableDataBorderSetFlag").iCheck('check');
						$("#tableDataBorderValue").numberbox("enable");
						$("#tableDataBorderGtColor").spectrum("enable");
						$("#tableDataBorderLtColor").spectrum("enable");
						$("#tableDataBorderShowUpDown").iCheck('enable');
						if(tempTableDataBorderValue==''){
							$("#tableDataBorderValue").numberbox("setValue",'');
							
						}else{
							if(tempTableDataBorderValue!=null&&tempTableDataBorderValue!=undefined){
								$("#tableDataBorderValue").numberbox("setValue",tempTableDataBorderValue);
							}else{
								$("#tableDataBorderValue").numberbox("setValue",'0');
							}
						}
						
						if(tempTableDataBorderGtColor==''){
							$("#tableDataBorderGtColor").spectrum("set","");
						}else{
							if(tempTableDataBorderGtColor!=null&&tempTableDataBorderGtColor!=undefined){
								$("#tableDataBorderGtColor").spectrum("set",tempTableDataBorderGtColor);
							}else{
								$("#tableDataBorderGtColor").spectrum("set","#00ff00");
							}
						}
						
						if(tempTableDataBorderGtColor==''){
							$("#tableDataBorderLtColor").spectrum("set","");
						}else{
							if(tempTableDataBorderLtColor!=null&&tempTableDataBorderLtColor!=undefined){
								$("#tableDataBorderLtColor").spectrum("set",tempTableDataBorderLtColor);
							}else{
								$("#tableDataBorderLtColor").spectrum("set","#ff0000");
							}
						}
						if(tempTableDataBorderShowUpDown==''){
							$("#tableDataBorderShowUpDown").iCheck('uncheck');
						}else{
							if(tempTableDataBorderShowUpDown!=null&&tempTableDataBorderShowUpDown!=undefined&&tempTableDataBorderShowUpDown!='0'){
								$("#tableDataBorderShowUpDown").iCheck('check');
							}else{
								$("#tableDataBorderShowUpDown").iCheck('uncheck');
							}
						}
						
					}else{
						$("#tableDataBorderSetFlag").iCheck('uncheck');
						$("#tableDataBorderValue").numberbox("setValue",'');
						$("#tableDataBorderValue").numberbox("disable");
						$("#tableDataBorderGtColor").spectrum("set","#00ff00");
						$("#tableDataBorderGtColor").spectrum("disable");
						$("#tableDataBorderLtColor").spectrum("set","#ff0000");
						$("#tableDataBorderLtColor").spectrum("disable");
						$("#tableDataBorderShowUpDown").iCheck('uncheck');
						$("#tableDataBorderShowUpDown").iCheck('disable');
					}
				
				}
				
				/*还原动作*/
				if(tempTableDataEvent==''){
					$("input[name='tableDataEvent']").iCheck('uncheck');
				}else{
					if(tempTableDataEvent==undefined||tempTableDataEvent==null||tempTableDataEvent==''||tempTableDataEvent=='none'){
						$("input[name='tableDataEvent'][value='none']").iCheck('check');
						$("#tableDataEventLinkDiv").hide();
						$("#tableDataEventActiveDiv").hide();
					}else if(tempTableDataEvent=='link'){
						$("input[name='tableDataEvent'][value='link']").iCheck('check');
						$("#tableDataEventLinkDiv").show();
						$("#tableDataEventActiveDiv").hide();
						if(tempTableDataEventSelectJson!=''&&tempTableDataEventSelectJson!=undefined&&tempTableDataEventSelectJson!=null&&tempTableDataEventSelectJson!=''){
							var tableEventSelectJson=$.parseJSON(tempTableDataEventSelectJson);
							if(tableEventSelectJson!=null){
								var eventList=tableEventSelectJson["eventList"];
								if(eventList!=undefined&&eventList!=null&&eventList!=''&&eventList!='null'&&eventList.length>0){
									var event=eventList[0];
									var source=event["source"];
									var sourceShow=event["sourceShow"];
									var parameterShow=event["parameterShow"];
									if(source!=undefined&&source!=null&&source!=''&&source!='null'){
										$("#tableDataEventLink").val(source);
									}
									if(sourceShow!=undefined&&sourceShow!=null&&sourceShow!=''&&sourceShow!='null'){
										$("#tableDataEventLinkShow").val(sourceShow);
									}
									if(parameterShow!=undefined&&parameterShow!=null&&parameterShow!=''&&parameterShow!='null'){
										$("#tableDataEventLinkParamShow").val(parameterShow);
									}
								}
							
							}else{
								$("#tableDataEventLink").val("");
								$("#tableDataEventLinkShow").val("");
								$("#tableDataEventLinkParamShow").val("");
							}
							
						}else{
							$("#tableDataEventLink").val("");
							$("#tableDataEventLinkShow").val("");
							$("#tableDataEventLinkParamShow").val("");
						}
						
						
					}else if(tempTableDataEvent=='active'){
						$("input[name='tableDataEvent'][value='active']").iCheck('check');
						tableDataEventSetActiveShow(reportId,containerId,componentId);
						$("#tableDataEventLinkDiv").hide();
						$("#tableDataEventActiveDiv").show();
					
					}
				
				}
				
				/*操作单元格中包含维度时，禁用数据类型和边界等*/
				if(tempTableDataTdType==''||tempTableDataTdType=='dim'){
					
					/*数据类型等*/
					$("#tableDataTypeCommon").iCheck('check');
					$("input[name='tableDataType']").iCheck('disable');
					$("#tableDataNumberStep").numberbox("setValue",'');
					$("#tableDataNumberStep").numberbox("disable");
					$("#tableDataThousand").iCheck('uncheck');
					$("#tableDataThousand").iCheck('disable');
					
					/*边界等*/
					$("#tableDataBorderSetFlag").iCheck('uncheck');
					$("#tableDataBorderSetFlag").iCheck('disable');
					$("#tableDataBorderValue").numberbox("setValue",'');
					$("#tableDataBorderValue").numberbox("disable");
					$("#tableDataBorderGtColor").spectrum("set","#00ff00");
					$("#tableDataBorderGtColor").spectrum("disable");
					$("#tableDataBorderLtColor").spectrum("set","#ff0000");
					$("#tableDataBorderLtColor").spectrum("disable");
					$("#tableDataBorderShowUpDown").iCheck('uncheck');
					$("#tableDataBorderShowUpDown").iCheck('disable');
					
				}
				/*还原数据单元格属性结束*/
				
			});
		}
	}else{
		hideToolsPanel();
	}
}

</script>
