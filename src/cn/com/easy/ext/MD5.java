package cn.com.easy.ext;

import java.security.MessageDigest;

/**
 * <p>Description: 加密为hex或MD5</p>
 * @author chenfuquan
 */

public class MD5 {
  public MD5() {}

  public static String byte2hex(byte[] b) {
    String hs = "";
    String stmp = "";
    for (int n = 0; n < b.length; n++) {
      stmp = (java.lang.Integer.toHexString(b[n] & 0XFF));
      if (stmp.length() == 1)
        hs = hs + "0" + stmp;
      else
        hs = hs + stmp;
    }
   // System.out.println("--------" + hs.toUpperCase());
    return hs.toUpperCase();
  }

  public static String MD5Crypt(String s) {
    try {
      byte[] strTemp = s.getBytes();
     // System.out.println("--------" + s);
      MessageDigest mdTemp = MessageDigest.getInstance("MD5");
      mdTemp.update(strTemp);
      byte[] md = mdTemp.digest();
      return byte2hex(md);
    }
    catch (Exception e) {
      return null;
    }
  }

  public static void main(String[] args) {
    MD5 test = new MD5();
    System.out.print(test.MD5Crypt("1q2w3e"));
  }
}