<%@ tag body-content="empty" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="id" required="true" %>                                                  <e:description>id</e:description>
<%@ attribute name="width" required="true" %>                                               <e:description>宽度</e:description>
<%@ attribute name="height" required="true" %>                                              <e:description>高度</e:description>
<%@ attribute name="items" required="true" rtexprvalue="true" type="java.lang.Object"%>     <e:description>数据集</e:description>
<%@ attribute name="dimension" required="true" %>                                           <e:description>维度列</e:description>
<%@ attribute name="value" required="true" %>                                               <e:description>数据列</e:description>
<%@ attribute name="divStyle" required="false" %>                                           <e:description>容器div样式,不包括width和height属性</e:description>
<%@ attribute name="centerX" required="false" %>                                            <e:description>圆心横坐标,支持绝对值（px）和百分比,默认为"50%",百分比计算min(width, height) * 50%. </e:description>
<%@ attribute name="centerY" required="false" %>                                            <e:description>圆心纵坐标,支持绝对值（px）和百分比,默认为"50%",百分比计算min(width, height) * 50%. </e:description>
<%@ attribute name="radiusInner" required="false" %>                                        <e:description>内半径，支持绝对值（px）和百分比，,默认为"10%",百分比计算比，min(width, height) / 2 * 10% </e:description>
<%@ attribute name="radiusOuter" required="false" %>                                        <e:description>外半径，支持绝对值（px）和百分比，,默认为"75%",百分比计算比，min(width, height) / 2 * 75% </e:description>
<%@ attribute name="title" required="false" %>                                              <e:description>标题</e:description>
<%@ attribute name="titleStyle" required="false" %>                                         <e:description>标题样式(注意:各属性间以","分隔),可设置的属性有:(1){color} color 颜色 (2){string} decoration 修饰，仅对tooltip.textStyle生效 (3){string} align 水平对齐方式，可选为：'left' | 'right' | 'center' (4){string} baseline 垂直对齐方式，可选为：'top' | 'bottom' | 'middle' (5){string} fontFamily  字体系列 (6){number} fontSize  字号 ，单位px (7){string} fontStyle 样式，可选为：'normal' | 'italic' | 'oblique' (8){string | number} fontWeight 粗细，可选为：'normal' | 'bold' | 'bolder' | 'lighter' | 100 | 200 |... | 900 </e:description>
<%@ attribute name="tooltip" required="false" %>                                            <e:description>是否显示提示框(true/false),默认为显示(true)</e:description>
<%@ attribute name="unit" required="false" %>                                               <e:description>显示单位,是否显示提示框(tooltip)为true时才有效</e:description>
<%@ attribute name="labelPosition" required="false" %>                                      <e:description>标签显示位置(outer/inner),默认为外部(outer)</e:description>
<%@ attribute name="labelStyle" required="false" %>                                      	<e:description>文本样式(注意:各属性间以","分隔),可设置的属性有:(1){color} color 颜色 (2){string} decoration 修饰，仅对tooltip.textStyle生效 (3){string} align 水平对齐方式，可选为：'left' | 'right' | 'center' (4){string} baseline 垂直对齐方式，可选为：'top' | 'bottom' | 'middle' (5){string} fontFamily  字体系列 (6){number} fontSize  字号 ，单位px (7){string} fontStyle 样式，可选为：'normal' | 'italic' | 'oblique' (8){string | number} fontWeight 粗细，可选为：'normal' | 'bold' | 'bolder' | 'lighter' | 100 | 200 |... | 900 </e:description>
<%@ attribute name="legend" required="false" %>                                             <e:description>是否显示图例(true/false),默认为显示(true)</e:description>
<%@ attribute name="legendPadding" required="false" %>                                      <e:description>图例内边距(5,5,5,5)，单位px，接受上右下左边距,以","分隔</e:description>
<%@ attribute name="legendOrient" required="false" %>                                       <e:description>布局方式，默认为水平布局(horizontal)，可选为：'horizontal' | 'vertical'</e:description>
<%@ attribute name="legendX" required="false" %>                                            <e:description>水平安放位置，默认为居中(center)，可选为：'center' | 'left' | 'right' | {number}（x坐标，单位px）</e:description>
<%@ attribute name="legendY" required="false" %>                                            <e:description>垂直安放位置，默认为底部(bottom)，可选为：'top' | 'bottom' | 'center' | {number}（y坐标，单位px）</e:description>

