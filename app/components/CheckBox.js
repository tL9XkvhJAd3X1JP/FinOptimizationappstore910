import React, { Component } from "react";
import {
  View,
  Image,
  TouchableHighlight,
  TouchableNativeFeedback
} from "react-native";
import Images from "../resource/Images";
import Globle from "../Global";
export default class CheckBox extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isChecked: this.props.isChecked || false
    };
  }

  getChecked() {
    return this.state.isChecked;
  }

  setChecked(isChecked) {
    this.setState({
      isChecked: isChecked
    });
  }

  checkClick() {
    this.setState({
      isChecked: !this.state.isChecked
    });
  }

  render() {
    const content = (
      <Image
        source={
          this.state.isChecked ? Images.common.checked : Images.common.unchecked
        }
      />
    );

    return (
      <View>
        {Globle.ios
          ? <TouchableHighlight
              underlayColor={"transparent"}
              onPress={() => this.checkClick()}
            >
              {content}
            </TouchableHighlight>
          : <TouchableNativeFeedback
              background={TouchableNativeFeedback.SelectableBackground()}
              onPress={() => this.checkClick()}
            >
              {content}
            </TouchableNativeFeedback>}
      </View>
    );
  }
}
