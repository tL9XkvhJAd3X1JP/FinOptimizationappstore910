package com.fin.optimization.activity;

import android.app.Dialog;
import android.os.Bundle;

import com.fin.optimization.constant.Constants;
import com.fin.optimization.utils.AppStatusConstant;
import com.fin.optimization.utils.AppStatusManager;
import com.fin.optimization.widget.SplashScreen;

import javax.annotation.Nullable;

/**
 * Created by Ryan on 2019/3/23.
 */
public class LoadingReactActivity extends BaseReactActivity {

    private Dialog dialog;

    @Nullable
    @Override
    protected String getMainComponentName() {
        return Constants.ReactName.LOADING_REACT;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        //显示Dialog
        dialog = new SplashScreen().show(this, true);
//        }
        AppStatusManager.getInstance().setAppStatus(AppStatusConstant.STATUS_NORMAL);
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onDestroy() {
        if (dialog != null) {
            dialog.dismiss();
        }
        super.onDestroy();
    }
}
