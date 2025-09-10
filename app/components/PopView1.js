/**@flow */
import React, { Component,PureComponent } from "react";
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
  KeyboardAvoidingView,
} from "react-native";
import { NativeModules } from "react-native";
import Images from "../resource/Images";
import LongBlueBtn from "../components/LongBlueBtn";
//使用方法
//1.导入import PopView1 from "../components/PopView1";
//2.<PopView1 ref = 'popView'></PopView1>  写在render(){}最外层的<View>内
//3.类内加入回调方法
//popOkClick=()=>
//{
//    alert(this.refs.popView.oldPassword);
//alert(this.refs.popView.newPassword);
//}
//4.显示弹框调用this.refs.popView.setState({isHiden:false,actionView:this,});

//修改密码框 //PureComponent Component
export default class PopView1 extends PureComponent {
    constructor(props){
        super(props);
        //initialProps
//        var object = props.hasOwnProperty('object') ? props.object : null;
        //JSON.stringify(props)
        //        alert(JSON.stringify(object));
//        this._onChangeText = this._onChangeText.bind(this);
        
        this.state =
        {
            isHiden:true,//是否隐藏
            actionView:null,//当前界面的this对象
        }
        //使用的界面要实现popOkClick();方法 this.oldPassword this.newPassword是返回值
    }
    _hideView=()=>
    {
       
        this.setState({ isHiden: true,//设置state为正在加载
                      actionView:null,
                      });
        
    }
    //提交
    _subPress=()=> {
        //        alert(this.account);
        //        alert(this.password);
//        alert(this.state.actionView);
        if(this.state.actionView != null)
        {
            //点确定回调的方法
            this.state.actionView.popOkClick();
        }
        
    }
    _onChangeText1=(inputData)=>{
        this.oldPassword = inputData;
        
    }
    _onChangeText2=(inputData)=>{
        this.newPassword = inputData;
       
    }
    render() {
        if(!this.state.isHiden)
        {
            return this.renderView();
        }
        else
        {
            
            return null;
        }
    }
    renderView(){
        return (
                <KeyboardAvoidingView style={styles.container} behavior="padding">
                <View style={styles.container2}>
                <View style={styles.container1}>
                <Text style={styles.text1}>修改密码</Text>
                <TouchableOpacity onPress={this._hideView} style={styles.closeImg}>
                <Image source={Images.common.close} style={styles.closeImg} />
                </TouchableOpacity>
                
                
                <TextInput
                style={styles.inputStyle1}
                //                onChangeText={(text) => this.setState({text})}
                onChangeText={this._onChangeText1}//输入框改变触发的函数
                //                value={this.state.text}
                placeholder="请输入旧密码"
                editable={true}//是否可编辑
                maxLength = {50}
                ref = 'account'
                //                blurOnSubmit = {true}
                returnKeyType='done'
                
                //                autoFocus = {true} // bool, 如果为ture，在componenDidMount后会获得焦点。默认false
                //                inlineImageLeft='searchIcon'//{Images.common.searchIcon}
                //                inlineImagePadding={15}
                // 如果为true,文本框会在提交的时候失焦。对于单行输入框默认值为ture,多行则为false。
                // 注意：对于多行输入框来说，如果为ture情况下，则在按下回车键时就会失去焦点同事触发
                // onSubmitEditing事件，而不会换行
                blurOnSubmit = {true}
                
                // 如果为false，会关闭键盘上拼写自动修正。默认值是true
                autoCorrect = {false}
                //enum('never', 'while-editing', 'unless-editing', 'always')
                // 清除按钮出现的时机
                clearButtonMode = {'while-editing'}
                />
                <TextInput
                style={styles.inputStyle2}
                //                onChangeText={(text) => this.setState({text})}
                onChangeText={this._onChangeText2}//输入框改变触发的函数
                //                value={this.state.text}
                placeholder="请输入新密码"
                editable={true}//是否可编辑
                maxLength = {50}
                ref = 'password'
                //                blurOnSubmit = {true}
                returnKeyType='done'
                secureTextEntry={true}
                //                inlineImageLeft='searchIcon'//{Images.common.searchIcon}
                //                inlineImagePadding={15}
                // 如果为true,文本框会在提交的时候失焦。对于单行输入框默认值为ture,多行则为false。
                // 注意：对于多行输入框来说，如果为ture情况下，则在按下回车键时就会失去焦点同事触发
                // onSubmitEditing事件，而不会换行
                blurOnSubmit = {true}
                
                // 如果为false，会关闭键盘上拼写自动修正。默认值是true
                autoCorrect = {false}
                // 清除按钮出现的时机
                //enum('never', 'while-editing', 'unless-editing', 'always')
                // 清除按钮出现的时机
                clearButtonMode = {'while-editing'}
                
                />
                <TouchableOpacity onPress={this._subPress}>
                <View style={styles.btnRender}>
                <Text style={styles.btnRenderText}>提 交</Text>
                </View>
                </TouchableOpacity>
                
                </View>
                </View>
                
                </KeyboardAvoidingView>
                );
    }
}

