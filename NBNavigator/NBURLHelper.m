//
//  NBURLHelper.m
//  Pods
//
//  Created by 刘彬 on 2017/7/7.
//
//

#import "NBURLHelper.h"
#import "NSString+URL.h"

static NSString * schemeIdentifier;

@implementation NBURLHelper

+ (void)setSchemeIdentifier:(NSString *)identifier
{
    schemeIdentifier = identifier;
}

+ (BOOL)isWebURL:(NSURL*)URL
{
    return [@"http" caseInsensitiveCompare:URL.scheme] == NSOrderedSame
    || [@"https" caseInsensitiveCompare:URL.scheme] == NSOrderedSame
    || [@"ftp" caseInsensitiveCompare:URL.scheme] == NSOrderedSame
    || [@"ftps" caseInsensitiveCompare:URL.scheme] == NSOrderedSame
    || [@"data" caseInsensitiveCompare:URL.scheme] == NSOrderedSame
    || [@"file" caseInsensitiveCompare:URL.scheme] == NSOrderedSame;
}

+ (BOOL)isAppURL:(NSURL *)URL
{
    BOOL flag               = NO;
    
    NSString * appScheme    = [NBURLHelper appUrlScheme];
    flag                    = [appScheme caseInsensitiveCompare:URL.scheme] == NSOrderedSame;
    
    return flag;
}

+ (NSString *)appUrlScheme
{
    NSString * urlScheme        = nil;
    NSArray * schemes           = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    
    for (NSDictionary * scheme in schemes) {
        NSString * identifier   = [scheme objectForKey:@"CFBundleURLName"];
        if (identifier && [identifier isEqualToString:schemeIdentifier]) {
            NSArray * items     = [scheme objectForKey:@"CFBundleURLSchemes"];
            if (items && items.count) {
                urlScheme       = [items objectAtIndex:0];
            }
        }
    }
    
    return urlScheme;
}

// 获取URL中的参数
+ (NSMutableDictionary *)getURLParamsWithURL:(NSURL*)url defaultKey:(NSString *)defaultKey
{
    if (url == nil) {
        return nil;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString * urlString        = url.absoluteString ;
    NSString * query            = url.query;
    NSString * path             = url.path;
    
    params = [[NSMutableDictionary alloc] initWithDictionary:[query nb_getURLParams]];
    
    NSRange range  = [urlString rangeOfString:@"#!"];
    if ([urlString rangeOfString:@"#!"].location != NSNotFound) {
        NSString *temp = [urlString  substringFromIndex:range.location + 1];
        if ([path rangeOfString:@"&"].location != NSNotFound) {
            temp = [temp substringFromIndex:1];
        }
        NSDictionary *tempPara = [temp nb_getURLParams];
        for (NSString *key in tempPara.allKeys) {
            NSString *tempValue = [tempPara objectForKey:key];
            [params setObject:tempValue forKey:key];
        }
    }
    
    if ([path rangeOfString:@"/"].location != NSNotFound) {
        NSArray *paraArray = [path componentsSeparatedByString:@"/"];
        if (defaultKey) {
            NSString *para = paraArray[paraArray.count - 1];
            if ([path rangeOfString:@".html"].location != NSNotFound) {
                para = [para componentsSeparatedByString:@".html"][0];
                [params setObject:para forKey:defaultKey ? defaultKey : @"itemId"];
            }
        }
    }
    
    return params;
}

@end
