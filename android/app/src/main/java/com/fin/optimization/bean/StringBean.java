package com.fin.optimization.bean;

/**
 * Created by xiongjida on 2017/11/30.
 */

public class StringBean extends BaseBean {

    private String json;

    public StringBean(String json) {
        this.json = json;
    }

    public String getJson() {
        return json;
    }

    public void setJson(String json) {
        this.json = json;
    }
}
