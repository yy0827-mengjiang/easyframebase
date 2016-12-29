<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:set var="cube_code" value="${param.cube_code}"></e:set>
<e:q4o var="cubeDetail" sql="kpi.view.cubeDetail"/>
<e:q4l var="formulaType" sql="kpi.view.formulaType"/>
<e:q4l var="classNum" sql="kpi.view.classNum"/>
<e:q4o var="classCount" sql="kpi.view.classCount"/>
<e:q4o var="typeInfo" sql="kpi.view.typeInfo"/>
<e:q4l var="formulaSub" sql="kpi.basekpi.formulaSub"/>
<e:q4l var="unit" sql="kpi.view.unit"/> 
<e:q4l var="kpiType" sql="kpi.view.kpiType"/> 
<e:q4l var="serviceType" sql="kpi.view.serviceType"/> 
<e:q4l var="classification" sql="kpi.view.classification"/> 
<e:q4l var="cycle" sql="kpi.view.cycle"/> 
<e:q4l var="reservedAttr" sql="kpi.view.reservedAttr"/> 
<e:q4o var="baseKpiInfo" sql="kpi.basekpi.baseKpiInfo"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>基础指标</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
	<e:style value="/pages/xbuilder/resources/component/icheck/icheck.css"/>
	<e:script value="/pages/xbuilder/resources/component/icheck/icheck.min.js"/>
    <script type="text/javascript">
        $(function () {
  		  $('input.checkN').iCheck({
        	    labelHover : false,
        	    cursor : true,
        	    checkboxClass : 'icheckbox_square-blue',
        	    radioClass : 'iradio_square-blue',
        	    increaseArea : '20%'
            }).on('ifClicked', function(event){
        	});
        	setServiceCode('${e:java2json(classNum.list)}','${e:java2json(formulaType.list)}','${e:java2json(formulaSub.list)}');
            $("#baseKpiForm").form({
                url:'<e:url value="/draftBaseKpi.e?cube_code=${cube_code}"/>',
                success:function(data){
                   var data = eval('(' + data + ')');
                   if(data.success > 0){
                       if(data.action=="insert"){
                           $.messager.alert("提示信息","添加基础指标成功!","info",function() {
                        	   //window.location.href='<e:url value="/pages/kpi/kpiManager/baseManager.jsp"/>?account_type=${param.account_type}';
		       				   $("#kpi").html('');
		         			   $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube=${cube_code}');
                        	   $('#tt').tree('reload',$('#tt').tree('getParent', current_node.target).target);
                           });
                       } else{
                           $.messager.alert("提示信息","编辑基础指标成功!","info",function() {
                        	   $("#kpi").html('');
                 			   $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube=${cube_code}');
                        	   $('#tt').tree('reload',$('#tt').tree('getParent', current_node.target).target);
                        	   //window.location.href='<e:url value="/pages/kpi/kpiManager/newKpiManager.jsp"/>?account_type=${param.account_type}';
                           });
                       }
                   }else{
                       if(data.action=="insert"){
                           $.messager.alert("提示信息","添加基础指标失败!","info");
                       } 
                       else{
                           $.messager.alert("提示信息","编辑基础指标失败!","info");
                       }
                   }
                }
            });
            if('${action}'=="update"){
                $(":button[name='draft']").html("保存");
                $(":button[name='version']").hide();
            }
            if('${action}'=="insert"){
                $(":button[name='version']").hide();
            }
            //var kpiUnit=$.parseJSON('${kpiInfo.kpiUnit}');
            var baseKpi= $.parseJSON('${kpiInfo.baseKpi}'.replace(/\r\n/g,'').replace(/\t/g,''));
//             var eds= $.parseJSON('${kpiInfo.eds}');
//             var kpiUnitHtml=[];
           // for(var i=0;i<kpiUnit.length;i++){
                //kpiUnitHtml.push('<option value="',kpiUnit[i].id,'"',kpiUnit[i].id==baseKpi.kpi_unit?" selected>":">" ,kpiUnit[i].text,'</option>');
           // }
           // $("[name='kpi_unit']").append(kpiUnitHtml.join(""));
//             var edsHtml=[];
//             for(var i=0;i<eds.length;i++){
//                 edsHtml.push('<option value="',eds[i].id,'"',eds[i].id==baseKpi.kpi_eds?" selected>":">" ,eds[i].text,'</option>');
//             }
//             $("[name='kpi_eds']").append(edsHtml.join(""));
            $("#baseKpiForm").form('load',baseKpi);
            if(baseKpi.kpi_eds == "") {
            	$("#kpi_eds").val("${cubeDetail.CUBE_DATASOURCE}");
            }
            if(baseKpi.account_type == "") {
            	$("#account_type").val("${cubeDetail.ACCOUNT_TYPE}");
            }
            if(baseKpi.kpi_condition != null && baseKpi.kpi_condition!="") {
                $("#kpi_condition_s").val(utf8to16(base64decode(baseKpi.kpi_condition)));
            }
            if(baseKpi.kpi_name !=null && baseKpi.kpi_name !="" && baseKpi.kpi_name !="null") {
            	$("#old_kpi_name").val(baseKpi.kpi_name);
            	$("#showTitle").html(baseKpi.kpi_name+"[V"+(baseKpi.kpi_version*1-1)+"]");
            }
            $(":button").click(function(){
                var $this=$(this);
                if($this.attr("name")=="close"){
      			    $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube=${cube_code}');
                    $("#kpi").html("");
                    return;
                }
//                 var validate=$("input[name='kpi_origin_stc']").val();
//                 if(validate==""||validate==null){
//                 	$.messager.alert("提示信息","请填写数据源信息!","info");
//                     return;
//                 }
                var kpi_condition = $("#kpi_condition_s").val();
                if(kpi_condition != null && kpi_condition !="") {
	                if(kpi_condition.toLowerCase().indexOf("where")!=0){
						$.messager.alert("提示信息！", "查询条件请以where开头，前面不要有空格!", "info");
						return;
					}
           		}
                var _kpiName = $("#kpi_name").val();
                if(_kpiName==null||_kpiName==""){
                	$.messager.alert("提示信息！", "指标名称不能为空!", "info");
					return;
                }
                var _kpiUnit = $("#kpi_unit").val();
                if(_kpiUnit==null||_kpiUnit==""){
                	$.messager.alert("提示信息！", "指标单位不能为空!", "info");
					return;
                }
                var _business = $("#kpi_explain").val();
                if(_business==""||null==_business){
            		$.messager.alert("提示信息！", "请输入业务口径 ！", "info");
            		return false;
            	}
                var _kpiOriginRegular = $("#kpi_origin_regular").val();
                if(_kpiOriginRegular==""||null==_kpiOriginRegular){
            		$.messager.alert("提示信息！", "请输入技术口径 ！", "info");
            		return false;
            	}
                var _kpiOriginStc = $("#kpi_origin_stc").val();
                if(_kpiOriginStc==null||_kpiOriginStc==""){
                	$.messager.alert("提示信息！", "取值字段不能为空!", "info");
					return;
                }
                var _dimAuthor = $("#kpi_proposer").val();
                if(_dimAuthor==""||null==_dimAuthor){
            		$.messager.alert("提示信息！", '请输入提出者 ！', "info");
            		return false;
            	}
                var _dimDept = $("#kpi_proposer_dept").val();
            	if(_dimDept==""||null==_dimDept){
            		$.messager.alert("提示信息！", '请输入提出部门！', "info");
            		return false;
            	}
                //var $this=$(this);
                var isPublish;
                if($this.attr("name")=="draft"){
                    isPublish=false;
                }
                else
                    isPublish=true;
                $("input[name='isPublish']").val(isPublish);
                var $form=$this.parents("form");

                $.messager.confirm('提示信息', '是否提交该指标信息?', function(r){
                    if (r){
                    	//$("#kpi_condition").val(base64encode(utf16to8($("#kpi_condition_s").val())));
                    	var _formKpiTypes = $("input[name=formKpiTypes]");
                    	var _formType = "";
                    	for(var i=0;i<_formKpiTypes.length;i++){
                    		if(_formKpiTypes[i].checked){
                    			if(_formType!=''&&_formType!=null){
                    				_formType = _formType + ",";
                    			}
                    			_formType = _formType + $(_formKpiTypes[i]).val();
                    		}
                    	}
                    	$("#formKpiSub").val(_formType);
                    	$("#baseKpiForm").submit();
                    }
                });
            });
            $("input[name='kpi_name']").blur(function(){
            	var value = $(this).val();
            	var old_value =$("#old_kpi_name").val();
            	if(value != old_value) {
            		$.ajax({
                        type:"post",
                        url:'<e:url value="/validateBaseKpiName.e"/>',
                        data:"kpi_name="+value+"&cube_code=${cubeDetail.CUBE_CODE}",
                        dataType:"json",
                        async: false,
                        success:function(data){
                            if(data.msg =="1"){
                            	$.messager.alert("提示信息","指标名称为:“"+ value+"”已经存在","info",function(){
                            		$("#kpi_name")[0].focus();
                            	});
                            } else if(data.msg != "0") {
                            	$.messager.alert("提示信息",data.msg,"info",function(){
                            		$("#kpi_name")[0].focus();
                            	});
                            } 
                        } 
                    }); 
                }
            });
            $("input[name='kpi_origin_stc']").blur(function(){
//                 var $eds=$("[name='kpi_eds']");
//                 var edsV=$eds.val();
//                 if(edsV==null||edsV==""){
//                 	$.messager.alert("提示信息","请选择数据源!","info");
//                     return;
//                     $eds.focus();
//                 }
                var value=$(this).val();
                var $that=$(this);
                var reg=/^[\w]+\.[\w]+\.[\w]+$/;
                if(reg.test(value)){
                    $.ajax({
                        type:"post",
                        url:'<e:url value="/validateSTC.e"/>',
                        data:"STC="+value+"&kpi_eds=${cubeDetail.CUBE_DATASOURCE}",
                        dataType:"json",
                        async: false,
                        success:function(data){
                            if(data.msg!="success"){
                            	$.messager.alert("提示信息",data.msg,"info",function(){
                            		$("#kpi_origin_stc")[0].focus();
                            	});
                            }
                        }
                    });
                }
                else
                	$.messager.alert("提示信息","请填写schame.table.column格式!","info");
            });
            //$(":hidden[name='baseType']").val('${type}');
            $('table select').on('change',selectCode);
            $('#kpi_explain').val("${baseKpiInfo.KPI_EXPLAIN }");
            $('#kpi_origin_regular').val("${baseKpiInfo.KPI_ORIGIN_REGULAR }");
            formatSql('kpi_explain');
            formatSql('kpi_origin_regular');
            
        });
        function selectCode(){
        	if($('#operation').val()=="update"){
				var _obj = parseInt($(this).attr("codeStart"));
				var _code = $(this).find("option:selected").val();
				var _name = $(this).attr("name");
				$('#' + _name + "Val").html('');
				$('#' + _name + "Val").html(_code);
				$('#' + _name).val(_code);
        	}else{
        		var _obj = parseInt($(this).attr("codeStart"));
    			var _code = $(this).find("option:selected").val();
    			var _name = $(this).attr("name");
    			$('#' + _name + "Val").html('');
    			$('#' + _name + "Val").html(_code);
        	}
		}
        function setServiceCode(data,value,sub){
        	 console.log(data);
        	 var _data = $.parseJSON(data);
        	 var _serviceCode =$.parseJSON('${serviceCode}');
        	 if($('#operation').val()=="update"){
        		 if(_serviceCode ==  null || _serviceCode =="") {
        			 $('#' +_data[0].CLASS_NAME).val('${param.serverClass}');
    	        	 for(var i=0;i<_data.length;i++){
    	        		 $('#' + _data[i].CLASS_NAME).val($('#' + _data[i].CLASS_NAME).find("option:selected").val());
    	        		 $('#' + _data[i].CLASS_NAME + "Val").html($('#' + _data[i].CLASS_NAME).find("option:selected").val());
    	        	 }
        		 } else {
        			 for(var i=0;i<_data.length;i++){
            			 $('#' + _data[i].CLASS_NAME + 'Val').html($(_serviceCode).attr(_data[i].CLASS_NAME));
//             			 $('#' +_data[i].CLASS_NAME).val($(_serviceCode).attr(_data[i].CLASS_NAME));
            			 $('#' +_data[i].CLASS_NAME).val($(_serviceCode).attr(_data[i].CLASS_NAME));

            		 }
            		 $('#codeId').val($(_serviceCode).attr("codeId"));
//             		 $("#acctType").html('');
//             		 var _value = $.parseJSON(value);
            		 var _sub = $.parseJSON(sub);
            		 $("input:checkbox[name='formKpiTypes']").each(function(index,item){
          				for(var k=0;k<_sub.length;k++){
          					if(_sub[k].ATTR_CODE==$(item).val()){
          						 $(item).iCheck('check'); 
          					}
          				}
            		 });
//             		 for(var i=0;i<_value.length;i++){
//          				for(var k=0;k<_sub.length;k++){
//          					if(_sub[k].ATTR_CODE==_value[i].ATTR_CODE){
//          						_value[i].ischeck = "1";
//          					}
//          				}
//          			}
//          			for(var i=0;i<_value.length;i++){
//          				if(_value[i].ischeck=='1'){
//          					$("#acctType").append("<input type='checkbox' name='formKpiTypes' value='" +_value[i].ATTR_CODE + "' checked='checked' class='checkN'>"+_value[i].ATTR_NAME);
//          				}else{
//          					$("#acctType").append("<input type='checkbox' name='formKpiTypes' value='" +_value[i].ATTR_CODE + "' class='checkN'>"+_value[i].ATTR_NAME);
//          				}
//          			}
        		 }
         	}else{
         		 $('#' +_data[0].CLASS_NAME).val('${param.serverClass}');
	        	 for(var i=0;i<_data.length;i++){
	        		 $('#' + _data[i].CLASS_NAME + "Val").html($('#' + _data[i].CLASS_NAME).find("option:selected").val());
	        	 }
         	}
        }
        $(function() {
			var wWidth = $(window).width();
			$(".tit_div1").width(wWidth-305);
		});
        function formatSql(name){
	    	$("#"+name).format({
	    		method: 'sql'
	    	});
	    }
    </script>
