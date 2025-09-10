//
//  NSDictionary+myDic.h
//  wsm
//
//  Created by chenxing on 12-12-4.
//  Copyright (c) 2012年 chenxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (myDic)
-(id)objectForKeyFilterNSNull:(id)key;
-(id)objectForKeyWithStringValue:(id)key;
- (NSDictionary*) dictionaryWithLowercaseKeys;
-(id)objectForKeyForResponseData:(id)key;
@end
