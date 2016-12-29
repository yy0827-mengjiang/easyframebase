package cn.com.easy.xbuilder.parser;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.binary.Base64;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Datasources;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.service.DataSetService;
import cn.com.easy.xbuilder.service.XBaseService;

public class XGenerateHtmlPC implements XGenerateHtml {
	private final Report report;
	private final String type;//
	private final SqlRunner runner;
	private String jspPath = "";
	private StringBuffer error = new StringBuffer();
	private StringBuffer page = new StringBuffer();
	
	private String nullid = "";

	public XGenerateHtmlPC(Report report, String type, SqlRunner runner) {
		this.report = report;
		this.type = type;
		this.runner = runner;
	}

	private String generateJspHead() {
		StringBuffer head = new StringBuffer();
		head.append("<%@ page language=\"java\" pageEncoding=\"UTF-8\"%>").append("\n");
		head.append("<%@ taglib prefix=\"e\" uri=\"http://www.bonc.com.cn/easy/taglib/e\"%>").append("\n");
		head.append("<%@ taglib prefix=\"c\" uri=\"http://www.bonc.com.cn/easy/taglib/c\"%>").append("\n");
		head.append("<%@ taglib prefix=\"a\" tagdir='/WEB-INF/tags/app'%>").append("\n");
		DataSetService ser = new DataSetService();
		String urlParam = ser.getParamString(this.report.getId());
		head.append(urlParam).append("\n");
		return head.toString();
	}

