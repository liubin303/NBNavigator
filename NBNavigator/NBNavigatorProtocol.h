//
//  NBNavigatorProtocol.h
//  Pods
//
//  Created by 刘彬 on 2017/7/10.
//
//

#import <Foundation/Foundation.h>

#define kInitMethod                                     @"__INITMETHOD__"
#define kInstanceMethod                                 @"__INSTANCEMETHOD__"
#define kClass                                          @"__CLASS__"

/*!
 @protocol
 @abstract      使用导航器进行导航的类需要实现次协议
 */
@protocol NBNavigatorProtocol <NSObject>

@required
/*!
 @method
 @abstract      初始化
 @param         query: 初始化参数，字典形式
 @return        实例对象
 */
- (instancetype)initWithQuery:(NSDictionary *)query;

@optional

/*!
 @method
 @abstract      做初始化工作
 @param         query: 初始化参数，字典形式
 @return        void
 */
- (void)doInitializeWithQuery:(NSDictionary *)query;

@end
