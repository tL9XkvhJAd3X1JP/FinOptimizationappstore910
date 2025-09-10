package com.finoptimization.rnmodle;

import android.app.Activity;
import android.text.InputType;
import android.view.View;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.finoptimization.R;
import com.finoptimization.constant.Constants;
import com.finoptimization.widget.WiseLinkDialog;

import javax.annotation.Nonnull;

/**
 * Created by Ryan on 2019/4/1.
 */
public class AndroidDialog extends ReactContextBaseJavaModule implements LifecycleEventListener {

    private WiseLinkDialog mModifyPwdDialog;

    public AndroidDialog(@Nonnull ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addLifecycleEventListener(this);
    }

    @Nonnull
    @Override
    public String getName() {
        return Constants.ReactName.ANDROID_DIALOG;
    }

    @ReactMethod
    public void showModifyPwdDialog(Callback successCallback, Callback errorCallback) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            initModifyPwdDialog(successCallback, errorCallback);
        } else {
            errorCallback.invoke();
        }

    }

    private void initModifyPwdDialog(Callback successCallback, Callback errorCallback) {
        mModifyPwdDialog = new WiseLinkDialog(getCurrentActivity());
        mModifyPwdDialog.setTitle("修改密码");
        View contentView = View.inflate(getCurrentActivity(), R.layout.view_modify_pwd, null);
        EditText lastPwd = contentView.findViewById(R.id.et_last_pwd);
        EditText newPwd = contentView.findViewById(R.id.et_new_pwd);
        CheckBox showPwd = contentView.findViewById(R.id.btn_show_pwd);

        showPwd.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    newPwd.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
                } else {
                    newPwd.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
                }
                newPwd.setSelection(newPwd.length());
            }
        });

        mModifyPwdDialog.setView(contentView);
        mModifyPwdDialog.setOkButton1("提交", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    successCallback.invoke(newPwd.getText().toString().trim());
                } catch (Exception e) {
                    errorCallback.invoke();
                }
            }
        });
        mModifyPwdDialog.show();
    }

    @Override
    public void onHostResume() {

    }

    @Override
    public void onHostPause() {

    }

    @Override
    public void onHostDestroy() {
        dissmissDialog();
    }

    private void dissmissDialog() {
        if (mModifyPwdDialog != null && mModifyPwdDialog.isShowing()) {
            mModifyPwdDialog.dismiss();
            mModifyPwdDialog = null;
        }
    }
}
