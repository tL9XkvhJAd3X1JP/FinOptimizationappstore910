package com.finoptimization.bean;

/**
 * 作者：WangJintao
 * 时间：2018/5/14
 * 邮箱：wangjintao1988@163.com
 */
public class ResourceBean extends BaseBean {


    /**
     * isSuccess : false
     * code : 10000
     * message : 操作成功！
     * data : {"versionCode":"1","versionName":"1.0.1","instruction":"智信科源","clientDownUrl":"http://wsm1.wiselink.net.cn/yycx/yiyi1.0.3.apk","createdate":"","clientType":1,"isForced":0,"businessInterfaceAddress":"http://192.168.10.190:18080/evrental/","businessInterfaceAddress_ssl":"http://192.168.10.190:18080/evrental/","fileInterfaceAddress":"http://118.26.142.213:8080/travelplatform/upload","minVersionCode":"0","uploadBluetoothDataUrl":"https://test1.wiselink.net.cn:8443/bluetoothapi/","innerBusinessInterfaceAddress_ssl":"http://192.168.10.190:18080/evrental/"}
     * androidData : null
     */

    private DataBean data;
    private Object androidData;

    public DataBean getData() {
        return data;
    }

    public void setData(DataBean data) {
        this.data = data;
    }

    public Object getAndroidData() {
        return androidData;
    }

    public void setAndroidData(Object androidData) {
        this.androidData = androidData;
    }

    public static class DataBean {
        /**
         * versionCode : 1
         * versionName : 1.0.1
         * instruction : 智信科源
         * clientDownUrl : http://wsm1.wiselink.net.cn/yycx/yiyi1.0.3.apk
         * createdate :
         * clientType : 1
         * isForced : 0
         * businessInterfaceAddress : http://192.168.10.190:18080/evrental/
         * businessInterfaceAddress_ssl : http://192.168.10.190:18080/evrental/
         * fileInterfaceAddress : http://118.26.142.213:8080/travelplatform/upload
         * minVersionCode : 0
         * uploadBluetoothDataUrl : https://test1.wiselink.net.cn:8443/bluetoothapi/
         * innerBusinessInterfaceAddress_ssl : http://192.168.10.190:18080/evrental/
         */

        private String versionCode;
        private String versionName;
        private String instruction;
        private String clientDownUrl;
        private String createdate;
        private int clientType;
        private int isForced;
        private String businessInterfaceAddress;
        private String businessInterfaceAddress_ssl;
        private String fileInterfaceAddress;
        private String minVersionCode;
        private String uploadBluetoothDataUrl;
        private String innerBusinessInterfaceAddress_ssl;

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

        public String getCreatedate() {
            return createdate;
        }

        public void setCreatedate(String createdate) {
            this.createdate = createdate;
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

        public String getFileInterfaceAddress() {
            return fileInterfaceAddress;
        }

        public void setFileInterfaceAddress(String fileInterfaceAddress) {
            this.fileInterfaceAddress = fileInterfaceAddress;
        }

        public String getMinVersionCode() {
            return minVersionCode;
        }

        public void setMinVersionCode(String minVersionCode) {
            this.minVersionCode = minVersionCode;
        }

        public String getUploadBluetoothDataUrl() {
            return uploadBluetoothDataUrl;
        }

        public void setUploadBluetoothDataUrl(String uploadBluetoothDataUrl) {
            this.uploadBluetoothDataUrl = uploadBluetoothDataUrl;
        }

        public String getInnerBusinessInterfaceAddress_ssl() {
            return innerBusinessInterfaceAddress_ssl;
        }

        public void setInnerBusinessInterfaceAddress_ssl(String innerBusinessInterfaceAddress_ssl) {
            this.innerBusinessInterfaceAddress_ssl = innerBusinessInterfaceAddress_ssl;
        }
    }
}
