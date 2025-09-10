//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
@interface TSTimeLocateView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource,CAAnimationDelegate> {
    int currentYear;
}

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (assign, nonatomic) NSInteger buttonIndex;
@property (assign, nonatomic) int currentYear;
@property (retain, nonatomic) NSString *yearContent;
@property (retain, nonatomic) NSString *monthContent;
@property (retain, nonatomic) NSString *dayContent;
@property (retain, nonatomic) NSString *hourContent;
@property (retain, nonatomic) NSString *minuteContent;

+ (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;

-(void)setFirstValues;

@end
