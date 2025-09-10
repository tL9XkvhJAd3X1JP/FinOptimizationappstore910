/**@flow */
import React, { Component } from "react";
import Global from "../Global";
import {
  View,
  Text,
  StyleSheet,
  Image,
  TouchableOpacity,
  TouchableNativeFeedback
} from "react-native";
import { NativeModules } from "react-native";
import Images from "../resource/Images";

export default class TitleBar extends Component {
  _finish() {
    if (Global.ios) {
      NativeModules.Native.popViewTo("");
    } else {
      NativeModules.AndroidUtils.finishActivity();
    }
  }

  render() {
    const leftView = (
      <View style={styles.button}>
        <Image
          source={
            this.props.leftDisable
              ? null
              : this.props.leftImg
                ? this.props.leftImg
                : Images.common.arrow_back_left
          }
        />
      </View>
    );

    const rightView = (
      <View style={styles.button}>
        <Image
          source={
            this.props.rightDisable
              ? null
              : this.props.rightImg ? this.props.rightImg : null
          }
        />
      </View>
    );

    return (
      <View style={styles.wap}>
        <View style={styles.container}>
          {Global.ios
            ? <TouchableOpacity
                disabled={this.props.leftDisable}
                onPress={
                  this.props.onLeftPress ? this.props.onLeftPress : this._finish
                }
              >
                {leftView}
              </TouchableOpacity>
            : <TouchableOpacity
                disabled={this.props.leftDisable}
                // background={TouchableNativeFeedback.SelectableBackground()}
                onPress={
                  this.props.onLeftPress ? this.props.onLeftPress : this._finish
                }
              >
                {leftView}
              </TouchableOpacity>}

          <View style={styles.textCenter}>
            <Text style={styles.textStyle}>
              {this.props.name}
            </Text>
          </View>
          {Global.ios
            ? <TouchableOpacity
                disabled={
                  this.props.rightDisable == undefined && !this.props.rightImg
                    ? true
                    : this.props.rightDisable
                }
                onPress={
                  this.props.onRightPress ? this.props.onRightPress : null
                }
              >
                {rightView}
              </TouchableOpacity>
            : <TouchableOpacity
                disabled={
                  this.props.rightDisable == undefined && !this.props.rightImg
                    ? true
                    : this.props.rightDisable
                }
                // background={TouchableNativeFeedback.SelectableBackground()}
                onPress={
                  this.props.onRightPress ? this.props.onRightPress : null
                }
              >
                {rightView}
              </TouchableOpacity>}
        </View>
        {/* {Global.isAboveAndroidLollipop() || Global.ios
          ? null
          : <Image
              source={{ uri: "shadow_title" }}
              style={{ height: 7 * Global.unitHeight }}
            />} */}
        <Image
          // source={{ uri: "shadow_title" }}
          source={Images.common.shadow_title}
          style={{ height: 2, width: Global.width }}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  wap: {
    height: Global.titleHeight(),
    backgroundColor: "#0e5db7"
  },
  container: {
    paddingTop: Global.statusBarHeight,
    flex: 1,
    flexDirection: "row",
    justifyContent: "space-between"
  },
  button: {
    width: Global.titleHeight() - Global.statusBarHeight,
    height: Global.titleHeight() - Global.statusBarHeight,
    justifyContent: "center",
    alignItems: "center"
  },
  imgLeft: {
    width: 30 * Global.unitWidth,
    height: 55 * Global.unitWidth
  },
  textCenter: {
    height: Global.titleHeight() - Global.statusBarHeight,
    justifyContent: "center",
    alignItems: "center"
  },
  textStyle: {
    fontSize: Global.unitPxWidthConvert(15),
    color: "#ffffff"
  }
});
