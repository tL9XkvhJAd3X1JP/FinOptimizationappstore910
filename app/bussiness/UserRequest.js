//import MyLoading from "../components/MyLoading";
import UrlHelper from "../bussiness/UrlHelper";
import { postFetch } from "../network/request/HttpExtension";
export default class UserRequest {
  static getInstance = () => {
    return new UserRequest();
  };
  baseRequest = (actionName, param, okCallBack, errorCallBack) => {
    postFetch(actionName, param).then(response => {
      //                     if (this.state.warnLoaded2) {
      //                     this.refs.MyLoading.dismissLoading();
      //                     }
      if (response) {
        if (global.Code.SUCESS == response.code) {
          okCallBack(response.data, response.message, param);
        } else {
          //                           alert(response.message);
          errorCallBack(response.message, param);
        }
      } else {
        errorCallBack("", param);
      }
    });
  };
  //6.6    登陆－loginInfo
  loginInfo = (param, okCallBack, errorCallBack) => {
    this.baseRequest("/interfaceController/loginInfo", param, okCallBack, errorCallBack);
  };
  //选田车列表
  getVehicleScreening = (param, okCallBack, errorCallBack) => {
    this.baseRequest("/interfaceController/getVehicleScreening", param, okCallBack, errorCallBack);
  };
  //6.12    获取报警信息列表接口－getAlarmList
  getAlarmList = (param, okCallBack, errorCallBack) => {
    this.baseRequest("/interfaceController/getAlarmList", param, okCallBack, errorCallBack);
  };
  //6.15	报警详细信息
  getWarningGPS = (param, okCallBack, errorCallBack) => {
    this.baseRequest(
      global.urlInterface.GetWarningGPS.GetWarningGPSInterface,
      param,
      okCallBack,
      errorCallBack
    );
  };
  //检测升级
  checkUpgrade = (param, okCallBack, errorCallBack) => {
    this.baseRequest(
      global.urlInterface.ChannelClient.ChannelClientInterface,
      param,
      okCallBack,
      errorCallBack
    );
  };
  //修改密码
  updatePassword = (param, okCallBack, errorCallBack) => {
    this.baseRequest(
      global.urlInterface.UpdatePassword.UpdatePasswordInterface,
      param,
      okCallBack,
      errorCallBack
    );
  };
  //异常聚集位置转换
  gpsToBaiduPoints = (param, okCallBack, errorCallBack) => {
    this.baseRequest(
      global.urlInterface.GpsToBaiduPoints.GpsToBaiduPointsInterface,
      param,
      okCallBack,
      errorCallBack
    );
  };
  //获取聚集列表报警信息列表接口－getAbnormalGatherRecord
  getAbnormalGatherRecord = (param, okCallBack, errorCallBack) => {
    this.baseRequest(
      "/interfaceController/getAbnormalGatherRecord",
      param,
      okCallBack,
      errorCallBack
    );
  };
  //获取报警类型(没有配置的不显示)
  getWarnRecord = (param, okCallBack, errorCallBack) => {
    this.baseRequest(
      global.urlInterface.GetParameters.GetParametersInterface,
      param,
      okCallBack,
      errorCallBack
    );
  };
}

//module.exports = {
//    loginInfo,
//
//};
//export {
//    loginInfo,
//};
