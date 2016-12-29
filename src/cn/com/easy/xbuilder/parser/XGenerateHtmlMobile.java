package cn.com.easy.xbuilder.parser;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.codec.binary.Base64;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.service.DataSetService;
import cn.com.easy.xbuilder.service.XBaseService;

public class XGenerateHtmlMobile implements XGenerateHtml {
	private final Report report;
	private final String type;//
	private final SqlRunner runner;
	private String jspPath = "";
	private StringBuffer error = new StringBuffer();
	private StringBuffer page = new StringBuffer();
	private String nullid = "";

	public XGenerateHtmlMobile(Report report, String type, SqlRunner runner) {
		this.report = report;
		this.type = type;
		this.runner = runner;
	}

	private String generateJspHead() {
		StringBuffer head = new StringBuffer();
		head.append("<%@ page language=\"java\" pageEncoding=\"UTF-8\"%>").append("\n");
		head.append("<%@ taglib prefix=\"e\" uri=\"http://www.bonc.com.cn/easy/taglib/e\"%>").append("\n");
		head.append("<%@ taglib prefix=\"c\" uri=\"http://www.bonc.com.cn/easy/taglib/c\"%>").append("\n");
		head.append("<%@ taglib prefix=\"m\" uri=\"http://www.bonc.com.cn/easy/taglib/m\"%>").append("\n");
		head.append("<%@ taglib prefix=\"a\" tagdir='/WEB-INF/tags/app'%>").append("\n");
		DataSetService ser = new DataSetService();
		String urlParam = ser.getParamString(this.report.getId());
		head.append(urlParam).append("\n");
		return head.toString();
	}

	private String generateHtmlHead() {
		StringBuffer head = new StringBuffer();
		
		head.append("<!doctype html>").append("\n");
		head.append("<html>").append("\n");
		head.append("<head>").append("\n");
		head.append("<meta charset=\"utf-8\">").append("\n");
		head.append("<meta name=\"viewport\" content=\"width=device-width,maximum-scale=1.0,user-scalable=no\">").append("\n");
		//head.append("<base href=\"<%=request.getScheme() + \"://\" + request.getServerName() + \":\" + request.getServerPort() + request.getContextPath() + \"/\"%>\">").append("\n");
		head.append("<title>" + this.report.getInfo().getName() + "</title>").append("\n");
		head.append("<c:resources type=\"highchart\" style=\"b\"/>").append("\n");
		head.append("<m:resources type=\"webix\"/>").append("\n");
		
		return head.toString();
	}

	@SuppressWarnings("unchecked")
	private String generateStyle() throws SQLException {
		StringBuffer style = new StringBuffer();
		Map theme = null;
		if (this.report.getTheme() != null) {
			theme = runner.queryForMap("select CSS from x_theme where ID='"+ this.report.getTheme() + "'");
		}
		style.append("<e:style value=\"/pages/xbuilder/resources/themes/base/boncX@links.css\"/>").append("\n");
		if (theme != null && (!("".equals(theme.get("CSS"))))) {
			style.append("<e:style value=\"/"+theme.get("CSS")+"\"/>").append("\n");
		}
		style.append("<link rel=\"stylesheet\" href='<e:url value=\"/pages/xbuilder/resources/component/gridster/jquery.gridster.min.css\"/>'").append("\n");
		style.append("<link rel=\"stylesheet\" href='<e:url value=\"/pages/xbuilder/resources/component/gridster/style.css\"/>'>").append("\n");
		style.append("<style>.webix_view.webix_window {z-index:9999999999999990!important;}</style>").append("\n");
		//style.append("<style>document.body.style.overflow='hidden';</style>").append("\n");
		
		return style.toString();
	}
	
