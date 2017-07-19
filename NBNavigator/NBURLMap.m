//
//  NBURLMap.m
//  Pods
//
//  Created by 刘彬 on 2017/7/10.
//
//

#import "NBURLMap.h"
#import "NBURLHelper.h"
#import "NBViewMap.h"
#import "NSString+URL.h"
#import "NBNavigator.h"
#import "NBViewDataModel.h"

@implementation NBURLMap

+ (NSString *)urlForViewWithIdentifier:(NSString *)identifier params:(NSDictionary *)params{
    NSString * url              = nil;
    
    if (identifier) {
        NSString * scheme       = [NBURLHelper appUrlScheme];
        NSString * host         = APPURL_HOST_VIEW;
        NSString * path         = identifier;
        url                     = [NSString stringWithFormat:@"%@://%@/%@",scheme,host,path];
        url                     = [url nb_stringByAddingURLParams:params];
    }
    
    return url;
}

+ (NSString *)urlForServiceWithIdentifier:(NSString *)identifier params:(NSDictionary *)params{
    NSString * url              = nil;
    
    if (identifier) {
        NSString * scheme       = [NBURLHelper appUrlScheme];
        NSString * host         = APPURL_HOST_SERVICE;
        NSString * path         = identifier;
        url                     = [NSString stringWithFormat:@"%@://%@/%@",scheme,host,path];
        url                     = [url nb_stringByAddingURLParams:params];
    }
    
    return url;
}

+ (NSString *)urlForWebWithIdentifier:(NSString *)identifier params:(NSDictionary *)params
{
    NSDictionary *viewModalDict = [[NBNavigator sharedInstance] viewModalDict];
    NBViewDataModel *viewDataModel = [viewModalDict objectForKey:identifier];
    
    if (viewDataModel) {
        NSString *url = viewDataModel.webUrl;
        
        BOOL hasDefaultKey = NO;
        if (viewDataModel.paramKey && [params.allKeys containsObject:viewDataModel.paramKey]) {
            url = [NSString stringWithFormat:url,  [params objectForKey:viewDataModel.paramKey]];
            hasDefaultKey = YES;
        }
        
        if ((hasDefaultKey && params.allKeys.count > 1) ||
            (!hasDefaultKey && params.allKeys.count > 0)) {
            if ([url rangeOfString:@"?"].location == NSNotFound) {
                url = [url stringByAppendingString:@"?"];
            } else {
                url = [url stringByAppendingString:@"&"];
            }
        }
        
        for (NSString *key in params.allKeys) {
            if (![key isEqualToString:viewDataModel.paramKey]) {
                id object = [params objectForKey:key];
                if ([object isKindOfClass:[NSString class]]
                    || [object isKindOfClass:[NSNumber class]]) {
                    NSString *value = [NSString stringWithFormat:@"%@", [params objectForKey:key]];
                    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, [value nb_urlEncoding]]];
                }
            }
        }
        
        return url;
    }
    
    return nil;
}

+ (NSString *)identifierWithInternalUrl:(NSString *)url
{
    if (!url) {
        return nil;
    }
    // 只有自家域名的能跳转native，其他都直接web打开。
    if (![[NBNavigator sharedInstance] isURLInAppList:url]) {
        return nil;
    }

    // 先以path中最后一位为Key
    NSString *identifier = [self identifierLastPathWithInternalUrl:url];
    
    NBViewDataModel *viewDataModel = [[NBNavigator sharedInstance] viewDataModelForIdentifier:identifier];
    
    if (viewDataModel == nil) {
        // 找不到定义，再以path为Key
        identifier = [self identifierPathWithInternalUrl:url];
    }
    
    return identifier;
}

