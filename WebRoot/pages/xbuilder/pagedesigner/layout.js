var LayOutUtil = {
	lindex:1,
	tmpContainerId:'',//当前临时选择的容器id
	tmpComponentId:'',//当前临时选择的组件id
	gridster:{},
	data:{},
	init:function(xid,userid,name,theme,lhtml,lwidth,dstype,ltype,colors,contw,typeext){
		LayOutUtil.data.userId = StoreData.userId = userid+'';
		LayOutUtil.data.xid = StoreData.xid = xid;
		LayOutUtil.data.name = StoreData.name = name;
		LayOutUtil.data.theme = StoreData.theme = theme;
		LayOutUtil.data.lwidth = StoreData.lwidth = lwidth;
		LayOutUtil.data.dstype = StoreData.dsType = dstype;
		LayOutUtil.data.colorJson = StoreData.colorJson = $.parseJSON(colors);
		LayOutUtil.data.color = StoreData.color = [];
		LayOutUtil.data.lhtml = StoreData.lhtml = lhtml;
		LayOutUtil.data.ltype = StoreData.ltype = ltype;
		LayOutUtil.data.container = StoreData.container = {};
		LayOutUtil.data.contw = contw;
		LayOutUtil.data.typeExt = StoreData.typeExt = typeext;
		LayOutUtil.gridsterInit();
		LayOutUtil.setColor();
		var params = {xid:xid,contw:contw,userId:StoreData.userId,theme:theme,lhtml:lhtml,lwidth:lwidth,dstype:dstype,ltype:ltype,typeExt:typeext};
		cn.com.easy.xbuilder.service.XService.setView(params,function(data,e){
            $("#theme_tab li a").eq(0).addClass("active");
		 	 LayOutUtil.setThemeNoConfirm($("#theme_tab li a").eq(0).attr("value"));
		 	$("#theme_tab li a").click(function(){
		 		if(LayOutUtil.data.theme==$(this).attr("value")){
		 			return;
		 		}
		 		$(this).addClass("active").parent().siblings("li").find("a").removeClass("active");
		 		LayOutUtil.setTheme($(this).attr("value"));
		 	});
              
		 	$(".style-area li a").eq(0).addClass("active")
		 	 	LayOutUtil.setThemeNoConfirm($(".style-area li a").eq(0).attr("value"));
		 	$(".btn-style").click(function(){
		 		$(".style-area").toggle();
		 	});
		 	$(".style-area li a").click(function(){
		 		if(StoreData.theme==$(this).attr("value")){
		 			return;
		 		}
		 		$(this).addClass("active").parent().siblings("li").find("a").removeClass("active");
		 		LayOutUtil.setTheme($(this).attr("value"))
		 	});
		 	if(StoreData.dsType == 2){
			 	window.setTimeout(function(){
					$('#'+StoreData.xid+'_1').addClass('default-border').removeClass('selected-border');
					$('#'+StoreData.xid+'_1').addClass('selected-border');
					LayOutUtil.setContainer(StoreData.xid+'_1');
					checkContainer('DDATAGRID','基础表格','DATAGRID','pages/xbuilder/component/datagrid/Template.jsp','pages/xbuilder/component/datagrid/kpi/Properties.jsp',compClass.DATAGRID);
				},400);
			}
		});
		if(StoreData.dsType=="2"){
	   		initCubeMenu();
	   	}
	   	initDimensionDroppable();
	   	$('#publish_a').click(function(e){
	   		var inname = $('#autoInput').val();
	   		$('#reportSaveName').val(inname);
	   		/*
	   		if(LayOutUtil.data.xOneSaveBtn=='1'){
	   			$("#saveTypeRadioTemp").attr("checked","checked");
	   		}
	   		*/
			$("#reportNamedlg").dialog("open");
	   	});
	},
	gridsterInit:function(){
		var cont_map={};
		var tmp_xy = {};
		var tmp_html = "";
		var temp_contid = null;
		var $lid = null
		var drag_flag = false;
		
		var rowCount = 0;
        $(".gridster>ul>li").each(function(index,item){
            var rowIndex = parseInt($(item).attr("data-row"));
            if(rowIndex>rowCount){
            	rowCount = rowIndex;
            }
        });
        if(rowCount>10){
        	rowCount = rowCount+"";
        	rowCount = parseInt(rowCount.charAt(0))+1;
        }
       
        var totalBlockSize = 0;
        var perWidth = 20;
        var margin = 2;
        var realWidth = 0;
        var containerWidth = $(".gridster").width();//这个值获取的比实际的大一些
        var blockArr=[];
        var maxRowWidth=0;
        var realWidth=0;
        var maxWidthRowBlockSize=0;
        for(var i=0;i<rowCount;i++){
            totalBlockSize = 0 ;
            if(i==0){
            	blockArr = $(".gridster>ul>li[data-row='1']");
            }else{
            	blockArr=[];
            	var tempBlockArr = $(".gridster>ul>li");
            	$.each(tempBlockArr,function(index,item){
            		var rownum = $(item).attr("data-row");
            		if(rownum!="1"&&rownum.charAt(0)==i){
            			blockArr.push(item);
            		}
            	});
            }
            for (var j = 0; j < blockArr.length; j++) {
                totalBlockSize += parseInt($(blockArr[j]).attr("data-sizex"));
            };
            realWidth = totalBlockSize*perWidth+totalBlockSize*margin*2;
            if(realWidth>maxRowWidth){
                maxRowWidth=realWidth;
                maxWidthRowBlockSize = totalBlockSize;
            }
        }

        if(maxRowWidth>=containerWidth){
        	maxRowWidth =  containerWidth;
        }else{
        	var lw = screen.width-10;
    		var sourceDataLw=$.ajax({url: appBase+'/getDLWidth.e?xid='+StoreData.xid,type:"POST",cache: false,async: false}).responseText;
    		maxRowWidth = maxRowWidth*(lw/sourceDataLw);
    		if(maxRowWidth>containerWidth){
    			maxRowWidth = containerWidth;
    		}
        }

        perWidth = (maxRowWidth-maxWidthRowBlockSize*margin*2-15)/maxWidthRowBlockSize;//不行就减去15像素           
        
	     LayOutUtil.gridster = $(".gridster > ul").gridster({
	        widget_margins: [margin, margin],
	        widget_base_dimensions: [perWidth,20],
	        min_cols: 6,
	        autogenerate_stylesheet: true,
	        avoid_overlapped_widgets: true,
		  draggable: {
		  handle: '.component-head>h3,.component-head>h3>span,.component-head>ul',
			  start: function(event, ui){
			  	$lid = $('#'+ui.$player[0].id);
			  	temp_contid = ui.$player[0].id;
			  	
			  	var $tmpObj = $(ui.$player[0].outerHTML);
			  	tmp_html = $tmpObj.find('#div_body_'+temp_contid).html();
			  	$('#div_body_'+temp_contid).html('');
			  	
			  	tmp_xy={x:$tmpObj.data('sizex'),y:$tmpObj.data('sizey')};
       			LayOutUtil.gridster.resize_widget($lid,5,5);
			  },
			stop: function(event, ui) {
				LayOutUtil.gridster.resize_widget($lid,tmp_xy.x,tmp_xy.y,function(){
					var tgd = $(tmp_html).find("div[id^='treegrid_panel_']");
					var dgd = $(tmp_html).find("div[id^='datagrid_panel_']");
					var cst = $(tmp_html).find("div[id^='crosstable_panel_']");
					if(tgd.length<=0 && dgd.length<=0 && cst.length<=0){
						$('#div_body_'+temp_contid).html(tmp_html);
						$('#div_body_'+temp_contid).css("overflow","hidden");
					}else{
						var tempname = tgd.length>0?'treegrid':dgd.length>0?'datagrid':'crosstable';
						var tempcomp = tgd.length>0?tgd[0].id.replace(tempname+'_panel_',''):dgd.length>0?dgd[0].id.replace(tempname+'_panel_',''):cst[0].id.replace(tempname+'_panel_','');
						var tempargs = 'reportId='+StoreData.xid+'&containerId='+temp_contid+'&componentId='+tempcomp;
						$('#div_body_'+temp_contid).load(appBase+'/pages/xbuilder/component/'+tempname+'/Template.jsp?'+tempargs);
					}
					LayOutUtil.setLHtml($("#selectable_layout_id001").html());
					tmp_html = "";
				});
			}
		  },
		  resize: {
			enabled: true,
			stop: function(e, ui, $widget) {
				var vid = $widget[0].id;
				var divBodyHight=$widget[0].clientHeight-50;
				if(divBodyHight<0){
					divBodyHight=0;
				}
				var resizeDiv=$("div[id^='div_body_"+vid+"']");
				var tgd = resizeDiv.find("div[id^='treegrid_panel_']");
				var dgd = resizeDiv.find("div[id^='datagrid_panel_']");
				var cst = resizeDiv.find("div[id^='crosstable_panel_']");
				if(tgd.length>0 || dgd.length>0 || cst.length>0){
					resizeDiv.css("height",divBodyHight+"px");
					resizeDiv.css("overflow","auto");
				}else{
					resizeDiv.css("overflow","hidden");
				}
				
				LayOutUtil.setLHtmlAndC(vid,$("#selectable_layout_id001").html(),$widget[0].clientWidth,$widget[0].clientHeight,function(){
					$.post('getXContainerInfo.e',{vd:vid},function(js){
						eval(js);
						var $container=$("#container");   
						if($container[0]!=undefined&&$container[0].scrollHeight>$container[0].clientHeight){
							$("#tools_panel").css("right","14px");
						}else {
							$("#tools_panel").css("right","0");
						}
					});
				});
		  	}
		  }
	    }).data('gridster');
	},
	setEdit:function(xid,maxIndex,userid,name,theme,lhtml,lwidth,dstype,ltype,colors,contw){
		LayOutUtil.lindex=maxIndex;
		LayOutUtil.data.userId = StoreData.userId = userid+'';//MODIFY_USER
		LayOutUtil.data.xid = StoreData.xid = xid;
		LayOutUtil.data.name = StoreData.name = name;
		LayOutUtil.data.theme = StoreData.theme = theme;
		LayOutUtil.data.themeCache = StoreData.themeCache = theme;
		LayOutUtil.data.colorJson = StoreData.colorJson = [];
		LayOutUtil.data.color = StoreData.color = [];
		LayOutUtil.data.lhtml = StoreData.lhtml = lhtml;
		LayOutUtil.data.lwidth = StoreData.lwidth = lwidth;
		LayOutUtil.data.dstype = StoreData.dsType = dstype;
		LayOutUtil.data.colorJson = StoreData.colorJson = $.parseJSON(colors);
		LayOutUtil.data.color = StoreData.color = [];
		LayOutUtil.data.lhtml = StoreData.lhtml = lhtml;
		LayOutUtil.data.ltype = StoreData.ltype = ltype;
		LayOutUtil.data.container = StoreData.container = {};
		LayOutUtil.data.contw = contw;
		LayOutUtil.gridsterInit();
		LayOutUtil.setColor();
		var param = {xid:StoreData.xid,userId:StoreData.userId};
		cn.com.easy.xbuilder.service.XService.setModifyUser(param,function(data,exception){});
		LayOutUtil.setThemeNoConfirm(theme);
		$("#theme_tab li a").click(function(){
	 		if(LayOutUtil.data.theme==$(this).attr("value")){
	 			return;
	 		}
	 		$(this).addClass("active").parent().siblings("li").find("a").removeClass("active");
	 		LayOutUtil.setTheme($(this).attr("value"));
	 	});
		if(StoreData.dsType=="2"){
			cn.com.easy.xbuilder.service.XService.getCubeId({xid:StoreData.xid},function(data,exception){
				StoreData.cubeId = data;
				LayOutUtil.setCubeId(data);
			});
			initCubeMenu();
	   	}
	   	initDimensionDroppable();
	   	$('#publish_a').click(function(e){
	   		var inname = $('#autoInput').val();
	   		$('#reportSaveName').val(inname);
			$("#reportNamedlg").dialog("open");
	   	});
	},
	setName:function(name){
		LayOutUtil.data.name = StoreData.name = name;
		var param = {xid:StoreData.xid,name:name};
		cn.com.easy.xbuilder.service.XService.setName(param,function(data,exception){});
	},
	setNameAndGenerate:function(name,slw){
		LayOutUtil.data.name = StoreData.name = name;
		var param = {xid:StoreData.xid,name:name};
		cn.com.easy.xbuilder.service.XService.setNameSave(param,function(data,exception){
			$('#autoInput').val(name);
			$("#reportNamedlg").dialog("close");
			//window.open(appBase+'/xGenerate.e?xid='+StoreData.xid+'&type=1&slw='+slw,name, 'height=100%, width=100%, top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');
			LayOutUtil.openNewPage(appBase+'/xGenerate.e?xid='+StoreData.xid+'&type=1&slw='+slw);
		});
	},
	setNameAndTypeGenerate:function(name,type,slw){
		LayOutUtil.data.name = StoreData.name = name;
		var param = {xid:StoreData.xid,name:name,type:type};
		cn.com.easy.xbuilder.service.XService.setNameSave(param,function(data,exception){
			$('#autoInput').val(name);
			$("#reportNamedlg").dialog("close");
			var url=appBase+'/xGenerate.e?xid='+StoreData.xid+'&type=1&slw='+slw;
			if(type=='0'){
				url=appBase+'/xGenerate.e?xid='+StoreData.xid+'&type=0&edit=0';
			}
			LayOutUtil.openNewPage(url);
		});
	},
	setCubeId:function(cubeId){
		var param = {xid:StoreData.xid,cubeId:cubeId};
		cn.com.easy.xbuilder.service.XService.setCubeId(param,function(data,exception){});
		
	},
	setTheme:function(theme){
		$.messager.confirm('确认信息', '更换主题，原设定的颜色将变更为默认值，是否继续？', function(r){
			if (r){
				LayOutUtil.setThemeFile(theme);
				LayOutUtil.data.theme = StoreData.theme = theme;
				LayOutUtil.data.themeCache = StoreData.themeCache = theme;
				LayOutUtil.setColor();
				LayOutUtil.setDefaultColor(theme);
				cn.com.easy.xbuilder.service.XService.setTheme(LayOutUtil.data,function(data,exception){});
			}else{
				$('#theme').val(LayOutUtil.data.themeCache);
			}
		});
	},
	setThemeNoConfirm:function(theme){
		LayOutUtil.setThemeFile(theme);
		LayOutUtil.data.theme = StoreData.theme = theme;
		LayOutUtil.data.themeCache = StoreData.themeCache = theme;
		LayOutUtil.setColor();
		LayOutUtil.setDefaultColor(theme);
		cn.com.easy.xbuilder.service.XService.setTheme(LayOutUtil.data,function(data,exception){});
	},	
	setThemeFile:function(theme){
		for(var i=0;i<LayOutUtil.data.colorJson.length;i++){
			if(LayOutUtil.data.colorJson[i].THEME_ID==theme){
				if($("#themeCssFile").size()>0){//清除已有主题css文件
					$("#themeCssFile").remove();
				}
				if(LayOutUtil.data.colorJson[i].THEME_FILE_PATH!=""){
					$("<link>").attr({ rel: "stylesheet",id:"themeCssFile",type: "text/css",href: appBase+"/"+ LayOutUtil.data.colorJson[i].THEME_FILE_PATH}).appendTo("head");
				}
				break;
			}
		}
	},
	setDefaultColor:function(theme){
		$("div[id^='div_area_']").each(function(i,e){
			var firstColorIndex=-1;
			for(var i=0;i<LayOutUtil.data.colorJson.length;i++){
				$(e).removeClass(LayOutUtil.data.colorJson[i].ID);
				if(theme==LayOutUtil.data.colorJson[i].THEME_ID){
					$(e).addClass(LayOutUtil.data.colorJson[i].ID);
					if(firstColorIndex==-1){
						firstColorIndex=i;
					}
					break;
					//alert(LayOutUtil.data.colorJson[i].ID);
				}
			}
			//LayOutUtil.data.currentColor=StoreData.currentColor = LayOutUtil.data.colorJson[0].ID;
		});
	},
	setColor:function(){
		LayOutUtil.data.color = StoreData.color = [];
		for(var i=0;i<LayOutUtil.data.colorJson.length;i++){
			var item = LayOutUtil.data.colorJson[i];
			if(item.THEME_ID == LayOutUtil.data.theme){
				LayOutUtil.data.color.push({id:item.ID,name:item.NAME});
				StoreData.color.push({id:item.ID,name:item.NAME});
			}
		}
	},
	setLHtml:function(lhtml){
		LayOutUtil.data.lhtml = StoreData.lhtml = lhtml;
		var param = {xid:LayOutUtil.data.xid,lhtml:lhtml};
		cn.com.easy.xbuilder.service.XService.setLHtml(param,function(data,exception){});
		
	},
	setLHtmlAndC:function(id,lhtml,w,h,callback){
		LayOutUtil.data.lhtml = StoreData.lhtml = lhtml;
		var param = {xid:LayOutUtil.data.xid,cid:id,lhtml:lhtml,width:w+"",height:h+""};
		cn.com.easy.xbuilder.service.XService.setLHtml(param,function(e,d){
			if(callback){
				callback();
			}
		});
	},
	addL:function(){
		LayOutUtil.lindex = (LayOutUtil.lindex+1);
		var lid = StoreData.xid+'_'+LayOutUtil.lindex;
		//LayOutUtil.gridster.add_widget.apply(LayOutUtil.gridster,['<li id="'+lid+'"><div id="div_set_'+lid+'" class="component-set"><ol><li><a href="#" onclick="openEditePropertyView("'+StoreData.xid+'","'+lid+'","<e:url value="/pages/xbuilder/pagedesigner/ContainerProperty.jsp"/>");return false;">编辑</a></li><li><a href="javascript:void(0)" onclick="removeComponents("'+StoreData.xid+'","'+lid+'")">移除</a></li></ol></div><div  id="div_area_'+lid+'" class="component-area"><div  id="div_head_'+lid+'" class="component-head"><h3 id="div_head_title_'+lid+'">未命名标题</h3></div><div id="div_body_'+lid+'" class="component-con"></div></div></li>', 14, 14]);
		LayOutUtil.gridster.add_widget.apply(LayOutUtil.gridster,['<li id="'+lid+'"><b class="bTl"></b> <b class="bTr"></b> <b class="bBl"></b> <b class="bBr"></b><div id="div_set_'+lid+'" class="component-set"><ol><li class="icoComponentEditor"><a href="javascript:void(0)" onclick="LayOutUtil.componentEdit(\''+lid+'\');return false;" title="模板编辑">模板编辑</a></li><li class="icoSetContainer"><a href="javascript:void(0)" onclick="LayOutUtil.openEditePropertyView(\''+lid+'\');return false;" title="布局设置">布局设置</a></li><li class="icoEmptyContainer"><a href="javascript:void(0)" onclick="LayOutUtil.removeComponents(\''+lid+'\');return false;" title="布局清空">布局清空</a></li><li class="icoDeleteContainer"><a href="javascript:void(0)" onclick="LayOutUtil.removeL(\''+lid+'\');return false;" title="布局删除">布局删除</a></li></ol></div><div  id="div_area_'+lid+'" class="component-area"><div  id="div_head_'+lid+'" class="component-head"><h3 id="div_head_title_'+lid+'"><span id="div_head_title_'+lid+'_span">未命名标题</span></h3></div><div id="div_body_'+lid+'" class="component-con"></div></div></li>', 14, 14]);
		LayOutUtil.addLayoutLi(lid,$('#selectable_layout_id001').html());
	},
	removeL:function(contid){
		StoreData.curContainerId = contid;
		LayOutUtil.hasEvents(contid,'',function(){
			if($.trim($('#div_body_'+StoreData.curContainerId).html())!=""){
				$.messager.confirm('确认信息', '发现容器中已经设置内容，是否删除？', function(r){
					if (r){
						LayOutUtil.gridster.remove_widget($('#'+StoreData.curContainerId),false,function(){
							LayOutUtil.removeLayoutLi(StoreData.curContainerId,$('#selectable_layout_id001').html());
							StoreData.curContainerId = StoreData.curComponentId = LayOutUtil.tmpContainerId = LayOutUtil.tmpComponentId = '';
							LayOutUtil.data.container = StoreData.container = {};
						});
						$("#tools_panel .closeTools").click();
					}
				});
			}else{
				LayOutUtil.gridster.remove_widget($('#'+StoreData.curContainerId),false,function(){
					LayOutUtil.removeLayoutLi(StoreData.curContainerId,$('#selectable_layout_id001').html());
					StoreData.curContainerId = StoreData.curComponentId = LayOutUtil.tmpContainerId = LayOutUtil.tmpComponentId = '';
				});
				$("#tools_panel .closeTools").click();
			}
		});
	},
	addLayoutLi:function(lid,lhtml){
		LayOutUtil.data.lhtml = StoreData.lhtml = lhtml;
		var param = {xid:StoreData.xid,lid:lid,lhtml:lhtml};
		cn.com.easy.xbuilder.service.XService.addLayoutLi(param,function(data,exception){
			var $container=$("#container");   
			if($container[0]!=undefined&&$container[0].scrollHeight>$container[0].clientHeight){
				$("#tools_panel").css("right","14px");
			}else {
				$("#tools_panel").css("right","0");
			}
		});
	},
	addLayoutMultiLi:function(lhtml,contws){
		LayOutUtil.data.lhtml = StoreData.lhtml = lhtml;
		var param = {xid:StoreData.xid,lhtml:lhtml,contws:contws};
		cn.com.easy.xbuilder.service.XService.addLayoutMultiLi(param,function(data,exception){
			var $container=$("#container");   
			if($container[0]!=undefined&&$container[0].scrollHeight>$container[0].clientHeight){
				$("#tools_panel").css("right","14px");
			}else {
				$("#tools_panel").css("right","0");
			}
		});
	},
	removeLayoutLi:function(lid,lhtml){
		LayOutUtil.data.lhtml = StoreData.lhtml = lhtml;
		var param = {xid:StoreData.xid,lid:lid,lhtml:lhtml};
		cn.com.easy.xbuilder.service.XService.removeLayoutLi(param,function(data,exception){});
	},
	createLayout:function(param){
		var containerObj={};
		if(param=='layout_05'){
			containerObj.nums=2;
			containerObj.Layout=[1,1];
		}else if(param=='layout_02'){
			containerObj.nums=3;
			containerObj.Layout=[1,1,1];
		}else if(param=='layout_03'){
			containerObj.nums=4;
			containerObj.Layout=[1,0.5,0.5,1];
		}else if(param=='layout_06'){
			containerObj.nums=4;
			containerObj.Layout=[0.5,0.5,1,1];
		}else if(param=='layout_07'){
			containerObj.nums=5;
			containerObj.Layout=[0.5,0.5,0.5,0.5,1];
		}else if(param=='layout_08'){
			containerObj.nums=6;
			containerObj.Layout=[0.5,0.5,0.5,0.5,0.5,0.5];
		}else if(param=='layout_04'){
			containerObj.nums=3;
			containerObj.Layout=[1,0.5,0.5];
		}else if(param=='layout_01'){
			LayOutUtil.addL();
			return;
		}
		var base_num = LayOutUtil.data.lwidth*0.9*0.91/40;
		var num_base=Math.floor(base_num);
		var num_base2=Math.round(base_num);
		var temp = num_base2>num_base?1:0;
		
		var num;
		var contws = '';
		for(var i=1;i<=containerObj.nums;i++){
			LayOutUtil.lindex++;
			if(containerObj.Layout[i-1]==0.5){
				num=num_base;
			}else{
				num=LayOutUtil.data.contw-temp;
			}
			var lid=StoreData.xid+'_'+LayOutUtil.lindex;
			LayOutUtil.gridster.add_widget.apply(LayOutUtil.gridster,['<li id="'+lid+'"><b class="bTl"></b> <b class="bTr"></b> <b class="bBl"></b> <b class="bBr"></b><div id="div_set_'+lid+'" class="component-set"><ol><li class="icoComponentEditor"><a href="javascript:void(0);" onclick="LayOutUtil.componentEdit(\''+lid+'\');return false;" title="模板编辑">模板编辑</a></li><li class="icoSetContainer"><a href="javascript:void(0);" onclick="LayOutUtil.openEditePropertyView(\''+lid+'\');return false;" title="布局设置">布局设置</a></li><li class="icoEmptyContainer"><a href="javascript:void(0);" onclick="LayOutUtil.removeComponents(\''+lid+'\');return false;" title="布局清空">布局清空</a></li><li class="icoDeleteContainer"><a href="javascript:void(0);" onclick="LayOutUtil.removeL(\''+lid+'\');return false;" title="布局删除">布局删除</a></li></ol></div><div  id="div_area_'+lid+'" class="component-area"><div  id="div_head_'+lid+'" class="component-head"><h3 id="div_head_title_'+lid+'"><span  id="div_head_title_'+lid+'_span">未命名标题</span></h3></div><div id="div_body_'+lid+'" class="component-con"></div></div></li>',num, 14]);
			contws +=(num*20)+',';
		}
		LayOutUtil.addLayoutMultiLi($('#selectable_layout_id001').html(),contws);
	},
	setContainer:function(id){
		StoreData.curContainerId = id;
		LayOutUtil.data.container = StoreData.container = {id:id};
	},
	changeLayout:function(param){
		var layoutLen = $('#selectable_layout_id001 > ul > li').length;
		if(!!layoutLen){
			$.messager.confirm('确认信息', '我们发现当前已经存在布局，更换布局则会删除他们，确定继续吗？', function(r){
				if (r){
					StoreData.curContainerId = StoreData.curComponentId = LayOutUtil.tmpContainerId = LayOutUtil.tmpComponentId = '';
					LayOutUtil.data.container = StoreData.container = {};
			        LayOutUtil.gridster.remove_all_widgets(function(){
				        if(--layoutLen == 0){
				        	cn.com.easy.xbuilder.service.XService.removeAllLayoutLi(StoreData.xid,function(data,e){
								LayOutUtil.createLayout(param);
				        	});
			        	}
			        });
			        $("#tools_panel .closeTools").click();
				}
			});
		}else{
			LayOutUtil.createLayout(param);
			 $("#tools_panel .closeTools").click();
        }
	},
	
	setLType:function(t){
		LayOutUtil.data.ltype = StoreData.ltype = t;
		var param = {xid:StoreData.xid,ltype:t};
		cn.com.easy.xbuilder.service.XService.setLType(param,function(data,exception){});
		if(t == '2'){
			$.messager.show({
				title:'手机模式功能不支持提示',
				msg:'1、表格分页和导出。2、行间相邻相同数据合并。<br/>3、弹出页面功能。4、多列布局。',
				showType:'slide',
				width:300,
				height:130,
				style:{
					right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop+10,
					bottom:''
				}
			});
			$('li.switch-num2-item').each(function(i,item){
				$(item).attr('style','display:none;');
			});
			$('span.pop-links').attr('style','display:none;');
			if($("#legendPosDt")[0]!=undefined){
				$("#legendPosDt").hide();
			}
			if($("#legendPosDd")[0]!=undefined){
				$("#legendPosDd").hide();
			}
		}else if(t == '1'){
			$('li.switch-num2-item').each(function(i,item){
				$(item).attr('style','display:inline-block;');
			});
			$('span.pop-links').attr('style','display:inline-block;');
			if($("#legendPosDt")[0]!=undefined){
				$("#legendPosDt").show();
			}
			if($("#legendPosDd")[0]!=undefined){
				$("#legendPosDd").show();
			}
		}
		tableSwitchLType(t);//表格切换电脑手机
		treeTableSwitchLType(t);//下钻表格切换电脑手机
		crossTableSwitchLType(t);//交叉表格切换电脑手机
	},
	setComponent:function(contid,compid,ispop){
		LayOutUtil.tmpComponentId = compid;
		LayOutUtil.tmpContainerId = contid;
		if(!!ispop){
			contid += "_pop";
		}
		LayOutUtil.toggleButtons(contid,'show');
	},
	toggleButtons:function(contid,t){
		if(t =='show'){
			if($.trim($("#div_body_"+contid).html())==""){
				var $oo1 = $("#div_set_"+contid).show().children("ol").show();
				$oo1.children("li").hide();
				$oo1.children(".icoDeleteContainer").show();
			}else{
				$("#div_set_"+contid).show().find("ol").show().find("li").show();
			}
		}else{
			$("#div_set_"+contid).hide().find("ol").hide();
		}
	},
	liToggleButtons:function(contid,t){
		if(t =='show'){
			if($.trim($("#div_body_"+contid).html())==""){
				var $oo1 = $("#div_set_"+contid).show().children("ol").show();
				$oo1.children("li").hide();
				$oo1.children(".icoDeleteContainer").show();
			}
		}else{
			$("#div_set_"+contid).hide().find("ol").hide();
		}
	},
	resetPage:function (){
		$.messager.confirm('确认信息', '刷新页面，所有配置信息会被删除，是否继续？', function(r){
			if (r){
				$('#resetf').submit();
			}
		});
		$("#tools_panel .closeTools").click();
	},
	openEditePropertyView:function(contid){
		StoreData.curContainerId = contid;
		StoreData.curComponentId = LayOutUtil.tmpComponentId;
		showPropertyPage(contid,'container','pages/xbuilder/pagedesigner/ContainerProperty.jsp?containerId='+contid+'&viewId='+StoreData.xid)
	},
	componentEdit:function(contid) {
		StoreData.curContainerId = contid;
		StoreData.curComponentId = LayOutUtil.tmpComponentId;
		var tempUrl=StoreData.components[StoreData.curComponentId].propertyUrl;
		if(tempUrl.indexOf("pages/xbuilder/component/")>-1){
			tempUrl=tempUrl.substring(tempUrl.indexOf("pages/xbuilder/component/"));
			
		}
		showPropertyPage(contid,StoreData.curComponentId,tempUrl);
		//showPropertyPage(contid,StoreData.curComponentId,StoreData.components[StoreData.curComponentId].propertyUrl);
	},
	removeComponents:function(contid) {
		StoreData.curContainerId = contid;
		LayOutUtil.hasEvents(contid,'',function(){
			StoreData.curComponentId = LayOutUtil.tmpComponentId = "";
			cn.com.easy.xbuilder.service.XComponentService.clearContainer(StoreData.xid,StoreData.curContainerId,function(data,exception){
				if (exception != undefined) {
					$.messager.alert("提示信息！",exception,"error");
				} else {
					$("#div_body_" + StoreData.curContainerId).empty();
					$("#div_head_title_" + StoreData.curContainerId).html("<span>未命名标题</span>");
					$("#div_head_" + StoreData.curContainerId).html($("#div_head_title_" + StoreData.curContainerId).prop("outerHTML"));
					$("#div_head_title_" + StoreData.curContainerId).show();
					LayOutUtil.setLHtml($("#selectable_layout_id001").html());
				}
			});
			$("#tools_panel .closeTools").click();
		});
	},
	hasEvents:function(contid,compid,callback){
		cn.com.easy.xbuilder.service.XService.hasEvents(StoreData.xid,contid,compid,function(data,exception){
			if(data == ''){
				if(callback){
					callback();
				}
			}else{
				$.messager.alert('提示信息','我们发现容器中"'+data+'"，请先删除动作(设置动作为无)。','error');
			}
		});
	},
	uuid:function() {
		var s = [];
		var hexDigits = "0123456789abcdef";
		for (var i = 0; i < 36; i++) {
			s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
		}
		s[14] = "4";
		s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);
		s[8] = s[13] = s[18] = s[23] = "_";
	
		var uuid = s.join("");
		return uuid;
	},
	openNewPage:function(url){
		/*
		var form=$('<form action="'+url+'" method="post" target="_bland"> </form>');
		form.appendTo('body');
		form[0].submit();
		*/
		var openLink = $("<a href='"+url+"' target='_blank'></a>");
		openLink[0].click();
	}
};
$(function(){
	$('#selectable_layout_id001').delegate('li','hover', function(event){
		if(event.type == "mouseleave" ){
			LayOutUtil.liToggleButtons($(this).attr('id'),'hide');
		}
		if(event.type == "mouseenter" ){
			LayOutUtil.liToggleButtons($(this).attr('id'),'show');
		}
	});
    $('#selectable_layout_id001').delegate('li','click', function(){
		$('#selectable_layout_id001 li').addClass('default-border').removeClass('selected-border');
		$(this).addClass('selected-border');
		LayOutUtil.setContainer($(this).attr("id"));
		$("#tools_panel .closeTools").click();
    });   
});
/*---------------------------------------------------------------*/
$(function(){
    //右侧工具栏弹出toolsPanel();
    //工具栏tabs
    tabPanel();
    guideToggle();
   	innerHeight();
   	$(window).resize(function(){
   		 innerHeight();
   	});
	/*
	$("#container").resize(function(){
  
	if($(this).height()-24 > $("#tools_panel").height()){
  		$("#tools_panel").css("right","21px");
   		}
   else {
   		$("#tools_panel").css("right","7px");
   	}
	})
	*/
    $('.radioGroup a').click(function(){
        $(this).addClass('cur').siblings().removeClass('cur');
    });
    $('.serchIndex').click(function(){
		$('.serchIndex .serchSet, .serchIndex .bTl, .serchIndex .bTr, .serchIndex .bBl, .serchIndex .bBr ').show();
		$(this).addClass('tg');
	});
	$('.group.guideBox, #header').click(function(){
		$('.serchIndex .serchSet, .serchIndex .bTl, .serchIndex .bTr, .serchIndex .bBl, .serchIndex .bBr ').hide();
		$('.serchIndex').removeClass('tg');
	});
	
	var oInput = document.getElementById("autoInput");
	checkLength(oInput);
	
});
       
