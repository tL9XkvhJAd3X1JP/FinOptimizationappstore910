//
//  BaseViewController.h
//  BaseProject
//
//  Created by janker on 2018/11/1.
//  Copyright © 2018 ChenXing. All rights reserved.
//
/**
 block 常见用法
 2.2 typedef简化Block的声明
 
 利用typedef简化Block的声明：
 
 声明
 
 typedef return_type (^BlockTypeName)(var_type);
 
 例子1：作属性
 
 //声明 typedef void(^ClickBlock)(NSInteger index); //block属性 @property (nonatomic, copy) ClickBlock imageClickBlock;
 
 例子2：作方法参数
 
 //声明 typedef void (^handleBlock)();
 //block作参数
 - (void)requestForRefuseOrAccept:(MessageBtnType)msgBtnType messageModel:(MessageModel *)msgModel handle:(handleBlock)handle{
 ...
 
 2.3 Block的常见用法
 2.3.1 局部位置声明一个Block型的变量
 
 位置
 
 return_type (^blockName)(var_type) = ^return_type (var_type varName) { // ... };
 blockName(var);
 
 例子
 
 void (^globalBlockInMemory)(int number) = ^(int number){ printf("%d \n",number);
 };
 globalBlockInMemory(90);
 
 2.3.2 @interface位置声明一个Block型的属性
 
 位置
 
 @property(nonatomic, copy)return_type (^blockName) (var_type);
 
 例子
 
 //按钮点击Block @property (nonatomic, copy) void (^btnClickedBlock)(UIButton *sender);
 
 2.3.3 在定义方法时，声明Block型的形参
 用法
 - (void)yourMethod:(return_type (^)(var_type))blockName;
 2.3.4 在调用如上方法时，Block作实参
 例子
 UIView+AddClickedEvent.m
 
 - (void)addClickedBlock:(void(^)(id obj))clickedAction{ self.clickedAction = clickedAction;
 // :先判断当前是否有交互事件，如果没有的话。。。所有gesture的交互事件都会被添加进gestureRecognizers中
 if (![self gestureRecognizers]) { self.userInteractionEnabled = YES; // :添加单击事件 UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
 [self addGestureRecognizer:tap];
 }
 }
 */
#import <UIKit/UIKit.h>
#import "XYTransitionProtocol.h"
#import "TwoLabelCell.h"
#import "Response.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController<YTKRequestAccessory,YTKRequestDelegate,UIGestureRecognizerDelegate,XYTransitionProtocol>
{
    NSMutableDictionary *viewDic;
//    TwoLabelCell *reuseCell;
}
//0:默认(导航上和contentview下) 1:导航和contentview重叠 2无导航 无contentview
@property (assign, nonatomic) int navType;

//@property (strong, nonatomic) MBProgressHUD *hud;
//是否支持右水滑返回
@property (assign, nonatomic) BOOL notRightScrollPop;

//下拉不刷
@property (assign, nonatomic) BOOL removeHeaderRequest;
//上拉不分页
@property (assign, nonatomic) BOOL removeFooterRequest;
//界面参数
@property (strong,nonatomic) NSMutableDictionary *viewDic;
//下半部分界面
@property (strong,nonatomic) UIView *contentView;
//头界面
@property (strong,nonatomic) UIView *headerView;
//左上角按钮名字
@property (strong,nonatomic) NSString *leftNavBtnName;
//右上角按钮名字
@property (strong,nonatomic) NSString *rightNavBtnName;

//左上角图片名字
@property (strong,nonatomic) NSString *leftNavBtnImg;
//右上角图片名字
@property (strong,nonatomic) NSString *rightNavBtnImg;

/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle StatusBarStyle;


@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UICollectionView * collectionView;

//@property (nonatomic, strong)TwoLabelCell *reuseCell;

-(void)showViewMessage:(NSString *)message afterDelayTime:(NSTimeInterval)delay block:(void(^)(void))block;
-(void)showViewMessageInfo:(NSString *)message afterDelayTime:(NSTimeInterval)delay block:(void(^)(void))block;
-(void)showViewMessage:(NSString *)message afterDelayTime:(NSTimeInterval)delay;
-(void)showViewMessage:(NSString *)message;
-(void)showNetWaiting;
-(void)closeNetWaiting;
-(void) pushToViewWithClassName:(NSString *) className;
-(void) pushToViewWithNewViewDicAndClassName:(NSString *) className;
//初始化开始的界面结构
-(void)initBaseFrame;

//nav左按钮
- (void) leftNavBtnPressed: (id) sender;
//nav右按钮
- (void) rightNavBtnPressed: (id) sender;
//取消网络请求
- (void)cancelRequest;
-(void)loadNavBarView;
#pragma mark tableview
-(void)headerRereshing;
-(void)footerRereshing;
-(void)tableViewEndRefreshing;
//显示二次确认
-(void)showCustomAlertViewWithTitle:(NSString *)title message:(NSString *)message okButtonTitle:(NSString *)okButtonTitle cancelBlock:(void(^)(void))cancelBlock okBlock:(void(^)(void))okBlock;

-(BOOL)popToViewControllWithClassName:(NSString *)className;
-(UIViewController *)getViewControllWithClassName:(NSString *)className;
-(void) pushToViewWithClassName:(NSString *) className animate:(BOOL)animate;

-(UITableViewCell *)getTabbleViewCellFrom:(id)sender;
-(UITableView *)getTabbleViewFrom:(id)sender;

-(void)showNoDataImage;
-(void)removeNoDataImage;
-(void)pushToViewWithReactNativeModuleName:(NSString *)moduleName viewControllerName:(NSString *)viewControllerName;
@end

NS_ASSUME_NONNULL_END
