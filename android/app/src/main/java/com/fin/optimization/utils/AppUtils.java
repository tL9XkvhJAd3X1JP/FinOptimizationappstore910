package com.fin.optimization.utils;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Point;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import android.support.v4.content.FileProvider;
import android.text.InputFilter;
import android.text.Spanned;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import com.fin.optimization.MainApplication;
import com.fin.optimization.R;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import permissions.dispatcher.PermissionRequest;

public class AppUtils {

    private static String _ver = null;
    private static int titleHeight = 0;

    public static String getVersion(Context context) {
        if (_ver == null) {
            _ver = "1.0";
            try {
                PackageManager packageManager = context.getPackageManager();
                PackageInfo packInfo = packageManager.getPackageInfo(context.getPackageName(), 0);
                _ver = packInfo.versionName;
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }
        }

        return _ver;
    }

    public static int getVersionCode(Context context) {
        int code = 1;
        try {
            PackageManager packageManager = context.getPackageManager();
            PackageInfo packInfo = packageManager.getPackageInfo(context.getPackageName(), 0);
            code = packInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        return code;
    }

    public static String getVersionName(Context context) {
        String versionName = "1.0";
        try {
            PackageManager packageManager = context.getPackageManager();
            PackageInfo packInfo = packageManager.getPackageInfo(context.getPackageName(), 0);
            versionName = packInfo.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        return versionName;
    }

    /**
     * 是否需要加密
     *
     * @param httpUrl
     * @return
     */
    public static boolean isNeedEncode(String httpUrl) {
        boolean result = false;
        if (!TextUtils.isEmpty(httpUrl)) {
//            result = !httpUrl.contains(String.valueOf("CloudVerificationService"))
//                    && !httpUrl.contains(String.valueOf("CheckBoundDevice"))
//                    && !httpUrl.contains(String.valueOf("BoundDevice1"))
//                    && !httpUrl.contains(String.valueOf("https://"))
//                    && !httpUrl.contains(String.valueOf("baoyang"))
//                    && !httpUrl.contains(String.valueOf("getbaoyang"))
//                    && !httpUrl.contains(String.valueOf("UpdateEnable"))
//                    && !httpUrl.contains(String.valueOf("VehicleShareList"))
//                    && !httpUrl.contains(String.valueOf("ShareVehicle"))
//                    && !httpUrl.contains(String.valueOf("getSMSVerificationCode"));
        }
        return result;
    }

    /**
     * 拨打电话页面
     *
     * @param phoneNumber
     * @return
     */
    public static void startDialActivity(Context c, String phoneNumber) {
        try {
            Intent intent = new Intent();
            // 系统默认的action，用来打开默认的电话界面
            intent.setAction(Intent.ACTION_DIAL);
            // 需要拨打的号码

            if (!TextUtils.isEmpty(phoneNumber)) {
                intent.setData(Uri.parse("tel:" + phoneNumber));
                c.startActivity(intent);
            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                ToastUtil.show(c, "拨号失败，请手动拨打");
            } catch (Exception e1) {
                e1.printStackTrace();
            }

        }

    }


    /**
     * dip 转 px
     */
    public static int dip2px(Context context, float dpValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }

    /**
     * px 转 dip
     */
    public static int px2dip(Context context, float pxValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

    /**
     * 安装apk，用于软件更新
     *
     * @param filePath
     * @return
     */
    public static Intent installApk(String filePath) {
        Intent install = new Intent(Intent.ACTION_VIEW);
        if (Build.VERSION.SDK_INT >= 24) {//判读版本是否在7.0以上
            Uri apkUri = FileProvider.getUriForFile(MainApplication.getApp(), MainApplication.getApp().getPackageName() + ".fileprovider", new File(filePath));//在AndroidManifest中的android:authorities值
            install.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            install.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);//添加这一句表示对目标应用临时授权该Uri所代表的文件
            install.setDataAndType(apkUri, "application/vnd.android.package-archive");
        } else {
            install.setDataAndType(Uri.fromFile(new File(filePath)), "application/vnd.android.package-archive");
            install.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        }
        return install;
    }

    public static void hideSoft(Context context, View view) {
        if (view == null)
            return;
        InputMethodManager imm = (InputMethodManager) context
                .getSystemService(Context.INPUT_METHOD_SERVICE);
        // 隐藏软键盘
        imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
    }


    public static void showKeyboard(final EditText editText) {

        if (editText != null) {
            new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
                @Override
                public void run() {
                    //设置可获得焦点
                    editText.setFocusable(true);
                    editText.setFocusableInTouchMode(true);
                    //请求获得焦点
                    editText.requestFocus();
                    //调用系统输入法
                    InputMethodManager inputManager = (InputMethodManager) editText
                            .getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                    inputManager.showSoftInput(editText, 0);
                }
            }, 300);

        }
    }

