function popup(url,containerId,componentId,propertyUrl,viewId,type){
	var title=$("#popup_"+componentId).attr("data-titile");
	var tempUrl=null;
	if(typeof(compFileDir) != "undefined"){
		if(type=='CROSSTABLE'||(type==undefined&&url.indexOf("pages/xbuilder/component/crosstable/")>-1)){
			tempUrl=appBase+"/crossDataJson.e?TitleType="+compFileDir+"&reportId="+viewId+"&containerId="+containerId+"&componentId="+componentId+(typeof(queryParamsStr) == "undefined"?"":"&"+queryParamsStr.substring(1));
		}else{
			tempUrl=appBase+"/pages/xbuilder/usepage/"+compFileDir+"/"+viewId+"/comp_"+componentId+".jsp?"+(typeof(queryParamsStr) == "undefined"?"":queryParamsStr.substring(1));
		}
		$('#popdiv').load(tempUrl,null,function(){
			$.parser.parse($("#popdiv"));
			$('#popdiv').window({title: title,height:500,width:800,collapsible:false,modal:true});
			$("#popdiv").window("center");
			$("#popdiv").window("open");
		});
	}
}
function formatNumber(number,pattern)
{
	var str			= number.toString();
	var strInt;
	var strFloat='';
	var formatInt;
	var formatFloat;
	if(/\./g.test(pattern))
	{
		formatInt		= pattern.split('.')[0];
		formatFloat		= pattern.split('.')[1];
	}
	else
	{
		formatInt		= pattern;
		formatFloat		= null;
	}

	if(/\./g.test(str))
	{
		if(formatFloat!=null)
		{
			var tempFloat	= Math.round(parseFloat('0.'+str.split('.')[1])*Math.pow(10,formatFloat.length))/Math.pow(10,formatFloat.length);
			strInt		= (Math.floor(number)+Math.floor(tempFloat)).toString();				
			strFloat	= /\./g.test(tempFloat.toString())?tempFloat.toString().split('.')[1]:'0';			
			if(strFloat.length<formatFloat.length){
				var tempLengh=strFloat.length;
				for(var i=0;i<(formatFloat.length-tempLengh);i++){
					strFloat=strFloat+'0';
				}
			}
		}
		else
		{
			strInt		= Math.round(number).toString();
			strFloat='';
		}
	}
	else
	{
		if(formatFloat!=null){
			strInt		= str;
			for(var i=0;i<formatFloat.length;i++){
				strFloat=strFloat+'0';
			}
		}else{
			strInt		= str;
			strFloat='';
		}
		
	}
	if(formatInt!=null)
	{
		var outputInt	= '';
		var zero		= formatInt.match(/0*$/)[0].length;
		var comma		= null;
		if(/,/g.test(formatInt))
		{
			comma		= formatInt.match(/,[^,]*/)[0].length-1;
		}
		var newReg		= new RegExp('(\\d{'+comma+'})','g');

		if(strInt.length<zero)
		{
			outputInt		= new Array(zero+1).join('0')+strInt;
			outputInt		= outputInt.substr(outputInt.length-zero,zero)
		}
		else
		{
			outputInt		= strInt;
		}

		var 
		outputInt			= outputInt.substr(0,outputInt.length%comma)+outputInt.substring(outputInt.length%comma).replace(newReg,(comma!=null?',':'')+'$1')
		outputInt			= outputInt.replace(/^,/,'');

		strInt	= outputInt;
	}

	if(formatFloat!=null)
	{
		var outputFloat	= '';
		var zero		= formatFloat.match(/^0*/)[0].length;

		if(strFloat.length<zero)
		{
			outputFloat		= strFloat+new Array(zero+1).join('0');
			//outputFloat		= outputFloat.substring(0,formatFloat.length);
			var outputFloat1	= outputFloat.substring(0,zero);
			var outputFloat2	= outputFloat.substring(zero,formatFloat.length);
			outputFloat		= outputFloat1+outputFloat2.replace(/0*$/,'');
		}
		else
		{
			outputFloat		= strFloat.substring(0,formatFloat.length);
		}

		strFloat	= outputFloat;
	}
	else
	{
		if(pattern!='' || (pattern=='' && strFloat=='0'))
		{
			strFloat	= '';
		}
	}

	return strInt+(strFloat==''?'':'.'+strFloat);
}
/** 描述：格式化数据
	参数：value 数据值
		  decimalNum 小数位数
		  mulNum 乘数（用于百分数、以万为单位等）
		  endString 结尾跟随字符
		  hasThousandSplit 是否有千分符
	返回值：格式化后的字符
	例：transformValue(3333.3,4,1,'',true) ->3,333.3000
		  
*/
function transformValue(value,decimalNum,mulNum,endString,hasThousandSplit){
	//alert(typeof mulNum);
	if(value==null){
		value=0;
	}
	if(decimalNum==null){
		decimalNum=0;
	}
	if(mulNum==null){
		mulNum=1;
	}
	if(endString==null){
		endString='';
	}
	if(hasThousandSplit==null){
		hasThousandSplit=false;
	}
	if(typeof(value)!="number"){
		value=parseFloat(value);
	}
	var signString='';
	if(value<0){
		value=Math.abs(value);
		signString='-';
	}
	if(typeof(decimalNum)!="number"){
		alert("小数位数必须是数值类型");
		return value;
	}
	if(typeof(mulNum)!="number"){
		alert("乘数必须是数值类型");
		return value;
	}
	if(typeof(endString)!="string"){
		alert("结尾跟随字符必须是字符类型");
		return value;
	}
	if(typeof(hasThousandSplit)!="boolean"){
		alert("是否有千分符 必须是布尔类型");
		return false;
	}
	if(value==undefined||isNaN(value)||value==null||value=='null'||value=='NULL'){
		return "";
	}
	var regForDataValue = /^[-\+]?\d+\.?\d*[E\e]?[+\-]?\d*$/;
	var reg = /^[-\+]?\d+\.?\d*$/;
	if(!regForDataValue.test(value)){
		alert("要转换的数据不是正确的数值");
		return value;
	}
	if(!reg.test(mulNum)){
		alert("乘数不是正确的数值");
		return value;
	}
	reg = /^([1-9]+\d)||(0)*$/;
	if(!reg.test(decimalNum)){
		alert("小数位数不是正确的数值");
		return value;
	}
	//alert(value);
	var formatterString="";
	if(hasThousandSplit){
		formatterString='#,###,###,###,###,###,###,###,###,###';
	}else{
		formatterString='############################';
	}
	if(decimalNum>0){
		formatterString=formatterString+'.';
		for(var i=0;i<decimalNum;i++){
			formatterString=formatterString+'#';
		}
	}
	//alert(formatterString);
	//alert((formatNumber(value*mulNum,formatterString)+endString));
	return (signString+formatNumber(new Number(value)*mulNum,formatterString)+endString);
}


$(function(){
	var searchCon = $(".bodyPC .serchIndex.serchIndexPC");
	if(searchCon.height()>50){
		var rTB = $("<span class='rTB rT'></span>");
		var t1 = window.setInterval(autoHeight,3000); 
		rTB.appendTo(searchCon);
		rTB.toggle(
			function(){
				searchCon.height("auto");
				$('.rTB').addClass("rB").removeClass("rT");
				window.clearInterval(t1); 
			},
			function(){
				searchCon.height("50px");
				$('.rTB').addClass("rT").removeClass("rB");
				window.clearInterval(t1); 
			}
		)	
	}
	function autoHeight(){ 
			var searchCon = $(".bodyPC .serchIndex.serchIndexPC");
			searchCon.css({'height':'50px','overflow':'hidden'});
		} 
})