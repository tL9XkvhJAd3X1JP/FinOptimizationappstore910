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

import { MapView, BaiduMapMarker, Geocode } from "react-native-baidumap-sdk";

export default class UnusualTogether extends Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      data: JSON.parse(props.object),
      center: null, //圆形覆盖物中心
      radius: null //圆的半径
    };
  }

  warnDeal() {
    var data = {};
    data.id = this.state.data.id;
    data.alarmType = 18;
    navigateTo(global.navigation.WarnDeal, JSON.stringify(data));
  }

  componentWillUnmount() {
    removeEventAction("dealState1");
  }

  componentDidMount() {
    registEventAction("dealState1", state => {
      popCurrentView();
    });

    if (!this.state.data.fenceValue) {
      //车辆坐标为空,不再进行操作
      showToastMessage("无法解析车辆位置！");
      return;
    }
    //设置围栏
    var efenceList = [];
    var efence = this.state.data.fenceValue.split("|");
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
          zoom: this.getZoomByRadius(parseFloat(radius))
        });

        setTimeout(() => {
          this.refs.MapView.setStatus(
            {
              center: {
                latitude: efenceList[0].latitude,
                longitude: efenceList[0].longitude
              }
            },
            2000
          );
        }, 10);
      }
    }
    //转换marker坐标
    const param = new Map();
    param.set(
      global.urlInterface.GpsToBaiduPoints.positionList,
      this.state.data.positionList
    );
    UserRequest.getInstance().gpsToBaiduPoints(
      param,
      response => {
        if (response.fenceValue) {
          var efence = response.fenceValue.split("|");
          if (efence) {
            var length = efence.length;
            var efenceList = [];
            for (var i = 0; i < length; i++) {
              var pointStr = efence[i];
              if (pointStr) {
                var point = pointStr.split(",");
                if (point.length == 2) {
                  var p = {};
                  p.latitude = parseFloat(point[1]);
                  p.longitude = parseFloat(point[0]);
                  efenceList.push(p);
                }
              }
            }
            this.refs.MarkerList.setState({
              markers: efenceList,
              data: this.state.data.list
            });
          }
        }
      },
      error => {
        showToastMessage(error);
      }
    );
  }

  getZoomByRadius = radius => {
    var zoom = [
      "50",
      "100",
      "200",
      "500",
      "1000",
      "2000",
      "5000",
      "10000",
      "20000",
      "25000",
      "50000",
      "100000",
      "200000",
      "500000",
      "1000000",
      "2000000"
    ]; //级别18到3。
    var distance = 2 * radius;
    for (var i = 0, zoomLen = zoom.length; i < zoomLen; i++) {
      if (zoom[i] - distance > 0) {
        return 18 - i + 3; //之所以会多3，是因为地图范围常常是比例尺距离的10倍以上。所以级别会增加3。
      }
    }
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
        <MapView
          ref="MapView"
          style={{ flex: 1 }}
          zoomLevel={this.state.zoom}
          zoomControlsDisabled={true}
        >
          <MarkerList ref="MarkerList" />
          {/* {this.state.center != null && this.state.radius != null
            ? <MapView.Circle
                center={this.state.center}
                radius={this.state.radius}
                strokeWidth={1}
                strokeColor="rgba(0, 0, 255, 0.5)"
                fillColor="rgba(255, 0, 0, 0.5)"
              />
            : null} */}
        </MapView>
        {this.state.data.hasDeal
          ? null
          : <TouchableWithoutFeedback onPress={() => this.warnDeal()}>
              <Image source={Images.common.warn_deal} style={styles.warnDeal} />
            </TouchableWithoutFeedback>}
      </View>
    );
  }
}

class MarkerList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data: [],
      markers: null //mark
    };
  }

  renderMark(item, index) {
    var info = this.state.data[index];
    item.vin = info.vin;
    item.plateNumber = info.plateNumber;
    item.name = info.name;
    item.mobile = info.mobile;
    return <Marker data={item} key={index} />;
  }

  render() {
    var markers =
      this.state.markers == null
        ? null
        : this.state.markers.map((item, index) => {
            return this.renderMark(item, index);
          });
    return markers;
  }
}

class Marker extends Component {
  constructor(props) {
    super(props);
    this.state = {
      latitude: props.data.latitude,
      longitude: props.data.longitude
    };
  }

  shouldComponentUpdate(nextProps, nextState) {
    return (
      this.state.latitude != nextState.latitude ||
      this.state.longitude != nextState.longitude
    );
  }

  async onSelected() {
    if (!this.props.data.address) {
      const reverseResult = await Geocode.reverse({
        latitude: this.state.latitude,
        longitude: this.state.longitude
      });
      this.props.data.address = reverseResult.address;
      this.refs.Address.setState({
        address: this.props.data.address
      });
    }
  }

  render() {
    var mark =
      this.state.latitude && this.state.longitude
        ? <MapView.Marker
            coordinate={{
              latitude: this.state.latitude,
              longitude: this.state.longitude
            }}
            image="car_green"
            onPress={() => this.onSelected()}
          >
            <MapView.Callout>
              <View style={styles.callout}>
                <Text style={styles.text}>
                  车主姓名：{this.props.data.name}
                </Text>
                <Text style={styles.text}>
                  车主电话：{this.props.data.mobile}
                </Text>
                <Text style={styles.text}>
                  车 牌 号：{this.props.data.plateNumber}
                </Text>
                <Text style={styles.text}>
                  车 架 号：{this.props.data.VIN}
                </Text>
                <Address ref="Address" />
              </View>
              <Text />
            </MapView.Callout>
          </MapView.Marker>
        : null;
    return mark;
  }
}

class Address extends Component {
  constructor(props) {
    super(props);
    this.state = {
      address: ""
    };
  }

  render() {
    var add = this.state.address
      ? <Text style={{ fontSize: 10, color: "#000000" }}>
          地址：{this.state.address}
        </Text>
      : null;
    return add;
  }
}

const styles = StyleSheet.create({
  callout: {
    width: 200,
    backgroundColor: "#ffffff",
    borderRadius: 4,
    borderColor: "#afafaf",
    borderWidth: 1,
    padding: 10
  },
  text: {
    fontSize: 10,
    color: "#000000"
  },
  warnDeal: {
    position: "absolute",
    bottom: 100,
    right: 20
  }
});
