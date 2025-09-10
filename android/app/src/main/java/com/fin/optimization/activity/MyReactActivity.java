package com.fin.optimization.activity;

import com.fin.optimization.MainApplication;

import javax.annotation.Nullable;

/**
 * Created by Ryan on 2019/4/13.
 */
public class MyReactActivity extends BaseReactActivity {


    @Nullable
    @Override
    protected String getMainComponentName() {
        return MainApplication.getApp().getReactModuleName();
    }
}
