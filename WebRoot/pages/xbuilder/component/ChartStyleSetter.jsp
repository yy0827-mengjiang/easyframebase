<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<e:q4l var="rowList">select 1 rowno from dual union select 2 from dual union select 3 from dual</e:q4l>
<dl>
      <dt id="legendPosDt">图例位置</dt>
			<dd id="legendPosDd">
			     <p>
					 <span id="bottom" name="legend" title="居下" class="positionIcon positionBottomSelect"  onclick="${param.chartType}_setLegendPosition('bottom')"></span>
			     	 <span id="left" name="legend" title="居左" class="positionIcon positionLeft"  onclick="${param.chartType}_setLegendPosition('left')"></span>
					 <span id="right" name="legend" title="居右" class="positionIcon positionRight" onclick="${param.chartType}_setLegendPosition('right')"></span>
					 <span id="top" name="legend" title="居上" class="positionIcon positionTop"  onclick="${param.chartType}_setLegendPosition('top')"></span>
					 <span id="none" name="legend" title="无" class="positionIcon positionNone" onclick="${param.chartType}_setLegendPosition('none')"></span>
			     </p>
			     <e:if condition="${param.chartType eq 'column' && param.yAxis == 1}">
				    <p>
				        堆叠显示: <input type="checkbox" value="true" id="stacking" name="stacking" class="checkN"/>
				    </p>
				 </e:if>
				 
				 <e:if condition="${param.chartType eq 'columnline'}">
				    <p>
				        堆叠显示: <input type="checkbox" value="true" id="stacking" name="stacking" class="checkN"/>
				    </p>
				 </e:if>
				 
			 </dd>
			 <e:if condition="${param.chartType ne 'pie' && param.chartType ne 'scatter'}">
				 <dd class="blockDd">
				 	<div class="ppSetItem">
				     <table id="${param.chartType}_tb1">
					     <colgroup>
						     <col width="25%" />
						     <col width="25%" />
						     <col width="25%" />
						     <col width="25%" />
					     </colgroup>
					     <thead>
							<tr>
								<th>y轴</th>
								<th>标题</th>
								<th>颜色</th>
								<th>单位</th>
							</tr>
						</thead>
						<tbody>
							<e:forEach items="${rowList.list}" var="row" indexName="index">
							    <e:if condition="${index lt param.yAxis}">
							          <tr>
										<th>${index}</th>
										<td><input type="text" name="${param.chartType}_title" onblur="${param.chartType}_fun_SetScale()" class="wih_65" /></td>
										<td><input type="text" name="${param.chartType}_color" class="colorpk" value="#000"/></td>
										<td><input type="text" name="${param.chartType}_unit"  onblur="${param.chartType}_fun_SetScale()" class="wih_45" /></td>
									   </tr>
							    </e:if>
							</e:forEach>
						</tbody> 
				  </table>
				  </div>
				 </dd>
			 </e:if>
	</dl>
			 
<div id="colorListDiv">
    <div class="color_setter">
    	<h5>彩色</h5>
    	<ul id="singleColorUl"></ul>
    </div>
    <div class="color_setter">
    	<h5>单色</h5>
    	<ul id="muiltiColorUl"></ul>
    </div>
</div>

