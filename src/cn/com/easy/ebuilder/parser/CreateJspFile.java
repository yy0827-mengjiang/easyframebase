/********************************************************************************
 * Copy Right Information	: 东方国信
 * Project					: 页面管控平台
 * JDK Version Used        	: 1.6.24
 * Comments         	    : 生成文件与读取文件
 * Version                  ：1.0.1
 * Sr.		Date		Author				Why and What is Modified
 * 1.	2013.4.2		周晓龙				初始化
 ********************************************************************************/
package cn.com.easy.ebuilder.parser;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.ebuilder.sync.Clusters;
import cn.com.easy.ebuilder.sync.SyncSend;

public class CreateJspFile {
	private static SqlRunner runner;
	private static HttpServletRequest request;
	public CreateJspFile(SqlRunner db,HttpServletRequest request){
		this.runner = db;
		this.request = request;
	}
	/**
	 * 
	 * @param oldfilename
	 *            原文件名，包含径与扩展名
	 * @param newfilename
	 *            新文件名，包含径与扩展名
	 * @return
	 */
	public static boolean fileRename(String oldfilename, String newfilename) {
		File file = new File(oldfilename);
		if (file.exists()) {
			File filenew = new File(newfilename);
			if(filenew.exists())
				filenew.delete();
			file.renameTo(new File(newfilename));
			System.out.println("文件更名成功！");
		} else {
			System.err.println("更名文件不存在！");
			return false;
		}
		return true;
	}
	/**
	 * 
	 * @param pathfile
	 *            文件地址 
	 * @param filename
	 *            文件名称
	 * @param content
	 *            文件内容
	 * @return 是否成功
	 * @throws IOException
	 */
	public static boolean createfile(String pathfile,String filename, String content)
			throws IOException {
		try{
			File file = new File(pathfile);
			file.mkdir();
			file = new File(pathfile+filename);
			if (file.exists())
				file.delete();
			FileOutputStream fos = new FileOutputStream(pathfile+filename);
			String PageJspContent = content;
			if (PageJspContent != null && !PageJspContent.equals("")) {
				fos.write(PageJspContent.getBytes("UTF-8"));
				fos.close();
			} else {
				fos.close();
				return false;
			}
			return true;
		}finally{
			if (content != null && !content.equals("")) {
				 List<Map<String, String>> clusters = Clusters.cls.getClusters(runner);
				 if(clusters != null && clusters.size()>0){
					Thread tch = new Thread(new SyncSend(pathfile,filename,content,clusters,runner,request));
					tch.start();
				 }
			}
		}
	}
	 /**
	  * 读取文本文件
	  * @param fileName 文件路径+文件名称
	  * @return 文件内容
	  */
    public static String readFile(String fileName) {
    	StringBuffer pagesrc = new StringBuffer();
        File file = new File(fileName);
        Reader reader = null;
        try {
            char[] tempchars = new char[30];
            int charread = 0;
            reader = new InputStreamReader(new FileInputStream(fileName),"UTF-8");
            while ((charread = reader.read(tempchars)) != -1) {
                if ((charread == tempchars.length)
                        && (tempchars[tempchars.length - 1] != '\r')) {
                	pagesrc.append(tempchars);
                } else {
                    for (int i = 0; i < charread; i++) {
                        if (tempchars[i] == '\r') {
                            continue;
                        } else {
                        	pagesrc.append(tempchars[i]);
                        }
                    }
                }
            }
        } catch (Exception e1) {
            e1.printStackTrace();
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e1) {
                }
            }
        }
        return pagesrc.toString();
    }
    /**
     * 删除指定文件夹下所有文件
     * @param path 文件夹完整绝对路径
     */
	public static boolean delAllFile(String path) {
		boolean flag = false;
		File file = new File(path);
		if (!file.exists()) {
			return true;
		}
		if (!file.isDirectory()) {
			return true;
		}
		String[] tempList = file.list();
		File temp = null;
		for (int i = 0; i < tempList.length; i++) {
			if (path.endsWith(File.separator)) {
				temp = new File(path + tempList[i]);
			} else {
				temp = new File(path + File.separator + tempList[i]);
			}
			if (temp.isFile()) {
				temp.delete();
			}
			if (temp.isDirectory()) {
				delAllFile(path + "/" + tempList[i]);//先删除文件夹里面的文件
				delFolder(path + "/" + tempList[i]);//再删除空文件夹
				flag = true;
			}
		}
		return flag;
	}
	/**
     * 删除空文件夹
     * @param folderPath 文件夹完整绝对路径
     */
	public static void delFolder(String folderPath) {
		try {
			delAllFile(folderPath); //删除完里面所有内容
			String filePath = folderPath;
			filePath = filePath.toString();
			java.io.File myFilePath = new java.io.File(filePath);
			myFilePath.delete(); //删除空文件夹
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 复制文件
	 * @param  源目录
	 * @param tsoleargeFiletFile 目标目录
	 * @throws IOException
	 */
	public static boolean copyFile(File sourceFile, File targetFile) throws IOException {
		boolean rs = false;
        BufferedInputStream inBuff = null;
        BufferedOutputStream outBuff = null;
        try {
            // 新建文件输入流并对它进行缓冲
            inBuff = new BufferedInputStream(new FileInputStream(sourceFile));

            // 新建文件输出流并对它进行缓冲
            outBuff = new BufferedOutputStream(new FileOutputStream(targetFile));

            // 缓冲数组
            byte[] b = new byte[1024 * 5];
            int len;
            while ((len = inBuff.read(b)) != -1) {
                outBuff.write(b, 0, len);
            }
            // 刷新此缓冲的输出流
            outBuff.flush();
            rs = true;
        } catch (Exception e) {
        	rs = false;
			e.printStackTrace();
		} finally {
            // 关闭流
            if (inBuff != null)
                inBuff.close();
            if (outBuff != null)
                outBuff.close();
        }
		return rs;
    }
/**
 * 复制文件夹
 * @param sourceDir 原目录
 * @param targetDir 目标目录
 * @throws IOException
 */
    public static boolean copyDirectiory(String sourceDir, String targetDir) throws IOException {
    	boolean rs = false;
    	try {
	        // 新建目标目录
	        (new File(targetDir)).mkdirs();
	        // 获取源文件夹当前下的文件或目录
	        File[] file = (new File(sourceDir)).listFiles();
	        for (int i = 0; i < file.length; i++) {
	            if (file[i].isFile() && !file[i].isHidden()) {
	                // 源文件
	                File sourceFile = file[i];
	                // 目标文件
	                File targetFile = new File(new File(targetDir).getAbsolutePath() + File.separator + file[i].getName());
	                copyFile(sourceFile, targetFile);
	            }
	            if (file[i].isDirectory()) {
	                // 准备复制的源文件夹
	                String dir1 = sourceDir + "/" + file[i].getName();
	                // 准备复制的目标文件夹
	                String dir2 = targetDir + "/" + file[i].getName();
	                copyDirectiory(dir1, dir2);
	            }
	        }
	        rs = true;
    	} catch (Exception e) {
			e.printStackTrace();
		}
        return rs;
    }
    /**
     * 文件GBK转码
     * @param srcFileName
     * @param destFileName
     * @param srcCoding
     * @param destCoding
     * @throws IOException
     */
    public void copyFile(File srcFileName, File destFileName, String srcCoding, String destCoding) throws IOException {
        BufferedReader br = null;
        BufferedWriter bw = null;
        try {
            br = new BufferedReader(new InputStreamReader(new FileInputStream(srcFileName), srcCoding));
            bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(destFileName), destCoding));
            char[] cbuf = new char[1024 * 5];
            int len = cbuf.length;
            int off = 0;
            int ret = 0;
            while ((ret = br.read(cbuf, off, len)) > 0) {
                off += ret;
                len -= ret;
            }
            bw.write(cbuf, 0, off);
            bw.flush();
        } finally {
            if (br != null)
                br.close();
            if (bw != null)
                bw.close();
        }
    }
    
/*    public  static void main(String[] args) throws IOException{
    	//System.out.println(readFile("E:\\MyProject\\localnet\\WebRoot\\pages\\ebuilder\\usepage\\formal\\R201304090939347503608\\Source_R201304090939347503608.sre"));
    	 // 源文件夹
        String url1 = "E:/MyProject/easyframework/WebRoot/pages/ebuilder/usepage/formal/R2013080211334163035397/";
        // 目标文件夹
        String url2 = "E:/MyProject/easyframework/WebRoot/pages/ebuilder/usepage/backup/R2013080211334163035397/";
        // 创建目标文件夹
        copyDirectiory(url1,url2);
        System.out.println("end");  
      }*/
}