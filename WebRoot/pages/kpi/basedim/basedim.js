function automatic() {
	if (!$('#rauto').attr("checked")) {
		$('#auto').hide();
		$('#auto2').hide();
		$('#manual').show();
		$('#src_tab').val('');
		$('#conds').val('');
	} else {
		$('#auto').show();
		$('#auto2').show();
		$('#manual').hide();
		$('#sql_code').val('');
	}
	var _option = "<option>请选择</option>";
	$("#code").html('');
	$("#code").append(_option);
	$("#name").html('');
	$("#name").append(_option);
	$("#ails").html('');
	$("#ails").append(_option);
}
function dimType(){
	if (!$('#dim_type1').attr("checked")) {
		$('#dimType').hide();
	}else{
		$('#dimType').show();
	}
}
function onDataSource(dataSources) {
	if (dataSources.length > 0) {
		var _data = $.parseJSON(dataSources);
		var _dataSource = $('#dataSourceName');
		var _option = "<option value=''>默认数据源</option>";
		for (var i = 0; i < _data.length; i++) {
			_option = _option + "<option value='" + _data[i].value + "'>"
					+ _data[i].text + "</option>";
		}
		_dataSource.html('');
		_dataSource.append(_option);
	}
}
function dataSourceSel(dataSources,selDataSource){
	if (dataSources.length > 0) {
		var _data = $.parseJSON(dataSources);
		var _dataSource = $('#database_name1');
		var _option = "<option value=''>默认数据源</option>";
		for (var i = 0; i < _data.length; i++) {
			if(_data[i].value==selDataSource){
				_option = _option + "<option value='" + _data[i].value + "' selected=selected>"
				+ _data[i].text + "</option>";
			}else{
			_option = _option + "<option value='" + _data[i].value + "'>"
					+ _data[i].text + "</option>";
			}
		}
		_dataSource.html('');
		_dataSource.append(_option);
	}
}
function dimTabSearch() {
	var _value = $('#dim_tab').val();
	if ("" != _value) {
		cn.com.easy.kpi.service.DimDbService.dimTabSeach(_value,
				function(data) {
					var _data = $.parseJSON(data);
					if ("success" != _data.res) {
						$.messager.alert("提示信息！", _data.data, "info");
					} else {
						var __data = _data.data;
						$("#dim_onwer").val(_data.schema);
						$("#dim_table").val(_data.table);
						$("#dim_field").val(_data.column);
					}

				});
	}
}

function doSearch() {
	var _value = $('#src_tab').val();
	var _dataBase = $('#database_name1 option:selected').text().split(" ")[1];
	var _dataSource = $('#database_name1 option:selected').val();
	if ("" != _value) {
		cn.com.easy.kpi.service.DimDbService.sourceTable(_dataBase,_value,_dataSource,
				function(data) {
					var _data = $.parseJSON(data);
					if ("success" != _data.res) {
						$.messager.alert("提示信息！", _data.data, "info");
					} else {
						var __data = _data.data;
						var _option = "<option value=''>请选择</option>";
						for (var i = 0; i < __data.length; i++) {
							_option = _option + "<option value=" + __data[i]
									+ ">" + __data[i] + "</option>"
						}
						$("#src_onwer").val(_data.schema);
						$("#src_table").val(_data.table);
						$("#code").html('');
						$("#code").append(_option);
						$("#name").html('');
						$("#name").append(_option);
						$("#ails").html('');
						$("#ails").append(_option);
					}
				});
	}

}

