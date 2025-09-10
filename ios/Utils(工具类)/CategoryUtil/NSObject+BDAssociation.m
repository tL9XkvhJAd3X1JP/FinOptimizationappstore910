//
//  NSObject+BDAssociation.m
//  wsmCarOwner
//
//  Created by janker on 16/5/5.
//  Copyright © 2016年 chenxing. All rights reserved.
//

#import "NSObject+BDAssociation.h"

@implementation NSObject (BDAssociation)
static const char associatedObjectsKey;
//static const char alertKey;
//- (id)associatedObjectForKey:(NSString*)key
//{
//    NSMutableDictionary *dict = objc_getAssociatedObject(self, &associatedObjectsKey);
//
//    return [dict objectForKey:key];
//
//}
- (id)getMyAssociatedObjectForKey:(NSString*)key
{
    //MYLog(@"======================");
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &associatedObjectsKey);
    
    return [dict objectForKey:key];
    
}

- (void)setMyAssociatedObject:(id)object forKey:(NSString*)key {
    
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &associatedObjectsKey);
    
    if (!dict) {
        
        dict = [NSMutableDictionary dictionaryWithCapacity:1];
        
        objc_setAssociatedObject(self, &associatedObjectsKey, dict, OBJC_ASSOCIATION_RETAIN);
        
    }
    
    [dict setObject:object forKey:key];
    
}

//- (void)setAssociatedObject:(id)object forKey:(NSString*)key {
//    
//    NSMutableDictionary *dict = objc_getAssociatedObject(self, &associatedObjectsKey);
//    
//    if (!dict) {
//        
//        dict = [NSMutableDictionary dictionaryWithCapacity:1];
//        
//        objc_setAssociatedObject(self, &associatedObjectsKey, dict, OBJC_ASSOCIATION_RETAIN);
//        
//    }
//    
//    [dict setObject:object forKey:key];
//    
//}
@end