</head>

<body>
<input type="hidden" id="SEL_CUBE_CODE" name="SEL_CUBE_CODE" value="${cube_code}"/>
<input type="hidden" id="operFlag" name="operFlag" value="${param.operFlag}"/>
<div class="kpi_guide">
	<div class="tit_div1">
		<h3 id="showTitle">指标信息</h3>
		<span>
			 <button type="button" name="draft">提交版本</button>
            <button type="button" name="version">提交版本</button>
            <button type="button" name="close">关闭</button>
		</span>
	</div>
	<div class="editBase_div1">
    <form id="baseKpiForm" enctype="multipart/form-data" method="post">
        <input type="hidden" name="kpi_category" value="">
        <input type="hidden" id="kpi_eds" name="kpi_eds" value="${cubeDetail.CUBE_DATASOURCE}">
        <input type="hidden" id="kpi_version" name="kpi_version" value="">
        <input type="hidden" id="account_type" name="account_type" value="${cubeDetail.ACCOUNT_TYPE}">
        <input type="hidden" id="base_key" name="base_key" readonly="readonly" value="${sysCode}">
        <input type="hidden" name="formKpiSub" id="formKpiSub">
        <input type="hidden" name="old_kpi_name" id="old_kpi_name" value=""/>
        <input type="hidden" name="create_user_id" id="create_user_id" value="${UserInfo.USER_ID}"/>
        <input type="hidden" name="create_time" id="create_time" value=""/>
        
        <div class="editBase_div_child1">
        <e:if condition="${typeInfo.SERVER_VIEW=='1' }">
        <dl class="ddLine serviceCode">
			<dt>指标编码：</dt>
			<dd class="kpiTableArea">
			
				<div class="kpiTrTop">
					<e:forEach items="${classNum.list }" var="class">
						<span class="kpiCodeCol" id="${class.CLASS_NAME }Val" width="${100/classCount.C }%">
						</span>
					</e:forEach>
				</div>
			<table>
				<tr class="kpiTrBot">
				<e:if condition="${action eq 'insert' }" var="isUpdate">
					<e:forEach items="${classNum.list }" var="class" indexName="index">
						<td>
						<select id="${class.CLASS_NAME }"  codeStart="${index*2}" name="${class.CLASS_NAME }" style="width: 100%; height:26px;">
							<e:q4l var="kpiType">SELECT CODE AS "CODE",NAME AS "NAME" FROM X_KPI_CODE_TYPE WHERE TYPE='${class.ID }' 
							<e:if condition="${class.ID =='4' }">
						   		AND ACCOUNTYPE='${cubeDetail.ACCOUNT_TYPE }'
						    </e:if>
							ORDER BY ORD</e:q4l>
							<e:forEach items="${kpiType.list}" var="kt">
			                 	<option value ="${kt.CODE}">${kt.NAME}</option>	
			           		</e:forEach>	
						</select>
						</td>
					</e:forEach>
				</e:if>
				<e:else condition="${isUpdate }">
					<e:forEach items="${classNum.list }" var="class" indexName="index">
						<td>
