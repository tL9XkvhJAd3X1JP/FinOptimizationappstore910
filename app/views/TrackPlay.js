/**@flow */
import React, { Component } from "react";
import {
  Alert,
  ScrollView,
  View,
  Text,
  StatusBar,
  StyleSheet,
  Image,
  DeviceEventEmitter,
  TouchableWithoutFeedback
} from "react-native";
import TitleBar from "../components/TitleBar";
import Images from "../resource/Images";
import RadioGroup from "../components/RadioGroup";
import RadioButton from "../components/RadioButton";
import TextBtn from "../components/TextBtn";
import WarnDealItem from "../components/WarnDealItem";
import MyLoading from "../components/MyLoading";
import UrlHelper from "../bussiness/UrlHelper";
import { postFetch } from "../network/request/HttpExtension";
import Global from "../Global";
import Button from "../components/Button";
import PopView3 from "../components/PopView3";
import DatePicker from "react-native-datepicker";
import moment from "moment";

import {
  MapView,
  BaiduMapMarker,
  Initializer
} from "react-native-baidumap-sdk";

export default class TrackPlay extends Component {
  constructor(props) {
    super(props);
    Initializer.init("VwG2kj6iDZ21dHMGP8sKAUQl0ejVqwVg").catch(e =>
      console.error(e)
    );
    this.state = {
      latitude: 39.912943,
      longitude: 116.404844
    };
  }

  popOkClick3 = () => {
    DeviceEventEmitter.emit("speedType", this.refs.PopView3.selectedItem);
  };

  showPop = () => {
    this.refs.PopView3.setState({
      isHiden: false,
      actionView: this,
      title: "选择列表",
      data: ["快速回放", "匀速回放", "慢速回放"]
    });
  };

