<%@ tag body-content="scriptless" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="id" required="true" %>                                               	<e:description>表格id</e:description>
<%@ attribute name="url" required="true" %>                                              	<e:description>数据路径</e:description>
<%@ attribute name="jsonUrl" required="false" %>                                              	<e:description>jsonUrl</e:description>



<%@ attribute name="width" required="false" %>                                              <e:description>表格宽，值是数字</e:description>
<%@ attribute name="height" required="false" %>                                             <e:description>表格高，值可以是数字或者'auto'，auto是自动高</e:description>
<%@ attribute name="pager" required="false" %>                                             	<e:description>是否分页</e:description>
<%@ attribute name="pageSize" required="false" %>                                           <e:description>每页行数</e:description>
<%@ attribute name="pageGroup" required="false" %>                                          <e:description>显示几个按钮</e:description>
<%@ attribute name="select" required="false" %>                                             <e:description>选中单元格（可选值：row,cell,column）</e:description>
<%@ attribute name="clickCell" required="false" %>                                        	<e:description>点击单元格事件（可选值：row,cell,column）</e:description>
<%@ attribute name="download" required="false" %>                          	        		<e:description>导出文件的名称，不为空时下载</e:description>
<%@ attribute name="frozenColumn" required="false" %>                          	        	<e:description>锁定列，int型，锁定最左侧几列</e:description>
<%@ attribute name="reloadUrl" required="false" %>                          	        	<e:description>重新加载</e:description>
<%@ attribute name="autoFit" required="false" %>                          	        		<e:description>自动适应</e:description>
<%@ attribute name="adjustColumn" required="false" %>                                <e:description>要自动调整行高的列ID（自动换行的列ID）</e:description>
<%@ attribute name="afterFunction" required="false" %>                                <e:description>执行后成后执行的方法</e:description>

<jsp:doBody var="bodyRes" />
</style>
<div id="${id}" style="width:${width}px;margin-left:0px;margin-right:auto;"></div>
<e:if condition="${pager=='true'}">
<div id="paging_here"></div>
</e:if>

<e:if var="fc" condition="${frozenColumn!=null && frozenColumn!=''}">
	<e:set var="frozenColumn" value="${frozenColumn}"/>
</e:if>
<e:else condition="${fc}">
	<e:set var="frozenColumn" value="1"/>
</e:else>

<e:invoke var="columns" objectClass="cn.com.easy.taglib.util.TagHelper" method="getColumnJson">
	<e:param value="<table>${bodyRes}</table>"/>
	<e:param value="${frozenColumn}"/>
</e:invoke>

<script type="text/javascript"><!--
//webix.Touch.disable();
webix.Touch.limit(true);
var grida_${id};
var fullwidth = window.innerWidth-25;
var fullheight = window.innerHeight-60;
var os = navigator.userAgent.toLowerCase();
var isAndroid = (os.indexOf('android') > -1);
function datagridReload( wid, url ){
	var dg = eval('grida_'+wid);
	$$( dg ).clearAll();
	$$( dg ).load(url);
}
var options_${id}={};

