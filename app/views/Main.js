import React, { Component } from "react";
import {
  Alert,
  View,
  Text,
  Image,
  StatusBar,
  StyleSheet,
  TouchableWithoutFeedback,
  FlatList,
  NativeModules,
  DeviceEventEmitter,
  AppState,
  BackHandler
} from "react-native";
import Images from "../resource/Images";
import TitleBar from "../components/TitleBar";
import ScrollableTabView from "react-native-scrollable-tab-view";
import DefaultLeftIconTabBar from "../components/DefaultLeftIconTabBar";
import Button from "../components/Button";
import Global from "../Global";
import { postFetch } from "../network/request/HttpExtension";
import UrlHelper from "../bussiness/UrlHelper";
import MyLoading from "../components/MyLoading";
import PopView2 from "../components/PopView2";
import PopView4 from "../components/PopView4";
import PopView3 from "../components/PopView3";
import JsonUtils from "../utils/JsonUtils";
import moment from "moment";

import { MapView, BaiduMapMarker, Location } from "react-native-baidumap-sdk";

export default class Main extends Component {
  objData = {};
  device = {};
  location = null;
  timeoutLocation = null;
  constructor(props) {
    super(props);
    this.state = {
      title: global.userAccount.principal ? "车辆监控" : "预警中心",
      leftImg: global.userAccount.principal
        ? null
        : Images.common.title_refresh,
      rightImg: global.userAccount.principal
        ? Images.common.select_car
        : Images.common.title_deal,
      leftDisable: global.userAccount.principal ? true : false,
      page: global.userAccount.principal ? 0 : 1,
      appState: AppState.currentState
    };
  }

  init() {
    AppState.addEventListener("change", this._handleAppStateChange);

    BackHandler.addEventListener("hardwareBackPress", this.onBackPressed);

    if (!global.userAccount.principal) {
      this.requestWarnData();
    }

    this.checkUpgrade();
    registEventAction("refrehCarMonitor", data => {
      //刷新 设备
      this.refs.ContentView.refs.CarMonitor.refs.Marker.setState({
        data: null//清空地图mark
      });
      var objData = JSON.parse(data);
      var length = objData.proInfo.length;
      this.refs.ContentView.refs.CarMonitor.refs.OnLineState.setState({
        data: objData.proInfo,
        selectPosition: length == 0 ? -1 : 0
      });
      //刷新 是否显示拦截控制
      this.refs.ContentView.refs.CarMonitor.refs.MonitorImage.setState({
        showControlImage:
          length != 0 &&
          (objData.proInfo[0].productTypeID == 3 ||
            objData.proInfo[0].productTypeID == 5),
        showOtherImage: length != 0,
        cusId: objData ? objData.id : -1
      });
      //刷新 刷新按钮
      this.refs.ContentView.refs.CarMonitor.refs.Refresh.setState({
        show: length != 0
      });
      //刷新 位置按钮
      this.refs.ContentView.refs.CarMonitor.refs.CarLocation.setState({
        show: length != 0
      });
      //获取位置
      if (length != 0) {
        this.requestLocation(objData, objData.proInfo[0]);
      } else {
        showToastMessage("该车辆未安装设备！");
      }
    });

    registEventAction("dealState3", state => {
      //处理报警后，刷新列表
      this.requestWarnData();
    });
  }

  //检测升级
  checkUpgrade = () => {
    const params = new Map();
    params.set(
      global.urlInterface.ChannelClient.clientType,
      Global.ios ? 2 : 1
    );
    params.set(
      global.urlInterface.ChannelClient.CustomerFlag,
      Global.CustomerFlag
    );
    UserRequest.getInstance().checkUpgrade(
      params,
      data => {
        if (Global.android) {
          //保存本地
          NativeModules.AndroidUtils.saveUrl(JSON.stringify(data));
        }
        this.checkVersionCode(data);
      },
      error => {
        // showToastMessage(error);
      }
    );
  };

  //检测升级
  checkVersionCode = data => {
    try {
      if (
        parseInt(
          Global.ios ? Global.iosVersionCode : Global.androidVersionCode
        ) < parseInt(data.versionCode)
      ) {
        if (data.clientDownUrl) {
          this.clientDownUrl = data.clientDownUrl;
          //升级
          this.refs.popView2.setState({
            isHiden: false,
            actionView: this,
            message: "检测到新版本,是否确定升级?",
            title: "提示",
            messageId: 1000
          });
        }
      }
    } catch (error) {}
  };

  componentDidMount() {
    // if (this.location == null) {
    //   this.requestBaiduLocation();
    //   if (this.timeoutLocation != null) {
    //     Location.stop();
    //     clearTimeout(this.timeoutLocation);
    //     this.timeoutLocation = null;
    //   }
    //   this.timeoutLocation = setTimeout(() => {
    //     Location.stop();
    //   }, 10000);
    // }

    //初始化列表，防止白屏
    // this.refs.ContentView.refs.WarnList.setState({
    //   warnData: this.refs.ContentView.refs.WarnList.warnDataDefault
    // });

    // if (Global.android) {
    //   setTimeout(() => {
    //     NativeModules.SplashScreen.hide();
    //   }, 1000);
    //   if (this.props.object != null) {
    //     global.versionAndUrlModel = JSON.parse(this.props.object);
    //   }
    //   if ("WelcomeActivity" == this.props.from) {
    //     setTimeout(() => {
    //       NativeModules.AndroidUtils.finishAllActivityExcludeLast();
    //     }, 1000);
    //   }
    // }
    // if (!global.versionAndUrlModel) {
    //   getVersionAndUrlModel(data => {
    //     global.versionAndUrlModel = JSON.parse(data);
    //     this.initUserData();
    //   });
    // } else {
    //   this.initUserData();
    // }
    if (Global.android) {
      if ("finishOther" == this.props.object) {
        NativeModules.AndroidUtils.finishAllActivityExcludeLast();
      }
    }
    this.init();
  }