	private String generateJavaScript() {
		StringBuffer javaScript = new StringBuffer();
		javaScript.append("<script>var compFileDir='"+ this.type + "';var queryParamsStr='${urlParam}';var gridster;</script>").append("\n");
		javaScript.append("<script src='<e:url value=\"/pages/xbuilder/resources/scripts/jquery.touchSwipe.min.js\"/>'></script>").append("\n");
		javaScript.append("<script src='<e:url value=\"/pages/xbuilder/resources/component/gridster/jquery.gridster.js\"/>'></script>").append("\n");
		javaScript.append("<script src='<e:url value=\"/pages/xbuilder/resources/scripts/xbuilder.js\"/>'></script>").append("\n");
		javaScript.append("<script src='<e:url value=\"/pages/xbuilder/pagedesigner/Script_property.js\"/>'></script>").append("\n");
		// javaScript.append("<e:style
		// value=\"/pages/xbuilder/resources/css/default.css\"/>").append("\n");

		javaScript.append("<script>$(function(){").append("\n");
		javaScript.append("var bodyWidth=$(document.body).outerWidth(true);").append("\n");
		javaScript.append("var blockSize=bodyWidth/("+ this.report.getLayout().getWidth() + "/20);").append("\n");
		javaScript.append("gridster = $(\".gridster > ul\").gridster({").append("\n");
		javaScript.append("widget_margins: [2, 2],").append("\n");
		javaScript.append("widget_base_dimensions: [blockSize, blockSize],").append("\n");
		javaScript.append("autogenerate_stylesheet:true,").append("\n");
		javaScript.append("avoid_overlapped_widgets: true").append("\n");
		javaScript.append("}).data('gridster');").append("\n");

		javaScript.append("$('.component-area').css('width','100%');").append("\n");
		javaScript.append("$('.component-area').css('height','100%');").append("\n");
		javaScript.append("$('.component-head').css('height','29px');").append("\n");
		javaScript.append("$('.component-con').each(function(i,e){").append("\n");
		javaScript.append("var tempHeight=$(e).parent().height()-30;").append("\n");
		javaScript.append("$(e).css('height',tempHeight+'px');").append("\n");
		javaScript.append("});").append("\n");

		List<Container> containers = this.report.getContainers().getContainerList();
		for (int c = 0; c < containers.size(); c++) {
			Container container = containers.get(c);
			List<Component> components = container.getComponents().getComponentList();
			int size = (components == null || components.size() <= 0) ? 0: components.size();
			String cid = container.getId();
			String type = container.getType();
			if (size != 0) {
				if (type.equals("1")) {
					Component baseComponent = null;
					if(container.getPop()!=null&&!"".equals(container.getPop())){
						for(Component comp : components){
							if(!comp.getId().equals(container.getPop())){
								baseComponent = comp;
								break;
							}
						}
					}else{
						baseComponent = components.get(0);
					}
					
					String compPath = "";
					
					//交叉表属性用来判断load
					String crosstable = baseComponent.getType();
					
					String reportId = report.getId();
					String containerId = container.getId();
					String componentId = baseComponent.getId();
					
					if("CROSSTABLE".equals(crosstable)){
						compPath = "/crossDataJson.e?TitleType="+this.type+"&reportId="+reportId+"&containerId="+containerId+"&componentId="+componentId+"&a=1${urlParam}";
					}else{
						compPath = "/pages/xbuilder/usepage/" + this.type+ "/" + this.report.getId() + "/comp_"+ baseComponent.getId() + ".jsp?a=1${urlParam}";
					}
					
					
					javaScript.append("$('#div_body_" + cid + "').load(appBase+'"+ compPath + "');").append("\n");
				} else if (type.equals("2") || type.equals("3")) {
					javaScript.append("$('#div_head_li_" + cid + "_"+ components.get(0).getId()+ "_value').click();").append("\n");
				}
			} else {
				nullid += cid + ";";
			}
		}
		javaScript.append("gridster.disable();").append("\n");
		javaScript.append("$('#selectable_layout_id001 li').addClass('default-border').removeClass('selected-border');").append("\n");
		//查询条件部分手机不显示 2016-07-11
		javaScript.append("$('.serchIndexIn.serchIndexInMobile').parent('.serchIndex').css({ 'overflow' : 'visible', 'z-index' : '10' });");
		javaScript.append("$(\"#selectable_layout_id001\").swipe({").append("\n");
		javaScript.append("swipeUp:function(event, direction, distance, duration, fingerCount) {").append("\n");
		javaScript.append("var t = $(window).scrollTop();").append("\n");
		javaScript.append("$('body,html').animate({'scrollTop':t+300},100);").append("\n");
		javaScript.append("},").append("\n");
		javaScript.append("swipeDown:function(event, direction, distance, duration, fingerCount) {").append("\n");
		javaScript.append("var b = $(window).scrollTop();").append("\n");
		javaScript.append("$('body,html').animate({'scrollTop':b-300},100);").append("\n");
		javaScript.append("}").append("\n");
		javaScript.append("});").append("\n");
		javaScript.append("});</script>").append("\n");
		return javaScript.toString();
	}

