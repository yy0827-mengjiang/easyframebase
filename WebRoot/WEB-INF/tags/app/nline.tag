<%@ tag body-content="empty" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:description>指标列对应的配置：例如：“name:指标2,color:#cf44cf,itemType:r,lineWidth:4,spline:true”，其中 name：指标名称，color：图颜色，itemType：数据点样式（有三种值：r：圆点、d：三角、s：正文形,默认为圆点），lineWidth：线粗度（数字），spline：是否是圆滑曲线（true/false）</e:description>
<%@ attribute name="id" required="true" %>                                                  <e:description>线图id（必选）</e:description>
<%@ attribute name="title" required="false" %>                                              <e:description>线图标题</e:description>
<%@ attribute name="titleheight" required="false" %>                                         <e:description>线图标题高度</e:description>

<%@ attribute name="url" required="false" %>                                              	<e:description>数据路径，与数据（items）二选一</e:description>
<%@ attribute name="items" required="false" rtexprvalue="true" type="java.lang.Object"%>    <e:description>数据，与数据路径（url）二选一</e:description>

<%@ attribute name="yaxis" required="false" %>                                             	<e:description>线图y轴屬性,title:y轴标题,unit:y轴刻度单位,min:最小值,max:最大值,step:最小刻度值,yColor:y轴颜色,lineColor:刻度线颜色,pointNum:小数点位数。其中刻度线颜色（lineColor）需要 是否显示准线（crosshairs）设置成true才生效。</e:description>
<%@ attribute name="xtitle" required="false" %>                       						<e:description>x轴标题</e:description>
<%@ attribute name="xstep"  required="false" %>                       						<e:description>x轴数据间隔(数字)，即隔几个显示一个，默认为0</e:description>
<%@ attribute name="dimension" required="true" %>                       					<e:description>维度列（必选）</e:description>

<%@ attribute name="divstyle" required="false" %>                                           <e:description>div样式</e:description>
<%@ attribute name="width" required="true" %>                                              <e:description>线图宽度(数字或auto)（必选）</e:description>
<%@ attribute name="height" required="true" %>                                             <e:description>线图高度(数字)（必选）</e:description>
<%@ attribute name="chartpadding" required="false" %>										<e:description>设置图表上下左右距离，有四个选项（top、bottom、left、right）；例如：chartpadding="top:0,bottom:0,left:0,right:0"</e:description>
<%@ attribute name="colors" required="false" %>											    <e:description>设置图表颜色(字符串，各颜色之间以逗号分隔)</e:description>

<%@ attribute name="crosshairs" required="false" %>                                         <e:description>是否显示准线</e:description>
<%@ attribute name="legend" required="false" %>                                             <e:description>是否显示图例(true/false)</e:description>
<%@ attribute name="legendLayout" required="false" %>      									<e:description>图例的横向或纵向显示，x为横向（默认），y为纵向</e:description>
<%@ attribute name="legendAlign" required="false" %>      									<e:description>图例左右位置,值：left、right、center（默认）</e:description>
<%@ attribute name="legendVerticalAlign" required="false" %>      							<e:description>图例上下位置,值：top（默认）、bottom、middle</e:description>

<%@ attribute name="tooltip" required="false" %>      										<e:description>是否显示线图上提示，默认形式：维度：指标值。1：显示（默认形式），0：不显示，其他数字留扩展</e:description>
<%@ attribute name="showBorder" required="false" %>      									<e:description>是否显示边框（true/false），默认为true</e:description>

<%@ attribute name="dataPointAxisClick" required="false" %>                                <e:description>点击线图数据维度，参数e（未写）</e:description>
<%@ attribute name="dataPointClick" required="false" %>                                     <e:description>点击线图数据点执行js方法，参数e（未写）</e:description>

