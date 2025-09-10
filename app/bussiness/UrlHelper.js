global.Code = {
  SUCESS: "10000",
  OVER_TIME: "-1"
};
global.urlInterface = {
  // 预警中心 getAlarmEfenceRecord (6.电子围栏，9.风险点，7.家，8.工作单位)
  AlarmEfenceRecord: {
    //接口
    AlarmEfenceRecordInterface: "/interfaceController/getAlarmEfenceRecord",
    //参数 公司id
    companyId: "companyId"
  },
  //预警中心 getAlarmRecord (1、碰撞报警；2、拆除报警；3、低电量报警；4、日里程异常报警；5、月里程异常报警；10、长时间离线)
  AlarmRecord: {
    //接口
    AlarmRecordInterface: "/interfaceController/getAlarmRecord",
    //参数 公司id
    companyId: "companyId"
  },
  GetAllAlarm: {
    //接口
    GetAllAlarmInterface: "/interfaceController/getAllAlarm",
    //参数 公司id
    companyId: "companyId"
  },
  //获取车辆档案
  VehicleFileInfo: {
    VehicleFileInfoInterface: "/interfaceController/getVehicleFileInfo",
    cusId: "cusId", //用户id
    companyId: "companyId" //公司id
  },
  //预警处理
  InsertAlarmDeal: {
    InsertAlarmDealInterface: "/interfaceController/insertAlarmDeal",
    alarmId: "alarmId", //报警表主键 必填
    alarmType: "alarmType", //报警类型 必填
    state: "state", //处理状态 0-未处理 1-排查中 2-已处理 3-忽略 必填
    situation: "situation", //排查情况
    faultReason: "faultReason", //故障原因
    processingMode: "processingMode", //处理方式
    processingResult: "processingResult", //处理结果
    processingExplain: "processingExplain", //处理说明
    modifyUserId: "modifyUserId" //最后处理人id 必填
  },
  //轨迹回放
  GetGPStrack: {
    GetGPStrackInterface: "/interfaceController/getGPStrack",
    idc: "idc", //设备idc
    starttime: "starttime", //	开始时间
    endtime: "endtime" //	结束时间
  },
  //控制
  RemoteControl: {
    RemoteControlInterface: "/interfaceController/remoteControl",
    idc: "idc",
    devId: "devId", //设备id
    vType: "vType", //B100：拦截  B101：恢复
    userId: "userId"
  },
  //参数设置
  SetDevicePara: {
    SetDeviceParaInterface: "/interfaceController/setDevicePara",
    id: "id", //	设备主键id
    pushType: "pushType", //	下发类型 设备类型
    pushContent: "pushContent", //	下发内容 如果type=0,则是秒数 如果type=1，则是时间点（时分），多个时用逗号隔开
    userId: "userId", //	登陆账号的id
    companyId: "companyId", //	公司id
    type: "type", //设置时间格式类型 ０：按时间间隔 １：按固定时间点
    idc: "idc"
  },
  //获取车辆当前位置
  GetCurrentGPS: {
    GetCurrentGPSInferface: "/interfaceController/getCurrentGPS",
    idc: "idc"
  },
  //获取报警详细信息
  GetWarningGPS: {
    GetWarningGPSInterface: "/interfaceController/getWarningGPS",
    latitude: "latitude",
    longitude: "longitude",
    efencePoints: "efencePoints",
    efenceType: "efenceType" //1：圆形 3：多边形
  },
  //获取资源接口
  ChannelClient: {
    // ChannelClientInterface: "/version/channelClient",
    ChannelClientInterface: "/interfaceController/channelClient",
    clientType: "clientType", //1 android 2.ios
    CustomerFlag: "CustomerFlag" //客户标识
  },
  //修改密码
  UpdatePassword: {
    UpdatePasswordInterface: "/interfaceController/updatePassword",
    username: "username",
    password: "password",
    newpassword: "newpassword"
  },
  //登录
  LoginInfo: {
    LoginInfoInterface: "/interfaceController/loginInfo"
  },
  //异常聚集位置转换
  GpsToBaiduPoints: {
    GpsToBaiduPointsInterface: "/interfaceController/gpsToBaiduPoints",
    positionList: "positionList"
  },
  //根据公司id查询报警类型
  GetParameters: {
    GetParametersInterface: "/interfaceController/getParameters",
    companyId: "companyId",
    isWeb: "isWeb"
  }
};