	private String generateBodyStart() {
		StringBuffer body = new StringBuffer();
		body.append("</head>").append("\n");
		//body.append("<body>").append("\n");
		body.append("<body style=\"overflow:hidden\">").append("\n");
		return body.toString();
	}

	private String generateDateQuery(Dimsion dim) {
		StringBuffer date = new StringBuffer();
		String now =  getDefaultAcct("day");
		date.append("<span class=\"pr_15 data\">");
		// date.append(dim.getDesc()+":<input type=\"date\"
		// id=\""+dim.getVarname()+"\"
		// name=\""+dim.getVarname()+"\"/>").append("<span
		// style=\"padding-left:10px;\"></span>");
		String varName = dim.getVarname();
		if(isCNVarName(dim)){//true 非中文
			varName = dim.getVardesc();
		}
		
		date.append("<e:if condition=\"${param." + varName
				+ " != null && param." + varName + " ne '' &&param."+varName+" !='undefined' && param."+varName+" != 'null' }\" var='"
				+ varName + "_if' >");
		date.append("<e:set var='default_" + varName
				+ "' value='${param." + varName + "}'/>");
		date.append("</e:if>");
		date.append("<e:else condition='${" + varName + "_if}'>");
		date.append("<e:q4o var='cur_"+varName+"'>select CONST_VALUE from sys_const_table t where t.const_name='calendar.curdate'</e:q4o>");
		date.append("<e:set var='default_" + varName + "' value='${cur_"+varName+".CONST_VALUE}'/>");
		date.append("</e:else>");
		date.append("<m:day id='"+ varName+ "' label='"+ dim.getDesc()+ "' name='"+ varName
								+ "' defaultValue='${default_"+ varName
								+ "}' width='300' format='%Y-%m-%d' view='datepicker' getValueMethod='getValue'/>").append("\n");
		date.append("</span>");
		return date.toString();
	}

	private String generateMonthQuery(Dimsion dim) {
		StringBuffer month = new StringBuffer();
		month.append("<span class=\"pr_15 data\">");
		// month.append(dim.getDesc()+":<input type=\"month\"
		// id=\""+dim.getVarname()+"\"
		// name=\""+dim.getVarname()+"\"/>").append("<span
		// style=\"padding-left:10px;\"></span>");
		SimpleDateFormat format = new SimpleDateFormat("yyyyMM");
		String varName = dim.getVarname();
		if(isCNVarName(dim)){//true 非中文
			varName = dim.getVardesc();
		}
		month.append("<e:if condition=\"${param." + varName
				+ " != null && param." + varName + " ne '' &&param."+varName+" !='undefined' && param."+varName+" != 'null' }\" var='"
				+ varName + "_if' >");
		month.append("<e:set var='default_" + varName
				+ "' value='${param." + varName + "}'/>");
		month.append("</e:if>");
		month.append("<e:else condition='${" + varName + "_if}'>");
		month.append("<e:q4o var='cur_"+varName+"'>select CONST_VALUE from sys_const_table t where t.const_name='calendar.maxmonth'</e:q4o>");
		month.append("<e:set var='default_" + varName + "' value='${cur_"+varName+".CONST_VALUE}'/>");
		month.append("</e:else>");
		month.append("<span class='searchItemName'>"+dim.getDesc()+"</span>"
								+ "<m:month label='' style='width:200px; height:26px;' name='"
								+ varName + "' id='"
								+ varName
								+ "' isData='0' defaultValue='${default_"
								+ varName + "}'/></span>").append(
						"\n");
		return month.toString();
	}

