//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
@interface TSDateLocateView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource,CAAnimationDelegate> {
    int currentYear;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (assign, nonatomic) NSInteger buttonIndex;
@property (assign, nonatomic) int currentYear;
@property (strong, nonatomic) NSString *yearContent;
@property (strong, nonatomic) NSString *monthContent;
@property (strong, nonatomic) NSString *dayContent;

+ (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;

-(void)setFirstValues;

-(void)setFirstValuesWithStr:(NSString *)dateStr;

@end
