<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@ attribute name="id" required="true" %>                                               <e:description>表格id</e:description>
<%@ attribute name="idField" required="true" %>                                          <e:description>主键对应列</e:description>
<%@ attribute name="treeField" required="true" %>                                        <e:description>树对应列</e:description>
<%@ attribute name="treeFieldTitle" required="true" %>                                   <e:description>树对应列的标题</e:description>
<%@ attribute name="treeFieldWidth" required="true" %>                                   <e:description>树对应列的宽度</e:description>
<%@ attribute name="url" required="true" %>                                              <e:description>数据路径</e:description>
<%@ attribute name="menuWidth" required="true" %>                                        <e:description>维度菜单宽度</e:description>
<%@ attribute name="defaultDim" required="true" %>                                       <e:description>默认选中维度</e:description>
<%@ attribute name="onClickRow" required="false" %>                          	         <e:description>单击行事件</e:description>
<%@ attribute name="onClickCell" required="false" %>                          	         <e:description>单击列事件</e:description>
<%@ attribute name="download" required="false" %>                          	        	 <e:description>导出文件的名称</e:description>
<%@ attribute name="downArgs" required="false" %>                          	        	 <e:description>导出文件的获得sql的参数，格式为&A=33&b=44</e:description>
<%@ attribute name="extds" required="false" %>                                           <e:description>数据源类型</e:description>
<%@ attribute name="module_id" required="false" %>                                       <e:description>菜单编号</e:description>
<%@ attribute name="jl_ols" required="false" %>                                          <e:description>吉林onLoadSuccess是否只运行一次,值为true和false</e:description>
<%@ attribute name="pagination" required="false" %>                                      <e:description>是否显示分页(true/false),默认为 否(false)</e:description>
<%@ attribute name="pageSize" required="false" %>                                        <e:description>分页记录数，默认为10</e:description>
<%@ attribute name="pageNumCount" required="false" %>                                    <e:description>下钻行高度，只有下钻类型为柱图线图或自定义时起作用</e:description>
<%@ attribute name="drillRowHeight" required="false" %>

<jsp:doBody var="bodyRes" />
<e:if condition="${pagination == null || pagination eq '' }">
	<e:set var="pagination" value="false"/>
</e:if>
<e:if condition="${pageSize == null || pageSize eq '' }">
	<e:set var="pageSize" value="10"/>
</e:if>
<e:if condition="${pageNumCount == null || pageNumCount eq '' }">
	<e:set var="pageNumCount" value="10"/>
</e:if>

<e:set var="initDimArray" value="${e:split(defaultDim, ',')}" />
<e:set var="initDimSize" value="${e:length(initDimArray)}" />
<e:set var="dc">${e:getDate("yyyyMMddHHmmssSSSS")}</e:set>

<div id="cm_${id}" class="easyui-menu" style="width:${menuWidth}px;">
	${e:replace(e:replace(bodyRes, "id_template", id), "exprot_field", id)}
	<div class="menu-sep"></div>
	<div onclick="clear_${id}()" iconCls="icon-cut">清空数据</div>
