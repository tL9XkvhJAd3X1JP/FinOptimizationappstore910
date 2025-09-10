//
//  TestListViewController.m
//  FinOptimization
//
//  Created by janker on 2019/4/8.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "TestListViewController.h"

@interface TestListViewController ()

@end

@implementation TestListViewController
-(void)loadView
{
  self.notRightScrollPop = YES;
  [super loadView];
}
- (void)viewDidLoad {
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
