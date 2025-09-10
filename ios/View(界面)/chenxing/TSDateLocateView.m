//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "TSDateLocateView.h"
#define kDuration 0.3
#define year_Nums 61
#define year_Nums_Add 60
#define month_Nums 12
#define rowHeight 44
//picker
static int const constNum_picker1 = -555;
static int const constNum_picker2 = -556;
static int const constNum_picker3 = -557;

@implementation TSDateLocateView

@synthesize titleLabel;
@synthesize locatePicker,currentYear;
-(void)dealloc
{
//    [_yearContent release];
//    [_dayContent release];
//    [_monthContent release];
//    [titleLabel release];
//    [locatePicker release];
//    [super dealloc];
}
+ (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    TSDateLocateView *_self = [[[NSBundle mainBundle] loadNibNamed:@"TSDateLocateView" owner:self options:nil] objectAtIndex:0];
    
    if (_self) {
        _self.delegate = delegate;
        _self.titleLabel.text = title;
        _self.locatePicker.dataSource = _self;
        _self.locatePicker.delegate = _self;
        _self.currentYear = [_self getCurrentYear];
        _self.locatePicker.backgroundColor = [UIColor whiteColor];

        //[locatePicker selectRow:0 inComponent:0 animated:YES];
    }
    return _self;
}

- (void)showInView:(UIView *) view
{
    self.tag = constNum_picker2;
    UIView *tempView = [view viewWithTag:constNum_picker2];
    UIView *tempView2 = [view viewWithTag:constNum_picker1];
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
    [self setFirstValues];
    
    
}
-(void)setFirstValues
{
    NSString *date = [NomalUtil getCurrentDate:NO];
    [self setFirstValuesWithStr:date];
}
-(void)setFirstValuesWithStr:(NSString *)dateStr
{
    NSArray *array = [dateStr componentsSeparatedByString:@"-"];
    int year = [[array objectAtIndex:0] intValue];
    int month = [[array objectAtIndex:1] intValue];
    int day = [[array objectAtIndex:2] intValue];
    self.yearContent = [NSString stringWithFormat:@"%d",year];
    self.monthContent = [NSString stringWithFormat:@"%d",month];
    self.dayContent = [NSString stringWithFormat:@"%d",day];
    int yearRow = year - currentYear + year_Nums;
    [locatePicker selectRow:yearRow inComponent:0 animated:YES];
    [locatePicker selectRow:month - 1 inComponent:1 animated:YES];
    [locatePicker selectRow:day - 1 inComponent:2 animated:YES];
    [locatePicker reloadAllComponents];

}
#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(int) getCurrentYear
{
    //计算当前年，最好根据服务器时间进行调整
    NSString *date = [NomalUtil getCurrentDate:NO];

    return  [[date substringToIndex:4] intValue];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return year_Nums + year_Nums_Add;
            break;
        case 1:
            return month_Nums;
            break;
        case 2:
        {
            NSInteger year = [locatePicker selectedRowInComponent:0] + currentYear - year_Nums;
            return [NomalUtil getMonthOfDaysWithYear:year
                                               month:[locatePicker selectedRowInComponent:1]];
        }
            
            break;
        default:
            return 0;
            break;
    }
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    switch (component) {
//        case 0:
//        {
//            int num = currentYear - year_Nums + row;
//            return [NSString stringWithFormat:@"%d年",num];
//        }
//            
//            
//            break;
//        case 1:
//            return [NSString stringWithFormat:@"%d月",row+1];
//            break;
//        case 2:
//            return [NSString stringWithFormat:@"%d日",row+1];
//            break;
//        default:
//            return nil;
//            break;
//    }
//}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return rowHeight;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat len = pickerView.frame.size.width - 20;
//    CGFloat len = ScreenWidth - 20;
    if (component == 0)
    {
        len = len/4 * 1.3;
    }
    else if (component == 1)
    {
        len /=4;
        
    }
    else if (component == 2)
    {
        len /=4;
    }
    return len;
}

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
        labelOnComponent.tag = 1;
//        if (IsiOS7Later)
//        {
//            labelOnComponent.backgroundColor = [UIColor whiteColor];
//            labelOnComponent.textColor = [UIColor blackColor];
//        }
        labelOnComponent.frame=view.frame;
        labelOnComponent.font = [UIFont boldSystemFontOfSize:20];
        [labelOnComponent setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:labelOnComponent];
//        [labelOnComponent release];
    }
    
    switch (component) {
        case 0:
        {
            long num = currentYear - year_Nums + row;
            labelOnComponent.text = [NSString stringWithFormat:@"%ld年",num];
        }
            break;
        case 1:
            
            labelOnComponent.text =  [NSString stringWithFormat:@"%ld月",(long)(row+1)];
            break;
        case 2:
            labelOnComponent.text =  [NSString stringWithFormat:@"%ld日",(long)(row+1)];
            break;
        default:
            return nil;
            break;
    }
    
    
    
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0 || component == 1)
    {
        [locatePicker selectRow:[locatePicker selectedRowInComponent:2]
                    inComponent:2
                       animated:YES];
        
        [locatePicker reloadComponent:2];
                
    }

    if (component == 0)
    {
        long num = currentYear - year_Nums + row;
        self.yearContent = [NSString stringWithFormat:@"%ld",num];
    }
    else if (component == 1)
    {
        self.monthContent = [NSString stringWithFormat:@"%ld",(long)(row+1)];
    }
    else if (component == 2)
    {
        self.dayContent = [NSString stringWithFormat:@"%ld",(long)(row+1)];
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
//    if(self.delegate) {
//        [self.delegate actionSheet:self clickedButtonAtIndex:0];
//    }
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
    long maxDay = [NomalUtil getMonthOfDaysWithYear:[_yearContent intValue] month:[_monthContent intValue] - 1];
    if ([_dayContent intValue] > maxDay)
    {
        self.dayContent = [NSString stringWithFormat:@"%ld",maxDay];
    }
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:_buttonIndex];
    }
    
}

@end