    /**
     * 利用反射获取状态栏高度
     *
     * @return
     */
    public static int getStatusBarHeight() {
        int result = (int) Math.ceil(25 * MainApplication.getApp().getResources().getDisplayMetrics().density);
        //获取状态栏高度的资源id
        int resourceId = MainApplication.getApp().getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            result = MainApplication.getApp().getResources().getDimensionPixelSize(resourceId);
        }
        return result;
    }

    /**
     * 不包括虚拟按键
     *
     * @param context
     * @return
     */
    public static int[] getScreenSize(Activity context) {
        int[] size = new int[2];
        WindowManager manager = context.getWindowManager();
        DisplayMetrics outMetrics = new DisplayMetrics();
        manager.getDefaultDisplay().getMetrics(outMetrics);
        size[0] = outMetrics.widthPixels;
        size[1] = outMetrics.heightPixels;
        return size;
    }

    /**
     * 包括虚拟按键
     *
     * @return
     */
    public static int[] getScreenSize2() {
        int[] size = new int[2];
        WindowManager windowManager =
                (WindowManager) MainApplication.getApp().getSystemService(Context.
                        WINDOW_SERVICE);
        final Display display = windowManager.getDefaultDisplay();
        Point outPoint = new Point();
        if (Build.VERSION.SDK_INT >= 19) {
            // 可能有虚拟按键的情况
            display.getRealSize(outPoint);
        } else {
            // 不可能有虚拟按键
            display.getSize(outPoint);
        }
        int mRealSizeWidth;//手机屏幕真实宽度
        int mRealSizeHeight;//手机屏幕真实高度
        size[1] = outPoint.y;
        size[0] = outPoint.x;
        return size;
    }


    /**
     * 上次点击时间
     */
    private static long lastClickTime;
    private static long lastClickTime1;
    /**
     * 上次点击view id
     */
    private static long lastClickId;

    public static boolean isFastDoubleClick(int id) {
        long time = System.currentTimeMillis();
        long timeD = time - lastClickTime;
        if (lastClickId == id && (0 < timeD && timeD < 1000)) {
            return true;
        }
        lastClickId = id;
        lastClickTime = time;
        return false;
    }


    /**
     * @param
     * @return boolean
     * @Title: CommonUtil.java
     * @Description: 判断是否是手机号
     * @author wuyulong
     * @date 2014-7-14 下午6:01:35
     */
    public static boolean isValidMobiNumber(String paramString) {
        boolean isValidMobiNumber = false;
        String regex = "^1\\d{10}$";
        if (!TextUtils.isEmpty(paramString)) {
            Pattern pattern = Pattern.compile(regex);
            Matcher isMatcher = pattern.matcher(paramString);
            isValidMobiNumber = isMatcher.matches();
            return isValidMobiNumber;
        } else {
            return isValidMobiNumber;
        }
    }


    /**
     * 判断当前栈顶运行的activity
     *
     * @param context
     * @return
     */
    public static boolean isActivityRun(Context context, String name) {
        ActivityManager manager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningTaskInfo> runningTasks = manager.getRunningTasks(1);
        ActivityManager.RunningTaskInfo cinfo = runningTasks.get(0);
        ComponentName component = cinfo.topActivity;
        System.out.println("component.getClassName():" + component.getClassName());
        if (name.equals(component.getClassName())) {
            return true;
        }
        return false;
    }

    /**
     * 权限请求
     *
     * @param context
     * @param message
     * @param request
     */
    public static void showRequestPremissionDialog(final Activity context, String message, final PermissionRequest request) {
        showRequestPremissionDialog(context, message, request, true);
    }

    public static void showRequestPremissionDialog(final Activity context, String message, final PermissionRequest request, boolean isFinish) {
        new AlertDialog.Builder(context)
                .setTitle(context.getString(R.string.premission_request))
                .setCancelable(false)
                .setMessage(message)
                .setPositiveButton(context.getString(R.string.allow), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        request.proceed();
                    }
                })
                .setNegativeButton(context.getString(R.string.denied), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        request.cancel();
                        if (isFinish) {
                            context.finish();
                        }
                    }
                })
                .show();
    }

    /**
     * 权限请求
     *
     * @param context
     * @param message
     */
    public static void showRequestPremissionDialog(final Activity context, String message) {
        showRequestPremissionDialog(context, message, true);
    }

    public static void showRequestPremissionDialog(final Activity context, String message, boolean isFinish) {
        new AlertDialog.Builder(context)
                .setPositiveButton(context.getString(R.string.go_set), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //打开应用列表
                        AppUtils.openApplicationSettings(context);
                        if (isFinish) {
                            context.finish();
                        }
                    }
                })
                .setNegativeButton(context.getString(R.string.close), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        if (isFinish) {
                            context.finish();
                        }
                    }
                })
                .setCancelable(false)
                .setMessage(message)
                .show();
    }


    /**
     * 打开应用程序列表界面
     *
     * @param context
     */
    public static void openApplicationSettings(Context context) {
        try {
            Intent intent = new Intent(Settings.ACTION_APPLICATION_SETTINGS);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * 获取进程号对应的进程名
     *
     * @param pid 进程号
     * @return 进程名
     */
    public static String getProcessName(int pid) {
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader("/proc/" + pid + "/cmdline"));
            String processName = reader.readLine();
            if (!TextUtils.isEmpty(processName)) {
                processName = processName.trim();
            }
            return processName;
        } catch (Throwable throwable) {
            throwable.printStackTrace();
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException exception) {
                exception.printStackTrace();
            }
        }
        return null;
    }

    /**
     * 过滤中文
     *
     * @param v
     */
    public static void filterChinese(Activity activity, EditText v) {
        v.setFilters(new InputFilter[]{new InputFilter() {
            @Override
            public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {
                if (null != source && isChinese(source.toString())) {
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            ToastUtil.show(activity.getApplicationContext(), "不可输入中文");
                        }
                    });
                    return "";
                }
                return source;
            }
        }});
    }

    // 完整的判断中文汉字和符号
    @SuppressWarnings("unused")
    private static boolean isChinese(String strName) {
        char[] ch = strName.toCharArray();
        for (char c : ch) {
            if (isChinese(c)) {
                return true;
            }
        }
        return false;
    }

    // 根据Unicode编码完美的判断中文汉字和符号
    private static boolean isChinese(char c) {
        Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);
        return ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS
                || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS
                || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
                || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_B
                || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION
                || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS
                || ub == Character.UnicodeBlock.GENERAL_PUNCTUATION;
    }


    /**
     * 合并两数组
     *
     * @param org of type byte[] 原数组
     * @param to  合并一个byte[]
     * @return 合并的数据
     */

    public static byte[] append(byte[] org, byte[] to) {

        byte[] newByte = new byte[org.length + to.length];

        System.arraycopy(org, 0, newByte, 0, org.length);

        System.arraycopy(to, 0, newByte, org.length, to.length);

        return newByte;

    }

    /**
     * 获取title高度
     */
    public static int getTitleHeight() {
        if (titleHeight == 0) {
            int heightPixels = MainApplication.getApp().getResources().getDisplayMetrics().heightPixels;
            int defaultTitle = (int) (heightPixels / 10.0f);
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
                titleHeight = defaultTitle - AppUtils.getStatusBarHeight();
            } else {
                titleHeight = defaultTitle;
            }
        }
        return titleHeight;
    }
}

