import React, { Component } from "react";
import { Alert, Text, Image, View, StyleSheet } from "react-native";
import Input from "./Input";
import Button from "../components/Button";
import Global from "../Global";
import PropTypes from "prop-types";

export default class WarnDealItem extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <View>
        <Text
          style={{
            color: "#000000",
            fontSize: Global.unitPxWidthConvert(12),
            marginTop: 10
          }}
        >
          {this.props.name}
        </Text>
        <View
          style={[
            styles.select,
            {
              height: this.props.height
                ? this.props.height
                : Global.unitPxWidthConvert(35)
            }
          ]}
        >
          <Input
            inputStyle={{
              height: this.props.height
                ? this.props.height
                : Global.unitPxWidthConvert(35),
              backgroundColor: "#00000000",
              flex: 1,
              textAlignVertical: this.props.multiline ? "top" : "center",
              paddingTop: this.props.multiline ? 10 : null,
              paddingBottom: this.props.multiline ? 10 : null
            }}
            multiline={this.props.multiline}
            hintColor="#afafaf"
            hint="请输入"
            editable={true}
            onChangeText={this.props.onChangeText}
          />
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  select: {
    marginTop: 10,
    flexDirection: "row",
    alignItems: "center",
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