var contenViewWidth = Global.width - Global.unitPxWidthConvert(30);
var inputTextWidth = contenViewWidth - Global.unitPxWidthConvert(30);
var inputTextHeight = Global.unitPxWidthConvert(40);
var spaceH = Global.unitPxWidthConvert(15);
var space = Global.unitPxWidthConvert(15);

//var contenViewHeight = Global.width - Global.unitPxWidthConvert(30);
const styles = StyleSheet.create({
                                 container: {
//                                 flex: 1,
//                                 flexDirection: 'column',
                                 backgroundColor: 'rgba(0, 0, 0, 0.5)',
                                 width:Global.width,
                                 height:Global.height,
                                 justifyContent:"center",
                                 top:0,
                                 left:0,
                                 position: 'absolute',
                                 },
                                 container2: {
                                 flex: 1,
                                 //                                 flexDirection: 'column',
//                                 backgroundColor: 'rgba(0, 0, 0, 0.2)',
                                 width:Global.width,
                                 height:Global.height,
                                 justifyContent:"center",
                                 },
                                 container1: {
//                                 flex: 1,
                                 marginLeft:space,
                                 
//                                 flexDirection: 'column',
                                backgroundColor: "#FFFFFF",
                                 width:contenViewWidth,
                                 height:Global.unitPxWidthConvert(240),
                                 borderRadius:10,
//                                 height:Global.height,
                                 
//                                 justifyContent可以决定其子元素沿着主轴的排列方式。子元素对应的这些可选项有：flex-start、center、flex-end、space-around以及space-between
                                 justifyContent:"center",
                                 },
                                 text1:
                                 {
                                 //                                 flex: 1,
                                 fontWeight:"bold",
//                                 marginTop:spaceH,
                                 marginLeft:space,
                                 
                                 //                                 height:40,//contentViewHeight,
//                                 width:Global.width,
                                 lineHeight:Global.unitPxWidthConvert(20),
                                 color:"#0E5DB7",
                                 fontSize: Global.unitPxWidthConvert(15),
                                 textAlign:'left',
//                                 alignItems:'center',
//                                 justifyContent:'center',
//                                 textAlignVertical:'center',
                                 //                                 position: 'absolute',
                                 //                                 backgroundColor:'#FFFFFF'
                                 },
                                 closeImg:{
                                 top:0,
                                 right:0,
                                 borderTopRightRadius:10,
                                 width:Global.unitPxWidthConvert(60),
                                 height:Global.unitPxWidthConvert(53),
//                                 marginTop:Global.unitPxWidthConvert((60-36)/2),
                                 position: 'absolute',
//                                 backgroundColor:'#000000',
                                 },
                                 inputStyle1:{
                                 backgroundColor:'#FFFFFF',
                                 width:inputTextWidth,
                                 height:inputTextHeight,
                                 marginTop:spaceH,
                                borderColor:"#0E5DB7",
                                borderWidth:1,
                                 marginLeft:space,
                                 borderRadius:4,
                                 fontSize:Global.unitPxWidthConvert(13),
                                 color:'#5E5E5E',
                                 paddingLeft:5,
                                 },
                                 inputStyle2:{
                                 backgroundColor:'#FFFFFF',
                                 width:inputTextWidth,
                                 height:inputTextHeight,
                                 marginTop:spaceH,
                                 borderColor:"#0E5DB7",
                                 borderWidth:1,
                                 marginLeft:space,
                                 borderRadius:4,
                                 fontSize:Global.unitPxWidthConvert(13),
                                 color:'#5E5E5E',
                                 paddingLeft:5,
                                 },
                                 btnRender: {
                                 //                                 marginBottom: Global.unitPxWidthConvert(35)+Global.safeAreaViewHeight,
                                 marginTop:spaceH,
                                 width:inputTextWidth,
                                 marginLeft:space,
                                 height:inputTextHeight,
                                 backgroundColor:"#0e5db7",
                                 borderRadius:4,
                                 alignItems:'center',
                                 //                                 paddingTop: Global.unitPxHeightConvert(10)
                                 },
                                 btnRenderText:{
                                
                                 width:inputTextWidth,
                                 height:inputTextHeight,
                                 color:"#FFFFFF",
                                 fontSize: Global.unitPxWidthConvert(15),
                                 textAlign:'center',
                                 textAlignVertical:'center',
                                 lineHeight:inputTextHeight,
//                                 alignItems:'center',
                                 //                                 paddingTop: Global.unitPxHeightConvert(10)
                                 },
                                 
 
});