  requestLocation = (objData, device, showLoading = false) => {
    this.objData = objData;
    this.device = device;
    const param = new Map();
    param.set(global.urlInterface.GetCurrentGPS.idc, device.IDC);
    if (showLoading) {
      this.refs.MyLoading.showLoading();
    }
    postFetch(
      global.urlInterface.GetCurrentGPS.GetCurrentGPSInferface,
      param
    ).then(response => {
      this.refs.MyLoading.dismissLoading();
      if (response) {
        if (global.Code.SUCESS == response.code) {
          var data = {};
          data.longitude = response.data.longitude;
          data.latitude = response.data.latitude;
          data.address = response.data.address;
          data.speed = response.data.speed;
          data.accState = response.data.accState;
          data.salState = response.data.salState;
          data.bindState = response.data.bindState;
          data.direction = response.data.direction;
          data.name = objData.name;
          data.mobile = objData.mobile;
          data.platenumber = objData.platenumber;
          data.VIN = objData.VIN;
          data.salCount = response.data.salCount; //剩余电量
          data.productTypeID = device.productTypeID;
          data.gpsTime = moment(response.data.gpsTime).format(
            "YYYY-MM-DD HH:mm:ss"
          );

          setTimeout(() => {
            this.refs.ContentView.refs.CarMonitor.refs.Marker.setState({
              data: data,
              longitude: data.longitude,
              latitude: data.latitude
            });
          }, 100);

          setTimeout(() => {
            this.refs.ContentView.refs.CarMonitor.refs.MapView.setStatus(
              {
                center: {
                  latitude: data.latitude,
                  longitude: data.longitude
                }
              },
              1000
            );
          }, 500);
        } else {
          this.refs.ContentView.refs.CarMonitor.refs.Marker.setState({
            data: null,
            longitude: 0,
            latitude: 0
          });
          showToastMessage(response.message);
        }
      }
    });
  };

  refresh = () => {
    this.requestLocation(this.objData, this.device, true);
  };

  /**
   * 切换设备
   *
   * @memberof Main
   */
  popOkClick4 = (item, index) => {
    this.refs.ContentView.refs.CarMonitor.refs.OnLineState.setState({
      selectPosition: index
    });
    var objData = this.refs.ContentView.refs.CarMonitor.refs.OnLineState.state
      .data[index];
    this.refs.ContentView.refs.CarMonitor.refs.MonitorImage.setState({
      showControlImage: objData.productTypeID == 3 || objData.productTypeID == 5
    });
    this.refs.ContentView.refs.CarMonitor.refs.Marker.setState({
      data: null
    });
    this.requestLocation(this.objData, this.objData.proInfo[index]);
  };

  componentWillUnmount() {
    AppState.removeEventListener("change", this._handleAppStateChange);
    BackHandler.removeEventListener("hardwareBackPress", this.onBackPressed);
    removeEventAction("refrehCarMonitor");
    removeEventAction("dealState3");
    if (this.timeoutLocation != null) {
      Location.stop();
      clearTimeout(this.timeoutLocation);
      this.timeoutLocation = null;
    }
  }

  /**
   * 退出应用
   *
   * @memberof Main
   */
  onBackPressed = () => {
    // if(Global.android){
    //   BackHandler.exitApp();
    //   NativeModules.AndroidUtils.exitApp();
    //   return true;
    // }
  };

  _handleAppStateChange = nextAppState => {};

  //切换idc
  changeState = (selectPosition, idcList) => {
    this.refs.PopView4.setState({
      isHiden: false,
      actionView: this,
      title: "选择列表",
      data: idcList,
      selectedIndex: selectPosition
    });
  };

  /**
   * 获取预警中心数据(分两个接口获取)
   *
   * @memberof Main
   */
  requestWarnData1() {
    const param = new Map();
    param.set(
      global.urlInterface.AlarmEfenceRecord.companyId,
      global.userAccount.companyId
    );
    postFetch(
      global.urlInterface.AlarmEfenceRecord.AlarmEfenceRecordInterface,
      param
    ).then(response => {
      // this.setState({
      //   warnLoaded1: true
      // });
      // if (this.state.warnLoaded2) {
      this.refs.MyLoading.dismissLoading();
      // }
      if (global.Code.SUCESS == response.code) {
        this.refs.ContentView.refs.WarnList.dealWarnData(response.data);
      } else {
        showToastMessage(response.message);
      }
    });
  }

