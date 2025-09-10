package com.finoptimization.bean;

import org.litepal.annotation.Column;
import org.litepal.crud.LitePalSupport;

/**
 * Created by Ryan on 2019/1/30.
 */
public class User extends LitePalSupport {

    //        private String customername;//姓名
//        private Integer sex;//性别 男:1,女:2
//        private String mobilephone;//手机号码
//        private String loginname;//登录用户名
//        private String password;//登录密码
//        private String idnumber;//身份证号码
//        private String linkmanname;//紧急联系人姓名
//        private Integer linkmansex;//联系人性别 男:1,女:2
//        private String linkmanphone;//紧急联系人电话
//        private String linkmanidnumber;//紧急联系人身份证号码
//        private String frontidcard;//使用人身份证正面照片
//        private String reverseidcard;//使用人身份证反面照片
//        private String frontphoto;//正面免冠照片
//        private String againsttheft;//防盗账号
//        private String volunteer;//志愿者
//        private Integer state;//1:未通过审核,2:通过审核
//        private Date createddate;//创建时间
//        private String createdby;//创建人
//        private Date modifydate;//修改时间
//        private String modifyby;//修改人
//        private String brand;//电动车品牌
//        private String generatornumber;//电动车车机号
//        private String vin;//车架号
//        private String bikephoto;//电动车上牌后照片
//        private String userprove;//电动车使用证明
//        private String sn;//SN
//        private String idc;//idc
//        private String imei;//防盗定位终端设备IMEI码
//        private Long customerid;//会员表主键
//        private String paltenumber;//车牌号
//        private String color;//电动车颜色
//        private Date buytime;//购买时间
//        private Integer accidentinsurance;//驾驶人意外保险,1:50/年,2:100/年,3:200/年
//        private Integer companyid;//公司Id(派出所)
//        private Integer groupid;//小组Id(村委会)
//        private String companyName;//公司名称(派出所)
//        private String groupName;//小组名称(村委会)

    private String customername;
    private int sex;
    private String mobilephone;
    private String loginname;
    private String password;
    private String idnumber;
    private String linkmanname;
    private int linkmansex;
    private String linkmanphone;
    private String linkmanidnumber;
    private String frontidcard;
    private String reverseidcard;
    private String frontphoto;
    private String againsttheft;
    private String volunteer;
    private int state;////1:待审核,2:通过审核,3:未通过审核
    private String createddate;
    private String createdby;
    private String brand;
    private String generatornumber;
    private String vin;
    private String bikephoto;
    private String userprove;
    private String sn;
    private String idc;
    private String imei;
    @Column(unique = true, defaultValue = "-1")  // 唯一，默认值
    private String customerid;
    private String paltenumber;
    private String color;
    private String buytime;
    private int accidentinsurance;
    private long companyid;
    private long groupid;
    private String companyName;//公司名称(派出所)
    private String groupName;//小组名称(村委会)
    private String productId; //设备id
    @Column(defaultValue = "0")
    private int unReadEfenceAlarmMaxId;//未读围栏报警最大id
    @Column(defaultValue = "0")
    private int unReadRemovedAlarmMaxId;//未读拆除报警最大id
    private String bindingDate;// 设备绑定时间;
    private String token;//令牌 -1代表token超时，需要重新登陆。

    public String getCustomername() {
        return customername;
    }

    public void setCustomername(String customername) {
        this.customername = customername;
    }

    public int getSex() {
        return sex;
    }

    public void setSex(int sex) {
        this.sex = sex;
    }

    public String getMobilephone() {
        return mobilephone;
    }

    public void setMobilephone(String mobilephone) {
        this.mobilephone = mobilephone;
    }

    public String getLoginname() {
        return loginname;
    }

