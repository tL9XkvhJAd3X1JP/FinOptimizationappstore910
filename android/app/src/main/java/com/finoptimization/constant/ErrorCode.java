package com.finoptimization.constant;

/***
 * 错误码
 *
 * @author zhaohaibin
 *
 */
public class ErrorCode {

    /**
     * 过时了
     */
    public static final String OVER_TIME = "-1";

    /**
     * 列表无数据
     **/
    public static final String SUCCESS = "10000";
    /**
     * 参数异常
     **/
    public static final String PARAM_EXCEPTION = "10001";
    /**
     * 参数为空
     **/
    public static final String PARAM_NULL = "100011";
    /**
     * 请求不合法
     **/
    public static final String REQUEST_ILLEGAL = "10002";
    /**
     * 请求校验错误
     **/
    public static final String CHECK_ERR = "10003";

    public static final String RENT_CAR_FAILE_MONEY = "10005";//租车时余额不足

    public static final String GPS_CITY_OUT = "10006";//城市定位时当前城市未开通

    public static final String RENT_USER_NOT_PASS = "10007";//没有通过认证或认证被驳回

    public static final String RENT_USER_NOT_MEMBER = "10008";//不是会员

    public static final String OPEN_DOOR_HAVE_MONEY = "10009";//开锁时代缴停车费有现金返还

}
