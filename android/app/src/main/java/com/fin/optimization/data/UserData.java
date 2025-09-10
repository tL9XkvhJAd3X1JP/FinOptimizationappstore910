package com.fin.optimization.data;

import com.fin.optimization.bean.User;
import com.fin.optimization.utils.MyPreferenceManager;

import org.litepal.LitePal;

public class UserData {

    private static UserData instance;

    private UserData() {
    }

    private User user;

    public static UserData getInstance() {
        if (instance == null) {
            synchronized (UserData.class) {
                if (instance == null) {
                    instance = new UserData();
                }
            }
        }
        return instance;
    }

    public void save(User user) {
        if (user == null) {
            return;
        }
        refreshToken(user);
        this.user = user;
        refreshMaxId(this.user);
        user.saveOrUpdate("customerid = ?", String.valueOf(user.getCustomerid()));
    }

    private void refreshToken(User user) {
        if (this.user != null) {
            user.setToken(this.user.getToken());
        }
    }


    private void refreshMaxId(User user) {
        if (user != null) {
            user.setUnReadRemovedAlarmMaxId((int) new MyPreferenceManager().getRemovedAlarmMaxId(user.getCustomerid()));
            user.setUnReadEfenceAlarmMaxId((int) new MyPreferenceManager().getEfenceAlarmMaxId(user.getCustomerid()));
        }
    }

    /**
     * 获取user
     *
     * @return
     */
    public User getUser() {
        if (user == null) {
            user = LitePal.findFirst(User.class);
            refreshMaxId(user);
        }
        return user;
    }

    /**
     * 清空数据
     */
    public void clearUserData() {
        LitePal.deleteAll(User.class);
        this.user = null;
    }
}