	private String generateInputQuery(Dimsion dim) {
		StringBuffer text = new StringBuffer();
		String varName = dim.getVarname();
		if(isCNVarName(dim)){//true 非中文
			varName = dim.getVardesc();
		}
		
		text.append("<span class=\"pr_15 data\">");
		text.append("<e:if condition=\"${param." + varName
				+ " != null && param." + varName + " ne '' &&param."+varName+" !='undefined' && param."+varName+" != 'null' }\" var='"
				+ varName + "_if' >");
		text.append("<e:set var='default_" + varName
				+ "' value='${param." + varName + "}'/>");
		text.append("</e:if>");
		text.append("<e:else condition='${" + varName + "_if}'>");
		text.append("<e:set var='default_" + varName + "' value=''/>");
		text.append("</e:else>");
		text.append("<span class='searchItemName'>"+dim.getDesc()+"</span>"
								+ "<input type=\"text\" id=\""
								+ varName + "\" name=\""
								+ varName
								+ "\" style='width:200px;' value='${default_"
								+ varName + "}'/></span>").append(
						"\n");
		return text.toString();
	}

	private String generateSelectQuery(Dimsion dim) {
		StringBuffer select = new StringBuffer();
		select.append("<span class=\"pr_15 down\">");
		String createType = dim.getCreatetype();
		String multiple = dim.getIsselectm();
		String extds = "";
		
		String varName = dim.getVarname();
		if(isCNVarName(dim)){//true 非中文
			varName = dim.getVardesc();
		}
		
		if (!"".equals(dim.getSql().getExtds())) {
			extds += " extds=\"" + dim.getSql().getExtds() + "\" ";
		}
		if (createType.equals("1")) {
			select.append(dim.getDesc() + "<e:q4l var=\"" + dim.getId() + "\" "
					+ extds + ">select " + dim.getCodecolumn() + ","
					+ dim.getDesccolumn() + " from " + dim.getTable()+" order by "+dim.getOrdercolumn()
					+ "</e:q4l>");
		} else if (createType.equals("2")) {
			select.append(dim.getDesc() + "<e:q4l var=\"" + dim.getId() + "\" "
					+ extds + ">" + dim.getSql().getSql() + "</e:q4l>");
		}
		//if (multiple.equals("1")) {
			select.append("<e:if condition=\"${param." + varName
					+ " != null && param." + varName
					+ " ne '' &&param."+varName+" !='undefined' && param."+varName+" != 'null' }\" var='" + varName + "_if' >");
			select.append("<e:set var='default_" + varName
					+ "' value='${param." + varName + "}'/>");
			select.append("</e:if>");
			select.append("<e:else condition='${" + varName
							+ "_if}'>");
			select.append("<e:set var='default_" + varName
					+ "' value='" + dim.getDefaultvalue() + "'/>");
			select.append("</e:else>");
			
			//判断配置型（1）还是手动型（非1）
			if("1".equals(createType)){
				select.append("<e:select id=\"" + varName
						+ "\" name=\"" + varName + "\" items=\"${"
						+ dim.getId() + ".list}\" label=\"" + dim.getDesccolumn() 
						+ "\" value=\"" + dim.getCodecolumn() 
						+ "\" style=\"width:200px\" defaultValue='${default_"
						+ varName
						+ "}' headLabel='--请选择--' headValue=''/></span>");
			}else{
				select.append("<e:select id=\"" + varName
						+ "\" name=\"" + CommonTools.transformSqlForDim(varName) + "\" items=\"${"
						+ dim.getId() + ".list}\" label=\"CODEDESC" 
						+ "\" value=\"CODE" 
						+ "\" style=\"width:200px\" defaultValue='${default_"
						+ varName
						+ "}' headLabel='--请选择--' headValue=''/></span>");
			}
			
		//}
		return select.append("\n").toString();
	}

