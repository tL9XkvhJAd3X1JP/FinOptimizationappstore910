import React, { Component } from "react";
import { View, TextInput, ViewPropTypes, StyleSheet } from "react-native";
import PropTypes from "prop-types";
import Global from "../Global";

/**
 * 自定义InputView
 * 用法：
 * <Input
              inputStyle={{
                height: 35,
                backgroundColor: "#00000000",
                flex: 1
              }}
              hintColor="#afafaf"
              hint="请选择"
              editable={false}
              value={this.state.text}
            />
 * @export
 * @class Input
 * @extends {Component}
 */
export default class Input extends Component {
  constructor(props) {
    super(props);
    this.state = { text: "" };
  }

  propTypes: {
    inputStyle: ViewPropTypes.style
  };

  render() {
    const { inputStyle } = this.props;
    return (
      <TextInput
        style={[styles.input, inputStyle]}
        placeholder={this.props.hint}
        placeholderTextColor={this.props.hintColor}
        editable={this.props.editable}
        value={this.props.value}
        multiline={this.props.multiline}
        onChangeText={this.props.onChangeText}
      />
    );
  }
}

const styles = StyleSheet.create({
  input: {
    height: Global.unitPxWidthConvert(40),
    backgroundColor: "#ffffff",
    borderRadius: 4,
    paddingHorizontal: 8,
    color: "#000000",
    fontSize: Global.unitPxWidthConvert(12),
    padding: 0
  }
});
