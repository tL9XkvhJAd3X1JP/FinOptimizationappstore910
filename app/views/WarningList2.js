import React, { Component } from "react";
import {
  Button,
  Alert,
  View,
  Text,
  StatusBar,
  Image,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  FlatList,
  NativeModules,
  AppRegistry,
  DeviceEventEmitter,
  NativeAppEventEmitter,
  NativeEventEmitter,
  RefreshControl,
  ActivityIndicator
} from "react-native";
import TitleBar from "../components/TitleBar";
import Global from "../Global";
import LongBlueBtn from "../components/LongBlueBtn";
import Images from "../resource/Images";
import { postFetch } from "../network/request/HttpExtension";
import moment from "moment";
//import TimePickerItem from "../components/TimePickerItem";
import DatePicker from "react-native-datepicker";
// import { parse } from "querystring";

//var listData = null;
const NativeEvents = new NativeEventEmitter(NativeModules.EventUtil);
export default class WarningList2 extends Component {
  constructor(props) {
    super(props);
    //initialProps
    this.alarmType = props.hasOwnProperty("object") ? props.object : "19";
    this.typeName = "异常聚集报警";
    //JSON.stringify(props)
    //        alert(JSON.stringify(object));

    this.state = {
      data: null,
      isLoading: false,
      isLoadingMore: false,
      page: 0,
      startTimeValue: "",
      endTimeValue: ""
    };
  }

    componentWillUnmount() {
        removeEventAction("dealState2");
    }

  componentDidMount() {
//    this.startTimeValue = moment(new Date().getTime()).format("YYYY-MM-DD");
      registEventAction("dealState2", data => {
                        //                      alert(JSON.stringify(data));
                        // alert(data);
                        var item = JSON.parse(data);
                        this.state.data.splice(item.indexRow, 1);
                        this.setState({
                                      data: this.state.data //把数据重置为最新
                                      });
                        
                        //数据处理
                        });
    this.loadData(true);
  }

  loadData = refreshing => {
    //根据传入数据判断是上拉还是下拉
    //正在请求的时候要等
    if (this.state.isLoading == true || this.state.isLoadingMore == true) {
      return;
    }
    if (refreshing) {
      //如果是下拉
      this.setState({
        isLoading: true //设置state为正在加载
        //        page: 0
      });
      this.state.page = 0;
    } else {
      this.setState({
        isLoadingMore: true //设置state为正在加载
        //        page: this.state.page + 1
      });
      this.state.page++;
    }

    const param = new Map();

    param.set("pageIndex", this.state.page);
    param.set("pageRows", "10");

    param.set("companyId", global.userAccount.companyId);
    if (this.startTimeString != null && this.endTimeString != null) {
      param.set("startAlarmTime", this.startTimeString);
      param.set("endAlarmTime", this.endTimeString);

      //        param.set(
      //                  "startAlarmTime",
      //                  moment(new Date().getTime() - 15 * 24 * 3600 * 1000).format("YYYY-MM-DD")
      //                  );
      //        param.set(
      //                  "endAlarmTime",
      //                  moment(new Date().getTime()).format("YYYY-MM-DD")
      //                  );
    }

    UserRequest.getInstance().getAbnormalGatherRecord(
      param,
      (data, requestParm) => {
        let dataArray = [];
        if (refreshing) {
          //                      alert(JSON.stringify(data));
          //最后把结果置回来
          this.setState({
            data: data, //把数据重置为最新
            isLoading: false, //把加载状态设置为不加载（即加载结束）
            isLoadingMore: false
          });
        } else {
          //                        this.showToast('已加载全部');
          //如果上拉，添加数据
          if (data != null) {
            dataArray = this.state.data.concat(data);
          }

          //最后把结果置回来
          this.setState({
            data: dataArray, //把数据重置为最新
            isLoading: false, //把加载状态设置为不加载（即加载结束）
            isLoadingMore: false
          });
        }
      },
      (message, requestParm) => {
        //alert(message);
        showToastMessage(message);
        this.setState({
          data: null, //把数据重置为最新
          isLoading: false, //把加载状态设置为不加载（即加载结束）
          isLoadingMore: false
        });
      }
    );
  };
  //上拉更多动画
  genIndicator = () => {
    //底部加载(一个圆圈)
    return (
      <View style={styles.indicatorContainer}>
        <ActivityIndicator
          style={styles.indicator}
          size={"large"}
          color={"gray"}
          animating={true}
        />
        <Text style={styles.text_indicator}>Loading</Text>
      </View>
    );
  };
  //    componentDidMount() {
  //        //收到监听
  //        this.listener = DeviceEventEmitter.addListener('aaaa', (message) => {
  //                                                       //收到监听后想做的事情
  //                                                       alert(message);  //监听
  //                                                       })
  //    }
  //    componentWillUnmount() {
  ////        alert("componentWillUnmount");
  //        //移除监听
  //        if (this.listener) {
  ////            alert("remove");
  //            this.listener.remove();
  //        }
  //    }
  //请求完成时
  //    this.setState({
  //                  list: this.state.data.concat(responseData.movies),
  //                  loaded: true,
  //                  });

