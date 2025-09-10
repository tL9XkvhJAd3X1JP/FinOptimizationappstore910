//
//  TwoViewController.h
//  BaseProject
//
//  Created by janker on 2018/11/3.
//  Copyright © 2018 ChenXing. All rights reserved.
//
/**
 总结：在 Objective-C 语言中，一共有 3 种类型的 block：
 
 _NSConcreteGlobalBlock 全局的静态 block，不会访问外部局部变量。
 _NSConcreteStackBlock 保存在栈中的 block，当函数返回时会被销毁。
 _NSConcreteMallocBlock 保存在堆中的 block，当引用计数为 0 时会被销毁。
 
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
 
     NSLog(@"str0内存地址： %p",str0);    //0x107fcb088   在64位系统上得到的内存地址较短，说明存放在常量区（代码，常量，全局，堆，栈）
 */
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^RequestFinishBlock)(void);
@interface TwoViewController : BaseViewController
@property (nonatomic, copy) RequestFinishBlock finishBlock;
@property (nonatomic, assign) int tempInt;
@end

NS_ASSUME_NONNULL_END
