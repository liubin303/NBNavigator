//
//  NBURLMap.h
//  Pods
//
//  Created by 刘彬 on 2017/7/10.
//
//

#import <Foundation/Foundation.h>

@interface NBURLMap : NSObject

/*!
 @method
 @abstract      生成view跳转url
 @param         identifier: view 标识
 @param         params: 初始化参数
 @discussion    参数必须全部为NSString类型的,示例；
 [NBURLMap urlForViewWithIdentifier:APPURL_IDENTIFIER_WEBVIEW params:@{@"_url": @"http://www.baidu.com", @"_title": @"你好"}];
 @return        NSString,生成的view跳转url
 */
+ (NSString *)urlForViewWithIdentifier:(NSString *)identifier params:(NSDictionary *)params;

/*!
 @method
 @abstract      生成调用应用服务的url
 @param         identifier: 应用提供的服务标识
 @param         params: 初始化参数
 @discussion    参数必须全部为NSString类型的,示例；
 [NBURLMap urlForViewWithIdentifier:APPURL_IDENTIFIER_WEBVIEW params:@{@"_url": @"http://www.baidu.com", @"_title": @"你好"}];
 @return        NSString,生成的view跳转url
 */
+ (NSString *)urlForServiceWithIdentifier:(NSString *)identifier params:(NSDictionary *)params;


/*!
 @method
 @abstract      生成线上的url
 @param         identifier: 应用提供的服务标识
 @param         params: 初始化参数
 @discussion    参数必须全部为NSString类型的,示例；
 [NBURLMap urlForWebWithIdentifier:APPURL_IDENTIFIER_WEBVIEW params:@{@"_url": @"http://www.baidu.com", @"_title": @"你好"}];
 @return        NSString,生成的viewmap中对应的线上url
 */
+ (NSString *)urlForWebWithIdentifier:(NSString *)identifier params:(NSDictionary *)params;

/*!
 @method
 @abstract      根据内部URL获取identifier
 @return        NSString
 */
+ (NSString *)identifierWithInternalUrl:(NSString *)url;


/*!
 @method
 @abstract      根据文件名称获取文件路径
 @return        NSString，文件路径
 */
+ (NSString *)fileUrlWithFilePath:(NSString *)filePath;

/*!
 @method
 @abstract      从ViewMap配置文件中获取identifier对应的view是否通过native方式跳转
 @return        NSString
 */
+ (BOOL)shouldLoadViewViaNativeWithIdentifier:(NSString *)identifier;

@end
