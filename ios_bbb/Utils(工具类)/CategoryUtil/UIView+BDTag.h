//
//  UIView+BDTag.h
//  wsmCarOwner
//
//  Created by janker on 16/5/5.
//  Copyright © 2016年 chenxing. All rights reserved.
//
/*
 
 1.    概念
 
 objective-c有两个扩展机制：category和associative。我们可以通过category来扩展方法，但是它有个很大的局限性，不能扩展属性。于是，就有了专门用来扩展属性的机制：associative。
 
 
 2.    使用方法
 
 在iOS开发过程中，category比较常见，而associative就用的比较少。associative的主要原理，就是把两个对象相互关联起来，使得其中的一个对象作为另外一个对象的一部分。
 
 使用associative，我们可以不用修改类的定义而为其对象增加存储空间。这在我们无法访问到类的源码的时候或者是考虑到二进制兼容性的时候是非常有用。
 
 associative是基于关键字的。因此，我们可以为任何对象增加任意多的associative，每个都使用不同的关键字即可。associative是可以保证被关联的对象在关联对象的整个生命周期都是可用的。
 
 
 
 associative机制提供了三个方法：
 
 OBJC_EXPORT void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
 
 
 
 OBJC_EXPORT id objc_getAssociatedObject(id object, const void *key)
 
 
 
 OBJC_EXPORT void objc_removeAssociatedObjects(id object)
 
 2.1.创建associative
 
 创建associative使用的是：objc_setAssociatedObject。它把一个对象与另外一个对象进行关联。该函数需要四个参数：源对象，关键字，关联的对象、关联策略。
 
 关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
 
 关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；还有这种关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。这种关联策略是通过使用预先定义好的常量来表示的。
 
 
 
 比如，我们想对一个UIView，添加一个NSString类型的tag。可以这么做：
 
 - (void)setTagString:(NSString *)value {
 
 objc_setAssociatedObject(self, KEY_TAGSTRING, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 
 }
 2.2.获取associative对象
 
 获取相关联的是函数objc_getAssociatedObject。
 
 继续上面的例子，从一个UIView的实例中，获取一个NSString类型的tag
 
 - (NSString *)tagString {
 
 NSObject *obj = objc_getAssociatedObject(self, KEY_TAGSTRING);
 
 if (obj && [obj isKindOfClass:[NSString class]]) {
 
 return (NSString *)obj;
 
 }
 
 
 
 return nil;
 
 }
 
 
 2.3.断开associative
 
 断开associative是使用objc_setAssociatedObject函数，传入nil值即可。
 
 objc_setAssociatedObject(self, KEY_TAGSTRING, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 
 
 
 使用函数objc_removeAssociatedObjects可以断开所有associative。通常情况下不建议这么做，因为他会断开所有关联。
 
 **/
#import <UIKit/UIKit.h>

@interface UIView (BDTag)
@property (nonatomic, retain) NSString *tagString;

@property (nonatomic, retain) NSString *resetFrameString;

@property (nonatomic, retain) NSString *resetFontString;

- (UIView *)viewWithTagString:(NSString *)value;



// set round corner
- (void) setCornerRadius : (CGFloat) radius;
// set inner border
- (void) setBorder : (UIColor *) color width : (CGFloat) width;
// set the shadow
// Example: [view setShadow:[UIColor blackColor] opacity:0.5 offset:CGSizeMake(1.0, 1.0) blueRadius:3.0];
- (void) setShadow : (UIColor *)color opacity:(CGFloat)opacity offset:(CGSize) offset blurRadius:(CGFloat)blurRadius;
@end
