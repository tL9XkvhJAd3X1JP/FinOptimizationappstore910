package com.finoptimization.rnmodle;

import android.app.Activity;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.finoptimization.constant.Constants;

import javax.annotation.Nonnull;

/**
 * Created by Ryan on 2019/3/28.
 */
public class AndroidUtils extends ReactContextBaseJavaModule {

    public AndroidUtils(@Nonnull ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Nonnull
    @Override
    public String getName() {
        return Constants.ReactName.ANDROID_UTILS;
    }

    @ReactMethod
    public void finishActivity() {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            currentActivity.finish();
        }
    }
}
