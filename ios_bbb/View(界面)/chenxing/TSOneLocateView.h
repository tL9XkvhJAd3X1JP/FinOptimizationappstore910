//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>

@interface TSOneLocateView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource,CAAnimationDelegate> {
@private
    NSArray *arrayData;
}

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (retain, nonatomic) NSArray *arrayData;
@property (assign, nonatomic) NSInteger buttonIndex;
@property (retain, nonatomic) NSString *titleName;//选中的条目


//1:CarType 2:CarModel 3:CarEngine
@property (assign, nonatomic) NSInteger typeLocate;

+ (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate data:(NSArray *)array;

- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *) view row:(int)row;
-(void)setFirstValues:(NSInteger)row;

@end
