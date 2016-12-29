package cn.com.easy.kpi.util;

import java.sql.Timestamp;


@LogAnnotation(tableName = "X_KPI_LOG")
public class LogInfo {

	@LogAnnotation(colnum = "LOG_KEY")
	private int logKey;
	@LogAnnotation(colnum = "KPI_KEY")
	private int kpiKey;
	@LogAnnotation(colnum = "KPI_CODE")
	private String kpiCode;
	@LogAnnotation(colnum = "KPI_VERSION")
	private int kpiVersion;
	@LogAnnotation(colnum = "LOG_ACTION")
	private String logAction;
	@LogAnnotation(colnum = "LOG_DETAIL_BEFORE")
	private String logDetatlBef;
	@LogAnnotation(colnum = "LOG_DETAIL_AFTER")
	private String logDetatlAft;
	@LogAnnotation(colnum = "LOG_DATETIME")
	private Timestamp logDateTime;
	@LogAnnotation(colnum = "LOG_USER")
	private String logUser;
	@LogAnnotation(colnum = "LOG_USERID")
	private String logUserId;
	@LogAnnotation(colnum = "LOG_IP")
	private String logIp;

	public int getLogKey() {
		return logKey;
	}

	public void setLogKey(int logKey) {
		this.logKey = logKey;
	}

	public int getKpiKey() {
		return kpiKey;
	}

	public void setKpiKey(int kpiKey) {
		this.kpiKey = kpiKey;
	}

	public String getKpiCode() {
		return kpiCode;
	}

	public void setKpiCode(String kpiCode) {
		this.kpiCode = kpiCode;
	}

	public int getKpiVersion() {
		return kpiVersion;
	}

	public void setKpiVersion(int kpiVersion) {
		this.kpiVersion = kpiVersion;
	}

	public String getLogAction() {
		return logAction;
	}

	public void setLogAction(String logAction) {
		this.logAction = logAction;
	}

	public String getLogDetatlBef() {
		return logDetatlBef;
	}

	public void setLogDetatlBef(String logDetatlBef) {
		this.logDetatlBef = logDetatlBef;
	}

	public String getLogDetatlAft() {
		return logDetatlAft;
	}

	public void setLogDetatlAft(String logDetatlAft) {
		this.logDetatlAft = logDetatlAft;
	}

	public Timestamp getLogDateTime() {
		return logDateTime;
	}

	public void setLogDateTime(Timestamp logDateTime) {
		this.logDateTime = logDateTime;
	}

	public String getLogUser() {
		return logUser;
	}

	public void setLogUser(String logUser) {
		this.logUser = logUser;
	}

	public String getLogUserId() {
		return logUserId;
	}

	public void setLogUserId(String logUserId) {
		this.logUserId = logUserId;
	}

	public String getLogIp() {
		return logIp;
	}

	public void setLogIp(String logIp) {
		this.logIp = logIp;
	}

}
