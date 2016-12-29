package cn.com.easy.xbuilder.parser;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.mbuilder.utils.StringUtil;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Condition;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Datasources;
import cn.com.easy.xbuilder.element.Info;
import cn.com.easy.xbuilder.element.Kpi;
import cn.com.easy.xbuilder.element.Layout;
import cn.com.easy.xbuilder.element.Legend;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Subdrill;
import cn.com.easy.xbuilder.element.Weblink;
import cn.com.easy.xbuilder.element.XAxis;
import cn.com.easy.xbuilder.element.YAxis;
import cn.com.easy.xbuilder.service.DataSetService;
import cn.com.easy.xbuilder.service.component.ComponentBaseService;
import cn.com.easy.xbuilder.service.component.CrossTableService;
import cn.com.easy.xbuilder.service.component.DatagridService;
import cn.com.easy.xbuilder.service.component.TreegridService;

public class XGenerateCompMobile implements XGenerateComp {
	private final Report report;
	private final String type;//
	private final SqlRunner runner;
	private StringBuffer error = new StringBuffer();// 错误信息，如校验错误等
	private final String actionUrl;
	private final Map<Integer, String> num2Abc;// 将excel的列和数字对应，key为数字，值为excel列
	private final String[] defaultColors = new String[]{"#1ea3d5","#d34737","#3b5998", "#1ea3d5","#d34737","#3b5998","#1ea3d5","#d34737","#3b5998","#1ea3d5"};
	private Map<String, String> comp2cont = new HashMap<String, String>();//组件id和容器id对应关系
	public XGenerateCompMobile(Report report,String type,SqlRunner runner){
		this.report = report;
		this.type = type;
		this.runner = runner;
		this.actionUrl = "/pages/xbuilder/usepage/" + this.type + "/" + this.report.getId() + "/" + this.type + "_" + this.report.getId() + "Action.jsp?eaction=";
		this.num2Abc = new HashMap<Integer, String>();
		String[] a_z = new String[] { "A", "B", "C", "D", "E", "F", "G", "H",
				"I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
				"U", "V", "W", "X", "Y", "Z" };
		for (int a = 0; a < a_z.length; a++) {
			this.num2Abc.put(a, a_z[a]);
		}
		for (int th_i = 0; th_i < 2; th_i++) {
			for (int th_j = 0; th_j < 26; th_j++) {
				this.num2Abc.put((th_i + 1) * 26 + th_j, a_z[th_i] + a_z[th_j]);
			}
		}		
	}
	// 生成jsp头
	private String generateJspHead() {
		StringBuffer head = new StringBuffer();
		head.append("<%@ page language=\"java\" pageEncoding=\"UTF-8\"%>").append("\n");
		head.append("<%@page import=\"cn.com.easy.ebuilder.parser.CommonTools\"%>").append("\n");
		head.append("<%@ taglib prefix=\"e\" uri=\"http://www.bonc.com.cn/easy/taglib/e\"%>").append("\n");
		head.append("<%@ taglib prefix=\"c\" uri=\"http://www.bonc.com.cn/easy/taglib/c\"%>").append("\n");
		head.append("<%@ taglib prefix=\"m\" uri=\"http://www.bonc.com.cn/easy/taglib/m\"%>").append("\n");
		head.append("<%@ taglib prefix=\"a\" tagdir='/WEB-INF/tags/app'%>").append("\n");
		XGenerateAction xga = new XGenerateAction(this.report,this.type,false);
		String transcoding = xga.transformSqlParamURI(xga.getReportDataSet());
		head.append(transcoding);
		DataSetService ser = new DataSetService();
	    String urlParam=ser.getResString(this.report.getId());
	    head.append(urlParam).append("\n");
		return head.toString();
	}
	
	
	//处理Condition
	public String transCondition(List<Condition> list){
		String tmp = "";
		for(int i=0;i<list.size();i++){
			Condition condi = list.get(i);
			String cnd = condi.getCond();
			if(!"".equals(cnd)){
				if(i==0){
					tmp+="?"+cnd;
				}else{
					tmp+="&"+cnd;
				}
			}
		}
		return tmp;
	}
	
	//生成页面模版
	public String generateWebLateTag(Component comp){
		StringBuffer webLate = new StringBuffer();
		//用户输入的url
		String userUrl = comp.getUserUrl();
		//取weblink
		Weblink weblink = comp.getWeblink();
		//iframe属性id
		String id = comp.getId();
		//iframe属性width
		String width = comp.getWidth();
		//iframe属性height
		String height = comp.getHeight();
		//iframe属性scrolling
		String scrolling = "auto";
		//iframe属性frameborder
		String frameborder = "0";
		if(weblink!=null){
			List<Condition> list = weblink.getCondition();
			String cnd = this.transCondition(list);
			if(!"".equals(cnd)){
				userUrl+=cnd;
			}
		}
		
		webLate.append("<iframe ");
		webLate.append("id='"+id+"' ");
		webLate.append("src='"+userUrl+"' ");
		webLate.append("width='"+width+"' ");
		webLate.append("height='"+height+"' ");
		webLate.append("scrolling='"+scrolling+"' ");
		webLate.append("frameborder='"+frameborder+"' ");
		webLate.append("</iframe>");
		
		return webLate.toString();
	}
	
