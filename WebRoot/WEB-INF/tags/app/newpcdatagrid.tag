<%@ tag body-content="scriptless" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="id" required="true" %>                                               	<e:description>表格id</e:description>
<%@ attribute name="url" required="true" %>                                              	<e:description>数据路径</e:description>
<%@ attribute name="extds" required="false" %>                       						<e:description>扩展数据源名称</e:description>
<%@ attribute name="fitColumns" required="false" %>											<e:description>是否列自动适合宽带(true/false),默认为 是(true)</e:description>
<%@ attribute name="pagination" required="false" %>                                       	<e:description>是否显示分页工具栏(true/false),默认为 是(true)</e:description>
<%@ attribute name="rownumbers" required="false" %>                                       	<e:description>是否显示行号(true/false),默认为 是(true)</e:description>
<%@ attribute name="singleSelect" required="false" %>                                       <e:description>数据是否单选(true/false)</e:description>
<%@ attribute name="pageSize" required="false" %>                                       	<e:description>页面结果集大小</e:description>
<%@ attribute name="pageList" required="false" %>                                       	<e:description>每页记录数(以‘,’分隔的字符串),默认为'10,15,20,25,30,40,50'</e:description>
<%@ attribute name="onClickRow" required="false" %>                          	         	<e:description>单击行事件(js方法名,js方法有两个参数rowIndex,rowData)</e:description>
<%@ attribute name="onDblClickRow" required="false" %>                          	        <e:description>双击行事件(js方法名,js方法有两个参数rowIndex,rowData)</e:description>
<%@ attribute name="onClickCell" required="false" %>                          	        	<e:description>单击单元格事件(js方法名,js方法有三个参数rowIndex, field, value)</e:description>
<%@ attribute name="onDblClickCell" required="false" %>                          	        <e:description>双击单元格事件(js方法名,js方法有三个参数rowIndex, field, value)</e:description>
<%@ attribute name="onBeforeLoad" required="false" %>                          	            <e:description>预加载事件</e:description>
<%@ attribute name="onLoadSuccess" required="false" %>                          	        <e:description>加载当前页面数据成功事件(js方法名,js方法有一个参数data)</e:description>
<%@ attribute name="download" required="false" %>                          	        		<e:description>导出文件的名称，不为空时下载</e:description>
<%@ attribute name="downArgs" required="false" %>                          	        		<e:description>导出文件的获得sql的参数，格式为&A=33&b=44</e:description>
<%@ attribute name="nowrap" required="false" %>                                             <e:description>单元格中的内容是否不换行，true不换；false换行</e:description>

<%@ attribute name="frozenRows" required="false" %>                                         <e:description>锁定前几行</e:description>
<%@ attribute name="frozenColumns" required="false" %>                                      <e:description>锁定列(数组字符串)</e:description>

<%@ attribute name="sortName" required="false" %>                                           <e:description>横向维度排序列名</e:description>
<%@ attribute name="sortOrder" required="false" %>                                          <e:description>默认排序顺序(asc/desc)</e:description>
<%@ attribute name="remoteSort" required="false" %> 										<e:description>是否使用远程排序</e:description>
<%@ attribute name="fit" required="false" %> 												<e:description>表格自适应</e:description>

<%@ attribute name="mergerFields" required="false" %> 										<e:description>数据记录需要行合并的列的字段名（th中的field属性值），多个值以“,”分隔，如“column1,column2”</e:description>


<%@ attribute name="dimCol" required="false" %> 										    <e:description>指标列名称</e:description>
<%@ attribute name="kpiCol" required="false" %> 										    <e:description>指标值列名称</e:description>
<%@ attribute name="rotaCol" required="false" %> 										    <e:description>数据集SQL中的旋转列</e:description>
<%@ attribute name="rotaColOrder" required="false" %> 										<e:description>旋转列排序方式</e:description>