function editDoSearch(code, name, ails) {
	var _check = $('#rauto').attr("checked");
	var _value = "";
	if(_check){
		_value = $('#src_tab').val();
	}else{
		_value = $('#sql_code').val();
	}
	var _dataBase = $('#database_name1 option:selected').text().split(" ")[1];
	var _dataSource = $('#database_name1').val();
	if ("" != _value) {
		cn.com.easy.kpi.service.DimDbService.sourceTable(_dataBase,_value,_dataSource,
				function(data) {
					var _data = $.parseJSON(data);
					if ("success" != _data.res) {
						$.messager.alert("提示信息！", _data.data, "info");
					} else {
						var __data = _data.data;
						var _code = "<option value=''>请选择</option>";
						for (var i = 0; i < __data.length; i++) {
							if (code == __data[i]) {
								_code = _code + "<option value='" + __data[i]
										+ "' selected=selected>" + __data[i]
										+ "</option>";
							} else {
								_code = _code + "<option value='" + __data[i]
										+ "'>" + __data[i] + "</option>";
							}
						}
						$("#code").html('');
						$("#code").append(_code);

						var _name = "<option value=''>请选择</option>";
						for (var i = 0; i < __data.length; i++) {
							if (name == __data[i]) {
								_name = _name + "<option value='" + __data[i]
										+ "' selected=selected>" + __data[i]
										+ "</option>";
							} else {
								_name = _name + "<option value='" + __data[i]
										+ "'>" + __data[i] + "</option>";
							}
						}
						$("#name").html('');
						$("#name").append(_name);
						var _ails = "<option value=''>请选择</option>";
						for (var i = 0; i < __data.length; i++) {
							if (ails == __data[i]) {
								_ails = _ails + "<option value='" + __data[i]
										+ "' selected=selected>" + __data[i]
										+ "</option>";
							} else {
								_ails = _ails + "<option value='" + __data[i]
										+ "'>" + __data[i] + "</option>";
							}
						}
						$("#ails").html('');
						$("#ails").append(_ails);
						$("#src_onwer").val(_data.schema);
						$("#src_table").val(_data.table);
					}
				});
	}
}

function doSearchSql() {
	var _value = $('#sql_code').val();
	var _dataBase = $('#database_name1 option:selected').val();
	var _dataSource = $('#database_name1').val();
	if ('' != _value) {
		cn.com.easy.kpi.service.DimDbService.sourceTable(_dataBase,_value,_dataSource, function(data) {
			var _data = $.parseJSON(data);
			if ("success" != _data.res) {
				$.messager.alert("提示信息！", _data.data, "info");
			} else {
				var __data = _data.data;
				var _option = "<option value=''>请选择</option>";
				for (var i = 0; i < __data.length; i++) {
					_option = _option + "<option value='"+__data[i]+"'>" + __data[i] + "</option>"
				}
				$("#code").html('');
				$("#code").append(_option);
				$("#name").html('');
				$("#name").append(_option);
				$("#ails").html('');
				$("#ails").append(_option);
			}
		});
	}
}

function srcTab() {
	var _value = $('#src_tab').val();
	var _dataSource = $('#database_name1').val();
	if (!_value) {
		_value = "用户名.表名";
		$('#src_tab').val(_value);
		$('#src_tab').attr("color", "gray");

	} else {
		doSearch();
	}
}

function validName() {
	var _dimName = $('#dim_name').val();
	if ('' != _dimName) {
		cn.com.easy.kpi.service.DimDbService.vaildName(_dimName,
				function(data) {
					var _data = $.parseJSON(data);
					if (_data.date) {
						$.messager.alert("提示信息！", '基础维度名称己存在！', "info");
					}
				});
	}
}

