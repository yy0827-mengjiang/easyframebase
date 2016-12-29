package cn.com.easy.xbuilder.utils;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.zip.CRC32;
import java.util.zip.CheckedOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

public class ZipUtil {
  
	static final int BUFFER = 8192;  
	  
    public static void compress(OutputStream os,String srcPathName) {  
        File file = new File(srcPathName);  
        if (!file.exists())  
            throw new RuntimeException(srcPathName + "不存在！");  
        try {  
            CheckedOutputStream cos = new CheckedOutputStream(os, new CRC32());  
            ZipOutputStream out = new ZipOutputStream(cos);  
            String basedir = "";  
            compress(file, out, basedir);  
            out.close();  
        } catch (Exception e) {  
            throw new RuntimeException(e);  
        }  
    }  
  
    private static void compress(File file, ZipOutputStream out, String basedir) {  
        /* 判断是目录还是文件 */  
        if (file.isDirectory()) {  
            compressDirectory(file, out, basedir);  
        }else{  
        	compressFile(file, out, basedir);
        }  
    }  
  
    private static void compressDirectory(File dir, ZipOutputStream out, String basedir) {  
        if(!dir.exists()){  
        	return;
        }  
        File[] files = dir.listFiles();  
        for (int i = 0; i < files.length; i++) {  
            /* 递归 */  
            compress(files[i], out, basedir + dir.getName() + "/");  
        }  
    }  
  
    private static void compressFile(File file, ZipOutputStream out, String basedir) {  
        if(!file.exists()){  
        	return;
        }  
        try {  
            BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file));  
            ZipEntry entry = new ZipEntry(basedir + file.getName());  
            out.putNextEntry(entry);  
            int count = 0;  
            byte data[] = new byte[BUFFER];  
            while ((count = bis.read(data, 0, BUFFER)) != -1) {  
                out.write(data, 0, count);  
            }  
            bis.close();  
        } catch (Exception e) {  
            throw new RuntimeException(e);  
        }  
    }
    /**
     * 解压ZIP文件
     * @param sourceDirZipFileName ZIP文件路径与名称
     * @param targetDir 解压到存放的路径  不包括文件名
     * @throws ZipException
     * @throws IOException
     */
    public static void zipInputStream(String sourceDirZipFileName,
			String targetDir) throws ZipException, IOException {
		File file = new File(sourceDirZipFileName);
		ZipFile zipFile = new ZipFile(file);
		ZipInputStream zipInputStream = new ZipInputStream(new FileInputStream(file));
		ZipEntry zipEntry = null;
		while ((zipEntry = zipInputStream.getNextEntry()) != null) {
			String fileName = zipEntry.getName();
			File temp = new File(targetDir + "/" +fileName);
			if (!temp.getParentFile().exists())
				temp.getParentFile().mkdirs();
			OutputStream os = new FileOutputStream(temp);
			// 通过ZipFile的getInputStream方法拿到具体的ZipEntry的输入流
			InputStream is = zipFile.getInputStream(zipEntry);
			int len = 0;
			while ((len = is.read()) != -1)
				os.write(len);
			os.close();
			is.close();
		}
		zipInputStream.close();
	}
	
	public static void main(String[] args) throws IOException {
		
	}
}