  /**
   * 获取预警中心数据(分两个接口获取)
   *
   * @memberof Main
   */
  requestWarnData2 = () => {
    const param = new Map();
    param.set(
      global.urlInterface.AlarmRecord.companyId,
      global.userAccount.companyId
    );
    postFetch(
      global.urlInterface.AlarmRecord.AlarmRecordInterface,
      param
    ).then(response => {
      // this.setState({
      //   warnLoaded2: true
      // });
      // if (this.state.warnLoaded1) {
      this.refs.MyLoading.dismissLoading();
      // }
      if (global.Code.SUCESS == response.code) {
        this.refs.ContentView.refs.WarnList.dealWarnData(response.data);
      } else {
        showToastMessage(response.message);
      }
    });
  };

  //requestWarnData1 和 requestWarnData2 合并
  requestWarnData = () => {
    // const param = new Map();
    // param.set(
    //   global.urlInterface.GetAllAlarm.companyId,
    //   global.userAccount.companyId
    // );
    // postFetch(
    //   global.urlInterface.GetAllAlarm.GetAllAlarmInterface,
    //   param
    // ).then(response => {
    //   this.refs.MyLoading.dismissLoading();
    //   if (response) {
    //     if (global.Code.SUCESS == response.code) {
    //       this.refs.ContentView.refs.WarnList.dealWarnData(response.data);
    //     } else {
    //       showToastMessage(response.message);
    //     }
    //   }
    // });
    const param1 = new Map();
    param1.set(
      global.urlInterface.AlarmEfenceRecord.companyId,
      global.userAccount.companyId
    );
    var requeset1 = postFetch(
      global.urlInterface.AlarmEfenceRecord.AlarmEfenceRecordInterface,
      param1
    );
    const param2 = new Map();
    param2.set(
      global.urlInterface.AlarmRecord.companyId,
      global.userAccount.companyId
    );
    var request2 = postFetch(
      global.urlInterface.AlarmRecord.AlarmRecordInterface,
      param2
    );
    const param3 = new Map();
    param3.set(
      global.urlInterface.GetParameters.companyId,
      global.userAccount.companyId
    );
    var requeset3 = postFetch(
      global.urlInterface.GetParameters.GetParametersInterface,
      param3
    );
    Promise.all([requeset1, request2, requeset3]).then(response => {
      this.refs.MyLoading.dismissLoading();
      if (response) {
        var data1 = response[0];
        var data2 = response[1];
        var data3 = response[2];
        var warnDataDefault = this.refs.ContentView.refs.WarnList.state
          .warnDataDefault;
        var warnList1 = [];
        var warnList2 = [];
        var warnShowOrNotList = [];
        if (data1 && data2 && data3) {
          if (data1 && global.Code.SUCESS == data1.code) {
            warnList1 = data1.data;
          } else {
            showToastMessage(data1.message);
          }
          if (data2 && global.Code.SUCESS == data2.code) {
            warnList2 = data2.data;
          } else {
            showToastMessage(data2.message);
          }
          if (data3 && global.Code.SUCESS == data3.code) {
            warnShowOrNotList = data3.data;
          } else {
            showToastMessage(data3.message);
          }
          var allWarn = [...warnList1, ...warnList2];
          warnDataDefault = this.dealWarnData(allWarn, warnDataDefault);
          warnDataDefault = this.dealShowOrNotWarnData(
            warnShowOrNotList,
            warnDataDefault
          );
          var warnShowList = warnDataDefault.filter(function(item) {
            //过滤显示的
            return item.isShow == 1;
          });
          var o = {};
          o.alarmType = -1;
          if (warnShowList.length % 2 == 0) {
            warnShowList.push(o);
          } else {
            warnShowList.push(o);
            warnShowList.push(o);
          }

          this.refs.ContentView.refs.WarnList.setState({
            warnData: warnShowList
          });
        }
      }
    });
  };

  dealShowOrNotWarnData(warnShowOrNotList, warnDataDefault) {
    if (warnShowOrNotList) {
      var length = warnShowOrNotList.length;
      if (length > 0) {
        warnDataDefault.forEach(element => {
          for (var i = 0; i < length; i++) {
            var hasFound = false;
            if (element.alarmType == warnShowOrNotList[i].alarmType) {
              element.isShow = warnShowOrNotList[i].isShow;
              element.alarmName = warnShowOrNotList[i].alarmTypeName;
              hasFound = true;
              break;
            }
          }
          if (!hasFound) {
            element.isShow = 0;
          }
        });
      }
    }
    return warnDataDefault;
  }

  dealWarnData(warnData, warnDataDefault) {
    if (warnData) {
      var length = warnData.length;
      if (length > 0) {
        warnDataDefault.forEach(element => {
          var hasFound = false;
          for (var i = 0; i < length; i++) {
            if (element.alarmType == warnData[i].alarmType) {
              element.alarmTypeCount = warnData[i].alarmTypeCount;
              hasFound = true;
              break;
            }
          }
          if (!hasFound) {
            element.alarmTypeCount = 0;
          }
        });
      }
    }
    return warnDataDefault;
  }

  popOkClick2 = code => {
    if (code == 1000) {
      //确定升级
      updateAppWithUrl(this.clientDownUrl);
    } else {
      this.remoteControl(code);
    }
  };

  showConfirm = code => {
    this.refs.popView2.setState({
      isHiden: false,
      actionView: this,
      message: "是否确定" + (code == 1 ? "设置拦截" : "取消拦截") + "?",
      title: "提示",
      messageId: code
    });
  };

