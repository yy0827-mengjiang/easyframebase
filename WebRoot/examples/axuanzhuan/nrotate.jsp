<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">

		<title>My JSP 'nrotate.jsp' starting page</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
	</head>
	<c:resources type="easyui"  style="${ThemeStyle }"/>
	<e:style value="/resources/themes/common/css/examples.css" />
	<script type="text/javascript">
  	 /*  $(function(){
  		var paramMap={};
		paramMap.rotaDimStr='acct_date';
		paramMap.eaction='all';
		$.ajax({
		      type : "post",  
		      url : '<e:url value="/examples/axuanzhuan/action.jsp"/>',  
		      data : paramMap,  
		      async : false,  
		      //dataType:"json",
		      success : function(data1){
		      	 data1 = data1.replace(/\r\n\t/g,'');
				 data1 = data1.replace(/(^\s*)|(\s*$)/g, "");
		      	 paramMap.dataJson=data1;
		      	 paramMap.rotaDimStr="ACCT_DATE";
				 $.ajax({
				      type : "post",  
				      url : '<e:url value="/rotaData.e"/>',  
				      data : paramMap,  
				      async : false,  
				      //dataType:"json",
				      success : function(data2){
				    	  $("#c1").html(data2);
				      }
				  }); 
		      }
		});

  	});   */
  
  </script>
	<body style="padding: 10px 20px">
		<div class="exampleWarp">
			<h1 class="titOne">
				旋转组件（表中356906条记录测试）
			</h1>
			<h1 class="titThree">
				以日期旋转
			</h1>
			<c:datagrid url="/examples/axuanzhuan/action.jsp?eaction=all" id="dg"
				style="width:800px;height:auto;" rotadim="ACCT_DATE"
				kpiCol="AREA_NAME" valCol="TARGET_VALUE" dimDesc="日期">

			</c:datagrid>

			<h1 class="titThree">
				以地市旋转
			</h1>
			<c:datagrid url="/examples/axuanzhuan/action.jsp?eaction=all"
				id="dg2" style="width:1010px;height:auto;" rotadim="AREA_NAME"
				kpiCol="ACCT_DATE" valCol="TARGET_VALUE" dimDesc="地市">

			</c:datagrid>

			<h1 class="titThree">
				以码表旋转
			</h1>
			<c:datagrid url="/examples/axuanzhuan/action.jsp?eaction=all"
				id="dg3" style="width:1010px;height:auto;" pagination="true"
				rotatable="CMCODE_AREA" rotadimcode="AREA_DESC" rotadim="AREA_NAME"
				kpiCol="ACCT_DATE" valCol="TARGET_VALUE" dimDesc="地市">
			</c:datagrid>

			<h1 class="titThree">
				普通表格
			</h1>
			<c:datagrid url="/examples/axuanzhuan/action.jsp?eaction=all"
				id="table1" download="true" style="width:800px;height:360px;">
				<thead>
					<tr>
						<th field="ACCT_DATE" width="100">
							小时
						</th>
						<th field="AREA_NO" width="100">
							地市编号
						</th>
						<th field="AREA_NAME" width="100">
							地市名称
						</th>
						<th field="TARGET_VALUE" width="100">
							当期值
						</th>
					</tr>
				</thead>
			</c:datagrid>
		</div>
	</body>
</html>
