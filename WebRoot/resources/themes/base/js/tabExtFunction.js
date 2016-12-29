 			$(document).ready(function () {
					            //监听右键事件，创建右键菜单
					            $('#TabDiv').tabs({
					                onContextMenu:function(e, title,index){
					                    e.preventDefault();
					                   // if(index>0){
					                        $('#menu_context').menu('show', {
					                            left: e.pageX,
					                            top: e.pageY
					                        }).data("tabTitle", title);
					                   // }
					                }
					            });
					            //右键菜单click
					            $("#menu_context").menu({
					                onClick : function (item) {
					                    closeTab(this, item.name);
					                }
					            });
						 });
						 
						//删除Tabs
					        function closeTab(menu, type) {
					            var allTabs = $("#TabDiv").tabs('tabs');
					            var allTabtitle = [];
					            $.each(allTabs, function (i, n) {
					                var opt = $(n).panel('options');
					                if (opt.closable)
					                    allTabtitle.push(opt.title);
					            });
					            var curTabTitle = $(menu).data("tabTitle");
					            var curTabIndex = $("#TabDiv").tabs("getTabIndex", $("#TabDiv").tabs("getTab", curTabTitle));
					            switch (type) {
					                case 2:
					                    for (var i = 0; i < allTabtitle.length; i++) {
					                        $('#TabDiv').tabs('close', allTabtitle[i]);
					                    }
					                    break;
					                case 3:
					                    for (var i = 0; i < allTabtitle.length; i++) {
					                        if (curTabTitle != allTabtitle[i])
					                            $('#TabDiv').tabs('close', allTabtitle[i]);
					                    }
					                    $('#TabDiv').tabs('select', curTabTitle);
					                    break;
					                case 4:
					                    for (var i = curTabIndex+1; i < allTabtitle.length; i++) {
					                        $('#TabDiv').tabs('close', allTabtitle[i]);
					                    }
					                    $('#tt').tabs('select', curTabTitle);
					                    break;
					                case 5:
					                    for (var i = 0; i < curTabIndex; i++) {
					                        $('#TabDiv').tabs('close', allTabtitle[i]);
					                    }
					                    $('#TabDiv').tabs('select', curTabTitle);
					                    break;
					            }

					        }