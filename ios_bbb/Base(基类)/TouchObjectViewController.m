//
//  TouchObjectViewController.m
//  wsmCarOwner
//
//  Created by janker on 16/4/28.
//  Copyright © 2016年 chenxing. All rights reserved.
//

#import "TouchObjectViewController.h"

@interface TouchObjectViewController ()

@end

@implementation TouchObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // UIViewController *vc = [self getViewControllerWith:self.view];
    //    if (vc != nil && [vc isKindOfClass:NSClassFromString(@"NewMainViewController")])
    // MYLog(@"%@   %@",gestureRecognizer.view.superview,self);
//    NSObject *obj = [NomalUtil getLastViewController];
//    if (obj != nil && [obj isKindOfClass:NSClassFromString(@"CarExaminationResultViewController")])
//    {
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
    
    return NO;
}
//同时接受多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
//加上这段代码后，系统的 UIScreenEdgePanGestureRecognizer 就不会与其他的手势同时触发，从而解决了这个看起来有点奇怪的效果。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL isnew = [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
    //MYLog(@"----------------%d",isnew);
    return isnew;
}
@end
