//
//  WarnLocationViewController.m
//  FinOptimization
//
//  Created by janker on 2019/4/20.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "WarnLocationViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface WarnLocationViewController ()<BMKDistrictSearchDelegate,RCTBridgeModule>
@property (nonatomic, copy) void(^okblock)(id);
@property (nonatomic, copy) void(^errorblock)(id);
@end

@implementation WarnLocationViewController

- (void)viewDidLoad {
  
  


    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
RCT_EXPORT_MODULE(WarnLocation);
RCT_EXPORT_METHOD(searchPlace:(NSString *)placeName okCallBack:(RCTResponseSenderBlock)okCallBack errorCallBack:(RCTResponseSenderBlock)errorCallBack)
{
  self.okblock = okCallBack;
  self.errorblock = errorCallBack;
  kWeakSelf(self);
  BACKGROUND(^{

    BMKDistrictSearch *search = [[BMKDistrictSearch alloc] init];
    
    search.delegate = weakself;
    BMKDistrictSearchOption *option = [[BMKDistrictSearchOption alloc] init];
    
    option.city = placeName;

    //  option.city = @"北京";
    //  option.district = @"朝阳区";
    BOOL flag = [search districtSearch:option];
    if (flag) {
      NSLog(@"district检索发送成功");
    }  else  {
      NSLog(@"district检索发送失败");
      self.errorblock([NSArray arrayWithObjects:@"检索失败", nil]);
    }

  });
 
  

}

/**
 *返回行政区域搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果BMKDistrictSearch
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDistrictResult:(BMKDistrictSearch *)searcher result:(BMKDistrictResult *)result errorCode:(BMKSearchErrorCode)error {
  if (error == BMK_SEARCH_NO_ERROR) {
    //在此处理正常结果
    if (self.okblock != nil)
    {
      //NSString数组，字符串数据格式为: @"x,y;x,y"
      self.okblock(result.paths);
//      for (NSString *path in result.paths)
//      {
//
//      }
//      [temp convertPoint:<#(CGPoint)#> toCoordinateFromView:self.view];
    }
  }
  else {
    NSLog(@"检索失败");
    self.errorblock([NSArray arrayWithObjects:@"检索失败", nil]);
  }
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