  popOkClick3 = () => {
    // alert(this.refs.PopView3.selectedItem);
    // if (this.location == null) {
    //   this.refs.MyLoading.showLoading();
    //   this.requestBaiduLocation();
    //   if (this.timeoutLocation != null) {
    //     Location.stop();
    //     clearTimeout(this.timeoutLocation);
    //     this.timeoutLocation = null;
    //   }
    //   this.timeoutLocation = setTimeout(() => {
    //     this.refs.MyLoading.dismissLoading();
    //     Location.stop();
    //     alert("定位失败，请稍后重试！");
    //   }, 10000);
    // } else {
    //   alert(this.location.latitude + ",," + this.location.longitude);
    // }
    goToPlaceWithMap(
      this.refs.PopView3.selectedItem,
      this.refs.ContentView.refs.CarMonitor.refs.Marker.state.latitude,
      this.refs.ContentView.refs.CarMonitor.refs.Marker.state.longitude,
      this.refs.ContentView.refs.CarMonitor.refs.Marker.state.data.address
    );
  };

  async requestBaiduLocation() {
    await Location.init();
    Location.addLocationListener(location => {
      if (location.latitude && location.longitude) {
        this.location = location;
        if (this.timeoutLocation != null) {
          Location.stop();
          clearTimeout(this.timeoutLocation);
          this.timeoutLocation = null;
        }
      }
    });
    Location.start();
  }

  //追踪 导航
  trace = () => {
    this.refs.PopView3.setState({
      isHiden: false,
      actionView: this,
      title: "选择列表",
      data: ["百度地图", "高德地图", "腾讯地图"]
    });
  };

  /**
   * 远程控制
   *
   * @memberof Main
   */
  remoteControl = code => {
    this.refs.MyLoading.showLoading();
    const param = new Map();
    param.set(global.urlInterface.RemoteControl.idc, this.device.IDC);
    param.set(global.urlInterface.RemoteControl.devId, this.device.id);
    param.set(global.urlInterface.RemoteControl.vType, code);
    param.set(global.urlInterface.RemoteControl.userId, global.userAccount.id);
    postFetch(
      global.urlInterface.RemoteControl.RemoteControlInterface,
      param
    ).then(response => {
      this.refs.MyLoading.dismissLoading();
      if (response) {
        if (global.Code.SUCESS == response.code) {
          showToastMessage(response.message);
        } else {
          showToastMessage(response.message);
        }
      }
    });
  };

  onSelect(index) {
    if (index == 0 || index == 1) {
      this.setState({
        title: index == 0 ? "车辆监控" : "预警中心",
        leftImg: index == 0 ? null : Images.common.title_refresh,
        rightImg:
          index == 0 ? Images.common.select_car : Images.common.title_deal,
        leftDisable: index == 0 ? true : false,
        page: index
      });
    } else {
      navigateTo(global.navigation.PersionCenter);
    }
  }

  onLeftPress = () => {
    if (this.state.page == 1) {
      this.refs.MyLoading.showLoading();
      this.requestWarnData();
    }
  };

  onRightPress() {
    if (this.state.page == 0) {
      navigateTo(global.navigation.SelectCarList);
    } else {
      navigateTo(global.navigation.WarningList, "-1");
    }
  }

  order = () => {
    navigateTo(global.navigation.GpsSet, JSON.stringify(this.device));
  };

  trajectory = () => {
    navigateTo(
      null,
      this.device.IDC,
      "PlayBackViewController",
      null,
      "com.fin.optimization.activity.TrackPlayBackActivity"
    );
  };

  render() {
    return (
      <View style={{ flex: 1 }}>
        <StatusBar
          translucent={true}
          backgroundColor={"#00000000"} //状态栏背景颜色
          barStyle={"light-content"}
        />
        <TitleBar
          name={this.state.title}
          leftImg={this.state.leftImg}
          onLeftPress={() => this.onLeftPress()}
          rightImg={this.state.rightImg}
          onRightPress={() => this.onRightPress()}
          leftDisable={this.state.leftDisable}
        />
        <Content
          ref="ContentView"
          refresh={this.refresh}
          onSelect={index => this.onSelect(index)}
          showConfirm={this.showConfirm}
          changeState={this.changeState}
          trace={this.trace}
          order={this.order}
          trajectory={this.trajectory}
        />
        <PopView2 ref="popView2" />
        <PopView4 ref="PopView4" />
        <PopView3 ref="PopView3" />
        <MyLoading ref="MyLoading" />
      </View>
    );
  }
}

class Content extends Component {
  constructor(props) {
    super(props);
    this.state = {
      tabCheckedIconNames: [
        Images.common.monitor_checked,
        Images.common.warn_checked,
        Images.common.mine_checked
      ],
      tabUnCheckedIconNames: [
        Images.common.monitor_unchecked,
        Images.common.warn_unchecked,
        Images.common.mine_unchecked
      ]
    };
    this.onSelect = this.onSelect.bind(this);
  }

  onSelect(index) {
    if (index == 0 || index == 1) {
      this.tabView.goToPage(index);
    } else {
    }
    if (this.props.onSelect) {
      this.props.onSelect(index);
    }
  }

  showConfirm = code => {
    this.props.showConfirm(code);
  };

  shouldComponentUpdate(nextProps, nextState) {
    return nextProps.id !== this.props.id;
  }

