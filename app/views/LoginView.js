import React, { Component } from "react";
import {
  Button,
  Alert,
  View,
  Text,
  StatusBar,
  Image,
  StyleSheet,
  NativeModules,
  AppRegistry,
  DeviceEventEmitter,
  NativeAppEventEmitter,
  NativeEventEmitter
} from "react-native";
import TitleBar from "../components/TitleBar";
import Global from "../Global";
import LongBlueBtn from "../components/LongBlueBtn";
import Images from "../resource/Images";
//import PopView2 from "../components/PopView2";
import PopView4 from "../components/PopView4";
import TimePickerItem from "../components/TimePickerItem";
import {
  MapView,
  BaiduMapMarker,
  Initializer
} from "react-native-baidumap-sdk";
//import SelectCarList from "../views/SelectCarList";
//AppRegistry.registerComponent("LoginView", () => LoginView);

//const NativeEvents = new NativeEventEmitter(NativeModules.EventUtil);

export default class LoginView extends Component {
  constructor(props) {
    super(props);
    Initializer.init("VwG2kj6iDZ21dHMGP8sKAUQl0ejVqwVg").catch(e =>
      console.error(e)
    );
    //        DeviceEventEmitter.addListener("aaaa", (param) => {
    //                                       //收到通知后处理逻辑
    //                                       //eg 刷新数据
    //                                       alert(1111);
    //                                       });

    // 从 initialProps 读取
    var object = props.hasOwnProperty("object") ? props.object : null;
    this.myMap = new Map();
    //JSON.stringify(props)
    //        alert(JSON.stringify(object));
    //        this.appChannel = props.hasOwnProperty('appChannel') ? props.appChannel : 'auto';
    //        alert(JSON.stringify(props));
  }
  componentDidMount() {
    //收到监听
    //        this.listener = DeviceEventEmitter.addListener("xxxName", (message) => {
    //                                                       //收到监听后想做的事情
    //                                                       alert(message);  //监听
    //                                                       });

    if (global.android) {
      this.listener = DeviceEventEmitter.addListener("xxxName", message => {
        alert("dddd");
        console.warn("+++++++++++++++");
      });
    } else {
      //            this.listener = DeviceEventEmitter.addListener('xxxName',(userName) => {
      //                                                              console.warn("+++++++++++++++");
      //                                                                  alert("ddd");
      //                                                           });
      //            this.listener = NativeModules.EventUtil.addListener("SpotifyHelper", (param) => {
      //                                     //收到通知后处理逻辑
      //                                     //eg 刷新数据
      //                                     alert(22222);
      //                                     });
      //            NativeModules.EventUtil.addEvent("SpotifyHelper", (param) => {
      //                                             //收到通知后处理逻辑
      //                                             //eg 刷新数据
      //                                             alert(22222);
      //                                             });

      //            NativeModules.EventUtil.addEventName("goToCashier");
      //            NativeModules.EventUtil.addEventName("goToCashier2");
      //            const ReactEventEmit = NativeModules.EventUtil;
      //
      //            const myReactEventEmit = new NativeEventEmitter(ReactEventEmit);
      //
      //            this.listener = myReactEventEmit.addListener('goToCashier', (data) => {
      //
      //                                                         alert(data.aaa);
      //                                                         });
      //            this.listener2 = myReactEventEmit.addListener('goToCashier2', (data) => {
      //
      //                                                         alert(data.aaa);
      //                                                         });
      //            NativeModules.EventUtil.addEvent("goToCashier",(data) => {
      //
      //
      //                                             alert(444);
      ////                                             alert(data.aaa);
      //                                                                                                      });
      //           NativeModules.EventUtil.addEventName('EventReminder');
      //            const { EventUtil } = NativeModules;
      //
      //            const loadingManagerEmitter = new NativeEventEmitter(EventUtil);
      //            const subscription = loadingManagerEmitter.addListener('EventReminder',(reminder) => {
      //                                                                alert(555);   console.log(reminder)
      //                                                                   });
      //            this.addManyEvent();
      registEventAction("test", data => {
        alert(11);
      });
    }
  }
  addManyEvent() {
    NativeModules.EventUtil.addEventOnce("goToCashier", data => {
      //JSON.stringify(data[0])
      //                                         alert(data);
      alert(data.aaa);
      //                                             alert(JSON.stringify(data));
      this.addManyEvent();
      //                                             alert(data.aaa);
    });
  }
  componentWillUnmount() {
    //        alert("componentWillUnmount");
    //移除监听
    if (global.android) {
      if (this.listener) {
        //            alert("remove");
        this.listener.remove();
      }
    } else {
      NativeModules.EventUtil.removeEventOnce("goToCashier");
    }
  }
  //弹框回调的方法
  popOkClick = () => {
    //        this.refs.popView.oldPassword
    alert("11");
  };
  popOkClick2 = () => {
    alert("22");
  };
  popOkClick4 = item => {
    alert(item);
    //        alert(this.refs.PopView4.selectedItem);
  };
  //    registEventAction=(key,callBack)=>
  //    {
  //        alert(key);
  //        NativeModules.EventUtil.addEventOnce(key,callBack);
  //        this.myMap.set(key, callBack);
  //    };

