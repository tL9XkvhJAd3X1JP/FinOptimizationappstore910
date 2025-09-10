import React, { Component } from "react";
import {
  View,
  Text,
  StatusBar,
  Image,
  StyleSheet,
  NativeModules,
  TextInput
} from "react-native";
import Global from "../Global";
import LongBlueBtn from "../components/LongBlueBtn";
import Images from "../resource/Images";
import MyLoading from "../components/MyLoading";
//import UserRequest from "../bussiness/UserRequest";

//const NativeEvents = new NativeEventEmitter(NativeModules.EventUtil);

export default class Login extends Component {
  // 禁用某个页面的手势
  //    static navigationOptions = {
  //    gesturesEnabled: false,
  //    };
  constructor(props) {
    if (Global.ios) {
      setTimeout(() => {
        if (global.userAccount != null) {
          navigateTo("Main", null, null, "false");
        } else {
          StorageUtil.getJsonObject("userAccount", null).then(data => {
            global.userAccount = data;
            if (Global.ios) {
              //alert(JSON.stringify(global.userAccount));
              //已经登录，进下一个界面
              if (global.userAccount != null) {
                navigateTo("Main", null, null, "false");
              }
            }
          });
        }
      }, 1);
    }
    super(props);

    //        global.userAccount = data;

    // 从 initialProps 读取
    // var object = props.hasOwnProperty("object") ? props.object : null;

    //JSON.stringify(props)
    //        alert(JSON.stringify(object));
    //        this.appChannel = props.hasOwnProperty('appChannel') ? props.appChannel : 'auto';
    //        alert(JSON.stringify(props));
  }
  componentWillMount() {
    //登录中调用
    if (Global.ios) {
      // getVersionAndUrlModel(array => {
      //   //                        alert(33);
      //   //    global.version =
      //   //                alert(JSON.stringify(array));
      //   //                        alert(JSON.stringify(array));

      //   //                              alert(JSON.parse(array).versionName);
      //   if (array != null) {
      //     global.versionAndUrlModel = JSON.parse(array);
      //   }
      // });

      registEventAction("invalidLogin", state => {
        //登录已失效
        showToastMessage(state);
      });
    }
  }
  componentDidMount() {
    if (!global.imei) {
      getPhoneImei(imei => {
        global.imei = imei;
      });
    }

    if (Global.android) {
      if (this.props.object == "finishOther") {
        NativeModules.AndroidUtils.finishAllActivityExcludeLast();
      }
    }
  }

  componentWillUnmount() {
    removeEventAction("invalidLogin");
  }

