<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir='/WEB-INF/tags/app'%>
	<script>
		(function($){
			function pagerFilter(data){
		        if ($.isArray(data)){ 
		            data = {  
		                total: data.length,  
		                rows: data  
		            }  
		        }
		        var dg = $(this);  
				var state = dg.data('treegrid');
		        var opts = dg.treegrid('options');  
		        var pager = dg.treegrid('getPager');  
		        pager.pagination({
		        <e:if var="tmpW" condition="${download!=null && download!=''}">
		        	buttons:[{
		        		id:"excelBtn_${tableid}",
						iconCls:'icon-download-excel',
						handler:download_excel_${id}
					},{
						id:"pdfBtn_${tableid}",
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
		        </e:if>
		            onSelectPage:function(pageNum, pageSize){
		                opts.pageNumber = pageNum;  
		                opts.pageSize = pageSize;  
		                pager.pagination('refresh',{  
		                    pageNumber:pageNum,  
		                    pageSize:pageSize  
		                });  
		                dg.treegrid('loadData',state.allRows);  
		            }  
		        });  
		        opts.pageNumber = pager.pagination('options').pageNumber || 1;
		        if (!state.allRows){
		        	state.allRows = data.rows;
		        }
		        var topRows = [];
		        var childRows = [];
		        $.map(state.allRows, function(row){
		        	row._parentId ? childRows.push(row) : topRows.push(row);
		        });
		        data.total = topRows.length;
		        var start = (opts.pageNumber-1)*parseInt(opts.pageSize);  
		        var end = start + parseInt(opts.pageSize);  
				data.rows = $.extend(true,[],topRows.slice(start, end).concat(childRows));
				return data;
			}

			var appendMethod = $.fn.treegrid.methods.append;
			var removeMethod = $.fn.treegrid.methods.remove;
			var loadDataMethod = $.fn.treegrid.methods.loadData;
			$.extend($.fn.treegrid.methods, {
				clientPaging: function(jq){
					return jq.each(function(){
						var state = $(this).data('treegrid');
						var opts = state.options;
						opts.loadFilter = pagerFilter;
						var onBeforeLoad = opts.onBeforeLoad;
						opts.onBeforeLoad = function(row,param){
							state.allRows = null;
							return onBeforeLoad.call(this, row, param);
						}
						$(this).treegrid('loadData', state.data);
						if (opts.url){
							$(this).treegrid('reload');
						}
					});
				},
				loadData: function(jq, data){
					jq.each(function(){
						$(this).data('treegrid').allRows = null;
					});
					return loadDataMethod.call($.fn.treegrid.methods, jq, data);
				},
				/**
				append: function(jq, param){
					return jq.each(function(){
						if (state.options.loadFilter == pagerFilter){
							$.map(param.data, function(row){
								row._parentId = row._parentId || param.parent;
								state.allRows.push(row);
							});
							$(this).treegrid('loadData', state.allRows);
						} else {
							appendMethod.call($.fn.treegrid.methods, $(this), param);
						}
					})
				},
				remove: function(jq, id){
					return jq.each(function(){
						if ($(this).treegrid('find', id)){
							removeMethod.call($.fn.treegrid.methods, $(this), id);
						}
						var state = $(this).data('treegrid');
						if (state.options.loadFilter == pagerFilter){
							for(var i=0; i<state.allRows.length; i++){
								if (state.allRows[i][state.options.idField] == id){
									state.allRows.splice(i,1);
									break;
								}
							}
							$(this).treegrid('loadData', state.allRows);
						}
					})
				},
				**/
				getAllRows: function(jq){
					return jq.data('treegrid').allRows;
				}
			});

		})(jQuery);
		
		$(function(){
			var data = ${jsonData};
			$("#${tableid}").treegrid({
				onBeforeLoad:function(row,param){
					$("#${tableid}").treegrid("loadData",data);
					$("#excelBtn_${tableid}").attr("title","下载excel文件");
					$("#pdfBtn_${tableid}").attr("title","下载pdf文件");
				}
			});
			$('#${tableid}').treegrid().treegrid('clientPaging');
		})
		
		
		//页面js
		${script}
		
		
		
		//下载
		function download_excel_${id}(){
			download_${id}('excel');
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
			
			//$.post(appBase+'/export2Log.e',{menuid:cmenuid,content:epath});
			//if(cmenuid != null && cmenuid != ''){
			//设置alwaysAllowDown属性后一直允许导出
			if('${allowDown}'=='1'){
				download_exec_${id}(epath,null);
				return;
			}
			if('${applicationScope.AuthExport}' == 'false' || '${applicationScope.AuthExport}' == '' || '${applicationScope.AuthExport}' == 'null'){
				download_exec_${id}(epath,cmenuid);
			}else{
				$.post(appBase+'/auth2Export.e',{menuid:cmenuid},function(authflag){
					if(authflag == '1'){
						download_exec_${id}(epath,cmenuid);
					}else{
						$.messager.alert('提示信息','您没有导出权限！','info');
					}
				});
			}
			//}else{
			//	$.messager.alert('下载提示','请您正确选择菜单，然后在点击导出！','warning');
			//}
		}
	
		/**
	   		导出方法
		**/
		function download_exec_${id}(epath,cmenuid){
		//140228增加导出日志
		if(cmenuid!=null&&cmenuid!=''&&cmenuid!='null'){
			$.post(appBase+'/export2Log.e',{menuid:cmenuid,content:epath});
		}
		var ebuilderData = {};
		var str='';
		var frozenTitle2Arr = $('#${tableid}').datagrid('options').frozenColumns;
		var title2Arr = $('#${tableid}').datagrid('options').columns;
		for(var i=0;i<frozenTitle2Arr.length;i++){
			for(var n=0; n<frozenTitle2Arr[i].length; n++){
				var col=frozenTitle2Arr[i][n];
				var rn = col.rowspan == undefined?"1":col.rowspan;
				var cn = col.colspan == undefined?"1":col.colspan;
				if(n == 0){
					var drilldimrow = 0;
					var $headtd = $('#${tableid}').find("tr");
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
		var downParams='${downParams}';
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
		
		var eurl;
		var $export = '';
			if(epath == 'excel'||epath == 'down'){
				eurl = "/downXTableExcelEC.e";
				$export = $("<form id='export${id}' method='post' action='"+(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+"/downXTableExcelEC.e'><input type='hidden' name='module_id' /><input type='hidden' name='jsonData' /><input type='hidden' name='fileName' /><input type='hidden' name='columns' /><input type='hidden' name='key' value='V2' /><input type='hidden' name='downParams' /></form>").appendTo("body");
			}else{
				eurl = "/downXTablePdfEC.e";
				$export = $("<form id='export${id}' method='post' action='"+(window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+"/downXTablePdfEC.e'><input type='hidden' name='module_id' /><input type='hidden' name='jsonData' /><input type='hidden' name='fileName' /><input type='hidden' name='columns' /><input type='hidden' name='key' value='V2' /><input type='hidden' name='downParams' /></form>").appendTo("body");
			}
		var exportForm = $export[0];
		var tgObj = $('#${tableid}').treegrid('getData');
		//alert(tgObj.rows);
		exportForm.jsonData.value=$.toJSON(tgObj);
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
    <table id="${tableid}" class="easyui-treegrid" style="${style}"  idField="id" treeField="${rowsData}" pagination="${tablepagi}" pageSize="${pageSize}" pageList="[${pageList}]" fitColumns="false">
		<thead>
			${title }
		</thead>
	</table>