	private String generateCaSelectQuery(Dimsion parentDim, Dimsion childDim) {
		StringBuffer select = new StringBuffer();
		//select.append("<span class=\"pr_15 down\">"
				     // +"<span class='searchItemName'>"+parentDim.getDesc()+"</span>"
				      //+"<span class='searchItemName'>"+childDim.getDesc()+"</span>");
		String caselect = "";
		String parentName = parentDim.getVarname();
		if(isCNVarName(parentDim)){//true 非中文
			parentName = parentDim.getVardesc();
		}
		String childName = childDim.getVarname();
		if(isCNVarName(childDim)){//true 非中文
			childName = childDim.getVardesc();
		}
		
		if (childDim != null) {
			String parentSql = "2".equals(parentDim.getCreatetype()) ? parentDim
					.getSql().getSql()
					: "";
			String childSql = "2".equals(childDim.getCreatetype()) ? childDim
					.getSql().getSql() : "";

			select.append("<e:if condition=\"${param." + parentName
					+ " != null && param." + parentName
					+ " ne '' &&param."+parentName+" !='undefined' && param."+parentName+" != 'null' }\" var='" + parentName + "_if' >");
			select.append("<e:set var='default_" + parentName
					+ "' value='${param." + parentName + "}'/>");
			select.append("</e:if>");
			select.append("<e:else condition='${" + parentName
					+ "_if}'>");
			select.append("<e:set var='default_" + parentName
					+ "' value='" + parentDim.getDefaultvalue() + "'/>");
			select.append("</e:else>");

			select.append("<e:if condition=\"${param." + childName
					+ " != null && param." + childName
					+ " ne '' &&param."+childName+" !='undefined' && param."+childName+" != 'null' }\" var='" + childName + "_if' >");
			select.append("<e:set var='default_" + childName
					+ "' value='${param." + childName + "}'/>");
			select.append("</e:if>");
			select.append("<e:else condition='${" + childName
					+ "_if}'>");
			select.append("<e:set var='default_" + childName
					+ "' value='" + childDim.getDefaultvalue() + "'/>");
			select.append("</e:else>");
			caselect = "<a:caselect id='"
					+ parentName
					+ "'"
					+ " parentLabel='"
					+parentDim.getDesc()
					+"' parentLabelWidth='0'  parentTable='"
					+ parentDim.getTable()
					+ "'  parentDescCol='"
					+ parentDim.getDesccolumn()
					+ "' parentCodeCol='"
					+ parentDim.getCodecolumn()
					+ "'"
					+ " childLabel='"
					+childDim.getDesc()
					+"'  childLabelWidth='0' childTable='"
					+ childDim.getTable()
					+ "'   childDescCol='"
					+ childDim.getDesccolumn()
					+ "'  childCodeCol='"
					+ childDim.getCodecolumn()
					+ "'"
					+ " parentCol='"
					+ childDim.getParentcol()
					+ "' layout='vertical'  getValueMethod='getCasValue' parentName='"
					+ parentName
					+ "' childName='"
					+ childName
					+ "'"
					+ " parentDefault='${default_"
					+ parentName
					+ "}' childDefault='${default_"
					+ childName
					+ "}' parentExtds='"
					+ parentDim.getSql().getExtds()
					+ "' childExtds='"
					+ childDim.getSql().getExtds()
					+ "'>"
					+ "{"
					+ parentSql
					+ "};{"
					+ childSql
					+ "}</a:caselect></span>";
		}

		select.append(caselect);
		return select.append("\n").toString();
	}