  render() {
    let tabUnCheckedIconNames = this.state.tabUnCheckedIconNames;
    let tabCheckedIconNames = this.state.tabCheckedIconNames;
    return (
      <View style={{ flex: 1 }}>
        <ScrollableTabView
          ref={tabView => {
            this.tabView = tabView;
          }}
          //下划线颜色
          tabBarUnderlineStyle={{ backgroundColor: "#0e5db7", height: 0 }}
          //背景色
          tabBarBackgroundColor="#0e5db7"
          //选中字体颜色
          tabBarActiveTextColor="#00000000"
          //未选中字体颜色
          tabBarInactiveTextColor="#00000000"
          //禁止所有滑动
          scrollWithoutAnimation={true}
          //tabBar位置
          // tabBarPosition="bottom"
          //初始显示
          initialPage={global.userAccount.principal ? 0 : 1}
          //锁定滑动
          locked={true}
          //设置字体样式
          tabBarTextStyle={{
            fontSize: 0,
            fontStyle: "normal",
            fontWeight: "normal"
          }}
          //bar的默认样式
          renderTabBar={() =>
            <DefaultLeftIconTabBar
              style={{
                height: 0,
                borderWidth: 0,
                elevation: 0,
                marginLeft: 10,
                marginRight: 10
                // marginBottom: 10,
                // borderRadius: 4
              }}
              tabStyle={{
                height: 0,
                flexDirection: "column"
              }}
            />}
        >
          <View tabLabel="监控" style={{ flex: 1 }}>
            <CarMonitor
              ref="CarMonitor"
              refresh={this.props.refresh}
              showConfirm={this.showConfirm}
              changeState={this.props.changeState}
              trace={this.props.trace}
              order={this.props.order}
              trajectory={this.props.trajectory}
            />
          </View>
          {global.userAccount.principal
            ? null
            : <View tabLabel="预警" style={{ flex: 1 }}>
                <WarnList ref="WarnList" />
              </View>}
        </ScrollableTabView>

        <Menu
          onSelect={index => this.onSelect(index)}
          tabUnCheckedIconNames={tabUnCheckedIconNames}
          tabCheckedIconNames={tabCheckedIconNames}
          selectedIndex={global.userAccount.principal ? 0 : 1}
        />
      </View>
    );
  }
}

/**
 * 
 *  车辆监控
 * @class CarMonitor
 * @extends {Component}
 */
class CarMonitor extends Component {
  showConfirm = code => {
    this.props.showConfirm(code);
  };

  setStatus = () => {
    if (
      this.refs.Marker.state.latitude != 0 &&
      this.refs.Marker.state.longitude != 0
    ) {
      this.refs.MapView.setStatus(
        {
          center: {
            latitude: this.refs.Marker.state.latitude,
            longitude: this.refs.Marker.state.longitude
          }
        },
        2000
      );
    }
  };

  render() {
    return (
      <View style={{ flex: 1 }}>
        <MapView
          ref="MapView"
          style={{ flex: 1 }}
          zoomLevel={14}
          zoomControlsDisabled={true}
        >
          <Marker ref="Marker" />
        </MapView>
        <OnLineState ref="OnLineState" changeState={this.props.changeState} />
        <Refresh ref="Refresh" refresh={this.props.refresh} />
        <CarLocation ref="CarLocation" setStatus={this.setStatus} />
        <MonitorImage
          ref="MonitorImage"
          showConfirm={this.showConfirm}
          trace={this.props.trace}
          order={this.props.order}
          trajectory={this.props.trajectory}
        />
      </View>
    );
  }
}

class Marker extends Component {
  constructor(props) {
    super(props);
    this.state = {
      latitude: 0,
      longitude: 0,
      data: null
    };
  }

  // shouldComponentUpdate(nextProps, nextState) {
  //   return (
  //     this.state.latitude !== nextState.latitude ||
  //     this.state.longitude !== nextState.longitude
  //   );
  // }

  render() {
    var mark =
      this.state.latitude != 0 &&
      this.state.longitude != 0 &&
      this.state.data != null
        ? <MapView.Marker
            coordinate={{
              latitude: this.state.latitude,
              longitude: this.state.longitude
            }}
            selected={true}
            image="car_green"
          >
            <MapView.Callout>
              <View style={styles.callout}>
                <Text style={styles.popText}>
                  车牌号　：{this.state.data.platenumber}
                </Text>
                <Text style={styles.popText}>
                  车架号　：{this.state.data.VIN}
                </Text>
                <Text style={styles.popText}>
                  车主姓名：{this.state.data.name}
                </Text>
                <Text style={styles.popText}>
                  车主电话：{this.state.data.mobile}
                </Text>
                {/* 只有无线设备显示电量 */}
                {/* 非无线设备才显示Acc */}
                {this.state.data.productTypeID == 2
                  ? <Text style={styles.popText}>
                      剩余电量： {this.state.data.salCount}
                    </Text>
                  : <Text style={styles.popText}>
                      ACC状态：{this.state.data.accState == 1
                        ? "点火"
                        : this.state.data.accState == 0 ? "熄火" : ""}
                    </Text>}
                <Text style={styles.popText}>
                  定位类型：{this.state.data.bindState == 1
                    ? "GPS"
                    : this.state.data.bindState == 0 ? "基站" : ""}
                </Text>
                <Text style={styles.popText}>
                  在线状态：{this.state.data.salState == 1
                    ? "在线"
                    : this.state.data.salState == 0 ? "不在线" : ""}
                </Text>
                <Text style={styles.popText}>
                  定位时间：{this.state.data.gpsTime}
                </Text>
                <Text style={styles.popText}>
                  地　　址：{this.state.data.address}
                </Text>
              </View>
            </MapView.Callout>
          </MapView.Marker>
        : null;

    return mark;
  }
}

