package com.fin.optimization.activity;

import android.Manifest;
import android.app.ActivityOptions;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.util.Pair;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;

import com.fin.optimization.AppManager;
import com.fin.optimization.R;
import com.fin.optimization.bean.ResourceBean;
import com.fin.optimization.data.UrlData;
import com.fin.optimization.network.NetWorkAccess;
import com.fin.optimization.utils.AppUtils;
import com.fin.optimization.utils.GlideImgManager;
import com.fin.optimization.widget.DownLoadDialog;
import com.fin.optimization.widget.WiseLinkDialog;

import butterknife.BindView;
import library.systembartint.StatusBarUtil;
import permissions.dispatcher.NeedsPermission;
import permissions.dispatcher.OnNeverAskAgain;
import permissions.dispatcher.OnPermissionDenied;
import permissions.dispatcher.OnShowRationale;
import permissions.dispatcher.PermissionRequest;
import permissions.dispatcher.RuntimePermissions;

/**
 * 作者：WangJintao
 * 时间：2018/5/14
 * 邮箱：wangjintao1988@163.com
 */
@RuntimePermissions
public class WelcomeActivity extends AppCompatActivity implements DownLoadDialog.DownloadRightClick {

    private static final String TAG = WelcomeActivity.class.getSimpleName();
    private static Handler mHandler = new Handler();

    @BindView(R.id.imv_bg)
    ImageView imageView;

    private boolean clickToUpgrade;
    private ResourceBean.DataBean resourceData;
    private View view;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

//        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
        Window window = getWindow();
        //隐藏标题栏
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        //隐藏状态栏
        //定义全屏参数
        int flag = WindowManager.LayoutParams.FLAG_FULLSCREEN;
        //设置当前窗体为全屏显示
        window.setFlags(flag, flag);
//        }
        view = View.inflate(this, R.layout.activity_welcome, null);
        GlideImgManager.loadImage(this, R.drawable.background_bg, view.findViewById(R.id.imv_bg));
        setContentView(view);
        StatusBarUtil.setTranslucentStatus(this);

        AppManager.getAppManager().addActivity(this);


//        if (!NetworkDetector.isNetworkAvailable()) {
//            ToastUtil.show(getApplicationContext(), "请检查网络");
//            mHandler.postDelayed(new Runnable() {
//                @Override
//                public void run() {
//                    finish();
//                }
//            }, 1000);
//            return;
//        }

//        HashMap<String, String> params = new HashMap<>();
//        params.put(Constants.GetVersionPar.CLIENTTYPE, "1");
//        params.put(Constants.GetVersionPar.CUSTOMER_FLAG, Constants.CUSTOMER_FLAG);
//        NetWorkAccess.getInstance().byPost(Constants.GetVersionPar.GET_VERSION_API, ResourceBean.class, TAG, params, new NetWorkAccess.NetWorkAccessListener() {
//            @Override
//            public <T> void onAccessComplete(boolean success, T response, VolleyError error, String flag) {
//                if (success && response instanceof ResourceBean) {
//                    ResourceBean resourceBean = (ResourceBean) response;
//                    if (ErrorCode.SUCCESS.equals(resourceBean.getCode())) {
//                        isUpdate(resourceBean);
//                    } else {
//                        ToastUtil.show(getApplicationContext(), "数据异常");
//                        finish();
//                    }
//                }else{
//                    finish();
//                }
//            }
//        });

