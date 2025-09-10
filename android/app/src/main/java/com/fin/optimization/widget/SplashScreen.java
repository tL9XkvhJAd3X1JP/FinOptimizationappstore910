package com.fin.optimization.widget;

import android.app.Activity;
import android.app.Dialog;
import android.view.View;

import com.fin.optimization.R;
import com.fin.optimization.utils.GlideImgManager;

/**
 * Created by Ryan on 2019/4/25.
 */
public class SplashScreen {

    private int NULL_ID = 0;
    private Dialog mSplashDialog;
//    private static WeakReference<Activity> mActivity;

    /**
     * 打开启动屏
     */
    public Dialog show(final Activity activity, final boolean fullScreen, final int themeResId) {
        if (activity == null) return null;
//        mActivity = new WeakReference<Activity>(activity);
//        activity.runOnUiThread(new Runnable() {
//            @Override
//            public void run() {
        if (!activity.isFinishing()) {
            mSplashDialog = new Dialog(
                    activity,
                    themeResId != NULL_ID ? themeResId
                            : fullScreen ? R.style.SplashScreen_Fullscreen
                            : R.style.SplashScreen_SplashTheme

            );
            View view = View.inflate(activity, R.layout.activity_welcome, null);
            GlideImgManager.loadImage(activity, R.drawable.background_bg, view.findViewById(R.id.imv_bg));
            mSplashDialog.setContentView(view);
            mSplashDialog.setCancelable(false);
            if (!mSplashDialog.isShowing()) {
                mSplashDialog.show();
            }
        }
//    }
//        });
        return mSplashDialog;
    }

    /**
     * 打开启动屏
     */
    public Dialog show(final Activity activity, final boolean fullScreen) {
       return show(activity, fullScreen, 0);
    }

//    /**
//     * 打开启动屏
//     */
//    public static void show(final Activity activity) {
//        show(activity, false);
//    }
//
//    /**
//     * 关闭启动屏
//     */
//    public static void hide(Activity activity) {
//        if (activity == null) {
//            if (mActivity == null) {
//                return;
//            }
//            activity = mActivity.get();
//        }
//        if (activity == null) return;
//
//        activity.runOnUiThread(new Runnable() {
//            @Override
//            public void run() {
//                if (mSplashDialog != null && mSplashDialog.isShowing()) {
//                    mSplashDialog.dismiss();
//                    mSplashDialog = null;
//                }
//            }
//        });
//    }

}
