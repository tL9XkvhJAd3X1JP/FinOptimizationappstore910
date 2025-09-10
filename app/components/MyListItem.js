import React, { Component } from "react";
import {
    View,
    TouchableOpacity
} from "react-native";
import Global from "../Global";

export default class MyListItem extends React.PureComponent {
    _onPress = () => {
        this.props.onPressItem(this.props.id);
    };
    
    render() {
//        const textColor = this.props.selected ? "red" : "black";
        return (
                <TouchableOpacity onPress={this._onPress}>
                
                </TouchableOpacity>
                );
    }
}


//<View style={{ backgroundColor: textColor }}>
//<Text style={{ color: textColor }}>
//{this.props.title}
//</Text>
//
//</View>
