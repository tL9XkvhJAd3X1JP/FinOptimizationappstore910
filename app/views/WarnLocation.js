/**@flow */
import React, { Component } from "react";
import {
  Alert,
  View,
  StatusBar,
  Image,
  ScrollView,
  StyleSheet,
  FlatList,
  Text,
  TouchableWithoutFeedback,
  NativeModules,
  DeviceEventEmitter
} from "react-native";
import TitleBar from "../components/TitleBar";
import { postFetch } from "../network/request/HttpExtension";
import HorizontalGrayLine from "../components/HorizontalGrayLine";
import MyLoading from "../components/MyLoading";
import UrlHelper from "../bussiness/UrlHelper";
import Images from "../resource/Images";
import PopView4 from "../components/PopView4";
import moment from "moment";

import { MapView, BaiduMapMarker } from "react-native-baidumap-sdk";

export default class WarnLocation extends Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      gpsData: null, //多边形和出省市覆盖物
      data: JSON.parse(props.object),
      zoom: 14,
      center: null, //圆形覆盖物中心
      radius: null //圆的半径
    };
  }

  /**
   * 切换设备
   *
   * @memberof Main
   */
  popOkClick4 = (item, index) => {
    this.refs.OnLineState.setState({
      selectPosition: index
    });
    this.refs.DeviceNum.setState({
      idc:
        this.state.data.proInfo[index].productType +
        " (" +
        this.state.data.proInfo[index].productType +
        ")"
    });
    this.refs.PositionDetail.setState({
      positionDetail: ""
    });
    this.requestLocation(this.objData, this.objData.proInfo[index]);
  };

  componentWillUnmount() {
    removeEventAction("dealState1");
  }

  componentDidMount() {
    registEventAction("dealState1", state => {
      popCurrentView();
    });

    if (this.state.data.alarmType == 4 || this.state.data.alarmType == 5) {
      //月里程异常 和 日里程异常，显示当前位置，单独处理
      try {
        var length = this.state.data.proInfo.length;
        this.refs.OnLineState.setState({
          data: this.state.data.proInfo,
          selectPosition: length == 0 ? -1 : 0
        });
        //获取位置
        if (length != 0) {
          this.refs.DeviceNum.setState({
            idc:
              this.state.data.proInfo[0].IDC +
              " (" +
              this.state.data.proInfo[0].productType +
              ")"
          });
          this.requestLocation(this.state.data, this.state.data.proInfo[0]);
        } else {
          showToastMessage("该车辆未安装设备！");
        }
      } catch (error) {
        showToastMessage("该车辆未安装设备！");
      }

      return;
    }

    if (!this.state.data.latitude || !this.state.data.longitude) {
      //车辆坐标为空,不再进行操作
      showToastMessage("无法解析车辆位置！");
      return;
    }

    const param = new Map();
    param.set(
      global.urlInterface.GetWarningGPS.latitude,
      this.state.data.latitude
    );
    param.set(
      global.urlInterface.GetWarningGPS.longitude,
      this.state.data.longitude
    );

    //需要围栏的报警
    if (
      this.state.data.alarmType == 6 ||
      this.state.data.alarmType == 7 ||
      this.state.data.alarmType == 8 ||
      this.state.data.alarmType == 9
    ) {
      param.set(
        global.urlInterface.GetWarningGPS.efencePoints,
        this.state.data.fenceValue
      );
      param.set(
        global.urlInterface.GetWarningGPS.efenceType,
        this.state.data.fenceType
      );
    }

    UserRequest.getInstance().getWarningGPS(
      param,
      response => {
        if (response.address) {
          this.refs.PositionDetail.setState({
            positionDetail: response.address
          });
        }

        if (response.efencePoints && response.efenceType) {
          //有围栏数据
          if (response.efenceType == 3) {
            var efenceList = [];
            //多边形
            var efence = response.efencePoints.split("|");
            if (efence || efence.length > 0) {
              efence.map(item => {
                var pos = item.split(",");
                if (pos && pos.length == 2) {
                  var location = {};
                  location.latitude = parseFloat(pos[1]);
                  location.longitude = parseFloat(pos[0]);
                  efenceList.push(location);
                }
              });
            }
            //设置围栏
            if (efenceList.length > 0) {
              var array = new Array(efenceList);
              this.setState({
                gpsData: array,
                zoom: 14
              });
            }
          } else if (response.efenceType == 1) {
            //圆形
            var efenceList = [];
            //多边形
            var efence = response.efencePoints.split("|");
            if (efence || efence.length == 2) {
              var cirLocation = efence[0];
              var radius = efence[1];
              var pos = cirLocation.split(",");
              if (pos && pos.length == 2) {
                var location = {};
                location.latitude = parseFloat(pos[1]);
                location.longitude = parseFloat(pos[0]);
                efenceList.push(location);
              }
              //设置围栏
              if (efenceList.length > 0) {
                this.setState({
                  center: efenceList[0],
                  radius: parseFloat(radius),
                  zoom: 14
                });
              }
            }
          }
        }

        if (
          this.state.data.alarmType == 12 ||
          this.state.data.alarmType == 13
        ) {
          //出省 出市
          if (this.state.data.fenceName) {
            searchPlace(
              this.state.data.fenceName,
              data => {
                var array = JSON.parse(data);
                this.setState({
                  gpsData: array,
                  zoom: 8
                });
              },
              error => {
                alert("规划异常，请稍后再试");
              }
            );
          }
        }

        if (response.waringPos) {
          var position = response.waringPos.split(",");
          if (position.length == 2) {
            this.refs.Marker.setState({
              latitude: parseFloat(position[1]),
              longitude: parseFloat(position[0])
            });
            setTimeout(() => {
              this.refs.MapView.setStatus(
                {
                  center: {
                    latitude: parseFloat(position[1]),
                    longitude: parseFloat(position[0])
                  }
                },
                1000
              );
            }, 100);
          }
        }
      },
      error => {
        showToastMessage(error);
      }
    );
  }

  warnDeal() {
    navigateTo(global.navigation.WarnDeal, this.props.object);
  }

  renderPolygon(item, index) {
    return <Polygon data={item} key={index} />;
  }

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

  requestLocation = (objData, device) => {
    this.objData = objData;
    this.device = device;
    const param = new Map();
    param.set(global.urlInterface.GetCurrentGPS.idc, device.IDC);
    postFetch(
      global.urlInterface.GetCurrentGPS.GetCurrentGPSInferface,
      param
    ).then(response => {
      if (response) {
        if (global.Code.SUCESS == response.code) {
          var data = {};
          data.longitude = response.data.longitude;
          data.latitude = response.data.latitude;
          data.address = response.data.address;
          // data.speed = response.data.speed;
          // data.accState = response.data.accState;
          // data.salState = response.data.salState;
          // data.bindState = response.data.bindState;
          // data.direction = response.data.direction;
          // data.name = objData.name;
          // data.mobile = objData.mobile;
          // data.platenumber = objData.platenumber;
          // data.VIN = objData.VIN;
          // data.salCount = response.data.salCount; //剩余电量
          // data.productTypeID = device.productTypeID;
          // data.gpsTime = moment(response.data.gpsTime).format(
          //   "YYYY-MM-DD HH:mm:ss"
          // );
          this.refs.Marker.setState({
            latitude: parseFloat(data.latitude),
            longitude: parseFloat(data.longitude)
          });
          this.refs.PositionDetail.setState({
            positionDetail: data.address
          });
          setTimeout(() => {
            this.refs.MapView.setStatus(
              {
                center: {
                  latitude: parseFloat(data.latitude),
                  longitude: parseFloat(data.longitude)
                }
              },
              1000
            );
          }, 500);
        } else {
          this.refs.Marker.setState({
            longitude: 0,
            latitude: 0
          });
          showToastMessage(response.message);
        }
      }
    });
  };

  render() {
    return (
      <View style={{ flex: 1 }}>
        <StatusBar
          translucent={true}
          backgroundColor={"#00000000"} //状态栏背景颜色
          barStyle={"light-content"}
        />
        <TitleBar name={"报警详细"} />

        <View style={{ padding: 10, backgroundColor: "#ffffff" }}>
          <View
            style={{ flexDirection: "row", justifyContent: "space-between" }}
          >
            <Text style={styles.text}>
              车牌号　:{this.state.data.plateNumber}
            </Text>
            <Text style={styles.text}>
              {this.state.data.alarmTime1}
            </Text>
          </View>

          <View style={{ flexDirection: "row", paddingTop: 2 }}>
            <Text style={styles.text}>车架号　:</Text>
            <Text style={styles.text}>
              {this.state.data.vin}
            </Text>
          </View>

          <View style={{ flexDirection: "row", paddingTop: 2 }}>
            <Text style={styles.text}>设备号　:</Text>
            {/* <Text style={styles.text}>
              {this.state.data.idc + " (" + this.state.data.productType + ")"}
            </Text> */}
            <DeviceNum ref="DeviceNum" />
          </View>

          <View style={{ flexDirection: "row", paddingTop: 2 }}>
            <Text style={styles.text}>车主姓名:</Text>
            <Text style={styles.text}>
              {this.state.data.name}
            </Text>
          </View>

          <View style={{ flexDirection: "row", paddingTop: 2 }}>
            <Text style={styles.text}>车主电话:</Text>
            <Text style={styles.text}>
              {this.state.data.mobile}
            </Text>
          </View>

          <View style={{ flexDirection: "row", paddingTop: 2 }}>
            <Text style={styles.text}>报警类型:</Text>
            <Text style={styles.text}>
              {this.state.data.alarmTypeName}
            </Text>
          </View>

          <View style={{ flexDirection: "row", paddingTop: 2 }}>
            <Text style={styles.text}>报警说明:</Text>
            <Text style={styles.text}>
              {this.state.data.alarmDescribe}
            </Text>
          </View>
          <PositionDetail ref="PositionDetail" />
        </View>

        <View style={{ flex: 1 }}>
          <MapView
            ref="MapView"
            style={{ flex: 1 }}
            rotation={this.state.rotation}
            zoomLevel={this.state.zoom}
            zoomControlsDisabled={true}
          >
            <Marker ref="Marker" />
            {this.state.gpsData == null
              ? null
              : this.state.gpsData.map((item, index) => {
                  return this.renderPolygon(item, index);
                })}

            {this.state.efenceList == null
              ? null
              : <Polygon data={this.state.efenceList} />}

            {this.state.center != null && this.state.radius != null
              ? <MapView.Circle
                  center={this.state.center}
                  radius={this.state.radius}
                  strokeWidth={1}
                  strokeColor="rgba(0, 0, 255, 0.5)"
                  fillColor="rgba(255, 0, 0, 0.5)"
                />
              : null}
          </MapView>
          <OnLineState ref="OnLineState" changeState={this.changeState} />
          {this.state.data.hasDeal
            ? null
            : <TouchableWithoutFeedback onPress={() => this.warnDeal()}>
                <Image
                  source={Images.common.warn_deal}
                  style={styles.warnDeal}
                />
              </TouchableWithoutFeedback>}
        </View>
        <PopView4 ref="PopView4" />
      </View>
    );
  }
}

