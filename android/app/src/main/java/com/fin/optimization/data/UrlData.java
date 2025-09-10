package com.fin.optimization.data;

import android.content.Context;
import android.content.SharedPreferences;

import com.fin.optimization.MainApplication;
import com.fin.optimization.bean.ResourceBean;
import com.fin.optimization.constant.Constants;

import java.util.Arrays;

/**
 * 作者：WangJintao
 * 时间：2017/3/20
 * 邮箱：wangjintao1988@163.com
 * 保存一些App需要的数据
 */

public class UrlData {

    private static UrlData urlData = new UrlData();

    private static final String SP_NAME = "app_data";

    private static final String BASE_URL = "base_url";

    private static final String BASE_URL_SSL = "base_url_ssl";

    private static final String BASE_INNER_BUSINESS_INTERFACE_ADDRESS_SSL = "innerBusinessInterfaceAddress_ssl";

    private static final String BASE_FILE_URL = "base_file_url";

    private static final String BASE_BLE_UPLOAD_URL = "base_ble_upload_url";

    private ResourceBean.DataBean url;

    private UrlData() {
    }

    public static UrlData getInstance() {
        return urlData;
    }

    public ResourceBean.DataBean getUrl() {
        if (url == null) {
            url = getUrlData();
        }
        return url;
    }

    private void fillUrl(ResourceBean.DataBean dataEntity) {
        url.setBusinessInterfaceAddress(dataEntity.getBusinessInterfaceAddress());
        url.setBusinessInterfaceAddress_ssl(dataEntity.getBusinessInterfaceAddress_ssl());
        url.setFileInterfaceAddress(dataEntity.getFileInterfaceAddress());
    }

    public void saveUrl(ResourceBean.DataBean dataEntity) {
        saveBaseUrl(dataEntity.getBusinessInterfaceAddress());
        saveBaseUrlSSL(dataEntity.getBusinessInterfaceAddress_ssl());
        saveBaseFileUrl(dataEntity.getFileInterfaceAddress());
        if (url != null) {
            fillUrl(dataEntity);
        }
    }

    private ResourceBean.DataBean getUrlData() {
        ResourceBean.DataBean urlBean = new ResourceBean.DataBean();
        urlBean.setBusinessInterfaceAddress(getBaseUrl());
        urlBean.setBusinessInterfaceAddress_ssl(getBaseUrlSSL());
        urlBean.setFileInterfaceAddress(getBaseFileUrl());
        return urlBean;
    }


    private String getBaseUrl() {
        SharedPreferences sp = MainApplication.getApp().getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        return sp.getString(BASE_URL, "");
    }

    /**
     * 保存注册协议
     *
     * @param baseUrl
     */
    private void saveBaseUrl(String baseUrl) {
        SharedPreferences sp = MainApplication.getApp().getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        sp.edit().putString(BASE_URL, baseUrl).commit();
    }

    /**
     * 获取业务地址https
     *
     * @return
     */
    private String getBaseUrlSSL() {
        SharedPreferences sp = MainApplication.getApp().getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        return sp.getString(BASE_URL_SSL, "");
    }

    /**
     * 保存业务地址https
     *
     * @param baseUrl
     */
    private void saveBaseUrlSSL(String baseUrl) {
        SharedPreferences sp = MainApplication.getApp().getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        sp.edit().putString(BASE_URL_SSL, baseUrl).commit();
    }

    /**
     * 获取蓝牙日志上传时所需的一个字段
     *
     * @return
     */
    private String getInnerBusinessInterfaceAddress_ssl() {
        SharedPreferences sp = MainApplication.getApp().getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        return sp.getString(BASE_INNER_BUSINESS_INTERFACE_ADDRESS_SSL, "");
    }

    /**
     * 保存蓝牙日志上传时所需的一个字段
     *
     * @param innerBusinessInterfaceAddress_ssl
     */
    private void saveInnerBusinessInterfaceAddress_ssl(String innerBusinessInterfaceAddress_ssl) {
        SharedPreferences sp = MainApplication.getApp().getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        sp.edit().putString(BASE_INNER_BUSINESS_INTERFACE_ADDRESS_SSL, innerBusinessInterfaceAddress_ssl).commit();
    }

    /**
     * 获取上传图片/文件地址
     *
     * @return
     */
    private String getBaseFileUrl() {
        SharedPreferences sp = MainApplication.getApp().getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        return sp.getString(BASE_FILE_URL, "");
    }

    /**
     * 保存上传图片/文件地址
     *
     * @param baseUrl
     */
    private void saveBaseFileUrl(String baseUrl) {
        SharedPreferences sp = MainApplication.getApp().getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        sp.edit().putString(BASE_FILE_URL, baseUrl).commit();
    }

    /**
     * 保存蓝牙上传的接口
     *
     * @param bleUrl
     */
    public void saveBLEUploadUrl(String bleUrl) {
        SharedPreferences sp = MainApplication.getApp().getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        sp.edit().putString(BASE_BLE_UPLOAD_URL, bleUrl).commit();
    }

    /**
     * 获取蓝牙上传的接口
     *
     * @return
     */
    private String getBLEUploadUrl() {
        SharedPreferences sp = MainApplication.getApp().getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        return sp.getString(BASE_BLE_UPLOAD_URL, "");
    }

    //所有https加密的接口
    public static String[] HTTPS_REQUEST = new String[]{
            Constants.SendValidateCodePar.SEND_VALIDATE_API,//发送短信验证码
    };

    /**
     * 是否是需要https加密
     *
     * @param iml 接口
     * @return
     */
    public static boolean needHttpsRequest(String iml) {
        return Arrays.asList(HTTPS_REQUEST).contains(iml);
    }
}
