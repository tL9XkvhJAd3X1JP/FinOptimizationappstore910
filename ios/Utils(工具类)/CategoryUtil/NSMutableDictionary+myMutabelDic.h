//
//  NSMutableDictionary+myMutabelDic.h
//  wsm
//
//  Created by chenxing on 12-11-28.
//  Copyright (c) 2012年 chenxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (myMutabelDic)
- (void)setObjectFilterNull:(id)anObject forKey:(id < NSCopying >)aKey;
-(id)objectForKeyFilterNull:(id)key;

@end