class DeviceNum extends Component {
  constructor(props) {
    super(props);
    this.state = {
      idc: ""
    };
  }

  render() {
    return (
      <Text style={styles.text}>
        {this.state.idc}
      </Text>
    );
  }
}

class PositionDetail extends Component {
  constructor(props) {
    super(props);
    this.state = {
      positionDetail: ""
    };
  }

  render() {
    return (
      <View style={{ flexDirection: "row", paddingTop: 2 }}>
        <Text style={styles.text}>详细位置:</Text>
        <Text style={styles.text}>
          {this.state.positionDetail}
        </Text>
      </View>
    );
  }
}

class Marker extends Component {
  constructor(props) {
    super(props);
    this.state = {
      latitude: 0,
      longitude: 0
    };
  }

  shouldComponentUpdate(nextProps, nextState) {
    return (
      this.state.latitude !== nextState.latitude ||
      this.state.longitude !== nextState.longitude
    );
  }

  render() {
    var mark =
      this.state.latitude != 0 && this.state.longitude != 0
        ? <MapView.Marker
            coordinate={{
              latitude: this.state.latitude,
              longitude: this.state.longitude
            }}
            image="car_red"
          />
        : null;
    return mark;
  }
}

class Polygon extends Component {
  render() {
    return (
      <MapView.Polygon
        points={this.props.data}
        strokeWidth={1}
        strokeColor="rgba(0, 0, 255, 0.5)"
        fillColor="rgba(255, 0, 0, 0.5)"
      />
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

const styles = StyleSheet.create({
  warnDeal: {
    position: "absolute",
    bottom: 100,
    right: 20
  },
  callout: {
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
  text: {
    fontSize: 12,
    color: "#000000"
  },
  onLineStateBtn: {
    justifyContent: "center",
    alignItems: "center",
    top: 30,
    left: 15
  },
  leftTopTextStyle: {
    fontSize: 10,
    color: "#ffffff",
    position: "absolute"
  }
});
