//
//  SelectCarListViewController.m
//  FinOptimization
//
//  Created by janker on 2019/4/3.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SelectCarListViewController.h"

@interface SelectCarListViewController ()

@end

@implementation SelectCarListViewController
RCT_EXPORT_MODULE(SelectCarListViewController);
RCT_EXPORT_METHOD(sendRequest:(NSString *)className)
{
  
}

-(void)loadView
{
//  UIButton *button;
//  [button addTapBlock:<#^(UIButton *btn)block#>]
  self.notRightScrollPop = YES;
  [super loadView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
