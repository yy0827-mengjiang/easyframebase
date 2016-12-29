/*
 * 董一伯 2016年2月3日提交，修改菜单导航移动问题
*/
var menuMaxValue=1600;
var dline = 10;//col rownum
var slideFlag='left';
var tempJsonData=[];
var poor = 0;
var scroll = 0;
var menuStrMaxLength=0;//菜单名称最大长度,0表示为不限制
var menuAllLength=0;//所有菜单得总宽度
var menuShowLength=0;//菜单显示宽度
jQuery(function(){
		var divWidth=0;
		var dropdownMenuArray=menuJson;
		if(dropdownMenuArray==undefined||dropdownMenuArray==null||dropdownMenuArray==''){
			dropdownMenuArray=[];
		}
		//console.log(menuJson);
    	jQuery("#navMenuDropdown").showMenu(
    		menuJson
    		);
    	divWidth=0;
    	//获取菜单导航得总长度。也就是每个菜单目录得宽得和
    	jQuery("#nav").find("li").each(function(i,e){
			//alert($(e).width());
			divWidth=divWidth+$(e).width();
		
		});	
    	//alert("divWidth"+divWidth);
		/*if(divWidth<$(window).width()){
			divWidth=$(window).width();
			$('a[class="scrollerLeftDropdown"]').hide();
			$('a[class="scrollerRightDropdown"]').hide();
		}*/
		//divWidth=divWidth+100;
    	menuAllLength=divWidth;
		//alert(menuMaxValue);
    	//页面左侧“中国电信”得宽度
    	var leftWidth=jQuery(".DropdownH1").width();
    	//页面右侧管理员等模块得总宽度
    	var rightWidth=jQuery("#globalMenu").width();
    	//浏览器页面宽度
    	var windowWidth=$(window).width();
    	//获取菜单目录得宽度，也就是菜单显示得宽度
    	var menuWidth=windowWidth-leftWidth-rightWidth-60;
    	menuShowLength=menuWidth;
    	//alert("windowWidth:"+windowWidth+"   leftWidth:"+leftWidth+"    rightWidth:"+rightWidth+"    menuWidth:"+menuWidth);
		jQuery("#nav").css("width",menuWidth);
		//jQuery("#nav").css("width","200");
		//判断是否显示移动图标
		if(menuWidth<divWidth){
			$('a[class="scrollerLeftDropdown"]').show();
			$('a[class="scrollerRightDropdown"]').show();
		}else{
			$('a[class="scrollerLeftDropdown"]').hide();
			$('a[class="scrollerRightDropdown"]').hide();
		}
    	jQuery("#navMenuGroup .subs ul:last-child").css("border-right","0");
		jQuery("#nav li").hover(function(event){
			$(this).css("background-color","#244880");
			liHover(this,event);
		},function() {
			$(this).css("background-color","#2b579a");
		  });
		
		
    		
});
function liHover(obj,event){
	//var startTime=new Date().getTime();
	//var endTime=startTime;
	
	var $obj=jQuery(obj);
	//console.log($obj);
	if($obj.attr("isLevel1")=='1'){
		tempJsonData=[];
		for(var x=0;x<menuJson.length;x++){
			if(menuJson[x].ROOT_ID==$obj.attr("id")){
				tempJsonData.push(menuJson[x]);
			}
		}
	}
	
	if($('#subDiv_'+$obj.attr("id")).size()!=0){
		return false;
	}
	//console.log($obj.attr("id"));
	//endTime=new Date().getTime();
	//console.log("end0:"+(endTime-startTime));
	//startTime=endTime;
	var childrenArray=[];
	for(var a=0;a<tempJsonData.length;a++){
		if(tempJsonData[a].PID==$obj.attr("id")){
			childrenArray.push(tempJsonData[a]);
		}
	}
	
	var htmlStr="";
	if(childrenArray.length>0){
		htmlStr='<div class="subs Lright" id="subDiv_'+$obj.attr("id")+'"><ul>';
		var liMenuName='';
		for(var b=0;b<childrenArray.length;b++){
			liMenuName=childrenArray[b].NAME;
			htmlStr+='<li id='+childrenArray[b].ID+' liShow="'+liMenuName+'">';
			if(menuStrMaxLength!=0&&liMenuName.length>menuStrMaxLength){
				//liMenuName=liMenuName.substring(0,(menuStrMaxLength-3))+'...';
				liMenuName=liMenuName.substring(0,(menuStrMaxLength))+'...';
			}
			htmlStr+="<a href=\"javascript:void(0);\" onClick=\"goUrl('"+childrenArray[b].ID+"','"+childrenArray[b].NAME+"','"+childrenArray[b].TYPE+"','"+childrenArray[b].URL+"','"+childrenArray[b].STATE+"')\">";
			if(childrenArray[b].ISLEAF=='0'){//is not leaf
				htmlStr+="<span>"+liMenuName+"</span>";
			}else{
				htmlStr+=liMenuName;
			}
			
			htmlStr+="</a>";
			htmlStr+='</li>';
			if((b+1)%dline==0){
				htmlStr+='</ul><ul>';
			}
		}
		htmlStr+='</ul></div>';
		
		$obj.find("div").remove();
		$obj.append(htmlStr);
		var subsWidth = 0;
		$obj.find("div").find("ul").each(function(i,o){
			subsWidth += $(o).width()+2;
		});
		$obj.find(".subs").css("width",subsWidth);
		
		if($obj.parent().eq(0).attr("id")=='nav'){
			$("#nav .subs:not('#subDiv_"+$obj.attr("id")+"')").remove();
			if(event.pageX>$(window).width()/2){
				slideFlag='right';
			}else{
				slideFlag='left';
			}
		
		}
		
		var $navSubs=$("#nav").find(".subs");
		//alert(slideFlag);
		if(slideFlag=='left'){
			$navSubs.removeClass("Sright");
			$navSubs.addClass("Sleft"); 
		}else{
			$navSubs.removeClass("Sleft");
			$navSubs.addClass("Sright"); 
		}
		
		jQuery(".subs").siblings("a").addClass("hoverLink");
		$obj.find("li").hover(function(event){
			liHover(this,event);
		});
		
		
		jQuery(".hoverLink").next(".subs").addClass("hoverBox");
		var $hoverBoxSubs=jQuery(".hoverBox .subs");
		$hoverBoxSubs.mouseover(function(){
			jQuery(this).siblings("a").addClass("hoverLinkOn");
		});
		
		$hoverBoxSubs.mouseout(function(){
			jQuery(this).siblings("a").removeClass("hoverLinkOn");
		});
		
		$obj.find("li").mouseover(function(e){
			//$("#divID").css("background-color","red");
			
			$(this).css("backgroud-color","red");
			if($(this).attr("liShow").length>menuStrMaxLength&&menuStrMaxLength!=0){
				var tooltipForFrameMenu = "<div id='tooltipForFrameMenu' width='100px' height='12px' style='position:absolute;z-index:2000;border:solid #aaa 1px;background-color:#F9F9F9;color:#111'>"+$(this).attr("liShow")+ "</div>";
				if($("#tooltipForFrameMenu").size()>0){
					$("#tooltipForFrameMenu").remove();
				}
				$("body").append(tooltipForFrameMenu); 
				//alert(tooltipForFrameMenu);
				$("#tooltipForFrameMenu").css({
					"top" :(e.pageY +15)+ "px", 
					"left" :(e.pageX+15) + "px" 
				}); 
				$(obj).mouseout(function(){
					$("#tooltipForFrameMenu").remove(); 
				}); 
			}
		}); 
		
	}
	//alert(childrenArray.length);
}
function scollLeftForDropDown(){
	
	var scollValue=0;
	var off=$("#nav").offset();
	//alert(Math.abs((off.left-170)));
	if((off.left-170)<0){
		scollValue=parseInt((off.left-170))+50;
		$("#nav").animate({
			"left": (scollValue)
		},100);
	}
}

