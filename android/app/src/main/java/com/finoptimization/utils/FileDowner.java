package com.finoptimization.utils;

import android.os.AsyncTask;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * 文件下载（用于软件更新）
 *
 * @author spoon
 */
public class FileDowner extends AsyncTask<Void, Integer, Boolean> {
    HttpURLConnection httpURLConnection;
    String url, md5;
    FileDownCallBack fileDownCallBack;
    String filePath;

    public FileDowner(String url, String md5, String filePath, FileDownCallBack fileDownCallBack) {
        this.url = url;
        this.md5 = md5;
        this.filePath = filePath;
        this.fileDownCallBack = fileDownCallBack;

    }

    @Override
    protected void onPreExecute() {
        if (fileDownCallBack != null) {
            fileDownCallBack.onStart(filePath);
        }
        super.onPreExecute();
    }

    @Override
    protected void onProgressUpdate(Integer... values) {
        if (fileDownCallBack != null) {
            fileDownCallBack.onProgress(filePath, values[0]);
        }
        super.onProgressUpdate(values);
    }

    @Override
    protected Boolean doInBackground(Void... params) {
        try {
            URL url = new URL(this.url);
            httpURLConnection = (HttpURLConnection) url.openConnection();
            httpURLConnection.setRequestMethod("GET");
            //httpURLConnection.setDoOutput(true);
            httpURLConnection.setDoInput(true);
            httpURLConnection.setConnectTimeout(30000);
            httpURLConnection.setReadTimeout(30000);
            httpURLConnection.connect();
            int length = httpURLConnection.getContentLength();
            FileOutputStream fileOutputStream = new FileOutputStream(new File(filePath));
            InputStream inputStream = httpURLConnection.getInputStream();
            byte[] data = new byte[4 * 1024];
            int n = -1;
            int count = 0;
            while ((n = inputStream.read(data)) != -1 && !isCancelled()) {
                fileOutputStream.write(data, 0, n);
                count += n;
                publishProgress((int) ((count * 1.0f / length) * 100));
            }
            fileOutputStream.close();
            inputStream.close();

            if (!StringUtils.isEmpty(md5)) {
                String md5String = FileMD5Helper.md5sum(filePath);
                boolean isSuccess = md5.equalsIgnoreCase(md5String);
                Logger.e("checkFileMD5", String.valueOf(isSuccess));
                if (!isSuccess) {
                    File file = new File(filePath);
                    file.delete();
                    return false;
                }
            }
            return true;
        } catch (Exception e) {
//            fileDownCallBack.onDownError(filePath);
            e.printStackTrace();
        } finally {
            if (httpURLConnection != null) {
                httpURLConnection.disconnect();
            }
        }
        return false;
    }

    @Override
    protected void onPostExecute(Boolean result) {
        if (result) {
            if (fileDownCallBack != null) {
                fileDownCallBack.onDownSuccess(filePath);
            }
        } else {
            if (fileDownCallBack != null) {
                fileDownCallBack.onDownError(filePath);
            }
        }
        super.onPostExecute(result);
    }

    @Override
    protected void onCancelled() {
        if (httpURLConnection != null) {
            httpURLConnection.disconnect();
        }
        super.onCancelled();
    }

    /**
     * 文件下载回调接口
     *
     * @author spoon
     */
    public interface FileDownCallBack {
        void onStart(String filePath);

        void onProgress(String filePath, int proess);

        void onDownSuccess(String filePath);

        void onDownError(String filePath);
    }

}