	private String generateCaSelectQuery(Dimsion parentDim,Dimsion currnetDim,Dimsion childDim) {
		StringBuffer select = new StringBuffer();
		
		String currentDimSql = "2".equals(currnetDim.getCreatetype()) ? currnetDim.getSql().getSql(): "";
		if("1".equals(currnetDim.getShowtype())) {//平铺
			select.append("<span class=\"pr_15 caselect\" style='clear:left;width:95%'>");
			select.append("<e:if condition=\"${param." + currnetDim.getVarname()
					+ " != null && param." + currnetDim.getVarname()
					+ " ne '' &&param."+currnetDim.getVarname()+" !='undefined' && param."+currnetDim.getVarname()+" != 'null' }\" var='" + currnetDim.getVarname() + "_if' >");
			select.append("<e:set var='default_" + currnetDim.getVarname()
					+ "' value='${param." + currnetDim.getVarname() + "}'/>");
			select.append("</e:if>");
			select.append("<e:else condition='${" + currnetDim.getVarname()
					+ "_if}'>");
			select.append("<e:set var='default_" + currnetDim.getVarname()
					+ "' value='" + currnetDim.getDefaultvalue() + "'/>");
			select.append("</e:else>");

			//父节点
			select.append("<a:caselectlist id=\""+currnetDim.getVarname()+"\" name=\""+currnetDim.getVarname()+"\" curdimname=\""+currnetDim.getVarname()+"\" curdesc=\""+ currnetDim.getDesc() +"\" multiple=\""+ currnetDim.getIsselectm() +"\"");
			select.append(" defaultValue=\"${default_"+ currnetDim.getVarname()  +"}\" parentcodecol=\""+ currnetDim.getParentcol() +"\" parentdimname=\""+currnetDim.getParentdimname()+"\" level=\""+ currnetDim.getLevel() +"\"");
			if("1".equals(currnetDim.getCreatetype())) {
				select.append(" table=\""+ currnetDim.getTable()+"\" codecol=\""+currnetDim.getCodecolumn()+"\" desccol=\""+ currnetDim.getDesccolumn()+"\" ordcol=\""+ currnetDim.getOrdercolumn()+"\" sql=\"\" ");
			}
			select.append(" extds=\""+currnetDim.getSql().getExtds()+"\" >");
			if(!"1".equals(currnetDim.getCreatetype())) {
				select.append(currnetDim.getSql().getSql());
			}
			select.append("</a:caselectlist>");
			if(parentDim!=null){
				select.append("<script>$(document).ready(function() {initCas_"+ currnetDim.getVarname() +"_"+ currnetDim.getVarname() +"('${default_"+ currnetDim.getParentdimname()  +"}');});</script>");
			}
			select.append("</span>");
		} else {
			select.append("<span class=\"pr_15 caselect\">");
			select.append("<e:if condition=\"${param." + currnetDim.getVarname()
					+ " != null && param." + currnetDim.getVarname()
					+ " ne '' &&param."+currnetDim.getVarname()+" !='undefined' && param."+currnetDim.getVarname()+" != 'null' }\" var='" + currnetDim.getVarname() + "_if' >");
			select.append("<e:set var='default_" + currnetDim.getVarname()
					+ "' value='${param." + currnetDim.getVarname() + "}'/>");
			select.append("</e:if>");
			select.append("<e:else condition='${" + currnetDim.getVarname()
					+ "_if}'>");
			select.append("<e:set var='default_" + currnetDim.getVarname()
					+ "' value='" + currnetDim.getDefaultvalue() + "'/>");
			select.append("</e:else>");
			select.append("<span class='searchItemName'>").append(currnetDim.getDesc()).append("</span>");
			
			select.append("<a:caselectnew ");
			select.append("id='").append(currnetDim.getVarname()).append("' ");
			
			select.append("table='").append(currnetDim.getTable()).append("' ");
			select.append("codeCol='").append(currnetDim.getCodecolumn()).append("' ");
			select.append("descCol='").append(currnetDim.getDesccolumn()).append("' ");
			select.append("sortCol='").append(currnetDim.getOrdercolumn()).append("' ");
			if(parentDim!=null){
				if(!"".equals(currnetDim.getParentcol())){
					select.append("parentCol='").append(currnetDim.getParentcol()).append("' ");
				}
				if(!"".equals(currnetDim.getParentdimname())){
					select.append("parentElementId='").append(currnetDim.getParentdimname()).append("' ");
				}
			}
			if(childDim!=null){
				if(!"".equals(childDim.getVarname())){
					select.append("childElementId='").append(childDim.getVarname()).append("' ");
				}
			}
			select.append("defaultValue='${default_").append(currnetDim.getVarname()).append("}' ");
			select.append("defaultItemValue='").append(currnetDim.getDefaultvalue()).append("' ");
			
			//currnetDim.getIsselectm()
			if("1".equals(currnetDim.getIsselectm())){
				select.append("multiple='true' ");
				
			}
			
			select.append("extds='"+currnetDim.getSql().getExtds()+"' ");
			select.append(">");
			select.append(currentDimSql);
			select.append("</a:caselectnew>");
			select.append("</span>");
		}
		
		return select.append("\n").toString();
	}
	