<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
<script>
   //$(function(){
      if(StoreData.ltype=="2"){
    	  $("#legendPosDt").hide();
    	  $("#legendPosDd").hide();
      }
	  var singleColorArray=["#4e82bc,#c0504e,#9bbb58,#8064a1,#4dacc2,#f79647","#5081bb,#9bbb58,#4aacc5,#2c4d76,#607437,#276a7b","#bb5151,#7e64a1,#f79647,#772c29,#4d3b61,#b65707","#f79645,#4aacc9,#8163a3,#b65609,#236b83,#4d3b61"];
	  var muiltiColorArray=["#375e89,#426da0,#4a7bb5,#7494c5,#a3b3d5,#c2cde1","#8a3936,#a54340,#b84c49,#ca726e,#d5a2a1,#e2c2c3","#72883d,#869d4d,#94b155,#a8c47a,#bfd1a7,#d6e0c5","#5d4776,#6c538a,#7b5f9a,#9380ae,#b2a8c3,#cdc6d6"];
	  //添加单色颜色列表
	  for(var i=0;i<singleColorArray.length;i++){
		  $("#singleColorUl").append("<li></li>");
		  var colorArray=singleColorArray[i].split(",");
		  var $li=$("#singleColorUl").find("li").eq(i);
		  $.each(colorArray,function(index,item){
			  $li.append("<span class='colorItem1' style='background:"+item+"' color='"+item+"'></span>");
		  });
		  $li.click(function(){
			  $("#colorListDiv").find("li").each(function(index2,item2){
				  $(item2).addClass('defaultColorItem').removeClass ('selectColorItem');
			  });
			  $(this).addClass('selectColorItem').removeClass ('defaultColorItem');
			  var colorList = "";
			  $(this).find("span").each(function(index3,item3){
				  colorList+=$(item3).attr("color")+",";
			  });
			  var colors = colorList.substring(0, colorList.length-1);
			  ${param.chartType}_setColors(colors); 
			  resetChartStyle({colors:colors});
		  });
	  }
	  //添加彩色颜色列表
	  for(var i=0;i<muiltiColorArray.length;i++){
		  $("#muiltiColorUl").append("<li></li>");
		  var colorArray=muiltiColorArray[i].split(",");
		  var $li=$("#muiltiColorUl").find("li").eq(i);
		  $.each(colorArray,function(index,item){
			  $li.append("<span class='colorItem1' style='background:"+item+"' color='"+item+"'></span>");
		  });
		  $li.click(function(){
			  $("#colorListDiv").find("li").each(function(index2,item2){
				  $(item2).addClass('defaultColorItem').removeClass ('selectColorItem');
			  });
			  $(this).addClass('selectColorItem').removeClass ('defaultColorItem');
			  var colorList = "";
			  $(this).find("span").each(function(index3,item3){
				  colorList+=$(item3).attr("color")+",";
			  });
			  var colors = colorList.substring(0, colorList.length-1);
			  ${param.chartType}_setColors(colors); 
			  resetChartStyle({colors:colors});
		  });
	  }
	  
	  //回显选择的颜色
	  function selectColorRow(colorStr){
		  $("#colorListDiv").find("li").each(function(index,item){
			  $(item).addClass('defaultColorItem')
		  });
		  $.each(singleColorArray,function(index,item){
			 if(item==colorStr){
				 $("#singleColorUl").find("li").eq(index).addClass('selectColorItem').removeClass ('defaultColorItem');;
				 return false;
			 } 
		  });
		  $.each(muiltiColorArray,function(index,item){
				 if(item==colorStr){
					 $("#muiltiColorUl").find("li").eq(index).addClass('selectColorItem').removeClass ('defaultColorItem');;
					 return false;
				 } 
		 });
	  }
	  
	  <e:if condition="${param.chartType ne 'scatter'}">
		  $("#${param.chartType}_tb1 .colorpk").spectrum({
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
			    	${param.chartType}_fun_SetScale();
			    }
			});
	  	</e:if>
	  
	  <e:if condition="${param.chartType ne 'pie' && param.chartType ne 'scatter'}">
	 	 ${param.chartType}_appendKpiRow();
	  </e:if>
	   
	    
		$('input.checkN').iCheck({
	        labelHover : false,
	        cursor : true,
	        checkboxClass : 'icheckbox_square-blue',
	        radioClass : 'iradio_square-blue',
	        increaseArea : '20%'
		}).on('ifChecked', function(event){ 
			   if($(this).attr("id")=="showTitle"){
				   ${param.chartType}_fun_SetTitle();
			   }else if($(this).attr("id")=="stacking"){
				   ${param.chartType}_fun_SetStacking();
			   }
		}).on('ifUnchecked', function(event){ 
			   if($(this).attr("id")=="showTitle"){
				   ${param.chartType}_fun_SetTitle();
			   }else if($(this).attr("id")=="stacking"){
				   ${param.chartType}_fun_SetStacking();
			   }
		});
		
		function resetChartStyle(styleObj){
			var colors = styleObj.colors;
			$("#colorListDiv").attr("currentColors",colors);
			var chartOption=window['options_${param.chartType}_'+StoreData.curComponentId];
			if('${param.chartType}'=="scatter"){
				var rgbArr = [];
				var hexArr = colors.split(",");
				for(var i = 0;i<hexArr.length;i++){
					rgbArr[i] = hexArr[i].colorRgb();
				}
				chartOption.colors=rgbArr;
			}else{
				chartOption.colors=colors.split(",");
			}
			new Highcharts.Chart(chartOption);
		}
		
		function resetChartOption(option){
			if($("#colorListDiv").attr("currentColors")!=undefined&&$("#colorListDiv").attr("currentColors")!=""){
				option.colors = $("#colorListDiv").attr("currentColors").split(",");
			}
			return option;
		}
		
		function ${param.chartType}_setLegendPosition(position){
			${param.chartType}_restoreLegendPosition(position);
			${param.chartType}_setLegend(position);
		}
		
		function ${param.chartType}_restoreLegendPosition(position){
			if(position=='left'){
				$("#left").addClass("positionLeftSelect").removeClass("positionLeft");
				$("#top").addClass("positionTop").removeClass("positionTopSelect");
				$("#right").addClass("positionRight").removeClass("positionRightSelect");
				$("#bottom").addClass("positionBottom").removeClass("positionBottomSelect");
				$("#none").addClass("positionNone").removeClass("positionNoneSelect");
			}else if(position=='top'){
				$("#top").addClass("positionTopSelect").removeClass("positionTop");
				$("#left").addClass("positionLeft").removeClass("positionLeftSelect");
				$("#right").addClass("positionRight").removeClass("positionRightSelect");
				$("#bottom").addClass("positionBottom").removeClass("positionBottomSelect");
				$("#none").addClass("positionNone").removeClass("positionNoneSelect");
			}else if(position=='right'){
				$("#right").addClass("positionRightSelect").removeClass("positionRight");
				$("#top").addClass("positionTop").removeClass("positionTopSelect");
				$("#left").addClass("positionLeft").removeClass("positionLeftSelect");
				$("#bottom").addClass("positionBottom").removeClass("positionBottomSelect");
				$("#none").addClass("positionNone").removeClass("positionNoneSelect");
			}else if(position=='bottom'){
				$("#bottom").addClass("positionBottomSelect").removeClass("positionBottom");
				$("#top").addClass("positionTop").removeClass("positionTopSelect");
				$("#right").addClass("positionRight").removeClass("positionRightSelect");
				$("#left").addClass("positionLeft").removeClass("positionLeftSelect");
				$("#none").addClass("positionNone").removeClass("positionNoneSelect");
			}else if(position=='none'){
				$("#none").addClass("positionNoneSelect").removeClass("positionNone");
				$("#top").addClass("positionTop").removeClass("positionTopSelect");
				$("#right").addClass("positionRight").removeClass("positionRightSelect");
				$("#left").addClass("positionLeft").removeClass("positionLeftSelect");
				$("#bottom").addClass("positionBottom").removeClass("positionBottomSelect");
			}
		}
   //});
</script>