  //登录
  _onLogin = () => {
    //      NativeModules.WarnLocation.searchPlace("北京",(parm)=>{
    //                                             alert(parm);
    //                                             },(parm)=>{
    //                                             alert(parm);
    //                                             });
    //      return;
    //        alert(this.account);
    //        alert(this.password);

    // if (Global.ios) {
    //   getVersionAndUrlModel(array => {
    //     if (array != null) {
    //       global.versionAndUrlModel = JSON.parse(array);
    //     }
    //   });
    // }

    setTimeout(() => {
      const param = new Map();
      if (this.account != null) {
        param.set("username", this.account);
        global.account = this.account;
      }
      if (this.password != null) {
        param.set("password", this.password);
        global.password = this.password;
      }
      //        alert(global.userAccount);
      this.refs.MyLoading.showLoading();
      UserRequest.getInstance().loginInfo(
        param,
        data => {
          this.refs.MyLoading.dismissLoading();
          if (data) {
            data.token = global.token;
            //token保存到native
            setRequestToken(global.token);
            global.userAccount = data;
            StorageUtil.saveJsonObject("userAccount", data, result => {
              navigateTo("Main", "finishOther", null);
              // if (Global.android) {
              //   popCurrentView();
              //   saveLoginState(true);
              // }
            });
          } else {
            showToastMessage("登录失败！");
          }
        },
        message => {
          this.refs.MyLoading.dismissLoading();
          //alert(message);
          showToastMessage(message);
          if (Global.android) {
            saveLoginState(false);
          }
        }
      );
    }, 2);
  };
  _onChangeText1 = inputData => {
    this.account = inputData;
    //        console.log("输入的内容",inputsData); //把获取到的内容，设置给showValue
    //        this.setState({showValue:inputData});
  };
  _onChangeText2 = inputData => {
    this.password = inputData;
    //        console.log("输入的内容",inputsData); //把获取到的内容，设置给showValue
    //        this.setState({showValue:inputData});
  };
  render() {
    return (
      <View style={{ flex: 1 }}>
        <StatusBar
          translucent={true}
          backgroundColor={"#00000000"} //状态栏背景颜色
          barStyle={"light-content"}
        />
        <View style={styles.container}>
          <Image style={styles.bg_img} source={Images.common.login_bg} />
          <View style={styles.container1}>
            <Text style={styles.text1}>登 录</Text>
            <TextInput
              style={styles.inputStyle1}
              //                onChangeText={(text) => this.setState({text})}
              onChangeText={this._onChangeText1} //输入框改变触发的函数
              //                value={this.state.text}
              placeholder="请输入账号"
              editable={true} //是否可编辑
              maxLength={50}
              ref="account"
              //                blurOnSubmit = {true}
              returnKeyType="done"
              //                autoFocus = {true} // bool, 如果为ture，在componenDidMount后会获得焦点。默认false
              //                inlineImageLeft='searchIcon'//{Images.common.searchIcon}
              //                inlineImagePadding={15}
              // 如果为true,文本框会在提交的时候失焦。对于单行输入框默认值为ture,多行则为false。
              // 注意：对于多行输入框来说，如果为ture情况下，则在按下回车键时就会失去焦点同事触发
              // onSubmitEditing事件，而不会换行
              blurOnSubmit={true}
              // 如果为false，会关闭键盘上拼写自动修正。默认值是true
              autoCorrect={false}
              //enum('never', 'while-editing', 'unless-editing', 'always')
              // 清除按钮出现的时机
              clearButtonMode={"while-editing"}
            />
            <TextInput
              style={styles.inputStyle2}
              //                onChangeText={(text) => this.setState({text})}
              onChangeText={this._onChangeText2} //输入框改变触发的函数
              //                value={this.state.text}
              placeholder="请输入密码"
              editable={true} //是否可编辑
              maxLength={50}
              ref="password"
              //                blurOnSubmit = {true}
              returnKeyType="done"
              secureTextEntry={true}
              //                inlineImageLeft='searchIcon'//{Images.common.searchIcon}
              //                inlineImagePadding={15}
              // 如果为true,文本框会在提交的时候失焦。对于单行输入框默认值为ture,多行则为false。
              // 注意：对于多行输入框来说，如果为ture情况下，则在按下回车键时就会失去焦点同事触发
              // onSubmitEditing事件，而不会换行
              blurOnSubmit={true}
              // 如果为false，会关闭键盘上拼写自动修正。默认值是true
              autoCorrect={false}
              // 清除按钮出现的时机
              //enum('never', 'while-editing', 'unless-editing', 'always')
              // 清除按钮出现的时机
              clearButtonMode={"while-editing"}
            />

            <View style={styles.btnLogin}>
              <LongBlueBtn
                name={"登 录"}
                color="rgba(255, 255, 255, 0.2)"
                onPress={this._onLogin}
              />
            </View>
          </View>

          <MyLoading ref="MyLoading" />
        </View>
      </View>
    );
  }
}
var inputTextWidth = Global.width - Global.unitPxWidthConvert(30);
var inputTextHeight = Global.unitPxWidthConvert(40);
var spaceH = Global.unitPxWidthConvert(30);
var space = Global.unitPxWidthConvert(15);
const styles = StyleSheet.create({
  container: {
    //                                 flex: 1,
    flexDirection: "column",
    backgroundColor: "#0e5db7",
    width: Global.width,
    height: Global.height
  },
  bg_img: {
    //                                 flex: 1,
    //                                 width:Global.width,
  },
  container1: {
    //                                 flex: 1,
    flexDirection: "column",
    //                                 backgroundColor: "#0e5db7",
    width: Global.width,
    height: Global.height,
    top: 0,
    position: "absolute"
  },
  text1: {
    //                                 flex: 1,
    fontWeight: "bold",
    marginTop: Global.unitPxWidthConvert(100),
    //                                 marginLeft:Global.unitPxWidthConvert(10),

    //                                 height:40,//contentViewHeight,
    width: Global.width,
    lineHeight: Global.unitPxWidthConvert(54),
    color: "#FFFFFF",
    fontSize: Global.unitPxWidthConvert(43),
    textAlign: "center",
    alignItems: "center",
    justifyContent: "center",
    textAlignVertical: "center"
    //                                 position: 'absolute',
    //                                 backgroundColor:'#FFFFFF'
  },
  inputStyle1: {
    backgroundColor: "#FFFFFF",
    width: inputTextWidth,
    height: inputTextHeight,
    marginTop: spaceH,
    //                                 borderColor:'#5E5E5E',
    //                                 borderWidth:1,
    marginLeft: space,
    borderRadius: 4,
    fontSize: Global.unitPxWidthConvert(13),
    color: "#5E5E5E",
    paddingLeft: Global.unitPxWidthConvert(5)
  },
  inputStyle2: {
    backgroundColor: "#FFFFFF",
    width: inputTextWidth,
    height: inputTextHeight,
    marginTop: spaceH,
    //                                 borderColor:'#5E5E5E',
    //                                 borderWidth:1,
    marginLeft: space,
    borderRadius: 4,
    fontSize: Global.unitPxWidthConvert(13),
    color: "#5E5E5E",
    paddingLeft: Global.unitPxWidthConvert(5)
  },
  btnLogin: {
    //                                 marginBottom: Global.unitPxWidthConvert(35)+Global.safeAreaViewHeight,
    marginTop: Global.unitPxWidthConvert(50),
    width: Global.width - Global.unitPxWidthConvert(30),
    marginLeft: Global.unitPxWidthConvert(15),
    height: inputTextHeight
    //                                 paddingTop: Global.unitPxHeightConvert(10)
  }
});
