package cn.com.easy.down.server.export;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.batik.transcoder.TranscoderInput;
import org.apache.batik.transcoder.TranscoderOutput;
import org.apache.batik.transcoder.image.PNGTranscoder;

public class PngChartBySvgCode implements Strategy {

	@Override
	public String export(ArgsBean args) throws Exception {
		String outputFilePath =args.getDownPath() + args.getUuid() + ".png";
		FileOutputStream outputStream = null;
		ByteArrayInputStream inputStream=null;
		try {
			File file = new File(outputFilePath);
			outputStream = new FileOutputStream(file);
			byte[] bytes = args.getSvgCode().getBytes("UTF-8");
			inputStream=new ByteArrayInputStream(bytes);
			PNGTranscoder t = new PNGTranscoder();
			TranscoderInput input = new TranscoderInput(inputStream);
			TranscoderOutput output = new TranscoderOutput(outputStream);
			t.transcode(input, output);
			outputStream.flush();
		}finally {
			if (outputStream != null) {
				try {
					outputStream.close();
				} catch (IOException e) {
					System.err.println("createPngChartBySvgCode:关闭输出流出错！");
					e.printStackTrace();
				}
			}
			if(inputStream!=null){
				try {
					inputStream.close();
				} catch (IOException e) {
					System.err.println("createPngChartBySvgCode:关闭输入流出错！");
					e.printStackTrace();
				}
			}
		}
		return outputFilePath;
	}
}