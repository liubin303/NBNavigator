//
//  NBURLHelper.h
//  Pods
//
//  Created by 刘彬 on 2017/7/7.
//
//

#import <Foundation/Foundation.h>

@interface NBURLHelper : NSObject

/*!
 @method
 @abstract      设置应用协议
 @param         identifier: 应用协议标示
 @discussion    该方法必须在子工程中实现，设置项目对应的scheme identifier
 */
+ (void)setSchemeIdentifier:(NSString *)identifier;

/*!
 @method
 @abstract      判断url是否web url，相对于app而言
 @param         URL: URL
 @return        BOOL
 */
+ (BOOL)isWebURL:(NSURL*)URL;

/*!
 @method
 @abstract      判断是否app url
 @param         URL: URL
 @return        BOOL
 */
+ (BOOL)isAppURL:(NSURL *)URL;

/*!
 @method
 @abstract      应用url协议
 @return        NSString
 */
+ (NSString *)appUrlScheme;

/*!
 @method
 @abstract      获取URL中的参数
 @param         defaultKey:  url中 xxx.html 对应的Key
 @return        NSString
 */
+ (NSMutableDictionary *)getURLParamsWithURL:(NSURL*)url defaultKey:(NSString *)defaultKey;

///*!
// @method
// @abstract      添加自定义参数（token、platform等）
// @return        NSString
// */
//+ (NSMutableDictionary *)appendCustomerParamsWithOriginal:(NSMutableDictionary *)originalParams;
//
///*!
// @method
// @abstract      删除自定义参数（token、platform等）
// @return        NSString
// */
//+ (NSMutableDictionary *)removeCustomerParamsWithOriginal:(NSDictionary *)originalParams;
//
///*!
// @method
// @abstract      添加自定义参数（token、platform等）
// @return        NSString
// */
//+ (NSString *)appendCustomerParamsWithUrl:(NSString *)url;
//
///*!
// @method
// @abstract      删除自定义参数（token、platform等）
// @return        NSString
// */
//+ (NSString *)removeCustomerParamsWithURL:(NSString *)urlString;

@end
