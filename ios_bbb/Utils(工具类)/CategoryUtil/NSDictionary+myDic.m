//
//  NSDictionary+myDic.m
//  wsm
//
//  Created by chenxing on 12-12-4.
//  Copyright (c) 2012年 chenxing. All rights reserved.
//

#import "NSDictionary+myDic.h"

@implementation NSDictionary (myDic)
-(id)objectForKeyFilterNSNull:(id)key
{
    id content = [self objectForKey:key];
    if ((NSNull *)content !=  [NSNull null] && content != nil && ![@"<null>" isEqualToString:content])
    {
        return content;
    }
    else
    {
        return nil;
    }
}

-(id)objectForKeyWithStringValue:(id)key
{
//    key = [key lowercaseString];
    id content = [self objectForKey:key];
    
    if ((NSNull *)content == [NSNull null] || content == nil)
    {
        return nil;
    }
    else
    {
        return [content description];
    }
}

-(id)objectForKeyForResponseData:(id)key
{
    id content = [self objectForKey:key];
    if (content != nil && (NSNull *)content != [NSNull null])
    {
        return content;
    }
    return @"";
}

- (NSDictionary*) dictionaryWithLowercaseKeys
{
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:self.count];
    NSString* key;
    
    for (key in self) {
        [result setObject:[self objectForKey:key] forKey:[key lowercaseString]];
    }
    
    return result;
}

@end
