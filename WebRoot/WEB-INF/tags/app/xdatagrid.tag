<%@ tag body-content="scriptless" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="id" required="true" %>                                               	<e:description>表格id</e:description>
<%@ attribute name="jsonData" required="true" %>                                              	<e:description>数据路径</e:description>
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
<%@ attribute name="alwaysAllowDown" required="false" %>                          	        <e:description>一直允许导出，1是0否，默认为否</e:description>
<%@ attribute name="download" required="false" %>                          	        		<e:description>导出文件的名称，不为空时下载</e:description>
<%@ attribute name="downArgs" required="false" %>                          	        		<e:description>导出文件的获得sql的参数，格式为&A=33&b=44</e:description>
<%@ attribute name="downParams" required="false" %>                          	        	<e:description>导出文件时的所有参数(导出是记录日志时用到)，包括除downArgs中的值以外的界面上的所有查询查条件，用于下载中心记录，例如为“日期=${param.cc },地市=${param.area }”。如果查询时不是提交到本页，可以向id为“downParams_${id}”的隐藏表单赋值</e:description>
<%@ attribute name="nowrap" required="false" %>                                             <e:description>单元格中的内容是否不换行，true不换；false换行</e:description>

<%@ attribute name="frozenRows" required="false" %>                                         <e:description>锁定前几行</e:description>
<%@ attribute name="frozenColumns" required="false" %>                                      <e:description>锁定列(数组字符串)</e:description>

<%@ attribute name="sortName" required="false" %>                                           <e:description>默认排序列名</e:description>
<%@ attribute name="sortOrder" required="false" %>                                          <e:description>默认排序顺序(asc/desc)</e:description>
<%@ attribute name="remoteSort" required="false" %> 										<e:description>是否使用远程排序</e:description>
<%@ attribute name="fit" required="false" %> 												<e:description>表格自适应</e:description>

<%@ attribute name="mergerFields" required="false" %> 										<e:description>数据记录需要行合并的列的字段名（th中的field属性值），多个值以“,”分隔，如“column1,column2”</e:description>

