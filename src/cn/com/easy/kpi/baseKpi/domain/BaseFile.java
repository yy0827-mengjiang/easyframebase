package cn.com.easy.kpi.baseKpi.domain;

import java.io.InputStream;
import java.util.Date;

/**
 * Created by Administrator on 2016/2/16.
 */
public class BaseFile {
    private String id;
    private String code;
    private String fileName;
    private String filePath;
    private String type;
    private long fileSize;
    private Date updateTime;
    private InputStream source;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public InputStream getSource() {
        return source;
    }

    public void setSource(InputStream source) {
        this.source = source;
    }

    public long getFileSize() {
        return fileSize;
    }

    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }
}
