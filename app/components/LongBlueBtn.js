import React, { Component } from "react";
import {
  View,
  Text,
  TouchableNativeFeedback,
  TouchableHighlight,
  TouchableOpacity,
  StyleSheet
} from "react-native";
import Global from "../Global";

export default class LongBlueBtn extends Component {
  render() {
    const btnContent = (
      <View style={[styles.container, { backgroundColor: this.props.color }]}>
        <Text style={styles.buttonText}>
          {this.props.name}
        </Text>
      </View>
    );

    const comView = Global.ios
      ? <TouchableOpacity onPress={this.props.onPress}>
          {btnContent}
        </TouchableOpacity>
      : <TouchableOpacity
          // background={TouchableNativeFeedback.SelectableBackground()}
          onPress={this.props.onPress}
        >
          {btnContent}
        </TouchableOpacity>;

    return (
      <View>
        {comView}
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    height: Global.unitPxWidthConvert(40),
    borderBottomLeftRadius: 4,
    borderBottomRightRadius: 4,
    borderTopLeftRadius: 4,
    borderTopRightRadius: 4,
    justifyContent: "center",
    alignItems: "center"
  },
  buttonText: {
    color: "#ffffff",
    fontSize: Global.unitPxWidthConvert(12)
  }
});
