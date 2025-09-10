package com.finoptimization.constant;

import com.finoptimization.data.UrlData;

public class Constants {

    public static boolean RTM_ENV = true;//正式环境还是测试环境

    public final static String CUSTOMER_FLAG = "FIN";//大客户标识

    public static final int MAX_LOGINFO = 1000;// 在RTM_ENV为true每条日志的最大的长度

    public static final String URL_ENCODE_KEY = "e10adc3949ba59abbe56e057f20f888e";

    //测试
    private static String URL_TEST = "http://118.26.142.213:8080/upgrade/";//外网测试
    //    String URL_TEST = "http://221.123.179.91:18080/upgrade/";//预生产环境
    //外网正式地址
    private static String URL = "https://service.zhixinkeyuan.com:8443/upgrade/";
    // 宜维clientId
    public static String clientId = "564f7e35-5163-4431-9ba7-dceb2e46e509";

    // 错误信息上传接口(log日志)
    public static String UP_LOAD_LOG_URL = "http://221.123.179.91:8805/ErrorReport.ashx";


    public final class ReactName {
        public static final String PERSION_CENTER = "PersionCenter";//我的（个人中心界面）
        public static final String CAR_ARCHIVES= "CarArchives";//车辆档案
        public static final String ANDROID_DIALOG = "AndroidDialog";//dialog
        public static final String ANDROID_UTILS = "AndroidUtils";//utils
    }

    public static final String EMPTY_STRING = "";

    public static String getRealUrl() {
        return RTM_ENV ? URL : URL_TEST;
    }

    public static String getBaseUrl() {
        return UrlData.getInstance().getUrl().getBusinessInterfaceAddress();
    }

    public static String getBaseUrlSSL() {
        return UrlData.getInstance().getUrl().getBusinessInterfaceAddress_ssl();
    }

    public static String getUploadUrl() {
        return UrlData.getInstance().getUrl().getFileInterfaceAddress();
    }

    /**
     * 获取文件上传地址
     *
     * @return
     */
    public static String uploadImg() {
        return UrlData.getInstance().getUrl().getFileInterfaceAddress();
    }


    /**
     * 获取资源地址
     */
    public final class GetVersionPar {
        public static final String GET_VERSION_API = "version/channelClient";
        public static final String CLIENTTYPE = "clientType";//1 android 2.ios
        public static final String CUSTOMER_FLAG = "CustomerFlag";

    }

    /**
     * 发送短信验证码
     */
    public final class SendValidateCodePar {
        public static final String SEND_VALIDATE_API = "interfaceController/sendValidateCode";
        public static final String PHONE = "phone";
        public static final String TYPE = "type";//注册是1，找回密码2 绑定手机4
        public static final String IS_SEND = "isSend";//是否发送短信 1是；0否
    }

    /**
     * 获取登记地址（注册页面）
     */
    public final class RegisterAddress {
        public static final String GET_REGISTER_ADDRESS = "interfaceController/getRegisterAddress";
    }

    /**
     * 常住地所属居/村委会（注册页）
     */
    public final class LiveOftenAddress {
        public static final String GET_LIVEOFTEN_ADDRESS = "interfaceController/getLiveOftenAddress";
        public static final String ID = "id";
    }

    /**
     * 上传
     */
    public final class Upload {
        public static final String UPLOAD = "upload";

    }

    /**
     * 注册
     */
    public final class RegisteBike {
        public static final String REGISTE_BIKE_API = "interfaceController/registeBike";
        public static final String LOGINNAME = "loginname";//登录用户名
        public static final String PASSWORD = "password";//密码
        public static final String MOBILEPHONE = "mobilephone";//手机号码
        public static final String VCODE = "vCode";//code
        public static final String COMPANYID = "companyid";//登记地址
        public static final String GROUPID = "groupid";//常住地所属居/村委会
        public static final String CUSTOMERNAME = "customername";//使用人姓名
        public static final String SEX = "sex";//使用人性别
        public static final String IDNUMBER = "idnumber";//使用人身份证号
        public static final String LINKMANNAME = "linkmanname";//紧急联系人姓名
        public static final String LINKMANSEX = "linkmansex";//紧急联系人性别
        public static final String LINKMANPHONE = "linkmanphone";//紧急联系人电话
        public static final String LINKMANIDNUMBER = "linkmanidnumber";//紧急联系人身份证号
        public static final String FRONTIDCARD = "frontidcard";//使用人身份证正面照
        public static final String REVERSEIDCARD = "reverseidcard";//使用人身份证反面照
        public static final String FRONTPHOTO = "frontphoto";//使用人正面免冠照片
        public static final String BRAND = "brand";//电动车品牌
        public static final String GENERATORNUMBER = "generatornumber";//电动车电机号
        public static final String VIN = "vin";//电动车车架号
        public static final String COLOR = "color";//电动车颜色
        public static final String BUYTIME = "buytime";//电动车购买时间
        public static final String ACCIDENTINSURANCE = "accidentinsurance";//驾驶人意外险
        public static final String BIKEPHOTO = "bikephoto";//上牌后照片
        public static final String USERPROVE = "userprove";//使用证明
        public static final String VOLUNTEER = "volunteer";//志愿者
        public static final String PALTENUMBER = "paltenumber";//车牌号
        public static final String IMEI = "imei";//imei
        public static final String AGAINSTTHEFT = "againsttheft";//防盗定位账号
        public static final String PRODUCTID = "productId";//产品id(修改时使用)
        public static final String CUSTOMERID = "customerid";//用户id(修改时使用)
        public static final String COMPANY_NAME = "companyName";//登记地址
        public static final String GROUP_NAME = "groupName";//村委会
    }


