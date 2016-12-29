<%@ tag body-content="scriptless" import="java.util.*" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:script value="/pages/xbuilder/resources/scripts/jquery_format.js"/>

<%@ attribute name="id" required="true" %>				<e:description>编辑器id</e:description>
<%@ attribute name="mode" required="true" %>			<e:description>编辑模式，如sql、java（语言）</e:description>
<%@ attribute name="path" required="true" %>			<e:description>需要引入的js和css路径</e:description>
<%@ attribute name="indentWithTabs" required="false" %> <e:description>是否按Tab缩进</e:description>
<%@ attribute name="smartIndent" required="false" %>	<e:description>智能缩进</e:description>
<%@ attribute name="lineNumbers" required="false" %>	<e:description>行号</e:description>
<%@ attribute name="lineWrapping" required="false" %>	<e:description>自动换行</e:description>
<%@ attribute name="matchBrackets" required="false" %>	<e:description>括号匹配</e:description>
<%@ attribute name="styleActiveLine" required="false" %><e:description>光标行加深</e:description>
<%@ attribute name="autofocus" required="false" %>		<e:description>自动焦点</e:description>
<%@ attribute name="autocomplete" required="false" %>	<e:description>自动补全</e:description>
<%@ attribute name="fullScreen" required="false" %>		<e:description>全屏模式</e:description>
<%@ attribute name="getValueFn" required="false" %>		<e:description>获取编辑区域文本</e:description>
<%@ attribute name="setValueFn" required="false" %>		<e:description>设置编辑区域文本</e:description>
<%@ attribute name="getPerpageFn" required="false" %>	<e:description>获取行数方法</e:description>
<%@ attribute name="replaceSelectionFn" required="false" %>	<e:description>在光标位置插入或替换选中值</e:description>


<%@ attribute name="theme" required="false" %>			<e:description>主题切换</e:description>
<%@ attribute name="fontsize" required="false" %>		<e:description>字体大小</e:description>
<%@ attribute name="uppercase" required="false" %>	    <e:description>转换大写</e:description>
<%@ attribute name="lowercases" required="false" %>	    <e:description>转换小写</e:description>
<%@ attribute name="perpage" required="false" %>	    <e:description>行数选择</e:description>
<%@ attribute name="undo" required="false" %>	        <e:description>撤销</e:description>
<%@ attribute name="redo" required="false" %>	        <e:description>重做</e:description>
<%@ attribute name="format" required="false" %>	        <e:description>格式化</e:description>
<%@ attribute name="reset" required="false" %>	        <e:description>清空</e:description>
<!--codemirror-->
	<e:script value="${path}/lib/codemirror.js"/>
	<e:style value="${path}/lib/codemirror.css"/>
	<!--搜索-->
	<e:style value="${path}/addon/dialog/dialog.css"/>
	<e:style value="${path}/addon/search/matchesonscrollbar.css"/>
	<e:script value="${path}/addon/dialog/dialog.js"/>
	<e:script value="${path}/addon/search/searchcursor.js"/>
	<e:script value="${path}/addon/search/search.js"/>
	<e:script value="${path}/addon/scroll/annotatescrollbar.js"/>
	<e:script value="${path}/addon/search/matchesonscrollbar.js"/>
	<e:script value="${path}/addon/search/jump-to-line.js"/>
	<!--提示和补全-->
	<e:style value="${path}/addon/hint/show-hint.css" />
	<e:script value="${path}/addon/hint/show-hint.js"/>
	<e:script value="${path}/addon/hint/sql-hint.js"/>
	<!--sql高亮-->
	<e:script value="${path}/mode/sql/sql.js"/>
	<!--匹配括号-->
	<e:script value="${path}/addon/edit/matchbrackets.js"/>
	<!--光标行加深-->
	<e:script value="${path}/addon/selection/active-line.js"/>
	<!--全屏模式-->
	<e:style value="${path}/addon/display/fullscreen.css"/>
	<e:script value="${path}/addon/display/fullscreen.js"/>
	<!--主题-->
	<e:style value="${path}/theme/3024-day.css"/>
	<e:style value="${path}/theme/3024-night.css"/>
	<e:style value="${path}/theme/cobalt.css"/>
	<e:style value="${path}/theme/dracula.css"/>
	<e:style value="${path}/theme/eclipse.css"/>
	<e:style value="${path}/theme/erlang-dark.css"/>
	<e:style value="${path}/theme/isotope.css"/>
	<e:style value="${path}/theme/lesser-dark.css"/>
	<e:style value="${path}/theme/liquibyte.css"/>
	<e:style value="${path}/theme/neo.css"/>
	<e:style value="${path}/theme/night.css"/>
	<e:style value="${path}/theme/paraiso-light.css"/>
	<e:style value="${path}/theme/rubyblue.css"/>
	<e:style value="${path}/theme/the-matrix.css"/>
	<e:style value="${path}/theme/zenburn.css"/>
