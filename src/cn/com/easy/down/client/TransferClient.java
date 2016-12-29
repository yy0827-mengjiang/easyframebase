package cn.com.easy.down.client;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
      
    /**
     * 下载中心，socket客户端 
     *
     */
    public class TransferClient {  
    	private static ExecutorService executorService; 
    	private static String SERVER_IP ;//远程服务端IP
    	private static int SERVER_PORT ;//远程服务端端口号
    	@SuppressWarnings("unchecked")
		private Map paramMap;//要传递给服务端的参数Map
    	
    	/**
    	 * 构造方法
    	 * @param ip
    	 * @param port
    	 */
    	public TransferClient(String ip,int port){  
        	SERVER_IP = ip;
        	SERVER_PORT = port;
        }
    	
        /**
         * 构造方法
         * @param ip
         * @param port
         * @param paramMap
         */
    	@SuppressWarnings("unchecked")
		public TransferClient(String ip,int port,Map paramMap){  
        	SERVER_IP = ip;
        	SERVER_PORT = port;
        	setParamMap(paramMap);
        }
    	
        
        /**
         * 执行发送参数的线程
         */
        public void service(){  
            Runnable runnable = sendParameter(getParamMap());
            if(executorService == null){
    			executorService = Executors.newCachedThreadPool();//缓冲线程池
    		}
            executorService.execute(runnable);
        }  
        
        /**
         * 发送参数到服务端
         * @param paramJson
         * @return
         */
        @SuppressWarnings("unchecked")
		private static Runnable sendParameter(final Map paramMap){  
            return new Runnable(){  
                private Socket socket = null;  
                private String ip =  TransferClient.SERVER_IP;
                private int port = TransferClient.SERVER_PORT;  
				public void run() {  
                    if(createConnection()){  
                        try {  
                        	DataOutputStream out = new DataOutputStream(socket.getOutputStream());
                        	
                        	//首先将Map对象转为字节数组
                        	ByteArrayOutputStream bo = new ByteArrayOutputStream();  
                            ObjectOutputStream oo = new ObjectOutputStream(bo);  
                            oo.writeObject(paramMap);  
                            byte[] paramBytes = bo.toByteArray(); 
                            //System.out.println("参数字节长度为:"+bo.toByteArray().length);
                            bo.close();
                            oo.close();
                            
                        	//发送字节数组总长度
            				out.writeInt(paramBytes.length);
        					out.flush();
        					
        					//发送字节数组
                        	ByteArrayInputStream is = new ByteArrayInputStream(paramBytes);
        					byte[] sendBytes = new byte[1024];
            				int length = 0;
            				while ((length = is.read(sendBytes, 0, sendBytes.length)) > 0) {
            					out.write(sendBytes, 0, length);
            					out.flush();
            				}
            				out.close();
                            socket.close();  
                        } catch (Exception e) {  
                            e.printStackTrace();  
                        }  
                    }  
                }  
                  
                private boolean createConnection() {  
                    try {  
                        socket = new Socket(ip, port);  
                        System.out.println("连接服务器成功！");
                        return true;  
                    } catch (Exception e) {
                    	System.out.println("连接服务器失败！");
                    	e.printStackTrace();
                        return false;  
                    }   
                }  
                  
            };  
        }  
          
        public static void main(String[] args){  
            //new TransferClient("localhost",10000).service();  
        }

		public Map getParamMap() {
			return paramMap;
		}


		public void setParamMap(Map paramMap) {
			this.paramMap = paramMap;
		}  
    }

