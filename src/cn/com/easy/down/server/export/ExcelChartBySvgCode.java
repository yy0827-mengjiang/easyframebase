package cn.com.easy.down.server.export;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import jxl.Workbook;
import jxl.write.Label;
import jxl.write.NumberFormats;
import jxl.write.WritableCellFormat;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import com.fasterxml.jackson.databind.ObjectMapper;

public class ExcelChartBySvgCode extends ExcelPdf implements Strategy {

	@Override
	public String export(ArgsBean args) throws Exception{
		WritableWorkbook wbook=null;
		String filename = args.getFileName();
		if(filename==null||"".equals(filename.trim())){
			filename="sheet1";
		}
		String jsonData = args.getJsonData().replaceAll("undefined", "\"undefined\"");
		String path = args.getDownPath() + args.getUuid() + ".xls";
		
		wbook = Workbook.createWorkbook(new File(path));
		
		WritableSheet wsheet = wbook.createSheet(filename, 0); // sheet名
		ObjectMapper mapper = new ObjectMapper();
		List<Map> jsonList = mapper.readValue(jsonData, List.class);
		Set set = jsonList.get(0).keySet();
		List<String> headKeyList=new ArrayList<String>();
		for(Object obj : set){
			headKeyList.add(String.valueOf(obj));
		}
		Label label = null;
		for(int i=0;i<headKeyList.size();i++){
			label = new Label(i, 0, headKeyList.get(i));// 设置标题
			label.setCellFormat(super.getCellFormat("Head"));
			wsheet.addCell(label);
		}
		String keyValue=null;
		String tempKeyValue=null;
		WritableCellFormat cf_Head = super.getCellFormat("dataHead");
		WritableCellFormat cf_floatData = super.getCellFormat("floatData");
		WritableCellFormat cf_intData = super.getCellFormat("intData");
		WritableCellFormat cf_floatData_100 = super.getCellFormat("FloatData_100");
		jxl.write.Number number = null;
		int colNum=0;
		int rowNum=0;
		for(int a=0;a<jsonList.size();a++){
			for(int b = 0;b<headKeyList.size();b++){
				colNum=b;
				rowNum=a+1;
				keyValue=String.valueOf(jsonList.get(a).get(headKeyList.get(b)));
				keyValue = ((!keyValue.equals("null"))&& (!keyValue.equals(""))) ? keyValue.toString().replaceAll(" ", "").replaceAll(",", "") : "";
				tempKeyValue = ((!keyValue.equals("null"))&& (!keyValue.equals(""))) ? keyValue.toString().replaceAll("&nbsp;", " ") : "";
				if (keyValue != null && (!keyValue.equals(""))) {
					if (keyValue.toString().matches("-?[0-9]+[.]?[0-9]*%")) {//正负nn% 小数点可有可无，长度没限制;数据因该避免有nn.%情况
						if(keyValue != null && !keyValue.toString().equals("")){
							if(keyValue.toString().indexOf("%") != -1){
								WritableCellFormat wcf=new WritableCellFormat(NumberFormats.PERCENT_FLOAT);
								number = new jxl.write.Number(colNum, rowNum, Double.parseDouble(keyValue.toString().replaceAll("%",""))/100,wcf);
								number.setCellFormat(cf_floatData_100);
								wsheet.addCell(number);
							}else{
								WritableCellFormat wcf=new WritableCellFormat(NumberFormats.PERCENT_FLOAT);
								number = new jxl.write.Number(colNum, rowNum, Double.parseDouble(keyValue.toString()),wcf);
								number.setCellFormat(cf_floatData_100);
								wsheet.addCell(number);
							}
						}else{
							label = new Label(colNum, rowNum, "");
							wsheet.addCell(label);
						}
					} else if (keyValue.toString().matches("-?[0-9]+[.][0-9]+")) {//正负nn.nn小数，长度没限制
						number = new jxl.write.Number(colNum, rowNum, Double.parseDouble(keyValue.toString()));
						number.setCellFormat(cf_floatData);
						wsheet.addCell(number);

					} else if (keyValue.toString().matches("-?[0-9]+")) {//正负整数
						number = new jxl.write.Number(colNum, rowNum, Double.parseDouble(keyValue.toString()));
						number.setCellFormat(cf_intData);
						wsheet.addCell(number);
					} else if (keyValue.toString().matches("-?[0-9]+[.]?[0-9]*E[1-9]+")) {
						BigDecimal bdmp = new BigDecimal(keyValue.toString());  
						String bdmpplain = bdmp.toPlainString();
						number = new jxl.write.Number(colNum, rowNum, Double.parseDouble(bdmpplain));
						number.setCellFormat(cf_floatData);
						wsheet.addCell(number);
					} else {
						label = new Label(colNum, rowNum, (tempKeyValue != null && !tempKeyValue.equals("")) ? tempKeyValue.replaceAll("<.*?>", "") : "");// 设置标题
						label.setCellFormat(cf_Head);
						wsheet.addCell(label);
					}
				} else {
					label = new Label(colNum, rowNum, (tempKeyValue != null && !tempKeyValue.equals("")) ? tempKeyValue.replaceAll("<.*?>", "") : "");// 设置标题
					label.setCellFormat(cf_Head);
					wsheet.addCell(label);
				}
			}
		}
		
		wbook.write();
		wbook.close();
		return path;
	}
}