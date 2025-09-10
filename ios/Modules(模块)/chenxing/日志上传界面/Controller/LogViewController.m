//
//  LogViewController.m
//  BaseProject
//
//  Created by janker on 2018/11/19.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import "LogViewController.h"
#import "FileUploadAction.h"
#import "ErrorReportLogic.h"
@interface LogViewController ()
{
    ErrorReportLogic *errorReportLogic;
}
@end

@implementation LogViewController

- (void)viewDidLoad
{
    
//    [self AlertWithTitle:@"" message:nil andOthers:<#(NSArray<NSString *> *)#> animated:YES action:^(NSInteger index) {
//        <#code#>
//    }]

    self.leftNavBtnName = @"返回";
    self.title = @"日志";
    self.rightNavBtnName = @"上传";
    UITextView *scol = (UITextView *)[self.contentView getSubViewInstanceWith:[UITextView class]];
    
    scol.backgroundColor = KWhiteColor;
    scol.text = [SandBoxHelper readFileWithFilePath:[NVLogManager shareInstance].getCurrentLogFilePath];
    UIButton *button = (UIButton *)[self.contentView getSubViewInstanceWith:[UIButton class]];
    [button setFrameInSuperViewCenterBottom:nil toBottomSpace:20 width:ScreenWidth_Content - 40 height:40];
    
    [button renderButtonWithBlock:^(UIButton *tempButton)
    {
        NSLog(@"+++++++++++++");
        [[NVLogManager shareInstance] clearFileLog];
        //清完后要重新处理一下
        [[NVLogManager shareInstance] enableFileLogSystem];
        //出于日志第一行写入{UploadLog}的需要
        NSString *content = @"{UploadLog}\n";
        [[NVLogManager shareInstance] writeLogString:content];
        
        scol.text = [SandBoxHelper readFileWithFilePath:[NVLogManager shareInstance].getCurrentLogFilePath];
        
    } font:SYSTEMFONT(17) fontColor:KWhiteColor buttonName:@"删除日志" bgColor:[UIColor darkGrayColor] cornerRadius:4 borderColor:nil borderWidth:0];
    [scol setFrameInSuperViewCenterTop:nil toTopSpace:0 width:ScreenWidth height:button.top];
    
    scol.backgroundColor = [UIColor greenColor];
    self.contentView.backgroundColor = [UIColor greenColor];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
-(void)rightNavBtnPressed:(id)sender
{
    errorReportLogic = [[ErrorReportLogic alloc] init];
    errorReportLogic.delegate = self;
    [errorReportLogic requestErrorReport];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark- XYTransitionProtocol
/**
 转场动画的目标View 需要转场动画的对象必须实现该方法并返回要做动画的View
 
 @return view
 */
-(UIView *)targetTransitionView
{
    return self.view;
}


/**
 *  是否是需要实现转场效果，不需要转场动画可不实现，需要必须实现并返回YES
 *
 *  @return 是否
 */
//-(BOOL)isNeedTransition
//{
//    return YES;
//}

@end
