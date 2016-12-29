<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:if condition="${xsavedmode!='1'}">
	<e:q4l var="state" sql="xbuilder.reportManager.reportStateList"/>
</e:if>
<e:if condition="${xsavedmode=='1'}">
	<e:q4l var="state" sql="xbuilder.reportManager.reportStateListWithXSaveMode"/>
</e:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<a:base />
		<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources>
		<e:set var="userId">${sessionScope.UserInfo.USER_ID}</e:set>
		<title></title>
		<link rel="stylesheet" href="<e:url value="/pages/xbuilder/resources/component/gridster/jquery.gridster.min.css"/>"/>
		<link rel="stylesheet" href="<e:url value="/pages/xbuilder/resources/component/gridster/style.css"/>"/>
	    <e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/resources/themes/blue/boncBlue.css"/>
		<e:style value="/pages/xbuilder/resources/component/jqueryui/themes/base/jquery.ui.selectable.css"/>
	    <e:style value="/pages/xbuilder/resources/component/icheck/icheck.css"/>
		<script type="text/javascript">
			$(window).resize(function(){
			 	$('#reportTable').datagrid('resize');
			 });
			function doQuery(){
				var info = {};
				info.report_name = $("#report_name").val();
				info.report_id = $("#report_id").val();
				info.creator_name = $("#creator_name").val();
				info.create_date = $('#create_date').datebox('getValue');
				info.reportState = $("#state").val();
				$('#reportTable').datagrid('load',info);
				
								
			}
			function doQueryUser(){
				var info = {};
				info.userName = $("#userName").val();
				//$("#userTable").datagrid("options").queryParams=info;
				$("#userTable").datagrid("load",info);
			}
			function reportCZ(value,rowData){
				var state = rowData.INFACT_STATE;
				var rname = encodeURIComponent(encodeURIComponent(rowData.REPORT_NAME));
				var res = '';
				var read = '<a href="javascript:void(0)"class="moreLiulan" title="浏览" style="margin:0 5px;" onclick="showNotBlowseInfo()">浏览</a>' ;
				if(parseInt(state)<4&&parseInt(state)>0){
					read='<a href="javascript:void(0);" class="moreLiulan" title="浏览" style="margin:0 5px;" onclick="toReport(\''+rowData.URL+'\')">浏览</a>';
				}
				
				var upd =  '<a href="javascript:void(0);" class="moreBianji" title="编辑" style="margin:0 5px;" onclick="updReport(\''+rowData.REPORT_ID+'\',\''+state+'\')">编辑</a>';
				var copy = '<a href="javascript:void(0);" class="moreFuzhi" title="复制" style="margin:0 5px;" onclick="copyReport(\''+rowData.REPORT_ID+'\')">复制</a>';
				var pub =   '<a href="javascript:void(0)"class="moreShangjia" title="上架" style="margin:0 5px;" onclick="showNotPushInfo()">上架</a>' ;
				if(parseInt(state)<4&&parseInt(state)>0){
					pub =   '<a href="javascript:void(0);" class="moreShangjia" title="上架" style="margin:0 5px;" onclick="sendReport(\''+rowData.URL+'\',\''+rowData.REPORT_NAME+'\',\''+rowData.REPORT_ID+'\')">上架</a>';
				}
				var authorization='';
				/*授权*/
				var authorization='<a href="javascript:void(0)"class="moreXiajia" title="授权" style="margin:0 5px;" onclick="showNotAuthorizationInfo()">授权</a>';
				if(parseInt(state)==1){
					authorization = '<a href="javascript:void(0);" class="moreXiajia" title="授权" style="margin:0 5px;" onclick="formAuthorization(\''+rowData.REPORT_ID+'\')">授权</a>';
				}
				
				var stop = '<a href="javascript:void(0)"class="moreXiajia" title="下架" style="margin:0 5px;" onclick="showNotStopInfo()">下架</a>' ;
				if(parseInt(state)==1){
					stop = '<a href="javascript:void(0);" class="moreXiajia" title="下架" style="margin:0 5px;" onclick="stopUseReport(\''+rowData.REPORT_ID+'\')">下架</a>';
				}
				
				var exp =   '<a href="javascript:void(0)"class="moreDaochu" title="导出" style="margin:0 5px;" onclick="showNotExportInfo()">导出</a>' ;
				if(parseInt(state)<4&&parseInt(state)>0){
					exp =   '<a href="javascript:void(0);" class="moreDaochu" title="导出" style="margin:0 5px;" onclick="exportZip(\''+rname+'\',\''+rowData.URL+'\')">导出</a>';
				}
				var del =   '<a href="javascript:void(0);" class="moreShanchu" title="删除" style="margin:0 5px;" onclick="delReport(\''+rowData.REPORT_ID+'\')">删除</a>';
				var userId = '${userId}';
				/*
				 暂时去掉如果当前用户不是报表的开发用户，需求审批功能
				
				if(userId != rowData.CREATE_USER){
					del = '<a href="javascript:void(0)" class="btn-submit2" disabled="disabled">删除</a>';
					upd = '<a href="javascript:void(0);" class="btn-submit1" onclick="examin(\''+rowData.REPORT_ID+'\',\''+rowData.REPORT_NAME+'\',\''+rowData.CREATE_USER+'\',\''+rowData.OLD_STATE+'\');")">编辑</a>';
				}
				*/
				var des =   '<a href="javascript:void(0);" class="moreMiaoshu" title="描述" style="margin:0 5px;" onclick="desReport(\''+rowData.REPORT_ID+'\',\''+rowData.REPORT_NAME+'\')">描述</a>';
				var file =  '<a href="javascript:void(0);" class="moreWendang" title="附件" style="margin:0 5px;" onclick="operateFile(\''+rowData.REPORT_ID+'\')">附件</a>';
				
				var more = '<a id="more_'+rowData.REPORT_ID+'" href="javascript:void(0)" style="margin:0 5px;" class="easyui-tooltip">更多' +
							'<div style="display:none"><div class="moreBtn" id="toolbarM_'+rowData.REPORT_ID+'">' +
								read+
								copy+
								stop+
								exp+
								del+
								des+
							'</div></div></a>';
				
				state = rowData.OLD_STATE;
				if(parseInt(state)==4){
					var edit = '<a href="javascript:void(0);" class="moreBianji" title="编辑" style="margin:0 5px;" onclick="updReport(\''+rowData.REPORT_ID+'\',\'0\')">编辑</a>';
					if(userId != rowData.CREATE_USER){
						edit = '<a href="javascript:void(0);" class="moreBianji" title="编辑" style="margin:0 5px;" onclick="examin(\''+rowData.REPORT_ID+'\',\''+rowData.REPORT_NAME+'\',\''+rowData.CREATE_USER+'\',\''+rowData.OLD_STATE+'\');")">编辑</a>';
					}
					var read = '<a href="javascript:void(0)" class="moreLiulan" title="浏览" style="margin:0 5px;" disabled="disabled">浏览</a>';
					var pub = '<a href="javascript:void(0)" class="moreShangjia" title="上架" style="margin:0 5px;" disabled="disabled">上架</a>';
					var stop = '<a href="javascript:void(0)" class="moreXiajia" title="下架" style="margin:0 5px;" disabled="disabled">下架</a>';
					var exp = '<a href="javascript:void(0)" class="moreDaochu" title="导出" style="margin:0 5px;" disabled="disabled">导出</a>';
					var more = '<a id="more_'+rowData.REPORT_ID+'" href="javascript:void(0)" style="margin:0 5px;" class="easyui-tooltip">更多' +
							'<div style="display:none"><div class="moreBtn" id="toolbarM_'+rowData.REPORT_ID+'">' +
								read+
								copy+
								stop+
								exp+
								del+
								des+
							'</div></div></a>';
					res = edit+pub+authorization+file+more;
				}else{
					res = upd+pub+authorization+file+more;
				}
				return  res;
			}
			
			function showNotBlowseInfo(){
				$.messager.alert("提示信息","<br/>报表状态不是发布，不允许浏览！",'info');
			}
			function showNotPushInfo(){
				$.messager.alert("提示信息","<br/>报表状态不是发布，不允许上架！",'info');
			}
			function showNotStopInfo(){
				$.messager.alert("提示信息","<br/>报表状态不是上架，不允许下架！",'info');
			}
			function showNotExportInfo(){
				$.messager.alert("提示信息","<br/>报表状态不是发布，不允许导出！",'info');
			}
			
			/*下面两个方法showNotAuthorizationInfo()；formAuthorization(formID)，都是授权所用*/
			function showNotAuthorizationInfo(){
				$.messager.alert("提示信息","<br/>未上架，不允许授权！",'info');
			}
			function formAuthorization(formID){
				$("#formRoleA").dialog('open');
				$('#roleAwin').load('<e:url value="/pages/xbuilder/pagemanager/menuRolesTree.jsp"/>',{formID:formID},function (data){});
			}
			
			function exportZip(rname,rpath){
				$.post(appBase+'/reportExport/exists.e?rname='+rname+'&rpath='+rpath,function(data){
					if(data=='0'){
						$.messager.alert("提示信息","<br/>导出错误，文件不存在！",'error');
						return false;
					}
					window.location.href = appBase+'/reportExport/zip.e?rname='+rname+'&rpath='+rpath;
				});
			}
			function toReport(url){
				window.open(appBase+"/"+url);
			}
			function updReport(reportId,state){
				if(state=='1'||state=='2'||state=='3'){
					var stateName='';
					if(state=='1'){
						stateName='上架';
					}else if(state=='2'){
						stateName='下架';
					}else if(state=='3'){
						stateName='发布';
					}
					$.messager.confirm("提示信息", "该报表为"+stateName+"状态，是否继续编辑？", function (r) {  
			            if(r){
			            	var lw = screen.width-10;
							window.open(appBase+'/xLiEdit.e?xid='+reportId+'&slw='+lw);//修改在新窗口中打开
							window.returnValue=false;
			            }else {  
			                return false;
			            }  
		       	 	});  
				}else{
					var lw = screen.width-10;
					window.open(appBase+'/xLiEdit.e?xid='+reportId+'&slw='+lw);//修改在新窗口中打开
					window.returnValue=false;
				}
			}
			
			function copyReport(reportId){
				var lw = screen.width-10;
				window.open(appBase+'/copyReport.e?xid='+reportId+'&slw='+lw);//修改在新窗口中打开
				window.returnValue=false;
			}
			function addReport(){
				$("#report_menu_load").load(appBase+"/pages/xbuilder/pagemanager/add.jsp",function(){
					$(this).dialog({title: '',height:416,width:725,modal:true});
					$(this).dialog();
				});
			}
			/*点击新建就跳转到自定义sql的设计界面，20160225*/
			function toSql(){
				window.open(appBase+'/pages/xbuilder/pagedesigner/XBuilder.jsp?dsType=1&lw='+(screen.width-10));
				window.returnValue=false;
			}
			
			function showReport(){
				$("#report_tree_dialog").dialog("open");
			}
			function sendReport(url,name,reportId){
				$("#cur_name").val(name);
				$("#cur_url").val(url);
				$("#cur_id").val(reportId);
				$("#report_tree_dialog").dialog("open");
			}
			function dblClick(node){
				var info = {};
				var res_name = $("#cur_name").val();
				var rep_id = $("#cur_id").val();
				info.resources_name=res_name;
				info.url=$("#cur_url").val();
				info.parent_id=node.id;
				info.eaction='SAVE';
				info.report_id = rep_id;
				if($("#cur_name").val()=='')
					return;
				$.post(appBase+"/pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=CURREPORT",{resources_name:res_name,parent_id:node.id,report_id:rep_id},function(data){
					if(parseInt($.trim(data))==0){
						$.messager.confirm('确认信息','确定要上架到当前菜单下?',function(r){  
						    if (r){  
						        $.post(appBase+"/pages/xbuilder/pagemanager/ReportActionAccount.jsp",info,function(data){
									if(parseInt($.trim(data))>0){
										$.messager.alert("提示信息","已经成功上架到菜单："+node.text+"下。","info");
										root_index=0;
										$("#report_tree").tree("reload");
										$("#reportTable").datagrid("load",$("#reportTable").datagrid("options").queryParams);
										$("#report_tree_dialog").dialog("close");
										$("#cur_name").val('');
										$("#cur_url").val('');
										$("#cur_id").val('');
									}else{
										$.messager.alert("提示信息","上架失败，请稍候联系管理员。","error");
									}
								});
						    }
						});
					}else{
						$.messager.alert("提示信息","该报表已经在此菜单下上架","info");
					}
				});
			}
			function closeDialog(){
				$("#cur_name").val('');
				$("#cur_url").val('');
				$("#cur_id").val('');
			}
			function toggleTree(node){
				var treeOnlyExpandOneNode='${treeOnlyExpandOneNode}';
   				if(treeOnlyExpandOneNode!='0'){
					var root =  $('#report_tree').tree('getParent',node.target);
					if(root != null){
						var nodes = $('#report_tree').tree('getChildren',root.target);
						for(var i=0;i<nodes.length;i++){
							if(nodes[i].state=='open' && nodes[i].id!=node.id)
								$('#report_tree').tree('collapse',nodes[i].target);
						}
					}
				}
			}
			var root_index=0;
			function extendRoot(node,data){
				if(root_index==0){
					var root = $('#report_tree').tree('getRoot');
					$('#report_tree').tree('expand',root.target);
					root_index++;
				}
			}
			function sendDetail(value,rowData){
				if(value>0){
					return '<a href="javascript:void(0);" style="text-decoration: none;margin:0 5px;" onclick="showMenuDetail(\''+rowData.REPORT_ID+'\',\''+rowData.REPORT_NAME+'\')">'+value+'</a>';
				}else{
					return value;
				}
			}
			function showMenuDetail(reportId,reportName){
				var info = {};
				info.report_id=reportId;
				info.report_name=reportName;
				$("#report_menu_dialog").dialog("open");
				$("#report_menu_load").load(appBase+"/pages/ebuilder/pagemanager/ReportMenuShow.jsp",info,function(data){});
			}
			
			function delReport(id){
				$.messager.confirm('确认信息','删除报表将删除报表的相关信息，确定删除吗?',function(r){  
					if(r){
						$.post(appBase+"/pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=DELETEALLRP",{report_id:id},function(data){
							if(parseInt($.trim(data))>0){
								$.messager.alert("提示信息","删除成功","info");
								$("#reportTable").datagrid("load",$("#reportTable").datagrid("options").queryParams);
							}else{
								$.messager.alert("提示信息","删除失败","error");
							}
						});
					}
				});
			}
			
			$(function(){
				$('#reportDescForm').form({  
					url:appBase+"/pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=INSERTREPORT",
				    onSubmit: function(){  
				        return $(this).form('validate');
				    },
				    success:function(data){  
				    	$("#report_id").val("");
				        var temp = $.trim(data);
						if(temp>0) {
							$.messager.alert("信息","报表描述保存成功！","info");
							$("#reportDescDialog").dialog("close");
							$('#reportTable').datagrid("load",$("#reportTable").datagrid("options").queryParams);
						} else {
							$.messager.alert("信息","报表描述保存过程中出现错误，请联系管理员！","info");
						}
					}
				});
		
				//描述弹出框
				$("#reportDescDialog").dialog({
					width:400,
					height:310,
					modal:true,
					closed:true,
					top:90,
					buttons:[{
						text:'提交',
						handler:saveReport
					}]
				});
				
				//用户信息弹出框
				$("#userInfoDialog").dialog({
					width:450,
					height:415,
					modal:true,
					closed:true,
					top:20,
					buttons:[{
						text:'确认',
						handler:saveUser
					}]
				});
				//报表编辑申核
				$("#examination").dialog({
					width:350,
					height:350,
					modal:true,
					closed:true,
					top:20,
					buttons:[{
						text:'确认',
						handler:examinsubmit
					}]
				});
		
				 $("#depTreeDialog").dialog({
				 	width:400,
					height:400,
					modal:true,
					closed:true,
					top:20
					 });
				}); 
				
			function desReport(Id,reportName){
				var info = {};
				info.report_id=Id;
				info.eaction="REPORTLOAD";
				$("#reportDescDialog").dialog("open");
				$("#report_id").val(Id);
				$("#words").val(reportName);
				var postUrl=appBase+"/pages/xbuilder/pagemanager/ReportActionAccount.jsp";
				$.post(postUrl,info,function(data){
					console.log(data);
					if($.trim(data)!=''){
						$("#reportDescForm").form("load",data[0]);
					}else{
						$("#user_id").val("");
						$("#user_name").val("");
						$("#department_desc").val("");
						$("#department_code").val("");
						$("#report_desc").val("");
						$("#report_id").val(Id);
					}
				},"json");
			}
			
			//文档操作
			function operateFile(reportId){
				CURRENT_REPORT_ID = reportId;
				var info = {};
				info.reportId = reportId;
				//$("#fileListTable").datagrid("options").queryParams=info;
				$("#fileListTable").datagrid("load",info);
			
				$('#reportId').val(reportId);
				$('#fileDiv').dialog('open');
			}
			
			//报表描述提交按钮事件
			function saveReport(){
				$("#reportDescForm").submit();
			}
			
			//用户信息确认按钮事件
			function saveUser(){
				var selected = $('#userTable').datagrid('getSelected');
				if(selected==null){
					$.messager.alert("信息","请选择一个用户！","info");
				}else{
					$("#user_id").val(selected.USER_ID);
					$("#user_name").val(selected.USER_NAME);
					$("#userInfoDialog").dialog('close');
				}
			}
				
			function getUserName(){
				$("#userInfoDialog").dialog('open');
				$("#user_name").blur();
				$("#userName").val("");
				//$("#userTable").datagrid("options").queryParams=$("#userName").val();
				$('#userTable').datagrid("load",$("#userTable").datagrid("options").queryParams);
			}
			
			function getDepName(){
				 $("#depTreeDialog").dialog('open');
			}
				
			function slectDep(node){
				$("#department_code").val(node.id);
				$("#department_desc").val(node.text);
				$("#depTreeDialog").dialog('close');
			}
			var CURRENT_REPORT_ID = '';		
			$(function(){
				$('#fileDiv').dialog({
					width : '600',
					height : '400',
					title:"文档操作",
					closed: true,
					modal: true
				});
			
				$('#fileForm').form({
					url:appBase+'/pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=addFile',
					success:function(data){
						//$('#fileDiv').dialog('close');
						var info = {};
						info.reportId = CURRENT_REPORT_ID;
						//$("#fileListTable").datagrid("options").queryParams=info;
						$("#fileListTable").datagrid("load",info);
				     	if(data == 1){
			    			$('#fileForm')[0].reset()
			    		}else{
							$.messager.alert('提示信息', '上传失败', 'error');
			    		}
					}
				});
			});		
			function subFileUpload(){
				$('#fileForm').submit();
			}
			function formatOpt(value,rowData){
			   	var content='<a class="easyui-linkbutton" href="javascript:void(0);" onclick="downloadFile(\''+rowData.FILE_PATH+'\',\''+rowData.FILE_NAME+'\');">下载</a>';
			   	content+='&nbsp;<a class="easyui-linkbutton" href="javascript:void(0);" onclick="deleteFile(\''+rowData.FILE_PATH+'\');">删除</a>'
			   	return content;
			}
			function downloadFile(filePath,fileName){
				//var url = '<e:url value="'+filePath.substring(1,filePath.length)+'"/>';
				//window.open(url,'_ablank');
				
				window.location.href = appBase+'/reportExport/downloadFile.e?rpath='+filePath+'&rname='+fileName;
			}
			function deleteFile(filePath){
				$.messager.confirm('确认信息','确定删除?',function(r){  
				    if (r){  
				        $.post(appBase+"/pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=deleteFile",{filePath:filePath},function(data){
							if(data==1){
								var info = {};
								info.reportId = CURRENT_REPORT_ID;
								//$("#fileListTable").datagrid("options").queryParams=info;
								$("#fileListTable").datagrid("load",info);
							} else {
								$.messager.alert('提示信息', '删除失败', 'error');
							}
						});
				    }
				});
			}
		
			function stopUseReport(id){
		  		$.messager.confirm('确认信息','下架报表后将无法访问，只有重新上架后才可以访问，确定下架吗?',function(r){  
					if(r){
						$.post(appBase+"/pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=stopUseReport",{report_id:id},function(data){
							if(parseInt($.trim(data))>0){
								$("#reportTable").datagrid("load",$("#reportTable").datagrid("options").queryParams);
								$.messager.alert("提示信息","下架成功","info");
							}else{
								$.messager.alert("提示信息","下架失败","error");
							}
						});
					}
				});
		  	}
		  	function examin(reportId,reportName,user,reportstate){
		  		var info = {};
		  		info.reportId = reportId;
		  		info.reportName = reportName;
		  		info.user = user;
		  		$.post(appBase+"/pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=checkexamin",info,function(data){
					if($.trim(data) == 'N'){
						$('#exreportid').val(reportId);
				  		$('#exreportname').val(reportName);
				  		$('#exreportuser').val(user);
				  		$("#examination").dialog("open");
					}else{
						if(reportstate == '4'){
		  	    			updReport(reportId,'0');
		  	    		}else{
		  	    			updReport(reportId,'1');
		  	    		}
					}
				});
		  	}
		  	function examinsubmit(){
		  		var info = {};
		  		info.exreportid = $('#exreportid').val();
		  		info.exreportname = $('#exreportname').val();
		  		info.creator = $('#exreportuser').val();
		  		info.examcon = $('#examcon').val();
		  		info.eaction = 'examin';
		  		$.post(appBase+"/pages/xbuilder/pagemanager/ReportActionAccount.jsp",info,function(data){
					if(parseInt($.trim(data))>0){
						$.messager.alert("提示信息","申请成功","info");
						$("#examination").dialog("close");
					}else{
						$.messager.alert("提示信息","申请失败","error");
					}
				});
		  	}
		  	//加载成功时加载更多
		  	function showMore(data){
		  		$.each(data.rows,function(i,v){
		  			$('#more_'+v.REPORT_ID).tooltip({
		  				deltaY:-12,
		  				deltaX:-10,
						content: function(){
							return $('#toolbarM_'+v.REPORT_ID);
						},
						onUpdate: function(content){
							content.panel({
								width: 156,
								border: false
							});
						},
						onShow: function(){
							var t = $(this);
							t.tooltip('tip').unbind().bind('mouseenter', function(){
								t.tooltip('show');
							}).bind('mouseleave', function(){
								t.tooltip('hide');
							});
						}
			  		});
		  		});
			  	$.parser.parse();
			 }
			 //双击浏览报表
			 function toShowReport(rowIndex, rowData){
			 	var state = rowData.INFACT_STATE;
				if(parseInt(state)<4&&parseInt(state)>0){
					var url = rowData.URL;
					window.open(appBase+"/"+url,"newwindow");
				}else{
					$.messager.alert("提示信息","<br/>报表状态不是发布，不允许浏览！",'info');
				}
			 }
	</script>
	</head>
	<body>
		<div id="tbar" class="unBorder" >
			<h2>报表管理</h2>
			<div class="search-area">
				报表名称： <input type="text" style="width: 100px" id="report_name" name="report_name" />
				创建人： <input type="text" style="width: 100px" id="creator_name" name="creator_name">
				状态  ： <e:select items="${state.list}" style="width: 100px" label="code_desc" value="code" name="state" id="state" class="easyui-validatebox" required="true" defaultValue="${param.state}" />
				创建时间：  <c:datebox id="create_date" style="width:100px" name="create_date" required="false" format="yyyymmdd"/>
				<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doQuery()">查询</a>
				<a href="javascript:void(0);" class="easyui-linkbutton easyui-linkbutton-green" onclick="addReport()">新增</a>
			</div>
		</div>
		<c:datagrid
			url="pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=LIST" fit="true"
			id="reportTable" pageSize="15" style="width:auto;display:none;" onLoadSuccess="showMore" onDblClickRow="toShowReport"
			download="true" nowrap="false" border="false" remoteSort="true" toolbar="#tbar">
			<thead frozen="true">
				<tr>
					<th field="REPORT_NAME"  width="190"  align="center" sortable="true">
						报表名称
					</th>
				</tr>
			</thead>
			<thead>
				<tr>
					<th field="STATE" width="40" align="center" sortable="true">
						报表状态
					</th>
					<th field="CREATOR_NAME" width="60" align="center" sortable="true">
						创建人
					</th>
					<th field="CREATE_DATE" width="90" align="center" sortable="true" formatter="formatDAT_reportTable">
						创建时间
					</th>
					<th field="PUBLISH_USERNAME" width="60" align="center" sortable="true">
						上架人
					</th>
					<th field="PUBLISH_DATE" width="90" align="center" sortable="true" formatter="formatDAT_reportTable">
						最后上架时间
					</th>
					<th field="MENU_NAME" width="120" align="center" sortable="true">
						附加信息
					</th>
					<th field="cz" width="145" align="center" formatter="reportCZ">
						操作
					</th>
				</tr>
			</thead>
		</c:datagrid>
		<div class="easyui-dialog" id="report_tree_dialog"
			title="上架到菜单(双击菜单上架)"
			data-options="closed:true,top:30,modal:true,onClose:closeDialog"
			style="width: 330px; height: 380px; padding: 5px;">
			<input type="hidden" id="cur_name" name="cur_name">
			<input type="hidden" id="cur_url" name="cur_url">
			<input type="hidden" id="cur_id" name="cur_id">
			<a:tree id="report_tree"
				url="pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=RTREE"
				onLoadSuccess="extendRoot" onDblClick="dblClick"
				onExpand="toggleTree" />
		</div>
		<div class="easyui-dialog" id="report_menu_dialog" title="上架菜单信息"
			data-options="iconCls:'icon-save',closed:true,top:30,modal:true,onClose:closeDialog"
			style="width: 230px; height: 330px;">
			<div id="report_menu_load"></div>
		</div>

		<div id="reportDescDialog" title="报表描述">
			<form action="" method="post" id="reportDescForm">
				<table width="100%" class="windowsTable">
					<colgroup>
						<col width="25%">
						<col width="*">
					</colgroup>
					<tr>
						<th>
							报表提出人：
						</th>
						<td>
							<input type="hidden" name="user_id" id="user_id">
							<input type="text" style="width: 90%" name="user_name"
								id="user_name" onclick="getUserName()">
						</td>
					</tr>
					<tr>
						<th>
							报表提出部门：
						</th>
						<td>
							<input type="hidden" name="department_code" id="department_code">
							<input type="text" style="width: 90%" name="department_desc"
								id="department_desc" onclick="getDepName()">
						</td>
					</tr>
					<tr>
						<th>
							报表描述： 
						</th>
						<td>
							<textarea style="width: 91%; height: 100px;" id="report_desc" name="report_desc"></textarea>
						</td>
					</tr>
					<input type="hidden" name="report_id" id="report_id">
					<input type="hidden" name="words" id="words">
				</table>
			</form>
		</div>

		<div id="userInfoDialog" title="用户信息">
			<form action="" method="post" id="userInfoForm">
				<div id="tbaru">
					<table>
						<tr>
							<td>
								用户名称：
								<input type="text" id="userName" name="userName">
							</td>
							<td>
								<a href="javascript:void(0);" class="easyui-linkbutton"
									onclick="doQueryUser()">查询</a>
							</td>
						</tr>
					</table>
				</div>
				<c:datagrid
					url="/pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=USERLIST"
					id="userTable" singleSelect="true" toolbar="#tbaru">
					<thead>
						<tr>
							<th field="ck" checkbox="true"></th>
							<th field="USER_ID" width="100">
								用户ID
							</th>
							<th field="USER_NAME" width="100">
								用户名称
							</th>
						</tr>
					</thead>
				</c:datagrid>
			</form>
		</div>
		<!-- 文档操作 -->
		<div id="fileDiv">
			<form id="fileForm" name="fileForm" method="post" enctype="multipart/form-data">
				<div class="contents-head">
					<h2>选择上传文档：</h2>
					<div class="search-area">
						<input type="hidden" id="reportId" name="reportId">
						<input type="file" id="uploadFile" name="uploadFile" size="240" style="width: 240px;">
						<a href="javascript:void(0)" onclick="subFileUpload()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">提交</a>
					</div>
				</div>
			</form>
			<c:datagrid id="fileListTable" url="/pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=fileList" pageSize="100" style="height:290px;"  nowrap="false" pagination="false">
				<thead>
					<tr>
						<th field="FILE_NAME" width="60" align="center">
							文档名称
						</th>
						<th field="CREATE_TIME" width="20" align="center">
							上传时间
						</th>
						<th field="USER_ID" width="15" align="center">
							上传人
						</th>
						<th field="opt" width="10" align="center" formatter="formatOpt">
							操作
						</th>
					</tr>
				</thead>
			</c:datagrid>
		</div>
		
		
		<div id="depTreeDialog" title="局方部门">
			<a:tree id="depTree"
				url="pages/xbuilder/pagemanager/ReportActionAccount.jsp?eaction=DEPTREE"
				onSelect="slectDep" />
		</div>
		<!-- 审核 -->
		<div id="examination" title="报表申请编辑">
			<table border=0>
				<tr>
					<td colspan="2" style="height:1;background-color:#E8E8E9;"></td>
				</tr>
				<tr>
					<td align="right">
						报表ID:
					</td>
					<td align="left">
						<input id="exreportid" name="exreportid" value="" readonly="true"
							style="width: 120px; border: 0; border-bottom: 1 solid black; background: ;" />
					</td>
				</tr>
				<tr>
					<td colspan="2" style="height:1;background-color:#E8E8E9;"></td>
				</tr>
				<tr>
					<td align="right">
						报表名称:
					</td>
					<td align="left">
						<input id="exreportname" name="exreportname" value="" readonly="true"
							style="width: 120px; border: 0; border-bottom: 1 solid black; background: ;" />
						<input id="exreportuser" type="hidden" name="exreportuser" value=""/>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="height:1;background-color:#E8E8E9;"></td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						修改内容：
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<textarea id="examcon" name="examcon" rows="8" cols="30"></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="height:1;background-color:#E8E8E9;"></td>
				</tr>
				<tr>
					<td colspan="2">
						<font color="red">&nbsp;&nbsp;&nbsp;&nbsp;提示:由于本报表不是您本人创建，若要编辑，请向创建人申请编辑!请填写上面的修改内容。</font>
					</td>
				</tr>
			</table>
		</div>
		
		<div class="easyui-dialog" id="formRoleA" title="角色授权"
			data-options="iconCls:'icon-save',closed:true,top:30,modal:true,onClose:closeDialog"
			style="width: 530px; height: 330px;">
			<div id="roleAwin"></div>
		</div>
	</body>
</html>