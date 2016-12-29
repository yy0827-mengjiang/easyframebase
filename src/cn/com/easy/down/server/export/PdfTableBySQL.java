package cn.com.easy.down.server.export;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.down.server.CommonToolsUtil;
import cn.com.easy.down.server.PdfAddWaterMark;
import cn.com.easy.util.SqlUtils;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfWriter;

public class PdfTableBySQL extends ExcelPdf implements Strategy {

	@Override
	public String export(ArgsBean args) throws Exception {
		String fileAllPath = null;
		int exl_max_recode = 2500,num=0;
		String dataSourceName = args.getDownDb();
		SqlRunner runner = args.getRunner();
		Map<String, String> parameters = args.getParameters();
		if(args.getMaxRow() != null && !args.getMaxRow().equals("") && !args.getMaxRow().trim().equals("")){
			exl_max_recode = Integer.parseInt(args.getMaxRow());
		}
		String sql = args.getDownSql();
		sql = SqlUtils.characterConversion(sql);
		
		//>>导出的文件列表，多于1个时，需要压缩，再导出
		List<String> elsList = new ArrayList<String>();
		int page = 1;
		while(true){
			num++;
			if(num>5000){
				num=0;
				Thread.sleep(50);
			}
			int start = (page-1)*exl_max_recode;
			int end = page*exl_max_recode;
			String data_sql = "";
			data_sql = CommonToolsUtil.getSqlRows(dataSourceName, sql, start, end);
			
			List data = null;
			if(parameters != null && parameters.size()>0){
				if (dataSourceName != null && !dataSourceName.equals("")&& !dataSourceName.toUpperCase().trim().equals("NULL") && !dataSourceName.trim().equals(""))
					data = runner.queryForMapList(dataSourceName,data_sql,parameters);
				else 
					data = runner.queryForMapList(data_sql,parameters);
			}else{
				if (dataSourceName != null && !dataSourceName.equals("")&& !dataSourceName.toUpperCase().trim().equals("NULL") && !dataSourceName.trim().equals(""))
					data = runner.queryForMapList(dataSourceName,data_sql,(Object[])null);
				else 
					data = runner.queryForMapList(data_sql);
			}
			if(data == null || data.size()<=0){
				break;
			}
			
			String pre_tmp = page<10?"0"+page+"_":page+"_";
			String xls_name = pre_tmp+args.getUuid() + ".pdf";
			
			Document doc = new Document(PageSize.A4);
			PdfWriter.getInstance(doc, new FileOutputStream(args.getDownPath()+xls_name));
			doc.open();
			this.bigData2Pdf(data, args.getColumns(),doc,start,end,(page-1));
			page++;
			doc.newPage();
			doc.close();
			
			
			if(args.getMarkInfo() != null){
				PdfAddWaterMark mark = new PdfAddWaterMark();
				args.getMarkInfo().put("srcpdf", args.getDownPath()+xls_name);
				args.getMarkInfo().put("destpdf", args.getDownPath()+xls_name+"_.pdf");
				mark.addTextMark(args.getMarkInfo());
				
				File tempfile = new File(args.getDownPath()+xls_name);
				if (tempfile.exists()) {
					tempfile.delete();
				}
				elsList.add(args.getDownPath()+xls_name+"_.pdf");
			}else{
				elsList.add(args.getDownPath()+xls_name);
			}
		}
		
		//下载的文件
		if(elsList.size()>1){
			fileAllPath = args.getDownPath()+args.getUuid()+".zip";
            zip(fileAllPath,elsList);
		}else if(elsList.size()==1){
			fileAllPath = elsList.get(0);
			File downFile=new File(fileAllPath);
			downFile.renameTo(new File(fileAllPath));
		}else{
			//>>出错
			System.err.println("在导出 "+args.getFileName()+" 文件时出错，请联系管理员");
			return null;
		}
		return fileAllPath;
	}
	private void bigData2Pdf(List<Map> data,String columns, Document doc,int start,int end,int page) throws RowsExceededException, WriteException, DocumentException, IOException, InterruptedException {
		columns = columns != null?columns.replaceAll("<.*?>", ""):"";
		row = columns.split("&").length - 1;
		List nameList = arr2Title(columns, "0"); // 生成excel表头
		int size = ((List<String>) nameList.get(3)).size();
		Table table = new Table(size);
		writeHeadToPdf((List) nameList.get(0), (List) nameList.get(1),table);// 将表格头写入excel
		List<String> filedList = (List<String>)nameList.get(2);
		filedList.remove(filedList.size()-1);
		List<String> percentList = (List<String>)nameList.get(3);
		writeBigDataPdf(data, table,filedList,percentList);
		doc.add(table);
	}
	private void writeBigDataPdf(List<Map> data, Table table,List fieldList,List percentList) throws DocumentException, IOException, InterruptedException {
		int col = 0;
		int num=1;
		Object keyValue = null;
		String tempKeyValue = null;
		BaseFont bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H",BaseFont.NOT_EMBEDDED);
		Font font = new Font(bfChinese, 9, Font.NORMAL);

		@SuppressWarnings("unused")
		jxl.write.Number number = null;
		for(int d=0;d<data.size();d++){
			row++;
			Map dataMap = data.get(d);
			for (int xx = 0; xx < fieldList.size(); xx++) {
				for (int xxx = 0; xxx < fieldList.size(); xxx++) {
					int coln = Integer.parseInt(((String) fieldList.get(xxx)).split("&")[1]);
					if(coln == xx){
						col = Integer.parseInt(((String) fieldList.get(xxx)).split("&")[1]);
						keyValue = dataMap.get(((String) fieldList.get(xxx)).split("&")[0]);
						tempKeyValue = (keyValue != null && (!keyValue.equals(""))) ? keyValue.toString().replaceAll("&nbsp;", " ") : "";
						keyValue =  (keyValue != null && (!keyValue.equals(""))) ? keyValue.toString().replaceAll(" ", "").replaceAll(",", "") : "";
						break;
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
							table.addCell(new Paragraph(keyValue.toString(), font));
						}

					} else if (keyValue.toString().matches("-?[0-9]+")) {//正负整数
						if(percentList.get(col).equals("1")){
							DecimalFormat numformat = new  DecimalFormat("#####0.00");  
							table.addCell(new Paragraph(numformat.format(Double.parseDouble(keyValue.toString())*100)+"%", font));
						}else{
							table.addCell(new Paragraph(keyValue.toString(), font));
						}
					} else if (keyValue.toString().matches("-?[0-9]+[.]?[0-9]*E[1-9]+")) {
						if(percentList.get(col).equals("1")){
							DecimalFormat numformat = new  DecimalFormat("#####0.00");  
							table.addCell(new Paragraph(numformat.format(Double.parseDouble(keyValue.toString())*100)+"%", font));
						}else{
							table.addCell(new Paragraph(keyValue.toString(), font));
						}
					} else {
						table.addCell(new Paragraph(keyValue.toString(), font));
					}
				} else {
					table.addCell(new Paragraph((tempKeyValue != null && !tempKeyValue.equals("")) ? tempKeyValue.replaceAll("<.*?>", "") : "", font));
				}
			}
			if(d>=num*1000){
				Thread.sleep(1000);
				num++;
			}
		}
	}
}
