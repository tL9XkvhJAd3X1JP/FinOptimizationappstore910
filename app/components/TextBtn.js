import React, { Component } from "react";
import { View, Text, ViewPropTypes, StyleSheet } from "react-native";
import PropTypes from "prop-types";
import Button from "./Button";
import Global from "../Global";

/**
 * 自定义button
 * 用法：
  <TextBtn
    title="提 交"
    onPress={() => {
      this._save();
    }}
    textStyle={{ color: "#ff0000" }}
    btnStyle={{ height: 100 }}
  />
 * @export
 * @class TextBtn
 * @extends {Component}
 */
export default class TextBtn extends Component {
  propTypes = {
    textStyle: Text.propTypes.style,
    btnStyle: ViewPropTypes.style
  };

  render() {
    const { btnStyle, textStyle } = this.props;
    return (
      <Button onPress={this.props.onPress}>
        <View style={[styles.button, btnStyle]}>
          <Text style={[styles.text, textStyle]}>
            {this.props.title}
          </Text>
        </View>
      </Button>
    );
  }
}

const styles = StyleSheet.create({
  button: {
    height: Global.unitPxWidthConvert(35),
    backgroundColor: "#0e5db7",
    borderRadius: 4,
    justifyContent: "center"
  },
  text: {
    fontSize: Global.unitPxWidthConvert(12),
    color: "#ffffff",
    textAlign: "center"
  }
});
