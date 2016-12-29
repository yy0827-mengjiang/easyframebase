package cn.com.easy.xbuilder.parser;
/*
 * chenfuquan
 * 对编码进行重构
 */
import java.util.ArrayList;
import java.util.List;

import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.core.EasyContext;

public class XTranscode{
	private final Report report;
	private final boolean isaction;
	private final String istranscode;
	public XTranscode(Report report,boolean isaction){
		this.report = report;
		this.isaction = isaction;
		this.istranscode = String.valueOf(EasyContext.getContext().getServletcontext().getAttribute("xtranscode"));
	}
	public StringBuffer compTc(String paramUrlCode){
		StringBuffer SqlParamURI = new StringBuffer();
		if(paramUrlCode !=null && !paramUrlCode.equals("")){
			paramUrlCode = paramUrlCode.substring(0, paramUrlCode.length()-1);
			String[] paramUrlCodeData = paramUrlCode.split("#");
			List<String> paramUrlCodeList = new ArrayList<String>();
			for (int i = 0; i < paramUrlCodeData.length; i++){
				if (!paramUrlCodeList.contains(paramUrlCodeData[i])) {
					paramUrlCodeList.add(paramUrlCodeData[i]);
				}
			}
			List<Dimsion> dimList =new ArrayList<Dimsion>();
			if(report.getDimsions()!=null){
				dimList=report.getDimsions().getDimsionList();
			}
			for (int i = 0; i < paramUrlCodeList.size(); i++){
				String dimcode = paramUrlCodeList.get(i);
				SqlParamURI.append("<%").append("\n");
				boolean isMuti = false;
				if(isaction && null != dimList && dimList.size()>0){
					for(Dimsion dimsion:dimList){
						String name = dimsion.getVarname();
						if(dimcode.toUpperCase().equals(name.toUpperCase())){
							isMuti = "1".equals(dimsion.getIsselectm())?true:false;
							break;
						}
					}
				}
				this.generateTranscode(SqlParamURI, dimcode, isMuti);
			}
		}else{
			SqlParamURI.append("").append("\n");
		}
		return SqlParamURI;
	}
	private StringBuffer generateTranscode(StringBuffer SqlParamURI,String dimcode,boolean isMuti){
		SqlParamURI.append("boolean isMuti_"+dimcode+"="+isMuti).append(";\n");
		
		if(null != this.istranscode && "1".equals(this.istranscode)){
			SqlParamURI.append("CommonTools commontools_"+dimcode+" = new CommonTools();").append("\n");
		}
		
		SqlParamURI.append("String isMessyCode_").append(dimcode).append(" = request.getParameter(\"").append(dimcode).append("\");").append("\n");
		SqlParamURI.append("if(isMessyCode_").append(dimcode).append(" == null || isMessyCode_").append(dimcode).append(".equals(\"\") || isMessyCode_").append(dimcode).append(".toUpperCase().equals(\"NULL\")){").append("\n");
		SqlParamURI.append("   isMessyCode_").append(dimcode).append(" = request.getAttribute(\"").append(dimcode).append("\") + \"\";").append("\n");
		SqlParamURI.append("}").append("\n");
		SqlParamURI.append("if(isMessyCode_").append(dimcode).append(" == null || isMessyCode_").append(dimcode).append(".equals(\"\") || isMessyCode_").append(dimcode).append(".toUpperCase().equals(\"NULL\")){").append("\n");
		SqlParamURI.append("   isMessyCode_").append(dimcode).append(" = \"-1\".equals(request.getSession().getAttribute(\"").append(dimcode.toUpperCase()).append("\"))?\"\":request.getSession().getAttribute(\"").append(dimcode.toUpperCase()).append("\") + \"\";").append("\n");
		SqlParamURI.append("}").append("\n");
		
		if(null != this.istranscode && "1".equals(this.istranscode)){
			SqlParamURI.append("isMessyCode_").append(dimcode).append(" = isMessyCode_").append(dimcode).append("!=null?new String(isMessyCode_").append(dimcode).append(".getBytes(\"ISO-8859-1\"),\"UTF-8\"):\"\";").append("\n");
		}
		
		if(null != this.istranscode && "1".equals(this.istranscode)){
			SqlParamURI.append("String isMessyCode_").append(dimcode).append("_"+dimcode).append(" = request.getParameter(\"").append(dimcode).append("\");").append("\n");
			SqlParamURI.append("if(isMessyCode_").append(dimcode).append("_"+dimcode).append(" == null || isMessyCode_").append(dimcode).append("_"+dimcode).append(".equals(\"\") || isMessyCode_").append(dimcode).append("_"+dimcode).append(".toUpperCase().equals(\"NULL\")){").append("\n");
			SqlParamURI.append("   isMessyCode_").append(dimcode).append("_"+dimcode).append(" = request.getAttribute(\"").append(dimcode).append("\") + \"\";").append("\n");
			SqlParamURI.append("}").append("\n");
			SqlParamURI.append("if(isMessyCode_").append(dimcode).append("_"+dimcode).append(" == null || isMessyCode_").append(dimcode).append("_"+dimcode).append(".equals(\"\") || isMessyCode_").append(dimcode).append("_"+dimcode).append(".toUpperCase().equals(\"NULL\")){").append("\n");
			SqlParamURI.append("   isMessyCode_").append(dimcode).append("_"+dimcode).append(" = \"-1\".equals(request.getSession().getAttribute(\"").append(dimcode.toUpperCase()).append("\"))?\"\":request.getSession().getAttribute(\"").append(dimcode.toUpperCase()).append("\") + \"\";").append("\n");
			SqlParamURI.append("}").append("\n");
			SqlParamURI.append("isMessyCode_").append(dimcode).append("_"+dimcode).append(" = isMessyCode_").append(dimcode).append("_"+dimcode).append("!=null?new String(isMessyCode_").append(dimcode).append("_"+dimcode).append(".getBytes(\"ISO-8859-1\"),\"gb2312\"):\"\";").append("\n");
		}
		
		if(null != this.istranscode && "1".equals(this.istranscode)){
			SqlParamURI.append("if(!commontools_"+dimcode+".isMessyCode(isMessyCode_").append(dimcode).append(")){").append("\n");
		}
		SqlParamURI.append("if(isMuti_"+dimcode+"){").append("\n");
		SqlParamURI.append("String dimvarname = isMessyCode_"+dimcode+";").append("\n");
		SqlParamURI.append("dimvarname = dimvarname.replaceAll(\",\", \"','\");").append("\n");
		SqlParamURI.append("	request.setAttribute(\"").append(dimcode).append("\",").append("dimvarname").append(");").append("\n");
		SqlParamURI.append("}else{").append("\n");
		SqlParamURI.append("	request.setAttribute(\"").append(dimcode).append("\",isMessyCode_").append(dimcode).append(");").append("\n");
		
		if(null != this.istranscode && "1".equals(this.istranscode)){
			SqlParamURI.append("}").append("\n");
		}
		
		SqlParamURI.append("}").append("\n");
		if(null != this.istranscode && "1".equals(this.istranscode)){
			SqlParamURI.append("else if(!commontools_"+dimcode+".isMessyCode(isMessyCode_").append(dimcode).append("_").append(dimcode).append(")){").append("\n");
			SqlParamURI.append("if(isMuti_"+dimcode+"){").append("\n");
			SqlParamURI.append("String dimvarname = isMessyCode_"+dimcode+"_"+dimcode+";").append("\n");
			SqlParamURI.append("dimvarname = dimvarname.replaceAll(\",\", \"','\");").append("\n");
			SqlParamURI.append("	request.setAttribute(\"").append(dimcode).append("\",").append("dimvarname").append(");").append("\n");
			SqlParamURI.append("}else{").append("\n");
			SqlParamURI.append("	request.setAttribute(\"").append(dimcode).append("\",isMessyCode_").append(dimcode).append("_").append(dimcode).append(");").append("\n");
			SqlParamURI.append("}").append("\n");
			
			SqlParamURI.append("}").append("\n");
		}
		SqlParamURI.append("%>").append("\n");
		return SqlParamURI;
	}
}