import React, { Component } from "react";
import { Alert, Text, Image, View, StyleSheet } from "react-native";
import Input from "./Input";
import Images from "../resource/Images";
import Button from "../components/Button";
import DatePicker from "react-native-datepicker";
import Global from "../Global";

export default class GpsSetTimeItem extends Component {
  constructor(props) {
    super(props);
    this.state = {
      text: ""
    };
  }

  render() {
    return (
      <View>
        <Text style={{ color: "#000000", fontSize: 12, marginTop: 10 }}>
          {this.props.name}
        </Text>
        <View>
          <View style={styles.select}>
            <Input
              inputStyle={{
                height: Global.unitPxWidthConvert(35),
                backgroundColor: "#00000000",
                flex: 1
              }}
              hintColor="#afafaf"
              hint="请选择"
              editable={false}
              value={this.state.text}
            />
            <Image source={Images.common.arrow_down} />
          </View>
          <DatePicker
            style={{
              position: "absolute",
              width: Global.width - 40,
              marginTop: 10
            }}
            format="HH:mm"
            confirmBtnText="确定"
            cancelBtnText="取消"
            mode="time"
            showIcon={false}
            hideText={true}
            onDateChange={date => {
              this.setState({ text: date });
              this.props.onChangeText(date);
            }}
          />
        </View>
      </View>
    );
  }
}
const styles = StyleSheet.create({
  select: {
    flex: 1,
    marginTop: 10,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "flex-end",
    borderBottomColor: "#afafaf",
    borderTopColor: "#afafaf",
    borderLeftColor: "#afafaf",
    borderRightColor: "#afafaf",
    borderBottomWidth: 1,
    borderLeftWidth: 1,
    borderTopWidth: 1,
    borderRightWidth: 1,
    borderTopLeftRadius: 4,
    borderTopRightRadius: 4,
    borderBottomRightRadius: 4,
    borderBottomLeftRadius: 4,
    paddingRight: 5
  }
});
