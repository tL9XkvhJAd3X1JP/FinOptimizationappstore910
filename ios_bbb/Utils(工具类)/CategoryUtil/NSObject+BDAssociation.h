//
//  NSObject+BDAssociation.h
//  wsmCarOwner
//
//  Created by janker on 16/5/5.
//  Copyright © 2016年 chenxing. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 这是一个方便，强大，并且简单的类。利用associative机制，为任何Object，添加你所需要的信息。比如用户登录，向服务端发送用户名/密码时，可以将这些信息绑定在请求的项之中。等请求完成后，再取出你所需要的信息，进行逻辑处理。而不需要另外设置成员，保存这些数据。
 */
@interface NSObject (BDAssociation)


//- (id)associatedObjectForKey:(NSString*)key;
//
//- (void)setAssociatedObject:(id)object forKey:(NSString*)key;
- (id)getMyAssociatedObjectForKey:(NSString*)key;
- (void)setMyAssociatedObject:(id)object forKey:(NSString*)key;
@end
