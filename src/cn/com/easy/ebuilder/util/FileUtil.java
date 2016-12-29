package cn.com.easy.ebuilder.util;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

public class FileUtil {

	public FileUtil() {

	}
/**
 * 读取EXCEL文件 xls
 * @param fileName xls全路径
 * @return 内容列表
 */
	public static List readXls(String fileName){
		List<String> list = new ArrayList<String>();
		String filePath = fileName;
		InputStream fs = null;
		Workbook workBook = null;
		try {
			fs = new FileInputStream(filePath);
			workBook = Workbook.getWorkbook(fs);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (BiffException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		Sheet sheet = workBook.getSheet(0);
		System.out.println(sheet.getColumns());
		System.out.println(sheet.getRows());
		Cell cell = null;
		for (int j = 0; j < sheet.getColumns(); j++) {
			for (int i = 0; i < sheet.getRows(); i++) {
				cell = sheet.getCell(j, i);
				list.add(cell.getContents());
			}
		}
		workBook.close();// 记得关闭
		return list;
	}
}