/**
  *切换效果
  */
function tabPanel(){
     var $tab_li = $('.tabTiele li');
     
     $tab_li.click(function(){
         $(this).addClass('cur').siblings().removeClass('cur');
         var index = $tab_li.index(this);
         $('.tabBox .tabInner').eq(index).show().siblings(".tabInner").hide();
     });
     $(document).bind("click",function(e){
         var target = $(e.target);
         if(target.closest("div#tabTools").length == 0){
         	if(!(target.parents("ul").attr("id")=='cubeMemuList'||target.attr("id")=='jpwClose')){
         		$(".tabBox .tabInner").hide();
         	}
             
             $('.tabTiele li').removeClass('cur');
         }
     });
 }
       
function guideToggle(){
    var $guide_li= $(".toggleShow li");
    $guide_li.click(function(){
        var $gudedBox = $("#guideOut");
        var index = $guide_li.index(this);
        var aId=$(this).find("a").eq(0).attr("id");
        if(aId=='pcToggle'){
        	$(this).addClass('cur').siblings().removeClass('cur');
        		LayOutUtil.setLType('1');
        		$gudedBox.removeClass("phone_guide").addClass("pc_guide");
        		$("#con_panel").removeClass("phoneGuideBg").resize();
        		$gudedBox.removeAttr("style"); 
        		$gudedBox.unbind("mousedown");
        		$gudedBox.unbind("mouseMove");
        		$gudedBox.unbind("mouseUp");
        }else if(aId=='phoneToggle'){
        	$(this).addClass('cur').siblings().removeClass('cur');
        		LayOutUtil.setLType('2');
        		/*$gudedBox.removeClass("pc_guide").addClass("phone_guide");
        		$("#con_panel").addClass("phoneGuideBg").resize();
        		$(function(){
        			bindResize(document.getElementById('guideOut'));
        		});
			    function bindResize(el){
				    var els = el.style,
				    x = 0;
				    $(el).mousedown(function (e){
				        x = e.clientX - el.offsetWidth,
				        el.setCapture ? (
				                el.setCapture(),
				                el.onmousemove = function (ev){
				                    mouseMove(ev || event);
				                },
				                el.onmouseup = mouseUp
				                ) : (
				                $(document).bind("mousemove", mouseMove).bind("mouseup", mouseUp)
				                );
				        e.preventDefault();
				        function mouseMove(e){
						    els.width = e.clientX - x + 'px';
						}
						function mouseUp(){
						    el.releaseCapture ? (
						        el.releaseCapture(),
						                el.onmousemove = el.onmouseup = null
						        ) : (
						        $(document).unbind("mousemove", mouseMove).unbind("mouseup", mouseUp)
						        );
						     
						}
				    });
				}*/
        }
        $('.pc_guide').eq(index).show().siblings(".guideBox").hide();
    });
}
       

       
       
 //右侧高度计算
