package com.fin.optimization.rnpackage;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.fin.optimization.rnmodle.AndroidDialog;
import com.fin.optimization.rnmodle.AndroidUtils;
import com.fin.optimization.rnmodle.SplashScreenModule;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.Nonnull;

/**
 * Created by Ryan on 2019/3/28.
 */
public class ReactNativePackage implements ReactPackage {

    @Nonnull
    @Override
    public List<NativeModule> createNativeModules(@Nonnull ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        modules.add(new AndroidDialog(reactContext)); //此处加入自定义模块
        modules.add(new AndroidUtils(reactContext));
        modules.add(new SplashScreenModule(reactContext));
        return modules;
    }

    @Nonnull
    @Override
    public List<ViewManager> createViewManagers(@Nonnull ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }
}
