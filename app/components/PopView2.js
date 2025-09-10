/**@flow */
import React, { Component, PureComponent } from "react";
import Global from "../Global";
import {
  View,
  Text,
  StyleSheet,
  Image,
  TouchableHighlight,
  TouchableNativeFeedback,
  TextInput,
  TouchableOpacity,
  KeyboardAvoidingView
} from "react-native";
import { NativeModules } from "react-native";
import Images from "../resource/Images";
import LongBlueBtn from "../components/LongBlueBtn";
//使用方法
//1.导入import PopView2 from "../components/PopView2";
//2.<PopView2 ref = 'popView2'></PopView2>  写在render(){}最外层的<View>内
//3.类内加入回调方法
//popOkClick2=(messageId)=>
//{
//}
//4.显示弹框调用this.refs.popView2.setState({isHiden:false,actionView:this,message:"是否确定?",title:"好消息",messageId:1,});
//
//普通的二次确认框 //PureComponent Component
export default class PopView2 extends PureComponent {
  constructor(props) {
    super(props);
    //initialProps
    //        var object = props.hasOwnProperty('object') ? props.object : null;
    //JSON.stringify(props)
    //        alert(JSON.stringify(object));
    //        this._onChangeText = this._onChangeText.bind(this);

    this.state = {
      isHiden: true, //是否隐藏
      actionView: null, //当前界面的this对象
      title: "提示信息",
      message: "是否确定?",
      messageId: 0
    };
    //使用的界面要实现popOkClick();方法 this.oldPassword this.newPassword是返回值
  }
  _hideView = () => {
    this.setState({
      isHiden: true, //设置state为正在加载
      actionView: null
    });
  };
  _cancle = () => {
    if (this.state.actionView != null) {
      //点确定回调的方法
      try {
        this.state.actionView.popOkClick2Cancle(this.state.messageId);
      } catch (err) {}

      this._hideView();
    }
  };
  //提交
  _subPress = () => {
    //        alert(this.account);
    //        alert(this.password);
    //        alert(this.state.actionView);
    if (this.state.actionView != null) {
      //点确定回调的方法
      this.state.actionView.popOkClick2(this.state.messageId);
      this._hideView();
    }
  };

  render() {
    if (!this.state.isHiden) {
      return this.renderView();
    } else {
      return null;
    }
  }
  renderView() {
    return (
      <KeyboardAvoidingView style={styles.container} behavior="padding">
        <View style={styles.container2}>
          <View style={styles.container1}>
            <TouchableOpacity onPress={this._cancle} style={styles.closeImg}>
              <Image source={Images.common.close} style={styles.closeImg} />
            </TouchableOpacity>

            <Text style={styles.text1}>
              {this.state.title}
            </Text>

            <Text style={styles.text2}>
              {this.state.message}
            </Text>

            <TouchableOpacity onPress={this._subPress} style={styles.btnRender}>
              <Text style={styles.btnRenderText}>确 定</Text>
            </TouchableOpacity>
          </View>
        </View>
      </KeyboardAvoidingView>
    );
  }
}
//<View style={styles.btnRender}>
//<Text style={styles.btnRenderText}>确 定</Text>
//</View>
var contenViewWidth = Global.width - Global.unitPxWidthConvert(30);
var inputTextWidth = contenViewWidth - Global.unitPxWidthConvert(30);
var inputTextHeight = Global.unitPxWidthConvert(40);
var spaceH = Global.unitPxWidthConvert(25);
var space = Global.unitPxWidthConvert(15);

//var contenViewHeight = Global.width - Global.unitPxWidthConvert(30);
const styles = StyleSheet.create({
  container: {
    //                                 flex: 1,
    //                                 flexDirection: 'column',
    backgroundColor: "rgba(0, 0, 0, 0.5)",
    width: Global.width,
    height: Global.height,
    justifyContent: "center",
    top: 0,
    left: 0,
    position: "absolute"
  },
  container2: {
    flex: 1,
    //                                 flexDirection: 'column',
    //                                 backgroundColor: 'rgba(0, 0, 0, 0.2)',
    width: Global.width,
    //                                 height:Global.height,
    justifyContent: "center"
  },
  container1: {
    //里面白背景框
    //                                 flex: 1,
    marginLeft: space,

    //                                 flexDirection: 'row',
    backgroundColor: "#FFFFFF",
    width: contenViewWidth,
    //                                 height:Global.unitPxWidthConvert(170),
    borderRadius: 10,
    //                                 height:Global.height,

    //                                 justifyContent可以决定其子元素沿着主轴的排列方式。子元素对应的这些可选项有：flex-start、center、flex-end、space-around以及space-between
    justifyContent: "center"
  },
  text1: {
    //                                 flex: 1,
    fontWeight: "bold",
    marginTop: spaceH,
    //                                 paddingTop:10,
    marginLeft: space,

    //                                 height:40,//contentViewHeight,
    //                                 width:Global.width,
    lineHeight: Global.unitPxWidthConvert(20),
    color: "#0E5DB7",
    fontSize: Global.unitPxWidthConvert(15),
    textAlign: "left"
    //                                 alignItems:'center',
    //                                 justifyContent:'center',
    //                                 textAlignVertical:'center',
    //                                position: 'absolute',
    //                                 backgroundColor:'#FFFFFF'
  },
  text2: {
    //                                  flex: 1,
    //                                 fontWeight:"bold",
    marginTop: spaceH,
    marginLeft: space,

    //                                 height:40,//contentViewHeight,
    width: inputTextWidth,
    //                                 lineHeight:20,
    color: "#0E5DB7",
    fontSize: Global.unitPxWidthConvert(14),
    textAlign: "center",
    alignItems: "center",
    justifyContent: "center",
    textAlignVertical: "center"
    //                                 position: 'absolute',
    //                                 backgroundColor:'#FFFFFF'
  },
  closeImg: {
    top: 0,
    right: 0,
    borderTopRightRadius: 10,
    width: Global.unitPxWidthConvert(60),
    height: Global.unitPxWidthConvert(53),
    //                                 marginTop:Global.unitPxWidthConvert((60-36)/2),
    position: "absolute",
    padding: 0
    //                                 backgroundColor:'#000000',
  },

  btnRender: {
    //                                 flex: 1,
    //                                 marginBottom: Global.unitPxWidthConvert(35)+Global.safeAreaViewHeight,
    marginTop: spaceH,
    width: inputTextWidth,
    marginLeft: space,
    height: inputTextHeight,
    backgroundColor: "#0e5db7",
    borderRadius: 4,
    alignItems: "center",
    justifyContent: "center",
    marginBottom: spaceH
    //                                 paddingTop: Global.unitPxHeightConvert(10)
  },
  btnRenderText: {
    //                                 flex: 1,
    width: inputTextWidth,
    height: inputTextHeight,
    color: "#FFFFFF",
    fontSize: Global.unitPxWidthConvert(15),
    textAlign: "center",
    textAlignVertical: "center",
    lineHeight: inputTextHeight
    //                                 alignItems:'center',
    //                                 paddingTop: Global.unitPxHeightConvert(10)
  }
});
