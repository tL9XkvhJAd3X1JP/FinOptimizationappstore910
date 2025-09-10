/**@flow */
import React, { Component } from "react";
import {
  Alert,
  ScrollView,
  View,
  Text,
  StatusBar,
  StyleSheet
} from "react-native";
import TitleBar from "../components/TitleBar";
import Images from "../resource/Images";
import CheckBox from "../components/CheckBox";
import ScrollableTabView from "react-native-scrollable-tab-view";
import DefaultLeftIconTabBar from "../components/DefaultLeftIconTabBar";
import TextBtn from "../components/TextBtn";
import Input from "../components/Input";
import GpsSetTimeItem from "../components/GpsSetTimeItem";
import MyLoading from "../components/MyLoading";
import { postFetch } from "../network/request/HttpExtension";
import Global from "../Global";

export default class GpsSet extends Component {
  data = {};
  constructor(props) {
    super(props);
    this.data.index = 0;
    this.state = {
      // tabNames: ["Tab1", "Tab2", "Tab3", "Tab4"],
      tabCheckedIconNames: [Images.common.checked, Images.common.checked],
      tabUnCheckedIconNames: [Images.common.unchecked, Images.common.unchecked]
    };
    this.device = JSON.parse(this.props.object);
  }

  _preSave = () => {
    if (this.device.productTypeID == 2) {
      var type = this.data.index == 0 ? 1 : 0;
      var value = null;
      if (type == 0) {
        value = this.data.timeInterval;
        try {
          if (Number.parseInt(value) < 1 || Number.parseInt(value) > 999) {
            showToastMessage("请输入1-999范围的数字");
            return;
          }
        } catch (error) {
          showToastMessage("请输入1-999范围的数字");
          return;
        }
      } else {
        if (this.data.timePoint1) {
          value = value
            ? value + "," + this.data.timePoint1
            : this.data.timePoint1;
        }
        if (this.data.timePoint2) {
          value = value
            ? value + "," + this.data.timePoint2
            : this.data.timePoint2;
        }
        if (this.data.timePoint3) {
          value = value
            ? value + "," + this.data.timePoint3
            : this.data.timePoint3;
        }
        if (this.data.timePoint4) {
          value = value
            ? value + "," + this.data.timePoint4
            : this.data.timePoint4;
        }
      }
      this._save(type, value);
    } else {
      var value = this.data.timeInterval;
      try {
        if (!value) {
          showToastMessage("请输入5-10800范围的数字");
          return;
        }
        if (Number.parseInt(value) < 5 || Number.parseInt(value) > 10800) {
          showToastMessage("请输入5-10800范围的数字");
          return;
        }
      } catch (error) {
        showToastMessage("请输入5-10800范围的数字");
        return;
      }
      this._save(null, value);
    }
  };

  _save(type, value) {
    this.refs.MyLoading.showLoading();
    const param = new Map();
    param.set(global.urlInterface.SetDevicePara.idc, this.device.IDC);
    if (type != null) {
      param.set(global.urlInterface.SetDevicePara.type, type);
    }
    param.set(global.urlInterface.SetDevicePara.pushContent, value);
    param.set(global.urlInterface.SetDevicePara.id, this.device.id);
    param.set(
      global.urlInterface.SetDevicePara.pushType,
      this.device.productTypeID
    );
    param.set(global.urlInterface.SetDevicePara.userId, global.userAccount.id);
    param.set(
      global.urlInterface.SetDevicePara.companyId,
      global.userAccount.companyId
    );

    postFetch(
      global.urlInterface.SetDevicePara.SetDeviceParaInterface,
      param
    ).then(response => {
      this.refs.MyLoading.dismissLoading();
      if (global.Code.SUCESS == response.code) {
        popCurrentView();
        showToastMessage(response.message);
      } else {
        showToastMessage(response.message);
      }
    });
  }

  onChangeTab = index => {
    this.data.index = index;
  };

  onTimePoint1 = text => {
    this.data.timePoint1 = text;
  };
  onTimePoint2 = text => {
    this.data.timePoint2 = text;
  };
  onTimePoint3 = text => {
    this.data.timePoint3 = text;
  };
  onTimePoint4 = text => {
    this.data.timePoint4 = text;
  };

  onTimeInterval = text => {
    this.data.timeInterval = text;
  };

