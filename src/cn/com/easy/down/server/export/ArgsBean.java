package cn.com.easy.down.server.export;

import java.util.Map;

import cn.com.easy.core.sql.SqlRunner;

public class ArgsBean {
	private SqlRunner runner;
	private String maxRow;
	private String downPath;
	private String downSql;
	private String downDb;
	private Map<String, String> parameters;
	private Map<String, String> markInfo;
	private String dataType;
	private String fileType;
	private String jsonData;
	private String fileName;
	private String columns;
	private String commentType="";//组件类型，表格：table,图型：chart
	private String svgCode="";//图形组件的svg代码
	private String uuid;
	public ArgsBean(SqlRunner _runner,String _maxRow,String _downPath,String _downSql,String _downDb,Map<String, String> _parameters,Map<String, String> _markInfo,String _dataType,String _fileType,String _jsonData,String _fileName,String _columns,String _commentType,String _svgCode,String _uuid){
		this.runner = _runner;
		this.maxRow = _maxRow;
		this.downPath = _downPath;
		this.downSql = _downSql;
		this.downDb = _downDb;
		this.parameters = _parameters;
		this.markInfo = _markInfo;
		this.dataType = _dataType;
		this.fileType = _fileType;
		this.jsonData = _jsonData;
		this.fileName = _fileName;
		this.columns = _columns;
		this.commentType =_commentType;
		this.svgCode =_svgCode;
		this.uuid = _uuid;
	}
	public SqlRunner getRunner() {
		return runner;
	}
	public String getMaxRow() {
		return maxRow;
	}
	public String getDownPath() {
		return downPath;
	}
	public String getDownSql() {
		return downSql;
	}
	public String getDownDb() {
		return downDb;
	}
	public Map<String, String> getParameters() {
		return parameters;
	}
	public Map<String, String> getMarkInfo() {
		return markInfo;
	}
	public String getDataType() {
		return dataType;
	}
	public String getFileType() {
		return fileType;
	}
	public String getJsonData() {
		return jsonData;
	}
	public String getFileName() {
		return fileName;
	}
	public String getColumns() {
		return columns;
	}
	public String getCommentType() {
		return commentType;
	}
	public String getSvgCode() {
		return svgCode;
	}
	public void setSvgCode(String _svgCode) {
		this.svgCode = _svgCode;
	}
	public String getUuid() {
		return uuid;
	}
}