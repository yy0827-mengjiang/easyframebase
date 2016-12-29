package cn.com.easy.down.server.export;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;

import com.fasterxml.jackson.databind.ObjectMapper;

public class ExcelTableBigDataByJson extends ExcelTableBigDataBySQL implements Strategy {
	private List<LinkedHashMap<String, Object>> jsonList = null;
	//查询数据
	@Override
	protected boolean queryData() throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		jsonList = mapper.readValue(super.args.getJsonData(), List.class);
		return true;
	}
	//写xlsx数据
	@Override
	protected String write() throws Exception {
		//字段先排序
		Map<Integer,String> fieldTree = new TreeMap<Integer,String>();
		for (int x = 0; x < fieldList.size(); x++) {
			String[] kv = ((String) fieldList.get(x)).split("&");
			fieldTree.put(Integer.parseInt(kv[1]),kv[0]);
		}
		int num = xsheet.getPhysicalNumberOfRows();
		
		try {
			for (int ww = 0; ww < jsonList.size(); ww++) {
				Row row = xsheet.createRow(num+ww);
				Map<String, Object> jsonMap = jsonList.get(ww);
				for (int x :fieldTree.keySet()) {
					Cell cell = row.createCell(x);
					Object keyValue = jsonMap.get(fieldTree.get(x));
					if(null == keyValue || "".equals(keyValue)){
						cell.setCellValue("");
						cell.setCellType(XSSFCell.CELL_TYPE_STRING);
					}else if(keyValue instanceof String){
						cell.setCellValue(String.valueOf(keyValue));
						cell.setCellType(XSSFCell.CELL_TYPE_STRING);
					}else{
						cell.setCellValue(Double.parseDouble(String.valueOf(keyValue)));
						cell.setCellType(XSSFCell.CELL_TYPE_NUMERIC);
					}
				}
				this.i++;
				if(this.i>=1000000){
					if(!super.newFile(true)){
						return null;
					}
				}
			}
			if(!super.newFile(false)){
				return null;
			}
			return super.returnFile();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}