  //界面刷新
  //通过setNativeProps，不使用state和props，直接修改RN自带的组件

  //    loadData()
  //    {
  //        this.setState({
  //                      showValue:"",
  //                      list:null,
  //                      loaded: true,
  //                      });
  //
  //    }
  //    inlineImageLeft
  //    inlineImagePadding
  //    [{carName:"aaa",carStates:"1",sn:"123456",time:"2019-10-10 12:23:03"},{carName:"aaa",carStates:"1",sn:"123456",time:"2019-10-10 12:23:03"},{carName:"aaa",carStates:"1",sn:"123456",time:"2019-10-10 12:23:03"},{carName:"aaa",carStates:"1",sn:"123456",time:"2019-10-10 12:23:03"}]
  //界面的展示
  render() {
    return this.renderListView();
  }

  //    renderLoadingView() {
  //        return (
  //                <View style={styles.container}>
  //
  //                <StatusBar
  //                translucent={true}
  //                backgroundColor={"#00000000"} //状态栏背景颜色
  //                barStyle={"light-content"}
  //                />
  //                <TitleBar name={"选择车辆"}/>
  //
  //                <View style={styles.mycontainer}>
  //
  //                <TextInput
  //                style={styles.inputStyle}
  //                //                onChangeText={(text) => this.setState({text})}
  //                onChangeText={this._onChangeText}//输入框改变触发的函数
  //                //                value={this.state.text}
  //                placeholder="请输入查询条件"
  //                editable={true}//是否可编辑
  //                maxLength = {50}
  //                ref = 'textInputRefer'
  //                //                blurOnSubmit = {true}
  //                returnKeyType='done'
  //                //                inlineImageLeft='searchIcon'//{Images.common.searchIcon}
  //                //                inlineImagePadding={15}
  //                />
  //
  //                <TouchableOpacity onPress={this.showData.bind(this)}>
  //                <View style={styles.btn}>
  //                <Text style={styles.wordC}>查询</Text>
  //                </View>
  //                </TouchableOpacity>
  //
  //                </View>
  //                <View style={styles.container_contentView}>
  //                <Text style ={styles.text_style}>
  //                正在加载数据...
  //                </Text>
  //                </View>
  //                </View>
  //                );
  //    }
  startTime = text => {
    //      this.refs.startDate.text = text;
    //      this.startTimeValue = text;
    this.setState({
      startTimeValue: text
    });
      this.startTimeString = text;
    if (this.startTimeString != null && this.endTimeString != null) {
      this.loadData(true);
    }

    //      alert(this.refs.startDate);
  };
  endTime = text => {
    //alert(text);
    //      this.endTimeValue = text;
    this.setState({
      endTimeValue: text
    });
      this.endTimeString = text;
    if (this.startTimeString != null && this.endTimeString != null) {
      this.loadData(true);
    }
  };
//    testClick =()=>{
//        alert(3333);
//    }
  renderListView() {
    return (
      <View style={styles.container}>
        <StatusBar
          translucent={true}
          backgroundColor={"#00000000"} //状态栏背景颜色
          barStyle={"light-content"}
        />

        <TitleBar name={this.typeName} />
        <View style={{ flexDirection: "row" }}>
          <View style={styles.date1View}>
            <DatePicker
              style={styles.dateContent}
              //              ref="startDate"
              date={this.state.startTimeValue}
              mode="date"
              format="YYYY-MM-DD"
              confirmBtnText="确定"
              cancelBtnText="取消"
              showIcon={true}
              iconSource={Images.common.arrow_down}
              //              hideText={false}
              maxDate={moment(new Date().getTime()).format("YYYY-MM-DD")}
              placeholder="查询开始时间"
              customStyles={{
                dateIcon: {
                  width: 15,
                  height: 8
                  //            position: 'absolute',
                  //            left: 0,
                  //            top: 4,
                  //            marginLeft: 0
                },
                dateInput: {
                  borderWidth: 0
                },
                dateText: {
                  color: "gray",
                  fontSize: Global.unitPxWidthConvert(13)
                },
                placeholderText: {
                  fontSize: Global.unitPxWidthConvert(13)
                }
              }}
              onDateChange={datetime => {
                this.startTime(datetime);
              }}
//            onPressDate={()=>{this.testClick();}}
            />
          </View>
          <View style={styles.date1View}>
            <DatePicker
              style={styles.dateContent}
              date={this.state.endTimeValue}
              //            date={this.state.datetime}
              mode="date"
              format="YYYY-MM-DD"
              confirmBtnText="确定"
              cancelBtnText="取消"
              showIcon={true}
              iconSource={Images.common.arrow_down}
              //            hideText={true}
              maxDate={moment(new Date().getTime()).format("YYYY-MM-DD")}
              placeholder="查询结束时间"
              customStyles={{
                dateIcon: {
                  width: 15,
                  height: 8
                  //            position: 'absolute',
                  //            left: 0,
                  //            top: 4,
                  //            marginLeft: 0
                },
                dateInput: {
                  borderWidth: 0
                },
                dateText: {
                  color: "gray",
                  fontSize: Global.unitPxWidthConvert(13)
                },
                placeholderText: {
                  fontSize: Global.unitPxWidthConvert(13)
                }
              }}
              onDateChange={datetime => {
                this.endTime(datetime);
              }}
              //            onDateChange={(datetime) => {this.setState({datetime: datetime});}}
            />
          </View>
        </View>

        <FlatList
          data={this.state.data}
          renderItem={this.renderRow}
          style={styles.list}
          //                keyExtractor={item => item.id}
          keyExtractor={(item, index) => index + ""}
          //                ItemSeparatorComponent={() => <View style={{
          //                height: 1,
          //                backgroundColor: '#D6D6D6'
          //                }}/>}
          ListEmptyComponent={this.emptyComponent}
          //2:自定义的下拉刷新
          refreshControl={
            //为控制listView下拉刷新的属性  用于自定义下拉图标设置
            <RefreshControl //这一组件可以用在ScrollView或ListView内部，为其添加下拉刷新的功能。
              title={"Loading"}
              colors={["gray"]} //android的刷新图标颜色
              tintColor={"gray"} //ios的刷新图标颜色
              titleColor={"gray"} //标题的颜色
              refreshing={this.state.isLoading} //判断是否正在刷新
              onRefresh={() => {
                //触动刷新的方法
                this.loadData(true); //加载数据(带参数)
              }}
            />
          }
          //3:自定义的上拉加载数据
          //                ListFooterComponent={() =>this.genIndicator()}//上拉加载更多的时候调用自定义的加载图标，一般为一个loading的圆圈（ActivityIndicator）
          //                onEndReached={() => {//当所有的数据都已经渲染过，并且列表被滚动到距离最底部时调用
          //                this.loadData()//加载数据（不带参数）
          //                }}
          onScroll={this.onScroll}
          ref="myFlatList"
          keyboardDismissMode="on-drag"
        />
      </View>
    );
  }
  onScroll = event => {
    if (
      event.nativeEvent.contentSize.height >
        event.nativeEvent.layoutMeasurement.height &&
      event.nativeEvent.contentSize.height -
        event.nativeEvent.contentOffset.y <=
        event.nativeEvent.layoutMeasurement.height * 1.33
    ) {
      this.loadData(); //加载数据（不带参数）
    }
  };
  //点击一条数据
  viewClick(item, index) {
    //      this.state.data.delete(index);

    item.indexRow = index;
    item.hasDeal = this.props.object == -1;
    //      alert(JSON.stringify(item));
    if (Global.ios && (this.alarmType == "12" || this.alarmType == "13")) {
      navigateTo("", JSON.stringify(item), "ProvinceLocationViewController2");
    } else {
      navigateTo(global.navigation.UnusualTogether, JSON.stringify(item));
    }
  }
  //点车的名字
  carNameClick(item) {
//      navigateTo("LoginView");
    // alert(JSON.stringify(item));
    //    navigateTo("CarArchives", item.cusId + "");
  }
  renderRow = ({ item, index }) => {
    // { item }是一种“解构”写法，请阅读ES2015语法的相关文档
    // item也是FlatList中固定的参数名，请阅读FlatList的相关文档
    return (
      <TouchableOpacity
        onPress={() => {
          this.viewClick(item, index);
        }}
      >
        <View style={styles.container_item}>
          <Text
            style={styles.text1}
            onPress={() => {
              this.carNameClick(item);
            }}
          >
            聚集数量：{item.alarmValue}
          </Text>
          <Text style={styles.text2}>
            {item.alarmTime} >
          </Text>

          <Text style={styles.text4}>
            位置：{item.address}
          </Text>
        </View>
      </TouchableOpacity>
    );
  };
  //numberOfLines={3}
  //                <Image source={Images.common.car_blue} style={styles.thumbImg} />
  //定义空布局
  emptyComponent = () => {
    return (
      <View style={styles.container_contentView}>
        <Text style={styles.text_style}>暂无数据,下拉刷新</Text>
      </View>
    );
  };
}