function toolsPanel(){
  if($(".panel.combo-p").size()>0){
	$(".panel.combo-p").hide();//隐藏combox的panel
  }
  var centerHeight = $("body").height()-50;
  $("#tools_panel").height(centerHeight-14);
  $(".tools_level_1_inter .bottom_com").height(centerHeight-88);
  $("#propertiesPage").height(centerHeight-66);
  var $container=$("#container");   
	if($container[0]!=undefined&&$container[0].scrollHeight>$container[0].clientHeight){
		$("#tools_panel").css("right","14px");
	}
	else {
		$("#tools_panel").css("right","0");
	}
   $("#tools_panel .closeTools").click(function(){
   		hideToolsPanel();
   });
   $("#tools_panel").show();
   $("#tools_panel").css('z-index','9000');
};
function showToolsPanel(){
	if($(".panel.combo-p").size()>0){
		$(".panel.combo-p").hide();//隐藏combox的panel
	}
	$("#tools_panel").show();
	$("#tools_panel").css('z-index','9000');
}
function hideToolsPanel(){
	$(".tools_level_1").hide();
	if($(".panel.combo-p").size()>0){
		$(".panel.combo-p").hide();//隐藏combox的panel
	}
	$("#tools_panel").hide();
	$("#tools_panel").css('z-index','2');
}
  
