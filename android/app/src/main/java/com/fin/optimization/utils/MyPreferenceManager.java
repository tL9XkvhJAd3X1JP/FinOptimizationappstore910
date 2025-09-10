package com.fin.optimization.utils;

import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import com.fin.optimization.MainApplication;

/**
 * Created by WAHAHA on 2018/11/13.
 */
public class MyPreferenceManager {

    private final SharedPreferences preferences;

    private String keyEnclosureMaxId = "key_enclosure_";
    private String keyRemovedMaxId = "key_removed_";
    private String KeyHasLogin = "key_has_login_";
    private String KeyToken = "key_token";

    public MyPreferenceManager() {
        preferences = PreferenceManager.getDefaultSharedPreferences(MainApplication.getApp());
    }

    /**
     * 保存围栏报警最大id
     *
     * @param customerId
     * @param enclosureMaxId
     */
    public void saveEfenceAlarmMaxId(String customerId, int enclosureMaxId) {
        preferences.edit().putLong(keyEnclosureMaxId + customerId, enclosureMaxId).commit();
    }

    /**
     * 获取围栏报警最大id
     *
     * @param customerId
     * @return
     */
    public long getEfenceAlarmMaxId(String customerId) {
        return preferences.getLong(keyEnclosureMaxId + customerId, 0);
    }

    /**
     * 保存拆除报警最大id
     *
     * @param customerId
     * @param removedMaxId
     */
    public void saveRemovedAlarmMaxId(String customerId, int removedMaxId) {
        preferences.edit().putLong(keyRemovedMaxId + customerId, removedMaxId).commit();
    }

    /**
     * 获取拆除报警最大id
     *
     * @param customerId
     * @return
     */
    public long getRemovedAlarmMaxId(String customerId) {
        return preferences.getLong(keyRemovedMaxId + customerId, 0);
    }

    /**
     * 保存登录状态
     */
    public void saveLoginState(boolean hasLogin) {
        preferences.edit().putBoolean(KeyHasLogin, hasLogin).commit();
    }

    /**
     * 获取登录状态
     *
     * @return
     */
    public boolean getLoginState() {
        return preferences.getBoolean(KeyHasLogin, false);
    }

    /**
     * 保存请求token
     */
    public void saveRequestToken(String token) {
        preferences.edit().putString(KeyToken, token).commit();
    }

    /**
     * 获取登录状态
     *
     * @return
     */
    public String getRequestToken() {
        return preferences.getString(KeyToken, "");
    }
}
