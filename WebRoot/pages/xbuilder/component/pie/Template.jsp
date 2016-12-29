<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<div id="body_${param.componentId}" class="core-panel" onmouseover="LayOutUtil.setComponent('${param.containerId}','${param.componentId}','${param.ispop}');">
<div id="comp_${param.componentId}" data-fun_edit="pie_fun_edit"></div>
<div id="pie_panel_${param.componentId}" style="width:auto;height:auto;padding:0px;margin: 0px;overflow:hidden;" >
<div id="pie_${param.componentId}" style="width: auto; height: 100%; margin:0 auto 10px auto;"></div>
</div>

<script type="text/javascript">
<e:switch value="${param.pieType}">
  <e:case value="1">
     var options_pie_${param.componentId} ={
	    chart: {
			renderTo: 'pie_${param.componentId}',
			backgroundColor: 'rgba(0,0,0,0)',
			plotShadow: false
		},
		title: {
			text: '饼图模版',
			style:{color:'#8e8e9c',font: 'normal 14px Arial, sans-serif'}
		},
		colors:['#1ea3d5','#d34737','#3b5998', '#1ea3d5','#d34737','#3b5998','#1ea3d5','#d34737','#3b5998','#1ea3d5'],
		tooltip: {
			pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>',
            percentageDecimals: 2
		},
		plotOptions: {
			pie: {
				allowPointSelect: true,
				cursor: 'pointer',
				dataLabels: {
				style:{color:'#666666',font: 'normal 14px microsoft yahei'},
				formatter: function() {
						return '<b>'+ this.point.name +'</b>: '+ this.point.y +' 万';
					}
				}
				
			}
		},exporting:{
			enabled:false
		},
	    series: [{
	    	type:'pie',
	    	name: '指标一',
	    	data: [['1月',230],['2月',130],['3月',330],['4月',210],['5月',150],['6月',200]]
		}]
	};
  </e:case>
  <e:case value="2">
  var options_pie_${param.componentId} ={
		    chart: {
				renderTo: 'pie_${param.componentId}',
				backgroundColor: 'rgba(0,0,0,0)',
				plotShadow: false
			},
			title: {
				text: '环形图模版',
				style:{color:'#666666',font: 'normal 14px microsoft yahei'}
			},
			colors:['#1ea3d5','#d34737','#3b5998', '#1ea3d5','#d34737','#3b5998','#1ea3d5','#d34737','#3b5998','#1ea3d5'],
			tooltip: {
				pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>',
	            percentageDecimals: 2
			},
			plotOptions: {
				pie: {
					allowPointSelect: true,
					cursor: 'pointer',
					dataLabels: {
					style:{color:'#666666',font: 'normal 14px microsoft yahei'},
					formatter: function() {
							return '<b>'+ this.point.name +'</b>: '+ this.point.y +' 万';
						}
					}
					
				}
			},exporting:{
				enabled:false
			},
		    series: [{
		    	type:'pie',
		    	name: '指标一',
		    	innerSize:'40%',
		        data: [['1月',230],['2月',130],['3月',330],['4月',210],['5月',150],['6月',200]]
			}]
		};
  </e:case>
</e:switch>
	<e:if condition="${param.ispop != 'true'}">
		var pheight = parseInt( $("#div_area_${param.containerId}").css("height"));
		$("#pie_panel_${param.componentId}").css("height",(pheight-40)+"px");
		$("#pie_panel_${param.componentId}").css("width",$("#div_area_${param.containerId}").css("width"));
	</e:if>
		cn.com.easy.xbuilder.service.component.PieService.getComponentJsonData(StoreData.xid,'${param.containerId}','${param.componentId}',$.toJSON({}),function(data,exception){
			var jsonObj=$.parseJSON(data);
			if(jsonObj.colors!=""&&jsonObj.colors!=undefined){
				options_pie_${param.componentId}.colors = jsonObj.colors.split(",");
			}
			var chart_pie_${param.componentId} = new Highcharts.Chart(options_pie_${param.componentId}); 
		});
	 
</script>
</div>
