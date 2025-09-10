package com.finoptimization.network;

import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;

import com.android.volley.Request;
import com.android.volley.Request.Method;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.Volley;
import com.finoptimization.MainApplication;
import com.finoptimization.R;
import com.finoptimization.activity.LoginActivity;
import com.finoptimization.bean.BaseBean;
import com.finoptimization.bean.User;
import com.finoptimization.constant.Constants;
import com.finoptimization.constant.ErrorCode;
import com.finoptimization.data.UserData;
import com.finoptimization.utils.DeviceUtils;
import com.finoptimization.utils.Logger;
import com.finoptimization.utils.ToastUtil;

import java.util.Map;
import java.util.Set;

/**
 * 网络访问入口
 */
public class NetWorkAccess {

    private static final String TAG = "NetWorkAccess";

    private static NetWorkAccess mInstance;

    private static RequestQueue mRequestQueue;// 主要的请求类

    private Context mcontext;

    private int timeout = 8000;//

    public NetWorkAccess() {
        super();
        this.mcontext = MainApplication.getApp();
        mRequestQueue = getRequestQueue();
    }

    /**
     * 获取网络请求入口的实例
     *
     * @return
     */
    public static synchronized NetWorkAccess getInstance() {
        if (mInstance == null) {
            mInstance = new NetWorkAccess();
        }
        return mInstance;
    }

    /**
     * 获取请求队列
     *
     * @return
     */
    public RequestQueue getRequestQueue() {
        if (mRequestQueue == null) {
            mRequestQueue = Volley.newRequestQueue(mcontext.getApplicationContext());
        }
        return mRequestQueue;
    }

    /**
     * 添加到请求队列
     *
     * @param req
     */
    public <T> void addToRequestQueue(Request<T> req) {
        getRequestQueue().add(req);
    }

    /**
     * 获取请求类
     *
     * @return
     */
    @Deprecated
    public GsonRequest getRequest() {
        return null;
    }

    /**
     * 取消tag标记的请求
     */
    public void cancel(String flag) {
        if (mRequestQueue != null) {
            mRequestQueue.cancelAll(flag);
        }
    }

    /**
     * 请求成功或失败的回调接口
     */
    public interface NetWorkAccessListener {
        public <T> void onAccessComplete(boolean success, T response, VolleyError error, String flag);
    }

    /**
     * 设置超时时间，默认25秒
     */
    public NetWorkAccess setTimeout(int timeout) {
        this.timeout = timeout;
        return this;
    }

    /**************************************************************/

    /**
     * 开始post请求 无dialog 默认提示网络请求超时
     *
     * @param url
     * @param clazz
     * @param flag
     * @param map
     * @param listener
     * @return
     */
    synchronized public <T> NetWorkAccess byPost(String url, Class<T> clazz, String flag, Map<String, String> map,
                                                 NetWorkAccessListener listener) {
        startrequest(url, clazz, Method.POST, false, listener, flag, true, 2, map);
        return this;
    }

    /**
     * @param url
     * @param clazz
     * @param flag
     * @param map
     * @param count    请求次数
     * @param listener
     * @param <T>
     * @return
     */
    synchronized public <T> NetWorkAccess byPost(String url, Class<T> clazz, String flag, Map<String, String> map, int count,
                                                 NetWorkAccessListener listener) {
        startrequest(url, clazz, Method.POST, false, listener, flag, true, count, map);
        return this;
    }

    /**
     * post请求,参数为json,非a=1&b=2的形式
     *
     * @param url
     * @param clazz
     * @param flag
     * @param map
     * @param listener
     * @param <T>
     * @return
     */
    synchronized public <T> NetWorkAccess byStreamPost(String url, Class<T> clazz, String flag, Map<String, String> map,
                                                       NetWorkAccessListener listener) {
        startrequest(url, clazz, Method.POST, false, listener, flag, true, map, 2, true);
        return this;
    }


    /**
     * 开始post请求
     *
     * @param url
     * @param clazz
     * @param flag
     * @param map
     * @param isShowNetworkError
     * @param listener
     * @return
     */
    synchronized public <T> NetWorkAccess byPost(String url, Class<T> clazz, String flag, Map<String, String> map,
                                                 boolean isShowNetworkError, NetWorkAccessListener listener) {
        startrequest(url, clazz, Method.POST, false, listener, flag, isShowNetworkError, map);
        return this;
    }

    /**
     * 打印并存储get请求的log日志
     *
     * @param url
     */
    private void printGetRequestLog(String url) {
        if (Constants.RTM_ENV) {
            int n = url.indexOf(".cn:");
            Logger.e("HttpRequest", n <= 0 ? url : url.substring(n + 8));

        } else {
            Logger.e("HttpRequest", url);
        }
    }

    /**
     * 打印并存储post请求的log日志
     *
     * @param params
     */
    private void printPostRequestLog(Map<String, String> params, String url) {
        try {
            url += getParamStr(params);
            printGetRequestLog(url);
        } catch (Exception e) {
            throw new RuntimeException("UTF-8编码错误");
        }
    }

    private <T> GsonRequest initListener(String url, Class<T> clazz, int method, boolean savecache,
                                         NetWorkAccessListener listener, boolean isShowNetworkError, Map<String, String> map, String flag, int millis, int count, boolean isStream) {
        url = handlerUrl(url);
        ResponseListener<T> relistener = new ResponseListener<T>(this, listener, isShowNetworkError, flag);
        GsonRequest request = new GsonRequest<T>(method, url, clazz, isStream, relistener, null);
        if (method != Method.GET) {
            printPostRequestLog(map, url);
            request.setParams(map);
        }
        request.setUrl(url);
        request.setTimeout(millis, count);
        request.setShouldCache(savecache);
        relistener.setCurrnetRequest(request);
        return request;
    }

