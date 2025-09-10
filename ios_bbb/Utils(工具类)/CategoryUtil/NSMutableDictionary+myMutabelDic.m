//
//  NSMutableDictionary+myMutabelDic.m
//  wsm
//
//  Created by chenxing on 12-11-28.
//  Copyright (c) 2012年 chenxing. All rights reserved.
//

#import "NSMutableDictionary+myMutabelDic.h"

@implementation NSMutableDictionary (myMutabelDic)
- (void)setObjectFilterNull:(id)anObject forKey:(id < NSCopying >)aKey
{
    
    //&& ![@"" isEqualToString:[anObject description]]
    if (anObject != nil && (NSNull *)anObject != [NSNull null] && ![@"<null>" isEqualToString:anObject])
    {
        [self setObject:anObject forKey:aKey];
    }
//    else
//    {
//        //
//        [self removeObjectForKey:aKey];
//    }

}
-(id)objectForKeyFilterNull:(id)key
{
    id content = [self objectForKey:key];
    if (content != nil)
    {
        return content;
    }
    return @"";
}

@end
