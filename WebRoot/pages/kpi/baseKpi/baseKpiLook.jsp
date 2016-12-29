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
    <title>${kpiName }</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="description" content="This is my page">
   	<e:if condition="${lookUpFlag ne '1'}">
	    <c:resources type="easyui,app"  style="${ThemeStyle }"/>
		<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
		<e:style value="/resources/easyResources/component/easyui/icon.css" />
		<e:style value="/resources/themes/base/boncBase@links.css"/>
		<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	</e:if>
    <script type="text/javascript">
        $(function () {
        	setServiceCode('${e:java2json(classNum.list)}','${e:java2json(formulaType.list)}','${e:java2json(formulaSub.list)}');
            var baseKpi= $.parseJSON('${kpiInfo.baseKpi}'.replace(/\r\n/g,'').replace(/\t/g,''));
//             $("#baseKpiForm").form('load',baseKpi);
            $("#showTitle").html(baseKpi.kpi_name+"[V"+baseKpi.kpi_version+"]");
		    $("#kpi_name").html(baseKpi.kpi_name);
		    $("#kpi_version").html(baseKpi.kpi_version);
		    $("#kpi_origin_stc").html(baseKpi.kpi_origin_stc);
		    $("#kpi_proposer").html(baseKpi.kpi_proposer);
		    $("#kpi_proposer_dept").html(baseKpi.kpi_proposer_dept);
		    $("#kpi_origin_desc").html(baseKpi.kpi_origin_desc);
			$("#kpi_unit").html(baseKpi.kpi_unit_name);
            if(baseKpi.kpi_eds == "") {
            	$("#kpi_eds").val("${cubeDetail.CUBE_DATASOURCE}");
            }
            if(baseKpi.account_type == "") {
            	$("#account_type").val("${cubeDetail.ACCOUNT_TYPE}");
            }
            if(baseKpi.kpi_condition != null && baseKpi.kpi_condition!="") {
                $("#kpi_condition_s").val(utf8to16(base64decode(baseKpi.kpi_condition)));
            }
            $(":button").click(function(){
                var $this=$(this);
                if($this.attr("name")=="close"){
      			    $("#kpi").load('<e:url value="/pages/kpi/kpiManager/kpiMain.jsp"/>?kpi_category=&cube=${cube_code}');
                    $("#kpi").html("");
                    return;
                }
            });
            $('select').on('change',selectCode);
            var browser_width = $(window).width(); 
			$('.tit_div1').css({'width':browser_width-20,'left':'10px' });
			$(window).resize(function() { 
					$('.tit_div1').css({'width':$(window).width()-20,'left':'10px' });
			});
			
			$("#kpi_explain").val("${baseKpiInfo.KPI_EXPLAIN}");
			
		    $("#kpi_origin_regular").val("${baseKpiInfo.KPI_ORIGIN_REGULAR}");
		    $("#kpi_explain").format({
	    		method: 'sql'
	    	});
		    $("#kpi_origin_regular").format({
	    		method: 'sql'
	    	});
        });
        function selectCode(){
			var _obj = parseInt($(this).attr("codeStart"));
			var _code = $(this).find("option:selected").val();
			var _name = $(this).attr("name");
			$('#' + _name + "Val").html('');
			$('#' + _name + "Val").html(_code);
		}
        function setServiceCode(data,value,sub){
        	 var _data = $.parseJSON(data);
        	 var _serviceCode =$.parseJSON('${serviceCode}');
        	 if($('#operation').val()=="update"){
        		 if(_serviceCode ==  null || _serviceCode =="") {
        			 $('#' +_data[0].CLASS_NAME).val('${param.serverClass}');
    	        	 for(var i=0;i<_data.length;i++){
    	        		 $('#' + _data[i].CLASS_NAME + "Val").html($('#' + _data[i].CLASS_NAME).find("option:selected").val());
    	        	 }
        		 } else {
        			 for(var i=0;i<_data.length;i++){
//             			 $('#' + _data[i].CLASS_NAME + 'Val').html($(_serviceCode).attr(_data[i].CLASS_NAME));
            			 $('#' +_data[i].CLASS_NAME).val($(_serviceCode).attr(_data[i].CLASS_NAME));
            			 $('#' + _data[i].CLASS_NAME + 'Val').html($(_serviceCode).attr(_data[i].CLASS_NAME) + " " +$('#' +_data[i].CLASS_NAME).find("option:selected").text());
//             			 $('#' +_data[i].CLASS_NAME +'_span').html($(_serviceCode).attr(_data[i].CLASS_NAME) + " " +$('#' +_data[i].CLASS_NAME).find("option:selected").text());
            		 }
            		 $('#codeId').val($(_serviceCode).attr("codeId"));
//             		 $("#acctType").html('');
//             		 var _value = $.parseJSON(value);
//             		 var _sub = $.parseJSON(sub);
//             		 for(var i=0;i<_value.length;i++){
//          				for(var k=0;k<_sub.length;k++){
//          					if(_sub[k].ATTR_CODE==_value[i].ATTR_CODE){
//          						_value[i].ischeck = "1";
//          					}
//          				}
//          			}
//          			for(var i=0;i<_value.length;i++){
//          				if(_value[i].ischeck=='1'){
//          					$("#acctType").append("<input type='checkbox' name='formKpiTypes' value='" +_value[i].ATTR_CODE + "' checked='checked'>"+_value[i].ATTR_NAME);
//          				}else{
//          					$("#acctType").append("<input type='checkbox' name='formKpiTypes' value='" +_value[i].ATTR_CODE + "'>"+_value[i].ATTR_NAME);
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
    </script>
</head>

<body>
<input type="hidden" id="SEL_CUBE_CODE" name="SEL_CUBE_CODE" value="${cube_code}"/>
<input type="hidden" id="operFlag" name="operFlag" value="${param.operFlag}"/>
<div class="kpi_guide">
	<div class="tit_div1">
		<h3 id="showTitle"></h3>
		<span>
			<e:if condition="${lookUpFlag == '1'}">
            	<button type="button" name="close">关闭</button>
            </e:if>
		</span>
	</div>
	<div class="editBase_div1">
    <form id="baseKpiForm" enctype="multipart/form-data" method="post">
        <input type="hidden" name="kpi_category" value="">
        <input type="hidden" id="kpi_eds" name="kpi_eds" value="${cubeDetail.CUBE_DATASOURCE}">
<!--         <input type="hidden" id="kpi_version" name="kpi_version" value=""> -->
        <input type="hidden" id="account_type" name="account_type" value="${cubeDetail.ACCOUNT_TYPE}">
        <input type="hidden" id="base_key" name="base_key" readonly="readonly">
        <input type="hidden" name="formKpiSub" id="formKpiSub">
        <input type="hidden" name="old_kpi_name" id="old_kpi_name" value=""/>
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
				<tr class="kpiTrBot"  style="display: none;">
				<e:forEach items="${classNum.list }" var="class" indexName="index">
					<td>
					<select id="${class.CLASS_NAME }"  codeStart="${index*2}" name="${class.CLASS_NAME }" style="width: 100%; height:26px; display: none;" >
						<e:q4l var="kpiType">select code,name from X_KPI_CODE_TYPE where type='${class.ID }' order by ord</e:q4l>
						<e:forEach items="${kpiType.list}" var="kt">
		                 	<option value ="${kt.CODE}">${kt.NAME}</option>	
		           		</e:forEach>	
					</select>
					</td>
				</e:forEach>
				<e:forEach items="${classNum.list }" var="class" indexName="index">
					<span id="${class.CLASS_NAME }_span" style="width: 120px; height:26px; text-align: left; margin-right: 10px;"></span>
				</e:forEach>
				</tr>
				</table>
				<input type="hidden" name="codeId" id="codeId" value="" readonly="readonly" style="width: 12%; height:26px;">
			</dd>
			</dl>
			<div class="kpiDivider"></div>
			</e:if>
			<dl class="ddLine">
                <dt>指标名称：</dt>
                <dd><span id="kpi_name" name="kpi_name"></span> 
				</dd>
			</dl>
			 <dl class="ddLine">
                <dt>业务口径：</dt>
                <dd>
                 <textarea class="taStyleNone" name="kpi_explain" id="kpi_explain" disabled="disabled"></textarea>
                </dd>
            </dl>
             <dl class="ddLine">
                <dt>技术口径：</dt>
                <dd>
                 <textarea class="taStyleNone" name="kpi_origin_regular" id="kpi_origin_regular" disabled="disabled"></textarea>
                </dd>
            </dl>
            <div class="kpiDivider"></div>
			<dl class="ddLine serviceCode">
             	<dt>取值字段：</dt>
                <dd><span id="kpi_origin_stc"></span>
<!--                 <input type="text" name="kpi_origin_stc" id="kpi_origin_stc" readonly="readonly"><B style="color: red;">&nbsp;*</B> -->
                </dd>
            </dl>
            <e:if condition="${typeInfo.EXT_VIEW=='1' }">
			<dl class="ddLine">
				<dt>扩展属性：</dt>
				<dd>
					<div id="acctType">
		             	<e:forEach items="${formulaType.list}" var="fl" indexName="ind">
							<e:if condition="${fl.ATTR_CODE eq 'A'}" var="flag">
								<input type="checkbox" name="formKpiTypes" value="${fl.ATTR_CODE }" checked='checked' disabled="disabled" style="display:none;">
							</e:if>
							<e:else condition="${flag }">
								<input type="checkbox" name="formKpiTypes" value="${fl.ATTR_CODE }" disabled="disabled" style="display:none;">
							</e:else>
						</e:forEach>
						<e:forEach items="${formulaType.list}" var="fl" indexName="ind">
							<e:forEach items="${formulaSub.list }" var="fml">
								<e:if condition="${fl.ATTR_CODE eq fml.attr_code}">
									<span>${fl.ATTR_NAME }</span>
								</e:if>
							</e:forEach>
						</e:forEach>
	             	</div>
				</dd>
			</dl>
			</e:if>
			<dl class="ddLine">
                <dt>指标单位：</dt>
                <dd><span id="kpi_unit"></span>
<!--                 <input type="text" name="kpi_version" readonly="readonly"> -->
                </dd>
            </dl>
			<dl class="ddLine">
                <dt>版本号：</dt>
                <dd><span id="kpi_version"></span>
<!--                 <input type="text" name="kpi_version" readonly="readonly"> -->
                </dd>
            </dl>
            <dl>
                <dt>提出人：</dt>
                <dd><span id="kpi_proposer"></span>
<!--                 <input type="text" name="kpi_proposer" readonly="readonly"><B style="color: red;">&nbsp;*</B> -->
                </dd>
            </dl>
            <dl>
                <dt>提出部门：</dt>
                <dd><span id="kpi_proposer_dept"></span>
<!--                 <input type="text" name="kpi_proposer_dept" readonly="readonly"><B style="color: red;">&nbsp;*</B> -->
                </dd>
            </dl>
            <dl class="ddLine">
                <dt>需求来源:</dt>
                <dd><span id="kpi_origin_desc"></span><br/>
<!--                  	<textarea rows="3" cols="10" id="kpi_origin_desc" name="kpi_origin_desc" readonly="readonly"></textarea><br> -->
<!--                 	<input type="file" name="upfile" class="file_none"> -->
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
