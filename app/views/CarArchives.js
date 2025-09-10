/**@flow */
import React, { Component } from "react";
import {
  View,
  StatusBar,
  Image,
  ScrollView,
  StyleSheet,
  FlatList
} from "react-native";
import TitleBar from "../components/TitleBar";
import ScrollableTabView, {
  DefaultTabBar
} from "react-native-scrollable-tab-view";
import { postFetch } from "../network/request/HttpExtension";
import CarArchivesNormalItem from "../components/CarArchivesNormalItem";
import HorizontalGrayLine from "../components/HorizontalGrayLine";
import MyLoading from "../components/MyLoading";
import UrlHelper from "../bussiness/UrlHelper";
import Global from "../Global";

/**
 * 车辆档案
 *
 * @export
 * @class CarArchives
 * @extends {Component}
 */
export default class CarArchives extends Component {
  constructor(props) {
    super(props);

    this.state = {
      data: {}
    };
  }
  componentDidMount() {
    this.requestData();
  }

  requestData() {
    this.refs.MyLoading.showLoading();
    const param = new Map();
    param.set(global.urlInterface.VehicleFileInfo.cusId, this.props.object);
    postFetch(
      global.urlInterface.VehicleFileInfo.VehicleFileInfoInterface,
      param
    ).then(response => {
      this.refs.MyLoading.dismissLoading();
      if (global.Code.SUCESS == response.code) {
        if (response.data.length != 0) {
          this.setState({
            data: response.data[0]
          });
        }
      } else {
        alert(response.message);
      }
    });
  }

  render() {
    return (
      <View style={styles.container}>
        <StatusBar
          translucent={true}
          backgroundColor={"#00000000"} //状态栏背景颜色
          barStyle={"light-content"}
        />
        <TitleBar name={"车辆档案"} />
        <ScrollableTabView
          //  onChangeTab={(obj) => {
          //       // Alert.alert('current index ： ' + obj.i)
          //       // Alert.alert(""+obj.ref)
          //   }}
          //下划线颜色
          tabBarUnderlineStyle={{ backgroundColor: "#0e5db7", height: 2 }}
          //背景色
          tabBarBackgroundColor="#ffffff"
          //未选中字体颜色
          tabBarActiveTextColor="#2a2a2a"
          //选中字体颜色
          tabBarInactiveTextColor="#0e5db7"
          //禁止所有滑动
          scrollWithoutAnimation={true}
          //设置字体样式
          tabBarTextStyle={{
            fontSize: Global.unitPxWidthConvert(12),
            lineHeight: Global.unitPxWidthConvert(40),
            fontStyle: "normal",
            fontWeight: "normal"
          }}
          //bar的默认样式
          renderTabBar={() =>
            <DefaultTabBar
              style={{
                height: Global.unitPxWidthConvert(40),
                borderWidth: 0,
                elevation: 0
              }}
              tabStyle={{
                height: Global.unitPxWidthConvert(40),
                justifyContent: "flex-start"
              }}
            />}
        >
          <View tabLabel="基本" style={styles.page}>
            <ScrollView>
              <CarArchivesNormalItem
                name="车牌号"
                value={this.state.data.plateNumber}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem name="车架号" value={this.state.data.vin} />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="发动机号"
                value={this.state.data.engine}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="车身价(万元)"
                value={this.state.data.carPrice}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="车总价(万元)"
                value={this.state.data.vehiclePrice}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="车系"
                value={this.state.data.carSerialName}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="车型"
                value={this.state.data.carTypeName}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="出厂年份"
                value={this.state.data.productionDate}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="购买日期"
                value={this.state.data.buyDate}
              />
              <HorizontalGrayLine />
            </ScrollView>
          </View>
          <View tabLabel="车主" style={styles.page}>
            <ScrollView>
              <CarArchivesNormalItem name="车主姓名" value={this.state.data.name} />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="性别"
                value={this.state.data.sexName}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="手机号码"
                value={this.state.data.mobile}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="电子邮箱"
                value={this.state.data.email}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="身份证号码"
                value={this.state.data.idNumber}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="单位名称"
                value={this.state.data.companyName}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="家庭住址"
                value={this.state.data.homeAddress}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="工作地址"
                value={this.state.data.companyAddress}
              />
              <HorizontalGrayLine />
            </ScrollView>
          </View>
          <View tabLabel="设备">
            <DeviceList data={this.state.data.list} />
          </View>
          <View tabLabel="贷款" style={styles.page}>
            <ScrollView>
              <CarArchivesNormalItem
                name="月供(元)"
                value={this.state.data.monthSupply}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="贷款金额(万元)"
                value={this.state.data.amount}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="月供还款日期"
                value={this.state.data.repaymentDay}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="贷款期限(年)"
                value={this.state.data.period}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="还款开始日期"
                value={this.state.data.repaymentBeginDate}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="还款结束日期"
                value={this.state.data.repaymenTendDate}
              />
              <HorizontalGrayLine />
              <CarArchivesNormalItem
                name="未按期还款次数"
                value={this.state.data.violationTimes}
              />
              <HorizontalGrayLine />
            </ScrollView>
          </View>
        </ScrollableTabView>
        <MyLoading ref="MyLoading" />
      </View>
    );
  }
}
/**
 * 设备列表
 *
 * @class DeviceList
 * @extends {PureComponent}
 */
class DeviceList extends React.PureComponent {
  _renderItem = ({ item }) =>
    <View style={styles.device}>
      <CarArchivesNormalItem name="设备号" value={item.idc} />
      <HorizontalGrayLine />
      <CarArchivesNormalItem name="设备类型" value={item.productTypeName} />
    </View>;
  _keyExtractor = (item, index) => index + "";
  render() {
    return (
      <FlatList
        data={this.props.data}
        renderItem={this._renderItem}
        keyExtractor={this._keyExtractor}
      />
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
    marginTop: 10,
    marginBottom: 10 + Global.safeAreaViewHeight,
    marginHorizontal: 10,
    backgroundColor: "#ffffff",
    overflow: "hidden"
  },
  device: {
    borderRadius: 4,
    marginTop: 5,
    marginLeft: 10,
    marginRight: 10,
    backgroundColor: "#ffffff",
    overflow: "hidden"
  }
});