        requestPermission();
    }

    private void startCountDown() {
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                judgeLogin();
            }
        }, 1500);
    }

    private void requestPermission() {
        WelcomeActivityPermissionsDispatcher.requestStoragePermissionWithPermissionCheck(this);
    }

    private void isUpdate(ResourceBean resourceBean) {
        ResourceBean.DataBean dataEntity = resourceBean.getData();
        if (dataEntity == null) {
            showUpdateErrDialog("系统繁忙，请稍候再试");
        } else {
//            int code = -1;
//            try {
//                code = getApplication().getPackageManager().getPackageInfo(getApplication().getPackageName(), 0).versionCode;
//            } catch (PackageManager.NameNotFoundException e) {
//                e.printStackTrace();
//            }
            saveUrl(dataEntity);
//            if (Integer.parseInt(dataEntity.getVersionCode()) > code) {
//                showUpdateDialog(dataEntity);
//            } else {
            requestPermission();
//            }
        }
    }

    private void saveUrl(ResourceBean.DataBean dataEntity) {
        UrlData.getInstance().saveUrl(dataEntity);
    }

    private void showUpdateDialog(ResourceBean.DataBean dataEntity) {
        boolean isForce = dataEntity.getIsForced() == 1;
        String baseUrl = dataEntity.getBusinessInterfaceAddress();
        String baseUrlSSL = dataEntity.getBusinessInterfaceAddress_ssl();
        if (TextUtils.isEmpty(baseUrl) || TextUtils.isEmpty(baseUrlSSL)) {
            isForce = true;
        }
        String version = "版本号：" + dataEntity.getVersionName();
        String content = TextUtils.isEmpty(dataEntity.getInstruction()) ? null
                : ("更新内容：\n" + dataEntity.getInstruction());
        try {
            final boolean finalIsForce = isForce;
            WiseLinkDialog wiseLinkDialog = new WiseLinkDialog(WelcomeActivity.this);
            wiseLinkDialog.setTitle("升级提示");
            wiseLinkDialog.setMessage(version + "\n" + content);
            wiseLinkDialog.setCanDismissByKeyBack(false);
            wiseLinkDialog.setOkButton("升级", new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    wiseLinkDialog.dismiss();
                    clickToUpgrade = true;
                    resourceData = dataEntity;
                    requestPermission();
                }
            });
            wiseLinkDialog.setCancleButton(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    wiseLinkDialog.dismiss();
                    if (finalIsForce) {
                        finish();
                    } else {
                        requestPermission();
                    }
                }
            });
            wiseLinkDialog.setCanceledOnTouchOutside(false);
            wiseLinkDialog.show();
        } catch (Exception e) {

        }
    }

    private void showUpdateErrDialog(String message) {
        WiseLinkDialog wiseLinkDialog = new WiseLinkDialog(WelcomeActivity.this);
        wiseLinkDialog.setMessage(message);
        wiseLinkDialog.setOkButton(message, new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });
        wiseLinkDialog.setCanDismissByKeyBack(false);
        wiseLinkDialog.setCanceledOnTouchOutside(false);
        wiseLinkDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                if (!WelcomeActivity.this.isFinishing()) {
                    finish();
                }
            }
        });
        wiseLinkDialog.show();
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        AppManager.getAppManager().finishActivity(this);
        NetWorkAccess.getInstance().cancel(TAG);
        mHandler.removeCallbacksAndMessages(null);
    }

    private void judgeLogin() {
        Intent intent = null;
//        if (new MyPreferenceManager().getLoginState()) {
//            intent = new Intent(getApplicationContext(), MainActivity.class);
//        } else {
//            intent = new Intent(getApplicationContext(), LoginActivity.class);
//        }
        intent = new Intent(getApplicationContext(), LoadingReactActivity.class);
//        intent.putExtra("object", new Gson().toJson(UrlData.getInstance().getUrl()));
//        intent.putExtra("from", WelcomeActivity.class.getSimpleName());

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            startActivity(intent, ActivityOptions.makeSceneTransitionAnimation(this,
                    Pair.create(view.findViewById(R.id.imv_bg), "image"))
                    .toBundle());
        } else {
            startActivity(intent);
        }

//        finish();
    }


    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    /**
     * 用户操作权限的结果
     *
     * @param requestCode
     * @param permissions
     * @param grantResults
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        WelcomeActivityPermissionsDispatcher.onRequestPermissionsResult(this, requestCode, grantResults);
    }

    @NeedsPermission({Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_PHONE_STATE})
    public void requestStoragePermission() {
        if (clickToUpgrade) {
            DownLoadDialog mDialog = new DownLoadDialog(WelcomeActivity.this, resourceData);
            mDialog.setmDownloadRightClick(this);
            mDialog.show();
        } else {
            startCountDown();
        }
    }

    @OnShowRationale({Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_PHONE_STATE})
    void showRationaleForStorage(PermissionRequest request) {
//        if (clickToUpgrade) {
//            if (!this.isFinishing()) {
//                AppUtils.showRequestPremissionDialog(this, getString(R.string.request_permission_storage), request);
//            }
//        } else {
        request.proceed();
//        }
    }

    @OnPermissionDenied({Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_PHONE_STATE})
    void showDeniedForStorage() {
//        if (clickToUpgrade) {
        finish();
//        } else {
//            startCountDown();
//        }
    }

    @OnNeverAskAgain({Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_PHONE_STATE})
    void showNeverAskForStorage() {
//        if (clickToUpgrade) {
//            if (!isFinishing()) {
        AppUtils.showRequestPremissionDialog(this, getString(R.string.request_permission_all));
//            }
//        } else {
//            startCountDown();
//        }
    }

    @Override
    public void onRightClick(boolean isForce) {
        if (isForce) {
            finish();
        } else {
            startCountDown();
        }
    }
}
