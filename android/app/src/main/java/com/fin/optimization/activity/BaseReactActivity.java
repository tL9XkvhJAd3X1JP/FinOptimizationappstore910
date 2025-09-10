package com.fin.optimization.activity;

import android.content.Intent;
import android.os.Bundle;

import com.facebook.react.ReactActivity;
import com.facebook.react.ReactActivityDelegate;
import com.fin.optimization.AppManager;
import com.fin.optimization.utils.AppStatusConstant;
import com.fin.optimization.utils.AppStatusManager;

import javax.annotation.Nullable;

import library.systembartint.StatusBarUtil;

/**
 * Created by Ryan on 2019/4/3.
 */
public class BaseReactActivity extends ReactActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppManager.getAppManager().addActivity(this);
        StatusBarUtil.setTranslucentStatus(this);
        switch (AppStatusManager.getInstance().getAppStatus()) {
            case AppStatusConstant.STATUS_FORCE_KILLED:
                restartApp();
                break;
        }
        //解决应用程序多次重启问题
        if ((getIntent().getFlags() & Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT) != 0) {
            finish();
            return;
        }
    }

    private void restartApp() {
        Intent intent = new Intent(this, LoadingReactActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        AppManager.getAppManager().finishActivity(this);
    }

    @Override
    protected ReactActivityDelegate createReactActivityDelegate() {
        return new ReactActivityDelegate(this, getMainComponentName()) {
            @Nullable
            @Override
            protected Bundle getLaunchOptions() {
                Bundle bundle = new Bundle();
                try {
                    Bundle extras = getIntent().getExtras();
                    bundle.putString("object", extras.getString("object"));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                return bundle;
            }
        };
    }


}