function saved(status) {
			var _dim_name = $('#dim_name').val();
			var _dim_tab = $('#dim_tab').val();
			var _dim_author = $('#dim_author').val();
			var _dim_dept = $('#dim_dept').val();
			var _dim_cond = $('#conds').val();
			var _name = $('#name  option:selected').val();
			var _code = $('#code  option:selected').val();
			var _ails = $('#ails  option:selected').val();
			var _dataSource = $('#database_name1  option:selected').val();
			if(_dataSource == ""||_dataSource == null){
				$.messager.alert("提示信息！", '请选择数据源！', "info");
				return false;
			}
			if (_dim_name == "" || _dim_name == null) {
				$.messager.alert("提示信息！", '请输入维度名称！', "info");
				return false;
			}
		
			if (_dim_name.length > 100) {
				$.messager.alert("提示信息！", '维度名称过长！', "info");
				return false;
			}
		
			if (_dim_tab == "" || _dim_tab == null) {
				$.messager.alert("提示信息！", '请输入维度字段！', "info");
				return false;
			}
		//	if (_dim_author == "" || _dim_author == null) {
		//		$.messager.alert("提示信息！", '请输入维度提出人！', "info");
		//		return false;
		//	}
		//	if (_dim_dept == "" || _dim_dept == null) {
		//		$.messager.alert("提示信息！", '请输入维度提出部门！', "info");
		//		return false;
		//	}
			if(_dim_cond!=''&&_dim_cond!=null){
				if(_dim_cond.toLowerCase().indexOf("where")!=0){
					$.messager.alert("提示信息！", '查询条件请以WHERE或where开头，前面不要有空格！', "info");
					return false;
				}
			}
			if($('#dim_type1').attr("checked")){
				if(_name == "请选择" ||_name == null){
					$.messager.alert("提示信息！", '请选择名称！', "info");
					return false;
				}
				if(_code == "请选择" ||_code == null){
					$.messager.alert("提示信息！", '请选择编码！', "info");
					return false;
				}
				if(_ails == "请选择" ||_ails == null){
					$.messager.alert("提示信息！", '请选择排序！', "info");
					return false;
				}
			}
			if ($("input[name='conf_set']:checked").val() == '0') {
				$("#sql_code").val('');
			} else {
				$("#src_tab").val('');
				$("#conds").val('');
			}
		
			$("#dim_status").val(status);
			
			if($('#rmanual').attr("checked")){
				$('#src_onwer').val('');
				$('#src_table').val('');
			}
	$.messager.confirm('提示信息', '是否保存维度信息?', function(r){
		if (r){
			$("#dimForm").get(0).enctype = "multipart/form-data";
			$("#dimForm").get(0).encoding = "multipart/form-data";
			$("#dimForm").get(0).action = "../basedim/upload.jsp";
			$("#dimForm").get(0).method = 'POST';
			$("#dimForm").get(0).target = 'hidden_frame';
			$('#conds').val(base64encode(utf16to8(_dim_cond)));
			$('#dimForm').submit();
		}else{
			var _cond =$("#conds").val(); 
			$("#conds").val(utf8to16(base64decode(_cond)));
		}
	});

}
function update(status) {
			var _dim_name = $('#dim_name').val();
			var _dim_tab = $('#dim_tab').val();
			var _dim_author = $('#dim_author').val();
			var _dim_dept = $('#dim_dept').val();
			var _dim_cond = $('#conds').val().replace(/(^\s*)|(\s*$)/g,'');;
			var _dataSource = $('#database_name1  option:selected').val();
			var _name = $('#name  option:selected').val();
			var _code = $('#code  option:selected').val();
			var _ails = $('#ails  option:selected').val();
			if(_dataSource == ""||_dataSource == null){
				$.messager.alert("提示信息！", '请选择数据源！', "info");
				return false;
			}
			if (_dim_name == "" || _dim_name == null) {
				$.messager.alert("提示信息！", '请输入维度名称！', "info");
				return false;
			}
		
			if (_dim_name.length > 100) {
				$.messager.alert("提示信息！", '维度名称过长！', "info");
				return false;
			}
		
			if (_dim_tab == "" || _dim_tab == null) {
				$.messager.alert("提示信息！", '请输入维度字段！', "info");
				return false;
			}
			if ($("input[name='conf_set']:checked").val() == '0') {
				$("#sql_code").val('');
			} else {
				$("#src_tab").val('');
				$("#conds").val('');
			}
			if($('#dim_type1').attr("checked")){
				if(_name == "请选择" ||_name == null){
					$.messager.alert("提示信息！", '请选择名称！', "info");
					return false;
				}
				if(_code == "请选择" ||_code == null){
					$.messager.alert("提示信息！", '请选择编码！', "info");
					return false;
				}
				if(_ails == "请选择" ||_ails == null){
					$.messager.alert("提示信息！", '请选择排序！', "info");
					return false;
				}
			}
			
			if(_dim_cond!=''&&_dim_cond!=null){
				if(_dim_cond.toLowerCase().indexOf("where")!=0){
					$.messager.alert("提示信息！", '查询条件请以WHERE或where开头！', "info");
					return false;
				}
				 $('#conds').val(base64encode(utf16to8(_dim_cond)));
			}
			
			$("#dim_status").val(status);
		
			if($('#rmanual').attr("checked")){
				$('#src_onwer').val('');
				$('#src_table').val('');
			}
			
	$.messager.confirm('提示信息', '是否保存维度信息?', function(r){
		if (r){
			$("#dimForm").get(0).enctype = "multipart/form-data";
			$("#dimForm").get(0).encoding = "multipart/form-data";
			$("#dimForm").get(0).action = "../basedim/upload.jsp";
			$("#dimForm").get(0).method = 'POST';
			$("#dimForm").get(0).target = 'hidden_frame';
			$('#dimForm').submit();
		}else{
			var _cond =$("#conds").val(); 
			$("#conds").val(utf8to16(base64decode(_cond)));
		}
	});

}
function closeDim(){
	$.messager.confirm('提示信息', '确认关闭当前页面?', function(r){
		if (r){
			$('#kpi').html('');
		}
	});
}
