//
//  BaseRequest.h
//  BaseProject
//
//  Created by janker on 2018/11/1.
//  Copyright © 2018 ChenXing. All rights reserved.
//
/**YTKBaseRequest：为请求的基类，内部声明了请求的常用 API ：
比如请求方式，请求解析方式，响应解析方式，请求参数等等。它的用意是让子类去实现的，本身不做实现。

YTKRequest：是 YTKBaseRequest 的子类，在其基础上支持了缓存，并且提供了丰富的缓存策略。基本上项目中使用都是继承于 YTKRequest 去写业务的 Request。

YTKNetworkAgent：真正做网络请求的类，在内部跟 AFNetworking 直接交互，调用了 AFNetworking 提供的各种请求，当然，如果底层想切换其他第三方，在这个类中替换掉就行了。

YTKNetworkConfig：该文件为网络请求的统一配置类，提供了设置 baseUrl cdnUrl 等基础请求路径，可以给所有的请求增加参数等等。

YTKBatchRequest：为批量进行网络请求而生，提供了代理和 block 两种方式给外部使用

YTKChainRequest：当多个请求之间有关联的时候采用此类去实现非常方便，即下一个请求可能要根据上个请求返回的数据进行请求。

YTKBatchRequestAgent，YTKChainRequestAgent：分别是 YTKBatchRequest，YTKChainRequest 的操作类，不需要也无妨主动调用
*/

#import "YTKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseRequest : YTKBaseRequest
@property (strong, nonatomic)NSMutableDictionary *requestHeaderDic;

@property (strong, nonatomic)NSMutableDictionary *parm;

@property (strong, nonatomic)NSString *requestEndUrl;//以什么结速的

@property (strong, nonatomic)NSString *requestBaseUrl;//以什么开始的

@property(nonatomic,assign)BOOL isOpenAES;//是否开启加密 默认不开启
//1是获取ip 2是普通post请求
@property(nonatomic,assign)int isPostBodyToJson;//post转json
@end

NS_ASSUME_NONNULL_END