  //修改密码
  onModifyPwd() {
    //        this.registEventAction('mykey',(param)=>{
    //
    //                               alert(param);
    //                               this.myMap.delete('mykey');
    //                               });
    //        registEventAction('mykey',(param)=>{
    //
    //                          alert(JSON.stringify(param));
    //
    //                          });
    //PlayBackViewController
    //PlayBackViewController LoginViewController
    NativeModules.iosUtil.pushToNativeViewWithviewControllerName(
      "PlayBackViewController"
    );
    //        NativeModules.iosUtil.pushToViewWithModuleName("PopView1","BaseViewController")
    //        alert(this.refs);
    //        this.refs.PopView4.setState({isHiden:false,actionView:this,title:"选择列表",data:["百度地图","高德地图"],selectedIndex:0,});
    //        NativeModules.iosUtil.pushToViewWithModuleName("Main","BaseViewController")
    //        NativeModules.iosUtil.pushToViewWithModuleName("TestListView","TestListViewController")
    //        alert(Images.common.searchIcon);
    //        alert(Global.width);
    //        alert(Global.unitWidth);
    //        alert(Global.pixelScale);
    //        global.variables.userAccount = "sssss";//{c:4, a:2, d:3, b:1}
    //        NativeModules.AndroidDialog.showModifyPwdDialog(
    //                                                        success => {
    //                                                        Alert.alert(success);
    //                                                        },
    //                                                        error => {
    //                                                        Alert.alert(error);
    //                                                        }
    //                                                        );

    //        StorageUtil.saveString("myKey1","chenxing").then(result => {
    //
    //
    //                                                         alert("saveString="+result);
    //                                                         }).catch(err => {
    //                                                                  alert("err="+err);
    //                                                                  });
    //["aa":"bb","cc","dd"]
    //        var dic = {c:4, a:2, d:3, b:1}; // 定义一个字典
    //
    //        StorageUtil.saveJsonObject("myKeyJson",dic).then(result => {
    //
    //
    //                                                                           alert("myKeyJsonsaveString="+result);
    //                                                                           }).catch(err => {
    //                                                                                    alert("err="+err);
    //                                                                                    });
  }
  //检查更新
  _onCheckUpgrade = () => {
    //        var myfun = this.myMap.get("mykey");
    //        myfun("kkk");
    postEventAction("mykey", { c: 4, a: 2, d: 3, b: 1 });
    //        NativeModules.iosUtil.pushToViewWithModuleName("Login","BaseViewController")
    //        alert(this.props);
    //        const { navigation } = this.props;
    //        navigation.navigate('SelectCarList');
    //        this.props.navigation.navigate('组件名')
    //      alert(global.variables.language);
    //        StorageUtil.remove("myKey1").then(result => {
    //
    //
    //                                          alert("remove="+result);
    //                                          }).catch(err => {
    //                                                   alert("err="+err);
    //                                                   });
    //        StorageUtil.remove("myKeyJson").then(result => {
    //
    //
    //                                          alert("remove="+result);
    //                                          }).catch(err => {
    //                                                   alert("err="+err);
    //                                                   });
  };
  //退出登录
  _onLoginOut() {
    if (Global.ios) {
      //            alert(global.variables.userAccount);
      //            JSON.stringify()
      //返回的都是 Promise
      //            StorageUtil.getString("myKey1","aaaa").then(result => {
      //
      //
      //                                                        alert("str="+result);
      //                                                        }).catch(err => {
      //                                                                 alert("err="+err);
      //                                                                 });

      //            StorageUtil.getJsonObject("myKeyJson","myKeyJson").then(result => {
      //
      //
      //                                                            alert(result);
      ////                                                             alert(JSON.stringify(result));
      //
      //                                                            }).catch(err => {
      //                                                                     alert("err="+err);
      //                                                                     });

      //本地调用
      NativeModules.iosUtil.pushToViewWithModuleName2(
        "SelectCarList",
        "SelectCarListViewController",
        { app: "appName", index: "indexValue" }
      );
      //   NativeModules.iosUtil.pushToNativeViewWithviewControllerName(
      //     "PlayBackViewController"
      //   );
      //            removeEventAction("mykey");
      //            removeAllEventAction();
    } else {
      NativeModules.AndroidUtils.finishActivity();
    }
  }
  timePickerChanged = text => {
//    alert(text);
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

        <TimePickerItem
          mode="date"
          format="YYYY-MM-DD"
          myStyle={styles.dateContent}
          timePickerItemChanged={text => {
            this.timePickerChanged(text);
          }}
        />

        <View style={styles.persionInfo}>
          <Image source={Images.common.persion_bg} />
          <View style={styles.phoneWap}>
            <Text style={styles.accountDes}>当前账号</Text>
            <Text style={styles.phoneStye}>18518758899</Text>
          </View>
        </View>
        <Image source={Images.common.persion_curtain} />
        <View style={styles.surplusSpace}>
          <View style={styles.blueBtnParent}>
            <LongBlueBtn
              name={"修改密码"}
              color={"#0e5db7"}
              onPress={this.onModifyPwd}
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

          <Text style={styles.versionInfo}>当前版本V1.0</Text>
        </View>

        <PopView4 ref="PopView4" />
      </View>
    );
  }
}
//<PopView1 ref = 'popView'></PopView1>
const styles = StyleSheet.create({
  dateContent: {
    //    flex: 1,
    width: 200,
    height: 40,
    //                                 marginLeft: 5,
    //                                 marginRight: 5,
    justifyContent: "center"
  },
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
