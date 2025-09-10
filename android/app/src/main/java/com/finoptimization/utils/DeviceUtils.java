package com.finoptimization.utils;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.IBinder;
import android.support.v4.app.ActivityCompat;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;

/**
 * 各种phone信息接口 例如 imei 手机型号，系统 ，分辨率等
 */
public class DeviceUtils {
    private static String imei;
    private static int verCode = -1;
    private static String channel;
    private static String mac;

    /**
     * 获取手机IMEI
     */
    @SuppressLint("MissingPermission")
    public static String getPhoneIMEI(Context context) {
        if (!TextUtils.isEmpty(imei)) {
            return imei;
        }
        String permission = Manifest.permission.READ_PHONE_STATE;
        if (ActivityCompat.checkSelfPermission(context, permission)
                == PackageManager.PERMISSION_GRANTED) {
            // Proceed with your code execution
            TelephonyManager tm = (TelephonyManager) context
                    .getSystemService(Context.TELEPHONY_SERVICE);
            imei = tm.getDeviceId().trim();

        } else {
            // Uhhh I guess we have to ask for permission
        }


        if (imei == null) {
            imei = "";
        }

        return imei;
    }

    /**
     * 获取当前程序版本数值
     *
     * @param context 上下文
     * @return 当前程序版本数值
     */
    public static int getCurrentAppVersionCode(Context context) {
        if (verCode != -1) {
            return verCode;
        }
        try {
            verCode = context.getPackageManager().getPackageInfo(
                    context.getPackageName(), 0).versionCode;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return verCode;
    }

    /**
     * 获取当前程序版本名
     *
     * @param context 上下文
     * @return 当前程序版本名
     */
    public static String getCurrentAppVersionName(Context context) {
        String versionName = "";
        try {
            versionName = context.getPackageManager().getPackageInfo(
                    context.getPackageName(), 0).versionName;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return versionName;
    }

    /**
     * 获取当前程序渠道
     *
     * @param context 上下文
     * @return 当前程序渠道
     */
    public static String getChannel(Context context) {
        if (TextUtils.isEmpty(channel)) {
            channel = getMetaData(context, "UMENG_CHANNEL");
            if (TextUtils.isEmpty(channel)) {
                channel = "SPI";
            }
        }
        return channel;

    }


    private static String getMetaData(Context context, String key) {
        try {
            ApplicationInfo ai = context.getPackageManager()
                    .getApplicationInfo(context.getPackageName(),
                            PackageManager.GET_META_DATA);
            Object value = ai.metaData.get(key);
            if (value != null) {
                return value.toString();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;

    }

    /**
     * 获取DisplayMetrics(获取屏幕信息)
     *
     * @param context
     * @return
     */
    public static DisplayMetrics getDisplayMetrics(Context context) {
        // 这个可以用于1.5
        DisplayMetrics dm = new DisplayMetrics();
        WindowManager wm = (WindowManager) context
                .getSystemService(Context.WINDOW_SERVICE);
        wm.getDefaultDisplay().getMetrics(dm);
        return dm;
    }

    /**
     * 根据手机的分辨率从 dp 的单位 转成为 px(像素)
     */
    public static int dip2px(Context context, int dpValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }

    /**
     * 根据手机的分辨率从 px(像素) 的单位 转成为 dp
     */
    public static int px2dip(Context context, int pxValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

    /**
     * 获取手机型号
     *
     * @return
     */
    public static String getModel() {
        return android.os.Build.MODEL;
    }

    /**
     * 隐藏软键盘
     *
     * @param activity
     */
    public static void hideSoftInput(Activity activity) {
        try {
            if (activity == null || activity.getCurrentFocus() == null) {
                return;
            }
            IBinder binder = activity.getCurrentFocus().getWindowToken();
            if (binder == null) {
                return;
            }
            ((InputMethodManager) activity
                    .getSystemService(Context.INPUT_METHOD_SERVICE))
                    .hideSoftInputFromWindow(binder,
                            InputMethodManager.HIDE_NOT_ALWAYS);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
