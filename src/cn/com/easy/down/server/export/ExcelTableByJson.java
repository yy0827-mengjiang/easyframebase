package cn.com.easy.down.server.export;

import java.io.File;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jxl.Workbook;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import com.fasterxml.jackson.databind.ObjectMapper;

public class ExcelTableByJson extends ExcelPdf implements Strategy {
	@Override
	public String export(ArgsBean args) throws Exception {
		String jsonData = args.getJsonData().replaceAll("undefined", "\"undefined\"");
		String columns = args.getColumns() != null?args.getColumns().replaceAll("<.*?>", ""):"";
		ObjectMapper mapper = new ObjectMapper();
		List<LinkedHashMap<String, Object>> jsonList = mapper.readValue(jsonData, List.class);
		row = columns.split("&").length - 1;// 数据写入的第一行为表格头的行数，此处-1是为了for循环的row++
	
		String path = args.getDownPath() + args.getUuid() + ".xls";
		WritableWorkbook wbook = Workbook.createWorkbook(new File(path));
		WritableSheet wsheet = wbook.createSheet(args.getFileName(), 0); // sheet名
		List nameList = super.arr2Title(columns, "0"); // 生成表格头List

		super.writeHeadToExcel((List) nameList.get(0), (List) nameList.get(1),wsheet);// 将表格头写入excel
		List<String> percentList = (List<String>)nameList.get(3);
		for (int ww = 0; ww < jsonList.size(); ww++) {// 将json数据写入excel
			row++;
			//Object json = jsonList.get(ww);//jsonArr[ww];
			Map<String, Object> jsonMap = jsonList.get(ww);//jsonArr[ww];
			//JSONObject jsonObject = JSONObject.fromObject(json);
			Map<String, Class<?>> clazzMap = new HashMap<String, Class<?>>();
			clazzMap.put("children", Map.class);
			Map<String, ?> dataMap = jsonMap;//(Map) JSONObject.toBean(jsonObject, Map.class, clazzMap);// 以上为将json转化为Map，map里为ArrayList和String,ArrayList里为map，一次类推，故用递归
			map2Str(dataMap, wsheet, null, (List<String>) nameList.get(2),percentList);
		}

		wbook.write();
		wbook.close();
		return path;
	}
}