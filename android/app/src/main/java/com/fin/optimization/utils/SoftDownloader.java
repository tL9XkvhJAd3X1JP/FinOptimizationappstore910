package com.fin.optimization.utils;

import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.view.View;

import com.fin.optimization.R;
import com.fin.optimization.widget.WiseLinkDialog;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.concurrent.Executors;

public class SoftDownloader implements FileDowner.FileDownCallBack {
    WiseLinkDialog downProgress;
    Context context;
    String softUrl;
    FileDowner softUpdate;
    int title;


    public SoftDownloader(Context context, String softUrl, int title) {
        this.context = context;
        this.softUrl = softUrl;
        this.title = title;
    }

    public void startDownload() {
        try {
            String fileName = softUrl.substring(softUrl.lastIndexOf("/") + 1);
            if (Build.VERSION.SDK_INT < 24) {
                try {
                    context.openFileOutput(fileName, Context.MODE_WORLD_READABLE);
                } catch (FileNotFoundException e) {
                    throw new RuntimeException(context.getString(R.string.get_file_exception));
                }
                String filePath = context.getFileStreamPath(fileName).getAbsolutePath();
                softUpdate = new FileDowner(softUrl, null, filePath, this);
//                softUpdate.execute((Void) null);
                softUpdate.executeOnExecutor(Executors.newCachedThreadPool());
            } else {
                if (TextUtils.equals(Environment.getExternalStorageState(), Environment.MEDIA_MOUNTED)) {
                    File externalStorageDirectory = Environment.getExternalStorageDirectory();
                    String filePath = externalStorageDirectory.getAbsolutePath() + "/wiselink";
                    File file = new File(filePath);
                    if (!file.exists()) {
                        file.mkdirs();
                    }
                    filePath = filePath + "/" + fileName;
                    Logger.e("updateFile:" + filePath);
                    softUpdate = new FileDowner(softUrl, null, filePath, this);
                    softUpdate.executeOnExecutor(Executors.newCachedThreadPool());;
                } else {
                    //请安装SDcard
//                    ToastUtil.show(context, "手机存储异常,请尝试重新下载！");
                    throw new RuntimeException(context.getString(R.string.save_file_exception));
                }
            }
        } catch (Exception e) {
            updataFail();
        }
    }

    private void updataFail() {
        /*
        WiseLinkDialog dialog = new WiseLinkDialog(context);
        dialog.setTitle("提示");
        dialog.setMessage(context.getString(R.string.update_failed_tips));
        dialog.setPositiveButton(R.string.go_download, -1, new DialogInterface
                .OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {
                if (!NetworkDetector.isNetworkAvailable(WiseLinkApp.getApp())) {
                    ToastUtil.show(WiseLinkApp.getApp(), context.getString(R.string.no_network_title));
                    return;
                }
                if (Constants.RTM_ENV) {
                    IntentUtils.openByBrowser(context, "http://wsm1.wiselink.net.cn/wtsWiselink.html");
                } else {
                    IntentUtils.openByBrowser(context, "http://192.168.10.193:9090/wtsWiselink.html");
                }

            }
        });
        dialog.setNegativeButton(R.string.cancel, -1, null);
        dialog.show();*/
    }

    @Override
    public void onStart(String filePath) {
        try {
            downProgress = new WiseLinkDialog(context);
            downProgress.setTitle(title);
            downProgress.setCancelable(false);
            downProgress.setProgress(0);
            downProgress.setOkButton("取消", new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (softUpdate != null && softUpdate.getStatus() != AsyncTask.Status.FINISHED) {
                        softUpdate.cancel(true);
                    }
                    downProgress.dismiss();
                }
            });
            downProgress.show();
        } catch (Exception e) {
            if (softUpdate != null && softUpdate.getStatus() != AsyncTask.Status.FINISHED) {
                softUpdate.cancel(true);
            }
            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    updataFail();
                }
            });
        }
    }

    @Override
    public void onProgress(String filePath, int proess) {
        downProgress.setProgress(proess);
    }

    @Override
    public void onDownSuccess(String filePath) {
        try {
            if (filePath.toLowerCase().endsWith(".apk")) {
                File dir = context.getFilesDir();
                File[] files = dir.listFiles();
                for (int i = 0; i < files.length; i++) {
                    if (files[i].getAbsolutePath().toLowerCase().endsWith(".apk") && !files[i].getAbsolutePath().equalsIgnoreCase(filePath)) {
                        files[i].delete();
                    }
                }
                Intent installApk = AppUtils.installApk(filePath);
                context.startActivity(installApk);
                downProgress.dismiss();
            }
        } catch (Exception e) {
            downProgress.dismiss();
            updataFail();
        }


    }

    @Override
    public void onDownError(String filePath) {
        downProgress.dismiss();
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                updataFail();
            }
        });

//        ToastUtil.show(context, R.string.updateError);
    }


}