class CarLocation extends Component {
  constructor(props) {
    super(props);
    this.state = {
      show: false
    };
  }

  shouldComponentUpdate(nextProps, nextState) {
    return this.state.show !== nextState.show;
  }

  render() {
    return (
      <View>
        {this.state.show
          ? <TouchableWithoutFeedback onPress={() => this.props.setStatus()}>
              <Image
                source={Images.common.main_location}
                style={{
                  position: "absolute",
                  bottom: 100,
                  left: 15
                }}
              />
            </TouchableWithoutFeedback>
          : null}
      </View>
    );
  }
}

class Refresh extends Component {
  constructor(props) {
    super(props);
    this.state = {
      show: false
    };
  }

  shouldComponentUpdate(nextProps, nextState) {
    return this.state.show !== nextState.show;
  }

  render() {
    return (
      <View style={{ position: "absolute" }}>
        {this.state.show
          ? <TouchableWithoutFeedback onPress={() => this.props.refresh()}>
              <View style={styles.refresBtn}>
                <Image source={Images.common.monitor_online_state} />
                <Text style={styles.leftTopTextStyle}>刷新</Text>
              </View>
            </TouchableWithoutFeedback>
          : null}
      </View>
    );
  }
}

class MonitorImage extends Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      showControlImage: false,
      showOtherImage: false,
      cusId: -1
    };
  }

  shouldComponentUpdate(nextProps, nextState) {
    return (
      this.state.showControlImage !== nextState.showControlImage ||
      this.state.showOtherImage !== nextState.showOtherImage
    );
  }

  outage() {
    this.props.showConfirm(1);
  }

  power_supply() {
    this.props.showConfirm(2);
  }

  //gps 间隔时间
  order() {
    this.props.order();
  }

  //追踪  跳转第三方导航
  trace() {
    this.props.trace();
  }

  archives() {
    navigateTo(global.navigation.CarArchives, this.state.cusId + "");
  }

  trajectory() {
    this.props.trajectory();
  }

  render() {
    return (
      <View style={{ position: "absolute", right: 10, bottom: 100 + Global.safeAreaViewHeight }}>
        {this.state.showControlImage
          ? <View>
              <TouchableWithoutFeedback onPress={() => this.outage()}>
                <Image source={Images.common.monitor_outage} />
              </TouchableWithoutFeedback>
              <TouchableWithoutFeedback onPress={() => this.power_supply()}>
                <View style={{ marginTop: 10 }}>
                  <Image source={Images.common.monitor_power_supply} />
                </View>
              </TouchableWithoutFeedback>
            </View>
          : null}

        {this.state.showOtherImage
          ? <View>
              <TouchableWithoutFeedback onPress={() => this.order()}>
                <View style={{ marginTop: 10 }}>
                  <Image source={Images.common.monitor_order} />
                </View>
              </TouchableWithoutFeedback>
              <TouchableWithoutFeedback onPress={() => this.trace()}>
                <View style={{ marginTop: 10 }}>
                  <Image source={Images.common.monitor_trace} />
                </View>
              </TouchableWithoutFeedback>
              <TouchableWithoutFeedback onPress={() => this.archives()}>
                <View style={{ marginTop: 10 }}>
                  <Image source={Images.common.monitor_archives} />
                </View>
              </TouchableWithoutFeedback>
              <TouchableWithoutFeedback onPress={() => this.trajectory()}>
                <View style={{ marginTop: 10 }}>
                  <Image source={Images.common.monitor_trajectory} />
                </View>
              </TouchableWithoutFeedback>
            </View>
          : null}
      </View>
    );
  }
}

/**
 * 预警列表
 *
 * @class WarnList
 * @extends {Component}
 */
