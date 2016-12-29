package cn.com.easy.down.server;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.ObjectInputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import cn.com.easy.annotation.Component;
import cn.com.easy.core.sql.SqlRunner;

@Component
public class TransferServer {  
      
        private int tryBindTimes = 0;            //初始的绑定端口的次数设定为0  
        private ServerSocket serverSocket;       //服务套接字 
        private ExecutorService executorService; //线程池  
        private final int POOL_SIZE = 4;         //单个CPU的线程池大小   
        private static SqlRunner runner;
		public TransferServer(){}
		/** 
         * 带参数的构造器，选用用户指定的端口号 
         * @param port 
         * @throws Exception 
         */  
        public TransferServer(int port) throws Exception{  
            try {
            	tryBindTimes = 0 ;
                this.bindToServerPort(port);  
                executorService = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors() * POOL_SIZE);  
                System.out.println("开辟线程数:"+Runtime.getRuntime().availableProcessors() * POOL_SIZE);
            } catch (Exception e) {  
                throw new Exception("绑定端口不成功!");  
            }  
        }  
        
        /**
         * 绑定服务端端口
         * @param port
         * @throws Exception
         */
        private void bindToServerPort(int port) throws Exception{  
            try {  
                serverSocket = new ServerSocket(port);  
                System.out.println("服务启动，绑定的端口号:"+port); 
            } catch (Exception e) {  
                this.tryBindTimes = this.tryBindTimes + 1;  
                port = port + this.tryBindTimes;  
                if(this.tryBindTimes >= 20){  
                	String errMsg = "您已经尝试很多次了，但是仍无法绑定到指定的端口!请重新选择绑定的默认端口号";
                	System.out.println(errMsg); 
                    throw new Exception(errMsg);  
                }else{
                    this.bindToServerPort(port);//递归绑定端口  
                }
            }  
        }  
        
        /**
         * 监听客户端方法
         */
        public void service(){  
            Socket socket = null;  
            while (true) {  
                try {  
                    socket = serverSocket.accept();  
                    executorService.execute(new Handler(socket,runner));//执行导出线程  
                } catch (Exception e) {  
                    e.printStackTrace();  
                }  
            }  
        }  
          
        /**
         * 导出文件线程
         *
         */
        class Handler implements Runnable{  
            private Socket socket;  
            public Handler(Socket socket,SqlRunner runner){  
                this.socket = socket;  
            }  
            @SuppressWarnings({ "unchecked", "deprecation" })
			public void run() {  
            	try{
            		  DataInputStream dis = new DataInputStream(socket.getInputStream());
            		  byte[] sendBytes = new byte[1024];
            		  int totalLength = dis.readInt();
            		  byte[] fullParamBytes = new byte[totalLength];
            		  int index = 0;
            		  int read = 0;
            		  while (true) {
  						read = dis.read(sendBytes);
  						if (read == -1)
  							break;
  						for(int i=0;i<read;i++){
  							fullParamBytes[index++]=sendBytes[i];
  						}
  					  }
            		  //字节数组转为object对象
            		  ByteArrayInputStream bi = new ByteArrayInputStream(fullParamBytes);  
            		  ObjectInputStream oi = new ObjectInputStream(bi);  
            		  Object paramObj = oi.readObject();  
            		  bi.close();
            		  oi.close();
            		  dis.close();
            		  socket.close();
            		  
//            		  String fullParamStr = Functions.java2json(paramObj);
//            		  System.out.println("完整参数为--->"+fullParamStr);
            		  //添加在服务端获取的参数
            		  Map paramMap = (Map)paramObj;
            		  paramMap = TransferServer.addExtParams(paramMap);
            		  Date currentDate=new Date();
            		  SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
            		  if ((DownQueue.lastExcuteDateStr != null) && (!sdf.format(currentDate).equals(DownQueue.lastExcuteDateStr))) {
            			  int step=2;
            			  List<Map<String, String>> exportMapList=(List<Map<String, String>> )runner.queryForMapList("SELECT ID,FILE_PATH FROM E_EXPORTING_INFO T WHERE TO_CHAR(T.OPT_TIME+"+step+",'YYYYMMDD')<='"+sdf.format(currentDate)+"'");
            			  for(Map<String, String> tempMap:exportMapList){
            				  if(tempMap.get("FILE_PATH")==null){
            					  continue;
            				  }
            				  File tempFile=new File(tempMap.get("FILE_PATH"));
            				  if(tempFile!=null&&(tempFile.isFile())&&tempFile.exists()){
            					  tempFile.delete();
            				  }
            			  }
            			  runner.execute("DELETE FROM E_EXPORTING_INFO T WHERE TO_CHAR(T.OPT_TIME+"+step+",'YYYYMMDD')<='"+sdf.format(currentDate)+"'");
        		      }
        		      DownQueue.lastExcuteDateStr = sdf.format(currentDate);


            		  String action = String.valueOf(paramMap.get("action"));
        			  if("export".equals(action)){//导出
        				  String fileType=String.valueOf(paramMap.get("fileType"));
        				  if("excel".equals(fileType.toLowerCase().trim())){
        					  fileType="excel";
        					  
        				  }else if("pdf".equals(fileType.toLowerCase().trim())){
        					  fileType="pdf";
        				  }else if("image/png".equals(fileType.toLowerCase().trim())){
        					  fileType="png";
        				  }else if("image/jpeg".equals(fileType.toLowerCase().trim())){
        					  fileType="jpg";
        				  }else if("application/pdf".equals(fileType.toLowerCase().trim())){
        					  fileType="pdf";
        				  }else if("application/vnd.ms-excel".equals(fileType.toLowerCase().trim())){
        					  fileType="excel";
        				  }
        				  DownLog.getInstance((SqlRunner)paramMap.get("runner")).log(String.valueOf(paramMap.get("id")), "1", String.valueOf(paramMap.get("fileName")),fileType,  String.valueOf(paramMap.get("userId")),String.valueOf(paramMap.get("downParams")), String.valueOf(paramMap.get("systemFlag")));
        				  DownQueue.enterQueue(paramMap);
        				  DownQueue.saveQueueToDatabase(null,runner);
        				  cn.com.easy.down.server.DownController.getInstance().tryGenerateFile();
        			  }else if("cancel".equals(action)){//取消导出任务
        				  cn.com.easy.down.server.DownController.getInstance().stopGenerateFile(paramMap.get("id")+"",runner);
        			  }else if("delete".equals(action)){//先取消再删除
        				  cn.com.easy.down.server.DownController.getInstance().deleteFile(paramMap.get("id")+"",runner);
        			  }
            	}catch(Exception e){
            		e.printStackTrace();
            	}
            }  
        }  
        
        @SuppressWarnings({ "unchecked"})
		private static Map addExtParams(Map paramMap){
        	paramMap.put("downPath", TransferServer.class.getClassLoader().getResource("/").getPath().replace("WEB-INF/classes/","")+"pages/download/");
            paramMap.put("runner", runner);
            return paramMap;
        }
        
        public static void main(String[] args) throws Exception{  
            new TransferServer(10000).service();  
        }  
    }  

