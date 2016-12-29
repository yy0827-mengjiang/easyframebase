<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="cn.com.easy.xbuilder.service.component.ComponentBaseService"%>
<%@ page import="cn.com.easy.xbuilder.element.Report"%>
<%@ page import="cn.com.easy.xbuilder.element.Component"%>
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

<!-- //border: 1px solid #d0d7e5; -->
<div class="core-panel" onmouseover="LayOutUtil.setComponent('${param.containerId}','${param.componentId}','${param.ispop}');">
	<div id="comp_${param.componentId}" style="display: none"  data-fun_edit="crossTableComponentEdit"></div>
	<div id="crosstable_panel_${param.componentId}">
		<div id="editorDiv_${param.componentId}"  style="width:auto;height:auto;padding:0px;margin: 0px;">
			<span style="padding:4px 0 4px 4px; margin-top:4px; display:block;">
				<span>
					<a href="javascript:void(0);" onclick="LayOutUtil.componentEdit('${param.containerId}');return false;" class="icoTableData03">数据修改</a>
					<input type="text" style="text-align: center; width:9%; margin-right:0.1%; border:2px solid #d3cfc8; height:16px; color:#333;" readonly="readonly" id="tableHeadColName_${param.componentId}" name="tableHeadColName_${param.componentId}" value=""/>
					<input type="text" style="width:25%;" id="tableHeadColValue_${param.componentId}" name="tableHeadColValue_${param.componentId}" value="" onblur="setCrossTableHeadColValue(this.value)"/>
				</span>
			</span>
			<div id="comp_main_scoll_${param.componentId}" style="overflow:auto;">
				<div id="comp_scoll_${param.componentId}">
				<table id="selectable_${param.componentId}" border="1" class="reportTable"  style="border-spacing: 0;">
				    <%if(tabHead!=null&&!(tabHead.equals(""))){%>
						<%=tabHead%>
					<%}else{%>
						<script>
						   $("#selectable_${param.componentId}").html(createOriginalDesignTable());
						</script>
					<%}%>
				  </table>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
var hasExcuteSeleted${param.componentId}=true;
var beginSelectTd${param.componentId}={};
var endSelectTd${param.componentId}={};
var isFirstSelectTdFlag${param.componentId}=true;	
var templateTable${param.componentId} = $("#comp_scoll_${param.componentId}").html();
$(function(){
	initSelectable${param.componentId}();
});

/**
 * 初始化表格
 */
function initSelectable${param.componentId}(){
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
}