//<View style={{
//flex: 1,
//height: '100%',
//alignItems: 'center',
//justifyContent: 'center',
//backgroundColor: 'rgba(232, 232, 232, 1)',//,"#FFFFFF",
//}}>
//<Text style={styles.text_style}>暂无数据下拉刷新</Text>
//</View>

//<View style={styles.container_item}>
//<Image source={Images.common.car_blue} style={styles.thumbImg} />
//
//<Text style={styles.text1}>车辆名称</Text>
//<Text style={styles.text2}>停车</Text>
//<Text style={styles.text3}>18793939333</Text>
//<Text style={styles.text4}>2019-10-21 10:24:35</Text>
//</View>

//<Button //                {movie.title}
//style= {styles.button}
//title = '清除'
//onPress = {()=>{
//    this.refs.textInputRefer.clear();
//}}/>
//{height: 40, width:Global.width - Global.unitPxWidthConvert(20),borderColor: '#5E5E5E', borderWidth: 1,fontSize:Global.unitPxWidthConvert(15)}
//style = {{paddingLeft: Global.unitPxWidthConvert(10),paddingTop: Global.unitPxWidthConvert(10)}}
//width:Global.width - Global.unitPxWidthConvert(20),
//fontSize:Global.unitPxWidthConvert(15),paddingLeft: Global.unitPxWidthConvert(10)
//position: relative;
//position: absolute;
//React Native 中，position 默认值为 relative，即相对布局
//样式设置 position: 'absolute' 绝对布局
//justifyContent
//决定其子元素沿着主轴的排列方式。子元素对应的这些可选项有：
//flex-start、center、flex-end、space-around以及space-between
var buttonWidth = Global.unitPxWidthConvert(60);
var buttonHeight = Global.unitPxWidthConvert(30);
var space = Global.unitPxWidthConvert(10);
var inputTextWidth = Global.width - buttonWidth - space * 3;
var searchHeight = Global.unitPxWidthConvert(44);
var spaceH = (searchHeight - buttonHeight) / 2.0;