	private String generateQuery() {
		if (this.report.getDimsions() == null || this.report.getDimsions().getDimsionList() == null || this.report.getDimsions().getDimsionList().size()<=0) {
			return "";
		}
		StringBuffer query = new StringBuffer();

		query.append("<div class=\"serchIndex\"><div class=\"serchIndexIn serchIndexInMobile\"><p>");
		query.append("<m:mquery id='query_" + this.report.getId()+ "' contentId='form_" + this.report.getId() + "' />");
		query.append("<form id=\"form_" + this.report.getId()+ "\" method=\"post\" action=\"\" style='display:none;'>");
			List<Dimsion> dims = this.report.getDimsions().getDimsionList();
			boolean flag = false;
			for (Dimsion dim : dims) {
				if (dim.getIsparame().equals("0")) {
					String type = dim.getType().toLowerCase();
					if (type.equals("day")) {
						query.append(this.generateDateQuery(dim));
					} else if (type.equals("month")) {
						query.append(this.generateMonthQuery(dim));
					} else if (type.equals("input")) {
						query.append(this.generateInputQuery(dim));
					} else if (type.equals("hidden")) {
						query.append(this.generateInputQuery(dim));
					} else if (type.equals("select")) {
						query.append(this.generateSelectQuery(dim));
					} else if (type.equals("caselect")) {
						if ("".equals(dim.getParentcol())) {
							Dimsion childDim = (new DataSetService()).getChildDimsion(this.report, dim.getVarname());
							query.append(this.generateCaSelectQuery(dim,childDim));
						}
//						DataSetService dataSetService=new DataSetService();
//						Dimsion childDim = dataSetService.getChildDimsion(this.report, dim);
//						Dimsion parentDim=dataSetService.getParentDimsion(this.report, dim);
//						query.append(this.generateCaSelectQuery(parentDim,dim,childDim));
					}
					flag = true;
				}
			}
			if(!flag){
				return "";
			}
			query.append("</form></p></div></div>");
		return query.toString();
	}

	private String generateLayoutLi() {
		StringBuffer layout = new StringBuffer();

		String sizex = this.report.getInfo().getSizex();
		String html = new String(Base64.decodeBase64(this.report.getLayout().getValue()));
		Document doc = Jsoup.parse(html);

		Elements trs = doc.select("ul").eq(0);
		for (Element tr : trs) {
			Elements tds = tr.children();
			int toph = 0;
			for (Element td : tds) {
				Element li = td.select("li").first();
				li.attr("data-sizex",sizex);
				//li.removeAttr("data-sizex");
				li.removeAttr("data-sizey");
				String lid = li.attr("id");
				int contheight = getContHeight(lid);
				if(toph == 0){
					li.attr("style","height:"+contheight+"px;");
				}else{
					li.attr("style","height:"+contheight+"px;top:"+toph+"px;");
				}
				toph += contheight+40;
				//li.getElementsByAttributeValue("id","div_body_"+lid).first().attr("style","width:100%;height:"+contheight+"px;");
				if (td.hasClass("preview-holder")) {
					td.remove();
				}
				td.removeAttr("onclick");
				if (nullid.indexOf(td.attr("id") + ";") != -1) {
					td.attr("style", "display:none;");
				}
			}
			Elements spans = tr.select("span");
			for (Element span : spans) {
				if (span.hasClass("gs-resize-handle")
						&& span.hasClass("gs-resize-handle-both")) {
					span.remove();
				}
			}
			Elements divs = tr.select("div");
			for (Element div : divs) {
				
				String id = div.attr("id");
				if (!id.startsWith("div_")) {
					div.remove();
				}else if (id.startsWith("div_set_")) {
					div.attr("style", "display:none;");
				}
				/*
				 * else if(nullid.indexOf(id+";") != -1){
				 * div.attr("style","display:none;"); }
				 */
			}
		}
		layout.append("<div id=\"selectable_layout_id001\" class=\"gridster ready\">"+ trs.toString() + "</div>");
		return layout.toString();
	}
	private int getContHeight(String contid){
		List<Container> containers = this.report.getContainers().getContainerList();
		for(int c=0;c<containers.size();c++){
			Container container = containers.get(c);
			String cid = container.getId();
			if(cid.equals(contid)){
				return Integer.parseInt(container.getHeight());
			}
		}
		return 0;
	}
	