+ (NSString *)identifierLastPathWithInternalUrl:(NSString *)url
{
    NSString *identifier    = nil;
    
    if (url) {
        NSURL * URL         = [NSURL URLWithString:url];
        
        NSString * scheme   = URL.scheme;
        NSString * host     = URL.host;
        NSString * query    = URL.query;
        NSString * fragment = URL.fragment;
        NSString * path     = URL.path;

#pragma unused(scheme)
#pragma unused(host)
#pragma unused(query)
#pragma unused(fragment)
#pragma unused(path)
        
        //去除path前的“/”字符
        if (path && path.length) {
            path            = [path substringFromIndex:1];
        }
        
        if ([path rangeOfString:@"/"].location != NSNotFound) {
            NSArray *subPaths = [path componentsSeparatedByString:@"/"];
            path = [subPaths objectAtIndex:MAX(0, subPaths.count - 1)];
            
            if ([path rangeOfString:@".html"].location != NSNotFound) {
                path = [path componentsSeparatedByString:@".html"][0];
            }
        } else if ([path rangeOfString:@".html"].location != NSNotFound) {
            path = [path componentsSeparatedByString:@".html"][0];
        }
        
        identifier = path;
    }
    
    return identifier;
}

+ (NSString *)identifierPathWithInternalUrl:(NSString *)url
{
    NSString *identifier    = nil;
    
    if (url) {
        NSURL * URL         = [NSURL URLWithString:url];
        
        NSString * scheme   = URL.scheme;
        NSString * host     = URL.host;
        NSString * query    = URL.query;
        NSString * fragment = URL.fragment;
        NSString * path     = URL.path;

#pragma unused(scheme)
#pragma unused(host)
#pragma unused(query)
#pragma unused(fragment)
#pragma unused(path)
        
        //去除path前的“/”字符
        if (path && path.length) {
            path            = [path substringFromIndex:1];
        }
        
        if ([path rangeOfString:@"/"].location != NSNotFound) {
            NSArray *subPaths = [path componentsSeparatedByString:@"/"];
            NSString *file = [subPaths objectAtIndex:MAX(0, subPaths.count - 1)];
            
            if ([file rangeOfString:@".html"].location != NSNotFound) {
                NSString * last = [file componentsSeparatedByString:@".html"][0];
                NSMutableArray *newArray = [NSMutableArray arrayWithArray:subPaths];
                [newArray removeLastObject];
                path =  [[newArray componentsJoinedByString:@"/"] stringByAppendingPathComponent:last];
            }
        } else if ([path rangeOfString:@".html"].location != NSNotFound) {
            path = [path componentsSeparatedByString:@".html"][0];
        }
        
        identifier = path;
    }
    
    return identifier;
}


+ (NSString *)fileUrlWithFilePath:(NSString *)filePath
{
    if ([filePath length] == 0) {
        return nil;
    }
    // 分割路径
    NSMutableArray* directoryParts = [NSMutableArray arrayWithArray:[filePath componentsSeparatedByString:@"/"]];
    // 读取文件名
    NSString* filename = [directoryParts lastObject];
    [directoryParts removeLastObject];
    // 拼接文件路径
    NSString* directoryPartsJoined = [directoryParts componentsJoinedByString:@"/"];
    NSString *localH5Path = [[NBNavigator sharedInstance].delegate navigatorPathOfLocalH5];
    if (directoryPartsJoined.length > 0) {
        localH5Path = [NSString stringWithFormat:@"%@/%@", localH5Path, directoryPartsJoined];
    }

    NSString* fileUrl = nil;
    NSBundle* mainBundle = [NSBundle mainBundle];
    fileUrl = [mainBundle pathForResource:filename ofType:@"" inDirectory:localH5Path];
    if (fileUrl) {
        fileUrl = [NSString stringWithFormat:@"file://%@", fileUrl];
    }
    
    return fileUrl;
}

+ (BOOL)shouldLoadViewViaNativeWithIdentifier:(NSString *)identifier
{
    BOOL flag = YES;
    
    NSDictionary *viewModalDict = [[NBNavigator sharedInstance] viewModalDict];
    NBViewDataModel *viewDataModel = [viewModalDict objectForKey:identifier];
    
    if (viewDataModel && viewDataModel.type != ViewTypeNative) {
        flag = NO;
    }
    
    return flag;
}


@end