	private String generateHtmlHead() {
		StringBuffer head = new StringBuffer();
		head.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">").append("\n");
		head.append("<html>").append("\n");
		head.append("<head>").append("\n");
		//head.append("<base href=\"<%=request.getScheme() + \"://\" + request.getServerName() + \":\" + request.getServerPort() + request.getContextPath() + \"/\"%>\">").append("\n");
		head.append("<meta charset=\"utf-8\">").append("\n");
		head.append("<meta name=\"renderer\" content=\"webkit\">").append("\n");
		head.append("<title>" + this.report.getInfo().getName() + "</title>").append("\n");
		head.append("<style>.datagrid-header .datagrid-cell {white-space: normal!important; word-wrap: normal!important; overflow: inherit!important;  height: auto!important; min-height:18px!important;}</style>").append("\n");
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
		//style.append("<e:style value=\"/pages/xbuilder/resources/component/gridster/jquery.gridster.min.css\"/>").append("\n");
		//style.append("<e:style value=\"/pages/xbuilder/resources/component/gridster/style.css\"/>").append("\n");
		return style.toString();
	}

	private String generateJavaScript() {
		List<Container> containers = this.report.getContainers().getContainerList();
		StringBuffer contidarr = new StringBuffer();
		StringBuffer javaScript = new StringBuffer();
		javaScript.append("<c:resources type=\"easyui,highchart\" style=\"b\"/>").append("\n");
		javaScript.append("<script>var compFileDir='"+ this.type+ "';var queryParamsStr='${urlParam}';var gridster;</script>").append("\n");
		javaScript.append("<e:style value=\"/pages/xbuilder/resources/component/gridster/jquery.gridster.min.css\"/>").append("\n");
		javaScript.append("<e:style value=\"/pages/xbuilder/resources/component/gridster/style.css\"/>").append("\n");
		javaScript.append("<e:script value=\"/pages/xbuilder/resources/component/gridster/jquery.gridster.js\"/>").append("\n");
		//javaScript.append("<e:script value=\"/resources/component/highcharts/modules/exporting.js\"/>").append("\n");

		
		
		for (int c = 0; c < containers.size(); c++) {
			Container container = containers.get(c);
			contidarr.append(container.getId()+",");
		}
		contidarr.deleteCharAt(contidarr.length()-1);
		javaScript.append("<a:autowidth xid=\""+this.report.getId()+"\" lwidth=\""+this.report.getLayout().getWidth()+"\" cids=\""+contidarr.toString()+"\" devemodel=\"${param.deve}\"/>").append("\n");
		
		//javaScript.append("<e:script value=\"/pages/xbuilder/resources/scripts/xbuilder.js\"/>").append("\n");
		//javaScript.append("<e:script value=\"/pages/xbuilder/pagedesigner/Script_property.js\"/>").append("\n");
		// javaScript.append("<e:style
		// value=\"/pages/xbuilder/resources/css/default.css\"/>").append("\n");
		javaScript.append("<script>$(function(){setTimeout(function(){").append("\n");
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
					
					javaScript.append("$('#div_body_" + cid + "').load(appBase+'"+ compPath + "'");
					if(this.report.getInfo().getLtype().equals("1") && baseComponent.getType().toLowerCase().equals("treegrid")){
						javaScript.append(",function(){$.parser.parse($('#div_body_" + cid + "'));}");
					}else if(this.report.getInfo().getLtype().equals("1") && baseComponent.getType().toLowerCase().equals("crosstable") && baseComponent.getRowtype().equals("2")){
						javaScript.append(",function(){$.parser.parse($('#div_body_" + cid + "'));}");
					}
					javaScript.append(");").append("\n");
				} else if (type.equals("2") || type.equals("3")) {
					javaScript.append("$('#div_head_li_" + cid + "_"+ components.get(0).getId()+ "_value').click();").append("\n");
				}
			} else {
				nullid += cid + ";";
			}
		}
		javaScript.append("var hid = $('.serchIndexInPC').attr('class');");
		javaScript.append("if(undefined==hid){$('.bodyPC').css('padding-top','0')}");
		javaScript.append("},500); });</script>").append("\n");
		return javaScript.toString();
	}

	private String generateBodyStart() {
		StringBuffer body = new StringBuffer();
		body.append("</head>").append("\n");
		body.append("<body class='bodyPC'>").append("\n");
		//页面水印 邢政填加
		String pcWaterMark = String.valueOf(EasyContext.getContext().getServletcontext().getAttribute("XPCWaterMark"));
		if(null != pcWaterMark && !"".equals(pcWaterMark) && pcWaterMark.equals("1")){
			//水印个数
			String density = String.valueOf(EasyContext.getContext().getServletcontext().getAttribute("XPCWaterDensity"));
			String waterContent =  String.valueOf(EasyContext.getContext().getServletcontext().getAttribute("XPCWaterContent"));
			if(!"".equals(waterContent)&&waterContent!=null){
				String content = this.getWaterContent(waterContent);
				body.append("<a:watermarkpc id=\""+report.getId()+"\" density=\""+density+"\" content=\""+content+"\" />\n");
			}else{
				body.append("<a:watermarkpc id=\""+report.getId()+"\" density=\""+density+"\" />\n");
			}
		}
		return body.toString();
	}

	private String generateDateQuery(Dimsion dim,String[] varSuffixs) {
		StringBuffer month = new StringBuffer();
		month.append("<span class=\"pr_16 data\">");
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		month.append("<span class='searchItemName'>" + dim.getDesc()+"</span>");
		for(int i= 0; i < varSuffixs.length; i++) {
			String varName = dim.getVarname() + varSuffixs[i];
			
			if(isCNVarName(dim)){//true 非中文
				varName = dim.getVardesc() + varSuffixs[i];
			}
			if(i > 0) {
				month.append("~");
			}
			month.append("<e:if condition=\"${param." + varName
					+ " != null && param." + varName + " ne '' &&param."+varName+" !='undefined' && param."+varName+" != 'null' }\" var='"
					+ varName + "_if' >");
			month.append("<e:set var='default_" + varName
					+ "' value='${param." + varName + "}'/>");
			month.append("</e:if>");
			month.append("<e:else condition='${" + varName + "_if}'>");
			month.append("<e:q4o var='cur_"+ varName+ "'>select CONST_VALUE from sys_const_table t where t.const_name='calendar.curdate'</e:q4o>");
			month.append("<e:set var='default_" + varName+ "' value='${cur_" + varName + ".CONST_VALUE}'/>");
			month.append("</e:else>");
			month.append("<c:datebox required='false' format='yyyymmdd' name='"
									+ varName + "' id='"
									+ varName
									+ "' defaultValue='${default_"
									+ varName + "}'/>");
		}
		month.append("\n");
		month.append("</span>");
		return month.toString();
	}

	private String generateMonthQuery(Dimsion dim ,String[]varSuffixs) {
		StringBuffer month = new StringBuffer();
		month.append("<span class=\"pr_16 down\">");
		SimpleDateFormat format = new SimpleDateFormat("yyyyMM");
		month.append("<span class='searchItemName'>" + dim.getDesc()+"</span>");
		for(int i= 0; i < varSuffixs.length; i++) {
			String varName = dim.getVarname() + varSuffixs[i];
			if(isCNVarName(dim)){//true 非中文
				varName = dim.getVardesc() + varSuffixs[i];
			}
			
			if(i > 0) {
				month.append("~");
			}
			month.append("<e:if condition=\"${param." + varName
					+ " != null && param." + varName + " ne '' &&param."+varName+" !='undefined' && param."+varName+" != 'null' }\" var='"
					+ varName + "_if' >");
			month.append("<e:set var='default_" + varName+ "' value='${param." + varName + "}'/>");
			month.append("</e:if>");
			month.append("<e:else condition='${" + varName + "_if}'>");
			month.append("<e:q4o var='cur_"
							+ varName
							+ "'>select CONST_VALUE from sys_const_table t where t.const_name='calendar.maxmonth'</e:q4o>");
			month.append("<e:set var='default_" + varName
					+ "' value='${cur_" + varName + ".CONST_VALUE}'/>");
			month.append("</e:else>");
			month.append("<c:month label='' name='" + varName + "' id='"
							+ varName
							+ "' isData='0' defaultValue='${default_"
							+ varName + "}'/>");
		}
		month.append("\n");
		month.append("</span>");
		return month.toString();
	}
	
	
	

	private String generateInputQuery(Dimsion dim,String[] varSuffixs) {
		StringBuffer text = new StringBuffer();
		text.append("<span class=\"pr_16 data\">");
		text.append("<span class='searchItemName'>" + dim.getDesc()+"</span>");
		for(int i= 0; i < varSuffixs.length; i++) {
			String varName = dim.getVarname() + varSuffixs[i];
			if(isCNVarName(dim)){//true 非中文
				varName = dim.getVardesc() + varSuffixs[i];
			}
			if(i > 0) {
				text.append("~");
			}
			text.append("<e:if condition=\"${param." + varName
					+ " != null && param." + varName + " ne '' &&param."+ varName +" !='undefined' && param."+varName+" != 'null' }\" var='"
					+ varName + "_if' >");
			text.append("<e:set var='default_" + varName
					+ "' value='${param." + varName + "}'/>");
			text.append("</e:if>");
			text.append("<e:else condition='${" + varName + "_if}'>");
			text.append("<e:set var='default_" + varName + "' value=''/>");
			text.append("</e:else>");
			text.append("<input type=\"text\" id=\""
									+ varName + "\" name=\""
									+ varName
									+ "\" style='width:145px;' value='${default_"
									+ varName + "}'/>");
		}
		text.append("\n");
		text.append("</span>");
		return text.toString();
	}

	private String generateSelectQuery(Dimsion dim) {
		StringBuffer select = new StringBuffer();
		String createType = dim.getCreatetype();
		String sql = "";
		if (createType.equals("1")) {
			sql = "select "+ dim.getCodecolumn() +" as code, " + dim.getDesccolumn() + " as codedesc " + " from " + dim.getTable() + " group by " + dim.getCodecolumn() + ", " + dim.getDesccolumn();
		} else if (createType.equals("2")) {
			sql = CommonTools.transformSqlForDim(dim.getSql().getSql());
		}
		
		String varName = dim.getVarname();
		Pattern pattern = Pattern.compile("[\u4e00-\u9fa5]");
		if(null!=dim.getConditiontype() && "1".equals(dim.getConditiontype())){
			Matcher matcher = pattern.matcher(dim.getVardesc()); 
			if(!matcher.find()){
				varName = dim.getVardesc();
			}
		}
		
		
		select.append("<e:if condition=\"${param." + varName
				+ " != null && param." + varName
				+ " ne '' &&param."+varName+" !='undefined' && param."+varName+" != 'null' }\" var='" + varName + "_if' >");
		select.append("<e:set var='default_" + varName
				+ "' value='${param." + varName + "}'/>");
		select.append("<e:set var='default_mode" + varName + "' value='${param.mode" + varName + "}'/>");
		
		select.append("</e:if>");
		select.append("<e:else condition='${" + varName
						+ "_if}'>");
			//后加默认值判断
			select.append("<e:if condition=\"${param.condtype eq '1'}\" var=\"cond_if\">");
			select.append("<e:set var='default_"+varName+"' value=''/>");
			select.append("</e:if>");
			select.append("<e:else condition=\"${cond_if}\">");
		//1常量，2用户属性
		String DefaultValueType = dim.getDefaultValueType();
		if("1".equals(DefaultValueType)){
			select.append("<e:set var='default_" + varName
					+ "' value='" + dim.getDefaultvalue() + "'/>");
		}else if("2".equals(DefaultValueType)){
			select.append("<e:set var='default_" + varName
					+ "' value='${" + dim.getDefaultvalue() + "}'/>");
		}
			select.append("</e:else>");
		select.append("</e:else>");
 		if(!"0".equals(dim.getShowtype())) {
			select.append("<span class=\"pr_15 caselect\" style='clear:left;width:85%'>");
		} else {
			select.append("<span class=\"pr_15 caselect\">");
		}
		select.append("<a:selectlist id=\""+ varName  +"\" name=\""+ varName  +"\" desc=\""+ dim.getDesc() +"\" curdimname=\""+ varName  +"\" defaultValue=\"${default_"+ varName  +"}\" defaultEcho=\"${default_mode"+ varName  +"}\" multiple=\""+ dim.getIsselectm() +"\" showtype=\""+ dim.getShowtype() +"\" sql=\"\" extds=\""+ dim.getSql().getExtds() +"\">");
		select.append(sql);
		select.append("</a:selectlist></span>");
		return select.append("\n").toString();
	}

	private String generateCaSelectQuery(Dimsion parentDim, Dimsion childDim) {
		StringBuffer select = new StringBuffer();
		select.append("<span class=\"pr_16 down\"><style>.parentList{float:left!important;}</style>");
		String caselect = "";
		if (childDim != null) {
			String parentSql = "2".equals(parentDim.getCreatetype()) ? parentDim
					.getSql().getSql()
					: "";
			String childSql = "2".equals(childDim.getCreatetype()) ? childDim
					.getSql().getSql() : "";
			if("1".equals(childDim.getShowtype())) {//平铺
				select.append("<e:if condition=\"${param." + parentDim.getVarname()
						+ " != null && param." + parentDim.getVarname()
						+ " ne '' &&param."+parentDim.getVarname()+" !='undefined' && param."+parentDim.getVarname()+" != 'null' }\" var='" + parentDim.getVarname() + "_if' >");
				select.append("<e:set var='default_" + parentDim.getVarname()
						+ "' value='${param." + parentDim.getVarname() + "}'/>");
				select.append("</e:if>");
				select.append("<e:else condition='${" + parentDim.getVarname()
						+ "_if}'>");
				select.append("<e:set var='default_" + parentDim.getVarname()
						+ "' value='" + parentDim.getDefaultvalue() + "'/>");
				select.append("</e:else>");
	
				select.append("<e:if condition=\"${param." + childDim.getVarname()
						+ " != null && param." + childDim.getVarname()
						+ " ne '' &&param."+parentDim.getVarname()+" !='undefined' && param."+parentDim.getVarname()+" != 'null' }\" var='" + childDim.getVarname() + "_if' >");
				select.append("<e:set var='default_" + childDim.getVarname()
						+ "' value='${param." + childDim.getVarname() + "}'/>");
				select.append("</e:if>");
				select.append("<e:else condition='${" + childDim.getVarname()
						+ "_if}'>");
				select.append("<e:set var='default_" + childDim.getVarname()
						+ "' value='" + childDim.getDefaultvalue() + "'/>");
				select.append("</e:else>");
				//父节点
				select.append("<a:caselectlist id=\""+parentDim.getVarname()+"\" name=\""+parentDim.getVarname()+"\" curdimname=\""+parentDim.getVarname()+"\" curdesc=\""+"<strong class='titList'>"+ parentDim.getDesc()+"<strong>" +"\" multiple=\""+ parentDim.getIsselectm() +"\"");
				select.append(" defaultValue=\"${default_"+ parentDim.getVarname()  +"}\" parentcodecol=\""+ parentDim.getParentcol() +"\" parentdimname=\""+parentDim.getParentdimname()+"\" level=\""+ parentDim.getLevel() +"\"");
				if("1".equals(parentDim.getCreatetype())) {
					select.append(" table=\""+ parentDim.getTable()+"\" codecol=\""+parentDim.getCodecolumn()+"\" desccol=\""+ parentDim.getDesccolumn()+"\" ordcol=\""+ parentDim.getOrdercolumn()+"\" sql=\"\" ");
				}
//				} else {
//					select.append("  sql=\""+ parentDim.getSql().getSql() +"\" ");
//				}
				select.append(" extds=\""+parentDim.getSql().getExtds()+"\" >");
				if(!"1".equals(parentDim.getCreatetype())) {
					select.append(parentDim.getSql().getSql());
				}
				select.append("</a:caselectlist>");
				//子节点
				select.append("<a:caselectlist id=\""+childDim.getVarname()+"\" name=\""+childDim.getVarname()+"\" curdimname=\""+childDim.getVarname()+"\" curdesc=\""+"<strong class='titList'>"+ childDim.getDesc()+"</strong>" +"\" multiple=\""+ childDim.getIsselectm() +"\"");
				select.append(" defaultValue=\"${default_"+ childDim.getVarname()  +"}\" parentcodecol=\""+ childDim.getParentcol() +"\" parentdimname=\""+childDim.getParentdimname()+"\" level=\""+ childDim.getLevel() +"\"");
				if("1".equals(childDim.getCreatetype())) {
					select.append(" table=\""+ childDim.getTable()+"\" codecol=\""+childDim.getCodecolumn()+"\" desccol=\""+ childDim.getDesccolumn()+"\" ordcol=\""+ childDim.getOrdercolumn()+"\" sql=\"\" ");
				}
//				} else {
//					select.append("  sql=\""+ childSql +"\" ");
//				}
				select.append(" extds=\""+childDim.getSql().getExtds()+"\" >");
				if(!"1".equals(childDim.getCreatetype())) {
					select.append(childSql);
				}
				select.append("</a:caselectlist>");
				select.append("<script>  $(document).ready(function() {initCas_"+ childDim.getVarname() +"_"+ childDim.getVarname() +"('${default_"+ parentDim.getVarname()  +"}');});</script>");
				select.append("</span>");
			} else {
				select.append("<e:if condition=\"${param." + parentDim.getVarname()
						+ " != null && param." + parentDim.getVarname()
						+ " ne '' &&param."+parentDim.getVarname()+" !='undefined' && param."+parentDim.getVarname()+" != 'null' }\" var='" + parentDim.getVarname() + "_if' >");
				select.append("<e:set var='default_" + parentDim.getVarname()
						+ "' value='${param." + parentDim.getVarname() + "}'/>");
				select.append("</e:if>");
				select.append("<e:else condition='${" + parentDim.getVarname()
						+ "_if}'>");
				select.append("<e:set var='default_" + parentDim.getVarname()
						+ "' value='" + parentDim.getDefaultvalue() + "'/>");
				select.append("</e:else>");
	
				select.append("<e:if condition=\"${param." + childDim.getVarname()
						+ " != null && param." + childDim.getVarname()
						+ " ne '' &&param."+parentDim.getVarname()+" !='undefined' && param."+parentDim.getVarname()+" != 'null' }\" var='" + childDim.getVarname() + "_if' >");
				select.append("<e:set var='default_" + childDim.getVarname()
						+ "' value='${param." + childDim.getVarname() + "}'/>");
				select.append("</e:if>");
				select.append("<e:else condition='${" + childDim.getVarname()
						+ "_if}'>");
				select.append("<e:set var='default_" + childDim.getVarname()
						+ "' value='" + childDim.getDefaultvalue() + "'/>");
				select.append("</e:else>");
				caselect = "<a:caselect id='"
						+ parentDim.getVarname()
						+ "'"
						+ " parentLabel='"+parentDim.getDesc()+"' parentLabelWidth='0'  parentTable='"
						+ parentDim.getTable()
						+ "'  parentDescCol='"
						+ parentDim.getDesccolumn()
						+ "' parentCodeCol='"
						+ parentDim.getCodecolumn()
						+ "'"
						+ " childLabel='"+childDim.getDesc()+"'  childLabelWidth='0' childTable='"
						+ childDim.getTable()
						+ "'   childDescCol='"
						+ childDim.getDesccolumn()
						+ "'  childCodeCol='"
						+ childDim.getCodecolumn()
						+ "'"
						+ " parentCol='"
						+ childDim.getParentcol()
						+ "' layout='vertical'  getValueMethod='getCasValue' parentName='"
						+ parentDim.getVarname()
						+ "' childName='"
						+ childDim.getVarname()
						+ "'"
						+ " parentDefault='${default_"
						+ parentDim.getVarname()
						+ "}' childDefault='${default_"
						+ childDim.getVarname()
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
		}
		select.append(caselect);
		return select.append("\n").toString();
	}
	
	private String generateCaSelectQuery(Dimsion parentDim,Dimsion currnetDim,Dimsion childDim) {
		StringBuffer select = new StringBuffer();
		
		String currentDimSql = "2".equals(currnetDim.getCreatetype()) ? currnetDim.getSql().getSql(): "";
		
		//中文字段
		String varName = currnetDim.getVarname();
		Pattern pattern = Pattern.compile("[\u4e00-\u9fa5]");
		if(null!=currnetDim.getConditiontype() && "1".equals(currnetDim.getConditiontype())){
			Matcher matcher = pattern.matcher(currnetDim.getVardesc()); 
			if(!matcher.find()){
				varName = currnetDim.getVardesc();
			}
		}
		
		
		
		if("1".equals(currnetDim.getShowtype())) {//平铺
			select.append("<span class=\"pr_15 caselect\" style='clear:left;width:95%'>");
			select.append("<e:if condition=\"${param." + varName
					+ " != null && param." + varName
					+ " ne '' &&param."+varName+" !='undefined' && param."+varName+" != 'null' }\" var='" + varName + "_if' >");
			select.append("<e:set var='default_" + varName
					+ "' value='${param." + varName + "}'/>");
			select.append("</e:if>");
			select.append("<e:else condition='${" + varName
					+ "_if}'>");
				//后加默认值判断
				select.append("<e:if condition=\"${param.condtype eq '1'}\" var=\"cond_if\">");
				select.append("<e:set var='default_"+varName+"' value=''/>");
				select.append("</e:if>");
				select.append("<e:else condition=\"${cond_if}\">");
			String DefaultValueType = currnetDim.getDefaultValueType();
			if("1".equals(DefaultValueType)){
				select.append("<e:set var='default_" + varName
						+ "' value='" + currnetDim.getDefaultvalue() + "'/>");
			}else if("2".equals(DefaultValueType)){
				select.append("<e:set var='default_" + varName
						+ "' value='${" + currnetDim.getDefaultvalue() + "}'/>");
			}
				select.append("</e:else>");
			select.append("</e:else>");

			//父节点
			select.append("<a:caselectlist id=\""+varName+"\" name=\""+varName+"\" curdimname=\""+varName+"\" curdesc=\""+"<strong class='titList'>" + currnetDim.getDesc()+"</strong>" +"\" multiple=\""+ currnetDim.getIsselectm() +"\"");
			select.append(" defaultValue=\"${default_"+ varName  +"}\" parentcodecol=\""+ currnetDim.getParentcol() +"\" parentdimname=\""+currnetDim.getParentdimname()+"\" level=\""+ currnetDim.getLevel() +"\"");
			if("1".equals(currnetDim.getCreatetype())) {
				select.append(" table=\""+ currnetDim.getTable()+"\" codecol=\""+currnetDim.getCodecolumn()+"\" desccol=\""+ currnetDim.getDesccolumn()+"\" ordcol=\""+ currnetDim.getOrdercolumn()+"\" sql=\"\" ");
			}
			select.append(" extds=\""+currnetDim.getSql().getExtds()+"\" >");
			if(!"1".equals(currnetDim.getCreatetype())) {
				select.append(currnetDim.getSql().getSql());
			}
			select.append("</a:caselectlist>");
			if(parentDim!=null){
				select.append("<script>$(document).ready(function() {initCas_"+ varName +"_"+ varName +"('${default_"+ currnetDim.getParentdimname()  +"}');});</script>");
			}
			select.append("</span>");
		} else {
			select.append("<span class=\"pr_15 caselect\">");
			select.append("<e:if condition=\"${param." + varName
					+ " != null && param." + varName
					+ " ne '' &&param."+varName+" !='undefined' && param."+varName+" != 'null' }\" var='" + varName + "_if' >");
			select.append("<e:set var='default_" + varName
					+ "' value='${param." + varName + "}'/>");
			
			select.append("</e:if>");
			select.append("<e:else condition='${" + varName
					+ "_if}'>");
				//后加默认值判断
				select.append("<e:if condition=\"${param.condtype eq '1'}\" var=\"cond_if\">");
				select.append("<e:set var='default_"+varName+"' value=''/>");
				select.append("</e:if>");
				select.append("<e:else condition=\"${cond_if}\">");
			String DefaultValueType = currnetDim.getDefaultValueType();
			if("1".equals(DefaultValueType)){
				select.append("<e:set var='default_" + varName
						+ "' value='" + currnetDim.getDefaultvalue() + "'/>");
			}else if("2".equals(DefaultValueType)){
				select.append("<e:set var='default_" + varName
						+ "' value='${" + currnetDim.getDefaultvalue() + "}'/>");
			}
				select.append("</e:else>");
			select.append("</e:else>");
			select.append("<span class='searchItemName'>").append(currnetDim.getDesc()).append("</span>");
			
			//替换标签（解决联动多选问题）
			//select.append("<a:caselectnew "); 以前的 01
			select.append("<a:selectlinkage ");
			//select.append("id='").append(varName).append("' ");
			select.append("id='").append(varName+"_TMP").append("' ");
			select.append("name='").append(varName).append("' ");
			select.append("table='").append(currnetDim.getTable()).append("' ");
			select.append("codeCol='").append(currnetDim.getCodecolumn()).append("' ");
			select.append("descCol='").append(currnetDim.getDesccolumn()).append("' ");
			select.append("sortCol='").append(currnetDim.getOrdercolumn()).append("' ");
			if(parentDim!=null){
				if(!"".equals(currnetDim.getParentcol())){
					select.append("parentCol='").append(currnetDim.getParentcol()).append("' ");
				}
				if(!"".equals(currnetDim.getParentdimname())){
					//非中文名称
					String str = getCNVarName(currnetDim.getParentdimname()); 
					//select.append("parentElementId='").append(str).append("' "); 以前的 01
					select.append("parentElementId='").append(str+"_TMP").append("' "); 
				}
			}
			if(childDim!=null){
				if(!"".equals(childDim.getVarname())){
					//中文字段
					String chilName = childDim.getVarname();
					if(null!=childDim.getConditiontype() && "1".equals(childDim.getConditiontype())){
						Matcher matcher = pattern.matcher(childDim.getVardesc()); 
						if(!matcher.find()){
							chilName = childDim.getVardesc();
						}
					}
					//select.append("childElementId='").append(chilName).append("' "); 以前的 01
					select.append("childElementId='").append(chilName+"_TMP").append("' ");
				}
			}
			select.append("defaultValue='${default_").append(varName).append("}' ");
			select.append("defaultItemValue='").append("").append("' ");
			
			//currnetDim.getIsselectm()
			if("1".equals(currnetDim.getIsselectm())){
				select.append("multiple='true' ");
				
			}
			
			select.append("extds='"+currnetDim.getSql().getExtds()+"' ");
			select.append(">");
			select.append(currentDimSql);
			//select.append("</a:caselectnew>"); 以前的 01
			select.append("</a:selectlinkage>");
			select.append("</span>");
		}
		
		return select.append("\n").toString();
	}
	
	private String generateUploadQuery(Dimsion dim,String[] varSuffixs) {
		StringBuffer text = new StringBuffer();
		text.append("<span class=\"pr_16 data\">");
		text.append("<span class='searchItemName'>" + dim.getDesc()+"</span>");
		for(int i= 0; i < varSuffixs.length; i++) {
			String varName = dim.getVarname() + varSuffixs[i];
			if(isCNVarName(dim)){//true 非中文
				varName = dim.getVardesc() + varSuffixs[i];
			}
			if(i > 0) {
				text.append("~");
			}
			text.append("<e:if condition=\"${param." + varName
					+ " != null && param." + varName + " ne '' &&param."+ varName +" !='undefined' && param."+varName+" != 'null' }\" var='"
					+ varName + "_if' >");
			text.append("<e:set var='default_" + varName
					+ "' value='${param." + varName + "}'/>");
			text.append("</e:if>");
			text.append("<e:else condition='${" + varName + "_if}'>");
			text.append("<e:set var='default_" + varName + "' value=''/>");
			text.append("</e:else>");
			text.append("\n");
			text.append("<iframe id=\"iframe_upload_"+varName+"\" width=\"300\" height=\"31\"align=\"middle\" class=\"fromFileIframe\"  noresize=\"noresize\" scrolling=\"no\" frameborder=\"0\" src=\"<e:url value='/pages/xbuilder/usepage/common/CommonReportUploadFile.jsp?reportId="+this.report.getId()+"&fieldName="+varName+"&logId=${default_"+varName+" }'/>\"></iframe>").append("\n");
			text.append("<a href=\"javascript:void(0);\" class=\"easyui-linkbutton\"	onclick=\"javascript:reportselectfile('"+this.report.getId()+"','"+varName+"')\">文件列表</a>&nbsp;&nbsp").append("\n");
			text.append("<a href=\"javascript:void(0);\" class=\"easyui-linkbutton\" onclick=\"javascript:reportdownfile('"+this.report.getId()+"')\">模板下载</a>").append("\n");
			text.append("<input type=\"hidden\" id=\""+varName+"\" name=\""+varName+"\" value=\"${default_"+varName+"}\" />").append("\n");
			text.append("</span>");
		}
		text.append("\n");
		return text.toString();
	}

	private String generateQuery() {
		if (this.report.getDimsions() == null || this.report.getDimsions().getDimsionList() == null || this.report.getDimsions().getDimsionList().size()<=0) {
			return "";
		}
		StringBuffer query = new StringBuffer();
		query.append("<script type=\"text/javascript\">\n");
		query.append("function doQuery(){\n");
		query.append("var form_"+this.report.getId()+"_action=window.location.href;\n");
		query.append("if(form_"+this.report.getId()+"_action.indexOf(\"?\")){\n");
		query.append("	$(\"#form_"+this.report.getId()+"\").attr(\"action\",form_"+this.report.getId()+"_action.substring(0,form_"+this.report.getId()+"_action.indexOf(\"?\")));\n");
		query.append("}\n");
		query.append("document.getElementById(\"form_" + this.report.getId()+ "\").submit();\n");
		query.append("}\n");
		query.append("</script>\n");
		query.append("<div class=\"serchIndex serchIndexPC\"><div class=\"serchIndexIn serchIndexInPC\"><form id=\"form_" + this.report.getId()+ "\" method=\"post\" action=\"\"><h3>查询条件 </h3>");
		List<Dimsion> dims = this.report.getDimsions().getDimsionList();
		
		/*上传条件时的公共部分 开始*/
		/*扩展数据源隐藏表单 开始*/
		StringBuilder extdsStrBuil=new StringBuilder();
		Map<String, String> extdsMap=new HashMap<String, String>();
		//extdsMap.put(null, null);
		Datasources datasources=this.report.getDatasources();
		if(datasources!=null&&datasources.getDatasourceList()!=null&&datasources.getDatasourceList().size()>0){
			List<Datasource> datasourceList=datasources.getDatasourceList();
			for(Datasource tempDatasource:datasourceList){
				if(tempDatasource.getExtds()!=null&&(!("".equals(tempDatasource.getExtds().trim())))){
					extdsMap.put(tempDatasource.getExtds(), tempDatasource.getExtds());
				}else{
					extdsMap.put(null, null);
				}
			}
		}
		Set<String> set=extdsMap.keySet();
		Iterator<String> itertator=set.iterator();
		while(itertator.hasNext()){
			extdsStrBuil.append("#").append(String.valueOf(itertator.next()));
		}
		query.append("<input type='hidden' id='extdsHidden' value='"+extdsStrBuil.substring(1)+"' />\n");
		/*扩展数据源隐藏表单 结束*/
		
		/*上传查询条件用的style样式表 开始		 */
		query.append("<style>\n");
		query.append("	@-moz-document url-prefix() { .fromFileIframe {margin-top:-5px;} }\n");
		query.append("	@media screen and (-webkit-min-device-pixel-ratio:0) {.fromFileIframe {margin-top:-5px;}  }\n");
		query.append("</style>\n");
		query.append("\n");
		/*上传查询条件用的style样式表 结束*/
		
		/*上传查询条件用的javascript方法 开始*/
		query.append("<script>\n");
		query.append("   function reportselectfile(reportId,dimname){\n");
		query.append("   	 var logId=$(\"#\"+dimname).val();\n");
		query.append("     	 var info = {}; \n");
		query.append("		 info.reportId = reportId;\n");
		query.append("		 info.logId=logId; \n");
		query.append("		 info.fieldName = dimname; \n");
		query.append("		 $(\"#upload"+this.report.getId()+"\").load(\"<e:url value ='/pages/xbuilder/usepage/common/CommonReportSelectFile.jsp'/>\",info,function(){\n");
		query.append("			$.parser.parse($(\"#upload"+this.report.getId()+"\"));\n");
		query.append("			$('#upload"+this.report.getId()+"').window('open');\n");
		query.append("		 });\n");
		query.append("	 }\n");
		query.append("	 function reportdownfile(reportId){\n");
		query.append("		 window.location.href = \"<e:url value='/pages/xbuilder/usepage/common/CommonReportDownModule.jsp'/>\";\n");
		query.append("		 window.returnValue=false;\n");
		query.append("	 }\n");
		query.append("	 function showSelectFile(reportId,logId){\n");
		query.append("		 $(\"#param2\").val(logId);\n");
		query.append("	 }\n");
		query.append("</script>\n");
		query.append("\n");
		/*上传查询条件用的javascript方法 结束*/
		
		/*上传查询条件用的对话框 开始*/
		query.append("<div id=\"upload"+this.report.getId()+"\" class=\"easyui-window\" title=\"&nbsp;选择文件\" data-options=\"modal:true,closed:true,resizable:false,minimizable:false,maximizable:false,collapsible:false\" 	style=\"width: 603px; height: 300px; padding: 1px; overflow: hidden;\">\n");
		query.append("</div>\n");
		query.append("\n");
		/*上传查询条件用的对话框 结束*/
		
		query.append("<div style=\"padding:0;\">");
		//此处需要排序
		listSort(dims);
		boolean flag = false;
		for (Dimsion dim : dims) {
			if (dim.getIsparame().equals("0")) {
				String type = dim.getType().toLowerCase();
				String[] varSuffixs = {""};
				if("2".equals(this.report.getInfo().getType())) {//指标库模式 between and
					if("06".equals(dim.getFormula()) //>=...<=
							||"10".equals(dim.getFormula()) //>...<
							||"11".equals(dim.getFormula()) //>=...<
							||"12".equals(dim.getFormula())) {//>...<=
						varSuffixs = new String[2];
						varSuffixs[0] = "_1";
						varSuffixs[1] = "_2";
					}
				}
				if (type.equals("day")) {
					query.append(this.generateDateQuery(dim,varSuffixs));
				} else if (type.equals("month")) {
					query.append(this.generateMonthQuery(dim,varSuffixs));
				} else if (type.equals("input")) {
					query.append(this.generateInputQuery(dim,varSuffixs));
				} else if (type.equals("hidden")) {
					query.append(this.generateInputQuery(dim,varSuffixs));
				} else if (type.equals("select")) {
					query.append(this.generateSelectQuery(dim)); //下拉和联动不支持between and
				} else if (type.equals("caselect")) {
//					if ("".equals(dim.getParentcol())) {
//						Dimsion childDim = (new DataSetService()).getChildDimsion(this.report, dim.getVarname());
//						query.append(this.generateCaSelectQuery(dim,childDim));
//					}
					DataSetService dataSetService=new DataSetService();
					Dimsion childDim = dataSetService.getChildDimsion(this.report, dim);
					Dimsion parentDim=dataSetService.getParentDimsion(this.report, dim);
					query.append(this.generateCaSelectQuery(parentDim,dim,childDim));
				}else if(type.equals("upload")){//上传
					query.append(this.generateUploadQuery(dim,varSuffixs));
					
				}
				flag = true;
			}
		}
		if(!flag){
			return "";
		}
		query.append("<span class=\"pr_15\"><input id=\"condtype\" name=\"condtype\" type=\"hidden\" value=\"1\"/><a href=\"javascript:void(0);\" class=\"easyui-linkbutton\" onclick=\"doQuery()\">确认查询</a></span></div></form></div></div>");
		return query.toString();
	}

	private String generateLayoutLi() {
		StringBuffer layout = new StringBuffer();

		String html = new String(Base64.decodeBase64(this.report.getLayout()
				.getValue()));
		Document doc = Jsoup.parse(html);

		Elements trs = doc.select("ul").eq(0);
		for (Element tr : trs) {
/*			String ustl = tr.attr("style");
			ustl = ustl.replace("margin: 0px;", "margin: 0 auto;");
			tr.attr("style", ustl);*/
			String ustl = tr.attr("style");
			//position: relative; margin: 0px; z-index: 1; height: 408px; width: 1896px;
			if(null != ustl && ustl.indexOf("width")>-1){
				ustl = ustl.substring(0,ustl.lastIndexOf("width"));
			}
			tr.attr("style",ustl);
			tr.classNames();
			Elements tds = tr.children();
			for (Element td : tds) {
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
				} else if (id.startsWith("div_set_")) {
					div.attr("style", "display:none;");
				}
				/*
				 * else if(nullid.indexOf(id+";") != -1){
				 * div.attr("style","display:none;"); }
				 */
			}
		}
		layout.append("<div id=\"selectable_layout_id001\" class=\"gridster ready\">"
						+ trs.toString() + "</div>");
		return layout.toString();
	}

	private String generateBodyEnd() {
		StringBuffer end = new StringBuffer();
		
		end.append("<e:if condition=\"${applicationScope['xpageinfo'] == '1'}\">").append("\n");
		
		end.append("<div id = \"xpageinfo_"+this.report.getId()+"\" class=\"popbtn easyui-draggable\" >").append("\n");
		end.append("<a id = \"xpageinfo_a_"+this.report.getId()+"\" href=\"javascript:void(0)\" class=\"easyui-linkbutton\" onclick=\"showDialogDesc()\">页面描述</a>").append("\n");
		end.append("<div id=\"dialog_"+this.report.getId()+"\"></div>");
		end.append("</div>");
		end.append("<script type=\"text/javascript\">").append("\n");
		end.append("$(function() {");
		end.append("$('#xpageinfo_"+this.report.getId()+"').draggable({");
		end.append("disabled:false,cursor:\"move\", ");
		end.append("onStartDrag:function(e){");
		end.append("$('#xpageinfo_a_"+this.report.getId()+"').linkbutton('disable');");
		end.append("},");
		end.append("onStopDrag:function(e){");
		end.append("$('#xpageinfo_a_"+this.report.getId()+"').linkbutton('enable'); return false;");
		//end.append("$('#xpageinfo_a_"+this.report.getId()+"').on(\"click\",\"showDialogDesc\");");
		end.append("}");
		end.append(" }); });");
		end.append("function showDialogDesc(){");
		end.append("var left = document.body.clientWidth-505;");
		end.append("var top = document.body.scrollHeight-305;");
		end.append("$('#dialog_"+this.report.getId()+"').dialog({");
		end.append("title: '页面描述',");
		end.append("width: 500,");
		end.append("height: 300,");
		end.append("closed: false,");
		end.append("cache: false,");
		end.append("maximizable: true,");
		end.append("minimizable: false,");
		end.append("href:appBase+'/pages/xbuilder/usepage/common/reportInfo.jsp?reportid="+this.report.getId()+"',");
		end.append("resizable: true, ");
		end.append("shadow: true, ");
		end.append("left: left, ");
		end.append("top: top ");
		end.append("});");
		end.append("}");
		end.append("</script>").append("\n");
		end.append("</e:if>").append("\n");
		end.append("<div id=\"popdiv\" style=\"width: 650px; padding: 10px;\" closed=\"true\" shadow=\"true\" resizable=\"false\" collapsible=\"true\" minimizable=\"false\" maximizable=\"false\"></div>\n");
		end.append("</body>\n");
		end.append("</html>");
		return end.toString();
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
	
	/**
	 * 指定字段排序 (周杰添加，因为查询条件可以排序是通过index改变的)
	 * @param resultList
	 * @throws Exception
	 */
	 private void listSort(List<Dimsion> resultList) {
		Collections.sort(resultList, new Comparator<Dimsion>() {
			public int compare(Dimsion o1, Dimsion o2) {
				String sstr1 = (String) o1.getIndex();
				String sstr2 = (String) o2.getIndex();
				String level1 = o1.getLevel();
				String level2 = o2.getLevel();
				if (sstr1 == null || sstr1.equals(""))
					sstr1 = "0";
				if (sstr2 == null || sstr2.equals(""))
					sstr2 = "0";
				if (level1 == null || level1.equals(""))
					level1 = "99999999";
				if (level2 == null || level2.equals(""))
					level2 = "99999999";
				Integer s1 = Integer.parseInt(sstr1);
				Integer s2 = Integer.parseInt(sstr2);
				Integer l1 = Integer.parseInt(level1);
				Integer l2 = Integer.parseInt(level2);
				if (l1 > l2 || s1 > s2) {
					return 1;
				} else {
					return -1;
				}
			}
		});
//		
//		
//		Collections.sort(resultList, new Comparator<Dimsion>() {
//			public int compare(Dimsion o1, Dimsion o2) {
//				String sstr1 = (String) o1.getLevel();
//				String sstr2 = (String) o2.getLevel();
//				if (sstr1 == null || sstr1.equals(""))
//					sstr1 = "0";
//				if (sstr2 == null || sstr2.equals(""))
//					sstr2 = "0";
//				Integer s1 = Integer.parseInt(sstr1);
//				Integer s2 = Integer.parseInt(sstr2);
//				if (s1 > s2) {
//					return 1;
//				} else {
//					return -1;
//				}
//			}
//		});
		
	} 
	 
	 
	/**
	 * 获得中文名称
	 * @param parentStr
	 * @return
	 */ 
	private String getCNVarName(String parentStr){
		String varName = parentStr;
		List<Dimsion> dims = this.report.getDimsions().getDimsionList();
		for(Dimsion dim : dims){
			if(dim.getVarname().equals(parentStr)){
				if(null!=dim.getConditiontype() && "1".equals(dim.getConditiontype())){
					Pattern pattern = Pattern.compile("[\u4e00-\u9fa5]");
					Matcher matcher = pattern.matcher(dim.getVardesc()); 
					if(!matcher.find()){
						varName = dim.getVardesc();
					}
				}
			}
		}
		return varName;
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
	
	//水印取值
	@SuppressWarnings("unchecked")
	public String getWaterContent(String waterContent){
		String res = "";
		try{
			if(!"".equals(waterContent)&&waterContent!=null){
				waterContent = waterContent.toUpperCase();
				char[] arr = waterContent.toCharArray();
				for(int i=0;i<arr.length;i++){
					String type = String.valueOf(arr[i]);
					if("A".equals(type)){
						String deptcode = ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("DEPT_CODE")+"";
						Map<String,String> dep = runner.queryForMap("SELECT DEPART_CODE, DEPART_DESC, PARENT_CODE FROM E_DEPARTMENT WHERE DEPART_CODE = '"+deptcode+"' ");
						if(null!=dep &&!"".equals(dep.get("DEPART_DESC")) && dep.get("DEPART_DESC")!=null){
							res+= dep.get("DEPART_DESC")+"-";
						}else{
							res+="未知部门-";
						}
					}else if("B".equals(type)){
						String userName = ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("USER_NAME")+"";
						res+=userName+"-";
					}else if("C".equals(type)){
						String dataTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
						res+=dataTime+"-";
					}else if("D".equals(type)){
						String userTel = ((Map)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo")).get("MOBILE")+"";
						res+=userTel+"-";
					}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		if(!"".equals(res)){
			res = res.substring(0,res.length()-1);
		}
		return res;
	}
}
