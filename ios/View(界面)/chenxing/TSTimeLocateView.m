//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "TSTimeLocateView.h"
#define kDuration 0.3
#define year_Nums 61
#define year_Nums_Add 60
#define month_Nums 12
#define rowHeight 44
//picker
static int const constNum_picker1 = -555;
static int const constNum_picker2 = -556;
static int const constNum_picker3 = -557;
@implementation TSTimeLocateView

@synthesize titleLabel;
@synthesize locatePicker,currentYear;
-(void)dealloc
{
//    [_yearContent release];
//    [_dayContent release];
//    [_monthContent release];
//    [_hourContent release];
//    [_minuteContent release];
//    [titleLabel release];
//    [locatePicker release];
//    [super dealloc];
}
+ (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    TSTimeLocateView *_self = [[[NSBundle mainBundle] loadNibNamed:@"TSTimeLocateView" owner:self options:nil] objectAtIndex:0];
    
    if (_self) {
        _self.delegate = delegate;
        _self.titleLabel.text = title;
        _self.locatePicker.dataSource = _self;
        _self.locatePicker.delegate = _self;
        _self.currentYear = [_self getCurrentYear];
//        if (IsiOS7Later)
//        {
            _self.locatePicker.backgroundColor = [UIColor whiteColor];
//        }

        //[locatePicker selectRow:0 inComponent:0 animated:YES];
    }
    return _self;
}

- (void)showInView:(UIView *) view
{
    self.tag = constNum_picker2;
    UIView *tempView = [view viewWithTag:constNum_picker2];
    UIView *tempView2 = [view viewWithTag:constNum_picker1];
    if (tempView2 != nil)
    {
        [tempView2 removeFromSuperview];
//        [NomalUtil closeWithAnimation:tempView2];
    }
    UIView *tempView3 = [view viewWithTag:constNum_picker3];
    if (tempView3 != nil)
    {
        [tempView3 removeFromSuperview];
//        [NomalUtil closeWithAnimation:tempView3];
    }
    if (tempView != nil)
    {
        [tempView removeFromSuperview];
//        return;
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
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];

    long year = [components year];
    long month = [components month];
    long day = [components day];
    long hour = [components hour];
    long minute = [components minute];
    
    self.yearContent = [NSString stringWithFormat:@"%ld",year];
    self.monthContent = [NSString stringWithFormat:@"%ld",month];
    self.dayContent = [NSString stringWithFormat:@"%ld",day];
    
    if(hour < 10)
    {
        self.hourContent = [NSString stringWithFormat:@"0%ld", hour];
    }
    else
    {
        self.hourContent = [NSString stringWithFormat:@"%ld", hour];
    }
    
    if(minute < 10)
    {
        self.minuteContent = [NSString stringWithFormat:@"0%ld", minute];
    }
    else
    {
        self.minuteContent = [NSString stringWithFormat:@"%ld", minute];
    }
    
//    [locatePicker selectRow:year_Nums inComponent:0 animated:YES];
//    [locatePicker selectRow:month - 1 inComponent:1 animated:YES];
//    [locatePicker selectRow:day - 1 inComponent:2 animated:YES];
//    [locatePicker selectRow:hour inComponent:3 animated:YES];
//    [locatePicker selectRow:minute inComponent:4 animated:YES];
    
    [locatePicker selectRow:hour inComponent:0 animated:YES];
    [locatePicker selectRow:minute inComponent:1 animated:YES];
    
    [locatePicker reloadAllComponents];
}

#pragma mark - PickerView lifecycle
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
//    return 5;
    return 2;
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
//        case 0:
//            return year_Nums + year_Nums_Add;
//            break;
//        case 1:
//            return month_Nums;
//            break;
//        case 2:
//        {
//            int year = [locatePicker selectedRowInComponent:0] + currentYear - year_Nums;
//            return [NomalUtil getMonthOfDaysWithYear:year
//                                               month:[locatePicker selectedRowInComponent:1]];
//        }
//            break;
//        case 3:
//        {
//            return 24;
//        }
//            break;
//        case 4:
//        {
//            return 60;
//        }
//            break;
        case 0:
        {
            return 24;
        }
            break;
        case 1:
        {
            return 60;
        }
            break;

        default:
            return 0;
            break;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return rowHeight;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat len = pickerView.frame.size.width - 20;
