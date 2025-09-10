package com.finoptimization.bean;

/**
 * 作者：WangJintao
 * 时间：2018/5/14
 * 邮箱：wangjintao1988@163.com
 */
public class BaseBean {

    protected boolean isSuccess;
    protected String code;
    protected String message;

    public boolean isSuccess() {
        return isSuccess;
    }

    public void setSuccess(boolean success) {
        isSuccess = success;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
