package cn.com.easy.ext;

import java.awt.Color;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import cn.com.easy.core.sql.SqlRunner;
 
public class PoiFileUtil {
	/**
	 * 读取文本文件
	 * @param file 所要读取的文本文件
	 * @param startRow 数据开始行
	 * @param cols 列所对应的字段
	 * @return
	 */
	public static List<Map> readText(File file, int startRow, List<String> cols,StringBuffer messages) {
		List<Map> lm = new ArrayList<Map>();
		Map map = null;
		int curRow = 1;
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(file));
			String line = "";
			while((line = br.readLine())!=null){
				if(curRow == startRow && cols.size()==0){
					for(String s :line.trim().split("\t"))
						cols.add(s);
				}
				if(curRow>startRow){
					map = new HashMap();
					//String [] colmouns = line.trim().split("\t");//原来要求每一列必须有值并且不能为空
					String [] colmouns = line.split("\t");//如果某列的值就为空怎么处理，写成空格或其他内容导入？
					System.out.println(colmouns.length+"==="+cols.size());
					if(colmouns.length>cols.size()){
						if(messages!=null)
							messages.append("数据格式错误：第"+curRow+"行数据多于字段列，请查看！");
						return null;
					}
					if(colmouns.length<cols.size()){
						if(messages!=null)
							messages.append("数据格式错误：第"+curRow+"行数据少于字段列，请查看！");
						return null;
					}
					System.out.println("ttttttttttttttt");
					for(int c = 0; c < colmouns.length ; c++ ){
						map.put(cols.get(c), colmouns[c]);
						if(c == colmouns.length-1){
							lm.add(map);
						}
					}
				}
				curRow++;
			}
		} catch (Exception e) {
			e.printStackTrace();
			if(messages!=null)
				messages.append("读取过程中出错！请稍候联系管理员");
			return null;
		}finally {
			try {
				if(br != null){
						br.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		System.out.println(lm);
		return lm;
	}

	/**
	 * 
	 * @param file 要读取的EXCEL文件
	 * @param startRow 数据的起始行（从0开始）
	 * @param cols 列对应的字段
	 * @return 返回list<map>
	 * @throws IOException
	 */
	public static List<Map> readExcel(File file, int startRow,
			List<String> cols) throws IOException {
		FileInputStream fis = new FileInputStream(file);
		List<Map> lm = new ArrayList<Map>();
		Map map = new HashMap();
		int c = 0;
		int r = 0;
		Workbook wb = null;
		if(file.getName().endsWith("xlsx")){
			wb = new XSSFWorkbook(fis);
		} else {
			wb = new HSSFWorkbook(fis);
		}
		int sheets = wb.getNumberOfSheets();
		System.out.println(file+"的sheets==="+sheets);
		Sheet sheet ;
		for(int i = 0; i < sheets; i++) {
			sheet = wb.getSheetAt(i);
			for (Row row : sheet) {
				map = new HashMap();
				if(row.getRowNum()==startRow-1 && cols.size()==0){
					for (Cell cell : row){
						String cellStr = cell.getStringCellValue();
						if(cellStr==null || cellStr==""){
							cols.add("-");
						}else{
							cols.add(cellStr);
						}
					}
				}
				if(row.getRowNum()<startRow){
					continue;
				}
				for (Cell cell : row) {
					c=cell.getColumnIndex();
					switch (cell.getCellType()) {
						case Cell.CELL_TYPE_STRING:
							map.put(cols.get(c), cell.getRichStringCellValue()
									.getString());
							break;
						case Cell.CELL_TYPE_NUMERIC:
							if (DateUtil.isCellDateFormatted(cell)) {
								map.put(cols.get(c), new Date(cell.getDateCellValue().getTime()));
							} else {
								map.put(cols.get(c), cell.getNumericCellValue());
							}
							break;
						case Cell.CELL_TYPE_BOOLEAN:
							map.put(cols.get(c), cell.getBooleanCellValue());
							System.out.println(cell.getBooleanCellValue());
							break;
						case Cell.CELL_TYPE_FORMULA:
							map.put(cols.get(c), cell.getCellFormula());
							break;
					}
				}
				lm.add(map);
			}
		}
		return lm;
	}
	/**
	 * 
	 * @param file 创建的文件
	 * @param sheetName sheet名
	 * @param datas 写入数据
	 * @param mapKeys 每列的字段
	 * @param pageSize 分页的记录条数（0表示不分）
	 * @throws FileNotFoundException
	 */
	@SuppressWarnings("rawtypes")
	public static void writeExcel(File file,String sheetName,List<Map> datas,List<String> mapKeys,int pageSize) throws FileNotFoundException{
		FileOutputStream fos = new FileOutputStream(file);
		Workbook wb = null;
		if(file.getName().endsWith(".xlsx")){
			wb = new XSSFWorkbook();
		} else {
			wb = new HSSFWorkbook();
		}
		Sheet sheet = wb.createSheet(sheetName);
		Set set = datas.get(0).keySet();
		if(mapKeys == null){
			mapKeys = new ArrayList<String>();
			for(Object s : set){
				mapKeys.add(s.toString());
			}
		}
		createHead(wb,sheet,mapKeys);
		for(int r = 0; r < datas.size(); r++){
			if(pageSize != 0 && r>=pageSize){
				sheet = wb.createSheet(sheetName+r/pageSize);
				pageSize += pageSize;
			}
			
			Row row = sheet.createRow(r+1);
			int c = 0;
//			for(Object o )
			for(String key : mapKeys){
				Cell cell = row.createCell(c++);
				Object o = datas.get(r).get(key);
				if ( o instanceof String) {
					cell.setCellValue(o.toString());
					continue;
				}
				if(o instanceof java.util.Date){
					cell.setCellValue((Date)o);
					continue;
				}
				if(o instanceof Double){
					cell.setCellValue((Double)o);
					continue;
				}
				if(o instanceof Boolean){
					cell.setCellValue((Boolean)o);
					continue;
				}
				if(o instanceof Integer){
					cell.setCellValue((Integer)o);
					continue;
				}
				cell.setCellValue("--");
			}
		}
		try {
			wb.write(fos);
		} catch (IOException e) {
			e.printStackTrace();
		} finally{
			try {
				if(fos!=null)
					fos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * 
	 * @param wb 
	 * @param sheet
	 * @param headerNames
	 */
	public static void createHead(Workbook wb,Sheet sheet,List<String> headerNames){
		Row row = sheet.createRow(0);
		Cell cell;
		Font font = wb.createFont();
		font.setFontHeightInPoints((short)12);
		font.setFontName("宋体");
		CellStyle cs =  wb.createCellStyle();
		cs.setFont(font);
		cs.setAlignment(CellStyle.ALIGN_CENTER);
		for(int i = 0; i < headerNames.size(); i++){
			cell = row.createCell(i);
			cell.setCellValue(headerNames.get(i));
			cell.setCellStyle(cs);
		}
	}
	
	public static void writeTxt(List<Map> datas,File file,List<String> keyList) throws IOException{
		FileWriter fw = new FileWriter(file);
		BufferedWriter bw = new BufferedWriter(fw);
		Set mapKeys = datas.get(0).keySet();
		if(keyList == null) 
			keyList = new ArrayList(mapKeys);
		for(int c = 0; c < keyList.size(); c++){
			bw.write(keyList.get(c));
			if(c < keyList.size()-1)
				bw.write("\t");
		}
		bw.write("\r\n");
		for(Map m : datas){
			for(int i = 0; i < keyList.size(); i++){
				if(m.get(keyList.get(i)) != null){
					bw.write(m.get(keyList.get(i)).toString());
				}
				else
					bw.write("null");
				if(i < (keyList.size()-1))
					bw.write("\t");
			}
			bw.write("\r\n");
		}
		bw.close();
		fw.close();
	}
	public static void writeTxt(String content,File file)throws Exception{
		FileWriter fw = new FileWriter(file);
		BufferedWriter bw = new BufferedWriter(fw);
		bw.write(content);
		bw.close();
		fw.close();
	}
	
	public static StringBuffer readText(File f) throws Exception{
		FileReader fr = new FileReader(f);
		BufferedReader br = new BufferedReader(fr);
		String line = null;
		StringBuffer sb = new StringBuffer("");
		while((line=br.readLine())!=null)
			sb.append(line).append("\n");
		return sb;
	} 
	
	public static void main(String[] args) {
		
	}
}