<div id="div_${id}" style="${divstyle }"></div>
	<script>
	webix.ready(function(){
		var data_${id} = [];
		var hasUrl_${id}='${url}';
		if((hasUrl_${id}=='null'||hasUrl_${id}=='')&&'${items}'!=''&&'${items}'!='null'){
			data_${id}=eval('(${e:java2json(items)})');
		}
		var colors_${id}=['#e7ebe9','#a7d2e7','#74bfdf','#15b0db','#0097c7','#0073b6','#005a8d','#00acdb','#adc9d2','#bbd3da'];//默认颜色
		if('${colors}'!=''){
			colors_${id}='${colors}'.split(",");
		}
		var colors_current_index_${id}=0;
		var colors_current_index_copy_${id}=0;
		
		var xdata_current_index_${id}=0;
		var  xdata_step_${id}=0;
		if('${xstep}'!=''&&'${xstep}'!='null'){
			xdata_step_${id}=parseInt('${xstep}');
		}
		xdata_step_${id}=xdata_step_${id}+1;
		
		var os_${id} = navigator.userAgent.toLowerCase();
		var isAndroid_${id} = (os_${id}.indexOf('android') > -1);
		var lineChart_${id} =new webix.ui({
		  container: "div_${id}",
		  cols:[
	         	{
	            rows:[
					<e:if condition="${title!=null && title ne ''}">
	                {
	                	<e:if condition="${showBorder!=null && showBorder eq 'false'}">
		               		borderless:true,
		               	</e:if>
	                    template:"<div style='width:100%;text-align:center'>${title}</div>"
	                    <e:if condition="${titleheight!=null && titleheight ne ''}">
	                    ,height:${titleheight}
	                    </e:if>
	                    <e:if condition="${titleheight==null || titleheight eq ''}">
	                    ,height:30
	                    </e:if>
	                },
	                </e:if>
			
					{
						id:"${id}",
				        view:"chart",
				        <e:if condition="${showBorder!=null && showBorder eq 'false'}">
	                		borderless:true,
	                	</e:if>
				        minHeight:30,
				        minWidth:30,
				        
				        <e:if condition="${chartpadding!=null&&chartpadding!=''}">
				        padding:{
					        ${chartpadding}
					    },
					    </e:if>
				        type:"line",
				       
				        <e:if condition="${width!=null&&!e:endsWith(width,'px')&&!e:endsWith(width,'pt')&&!e:endsWith(width,'em')&&!e:endsWith(width,'%')&&width!='auto'}">
							width:${width},
						</e:if>
						<e:if condition="${height!=null&&!e:endsWith(height, 'px')&&!e:endsWith(height,'pt')&&!e:endsWith(height,'em')&&!e:endsWith(height,'%')&&height!='auto'}">
							height:${height},
						</e:if>
						on:{
					        "onItemClick": function(id, e, node){ 
					        }
					    },
					    
					    <e:if condition="${url!=null&&url!=''}">
							url:(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'),
						</e:if>
						<e:if condition="${url==null||url==''}">
							data:data_${id},
						</e:if>
				        xAxis:{
				        	<e:if condition="${xtitle!=null&&xtitle!=''}">
								title:"${xtitle}",
							</e:if>
				        	
				            template:function(obj){
				            	var tempValue=null;
				            	if(xdata_current_index_${id}%xdata_step_${id}==0){
				            		tempValue = obj["${dimension}"];
				            	}else{
				            		tempValue = '';
				            	}
				            	xdata_current_index_${id}++;
				            	return tempValue;
				            	
				            },
				            lines:false,
				            color:"#000000"
				        },
				        yAxis:{
				        	<e:if condition="${yaxis!=''&&yaxis!=null}">
					        	<e:forEach items="${e:split(yaxis,';')}" var="item">
									<e:set var="easy_yaxis_map" value="${e:str2map(item,':',',')}" />
									<e:set var="easy_yaxis_map_pointNum" value="0" />
									<e:if condition="${easy_yaxis_map.pointNum!=''&&easy_yaxis_map.pointNum!=null}">
										<e:set var="easy_yaxis_map_pointNum" value="${easy_yaxis_map.pointNum}" />
									</e:if>
									<e:if condition="${index==0}">
										title:"${easy_yaxis_map.title}",
							        	template: function(value){
										    return parseFloat(value).toFixed(${easy_yaxis_map_pointNum})+'${easy_yaxis_map.unit}';
										},
										<e:if condition="${easy_yaxis_map.yColor!=''&&easy_yaxis_map.yColor!=null}">
											color:"${easy_yaxis_map.yColor}",
										</e:if>
										<e:if condition="${crosshairs==''||crosshairs==null||crosshairs=='true'}">
											<e:if condition="${easy_yaxis_map.lineColor!=''&&easy_yaxis_map.lineColor!=null}">
												lineColor:"${easy_yaxis_map.lineColor}",
											</e:if>
											<e:if condition="${easy_yaxis_map.lineColor==''||easy_yaxis_map.lineColor==null}">
												lineColor:"#f1f1f1",
											</e:if>
										</e:if>
										<e:if condition="${crosshairs!=''&&crosshairs!=null&&crosshairs=='false'}">
											lineColor:"#ffffff",
										</e:if>
										<e:if condition="${easy_yaxis_map.min!=''&&easy_yaxis_map.min!=null}">
											start:"${easy_yaxis_map.min}",
										</e:if>
										<e:if condition="${easy_yaxis_map.step!=''&&easy_yaxis_map.step!=null}">
											step:"${easy_yaxis_map.step}",
										</e:if>
										<e:if condition="${easy_yaxis_map.max!=''&&easy_yaxis_map.max!=null}">
											end:"${easy_yaxis_map.max}",
										</e:if>
									</e:if>
								</e:forEach>
							</e:if>
							<e:if condition="${yaxis==''||yaxis==null}">
								<e:if condition="${crosshairs!=''&&crosshairs!=null&&crosshairs=='false'}">
									lineColor:"#ffffff",
								</e:if>
								<e:if condition="${crosshairs==''||crosshairs==null||crosshairs=='true'}">
									lineColor:"#f1f1f1",
								</e:if>
								template: function(value){
								    return parseFloat(value).toFixed(0);
								},
							</e:if>
				        	lines:true,
				            lineShape:"line",
				            bg: "#000000"
				            
				        },
				        //offset:0,
				        <e:if condition="${legend!=''&&legend!=null&&legend=='true'}">
				        legend:{
				            values:[
					            <e:if condition="${dynattrs!=''&&dynattrs!=null}">
						        	<e:forEach items="${dynattrs}" var="item">
						        		<e:if condition="${index>0}">
						        			,
						        		</e:if>
						        		<e:if condition="${item.value!=''&&item.value!=null}">
						               		<e:set var="easy_map" value="${e:str2map(item.value,':',',')}" />
						               		
						               		<e:if condition="${easy_map.name!=''&&easy_map.name!=null}">
							                	<e:if condition="${easy_map.color!=''&&easy_map.color!=null}">
							                    	
							                    	 {text:"${easy_map.name}",color:"${easy_map.color}"}
							                    </e:if>
							                    <e:if condition="${easy_map.color==''||easy_map.color==null}">
							                    	 {text:"${easy_map.name}",color:colors_${id}[(colors_current_index_copy_${id}++)%(colors_${id}.length)]}
							                    </e:if>
						                    	
						                    </e:if>
						                    <e:if condition="${easy_map.name==''||easy_map.name==null}">
						                    	<e:if condition="${easy_map.color!=''&&easy_map.color!=null}">
							                    	
							                    	 {text:"${item.key}",color:"${easy_map.color}"}
							                    </e:if>
							                    <e:if condition="${easy_map.color==''||easy_map.color==null}">
							                    	 {text:"${item.key}",color:colors_${id}[(colors_current_index_copy_${id}++)%(colors_${id}.length)]}
							                    </e:if>
						                    </e:if>
						                </e:if>
						        	</e:forEach>
								</e:if>
				            	
				            	
				           	],
				           	<e:if condition="${legendAlign==null || legendAlign eq ''}">
				            	align:"right",
				            </e:if>
				         	<e:if condition="${legendAlign!=null && legendAlign ne '' }">
				            	align:"${legendAlign}",
				            </e:if>
				            <e:if condition="${legendVerticalAlign==null || legendVerticalAlign eq '' }">
				            	valign:"top",
				            </e:if>
				            <e:if condition="${legendVerticalAlign!=null && legendVerticalAlign ne '' }">
				            	valign:"${legendVerticalAlign}",
				            </e:if>
				            <e:if condition="${legendLayout==null || legendLayout eq ''}">
				            	layout:"x",
				            </e:if>
				            <e:if condition="${legendLayout!=null && legendLayout ne '' }">
				            	layout:"${legendLayout}",
				            </e:if>
				            width: 200,
				            margin: 8,
				            marker:{
					            width: 10,
					            height:10,
					            radius:0
				            }
				        },
				        </e:if>
				        series:[
				        	<e:if condition="${dynattrs!=''&&dynattrs!=null}">
					        	<e:forEach items="${dynattrs}" var="item">
					        		<e:if condition="${index>0}">
					        			,
					        		</e:if>
					        		
									 {
						               
						                <e:if condition="${item.value!=''&&item.value!=null}">
						                <e:set var="easy_map" value="${e:str2map(item.value,':',',')}" />
						                <e:if condition="${easy_map.spline!=''&&easy_map.spline!=null&&easy_map.spline=='true'}">
					                    	 type:"spline",
					                    </e:if>
						                item:{
						                    alpha:1,
						                    <e:if condition="${easy_map.itemType!=''&&easy_map.itemType!=null}">
						                    	type:"${easy_map.itemType}",
						                    </e:if>
						                    radius: 3
						                },
						                line:{
						                	<e:if condition="${easy_map.color!=''&&easy_map.color!=null}">
						                    	color:"${easy_map.color}",
						                    </e:if>
						                    <e:if condition="${easy_map.color==''||easy_map.color==null}">
						                    	 color:colors_${id}[(colors_current_index_${id}++)%(colors_${id}.length)],
						                    </e:if>
						                    <e:if condition="${easy_map.lineWidth!=''&&easy_map.lineWidth!=null}">
						                    	width:${easy_map.lineWidth}
						                    </e:if>
						                    <e:if condition="${easy_map.lineWidth==''||easy_map.lineWidth==null}">
						                    	  width:2
						                    </e:if>
						                   
						                    
						                },
						                </e:if>
						                <e:if condition="${tooltip eq '1'}">
										tooltip:{
							                template: "#${dimension}#:#${item.key}#"
					            		},
					                   	</e:if>
					                   	 value:"#${item.key}#"
						            }
								</e:forEach>
							</e:if>
				        ]
				      }
				    
			    
			    	]
		        }
		    ]
		});
   		//webix.Touch.disable();
	   	webix.Touch.limit(true);
	   	alert('${width}');
	   	<e:if condition="${width==null || width=='' || width=='auto'}">
	   	alert('aa:${width}');
	   
	   	//alert(parent.window.document.getElementById("ContentIframe").contentWindow.document.body.clientHeight);
	   	//alert(top.window.document.getElementById("ContentIframe"));
	    webix.attachEvent("onRotate", function(orientation){
	    
	    	setTimeout(function() {
		//alert(1);
		//alert(parent.window.document.getElementById("ContentIframe").src);
	    //alert(top.window.document.getElementById("ContentIframe"));
	    	//parent.window.document.getElementById("ContentIframe").width=2000;  
	    	var rotateWidth = window.innerWidth-25;
			var isLandscape = window.orientation==90||window.orientation==-90;
			if(isAndroid_${id}){
				rotateWidth = window.innerHeight+30;
				if (isLandscape){
					rotateWidth += 30;
				}
			}
			//alert(document.getElementById("ContentIframe").width);
			//alert(rotateWidth);
			lineChart_${id}.config.width = rotateWidth;
			//alert(0);
			//lineChart_${id}.define("width", rotateWidth);
			//alert(1);
			//lineChart_${id}.$setSize(rotateWidth,lineChart_${id}.$height);
			//alert(2);
	    	lineChart_${id}.resize();
	    	//document.getElementById('div_${id}').width=rotateWidth;
	    	
	    	alert(lineChart_${id}.$width);
	    	//var obj2 = document.getElementById('div_${id}');
			//obj2.style.zoom=rotateWidth/window.innerWidth;
			},500);
	    	
		});
		</e:if>
    });  
	</script>

