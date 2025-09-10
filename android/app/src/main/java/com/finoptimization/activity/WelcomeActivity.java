package com.finoptimization.activity;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;

import com.android.volley.VolleyError;
import com.finoptimization.MainActivity;
import com.finoptimization.R;
import com.finoptimization.bean.ResourceBean;
import com.finoptimization.bean.User;
import com.finoptimization.constant.Constants;
import com.finoptimization.constant.ErrorCode;
import com.finoptimization.data.UrlData;
import com.finoptimization.data.UserData;
import com.finoptimization.network.NetWorkAccess;
import com.finoptimization.network.NetworkDetector;
import com.finoptimization.utils.AppUtils;
import com.finoptimization.utils.GlideImgManager;
import com.finoptimization.utils.ToastUtil;
import com.finoptimization.widget.DownLoadDialog;
import com.finoptimization.widget.WiseLinkDialog;

import java.util.HashMap;

import butterknife.BindView;
import butterknife.ButterKnife;
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

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
            Window window = getWindow();
            //隐藏标题栏
            requestWindowFeature(Window.FEATURE_NO_TITLE);
            //隐藏状态栏
            //定义全屏参数
            int flag = WindowManager.LayoutParams.FLAG_FULLSCREEN;
            //设置当前窗体为全屏显示
            window.setFlags(flag, flag);
        }
        setContentView(R.layout.activity_welcome);
        StatusBarUtil.setTranslucentStatus(this);
        ButterKnife.bind(this);
        GlideImgManager.loadImage(this, R.drawable.background_bg, imageView);


        if (!NetworkDetector.isNetworkAvailable()) {
            ToastUtil.show(getApplicationContext(), "请检查网络");
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    finish();
                }
            }, 1000);
            return;
        }

        HashMap<String, String> params = new HashMap<>();
        params.put(Constants.GetVersionPar.CLIENTTYPE, "1");
        params.put(Constants.GetVersionPar.CUSTOMER_FLAG, Constants.CUSTOMER_FLAG);
        NetWorkAccess.getInstance().byStreamPost(Constants.GetVersionPar.GET_VERSION_API, ResourceBean.class, TAG, params, new NetWorkAccess.NetWorkAccessListener() {
            @Override
            public <T> void onAccessComplete(boolean success, T response, VolleyError error, String flag) {
                if (success && response instanceof ResourceBean) {
                    ResourceBean resourceBean = (ResourceBean) response;
                    if (ErrorCode.SUCCESS.equals(resourceBean.getCode())) {
                        isUpdate(resourceBean);
                    } else {
                        ToastUtil.show(getApplicationContext(), "数据异常");
                    }
                }
            }
        });
    }

    private void startCountDown() {
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                judgeLogin();
            }
        }, 2500);
    }

    private void requestPermission() {
        WelcomeActivityPermissionsDispatcher.requestStoragePermissionWithPermissionCheck(this);
    }

    private void isUpdate(ResourceBean resourceBean) {
        ResourceBean.DataBean dataEntity = resourceBean.getData();
        if (dataEntity == null) {
            showUpdateErrDialog("系统繁忙，请稍候再试");
        } else {
            int code = -1;
            try {
                code = getApplication().getPackageManager().getPackageInfo(getApplication().getPackageName(), 0).versionCode;
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }
            saveUrl(dataEntity);
            if (Integer.parseInt(dataEntity.getVersionCode()) > code) {
                showUpdateDialog(dataEntity);
            } else {
                requestPermission();
            }
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
                finish();
            }
        });
        wiseLinkDialog.show();
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        NetWorkAccess.getInstance().cancel(TAG);
        mHandler.removeCallbacksAndMessages(null);
    }

    private void judgeLogin() {
        User user = UserData.getInstance().getUser();
        if (user == null) {
            startActivity(new Intent(this, LoginActivity.class));
        } else {
            startActivity(new Intent(this, MainActivity.class));
        }
        finish();
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

    @NeedsPermission({Manifest.permission.WRITE_EXTERNAL_STORAGE})
    public void requestStoragePermission() {
        if (clickToUpgrade) {
            DownLoadDialog mDialog = new DownLoadDialog(WelcomeActivity.this, resourceData);
            mDialog.setmDownloadRightClick(this);
            mDialog.show();
        } else {
            startCountDown();
        }
    }

    @OnShowRationale({Manifest.permission.WRITE_EXTERNAL_STORAGE})
    void showRationaleForStorage(PermissionRequest request) {
        if (clickToUpgrade) {
            if (!this.isFinishing()) {
                AppUtils.showRequestPremissionDialog(this, getString(R.string.request_permission_storage), request);
            }
        } else {
            request.proceed();
        }
    }

    @OnPermissionDenied({Manifest.permission.WRITE_EXTERNAL_STORAGE})
    void showDeniedForStorage() {
        if (clickToUpgrade) {
            finish();
        } else {
            startCountDown();
        }
    }

    @OnNeverAskAgain({Manifest.permission.WRITE_EXTERNAL_STORAGE})
    void showNeverAskForStorage() {
        if (clickToUpgrade) {
            if (!isFinishing()) {
                AppUtils.showRequestPremissionDialog(this, getString(R.string.request_permission_storage));
            }
        } else {
            startCountDown();
        }
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