  requestData = (startTime, endTime) => {
    this.refs.Loading.showLoading();
    const param = new Map();
    param.set(global.urlInterface.GetGPStrack.idc, 1);
    param.set(global.urlInterface.GetGPStrack.starttime, startTime);
    param.set(global.urlInterface.GetGPStrack.endtime, endTime);
    postFetch(
      global.urlInterface.GetGPStrack.GetGPStrackInterface,
      param
    ).then(response => {
      this.refs.Loading.dismissLoading();
      if (global.Code.SUCESS == response.code) {
      } else {
        alert(response.message);
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
        <TitleBar name="车辆轨迹" />
        <MapView
          style={{ flex: 1 }}
          center={{
            latitude: this.state.latitude,
            longitude: this.state.longitude
          }}
          zoomLevel={14}
          zoomControlsDisabled={true}
        />
        <Controller showPop={this.showPop} requestData={this.requestData} />
        <PopView3 ref="PopView3" />
        {<MyLoading ref="Loading" />}
      </View>
    );
  }
}

class Controller extends Component {
  date = new Date();

  constructor(props) {
    super(props);
    this.state = {
      panelHidden: false,
      startTime: this.fromatDate(this.date.getTime(), "YYYY-MM-DD ") + "00:00",
      endTime: this.fromatDate(this.date.getTime(), "YYYY-MM-DD HH:mm")
    };
  }

  fromatDate(time, fomatter = null) {
    if (!time) return "";
    var fmt = fomatter || "YYYY-MM-DD HH:mm:ss";
    return moment(time).format(fmt);
  }

  showPop = () => {
    this.props.showPop();
  };

  hidden() {
    this.setState(previousState => {
      return { panelHidden: !previousState.panelHidden };
    });
  }

  _pause() {}

  _continue() {}

  _query() {
    this.props.requestData(this.state.startTime, this.state.endTime);
  }

  render() {
    return (
      <View style={styles.warp}>
        <TouchableWithoutFeedback onPress={() => this.hidden()}>
          <View>
            <Image
              source={Images.common.track_drag}
              style={{ alignSelf: "center" }}
            />
            <View
              style={{
                backgroundColor: "#0e5db7",
                height: 10,
                borderTopRightRadius: 4,
                borderTopLeftRadius: 4
              }}
            />
          </View>
        </TouchableWithoutFeedback>

        {this.state.panelHidden
          ? null
          : <View style={styles.controller}>
              <View style={styles.time}>
                <View style={{ flexDirection: "row", alignItems: "center" }}>
                  <Text style={[styles.blueTextStyle, { paddingRight: 10 }]}>
                    开始时间
                  </Text>
                  <Text style={[styles.blueTextStyle, { paddingRight: 10 }]}>
                    {this.state.startTime}
                  </Text>
                </View>
                <DatePicker
                  style={{
                    position: "absolute",
                    width: Global.width - 40,
                    marginTop: 10
                  }}
                  format="YYYY-MM-DD HH:mm"
                  confirmBtnText="确定"
                  cancelBtnText="取消"
                  mode="datetime"
                  showIcon={false}
                  hideText={true}
                  onDateChange={date => {
                    this.setState({ startTime: date });
                  }}
                />
              </View>
              <View style={[styles.time, { marginTop: 10 }]}>
                <View style={{ flexDirection: "row", alignItems: "center" }}>
                  <Text style={[styles.blueTextStyle, { paddingRight: 10 }]}>
                    结束时间
                  </Text>
                  <Text style={[styles.blueTextStyle, { paddingRight: 10 }]}>
                    {this.state.endTime}
                  </Text>
                </View>
                <DatePicker
                  style={{
                    position: "absolute",
                    width: Global.width - 40,
                    marginTop: 10
                  }}
                  format="YYYY-MM-DD HH:mm"
                  confirmBtnText="确定"
                  cancelBtnText="取消"
                  mode="datetime"
                  showIcon={false}
                  hideText={true}
                  onDateChange={date => {
                    this.setState({ endTime: date });
                  }}
                />
              </View>

              <TextBtn
                title="查询"
                onPress={() => {
                  this._query();
                }}
                textStyle={{ color: "#ffffff", fontSize: 10 }}
                btnStyle={{
                  height: 35,
                  backgroundColor: "#ffffff4d",
                  marginTop: 10
                }}
              />
              <View style={{ flexDirection: "row", marginTop: 10 }}>
                <SpeedControl showPop={this.showPop} />
                <Button>
                  <View style={styles.controlSwitch}>
                    <Image
                      source={Images.common.track_play_start}
                      style={{ marginRight: 5 }}
                    />
                    <Text style={styles.blueTextStyle}>开始</Text>
                  </View>
                </Button>
              </View>
              <View style={{ flexDirection: "row", marginTop: 10 }}>
                <TextBtn
                  title="暂停"
                  onPress={() => {
                    this._pause();
                  }}
                  textStyle={{ color: "#ffffff", fontSize: 10 }}
                  btnStyle={{
                    height: 35,
                    backgroundColor: "#ffffff4d",
                    flex: 1,
                    marginRight: 5
                  }}
                />
                <TextBtn
                  title="继续"
                  onPress={() => {
                    this._continue();
                  }}
                  textStyle={{ color: "#ffffff", fontSize: 10 }}
                  btnStyle={{
                    height: 35,
                    backgroundColor: "#ffffff4d",
                    flex: 1,
                    marginLeft: 5
                  }}
                />
              </View>
            </View>}
      </View>
    );
  }
}

class SpeedControl extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      playType: "匀速回放"
    };
  }

  componentDidMount() {
    this.subscription = DeviceEventEmitter.addListener(
      "speedType",
      speedType => {
        this.setState({ playType: speedType });
      }
    );
  }

  componentWillUnmount() {
    this.subscription.remove();
  }

  showPop() {
    this.props.showPop();
  }

  render() {
    return (
      <Button onPress={() => this.showPop()}>
        <View style={styles.speedControl}>
          <Text style={[styles.blueTextStyle, { flex: 1 }]}>
            {this.state.playType}
          </Text>
          <Image source={Images.common.blue_arrow_down} />
        </View>
      </Button>
    );
  }
}

const styles = StyleSheet.create({
  warp: {
    position: "absolute",
    width: Global.width - 20,
    marginLeft: 10,
    bottom: 10,
    justifyContent: "center",
    borderBottomLeftRadius: 4,
    borderBottomRightRadius: 4
  },
  controller: {
    backgroundColor: "#0e5db7",
    borderBottomLeftRadius: 4,
    borderBottomRightRadius: 4,
    paddingBottom: 10,
    paddingHorizontal: 10
  },
  speedControl: {
    height: 35,
    width: 100,
    backgroundColor: "#ffffff",
    flexDirection: "row",
    alignItems: "center",
    borderRadius: 4,
    justifyContent: "flex-end",
    paddingHorizontal: 10
  },
  blueTextStyle: {
    color: "#1263ad",
    fontSize: 10
  },
  controlSwitch: {
    flex: 1,
    flexDirection: "row",
    backgroundColor: "#ffffff",
    justifyContent: "center",
    alignItems: "center",
    marginLeft: 10,
    borderRadius: 4
  },
  time: {
    height: 35,
    justifyContent: "center",
    backgroundColor: "#ffffff",
    borderRadius: 4,
    paddingHorizontal: 10
  }
});
