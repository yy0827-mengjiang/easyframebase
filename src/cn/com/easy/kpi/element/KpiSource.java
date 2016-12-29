package cn.com.easy.kpi.element;

public class KpiSource {
	private int source_key;
	private String kpi_code;
	private int kpi_version;	
	private String source_kpi;
	private String source_code;
	private String source_table;
	private String source_column;
	private String source_condition;
	private String source_type;
	private String source_name;
	private int source_version;
	public int getSource_version() {
		return source_version;
	}
	public void setSource_version(int source_version) {
		this.source_version = source_version;
	}
	public String getSource_name() {
		return source_name;
	}
	public void setSource_name(String source_name) {
		this.source_name = source_name;
	}
	public String getKpi_code() {
		return kpi_code;
	}
	public int getSource_key() {
		return source_key;
	}
	public void setSource_key(int source_key) {
		this.source_key = source_key;
	}
	public int getKpi_version() {
		return kpi_version;
	}
	public void setKpi_version(int kpi_version) {
		this.kpi_version = kpi_version;
	}
	public void setKpi_code(String kpi_code) {
		this.kpi_code = kpi_code;
	}
	public String getSource_kpi() {
		return source_kpi;
	}
	public void setSource_kpi(String source_kpi) {
		this.source_kpi = source_kpi;
	}
	public String getSource_code() {
		return source_code;
	}
	public void setSource_code(String source_code) {
		this.source_code = source_code;
	}
	public String getSource_table() {
		return source_table;
	}
	public void setSource_table(String source_table) {
		this.source_table = source_table;
	}
	public String getSource_column() {
		return source_column;
	}
	public void setSource_column(String source_column) {
		this.source_column = source_column;
	}
	public String getSource_condition() {
		return source_condition;
	}
	public void setSource_condition(String source_condition) {
		this.source_condition = source_condition;
	}
	public String getSource_type() {
		return source_type;
	}
	public void setSource_type(String source_type) {
		this.source_type = source_type;
	}
}
