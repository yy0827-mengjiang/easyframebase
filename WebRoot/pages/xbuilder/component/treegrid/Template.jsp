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

<!-- //border: 1px solid #d0d7e5; style="display: none;"-->
<div class="core-panel" onmouseover="LayOutUtil.setComponent('${param.containerId}','${param.componentId}','${param.ispop}');">
	<div id="comp_${param.componentId}" style="display: none"  data-fun_edit="treeTableComponentEdit"></div><!--  data-fun_edit="treeTableComponentEdit" -->
	<div id="treegrid_panel_${param.componentId}">
		<div id="editorDiv_${param.componentId}"  style="width:auto;height:auto;padding:0px;margin: 0px;">
			<span style=" padding:4px 0 4px 4px; margin-top:4px; display:block;">
				<span>
					<a href="javascript:void(0);" onclick="LayOutUtil.componentEdit('${param.containerId}');return false;" class="icoTableData02">数据修改</a>
					<input type="text" style="text-align: center; width:9%; margin-right:0.1%; border:2px solid  #d3cfc8; height:16px; color:#333;" readonly="readonly" id="treeTableHeadColName_${param.componentId}" name="treeTableHeadColName_${param.componentId}" value=""/>
					<select id="treeTableHeadColType_${param.componentId}" disabled="disabled" onchange="treeTableHeadColTypeValue(this.options[this.options.selectedIndex].value)">
						<option value="1">静态</option>
						<option value="2">动态</option>
					</select>
					<input type="text" style="width:25%;" disabled="disabled" id="treeTableHeadColValue_${param.componentId}" name="treeTableHeadColValue_${param.componentId}" value="" onkeyup="treeTableHeadColValue(this.value)"/>
					<a id="treeTableHeadMergeCellButton_${param.componentId}"  herf="javascript:void(0);" name="treeTableHeadMergeCellButton_${param.componentId}" onclick="treeTableHeadMergeCell()" title="合并" class="margerSplit margerBtnDisable" disabled="disabled"></a>
					<a id="treeTableHeadSplitCellButton_${param.componentId}"  herf="javascript:void(0);" name="treeTableHeadSplitCellButton_${param.componentId}" onclick="treeTableHeadSplitCell()" title="拆分" class="margerSplit splitBtnDisable" disabled="disabled"></a>
				</span>
					
			</span>
			<div id="comp_main_scoll_${param.componentId}" style="overflow:auto;">
				<div id="comp_scoll_${param.componentId}">
				<table id="selectable_${param.componentId}" border="1" class="reporttreeTable reportTable" >
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
								<td class="ui-state-default" istt="td6" tdInd="1"  ishead="1" style="width:100;">下钻名称</td>
								<td class="ui-state-default" istt="td6" tdInd="2"  ishead="1" style="width:100;"></td>
								<td class="ui-state-default" istt="td6" tdInd="3"  ishead="1" style="width:100;"></td>
								<td class="ui-state-default" istt="td6" tdInd="4"  ishead="1" style="width:100;"></td>
								<td class="ui-state-default" istt="td6" tdInd="5"  ishead="1" style="width:100;"></td>
								<td class="ui-state-default" istt="td6" tdInd="6"  ishead="1" style="width:100;"></td>
								<td class="ui-state-default" istt="td6" tdInd="7"  ishead="1" style="width:100;"></td>
							</tr>
							<tr class="ui-th">
								<th class="ui-state-default" istt="td7">6</th>
								<td class="ui-state-default" istt="td7" tdInd="1" data-treeTableDataTdType="drill">下钻数据列</td>
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
	if(window["treeTableHideColSelectorWin"]!=undefined){
		treeTableHideColSelectorWin();//指标库类型时，关闭指标列表窗口
	}
	StoreData.curContainerId='${param.containerId}';
	StoreData.curComponentId='${param.componentId}';
	isFirstSelectTdFlag${param.componentId}=true;//重置是否是第一个选择的单元格的标志
	if(!hasExcuteSeleted${param.componentId}){//是否是已经执行过选中（选中多个单元格时用到，只执行一次）
		$("#comp_scoll_${param.componentId}").parent().click();
		hasExcuteSeleted${param.componentId}=true;//设置 是否是已经执行过选中 标识为 已执行过
	}
	var $selectedsShow=$('#selectable_${param.componentId}').find('.ui-selected');//取所有选中单元格（可见区域）
	var $selectTreeTable = $selectedsShow.eq(0).parent().parent().parent();
	var selectTreeTableTrNum=$selectTreeTable.find("tr").size();
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
	$selectTreeTable.find("td").each(function(tdInd,tdDom){
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
	$selectedsShow=$selectTreeTable.find('.ui-selected');//取所有选中单元格（所有区域，包可见区域和非可见区域）
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
	$("#treeTableHeadColName_${param.componentId}").val(th_show[tdInd-1]+""+($selecteds.attr("istt").substring(2)-1));		
	$("#treeTableHeadColValue_${param.componentId}").val(treeTableRestoreHtml($selecteds.html()));	
	/*设置编辑表头内容区域*/
	if($selectedsShow.size()>1){
		$("#treeTableHeadColType_${param.componentId}").val(1);
	}
	if($selectedsShow.size()==1){
		if($selectedsShow.attr("ishead")=='1'){
			if($selectedsShow.attr("data-dynheadid")==undefined||$selectedsShow.attr("data-dynheadid")==null){
				$("#treeTableHeadColType_${param.componentId}").removeAttr("disabled").val(1);
				$("#treeTableHeadColValue_${param.componentId}").removeAttr("disabled");
			}else{
				$("#treeTableHeadColType_${param.componentId}").removeAttr("disabled").val(2);
				$("#treeTableHeadColValue_${param.componentId}").attr("disabled","disabled");
			}
			
			
		}else{
			$("#treeTableHeadColType_${param.componentId}").attr("disabled","disabled");
			$("#treeTableHeadColValue_${param.componentId}").attr("disabled","disabled");
		}
	}else{
		$("#treeTableHeadColType_${param.componentId}").attr("disabled","disabled");
		$("#treeTableHeadColValue_${param.componentId}").attr("disabled","disabled");
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if(isSameSelects){//选中的所有单元格是同类单元格
		if($selecteds.attr("ishead")=='1'){//是表头单元格
				hideToolsPanel();
				var tempTableHeadContaionDrillFlag=false;//选中单元格是否是下钻表头
				var tempTableHeadIsEnableDrillFlag=false;////选中单元格是否是可编辑的下钻表头
				for(var a=0;a<$selectedsShow.size();a++){
					if($($selectedsShow[a]).attr("tdInd")=='1'){
						tempTableHeadContaionDrillFlag=true;
						if($selecteds.attr("istt").substring(2)==(selectTreeTableTrNum-1)){
							tempTableHeadIsEnableDrillFlag=true;
						}
					}
				}
				if(tempTableHeadContaionDrillFlag){
					$("#treeTableHeadMergeCellButton_"+componentId).attr("disabled","disabled");
					$("#treeTableHeadSplitCellButton_"+componentId).attr("disabled","disabled");
					$("#treeTableHeadMergeCellButton_"+componentId).addClass("margerBtnDisable").removeClass("margerBtn");
					$("#treeTableHeadSplitCellButton_"+componentId).addClass("splitBtnDisable").removeClass("splitBtn");
					$("#treeTableHeadColType_"+componentId).attr("disabled","disabled").val('1');
					if(tempTableHeadIsEnableDrillFlag){
						$("#treeTableHeadColValue_${param.componentId}").removeAttr("disabled");
						$("#treeTableHeadColValue_"+componentId).focus();
					}else{
						$("#treeTableHeadColValue_${param.componentId}").attr("disabled","disabled");
					}
					
				
				}else{
					/*还原表头属性开始*/
					var isHasMergeCellFlag=false;//是否是有合并的单元格
					var isDynHeadCellFlag=false;//是否是全部为动态表头
					var isContainDynHeadCellFlag=false;//是否是包含动态表头
					
					for(var a=0;a<$selectedsShow.size();a++){
						/*判断是否是倒数第二行*/
						if((selectTreeTableTrNum-1)!=parseInt($($selectedsShow[a]).attr("istt").substring(2))){
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
						$("#treeTableHeadMergeCellButton_"+componentId).attr("disabled","disabled");
						$("#treeTableHeadMergeCellButton_"+componentId).addClass("margerBtnDisable").removeClass("margerBtn");
						$("#treeTableHeadSplitCellButton_"+componentId).removeAttr("disabled");
						$("#treeTableHeadSplitCellButton_"+componentId).addClass("splitBtn").removeClass("splitBtnDisable");
					}else if($selectedsShow.size()>1&&(!isHasMergeCellFlag)&&(!isContainDynHeadCellFlag)){//合并可点击
						$("#treeTableHeadMergeCellButton_"+componentId).removeAttr("disabled");
				    	$("#treeTableHeadMergeCellButton_"+componentId).addClass("margerBtn").removeClass("margerBtnDisable");
						$("#treeTableHeadSplitCellButton_"+componentId).attr("disabled","disabled");
						$("#treeTableHeadSplitCellButton_"+componentId).addClass("splitBtnDisable").removeClass("splitBtn");
					}else{
						$("#treeTableHeadMergeCellButton_"+componentId).attr("disabled","disabled");
						$("#treeTableHeadSplitCellButton_"+componentId).attr("disabled","disabled");
						$("#treeTableHeadMergeCellButton_"+componentId).addClass("margerBtnDisable").removeClass("margerBtn");
						$("#treeTableHeadSplitCellButton_"+componentId).addClass("splitBtnDisable").removeClass("splitBtn");
					}
					
					if(isDynHeadCellFlag==true){
						treeTableHeadColOpenProperties();
						$("#treeTableHeadColValue_"+componentId).blur();
						return;
					}else{
						hideToolsPanel();
						$("#treeTableHeadColValue_"+componentId).focus();
					}
					/*还原表头属性结束*/
				
				}
				
				
				
		}else{//是数据单元格
			
			var tempTableDataHasTextFlag=false;//选中单元格是否已绑定指标
			var tempTableDataIsDrillFlag=false;//选中单元格是否是下钻数据列
			var tempTableDataText='';
			for(var a=0;a<$selectedsShow.size();a++){
				tempTableDataText=$($selectedsShow[a]).text();
				if(tempTableDataText!=null&&tempTableDataText!=undefined&&tempTableDataText!=''){
					tempTableDataHasTextFlag=true;
				}
				if(a==0&&$($selectedsShow[a]).attr("tdInd")=='1'){
					tempTableDataIsDrillFlag=true;
				}
			}
			if(!tempTableDataHasTextFlag){
				//alert("请对当前数据单元格绑定指标后再做操作！");
				LayOutUtil.componentEdit('${param.containerId}');
				return false;
			}
			if(tempTableDataIsDrillFlag){//选中单元格是下钻列
				var url='';
				if(StoreData.dsType=='1'){
					url=appBase+'/pages/xbuilder/component/treegrid/sql/PropertiesDrill.jsp';
				}else if(StoreData.dsType=='2'){
					url=appBase+'/pages/xbuilder/component/treegrid/kpi/PropertiesDrill.jsp';
				}
				setProPageTitle("组件属性设置");
				$("#propertiesPage").load(url+"?report_id="+reportId+"&t="+(new Date().getTime()),function(){
					$.parser.parse($("#propertiesPage"));
					toolsPanel();
					toolsAddHideEvent();
					treeTableDrillInitDrillProperty(StoreData.xid,StoreData.curContainerId,StoreData.curComponentId);
				});
				
				
			}else{//选中单元格不是下钻列
				var url=appBase+'/pages/xbuilder/component/treegrid/PropertiesData.jsp';
				setProPageTitle("组件属性设置");
				$("#propertiesPage").load(url+"?report_id="+reportId+"&t="+(new Date().getTime()),function(){
					$.parser.parse($("#propertiesPage"));
					toolsPanel();
					toolsAddHideEvent();
					treeTableSwitchLType(StoreData.ltype);
					/*还原数据单元格属性开始*/
					var temptreeTableDataWidth='';//单元格宽度
					var temptreeTableDataType='';//数据类型 
					var temptreeTableDataNumberStep='';//小数位 
					var temptreeTableDataThousand='';//使用千分符(,) 
					var temptreeTableDataTdType='';//数据类型，维度：dim,指标：kpi
					var temptreeTableDataAlign='';//对齐方式 
					var temptreeTableDataRowMerge='';//行间相邻相同数据合并 
					var temptreeTableDataBorderSetFlag='';//设置边界 
					var temptreeTableDataBorderValue='';//边界值 
					var temptreeTableDataBorderGtColor='';//大于颜色 
					var temptreeTableDataBorderLtColor='';//小于颜色 
					var temptreeTableDataBorderShowUpDown='';//显示上下箭头 
					var temptreeTableDataEvent='';//事件类型 
					var temptreeTableDataEventSelectJson='';//事件json数据 
					for(var a=0;a<$selectedsShow.size();a++){
						temptreeTableDataText=$($selectedsShow[a]).text();
						if(temptreeTableDataText!=null&&temptreeTableDataText!=undefined&&temptreeTableDataText!=''){
							temptreeTableDataHasTextFlag=true;
						}
						if(a==0){//初始化临时变量
							temptreeTableDataWidth=$($selectedsShow[a]).attr("data-treeTableHeadWidth");
							temptreeTableDataTdType=$($selectedsShow[a]).attr("data-treeTableDataTdType");
							temptreeTableDataNumberStep=$($selectedsShow[a]).attr("data-treeTableDataNumberStep");
							temptreeTableDataThousand=$($selectedsShow[a]).attr("data-treeTableDataThousand");
							temptreeTableDataType=$($selectedsShow[a]).attr("data-treeTableDataType");
							temptreeTableDataAlign=$($selectedsShow[a]).attr("data-treeTableDataAlign");
							temptreeTableDataRowMerge=$($selectedsShow[a]).attr("data-treeTableDataRowMerge");
							temptreeTableDataBorderSetFlag=$($selectedsShow[a]).attr("data-treeTableDataBorderSetFlag");
							temptreeTableDataBorderValue=$($selectedsShow[a]).attr("data-treeTableDataBorderValue");
							temptreeTableDataBorderGtColor=$($selectedsShow[a]).attr("data-treeTableDataBorderGtColor");
							temptreeTableDataBorderLtColor=$($selectedsShow[a]).attr("data-treeTableDataBorderLtColor");
							temptreeTableDataBorderShowUpDown=$($selectedsShow[a]).attr("data-treeTableDataBorderShowUpDown");
							temptreeTableDataEvent=$($selectedsShow[a]).attr("data-treeTableDataEvent");
							temptreeTableDataEventSelectJson=$($selectedsShow[a]).attr("data-treeTableEventSelectJson");
						}
						
						
						if(temptreeTableDataWidth!=$($selectedsShow[a]).attr("data-treeTableHeadWidth")){
							temptreeTableDataWidth='';
						}
						if(temptreeTableDataTdType!=$($selectedsShow[a]).attr("data-treeTableDataTdType")){
							temptreeTableDataTdType='';
						}
						if(temptreeTableDataNumberStep!=$($selectedsShow[a]).attr("data-treeTableDataNumberStep")){
							temptreeTableDataNumberStep='';
						}
						if(temptreeTableDataThousand!=$($selectedsShow[a]).attr("data-treeTableDataThousand")){
							temptreeTableDataThousand='';
						}
						if(temptreeTableDataType!=$($selectedsShow[a]).attr("data-treeTableDataType")){
							temptreeTableDataType='';
						}
						if(temptreeTableDataAlign!=$($selectedsShow[a]).attr("data-treeTableDataAlign")){
							temptreeTableDataAlign='';
						}
						if(temptreeTableDataRowMerge!=$($selectedsShow[a]).attr("data-treeTableDataRowMerge")){
							temptreeTableDataRowMerge='';
						}
						if(temptreeTableDataBorderSetFlag!=$($selectedsShow[a]).attr("data-treeTableDataBorderSetFlag")){
							temptreeTableDataBorderSetFlag='';
						}
						if(temptreeTableDataBorderValue!=$($selectedsShow[a]).attr("data-treeTableDataBorderValue")){
							temptreeTableDataBorderValue='';
						}
						if(temptreeTableDataBorderGtColor!=$($selectedsShow[a]).attr("data-treeTableDataBorderGtColor")){
							temptreeTableDataBorderGtColor='';
						}
						if(temptreeTableDataBorderLtColor!=$($selectedsShow[a]).attr("data-treeTableDataBorderLtColor")){
							temptreeTableDataBorderLtColor='';
						}
						if(temptreeTableDataBorderShowUpDown!=$($selectedsShow[a]).attr("data-treeTableDataBorderShowUpDown")){
							temptreeTableDataBorderShowUpDown='';
						}
						if(temptreeTableDataEvent!=$($selectedsShow[a]).attr("data-treeTableDataEvent")){
							temptreeTableDataEvent='';
						}
						if(temptreeTableDataEventSelectJson!=$($selectedsShow[a]).attr("data-treeTableEventSelectJson")){
							temptreeTableDataEventSelectJson='';
						}
					}
					
					/*还原数据单元格宽度*/
					if(temptreeTableDataWidth==''){
						$("#treeTableDataWidth").numberbox("setValue",'');
					}else{
						if(temptreeTableDataWidth!=null&&temptreeTableDataWidth!=undefined){
							$("#treeTableDataWidth").numberbox("setValue",temptreeTableDataWidth);
						}else{
							$("#treeTableDataWidth").numberbox("setValue",'100');
						}
					}
					/*还原 数据类型、小数位数和千分符*/
					if(temptreeTableDataType==''){
						$("input[name='treeTableDataType']").iCheck('uncheck');
						$("#treeTableDataNumberStep").numberbox("setValue",'');
						$("#treeTableDataNumberStep").numberbox("disable");
						$("#treeTableDataThousand").iCheck('uncheck');
						$("#treeTableDataThousand").iCheck('disable');
					}else{
						if(temptreeTableDataType!=null&&temptreeTableDataType!=undefined){
							$("input[name='treeTableDataType'][value='"+temptreeTableDataType+"']").iCheck('check');
							if(temptreeTableDataType!='common'){
							
								if(temptreeTableDataNumberStep==''){
									$("#treeTableDataNumberStep").numberbox("setValue",'');
									$("#treeTableDataNumberStep").numberbox("disable");
								}else{
									if(temptreeTableDataNumberStep!=null&&temptreeTableDataNumberStep!=undefined){
										$("#treeTableDataNumberStep").numberbox("setValue",temptreeTableDataNumberStep);
										$("#treeTableDataNumberStep").numberbox("enable");
									}else{
										$("#treeTableDataNumberStep").numberbox("setValue",0);
										$("#treeTableDataNumberStep").numberbox("enable");
									}
								}
								
								if(temptreeTableDataThousand==''){
									$("#treeTableDataThousand").iCheck('uncheck');
									$("#treeTableDataThousand").iCheck('disable');
								}else{
									if(temptreeTableDataThousand!=null&&temptreeTableDataThousand!=undefined&&temptreeTableDataThousand!='0'){
										$("#treeTableDataThousand").iCheck('check');
										$("#treeTableDataThousand").iCheck('enable');
									}else{
										$("#treeTableDataThousand").iCheck('uncheck');
										$("#treeTableDataThousand").iCheck('enable');
									}
								}
								
							}else{
								$("#treeTableDataNumberStep").numberbox("setValue",'');
								$("#treeTableDataNumberStep").numberbox("disable");
								$("#treeTableDataThousand").iCheck('uncheck');
								$("#treeTableDataThousand").iCheck('disable');
							}
						}else{
							$("input[name='treeTableDataType'][value='common']").iCheck('check');
							$("#treeTableDataNumberStep").numberbox("setValue",'');
							$("#treeTableDataNumberStep").numberbox("disable");
							$("#treeTableDataThousand").iCheck('uncheck');
							$("#treeTableDataThousand").iCheck('disable');
						}
					}
					
								
					/*还原 对齐方式*/
					if(temptreeTableDataAlign==''){
						$("#treeTableDataAlignLeft").addClass("positionLeft").removeClass("positionSelect");
						$("#treeTableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
						$("#treeTableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
					}else{
						if(temptreeTableDataAlign!=null&&temptreeTableDataAlign!=undefined){
							if(temptreeTableDataAlign=='left'){
								$("#treeTableDataAlignLeft").addClass("positionLeftSelect").removeClass("positionLeft");
								$("#treeTableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
								$("#treeTableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
							}else if(temptreeTableDataAlign=='center'){
								$("#treeTableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
								$("#treeTableDataAlignCenter").addClass("positionCenterSelect").removeClass("positionCenter");
								$("#treeTableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
						
							}else if(temptreeTableDataAlign=='right'){
								$("#treeTableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
								$("#treeTableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
								$("#treeTableDataAlignRight").addClass("positionRightSelect").removeClass("positionRight");
							}
						}else{
							if(temptreeTableDataTdType==''||temptreeTableDataTdType==null||temptreeTableDataTdType==undefined){
								$("#treeTableDataAlignLeft").addClass("positionLeft").removeClass("positionSelect");
								$("#treeTableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
								$("#treeTableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
							}else{
								if(temptreeTableDataTdType=='dim'){
									$("#treeTableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
									$("#treeTableDataAlignCenter").addClass("positionCenterSelect").removeClass("positionCenter");
									$("#treeTableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
								}else if(temptreeTableDataTdType=='kpi'){
									$("#treeTableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
									$("#treeTableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
									$("#treeTableDataAlignRight").addClass("positionRightSelect").removeClass("positionRight");
								}
							}
						}
					}
					
					
					/*还原 行间相邻相同数据合并*/
					if(temptreeTableDataRowMerge==''){
						$("#treeTableDataRowMerge").iCheck('uncheck');
					}else{
						if(temptreeTableDataRowMerge!=null&&temptreeTableDataRowMerge!=undefined&&temptreeTableDataRowMerge!='0'){
							$("#treeTableDataRowMerge").iCheck('check');
						}else{
							$("#treeTableDataRowMerge").iCheck('uncheck');
						}
					}
					
					
					/*还原 设置边界、边界值、大于颜色、小于颜色、显示上下箭头*/
					if(temptreeTableDataBorderSetFlag==''){
						$("#treeTableDataBorderSetFlag").iCheck('uncheck');
						$("#treeTableDataBorderValue").numberbox("setValue",'');
						$("#treeTableDataBorderValue").numberbox("disable");
						$("#treeTableDataBorderGtColor").spectrum("set","#00ff00");
						$("#treeTableDataBorderGtColor").spectrum("disable");
						$("#treeTableDataBorderLtColor").spectrum("set","#ff0000");
						$("#treeTableDataBorderLtColor").spectrum("disable");
						$("#treeTableDataBorderShowUpDown").iCheck('uncheck');
						$("#treeTableDataBorderShowUpDown").iCheck('disable');
					}else{
						if(temptreeTableDataBorderSetFlag!=null&&temptreeTableDataBorderSetFlag!=undefined&&temptreeTableDataBorderSetFlag!='0'){
							$("#treeTableDataBorderSetFlag").iCheck('check');
							$("#treeTableDataBorderValue").numberbox("enable");
							$("#treeTableDataBorderGtColor").spectrum("enable");
							$("#treeTableDataBorderLtColor").spectrum("enable");
							$("#treeTableDataBorderShowUpDown").iCheck('enable');
							if(temptreeTableDataBorderValue==''){
								$("#treeTableDataBorderValue").numberbox("setValue",'');
								
							}else{
								if(temptreeTableDataBorderValue!=null&&temptreeTableDataBorderValue!=undefined){
									$("#treeTableDataBorderValue").numberbox("setValue",temptreeTableDataBorderValue);
								}else{
									$("#treeTableDataBorderValue").numberbox("setValue",'0');
								}
							}
							
							if(temptreeTableDataBorderGtColor==''){
								$("#treeTableDataBorderGtColor").spectrum("set","");
							}else{
								if(temptreeTableDataBorderGtColor!=null&&temptreeTableDataBorderGtColor!=undefined){
									$("#treeTableDataBorderGtColor").spectrum("set",temptreeTableDataBorderGtColor);
								}else{
									$("#treeTableDataBorderGtColor").spectrum("set","#00ff00");
								}
							}
							
							if(temptreeTableDataBorderGtColor==''){
								$("#treeTableDataBorderLtColor").spectrum("set","");
							}else{
								if(temptreeTableDataBorderLtColor!=null&&temptreeTableDataBorderLtColor!=undefined){
									$("#treeTableDataBorderLtColor").spectrum("set",temptreeTableDataBorderLtColor);
								}else{
									$("#treeTableDataBorderLtColor").spectrum("set","#ff0000");
								}
							}
							if(temptreeTableDataBorderShowUpDown==''){
								$("#treeTableDataBorderShowUpDown").iCheck('uncheck');
							}else{
								if(temptreeTableDataBorderShowUpDown!=null&&temptreeTableDataBorderShowUpDown!=undefined&&temptreeTableDataBorderShowUpDown!='0'){
									$("#treeTableDataBorderShowUpDown").iCheck('check');
								}else{
									$("#treeTableDataBorderShowUpDown").iCheck('uncheck');
								}
							}
							
						}else{
							$("#treeTableDataBorderSetFlag").iCheck('uncheck');
							$("#treeTableDataBorderValue").numberbox("setValue",'');
							$("#treeTableDataBorderValue").numberbox("disable");
							$("#treeTableDataBorderGtColor").spectrum("set","#00ff00");
							$("#treeTableDataBorderGtColor").spectrum("disable");
							$("#treeTableDataBorderLtColor").spectrum("set","#ff0000");
							$("#treeTableDataBorderLtColor").spectrum("disable");
							$("#treeTableDataBorderShowUpDown").iCheck('uncheck');
							$("#treeTableDataBorderShowUpDown").iCheck('disable');
						}
					
					}
					
					/*还原动作*/
					if(temptreeTableDataEvent==''){
						$("input[name='treeTableDataEvent']").iCheck('uncheck');
					}else{
						if(temptreeTableDataEvent==undefined||temptreeTableDataEvent==null||temptreeTableDataEvent==''||temptreeTableDataEvent=='none'){
							$("input[name='treeTableDataEvent'][value='none']").iCheck('check');
							$("#treeTableDataEventLinkDiv").hide();
							$("#treeTableDataEventActiveDiv").hide();
						}else if(temptreeTableDataEvent=='link'){
							$("input[name='treeTableDataEvent'][value='link']").iCheck('check');
							$("#treeTableDataEventLinkDiv").show();
							$("#treeTableDataEventActiveDiv").hide();
							if(temptreeTableDataEventSelectJson!=''&&temptreeTableDataEventSelectJson!=undefined&&temptreeTableDataEventSelectJson!=null&&temptreeTableDataEventSelectJson!=''){
								var treeTableEventSelectJson=$.parseJSON(temptreeTableDataEventSelectJson);
								if(treeTableEventSelectJson!=null){
									var eventList=treeTableEventSelectJson["eventList"];
									if(eventList!=undefined&&eventList!=null&&eventList!=''&&eventList!='null'&&eventList.length>0){
										var event=eventList[0];
										var source=event["source"];
										var sourceShow=event["sourceShow"];
										var parameterShow=event["parameterShow"];
										if(source!=undefined&&source!=null&&source!=''&&source!='null'){
											$("#treeTableDataEventLink").val(source);
										}
										if(sourceShow!=undefined&&sourceShow!=null&&sourceShow!=''&&sourceShow!='null'){
											$("#treeTableDataEventLinkShow").val(sourceShow);
										}
										if(parameterShow!=undefined&&parameterShow!=null&&parameterShow!=''&&parameterShow!='null'){
											$("#treeTableDataEventLinkParamShow").val(parameterShow);
										}
									}
								
								}else{
									$("#treeTableDataEventLink").val("");
									$("#treeTableDataEventLinkShow").val("");
									$("#treeTableDataEventLinkParamShow").val("");
								}
								
							}else{
								$("#treeTableDataEventLink").val("");
								$("#treeTableDataEventLinkShow").val("");
								$("#treeTableDataEventLinkParamShow").val("");
							}
							
							
						}else if(temptreeTableDataEvent=='active'){
							$("input[name='treeTableDataEvent'][value='active']").iCheck('check');
							treeTableDataEventSetActiveShow(reportId,containerId,componentId);
							$("#treeTableDataEventLinkDiv").hide();
							$("#treeTableDataEventActiveDiv").show();
						
						}
					
					}
					
					/*操作单元格中包含维度时，禁用数据类型和边界等*/
					if(temptreeTableDataTdType==''||temptreeTableDataTdType=='dim'){
						
						/*数据类型等*/
						$("#treeTableDataTypeCommon").iCheck('check');
						$("input[name='treeTableDataType']").iCheck('disable');
						$("#treeTableDataNumberStep").numberbox("setValue",'');
						$("#treeTableDataNumberStep").numberbox("disable");
						$("#treeTableDataThousand").iCheck('uncheck');
						$("#treeTableDataThousand").iCheck('disable');
						
						/*边界等*/
						$("#treeTableDataBorderSetFlag").iCheck('uncheck');
						$("#treeTableDataBorderSetFlag").iCheck('disable');
						$("#treeTableDataBorderValue").numberbox("setValue",'');
						$("#treeTableDataBorderValue").numberbox("disable");
						$("#treeTableDataBorderGtColor").spectrum("set","#00ff00");
						$("#treeTableDataBorderGtColor").spectrum("disable");
						$("#treeTableDataBorderLtColor").spectrum("set","#ff0000");
						$("#treeTableDataBorderLtColor").spectrum("disable");
						$("#treeTableDataBorderShowUpDown").iCheck('uncheck');
						$("#treeTableDataBorderShowUpDown").iCheck('disable');
						
					}
					/*还原数据单元格属性结束*/
					
				});
			}
		}
	}else{//选中的所有单元格不是同类单元格
		hideToolsPanel();
	}
}

</script>
