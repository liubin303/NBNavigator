//
//  NSURL+Navigator.m
//  Pods
//
//  Created by 刘彬 on 2017/7/13.
//
//

#import "NSURL+Navigator.h"
#import "NSString+URL.h"

@implementation NSURL (Navigator)

@end

@implementation NSDictionary (Navigator)

- (NSString *)nb_toQueryStringWithURLEncode:(BOOL)encode {
    @autoreleasepool {
        NSDictionary *dic = [self copy];
        
        NSArray *keys = [dic allKeys];
        if ([keys count] == 0) {
            return nil;
        }
        
        keys = [keys sortedArrayUsingSelector:@selector(compare:)];
        
        NSMutableString *str = [NSMutableString stringWithCapacity:10];
        BOOL isFirst = YES;
        for (NSString *key in keys) {
            
            NSArray *values = [dic objectForKey:key];
            if (![values isKindOfClass:[NSArray class]]) {
                values = @[values];
            }
            else {
                values = [values sortedArrayUsingSelector:@selector(compare:)];
            }
            
            for (NSString *value in values) {
                
                NSString *v = value;
                if (encode) {
                    v = [value nb_urlEncoding];
                }
                
                if (isFirst) {
                    isFirst = NO;
                }
                else {
                    [str appendString:@"&"];
                }
                
                NSString *item = [NSString nb_stringWithUTF8Format:"%s=%s",[key UTF8String],[v UTF8String]];
                [str appendString:item];
            }
        }
        
        return [NSString stringWithString:str];
    }
}

//转换成queryString,元素仅仅支持字符串内容，key升序，当一个key有多个values时，values升序
- (NSString *)nb_toQueryString {
    if (self.count > 0) {
        return [self nb_toQueryStringWithURLEncode:YES];
    } else {
        return @"";
    }
}

@end
