package com.finoptimization.network;

import android.text.TextUtils;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.NetworkResponse;
import com.android.volley.ParseError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.Response.ErrorListener;
import com.android.volley.Response.Listener;
import com.android.volley.RetryPolicy;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HttpHeaderParser;
import com.finoptimization.MainApplication;
import com.finoptimization.bean.StringBean;
import com.finoptimization.bean.UserBean;
import com.finoptimization.constant.Constants;
import com.finoptimization.data.UserData;
import com.finoptimization.utils.DeviceUtils;
import com.finoptimization.utils.FileMD5Helper;
import com.finoptimization.utils.Logger;
import com.finoptimization.utils.MapRemoveNullUtil;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

/**
 * 自定义请求Request类(保存请求的所有参数)
 */
public class GsonRequest<T> extends Request<T> {

    private static final String TAG = GsonRequest.class.getSimpleName();
    private Listener<T> mlistener;// 成功时的回调

    private final Gson gson;

    private final Class<T> clazz;

    private String murl;// 请求的URL(用户保留)

    private Map<String, String> params;// 提交的参数

    private byte[] body;

    public String getUrl() {
        return murl;
    }

    private boolean isStream;

    public void setUrl(String url) {
        this.murl = url;
    }

    public void setParams(Map<String, String> params) {
        MapRemoveNullUtil.removeNullValue(params);
        this.params = params;
    }

    public void setTimeout(int time, int count) {

        RetryPolicy retryPolicy = new DefaultRetryPolicy(time, Math.max(0, count - 1),
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT);
        this.setRetryPolicy(retryPolicy);
    }

    /**
     * 构造方法（可以设置get或者post请求）
     *
     * @param method
     * @param url
     * @param clazz
     * @param listener
     * @param errorListener
     */
    public GsonRequest(int method, String url, Class<T> clazz, boolean isStream, Listener<T> listener, ErrorListener errorListener) {
        super(method, url, errorListener);
        this.isStream = isStream;
        this.mlistener = listener;
        this.murl = url;
        this.clazz = clazz;
        this.gson = new Gson();
    }

    /**
     * 构造方法（默认get请求）
     *
     * @param url
     * @param clazz
     * @param listener
     * @param errorListener
     */
    public GsonRequest(String url, Class<T> clazz, Listener<T> listener, ErrorListener errorListener) {
        this(Method.GET, url, clazz, false, listener, errorListener);
    }

    @Override
    public Map<String, String> getHeaders() throws AuthFailureError {
        HashMap<String, String> header = new HashMap<>();
        header.put("clientId", Constants.clientId);
        header.put("appFlag", "1");
        if (isStream) {
            header.put("Content-Type", "application/json");
        } else {
//            header.put("Content-Type", "application/json");
            header.put("timestamp", String.valueOf(System.currentTimeMillis()));
            header.put("token", UserData.getInstance().getUser() == null ? "" : UserData.getInstance().getUser().getToken());
            header.put("sign", FileMD5Helper.md5(header.get("token") + header.get("timestamp") + getBodyParam() + Constants.URL_ENCODE_KEY));
            Map<String, String> params = getParams();
            header.put("userName", params.get("loginname"));
            header.put("password", params.get("password"));
            header.put("phoneID", DeviceUtils.getPhoneIMEI(MainApplication.getApp()));
        }
        Logger.e("Header", gson.toJson(header));
        return header;
    }

    private String getBodyParam() throws AuthFailureError {
        Map<String, String> sortedParams = new TreeMap<String, String>(getParams());
        Set<Map.Entry<String, String>> entrys = sortedParams.entrySet();
        StringBuilder basestring = new StringBuilder();
        for (Map.Entry<String, String> param : entrys) {
            basestring.append(param.getKey());
            basestring.append(param.getValue() == null ? Constants.EMPTY_STRING : param.getValue());
        }
        return basestring.toString();
    }

    @Override
    public byte[] getBody() throws AuthFailureError {
        Map<String, String> params = getParams();
        if (params != null && params.size() > 0) {
            body = encodeParameters(params, getParamsEncoding());
            return body;
        }
        return null;
    }

