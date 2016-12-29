package cn.com.easy.xbuilder.utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class FileUtil {

	public FileUtil() {

	}

	public static List readXls(String fileName) throws IOException {
		InputStream is = new FileInputStream(fileName);
		HSSFWorkbook hssfWorkbook = new HSSFWorkbook(is);
		List<String> list = new ArrayList<String>();
		// Read the Sheet
		for (int numSheet = 0; numSheet < hssfWorkbook.getNumberOfSheets(); numSheet++) {
			HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(numSheet);
			if (hssfSheet == null) {
				continue;
			}
			// Read the Row
			for (int rowNum = 0; rowNum <=hssfSheet.getLastRowNum(); rowNum++) {
				HSSFRow hssfRow = hssfSheet.getRow(rowNum);
				if (hssfRow != null) {
					list.add(getValue(hssfRow.getCell(0)));
				}
			}
		}
		if(is!=null){
			is.close();
		}
		return list;

	}

	public static List readXlsx(String fileName) throws IOException {
		InputStream is = new FileInputStream(fileName);
		XSSFWorkbook xssfWorkbook = new XSSFWorkbook(is);
		List<String> list = new ArrayList<String>();
		// Read the Sheet
		for (int numSheet = 0; numSheet < xssfWorkbook.getNumberOfSheets(); numSheet++) {
			XSSFSheet xssfSheet = xssfWorkbook.getSheetAt(numSheet);
			if (xssfSheet == null) {
				continue;
			}
			// Read the Row
			for (int rowNum = 0; rowNum <= xssfSheet.getLastRowNum(); rowNum++) {
				XSSFRow xssfRow = xssfSheet.getRow(rowNum);
				if (xssfRow != null) {
					list.add(getValue(xssfRow.getCell(0)));
				}
			}
		}
		return list;

	}

	/**
	 * 读取EXCEL文件 xls
	 * 
	 * @param fileName
	 *            xls全路径
	 * @return 内容列表
	 * @throws IOException
	 */
	public static List readExcel(String fileName) {
		List<String> list = new ArrayList<String>();
		String filePath = fileName;
		InputStream fs = null;
		try {
			if (fileName.endsWith(".xls")) {
				
					list = readXls(fileName);
			
			} else if (fileName.endsWith(".xlsx")) {
				list = readXlsx(fileName);
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		/*
		 * Workbook workBook = null; try { fs = new FileInputStream(filePath);
		 * workBook = Workbook.getWorkbook(fs); } catch (FileNotFoundException
		 * e) { e.printStackTrace(); } catch (BiffException e) {
		 * e.printStackTrace(); } catch (IOException e) { e.printStackTrace(); }
		 * Sheet sheet = workBook.getSheet(0);
		 * System.out.println(sheet.getColumns());
		 * System.out.println(sheet.getRows()); Cell cell = null; for (int j =
		 * 0; j < sheet.getColumns(); j++) { for (int i = 0; i <
		 * sheet.getRows(); i++) { cell = sheet.getCell(j, i);
		 * list.add(cell.getContents()); } } workBook.close();// 记得关闭
		 */return list;
	}

	@SuppressWarnings("static-access")
	private static String getValue(XSSFCell xssfRow) {
		String resultString="";
		if (xssfRow.getCellType() == xssfRow.CELL_TYPE_BOOLEAN) {
			resultString= String.valueOf(xssfRow.getBooleanCellValue());
		} else if (xssfRow.getCellType() == xssfRow.CELL_TYPE_NUMERIC) {
			long longVal = Math.round(xssfRow.getNumericCellValue());  
		    if(Double.parseDouble(longVal + ".0") == xssfRow.getNumericCellValue()){
		    	resultString= String.valueOf(longVal);
		    }else{
		    	resultString= String.valueOf(xssfRow.getNumericCellValue());
		    }
			
		} else {
			resultString= String.valueOf(xssfRow.getStringCellValue());
		}
		return replaceSomeString(resultString);
	}
	public static String replaceSomeString(String srcStr){
		String newString=srcStr.trim();
		Pattern CRLF = Pattern.compile("(\r\n|\r|\n|\n\r)");
		Matcher m = CRLF.matcher(newString);
		if (m.find()) {
		 newString = m.replaceAll("");
		}
		return newString;
	}
	@SuppressWarnings("static-access")
	private static String getValue(HSSFCell hssfCell) {
		String resultString="";
		if (hssfCell.getCellType() == hssfCell.CELL_TYPE_BOOLEAN) {
			resultString= String.valueOf(hssfCell.getBooleanCellValue());
		} else if (hssfCell.getCellType() == hssfCell.CELL_TYPE_NUMERIC) {
			long longVal = Math.round(hssfCell.getNumericCellValue());  
			if(Double.parseDouble(longVal + ".0") == hssfCell.getNumericCellValue()){
				resultString= String.valueOf(longVal);
			}else{
				resultString= String.valueOf(hssfCell.getNumericCellValue());
			}
		} else {
			resultString= String.valueOf(hssfCell.getStringCellValue());
		}
		
		return replaceSomeString(resultString);
	}
}