function innerHeight(){
	var centerHeight = $("body").height()-64;
	$("#con_panel").css("min-height",centerHeight);
}

function setProPageTitle(title){
	$("#tools_panel h3").html(title);
}
function checkLength(which) {
    var maxchar=100; 
	var oTextCount = document.getElementById("char"); 
	iCount = which.value.replace(/[^\u0000-\u00ff]/g,"aa").length; 
    if(iCount<=maxchar) 
    { 
		oTextCount.innerHTML = "<font color=#FF0000>"+ iCount+"</font>"; 
    	which.size=iCount+4; 
    }else{
    	$.messager.alert("提示信息！","请不要超过"+maxchar,"error");
    }
} 
function focusWords(which){
	if(which.value=="未命名报表"){
		which.value="";
	}
}
function blurWords(which){
	if(which.value==""){
		which.value="未命名报表";
	}else{
		LayOutUtil.setName(which.value);
	}
}
function tableShowColSelectorWin(){
	$("#header, #guideOut, .gridster").click(function(){
		tableHideColSelectorWin();
	});
}
function tableHideColSelectorWin(){
  	$("div[kpiSelectorDiv='true']").animate({right:"0"});
  	$("div[kpiSelectorDiv='true']").hide();
}

function treeTableShowColSelectorWin(){
	$("#header, #guideOut, .gridster").click(function(){
		treeTableHideColSelectorWin();
	});
}
function treeTableHideColSelectorWin(){
	$("div[kpiSelectorDiv='true']").animate({right:"0"});
  	$("div[kpiSelectorDiv='true']").hide();
}
function container_fun_edit(containerId,componentId){
	var initData = {
					showPalette: true,
					preferredFormat: "hex",
					showInput: true,
				    palette: [
				        ['#cc0000', '#ff2845', '#e000fc'],
				        ['#fc0088', '#ff4200', '#ffa200'],
				        ['#00bedc', '#00d744', '#acfd00'],
				        ['#e5dc0c', '#006be3', '#00bedc']
				    ]
				};
	cn.com.easy.xbuilder.service.XComponentService.getContainerAllInfoById(StoreData.xid,containerId,'',false,
		function(data, exception) {
			if (exception != undefined) {
				$.messager.alert("提示信息！",exception,"error");
			} else {
				if (data != "0") {//没有组件,直接load
					var containerObj=$.parseJSON(data);//取到容器对象
					var containerTitleObj=$('#containerTitle');
					if(containerObj.title!=undefined&&containerObj.title!=null&&containerObj.title!=''&&containerObj.title!='null'){
						var stylecls = containerObj.styleclass;
						if(stylecls){
							var cssArr = stylecls.split(',');
							initData.color = cssArr[3];
							$("#titleColor").spectrum(initData);
						}else{
							$("#titleColor").spectrum(initData);
						}
					}else{
						$("#titleColor").spectrum(initData);
					}
				}else{
					$("#titleColor").spectrum(initData);
				}
			}
		});
}

