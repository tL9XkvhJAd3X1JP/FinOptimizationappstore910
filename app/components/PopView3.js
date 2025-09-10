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
  FlatList,
} from "react-native";
import { NativeModules } from "react-native";
import Images from "../resource/Images";
import LongBlueBtn from "../components/LongBlueBtn";
//使用方法
//1.导入import PopView3 from "../components/PopView3";
//2.<PopView3 ref = 'PopView3'></PopView3>  写在render(){}最外层的<View>内
//3.类内加入回调方法
//popOkClick3=()=>
//{
//    alert(this.refs.PopView3.selectedItem);
//}
//4.显示弹框调用this.refs.PopView3.setState({isHiden:false,actionView:this,title:"选择列表",data:["百度地图","高德地图","腾讯地图"],});
//
//选择列表 //PureComponent Component
export default class PopView3 extends PureComponent {
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
            title:"选择列表",
            data:null,
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
//    _subPress=()=> {
//        //        alert(this.account);
//        //        alert(this.password);
////        alert(this.state.actionView);
//        if(this.state.actionView != null)
//        {
//            //点确定回调的方法
//            this.state.actionView.popOkClick3();
//        }
//
//    }

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
                <Text style={styles.text1}>{this.state.title}</Text>
                <TouchableOpacity onPress={this._hideView} style={styles.closeImg}>
                <Image source={Images.common.close} style={styles.closeImg} />
                </TouchableOpacity>
                
                
                
                
                <FlatList
                data={this.state.data}
                renderItem={this.renderRow}
                style={styles.list}
                //                ref={this.props.listRef}
                //                keyExtractor={item => item.id}
                keyExtractor={(item, index) => index+""}
                //                ItemSeparatorComponent={() => <View style={{
                //                height: 1,
                //                backgroundColor: '#D6D6D6'
                //                }}/>}
               
                //3:自定义的上拉加载数据
                //                ListFooterComponent={() =>this.genIndicator()}
                //上拉加载更多的时候调用自定义的加载图标，一般为一个loading的圆圈（ActivityIndicator）
                //onEndReachedThreshold  onEndReached
            
                
                //                keyboardShouldPersistTaps='always'
                //                onEndReachedThreshold={10}
                //                pageSize={10}
                //                initialListSize={20}
                //                automaticallyAdjustContentInsets = {false}
                //                contentOffset = {{x:0,y:0}}
                //                enableEmptySections={true}
                
                //                onEndReachedThreshold={0.2}
                //                onScrollBeginDrag={() => {
                ////                console.log('onScrollBeginDrag');
                ////                alert("onScrollBeginDrag");
                //                this.canAction = true;
                //                }}
                //                onScrollEndDrag={() => {
                ////                console.log('onScrollEndDrag');
                ////                alert("onScrollEndDrag");
                //                this.canAction = false;
                //                }}
                //                onMomentumScrollBegin={() => {
                ////                alert("onMomentumScrollBegin");
                ////                console.log('onMomentumScrollBegin');
                //                this.canAction = true;
                //                }}
                //                onMomentumScrollEnd={() => {
                ////                alert("onMomentumScrollEnd");
                ////                console.log('onMomentumScrollEnd');
                //                this.canAction = false;
                //                }}
//                onScroll={this.onScroll}
                ref = "myFlatList"
                keyboardDismissMode="on-drag"
                />
                
                
                
                </View>
                </View>
                
                </KeyboardAvoidingView>
                );
    }
    renderRow = ({item,index}) =>{
        return (
                <TouchableOpacity  onPress={() => {
                this.viewClick(item);
                }}>
                
                <View style={styles.container_item}>
                
                <Text style={styles.text_item}>{item}</Text>
                </View>
                </TouchableOpacity>
                );
    }
    viewClick(item){
//        alert(item);
        this.selectedItem = item;
        if(this.state.actionView != null)
        {
            //点确定回调的方法
            this.state.actionView.popOkClick3();
        }
        this._hideView();
    }
}
//{item[index]}
//<View style={styles.btnRender}>
//<Text style={styles.btnRenderText}>确 定</Text>
//</View>
var contenViewWidth = Global.width - Global.unitPxWidthConvert(30);
var inputTextWidth = contenViewWidth - Global.unitPxWidthConvert(30);
var inputTextHeight = Global.unitPxWidthConvert(40);
var spaceH = Global.unitPxWidthConvert(25);
var space = Global.unitPxWidthConvert(15);

var itemWidth = contenViewWidth - space*2;
var itemHeight = Global.unitPxWidthConvert(40);
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
                                 maxHeight:Global.height*0.75,
//                                 flexDirection: 'column',
//                                 backgroundColor: 'rgba(0, 0, 0, 0.2)',
                                 width:Global.width,
//                                 height:Global.height*0.7,
                                 
                                 justifyContent:"center",
                                 
                                 },
                                 container1: {//里面白背景框
//                                 flex: 1,
                                 marginLeft:space,
                                 
//                                 flexDirection: 'row',
                                backgroundColor: "#FFFFFF",
                                 width:contenViewWidth,
//                                 height:Global.unitPxWidthConvert(170),
                                 borderRadius:10,
//                                 height:Global.height,
                                 
//                                 justifyContent可以决定其子元素沿着主轴的排列方式。子元素对应的这些可选项有：flex-start、center、flex-end、space-around以及space-between
                                 justifyContent:"center",
                                 },
                                 text1:
                                 {
//                                 flex: 1,
                                 fontWeight:"bold",
                                 marginTop:spaceH,
//                                 paddingTop:10,
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
//                                position: 'absolute',
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
                              
                                 list: {
//                                 paddingTop: 0,
                                 paddingBottom: spaceH,
//                                 backgroundColor: 'rgba(232, 232, 232, 1)',//'#F5FCFF',
                                 },
                                 container_item: {
                                 flexDirection: 'row',
                                 width:itemWidth,
                                 height:itemHeight,
                                 backgroundColor:"#0e5db7",
                                 marginTop:spaceH,
                                 marginLeft:space,
                                 borderRadius:4,
                                 justifyContent:'center',
                                 },
                                 text_item:
                                 {
                                 //                                 flex: 1,
                                 fontWeight:"bold",
//                                 marginTop:spaceH,
                                 //                                 paddingTop:10,
//                                 marginLeft:space,
                                 
                                 //                                 height:40,//contentViewHeight,
                                 width:itemWidth,
                                 lineHeight:itemHeight,
                                 color:"#FFFFFF",
                                 fontSize: Global.unitPxWidthConvert(13),
                                 textAlign:'center',
//                                 alignItems:'center',
                                 //                                 justifyContent:'center',
                                 //                                 textAlignVertical:'center',
                                 //                                position: 'absolute',
                                 //                                 backgroundColor:'#FFFFFF'
                                 },
                                 
 
});
