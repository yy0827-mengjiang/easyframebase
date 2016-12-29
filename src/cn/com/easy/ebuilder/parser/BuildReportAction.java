package cn.com.easy.ebuilder.parser;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import cn.com.easy.taglib.function.Functions;
import cn.com.easy.util.StringUtils;


public class BuildReportAction {

	private String parseFragmentEnd(String sqlStatement, StringBuffer expression) {
		sqlStatement = StringUtils.stripEnd(sqlStatement, null);
		expression.insert(0, sqlStatement.substring(sqlStatement.lastIndexOf(" ") + 1)).insert(0, " ");
		sqlStatement = sqlStatement.substring(0, sqlStatement.lastIndexOf(" "));
		return StringUtils.stripEnd(sqlStatement, null);
	}

	private int isFunctionLeft(String fragment) {
		int i = StringUtils.lastIndexOf(fragment, "(", ")");
		if ((i != -1) && Character.isWhitespace(fragment.charAt(i - 1))) {
			i = -1;
		}
		return i;
	}

	private int isFunctionRight(String fragment) {
		int i = StringUtils.indexOf(fragment, ")", "(");
		return i;
	}
	
	private int isBeginLeft(String fragment) {
		int i = StringUtils.lastIndexOf(fragment.toLowerCase(), "between", "and");
		if ((i != -1) && Character.isWhitespace(fragment.charAt(i - 1))) {
			i = -1;
		}
		return i;
	}
	private int isBeginRight(String fragment) {
		int i = StringUtils.indexOf(fragment, "and", "between");
		return i;
	}
/*
	private String transformSql_old(String sqlStatement) {
		String[] sqlArray = formatSql(sqlStatement).split("#");
		int sqlArrayLength = sqlArray.length;
		StringBuffer sql = new StringBuffer();
		StringBuffer expression = null;
		String fragment = null;
		for (int i = 1; i <= sqlArrayLength; i++) {
			fragment = sqlArray[i - 1];
			if (i % 2 == 1) {
				expression = new StringBuffer();
				if (i > 1) {
					int index = -1;
					if ((index = isFunctionRight(fragment)) != -1 && isFunctionLeft(sqlArray[i - 3]) != -1) {
						sql.append(fragment.substring(0, index + 1));
						fragment = fragment.substring(index + 1);
					}
					if ((index = isBeginRight(fragment)) != -1 && isBeginLeft(sqlArray[i - 3]) != -1) {
						sql.append(fragment.substring(0, index + 1));
						fragment = fragment.substring(index + 1);
					}
					sql.append("\n").append("      ").append("</e:if>");
				}
				if (i != sqlArrayLength) {
					if (isFunctionLeft(fragment) != -1) {
						fragment = parseFragmentEnd(fragment, expression);
					}
					fragment = parseFragmentEnd(fragment, expression); // 运算符
					fragment = parseFragmentEnd(fragment, expression); // 列名
					if (fragment.toLowerCase().endsWith("where")) {
						fragment = fragment + " 1 = 1 and ";
					}
					fragment = parseFragmentEnd(fragment, expression); // 逻辑运算符
				}
				sql.append(fragment).append(" ");
			} else {// 在这里可以加
				sql.append("\n").append("      ").append("<e:if condition=\"${");
				sql.append("((param.").append(sqlArray[i - 1]).append(" != null)&&(param.").append(sqlArray[i - 1]).append(" != '')&&(param.").append(sqlArray[i - 1]).append(" != 'null'))");
				sql.append(" || ");
				sql.append("(").append(sqlArray[i - 1]).append(" != null &&").append(sqlArray[i - 1]).append(" != '')");
				sql.append("}\">").append("\n");
				sql.append("        ").append(expression);
				sql.append("#").append(sqlArray[i - 1]).append("#");
			}
		}
		return formatToSql(sql.toString());
	}
	private String transformSql_q(String sqlStatement) {
		String sql = sqlStatement;
		sql = sql.replaceAll("\n", "").replaceAll("\r", "").replaceAll("\\{", "<f>").replaceAll("\\}", "</f>");
		Pattern p = Pattern.compile("<f>(.*?)</f>");
		Matcher mStr = p.matcher(sql);
		while(mStr.find()) {
			StringBuffer ifTag = new StringBuffer("");
			if (mStr.group(1).toLowerCase().startsWith("and")|| mStr.group(1).toLowerCase().startsWith("or")) {
				ifTag.append("\n").append("      <e:if condition=\"${");
			}else{
				ifTag.append(" 1=1 ").append("\n").append("      <e:if condition=\"${");
			}
			String [] b= mStr.group(1).trim().split("#");
			int step = 0;
			for(int c = 0;c<b.length;c++){
				if (c % 2 == 1) {
					step ++;
					ifTag.append("(");
					ifTag.append("(");
					ifTag.append("(param.").append(b[c]).append(" != null)");
					ifTag.append("&&");
					ifTag.append("(param.").append(b[c]).append(" != '')");
					ifTag.append("&&");
					ifTag.append("(param.").append(b[c]).append(" != 'null')");
					ifTag.append(")");
					ifTag.append("||");
					ifTag.append("(");
					ifTag.append("(").append(b[c]).append(" != null)");
					ifTag.append("&&");
					ifTag.append("(").append(b[c]).append(" != '')");
					ifTag.append(")");
					ifTag.append(")");
					if(c!=b.length-2&&c!=b.length-1){
						ifTag.append("&&");
					}
				}
			}
			if(step ==0)
				ifTag.append("true");
			ifTag.append("}\">").append("\n");
			if (mStr.group(1).toLowerCase().startsWith("and")|| mStr.group(1).toLowerCase().startsWith("or")) {
				ifTag.append("        "+mStr.group(1)).append("\n");
			}else{
				ifTag.append("        and "+mStr.group(1)).append("\n");
			}
			ifTag.append("      </e:if>").append("\n      ");
			String ifStrTmp = "(?i)"+mStr.group();
			sql = replaceAll(sql,mStr.group(),ifTag.toString());
			sql = replaceAll(sql,ifStrTmp,ifTag.toString());
        }
		return sql;
	}
	private String replaceAll(String str, String regex, String value) {
	return str.replaceAll(regex, value == null ? "" : value.replaceAll(
			"\\\\", "\\\\\\\\").replaceAll("\\$", "\\\\\\$").replaceAll(
			"\\{", "\\\\\\{").replaceAll("\\}", "\\\\\\}"));
	}
	*/
	
