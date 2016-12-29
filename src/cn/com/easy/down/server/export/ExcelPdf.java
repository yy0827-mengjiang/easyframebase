package cn.com.easy.down.server.export;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.apache.tools.ant.taskdefs.GZip;

import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.NumberFormat;
import jxl.write.NumberFormats;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

import com.lowagie.text.Cell;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.BaseFont;

public class ExcelPdf {
	protected int row = 0;
	protected void writeHeadToExcel(List nameLst, List excelLst,WritableSheet sheet) throws RowsExceededException, WriteException {
		String nameStr = "";
		String exceStr = "";
		Label label = null;
		int cols = 0;
		int rows = 0;
		int endCols = 0;
		// 解析生成的list，合并excel单元格，下面为写入excel数据
		for (int m = 0; m < nameLst.size(); m++) {
			nameStr = (String) nameLst.get(m);
			exceStr = (String) excelLst.get(m);
			if (exceStr.indexOf("&") > 0) { // 合并单元格的标题
				cols = Integer.parseInt(exceStr.split("&")[0].split(",")[1]);
				rows = Integer.parseInt(exceStr.split("&")[0].split(",")[0]);
				endCols = Integer.parseInt(exceStr.split("&")[1].split(",")[1]);
				sheet.mergeCells(cols, rows, endCols, Integer.parseInt(exceStr
						.split("&")[1].split(",")[0]));// 从左上角的列行到到右下角的列行
			} else {// 单个单元格的标题
				cols = Integer.parseInt(exceStr.split(",")[1]);
				rows = Integer.parseInt(exceStr.split(",")[0]);
				endCols = cols;
			}
			label = new Label(cols, rows, nameStr);// 设置标题
			label.setCellFormat(getCellFormat("Head"));
			sheet.setColumnView(cols, 20 * (endCols - cols) + 20);// 设置列的宽度，每列宽为40
			sheet.addCell(label);
		}
	}
	protected void writeHeadToPdf(List nameLst, List<String> excelLst,Table table) throws DocumentException, IOException {
		String nameStr = "";
		String exceStr = "";
		int cols = 0;
		int rows = 0;
		int endCols = 0;
		BaseFont bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H",BaseFont.NOT_EMBEDDED);
		//BaseFont bfComic = BaseFont.createFont("C:/WINDOWS/Fonts/SIMSUN.TTC,1",BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
		Font font = new Font(bfChinese, 9, Font.NORMAL);
		// 解析生成的list，合并excel单元格，下面为写入excel数据
		for (int m = 0; m < nameLst.size(); m++) {
			nameStr = (String) nameLst.get(m);
			exceStr = excelLst.get(m);
			if (exceStr.indexOf("&") > 0) { // 合并单元格的标题
				cols = Integer.parseInt(exceStr.split("&")[0].split(",")[1]);
				rows = Integer.parseInt(exceStr.split("&")[0].split(",")[0]);
				endCols = Integer.parseInt(exceStr.split("&")[1].split(",")[1]);
				
				Cell cell = new Cell(new Paragraph(nameStr, font));
				cell.setColspan(endCols-cols+1);
				cell.setRowspan(Integer.parseInt(exceStr.split("&")[1].split(",")[0])-rows+1);
				table.addCell(cell);// 合并
			} else {// 单个单元格的标题
				//cols = strToInt(exceStr.split(",")[1]);
				//rows = strToInt(exceStr.split(",")[0]);
				//endCols = cols;
				table.addCell(new Paragraph(nameStr, font));
			}
		}
	}
	protected List arr2Title(String columns, String type)throws RowsExceededException, WriteException {
		List<String> mergeLst = new ArrayList<String>(); // 合并的单元格（非本行的单元格）
		List<String> nameLst = new ArrayList<String>(); // 合并单元格的名称，行R+数字 或者
		//2013-11-29修改，增加前台百分比格式化数据【%】，后台也相应格式化
		List<String> percentLst = new ArrayList<String>(); // 前台列中，是否百分比格式化，1是，0否
		Map perListMap=new HashMap(); //2014-03-20
		// 单元格名称，C+数字 或者 名称,N+数字
		List<String> excelLst = new ArrayList<String>(); // excel表格的list
		List<String> fields = new ArrayList<String>(); // sql中的字段标示
		int intCol = 0; // 标题共占用的列数
		
		String[] colAllArr = columns.split("#");// 表头所有行
		//String[] rowAllArr = colAllArr[1].split("&");// 表头所有行
		String[] rowAllArr = colAllArr[0].split("&");// 表头所有行
		// 特殊处理第一列：第一列 不在传入的columns中， 故手动加上，合并所有行占一列
		rowFlag: for (int rows = 0; rows < rowAllArr.length; rows++) {// 遍历表头
			int offset = 0;// 列的偏移量
			List<String> colMergeList = new ArrayList<String>();
			String[] colMergeStr = null;
		
			// +mergeLst.size());
			// 判断本行是否已有合并行， 将跳过的列记录下来
			for (int x = 0; x < mergeLst.size(); x++) {
				colMergeStr = mergeLst.get(x).split(",");
				if (colMergeStr[0].equals("" + rows)) {
					colMergeList.add(colMergeStr[1]);
				}
			}
		
			String[] singleRow = rowAllArr[rows].split(";"); // rowAllArr[rows]单行,singleRow某行的所有列信息
			colFlag: for (int cols = 0; cols < singleRow.length; cols++) { // 遍历某行的所有列,excel第一列为维度列
				String[] singleCol = singleRow[cols].split(","); // 某列的所有信息[标题，字段，行，列]
		
				String title = singleCol[0].trim().replaceAll("<BR>", ""); // 标题，并过滤
				int mergeRow = Integer.parseInt(singleCol[2]);// 单元格的行数
				int mergeCol = Integer.parseInt(singleCol[3]);// 单元格的列数
				String isPercent = singleCol[4];
				
				// 判断本行是否有需要跳过的合并列，有的话列偏移量加一
				for (int y = 0; y < colMergeList.size(); y++) {
					if (colMergeList.get(y).equals("" + offset)) {
						offset++;
						y = 0;
					}
				}
		
				if (!(singleCol[1].equals("undefined"))) {// 字段为undefined时，说明有合并列的情况，否则为字段
					fields.add(singleCol[1].toString() + "&" + offset);// 添加表字段，以便读取json数据时，对应列写入excel
		//			percentLst.add(isPercent);//2013-11-29修改
					 perListMap.put(offset, isPercent);//2014-03-20
				}
				
				nameLst.add(title);
				if (mergeRow > 1) {// 有合并行或行列的情况
					String fromRowCol = rows + "," + offset; // 从哪行哪列开始合并
					String endRowCol = (rows + mergeRow - 1) + ","
							+ (offset + mergeCol - 1);// 合并到哪行哪列
					excelLst.add(fromRowCol + "&" + endRowCol);
		
					// 记录所有非本行合并的列
					for (int ii = 1; ii < mergeRow; ii++) {
						for (int jj = 0; jj < mergeCol; jj++) {
							mergeLst.add((rows + ii) + "," + (offset + jj));
						}
					}
					offset = offset + mergeCol;
				} else if (mergeCol > 1) {// 有合并列的情况
					String fromRowCol = rows + "," + offset;// 从哪行哪列开始合并
					String endRowCol = rows + "," + (offset + mergeCol - 1);// 合并excel列
					offset = offset + mergeCol;
					excelLst.add(fromRowCol + "&" + endRowCol);// 合并except列
				} else {
					excelLst.add(rows + "," + offset);// 单个单元格
					offset++;
				}
			}
		}
		Collections.sort(fields);// 按照升序排序，所以前台写列时，也必须是按升序来写，如：V1,V2,V3等
		fields.add("children");// 递归子集的字段
		List retList = new ArrayList();
		retList.add(nameLst);
		retList.add(excelLst);
		retList.add(fields);
		int inx=0; //2014-03-20
		while(perListMap.get(inx)!=null){
			percentLst.add(perListMap.get(inx).toString());
			inx++;
		}
		retList.add(percentLst);
		return retList;
	}
	protected void map2Str(Map dataMap, WritableSheet wsheet, String depth,
			List fieldList,List percentList) throws RowsExceededException, WriteException {
		int col = 0;
		Object keyValue = null;
		String tempKeyValue = null;
		WritableCellFormat cf_Head = getCellFormat("dataHead");
		// WritableCellFormat cf_data =getCellFormat("data");
		WritableCellFormat cf_floatData = getCellFormat("floatData");
		WritableCellFormat cf_intData = getCellFormat("intData");
		WritableCellFormat cf_floatData_100 = getCellFormat("FloatData_100");

		Label label = null;
		jxl.write.Number number = null;
		for (int xx = 0; xx < fieldList.size(); xx++) {
			keyValue = dataMap.get(((String) fieldList.get(xx)).split("&")[0]);
			if (!(keyValue instanceof ArrayList) && keyValue != null) {
				col = Integer.parseInt(((String) fieldList.get(xx)).split("&")[1]);
				tempKeyValue = keyValue.toString().replaceAll("&nbsp;", " ");
				keyValue = keyValue.toString().replaceAll(" ", "").replaceAll(
						",", "");
				if (col == 0 && depth != null) { // 下钻出来的信息：表头进行缩进
					for (int m = 0; m < Integer.parseInt(depth); m++) {
						keyValue = "　　" + keyValue.toString();
					}
				}
				if (keyValue != null && (!keyValue.equals(""))) {
					if (keyValue.toString().matches("-?[0-9]+[.]?[0-9]*%")) {//正负nn% 小数点可有可无，长度没限制;数据因该避免有nn.%情况
						if(keyValue != null && !keyValue.toString().equals("")){
							if(keyValue.toString().indexOf("%") != -1){
								WritableCellFormat wcf=new WritableCellFormat(NumberFormats.PERCENT_FLOAT);
								number = new jxl.write.Number(col, row, Double.parseDouble(keyValue.toString().replaceAll("%",""))/100,wcf);
								number.setCellFormat(cf_floatData_100);
								wsheet.addCell(number);
							}else{
								if(percentList.get(col).equals("1")){
									WritableCellFormat wcf=new WritableCellFormat(NumberFormats.PERCENT_FLOAT);
									number = new jxl.write.Number(col, row, Double.parseDouble(keyValue.toString()),wcf);
									number.setCellFormat(cf_floatData_100);
									wsheet.addCell(number);
								}else{
									WritableCellFormat wcf=new WritableCellFormat(NumberFormats.PERCENT_FLOAT);
									number = new jxl.write.Number(col, row, Double.parseDouble(keyValue.toString()),wcf);
									number.setCellFormat(cf_floatData_100);
									wsheet.addCell(number);
								}
							}
						}else{
							label = new Label(col, row, "");
							wsheet.addCell(label);
						}
					//} else if (keyValue.toString().matches("-?[0-9]*\\.[0-9]*")) {
					} else if (keyValue.toString().matches("-?[0-9]+[.][0-9]+")) {//正负nn.nn小数，长度没限制
						if(percentList.get(col).equals("1")){
							WritableCellFormat wcf=new WritableCellFormat(NumberFormats.PERCENT_FLOAT);
							number = new jxl.write.Number(col, row, Double.parseDouble(keyValue.toString()),wcf);
							number.setCellFormat(cf_floatData_100);
							wsheet.addCell(number);
						}else{
							number = new jxl.write.Number(col, row, Double.parseDouble(keyValue.toString()));
							number.setCellFormat(cf_floatData);
							wsheet.addCell(number);
						}
					} else if (keyValue.toString().matches("-?[0-9]+")) {//正负整数
						if(percentList.get(col).equals("1")){
							WritableCellFormat wcf=new WritableCellFormat(NumberFormats.PERCENT_FLOAT);
							number = new jxl.write.Number(col, row, Double.parseDouble(keyValue.toString()),wcf);
							number.setCellFormat(cf_floatData_100);
							wsheet.addCell(number);
						}else{
							number = new jxl.write.Number(col, row, Double.parseDouble(keyValue.toString()));
							number.setCellFormat(cf_intData);
							wsheet.addCell(number);
						}
					} else if (keyValue.toString().matches("-?[0-9]+[.]?[0-9]*E-[1-9]+")) {
						BigDecimal bdmp = new BigDecimal(keyValue.toString());  
						String bdmpplain = bdmp.toPlainString();
						if(percentList.get(col).equals("1")){
							WritableCellFormat wcf=new WritableCellFormat(NumberFormats.THOUSANDS_INTEGER);
							number = new jxl.write.Number(col, row, Double.parseDouble(bdmpplain),wcf);
							number.setCellFormat(cf_floatData_100);
							wsheet.addCell(number);
						}else{
							number = new jxl.write.Number(col, row, Double.parseDouble(bdmpplain));
							number.setCellFormat(cf_floatData);
							wsheet.addCell(number);
						}
					} else {
						label = new Label(col, row, tempKeyValue);
						label.setCellFormat(cf_Head);
						wsheet.addCell(label);
					}
				} else {
					label = new Label(col, row, tempKeyValue);
					label.setCellFormat(cf_Head);
					wsheet.addCell(label);
				}

			} else if (keyValue != null) {
				String tempDepth = "";
				if (depth == null) {
					tempDepth = "1";
				} else {
					tempDepth = "" + (1 + Integer.parseInt(depth));
				}
				ArrayList keyList = (ArrayList) keyValue;
				for (int i = 0; i < keyList.size(); i++) {
					row++;
					map2Str((Map) keyList.get(i), wsheet, tempDepth, fieldList,percentList);
				}
			}
		}
	}
	protected void map2StrPdf(Map dataMap, Table table, String depth,
			List<String> fieldList,List percentList) throws DocumentException, IOException {
		int col = 0;
		Object keyValue = null;
		String tempKeyValue = null;
		@SuppressWarnings("unused")
		jxl.write.Number number = null;
		BaseFont bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H",BaseFont.NOT_EMBEDDED);
		Font font = new Font(bfChinese, 9, Font.NORMAL);
		
		for (int xx = 0; xx < fieldList.size(); xx++) {
			String dkey = (this.sortList(fieldList,xx)).split("&")[0];
			keyValue = dataMap.get(dkey);
			if (!(keyValue instanceof ArrayList) && keyValue != null) {
				//col = strToInt((fieldList.get(xx)).split("&")[1]);
				col = Integer.parseInt((this.sortList(fieldList,xx)).split("&")[1]);
				tempKeyValue = keyValue.toString().replaceAll("&nbsp;", " ");
				keyValue = keyValue.toString().replaceAll(" ", "").replaceAll(
						",", "");
				if (col == 0 && depth != null) { // 下钻出来的信息：表头进行缩进
					for (int m = 0; m < Integer.parseInt(depth); m++) {
						keyValue = "　　" + keyValue.toString();
					}
				}
				if (keyValue != null && (!keyValue.equals(""))) {
					if (keyValue.toString().matches("-?[0-9]+[.]?[0-9]*%")) {//正负nn% 小数点可有可无，长度没限制;数据因该避免有nn.%情况
						if(keyValue != null && !keyValue.toString().equals("")){
							if(keyValue.toString().indexOf("%") != -1){
								table.addCell(new Paragraph(keyValue.toString(), font));
							}else{
								if(percentList.get(col).equals("1")){
									DecimalFormat numformat = new  DecimalFormat("#####0.00");  
									table.addCell(new Paragraph(numformat.format(Double.parseDouble(keyValue.toString())*100)+"%", font));
								}else{
									table.addCell(new Paragraph(keyValue.toString(), font));
								}
							}
						}else{
							table.addCell(new Paragraph("", font));
						}
					} else if (keyValue.toString().matches("-?[0-9]+[.][0-9]+")) {//正负nn.nn小数，长度没限制
						if(percentList.get(col).equals("1")){
							DecimalFormat numformat = new  DecimalFormat("#####0.00");  
							table.addCell(new Paragraph(numformat.format(Double.parseDouble(keyValue.toString())*100)+"%", font));
						}else{
							table.addCell(new Paragraph(keyValue.toString(), font));;
						}
					} else if (keyValue.toString().matches("-?[0-9]+")) {//正负整数
						if(percentList.get(col).equals("1")){
							DecimalFormat numformat = new  DecimalFormat("#####0.00");  
							table.addCell(new Paragraph(numformat.format(Double.parseDouble(keyValue.toString())*100)+"%", font));
						}else{
							table.addCell(new Paragraph(keyValue.toString(), font));
						}
					} else if (keyValue.toString().matches("-?[0-9]+[.]?[0-9]*E-[1-9]+")) {
						if(percentList.get(col).equals("1")){
							DecimalFormat numformat = new  DecimalFormat("#####0.00");  
							table.addCell(new Paragraph(numformat.format(Double.parseDouble(keyValue.toString())*100)+"%", font));
						}else{
							table.addCell(new Paragraph(keyValue.toString(), font));
						}
					} else {
						table.addCell(new Paragraph(tempKeyValue, font));
					}
				} else {
					table.addCell(new Paragraph(tempKeyValue, font));
				}

			} else if (keyValue != null) {
				String tempDepth = "";
				if (depth == null) {
					tempDepth = "1";
				} else {
					tempDepth = "" + (1 + Integer.parseInt(depth));
				}
				ArrayList keyList = (ArrayList) keyValue;
				for (int i = 0; i < keyList.size(); i++) {
					row++;
					map2StrPdf((Map) keyList.get(i), table, tempDepth, fieldList,percentList);
				}
			}else{
				if("children".equals(String.valueOf(dkey).trim().toLowerCase())){
					continue;
				}
				tempKeyValue=" ";
				table.addCell(new Paragraph(tempKeyValue, font));
			}
		}
	}
	
