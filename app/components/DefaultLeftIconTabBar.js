const React = require("react");
const { ViewPropTypes } = (ReactNative = require("react-native"));
const PropTypes = require("prop-types");
const createReactClass = require("create-react-class");
const { StyleSheet, Text, Image, View, Animated } = ReactNative;
const Button = require("./Button");

const DefaultLeftIconTabBar = createReactClass({
  propTypes: {
    //跳转到对应tab的方法
    goToPage: PropTypes.func,
    //当前被选中的tab下标
    activeTab: PropTypes.number,
    //所有tabs集合
    tabs: PropTypes.array,
    backgroundColor: PropTypes.string,
    activeTextColor: PropTypes.string,
    inactiveTextColor: PropTypes.string,
    textStyle: Text.propTypes.style,
    tabStyle: ViewPropTypes.style,
    renderTab: PropTypes.func,
    underlineStyle: ViewPropTypes.style,
    // 保存Tab名称
    tabNames: PropTypes.array,
    // 保存Tab图标(未选中)
    tabUnCheckedIconNames: PropTypes.array,
    // 保存Tab图标(选中)
    tabCheckedIconNames: PropTypes.array
  },

  getDefaultProps() {
    return {
      activeTextColor: "navy",
      inactiveTextColor: "black",
      backgroundColor: null
    };
  },

  renderTabOption(name, page) {},

  renderTab(name, page, isTabActive, onPressHandler) {
    const {
      activeTextColor,
      inactiveTextColor,
      textStyle,
      tabUnCheckedIconNames,
      tabCheckedIconNames
    } = this.props;
    const textColor = isTabActive ? activeTextColor : inactiveTextColor;
    const fontWeight = isTabActive ? "bold" : "normal";
    const iconNames = isTabActive ? tabCheckedIconNames : tabUnCheckedIconNames;
    return (
      <Button
        style={{ flex: 1 }}
        key={name}
        accessible={true}
        accessibilityLabel={name}
        accessibilityTraits="button"
        onPress={() => onPressHandler(page)}
      >
        <View style={[styles.tab, this.props.tabStyle]}>
          <Image source={iconNames ? iconNames[page] : null} />
          <Text style={[{ color: textColor, fontWeight }, textStyle]}>
            {name}
          </Text>
        </View>
      </Button>
    );
  },

  render() {
    const containerWidth = this.props.containerWidth;
    const numberOfTabs = this.props.tabs.length;
    const tabUnderlineStyle = {
      position: "absolute",
      width: containerWidth / numberOfTabs,
      height: 4,
      backgroundColor: "navy",
      bottom: 0
    };

    const translateX = this.props.scrollValue.interpolate({
      inputRange: [0, 1],
      outputRange: [0, containerWidth / numberOfTabs]
    });
    return (
      <View
        style={[
          styles.tabs,
          { backgroundColor: this.props.backgroundColor },
          this.props.style
        ]}
      >
        {this.props.tabs.map((name, page) => {
          const isTabActive = this.props.activeTab === page;
          const renderTab = this.props.renderTab || this.renderTab;
          return renderTab(name, page, isTabActive, this.props.goToPage);
        })}
        <Animated.View
          style={[
            tabUnderlineStyle,
            {
              transform: [{ translateX }]
            },
            this.props.underlineStyle
          ]}
        />
      </View>
    );
  }
});

const styles = StyleSheet.create({
  tab: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    flexDirection: "row"
  },
  tabs: {
    height: 50,
    flexDirection: "row",
    justifyContent: "space-around",
    borderWidth: 1,
    borderTopWidth: 0,
    borderLeftWidth: 0,
    borderRightWidth: 0,
    borderColor: "#ccc"
  }
});

module.exports = DefaultLeftIconTabBar;