function scollRightForDropDown(){
	var scollValue=0;
	//alert("menuAllLength"+menuAllLength+"   menuShowLength:"+menuShowLength);
	//定义向左移动得界限，实际上就是隐藏得菜单得宽度
	var limit_left=menuAllLength-menuShowLength;
	var off=$("#nav").offset();
	//定义已移动得数值，实际已经向左移动得数值
	var move_left=parseInt(Math.abs((off.left-170)));
	//alert("move_left:"+move_left+"   limit_left:"+limit_left);
	if(move_left<limit_left){
		scollValue=(off.left-170)-50;
		//移动得方法
		$("#nav").animate({
			"left": scollValue
		},100);
	}
	
	
}
 (function(jQuery){
	jQuery.fn.showMenu=function(data){
		if(data==undefined){
			return false;
		}
		//var timestamp1 = new Date().getTime();
		if(typeof data=="string"){
			data = eval("("+data+")");
		}
		var jQuerythis=jQuery(this);
		var jQuerycoldrop=jQuery(document.createElement("ul")).attr("id","nav");
		var ids=jQuerythis.attr("id");
		jQuerythis.append(jQuerycoldrop);
		var liMenuName='';
		var li_index=0;
		var li_width=0;
		for(var i=0;i<data.length;i++){
			var jQueryitem=jQuery(document.createElement("li"));
			if(data[i].PID == null || data[i].PID == '' || data[i].PID == undefined|| data[i].PID == '0'){
				
				jQuerycoldrop.append(jQueryitem);
				liMenuName=data[i].NAME;
				if(data[i].ISLEAF=='0'){//is not leaf
					
					jQueryitem.html("<a href=\"javascript:void(0);\" onClick=\"goUrl('"+data[i].ID+"','"+data[i].NAME+"','"+data[i].TYPE+"','"+data[i].URL+"','"+data[i].STATE+"')\"><span>"+data[i].NAME+"</span></a>").attr({"id":data[i].ID}).attr({"isLevel1":"1"});
				}else{
					
					jQueryitem.html("<a href=\"javascript:void(0);\" onClick=\"goUrl('"+data[i].ID+"','"+data[i].NAME+"','"+data[i].TYPE+"','"+data[i].URL+"','"+data[i].STATE+"')\">"+data[i].NAME+"</a>").attr({"id":data[i].ID}).attr({"isLevel1":"1"});
				}
				//alert(jQueryitem.width());
				li_width+=jQueryitem.width();
				if(li_index==0){
					$("#nav li").eq(0).width(jQueryitem.width());
					$("#nav li").eq(0).css("left","0px");
					
				}else{
					//alert(li_width-jQueryitem.width());
					$("#nav li").eq(li_index).width(jQueryitem.width());
					$("#nav li").eq(li_index).css("left",(li_width-jQueryitem.width()));
				}
			
				li_index++;
				
			}
		}
		//var dddt = (new Date().getTime()-timestamp1)/1000;
		//console.log('time='+dddt);
	}	
		
 })(jQuery);
 function goUrl(id,name,type,url,state){
	if(url == ""){
		return;
	}
   	var h = window.screen.height;
   	var w = window.screen.width;
   	openBaseState0(id,name,url,state,type);
 }