<e:if var="ttt" condition="${jsonUrl==''}">
	webix.ajax().post((window["appBase"]==undefined?('<e:url value="/"/>'.substring(0,'<e:url value="/"/>'.lastIndexOf('/'))):window["appBase"])+('${url}'.indexOf("/")==0?'${url}':'/${url}'), null, function(text, xml, xhr){
	jsonData = eval( '(' + text + ')' );
	options_${id} = {
	view : 'datatable',
	container : '${id}',
	fixedRowHeight:false, 
	columns : ${columns},
	data : jsonData,
	<e:if var="tmpW" condition="${width!=null && width!=''}">
	width : ${width},
	</e:if>
	<e:else condition="${tmpW}">
		width:fullwidth,
	</e:else>
	<e:if var="tmpH" condition="${height!=null && height!='' && height!='auto'}">
		height : ${height},
	</e:if>
	<e:else condition="${tmpH}">
		//rowLineHeight:20, rowHeight:20,
		//autowidth:true,
		autoheight:true,
	</e:else>
	<e:if condition="${pager=='true'}">
		pager : {
			template : "{common.first()} {common.prev()} {common.pages()} {common.next()} {common.last()}",
			container : "paging_here",
			size : <e:if var="tmp" condition="${pageSize!=null && pageSize!=''}">${pageSize}</e:if><e:else condition="${tmp}">10</e:else>,
			group : <e:if var="tmp" condition="${pageGroup!=null && pageGroup!=''}">${pageGroup}</e:if><e:else condition="${tmp}">5</e:else>
		},
	</e:if>
	<e:if condition="${select!=null && select!=''}">
		select : '${select}',
	</e:if>
	<e:if condition="${frozenColumn!=null && frozenColumn!=''}">
		leftSplit : ${frozenColumn},
	</e:if>
	"export" : true,
	on : {
		<e:if condition="${ clickCell!=null }">
			"onItemClick" : '${clickCell}',
		</e:if>
		"onresize":webix.once(function(){
		var adjustColumn='${adjustColumn}';
			if(adjustColumn!=null&&adjustColumn!=''&&adjustColumn!='null'&&adjustColumn!=undefined&&adjustColumn!='undefined'){
				this.adjustRowHeight(adjustColumn, true); 
			}
		})
	}
};
grida_${id} = new webix.ui( options_${id} );
	var divw = 0;
	//头一列宽
	var f_col_width=0;
	//表格高度
	var f_col_height=grida_${id}.config.height;
	//计算所有列宽度得和
	grida_${id}.eachColumn( 
		    function (col){ 
		    	var colJson = grida_${id}.getColumnConfig( col );
		    	divw += colJson.width;
		    	var colIndex = grida_${id}.getColumnIndex( col );
	 		    	//头一列支持页面上下滑动
	 		        if(colIndex==0){
	 		        f_col_width=colJson.width;
	 		      }
		    },true
		);
	//获取手机浏览器得宽度
	var width=window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	/*
	  1.表格宽度(所有列宽得和，不是属性width 的值)
	  2.判断表格宽度和浏览器宽度
	  	  当表格宽度大于浏览器宽度时：就设定显示得宽度为浏览器宽度－15px
	  	  当表格宽度小于浏览器宽度时：就设定显示得宽度为浏览器宽度，并放大以充满整个屏幕
	*/
	if(divw>width){
			grida_${id}.config.width =width-10;
			grida_${id}.resize();
	}else if(divw<width){
		//width-125-(width-320)这么写是为了解决表格随着页面可以滑动。
		//于是就以320为基准，其他得手机宽度就多减去一部分宽度
		grida_${id}.config.width =width-130-(width-320);
		document.getElementById('${id}').style.zoom=width/(divw+15);
		grida_${id}.resize();	
	}
	//长按事件
	webix.attachEvent("onLongTouch",function(context){
	    //var y = window.pageYOffset;
        //var x = window.pageXOffset;
        //window.focus();
	    //window.scrollTo(x,y+10);
	    //scrollLeft = document.documentElement.scrollLeft || window.pageXOffset || document.body.scrollLeft;
	    //scrollTop = document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;
	   
	   //grida_${id}.disable();
	   
	    //parentV.focus();
	    
	    //webix.html.stopEvent(Event.TOUCH);
	    
        //grida_${id}.disable();
        //grida_${id}.refresh();
        //window.focus();
        //webix.Touch.limit(false);
        
        
        
        //webix.Touch.disable();
	    //grida_${id}.refresh();
    });
    //判断是否选中头一列，是选中
    var is_select_column=false;
    webix.attachEvent("onTouchStart",function(context){
        //alert(webix.toArray(grida_${id}.config.columns));
        if(context.x<f_col_width && context.y < f_col_height ){
             webix.Touch.disable();
	 		 grida_${id}.refresh();
	 		 is_select_column=true;
        }

        if(is_select_column){
             is_select_column=false;
             webix.Touch.enable();
             grida_${id}.refresh();
        }
        
        /* grida_${id}.eachColumn( 
	 		    function (col){ 
	 		    	var colJson = grida_${id}.getColumnIndex( col );
	 		    	//头一列支持页面上下滑动
	 		        if(colJson==0){
	 		        alert(11);
	 		           webix.Touch.disable();
	 		           grida_${id}.refresh();
	 		           return;
	 		        }
 
	 		    }
	    );  */
        //grida_${id}.focus();
        //grida_${id}.enable();
       // grida_${id}.refresh();
    });
    webix.attachEvent("onTouchEnd",function(start_context,current_context){
        webix.Touch.enable();
	    grida_${id}.refresh();
        
        //grida_${id}.focus();
        //grida_${id}.enable();
       // grida_${id}.refresh();
    });
    
	//旋转事件
 	webix.attachEvent("onRotate", function(orientation){
 		setTimeout(function() {
 			//计算所有列宽度得和
	 		var divw = 0;
	 		grida_${id}.eachColumn( 
	 		    function (col){ 
	 		    	var colJson = grida_${id}.getColumnConfig( col );
	 		        divw += colJson.width;
	 		    }
	 		);
	 		//获取手机得宽度和高度
	 		var rwidth=window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	 		var rheight=window.innerHeight;
	 		//rwidth<rheight为竖屏；rwidth>rheight为横屏
		 	if(rwidth<rheight){
		 		//旋转后有可能回手机浏览器宽度和之前得浏览器宽度不一样，为此判断一下取最小值
		 		var sw=rwidth>width?width:rwidth;
		 		if(divw>rwidth){
		 				grida_${id}.config.width =sw-25-(sw-325);
		 				grida_${id}.resize();
		 		}else if(divw<rwidth){
		 			grida_${id}.config.width =sw-130-(sw-320);
					document.getElementById('${id}').style.zoom=sw/(divw+17);
					grida_${id}.resize();	
		 		}
		 	}else if(rwidth>rheight){
		 		if(divw>rwidth){
		 			grida_${id}.config.width =rwidth-35;
		 			grida_${id}.resize();
		 		}
		 		if(divw<rwidth){
		 			grida_${id}.config.width =rwidth-125-(sw-325);
		 			document.getElementById('${id}').style.zoom=rwidth/(divw+12);
		 			grida_${id}.resize();
		 		}
		 	}
 		},500);
	});
	<e:if condition="${afterFunction!=null && afterFunction!=''}">
		${afterFunction}();
	</e:if>
	
	
});
</e:if>
<e:else condition="${ttt}">
	var mobileJson = ${jsonUrl};
	//alert(mobileJson.rows);
	options_${id} = {
	view : 'datatable',
	container : '${id}',
	fixedRowHeight:false, 
	columns : ${columns},
	data : mobileJson.rows,
	<e:if var="tmpW" condition="${width!=null && width!=''}">
	width : ${width},
	</e:if>
	<e:else condition="${tmpW}">
		width:fullwidth,
	</e:else>
	<e:if var="tmpH" condition="${height!=null && height!='' && height!='auto'}">
		height : ${height},
	</e:if>
	<e:else condition="${tmpH}">
		//rowLineHeight:20, rowHeight:20,
		//autowidth:true,
		autoheight:true,
	</e:else>
	<e:if condition="${pager=='true'}">
		pager : {
			template : "{common.first()} {common.prev()} {common.pages()} {common.next()} {common.last()}",
			container : "paging_here",
			size : <e:if var="tmp" condition="${pageSize!=null && pageSize!=''}">${pageSize}</e:if><e:else condition="${tmp}">10</e:else>,
			group : <e:if var="tmp" condition="${pageGroup!=null && pageGroup!=''}">${pageGroup}</e:if><e:else condition="${tmp}">5</e:else>
		},
	</e:if>
	<e:if condition="${select!=null && select!=''}">
		select : '${select}',
	</e:if>
	<e:if condition="${frozenColumn!=null && frozenColumn!=''}">
		leftSplit : ${frozenColumn},
	</e:if>
	"export" : true,
	on : {
		<e:if condition="${ clickCell!=null }">
			"onItemClick" : '${clickCell}',
		</e:if>
		"onresize":webix.once(function(){
		var adjustColumn='${adjustColumn}';
			if(adjustColumn!=null&&adjustColumn!=''&&adjustColumn!='null'&&adjustColumn!=undefined&&adjustColumn!='undefined'){
				this.adjustRowHeight(adjustColumn, true); 
			}
		})
	}
};
grida_${id} = new webix.ui( options_${id} );
	var divw = 0;
	//头一列宽
	var f_col_width=0;
	//表格高度
	var f_col_height=grida_${id}.config.height;
	//计算所有列宽度得和
	grida_${id}.eachColumn( 
		    function (col){ 
		    	var colJson = grida_${id}.getColumnConfig( col );
		    	divw += colJson.width;
		    	var colIndex = grida_${id}.getColumnIndex( col );
	 		    	//头一列支持页面上下滑动
	 		        if(colIndex==0){
	 		        f_col_width=colJson.width;
	 		      }
		    },true
		);
	//获取手机浏览器得宽度
	var width=window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	/*
	  1.表格宽度(所有列宽得和，不是属性width 的值)
	  2.判断表格宽度和浏览器宽度
	  	  当表格宽度大于浏览器宽度时：就设定显示得宽度为浏览器宽度－15px
	  	  当表格宽度小于浏览器宽度时：就设定显示得宽度为浏览器宽度，并放大以充满整个屏幕
	*/
	if(divw>width){
			grida_${id}.config.width =width-10;
			grida_${id}.resize();
	}else if(divw<width){
		//width-125-(width-320)这么写是为了解决表格随着页面可以滑动。
		//于是就以320为基准，其他得手机宽度就多减去一部分宽度
		grida_${id}.config.width =width-130-(width-320);
		document.getElementById('${id}').style.zoom=width/(divw+15);
		grida_${id}.resize();	
	}
	//长按事件
	webix.attachEvent("onLongTouch",function(context){
	    //var y = window.pageYOffset;
        //var x = window.pageXOffset;
        //window.focus();
	    //window.scrollTo(x,y+10);
	    //scrollLeft = document.documentElement.scrollLeft || window.pageXOffset || document.body.scrollLeft;
	    //scrollTop = document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;
	   
	   //grida_${id}.disable();
	   
	    //parentV.focus();
	    
	    //webix.html.stopEvent(Event.TOUCH);
	    
        //grida_${id}.disable();
        //grida_${id}.refresh();
        //window.focus();
        //webix.Touch.limit(false);
        
        
        
        //webix.Touch.disable();
	    //grida_${id}.refresh();
    });
    //判断是否选中头一列，是选中
    var is_select_column=false;
    webix.attachEvent("onTouchStart",function(context){
        //alert(webix.toArray(grida_${id}.config.columns));
        if(context.x<f_col_width && context.y < f_col_height ){
             webix.Touch.disable();
	 		 grida_${id}.refresh();
	 		 is_select_column=true;
        }

        if(is_select_column){
             is_select_column=false;
             webix.Touch.enable();
             grida_${id}.refresh();
        }
        
        /* grida_${id}.eachColumn( 
	 		    function (col){ 
	 		    	var colJson = grida_${id}.getColumnIndex( col );
	 		    	//头一列支持页面上下滑动
	 		        if(colJson==0){
	 		        alert(11);
	 		           webix.Touch.disable();
	 		           grida_${id}.refresh();
	 		           return;
	 		        }
 
	 		    }
	    );  */
        //grida_${id}.focus();
        //grida_${id}.enable();
       // grida_${id}.refresh();
    });
    webix.attachEvent("onTouchEnd",function(start_context,current_context){
        webix.Touch.enable();
	    grida_${id}.refresh();
        
        //grida_${id}.focus();
        //grida_${id}.enable();
       // grida_${id}.refresh();
    });
    
	//旋转事件
 	webix.attachEvent("onRotate", function(orientation){
 		setTimeout(function() {
 			//计算所有列宽度得和
	 		var divw = 0;
	 		grida_${id}.eachColumn( 
	 		    function (col){ 
	 		    	var colJson = grida_${id}.getColumnConfig( col );
	 		        divw += colJson.width;
	 		    }
	 		);
	 		//获取手机得宽度和高度
	 		var rwidth=window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	 		var rheight=window.innerHeight;
	 		//rwidth<rheight为竖屏；rwidth>rheight为横屏
		 	if(rwidth<rheight){
		 		//旋转后有可能回手机浏览器宽度和之前得浏览器宽度不一样，为此判断一下取最小值
		 		var sw=rwidth>width?width:rwidth;
		 		if(divw>rwidth){
		 				grida_${id}.config.width =sw-25-(sw-325);
		 				grida_${id}.resize();
		 		}else if(divw<rwidth){
		 			grida_${id}.config.width =sw-130-(sw-320);
					document.getElementById('${id}').style.zoom=sw/(divw+17);
					grida_${id}.resize();	
		 		}
		 	}else if(rwidth>rheight){
		 		if(divw>rwidth){
		 			grida_${id}.config.width =rwidth-35;
		 			grida_${id}.resize();
		 		}
		 		if(divw<rwidth){
		 			grida_${id}.config.width =rwidth-125-(sw-325);
		 			document.getElementById('${id}').style.zoom=rwidth/(divw+12);
		 			grida_${id}.resize();
		 		}
		 	}
 		},500);
	});
	<e:if condition="${afterFunction!=null && afterFunction!=''}">
		${afterFunction}();
	</e:if>
</e:else>

--></script>