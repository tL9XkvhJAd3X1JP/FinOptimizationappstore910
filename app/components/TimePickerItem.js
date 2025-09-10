import React, { Component } from "react";
import { Alert, Text, Image, View, StyleSheet } from "react-native";
import Images from "../resource/Images";
import DatePicker from "react-native-datepicker";
import Global from "../Global";
import moment from "moment";
//props 中传一个myStyle =this.props.myStyle 放长和宽 位置
//下面是可设置的props
//style={[this.props.myStyle]}
//date={this.state.timeValue}
//mode={this.props.mode}
//format={this.props.format}
//maxDate={this.props.maxDate}
//minDate={this.props.minDate}
//placeholder={this.props.placeholder}
//this.props.date
//this.props.timePickerItemChanged(text);
//使用例子
//<TimePickerItem
//mode="date"  date, datetime and time
//format="YYYY-MM-DD"
//myStyle={styles.dateContent}
//timePickerItemChanged={text => {
//    this.timePickerChanged(text);
//}}
///>
export default class TimePickerItem extends Component {
  constructor(props) {
    super(props);
    this.state = {
//      date: this.props.date,
    timeValue:""
    };
      if(this.props.date != null)
      {
            this.changeDate(this.props.date);
      }
      
  }

  changeDate = text => {
      //设置完后要刷一下界面
    this.setState({
      timeValue: text
    });
    //选择后的返回值，以及回调的方法
    this.dateText = text;
    if(this.props.timePickerItemChanged != null)
    {
        this.props.timePickerItemChanged(text);
    }
    
  };
  render() {
    return (
      <DatePicker
                    //              ref="startDate"
        style={[styles.dateContent, this.props.myStyle]}
        date={this.state.timeValue}
        mode={this.props.mode}
        format={this.props.format}
        maxDate={this.props.maxDate}
        minDate={this.props.minDate}
        placeholder={this.props.placeholder}
        confirmBtnText="确定"
        cancelBtnText="取消"
        showIcon={true}
        iconSource={Images.common.arrow_down}
        //              hideText={false}
        
        
        customStyles={{
          dateIcon: {
            width: 15,
            height: 8
            //            marginRight:15,
            //            paddingRight:15,
            //            right:30,
            //            position: 'absolute',
            //            left: 0,
            //            top: 4,
            //            marginLeft: 0
          },
          dateInput: {
            borderWidth: 0
            //            borderRadius: 4,
            //            borderColor: "#afafaf",
            //            backgroundColor: "#FFFFFF",
            //            width:300,
            //            paddingRight:30,
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
          this.changeDate(datetime);
        }}
        //            onPressDate={()=>{this.testClick();}}
      />
    );
  }
}
const styles = StyleSheet.create({

  dateContent: {
    borderWidth: 1,
    borderRadius: 4,
    borderColor: "#afafaf",
    backgroundColor: "#FFFFFF",
    width: 200,
    height: 40,
    //    flex: 1,
    //    width: dateViewWidth - space,
    //    height: pickerHeight,
    //    marginLeft: 5,
    //    marginRight: 5,
    justifyContent: "center"
  }
});
