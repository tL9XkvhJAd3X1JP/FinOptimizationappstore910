package com.fin.optimization;

import android.app.Application;

import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.modules.network.OkHttpClientFactory;
import com.facebook.react.modules.network.OkHttpClientProvider;
import com.facebook.react.modules.network.ReactCookieJarContainer;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.soloader.SoLoader;
import com.fin.optimization.constant.Constants;
import com.fin.optimization.rnpackage.ReactNativePackage;
import com.fin.optimization.utils.AppUtils;
import com.tencent.bugly.crashreport.CrashReport;

import java.io.IOException;
import java.io.InputStream;
import java.security.KeyStore;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;

import cn.qiuxiang.react.baidumap.BaiduMapPackage;
import okhttp3.OkHttpClient;

public class MainApplication extends Application implements ReactApplication {

    private static MainApplication app;

    private String ReactModuleName;

    private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {
        @Override
        public boolean getUseDeveloperSupport() {
            return BuildConfig.DEBUG;
        }

        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                    new MainReactPackage(),
                    new BaiduMapPackage(), new ReactNativePackage()
            );
        }

        @Override
        protected String getJSMainModuleName() {
            return "index";
        }
    };

    @Override
    public ReactNativeHost getReactNativeHost() {
        return mReactNativeHost;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        app = this;
        SoLoader.init(this, /* native exopackage */ false);

//        LitePal.initialize(this);

//        // 在使用 SDK 各组间之前初始化 context 信息，传入 ApplicationContext
//        SDKInitializer.initialize(this);
//        //自4.3.0起，百度地图SDK所有接口均支持百度坐标和国测局坐标，用此方法设置您使用的坐标类型.
//        //包括BD09LL和GCJ02两种坐标，默认是BD09LL坐标。
//        SDKInitializer.setCoordType(CoordType.BD09LL);

        // 获取当前进程名
        String processName = AppUtils.getProcessName(android.os.Process.myPid());
        // 设置是否为上报进程
        CrashReport.UserStrategy strategy = new CrashReport.UserStrategy(this);
        strategy.setUploadProcess(processName == null || processName.equals(getPackageName()));
        CrashReport.initCrashReport(getApplicationContext(), "6461e91cb6", !Constants.RTM_ENV);

        httpsSetting();
    }

    public static MainApplication getApp() {
        return app;
    }

    public String getReactModuleName() {
        return ReactModuleName;
    }

    public void setReactModuleName(String reactModuleName) {
        ReactModuleName = reactModuleName;
    }


    private void httpsSetting() {
        OkHttpClient.Builder client = new OkHttpClient.Builder()
                .connectTimeout(10 * 1000, TimeUnit.MILLISECONDS)
                .readTimeout(10 * 1000, TimeUnit.MILLISECONDS)
                .writeTimeout(10 * 1000, TimeUnit.MILLISECONDS)
                .cookieJar(new ReactCookieJarContainer());
        setCertificates(client, "key.bks");
        client.hostnameVerifier(new HostnameVerifier() {
            @Override
            public boolean verify(String hostname, SSLSession session) {
                return true;
            }
        });
        OkHttpClient.Builder builder = OkHttpClientProvider.enableTls12OnPreLollipop(client);
        // 将上面设置了认证的client对象替换
        OkHttpClientProvider.setOkHttpClientFactory(new OkHttpClientFactory() {
            @Override
            public OkHttpClient createNewNetworkModuleClient() {
                return builder.build();
            }
        });
    }

    private void setCertificates(OkHttpClient.Builder client, String fileName) {

        SSLContext context = null;
        InputStream is = null;

        try {
            is = getAssets().open(fileName);
            // 取得SSL的SSLContext实例
            context = SSLContext.getInstance("TLS");
            // 取得BKS密库实例
            KeyStore keyKeyStore = KeyStore.getInstance("BKS");
            // kclient:密钥
            keyKeyStore.load(is, "d9TM9n0s".toCharArray());
            //决定是否信任对方的证书
            TrustManagerFactory trustManagerFactory = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
            trustManagerFactory.init(keyKeyStore);
            TrustManager[] trustManagers = trustManagerFactory.getTrustManagers();
            // 取得KeyManagerFactory实例
            KeyManagerFactory keyManager = KeyManagerFactory.getInstance("X509");
            // 初始化密钥管理器、信任证书管理器
            keyManager.init(keyKeyStore, "d9TM9n0s".toCharArray());
            context.init(keyManager.getKeyManagers(), trustManagers, new SecureRandom());
            client.sslSocketFactory(context.getSocketFactory(), new X509TrustManager() {
                @Override
                public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {

                }

                @Override
                public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {

                }

                @Override
                public X509Certificate[] getAcceptedIssuers() {
                    return new X509Certificate[0];
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                    is = null;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

}