//    if (component == 0)
//    {
//        len = len/6 * 1.6;
//    }
//    else if (component == 1)
//    {
//        len = len/6 * 1.1;
//    }
//    else if (component == 2)
//    {
//        len = len/6 * 1.1;
//    }
//    else if (component == 3)
//    {
//        len = len/6 * 1.1;
//    }
//    else if (component == 4)
//    {
//        len = len/6 * 1.1;
//    }
    if (component == 0)
    {
        len = len/3 * 1.1;
    }
    else if (component == 1)
    {
        len = len/3 * 1.1;
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
        labelOnComponent.frame=view.frame;
        labelOnComponent.font = [UIFont boldSystemFontOfSize:20];
        [labelOnComponent setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:labelOnComponent];
//        [labelOnComponent release];
    }
    
    switch (component) {
//        case 0:
//        {
//            int num = currentYear - year_Nums + row;
//            labelOnComponent.text = [NSString stringWithFormat:@"%d年",num];
//        }
//            break;
//        case 1:
//            if(row + 1 < 10)
//            {
//                labelOnComponent.text =  [NSString stringWithFormat:@"0%d月",row+1];
//            }
//            else
//            {
//                labelOnComponent.text =  [NSString stringWithFormat:@"%d月",row+1];
//            }
//            break;
//        case 2:
//            if(row + 1 < 10)
//            {
//                labelOnComponent.text =  [NSString stringWithFormat:@"0%d日",row+1];
//            }
//            else
//            {
//                labelOnComponent.text =  [NSString stringWithFormat:@"%d日",row+1];
//            }
//            break;
//        case 3:
//            if(row < 10)
//            {
//                labelOnComponent.text =  [NSString stringWithFormat:@"0%d时",row];
//            }
//            else
//            {
//                labelOnComponent.text =  [NSString stringWithFormat:@"%d时",row];
//            }
//            break;
//        case 4:
//            if(row < 10)
//            {
//                labelOnComponent.text =  [NSString stringWithFormat:@"0%d分",row];
//            }
//            else
//            {
//                labelOnComponent.text =  [NSString stringWithFormat:@"%d分",row];
//            }
//            break;
        case 0:
            if(row < 10)
            {
                labelOnComponent.text =  [NSString stringWithFormat:@"0%ld时",(long)row];
            }
            else
            {
                labelOnComponent.text =  [NSString stringWithFormat:@"%ld时",(long)row];
            }
            break;
        case 1:
            if(row < 10)
            {
                labelOnComponent.text =  [NSString stringWithFormat:@"0%ld分",(long)row];
            }
            else
            {
                labelOnComponent.text =  [NSString stringWithFormat:@"%ld分",(long)row];
            }
            break;
        default:
            return nil;
            break;
    }
    
    
    
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    if (component == 0 || component == 1)
//    {
//        [locatePicker selectRow:[locatePicker selectedRowInComponent:2]
//              inComponent:2
//                 animated:NO];
//        [locatePicker reloadComponent:2];
//    }
//    if (component == 0)
//    {
//        int num = currentYear - year_Nums + row;
//        self.yearContent = [NSString stringWithFormat:@"%d",num];
//    }
//    else if (component == 1)
//    {
//        self.monthContent = [NSString stringWithFormat:@"%d",row+1];
//    }
//    else if (component == 2)
//    {
//        self.dayContent = [NSString stringWithFormat:@"%d",row+1];
//    }
//    else if (component == 3)
//    {
//        if(row < 10)
//        {
//            self.hourContent = [NSString stringWithFormat:@"0%d",row];
//        }
//        else
//        {
//            self.hourContent = [NSString stringWithFormat:@"%d",row];
//        }
//    }
//    else if (component == 4)
//    {
//        if(row < 10)
//        {
//            self.minuteContent = [NSString stringWithFormat:@"0%d",row];
//        }
//        else
//        {
//            self.minuteContent = [NSString stringWithFormat:@"%d",row];
//        }
//    }
     if (component == 0)
    {
        if(row < 10)
        {
            self.hourContent = [NSString stringWithFormat:@"0%ld",(long)row];
        }
        else
        {
            self.hourContent = [NSString stringWithFormat:@"%ld",(long)row];
        }
    }
    else if (component == 1)
    {
        if(row < 10)
        {
            self.minuteContent = [NSString stringWithFormat:@"0%ld",(long)row];
        }
        else
        {
            self.minuteContent = [NSString stringWithFormat:@"%ld",(long)row];
        }
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
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:_buttonIndex];
    }
    
}

@end
