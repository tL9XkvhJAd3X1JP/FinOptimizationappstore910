//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "TSOneLocateView.h"
#define kDuration 0.3
static int const constNum_picker1 = -555;
static int const constNum_picker2 = -556;
static int const constNum_picker3 = -557;
@implementation TSOneLocateView

@synthesize titleLabel;
@synthesize locatePicker;
@synthesize arrayData;
-(void)dealloc
{

}
+ (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate data:(NSArray *)array
{
    
    TSOneLocateView *_self = [[[NSBundle mainBundle] loadNibNamed:@"TSOneLocateView" owner:self options:nil] objectAtIndex:0];
   
    if (_self) {
        _self.delegate = delegate;
        _self.titleLabel.text = title;
        _self.locatePicker.dataSource = _self;
        _self.locatePicker.delegate = _self;
        _self.arrayData = array;
        _self.locatePicker.backgroundColor = [UIColor whiteColor];

        //[locatePicker selectRow:0 inComponent:0 animated:YES];
    }
    return _self;
}

-(void)setFirstValues:(NSInteger)row
{
    self.titleName = [arrayData objectAtIndex:row];
    [locatePicker selectRow:row inComponent:0 animated:YES];
    [locatePicker reloadAllComponents];
}
- (void)showInView:(UIView *) view
{
    self.tag = constNum_picker1;
    UIView *tempView = [view viewWithTag:constNum_picker1];
    UIView *tempView2 = [view viewWithTag:constNum_picker2];
    UIView *tempView3 = [view viewWithTag:constNum_picker3];
    if (tempView2 != nil)
    {
        [tempView2 removeFromSuperview];
        //        [NomalUtil closeWithAnimation:tempView2];
    }
    if (tempView3 != nil)
    {
        [tempView3 removeFromSuperview];
        //        [NomalUtil closeWithAnimation:tempView3];
    }
    if (tempView != nil)
    {
        [tempView removeFromSuperview];
        //        [NomalUtil closeWithAnimation:tempView];
    }
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, view.frame.size.width, self.frame.size.height);
    self.titleLabel.centerX = [self.titleLabel superview].width/2;
    
    [view addSubview:self];
    [self setFirstValues:0];
    
}
- (void)showInView:(UIView *) view row:(int)row
{
    [self showInView:view];
    self.titleName = [arrayData objectAtIndex:row];
    [locatePicker selectRow:row inComponent:0 animated:YES];
    [locatePicker reloadAllComponents];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [arrayData count];
            break;
//        case 1:
//            return [cities count];
//            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat len = pickerView.frame.size.width - 20;
    return len;
}


//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//
//}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //取得指定列的宽度
    CGFloat width=[self pickerView:pickerView widthForComponent:component];
    
    //取得指定列，行的高度
    CGFloat height=[self pickerView:pickerView rowHeightForComponent:component];
    
    //定义一个视图
    if (view == nil)
    {
        view = [[UIView alloc] init];
    }
    //指定视图frame
    
    UILabel *labelOnComponent = (UILabel *)[view viewWithTag:1];
    if (labelOnComponent == nil)
    {
        view.frame= CGRectMake(0, 0, width, height);
        labelOnComponent = [[UILabel alloc] init];
        labelOnComponent.backgroundColor = [UIColor clearColor];
//        if (IsiOS7Later)
//        {
//            labelOnComponent.backgroundColor = [UIColor whiteColor];
//            labelOnComponent.textColor = [UIColor blackColor];
//        }
        labelOnComponent.tag = 1;
        labelOnComponent.frame=view.frame;
        labelOnComponent.font = [UIFont boldSystemFontOfSize:20];
        [labelOnComponent setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:labelOnComponent];
//        [labelOnComponent release];
    }
    
    switch (component) {
        case 0:
        {
           labelOnComponent.text =  [arrayData objectAtIndex:row];
        }
            
            break;
        default:
            return nil;
            break;
    }
    
    
    return view;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            [self setFirstValues:row];
            
//            [self.locatePicker selectRow:0 inComponent:0 animated:NO];
            //[self.locatePicker reloadComponent:1];
        
            break;
//        case 1:
//            self.locate.city = [cities objectAtIndex:row];
//            
//            break;
        default:
            break;
    }
}


#pragma mark - Button lifecycle

- (IBAction)cancel:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (IBAction)locate:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:_buttonIndex];
    }
    
}

@end