var contentViewHeight = Global.height - Global.titleHeight() - searchHeight;
var contentViewWidth = Global.width;
var pickerHeight = Global.unitPxWidthConvert(35);
var dateViewWidth = (contentViewWidth - space * 3) / 2;
const styles = StyleSheet.create({
  indicatorContainer: {
    flex: 1,
    alignItems: "center"
  },
  indicator: {
    color: "gray",
    margin: 10
  },
  text_indicator: {
    //                                 flex: 1,
    //                                 marginTop:(contentViewHeight-40)/2,
    width: contentViewWidth,
    //                                 height:40,//contentViewHeight,
    lineHeight: 30,
    color: "gray",
    fontSize: 13,
    textAlign: "center",
    alignItems: "center",
    justifyContent: "center",
    textAlignVertical: "center"
    //                                 position: 'absolute',
    //                                 backgroundColor:'#FFFFFF'
  },
  date1View: {
    //    flex: 1,
    width: dateViewWidth,
    height: pickerHeight,
    marginLeft: space,
    marginTop: space,
    borderWidth: 1,
    borderColor: "#afafaf",
    justifyContent: "center",
    alignItems: "center",
    fontSize: 12,
    borderRadius: 4,
    backgroundColor: "#FFFFFF"
  },

  dateContent: {
    //    flex: 1,
    width: dateViewWidth - space,
    height: pickerHeight,
    marginLeft: 5,
    marginRight: 5,
    justifyContent: "center"
  },
  list: {
    paddingTop: 0,
    paddingBottom: 10,
    backgroundColor: "rgba(232, 232, 232, 1)" //'#F5FCFF',
  },
  container_item: {
    flex: 1,
    //                                 flexDirection: 'column',
    width: contentViewWidth - Global.unitPxWidthConvert(10) * 2,
    //                                 height:Global.unitPxWidthConvert(120),
    backgroundColor: "#FFFFFF",
    marginTop: Global.unitPxWidthConvert(10),
    marginLeft: Global.unitPxWidthConvert(10),
    borderRadius: 4,
    justifyContent: "flex-start"
  },
  //                                 thumbImg:{
  //                                 marginLeft:Global.unitPxWidthConvert(10),
  //                                 width:Global.unitPxWidthConvert(19),
  //                                 height:Global.unitPxWidthConvert(36),
  //                                 marginTop:Global.unitPxWidthConvert((60-36)/2),
  //                                 },
  text1: {
    flex: 1,
    fontWeight: "bold",
    marginTop: Global.unitPxWidthConvert(10),
    left: Global.unitPxWidthConvert(10),

    //                                 height:40,//contentViewHeight,
    lineHeight: Global.unitPxWidthConvert(20),
    color: "#FF8400",
    fontSize: Global.unitPxWidthConvert(13),
    textAlign: "left"
    //                                 alignItems:'center',
    //                                 justifyContent:'center',
    //                                 textAlignVertical:'center',
    //                                 position: 'absolute',
    //                                 backgroundColor:'#FFFFFF'
  },
  text2: {
    flex: 1,
    marginTop: Global.unitPxWidthConvert(10),
    right: Global.unitPxWidthConvert(10),

    //                                 height:40,//contentViewHeight,
    lineHeight: Global.unitPxWidthConvert(20),
    color: "gray",
    fontSize: Global.unitPxWidthConvert(10),
    textAlign: "center",
    alignItems: "center",
    justifyContent: "center",
    textAlignVertical: "center",
    position: "absolute"
  },
  text3: {
    flex: 1,
    marginTop: Global.unitPxWidthConvert(10),
    //                                 bottom:Global.unitPxWidthConvert(10),
    //                                 top:Global.unitPxWidthConvert(10+10)+20,
    left: Global.unitPxWidthConvert(10),
    //                                 height:40,//contentViewHeight,
    lineHeight: Global.unitPxWidthConvert(20),
    color: "gray",
    fontSize: Global.unitPxWidthConvert(13),
    textAlign: "left",
    alignItems: "center",
    justifyContent: "center",
    textAlignVertical: "center"
    //                                 position: 'absolute',
    //                                 backgroundColor:'#FFFFFF'
  },
  text4: {
    flex: 1,

    marginTop: Global.unitPxWidthConvert(10),
    marginBottom: Global.unitPxWidthConvert(10),
    left: Global.unitPxWidthConvert(10),
    width: contentViewWidth - Global.unitPxWidthConvert(40),

    //                                 height:40,//contentViewHeight,
    //                                 lineHeight:20,
    color: "gray",
    fontSize: Global.unitPxWidthConvert(13),
    textAlign: "left",
    alignItems: "center",
    justifyContent: "center",
    textAlignVertical: "center"
    //                                 position: 'absolute',
    //                                 backgroundColor:'#FFFFFF'
  },
  container: {
    flex: 1,
    backgroundColor: "#e9e9e9"
  },
  container_contentView: {
    flex: 1,
    width: contentViewWidth,
    height: contentViewHeight,
    backgroundColor: "rgba(232, 232, 232, 1)", //,"#FFFFFF",
    justifyContent: "center"
  },
  text_style: {
    //                                 flex: 1,
    //                                 marginTop:(contentViewHeight-40)/2,
    width: contentViewWidth,
    //                                 height:40,//contentViewHeight,
    lineHeight: 40,
    color: "gray",
    fontSize: 16,
    textAlign: "center",
    alignItems: "center",
    justifyContent: "center",
    textAlignVertical: "center"
    //                                 position: 'absolute',
    //                                 backgroundColor:'#FFFFFF'
  },
  mycontainer: {
    //                                 marginTop:30,
    //竖直轴(column)方向,水平轴(row)方向排列
    //    flexDirection: "row",
    height: searchHeight,
    backgroundColor: "#FFFFFF"
  },
  inputStyle: {
    width: inputTextWidth,
    height: buttonHeight,
    marginTop: spaceH,
    borderColor: "#5E5E5E",
    borderWidth: 1,
    marginLeft: space,
    borderRadius: 4,
    fontSize: Global.unitPxWidthConvert(13),
    color: "#5E5E5E",
    paddingLeft: 5,
    paddingTop: 0,
    paddingBottom: 0
  },
  btn: {
    marginTop: spaceH,
    marginLeft: space,
    width: buttonWidth,
    height: buttonHeight,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#0e5db7",
    borderRadius: 4
  },
  wordC: {
    color: "white",
    fontSize: Global.unitPxWidthConvert(13)
  }
});