	// 生成m:gotop
	private String generateGoTop() {
		// return "<m:gotop id=\"gotopspan\"/>\n";
		return "";
	}

	private String generateBodyEnd() {
		StringBuffer end = new StringBuffer();
		//end.append("<div id=\"popdiv\" style=\"width: 650px; padding: 10px;\" closed=\"true\" shadow=\"true\" resizable=\"false\" collapsible=\"true\" minimizable=\"false\" maximizable=\"false\"></div>\n");
		end.append("</body>\n");
		end.append("</html>");
		return end.toString();
	}
	private String getDefaultAcct(String t) {
		try {
			String name = "calendar.maxmonth";
			if(t.equals("day")){
				name = "calendar.curdate";
			}
			Map valMap = runner.queryForMap("select CONST_VALUE from sys_const_table t where t.const_name='"+name+"'");
			return String.valueOf(valMap.get("CONST_VALUE"));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private void destroy() {
		this.error = null;
	}

	@Override
	public String html(XGenerateComp xComp) {
		try {
			this.page.append(this.generateJspHead());
			this.page.append(this.generateHtmlHead());
			this.page.append(this.generateStyle());
			this.page.append(this.generateJavaScript());
			this.page.append(this.generateBodyStart());
			this.page.append(this.generateGoTop());
			this.page.append(this.generateQuery());
			this.page.append(this.generateLayoutLi());
			this.page.append(this.generateBodyEnd());
		} catch (Exception e) {
			this.error.append("||||"+e.getMessage());
		}

		if (this.error.length() > 0) {
			return this.error.toString();
		}

		String code = xComp.comp(this);
		if (!code.equals("success")) {
			return code;
		}
		return "success";
	}

	@Override
	public boolean saveToFile() {
		String root = this.getClass().getClassLoader().getResource("/").getPath().replace("WEB-INF/classes/", "/");
		String jsp = "pages/xbuilder/usepage/"+this.type+ "/"+ this.report.getId()+ "/"+ this.type+ "_"+ this.report.getId() + ".jsp";
		String path = root+jsp;
		FileOutputStream fos = null;
		try {
			File file = new File(path);
			if (file.exists()) {
				file.delete();
			} else {
				if (!file.getParentFile().exists()) {
					file.getParentFile().mkdirs();
				}
			}

			fos = new FileOutputStream(path);
			OutputStreamWriter osw = new OutputStreamWriter(fos, "UTF-8");
			osw.write(this.page.toString());
			osw.flush();
			this.jspPath = jsp;
			if (this.type.equals("formal")) {
				XBaseService mbs = new XBaseService();
				//mbs.saveToXmlByObj(this.report, false);
				mbs.saveToXmlByObj(this.report, true);
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			this.error.append("||||"+e.getMessage() + "\n");
			return false;
		} finally {
			if (fos != null) {
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
					this.error.append("||||"+e.getMessage() + "\n");
				}
			}
		}
	}
	
	@Override
	public String getJsp() {
		this.destroy();
		return this.jspPath;
	}
	
	@Override
	public StringBuffer getPage() {
		return this.page;
	}
	
	//判断中文
	private boolean isCNVarName(Dimsion dim){
		boolean flg = false;
		Pattern pattern = Pattern.compile("[\u4e00-\u9fa5]");
		if(null!=dim.getConditiontype() && "1".equals(dim.getConditiontype())){
			 Matcher matcher = pattern.matcher(dim.getVardesc()); 
			 if(!matcher.find()){
				 flg = true;
			 }
		}
		return flg;
	}
}