//
//  NSString+URL.m
//  Pods
//
//  Created by 刘彬 on 2017/7/10.
//
//

#import "NSString+URL.h"

@implementation NSString (URL)

// 对字符串URLencode编码
- (NSString *)nb_urlEncoding
{
    NSString *resultString = self;
    NSString *temString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                    kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    if ([temString length])
    {
        resultString = [NSString stringWithString:temString];
    }
    
    return resultString;
}

// 对字符串URLencode解码
- (NSString *)nb_urlDecoding {
    NSString *resultString = self;
    NSString *temString = CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                                    kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
    
    if ([temString length])
    {
        resultString = [NSString stringWithString:temString];
    }
    
    return resultString;
}

// 获取host path
- (NSString *)nb_getURLPathString {
    NSRange range1  = [self rangeOfString:@"?"];
    NSRange range2  = [self rangeOfString:@"#"];
    NSRange range   ;
    if (range1.location != NSNotFound) {
        range = NSMakeRange(range1.location, range1.length);
    }else if (range2.location != NSNotFound){
        range = NSMakeRange(range2.location, range2.length);
    }else{
        range = NSMakeRange(-1, 0);
    }
    
    if (range.location < self.length) {
        return [self substringToIndex:range.location];
    } else {
        return self;
    }
}

//获取url里面的参数
- (NSDictionary *)nb_getURLParams{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSRange range1  = [self rangeOfString:@"?"];
    NSRange range2  = [self rangeOfString:@"#!"];
    NSRange range3  = [self rangeOfString:@"#"];
    NSRange range   ;
    if (range1.location != NSNotFound) {
        range = NSMakeRange(range1.location, range1.length);
    } else if (range2.location != NSNotFound){
        range = NSMakeRange(range2.location, range2.length);
    } else if (range3.location != NSNotFound){
        range = NSMakeRange(range3.location, range3.length);
    }else{
        range = NSMakeRange(-1, 1);
    }
    
    if (range.location != NSNotFound && range.location+ range.length < self.length) {
        NSString * paramString = [self substringFromIndex:range.location+ range.length];
        NSArray * paramCouples = [paramString componentsSeparatedByString:@"&"];
        for (NSUInteger i = 0; i < [paramCouples count]; i++) {
            NSArray * param = [[paramCouples objectAtIndex:i] componentsSeparatedByString:@"="];
            if ([param count] == 2) {
                
                [dic setValue:[[param objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[param objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        return dic;
    }
    return nil;
}

// 对字符串添加url参数
- (NSString *)nb_stringByAddingURLParams:(NSDictionary *)params{
    NSString * string           = self;
    
    if (params.allKeys.count > 0) {
        NSMutableArray * pairArray  = [NSMutableArray array];
        
        for (NSString * key in params) {
            NSString * value        = [params objectForKey:key];
            NSString * keyEscaped   = [key nb_urlEncoding];
            NSString * valueEscaped = [value nb_urlEncoding];
            NSString * pair         = [NSString stringWithFormat:@"%@=%@",keyEscaped,valueEscaped];
            [pairArray addObject:pair];
        }
        
        NSString * query            = [pairArray componentsJoinedByString:@"&"];
        string                      = [NSString stringWithFormat:@"%@?%@",self,query];
    }
    
    return string;
}

+ (NSString *)nb_stringWithUTF8Format:(const char *)format, ... {
    
    char c_str[1024];
    memset(c_str, 0x0, sizeof(c_str));
    va_list arg_ptr;
    va_start(arg_ptr, format);
    vsprintf(c_str, format, arg_ptr);
    va_end(arg_ptr);
    if (c_str)
    {
        return [NSString stringWithUTF8String:c_str];
    }
    else
    {
        return nil;
    }
}

@end