  render() {
    // let tabNames = this.state.tabNames;
    let tabUnCheckedIconNames = this.state.tabUnCheckedIconNames;
    let tabCheckedIconNames = this.state.tabCheckedIconNames;
    return (
      <View style={styles.container}>
        <StatusBar translucent={true} barStyle={"light-content"} />
        <TitleBar name={"Gps间隔"} />
        <View style={{ justifyContent: "flex-end", flex: 1 }}>
          {this.device.productTypeID == 2
            ? <ScrollableTabView
                onChangeTab={obj => {
                  this.onChangeTab(obj.i);
                }}
                //下划线颜色
                tabBarUnderlineStyle={{ backgroundColor: "#0e5db7", height: 0 }}
                //背景色
                tabBarBackgroundColor="#ffffff"
                //未选中字体颜色
                tabBarActiveTextColor="#2a2a2a"
                //选中字体颜色
                tabBarInactiveTextColor="#2a2a2a"
                //禁止所有滑动
                scrollWithoutAnimation={true}
                //设置字体样式
                tabBarTextStyle={{
                  fontSize: 12,
                  lineHeight: Global.unitPxWidthConvert(50),
                  fontStyle: "normal",
                  fontWeight: "normal",
                  paddingLeft: 5
                }}
                //bar的默认样式
                renderTabBar={() =>
                  <DefaultLeftIconTabBar
                    style={{
                      height: Global.unitPxWidthConvert(50),
                      borderWidth: 0,
                      elevation: 0
                    }}
                    tabStyle={{
                      height: Global.unitPxWidthConvert(50)
                    }}
                    tabUnCheckedIconNames={tabUnCheckedIconNames}
                    tabCheckedIconNames={tabCheckedIconNames}
                  />}
              >
                <View tabLabel="按时间点" style={styles.page}>
                  <ScrollView>
                    <GpsSetTimeItem
                      name="第一时间点"
                      onChangeText={text => this.onTimePoint1(text)}
                    />
                    <GpsSetTimeItem
                      name="第二时间点"
                      onChangeText={text => this.onTimePoint2(text)}
                    />
                    <GpsSetTimeItem
                      name="第三时间点"
                      onChangeText={text => this.onTimePoint3(text)}
                    />
                    <GpsSetTimeItem
                      name="第四时间点"
                      onChangeText={text => this.onTimePoint4(text)}
                    />
                  </ScrollView>
                </View>
                <View tabLabel="按时间间隔" style={styles.page}>
                  <Input
                    onChangeText={text => this.onTimeInterval(text)}
                    hint="请输入时间间隔（1-999分钟）"
                    inputStyle={{
                      marginTop: 10,
                      borderBottomColor: "#afafaf",
                      borderTopColor: "#afafaf",
                      borderLeftColor: "#afafaf",
                      borderRightColor: "#afafaf",
                      borderBottomWidth: 1,
                      borderLeftWidth: 1,
                      borderTopWidth: 1,
                      borderRightWidth: 1,
                      borderTopLeftRadius: 4,
                      borderTopRightRadius: 4,
                      borderBottomRightRadius: 4,
                      borderBottomLeftRadius: 4,
                      height: Global.unitPxWidthConvert(40)
                    }}
                    hintColor="#afafaf"
                  />
                </View>
              </ScrollableTabView>
            : <View style={styles.page}>
                <Input
                  onChangeText={text => this.onTimeInterval(text)}
                  hint="请输入时间间隔（5-10800秒）"
                  inputStyle={{
                    marginTop: 10,
                    borderBottomColor: "#afafaf",
                    borderTopColor: "#afafaf",
                    borderLeftColor: "#afafaf",
                    borderRightColor: "#afafaf",
                    borderBottomWidth: 1,
                    borderLeftWidth: 1,
                    borderTopWidth: 1,
                    borderRightWidth: 1,
                    borderTopLeftRadius: 4,
                    borderTopRightRadius: 4,
                    borderBottomRightRadius: 4,
                    borderBottomLeftRadius: 4,
                    height: Global.unitPxWidthConvert(40)
                  }}
                  hintColor="#afafaf"
                />
              </View>}

          <TextBtn
            title="提 交"
            onPress={() => {
              this._preSave();
            }}
            textStyle={{ fontSize: Global.unitPxWidthConvert(12) }}
            btnStyle={{
              marginLeft: 10,
              marginRight: 10,
              marginBottom: 10 + Global.safeAreaViewHeight,
              height: Global.unitPxWidthConvert(40)
            }}
          />
        </View>
        <MyLoading ref="MyLoading" />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#e9e9e9"
  },
  page: {
    flex: 1,
    borderRadius: 4,
    margin: 10,
    padding: 10,
    backgroundColor: "#ffffff",
    overflow: "hidden"
  }
});