function initDimensionDroppable(){
	$("p[id='dimsion']").droppable({
		onDragEnter:function(e,source){
			$(source).draggable('options').cursor='auto';
		},
		onDragLeave:function(e,source){
			$(source).draggable('options').cursor='not-allowed';
		},
		onDrop:function(e,source){
			if(StoreData.dsType=="2"){
				var kpiSelector = null;
				if($("#container_conditionKpiSelector").css("display")!="none"){
					kpiSelector = conditionKpiSelector;
				}else{
					$(".kpiSelectorCon").each(function(index,item){
						if($(item).css("display")!="none"){
							var id = $(item).attr("id");
							id = id.substring("container_".length);
							kpiSelector = window[id];
							return false;
						}
					});
				}
				var category = kpiSelector.getCurCategory();
				category = "mykpi"?"kpi":category;
				enterDim([kpiSelector.currentItem],category);
			}else{
				setRsList([conditionSqlSelector.currentItem],category);
			}
		}
			
	});
}
//初始化数据魔方菜单列表
var CubeMenuData = [];
var isFirstDo = 1;//第一次进入指标库模式
function initCubeMenu(){
	kpiSelectorService.getCubeList(LayOutUtil.data.userId,function(dataArr,exception){
		if(exception != undefined){
			$.messager.alert("提示信息！","获取数据魔方发生错误："+exception,"error");
		}else{
			dataArr.splice(0,1);
			CubeMenuData = dataArr;
			var tempStr = '<li class="dateSearch"><p class="searchDate"><input type="text"  id="cubeName" name="cubeName"/><a href="javascript:void(0)" onclick="doCubeMenuQuery()">查询</a></p><p>注：用于数据集查询</p></li>';
			cn.com.easy.xbuilder.service.XService.getCubeId({xid:StoreData.xid},function(data,exception){
				$.each(dataArr,function(index,item){
					if(item.ID==data){//选中
						if(item.TYPE=='1'){
					    	tempStr += '<li><a class="hover" id="cubeMune_'+item.ID+'" cubeId="'+item.ID+'" title="'+item.TEXT+'" href="javascript:void(0)" text="'+item.TEXT+'" onclick="doSelectCube(this)"><span>'+item.DES+'</span><strong>日</strong></a></li>';
						}else{
					    	tempStr += '<li><a class="hover" id="cubeMune_'+item.ID+'" cubeId="'+item.ID+'" title="'+item.TEXT+'" href="javascript:void(0)" text="'+item.TEXT+'" onclick="doSelectCube(this)"><span>'+item.DES+'</span><strong>月</strong></a></li>';
						}
				    	isFirstDo++;
					}else if(item.TYPE=='1'){//日账期
			    		tempStr += '<li class="tIco01"><a id="cubeMune_'+item.ID+'" cubeId="'+item.ID+'" title="'+item.TEXT+'" href="javascript:void(0)" text="'+item.TEXT+'" onclick="doSelectCube(this)"><span>'+item.DES+'</span><strong>日</strong></a></li>';
					}else{//月账期
			    		tempStr += '<li class="tIco02"><a id="cubeMune_'+item.ID+'" cubeId="'+item.ID+'" title="'+item.TEXT+'" href="javascript:void(0)" text="'+item.TEXT+'" onclick="doSelectCube(this)"><span>'+item.DES+'</span><strong>月</strong></a></li>';
			    	}
			    });
			    $("#cubeMemuList").html(tempStr);
				StoreData.cubeId = data;
			});
		}
	});
}
//查询魔方
function doCubeMenuQuery(){
	var cubeName = $('#cubeName').val();
	$.each(CubeMenuData,function(index,item){
		if((item.TEXT.toUpperCase()).indexOf(cubeName.toUpperCase())>-1){
			$('#cubeMune_'+item.ID).show();
		}else{
			$('#cubeMune_'+item.ID).hide();
		}
    });
}
//选择魔方
var lastCubeId$ = null;
function doSelectCube(obj){
	var cubeId = $(obj).attr('cubeId');
	if(cubeId==lastCubeId$){//与上次选择用一个魔方不提示
		return false;
	}
	cn.com.easy.xbuilder.service.XService.getComponentsListSize({xid:StoreData.xid},function(data,exception){
		if(data>0&&isFirstDo!=1){
			$(".tabBox .tabInner").hide();
			$.messager.confirm("确认信息", "此报表已有组件或查询条件使用了该魔方，切换魔方会清空所有组件和查询条件，确定继续吗？", function (r) {
				if(r){
					lastCubeId$ = cubeId;//记录是不是点击上次的魔方
					LayOutUtil.setCubeId(cubeId);
					StoreData.cubeId = cubeId;
					cn.com.easy.xbuilder.service.XService.removeComponentsAndDimsions({xid:StoreData.xid},function(data,exception){
						var containerIdList = data.containerIdList;
						var dimIdList = data.dimIdList;
						
						for(var i=0;i<containerIdList.length;i++){
							$("#div_body_" + containerIdList[i]).empty();
							$("#div_head_title_" + containerIdList[i]).html("<span>未命名标题</span>");
							$("#div_head_" + containerIdList[i]).html($("#div_head_title_" + StoreData.curContainerId).prop("outerHTML"));
							$("#div_head_title_" + containerIdList[i]).show();
							LayOutUtil.setLHtml($("#selectable_layout_id001").html());
						}
						$propertiesPage = autoAppendObj("dimproperties");
						autoAppendObj("dimproperties").hide();
						$propertiesPage.empty(); 
						hideToolsPanel();//隐藏左边框
						for(var i=0;i<dimIdList.length;i++){
							if(rsList.length > 0) {
								rsList = removeObj(rsList,dimIdList[i]);
							}
						}
						rsList = [];
						editDim();
						window.setTimeout(function(){
							$('#'+StoreData.xid+'_1').addClass('default-border').removeClass('selected-border');
							$('#'+StoreData.xid+'_1').addClass('selected-border');
							LayOutUtil.setContainer(StoreData.xid+'_1');
							checkContainer('DDATAGRID','基础表格','DATAGRID','pages/xbuilder/component/datagrid/Template.jsp','pages/xbuilder/component/datagrid/kpi/Properties.jsp',compClass.DATAGRID);
							autoInitDim(cubeId);//自动注入已添加的查询条件
						},400);
					});
					changeHover(obj);
				}
			});
		}else{
			StoreData.cubeId = cubeId;
			LayOutUtil.setCubeId(cubeId);
			lastCubeId$ = cubeId;//记录是不是点击上次的魔方
			changeHover(obj);//改变选中状态
			autoInitDim(cubeId);//自动注入已添加的查询条件
		}
		isFirstDo++;
	});
}
//修改魔方选中状态
function changeHover(obj){
	$(obj).attr('class','hover');//改变选中状态
 	$(obj).parent().prevAll().each(function(i,v){
 		$(v).children().removeClass("hover");
 	});
 	$(obj).parent().nextAll().each(function(i,v){
 		$(v).children().removeClass("hover");
 	});
}
//初始化指标库魔方下拉列表
function initCubeComb(){
	kpiSelectorService.getCubeList(LayOutUtil.data.userId,function(dataArr,exception){
		if(exception != undefined){
			$.messager.alert("提示信息！","获取数据魔方发生错误："+exception,"error");
		}else{
			$("#cubeComb").combobox({
				data:dataArr,
				valueField:'ID',
				textField:'TEXT',
				panelHeight:'auto',
				onSelect:function(record){
					if(StoreData.cubeId!="-1"){
						cn.com.easy.xbuilder.service.XService.getComponentsListSize({xid:StoreData.xid},function(data,exception){
							if(data>0){
								$.messager.confirm('确认信息', '此报表已有组件或查询条件使用了该魔方，切换魔方会清空所有组件和查询条件，确定继续吗？', function(r){
									if(r){
										LayOutUtil.setCubeId(record.ID);
										StoreData.cubeId = record.ID;
										cn.com.easy.xbuilder.service.XService.removeComponentsAndDimsions({xid:StoreData.xid},function(data,exception){
											var containerIdList = data.containerIdList;
											var dimIdList = data.dimIdList;
											for(var i=0;i<containerIdList.length;i++){
												$("#div_body_" + containerIdList[i]).empty();
												$("#div_head_title_" + containerIdList[i]).html("<span>未命名标题</span>");
												$("#div_head_" + containerIdList[i]).html($("#div_head_title_" + StoreData.curContainerId).prop("outerHTML"));
												$("#div_head_title_" + containerIdList[i]).show();
												LayOutUtil.setLHtml($("#selectable_layout_id001").html());
											}
											$propertiesPage = autoAppendObj("dimproperties");
											autoAppendObj("dimproperties").hide();
											$propertiesPage.empty(); 
											hideToolsPanel();//隐藏左边框
											for(var i=0;i<dimIdList.length;i++){
												if(rsList.length > 0) {
													rsList = removeObj(rsList,dimIdList[i]);
												}
											}
											editDim();
										});
								    }else{
								    	$('#cubeComb').combobox('setValue', StoreData.cubeId);
								    }
							    });
							}else{
								StoreData.cubeId = record.ID;
								LayOutUtil.setCubeId(record.ID);
							}
						});
					}else{
						StoreData.cubeId = record.ID;
						LayOutUtil.setCubeId(record.ID);
					}
					if(window["tableHideColSelectorWin"]!=undefined){
						tableHideColSelectorWin();//指标库类型时，关闭指标列表窗口
					}
				},
				onLoadSuccess:function(){
					cn.com.easy.xbuilder.service.XService.getCubeId({xid:StoreData.xid},function(data,exception){
						$('#cubeComb').combobox('setValue', data);
						StoreData.cubeId = data;
					});
				}
			});
		}
	});
	
}

