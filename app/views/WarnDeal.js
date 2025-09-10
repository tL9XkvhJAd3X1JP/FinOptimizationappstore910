/**@flow */
import React, { Component } from "react";
import {
  Alert,
  ScrollView,
  View,
  Text,
  StatusBar,
  StyleSheet,
  DeviceEventEmitter
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

/**
 * 预警处理
 *
 * @export
 * @class WarnDeal
 * @extends {Component}
 */
export default class WarnDeal extends Component {
  data = {};
  constructor(props) {
    super(props);
    this.state = {
      tabCheckedIconNames: [
        Images.common.checked,
        Images.common.checked,
        Images.common.checked
      ],
      tabUnCheckedIconNames: [
        Images.common.unchecked,
        Images.common.unchecked,
        Images.common.unchecked
      ],
      data: JSON.parse(props.object)
    };
    this.data.state = 2;
  }

  situation(text) {
    this.data.situation = text;
  }

  faultReason(text) {
    this.data.faultReason = text;
  }

  processingMode(text) {
    this.data.processingMode = text;
  }

  processingResult(text) {
    this.data.processingResult = text;
  }

  processingExplain(text) {
    this.data.processingExplain = text;
  }

  _commit = () => {
    this.refs.MyLoading.showLoading();
    const param = new Map();
    param.set(global.urlInterface.InsertAlarmDeal.alarmId, this.state.data.id);
    param.set(
      global.urlInterface.InsertAlarmDeal.alarmType,
      this.state.data.alarmType ? this.state.data.alarmType : ""
    );
    param.set(global.urlInterface.InsertAlarmDeal.state, this.data.state);
    param.set(
      global.urlInterface.InsertAlarmDeal.situation,
      this.data.situation ? this.data.situation : ""
    );
    param.set(
      global.urlInterface.InsertAlarmDeal.faultReason,
      this.data.faultReason ? this.data.faultReason : ""
    );
    param.set(
      global.urlInterface.InsertAlarmDeal.processingMode,
      this.data.processingMode ? this.data.processingMode : ""
    );
    param.set(
      global.urlInterface.InsertAlarmDeal.processingResult,
      this.data.processingResult ? this.data.processingResult : ""
    );
    param.set(
      global.urlInterface.InsertAlarmDeal.processingExplain,
      this.data.processingExplain ? this.data.processingExplain : ""
    );
    param.set(
      global.urlInterface.InsertAlarmDeal.modifyUserId,
      global.userAccount ? global.userAccount.id : ""
    );
    postFetch(
      global.urlInterface.InsertAlarmDeal.InsertAlarmDealInterface,
      param
    ).then(response => {
      this.refs.MyLoading.dismissLoading();
      if (response) {
        if (global.Code.SUCESS == response.code) {
          showToastMessage(response.message);
          if (this.data.state == 1) {
            //关闭当前页面
            popCurrentView();
          } else {
            popCurrentView();
            var data = this.state.data;
            data.hasDeal = true;
            var jsonData = JSON.stringify(data);
            postEventAction("dealState1", this.data.state + "");
            postEventAction("dealState2", jsonData);
            postEventAction("dealState3", this.data.state + "");
          }
        } else {
          showToastMessage(response.message);
        }
      }
    });
  };

  onSelect(index, value) {
    this.data.state = value;
  }

  render() {
    let tabUnCheckedIconNames = this.state.tabUnCheckedIconNames;
    let tabCheckedIconNames = this.state.tabCheckedIconNames;
    return (
      <View style={styles.container}>
        <StatusBar
          translucent={true}
          backgroundColor={"#00000000"} //状态栏背景颜色
          barStyle={"light-content"}
        />
        <TitleBar name={"预警处理"} />
        <RadioGroup
          onSelect={(index, value) => this.onSelect(index, value)}
          style={styles.radioGroup}
          selectedIndex={0}
          tabUnCheckedIconNames={tabUnCheckedIconNames}
          tabCheckedIconNames={tabCheckedIconNames}
          textStyle={{ fontSize: 12, paddingLeft: 5 }}
        >
          {/* <RadioButton value={1}>
            <Text style={{ fontSize: Global.unitPxWidthConvert(12) }}>排查中</Text>
          </RadioButton> */}

          <RadioButton value={2}>
            <Text style={{ fontSize: Global.unitPxWidthConvert(12) }}>已处理</Text>
          </RadioButton>

          <RadioButton value={3}>
            <Text style={{ fontSize: Global.unitPxWidthConvert(12) }}>忽略</Text>
          </RadioButton>
        </RadioGroup>

        <View style={{ justifyContent: "flex-end", flex: 1 }}>
          <View style={styles.page}>
            <ScrollView>
              <WarnDealItem
                name="排查情况"
                height={Global.unitPxWidthConvert(35)}
                multiline={false}
                onChangeText={text => this.situation(text)}
              />
              <WarnDealItem
                name="故障原因"
                height={Global.unitPxWidthConvert(80)}
                multiline={true}
                onChangeText={text => this.faultReason(text)}
              />
              <WarnDealItem
                name="处理方式"
                height={Global.unitPxWidthConvert(35)}
                multiline={false}
                onChangeText={text => this.processingMode(text)}
              />
              <WarnDealItem
                name="处理结果"
                height={Global.unitPxWidthConvert(35)}
                multiline={false}
                onChangeText={text => this.processingResult(text)}
              />
              <WarnDealItem
                name="处理说明"
                height={Global.unitPxWidthConvert(80)}
                multiline={true}
                onChangeText={text => this.processingExplain(text)}
              />
            </ScrollView>
          </View>
          <TextBtn
            title="提 交"
            onPress={() => {
              this._commit();
            }}
            btnStyle={{
              marginLeft: 10,
              marginRight: 10,
              marginBottom: 10 + Global.safeAreaViewHeight
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
  },
  radioGroup: {
    flexDirection: "row",
    justifyContent: "space-around",
    height: Global.unitPxWidthConvert(50),
    backgroundColor: "#ffffff"
  },
  title: {
    color: "#000000",
    fontSize: Global.unitPxWidthConvert(12)
  }
});