class WarnList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      //预警数据
      warnData: [],
      warnDataDefault: [
        {
          alarmType: 2,
          alarmTypeCount: 0,
          alarmName: "拆除报警",
          alarmImage: Images.common.alarm_remove,
          backgroundColor: "#d72229cc"
        },
        {
          alarmType: 1,
          alarmTypeCount: 0,
          alarmName: "碰撞报警",
          alarmImage: Images.common.alarm_collision,
          backgroundColor: "#e47615cc"
        },
        {
          alarmType: 9,
          alarmTypeCount: 0,
          alarmName: "黑区风险停留",
          alarmImage: Images.common.alarm_risk,
          backgroundColor: "#f5c500e6"
        },
        {
          alarmType: 10,
          alarmTypeCount: 0,
          alarmName: "长时间离线",
          alarmImage: Images.common.alarm_long_time_offline,
          backgroundColor: "#b1ce24cc"
        },
        {
          alarmType: 4,
          alarmTypeCount: 0,
          alarmName: "日里程异常",
          alarmImage: Images.common.alarm_exp_day,
          backgroundColor: "#48aa35cc"
        },
        {
          alarmType: 5,
          alarmTypeCount: 0,
          alarmName: "月里程异常",
          alarmImage: Images.common.alarm_exp_mon,
          backgroundColor: "#03944499"
        },
        {
          alarmType: 8,
          alarmTypeCount: 0,
          alarmName: "长时间不上班",
          alarmImage: Images.common.alarm_leave_office,
          backgroundColor: "#1b1bbb99"
        },
        {
          alarmType: 7,
          alarmTypeCount: 0,
          alarmName: "长时间不回家",
          alarmImage: Images.common.alarm_leave_home,
          backgroundColor: "#6f4d1d99"
        },
        {
          alarmType: 3,
          alarmTypeCount: 0,
          alarmName: "设备电池低电量",
          alarmImage: Images.common.alarm_low_power,
          backgroundColor: "#1d386f99"
        },
        {
          alarmType: 6,
          alarmTypeCount: 0,
          alarmName: "围栏报警",
          alarmImage: Images.common.alarm_enclosure,
          backgroundColor: "#51266399"
        },
        {
          alarmType: 11,
          alarmTypeCount: 0,
          alarmName: "超速报警",
          alarmImage: Images.common.speed_warn,
          backgroundColor: "#2280d7cc"
        },
        {
          alarmType: 12,
          alarmTypeCount: 0,
          alarmName: "出省报警",
          alarmImage: Images.common.out_province_warn,
          backgroundColor: "#c47c3ccc"
        },
        {
          alarmType: 13,
          alarmTypeCount: 0,
          alarmName: "出市报警",
          alarmImage: Images.common.out_city_warn,
          backgroundColor: "#228b76e6"
        },
        {
          alarmType: 14,
          alarmTypeCount: 0,
          alarmName: "VIN码匹配异常",
          alarmImage: Images.common.vin_warn,
          backgroundColor: "#316d74cc"
        },
        {
          alarmType: 15,
          alarmTypeCount: 0,
          alarmName: "主从设备分离",
          alarmImage: Images.common.device_diff,
          backgroundColor: "#1c7d09cc"
        },
        {
          alarmType: 16,
          alarmTypeCount: 0,
          alarmName: "车辆设备分离",
          alarmImage: Images.common.out_province_warn,
          backgroundColor: "#21734699"
        },
        {
          alarmType: 17,
          alarmTypeCount: 0,
          alarmName: "翻转报警",
          alarmImage: Images.common.turn_on_warn,
          backgroundColor: "#67240a99"
        },
        {
          alarmType: 18,
          alarmTypeCount: 0,
          alarmName: "电瓶低电压",
          alarmImage: Images.common.low_voltage_warn,
          backgroundColor: "#4b6f1d99"
        },
        {
          alarmType: 19,
          alarmTypeCount: 0,
          alarmName: "异常聚集",
          alarmImage: Images.common.together_warn,
          backgroundColor: "#63098999"
        }
      ]
    };
  }

  _keyExtractor = (item, index) => item.alarmType;

  _onPressItem = data => {
    if (data.alarmType == 19) {
      navigateTo(global.navigation.WarningList2, data.alarmType + "");
    } else {
      navigateTo(global.navigation.WarningList, data.alarmType + "");
    }
  };

  dealWarnData(warnData) {
    var length = warnData.length;
    if (warnData && length > 0) {
      var arr = this.state.warnDataDefault;
      arr.forEach(element => {
        var hasFound = false;
        for (var i = 0; i < length; i++) {
          if (element.alarmType == warnData[i].alarmType) {
            hasFound = true;
            element.alarmTypeCount = warnData[i].alarmTypeCount;
          }
        }
        if (!hasFound) {
          element.alarmTypeCount = 0;
        }
      });
      this.setState({
        warnData: arr
      });
    }
  }

  _renderItem = ({ item }) =>
    <MyListItem onPressItem={this._onPressItem} data={item} />;

  render() {
    return (
      <FlatList
        numColumns={2}
        data={this.state.warnData}
        columnWrapperStyle={{ marginLeft: 5, marginRight: 5 }}
        style={{ marginTop: 5 }}
        keyExtractor={this._keyExtractor}
        renderItem={this._renderItem}
      />
    );
  }
}

/**
 * 预警列表条目
 *
 * @class MyListItem
 * @extends {Component}
 */
class MyListItem extends Component {
  num = 0;

  _onPress = () => {
    this.props.onPressItem(this.props.data);
  };

  shouldComponentUpdate(nextProps, nextState) {
    return nextProps.data.alarmTypeCount !== this.num;
  }

  render() {
    this.num = this.props.data.alarmTypeCount;
    var show = this.props.data.alarmType !== -1;
    var item = (
      <Button onPress={this._onPress}>
        <View
          style={{
            flex: 1,
            backgroundColor: this.props.data.backgroundColor,
            height: Global.unitPxWidthConvert(80),
            margin: 5,
            borderRadius: 4,
            flexDirection: "row",
            alignItems: "center",
            justifyContent: "flex-end",
            paddingRight: 15,
            paddingLeft: 15
          }}
        >
          <View style={{ flex: 1 }}>
            <Text
              style={{
                color: "#ffffff",
                fontSize: Global.unitPxWidthConvert(20)
              }}
            >
              {this.props.data.alarmTypeCount}
            </Text>
            <Text
              style={{
                color: "#000000",
                paddingTop: 1,
                fontSize: Global.unitPxWidthConvert(12)
              }}
            >
              {this.props.data.alarmName}
            </Text>
          </View>
          <Image source={this.props.data.alarmImage} />
        </View>
      </Button>
    );
    return (
      <View style={{ flex: 1 }}>
        {show
          ? item
          : <View
              style={{
                flex: 1,
                backgroundColor: "#ffffff",
                height: Global.unitPxWidthConvert(60),
                margin: 10,
                marginTop: 5,
                marginBottom: 10 + Global.safeAreaViewHeight,
                borderRadius: 4,
                flexDirection: "row",
                alignItems: "center",
                justifyContent: "flex-end",
                paddingRight: 15,
                paddingLeft: 15
              }}
            />}
      </View>
    );
  }
}