function setDescribe(){
	var info = {};
	info.report_id=StoreData.xid;
	info.eaction="REPORTLOAD";
	$("#reportDescDialog").dialog("open");
	$("#report_id").val(StoreData.xid);
	var postUrl=appBase+"/pages/xbuilder/pagemanager/ReportActionAccount.jsp";
	$.post(postUrl,info,function(data){
		if($.trim(data)!=''){
			$("#reportDescForm").form("load",data[0]);
		}else{
			$("#user_id").val("");
			$("#user_name").val("");
			$("#department_desc").val("");
			$("#department_code").val("");
			$("#report_desc").val("");
			$("#report_id").val(StoreData.xid);
		}
	},"json");
	$("#tools_panel .closeTools").click();
}

//用户信息确认按钮事件
function saveUser(){
	var selected = $('#userTable').datagrid('getSelected');
	if(selected==null){
		$.messager.alert("提示信息！","请选择一个用户！","info");
	}else{
		$("#user_id").val(selected.USER_ID);
		$("#user_name").val(selected.USER_NAME);
		$("#userInfoDialog").dialog('close');
	}
}

//报表描述提交按钮事件
function saveReport(){
	$("#reportDescForm").submit();
}

function getUserName(){
	$("#userInfoDialog").dialog('open');
	$("#user_name").blur();
	$("#userName").val("");
	//$("#userTable").datagrid("options").queryParams=$("#userName").val();
	$('#userTable').datagrid("load",$("#userTable").datagrid("options").queryParams);
}

function doQueryUser(){
	var info = {};
	info.userName = $("#userName").val();
	//$("#userTable").datagrid("options").queryParams=info;
	$("#userTable").datagrid("load",info);
}

function getDepName(){
	 $("#depTreeDialog").dialog('open');
}

function slectDep(node){
	$("#department_code").val(node.id);
	$("#department_desc").val(node.text);
	$("#depTreeDialog").dialog('close');
}