	protected void zip(String outName,List<String> files) throws IOException {
        ZipOutputStream zipOut = null;
        try{
        	zipOut = new ZipOutputStream(new FileOutputStream(outName));
	        for(int a=0;a<files.size();a++){
	        	File srcFile = new File(files.get(a));
	        	BufferedInputStream ins = new BufferedInputStream(new FileInputStream(srcFile));
				zipOut.putNextEntry(new ZipEntry(srcFile.getName()));
				int count = 0;
	            byte[] data = new byte[1024];
	            while ((count = ins.read(data, 0, 1024)) != -1) {
	            	zipOut.write(data, 0, count);
	            }
	            ins.close(); 
	        	
	            if(srcFile.exists()){
	            	srcFile.delete();
	    		}
	        }
        }finally{
        	if(null != zipOut){
        		zipOut.close();
        	}
        }
    }

	protected WritableCellFormat getCellFormat(String strType) throws WriteException {
		WritableCellFormat cf = new WritableCellFormat();
		if ("Head".equals(strType)) {
			cf.setBackground(Colour.LIGHT_TURQUOISE); // 背景颜色
			cf.setFont(new WritableFont(WritableFont.TIMES, 10,
					WritableFont.BOLD)); // 字体
			cf.setBorder(Border.ALL, BorderLineStyle.THIN); // 表格线
			cf.setWrap(true);
			cf.setVerticalAlignment(VerticalAlignment.CENTRE);
			cf.setAlignment(Alignment.CENTRE);
		} else if ("dataHead".equals(strType)) {
			cf.setFont(new WritableFont(WritableFont.TIMES, 10)); // 字体
			cf.setBorder(Border.ALL, BorderLineStyle.THIN); // 表格线
			cf.setVerticalAlignment(VerticalAlignment.CENTRE);
			cf.setAlignment(Alignment.LEFT);
		} else if ("floatData".equals(strType)) {// 两位小数点格式
			NumberFormat nfPERCENT_FLOAT = new NumberFormat("0.00");
			cf = new WritableCellFormat(nfPERCENT_FLOAT);
			cf.setFont(new WritableFont(WritableFont.TIMES, 10)); // 字体
			cf.setBorder(Border.ALL, BorderLineStyle.THIN); // 表格线
			cf.setVerticalAlignment(VerticalAlignment.CENTRE);
			cf.setAlignment(Alignment.LEFT);
		} else if ("intData".equals(strType)) {// 整数格式
			NumberFormat nfPERCENT_FLOAT = new NumberFormat("0");
			cf = new WritableCellFormat(nfPERCENT_FLOAT);
			cf.setFont(new WritableFont(WritableFont.TIMES, 10)); // 字体
			cf.setBorder(Border.ALL, BorderLineStyle.THIN); // 表格线
			cf.setVerticalAlignment(VerticalAlignment.CENTRE);
			cf.setAlignment(Alignment.LEFT);
		} else if ("FloatData_100".equals(strType)) {// 百分数格式
			NumberFormat nfPERCENT_FLOAT = new NumberFormat("0.00%");
			cf = new WritableCellFormat(nfPERCENT_FLOAT);
			cf.setFont(new WritableFont(WritableFont.TIMES, 10)); // 字体
			cf.setBorder(Border.ALL, BorderLineStyle.THIN); // 表格线
			cf.setVerticalAlignment(VerticalAlignment.CENTRE);
			cf.setAlignment(Alignment.LEFT);
		} else if ("FloatData_1000".equals(strType)) {// 百分数格式
			NumberFormat nfPERCENT_FLOAT = new NumberFormat("0.000%");
			cf = new WritableCellFormat(nfPERCENT_FLOAT);
			cf.setFont(new WritableFont(WritableFont.TIMES, 10)); // 字体
			cf.setBorder(Border.ALL, BorderLineStyle.THIN); // 表格线
			cf.setVerticalAlignment(VerticalAlignment.CENTRE);
			cf.setAlignment(Alignment.LEFT);
		} else {
			cf.setFont(new WritableFont(WritableFont.TIMES, 10)); // 字体
			cf.setBorder(Border.ALL, BorderLineStyle.THIN); // 表格线
			cf.setVerticalAlignment(VerticalAlignment.CENTRE);
			cf.setAlignment(Alignment.RIGHT);
		}
		return cf;
	}
	private String sortList(List<String> fieldList,int n) {
		String fieldStr1 = "";
       for(int i=0;i<fieldList.size();i++){
    	   fieldStr1 = fieldList.get(i);
			if(fieldStr1.indexOf("&") != -1){
				String[] fieldArr1 = fieldStr1.split("&");
				int a=Integer.parseInt(fieldArr1[1]);
				if(a == n){
					return fieldStr1;
				}
			}
		}
		return fieldStr1;
	}
}