<%@ attribute name="module_id" required="false" %><e:description>菜单编号</e:description>
<jsp:doBody var="bodyRes" />
<input type="hidden" id="downParams_${id }" value="${downParams }"/>
<table id="${id}"<e:forEach items="${dynattrs}" var="item"> ${item.key}="${item.value}"</e:forEach>>
	${bodyRes}
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
	var jsonData_${id} = ${jsonData}.rows;
	var options_${id} = {
		<e:if var="pflag" condition="${pagination==true}">
			data: jsonData_${id}.slice(0,${pageSize}),
		</e:if>
		<e:else condition="${pflag}">
			data:${jsonData}.rows,
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
		
		<e:if condition="${frozenColumns!=null && frozenColumns!=''}">
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
	$(document).ready(function() {
		$('#${id}').datagrid(options_${id});
		<e:if var="tmpW" condition="${download!=null && download!=''}">
			var pager_${id} = $('#${id}').datagrid('getPager');
			pager_${id}.pagination({
				buttons:[{
					id:"excelBtn_${id}",
					iconCls:'icon-download-excel',
					handler:download_excel_${id}
				},{
					id:"pdfBtn_${id}",
					iconCls:'icon-download-pdf',
					handler:download_pdf_${id}
				}
				<e:if condition="${xShowDownLoadButton=='1'}">
					,{
						id:"downBtn_${id}",
						iconCls:'icon-download-down',
						handler:export_excel_${id}
					}
				</e:if>	
				],
				total:jsonData_${id}.length,
				onSelectPage:function (pageNo, pageSize) {
		          var start = (pageNo - 1) * pageSize; 
		          var end = start + pageSize; 
		          $("#${id}").datagrid("loadData", jsonData_${id}.slice(start, end)); 
		            pager_${id}.pagination('refresh', { 
		            total:jsonData_${id}.length, 
		            pageNumber:pageNo 
		          }); 
	       	 	} 
			});
			$("#excelBtn_${id}").attr("title","下载excel文件");
			$("#pdfBtn_${id}").attr("title","下载pdf文件");
			$("#downBtn_${id}").attr("title","导出excel文件");
			function download_excel_${id}(){
				download_${id}('excel');
			}
			function download_xlsx_${id}(){
				download_${id}('xlsx');
			}
			function download_pdf_${id}(){
				download_${id}('pdf');
			}
			function export_excel_${id}(){
				download_${id}('down');
			}
			function download_${id}(epath){
				if(!downApp.waiting){
					downApp.waiting = true;
					setTimeout(function() {
						downApp.waiting = false;
					}, 2000);
				}else{
					return;
				}
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
				
				//$.post((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/export2Log.e',{menuid:cmenuid,content:epath});
				//if(cmenuid != null && cmenuid != ''){
				
				//设置alwaysAllowDown属性后一直允许导出
				if('${alwaysAllowDown}'=='1'){
					download_exec_${id}(epath,null);
					return;
				}
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
		</e:if>
		<e:else condition="${tmpW}">
			var pager1_${id} = $('#${id}').datagrid('getPager');
			pager1_${id}.pagination({
				total:jsonData_${id}.length,
				onSelectPage:function (pageNo, pageSize) {
		          var start = (pageNo - 1) * pageSize; 
		          var end = start + pageSize; 
		          $("#${id}").datagrid("loadData", jsonData_${id}.slice(start, end)); 
		            pager1_${id}.pagination('refresh', { 
		            total:jsonData_${id}.length, 
		            pageNumber:pageNo 
		          }); 
	       	 	} 
			});
		</e:else>
	});
	
	
	
	/**
	   导出方法
	**/
	function download_exec_${id}(epath,cmenuid){
	//140228增加导出日志
	if(cmenuid!=null&&cmenuid!=''&&cmenuid!='null'){
		$.post((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+'/export2Log.e',{menuid:cmenuid,content:epath});
	}
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
			if(n == 0){
				var drilldimrow = 0;
				var $headtd = $('#${id}').find("tr");
				$headtd.each(function (index, domEle) {
					drilldimrow++;
				});
				rn=drilldimrow;
			}
			
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
			//alert(col.field);
			var value = ebuilderData[col.field];
			//alert(value);
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
	
	//console.log(str);
	
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
	
	var downParams=$("#downParams_${id}").val();
	if(downParams!=''&&downParams!=null&&downParams!=undefined&&downParams!='null'){
		var downParamsStrArray=downParams.split(",");
		downParams='';
		for(var a=0;a<downParamsStrArray.length;a++){
			var downParamsMapArray= downParamsStrArray[a].split("=");
			if(downParamsMapArray.length==2&&downParamsMapArray[1]!=null&&downParamsMapArray[1]!='null'&&downParamsMapArray[1]!=''&&downParamsMapArray[1]!=undefined&&downParamsMapArray[1]!='undefined'){
				downParams+=","+downParamsStrArray[a];
			}
		}
	}else{
		downParams='';
	}
	
	var $export = '';
	var eurl;
		if(epath == 'excel'||epath == 'down'){
			eurl = "/downXTableExcelEC.e";
			$export = $("<form id='export${id}' method='post' action='"+(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+"/downXTableExcelEC.e'><input type='hidden' name='module_id' /><input type='hidden' name='jsonData' /><input type='hidden' name='fileName' /><input type='hidden' name='columns' /><input type='hidden' name='key' value='V2' /><input type='hidden' name='downParams' /></form>").appendTo("body");
		}else if(epath == 'xlsx'){
			eurl = "/downXTableXlsxEC.e";
			$export = $("<form id='export${id}' method='post' action='"+(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+"/downXTableXlsxEC.e'><input type='hidden' name='module_id' /><input type='hidden' name='jsonData' /><input type='hidden' name='fileName' /><input type='hidden' name='columns' /><input type='hidden' name='key' value='V2' /><input type='hidden' name='downParams' /></form>").appendTo("body");
		}else{
			eurl = "/downXTablePdfEC.e";
			$export = $("<form id='export${id}' method='post' action='"+(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+"/downXTablePdfEC.e'><input type='hidden' name='module_id' /><input type='hidden' name='jsonData' /><input type='hidden' name='fileName' /><input type='hidden' name='columns' /><input type='hidden' name='key' value='V2' /><input type='hidden' name='downParams' /></form>").appendTo("body");
		}
	var exportForm = $export[0];
	//取分页数据
	var tgObj = $('#${id}').datagrid('getData');
	//alert(tgObj.rows);
	//取全数据
	exportForm.jsonData.value=$.toJSON(${jsonData}.rows);
	exportForm.module_id.value='${module_id}';
	exportForm.fileName.value='${download}';
	exportForm.columns.value=str;
	exportForm.downParams.value=downParams;
	if(epath=='down'){
		loading_${id}();
	}
	/*
		页面直接导出
		每隔3秒获取一次下载状态
	*/
	$.post(appBase+eurl,$("#export${id}").serialize(),function(data){
		var _data = $.parseJSON($.trim(data));
		if(_data&&_data.id&&epath=='down'){
			var intervalId = setInterval(function(){
				var surl = appBase+'/getDownStatus.e';
				$.post(surl,{'id':_data.id},function(dataE){
					var _dataE = $.parseJSON($.trim(dataE));
					if(_dataE.status_id.trim()=='4'||_dataE.status_id.trim()=='5'){
						clearInterval(intervalId);
						var downFileUrl = '${DownLoadServerAction}';
						doDownload_${id}(_data.id,downFileUrl);
					}else if(_dataE.status_id.trim()=='99'){
						clearInterval(intervalId);
						$.messager.alert("提示信息","下载出错！请在下载中心查看下载状态。","error");
					}else if(_dataE.status_id.trim()=='3'){
						clearInterval(intervalId);
						$.messager.alert("提示信息","已取消下载！请在下载中心查看下载状态。","error");
					}
					disLoading_${id}();
				});
			},3000); 
		}else{
			disLoading_${id}();
			var expPageUrl = appBase+'/pages/frame/download/exportInfo.jsp';
			$.messager.show({
				title:'消息',
				msg:'已进入下载队列，请转到<a style="color:#00f" href="'+expPageUrl+'" target="_blank">导出中心</a>查看进行下载!',
				showType:'show'
			});
		}
	});
}
	//提交导出的form
	function doDownload_${id}(id,filePath){
		var form=$("<form>");//定义一个form表单
		form.attr("style","display:none");
		form.attr("method","post");
		form.attr("action",filePath);
		var input1=$("<input>");
		input1.attr("type","hidden");
		input1.attr("name","id");
		input1.attr("value",id);
		$("body").append(form);//将表单放置在web中
		form.append(input1);
		form.submit();//表单提交 
		form.remove();
    }
    //弹出加载层
	 function loading_${id}() {  
	     $("<div class=\"datagrid-mask\"></div>").css({'z-index':'9999999999999999', display: "block", width: $(window).width(), height: $(window).height() }).appendTo("body");  
	     $("<div class=\"datagrid-mask-msg\"></div>").html("正在导出，请稍候。。。").appendTo("body").css({ 'z-index':'9999999999999999', display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });  
	 }  
	   
	 //取消加载层  
	 function disLoading_${id}() {  
	     $(".datagrid-mask").remove();  
	     $(".datagrid-mask-msg").remove();  
	 }
</script>