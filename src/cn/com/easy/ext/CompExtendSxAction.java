package cn.com.easy.ext;
/**
 * 功能：通过配置表e_comp_extend_btn，实现扩展表格按钮区，这个action为山西特有下载功能类，配置时url为：SxExtExport.e
 * 入口：方法downmain中的id为自动传递的表格id，配置时不用在url后加，通过id找到改个性化导出的配置map
 * 导出：方法extDownByCustomSql每个excel为5000记录默认，超出时生成多个excel名称为xx_1这样，多个excel压缩为zip文件下载
 */
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.net.URLDecoder;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
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
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

import org.apache.commons.beanutils.BeanUtils;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.util.SqlUtils;

@Controller
public class CompExtendSxAction {
	private SqlRunner runner;
	
	@Action("SxExtExport")
	public void downmain(String id,String columns,String dataSourceName,HttpServletRequest request, HttpServletResponse response){
		Map<String,String> info = CompExtendSxConfig.getConfig(id);
		info.put("JsonColumns", columns);//扩展可选择列时会用到，暂时没用
		info.put("DataSource", dataSourceName);
		this.extDownByCustomSql(info,request, response);
	}
	
	//导出excel方法
	private void extDownByCustomSql(Map<String,String> info,HttpServletRequest request, HttpServletResponse response) {
		String filename = info.get("FileName");
		try {
			int exl_max_recode = 50000;//>>每个excel文件最大记录条数
			String xls_path = request.getSession().getServletContext().getRealPath("/")+ "/pages/download/";
			List<String> parameterNames = new ArrayList<String>();
			String sql = SqlUtils.parseParameter(info.get("Sql"), parameterNames);
			sql = SqlUtils.characterConversion(sql);
			List parameters = new ArrayList();
			for (String parameterName : parameterNames) {
				try {
					parameters.add(getParameter(request, parameterName));
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		
			//>>导出的文件列表，多于1个时，需要压缩，再导出
			List<String> elsList = new ArrayList<String>();
			int page = 1;
			while(true){
				
				int start = (page-1)*exl_max_recode;
				int end = page*exl_max_recode;
				String data_sql = CommonToolsUtil.getSqlRows(info.get("DataSource"), sql, start, end);
				
				List data = null;
				if(parameters != null && parameters.size()>0){
					if (info.get("DataSource") != null && !info.get("DataSource").equals("")&& !info.get("DataSource").toUpperCase().trim().equals("NULL") && !info.get("DataSource").trim().equals(""))
						data = runner.queryForMapList(info.get("DataSource"),data_sql,parameters.toArray());
					else 
						data = runner.queryForMapList(data_sql,parameters.toArray());
				}else{
					if (info.get("DataSource") != null && !info.get("DataSource").equals("")&& !info.get("DataSource").toUpperCase().trim().equals("NULL") && !info.get("DataSource").trim().equals(""))
						data = runner.queryForMapList(info.get("DataSource"),data_sql,(Object[])null);
					else 
						data = runner.queryForMapList(data_sql);
				}
				if(data == null || data.size()<=0){
					break;
				}
				
				String pre_tmp = page<10?"0"+page+"_":page+"_";
				String xls_name = pre_tmp+new SimpleDateFormat("yyyyMMddHHmmssSSSS").format(new Date()) + ".xls";
				elsList.add(xls_name);
				WritableWorkbook wbook = Workbook.createWorkbook(new File(xls_path+xls_name));
				WritableSheet wsheet = wbook.createSheet(start+"-"+data.size(), page);
				String[] fields = info.get("Fields").split(",");
				for(int i=0;i<fields.length;i++){
					Label label = new Label(i,0,fields[i]);
					label.setCellFormat(this.getCellFormat("Head"));
					wsheet.addCell(label);
				}
				
				String tempKeyValue = null;
				WritableCellFormat cf_Head = this.getCellFormat("dataHead");
				WritableCellFormat cf_floatData = this.getCellFormat("floatData");
				WritableCellFormat cf_intData = this.getCellFormat("intData");
				WritableCellFormat cf_floatData_100 = this.getCellFormat("FloatData_100");
				
				for(int row=0;row<fields.length;row++){
					Map<String,Object> rowdata = (Map<String,Object> ) data.get(row);
					for(String key:rowdata.keySet()){
						Object keyValue = rowdata.get(key);
						Label label = null;
						jxl.write.Number number = null;
						int col = 0;
						
						if (keyValue != null && (!keyValue.equals(""))) {
							if (keyValue.toString().matches("-?[0-9]+.?[0-9]*%")) {//正负nn% 小数点可有可无，长度没限制;数据因该避免有nn.%情况
								if(keyValue != null && !keyValue.toString().equals("")){
									if(keyValue.toString().indexOf("%") != -1){
										WritableCellFormat wcf=new WritableCellFormat(NumberFormats.PERCENT_FLOAT);
										number = new jxl.write.Number(col, row, Double.parseDouble(keyValue.toString().replaceAll("%", "")) / 100,wcf);
										number.setCellFormat(cf_floatData_100);
										wsheet.addCell(number);
									}else{
										number = new jxl.write.Number(col, row, Double.parseDouble(keyValue.toString()));
										WritableCellFormat tmp_Head = cf_floatData_100;
										try { 
											tmp_Head.setWrap(true);//自动换行 
										} catch (Exception e) { 
										      e.printStackTrace(); 
										}
										number.setCellFormat(tmp_Head);
										wsheet.addCell(number);
									}
								}else{
									label = new Label(col, row, "");
									wsheet.addCell(label);
								}
							} else if (keyValue.toString().matches("-?[0-9]+[.][0-9]+")) {//正负nn.nn小数，长度没限制
									number = new jxl.write.Number(col, row, Double.parseDouble(keyValue.toString()));
									WritableCellFormat tmp_Head = cf_floatData;
									try { 
										tmp_Head.setWrap(true);//自动换行 
									} catch (Exception e) { 
									      e.printStackTrace(); 
									}
									number.setCellFormat(cf_floatData);
									wsheet.addCell(number);
	
							} else if (keyValue.toString().matches("-?[0-9]+")) {//正负整数
									number = new jxl.write.Number(col, row, Double.parseDouble(keyValue.toString()));
									WritableCellFormat tmp_Head = cf_intData;
									try { 
										tmp_Head.setWrap(true);//自动换行 
									} catch (Exception e) { 
									      e.printStackTrace(); 
									}
									number.setCellFormat(tmp_Head);
									wsheet.addCell(number);
							} else if (keyValue.toString().matches("-?[0-9]+.?[0-9]*E[1-9]+")) {
									number = new jxl.write.Number(col, row, Double.parseDouble(keyValue.toString()));
									WritableCellFormat tmp_Head = cf_floatData;
									try { 
										tmp_Head.setWrap(true);//自动换行 
									} catch (Exception e) { 
									      e.printStackTrace(); 
									}
									number.setCellFormat(tmp_Head);
									wsheet.addCell(number);
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
						col++;
					}
				}
				page++;
				wbook.write();
				wbook.close();
			}
			
			//下载的文件
			String exp_file = null;
			if(elsList.size()>1){
				String zip_name = xls_path+new SimpleDateFormat("yyyyMMddHHmmssSSSS").format(new Date())+".zip";
				OutputStream outputStream = new FileOutputStream(zip_name);
	            ZipOutputStream zipOutputStream = new ZipOutputStream(outputStream);
	            for(String item:elsList){
	                zip(xls_path+item,zipOutputStream,item);
	            }
	            zipOutputStream.close();
	            outputStream.close();
	            exp_file = zip_name;
			}else if(elsList.size()==1){
				exp_file = xls_path+elsList.get(0);
			}else{
				//>>出错
				System.err.println("在导出 "+filename+" 文件时出错，请联系管理员");
				return;
			}
			DownLoad down = new DownLoad();
			down.downloadFile(request, response, exp_file, filename);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (WriteException e) {
			e.printStackTrace();
		}
	}
	
	//>>压缩文件
	private void zip(String in,ZipOutputStream out,String outEntry) throws IOException {
    	File inf = new File(in);
    	FileInputStream ins = new FileInputStream(inf);
        out.putNextEntry(new ZipEntry(outEntry));
        int b;
        while ((b = ins.read()) != -1) {
            out.write(b);
        }
        ins.close();
    }
	
	//解析sql中的参数
	private Object getParameter(HttpServletRequest request, String name) throws Exception {
		int index = 0;
		String objectName = null;
		String propertyName = null;
		if ((index = name.indexOf(".")) != -1) {
			objectName = name.substring(0, index);
			propertyName = name.substring(index + 1);
		} else {
			objectName = name;
		}
		Object obj = request.getAttribute(objectName);
		if (obj == null)
			obj = request.getSession().getAttribute(objectName);
		if (obj == null)
			obj = request.getSession().getServletContext().getAttribute(objectName);
		if (obj == null){
			obj = request.getParameter(name);
		}else if (propertyName != null) {
			try {
				obj = BeanUtils.getProperty(obj, propertyName);
			} catch (IllegalAccessException e) {
				throw new Exception(e.toString(), e);
			} catch (InvocationTargetException e) {
				throw new Exception(e.toString(), e);
			} catch (NoSuchMethodException e) {
				throw new Exception(e.toString(), e);
			}
		}
		return URLDecoder.decode((String)obj,"utf-8");
	}
	
	//格式化excel样式
	private WritableCellFormat getCellFormat(String strType) {
		WritableCellFormat cf = new WritableCellFormat();
		try {
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
			} else {
				cf.setFont(new WritableFont(WritableFont.TIMES, 10)); // 字体
				cf.setBorder(Border.ALL, BorderLineStyle.THIN); // 表格线
				cf.setVerticalAlignment(VerticalAlignment.CENTRE);
				cf.setAlignment(Alignment.RIGHT);
			}
		} catch (WriteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return cf;
	}
}