<%@ attribute name="rotaDimTable" required="false" %> 										<e:description>以码表旋转</e:description>
<%@ attribute name="rotaDimCode" required="false" %> 										<e:description>旋转码表编码列</e:description>
<%@ attribute name="rotaDimDesc" required="false" %> 										<e:description>旋转码表描述列</e:description>
<%@ attribute name="rotaOrdCode" required="false" %> 										<e:description>以码表旋转排序列</e:description>
<%@ attribute name="rotaOrdType" required="false" %> 										<e:description>以码表旋转排序方式</e:description>


<%@ attribute name="module_id" required="false" %>                                          <e:description>菜单编号</e:description>
<jsp:doBody var="bodyRes" />
<e:if condition="${mergerFields!=null}">
	
</e:if>
<table id="${id}"<e:forEach items="${dynattrs}" var="item"> ${item.key}="${item.value}"</e:forEach>>
   <e:if condition="${rotaCol==null||rotaCol eq ''}" var='rotateIf'>
     ${bodyRes}
  </e:if>
</table>
<e:if condition="${fitColumns==null}">
	<e:set var="fitColumns" value="true" />
</e:if>
<e:if condition="${pagination==null}">
	<e:set var="pagination" value="true" />
</e:if>
<e:if condition="${rownumbers==null}">
	<e:set var="rownumbers" value="true" /> 
</e:if>
<e:if condition="${singleSelect==null}">
	<e:set var="singleSelect" value="true" />
</e:if>
<e:if condition="${frozenColumns==null}">
	<e:set var="frozenColumns" value="[]" />
