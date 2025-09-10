package com.finoptimization.bean;

public class UserBean extends BaseBean {


    /**
     * isSuccess : true
     * code : 10000
     * message : 查询成功
     * data : {"id":9,"customername":"xiong","sex":1,"mobilephone":"11111111111","loginname":"ttt","password":"e10adc3949ba59abbe56e057f20f883e","idnumber":"222222","linkmanname":"558","linkmansex":1,"linkmanphone":"11111111112","linkmanidnumber":"55888","frontidcard":"","reverseidcard":"","frontphoto":"","againsttheft":"","volunteer":"","state":1,"createddate":1548753962000,"createdby":"0","brand":"jj","generatornumber":"hh","vin":"gg","bikephoto":"","userprove":"","sn":"","idc":"","imei":"","customerid":9,"paltenumber":"","color":"gh","buytime":1548691200000,"accidentinsurance":3,"companyid":254,"groupid":269}
     * data : {"customername":"xiong","sex":1,"mobilephone":"11111111111","loginname":"qqq","password":"e10adc3949ba59abbe56e057f20f883e","idnumber":"25588","linkmanname":"fgg","linkmansex":1,"linkmanphone":"12345678912","linkmanidnumber":"jjjj","frontidcard":"http://118.26.142.213:8080/","reverseidcard":"http://118.26.142.213:8080/","frontphoto":"http://118.26.142.213:8080/","againsttheft":"","volunteer":"","state":1,"createddate":"2019-02-15 17:51:22","createdby":"0","brand":"jjj","generatornumber":"jjj","vin":"hgg","bikephoto":"http://118.26.142.213:8080/","userprove":"http://118.26.142.213:8080/","sn":"","idc":"","imei":"","customerid":14,"paltenumber":"","color":"ggg","buytime":"2019-02-15 00:00:00","accidentinsurance":2,"companyid":256,"groupid":272,"vCode":"7480"}}
     */

    private User data;

    public User getData() {
        return data;
    }

    public void setData(User data) {
        this.data = data;
    }

}