	public String getDimsionVarType (String dimsionvartype,String varName){
		String varType = " | ";
		List<Map> dimsionVarTypeList = (List<Map>)Functions.json2java(""+dimsionvartype+"");
		for(Map dimsionMap : dimsionVarTypeList){
			if(dimsionMap != null && dimsionMap.get("dimname") != null && dimsionMap.get("dimname").equals(varName)){
				varType = "" + dimsionMap.get("dimtype") + "|" + dimsionMap.get("reportId");
				return varType;
			}
		}
		return varType;
	}
	public String transformSql(String sqlStatement,String dimsionvartype) {
		StringBuffer sqlBuffer = new StringBuffer();
		String sql = sqlStatement;
		
		sql = sql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\\{", "<f>").replaceAll("\\}", "<f>");
		String []sqlStr = sql.split("<f>");
		
		for(int i=0;i<sqlStr.length;i++){
			
			if (i % 2 != 1) {
				//SQL体				
				sqlBuffer.append(sqlStr[i]);				
			}else{
				//WHERE体
				StringBuffer ifTag = new StringBuffer("");
				if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
					ifTag.append("\n").append("      <e:if condition=\"${");
				}else{
					ifTag.append(" 1=1 ").append("\n").append("      <e:if condition=\"${");
				}
				String [] b= sqlStr[i].trim().split("#");
				int step = 0;
				boolean uploadstate = false;
				String reportId = "";
				String uploadConditionVarName = "";//上传条件变量名
				for(int c = 0;c<b.length;c++){
					
					if (c % 2 == 1) {
						step ++;
						String varStr =  getDimsionVarType(dimsionvartype, b[c]).toUpperCase().trim();
						String varTypeStr = varStr.substring(0, varStr.indexOf("|"));
						if(varTypeStr != null && varTypeStr.equals("UPLOAD")) {
							uploadstate = true;
							reportId = varStr.substring(varStr.indexOf("|")+1,varStr.length());
						}
						ifTag.append("(");
						ifTag.append("(");
						ifTag.append("(param.").append(b[c]).append(" != null)");
						ifTag.append("&&");
						ifTag.append("(e:trim(param.").append(b[c]).append(") != '')");
						ifTag.append("&&");
						ifTag.append("(param.").append(b[c]).append(" != 'null')");
						if(uploadstate){
							ifTag.append("&&");
							ifTag.append("(Query_"+b[c]+".TOTAL_ID > 0)");
							uploadConditionVarName = b[c];
						}
						ifTag.append(")");
						ifTag.append("||");
						ifTag.append("(");
						ifTag.append("(").append(b[c]).append(" != null)");
						ifTag.append("&&");
						ifTag.append("(e:trim(").append(b[c]).append(") != '')");
						ifTag.append("&&");
						ifTag.append("(").append(b[c]).append(" != 'null')");
						if(uploadstate){
							ifTag.append("&&");
							ifTag.append("(Query_"+b[c]+".TOTAL_ID > 0)");
							uploadConditionVarName = b[c];
						}
						ifTag.append(")");
						ifTag.append(")");
						if(c!=b.length-2&&c!=b.length-1){
							ifTag.append("&&");
						}
					}
				}				
				if(step ==0)
					ifTag.append("true");
				ifTag.append("}\">").append("\n");
				if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
					String[] exitStrTemp = sqlStr[i].split("#");
					if(uploadstate){						
						String varString = "";
						for(int iStep = 0 ; iStep < exitStrTemp.length ;iStep ++){
								varString = exitStrTemp[0].toUpperCase().replaceAll("OR", "").replaceAll("AND", "").replaceAll("=", " ");
								break;
						}
						ifTag.append("        "+sqlStr[i].trim().substring(0, 3)).append(" exists(select ID from (SELECT DISTINCT TRIM(T.DATA_CON) ID FROM SYS_REPORT_UPLOAD_DATA T WHERE T.REPORT_ID = '"+reportId+"' AND T.UPLOAD_USER = '${sessionScope.UserInfo.USER_ID}' AND (FIELD_NAME = '"+uploadConditionVarName+"' OR FIELD_NAME IS NULL)) TEMP"+reportId+" where TEMP"+reportId+".id = ").append(varString).append(")").append("\n");					
					}else{									
						if(exitStrTemp[0].replaceAll(" ", "").toUpperCase().indexOf("IN(")>0&&exitStrTemp.length==3){
							ifTag.append("<e:if condition=\"${("+exitStrTemp[1]+" != null)&&("+exitStrTemp[1]+" != '')&&(area_no != 'null')}\">");							
							ifTag.append("        "+exitStrTemp[0]+"'${"+exitStrTemp[1]+"}'"+exitStrTemp[2]).append("\n");							
							ifTag.append("</e:if>");
						}else{							
							ifTag.append("        "+sqlStr[i]).append("\n");
						}						
					}
				}else{
					if(uploadstate){
						ifTag.append("        and exists(select ID from (SELECT DISTINCT TRIM(T.DATA_CON) ID FROM SYS_REPORT_UPLOAD_DATA T WHERE T.REPORT_ID = '"+reportId+"' AND T.UPLOAD_USER = '${sessionScope.UserInfo.USER_ID}') TEMP"+reportId+" where TEMP"+reportId+".id = ").append(sqlStr[i].replaceAll("=", " ")).append(")").append("\n");
					}else{
						ifTag.append("        and "+sqlStr[i]).append("\n");
					}
				}
				ifTag.append("      </e:if>").append("\n      ");
				
				sqlBuffer.append(ifTag.toString());
				
			}
		}
	    String resultSql = sqlBuffer.toString();
		//nmg需求，根据选择账期动态改变列，示例SQL如下，acctDay为日期选择框的ID，也即维度名，acctDay_0为选择的日期，acctDay_1为选择的日期减一，acctDay_2为选择日期减2，以此类推。
		//	    select t1.area_no 地市编码,t1.max_kpi 最大值 ,t2.acctDay_0 DYNAMIC_ACCT_0,t2.acctDay_1 DYNAMIC_ACCT_1,t2.acctDay_2 DYNAMIC_ACCT_2 from (SELECT area_no,max(kpi_value) max_kpi from  AC_USER_CREDIT where 1=1 { and acct_day=#acctDay#} group by area_no) t1,
		//	    (select area_no,
		//	    sum(case acct_day when 'acctDay_0' then to_number(kpi_value)  else 0 end) acctDay_0,
		//	    sum(case acct_day when 'acctDay_1' then to_number(kpi_value)  else 0 end) acctDay_1,
		//	    sum(case acct_day when 'acctDay_2' then to_number(kpi_value)  else 0 end) acctDay_2
		//	    FROM AC_USER_CREDIT 
		//	    group by area_no) t2
		//	    where t1.area_no=t2.area_no(+)
	    List<Map> dimsionVarTypeList = (List<Map>)Functions.json2java(""+dimsionvartype+"");
		for(Map dimsionMap : dimsionVarTypeList){
			if("DAY".equals(dimsionMap.get("dimtype"))){
				String dimname = dimsionMap.get("dimname")+"";
				 String regEx="'"+dimname+"_\\d'";  
			        Pattern pattern = Pattern.compile(regEx); 
			        Matcher matcher = pattern.matcher(resultSql);  
			        String  matchStr="";
			        String dynamicIndex="0";
			        while (matcher.find()) {
			        	matchStr = matcher.group();
			        	dynamicIndex = matchStr.split("_")[1].substring(0,matchStr.split("_")[1].length()-1);
			        	resultSql = resultSql.replace(matchStr,"<e:q4o var='dateObj"+dynamicIndex+"'>select to_char(to_date('${param."+dimname+"}','YYYYMMDD')-"+dynamicIndex+",'YYYYMMDD') ACCT_DAY from dual</e:q4o>'${dateObj"+dynamicIndex+".ACCT_DAY}'");
			        }
			        break;
			}
		}
		return resultSql;
	}
	@SuppressWarnings("unused")
	public String transformSqlForDim(String dimSqlStatement) {
		StringBuffer sqlBuffer = new StringBuffer();
		String sql = dimSqlStatement;
		sql = sql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\\{", "<f>").replaceAll("\\}", "<f>");
		String []sqlStr = sql.split("<f>");
		for(int i=0;i<sqlStr.length;i++){
			if (i % 2 != 1) {
				//SQL体
				sqlBuffer.append(sqlStr[i]);
			}else{
				//WHERE体
				StringBuffer ifTagSessionScope = new StringBuffer("");//sessionScope
				if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
					ifTagSessionScope.append("\n").append("      <e:if condition=\"${");
				}else{
					ifTagSessionScope.append(" 1=1 ").append("\n").append("      <e:if condition=\"${");
				}
				String [] b= sqlStr[i].trim().split("#");
				int step = 0;
				for(int c = 0;c<b.length;c++){
					if (c % 2 == 1) {
						step ++;

						ifTagSessionScope.append("(");
						ifTagSessionScope.append("(");
						ifTagSessionScope.append("(sessionScope.").append(b[c]).append(" != null)");
						ifTagSessionScope.append("&&");
						ifTagSessionScope.append("(sessionScope.").append(b[c]).append(" != '')");
						ifTagSessionScope.append("&&");
						ifTagSessionScope.append("(sessionScope.").append(b[c]).append(" != 'null')");
						if(b[c].toUpperCase().equals("CITY_NO")||b[c].toUpperCase().equals("AREA_NO")){
							ifTagSessionScope.append("&&");
							ifTagSessionScope.append("(sessionScope.").append(b[c]).append(" != '-1')");
						}
						ifTagSessionScope.append(")");
						ifTagSessionScope.append(")");
						if(c!=b.length-2&&c!=b.length-1){
							ifTagSessionScope.append("&&");
						}
					}
				}
				if(step ==0){
					ifTagSessionScope.append("true");
				}
				ifTagSessionScope.append("}\">").append("\n");
				if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
					ifTagSessionScope.append("        "+b[0]+"'${sessionScope."+b[1]).append("}'\n");
				}else{
					ifTagSessionScope.append("        and "+b[0]+"'${sessionScope."+b[1]).append("}'\n");
				}
				ifTagSessionScope.append("      </e:if>").append("\n      ");
				sqlBuffer.append(ifTagSessionScope.toString());
			}
		}
		return sqlBuffer.toString();
	}
	/**
	 * 
	 * @param sqlStatement
	 * @return 返回字段 与 变量  如;  and area_no = #area#  map.get("col") = " and area_no = "; map.get("var") = "area"
	 */
	@SuppressWarnings("unused")
	public List<Map> transformSqlVar(String sqlStatement) {
		List<Map> transList = new ArrayList<Map>();
		StringBuffer sqlBuffer = new StringBuffer("");
		String sql = sqlStatement;
		sql = sql.replaceAll("\n", " ").replaceAll("\r", " ").replaceAll("\\{", "<f>").replaceAll("\\}", "<f>");
		String []sqlStr = sql.split("<f>");
		if(sqlStr.length <=1 || sql.indexOf("#") == -1){
			Map varTem = new HashMap();
			varTem.put("sql", sqlStatement);
			transList.add(varTem);
		}
		for(int i=0;i<sqlStr.length;i++){
			Map varTem = new HashMap();
			if (i % 2 != 1) {
				//SQL体
				sqlBuffer.append(sqlStr[i]);
			}else{
				//WHERE体
				StringBuffer ifTag = new StringBuffer("");
				if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
					ifTag.append("\n").append("  ");
				}else{
					ifTag.append(" 1=1 ").append(" ");
				}
				String [] b= sqlStr[i].trim().split("#");
				int step = 0;
				if(b.length >= 2){
					if (sqlStr[i].toLowerCase().trim().startsWith("and")|| sqlStr[i].toLowerCase().trim().startsWith("or")) {
						varTem.put("col", b[0]);
						varTem.put("var", b[1]);
					}else{
						varTem.put("col", " and "+b[0]);
						varTem.put("var", b[1]);
					}
				}
				sqlBuffer.append(ifTag.toString());
				varTem.put("sql", sqlBuffer.toString());
				transList.add(varTem);
			}
		}
		return transList;
	}
	@SuppressWarnings("unchecked")
	private String transformSqlParamURI(List<Map<String, String>> ResultSets) {
		String paramUrlCode = "";
		List<String> moreSelectFlag=new ArrayList<String>();
		Map<String,String> moreSelectFlagMap=new HashMap<String,String>();
		StringBuffer SqlParamURI = new StringBuffer();
		StringBuffer tempBuffer=new StringBuffer();
		for (Map<String, String> ResultSet : ResultSets) {
			String[] sqlArray = formatSql(ResultSet.get("sql")).split("#");
			//System.out.println("sql++"+ResultSet.get("sql"));
			int sqlArrayLength = sqlArray.length;
			for (int i = 1; i <= sqlArrayLength; i++) {
				if (i % 2 != 1) {
					paramUrlCode += sqlArray[i - 1]+"#";
					tempBuffer.delete(0, tempBuffer.length());
					tempBuffer.append(sqlArray[i - 2].replaceAll(" ", "").toUpperCase());
					if(tempBuffer.indexOf("IN(")>0&&tempBuffer.indexOf("IN(")>tempBuffer.indexOf("{")){
						moreSelectFlag.add("1");
					}else{
						moreSelectFlag.add("0");
					}
					
				}
			}
			System.out.println("moreSelectFlag: "+moreSelectFlag.toString());
		}
		if(paramUrlCode !=null && !paramUrlCode.equals("")){
			paramUrlCode = paramUrlCode.substring(0, paramUrlCode.length()-1);
			String[] paramUrlCodeData = paramUrlCode.split("#");
			List paramUrlCodeList = new ArrayList();
			for (int i = 0; i < paramUrlCodeData.length; i++){
				if (!paramUrlCodeList.contains(paramUrlCodeData[i])) {
					paramUrlCodeList.add(paramUrlCodeData[i]);
					moreSelectFlagMap.put(paramUrlCodeData[i],moreSelectFlag.get(i));
				}else{
					if("1".equals(moreSelectFlag.get(i))&&(!("1".equals(moreSelectFlagMap.get(paramUrlCodeData[i]))))){
						moreSelectFlagMap.put(paramUrlCodeData[i],moreSelectFlag.get(i));
					}
					
				}
			
			}
			for (int i = 0; i < paramUrlCodeList.size(); i++){
				SqlParamURI.append("<%").append("\n");
				//SqlParamURI.append("String isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(" = request.getParameter(\"").append(paramUrlCodeList.get(i)).append("\")!=null?new String(request.getParameter(\"").append(paramUrlCodeList.get(i)).append("\").getBytes(\"ISO-8859-1\"),\"UTF-8\"):\"\";").append("\n");
				SqlParamURI.append("String isMessyCode_").append(paramUrlCodeList.get(i)).append(" = request.getParameter(\"").append(paramUrlCodeList.get(i)).append("\");").append("\n");
				SqlParamURI.append("if(isMessyCode_").append(paramUrlCodeList.get(i)).append(" == null || isMessyCode_").append(paramUrlCodeList.get(i)).append(".equals(\"\") || isMessyCode_").append(paramUrlCodeList.get(i)).append(".toUpperCase().equals(\"NULL\")){").append("\n");
				SqlParamURI.append("   isMessyCode_").append(paramUrlCodeList.get(i)).append(" = request.getAttribute(\"").append(paramUrlCodeList.get(i)).append("\") + \"\";").append("\n");
				SqlParamURI.append("}").append("\n");
				SqlParamURI.append("if(isMessyCode_").append(paramUrlCodeList.get(i)).append(" == null || isMessyCode_").append(paramUrlCodeList.get(i)).append(".equals(\"\") || isMessyCode_").append(paramUrlCodeList.get(i)).append(".toUpperCase().equals(\"NULL\")){").append("\n");
				SqlParamURI.append("   isMessyCode_").append(paramUrlCodeList.get(i)).append(" = request.getSession().getAttribute(\"").append(paramUrlCodeList.get(i)).append("\") + \"\";").append("\n");
				SqlParamURI.append("}").append("\n");
				SqlParamURI.append("isMessyCode_").append(paramUrlCodeList.get(i)).append(" = isMessyCode_").append(paramUrlCodeList.get(i)).append("!=null?new String(isMessyCode_").append(paramUrlCodeList.get(i)).append(".getBytes(\"ISO-8859-1\"),\"UTF-8\"):\"\";").append("\n");
				
				SqlParamURI.append("String isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append(" = request.getParameter(\"").append(paramUrlCodeList.get(i)).append("\");").append("\n");
				SqlParamURI.append("if(isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append(" == null || isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append(".equals(\"\") || isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append(".toUpperCase().equals(\"NULL\")){").append("\n");
				SqlParamURI.append("   isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append(" = request.getAttribute(\"").append(paramUrlCodeList.get(i)).append("\") + \"\";").append("\n");
				SqlParamURI.append("}").append("\n");
				SqlParamURI.append("if(isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append(" == null || isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append(".equals(\"\") || isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append(".toUpperCase().equals(\"NULL\")){").append("\n");
				SqlParamURI.append("   isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append(" = request.getSession().getAttribute(\"").append(paramUrlCodeList.get(i)).append("\") + \"\";");
				SqlParamURI.append("}").append("\n");
				SqlParamURI.append("isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append(" = isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append("!=null?new String(isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append(".getBytes(\"ISO-8859-1\"),\"gb2312\"):\"\";").append("\n");
				
				//SqlParamURI.append("String isMessyCode_").append(paramUrlCodeList.get(i)).append(paramUrlCodeList.get(i)).append(" = request.getParameter(\"").append(paramUrlCodeList.get(i)).append("\")!=null?new String(request.getParameter(\"").append(paramUrlCodeList.get(i)).append("\").getBytes(\"ISO-8859-1\"),\"gb2312\"):\"\";").append("\n");
				SqlParamURI.append("if(!CommonTools.isMessyCode(isMessyCode_").append(paramUrlCodeList.get(i)).append(")){").append("\n");
				SqlParamURI.append("	request.setAttribute(\"").append(paramUrlCodeList.get(i)).append("\",isMessyCode_").append(paramUrlCodeList.get(i)).append(");").append("\n");
				//SqlParamURI.append("	request.getSession().setAttribute(\"").append(paramUrlCodeList.get(i)).append("\",isMessyCode_").append(paramUrlCodeList.get(i)).append(");").append("\n");
				SqlParamURI.append("}").append("\n");
				SqlParamURI.append("else if(!CommonTools.isMessyCode(isMessyCode_").append(paramUrlCodeList.get(i)).append("").append(paramUrlCodeList.get(i)).append(")){").append("\n");
				SqlParamURI.append("	request.setAttribute(\"").append(paramUrlCodeList.get(i)).append("\",isMessyCode_").append(paramUrlCodeList.get(i)).append("").append(paramUrlCodeList.get(i)).append(");").append("\n");
				//SqlParamURI.append("	request.getSession().setAttribute(\"").append(paramUrlCodeList.get(i)).append("\",isMessyCode_").append(paramUrlCodeList.get(i)).append("").append(paramUrlCodeList.get(i)).append(");").append("\n");
				SqlParamURI.append("}").append("\n");
				SqlParamURI.append("%>").append("\n");
				//System.out.println("test:   "+moreSelectFlag.get(i));
				if(moreSelectFlagMap.get(paramUrlCodeList.get(i)).trim().equals("1")){
					SqlParamURI.append("<%").append("\n");
					//SqlParamURI.append("String isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append("s_selects").append(" = request.getParameter(\"").append(paramUrlCodeList.get(i)).append("s_selects").append("\")!=null?new String(request.getParameter(\"").append(paramUrlCodeList.get(i)).append("s_selects").append("\").getBytes(\"ISO-8859-1\"),\"UTF-8\"):\"\";").append("\n");
					SqlParamURI.append("String isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(" = request.getParameter(\"").append(paramUrlCodeList.get(i)).append("s_selects").append("\");").append("\n");
					SqlParamURI.append("if(isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(" == null || isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(".equals(\"\") || isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(".toUpperCase().equals(\"NULL\")){").append("\n");
					SqlParamURI.append("   isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(" = request.getAttribute(\"").append(paramUrlCodeList.get(i)).append("s_selects").append("\") + \"\";").append("\n");
					SqlParamURI.append("}").append("\n");
					SqlParamURI.append("if(isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(" == null || isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(".equals(\"\") || isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(".toUpperCase().equals(\"NULL\")){").append("\n");
					SqlParamURI.append("   isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(" = request.getSession().getAttribute(\"").append(paramUrlCodeList.get(i)).append("\") + \"\";").append("\n");
					SqlParamURI.append("}").append("\n");
					SqlParamURI.append("isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(" = isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append("!=null?new String(isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(".getBytes(\"ISO-8859-1\"),\"UTF-8\"):\"\";").append("\n");
					
					SqlParamURI.append("String isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append(" = request.getParameter(\"").append(paramUrlCodeList.get(i)).append("s_selects").append("\");").append("\n");
					SqlParamURI.append("if(isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append(" == null || isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append(".equals(\"\") || isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append(".toUpperCase().equals(\"NULL\")){").append("\n");
					SqlParamURI.append("   isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append(" = request.getAttribute(\"").append(paramUrlCodeList.get(i)).append("s_selects").append("\") + \"\";").append("\n");
					SqlParamURI.append("}").append("\n");
					SqlParamURI.append("if(isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append(" == null || isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append(".equals(\"\") || isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append(".toUpperCase().equals(\"NULL\")){").append("\n");
					SqlParamURI.append("   isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append(" = request.getSession().getAttribute(\"").append(paramUrlCodeList.get(i)).append("\") + \"\";");
					SqlParamURI.append("}").append("\n");
					SqlParamURI.append("isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append(" = isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append("!=null?new String(isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append(".getBytes(\"ISO-8859-1\"),\"gb2312\"):\"\";").append("\n");
					
					//SqlParamURI.append("String isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(paramUrlCodeList.get(i)).append("s_selects").append(" = request.getParameter(\"").append(paramUrlCodeList.get(i)).append("s_selects").append("\")!=null?new String(request.getParameter(\"").append(paramUrlCodeList.get(i)).append("s_selects").append("\").getBytes(\"ISO-8859-1\"),\"gb2312\"):\"\";").append("\n");
					SqlParamURI.append("if(!CommonTools.isMessyCode(isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(")){").append("\n");
					SqlParamURI.append("	request.setAttribute(\"").append(paramUrlCodeList.get(i)).append("s_selects").append("\",isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(");").append("\n");
					//SqlParamURI.append("	request.getSession().setAttribute(\"").append(paramUrlCodeList.get(i)).append("s_selects").append("\",isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append(");").append("\n");
					SqlParamURI.append("}").append("\n");
					SqlParamURI.append("else if(!CommonTools.isMessyCode(isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append("").append(paramUrlCodeList.get(i)).append("s_selects").append(")){").append("\n");
					SqlParamURI.append("	request.setAttribute(\"").append(paramUrlCodeList.get(i)).append("s_selects").append("\",isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append("").append(paramUrlCodeList.get(i)).append("s_selects").append(");").append("\n");
					//SqlParamURI.append("	request.getSession().setAttribute(\"").append(paramUrlCodeList.get(i)).append("s_selects").append("\",isMessyCode_").append(paramUrlCodeList.get(i)).append("s_selects").append("").append(paramUrlCodeList.get(i)).append("s_selects").append(");").append("\n");
					SqlParamURI.append("}").append("\n");
					
					SqlParamURI.append("StringBuffer ").append(paramUrlCodeList.get(i)).append("s_selects_temp=new StringBuffer(\"\");").append("\n");
					SqlParamURI.append("String ").append(paramUrlCodeList.get(i)).append("s_selects=\"\";").append("\n");
					SqlParamURI.append("if(request.getAttribute(\"").append(paramUrlCodeList.get(i)).append("s_selects\")!=null){").append("\n");
					SqlParamURI.append("	").append(paramUrlCodeList.get(i)).append("s_selects=request.getAttribute(\"").append(paramUrlCodeList.get(i)).append("s_selects\").toString();").append("\n");
					SqlParamURI.append("}").append("\n");
					SqlParamURI.append("String ").append(paramUrlCodeList.get(i)).append("s_selectsArray[]=").append(paramUrlCodeList.get(i)).append("s_selects.split(\",\");").append("\n");
					SqlParamURI.append("for(int i=0;i<").append(paramUrlCodeList.get(i)).append("s_selectsArray.length;i++){").append("\n");
					SqlParamURI.append("if(").append(paramUrlCodeList.get(i)).append("s_selectsArray").append("[i].trim().equals(\"\")||").append(paramUrlCodeList.get(i)).append("s_selectsArray[i].trim().toLowerCase().equals(\"null\")){").append("\n");
					SqlParamURI.append("continue;").append("\n");
					SqlParamURI.append("}").append("\n");
					SqlParamURI.append("	").append(paramUrlCodeList.get(i)).append("s_selects_temp.append(\",'\"+").append(paramUrlCodeList.get(i)).append("s_selectsArray[i]+\"'\");").append("\n");
					SqlParamURI.append("}").append("\n");
					
					
					//去掉开头和结尾的 " ' "
					SqlParamURI.append("if(").append(paramUrlCodeList.get(i)).append("s_selects_temp != null && ").append(paramUrlCodeList.get(i)).append("s_selects_temp.length() > 1){").append("\n");
					SqlParamURI.append("StringBuffer ").append(paramUrlCodeList.get(i)).append("s_selects_temp_a = new StringBuffer();").append("\n");
					SqlParamURI.append(paramUrlCodeList.get(i)).append("s_selects_temp_a.append(").append(paramUrlCodeList.get(i)).append("s_selects_temp.toString().substring(1,").append(paramUrlCodeList.get(i)).append("s_selects_temp.length()-1));").append("\n");
					SqlParamURI.append(paramUrlCodeList.get(i)).append("s_selects_temp = ").append(paramUrlCodeList.get(i)).append("s_selects_temp_a;").append("\n");
					SqlParamURI.append("}").append("\n");
					
					
					SqlParamURI.append("if(").append(paramUrlCodeList.get(i)).append("s_selects_temp.length()>1){").append("\n");
					SqlParamURI.append("	request.setAttribute(\"").append(paramUrlCodeList.get(i)).append("\",").append(paramUrlCodeList.get(i)).append("s_selects_temp.substring(1));").append("\n");
					SqlParamURI.append("}");
					
					
					SqlParamURI.append("%>").append("\n");
					
				}
			}
		}else{
			SqlParamURI.append("").append("\n");
		}
		return SqlParamURI.toString();
	}
	private String formatSql(String sqlStatement) {
		sqlStatement = sqlStatement.replaceAll(">=", " &ge ");
		sqlStatement = sqlStatement.replaceAll("<=", " &le ");
		sqlStatement = sqlStatement.replaceAll("<>", " &ne ");
		sqlStatement = sqlStatement.replaceAll("!=", " &ne ");
		sqlStatement = sqlStatement.replaceAll("=", " = ");
		sqlStatement = sqlStatement.replaceAll(">", " > ");
		sqlStatement = sqlStatement.replaceAll("<", " < ");
		return sqlStatement;
	}

	private String formatToSql(String sqlStatement) {
		sqlStatement = sqlStatement.replaceAll("&ge",">=");
		sqlStatement = sqlStatement.replaceAll("&le","<=");
		sqlStatement = sqlStatement.replaceAll("&ne","<>");
		sqlStatement = sqlStatement.replaceAll("&ne","!=");
		return sqlStatement;
	}
	public String sqlSort(){
		StringBuffer sourceCode = new StringBuffer(); 
		sourceCode.append("<e:if condition=\"${param.sort!=null&&param.sort!=''&&param.sort!='null'&&param.sort!='undefined'}\">").append("\n");
		sourceCode.append("        ORDER BY nvl(\"${param.sort }\",0) ");
		sourceCode.append("		 <e:if condition=\"${param.order!=null&&param.order!=''&&param.order!='null'&&param.order!='undefined'}\">");
		sourceCode.append("  ${param.order } ").append("</e:if>\n");
		sourceCode.append("      </e:if>").append("\n");
      return sourceCode.toString();
	}
	public String build(List<Map<String, String>> ResultSets,String dimsionvartype) {
		StringBuffer sourceCode = new StringBuffer();
		sourceCode.append("<%@ page language=\"java\" pageEncoding=\"UTF-8\"%>").append("\n");
		sourceCode.append("<%@page import=\"cn.com.easy.ebuilder.parser.CommonTools\"%>").append("\n");
		sourceCode.append("<%@ taglib prefix=\"e\" uri=\"http://www.bonc.com.cn/easy/taglib/e\"%>").append("\n");
		sourceCode.append("<%@ taglib prefix=\"c\" uri=\"http://www.bonc.com.cn/easy/taglib/c\"%>").append("\n");
		sourceCode.append(transformSqlParamURI(ResultSets)).append("\n");
		
		sourceCode.append("<e:switch value=\"${param.eaction}\">").append("\n");
		for (Map<String, String> ResultSet : ResultSets) {
			sourceCode.append("  ").append("<e:case value=\"").append(ResultSet.get("id")).append("\">").append("\n");
			sourceCode.append("    ").append("<e:description>").append(ResultSet.get("desc")).append("</e:description>").append("\n");
			if (ResultSet.get("type").equals("datagrid")) {
				sourceCode.append(generateUploadPreCondition(dimsionvartype,ResultSet.get("dataSourceName")));//生成upload类型拼接exist子查询的先决条件
				sourceCode.append("    ").append("<c:tablequery ").append(getExtDsStr(ResultSet.get("dataSourceName"))).append(" >").append("\n");
				sourceCode.append("      ").append(transformSql(ResultSet.get("sql"),dimsionvartype)).append("\n");
				//表格加一个后台排序的功能
				sourceCode.append("      ").append(sqlSort()).append("\n");
				sourceCode.append("    ").append("</c:tablequery>").append("\n");
			} else if (ResultSet.get("type").equals("treegrid")) {
				sourceCode.append(generateUploadPreCondition(dimsionvartype,ResultSet.get("dataSourceName")));//生成upload类型拼接exist子查询的先决条件
				sourceCode.append("    ").append("<c:treegridquery  ").append(getExtDsStr(ResultSet.get("dataSourceName"))).append(" dimField=\"").append(ResultSet.get("dimField")).append("\">").append("\n");
				sourceCode.append("      ").append(transformSql(ResultSet.get("sql"),dimsionvartype)).append("\n");
				sourceCode.append("    ").append("</c:treegridquery>").append("\n");
			} else if (ResultSet.get("type").equals("echart")) {
				sourceCode.append(generateUploadPreCondition(dimsionvartype,ResultSet.get("dataSourceName")));//生成upload类型拼接exist子查询的先决条件
				sourceCode.append("    ").append("<c:chartquery ").append(getExtDsStr(ResultSet.get("dataSourceName"))).append(" >").append("\n");
				sourceCode.append("      ").append(transformSql(ResultSet.get("sql"),dimsionvartype)).append("\n");
				sourceCode.append("    ").append("</c:chartquery>").append("\n");
			}
			sourceCode.append("  ").append("</e:case>").append("\n");
		}
		sourceCode.append("</e:switch>").append("\n");
		return sourceCode.toString();
	}
	/**
	 * 生成Upload类型查询条件的先决条件，先查询下上传表是否有对应该查询条件的数据，如果没有就不拼exsit子查询
	 * @param dimsionvartype
	 * @return
	 */
	public String generateUploadPreCondition(String dimsionvartype,String datasourceName){
		StringBuffer result = new StringBuffer("");
		List<Map> dimsionVarTypeList = (List<Map>)Functions.json2java(""+dimsionvartype+"");
		datasourceName = datasourceName != null?" extds='"+datasourceName+"'":"";
		for(Map dimsionMap : dimsionVarTypeList){
			 if("UPLOAD".equals(dimsionMap.get("dimtype"))){
				 result.append("<e:q4o var='Query_"+dimsionMap.get("dimname")+"' "+datasourceName+">\n");
				 result.append("     select count(1) TOTAL_ID from SYS_REPORT_UPLOAD_DATA t where T.REPORT_ID = '"+dimsionMap.get("reportId")+"' AND T.UPLOAD_USER = '${sessionScope.UserInfo.USER_ID}' AND FIELD_NAME = '"+dimsionMap.get("dimname")+"'\n");
				 result.append("</e:q4o>\n");
			 }
		}
		return result.toString();
	}
	
	public String getExtDsStr(String dataSourceName){
		String getExtDsStr = "";
			if (dataSourceName != null && !dataSourceName.equals("")
				&& !dataSourceName.trim().equals("")
				&& !dataSourceName.trim().toUpperCase().equals("NULL"))
				getExtDsStr = " extds = \""+dataSourceName+"\"";
		return getExtDsStr;
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Map map1 = new HashMap();
		map1.put("id", "RS001");
		map1.put("desc", "测试1");
		map1.put("type", "datagrid");
		map1.put("sql", "select * from table where 1=1 { and aa = to_char(#aaa#,'yyyymmdd')} {and bb = to_char(#bbb#,'yyyymmdd')} and cc =#ccc# order ");

		Map map2 = new HashMap();
		map2.put("id", "RS002");
		map2.put("desc", "测试2");
		map2.put("type", "treegrid");
		map2.put("dimField", "area");
		map2.put("sql", "select * from table where { aa = #AsA#} {and bb= #bbb#} {AND CC =#ccc#} {and a >=#A#} and b < #c# order by id");
		
		Map map21 = new HashMap();
		map21.put("id", "RS002");
		map21.put("desc", "测试3");
		map21.put("type", "treegrid");
		map21.put("dimField", "city");
		map21.put("sql", "select * from table where aa = 'aaa' and bb= #bbb#  cc =#ccc# order by id");

		Map map3 = new HashMap();
		map3.put("id", "RS003");
		map3.put("desc", "测试action三");
		map3.put("type", "echart");
		map3.put("dimField", "area");
		// map3.put("sql","select * from (select zz,dd,ff from tbale where
		// name=#enmae# and pwd='1234') tmp where aa = 'aaa' and bb= #bbb# and
		// cc =#ccc# order by id");
// map3.put("sql", "select sum(decode(i.month_id, '200908', i.income, 0)) 八月份, "
// +" sum(decode(i.month_id, '200909', i.income, 0)) 九月份, "
// +" sum(decode(i.month_id, '200910', i.income, 0)) 十月份, "
// +" sum(decode(i.month_id, '200911', i.income, 0)) 十一月份, "
// +" sum(decode(i.month_id, '200912', i.income, 0)) 十二月份, "
// +" sum(decode(i.month_id, '201001', i.income, 0)) 一月份, "
// +" sum(decode(i.month_id, '201002', i.income, 0)) 二月份, "
// +" sum(decode(i.month_id, '201003', i.income, 0)) 三月份, "
// +" sum(decode(i.month_id, '201004', i.income, 0)) 四月份, "
// +" sum(decode(i.month_id, '201005', i.income, 0)) 五月份, "
// +" sum(decode(i.month_id, '201006', i.income, 0)) 六月份, "
// +" sum(decode(i.month_id, '201007', i.income, 0)) 七月份, "
// +" s.svc_name "
// +" from telecomdm.dm_kkpi_m_income@jldwdb i, "
// +" telecomdmcode.dmcode_svc_all@jldwdb s "
// +" where s.svc_id = i.svc_id "
// +" and s.parent_svc_id = '00' "
// +" {and i.month_id between #start_acct_day# and #end_acct_day#} "
// +" {and i.month_id between #start_acct_day# and #end_acct_day#}");
		map3.put("sql", "select 日期,地市,当日计费收入 from (select acct_day 日期,       " +
				"a.area_no area_no,       b.area_desc 地市,       sum(cd_value) 当日计费收入,       " +
				"sum(ld_value) 昨日计费收入,       sum(cm_value) 当月累计计费收入,       " +
				"sum(lm_value) 上月同期累计计费收入,       sum(cm_use_value) 当月累计使用量,       " +
				"sum(lm_user_value) 上月同期累计使用量  from telecomdm.dm_d_income_change@jldwdb a, " +
				"hb_test.cmcode_area b where 1=1 and  a.area_no = b.area_no   " +
				"{and acct_day = #acct_day#}  " +
				" {and a.area_no = #area#}   " +
				"{and a.city_no = #city#} " +
				" and aaa = 'Q123' "+
				"group by a.acct_day, a.area_no, b.area_desc order by area_no)");
        
		List list = new ArrayList();
		list.add(map1);
//		list.add(map2);
//		list.add(map21);
//		list.add(map3);
		
		 BuildReportAction bra = new BuildReportAction();
		 String sqlStatement = " select amname code, amname codedesc from pg_catalog.pg_am   ";
		// String code = bra.build(list);
		 List<Map> a = new ArrayList<Map>(); 
		 a = bra.transformSqlVar(sqlStatement);
		 for(Map ac : a){
			 System.out.println(ac.get("sql"));
			 System.out.println(ac.get("col"));
			 System.out.println(ac.get("var"));
		 }
		 //System.out.println(bra.transformSqlVar(sqlStatement));
	}
}
