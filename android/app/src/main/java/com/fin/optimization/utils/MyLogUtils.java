package com.fin.optimization.utils;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.text.TextUtils;

import com.fin.optimization.MainApplication;
import com.fin.optimization.constant.Constants;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.OutputStreamWriter;
import java.util.Calendar;
import java.util.HashMap;
import java.util.concurrent.Executors;


/**
 * 作者：WangJintao
 * 时间：2017/1/17
 * 邮箱：wangjintao1988@163.com
 */

public class MyLogUtils {

    public static String readLogText() {
        try {
            // String fileName = "/sdcard/wsm.log";
            File file = new File(MainApplication.getApp().getFilesDir(), "wsm.log");// new
            // File(fileName);
            FileReader fr = null;
            if (!file.exists()) {
                return "";
            }

            long n = 100000;
            long len = file.length();
            long skip = len - n;
            fr = new FileReader(file);
            fr.skip(Math.max(0, skip));

            char[] cs = new char[(int) Math.min(len, n)];
            fr.read(cs);

            fr.close();

            return new String(cs).trim();
        } catch (Throwable ex) {
        }
        return "";
    }

    public static String saveCrashInfoToFile(Context ctx, String text) {
        try {
            String fileName = "upload.log";
            FileOutputStream trace = ctx.openFileOutput(fileName, Context.MODE_PRIVATE);
            OutputStreamWriter writer = new OutputStreamWriter(trace);

            writer.write("{UploadLog}");
            writer.write("\n");
            writer.write(text.trim());// substring(Math.max(0, text.length() -
            // 3998)).

            writer.flush();
            writer.close();
            // mDeviceCrashInfo.store(trace, "");
            trace.flush();
            trace.close();
            return fileName;
        } catch (Exception e) {

        }
        return null;
    }

    public static void uploadLog() {
        String curFileName = saveCrashInfoToFile(MainApplication.getApp(), readLogText() + collectCrashDeviceInfo());
        if (TextUtils.isEmpty(curFileName))
            return;

        File file = new File(MainApplication.getApp().getFilesDir(), curFileName);

        String idc = "FinOptimization";
        try {


            HashMap<String, String> binParams1 = new HashMap<String, String>();
            binParams1.put("idc", idc);
            binParams1.put("Type", "Android_");
            FileUploader binVersion = new FileUploader(Constants.UP_LOAD_LOG_URL, file.getAbsolutePath(), binParams1,
                    new FileUploader.FileUploadCallBack() {

                        @Override
                        public void onStart() {
                        }

                        @Override
                        public void onProgress(int proess) {

                        }

                        @Override
                        public void onUploadSuccess(String result) {

                            if ("1".equals(result)) {
                                ToastUtil.show(MainApplication.getApp(), "日志上传成功");
                            } else {
                                ToastUtil.show(MainApplication.getApp(), "日志上传失败");
                            }

                        }

                        @Override
                        public void onUploadError() {
                            ToastUtil.show(MainApplication.getApp(), "日志上传失败");
                        }
                    });
            binVersion.executeOnExecutor(Executors.newCachedThreadPool());

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    /**
     * 收集程序崩溃的设备信息
     */
    public static String collectCrashDeviceInfo() {
        try {
            PackageInfo pi = MainApplication.getApp().getPackageManager()
                    .getPackageInfo(MainApplication.getApp().getPackageName(), 0);
            StringBuilder sb = new StringBuilder("\r\n");

            sb.append(String.format("\r\n[%s/%s/A%s]", Build.MODEL, Build.VERSION.SDK, pi.versionName));
            Calendar cal = Calendar.getInstance();
            int year = cal.get(Calendar.YEAR);
            int month = cal.get(Calendar.MONTH) + 1;
            int day = cal.get(Calendar.DAY_OF_MONTH);
            int hour = cal.get(Calendar.HOUR_OF_DAY);
            int min = cal.get(Calendar.MINUTE);
            int sec = cal.get(Calendar.SECOND);
            sb.append("\r\nPhone Datetime:").append(
                    String.format("%d/%d/%d %d:%d:%d", year, month, day, hour, min, sec));

            return sb.toString();

        } catch (PackageManager.NameNotFoundException e) {
            return "";
        }

    }
}
