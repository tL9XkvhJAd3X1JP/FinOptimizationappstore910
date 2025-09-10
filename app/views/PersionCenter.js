/**@flow */
import React, { Component } from "react";
import {
  Button,
  Alert,
  View,
  Text,
  StatusBar,
  Image,
  StyleSheet
} from "react-native";
import TitleBar from "../components/TitleBar";
import { NativeModules } from "react-native";
import Global from "../Global";
import LongBlueBtn from "../components/LongBlueBtn";
import Images from "../resource/Images";
import PopView1 from "../components/PopView1";
import PopView2 from "../components/PopView2";

/**
 * 我的
 *
 * @export
 * @class PersionCenter
 * @extends {Component<{}>}
 */
export default class PersionCenter extends Component {

  constructor(props) {
    super(props);
  }

  componentDidMount(){
  }

  //修改密码
  _onModifyPwd = () => {
    this.refs.popView1.setState({ isHiden: false, actionView: this });
  };
  //检查更新
  _onCheckUpgrade = () => {
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
        showToastMessage(error);
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
      } else {
        showToastMessage("未检测到新版本！");
      }
    } catch (error) {}
  };

  popOkClick2 = messageId => {
    if (messageId == 1000) {
      updateAppWithUrl(this.clientDownUrl);
    } else {
      this.loginOut();
    }
  };

  loginOut = () => {
    // if (Global.android) {
    //   NativeModules.AndroidUtils.saveLoginState(false);
    // }
    global.userAccount = null;
    StorageUtil.remove("userAccount", result => {
      if (Global.ios) {
        popCurrentView(global.navigation.Login);
      } else {
        navigateTo(global.navigation.Login, "finishOther");
      }
    });
  };

  //退出登录
  _onLoginOut = () => {
    //关闭所有页面，并跳转到登录
    this.refs.popView2.setState({
      isHiden: false,
      actionView: this,
      message: "确定退出登录?",
      title: "提示",
      messageId: 1001
    });
  };

  popOkClick = () => {
    var oldP = this.refs.popView1.oldPassword;
    var newP = this.refs.popView1.newPassword;
    if(!newP){
      showToastMessage("请输入新密码");
      return;
    }
    if(newP && (newP.length<6||newP.length>18) ){
      showToastMessage("请输入6-18位字符");
      return;
    }
    const params = new Map();
    params.set(
      global.urlInterface.UpdatePassword.username,
      global.userAccount.username
    );
    params.set(global.urlInterface.UpdatePassword.password, oldP);
    params.set(global.urlInterface.UpdatePassword.newpassword, newP);
    UserRequest.getInstance().updatePassword(
      params,
      (data, message) => {
        showToastMessage(message);
        this.refs.popView1.setState({ isHiden: true, actionView: this });
        this.loginOut();
      },
      error => {
        showToastMessage(error);
      }
    );
  };

  render() {
    return (
      <View style={styles.container}>
        <StatusBar
          translucent={true}
          backgroundColor={"#00000000"} //状态栏背景颜色
          barStyle={"light-content"}
        />
        <TitleBar name={"我的"} />
        <View style={styles.persionInfo}>
          <Image source={Images.common.persion_bg} />
          <View style={styles.phoneWap}>
            <Text style={styles.accountDes}>当前账号</Text>
            <Text style={styles.phoneStye}>
              {global.userAccount ? global.userAccount.username : ""}
            </Text>
          </View>
        </View>
        <Image source={Images.common.persion_curtain} />
        <View style={styles.surplusSpace}>
          <View style={styles.blueBtnParent}>
            <LongBlueBtn
              name={"修改密码"}
              color={"#0e5db7"}
              onPress={this._onModifyPwd}
            />
            <View style={styles.btnCheckUpdate}>
              <LongBlueBtn
                name={"检查更新"}
                color={"#0e5db7"}
                onPress={this._onCheckUpgrade}
              />
            </View>
          </View>
          <View style={styles.btnLoginOut}>
            <LongBlueBtn
              name={"退出登录"}
              color={"#cd8006"}
              onPress={this._onLoginOut}
            />
          </View>

          <Text style={styles.versionInfo}>
            当前版本V{getVersionName()}
          </Text>
        </View>
        <PopView1 ref="popView1" />
        <PopView2 ref="popView2" />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1
  },
  persionInfo: {
    height: Global.unitPxHeightConvert(150),
    backgroundColor: "#0e5db7",
    flexDirection: "row",
    alignItems: "center",
    paddingLeft: Global.unitPxWidthConvert(30)
  },
  persionImage: {
    width: 248 * Global.unitWidth,
    height: 248 * Global.unitWidth
  },
  phoneWap: {
    paddingLeft: Global.unitPxWidthConvert(15)
  },
  accountDes: {
    fontSize: 15,
    color: "#ffffff"
  },
  phoneStye: {
    marginTop: 15,
    fontSize: 25,
    color: "#ffffff"
  },
  surplusSpace: {
    flex: 1,
    justifyContent: "flex-end",
    paddingHorizontal: Global.unitPxWidthConvert(20)
  },
  blueBtnParent: {
    flex: 1,
    justifyContent: "center"
  },
  btnLoginOut: {
    paddingBottom: Global.unitPxHeightConvert(35),
    paddingTop: Global.unitPxHeightConvert(10)
  },
  versionInfo: {
    // backgroundColor: "#00ff00",
    paddingVertical: Global.unitPxHeightConvert(5),
    textAlign: "center",
    color: "#afafaf"
  },
  btnCheckUpdate: {
    paddingTop: Global.unitPxHeightConvert(10)
  }
});
