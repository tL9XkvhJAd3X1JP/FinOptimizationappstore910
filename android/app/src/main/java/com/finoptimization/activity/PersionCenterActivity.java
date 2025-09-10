package com.finoptimization.activity;

import com.facebook.react.ReactActivity;
import com.finoptimization.constant.Constants;

import javax.annotation.Nullable;

/**
 * Created by Ryan on 2019/3/27.
 */
public class PersionCenterActivity extends ReactActivity {

    @Nullable
    @Override
    protected String getMainComponentName() {
        return Constants.ReactName.PERSION_CENTER;
    }
}
