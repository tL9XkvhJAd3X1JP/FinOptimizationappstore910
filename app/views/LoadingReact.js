/**@flow */
import React, { Component } from "react";
import { NativeModules, View, PermissionsAndroid } from "react-native";
import PopView2 from "../components/PopView2";

export default class LoadingReact extends Component {
  constructor(props) {
    super(props);
    this.initUserData();
    // this.initUrlHelper();
  }

  /**
   * 初始化版本信息
   */
  // initUrlHelper() {
  //   if (this.props.object) {
  //     global.versionAndUrlModel = JSON.parse(this.props.object);
  //   }
  // }

  /**
   * 初始化用户信息
   */
  initUserData() {
    if (!global.userAccount) {
      StorageUtil.getJsonObject("userAccount", null, result => {
        if (result) {
          global.userAccount = result;
        }
      });
    }
  }

  goto = () => {
    if (global.userAccount) {
      navigateTo("Main","finishOther");
    } else {
      navigateTo("Login","finishOther");
    }
    // this.finishActivity();
  };

  componentDidMount() {
    this.checkPermission();
  }

  checkPermission = () => {
    try {
      //返回Promise类型
      const grantedStorage = PermissionsAndroid.check(
        PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE
      );
      const grantedPhone = PermissionsAndroid.check(
        PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE
      );

      Promise.all([grantedStorage, grantedPhone])
        .then(data => {
          if (data[0] && data[1]) {
            setTimeout(() => {
              this.goto();
            }, 1500);
          } else {
            this.requestMultiplePermission();
          }
        })
        .catch(err => {
          showToastMessage(err.toString());
          this.finishActivity();
        });
    } catch (err) {
      showToastMessage(err.toString());
      this.finishActivity();
    }
  };

  finishActivity = () => {
    NativeModules.SplashScreen.hide();
    popCurrentView();
  };

  //   componentWillUnmount() {
  //     NativeModules.SplashScreen.hide();
  //   }

  render() {
    return (
      <View style={{ flex: 1 }}>
        <PopView2 ref="popView2" />
      </View>
    );
  }

  popOkClick2 = code => {
    NativeModules.AndroidUtils.openPremissionSetting();
    this.finishActivity();
  };

  popOkClick2Cancle = code => {
    this.finishActivity();
  };

  async requestMultiplePermission() {
    try {
      const permissions = [
        PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE,
        PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE
      ];
      //返回得是对象类型
      const granteds = await PermissionsAndroid.requestMultiple(permissions);
      if (
        granteds[PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE] ==
          PermissionsAndroid.RESULTS.NEVER_ASK_AGAIN ||
        granteds[PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE] ==
          PermissionsAndroid.RESULTS.NEVER_ASK_AGAIN
      ) {
        var tips;
        if (
          granteds[PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE] ==
            PermissionsAndroid.RESULTS.NEVER_ASK_AGAIN &&
          granteds[PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE] ==
            PermissionsAndroid.RESULTS.NEVER_ASK_AGAIN
        ) {
          tips = "在设置-应用-金融风控-权限中开启外部存储、电话权限，以正常使用其功能。";
        } else {
          if (
            granteds[PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE] ==
            PermissionsAndroid.RESULTS.NEVER_ASK_AGAIN
          ) {
            tips = "在设置-应用-金融风控-权限中开启外部存储权限，以正常使用其功能。";
          }

          if (
            granteds[PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE] ==
            PermissionsAndroid.RESULTS.NEVER_ASK_AGAIN
          ) {
            tips = "在设置-应用-金融风控-权限中开启电话权限，以正常使用其功能。";
          }
        }

        this.refs.popView2.setState({
          isHiden: false,
          actionView: this,
          message: tips,
          title: "提示",
          messageId: 1000
        });
      } else {
        if (
          granteds[PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE] ==
            PermissionsAndroid.RESULTS.DENIED ||
          granteds[PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE] ==
            PermissionsAndroid.RESULTS.DENIED
        ) {
          this.finishActivity();
        } else {
          if (
            granteds[PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE] ==
              PermissionsAndroid.RESULTS.GRANTED &&
            granteds[PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE] ==
              PermissionsAndroid.RESULTS.GRANTED
          ) {
            this.goto();
          }
        }
      }
    } catch (err) {
      showToastMessage(err.toString());
      this.finishActivity();
    }
  }
}
