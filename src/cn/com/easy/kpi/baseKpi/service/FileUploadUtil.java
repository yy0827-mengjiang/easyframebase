package cn.com.easy.kpi.baseKpi.service;

import cn.com.easy.kpi.baseKpi.domain.BaseFile;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.*;

/**
 * Created by Administrator on 2016/2/4.
 */
public class FileUploadUtil {
    private FileItem item;
    private static String path=FileUploadUtil.class.getResource("/").getPath();
    private String propertiesPath = path+"framework.properties";
    public  boolean fileUpload(HttpServletRequest request,Map parameter) throws Exception {
        //Map parameterMap=new HashMap();
        //boolean isMultipart= ServletFileUpload.isMultipartContent(request);
        //if(!isMultipart)
        boolean flag=false;
        DiskFileItemFactory factory=new DiskFileItemFactory();
        ServletContext servletContext=request.getSession().getServletContext();
        File repository= (File) servletContext.getAttribute("javax.servlet.context.tempdir");
        factory.setRepository(repository);
        ServletFileUpload upload=new ServletFileUpload(factory);
        List<FileItem> items=upload.parseRequest(request);
        Iterator<FileItem> iter=items.iterator();
        while (iter.hasNext()){
            FileItem item=iter.next();
            if(item.isFormField()){
                String name=item.getFieldName();
                String value=item.getString("UTF-8");
                parameter.put(name,value);
            }else {
                this.item=item;
            }
        }
            //String filedName=this.item.getFieldName();
            String fileName=this.item.getName();
            //String upload_file_name="";
            //String upload_file_dir="";
            if(fileName!=null&&fileName!="") {
                flag=true;
                // String contentType=item.getContentType();
               // String direction = servletContext.getRealPath("/") + "baseKpiDesc";
                long sizeInBytes=item.getSize();
                Map map=this.fileOperate();
                File file = new File(path+map.get("FilePath"));
                if (!file.exists()) {
                    file.mkdirs();
                }
                int length = fileName.length();
                int lastIndex = fileName.lastIndexOf(".");
                String extName = fileName.substring(lastIndex + 1, length);
                if (!extName.toLowerCase().matches("xls|doc|jnt|docx|xlsx|ppt|pptx|txt")) {
                    flag=false;
                }
                String FileKPILanding=map.get("FileKPILanding").toString();
                String uniqueFileName = fileName.substring(0, lastIndex) + "-" + parameter.get("base_key") + "." + extName;
                File uploadedFile = new File(file, uniqueFileName);
                BaseFile baseFile=new BaseFile();
                baseFile.setCode(parameter.get("base_key").toString());
                baseFile.setFileName(fileName);
                baseFile.setFileSize(sizeInBytes);
                baseFile.setType(parameter.get("baseType").toString());
                baseFile.setSource(this.item.getInputStream());
                baseFile.setFilePath(uploadedFile.getAbsolutePath());
                baseFile.setId(parameter.get("base_key").toString());
                BaseKpiService baseKpiService=new BaseKpiService();
                if(FileKPILanding.equals("1")){
                    if(!uploadedFile.exists()){
                        item.write(uploadedFile);
                    }
                    //upload_file_name=fileName;
                    //upload_file_dir=uploadedFile.getAbsolutePath();
                }
                if(!parameter.get("isPublish").equals("true"))
                    baseKpiService.file2DB(baseFile,parameter.get("operation").toString(),FileKPILanding);
                else
                    baseKpiService.file2DB(baseFile,"insert",FileKPILanding);
            }
        //parameter.put("upload_file_name",upload_file_name);
        //parameter.put("upload_file_dir",upload_file_dir);
        return flag;
    }

    private Map fileOperate(){
        Map map=new HashMap();
        Properties properties=new Properties();
        FileInputStream fileInputStream=null;
        try{
        fileInputStream=new FileInputStream(this.propertiesPath);
            properties.load(fileInputStream);
            map.put("FileKPILanding",properties.getProperty("FileKPILanding"));
            map.put("FilePath",properties.getProperty("FilePath"));
        }catch (IOException e){
            e.printStackTrace();
        }
        return map;
    }
}