<!-- 						<input type="hidden" name="${class.CLASS_NAME }" id="${class.CLASS_NAME }"> -->
						<select id="${class.CLASS_NAME }"  codeStart="${index*2}" name="${class.CLASS_NAME }" style="width: 100%; height:26px;">
							<e:q4l var="kpiType">SELECT CODE AS "CODE",NAME AS "NAME" FROM X_KPI_CODE_TYPE WHERE TYPE='${class.ID }' 
							<e:if condition="${class.ID =='4' }">
						   		AND ACCOUNTYPE='${cubeDetail.ACCOUNT_TYPE }'
						    </e:if>
							ORDER BY ORD</e:q4l>
							<e:forEach items="${kpiType.list}" var="kt">
			                 	<option value ="${kt.CODE}">${kt.NAME}</option>	
			           		</e:forEach>	
						</select>
						</td>
					</e:forEach>
				</e:else>
				</tr>
				</table>
				<input type="hidden" name="codeId" id="codeId" value="" readonly="readonly" style="width: 12%; height:26px;">
			</dd>
			</dl>
			</e:if>
            <dl class="fourD">
                <dt>指标名称：</dt>
                <dd><input type="text" name="kpi_name" id="kpi_name"><B style="color: red;">&nbsp;*</B></dd>
                <dt>指标单位：</dt>
                <dd>
                <select name="kpi_unit" id="kpi_unit" style="width: 95%">
                	<option value="">--请选择--</option>
                	<e:forEach items="${unit.list }" var="item">
                		<option value="${item.code }">${item.name }</option>
                	</e:forEach>
                </select><B style="color: red;">&nbsp;*</B>
            </dl>
			 <dl class="ddLine">
                <dt>业务口径：</dt>
                <dd><textarea name="kpi_explain" id="kpi_explain" onblur="formatSql('kpi_explain')"></textarea><B style="color: red;">&nbsp;*</B></dd>
            </dl>
             <dl class="ddLine">
                <dt>技术口径：</dt>
                <dd><textarea name="kpi_origin_regular" id="kpi_origin_regular" onblur="formatSql('kpi_origin_regular')">${baseKpiInfo.KPI_EXPLAIN }</textarea><B style="color: red;">&nbsp;*</B></dd>
            </dl>
              <div class="kpiDivider"></div>
             <dl class="ddLine serviceCode">
             	<dt>取值字段：</dt>
                <dd><input type="text" name="kpi_origin_stc" id="kpi_origin_stc"><B style="color: red;">&nbsp;*</B></dd>
            </dl>
            <e:if condition="${typeInfo.EXT_VIEW=='1' }">
			<dl class="ddLine">
				<dt>扩展属性：</dt>
				<dd>
					<div id="acctType">
		             	<e:forEach items="${formulaType.list}" var="fl" indexName="ind">
							<e:if condition="${fl.ATTR_CODE eq 'A'}" var="flag">
								<input type="checkbox" name="formKpiTypes" value="${fl.ATTR_CODE }" checked='checked' class="checkN">${fl.ATTR_NAME }
							</e:if>
							<e:else condition="${flag }">
								<input type="checkbox" name="formKpiTypes" value="${fl.ATTR_CODE }" class="checkN">${fl.ATTR_NAME }
							</e:else>
						</e:forEach>
	             	</div>
				</dd>
			</dl>
			</e:if>
            <dl class="fourD">
                <dt>提出人：</dt>
                <dd><input type="text" name="kpi_proposer" id="kpi_proposer"><B style="color: red;">&nbsp;*</B></dd>
                <dt>提出部门：</dt>
                <dd><input type="text" name="kpi_proposer_dept" id="kpi_proposer_dept"><B style="color: red;">&nbsp;*</B></dd>
            </dl>
            <dl class="ddLine">
                <dt>需求来源:</dt>
                <dd>
                 	<textarea rows="3" cols="10" id="kpi_origin_desc" name="kpi_origin_desc"></textarea><br>
                	<input type="file" name="upfile" class="file_none">
         		    <e:if condition="${fileName != null && fileName !=''}"><a href="javascript:void(0)" onclick="downLoadFile('${fileName}','${filePath}','./')">${fileName}</a></e:if>
                </dd>
                <dt>
                    <input type="hidden" value="${action}" name="operation" id="operation">
                    <input type="hidden"  name="baseType">
                    <input type="hidden" value="" name="isPublish">
                </dt>
                
            </dl>
        </div>
    </form>
</div>
</div>
</body>
</html>