    private byte[] encodeParameters(Map<String, String> params, String paramsEncoding) {
        StringBuilder encodedParams = new StringBuilder();
//        HashMap<String, String> map = new HashMap<>();
        try {
            if (isStream) {
                encodedParams.append(gson.toJson(params));
            } else {

                if (params.isEmpty()) {
                    return encodedParams.toString().getBytes(paramsEncoding);
                } else {
                    for (Map.Entry<String, String> entry : params.entrySet()) {
                        encodedParams.append(URLEncoder.encode(entry.getKey(), paramsEncoding));
                        encodedParams.append('=');
                        encodedParams.append(entry.getValue() == null ? Constants.EMPTY_STRING : URLEncoder.encode(entry.getValue(), paramsEncoding));
                        encodedParams.append('&');
//                    map.put(entry.getKey(), entry.getValue() == null ? Constants.EMPTY_STRING : entry.getValue());
                    }
                    return encodedParams.toString().substring(0, encodedParams.length() - 1).getBytes(paramsEncoding);
                }
            }
            return encodedParams.toString().getBytes(paramsEncoding);
        } catch (UnsupportedEncodingException uee) {
            throw new RuntimeException("Encoding not supported: " + paramsEncoding, uee);
        }
    }

    /**
     * 发送(post)数据时 vollery获取请求的参数
     */
    @Override
    protected Map<String, String> getParams() throws AuthFailureError {
        if (params == null) {
            params = new HashMap<String, String>();
        }
        return params;
    }

    /**
     * 处理服务器返回数据(获取成功后才调用)
     */
    @Override
    protected Response<T> parseNetworkResponse(NetworkResponse response) {
        if (response == null) {
            return null;
        }
        if (response.statusCode != 200) {
            return null;
        }
        try {
            String json;
            if (isStream) {
                json = new String(response.data, getParamsEncoding());
            } else {
                json = new String(response.data, String.valueOf("UTF-8"));
            }
            printLog(json);
            if (clazz.getSimpleName().contains(String.valueOf("StringBean"))) {
                StringBean bean = new StringBean(json);
                return Response.success(gson.fromJson(gson.toJson(bean), clazz), HttpHeaderParser.parseCacheHeaders(response));
            } else {
                T t = gson.fromJson(json, clazz);
                if (t instanceof UserBean && isLoginOrRegister()) {
                    UserBean user = (UserBean) t;
                    if (user.getData() != null) {
                        Map<String, String> headers = response.headers;
                        user.getData().setToken(headers.get("token"));
                    }
                }
                return Response.success(t, HttpHeaderParser.parseCacheHeaders(response));
            }
        } catch (UnsupportedEncodingException e) {
            return Response.error(new ParseError(e));
        } catch (JsonSyntaxException e) {
            return Response.error(new ParseError(e));
        }
    }

    private boolean isLoginOrRegister() {

        if (TextUtils.isEmpty(getUrl())) {
            return false;
        }

        if (getUrl().contains(Constants.LoginInfo.LOGIN_INFO_API) || getUrl().contains(Constants.RegisteBike.REGISTE_BIKE_API)) {
            return true;
        }

        return false;
    }

    /**
     * 打印log日志
     *
     * @param json
     */
    private void printLog(String json) {
        StringBuffer resultBuffer = new StringBuffer();
        resultBuffer.append(json);
        if (Constants.RTM_ENV) {
            Logger.e(
                    "RET",
                    resultBuffer.length() < Constants.MAX_LOGINFO ? resultBuffer.toString() : (resultBuffer.substring(
                            0, Constants.MAX_LOGINFO) + " ..."));
        } else
            Logger.e("RET", resultBuffer.toString());

    }

    /**
     * 触发mlistener成功事件(必须)
     */
    @Override
    protected void deliverResponse(T response) {
        if (mlistener != null) {
            mlistener.onResponse(response);
            mlistener = null;
        }
    }

    @Override
    public void deliverError(VolleyError error) {
        super.deliverError(error);
        if (error != null) {
            Logger.e(TAG, error.toString());
        }
        if (mlistener != null && mlistener instanceof NetWorkAccess.ResponseListener) {
            NetWorkAccess.ResponseListener listener = (NetWorkAccess.ResponseListener) mlistener;
            listener.onErrorResponse(error);
            mlistener = null;
        }

    }

    @Override
    public void cancel() {
        if (mlistener != null) {
            ((NetWorkAccess.ResponseListener) mlistener).realse();
            mlistener = null;
        }
        super.cancel();
    }

}