<script type="text/javascript">
	 $(function () {
    	var pieChart_${id} = echarts.init(document.getElementById('${id}'));
    	option_${id} = {
    			<e:if condition="${title !=null && title ne ''}">
					title : {
						text:'${title}',
	    		        subtext: '',
	    		        x:'center',
	    		        padding:10
	    		        <e:if condition="${titleStyle !=null && titleStyle ne ''}">
	    		        	,textStyle:{${titleStyle}}
	    		        </e:if>
	    		        
	    		        
	    		    },
				</e:if>
				
				<e:if condition="${tooltip ==null || tooltip == ''||tooltip==true||tooltip=='true'}">
	    		    tooltip : {
	    		        trigger: 'item',
	    		        formatter: "{a} <br/>{b} : {c} ${unit}({d}%)"
	    		    },
    		    </e:if>
    		    
    		    <e:if condition="${legend ==null || legend == ''||legend==true||legend=='true'}">
	    		    legend: {
	    		    
	    		    	<e:if condition="${legendPadding !=null && legendPadding ne ''}">
	   		            	padding:[${legendPadding}],
	   		            </e:if>
	    		    	<e:if condition="${legendOrient !=null && legendOrient ne ''}">
	   		            	orient : '${legendOrient}',
	   		            </e:if>
	   		            <e:if condition="${legendOrient ==null || legendOrient == ''}">
	   		            	orient : 'horizontal',
	   		            </e:if>
	    		    	<e:if condition="${legendX !=null && legendX ne ''}">
	   		            	x : '${legendX}',
	   		            </e:if>
	   		            <e:if condition="${legendX ==null || legendX == ''}">
	   		            	x : 'center',
	   		            </e:if>
	    		        <e:if condition="${legendY !=null && legendY ne ''}">
	   		            	y : '${legendY}',
	   		            </e:if>
	   		            <e:if condition="${legendY ==null || legendY == ''}">
	   		            	y : 'bottom',
	   		            </e:if>
	    		        
	    		        data:[]
	    		    },
    		    </e:if>
    		    calculable : true,
    		    series : [ 
    		       
    		        {
						name:'',
    		            type:'pie',
    		            radius : [
	    		            <e:if condition="${radiusInner !=null && radiusInner ne ''}">
	   		            		'${radiusInner}',
	   		            	</e:if>
	   		            	<e:if condition="${radiusInner ==null || radiusInner == ''}">
	   		            		'10%', 
	   		            	</e:if>
	    		            <e:if condition="${radiusOuter !=null && radiusOuter ne ''}">
	   		            		'${radiusOuter}'
	   		            	</e:if>
	   		            	<e:if condition="${radiusOuter ==null || radiusOuter == ''}">
	   		            		'75%'
	   		            	</e:if>
    		            ],
   		            	center : [
	   		            	<e:if condition="${centerX !=null && centerX ne ''}">
	   		            		'${centerX}',
	   		            	</e:if>
	   		            	<e:if condition="${centerX ==null || centerX == ''}">
	   		            		'50%', 
	   		            	</e:if>
	   		            	<e:if condition="${centerY !=null && centerY ne ''}">
	   		            		'${centerY}'
	   		            	</e:if>
	   		            	<e:if condition="${centerY ==null || centerY == ''}">
	   		            		'50%'
	   		            	</e:if>
   		            	] ,
    		           
    		            roseType : 'area',
    		            x: '10%',               
    		            max: 40,                
    		            sort : 'ascending',     
    		            itemStyle : {
    		                normal : {
    		                	   label : {
    		                	   	   <e:if condition="${labelPosition !=null && labelPosition ne ''}">
				   		            		 position:'${labelPosition}',
				   		               </e:if>
				   		               <e:if condition="${labelPosition ==null || labelPosition == ''}">
				   		            		position:'outer',
				   		               </e:if>
				   		               <e:if condition="${labelStyle !=null && labelStyle ne ''}">
				   		            		textStyle:{${labelStyle}},
				   		               </e:if>
				   		               
    		                           show :true
    		                       },
    		                       labelLine : {
    		                       		<e:if condition="${labelPosition ==null || labelPosition == ''|| labelPosition != 'inner'}">
    		                           		show : true
    		                           	</e:if>
    		                           	<e:if condition="${labelPosition !=null && labelPosition ne '' && labelPosition == 'inner'}">
				   		            		show : false
				   		               </e:if>
    		                       }
    		                }
    		            },
    		            data:[]
    		        }
    		    ]
    		};
    	 var dataList_${id}=${e:java2json(items)};
    	 var legendFlag_${id}='${legend}';
    	 for(var i=0;i<dataList_${id}.length;i++){
    		   var dataObj = {};
    		   var ldataObj = {};
    		   dataObj.name = dataList_${id}[i]['${dimension}'];
    	   	   dataObj.value = dataList_${id}[i]['${value}'];
    	   	   option_${id}.series[0].data.push(dataObj);
    	   	   if(legendFlag_${id}==''||legendFlag_${id}=='null'||legendFlag_${id}=='true'){
    	   	   	  ldataObj.name = dataList_${id}[i]['${dimension}'];
    	   	   	  option_${id}.legend.data.push(ldataObj);
    	   	   }
    	   	   
    	   }
    	 pieChart_${id}.setOption(option_${id});
    	 //图形自适应方法
    	 setTimeout(function (){ 
             window.onresize = function () { 
            	 pieChart_${id}.resize();  
             } 
         },200);
    });
</script>
<div id="${id}" style="width:${width };height:${height };${divStyle}"></div>