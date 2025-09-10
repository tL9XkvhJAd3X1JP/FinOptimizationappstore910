
var buttonWidth = Global.unitPxWidthConvert(60);
var buttonHeight = Global.unitPxWidthConvert(30);
var space = Global.unitPxWidthConvert(10);
var inputTextWidth =Global.width - buttonWidth - space*3;
var searchHeight = Global.unitPxWidthConvert(44);
var spaceH = (searchHeight- buttonHeight)/2.0;

var contentViewHeight = Global.height - Global.titleHeight() - searchHeight;
var contentViewWidth = Global.width;
const viewStyles = StyleSheet.create({
                                     //居中显示在界面中间
                                     containerView_center: {
                                     flex: 1,
                                     width:contentViewWidth,
                                     height:contentViewHeight,
                                     backgroundColor: 'rgba(232, 232, 232, 1)',//,"#FFFFFF",
                                     justifyContent:'center'
                                     },
                                     text_center:
                                     {
                                     //                                 flex: 1,
                                     //                                 marginTop:(contentViewHeight-40)/2,
                                     width:contentViewWidth,
                                     //                                 height:40,//contentViewHeight,
                                     lineHeight:40,
                                     color:'gray',
                                     fontSize: 16,
                                     textAlign:'center',
                                     alignItems:'center',
                                     justifyContent:'center',
                                     textAlignVertical:'center',
                                     //                                 position: 'absolute',
                                     //                                 backgroundColor:'#FFFFFF'
                                     },
                                     });



