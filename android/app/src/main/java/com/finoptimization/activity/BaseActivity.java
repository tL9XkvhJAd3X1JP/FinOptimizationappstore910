package com.finoptimization.activity;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.finoptimization.AppManager;
import com.finoptimization.R;
import com.finoptimization.network.NetworkDetector;
import com.finoptimization.utils.AppUtils;
import com.finoptimization.utils.ToastUtil;
import com.finoptimization.widget.WiesLinkInputDialog;

import butterknife.ButterKnife;
import library.systembartint.StatusBarUtil;

/**
 * 作者：WangJintao
 * 时间：2018/5/3
 * 邮箱：wangjintao1988@163.com
 */
public class BaseActivity extends AppCompatActivity implements View.OnClickListener {

    private ImageView leftImageView, rightImageView;
    private FrameLayout leftLayout, rightLayout;
    private TextView titleView;
    private ProgressDialog progressDialog;
    private TextView rightTextButton;
    private TextView leftTextButton;
    protected boolean isOnResumed;
    private boolean showTitle = true;


    @Override
    public void setContentView(int layoutResID) {
        View rootView = View.inflate(this, R.layout.activity_base, null);
        View rlTitle = rootView.findViewById(R.id.rl_title);
        if (!showTitle) {
            rlTitle.setVisibility(View.GONE);
        }
        ViewGroup.LayoutParams layoutParams = rlTitle.getLayoutParams();
        layoutParams.height = AppUtils.getTitleHeight();
        rlTitle.setLayoutParams(layoutParams);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            rlTitle.setPadding(0, AppUtils.getStatusBarHeight(), 0, 0);
        }
        leftImageView = rootView.findViewById(R.id.iv_left);
        leftLayout = rootView.findViewById(R.id.fl_left);
        leftLayout.setOnClickListener(this);
        rightImageView = rootView.findViewById(R.id.iv_right);
        rightLayout = rootView.findViewById(R.id.fl_right);
        titleView = rootView.findViewById(R.id.tv_title);
        rightTextButton = rootView.findViewById(R.id.btn_text_right);
        leftTextButton = rootView.findViewById(R.id.btn_text_left);
        FrameLayout contentView = rootView.findViewById(R.id.layout_content);
        View.inflate(this, layoutResID, contentView);
        super.setContentView(rootView);
        ButterKnife.bind(this);


        //设置状态栏透明
        StatusBarUtil.setTranslucentStatus(this);
    }

    public void setContentView(int layoutResID, boolean showTitle) {
        this.showTitle = showTitle;
        setContentView(layoutResID);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppManager.getAppManager().addActivity(this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        closeProgressDialog();
        AppManager.getAppManager().finishActivity(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.fl_left:
                finish();
                break;
        }
    }


    protected void setLeftImageView(int imgRes) {
        if (imgRes == -1) {
            leftLayout.setVisibility(View.GONE);
        } else {
            leftLayout.setVisibility(View.VISIBLE);
            leftImageView.setImageResource(imgRes);
        }
    }

    protected void setLeftView(View view) {
        if (view == null) {
            leftLayout.setVisibility(View.GONE);
        } else {
            leftLayout.setVisibility(View.VISIBLE);
            leftLayout.removeAllViews();
            leftLayout.addView(view);
        }
    }

    protected void setRightImageView(int imgRes) {
        if (imgRes == -1) {
            rightLayout.setVisibility(View.GONE);
        } else {
            rightLayout.setVisibility(View.VISIBLE);
            rightImageView.setImageResource(imgRes);
        }
    }

    protected void setTitle(String title) {
        titleView.setText(title);
    }

    protected void setTitle(String title, int color) {
        titleView.setText(title);
        titleView.setTextColor(ContextCompat.getColor(getApplicationContext(), color));
    }

    public void setTitle(int resid) {
        titleView.setText(getString(resid));
    }

    protected void toast(String msg) {
        ToastUtil.show(this, msg);
    }

    protected void showProgressDialog(String... hint) {
        if (!isFinishing()) {

            if (this.progressDialog == null) {
                this.progressDialog = new ProgressDialog(this);
            }
            this.progressDialog
                    .setMessage(hint != null && hint.length > 0 ? hint[0]
                            : "正在加载...");
            this.progressDialog.setCanceledOnTouchOutside(false);
            progressDialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
                @Override
                public void onCancel(DialogInterface dialog) {
                    progressDialogCanceled();
                }
            });
            this.progressDialog.show();

        }
    }

    protected void setProgressMessage(String message) {
        if (this.progressDialog != null && this.progressDialog.isShowing()) {
            this.progressDialog.setMessage(message);
        }
    }

    protected void closeProgressDialog() {
        if (this.progressDialog != null)
            this.progressDialog.dismiss();
    }

    protected void progressDialogCanceled() {

    }

    protected void setRightTextButton(String text) {
        if (TextUtils.isEmpty(text)) {
            rightTextButton.setVisibility(View.GONE);
        } else {
            rightTextButton.setVisibility(View.VISIBLE);
            rightTextButton.setText(text);
        }
    }

    protected void setLeftTextContent(String text) {
        if (TextUtils.isEmpty(text)) {
            leftTextButton.setVisibility(View.GONE);
        } else {
            leftTextButton.setText(text);
            leftTextButton.setVisibility(View.VISIBLE);
        }
    }

    /**
     * 显示输入dialog
     *
     * @param maxWords 允许输入的最大字符数
     * @param view     要显示的textview
     */
    protected void showInputDialog(int maxWords, TextView view) {
        showInputDialog(null, maxWords, view, "");
    }

    /**
     * 显示输入dialog
     *
     * @param title    dialog title
     * @param maxWords 允许输入的最大字符数
     * @param view     要显示的textview
     * @param message  默认文字
     */
    protected void showInputDialog(String title, int maxWords, TextView view, String message) {
        WiesLinkInputDialog dialog = new WiesLinkInputDialog(this, maxWords, view);
        dialog.setTitle(TextUtils.isEmpty(title) ? "请输入" : title);
        dialog.setDefaultText(message);
        dialog.show();
    }

    protected void showInputDialog(String title, TextView view, String message) {
        WiesLinkInputDialog dialog = new WiesLinkInputDialog(this, -1, view);
        dialog.setTitle(TextUtils.isEmpty(title) ? "请输入" : title);
        dialog.setDefaultText(message);
        dialog.show();
    }

    /**
     * 显示输入dialog
     *
     * @param maxWords 允许输入的最大字符数
     * @param view     要显示的textview
     * @param message  默认文字
     */
    protected void showInputDialog(int maxWords, TextView view, String message) {
        showInputDialog("请输入", maxWords, view, message);
    }


    protected boolean isNetworkAvailable() {
        if (!NetworkDetector.isNetworkAvailable()) {
            ToastUtil.show(getApplicationContext(), "请检查网络");
            return false;
        }
        return true;
    }

    protected boolean isNetworkAvailable(boolean prompt) {
        if (prompt) {
            return isNetworkAvailable();
        }
        return NetworkDetector.isNetworkAvailable();
    }

    @Override
    protected void onResume() {
        super.onResume();
        isOnResumed = true;
    }
}
