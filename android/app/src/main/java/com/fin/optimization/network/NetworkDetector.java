package com.fin.optimization.network;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import com.fin.optimization.MainApplication;

public class NetworkDetector {

    /**
     * 检测当前网络是否可用
     * <p>
     * Current Activity
     *
     * @return true : 可用 <br>
     * false : 不可用
     */
    public static boolean isNetworkAvailable() {

        ConnectivityManager manager = (ConnectivityManager) MainApplication.getApp().getApplicationContext().getSystemService(
                Context.CONNECTIVITY_SERVICE);

        if (null == manager) {
            return false;
        }
        NetworkInfo networkInfo = manager.getActiveNetworkInfo();
        if (null == networkInfo || !networkInfo.isAvailable()) {
            return false;
        }

        return true;
    }

}
