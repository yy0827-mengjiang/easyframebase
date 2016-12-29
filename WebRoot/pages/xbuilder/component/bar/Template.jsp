<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<div class="core-panel" onmouseover="LayOutUtil.setComponent('${param.containerId}','${param.componentId}','${param.ispop}');">
<div id="comp_${param.componentId}" data-fun_edit="bar_fun_edit"></div>
<div id="bar_panel_${param.componentId}" style="width:auto;height:auto;padding:0px;margin: 0px;overflow:hidden;">
<div id="bar_${param.componentId}" style="width: auto; height: 100%; margin:0 auto 10px auto;"></div>
<script type="text/javascript">	
	<e:switch value="${param.yAxis}">
	<e:case value="1">
	var options_bar_${param.componentId} = {
			chart: {
				renderTo: 'bar_${param.componentId}',
				backgroundColor: 'rgba(0,0,0,0)'
			},
			title: {
				text: '条形图模版',
				align:'left',
				x: 0,
				y:15,
				style:{color:'#666666',font: 'normal 14px microsoft yahei'}
			},
			colors:['#1ea3d5','#d34737','#3b5998', '#1ea3d5','#d34737','#3b5998','#1ea3d5','#d34737','#3b5998','#1ea3d5'],
			xAxis: {
				categories: ['1季度','2季度','3季度','4季度'],
				gridLineWidth: 1,
				gridLineDashStyle: 'ShortDash',
				gridLineColor: '#dddddd',
				labels: {
					rotation: 0,
					align: 'right',
					style: {
						color:'#333',font: 'normal 14px microsoft yahei'
					}
				}
			},
			yAxis: [{
				gridLineWidth: 0,
				gridLineColor: 'transparent',
				labels: {
						formatter: function() {
							return this.value +'万';
						},
					style:{color:'#333',font: 'normal 14px microsoft yahei'}
					},
					title: {
						text: ''
					},
						opposite: false
					}
				],
			tooltip: {
				shared: true
			},
			legend: {
				align: 'right',
                x: 0,
                verticalAlign: 'top',
                y: 0,
                floating: true,
                fontWeight:'normal',
                fontColor:'#666',
                backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColorSolid) || 'transparent',
                itemStyle:{color:'#666', font: 'normal 14px microsoft yahei'},
                shadow: false,
			},exporting:{
				enabled:false
			},
		    series: [{  name: '指标一',
						type: 'bar',
						yAxis: 0,
		                data: [105,152,211,122],
		                tooltip: {
		                    valueSuffix: ' 万'
		                }
		            },{  name: '指标二',
						type: 'bar',
						yAxis: 0,
		                data: [91,101,111,99],
		                tooltip: {
		                    valueSuffix: ' 万'
		                }
		            }]
		};
	</e:case>
	<e:case value="2">
	var options_bar_${param.componentId} = {
			chart: {
				renderTo: 'bar_${param.componentId}',
				backgroundColor: 'rgba(0,0,0,0)',
			},
			colors:['#1ea3d5','#d34737','#3b5998', '#1ea3d5','#d34737','#3b5998','#1ea3d5','#d34737','#3b5998','#1ea3d5'],
			 title: {
		            text: '双Y轴条形图模板',
		            align:'left',
					x: 0,
					y:15,
					style:{color:'#666666',font: 'normal 14px microsoft yahei'}
		        },
		        legend: {
					align: 'right',
	                x: 0,
	                verticalAlign: 'top',
	                y: 0,
	                floating: true,
	                fontWeight:'normal',
	                fontColor:'#666',
	                backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColorSolid) || 'transparent',
	                itemStyle:{color:'#666', font: 'normal 14px microsoft yahei'},
	                shadow: false,
				},
		        xAxis: [{
		            categories: ['1季度', '2季度', '3季度', '4季度'],
		            gridLineWidth: 1,
					gridLineDashStyle: 'ShortDash',
					gridLineColor: '#dddddd',
					labels: {
						rotation: 0,
						align: 'right',
						style: {
							color:'#333',font: 'normal 14px microsoft yahei'
						}
					}
		        }],
		        yAxis: [{
		        	gridLineWidth: 0,
					gridLineColor: 'transparent',
		            labels: {
		                format: '{value}户',
		                style:{color:'#333',font: 'normal 14px microsoft yahei'}
		            },
		            title: {
		                text: '用户数',
		                style:{color:'#333',font: 'normal 14px microsoft yahei'}
		            }
		        }, { 
		            title: {
		                text: '收入',
		                style:{color:'#333',font: 'normal 14px microsoft yahei'}
		            },
		            labels: {
		                format: '{value} 万元',
		                style:{color:'#333',font: 'normal 14px microsoft yahei'}
		            },
		            opposite: true
		        }],
		        tooltip: {
		            shared: true
		        },
		        legend: {
						align: 'right',
		                x: 0,
		                verticalAlign: 'top',
		                y: 0,
		                floating: true,
		                fontWeight:'normal',
		                fontColor:'#666',
		                backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColorSolid) || 'transparent',
		                itemStyle:{color:'#666', font: 'normal 14px microsoft yahei'},
		                shadow: false,
					},exporting:{
						enabled:false
					},
		        series: [{
		            name: '用户数',
		            type: 'bar',
		            yAxis: 0,
		            data: [49, 71, 106, 129],
		            tooltip: {
		                valueSuffix: ' 户'
		            }

		        }, {
		            name: '收入',
		            type: 'bar',
		            yAxis: 1,
		            data: [7.0, 6.9, 9.5, 14.5],
		            tooltip: {
		                valueSuffix: '万元'
		            }
		        }]
		};
	</e:case>
	<e:case value="3">
	var options_bar_${param.componentId} = {
			chart: {
				renderTo: 'bar_${param.componentId}',
				backgroundColor: 'rgba(0,0,0,0)'
			},
			colors:['#1ea3d5','#d34737','#3b5998', '#1ea3d5','#d34737','#3b5998','#1ea3d5','#d34737','#3b5998','#1ea3d5'],
			title: {
	            text: '三Y轴条形图模板',
	            align:'left',
				x: 0,
				y:15,
				style:{color:'#666666',font: 'normal 14px microsoft yahei'}
	        },
	       legend: {
					align: 'right',
	                x: 0,
	                verticalAlign: 'top',
	                y: 0,
	                floating: true,
	                fontWeight:'normal',
	                fontColor:'#666',
	                backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColorSolid) || 'transparent',
	                itemStyle:{color:'#666', font: 'normal 14px microsoft yahei'},
	                shadow: false,
				},
	        xAxis: [{
	            categories: ['1季度', '2季度', '3季度', '4季度'],
	        }],
	        yAxis: [{ // Primary yAxis
	            labels: {
	                formatter: function() {
	                    return this.value +'户';
	                },

	            },
	            title: {
	                text: '光网用户'
	            },
	            opposite: true

	        }, { // Secondary yAxis
	            title: {
	                text: '宽带用户'
	            },
	            labels: {
	                formatter: function() {
	                    return this.value +'户';
	                }
	            }

	        }, { // Tertiary yAxis
	            title: {
	                text: '收入'
	            },
	            labels: {
	                formatter: function() {
	                    return this.value +'万元';
	                }
	            },
	            opposite: true
	        }],
	        tooltip: {
	            shared: true
	        },
	        exporting:{
				enabled:false
			},
	        series: [{
	            name: '收入',
	            type: 'bar',
	            yAxis: 2,
	            data: [49, 71, 106, 129],
	            tooltip: {
	                valueSuffix: '万元'
	            }

	        }, {
	            name: '宽带用户',
	            type: 'bar',
	            yAxis: 1,
	            data: [9960, 10160, 10150, 10090],
	            tooltip: {
	                valueSuffix: '户'
	            }

	        }, {
	            name: '光网用户',
	            type: 'bar',
	            yAxis: 0,
	            data: [1900, 2100, 2300, 2840],
	            tooltip: {
	                valueSuffix: '户'
	            }
	        }]
		};
	</e:case>
</e:switch>
<e:if condition="${param.ispop != 'true'}">
	var pheight = parseInt( $("#div_area_${param.containerId}").css("height"));
	$("#bar_panel_${param.componentId}").css("height",(pheight-40)+"px");
	$("#bar_panel_${param.componentId}").css("width",$("#div_area_${param.containerId}").css("width"));
</e:if>
	cn.com.easy.xbuilder.service.component.BarService.getComponentJsonData(StoreData.xid,'${param.containerId}','${param.componentId}',$.toJSON({}),function(data,exception){
		var jsonObj=$.parseJSON(data);
		if(jsonObj.colors!=""&&jsonObj.colors!=undefined){
			options_bar_${param.componentId}.colors = jsonObj.colors.split(",");
		}
		var chart_bar_${param.componentId} = new Highcharts.Chart(options_bar_${param.componentId});
	});
</script>
</div>
</div>
