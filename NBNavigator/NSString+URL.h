//
//  NSString+URL.h
//  Pods
//
//  Created by 刘彬 on 2017/7/10.
//
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/*!
 *  @brief 对字符串URLencode编码
 *
 */
- (NSString *)nb_urlEncoding;

/*!
 *  @brief 对字符串URLdecode解码
 *
 */
- (NSString *)nb_urlDecoding;

/*!
 *  @brief 获取url的host
 *
 */
- (NSString *)nb_getURLPathString;

/*!
 *  @brief 获取url里面的参数
 *
 */
- (NSDictionary *)nb_getURLParams;

/*!
 *  @brief 对字符串添加url参数
 *
 *  @param params 参数列表
 *
 */
- (NSString *)nb_stringByAddingURLParams:(NSDictionary *)params;

//高效的format，长度保持在1024
+ (NSString *)nb_stringWithUTF8Format:(const char *)format, ...;

@end
