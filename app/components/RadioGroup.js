import React, { Component } from "react";
import PropTypes from "prop-types";
import { StyleSheet, View, Text, ViewPropTypes } from "react-native";

import RadioButton from "./RadioButton";

const defaultSize = 20;
const defaultThickness = 1;
const defaultColor = "#007AFF";

/**
 *        <RadioGroup
          onSelect={(index, value) => this.onSelect(index, value)}
          style={styles.radioGroup}
          selectedIndex={1}
          tabUnCheckedIconNames={tabUnCheckedIconNames}
          tabCheckedIconNames={tabCheckedIconNames}
          activeColor="#ff8400"
          color="#ffffff"
          textStyle={{ fontSize: 12, paddingTop: 5 }}
          unChangeIndex={2}
          tabButtonStyle={{
            height: 60,
            flexDirection: "column",
            justifyContent: "center"
          }}
        >
          <RadioButton value={0}>
            <Text>监控</Text>
          </RadioButton>

          <RadioButton value={1}>
            <Text>预警</Text>
          </RadioButton>

          <RadioButton value={2}>
            <Text>我的</Text>
          </RadioButton>
        </RadioGroup> 
 *
 * @export
 * @class RadioGroup
 * @extends {Component}
 */
export default class RadioGroup extends Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      selectedIndex: this.props.selectedIndex
    };
    this.prevSelected = this.props.selectedIndex;
    this.onSelect = this.onSelect.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.selectedIndex != this.prevSelected) {
      this.prevSelected = nextProps.selectedIndex;
      this.setState({
        selectedIndex: nextProps.selectedIndex
      });
    }
  }

  getChildContext() {
    return {
      onSelect: this.onSelect,
      size: this.props.size,
      thickness: this.props.thickness,
      color: this.props.color,
      highlightColor: this.props.highlightColor
    };
  }

  onSelect(index, value) {
    this.setState({
      selectedIndex: index
    });
    if (this.props.onSelect) this.props.onSelect(index, value);
  }

  render() {
    var radioButtons = React.Children.map(
      this.props.children,
      (radioButton, index) => {
        let isSelected = this.state.selectedIndex == index;
        let color =
          isSelected && this.props.activeColor
            ? this.props.activeColor
            : this.props.color;
        let img = isSelected
          ? this.props.tabCheckedIconNames
            ? this.props.tabCheckedIconNames[index]
            : null
          : this.props.tabUnCheckedIconNames
            ? this.props.tabUnCheckedIconNames[index]
            : null;
        return (
          <RadioButton
            tabButtonStyle={this.props.tabButtonStyle}
            color={color}
            activeColor={this.props.activeColor}
            {...radioButton.props}
            index={index}
            isSelected={isSelected}
            img={img}
            textStyle={this.props.textStyle}
          >
            {radioButton.props.children}
          </RadioButton>
        );
      }
    );

    return (
      <View style={this.props.style}>
        {radioButtons}
      </View>
    );
  }
}

RadioGroup.childContextTypes = {
  onSelect: PropTypes.func.isRequired,
  size: PropTypes.number.isRequired,
  thickness: PropTypes.number.isRequired,
  color: PropTypes.string.isRequired,
  activeColor: PropTypes.string,
  highlightColor: PropTypes.string,
  // 保存Tab图标(未选中)
  tabUnCheckedIconNames: PropTypes.array,
  // 保存Tab图标(选中)
  tabCheckedIconNames: PropTypes.array,
  textStyle: ViewPropTypes.style,
  tabButtonStyle: ViewPropTypes.style,
  //不要改变的角标
  unChangeIndex: PropTypes.number
};

RadioGroup.defaultProps = {
  size: defaultSize,
  thickness: defaultThickness,
  color: defaultColor,
  highlightColor: null
};