function tdSelected${param.componentId}(){
	var reportId=StoreData.xid;
	StoreData.curContainerId='${param.containerId}';
	StoreData.curComponentId='${param.componentId}';
	var $selectedsShow=$('#selectable_${param.componentId}').find('.ui-selected');//取所有选中单元格（可见区域）
	var $selecteds=$selectedsShow.eq(0);
	var tdInd=parseInt($selecteds.attr("tdInd"));
	$("#tableHeadColName_${param.componentId}").val(th_show[tdInd-1]+""+($selecteds.attr("istt").substring(2)-1));		
	$("#tableHeadColValue_${param.componentId}").val($selecteds.html());
	$("#tableHeadColValue_${param.componentId}").focus();
	if($selecteds.attr("ishead")!="1"){
		$("#tableHeadColValue_${param.componentId}").attr("disabled","disabled");
	}else{
		$("#tableHeadColValue_${param.componentId}").removeAttr("disabled");
	}
	//如果选择的是列维度或指标标题行
	var isSelectColDimOrKpiColumns = true;
	$selectedsShow.each(function(index,item){
		if($(item).attr("ishead")!="1"){//表头单元格
			isSelectColDimOrKpiColumns=false;
			return false;
		}
	});
	if(isSelectColDimOrKpiColumns){
		hideToolsPanel();
		return;
	}
	//判断是否选择了相同类型的单元格
	var tempSelectColType = "";
	var isSelectSaveTypeCols = true;
	$selectedsShow.each(function(index,item){
		if(index==0){
			tempSelectColType=$(item).attr("colType");
		}else{
			if($(item).attr("colType")!=tempSelectColType){
				isSelectSaveTypeCols = false;
				return false;
			}
		}
	});
	
	if(!isSelectSaveTypeCols){
		hideToolsPanel();
		return;
	}
	
	//判断是否选择的行维度
	var isSelectRowDimColumns = true;
	$selectedsShow.each(function(index,item){
		if($(item).attr("colType")!="rowdimdata"){//表头单元格
			isSelectRowDimColumns=false;
			return false;
		}
	});
	if(isSelectRowDimColumns){//如果选择的行维度
		var url=appBase+'/pages/xbuilder/component/crosstable/PropertiesData.jsp';
		setProPageTitle("组件属性设置");
		$("#propertiesPage").load(url+"?report_id="+reportId+"&t="+(new Date().getTime()),function(){
			$.parser.parse($("#propertiesPage"));
			toolsPanel();
			crossTableSwitchLType(StoreData.ltype);
			var tempTableDataWidth='';//单元格宽度
			var tempTableDataAlign='';//对齐方式 
			var tempTableDataRowMerge='';//行间相邻相同数据合并 
			var tempTableDataEvent='';//事件类型 
			var tempTableDataEventSelectJson='';//事件json数据 
			for(var a=0;a<$selectedsShow.size();a++){
				if(a==0){//初始化临时变量
					tempTableDataWidth=$($selectedsShow[a]).attr("data-tableHeadWidth");
					tempTableDataAlign=$($selectedsShow[a]).attr("data-tableDataAlign");
					tempTableDataRowMerge=$($selectedsShow[a]).attr("data-tableDataRowMerge");
					tempTableDataEvent=$($selectedsShow[a]).attr("data-tableDataEvent");
					tempTableDataEventSelectJson=$($selectedsShow[a]).attr("data-tableEventSelectJson");
				}
				
				if(tempTableDataWidth!=$($selectedsShow[a]).attr("data-tableHeadWidth")){
					tempTableDataWidth='';
				}
				
				if(tempTableDataAlign!=$($selectedsShow[a]).attr("data-tableDataAlign")){
					tempTableDataAlign='';
				}
				
				if(tempTableDataRowMerge!=$($selectedsShow[a]).attr("data-tableDataRowMerge")){
					tempTableDataRowMerge='';
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
			
			/*还原 对齐方式*/
			$("#propertiesStoreDiv").attr("datafmtalign","left");
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
					$("#propertiesStoreDiv").attr("datafmtalign",tempTableDataAlign);
				}else{
					$("#tableDataAlignLeft").addClass("positionLeftSelect").removeClass("positionLeft");
					$("#tableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
					$("#tableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
				}
			}
			
			/*行间相邻相同数据合并*/
			if(tempTableDataRowMerge==''){
				$("#crossTableDataRowMerge").iCheck('uncheck');
			}else{
				if(tempTableDataRowMerge=="1"){
					$("#crossTableDataRowMerge").iCheck('check');
				}else{
					$("#crossTableDataRowMerge").iCheck('uncheck');
				}
			}
			//还原行维度事件
			restoreEvent${param.componentId}(tempTableDataEvent,tempTableDataEventSelectJson);
			setTimeout(function(){
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
			},500);
			return;
	    });
	}
	var isSelectDataColumns = true;
	$selectedsShow.each(function(index,item){
		if($(item).attr("colType")!="kpidata"){//如果不是指标数据列
			isSelectDataColumns=false;
			return false;
		}
	});
	//选中的是数据单元格
	if(isSelectDataColumns){
		for(var i=0;i<$selectedsShow.size();i++){
			if($($selectedsShow[i]).text()==undefined||$($selectedsShow[i]).text()==''){
				hideToolsPanel();
				return;
			}
		}
		
		var url=appBase+'/pages/xbuilder/component/crosstable/PropertiesData.jsp';
		setProPageTitle("组件属性设置");
		$("#propertiesPage").load(url+"?report_id="+reportId+"&t="+(new Date().getTime()),function(){
			$.parser.parse($("#propertiesPage"));
			toolsAddHideEvent();
			crossTableSwitchLType(StoreData.ltype);
			toolsPanel();
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
				$("#propertiesStoreDiv").attr("datafmttype","common");
				$("#propertiesStoreDiv").attr("datafmtthousand","0");
			}else{
				if(tempTableDataType!=null&&tempTableDataType!=undefined){
					$("input[name='tableDataType'][value='"+tempTableDataType+"']").iCheck('check');
					$("#propertiesStoreDiv").attr("datafmttype",tempTableDataType);
					if(tempTableDataType!='common'){
						if(tempTableDataNumberStep==''){
							$("#tableDataNumberStep").numberbox("setValue",'');
						}else{
							if(tempTableDataNumberStep!=null&&tempTableDataNumberStep!=undefined){
								$("#tableDataNumberStep").numberbox("setValue",tempTableDataNumberStep);
								$("#tableDataNumberStep").numberbox("enable");
							}else{
								$("#tableDataNumberStep").numberbox("setValue",0);
								$("#tableDataNumberStep").numberbox("enable");
							}
						}
						//是否显示千分位符
						if(tempTableDataThousand==''){
							$("#tableDataThousand").iCheck('uncheck');
							$("#tableDataThousand").iCheck('disable');
							$("#propertiesStoreDiv").attr("datafmtthousand","0");
						}else{
							if(tempTableDataThousand!=null&&tempTableDataThousand!=undefined&&tempTableDataThousand!='0'){
								$("#tableDataThousand").iCheck('check');
								$("#tableDataThousand").iCheck('enable');
								$("#propertiesStoreDiv").attr("datafmtthousand","1");
							}else{
								$("#tableDataThousand").iCheck('uncheck');
								$("#tableDataThousand").iCheck('enable');
								$("#propertiesStoreDiv").attr("datafmtthousand","0");
							}
						}
					}else{
						$("#tableDataNumberStep").numberbox("setValue",'');
						$("#tableDataNumberStep").numberbox("disable");
						$("#tableDataThousand").iCheck('uncheck');
						$("#tableDataThousand").iCheck('disable');
						$("#propertiesStoreDiv").attr("datafmtthousand","0");
					}
				}else{
					$("input[name='tableDataType'][value='common']").iCheck('check');
					$("#tableDataNumberStep").numberbox("setValue",'');
					$("#tableDataNumberStep").numberbox("disable");
					$("#tableDataThousand").iCheck('uncheck');
					$("#tableDataThousand").iCheck('disable');
					$("#propertiesStoreDiv").attr("datafmttype","common");
					$("#propertiesStoreDiv").attr("datafmtthousand","0");
				}
			}
						
			/*还原 对齐方式*/
			$("#propertiesStoreDiv").attr("datafmtalign","right");
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
					$("#propertiesStoreDiv").attr("datafmtalign",tempTableDataAlign);
				}else{
					$("#tableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
					$("#tableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
					$("#tableDataAlignRight").addClass("positionRightSelect").removeClass("positionRight");
				}
			}
			
			/*行间相邻相同数据合并*/
			if(tempTableDataRowMerge==''){
				$("#crossTableDataRowMerge").iCheck('uncheck');
			}else{
				if(tempTableDataRowMerge=="1"){
					$("#crossTableDataRowMerge").iCheck('check');
				}else{
					$("#crossTableDataRowMerge").iCheck('uncheck');
				}
			}
			/*还原 设置边界、边界值、大于颜色、小于颜色、显示上下箭头*/
			if(tempTableDataBorderSetFlag==''){
				$("#tableDataBorderSetFlag").iCheck("uncheck");
				$("#propertiesStoreDiv").attr("datafmtisbd","0");
				$("#tableDataBorderValue").numberbox("setValue","");
				$("#tableDataBorderValue").numberbox("disable");
				$("#tableDataBorderGtColor").spectrum("set","#00ff00");
				$("#propertiesStoreDiv").attr("datafmtbdup","#00ff00");
				$("#tableDataBorderGtColor").spectrum("disable");
				$("#tableDataBorderLtColor").spectrum("set","#ff0000");
				$("#propertiesStoreDiv").attr("datafmtbddown","#ff0000");
				$("#tableDataBorderLtColor").spectrum("disable");
				$("#tableDataBorderShowUpDown").iCheck("uncheck");
				$("#tableDataBorderShowUpDown").iCheck("disable");
				$("#propertiesStoreDiv").attr("datafmtisarrow","0");
			}else{
				if(tempTableDataBorderSetFlag!=null&&tempTableDataBorderSetFlag!=undefined&&tempTableDataBorderSetFlag!='0'){
					$("#tableDataBorderSetFlag").iCheck("check");
					$("#propertiesStoreDiv").attr("datafmtisbd","1");
					$("#tableDataBorderValue").numberbox("enable");
					$("#tableDataBorderGtColor").spectrum("enable");
					$("#tableDataBorderLtColor").spectrum("enable");
					$("#tableDataBorderShowUpDown").iCheck("enable");
					//边界值
					if(tempTableDataBorderValue==''){
						$("#tableDataBorderValue").numberbox("setValue",'');
					}else{
						if(tempTableDataBorderValue!=null&&tempTableDataBorderValue!=undefined){
							$("#tableDataBorderValue").numberbox("setValue",tempTableDataBorderValue);
						}else{
							$("#tableDataBorderValue").numberbox("setValue",'0');
						}
					}
					//大于边界值颜色
					if(tempTableDataBorderGtColor==''){
						$("#tableDataBorderGtColor").spectrum("set","");
						$("#propertiesStoreDiv").attr("datafmtbdup","#00ff00");
					}else{
						if(tempTableDataBorderGtColor!=null&&tempTableDataBorderGtColor!=undefined){
							$("#tableDataBorderGtColor").spectrum("set",tempTableDataBorderGtColor);
							$("#propertiesStoreDiv").attr("datafmtbdup",tempTableDataBorderGtColor);
						}else{
							$("#tableDataBorderGtColor").spectrum("set","#00ff00");
							$("#propertiesStoreDiv").attr("datafmtbdup","#00ff00");
						}
					}
					//小于边界值颜色
					if(tempTableDataBorderLtColor==''){
						$("#tableDataBorderLtColor").spectrum("set","");
						$("#propertiesStoreDiv").attr("datafmtbddown","#ff0000");
					}else{
						if(tempTableDataBorderLtColor!=null&&tempTableDataBorderLtColor!=undefined){
							$("#tableDataBorderLtColor").spectrum("set",tempTableDataBorderLtColor);
							$("#propertiesStoreDiv").attr("datafmtbddown",tempTableDataBorderLtColor);
						}else{
							$("#tableDataBorderLtColor").spectrum("set","#ff0000");
							$("#propertiesStoreDiv").attr("datafmtbddown","#ff0000");
						}
					}
					//是否显示上下箭头
					if(tempTableDataBorderShowUpDown==''){
						$("#tableDataBorderShowUpDown").iCheck('uncheck');
						$("#propertiesStoreDiv").attr("datafmtisarrow","0");
					}else{
						if(tempTableDataBorderShowUpDown!=null&&tempTableDataBorderShowUpDown!=undefined&&tempTableDataBorderShowUpDown!='0'){
							$("#tableDataBorderShowUpDown").iCheck('check');
							$("#propertiesStoreDiv").attr("datafmtisarrow","1");
						}else{
							$("#tableDataBorderShowUpDown").iCheck('uncheck');
							$("#propertiesStoreDiv").attr("datafmtisarrow","0");
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
					$("#tableDataBorderShowUpDown").iCheck("uncheck");
					$("#tableDataBorderShowUpDown").iCheck("disable");
					
					$("#propertiesStoreDiv").attr("datafmtisbd","0");
					$("#propertiesStoreDiv").attr("datafmtbddown","#ff0000");
					$("#propertiesStoreDiv").attr("datafmtbdup","#00ff00");
					$("#propertiesStoreDiv").attr("datafmtisarrow","0"); 
				}
			}
			
			/*还原动作*/
			restoreEvent${param.componentId}(tempTableDataEvent,tempTableDataEventSelectJson);
			/*还原数据单元格属性结束*/
		});
	}
}

/*还原动作*/
function restoreEvent${param.componentId}(tempTableDataEvent,tempTableDataEventSelectJson){
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
			crossTableDataSetEvent('active');
			$("#tableDataEventLinkDiv").hide();
			$("#tableDataEventActiveDiv").show();
		}
	}
}
</script>

