package cn.com.easy.down.server;

import java.awt.Color;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Image;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfGState;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.PdfStamper;
import com.lowagie.text.pdf.PdfWriter;

public class PdfAddWaterMark {

	public void addImageMark(String srcFile, String destFile,String imgFile, int imgWidth,
			int imgHeight) throws IOException, DocumentException {
		PdfReader reader = new PdfReader(srcFile);
		PdfStamper stamper = new PdfStamper(reader, new FileOutputStream(
				destFile));

		int total = reader.getNumberOfPages() + 1;
		PdfContentByte content;
		Image image = null;
		if (!StringUtils.isBlank(imgFile)) {
			image = Image.getInstance(imgFile);
			image.setAbsolutePosition(imgWidth, imgHeight);
			image.scaleToFit(100, 125);
		}
		for (int i = 1; i < total; i++) {
			content = stamper.getOverContent(i);
			if (image != null) {
				content.addImage(image);
			}
		}
		stamper.close();
	}

	public void addTextMark(Map<String,String> info) throws IOException, DocumentException {
		PdfReader reader = new PdfReader(info.get("srcpdf"));
		PdfStamper stamper = new PdfStamper(reader, new FileOutputStream(info.get("destpdf")));
		stamper.setEncryption(null,null, PdfWriter.ALLOW_PRINTING, false); 
		int total = reader.getNumberOfPages()+1;
		PdfContentByte content;
		BaseFont font = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H",BaseFont.NOT_EMBEDDED);
		for (int i = 1; i < total; i++) {
			content = stamper.getUnderContent(i);
			String text = info.get("WaterMarkText");
			if (!StringUtils.isBlank(text)) {
				content.beginText();
				String color = info.get("WaterMarkColor");
				if(color.equals("green")){
					content.setColorFill(Color.GREEN);
				}else if(color.equals("black")){
					content.setColorFill(Color.BLACK);
				}else if(color.equals("gray")){
					content.setColorFill(Color.GRAY);
				}else if(color.equals("blue")){
					content.setColorFill(Color.BLUE);
				}else if(color.equals("red")){
					content.setColorFill(Color.RED);
				}else{
					content.setColorFill(Color.GRAY);
				}
				int fontsize = Integer.parseInt(info.get("WaterMarkFontSize"));
				content.setFontAndSize(font, fontsize);
				String position = info.get("WaterMarkPosition");
				if(position.equals("0")){
					float pageWidth = reader.getPageSize(i).getWidth();
					float pageHeight = reader.getPageSize(i).getHeight();
					content.setTextMatrix((pageWidth-fontsize*text.length())/2,pageHeight/2);
				}else if(position.contains(",")){
					String[] xyarr = position.split(",");
					content.setTextMatrix(Integer.parseInt(xyarr[0]), Integer.parseInt(xyarr[1]));
				}
				
				PdfGState gs = new PdfGState();
				gs.setFillOpacity(Float.parseFloat(info.get("WaterMarkOpacit")));
				content.setGState(gs);
				int rotate = Integer.parseInt(info.get("WaterMarkRotate"));
				if(position.equals("0")){
					float pageWidth = reader.getPageSize(i).getWidth();
					float pageHeight = reader.getPageSize(i).getHeight();
					content.showTextAligned(Element.ALIGN_LEFT, text, (pageWidth-fontsize*text.length())/2,pageHeight/2-50, rotate);
				}else if(position.equals("-1")){//-1是平铺
					float pageWidth = reader.getPageSize(i).getWidth();
					float pageHeight = reader.getPageSize(i).getHeight();
					int pageHeightNum = (int) pageHeight/100;//以100像素为单位计算纵向平铺的数量,
					int singleMarkWidth = (int) ((fontsize/2)*text.length()*Double.parseDouble(info.get("waterMarkSpacing")));//计算单个水印的宽度
					for(int m=0;m<pageWidth&&(pageWidth-singleMarkWidth)>singleMarkWidth/2;m+=singleMarkWidth){//按照水印宽度平铺水印
						for(int j=0;j<pageHeightNum;j++){
							content.showTextAligned(Element.ALIGN_LEFT, text, m+(fontsize/2),j*100, rotate);
						}
					}
				}else{
					String[] xyarr = position.split(",");
					int x =xyarr[0] ==null?400:Integer.parseInt(xyarr[0]);
					int y =xyarr[1] ==null?400:Integer.parseInt(xyarr[1]);
					content.showTextAligned(Element.ALIGN_LEFT, text,x,y, rotate);
				}
				content.endText();
			}
		}
		stamper.close();
	}
/*	public static void main(String[] args){
		PdfAddWaterMark ddd = new PdfAddWaterMark();
		Map<String,String> info = new HashMap<String,String>();
		
		info.put("srcpdf", "f:/01_201402201358510720.pdf_.pdf");
		info.put("destpdf", "f:/01_2014.pdf");
		info.put("PdfWaterMark", "true");
		info.put("WaterMarkText", "大幅度生顶顶");
		info.put("WaterMarkPosition","0");
		info.put("WaterMarkColor","gray");
		info.put("WaterMarkFontSize","40");
		info.put("WaterMarkRotate","45");
		info.put("WaterMarkOpacit","0.6f");
		try {
			ddd.addTextMark(info);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}*/
}