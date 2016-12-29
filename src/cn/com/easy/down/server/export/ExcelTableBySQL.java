package cn.com.easy.down.server.export;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import jxl.Workbook;
import jxl.write.Label;
import jxl.write.NumberFormats;
import jxl.write.WritableCellFormat;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.down.server.CommonToolsUtil;
import cn.com.easy.util.SqlUtils;

public class ExcelTableBySQL extends ExcelPdf implements Strategy{
	@Override
	public String export(ArgsBean args) throws Exception {
		String fileAllPath = null;
		int exl_max_recode = 50000;
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
			int start = (page-1)*exl_max_recode;
			int end = page*exl_max_recode;
			String data_sql = "";//"select * from ( select t.*,rownum num from ("+sql+") t where rownum<="+end+") where num>"+start;
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
			String xls_name = pre_tmp +args.getUuid()+ ".xls";
			elsList.add(args.getDownPath()+xls_name);
			WritableWorkbook wbook = Workbook.createWorkbook(new File(args.getDownPath()+xls_name));
			this.bigData2Excel(data, args.getColumns(),wbook,start,end,(page-1));
			page++;
			wbook.write();
			wbook.close();
		}
		
		//下载的文件
		if(elsList.size()>1){
			fileAllPath = args.getDownPath()+args.getUuid()+".zip";
            super.zip(fileAllPath,elsList);
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
	private void bigData2Excel(List<Map> data,String columns, WritableWorkbook wbook,int start,int end,int page) throws RowsExceededException, WriteException {
		columns = columns != null?columns.replaceAll("<.*?>", ""):"";
		row = columns.split("&").length - 1;
		//WritableSheet wsheet = wbook.createSheet(start+"-"+end, page); // 分sheet导出
		WritableSheet wsheet = wbook.createSheet(start+"-"+data.size(), page); // 分sheet导出。
		List nameList = arr2Title(columns, "0"); // 生成excel表头
		super.writeHeadToExcel((List) nameList.get(0), (List) nameList.get(1),wsheet);// 将表格头写入excel
		List<String> filedList = (List<String>)nameList.get(2);
		filedList.remove(filedList.size()-1);
		
		List<String> percentList = (List<String>)nameList.get(3);
		this.writeBigData(data, wsheet,filedList,percentList);
	}
	private void writeBigData(List<Map> data, WritableSheet wsheet,List fieldList,List percentList) throws RowsExceededException, WriteException {
		int col = 0;
		int num=1;
		Object keyValue = null;
		String tempKeyValue = null;
		WritableCellFormat cf_Head = super.getCellFormat("dataHead");
		WritableCellFormat cf_floatData = super.getCellFormat("floatData");
		WritableCellFormat cf_intData = super.getCellFormat("intData");
		WritableCellFormat cf_floatData_100 = super.getCellFormat("FloatData_100");

		Label label = null;
		jxl.write.Number number = null;
		for(int d=0;d<data.size();d++){
			row++;
			Map dataMap = data.get(d);
			for (int xx = 0; xx < fieldList.size(); xx++) {
				keyValue = dataMap.get(((String) fieldList.get(xx)).split("&")[0]);
				col = Integer.parseInt(((String) fieldList.get(xx)).split("&")[1]);
				tempKeyValue = (keyValue != null && (!keyValue.equals(""))) ? keyValue.toString().replaceAll("&nbsp;", " ") : "";
				keyValue =  (keyValue != null && (!keyValue.equals(""))) ? keyValue.toString().replaceAll(" ", "").replaceAll(",", "") : "";
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
					} else if (keyValue.toString().matches("-?[0-9]+[.]?[0-9]*E[1-9]+")) {
						BigDecimal bdmp = new BigDecimal(keyValue.toString());  
						String bdmpplain = bdmp.toPlainString();
						if(percentList.get(col).equals("1")){
							WritableCellFormat wcf=new WritableCellFormat(NumberFormats.PERCENT_FLOAT);
							number = new jxl.write.Number(col, row, Double.parseDouble(bdmpplain),wcf);
							number.setCellFormat(cf_floatData_100);
							wsheet.addCell(number);
						}else{
							number = new jxl.write.Number(col, row, Double.parseDouble(bdmpplain));
							number.setCellFormat(cf_floatData);
							wsheet.addCell(number);
						}
					} else {
						label = new Label(col, row, (tempKeyValue != null && !tempKeyValue.equals("")) ? tempKeyValue.replaceAll("<.*?>", "") : "");// 设置标题
						label.setCellFormat(cf_Head);
						wsheet.addCell(label);
					}
				} else {
					label = new Label(col, row, (tempKeyValue != null && !tempKeyValue.equals("")) ? tempKeyValue.replaceAll("<.*?>", "") : "");// 设置标题
					label.setCellFormat(cf_Head);
					wsheet.addCell(label);
				}
			}
			if(d>=num*1000){
				try {
					Thread.sleep(1000);
					num++;
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		}
	}
}