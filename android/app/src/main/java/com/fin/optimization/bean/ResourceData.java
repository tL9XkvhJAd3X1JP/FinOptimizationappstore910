package com.fin.optimization.bean;

/**
 * Created by Ryan on 2019/4/23.
 */
public class ResourceData {


    /**
     * id : 48
     * versionCode : 1
     * versionName : 1.0.1
     * minVersionCode : 0
     * instruction : 金融风控
     * clientDownUrl : http://wsm1.wiselink.net.cn/yycx/yiyi1.0.3.apk
     * clientType : 1
     * isForced : 0
     * customerFlag : FIN
     * businessInterfaceAddress : http://192.168.10.190:8765/interfaceController/
     * businessInterfaceAddress_ssl : https://192.168.10.194:8770/evrental/
     * innerBusinessInterfaceAddress_ssl : https://192.168.43.67:8770/evrental/
     * upgradeType : 1
     * createDate : 1498223482000
     * modifyDate : 1555902853000
     * fileInterfaceAddress : http://118.26.142.213:8080
     */

    private int id;
    private String versionCode;
    private String versionName;
    private String minVersionCode;
    private String instruction;
    private String clientDownUrl;
    private int clientType;
    private int isForced;
    private String customerFlag;
    private String businessInterfaceAddress;
    private String businessInterfaceAddress_ssl;
    private String innerBusinessInterfaceAddress_ssl;
    private int upgradeType;
    private long createDate;
    private long modifyDate;
    private String fileInterfaceAddress;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getVersionCode() {
        return versionCode;
    }

    public void setVersionCode(String versionCode) {
        this.versionCode = versionCode;
    }

    public String getVersionName() {
        return versionName;
    }

    public void setVersionName(String versionName) {
        this.versionName = versionName;
    }

    public String getMinVersionCode() {
        return minVersionCode;
    }

    public void setMinVersionCode(String minVersionCode) {
        this.minVersionCode = minVersionCode;
    }

    public String getInstruction() {
        return instruction;
    }

    public void setInstruction(String instruction) {
        this.instruction = instruction;
    }

    public String getClientDownUrl() {
        return clientDownUrl;
    }

    public void setClientDownUrl(String clientDownUrl) {
        this.clientDownUrl = clientDownUrl;
    }

    public int getClientType() {
        return clientType;
    }

    public void setClientType(int clientType) {
        this.clientType = clientType;
    }

    public int getIsForced() {
        return isForced;
    }

    public void setIsForced(int isForced) {
        this.isForced = isForced;
    }

    public String getCustomerFlag() {
        return customerFlag;
    }

    public void setCustomerFlag(String customerFlag) {
        this.customerFlag = customerFlag;
    }

    public String getBusinessInterfaceAddress() {
        return businessInterfaceAddress;
    }

    public void setBusinessInterfaceAddress(String businessInterfaceAddress) {
        this.businessInterfaceAddress = businessInterfaceAddress;
    }

    public String getBusinessInterfaceAddress_ssl() {
        return businessInterfaceAddress_ssl;
    }

    public void setBusinessInterfaceAddress_ssl(String businessInterfaceAddress_ssl) {
        this.businessInterfaceAddress_ssl = businessInterfaceAddress_ssl;
    }

    public String getInnerBusinessInterfaceAddress_ssl() {
        return innerBusinessInterfaceAddress_ssl;
    }

    public void setInnerBusinessInterfaceAddress_ssl(String innerBusinessInterfaceAddress_ssl) {
        this.innerBusinessInterfaceAddress_ssl = innerBusinessInterfaceAddress_ssl;
    }

    public int getUpgradeType() {
        return upgradeType;
    }

    public void setUpgradeType(int upgradeType) {
        this.upgradeType = upgradeType;
    }

    public long getCreateDate() {
        return createDate;
    }

    public void setCreateDate(long createDate) {
        this.createDate = createDate;
    }

    public long getModifyDate() {
        return modifyDate;
    }

    public void setModifyDate(long modifyDate) {
        this.modifyDate = modifyDate;
    }

    public String getFileInterfaceAddress() {
        return fileInterfaceAddress;
    }

    public void setFileInterfaceAddress(String fileInterfaceAddress) {
        this.fileInterfaceAddress = fileInterfaceAddress;
    }
}