</e:if>
<script type="text/javascript">
	function mergeCellFun_${id}(table,column,pageData,frozenRowNum){
				var tmpStr='';
				var mergeBegin=0;
				var mergeEnd=0;
				var i=0;
				if(frozenRowNum!=null&&frozenRowNum!=''&&frozenRowNum!='null'){
					i=frozenRowNum;
				}
				if(i!=0){
					for(i=0;i<frozenRowNum;i++){
						if(tmpStr==pageData[i][column]){
							continue;
						}
						mergeEnd=i;
						if(0!=mergeEnd){
							$(table).datagrid('mergeCells',{ 
			                    index: mergeBegin,  
			                    field: column,  
			                    rowspan: (mergeEnd-mergeBegin)
			                });
						}
						tmpStr=pageData[i][column];
						mergeBegin=i;
					}
					mergeEnd=pageData.length;
					$(table).datagrid('mergeCells', {
						index : mergeBegin,
						field : column,
						rowspan : (mergeEnd - mergeBegin)
					});
				}
				tmpStr='';
				mergeBegin=0;
				mergeEnd=0;
				i=0;
				if(frozenRowNum!=null&&frozenRowNum!=''&&frozenRowNum!='null'){
					i=frozenRowNum;
				}
				for(;i<pageData.length;i++){
					if(tmpStr==pageData[i][column]){
						continue;
					}
					mergeEnd=i;
					if(0!=mergeEnd){
						$(table).datagrid('mergeCells',{ 
		                    index: mergeBegin,  
		                    field: column,  
		                    rowspan: (mergeEnd-mergeBegin)
		                });
					}
					tmpStr=pageData[i][column];
					mergeBegin=i;
				}
				mergeEnd=pageData.length;
				$(table).datagrid('mergeCells', {
					index : mergeBegin,
					field : column,
					rowspan : (mergeEnd - mergeBegin)
				});
		}
	
	
	//前台分页
	function pagerFilter_${id}(data){
		if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
			data = {
				total: data.length,
				rows: data
			}
		}
		var dg = $(this);
		var opts = dg.datagrid('options');
		var pager = dg.datagrid('getPager');

		pager.pagination({
			onSelectPage:function(pageNum, pageSize){
				opts.pageNumber = pageNum;
				opts.pageSize = pageSize;
				pager.pagination('refresh',{
					pageNumber:pageNum,
					pageSize:pageSize
				});
				dg.datagrid('loadData',data);
			}
		});
		if (!data.originalRows){
			data.originalRows = (data.rows);
		}
		var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
		var end = start + parseInt(opts.pageSize);
		data.rows = (data.originalRows.slice(start, end));
		return data;
	}
	
	function initConfig_${id}(finalData){
		var frozenColArr=${frozenColumns};
	    var jsonColumnFinal=new Array();
		var jsonColumnInner=new Array();
		
		if(finalData!=null&&finalData.cols!=null){
			var jsonColumn=$.parseJSON('['+finalData.cols+']');
			jsonColumnFinal.push(jsonColumnInner);
			for(var i=0;i<jsonColumn[0].length;i++){
				var isAdd=true;
				if(frozenColArr!=null&&frozenColArr.length>0){
					for(var j=0;j<frozenColArr[0].length;j++){
				    	if(frozenColArr[0][j].field==jsonColumn[0][i].field){
				    		isAdd=false;
				    		break;
				    	}
				    }
				}
				if(isAdd){
					jsonColumn[0][i].formatter=window[jsonColumn[0][i].formatter];
					jsonColumnInner.push(jsonColumn[0][i]);
				}
				
			}
		} 
        var options_${id} = {
        		<e:if condition="${rotaCol!=null&&rotaCol ne ''}" var='rotateIf'>
        			data: $.parseJSON(finalData.data).rows,
        			columns: jsonColumnFinal,
        			pageNumber:1,
            		loadFilter:pagerFilter_${id},
    		    </e:if>
        		<e:else condition="${rotateIf}">
        		   url: (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'),
        		</e:else>
        		fitColumns: ${fitColumns},
        		<e:if condition="${fit!=null}">
        			fit: ${fit},
        		</e:if>
        		<e:if condition="${nowrap!=null}">
        			nowrap: ${nowrap},
        		</e:if>
        		<e:if condition="${pageSize!=null}">
        			pageSize: ${pageSize},
        		</e:if>
        		<e:if condition="${pageList!=null}">
        			pageList: [${pageList}],
        		</e:if>
        		<e:if condition="${pageList==null || pageList==''}">
        			pageList: [10,15,20,25,30,40,50],
        		</e:if>
        		<e:if condition="${onClickRow!=null}">
        			onClickRow: ${onClickRow},
        		</e:if>
        		<e:if condition="${onDblClickRow!=null}">
        			onDblClickRow: ${onDblClickRow},
        		</e:if>
        		<e:if condition="${onClickCell!=null}">
        			onClickCell: ${onClickCell},
        		</e:if>
        		
        		onLoadSuccess:function(data){
        			<e:if condition="${frozenRows!=null && frozenRows>0}">
        				for(var i=0;i<${frozenRows};i++){
        					$(this).datagrid('freezeRow',i);
        				}
        			</e:if>
        			<e:if condition="${mergerFields!=null}">
        				var mergerFields='${mergerFields}';
        				var mergerFieldsParts=mergerFields.split(",");
        				if(mergerFieldsParts!=undefined&&mergerFieldsParts!=null&&mergerFieldsParts.length!=0){
        					for(var i=0;i<mergerFieldsParts.length;i++){
        						mergeCellFun_${id}(this,mergerFieldsParts[i],data.rows,'${frozenRows}');
        					}
        				}
        			</e:if>
        			<e:if condition="${onLoadSuccess!=null}">
        				${onLoadSuccess}(data);
        			</e:if>
        		},
        		<e:if condition="${onDblClickCell!=null}">
        			onDblClickCell: ${onDblClickCell},
        		</e:if>
        		<e:if condition="${onBeforeLoad!=null}">
        			onBeforeLoad: ${onBeforeLoad},
        		</e:if>
        		
        		<e:if condition="${frozenColumns!=null && frozenColumns!=''&& frozenColumns!='[]'}">
        				frozenColumns:${frozenColumns},
        				fitColumns:false,
        		</e:if>
        		
        		<e:if condition="${sortName!=null && sortName!=''}">
        				sortName:'${sortName}',
        		</e:if>
        		<e:if condition="${sortOrder!=null && sortOrder!=''}">
        				sortOrder:'${sortOrder}',
        		</e:if>
        		
        		pagination:	${pagination},
        		rownumbers:	${rownumbers},
        		singleSelect:	${singleSelect},
        		<e:if condition="${remoteSort!=null && remoteSort!=''}">
        			remoteSort:	${remoteSort}
        		</e:if>
        		<e:if condition="${remoteSort==null || remoteSort==''}">
        			remoteSort:	true
        		</e:if>	
        	};
                $('#${id}').datagrid(options_${id});
            /**********************end datagrid ****************************/
	}
	
$(document).ready(function() {
	<e:if condition="${rotaCol==null||rotaCol eq ''}" var='rotateIf'>
		initConfig_${id}(null);
    </e:if>
	<e:else condition="${rotateIf}">
	var paramMap={};
		paramMap.rotaCol='${rotaCol}';
		<e:if condition="${sortName!=null && sortName!=''}">
		        paramMap.sort="${sortName}";
		</e:if>
		<e:if condition="${sortOrder!=null && sortOrder!=''}">
				paramMap.order="${sortOrder}";
		</e:if>
		$.ajax({
		      type : "post",  
		      url : (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'),  
		      data : paramMap,  
		      async : false,  
		      //dataType:"json",
		      success : function(data1){
		      	 data1 = data1.replace(/\r\n\t/g,'');
				 data1 = data1.replace(/(^\s*)|(\s*$)/g, "");
		      	 paramMap.dataJson=data1;
		      	 paramMap.id="${id}";
		      	 paramMap.kpiCol="${kpiCol}";
		      	 paramMap.dimCol="${dimCol}";
		      	 paramMap.rotaColOrder="${rotaColOrder}";
		      	 paramMap.rotaDimTable="${rotaDimTable}";
		      	 paramMap.rotaDimCode="${rotaDimCode}";
		      	 paramMap.rotaDimDesc="${rotaDimDesc}";
		      	 paramMap.rotaOrdCode="${rotaOrdCode}";
		      	 paramMap.rotaOrdType="${rotaOrdType}";
				 $.ajax({
				      type : "post",  
				      url : (window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/rotaData2.e',  
				      data : paramMap,  
				      async : false,  
				      dataType:"json",
				      success : function(datars){
						initConfig_${id}(datars);
				      }
				  }); 
		      }
		});
		</e:else>
	
	
		
		var pager_${id} = $('#${id}').datagrid('getPager');	// get the pager of datagrid
		<e:if condition="${download!=null && download!=''}">
			function download_${id}(epath){
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
					download_exec_${id}(epath,cmenuid);
				}else{
					$.post((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/auth2Export.e',{menuid:cmenuid},function(authflag){
						if(authflag == '1'){
							download_exec_${id}(epath,cmenuid);
						}else{
							$.messager.alert('下载提示','您没有导出权限！','warning');
						}
					});
				}
				//}else{
				//	$.messager.alert('下载提示','请您正确选择菜单，然后在点击导出！','warning');
				//}
			}
			function download_excel_${id}(){
				download_${id}('excel');
			}
			function download_pdf_${id}(){
				download_${id}('pdf');
			}
			function download_exec_${id}(epath,cmenuid){
				$.post((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/setDownStatus.e',{downid:'${id}',status:'ing'});
				if(epath == 'excel'){
					pager_${id}.pagination({
						buttons:[{
							iconCls:'icon-download-ing',
							handler:function(){
							//alert('下载中，请稍候。。。');
								$.messager.confirm('操作提示','下载中，点击确定重新下载，点击取消则等待。', function(r){
									if (r){
										setNoDownStatus();
										download_excel_${id}();
									}
								});
							}
						},{
							iconCls:'icon-download-pdf',
							handler:function(){
							//alert('请等待其他下载完后，再操作!');
								$.messager.confirm('操作提示','下载中，点击确定重新下载，点击取消则等待。', function(r){
									if (r){
										setNoDownStatus();
										download_pdf_${id}();
									}
								});
							}
						}]
					});
				}else{
					pager_${id}.pagination({
						buttons:[{
							iconCls:'icon-download-excel',
							handler:function(){
							//alert('请等待其他下载完后，再操作!');
								$.messager.confirm('操作提示','下载中，点击确定重新下载，点击取消则等待。', function(r){
									if (r){
										setNoDownStatus();
										download_excel_${id}();
									}
								});
							}
						},{
							iconCls:'icon-download-ing',
							handler:function(){
							//alert('下载中，请稍候。。。');
								$.messager.confirm('操作提示','下载中，点击确定重新下载，点击取消则等待。', function(r){
									if (r){
										setNoDownStatus();
										download_pdf_${id}();
									}
								});
							}
						}]
					});
				}
			
				//$('#${id}').datagrid('options').loadMsg = '下载已经开始，请耐心等待，3秒后消失...';
				//$('#${id}').datagrid('loading');
				//setTimeout(function(){$('#${id}').datagrid('loaded')},3000);
				//$('#${id}').datagrid('options').loadMsg = '请稍候...';
				
				//140228增加导出日志
				$.post((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/export2Log.e',{menuid:cmenuid,content:epath});
				
				var table_${id}_url = $('#${id}').datagrid('options').url;
				var down_para_${id} = table_${id}_url.indexOf('?')!=-1?'&is_down_table=true':'?is_down_table=true';
				var qParams = $('#${id}').datagrid('options').queryParams;
				var url_params = table_${id}_url.indexOf('?')!=-1?table_${id}_url.substring(table_${id}_url.indexOf('?')+1):'';
				
				var q_param_str = ',';
				$.each(qParams, function(key, val){
 					q_param_str +=key+',';
				});
				var params = url_params+'${downArgs}';
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

				$.post(table_${id}_url+down_para_${id}+'${downArgs}',qParams,function(data){
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
					var frozenTitle2Arr = $('#${id}').datagrid('options').frozenColumns;
					var title2Arr = $('#${id}').datagrid('options').columns;
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
					str = str.replace(/&nbsp;/g,"").replace(/<\/?.+?>/g,"");
					var $export = '';
					var form_input = '';
			 		$.each(qParams, function(key, val){
	  					form_input+='<input type="hidden" name="'+key+'" value="'+val+'">';
					});
					form_input+='<input type="hidden" name="downid" value="${id}">';
					if(epath == 'excel'){
						$export = $('<form id=export${dc} method=post action="'+(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/downCtable.e">'+form_input+'<input type=hidden name=dataSourceName id=dataSourceName value=${extds }/><input type=hidden name=filename /><input type=hidden name=columns /></form>').appendTo('body');
					}else{
						$export = $('<form id=export${dc} method=post action="'+(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/downCtablePdf.e">'+form_input+'<input type=hidden name=dataSourceName id=dataSourceName value=${extds }/><input type=hidden name=filename /><input type=hidden name=columns /></form>').appendTo('body');
					}
					var exportForm = $export[0];
					<e:if condition="${download==null || download eq ''}">
						exportForm.filename.value='数据';
					</e:if>
					<e:if condition="${download!=null && download ne ''}">
						exportForm.filename.value='${download}';
					</e:if>
					exportForm.columns.value=str;
					exportForm.submit();
					setTimeout(getDownStatus,2000);
				});
			}
			function getDownStatus(){
				$.post((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/getDownStatus.e',{id:'${id}'},function(data){
					if(data == 'ok'){
						pager_${id}.pagination({
							buttons:[{
								iconCls:'icon-download-excel',
								handler:download_excel_${id}
							},{
								iconCls:'icon-download-pdf',
								handler:download_pdf_${id}
							}]
						});
					}else{
						setTimeout(function(){getDownStatus()},5000);
					}
				});

			}
			function setNoDownStatus(){
				pager_${id}.pagination({
					buttons:[{
						iconCls:'icon-download-excel',
						handler:download_excel_${id}
					},{
						iconCls:'icon-download-pdf',
						handler:download_pdf_${id}
					}]
				});
			}
			setNoDownStatus();
		</e:if>
	});
</script>