import React, { Component } from "react";
import { View, StyleSheet } from "react-native";
/**
 * 横线
 *
 * @export
 * @class HorizontalGrayLine
 * @extends {Component}
 */
export default class HorizontalGrayLine extends Component {
  render() {
    return <View style={styles.container} />;
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    height: 1,
    backgroundColor: "#e9e9e9"
  }
});