/**
 * 切换有线无线
 *
 * @class OnLineState
 * @extends {Component}
 */
class OnLineState extends Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      data: [],
      selectPosition: -1
    };
  }

  // shouldComponentUpdate(nextProps, nextState) {
  //   return this.state.selectPosition !== nextState.selectPosition;
  // }

  changeState() {
    var idcList = [];
    this.state.data.map(item =>
      idcList.push(item.SN + " (" + item.productType + ")")
    );
    this.props.changeState(this.state.selectPosition, idcList);
  }

  render() {
    return (
      <View style={{ position: "absolute" }}>
        {this.state.selectPosition == -1
          ? null
          : <TouchableWithoutFeedback onPress={() => this.changeState()}>
              <View style={styles.onLineStateBtn}>
                <Image source={Images.common.monitor_online_state} />
                <Text style={styles.leftTopTextStyle}>
                  {this.state.data[this.state.selectPosition].productType}
                </Text>
              </View>
            </TouchableWithoutFeedback>}
      </View>
    );
  }
}

/**
 * 底部菜单
 *
 * @class Menu
 * @extends {React.PureComponent}
 */
class Menu extends React.PureComponent {
  constructor(props, context) {
    super(props, context);
    this.state = {
      selectedIndex: this.props.selectedIndex
    };
    this.onSelect = this.onSelect.bind(this);
  }

  onSelect(index) {
    if (index == 0 || index == 1) {
      this.setState({
        selectedIndex: index
      });
    }
    if (this.props.onSelect) {
      this.props.onSelect(index);
    }
  }

  render() {
    let selectedIndex = this.state.selectedIndex;
    return (
      <View style={styles.menu}>
        <Button onPress={() => this.onSelect(0)}>
          <View
            style={{ alignItems: "center", justifyContent: "center", flex: 1 }}
          >
            <Image
              source={
                selectedIndex == 0
                  ? this.props.tabCheckedIconNames[0]
                  : this.props.tabUnCheckedIconNames[0]
              }
            />
            <Text
              style={[
                styles.menuText,
                { color: selectedIndex == 0 ? "#ff8400" : "#ffffff" }
              ]}
            >
              监控
            </Text>
          </View>
        </Button>
        {global.userAccount.principal
          ? null
          : <Button onPress={() => this.onSelect(1)}>
              <View
                style={{
                  alignItems: "center",
                  justifyContent: "center",
                  flex: 1
                }}
              >
                <Image
                  source={
                    selectedIndex == 1
                      ? this.props.tabCheckedIconNames[1]
                      : this.props.tabUnCheckedIconNames[1]
                  }
                />
                <Text
                  style={[
                    styles.menuText,
                    { color: selectedIndex == 1 ? "#ff8400" : "#ffffff" }
                  ]}
                >
                  预警
                </Text>
              </View>
            </Button>}
        <Button onPress={() => this.onSelect(2)}>
          <View
            style={{ alignItems: "center", justifyContent: "center", flex: 1 }}
          >
            <Image source={this.props.tabUnCheckedIconNames[2]} />
            <Text style={styles.menuText}>我的</Text>
          </View>
        </Button>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  menu: {
    position: "absolute",
    flexDirection: "row",
    justifyContent: "space-around",
    alignItems: "center",
    height: Global.unitPxWidthConvert(60),
    backgroundColor: "#0e5db7",
    width: Global.width - 20,
    marginLeft: 10,
    borderRadius: 4,
    bottom: 10 + Global.safeAreaViewHeight
  },
  menuText: {
    fontSize: 12,
    color: "#ffffff",
    paddingTop: 5
  },
  refresBtn: {
    position: "absolute",
    justifyContent: "center",
    alignItems: "center",
    top: 30,
    left: 15
  },
  onLineStateBtn: {
    justifyContent: "center",
    alignItems: "center",
    top: 90,
    left: 15
  },
  leftTopTextStyle: {
    fontSize: 10,
    color: "#ffffff",
    position: "absolute"
  },
  rightBottomTextStyle: {
    fontSize: 5,
    color: "#ffffff",
    position: "absolute",
    bottom: 5
  },
  callout: {
    width: 200,
    backgroundColor: "#ffffff",
    borderRadius: 4,
    borderBottomColor: "#afafaf",
    borderTopColor: "#afafaf",
    borderLeftColor: "#afafaf",
    borderRightColor: "#afafaf",
    borderBottomWidth: 1,
    borderLeftWidth: 1,
    borderTopWidth: 1,
    borderRightWidth: 1,
    padding: 10
  },
  popText: {
    fontSize: 10,
    color: "#000000"
  }
});