</div>
<script type="text/javascript">
	var jl_ols_flag_${id} = "0";
	var pageSize = ${pageSize};
	var pageNumCount=${pageNumCount};
	var initDimArray_${id} = new Array();
	<e:forEach items="${initDimArray}" var="item">
		initDimArray_${id}.push('${item}');
	</e:forEach>
	var options_${id} = {
		url: (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}')+'&dim=${initDimArray[0]}',
		idField:'TREETABLEID',
		treeField:'${treeField}',
		frozenColumns:[[
	        {title:'${treeFieldTitle}',field:'${treeField}',width:${treeFieldWidth},
		         formatter:function(value, rowData, rowIndex){
		         	return '<a href="javascript:void(0);" onclick="showMenu_${id}(event, \''+rowData.TREETABLEID+'\');" style="text-decoration: underline; color: #004080">'+value+'</a>';
		         }
	        }
		]],
		<e:if condition="${onClickRow!=null}">
			onClickRow: ${onClickRow},
		</e:if>
		<e:if condition="${onClickCell!=null}">
			onClickCell: ${onClickCell},
		</e:if>
		onLoadSuccess:function (node, data){
			<e:if condition="${jl_ols eq 'true'}">
				if(jl_ols_flag_${id} == '1'){
					return;
				}
			</e:if>
			if(node==null){
				node={level:1};
			}
			if(node.level<${initDimSize}){
				$(data).each(function(index, domEle){
					domEle.level=node.level+1;
					init_load_${id}(domEle,initDimArray_${id}[node.level]);
				});
			}
		}
	};
	
	/* $('#${id}').treegrid({
		onResizeColumn: function(index,field,value){
			alert(index);
		}
	}); */
	
	function init_load_${id}(node,type){
		if (node){
			var queryUrl =(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}')+'&dim='+type+setDimUrl_${id}(node)+'&${idField}='+node.${idField};
			//下钻带分页
			if(${pagination}){
				var curPage = node.curPage==undefined?1:node.curPage;
				queryUrl+="&curPage="+curPage+"&pageSize="+pageSize;
				$.post(queryUrl,{},function(data){
					removeChildren(node.TREETABLEID);
					data=$.parseJSON(data.replace(/(^\s*)|(\s*$)/g, ""));
					$('#${id}').treegrid('append', {parent:(node?node.TREETABLEID:null),data:data.rows});
					createPager(node.TREETABLEID,type,parseInt(data.total),"table","");
				})
			}else{//下钻不带分页
				$('#${id}').treegrid('append', {parent:(node?node.TREETABLEID:null),data:[]});
				$('#${id}').treegrid('options').url = queryUrl;
				$('#${id}').treegrid('reload', node.TREETABLEID);
			} 
		} else {
			alert('请选择要下转的数据！');
		}
	}
	//删除子节点
	function removeChildren(nodeId){
		var childNodes=$('#${id}').treegrid('getChildren',nodeId);
		for(var i=0;i<childNodes.length;i++){
			if(childNodes[i]._parentId==nodeId){
				if(childNodes[i].TREETABLEID!=undefined){
					$('#${id}').treegrid('remove',childNodes[i].TREETABLEID);
				}
			}
		}
	}
	
	var kpiMap={};
	//获取所有列
	function getAllColumns(){
		var columns=$('#${id}').treegrid('options').columns[0];
		var resultArr=new Array();
		$.each(columns,function(index,column){
			resultArr.push(column.field);
			kpiMap[column.field]=column.title;
		})
		return resultArr;
	}
	
	//构造并添加一个空数据行
	function addNullDataRow(nodeId){
		var nullDataRow={"${treeField}":""};
		var allColumns = getAllColumns();
		$.each(allColumns,function(index,colName){
			nullDataRow[colName]="";
		});
		nullDataRow["TREETABLEID"]=(new Date()).getTime();
		$('#${id}').treegrid('append', {parent:nodeId,data:[nullDataRow]});
	}
	
	//按表格形式下钻
	function reload_${id}(type){
		<e:if condition="${jl_ols eq 'true'}">
			jl_ols_flag_${id} = '1';
		</e:if>
		var node = $('#${id}').treegrid('getSelected');
		if(type == node.DIM){
			return;
		}
		
		var drillDims = setDimUrl_${id}(node);
		if(drillDims.indexOf(type) >-1){
			return;
		}
		var $menuItem = $("#"+type+"_${id}");
		
		if($menuItem.length>0){
			$menuItemGroup = $menuItem.data("group");
			$menuItemLevel = $menuItem.data("level");
			var flag = false;
			$("div[data-group='"+$menuItemGroup+"']").each(function(){
				if($(this).data("level")<$menuItemLevel){
					var dfield = $(this).data("field");
					if(drillDims.indexOf(dfield) <= -1){
						flag = true;
						return;
					}
				}
			});
		}
		if(flag){
			return;
		}
		if (node){
			var dim = {};
			setQueryParams_${id}(node,dim);
			var url = genUrl_${id}((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'),dim);
			var yparas = $('#${id}').treegrid('options').queryParams;
			if(yparas != null){
				yparas.is_down_table=false;
			}
			var curPage = node.curPage = 1;
			
			var queryUrl = url+'&dim='+type+setDimUrl_${id}(node)+'&${idField}='+node.${idField};
			//下钻带分页
			 if(${pagination}){
				queryUrl+="&curPage="+curPage+"&pageSize="+pageSize;
				$.post(queryUrl,yparas,function(data){
					removeChildren(node.TREETABLEID);
					data=$.parseJSON(data.replace(/(^\s*)|(\s*$)/g, ""));
					$('#${id}').treegrid('append', {parent:(node?node.TREETABLEID:null),data:data.rows});
					createPager(node.TREETABLEID,type,parseInt(data.total),"table","");
				});
			}else{//下钻不带分页
				$('#${id}').treegrid('options').queryParams = yparas;
				$('#${id}').treegrid('append', {parent:(node?node.TREETABLEID:null),data:[]});
				$('#${id}').treegrid('options').url = queryUrl;
				$('#${id}').treegrid('reload', node.TREETABLEID);
			}  
		}else {
			alert('请选择要下转的数据！');
		}
		$('#cm_${id}').menu('hide');
	}
	
	//创建分页：pageType：分页类型,table,column,line
	function createPager(nodeId,type,rowcount,pageType,chartTitle){
		var node = $('#${id}').treegrid('find',nodeId);
		var curPage = node.curPage==undefined?1:node.curPage;
		var tb=$("tr[node-id='"+nodeId+"']").eq(1).next("tr").find("table");
		var colspan = $('#${id}').treegrid('options').columns[0].length;
		trHtml="<tr><td colspan='"+colspan+"' height='25'><div id='pager_"+nodeId+"' class='pagination'></div></td></tr>";
		var $tr=$(tb).find("tr").eq($(tb).find("tr").length-1);
	    $tr.after(trHtml);
	    var tb2=$("tr[node-id='"+nodeId+"']").eq(0).next("tr").find("table");    
		var trHtml2="<tr><td align='center' height='25'><div>&nbsp;</div></td></tr>";
		var $tr=$(tb2).find("tr").eq($(tb2).find("tr").length-1);
	    $tr.after(trHtml2);
	    var optInit = {
                items_per_page:pageSize,
                num_display_entries:pageNumCount,
                num_edge_entries:2,
                current_page:curPage-1,
                prev_text:'上页',
                next_text:'下页',
                callback: function(pageIndex,jq){
                		gotoPage(pageIndex+1,type,nodeId,pageType,chartTitle);
                		return false;
                }
             }
        $("#pager_"+nodeId).pagination(rowcount, optInit);
	}
	
	//下钻到自定义页面
	function drillCustomPage_${id}(label,url){
		if(url.indexOf("?")==-1){
			url=url+"?temp=1";
		}
		var nodeId=$(".datagrid-row-selected").attr("node-id");
		var node =  $('#${id}').treegrid('find',nodeId);
		var dim = {};
		setQueryParams_${id}(node,dim);
		queryUrl = genUrl_${id}(url,dim);
		var yparas = $('#${id}').treegrid('options').queryParams;
		if(yparas != null){
			yparas.is_down_table=false;
		}
		queryUrl = queryUrl+setDimUrl_${id}(node)+'&${idField}='+node.${idField};
		removeChildren(nodeId);
		addNullDataRow(nodeId);
		var trLeft = $(".datagrid-row-selected").eq(0).next("tr").find("table").find("tr");
		var trRight = $(".datagrid-row-selected").eq(1).next("tr").find("table").find("tr");
		var trRightWidth = $(".datagrid-row-selected").eq(1).css("width");
	    var tdLeft = trLeft.find("td");
	    tdLeft.css("height","${drillRowHeight}px").attr("align","center");
	    tdLeft.html("<div style='height:auto;' class='datagrid-cell datagrid-cell-c1-${treeField}'>"+label+"</div>");
	    trRight.html("<td height='${drillRowHeight}px' width='"+trRightWidth+"'><iframe width='"+trRightWidth+"' height='${drillRowHeight-1}' frameborder='0' scrolling='auto' src='"+queryUrl+"'/></td>");
	}
	
	//以图表形式下钻
	function drillChart_${id}(type,chartType,title){
			<e:if condition="${jl_ols eq 'true'}">
				jl_ols_flag_${id} = '1';
			</e:if>
			var nodeId=$(".datagrid-row-selected").attr("node-id");
			var node =  $('#${id}').treegrid('find',nodeId);
			if(type == node.DIM){
				return;
			}
			var drillDims = setDimUrl_${id}(node);
			if(drillDims.indexOf(type) >-1){
				return;
			}
			var $menuItem = $("#"+type+"_${id}");
			if($menuItem.length>0){
				$menuItemGroup = $menuItem.data("group");
				$menuItemLevel = $menuItem.data("level");
				var flag = false;
				$("div[data-group='"+$menuItemGroup+"']").each(function(){
					if($(this).data("level")<$menuItemLevel){
						var dfield = $(this).data("field");
						if(drillDims.indexOf(dfield) <= -1){
							flag = true;
							return;
						}
					}
				});
			}
			if(flag){
				return;
			}
			if (node){
				var dim = {};
				setQueryParams_${id}(node,dim);
				var url = genUrl_${id}((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'),dim);
				var yparas = $('#${id}').treegrid('options').queryParams;
				if(yparas != null){
					yparas.is_down_table=false;
				}
				var curPage = node.curPage = 1;
				var queryUrl = url+'&dim='+type+setDimUrl_${id}(node)+'&${idField}='+node.${idField};
					//下钻带分页
					if(${pagination}){
						queryUrl+="&curPage="+curPage+"&pageSize="+pageSize;
					}
					
					$.post(queryUrl,yparas,function(data){
							removeChildren(nodeId);
							addNullDataRow(nodeId);
							data=$.parseJSON(data.replace(/(^\s*)|(\s*$)/g, ""));
							var trLeft = $(".datagrid-row-selected").eq(0).next("tr").find("table").find("tr");
							var trRight = $(".datagrid-row-selected").eq(1).next("tr").find("table").find("tr");
							$(".datagrid-row-selected").eq(1).next("tr").find("table").css("width","100%");
							var trRightWidth = $(".datagrid-row-selected").eq(1).css("width");
						    var tdLeft = trLeft.find("td");
						    tdLeft.css("height","${drillRowHeight}px").attr("align","center");
						    tdLeft.html("<div style='height:auto;' class='datagrid-cell datagrid-cell-c1-${treeField}'>"+title+"</div>");
						    var datetime=(new Date()).getTime();
						    trRight.html("<td height='${drillRowHeight}px' width='100%'><div style='width:100%;height:${drillRowHeight-1}px'  id='chartDiv_"+datetime+"'></div></td>");
						    if(${pagination}){
						    	createChart(chartType,"chartDiv_"+datetime,data.rows,'','','${treeField}',getAllColumns());  
								createPager(nodeId,type,parseInt(data.total),chartType,title);
						    }else{
						    	createChart(chartType,"chartDiv_"+datetime,data,'','','${treeField}',getAllColumns());  
						    }
						});
				
			}else {
				alert('请选择要下转的数据！');
			}
	}
	
	//创建下钻的图表
	function createChart(chartType,divId,data,title,subtitle,dim,kpiArr){
		Highcharts.theme = {
				   colors: ['#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe','#01d6ff','#ff8500','#ffcf13','#86d438','#8945fe'],
				   chart: {
				      borderWidth: 0,
				      plotShadow: true,
				      plotBorderWidth: 0
				   }
				};
		chartType=chartType=="line"?"spline":chartType;
		var options={
	        chart: {
	            type: chartType,
	    		renderTo: divId
	        },
	        title: {
	            text: title
	        },
	        subtitle: {
	            text: subtitle
	        },
	        xAxis: {
	            categories: [],
	            labels: {
					rotation: -45
				}
	        },
	        yAxis: {
	            min: 0,
	            title: {
	                text: '值'
	            }
	        },
	        tooltip: {
	           
	        },
	        plotOptions: {
	            column: {
	                pointPadding: 0.2,
	                borderWidth: 0
	            }
	        },
	        series: []
	    };
		options.series=new Array();
		$.each(kpiArr, function(index, item){
			var seriesItem = {name:kpiMap[item],data:[]};
			$.each(data, function(index, dataItem){
				seriesItem.data.push(dataItem[item]);
            });
			options.series.push(seriesItem);
		});
		
		$.each(data, function(index, item){
			options.xAxis.categories.push(item[dim]);
        });
		new Highcharts.Chart(options);
	}
	
	//跳转到指定分页,pageType:分页类型，table,column,line
	function gotoPage(pageIndex,type,nodeId,pageType,chartTitle){
		var node = $('#${id}').treegrid('find',nodeId);
		node.curPage=pageIndex;
		var dim = {};
		setQueryParams_${id}(node,dim);
		var url = genUrl_${id}((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'),dim);
		var yparas = $('#${id}').treegrid('options').queryParams;
		if(yparas != null){
			yparas.is_down_table=false;
		}
		$('#${id}').treegrid('options').queryParams = yparas;
		$('#${id}').treegrid('append', {parent:nodeId,data:[]});
		var curPage = node.curPage==undefined?1:node.curPage;
		var queryUrl = url+'&dim='+type+setDimUrl_${id}(node)+'&${idField}='+node.${idField}+"&curPage="+curPage+"&pageSize="+pageSize;
		$.post(queryUrl,yparas,function(data){
			removeChildren(nodeId);
			data=$.parseJSON(data.replace(/(^\s*)|(\s*$)/g, ""));
			if(pageType=="table"){
				$('#${id}').treegrid('append', {parent:nodeId,data:data.rows});
			}else{
				addNullDataRow(nodeId);
				var trLeft = $(".datagrid-row-selected").eq(0).next("tr").find("table").find("tr");
				var trRight = $(".datagrid-row-selected").eq(1).next("tr").find("table").find("tr");
				$(".datagrid-row-selected").eq(1).next("tr").find("table").css("width","100%");
				var trRightWidth = $(".datagrid-row-selected").eq(1).css("width");
			    var tdLeft = trLeft.find("td");
			    tdLeft.css("height","${drillRowHeight}px").attr("align","center");
			    tdLeft.html("<div style='height:auto;' class='datagrid-cell datagrid-cell-c1-${treeField}'>"+chartTitle+"</div>");
			    var datetime=(new Date()).getTime();
			    trRight.html("<td height='${drillRowHeight}px' width='100%'><div style='width:100%;height:${drillRowHeight-1}px'  id='chartDiv_"+datetime+"'></div></td>");
			    createChart(pageType,"chartDiv_"+datetime,data.rows,'','','${treeField}',getAllColumns());
			}
			createPager(node.TREETABLEID,type,parseInt(data.total),pageType,chartTitle);
		})
	}
	
	
	function genUrl_${id}(url,param){
		$.each(param,function(key,value){
			var reg = new RegExp(key+"=([^&]*)(&|$)",'g');
			if(url.match(reg)) url = url.replace(reg,'');
		});
		return url;
	}
	
	function clear_${id}(){
		var node = $('#${id}').treegrid('getSelected');
		if (node){
			$('#${id}').treegrid('options').url = null;
			$('#${id}').treegrid('reload', node.TREETABLEID);
			$('#${id}').treegrid('collapse', node.TREETABLEID);
		} else {
			alert('请选择要清理的数据！');
		}
	}
	
	function showMenu_${id}(e, id){
	    e=arguments[0]||window.event;//var event = $.Event(arguments[0] || window.event);
		var row = $('#${id}').treegrid('find',id);
		$("div[data-type='easyMenuItem_${id}'][data-level='0']").each(function (index, domEle) {
			$('#cm_${id}').menu('enableItem', domEle);
		}); //显示所有没有分组的维度菜单
		$("div[data-type='easyMenuItem_${id}'][data-level!='0']").each(function (index, domEle) {
			$('#cm_${id}').menu('disableItem', domEle);
		}); //隐藏所有有分组的维度菜单
		setMenuVisible_${id}(row);                                     //递归隐藏维度菜单
		//e.preventDefault();// 阻止事件
		var sc = $(window).scrollTop();

		if(sc==undefined){
			sc = 0;
		}
		var x = e.pageX;
		var y = e.pageY;
		if(x==undefined){
			x = e.clientX;
		}
		if(y==undefined){
			y = e.clientY;
		}
		if ($.browser.msie){
			if(parseInt($.browser.version) < 9){
				y = y+sc;
			}
		}
		stopPreventDefault(e);
		$('#${id}').treegrid('unselectAll');
		$('#${id}').treegrid('select', row.TREETABLEID);
		$('#cm_${id}').menu('show', {
			left: x,
			top: y
		});
		//e.stopPropagation();//阻止事件传播
		stopDefault(e);
	}
	function stopDefault(e) { 
     	if (e && e.preventDefault) {//如果是FF下执行这个
        	e.stopPropagation();//阻止事件传播
	    }else{ 
	        window.event.returnValue = false;//如果是IE下执行这个
	    }
	    return false;
 	}
 	function stopPreventDefault(e) { 
     	if (e && e.preventDefault) {//如果是FF下执行这个
        	e.preventDefault();
	    }else{ 
	        window.event.returnValue = false;//如果是IE下执行这个
	    }
	    return false;
 	}
 
	function enableMenuItem_${id}(id){
		var itemEl = $('#'+id)[0];  // the menu item element
		if(itemEl!=null){
			$('#cm_${id}').menu('enableItem', item.target);
		}
	}
	
	function disableMenuItem_${id}(id){
		var itemEl = $('#'+id)[0];  // the menu item element
		if(itemEl!=null){
			$('#cm_${id}').menu('disableItem', itemEl);
		}
	}
	
	function setMenuVisible_${id}(node){
		setGroupMenuVisible_${id}(node); //隐藏同组父维度菜单
		var parent = $('#${id}').treegrid('getParent',node.TREETABLEID);
		if(parent!=null){
			setMenuVisible_${id}(parent);
		}
		disableMenuItem_${id}(node.DIM+"_${id}");
	}
	
	function setGroupMenuVisible_${id}(node){
		var $menuItem = $("#"+node.DIM+"_${id}");
		if($menuItem.length>0){
			$menuItemGroup = $menuItem.data("group");
			$menuItemLevel = $menuItem.data("level");
			$("div[data-group='"+$menuItemGroup+"']").each(function(){
				if($(this).data("level")<$menuItemLevel){
					$('#cm_${id}').menu('disableItem', this);
				}
				if($(this).data("level")==$menuItemLevel+1){
					$('#cm_${id}').menu('enableItem', this);
				}
			});
		}
	}

	function setQueryParams_${id}(node, params){
		params[node.DIM] = node.${idField};
		var parent = $('#${id}').treegrid('getParent',node.TREETABLEID);
		if(parent!=null){
			setQueryParams_${id}(parent, params);
		}
	}
	
	function setDimUrl_${id}(node){
		var url = '&'+node.DIM+"="+node.${idField};
		var parent = $('#${id}').treegrid('getParent',node.TREETABLEID);
		if(parent!=null){
			url += setDimUrl_${id}(parent);
		}
		return url;
	}

	$(document).ready(function() {
		$('#${id}').treegrid(options_${id});
	});
function downExcel_${id}(field,epath){
	//判断是否拥有导出权限
	var cmenuid = '';
	try{
		if('${module_id}' != '' && '${module_id}' != null){
			cmenuid = '${module_id}';
		}else if(top.window.currentId != '' && top.window.currentId != undefined){
			cmenuid = top.window.currentId;
		}else if('${param.currentId}' != '' && '${param.currentId}' != null){
			cmenuid = '${param.currentId}';
		}else{
			cmenuid = '';
		}
	}catch(err){
		cmenuid = '';
	}
	//if(cmenuid != null && cmenuid != ''){
	if('${applicationScope.AuthExport}' == 'false' || '${applicationScope.AuthExport}' == '' || '${applicationScope.AuthExport}' == 'null'){
		download_exec_${id}(epath,field,cmenuid);
	}else{
		$.post((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/auth2Export.e',{menuid:cmenuid},function(authflag){
			if(authflag == '1'){
				download_exec_${id}(epath,field,cmenuid);
			}else{
				$.messager.alert('下载提示','您没有导出权限！','warning');
			}
		});
	}
}
function download_exec_${id}(epath,field,cmenuid){
	$('#${id}').treegrid('options').loadMsg = '下载已经开始，请耐心等待，3秒后消失...';
	$('#${id}').treegrid('loading');
	setTimeout(function(){$('#${id}').treegrid('loaded')},3000);
	$('#${id}').treegrid('options').loadMsg = '请稍候...';
	//140228增加导出日志
	$.post((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/export2Log.e',{menuid:cmenuid,content:epath});
	
	var table_${id}_url = (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}');
	table_${id}_url += '&dim='+field;
	
	var node = $('#${id}').treegrid('getSelected');
	var info = {};
	if(node){setQueryParams_${id}(node,info);}
	var down_para_${id} = '&'+$.param(info);
	var qParams = $('#${id}').treegrid('options').queryParams;
	
	var down_url_sql = table_${id}_url.indexOf('?')!=-1?table_${id}_url.substring(0,table_${id}_url.indexOf('?')):table_${id}_url;
	var url_params = table_${id}_url.indexOf('?')!=-1?table_${id}_url.substring(table_${id}_url.indexOf('?')+1):'';
	var q_param_str = ',';
	$.each(qParams, function(key, val){
			q_param_str +=key+',';
	});
	var params = url_params+'${downArgs}'+"&"+down_para_${id};
	qParams={};
	if(params != null && params != ''){
		var arr_tmp = params.split('&');
		if(arr_tmp.length>0){
			for(var a=0;a<arr_tmp.length;a++){
				if(arr_tmp[a] != null && arr_tmp[a].length>0){
					var v_arr = arr_tmp[a].split('=');
					if(q_param_str.indexOf(','+v_arr[0]+',')<=-1){
						qParams[v_arr[0]]=v_arr[1];
					}
				}
			}
		}else{
			var v_arr = arr_tmp[0].split('=');
			if(q_param_str.indexOf(','+v_arr[0]+',')<=-1){
				qParams[v_arr[0]]=v_arr[1];
			}
		}
	} 
	qParams.is_down_table=true;
	$.post(table_${id}_url,qParams,function(data){
		var ebuilderData = {};
		if (typeof(ebuilder_grid_field_percent) != "undefined") {
		    for (var i = 0; i < ebuilder_grid_field_percent.length; i++) {
		    	var data = ebuilder_grid_field_percent[i];
		        if (data.comid == '${id}') {
		            ebuilderData[data.filedkey] = '1';
		        }
		    }
		}
		var str='';
		var frozenTitle2Arr = $('#${id}').treegrid('options').frozenColumns;
		var title2Arr = $('#${id}').treegrid('options').columns;
		for(var i=0;i<frozenTitle2Arr.length;i++){
			for(var n=0; n<frozenTitle2Arr[i].length; n++){
				var col=frozenTitle2Arr[i][n];
				var rn = col.rowspan == undefined?"1":col.rowspan;
				var cn = col.colspan == undefined?"1":col.colspan;
				var value = ebuilderData[col.field];
				if(value !=null && value !='' && value !=undefined && value !='undefined'){
					if(value == '1'){
						str += col.title+','+col.field+','+rn+','+cn+',1;';
					}else{
						str += col.title+','+col.field+','+rn+','+cn+',0;';
					}
				}else{
					str += col.title+','+col.field+','+rn+','+cn+',0;';
				}
				if(n == (frozenTitle2Arr[i].length-1) && i !=(frozenTitle2Arr.length-1)){
					str +='&';
				}
			}
		}
		for(var i=0;i<title2Arr.length;i++){
			for(var n=0; n<title2Arr[i].length; n++){
				var col=title2Arr[i][n];
				var rn = col.rowspan == undefined?"1":col.rowspan;
				var cn = col.colspan == undefined?"1":col.colspan;
				var value = ebuilderData[col.field];
				if(value !=null && value !='' && value !=undefined && value !='undefined'){
					if(value == '1'){
						str += col.title+','+col.field+','+rn+','+cn+',1;';
					}else{
						str += col.title+','+col.field+','+rn+','+cn+',0;';
					}
				}else{
					str += col.title+','+col.field+','+rn+','+cn+',0;';
				}
				if(n == (title2Arr[i].length-1) && i !=(title2Arr.length-1)){
					str +='&';
				}
			}
		}
	//去除html标记
	str = str.replace(/&nbsp;/g,"").replace(/<\/?.+?>/g,"");
	
	//更改下钻维度的合并行数（这里easyui有个错误，所有的下钻维度，都是1行1列，实际可能为n行1列）
	var $dim_obj=$("#${id}").find('tr');
	var maxRow=0;
	$.each($dim_obj,function(index, o){
		maxRow++;
	});
	if(maxRow>1){
		var treeDimStr = str.substring(0,str.indexOf(";"));
		var surplusStr = str.substring(str.indexOf(";"));
		var treeDimArr = treeDimStr.split(",");
		treeDimArr[2] = maxRow;
		str = treeDimArr.join(",")+surplusStr;
	}
	var $export = '';
	var form_input = '';
	var outparams="";//导出参数字符串
	var param_index=0;
	$.each(qParams, function(key, val){
		form_input+='<input type=hidden name='+key+' value='+val+'>';
		if(param_index==0)
			outparams+="?"+key+"="+val;
		else
			outparams+="&"+key+"="+val;
		param_index++;
	});
	if(epath == 'excel'){
		$export = $('<form id=export${dc} method=post action="'+(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/downTgrid.e">'+form_input+'<input type=hidden name=dataSourceName id=dataSourceName value=${extds }/><input type=hidden name=filename /><input type=hidden name=columns /><input type=hidden name=key value=V2 /></form>').appendTo('body');
	}else{
		$export = $('<form id=export${dc} method=post action="'+(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/downTgridPdf.e">'+form_input+'<input type=hidden name=dataSourceName id=dataSourceName value=${extds }/><input type=hidden name=filename /><input type=hidden name=columns /><input type=hidden name=key value=V2 /></form>').appendTo('body');
	}
	var exportForm = $export[0];
	<e:if condition="${download==null || download eq ''}">
		exportForm.filename.value='数据';
	</e:if>
	<e:if condition="${download!=null && download ne ''}">
		exportForm.filename.value='${download}';
	</e:if>
	exportForm.columns.value=str;
	
	//form表单提交前先执行以下Action页面，以便取得导出数据的sql语句并放入session中
	var tableUrl=$('#${id}').treegrid('options').url;
	tableUrl=tableUrl.indexOf("?")>-1?tableUrl.substr(0,tableUrl.indexOf("?")):tableUrl;
	tableUrl+=outparams;
	$.ajax(tableUrl,{},function(data){});
	exportForm.submit();
});
}



</script>