//
//  NSURL+Navigator.h
//  Pods
//
//  Created by 刘彬 on 2017/7/13.
//
//

#import <Foundation/Foundation.h>

@interface NSURL (Navigator)

@end

@interface NSDictionary (Navigator)

//转换成queryString,元素仅仅支持字符串内容，key升序，当一个key有多个values时，values升序(编码前)
- (NSString *)nb_toQueryStringWithURLEncode:(BOOL)encode;

//转换成queryString,元素仅仅支持字符串内容，key升序，当一个key有多个values时，values升序
- (NSString *)nb_toQueryString;

@end