    private String handlerUrl(String url) {
        if (Constants.GetVersionPar.GET_VERSION_API.contains(url)) {
            return Constants.getRealUrl() + url;
        }
        if (Constants.Upload.UPLOAD.contains(url)) {
            return Constants.getUploadUrl();
        }
//        if (UrlData.needHttpsRequest(url)) {
        return Constants.getBaseUrlSSL() + url;
//        } else {
//            return Constants.getBaseUrl() + url;
//        }
//        return "http://192.168.42.112:8080/travelplatform/" + url;
    }


    /**
     * 开始请求
     *
     * @param <T>
     */
    @SuppressWarnings("unchecked")
    private <T> GsonRequest startrequest(String url, Class<T> clazz, int method, boolean savecache,
                                         NetWorkAccessListener listener, String flag, boolean isShowNetworkError, Map<String, String> map) {
        return startrequest(url, clazz, method, savecache, listener, flag, isShowNetworkError, map, timeout, 1, false);
    }

    private <T> GsonRequest startrequest(String url, Class<T> clazz, int method, boolean savecache,
                                         NetWorkAccessListener listener, String flag, boolean isShowNetworkError, int count, Map<String, String> map) {
        return startrequest(url, clazz, method, savecache, listener, flag, isShowNetworkError, map, timeout, count, false);
    }

    private <T> GsonRequest startrequest(String url, Class<T> clazz, int method, boolean savecache,
                                         NetWorkAccessListener listener, String flag, boolean isShowNetworkError, Map<String, String> map, boolean isStream) {
        return startrequest(url, clazz, method, savecache, listener, flag, isShowNetworkError, map, timeout, 1, isStream);
    }

    private <T> GsonRequest startrequest(String url, Class<T> clazz, int method, boolean savecache,
                                         NetWorkAccessListener listener, String flag, boolean isShowNetworkError, Map<String, String> map, int count, boolean isStream) {
        return startrequest(url, clazz, method, savecache, listener, flag, isShowNetworkError, map, timeout, count, isStream);
    }

    private <T> GsonRequest startrequest(String url, Class<T> clazz, int method, boolean savecache,
                                         NetWorkAccessListener listener, String flag, boolean isShowNetworkError, Map<String, String> map, int millis, int count, boolean isStream) {
        GsonRequest request = initListener(url, clazz, method, savecache, listener, isShowNetworkError, map, flag, millis, count, isStream);
        request.setTag(TextUtils.isEmpty(flag) ? TAG : flag);
        mRequestQueue.add(request);
        return request;
    }

    /**
     * 请求回调
     *
     * @param <T>
     */
    public class ResponseListener<T> implements Response.Listener<T>, Response.ErrorListener {
        private NetWorkAccess net;

        private NetWorkAccessListener listener;

        private GsonRequest request;

        private boolean isShowNetworkError;

        private String flag;

        public ResponseListener(NetWorkAccess netaccess, NetWorkAccessListener listener,
                                boolean isShowNetworkError, String flag) {
            this.net = netaccess;
            this.listener = listener;
            this.isShowNetworkError = isShowNetworkError;
            this.flag = flag;
        }

        @Override
        public void onResponse(T response) {
            if (listener != null) {
                if (response instanceof BaseBean) {
                    BaseBean baseBean = (BaseBean) response;
                    if (TextUtils.equals(baseBean.getCode(), ErrorCode.OVER_TIME)) {
                        UserData.getInstance().clearUserData();
                        MainApplication.getApp().startActivity(new Intent(MainApplication.getApp(), LoginActivity.class).putExtra("finishAll", true));
                        ToastUtil.show(MainApplication.getApp(), "登录已失效，请重新登录");
                    } else {
                        listener.onAccessComplete(true, response, null, flag);
                    }
                } else {
                    listener.onAccessComplete(true, response, null, flag);
                }
                listener = null;
            }
        }

        @Override
        public void onErrorResponse(VolleyError error) {
            if (listener != null) {
                listener.onAccessComplete(false, null, error, flag);
                request = null;
                listener = null;
            }
            if (isShowNetworkError) {
                ToastUtil.show(MainApplication.getApp(), R.string.network_error);
            }
            error.printStackTrace();
        }

        /**
         * 释放保存的界面对象的引用
         */
        public void realse() {
            listener = null;
            request = null;
        }

        public void setCurrnetRequest(GsonRequest request) {
            this.request = request;
        }
    }

    /**
     * 获取参数(得到 ?a=12&b=123)
     */
    public String getParamStr(Map<String, String> params) throws Exception {
        if (params != null) {
            params.put("version", DeviceUtils.getCurrentAppVersionCode(MainApplication.getApp()) + "");
            params.put("versionName", DeviceUtils.getCurrentAppVersionName(MainApplication.getApp()));
            params.put("platform", "1");
            User user = UserData.getInstance().getUser();
            if (user != null) {
                params.put("login_userId", String.valueOf(user.getCustomerid()));
                params.put("login_password", user.getPassword());
                params.put("login_name", user.getLoginname());
            }
        }
        StringBuffer bf = new StringBuffer();
        if (params != null) {
            Set<String> mset = params.keySet();
            String[] keys = mset.toArray(new String[mset.size()]);
            for (String key : keys) {
                String value = params.get(key);
                bf.append(key + String.valueOf("=") + value
                        + String.valueOf("&"));
            }
        }
        String str = bf.toString();
        return "?" + str;
    }
}