	// 生成c:npie
	private String generatePieTag(Component comp) {
		StringBuffer pie = new StringBuffer();
		XAxis xAxis = comp.getXaxis();
		Kpi kpi = comp.getKpiList().get(0);
		
		String colors = comp.getColors();
		String[] customColors = null;
		if(colors != null && !colors.equals("")){
			customColors = colors.split(",");
		}else{
			customColors = this.defaultColors.clone();
		}
		String ringSize = comp.getType().toLowerCase().equals("ring")?"40%":"";
//		pie.append("<c:npie " 
//						+ this.joinProp(comp.getId(), "id")
//						+ this.joinProp(ringSize, "innerSize")
//						//+ "\" legendLayout=\"horizontal\" legendAlign=\"center\" legendVerticalAlign=\"bottom\" "
//						+ this.joinProp(comp.getTitle(), "title")
//						+ this.joinProp(comp.getWidth(), "width")
//						+ this.joinProp(comp.getHeight(), "height")
//						+ this.joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url")
//						+ this.joinProp(kpi.getName(),kpi.getField())
//						+ this.joinProp(xAxis.getDimfield(), "dimension")
//						+ this.joinProp("['"+StringUtils.join(customColors,"','")+"']", "colors")
//						+ this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendVerticalAlign","legendLayout")
//						+ "/>").append("\n");
		
		//取标题是否显示（1:是,0:否,默认为1）
		String showTitle = comp.getShowTitle();
		
		pie.append("<c:npie ");
		pie.append(this.joinProp(comp.getId(), "id"));
		pie.append(this.joinProp("false", "showexport"));
		pie.append(this.joinProp("mobile", "porm"));
		pie.append(this.joinProp("2", "tipfmt"));
		pie.append(this.joinProp(ringSize, "innerSize"));
		if("1".equals(showTitle)){
			pie.append(this.joinProp(comp.getChartTitle(), "title"));
		}
		if(comp.getYaxisList()!=null&&comp.getYaxisList().size()>0){
			pie.append(this.joinProp(comp.getYaxisList().get(0).getUnit(),"unit"));
		}
		//pie.append(this.joinProp(comp.getWidth(), "width"));
		//pie.append(this.joinProp(comp.getHeight(), "height"));
		pie.append(this.joinProp("auto", "width"));
		pie.append(this.joinProp(String.valueOf(Integer.parseInt(comp.getHeight())-40), "height"));
		pie.append(this.joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url"));
		if(null != kpi.getExtcolumnid() && !"".equals(kpi.getExtcolumnid())){
			XExtColumn xec = new XExtColumn(this.report);
			String name = xec.getExtColName(kpi.getExtcolumnid());
			pie.append(this.joinProp(name,name));
		}else{
			pie.append(this.joinProp(kpi.getName(),kpi.getField()));
		}
		pie.append(this.joinProp(xAxis.getDimfield(), "dimension"));
		pie.append(this.joinProp("['"+StringUtils.join(customColors,"','")+"']", "colors"));
		pie.append(this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendVerticalAlign","legendLayout"));
		pie.append("/>\n");
		
		return pie.toString();
	}

	// 生成c:nline
	private String generateLineTag(Component comp) {
		StringBuffer line = new StringBuffer();
		XAxis xAxis = comp.getXaxis();
//		line.append(
//				"<c:nline " 
//						+ this.joinProp(comp.getId(), "id")
//						//+ "\" legend=\"true\" legendAlign=\"right\" "
//						+ this.joinProp(comp.getTitle(), "title")
//						+ this.joinProp(this.actionUrl + comp.getId()
//								+ "${urlParam}", "url")
//						+ this.joinProp(comp.getWidth(), "width")
//						+ this.joinProp(comp.getHeight(), "height")
//						+ this.joinProp(xAxis.getDimfield(), "dimension")
//						+ this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendValign","legendLayout")
//						+ this.generateYAxisAndKpi(comp) + "/>").append("\n");
		
		//取标题是否显示（1:是,0:否,默认为1）
		String showTitle = comp.getShowTitle();
		
		line.append("<c:nline ");
		line.append(this.joinProp(comp.getId(), "id"));
		line.append(this.joinProp("false", "showexport"));
		line.append(this.joinProp("mobile", "porm"));
		if("1".equals(showTitle)){
			line.append(this.joinProp(comp.getChartTitle(), "title"));
		}
		line.append(this.joinProp(this.actionUrl+comp.getId()+"${urlParam}", "url"));
		line.append(this.joinProp("auto", "width"));
		line.append(this.joinProp(String.valueOf(Integer.parseInt(comp.getHeight())-40), "height"));
		line.append(this.joinProp(xAxis.getDimfield(), "dimension"));
		line.append(this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendValign","legendLayout"));
		line.append(this.generateYAxisAndKpi(comp));
		line.append("/>\n");
		
		return line.toString();
	}
	
	// 生成c:nbar
	private String generateBarTag(Component comp) {
		StringBuffer column = new StringBuffer();
		XAxis xAxis = comp.getXaxis();
//		column.append(
//				"<c:nbar " 
//						+ this.joinProp(comp.getId(), "id")
//						//+ "\" legend=\"true\" legendAlign=\"right\" "
//						+ this.joinProp(comp.getTitle(), "title")
//						+ "yaxis=\""
//						+ this.joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url")
//						+ this.joinProp(comp.getWidth(), "width")
//						+ this.joinProp(comp.getHeight(), "height")
//						+ this.joinProp(xAxis.getDimfield(), "dimension")
//						+ this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendVerticalAlign","legendLayout")
//						+ this.generateYAxisAndKpi(comp) + "/>").append("\n");
		
		//取标题是否显示（1:是,0:否,默认为1）
		String showTitle = comp.getShowTitle();
		
		column.append("<c:nbar ");
		column.append(this.joinProp(comp.getId(), "id"));
		column.append(this.joinProp("false", "showexport"));
		column.append(this.joinProp("mobile", "porm"));
		if("1".equals(showTitle)){
			column.append(this.joinProp(comp.getChartTitle(), "title"));
		}
		column.append(joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url"));
		column.append(this.joinProp("auto", "width"));
		column.append(this.joinProp(String.valueOf(Integer.parseInt(comp.getHeight())-40), "height"));
		column.append(this.joinProp(xAxis.getDimfield(), "dimension"));
		column.append(this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendVerticalAlign","legendLayout"));
		column.append(this.generateYAxisAndKpi(comp) + "/>"+"\n");
		
		return column.toString();
	}

	// 生成c:ncolumn
	private String generateColumnTag(Component comp) {
		StringBuffer column = new StringBuffer();
		XAxis xAxis = comp.getXaxis();
//		column.append(
//				"<c:ncolumn " 
//						+ this.joinProp(comp.getId(), "id")
//						//+ "\" legend=\"true\" legendAlign=\"right\" "
//						+ this.joinProp(comp.getTitle(), "title")
//						+ this.joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url")
//						+ this.joinProp(comp.getWidth(), "width")
//						+ this.joinProp(comp.getHeight(), "height")
//						+ this.joinProp(xAxis.getDimfield(), "dimension")
//						+ this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendValign","legendLayout")
//						+ this.generateYAxisAndKpi(comp) + "/>").append("\n");
		
		//取标题是否显示（1:是,0:否,默认为1）
		String showTitle = comp.getShowTitle();
		
		column.append("<c:ncolumn ");
		column.append(this.joinProp(comp.getStacking(), "stacking"));
		column.append(this.joinProp(comp.getId(), "id"));
		column.append(this.joinProp("false", "showexport"));
		column.append(this.joinProp("mobile", "porm"));
		if("1".equals(showTitle)){
			column.append(this.joinProp(comp.getChartTitle(), "title"));
		}
		column.append(joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url"));
		column.append(this.joinProp("auto", "width"));
		column.append(this.joinProp(String.valueOf(Integer.parseInt(comp.getHeight())-40), "height"));
		column.append(this.joinProp(xAxis.getDimfield(), "dimension"));
		column.append(this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendValign","legendLayout"));
		column.append(this.generateYAxisAndKpi(comp) + "/>"+"\n");
		
		return column.toString();
	}

	// 生成c:catter，指标颜色为#fff时，不设置颜色；非#fff时，替换数组里对应的下标
	private String generateCatterTag(Component comp) {
		StringBuffer catter = new StringBuffer();
		String colors = comp.getColors();
		if(colors == null || colors.equals("")){
			colors = "rgba(255,97,3,.5);rgba(61,145,64,.5);rgba(255,215,0,.5);rgba(107,142,35,.5);rgba(112,128,105,.5);rgba(128,138,135.5)";
		}
		XAxis xAxis = comp.getXaxis();
//		catter.append("<c:scatter " 
//						+ this.joinProp(comp.getId(), "id")
//						//+ "\" legend=\"true\" legendAlign=\"right\" "
//						+ this.joinProp(comp.getTitle(), "title")
//						+ this.joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url")
//						+ this.joinProp(comp.getWidth(), "width")
//						+ this.joinProp(comp.getHeight(), "height")
//						+ this.generateChatLegend(comp.getLegend(),"showLegend","legendAlign","legendVerticalAlign","legendLayout")
//						+ this.joinProp(xAxis.getDimfield(), "dimension"));
		
		//取标题是否显示（1:是,0:否,默认为1）
		String showTitle = comp.getShowTitle();
		
		catter.append("<c:scatter ");
		catter.append(this.joinProp(comp.getId(), "id"));
		catter.append(this.joinProp("false", "showexport"));
		catter.append(this.joinProp("mobile", "porm"));
		if("1".equals(showTitle)){
			catter.append(this.joinProp(comp.getChartTitle(), "title"));
		}
		catter.append(this.joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url"));
		catter.append(this.joinProp("auto", "width"));
		catter.append(this.joinProp(String.valueOf(Integer.parseInt(comp.getHeight())-40)+"px", "height"));
		catter.append(this.generateChatLegend(comp.getLegend(),"showLegend","legendAlign","legendVerticalAlign","legendLayout"));
		catter.append(this.joinProp(xAxis.getDimfield(), "dimension"));
		
		List<YAxis> yaxisList = comp.getYaxisList();
		List<Kpi> kpiList = comp.getKpiList();
		String xaxisText="",indicatorX="",unitX="",yaxisText="",indicatorY="",unitY="";
		XExtColumn xec = new XExtColumn(this.report);
		for(int y=0;y<yaxisList.size();y++){
			YAxis yAxis = yaxisList.get(y);
			if(yAxis.getId().toUpperCase().equals("X")){
				xaxisText = yAxis.getTitle();
				unitX = yAxis.getUnit();
			}else if(yAxis.getId().toUpperCase().equals("Y")){
				yaxisText = yAxis.getTitle();
				unitY = yAxis.getUnit();
			}
			
			Kpi kpi = kpiList.get(y);
			if(null != kpi.getExtcolumnid() && !"".equals(kpi.getExtcolumnid())){
				if(kpi.getYaxisid().toUpperCase().equals("X")){
					indicatorX = xec.getExtColName(kpi.getExtcolumnid());
				}else if(kpi.getYaxisid().toUpperCase().equals("Y")){
					indicatorY = xec.getExtColName(kpi.getExtcolumnid());
				}
			}else{
				if(kpi.getYaxisid().toUpperCase().equals("X")){
					indicatorX = kpi.getField();
				}else if(kpi.getYaxisid().toUpperCase().equals("Y")){
					indicatorY = kpi.getField();
				}
			}
		}
		catter.append(this.joinProp(colors, "colors"));
		catter.append(this.joinProp(indicatorX, "indicatorX")).append(this.joinProp(indicatorY, "indicatorY"));
		catter.append(this.joinProp(xaxisText, "xaxisText")).append(this.joinProp(yaxisText, "yaxisText"));
		catter.append(this.joinProp(unitX, "unitX")).append(this.joinProp(unitY, "unitY")).append("/>\n");
		
		return catter.toString();
	}
	
	// 生成c:ncolumnline
	private String generateCollineTag(Component comp) {
		StringBuffer colline = new StringBuffer();
		XAxis xAxis = comp.getXaxis();
//		colline.append(
//				"<c:ncolumnline " 
//						+ this.joinProp(comp.getId(), "id")
//						//+ "\" legend=\"true\" legendAlign=\"right\" "
//						//+ this.joinProp(comp.getTitle(), "title")
//						+ this.joinProp(this.actionUrl + comp.getId()
//								+ "${urlParam}", "url")
//						+ this.joinProp(comp.getWidth(), "width")
//						+ this.joinProp(comp.getHeight(), "height")
//						+ this.joinProp(xAxis.getDimfield(), "dimension")
//						+ this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendValign","legendLayout")
//						+ this.generateYAxisAndKpi(comp) + "/>").append("\n");
		
		//取标题是否显示（1:是,0:否,默认为1）
		String showTitle = comp.getShowTitle();
		
		colline.append("<c:ncolumnline ");
		colline.append(this.joinProp(comp.getStacking(), "stacking"));
		colline.append(this.joinProp(comp.getId(), "id"));
		colline.append(this.joinProp("false", "showexport"));
		colline.append(this.joinProp("mobile", "porm"));
		if("1".equals(showTitle)){
			colline.append(this.joinProp(comp.getChartTitle(), "title"));
		}
		colline.append(this.joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url"));
		colline.append(this.joinProp("auto", "width"));
		colline.append(this.joinProp(String.valueOf(Integer.parseInt(comp.getHeight())-40), "height"));
		colline.append(this.joinProp(xAxis.getDimfield(), "dimension"));
		colline.append(this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendValign","legendLayout"));
		colline.append(this.generateYAxisAndKpi(comp) + "/>");
		colline.append("\n");
		
		return colline.toString();
	}
	
	//通用，生成多轴及指标c:nline,c:ncolum,c:nbar,c:ncolumnline
	private String generateYAxisAndKpi(Component comp) {
		//yaxis="title:一轴,unit:元,min:0;title:二轴,unit:戶;title:三轴,unit:万"
		StringBuffer yAxisAndKpiBuf = new StringBuffer();
		String colors = comp.getColors();
		String[] customColors = null;
		if(colors != null && !colors.equals("")){
			customColors = colors.split(",");
		}else{
			customColors = this.defaultColors.clone();
		}
		yAxisAndKpiBuf.append("yaxis=\"");
		List<YAxis> yAxisList = comp.getYaxisList();
		Map<String,Integer> yAxisOrd = new HashMap<String,Integer>();
		for(int y=0;y<yAxisList.size();y++){
			YAxis yAxis = yAxisList.get(y);
			yAxisOrd.put(yAxis.getId(),y);
			yAxisAndKpiBuf.append(delComma(this.joinPropAll(yAxis.getTitle(), "title")
					+ this.joinPropAll(yAxis.getUnit(), ",unit")
					+ this.joinProps(yAxis.getMin(), ",min")
					+ this.joinProps(yAxis.getMax(), ",max")
					+ this.joinPropAll(yAxis.getColor(), ",color"))
					+";"
			);
		}
		yAxisAndKpiBuf.deleteCharAt(yAxisAndKpiBuf.length()-1).append("\" ");
		List<Kpi> kpis = comp.getKpiList();
		XExtColumn xec = new XExtColumn(this.report);
		for (int i = 0; i < kpis.size(); i++) {
			Kpi kpi = kpis.get(i);
			
			if(null != kpi.getExtcolumnid() && !"".equals(kpi.getExtcolumnid())){
				String name = xec.getExtColName(kpi.getExtcolumnid());
				yAxisAndKpiBuf.append(name + "=\"name:" + name+this.joinProps(String.valueOf(yAxisOrd.get(kpi.getYaxisid())), ",yaxis")+this.joinProps(kpi.getType(), ",type")+this.joinProps(kpi.getColor(), ",color") + "\" ");
			}else{
				yAxisAndKpiBuf.append(kpi.getField() + "=\"name:" + kpi.getName()+this.joinProps(String.valueOf(yAxisOrd.get(kpi.getYaxisid())), ",yaxis")+this.joinProps(kpi.getType(), ",type")+this.joinProps(kpi.getColor(), ",color") + "\" ");
			}
			
			String color = kpi.getColor();
			if(color != null && !color.equals("") && !color.toLowerCase().equals("#fff")){
				customColors[i] = color;
			}
		}
		yAxisAndKpiBuf.append(this.joinProp("['"+StringUtils.join(customColors,"','")+"']", "colors"));
		return yAxisAndKpiBuf.toString();
	}
	
	//通用，图形生成图例
	//attr1 是否显示；attr2 左右对齐legendAlign；attr3 上下对齐verticalAlign；attr4 图例展示方式layout
	private String generateChatLegend(Legend legend,String attr1,String attr2,String attr3,String attr4) {
		if(legend != null){
			//top/bottom/left/right
			StringBuffer legendBuf = new StringBuffer();
			legendBuf.append(this.joinProp(legend.getIsShow(), attr1));
			if(legend.getIsShow().equals("true")){
				String position = legend.getPosition();
				if(position.equals("top")){
					legendBuf.append(this.joinProp("center",attr2));
					legendBuf.append(this.joinProp("top",attr3));
					legendBuf.append(this.joinProp("horizontal",attr4));
				}else if(position.equals("bottom")){
					legendBuf.append(this.joinProp("center",attr2));
					legendBuf.append(this.joinProp("bottom",attr3));
					legendBuf.append(this.joinProp("horizontal",attr4));
				}else if(position.equals("left")){
					legendBuf.append(this.joinProp("left",attr2));
					legendBuf.append(this.joinProp("middle",attr3));
					legendBuf.append(this.joinProp("vertical",attr4));
				}else if(position.equals("right")){
					legendBuf.append(this.joinProp("right",attr2));
					legendBuf.append(this.joinProp("middle",attr3));
					legendBuf.append(this.joinProp("vertical",attr4));
				}
			}
			return legendBuf.toString();
		}
		return "";
	}

	// 生成m:datagrid
	private String generateDatagridTag(Component comp) {
		StringBuffer datagrid = new StringBuffer();
		String lockNum = comp.getTablecollock();
		String subtotal = comp.getTableshowrowtotal();
		String dgurl = subtotal !=null && subtotal.equals("1")?"/datagridsubtotal.e?xid="+this.report.getId()+"&type="+this.type+"&compid=" + comp.getId() + "${urlParam}":this.actionUrl + comp.getId() + "${urlParam}";
		
		//String pagination = comp.getTablepagi();
		//String download = comp.getTableexport();
		lockNum = lockNum.equals("1")?comp.getTablecollocknum():"";
		//pagination = (pagination != null && pagination.equals("1"))? "true" :"false";
		//download = (download == null || download.equals("0"))?"":comp.getTitle().equals("")?"表格数据下载":comp.getTitle();
		
		datagrid.append("<m:datagrid id=\""+ comp.getId()+ "\" "
				+ this.joinProp(dgurl,"url")
				//+ this.joinProp(pagination,"pagination")
				//+ this.joinProp(download,"download")
				
				//+ this.joinProp("auto", "width", "grid")
				+ this.joinProp(comp.getHeight(), "height", "grid")
				//+ this.joinProp("auto", "height", "grid")
				+ "select=\"row\" >" );
//				+ "select=\"row\" " + this.joinProp(lockNum, "frozenColumn")
//				+ ">");
		Map<String, String> heads = this.str2Head(comp);
		
		//获得上一个方法的iscolspan的值（1有，0无）
		String isColspan = heads.get("isColspan");
		if("0".equals(isColspan)){
			datagrid.insert(datagrid.length()-1, " "+this.joinProp(lockNum, "frozenColumn")+" ");
		}
		
		datagrid.append(heads.get("head").replaceAll("<table>", "").replaceAll(
				"</table>", "").replace("rowspan=\"1\"", "").replace(
				"colspan=\"1\"", ""));
		datagrid.append("</m:datagrid>").append("\n");

		datagrid.insert(0, "</script>\n");
		datagrid.insert(0, heads.get("script"));
		datagrid.insert(0, "<script language=\"javascript\">\n");

		return datagrid.toString();
	}

	// 生成m:treegrid
	private String generateTreegridTag(Component comp) {
		StringBuffer treegrid = new StringBuffer();
		List<Subdrill> subdrills = new ArrayList<Subdrill>(comp.getSubdrills().getSubdrillList());
		ComparatorSubDrill csd = new ComparatorSubDrill();
		Collections.sort(subdrills, csd); 
		
		String dDim = "";
		String hasHeJiDim = comp.getHastotalflag();//是否为虚拟合计
		if(hasHeJiDim != null && hasHeJiDim.equals("1")){
			dDim = "all";
		}
		StringBuffer drill = new StringBuffer();
		if (subdrills != null && subdrills.size() > 0) {
			for (Subdrill subdrill : subdrills) {
				if (subdrill.getIsdefault().equals("1")) {
					dDim += "," + subdrill.getDrillcode();
				}
				drill.append(
						"<m:dimension label=\"" + subdrill.getDrillcoltitle()
								+ "\" field=\"" + subdrill.getDrillcode()
								+ "\" "
								+ this.joinProp(subdrill.getLevel(), "level")
								+ "></m:dimension>").append("\n");
			}
		}

		dDim = dDim.equals("")?subdrills.get(0).getDrillcode():dDim;
		treegrid.append("<m:treegrid id=\""
				+ comp.getId()
				+ "\" idField=\""+comp.getIdfield()+"\" height=\""+String.valueOf(Integer.parseInt(comp.getHeight())-40)+"\" treeField=\""+comp.getTreefield()+"\" "
				+ this.joinProp(comp.getTreefieldtitle(), "treeFieldTitle")
				+ this.joinProp(comp.getFieldwidth(), "treeFieldWidth")
				+ this.joinProp(this.actionUrl + comp.getId() + "${urlParam}",
						"url") + " defaultDim=\"" + dDim + "\" "
				+ this.joinProp(comp.getContextmenuwidth(), "menuWidth") + ">");
		Map<String, String> heads = this.str2Head(comp);
		treegrid.append("<jsp:attribute name=\"treeHead\">" + heads.get("head")
				+ "</jsp:attribute>");
		treegrid.append("<jsp:body>");
		treegrid.append(drill.toString());
		treegrid.append("</jsp:body>");
		treegrid.append("</m:treegrid>\n");

		treegrid.insert(0, "</script>\n");
		treegrid.insert(0, heads.get("script"));
		treegrid.insert(0, "<script language=\"javascript\">\n");
		return treegrid.toString();
	}
	// 生成所有组件，根据类型调用具体的每个组件生成方法。
	private boolean generateTag() {
		boolean code = true;
		List<Component> comps = new ArrayList<Component>();
		List<Container> containers = this.report.getContainers().getContainerList();
		for(int c=0;c<containers.size();c++){
			Container container = containers.get(c);
			List<Component> components = container.getComponents().getComponentList();
			if(components != null && components.size()>0){
				String w = containers.get(c).getWidth();
				String h = containers.get(c).getHeight();
				for(int p=0;p<components.size();p++){
					components.get(p).setWidth(w);
					components.get(p).setHeight(h);
					this.comp2cont.put(components.get(p).getId(), container.getId());
				}
				comps.addAll(components);
			}
		}
		if (comps == null || comps.size() <= 0) {
			return false;
		}
		
		StringBuffer tag = new StringBuffer();
		String jspheadString = this.generateJspHead();
		for (Component comp : comps) {
			tag.append(jspheadString);
			//tag.append("<div class=\"mbuliderC\">\n");
			//tag.append(this.joinTitle(comp.getTitle())).append("\n");
			tag.append("<div>\n");
			
			String type = this.getCompKind(comp.getType().toLowerCase());
			tag.append("<a:watermark id=\""+comp.getId()+"\"/>\n");
			if (type.equals("pie")) {
				tag.append(this.generatePieTag(comp));
			} else if (type.equals("line")) {
				tag.append(this.generateLineTag(comp));
			} else if (type.equals("bar")) {
				tag.append(this.generateBarTag(comp));
			} else if (type.equals("column")) {
				tag.append(this.generateColumnTag(comp));
			} else if (type.equals("scatter")) {
				tag.append(this.generateCatterTag(comp));
			} else if (type.equals("columnline")) {
				tag.append(this.generateCollineTag(comp));
			} else if (type.equals("datagrid")) {
				//暂时不用（生成水印得在SESSION中配置信息）
//				tag.append("<a:watermark id=\""+comp.getId()+"\"/>\n");
				tag.append(this.generateDatagridTag(comp));
			} else if (type.equals("treegrid")) {
				//暂时不用（生成水印得在SESSION中配置信息）
//				tag.append("<a:watermark id=\""+comp.getId()+"\"/>\n");
				tag.append(this.generateTreegridTag(comp));
			} else if (type.equals("crosstable")) {
				//未实现
			} else if(type.equals("weblate")){
				tag.append(this.generateWebLateTag(comp));
			}
			//tag.append("</div></div>\n");
			tag.append("</div>\n");
			String root = this.getClass().getClassLoader().getResource("/").getPath().replace("WEB-INF/classes/", "/");
			String path = "pages/xbuilder/usepage/" + this.type + "/" + this.report.getId() + "/comp_" + comp.getId() + ".jsp";
			boolean opt = this.newFile(root + path, tag.toString(),"comp_" + comp.getId() + ".jsp");
			if(!opt){
				code = false;
				this.error.append("||||生成"+comp.getTitle()+"_"+comp.getType()+"组件时发生错误");
				break;
			}else{
				tag.delete(0, tag.length()-1);
			}
		}
		return code;
	}
	
	
	/**
	 * 表格使用。将xml中头源数据，解析为组件可用的头代码。 1、删除掉没使用的td 2、剃掉td中所有的class和style样式。
	 * 3、将设置的td属性，添加进来，如宽度，格式化等。 4、删除掉没使用的tr 2014-10-31 修改：返回为map，包含表头和列的格式化函数
	 */
	private Map<String, String> str2Head(Component comp) {

		/**
		 * 将所有列添加到map中，这样只需要循环一次。
		 */
		Map<String, Datacol> datacolMaps = new HashMap<String, Datacol>();
		List<Datacol> datacols = comp.getDatastore().getDatacolList();
		for (Datacol datacol : datacols) {
			datacolMaps.put(Integer.parseInt(datacol.getTablerowcode())-1 + "_"+ datacol.getTablecolcode(), datacol);
		}

		String compType = comp.getType();
		StringBuffer head = new StringBuffer();
		StringBuffer script = new StringBuffer();
		head.append("<table><thead>");
		Document doc = Jsoup.parse("<table>" + comp.getHeadui().getText()
				+ "</table>");
		Elements trs = doc.select("tr");
		String isColspan="0";
		// 删除无用的td和添加td属性
		Pattern p = Pattern.compile("\\s*|\t|\r|\n");
		for (Element tr : trs) {
			tr.select("th").remove();
			Elements tds = tr.select("td");
			for (Element td : tds) {
				Matcher m = p.matcher(td.text());
				if (this.notNull(m.replaceAll("")) && this.notNull(td.attr("ishead")) && td.attr("ishead").equals("1")) {
					td.removeAttr("class").removeAttr("style");
					String col = td.attr("tdInd");
					
					if(compType.toLowerCase().equals("treegrid") && col.equals("1")){
						td.remove();
						continue;
					}
					
					String rows = td.attr("istt").replaceAll("td", "");
					String rowspan = td.attr("rowspan");
					String colspan = td.attr("colspan");
					if(!"".equals(colspan)&&colspan!=null)isColspan="1";
					if(rowspan != null && !rowspan.equals("")){
						int rowtmp = Integer.parseInt(rowspan)-1;
						rows = String.valueOf(rowtmp+Integer.parseInt(rows));
					}
					col = this.num2Abc.get(Integer.parseInt(col) - 1);
					Datacol datacol = datacolMaps.get(rows+ "_" + col);
					if (datacol == null) {
						continue;
					}
					//String tdWidth = datacol.getTableheadwidth();
					String filed = datacol.getDatacolcode();
					String align = datacol.getDatafmtalign();
/*					if (notNull(tdWidth)) {
						td.attr("width", tdWidth);
					}*/
					if (notNull(filed)) {
						String tmptxt = td.text();
						if(tmptxt.indexOf("<")>0){
							Pattern pattern = Pattern.compile("<.*(?i)(br)+.*>");
							Matcher matcher = pattern.matcher(tmptxt);
							td.text(matcher.replaceAll("（BR）"));
						}
						//td.attr("field", filed.toUpperCase());
						td.attr("field", filed);
					}
					if (notNull(align)) {
						td.attr("align", align);
					}else{
						if(datacol.getDatacoltype().equals("dim")) {
							td.attr("align", "center");
						}else{
							td.attr("align", "right");
						}
					}
					String width = td.attr("width");
					String styleStr = td.attr("style");
					if(("".equals(width) || width==null) && ("".equals(styleStr) || styleStr==null || styleStr.indexOf("width")<=0)){
						td.attr("width", "100");
					}
			

					// 以下四者有其一选中，需要生成格式化函数
					boolean isFmtBD = notNull(datacol.getDatafmtisbd())	&& datacol.getDatafmtisbd().toLowerCase().equals("1");// 格式化数据：是否设置边界判断
					boolean dFmtT = !datacol.getDatafmttype().equals("common");// 格式化数据类型
					boolean dFmtTD = notNull(datacol.getDatafmtthousand())&& datacol.getDatafmtthousand().toLowerCase().equals("1");// 格式化数据：是否显示千位符
					boolean dArrow = notNull(datacol.getDatafmtisarrow())&& datacol.getDatafmtisarrow().toLowerCase().equals("1");// 格式化数据：是否显示增减箭头
					//boolean event = (datacol.getEventstore() != null && datacol.getEventstore().getEventList() != null&& datacol.getEventstore().getEventList().size() >0)?true:false;//联动

					String suffixUP = dArrow ? "&uarr;" : "";// ↑
					String suffixDW = dArrow ? "&darr;" : "";// ↓
					//if (isFmtBD || dFmtTD || dArrow || dFmtT || event) {
					if (isFmtBD || dFmtTD || dArrow || dFmtT) {
						String fun1 = datacol.getTablecolcode() + "_"+comp.getId();
						td.attr("formatter", fun1);
						script.append("function " + fun1 + "(obj){").append("\n");
						script.append("var v = obj."+filed+";").append("\n");

						if(dFmtT){
							if (datacol.getDatafmttype().equals("percent")) {
								script.append("v = transformValue(obj." + filed + ","+ datacol.getDatadecimal()+ ",100,'%'," + dFmtTD + ");").append("\n");
							} else {
								script.append("v = transformValue(obj." + filed + ","+ datacol.getDatadecimal()+ ",1,''," + dFmtTD + ");").append("\n");
							}
						}
						if (isFmtBD) {
							script.append("if(obj." + filed + " >= "+ datacol.getDatafmtisbdvalue()+ "){").append("\n");
							script.append("v='<font color="+ datacol.getDatafmtbdup()+ ">'+v+'" + suffixUP+ "</font>';").append("\n");
							script.append("}else{").append("\n");
							script.append("v='<font color="+ datacol.getDatafmtbddown()+ ">'+v+'" + suffixDW+ "</font>';").append("\n");
							script.append("}").append("\n");
						}
						script.append("return v;}").append("\n");
						
/*						if(event){
							DataSetService ser = new DataSetService();
							Map<String,String> parammap = ser.getResObj(this.report.getId());
							Eventstore eventstore = datacol.getEventstore();
							Map<String,StringBuffer> paraMap = new HashMap<String,StringBuffer>();
							StringBuffer paraObj_Value = new StringBuffer();
							StringBuffer paraValue = new StringBuffer();
							StringBuffer paraStrs = new StringBuffer();
							List<Event> events = eventstore.getEventList();
							String fieldexd = "";
							if(this.report.getInfo().getType().equals("2")){
								fieldexd = "_code";
							}
							for(int e=0;e<events.size();e++){
								StringBuffer paraObj = new StringBuffer();
								List<Parameter> parameters = events.get(e).getParameterList();
								if(parameters != null && parameters.size()>0){
									for(int para=0;para<parameters.size();para++){
										String value = parameters.get(para).getValue()+fieldexd;
										if(value != null && !value.equals("")){
											String pname = parameters.get(para).getName();
											paraObj.append(pname+":"+value+",");
											if(parammap.containsKey(pname)){
												parammap.remove(pname);
											}
											paraObj_Value.append("\\''+obj."+value+"+'\\',");
											paraValue.append(value+",");
											paraStrs.append(pname+"='+"+value+"+'&");
										}
									}
									if(paraObj.length()>0){
										paraObj.deleteCharAt(paraObj.length()-1).insert(0,"{").append("}");
										paraMap.put(events.get(e).getSource(), paraObj);
									}
								}else{
									paraMap.put(events.get(e).getSource(), paraObj);
								}
							}
							if(paraObj_Value.length()>0){
								paraObj_Value.deleteCharAt(paraObj_Value.length()-1);
								paraValue.deleteCharAt(paraValue.length()-1);
								paraStrs.deleteCharAt(paraStrs.length()-1);
							}
							
							script.append("return '<a href=\"javascript:void(0);\"  style=\"text-decoration:underline;\" onclick=\"F"+comp.getId() + "_"+ datacol.getDatacolcode()+"_event("+paraObj_Value.toString()+");\">");
							script.append("'+v+'</a>';").append("\n}").append("\n");
							
							script.append("function F"+comp.getId() + "_"+ datacol.getDatacolcode()+"_event("+paraValue.toString()+"){").append("\n");
							String type = datacol.getEventstore().getType();
							if(type.equals("link")){
								String linkurl = events.get(0).getSource();
								script.append("window.open('pages/xbuilder/usepage/formal/"+ linkurl+ "/formal_"+ linkurl + ".jsp?a=1&"+paraStrs.toString()+"${urlParam}');");
							}else if(type.equals("cas")){
								for(String key:paraMap.keySet()){
									//StringBuffer paras = paraMap.get(key);
									String queryParam = "";
									if(parammap.size()>0){
										for(String pkey:parammap.keySet()){
											//queryParam += ","+pkey+":'"+parammap.get(pkey);
											queryParam += "&"+pkey+"="+parammap.get(pkey).replaceAll("'","");
										}
									}
									//String postparams = paras.length()>0?paras.insert(paras.length()-1,queryParam).toString():"{}";
									script.append("var divHeadLi_"+key+"=$('#div_head_li_"+this.comp2cont.get(key)+"_"+key+"');\n");
									script.append("if(divHeadLi_"+key+".parent().attr('ultype')=='r'){//切换\n");
									script.append("$('#div_head_li_"+this.comp2cont.get(key)+"_"+key+"').addClass('selected-tab-r').attr('selectLi','true').siblings('li').removeClass('selected-tab-r').removeAttr('selectLi');\n");
									script.append("}else if(divHeadLi_"+key+".parent().attr('ultype')=='l'){//选项卡\n");
									script.append("$('#div_head_li_"+this.comp2cont.get(key)+"_"+key+"').attr('selectLi','true').find('a').addClass('selected-tab-l').parent().siblings('li').removeAttr('selectLi').find('a').removeClass('selected-tab-l');\n");
									script.append("}\n$('#div_body_"+this.comp2cont.get(key)+"').html('');\n");
									script.append("$('#div_body_"+this.comp2cont.get(key)+"').load('pages/xbuilder/usepage/"+this.type+"/"+this.report.getId()+"/comp_"+key+".jsp"+"?componentId="+key+"&containerId="+this.comp2cont.get(key)+"&"+paraStrs.toString()+queryParam+"',function(data){\n");
									script.append("$.parser.parse($('#div_body_"+this.comp2cont.get(key)+"'));});\n");
								}
							}
							script.append("\n}");
						}*/
					}
				} else {
					td.remove();
				}
			}
		}

		// 删除无用的tr
		for (int i = 0; i < trs.size(); i++) {
			Element tr = trs.get(i);
			Elements tds = tr.select("td");
			if (tds == null || tds.size() <= 0) {
				trs.remove(i);
				i--;
			}
		}
		head.append(trs.toString().replaceAll("<th ", "<td ").replaceAll("</th>","</td>").replaceAll("（BR）","<br/>"));
		head.append("</thead></table>");
		Map<String, String> codes = new HashMap<String, String>();
		codes.put("head", head.toString());
		codes.put("script", script.toString());
		codes.put("isColspan", isColspan);
		return codes;
	}
	
	// 工具方法，拼接所有组件的title，title需要特殊处理
	private String joinTitle(String title) {
		if (this.notNull(title)) {
			return "<h3><b class=\"icon\"></b>" + title + "</h3>\n";
		} else {
			return "";
		}
	}

	// 工具方法，判断字符串是否为空，剔空格
	private boolean notNull(String s) {
		try {
			if (s != null && !s.equals("") && s.trim().length() > 0) {
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {
			return false;
		}
	}

	// 工具方法，拼接组件的属性值，非空时
	private String joinProp(String v, String k) {
		if (!this.notNull(v)) {
			return k.equals("width") ? k + "=\"auto\" "
					: k.equals("height") ? k + "=\"225\" " : "";
		} else {
			return k + "=\"" + v + "\" ";
		}
	}

	// 工具方法，拼接组件的属性值，非空时
	private String joinProp(String v, String k, String t) {
		if (!this.notNull(v)) {
			if (t.equals("char")) {
				return k.equals("width") ? k + "=\"auto\" " : k
						.equals("height") ? k + "=\"225\" " : "";
			} else if (t.equals("grid")) {
				return "";
			}
			return "";
		} else {
			return k + "=\"" + v + "\" ";
		}
	}

	// 工具方法，拼接组件的属性值，非空时
	private String joinProps(String v, String k) {
		if (!this.notNull(v)) {
			return k.equals("width") ? k + ":auto" : k.equals("height") ? k
					+ ":225" : "";
		} else {
			if (k.equals(",color") && v.equals("#fff")) {
				return "";
			}
			return k + ":" + v;
		}
	}
	// 工具方法，拼接组件的属性值
	private String joinPropAll(String v, String k) {
		return k + ":" + v;
	}

	// 工具方法，处理多余的逗号
	private String delComma(String s) {
		if (this.notNull(s)) {
			if (s.startsWith(",")) {
				s = s.substring(1);
				delComma(s);
			}
			if (s.endsWith(",")) {
				s = s.substring(0, s.length() - 1);
				delComma(s);
			}
			return s;
		} else {
			return "";
		}
	}
	
	// 工具方法，处理多余的逗号
	private String getCompKind(String name){
		String[] pies = {"pie","ring"};
		String[] lines = {"line","line2","line3"};
		String[] bars = {"bar","bar2","bar3"};
		String[] columns = {"column","column2","column3"};
		String[] columnline = {"columnline","columnline2","columnline3"};
		String kind = ArrayUtils.contains(pies, name)?"pie":ArrayUtils.contains(lines, name)?"line":ArrayUtils.contains(columns, name)?"column":ArrayUtils.contains(columnline, name)?"columnline":ArrayUtils.contains(bars, name)?"bar":name;
		return kind;
	}
	
	private class ComparatorSubDrill implements Comparator{
		public int compare(Object arg0, Object arg1) {
			Subdrill subdrill1 = (Subdrill)arg0,subdrill2 = (Subdrill)arg1;
		
			String v1 = subdrill1.getLevel(),v2 = subdrill2.getLevel();
			return (v1.toLowerCase()).compareTo(v2.toLowerCase());
		}
	}
	
	private boolean tagVerify() {
		try {
			// 验证基本信息和布局等。
			if(StringUtil.getStringValue(report.getId()).equals("")){
				this.error.append("||||<e >严重错误:").append("报表ID获取错误。</e>").append("<br/>\n");
			}
			Info info = this.report.getInfo();
			if(info == null){
				this.error.append("||||<e >严重错误:").append("报表信息初使化错误。</e>").append("<br/>\n");
			}
			if(StringUtil.getStringValue(info.getName()).equals("")){
				this.error.append("||||<e>严重错误:").append("报表报表名称尚未填写。</e>").append("<br/>\n");
			}
			//Dimsions dimsions = this.report.getDimsions();
			Layout layout = this.report.getLayout();
			Datasources datasources = this.report.getDatasources();
			//Query query = this.report.getQuery();
			List<Container> containers = this.report.getContainers().getContainerList();
			//if(containers == null || datasources ==null || query==null||dimsions==null||layout==null)
			if(containers == null || datasources ==null || layout==null)
				this.error.append("||||<e >严重错误:").append("报表源数据初使出错。</e>").append("<br/>\n");
			if(datasources !=null && (datasources.getDatasourceList() ==null || datasources.getDatasourceList().size()<=0)){
				this.error.append("||||<e >严重错误:").append("尚未配置数据集。</e>").append("<br/>\n");
			}
			/*
			if(dimsions !=null && (dimsions.getDimsionList() ==null || dimsions.getDimsionList().size()<=0)){
				errorMessage.append("    <e >严重错误:").append("尚未配置数据集。</e>").append("<br/>\n");
			}*/
			if(layout !=null){
				String lv = layout.getValue();
				if(lv == null || lv.equals("")){
					this.error.append("||||<e >严重错误:").append("尚未设置布局或者设置过程中出错。</e>").append("<br/>\n");
				}
			}
		} catch (Exception e) {
			this.error.append("||||"+e.getMessage() + "\n");
		}

		// 是否包含有效组件。
		List<Component> comps = new ArrayList<Component>();
		List<Container> containers = this.report.getContainers().getContainerList();
		for(int c=0;c<containers.size();c++){
			Container container = containers.get(c);
			List<Component> components = container.getComponents().getComponentList();
			if(components != null && components.size()>0){
				comps.addAll(components);
			}
		}
		if (comps.size()==0) {
			this.error.append("||||没有找到组件\n");
		}

/*		try {
			// 验证数据集和维度
			DataSetService dss = new DataSetService();
			String dssresult = dss.validate(this.report);
			if (!dssresult.equals("")) {
				this.error.append(dssresult + "\n");
			}
		} catch (Exception e) {
			this.error.append(e.getMessage() + "\n");
		}*/

		try {
			// 验证所有组件
			for (Component comp : comps) {
				String type = comp.getType().toLowerCase();
				if (type.equals("datagrid")) {
					//验证表格方法
					DatagridService val = new DatagridService();
					String res = val.validateComponent(this.report,comp);
					if(!"".equals(res)){
						this.error.append(res+"\n");
					}
				} else if (type.equals("treegrid")) {
					TreegridService cbs = new TreegridService();
					String result = cbs.validateComponent(this.report, comp);
					if (!result.equals("")) {
						this.error.append(result + "\n");
					}
				}else if(type.equals("crosstable")){
					CrossTableService crossService = new CrossTableService();
					String res = crossService.validateComponent(this.report,comp);
					if(!"".equals(res)){
						this.error.append(res+"\n");
					}
				}else{
					ComponentBaseService cbs = new ComponentBaseService();
					String cbsresult = cbs.validateAllChartComponent(this.report, comp);
					if (!cbsresult.equals("")) {
						this.error.append(cbsresult + "\n");
					}
				}
			}
		} catch (Exception e) {
			this.error.append("||||"+e.getMessage() + "\n");
		}
		if(this.error.length()>0){
			return false;
		}else{
			return true;
		}
	}
	// 生成jsp文件
	private boolean newFile(String path, String content,String name) {
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
			osw.write(content);
			osw.flush();
			this.compList.put(name, content);
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
	public String comp(XGenerateHtml xhtml) {
		if (!this.tagVerify()) {
			return this.error.toString();
		}
		if(!this.generateTag()){
			return this.error.toString();
		}
		if(!xhtml.saveToFile()){
			return this.error.append("||||生成"+this.report.getInfo().getName()+"报表时失败").toString();
		}
		return "success";
	}
}