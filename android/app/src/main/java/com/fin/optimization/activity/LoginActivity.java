package com.fin.optimization.activity;

import android.os.Bundle;

import com.fin.optimization.constant.Constants;

import javax.annotation.Nullable;

/**
 * Created by Ryan on 2019/3/23.
 */
public class LoginActivity extends BaseReactActivity {
    private static final String TAG = LoginActivity.class.getSimpleName();

//    private static final String TAG = LoginActivity.class.getSimpleName();
//    @BindView(R.id.et_phone)
//    EditText phoneView;
//    @BindView(R.id.et_pwd)
//    EditText pwdView;
//    @BindView(R.id.imv_bg)
//    ImageView imvBg;
//
//    @Override
//    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_login, false);
//        GlideImgManager.loadImage(this, R.drawable.bg_tie, imvBg);
//    }
//
//    @OnClick(R.id.btn_login)
//    void login() {
//        String phone = phoneView.getText().toString();
//        if (TextUtils.isEmpty(phone)) {
//            toast("请输入账号");
//            return;
//        }
//        String pwd = pwdView.getText().toString();
//        if (TextUtils.isEmpty(pwd)) {
//            toast("请输入密码");
//            return;
//        }
//        login(phone, pwd);
//    }
//
//    private void login(String phone, final String pwd) {
//        HashMap<String, String> params = new HashMap<>();
//        params.put(Constants.LoginInfo.LOGINNAME, phone);
//        params.put(Constants.LoginInfo.PASSWORD, FileMD5Helper.md5(pwd));
//        NetWorkAccess.getInstance().byPost(Constants.LoginInfo.LOGIN_INFO_API, UserBean.class, TAG, params, new NetWorkAccess.NetWorkAccessListener() {
//            @Override
//            public <T> void onAccessComplete(boolean success, T response, VolleyError error, String flag) {
//                closeProgressDialog();
//                if (success && response instanceof UserBean) {
//                    UserBean loginBean = (UserBean) response;
//                    if (TextUtils.equals(ErrorCode.SUCCESS, loginBean.getCode())) {
//                        handlerLoginData(loginBean.getData());
//                    } else {
//                        ToastUtil.show(getApplicationContext(), loginBean.getMessage());
//                    }
//                }
//            }
//        });
//
//    }
//
//    private void handlerLoginData(User data) {
//        if (data != null) {
//            saveData(data);
//            startActivity(new Intent(getApplicationContext(), MainActivity.class).putExtra("from", TAG));
//            finish();
//        } else {
//            ToastUtil.show(getApplicationContext(), "数据异常");
//        }
//    }
//
//    private void saveData(User data) {
//        UserData.getInstance().save(data);
//    }
//
//    @Override
//    protected void onDestroy() {
//        super.onDestroy();
//        progressDialogCanceled();
//
//    }
//
//    protected void progressDialogCanceled() {
//        NetWorkAccess.getInstance().cancel(TAG);
//    }
//
//    @OnLongClick(R.id.tv_login)
//    boolean upLoadLog() {
//        MyLogUtils.uploadLog();
//        return true;
//    }


    @Nullable
    @Override
    protected String getMainComponentName() {
        return Constants.ReactName.LOGIN;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            SplashScreen.show(this, true);//显示Dialog
//        }
        super.onCreate(savedInstanceState);
    }

}
