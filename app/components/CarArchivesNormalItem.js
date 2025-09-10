import React, { Component } from "react";
import { View, Text, StyleSheet } from "react-native";
import Global from "../Global";
/**
 * 车辆档案->基本->条目样式 
 *
 * @export
 * @class CarArchivesPageOneNormalItem
 * @extends {Component}
 */
export default class CarArchivesPageOneNormalItem extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.propName}>
          {this.props.name}
        </Text>
        <Text style={styles.propValue}>
          {this.props.value}
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    height: Global.unitPxWidthConvert(40),
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    backgroundColor: "#ffffff",
    paddingHorizontal: 15
  },
  propName: {
    color: "#000000",
    fontWeight: "bold",
    fontSize: Global.unitPxWidthConvert(12)
  },
  propValue: {
    color: "#5e5e5e",
    fontSize: Global.unitPxWidthConvert(12)
  }
});
