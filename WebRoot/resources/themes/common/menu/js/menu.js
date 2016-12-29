var menuMaxValue=2000;
var dline = 10;//col rownum
var slideFlag='left';
var tempJsonData=[];
var menuStrMaxLength=0;//菜单名称最大长度,0表示为不限制
jQuery(function(){
		var divWidth=30;
		var dropdownMenuArray=menuJson;
		if(dropdownMenuArray==undefined||dropdownMenuArray==null||dropdownMenuArray==''){
			dropdownMenuArray=[];
		}
		
    	jQuery("#nav-menu-dropdown").menu(
    		menuJson
    		);
    	divWidth=30;
    	jQuery("#nav").find("li").each(function(i,e){
			//alert($(e).width());
			divWidth=divWidth+$(e).width()+35;
		
		});	
		if(divWidth<$(window).width()){
			divWidth=$(window).width();
			$('a[class="scroller-left-dropdown"]').hide();
			$('a[class="scroller-right-dropdown"]').hide();
		}
		divWidth=divWidth+100;
		menuMaxValue=divWidth-$(window).width()-40;
		jQuery("#nav-menu-dropdown").css("width",divWidth);
    	jQuery("#nav .subs ul:last-child").css("border-right","0");
		jQuery("li").hover(function(event){
			liHover(this,event);
		});
		
    		
});
function liHover(obj,event){
	//var startTime=new Date().getTime();
	//var endTime=startTime;
	
	var $obj=jQuery(obj);
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
			//alert($("#nav .subs:not('#subDiv_"+$obj.attr("id")+"')").size());
			$("#nav .subs:not('#subDiv_"+$obj.attr("id")+"')").remove();
			if(event.pageX>$(window).width()/2){
				slideFlag='right';
			}else{
				slideFlag='left';
			}
		
		}
		
		var $navSubs=$("#nav").find(".subs");
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
	var off=$("#nav-menu-dropdown").offset();
	//alert(off.left);
	if(off.left<0){
		scollValue=off.left+100
	}
	$("#nav-menu-dropdown").animate({
		"left": (scollValue)
	},100);
}
function scollRightForDropDown(){
	var scollValue=0;
	var off=$("#nav-menu-dropdown").offset();
	if(off.left+menuMaxValue>0){
		scollValue=off.left-100
		$("#nav-menu-dropdown").animate({
			"left": (scollValue)
		},100);
	}
	
}
 (function(jQuery){
	jQuery.fn.menu=function(data){
		//var timestamp1 = new Date().getTime();
		if(typeof data=="string"){
			data = eval("("+data+")");
		}
		var jQuerythis=jQuery(this);
		var jQuerycoldrop=jQuery(document.createElement("ul")).attr("id","nav");
		var ids=jQuerythis.attr("id");
		jQuerythis.append(jQuerycoldrop);
		var liMenuName='';
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
