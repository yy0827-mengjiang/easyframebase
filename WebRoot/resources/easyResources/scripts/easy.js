
(function ($) {
	$.fn.tableStyle = function (options) {
		var defaults = {head:"easy-table-head-row", th:"easy-table-th", odd:"easy-table-body-row1", even:"easy-table-body-row2", hover:"easy-table-body-row3", td:"easy-table-td"};
		options = $.extend({}, defaults, options);
		return this.each(function () {
			$(this).find("thead tr").addClass(options.head);
			$(this).find("thead tr th,td").addClass(options.th);
			$(this).find("tbody tr:odd").addClass(options.odd);
			$(this).find("tbody tr:even").addClass(options.even);
			$(this).find("tbody tr").hover(function () {
				$(this).addClass(options.hover);
			}, function () {
				$(this).removeClass(options.hover);
			});
			$(this).find("tbody tr td").addClass(options.td);
		});
	};
	$.extend({
		getWinWidth: function () {
			return $(window).width();
		},
		
		getWinHeight: function () {
			return $(window).height();
		},
		
		selectAll: function (name) {
			//$("input:checkbox[name='" + name + "']").attr("checked", true);
			$("input:checkbox[name='" + name + "']").each(function(){
				if($(this).attr("disabled")!=true)
					$(this).attr("checked",true);
			});
		},
		
		cancelAll: function (name) {
			$("input:checkbox[name='" + name + "']").attr("checked", false);
			
		},
		
		 
	/*	此部分为jquery-1.6.2.min.js 所对应的方法
		selectAndCancelAll: function (obj, name) {		
			if ($(obj).attr("checked") != 'checked') {
				$("input:checkbox[name='" + name + "']").attr("checked", false);
			} else {
				//$("input:checkbox[name='" + name + "']").attr("checked", true);
				$("input:checkbox[name='" + name + "']").each(function(){				
					if($(this).attr("disabled")!='disabled')
						$(this).attr("checked",true);
				});
			}
		}
	*/
		
		
	//此部分为jquery-1.4.4.min.js 所对应的方法
		selectAndCancelAll: function (obj, name) {
			if ($(obj).attr("checked") == false) {
				$("input:checkbox[name='" + name + "']").attr("checked", false);
			} else {
				//$("input:checkbox[name='" + name + "']").attr("checked", true);
				$("input:checkbox[name='" + name + "']").each(function(){
					if($(this).attr("disabled")!=true)
						$(this).attr("checked",true);
				});
			}
		}			
	});
})(jQuery);
$(function () {
	$(".easy-table").tableStyle();
});
selectAll = function (name) {
	$("input:checkbox[name='" + name + "']").attr("checked", true);
};
cancelAll = function (name) {
	$("input:checkbox[name='" + name + "']").attr("checked", false);
};
selectAndCancelAll = function (obj, name) {
	if ($(obj).attr("checked") == false) {
		$("input:checkbox[name='" + name + "']").attr("checked", false);
	} else {
		//$("input:checkbox[name='" + name + "']").attr("checked", true);
		$("input:checkbox[name='" + name + "']").each(function(){
			if($(this).attr("disabled")!=true)
				$(this).attr("checked",true);
		});
	}
};
format = function (date) {
	var y = date.getFullYear();
	var m = date.getMonth() + 1;
	var d = date.getDate();
	return y + "-" + (m < 10 ? "0" + m : m) + "-" + (d < 10 ? "0" + d : d);
};

