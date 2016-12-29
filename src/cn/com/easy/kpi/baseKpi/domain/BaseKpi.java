package cn.com.easy.kpi.baseKpi.domain;
import java.util.Date;
import java.util.List;

public class BaseKpi {
    private String id;
    private String base_key;
    private String kpi_version;
    private String kpi_name;
    private String kpi_unit;
    private String kpi_unit_name;
    private String kpi_origin_schema;
    private String kpi_origin_table;
    private String kpi_origin_column;
    private String kpi_origin_regular;
    private String kpi_explain;
    private String kpi_proposer;
    private String kpi_proposer_dept;
    private String kpi_state;
    private String kpi_origin_desc;
    private String kpi_origin_stc;
    private String baseType;
    private String create_user_id;
    private String create_time;
    private String edit_user_id;
    private String edit_time;
    private String upload_file_name;
    private String upload_file_dir;
    private String kpi_eds;
    private String kpi_category;
    private String account_type;
    private String cube_code;
    private String kpi_code;

    public String getKpi_code() {
		return kpi_code;
	}

	public void setKpi_code(String kpi_code) {
		this.kpi_code = kpi_code;
	}

	public String getAccount_type() {
        return account_type;
    }

    public void setAccount_type(String account_type) {
        this.account_type = account_type;
    }

    public String getKpi_category() {
		return kpi_category;
	}

	public void setKpi_category(String kpi_category) {
		this.kpi_category = kpi_category;
	}

	public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getKpi_eds() {
        return kpi_eds;
    }

    public void setKpi_eds(String kpi_eds) {
        this.kpi_eds = kpi_eds;
    }

    public String getCreate_user_id() {
        return create_user_id;
    }

    public void setCreate_user_id(String create_user_id) {
        this.create_user_id = create_user_id;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public String getEdit_user_id() {
        return edit_user_id;
    }

    public void setEdit_user_id(String edit_user_id) {
        this.edit_user_id = edit_user_id;
    }

    public String getEdit_time() {
        return edit_time;
    }

    public void setEdit_time(String edit_time) {
        this.edit_time = edit_time;
    }

    public String getBaseType() {
        return baseType;
    }

    public void setBaseType(String baseType) {
        this.baseType = baseType;
    }

    public String getUpload_file_name() {
        return upload_file_name;
    }

    public void setUpload_file_name(String upload_file_name) {
        this.upload_file_name = upload_file_name;
    }

    public String getUpload_file_dir() {
        return upload_file_dir;
    }

    public void setUpload_file_dir(String upload_file_dir) {
        this.upload_file_dir = upload_file_dir;
    }

    public String getKpi_origin_stc() {
        return kpi_origin_stc;
    }

    public void setKpi_origin_stc(String kpi_origin_stc) {
        this.kpi_origin_stc = kpi_origin_stc;
    }

    public String getBase_key() {
        return base_key;
    }

    public void setBase_key(String base_key) {
        this.base_key = base_key;
    }

    public String getKpi_version() {
        return kpi_version;
    }

    public void setKpi_version(String kpi_version) {
        this.kpi_version = kpi_version;
    }

    public String getKpi_name() {
        return kpi_name;
    }

    public void setKpi_name(String kpi_name) {
        this.kpi_name = kpi_name;
    }

    public String getKpi_unit() {
        return kpi_unit;
    }

    public void setKpi_unit(String kpi_unit) {
        this.kpi_unit = kpi_unit;
    }

    public String getKpi_origin_schema() {
        return kpi_origin_schema;
    }

    public void setKpi_origin_schema(String kpi_origin_schema) {
        this.kpi_origin_schema = kpi_origin_schema;
    }

    public String getKpi_origin_table() {
        return kpi_origin_table;
    }

    public void setKpi_origin_table(String kpi_origin_table) {
        this.kpi_origin_table = kpi_origin_table;
    }

    public String getKpi_origin_column() {
        return kpi_origin_column;
    }

    public void setKpi_origin_column(String kpi_origin_column) {
        this.kpi_origin_column = kpi_origin_column;
    }

    public String getKpi_origin_regular() {
        return kpi_origin_regular;
    }

    public void setKpi_origin_regular(String kpi_origin_regular) {
        this.kpi_origin_regular = kpi_origin_regular;
    }

    public String getKpi_explain() {
        return kpi_explain;
    }

    public void setKpi_explain(String kpi_explain) {
        this.kpi_explain = kpi_explain;
    }

    public String getKpi_proposer() {
        return kpi_proposer;
    }

    public void setKpi_proposer(String kpi_proposer) {
        this.kpi_proposer = kpi_proposer;
    }

    public String getKpi_proposer_dept() {
        return kpi_proposer_dept;
    }

    public void setKpi_proposer_dept(String kpi_proposer_dept) {
        this.kpi_proposer_dept = kpi_proposer_dept;
    }

    public String getKpi_state() {
        return kpi_state;
    }

    public void setKpi_state(String kpi_state) {
        this.kpi_state = kpi_state;
    }

    public String getKpi_origin_desc() {
        return kpi_origin_desc;
    }

    public void setKpi_origin_desc(String kpi_origin_desc) {
        this.kpi_origin_desc = kpi_origin_desc;
    }

    public String getCube_code() {
		return cube_code;
	}

	public void setCube_code(String cube_code) {
		this.cube_code = cube_code;
	}

	public String getKpi_unit_name() {
		return kpi_unit_name;
	}

	public void setKpi_unit_name(String kpi_unit_name) {
		this.kpi_unit_name = kpi_unit_name;
	}

	private StringBuilder commonSql(){
        StringBuilder stringBuilder=new StringBuilder();
        stringBuilder.append(this.getKpi_name()+",");
        stringBuilder.append(this.getKpi_unit()+",");
        stringBuilder.append(this.getKpi_origin_schema()+",");
        stringBuilder.append(this.getKpi_origin_table()+",");
        stringBuilder.append(this.getKpi_origin_column()+",");
        stringBuilder.append(this.getKpi_origin_regular()+",");
        stringBuilder.append(this.getKpi_explain()+",");
        stringBuilder.append(this.getKpi_proposer()+",");
        stringBuilder.append(this.getKpi_proposer_dept()+",");
        stringBuilder.append(this.getKpi_state()+",");
        stringBuilder.append(this.getKpi_origin_desc()+",");
        stringBuilder.append(this.getAccount_type()+",");
        stringBuilder.append(this.getCube_code());
        return stringBuilder;
    }
    public Object[] insertSql(){
        StringBuilder stringBuilder=new StringBuilder();
        stringBuilder.append(this.getBase_key()+",");
        stringBuilder.append(this.getKpi_version()+",");
        stringBuilder.append(this.commonSql());
       return stringBuilder.toString().split(",");
    }
    public Object[] updateSql(){
        return this.commonSql().append(","+this.getBase_key()).toString().split("");
    }
}
