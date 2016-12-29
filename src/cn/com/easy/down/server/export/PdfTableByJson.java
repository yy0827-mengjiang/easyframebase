package cn.com.easy.down.server.export;

import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import cn.com.easy.down.server.PdfAddWaterMark;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.PdfWriter;

public class PdfTableByJson extends ExcelPdf implements Strategy {

	@Override
	public String export(ArgsBean args) throws Exception {
		String jsonData = args.getJsonData().replaceAll("undefined", "\"undefined\"");
		String columns = args.getColumns() != null?args.getColumns().replaceAll("<.*?>", ""):"";
		ObjectMapper mapper = new ObjectMapper();
		List<LinkedHashMap<String, Object>> jsonList = mapper.readValue(jsonData, List.class);
		row = columns.split("&").length - 1;// 数据写入的第一行为表格头的行数，此处-1是为了for循环的row++
	
		String path = args.getDownPath() + args.getUuid() + ".pdf";
		Document doc = new Document(PageSize.A4);
		PdfWriter.getInstance(doc, new FileOutputStream(path));
		doc.open();

		List nameList = super.arr2Title(columns, "0"); // 生成表格头List
		
		int size = ((List<String>) nameList.get(3)).size();
		//float[] widths = { 0.1f, 0.3f, 0.1f, 0.1f, 0.1f, 0.2f, 0.1f };
		//PdfPTable table = new PdfPTable(widths);
		//PdfPTable table = new PdfPTable(size);
		Table table = new Table(size);
		//table.setWidthPercentage(100);
		super.writeHeadToPdf((List) nameList.get(0), (List<String>) nameList.get(1),table);// 将表格头写入excel
		
		List<String> percentList = (List<String>)nameList.get(3);
		for (int ww = 0; ww < jsonList.size(); ww++) {// 将json数据写入excel
			row++;
			Map<String, Object> jsonMap = jsonList.get(ww);//jsonArr[ww];
			Map<String, Class<?>> clazzMap = new HashMap<String, Class<?>>();
			clazzMap.put("children", Map.class);
			Map<String, ?> dataMap = jsonMap;//(Map) JSONObject.toBean(jsonObject, Map.class, clazzMap);// 以上为将json转化为Map，map里为ArrayList和String,ArrayList里为map，一次类推，故用递归
			super.map2StrPdf(dataMap, table, null, (List<String>) nameList.get(2),percentList);
		}

		doc.add(table);
		doc.newPage();
		doc.close();
		@SuppressWarnings("unused")
		String filepath = path;
		//添加水印
		if(args.getMarkInfo() != null){
			PdfAddWaterMark mark = new PdfAddWaterMark();
			args.getMarkInfo().put("srcpdf", path);
			args.getMarkInfo().put("destpdf", path+"_.pdf");
			mark.addTextMark(args.getMarkInfo());
			filepath = path+"_.pdf";
			File tempfile = new File(filepath);
			if (tempfile.exists()) {
				tempfile.delete();
			}
			
		}
		return path;
	}
}