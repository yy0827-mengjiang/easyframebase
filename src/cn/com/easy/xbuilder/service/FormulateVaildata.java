package cn.com.easy.xbuilder.service;

import cn.com.easy.annotation.Service;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
@Service
public class FormulateVaildata {
	
	private String[] array={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
	
	private ScriptEngine jse = new ScriptEngineManager().getEngineByName("JavaScript");
	
	public String formulateVerification(String formula){
		String flg="1";
		formula = formula.replaceAll("\\d+", "1");
		flg = this.adjacentVail(formula);
		if("1".equals(flg)){
			flg = this.isOperator(formula);
		}
		if("1".equals(flg)){
			try{
				formula = formula.toUpperCase();
				for(String t:array){
					if(t.indexOf(formula)==-1){
						formula = formula.replaceAll(t, "1");
					}
				}
				//验证公式是否正确
				jse.eval(formula);
			}catch(Exception e){
				flg="0";
			}
		}
		return flg;
	}
	//验证相邻参数（1不相邻，0相邻）
	public String adjacentVail(String formula){
		String flg = "1";
		formula = formula.toUpperCase();
		for(String t:array){
			if(t.indexOf(formula)==-1){
				formula = formula.replaceAll(t, "1");
			}
		}
		formula = formula.replace("(","");
		formula = formula.replace(")","");
		char[] strArr = formula.toCharArray(); 
		for(int i=0;i<strArr.length;i++){
        	String a = String.valueOf(strArr[i]);
        	for(int j=i+1;j<strArr.length;){
        		String b = String.valueOf(strArr[j]);
        		if(a.equals(b)){
        			flg = "0";
        			break;
        		}else{
        			break;
        		}
        	}
        }
		return flg;
	}
	//验证只能包含运算符
	public String isOperator(String formula){
		String flg = "1";
		String formulStr="";
		String oper ="";
		String operTem="+-*/().";
		formulStr = formula.toUpperCase();
		formulStr = formulStr.replaceAll("\\d+", "A");
		for(int i=0;i<formulStr.length();i++){
			if(formulStr.charAt(i)<='Z' && formulStr.charAt(i)>='A'){
				
			}else{
				oper += formula.charAt(i);
			}
		}
		if(!"".equals(oper)){
			for(int j=0;j<oper.length();j++){
				if(operTem.indexOf(oper.charAt(j))!=-1){
					flg = "1";
				}else{
					flg = "0";
					break;
				}
			}
		}
		return flg;
	}
	
	//判断被除数为0
	public String isDividendZero(String formula){
		String flg="1";
		
		
		return flg;
	}
	
	
}