<style type="text/css">
      .CodeMirror {border-top: 1px solid #ddd;border-bottom: 1px solid #ddd; font-size:13px;}
      .CodeMirror-gutters{height:100% !important;}
      html .layout-split-north{border-bottom:0;}
</style>

<e:if condition="${theme==null || theme=='' }">
	  <e:set var="theme">true</e:set>     
</e:if>
<e:if condition="${fontsize==null || fontsize=='' }">
	  <e:set var="fontsize">true</e:set>     
</e:if>
<e:if condition="${uppercase==null || uppercase=='' }">
	  <e:set var="uppercase">true</e:set>     
</e:if>
<e:if condition="${lowercases==null || lowercases=='' }">
	  <e:set var="lowercases">true</e:set>     
</e:if>
<e:if condition="${undo==null || undo=='' }">
	  <e:set var="undo">true</e:set>     
</e:if>
<e:if condition="${redo==null || redo=='' }">
	  <e:set var="redo">true</e:set>     
</e:if>
<e:if condition="${format==null || format=='' }">
	  <e:set var="format">true</e:set>     
</e:if>
<e:if condition="${reset==null || reset=='' }">
	  <e:set var="reset">true</e:set>     
</e:if>

<div style="height:40px;line-height:40px;overflow:hidden;">
<div style="float:left;" id="codeMirrorBottons">
	<jsp:doBody></jsp:doBody>
</div>
<div style="float:right;">
<e:if condition="${uppercase==true}">
	<a class="easyui-linkbutton" onclick="touppercase()" title="转换成大写" data-options="iconCls:'icon-Asmall'"></a>
</e:if>
<e:if condition="${lowercases==true}">
	<a class="easyui-linkbutton" onclick="tolowercases()" title="转换成小写" data-options="iconCls:'icon-Abig'"></a>
</e:if>
<e:if condition="${undo==true}">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-undo1'" title="撤销" onclick="toundo()"></a>
</e:if>
<e:if condition="${redo==true}">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-redo1'" title="重做" onclick="toredo()"></a>
</e:if>
<e:if condition="${format==true}">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-format1'"  title="格式化" onclick="toformat()"></a>
</e:if>
<e:if condition="${reset==true}">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-clean'"  title="清空" onclick="toreset()"></a>
</e:if>
<e:if condition="${perpage==true}">&nbsp;&nbsp;行数
	<select id="perpage_${id}">
	    <option>10</option>
	    <option>20</option>
	    <option>30</option>
	    <option>50</option>
	    <option>100</option>
	    <option>200</option>
	</select>
</e:if>
<e:if condition="${fontsize==true}">&nbsp;&nbsp;字体
	<select onchange="selectFont()" id="fontsize_${id}">
	    <option>11</option>
	    <option selected>13</option>
	    <option>15</option>
	    <option>17</option>
	    <option>19</option>
	    <option>21</option>
	    <option>23</option>
	    <option>25</option>
	    <option>27</option>
	    <option>29</option>
	    <option>31</option>
	</select>
</e:if>
<!--主题-->
<e:if condition="${theme==true}">&nbsp;&nbsp;主题
	<select onchange="selectTheme()" id="select_${id}">
	    <option value="default">默认主题</option>
	    <option value="eclipse">默认-加粗</option>
	    <option value="neo">默认-浅蓝-大间距</option>
	    <option value="3024-day">白天</option>
	    <option value="3024-night">黑夜</option>
	    <option value="cobalt">深蓝</option>
	    <option value="dracula">深蓝-粉色</option>
	    <option value="erlang-dark">深蓝-黄色</option>
	    <option value="rubyblue">深蓝-紫色</option>
	    <option value="isotope">黑-橙色</option>
	    <option value="the-matrix">黑-绿色</option>
	    <option value="night">黑-蓝色(高对比)</option>
	    <option value="liquibyte">黑-紫色-加粗</option>
	    <option value="paraiso-light">浅灰-橙色</option>
	    <option value="lesser-dark">深灰-蓝色</option>
	    <option value="zenburn">深灰-加粗(低对比)</option>
	</select>&nbsp;&nbsp;
</e:if>
</div>
</div>

<textarea id="${id}"></textarea>

<script type="text/javascript">
<!--	codemirror参数-->
	var mode;
	var options_${id} = {
		<e:if condition="${autocomplete!=null}">
			mode:{name:'${mode}',globalVars: true,operatorChars: /^[*+\-%<>{!=]/}
		</e:if>
		<e:if condition="${autocomplete==null}">
			mode:"${mode}"
		</e:if>
		<e:if condition="${smartIndent!=null}">
			,smartIndent:${smartIndent}
		</e:if>
		<e:if condition="${lineNumbers!=null}">
			,lineNumbers:${lineNumbers}
		</e:if>
		<e:if condition="${lineWrapping!=null}">
			,lineWrapping:${lineWrapping}
		</e:if>
		<e:if condition="${matchBrackets!=null}">
			,matchBrackets:${matchBrackets}
		</e:if>
		<e:if condition="${styleActiveLine!=null}">
			,styleActiveLine:${styleActiveLine}
		</e:if>
		<e:if condition="${autofocus!=null}">
			,autofocus:${autofocus}
		</e:if>
		,extraKeys: {
			<e:if condition="${fullScreen!=null}">
		  	  "${fullScreen}": function(cm) {
	          	cm.setOption("fullScreen", !cm.getOption("fullScreen"));//全屏模式
	          },
			</e:if>
			"Esc": function(cm) {
	          if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
	        }
	    }
		
	};
	//初始化codemirror
	$(document).ready(function() {
		  window.editor = CodeMirror.fromTextArea(document.getElementById('${id}'),options_${id});
		  <e:if condition="${autocomplete==true}">
			  autocomplete();//开启自动提示和完成
		  </e:if>
		  setTimeout(function(){
			  cleanUndoHistory();//清空撤销历史记录
		  },1000);
	});
	//自动提示和完成
	function autocomplete(){
		$('.CodeMirror').keydown(function (event) {
			//排除ctrl，shift，alt键,当焦点在编辑区的时候在提示
			if(!event.ctrlKey&&!event.shiftKey&&!event.altKey&&editor.hasFocus()){
				var sql = editor.getValue().replace(/\s/g,'');
				//按键a-z的提示
				if(event.keyCode>=65&&event.keyCode<=90&&sql!=''){
					showComplete();
					return;
				}
				//退格键的提示
				if(event.keyCode==8&&sql!=''){
					var cursor = editor.getCursor();
					var range = editor.getRange({line:cursor.line,ch:cursor.ch-1},cursor);
					var reg =  /^[A-Za-z]+$/;
					if(reg.test(range)){
						showComplete();
					}
					return;
				}
			}
		});
	}
	//代码提示
	function showComplete(){
		editor.showHint({completeSingle:false,closeCharacters: /[\s()\[\]{};:>,\=\-']/});
		//closeCharacters可以设置哪些特殊字符不提示
		//在sql-hint.js中添加哪些特殊字符后面不提示
		//在sql.js中添加关键字
	}
	//获取sql文本
	function getCodeValue(){
		return editor.getValue();
	}
	//设置文本
	function setCodeValue(str){
		editor.setValue(str);
	}
	//获取选中文本
	function getSelectCode(){
		return editor.getSelection();
	}
	//获取选中值，没有值则返回所有文本
	function getSelectValue(){
		var selectValue = getSelectCode();
		if(selectValue==''){
			selectValue = getCodeValue();
		}
		return selectValue;
	}
	//对比选中sql是否为全部sql
	function compareValue(selectValue,codeValue){
		selectValue = selectValue.replace(/\s/g,"");
		codeValue = codeValue.replace(/\s/g,"");
		if(selectValue == codeValue){
			return true;
		}else{
			 return false;
		}	 
	}
	<e:if condition = "${getValueFn!=null&&getValueFn ne ''}">
	     //获取SQL方法
	     function ${getValueFn}(){
	  	   return editor.getValue();
	     }
	 </e:if>
	 
	 <e:if condition = "${getValueFn!=null&&getValueFn ne ''}">
	     //设置SQL方法
	     function ${setValueFn}(value){
	  	   return editor.setValue(value);
	     }
 	</e:if>
	 <e:if condition = "${getPerpageFn!=null&&getPerpageFn ne ''}">
	     //获取行数方法
	     function ${getPerpageFn}(){
	     	var perpage =  $("#perpage_${id}").find("option:selected").text();
	  	   	return perpage;
	     }
 	</e:if>
 	//切换主题
    function selectTheme() {
		var theme_${id} = document.getElementById("select_${id}");
   	 	var theme = theme_${id}.options[theme_${id}.selectedIndex].value;
    	editor.setOption("theme", theme);
  		setCookie('codeMirrorTheme',theme,30);
  	}
  	//改变字体大小
  	function selectFont(){
  		//设置文本编辑区域的字体
		var fontsize_${id} = document.getElementById("fontsize_${id}");
  		var fontSize = $("#fontsize_${id}").val()+'px';
  		$(".CodeMirror-lines").css('font-size',fontSize);
  		setCookie('codeMirrorFontSize',fontSize,30);
 	}
 	//大写
 	function touppercase(){
 		var uppercase = editor.getSelection().toUpperCase();
 		editor.replaceSelection(uppercase);
 	}
 	//小写
 	function tolowercases(){
 		var lowercases = editor.getSelection().toLowerCase();
 		editor.replaceSelection(lowercases);
 		
 	}
 	//撤销
 	function toundo(){
 		editor.undo();
 	}
 	//重做
 	function toredo(){
 		editor.redo();
 	}
 	//格式化
 	function toformat(){
 		var sql = editor.getValue();
 		$("#${id}").val(sql);
 		$("#${id}").format({
    		method: 'sql'
    	});
 		editor.setValue($("#${id}").val());
 	}
 	//重置
 	function toreset(){
 		editor.setValue("");
 	}
 	
 	$(function(){
 		$(".CodeMirror").css("height",($(".CodeMirror").parent().height()-42)+"px")
 		var theme = getCookie('codeMirrorTheme');
 		var fontSize = getCookie('codeMirrorFontSize');
 		if(fontSize == null){
 			fontSize = 13;
 		}else{
	 		fontSize = fontSize.substr(0,fontSize.indexOf('p'))
 		}
 		if(theme == null){
 			theme='default';
 		}	
 		$(".CodeMirror-lines").css('font-size',fontSize+'px');
 		editor.setOption("theme", theme);
		jsSelectItemByValue(document.getElementById('select_${id}'),theme);
		jsSelectItemByValue(document.getElementById('fontsize_${id}'),fontSize);
 	})
 	//根据value设置select选中
 	function jsSelectItemByValue(objSelect, objItemText) {            
	    //判断是否存在        
	    var isExit = false;        
	    for (var i = 0; i < objSelect.options.length; i++) {        
	        if (objSelect.options[i].value == objItemText) {        
	            objSelect.options[i].selected = true;        
	            isExit = true;        
	            break;        
	        }        
	    }
    }
    //替换选中值
    <e:if condition = "${replaceSelectionFn!=null&&replaceSelectionFn ne ''}">
	 	function ${replaceSelectionFn}(str){
	 		editor.replaceSelection(" "+str);
	 	}
 	</e:if>
 	//写cookies
	function setCookie(c_name, value, expiredays){
 　　	var exdate=new Date();
　　　　 exdate.setDate(exdate.getDate() + expiredays);
　　　　 document.cookie=c_name+ "=" + escape(value) + ((expiredays==null) ? "" : ";expires="+exdate.toGMTString());
 　　}
 
	//读取cookies
	function getCookie(name){
	    var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
	    if(arr=document.cookie.match(reg)){
	        return (arr[2]);
	    }else{
	        return null;
	    }    
	}
	//自适应layout调整后的大小
	function resizeEditor(){
		editor.setSize('100%',$('#codemirrorArea').height()-45);
	}
	function cleanUndoHistory(){
		editor.clearHistory();
	}
</script>