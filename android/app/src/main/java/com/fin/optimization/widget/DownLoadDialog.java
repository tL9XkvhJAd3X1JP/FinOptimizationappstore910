package com.fin.optimization.widget;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.fin.optimization.AppManager;
import com.fin.optimization.MainApplication;
import com.fin.optimization.R;
import com.fin.optimization.bean.ResourceBean;
import com.fin.optimization.utils.FileUtils;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.callback.FileCallback;
import com.lzy.okgo.model.Progress;

import java.io.File;

/**
 * Created by yangwei on 2015/12/21.
 */
public class DownLoadDialog implements View.OnClickListener {
    private Context mContext;
    private ResourceBean.DataBean mVersionBean;
    private Dialog mDialog;
    private ProgressBar mProgressBar;
    private TextView mTvDownloadGuide, mTvProgressBar, mTvDownlodLeft, mTvDownlodRight;
    private RelativeLayout mRltDownloadBtn;
    private DownloadRightClick mDownloadRightClick;

    public DownLoadDialog(Context mContext, ResourceBean.DataBean mVersionBean) {
        this.mContext = mContext;
        this.mVersionBean = mVersionBean;

        View v = LayoutInflater.from(mContext).inflate(R.layout.download_dialog, null);
        mTvDownloadGuide = (TextView) v.findViewById(R.id.tv_download_guide);
        mProgressBar = (ProgressBar) v.findViewById(R.id.pg_download_progressBar);
        mTvProgressBar = (TextView) v.findViewById(R.id.tv_progress);
        mTvDownlodLeft = (TextView) v.findViewById(R.id.tv_downlod_left);
        mTvDownlodLeft.setOnClickListener(this);
        mTvDownlodRight = (TextView) v.findViewById(R.id.tv_download_right);
        mTvDownlodRight.setOnClickListener(this);
        mRltDownloadBtn = (RelativeLayout) v.findViewById(R.id.rlt_download_btn);

        if ("1".equals(mVersionBean.getIsForced())) mTvDownlodRight.setText("退出");
        else mTvDownlodRight.setText("取消");

        mDialog = new Dialog(mContext, R.style.download_dialog_style);
        mDialog.setContentView(v);
        mDialog.setCancelable(false);
        Display display = mDialog.getWindow().getWindowManager().getDefaultDisplay();
        mDialog.getWindow().setLayout((int) (display.getWidth() * 4 / 5), ViewGroup.LayoutParams.WRAP_CONTENT);
    }

    public void show() {
        mDialog.show();
        startDownLoad();
    }

    /***
     * 开始下载
     */
    private void startDownLoad() {
        final String appPath = mContext.getExternalCacheDir().getAbsolutePath();
        OkGo.<File>get(mVersionBean.getClientDownUrl()).execute(new FileCallback(appPath, "abc.apk") {

            @Override
            public void onError(com.lzy.okgo.model.Response<File> response) {
                super.onError(response);
                setOnFailureUi();
            }

            @Override
            public void onSuccess(com.lzy.okgo.model.Response<File> response) {
                try {
                    Intent intent = FileUtils.installApk(MainApplication.getApp(), appPath + "/abc.apk");
                    if (intent != null) {
                        mContext.startActivity(intent);
                    }
                    if (mDialog != null) {
                        mDialog.dismiss();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                AppManager.getAppManager().finishAllActivity();
            }

            @Override
            public void downloadProgress(Progress progress) {
                super.downloadProgress(progress);
                changeNotify(progress.totalSize, progress.currentSize);
            }
        });
    }

    /***
     * 更新进度
     *
     * @param totalSize
     * @param currentSize
     */
    private void changeNotify(long totalSize, long currentSize) {
        int precent = 0;
        if (totalSize == 0) {
            totalSize = -1;
        }
        precent = (int) (currentSize * 100 / totalSize);

        if (totalSize == -1) {
            setOnFailureUi();
        } else {
            if (precent != 100) {
                mProgressBar.setProgress(precent);
                mTvProgressBar.setText(precent + "%");
            } else {
                mTvDownloadGuide.setText("下载完成");
                mProgressBar.setProgress(100);
                mTvProgressBar.setText("100%");
            }
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_downlod_left:
                retry();
                break;
            case R.id.tv_download_right:
                mDialog.dismiss();
                if (mDownloadRightClick != null) {
                    mDownloadRightClick.onRightClick("1".equals(mVersionBean.getIsForced()));
                }
                break;
        }
    }

    /**
     * 重新下载
     **/
    private void retry() {
        mTvDownloadGuide.setText("下载中...");
        mRltDownloadBtn.setVisibility(View.GONE);
        startDownLoad();
    }

    /**
     * 设置下载失败时候dialog显示
     **/
    private void setOnFailureUi() {
        mTvDownloadGuide.setText("下载失败");
        mRltDownloadBtn.setVisibility(View.VISIBLE);
        mProgressBar.setProgress(0);
        mTvProgressBar.setText("0%");
    }

    public DownloadRightClick getmDownloadRightClick() {
        return mDownloadRightClick;
    }

    public void setmDownloadRightClick(DownloadRightClick mDownloadRightClick) {
        this.mDownloadRightClick = mDownloadRightClick;
    }

    public interface DownloadRightClick {
        public void onRightClick(boolean isForce);
    }
}
