package cn.com.easy.xbuilder.parser;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import cn.com.easy.xbuilder.element.Extcolumn;
import cn.com.easy.xbuilder.element.Extcolumns;
import cn.com.easy.xbuilder.element.Param;
import cn.com.easy.xbuilder.element.Report;

public class XExtColumn {
	private final Report report;
	private final Extcolumns extcolumns;
	public XExtColumn(Report _report){
		this.report = _report;
		this.extcolumns = this.report.getExtcolumns();
	}
	public String[] getExtCol(String Extcolumnid){
		List<Extcolumn> extcolumnlst = null != this.extcolumns?this.extcolumns.getExtcolumnList():null;
		if(extcolumnlst == null){
			return null;
		}
		String[] extCol = new String[2];
		for(Extcolumn extcolumn:extcolumnlst){
			if(extcolumn.getId().equals(Extcolumnid)){
				String name = extcolumn.getName();
				String formula = extcolumn.getFormula().toUpperCase();
				
				Map<String,String> ParamMap = new HashMap<String,String>();
				List<?> params = extcolumn.getParamList();
				for(int p=0;p<params.size();p++){
					Object param = params.get(p);
					if(param instanceof Param){
						ParamMap.put(((Param)param).getName(),((Param)param).getValue());
					}else{
						ParamMap.put(((Map<String,String>)param).get("name"),((Map<String,String>)param).get("value"));
					}
				}
				
				StringBuffer formulaKpi = this.divisor2decode(formula, ParamMap,true,name);
				extCol[0] = name;
				extCol[1] = formulaKpi.toString();
			}
		}
		return extCol;
	}
	//解析公式中的除数为decode
	public StringBuffer divisor2decode(String formula,Map<String,String> ParamMap,boolean issum,String name){
		formula = formula.toUpperCase();
		int fl = formula.length();
		List<String> deoceSingle = new ArrayList<String>();
		List<String> deoceComposite = new ArrayList<String>();
		StringBuffer decodeFormula = new StringBuffer();
		StringBuffer finalFormula = new StringBuffer();
        for (int i=0;i<fl;i++) {
        	char c = formula.charAt(i);
            if (c <= 'Z' && c >= 'A') {
            	finalFormula.append(this.repSum(String.valueOf(c),ParamMap,issum));
            }else if("/".equals(String.valueOf(c))) {
            	char nextc = formula.charAt(i+1);
            	if("(".equals(String.valueOf(nextc))) {
            		String tmpFormula = formula.substring(i+2);
            		int m1 = 0;
            		int m2 = 0;
            		int end = 0;
            		for (int j=0;j<tmpFormula.length();j++) {
            			char tc = tmpFormula.charAt(j);
            			if("(".equals(String.valueOf(tc))){
            				m1++;
            			}else if(")".equals(String.valueOf(tc))){
            				if(m1 == 0){
            					end = j;
            				}else{
            					m1--;
            				}
            			}
            		}
            		String tmpDivisor = "(";
            		if(tmpFormula.length() == (end+1)){
            			tmpDivisor += tmpFormula.substring(0);
            		}else{
            			tmpDivisor += tmpFormula.substring(0,(end+1));
            		}
            		deoceComposite.add(this.repSum(tmpDivisor,ParamMap,issum));
                }else if(nextc <= 'Z' && nextc >= 'A'){
                	if(issum){
                		deoceSingle.add("SUM("+ParamMap.get(String.valueOf(nextc).toUpperCase())+")");
                	}else{
                		deoceSingle.add(ParamMap.get(String.valueOf(nextc).toUpperCase()));
                	}
                }else{
                	//为数字时
                	String tmpFormula = formula.substring(i+1);
                	deoceSingle.add(this.subNumeric(tmpFormula).toString());
                }
            	finalFormula.append(c);
            }else{
            	finalFormula.append(c);
            }
        }
        
/*        //decode(nvl(sum(SEX), 0), 0, 0, decode(sum(STATE)-sum(PWD_STATE),0,0,sum(STATE)-sum(PWD_STATE))) SEX1 from e_user
 * 原decode语法
        finalFormula.insert(0,"(").append(")");
        int dsl = deoceSingle.size();
        if(dsl>0){
        	for(int s=0;s<dsl;s++){
        		decodeFormula.append("decode(").append(deoceSingle.get(s)).append(",0,0,");
        	}
        }
        int dcl = deoceComposite.size();
        if(dcl>0){
        	for(int s=0;s<dcl;s++){
        		decodeFormula.append("decode(").append(deoceComposite.get(s)).append(",0,0,");
        	}
        }
        int dcsl = dsl+dcl;
        if(dcsl>0){
        	return decodeFormula.append(finalFormula).append(this.madeRightBracket(dcsl));
        }else{
        	return finalFormula;
        }*/
        
        finalFormula.insert(0,"(").append(")");
        int dsl = deoceSingle.size();
        int dcl = deoceComposite.size();
        int dcsl = dsl+dcl;
        if(dcsl>0){
        	decodeFormula.append("case ");
        }
        if(dsl>0){
        	for(int s=0;s<dsl;s++){
        		decodeFormula.append("when ").append(deoceSingle.get(s)).append("=0 then 0 ");
        	}
        }
        
        if(dcl>0){
        	for(int s=0;s<dcl;s++){
        		decodeFormula.append("when ").append(deoceComposite.get(s)).append("=0 then 0 ");
        	}
        }
        
        if(dcsl>0){
        	return decodeFormula.append("else "+finalFormula).append(" end \"").append(name).append("\" ");
        }else{
        	return finalFormula.append("as \"").append(name).append("\"");
        }
	}
	//解析公式中的除数为decode
	public String repSum(String formula,Map<String,String> ParamMap,boolean issum){
		StringBuffer finalFormula = new StringBuffer();
        for (int i=0;i<formula.length();i++) {
        	char c = formula.charAt(i);
            if (c <= 'Z' && c >= 'A') {
            	if(issum){
            		finalFormula.append("SUM("+ParamMap.get(String.valueOf(c).toUpperCase())+")");
            	}else{
            		finalFormula.append(ParamMap.get(String.valueOf(c).toUpperCase()));
            	}
            }else{
            	finalFormula.append(c);
            }
        }
        finalFormula.insert(0,"(").append(")");
		return finalFormula.toString();
	}
/*	//解析公式中的除数为decode
	private String madeRightBracket(int n){
		StringBuffer finalFormula = new StringBuffer();
        for (int i=0;i<n;i++) {
            finalFormula.append(")");
        }
		return finalFormula.toString();
	}*/
	//解析公式中的除数为decode
	public StringBuffer formulaNoSumNoDecode(String formula,Map<String,String> ParamMap){
		StringBuffer finalFormula = new StringBuffer();
        for (int i=0;i<formula.length();i++) {
            if (formula.charAt(i) <= 'Z' && formula.charAt(i) >= 'A') {
            	finalFormula.append(ParamMap.get(String.valueOf(formula.charAt(i)).toUpperCase()));
            }else{
            	finalFormula.append(formula.charAt(i));
            }
        }
        finalFormula.insert(0,"(").append(")");
		return finalFormula;
	}
	//解析字符串中完整的数字
	private StringBuffer subNumeric(String formula){
		StringBuffer finalNumeric = new StringBuffer();
		for (int i=0;i<formula.length();i++) {
			String c = String.valueOf(formula.charAt(i));
			Pattern pattern = Pattern.compile("[0-9]*[.]*"); 
			Matcher isNum = pattern.matcher(c);
			if(!isNum.matches()){
				return finalNumeric;
			}else{
				finalNumeric.append(c);
			}
		} 
		return finalNumeric;
	}
	//获得计算列的名称
	public String getExtColName(String Extcolumnid){
		List<Extcolumn> extcolumnlst = null != this.extcolumns?this.extcolumns.getExtcolumnList():null;
		if(extcolumnlst == null){
			return null;
		}
		for(Extcolumn extcolumn:extcolumnlst){
			if(extcolumn.getId().equals(Extcolumnid)){
				return extcolumn.getName();
			}
		}
		return null;
	}
}
