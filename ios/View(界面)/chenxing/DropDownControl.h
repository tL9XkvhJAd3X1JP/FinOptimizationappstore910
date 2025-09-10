//
//  SelectControl.h
//  GeneralMerchandiseStore
//
//  Created by user on 14-5-15.
//  Copyright (c) 2014年 maqianli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownControlDelegate <NSObject>
/**
 *返回选择的下拉列表框的索引
 */
-(void)selectedIndex:(NSInteger)selectIndex dropDownId:(int)dropDownId;

-(void)selectedText:(NSString *)selectText dropDownId:(int)dropDownId;

-(void)selectedIndex:(NSInteger)selectIndex selectText:(NSString *)selectText dropDownId:(int)dropDownId;

/**
 *删除下拉列表框的索引
 */
-(void)deleteDataArr:(NSInteger)dropDownId;
@end

@interface DropDownControl : UIView<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
/**
 *  初始化下拉列表框
 *  button:下拉按钮
 *  dataSourceArr:数据源
 *  dropDownId:列表框id
 *  delegate:代理对象
 */
-(id)initDropDown:(UIButton *)button dataSourceArr:(NSArray *)dataSourceArr dropDownId:(int)dropDownId delegate:(id)delegate;

/**
 *  初始化下拉列表框
 *  button:下拉按钮
 *  dataSourceArr:数据源
 *  cellFont:cell的字体
 *  dropHeight:下拉列表展开的高度
 *  dropDownId:列表框id
 *  delegate:代理对象
 */
-(id)initDropDown:(UIButton *)button dataSourceArr:(NSArray *)  dataSourceArr cellFont:(UIFont *) cellFont dropHeight:(float) dropHeight dropDownId:(int)dropDownId delegate:(id)delegate;

-(id)initDropDown:(UIButton *)button dataSourceArr:(NSArray *)  dataSourceArr cellFont:(UIFont *) cellFont cellHeight:(float) cellHeight dropHeight:(float) dropHeight dropDownId:(int)dropDownId delegate:(id)delegate;

/**
 *  初始化下拉列表框
 *  button:下拉按钮
 *  dataSourceArr:数据源
 *  dropDownId:列表框id
 *  delegate:代理对象
 *  hasDelete:是否允许删除
 */
-(id)initDropDown:(UIButton *)button dataSourceArr:(NSArray *)dataSourceArr dropDownId:(int)dropDownId delegate:(id)delegate hasDelete:(BOOL)hasDelete;

/**
 *  显示或隐藏下拉列表框   selectedIndex 选中行的索引
 *  返回值 1:打开  0:隐藏
 */
-(int)showOrHideDropDown:(int)selectedIndex;
/**
 *  隐藏下拉列表框
 *  返回值 0:隐藏
 */
-(int)hideDropDown;

-(void)refreshDataSourceArr:(NSArray *)dataSourceArr;

@property (assign,nonatomic)id<DropDownControlDelegate> delegate;
@property (assign,nonatomic) BOOL isShow;

@end