    public void setLoginname(String loginname) {
        this.loginname = loginname;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getIdnumber() {
        return idnumber;
    }

    public void setIdnumber(String idnumber) {
        this.idnumber = idnumber;
    }

    public String getLinkmanname() {
        return linkmanname;
    }

    public void setLinkmanname(String linkmanname) {
        this.linkmanname = linkmanname;
    }

    public int getLinkmansex() {
        return linkmansex;
    }

    public void setLinkmansex(int linkmansex) {
        this.linkmansex = linkmansex;
    }

    public String getLinkmanphone() {
        return linkmanphone;
    }

    public void setLinkmanphone(String linkmanphone) {
        this.linkmanphone = linkmanphone;
    }

    public String getLinkmanidnumber() {
        return linkmanidnumber;
    }

    public void setLinkmanidnumber(String linkmanidnumber) {
        this.linkmanidnumber = linkmanidnumber;
    }

    public String getFrontidcard() {
        return frontidcard;
    }

    public void setFrontidcard(String frontidcard) {
        this.frontidcard = frontidcard;
    }

    public String getReverseidcard() {
        return reverseidcard;
    }

    public void setReverseidcard(String reverseidcard) {
        this.reverseidcard = reverseidcard;
    }

    public String getFrontphoto() {
        return frontphoto;
    }

    public void setFrontphoto(String frontphoto) {
        this.frontphoto = frontphoto;
    }

    public String getAgainsttheft() {
        return againsttheft;
    }

    public void setAgainsttheft(String againsttheft) {
        this.againsttheft = againsttheft;
    }

    public String getVolunteer() {
        return volunteer;
    }

    public void setVolunteer(String volunteer) {
        this.volunteer = volunteer;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public String getCreateddate() {
        return createddate;
    }

    public void setCreateddate(String createddate) {
        this.createddate = createddate;
    }

    public String getCreatedby() {
        return createdby;
    }

    public void setCreatedby(String createdby) {
        this.createdby = createdby;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getGeneratornumber() {
        return generatornumber;
    }

    public void setGeneratornumber(String generatornumber) {
        this.generatornumber = generatornumber;
    }

    public String getVin() {
        return vin;
    }

    public void setVin(String vin) {
        this.vin = vin;
    }

    public String getBikephoto() {
        return bikephoto;
    }

    public void setBikephoto(String bikephoto) {
        this.bikephoto = bikephoto;
    }

    public String getUserprove() {
        return userprove;
    }

    public void setUserprove(String userprove) {
        this.userprove = userprove;
    }

    public String getSn() {
        return sn;
    }

    public void setSn(String sn) {
        this.sn = sn;
    }

    public String getIdc() {
        return idc;
    }

    public void setIdc(String idc) {
        this.idc = idc;
    }

    public String getImei() {
        return imei;
    }

    public void setImei(String imei) {
        this.imei = imei;
    }

    public String getCustomerid() {
        return customerid;
    }

    public void setCustomerid(String customerid) {
        this.customerid = customerid;
    }

    public String getPaltenumber() {
        return paltenumber;
    }

    public void setPaltenumber(String paltenumber) {
        this.paltenumber = paltenumber;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getBuytime() {
        return buytime;
    }

    public void setBuytime(String buytime) {
        this.buytime = buytime;
    }

    public int getAccidentinsurance() {
        return accidentinsurance;
    }

    public void setAccidentinsurance(int accidentinsurance) {
        this.accidentinsurance = accidentinsurance;
    }

    public long getCompanyid() {
        return companyid;
    }

    public void setCompanyid(long companyid) {
        this.companyid = companyid;
    }

    public long getGroupid() {
        return groupid;
    }

    public void setGroupid(long groupid) {
        this.groupid = groupid;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public int getUnReadEfenceAlarmMaxId() {
        return unReadEfenceAlarmMaxId;
    }

    public void setUnReadEfenceAlarmMaxId(int unReadEfenceAlarmMaxId) {
        this.unReadEfenceAlarmMaxId = unReadEfenceAlarmMaxId;
    }

    public int getUnReadRemovedAlarmMaxId() {
        return unReadRemovedAlarmMaxId;
    }

    public void setUnReadRemovedAlarmMaxId(int unReadRemovedAlarmMaxId) {
        this.unReadRemovedAlarmMaxId = unReadRemovedAlarmMaxId;
    }

    public String getBindingDate() {
        return bindingDate;
    }

    public void setBindingDate(String bindingDate) {
        this.bindingDate = bindingDate;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}
