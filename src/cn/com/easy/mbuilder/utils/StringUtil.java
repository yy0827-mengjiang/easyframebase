package cn.com.easy.mbuilder.utils;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class StringUtil {

	public static List<String> getBind(String arg0, String regex) {
		String[] splitRes = arg0.split(regex);
		List<String> res = new ArrayList<String>();
		for (int i = 1; i < splitRes.length;) {
			res.add(splitRes[i]);
			i += 2;
		}
		return res;
	}

	public static int getCounts(String arg0, String regex) {
		if (arg0 == "" || arg0 == null)
			return 0;
		if (arg0.indexOf(regex) < 0)
			return 0;
		StringBuffer sb = new StringBuffer(arg0);
		int regex_length = regex.length();
		int count = 0;
		while (sb.indexOf(regex) >= 0) {
			count++;
			// sb.deleteCharAt(sb.indexOf(regex));
			sb.delete(sb.indexOf(regex), sb.indexOf(regex) + regex_length);
		}
		return count;
	}

	public static int isSql(String dataSql, String s, String e) {
		StringBuffer sb = new StringBuffer(dataSql);
		int start = -1;
		int end = -1;
		while (sb.indexOf(s) > -1) {
			start = sb.indexOf(s);
			if ((end = sb.indexOf(e, start)) > -1) {
				sb.deleteCharAt(start);
				sb.deleteCharAt(end - 1);
			} else {
				break;
			}
		}
		if (sb.indexOf(s) == -1 && sb.indexOf(e) == -1)
			return -1;
		else
			return sb.indexOf(s) != -1 ? sb.indexOf(s) : sb.indexOf(e);
	}

	public static String formatSql(String dataSql, String s, String e) {
		StringBuffer sb = new StringBuffer(dataSql);
		StringBuffer sb_temp = new StringBuffer(" "
				+ dataSql.toUpperCase().replaceAll("[\\s]", " ").replaceAll(
						"[\\(]", "( "));
		int start = -1;
		int end = -1;
		int total = 0;
		int start_where = 0;
		int end_where = 0;
		while (end_where != -1) {
			start_where = sb_temp.indexOf(" WHERE ", end_where + 6);
			end_where = sb_temp.indexOf(" SELECT ", start_where + 5);
			if (start_where == -1)
				break;
			if (end_where == -1) {
				total += StringUtil.getCounts(sb_temp.substring(start_where),
						"#");
			} else {
				total += StringUtil.getCounts(sb_temp.substring(start_where,
						end_where), "#");
			}
		}
		int count = 0;
		int index = 0;
		while (sb.indexOf(s) > -1) {
			start = sb.indexOf(s);
			if ((end = sb.indexOf(e, start)) > -1) {
				index++;
				if (!sb.substring(start + 1, end).trim().toUpperCase().matches(
						"(OR|AND)[\\D\\d]+#[\\D\\d]+#[\\D\\d]*"))
					if (!sb.substring(start + 1, end).matches(
							"[\\D\\d]+#[\\D\\d]+#[\\D\\d]*")
							|| !sb.substring(0, start).trim().toUpperCase()
									.endsWith("WHERE"))
						return "AND" + index;
				count += getCounts(sb.substring(start + 1, end), "#");
				sb.replace(end, end + 1, " ");
				sb.replace(start, start + 1, " ");
			} else {
				break;
			}
		}
		if (count != total)
			return "COUNT";
		if (sb.indexOf(s) == -1 && sb.indexOf(e) == -1)
			return sb.toString();
		else
			return null;
	}

	public static String getDataSequence() {
		String dataSequence = "";
		dataSequence = new SimpleDateFormat("yyyyMMddHHmmssSSS")
				.format(new Date());
		return dataSequence;
	}

	public static String getData() {
		String dataSequence = "";
		dataSequence = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
				.format(new Date());
		return dataSequence;
	}

	public static String getStringValue(String string) {
		if (string != null && !string.equals("")
				&& !string.toLowerCase().equals("undefined")
				&& !string.toLowerCase().equals("null")) {
			return string.trim();
		} else {
			return "";
		}
	}
	public static int getStrToIntValue(String string) {
		if (string != null && !string.equals("")
				&& !string.toLowerCase().equals("undefined")
				&& !string.toLowerCase().equals("null")) {
			return Integer.parseInt(string.trim());
		} else {
			return 0;
		}
	}
	private static final String regEx_script = "<script[^>]*?>[\\s\\S]*?<\\/script>"; // 定义script的正则表达式  
    private static final String regEx_style = "<style[^>]*?>[\\s\\S]*?<\\/style>"; // 定义style的正则表达式  
    private static final String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式  
    private static final String regEx_space = "\\s*|\t|\r|\n";//定义空格回车换行符
    /** 
     * @param htmlStr 
     * @return 
     *  删除Html标签 
     */  
    public static String delHTMLTag(String htmlStr) {  
        Pattern p_script = Pattern.compile(regEx_script, Pattern.CASE_INSENSITIVE);  
        Matcher m_script = p_script.matcher(htmlStr);  
        htmlStr = m_script.replaceAll(""); // 过滤script标签  
  
        Pattern p_style = Pattern.compile(regEx_style, Pattern.CASE_INSENSITIVE);  
        Matcher m_style = p_style.matcher(htmlStr);  
        htmlStr = m_style.replaceAll(""); // 过滤style标签  
  
        Pattern p_html = Pattern.compile(regEx_html, Pattern.CASE_INSENSITIVE);  
        Matcher m_html = p_html.matcher(htmlStr);  
        htmlStr = m_html.replaceAll(""); // 过滤html标签  
  
        Pattern p_space = Pattern.compile(regEx_space, Pattern.CASE_INSENSITIVE);  
        Matcher m_space = p_space.matcher(htmlStr);  
        htmlStr = m_space.replaceAll(""); // 过滤空格回车标签  
        return htmlStr.trim(); // 返回文本字符串  
    }  
      
    public static String getTextFromHtml(String htmlStr){  
        htmlStr = delHTMLTag(htmlStr);  
        htmlStr = htmlStr.replaceAll("&nbsp;", "");  
        //htmlStr = htmlStr.substring(0, htmlStr.indexOf("。")+1);  
        return htmlStr;  
    }  
}
