//
//  ErrorReportLogic.h
//  BaseProject
//
//  Created by janker on 2018/11/19.
//  Copyright © 2018 ChenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//主要为了让界面对数据的处理逻辑分开
@interface ErrorReportLogic : NSObject<YTKRequestAccessory,YTKRequestDelegate>
@property (nonatomic, weak, nullable) id delegate;
-(void)requestErrorReport;
@end

NS_ASSUME_NONNULL_END