    /**
     * 需改注册信息(参数同注册)
     */
    public final class RegisteBikeUpdate {
        public static final String REGISTE_BIKE_UPDATE_API = "interfaceController/registeBikeUpdate";
    }

    /**
     * 登录
     */
    public final class LoginInfo {
        public static final String LOGIN_INFO_API = "interfaceController/getLoginInfo";
        public static final String LOGINNAME = "loginname";//登录用户名
        public static final String PASSWORD = "password";//密码
    }


    /**
     * 重置密码
     */
    public final class RestPwd {
        public static final String RESET_PWD_API = "interfaceController/updatePasswordByLoginname";
        public static final String LOGINNAME = "loginname";//登录用户名
        public static final String PASSWORD = "password";//密码
        public static final String VALIDATECODE = "validateCode";//code
    }

    /**
     * 根据手机号查询账号列表
     */
    public final class LoginnameByPhoneNum {
        public static final String LOGIN_NAME_BY_PHONENUM = "interfaceController/getLoginnameByPhoneNum";
        public static final String MOBILEPHONE = "mobilePhone";//电话

    }

    /**
     * 轨迹回放
     */
    public final class GPStrack {
        public static final String GPS_TRACK_API = "interfaceController/getGPStrack";
        public static final String IDC = "idc";
        public static final String STARTTIME = "starttime";
        public static final String ENDTIME = "endtime";
        public static final String BINDINGDATE = "bindingDate";
    }


    /**
     * 围栏报警
     */
    public final class AlarmEfence {
        public static final String ALARMEFENCE_API = "interfaceController/getAlarmEfence";
        public static final String IDC = "idc";
    }

    /**
     * 拆除报警
     */
    public final class AlarmDismantle {
        public static final String ALARMDISMANTLE_API = "interfaceController/getAlarmDismantle";
        public static final String IDC = "idc";
    }


    /**
     * 当前位置
     */
    public final class CurrentGPS {
        public static final String CURRENTGPS_API = "interfaceController/getCurrentGPS";
        public static final String IDC = "idc";
    }


    /**
     * 检测用户名是否注册在该手机号下面
     */
    public final class CheckPhoneAndLoginname {
        public static final String CHECK_PHONE_AND_LOGINNAME_API = "interfaceController/checkPhoneAndLoginname";
        public static final String LOGINNAME = "loginname";
        public static final String MOBILEPHONE = "mobilephone";
    }


    /**
     * 设置围栏
     */
    public final class SettingFence {
        public static final String SETTING_FENCE_API = "interfaceController/settingFence";
        public static final String PRODUCTID = "productId";
        public static final String IDC = "idc";
        public static final String ALARMTYPE = "alarmType";//报警类型  0全部  1入区    2出区
        public static final String EFENCEPOINTS = "efencePoints";//围栏数据点以“|”隔开
        public static final String STARTDATE = "startDate";
        public static final String ENDDATE = "endDate";
        public static final String ISENABLE = "isEnable";//围栏启用状态：0否；1是
        public static final String EFENCETYPE = "efenceType";//围栏类型  1圆形 2矩形    3多边形
        public static final String CUSTOMERID = "customerid";//用户id
    }

    /**
     * 获取围栏数据
     */
    public final class GetEfenceInfoByProductId {
        public static final String GETEFENCEINFOBYPRODUCTID_API = "interfaceController/getEfenceInfoByProductId";
        public static final String PRODUCTID = "productId";
        public static final String CUSTOMERID = "customerid";//用户id
        public static final String IDC = "idc";

    }


    /**
     * 获取拆除及预警未读信息
     */
    public final class GetAlarmUnreadNum {
        public static final String GetAlarmUnreadNum_API = "interfaceController/getAlarmUnreadNum";
        public static final String IDC = "idc";
        public static final String DISMANTLE_ID = "dismantleID";//拆除预警最大ID
        public static final String EFENCE_ID = "efenceID";//围栏最大ID
    }


    /**
     * 获取地理位置
     */
    public final class GetWarningGPS {
        public static final String GETWARNINGGPS_API = "interfaceController/getWarningGPS";
        public static final String LATITUDE = "latitude";
        public static final String LONGITUDE = "longitude";
        public static final String EFENCEPOINTS = "efencePoints";//围栏点集合
        public static final String EFENCETYPE = "efenceType";//围栏类型
    }

    /**
     * 根据用户id获取审核状态接口
     */
    public final class GetInfoByCustomerId {
        public static final String GETINFOBYCUSTOMERID_API = "interfaceController/getInfoByCustomerId";
        public static final String CUSTOMERID = "customerid";//用户id
    }

}
