//
//  NBNavigator.m
//  Pods
//
//  Created by 刘彬 on 2017/7/7.
//
//

#import "NBNavigator.h"
#import "NSString+URL.h"
#import "NSURL+Navigator.h"
#import "NBURLHelper.h"
#import "NBURLMap.h"
#import "NBViewMap.h"
#import "NBViewDataModel.h"

//解决performSelector的一个warning
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

BOOL openURL(NSString * url){
    BOOL handles = [[NBNavigator sharedInstance] openURL:url];
    
    return handles;
}

@implementation NBNavigator

#pragma mark - open url
- (BOOL)openURL:(NSString *)url{
    BOOL handles = NO;
    
    if (url) {
        
        // 过滤错误参数
        NSDictionary *oldParams = [url nb_getURLParams];
        NSString *mainString = [url nb_getURLPathString];
        url = [mainString nb_stringByAddingURLParams:oldParams];
        
        NSURL * URL         = [NSURL URLWithString:url];
        
        NSString * scheme   = URL.scheme;
        NSString * host     = URL.host;
        NSString * query    = URL.query;
        NSString * fragment = URL.fragment;
        NSString * path     = URL.path;
        
        //去除path前的“/”字符
        if (path && path.length) {
            path                = [path substringFromIndex:1];
        }
        
#pragma unused(scheme)
#pragma unused(host)
#pragma unused(query)
#pragma unused(fragment)
#pragma unused(path)
        
        // 黑名单判断
        if (![self isURLInWhiteList:url] && [self isURLInBlackList:url]) {
            NSLog(@"%@ 在黑名单中，无法打开",url);
            handles = NO;
            return handles;
        }
        
        BOOL isNative = NO;
        BOOL isWeb = NO;
        
        NBViewDataModel * viewDataModel = nil;
        NSString * viewIdentifier       = [NBURLHelper isAppURL:URL] ? path : [NBURLMap identifierWithInternalUrl:url];
        viewDataModel                   = viewIdentifier ? [self viewDataModelForIdentifier:viewIdentifier] : nil;
        NSMutableDictionary * params    = nil;

        // 在viewmap中注册过
        if (viewDataModel) {
            // 画面权限判断
            if ([self.delegate respondsToSelector:@selector(navigatorAuthForViewModel:)]) {
                BOOL result = [self.delegate navigatorAuthForViewModel:viewDataModel];
                if (!result) {
                    NSLog(@"%@ 需要登录", viewIdentifier);
                    return YES;
                }
            }

            // 如果在主tab里， 跳到主tab
            if (viewDataModel.inTab.integerValue > 0) {
                if ([self.delegate respondsToSelector:@selector(navigatorWillChangeTabbarToIndex:)]) {
                    [self.delegate navigatorWillChangeTabbarToIndex:viewDataModel.inTab.integerValue-1];
                }
                return YES;
            }
            params = [NBURLHelper getURLParamsWithURL:URL defaultKey:viewDataModel.paramKey];
            switch (viewDataModel.type) {
                case ViewTypeNative:{
                    isNative = YES;
                    break;
                }
                case ViewTypeOnlineH5:{
                    isWeb = YES;
                    if (viewDataModel.webUrl.length > 0) {
                        url = viewDataModel.webUrl;
                    }
                    break;
                }
                case ViewTypeLocalH5:{
                    isWeb = YES;
                    NSString *filePath = [NBURLMap fileUrlWithFilePath:viewDataModel.filePath];
                    if (filePath.length > 0) {
                        url = filePath;
                    }
                    break;
                }
                default:
                    break;
            }
        }else{
            NSLog(@"URL=%@中不包含有效的ViewIdentifier",url);
            // 处理service
            if ([NBURLHelper isAppURL:URL] && [host isEqualToString:APPURL_HOST_SERVICE]) {
                NSString * function                 = path;
                params                              = [NBURLHelper getURLParamsWithURL:URL defaultKey:nil];
                SEL selector                        = NSSelectorFromString([NSString stringWithFormat:@"%@:",function]);
                [self processService:selector params:params];
                handles                             = YES;
                return handles;
            }else if([NBURLHelper isWebURL:URL]){
                isNative = NO;
                isWeb = YES;
                // 不在白名单中，使用系统浏览器打开
                if (![self isURLInWhiteList:url]) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@可能是一个不安全的链接，是否打开?",url] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"继续打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [self.rootViewController presentViewController:alertController animated:YES completion:nil];
                    return YES;
                }
            }
            else{
                // 这里处理打电话、发短信、邮件等系统scheme
                handles = [[UIApplication sharedApplication] openURL:URL];
                return handles;
            }
        }
        
        // 切换tabbar
        if ([params.allKeys containsObject:APPURL_PARAM_TABBARINDEX]) {
            if ([self.delegate respondsToSelector:@selector(navigatorWillChangeTabbarToIndex:)]) {
                [self.delegate navigatorWillChangeTabbarToIndex:[[params objectForKey:APPURL_PARAM_TABBARINDEX] integerValue]-1];
            }
        }
        if (isNative) {
            NSString * retrospect               = [params objectForKey:APPURL_PARAM_RETROSPECT];
            NSString * animated                 = [params objectForKey:APPURL_PARAM_ANIMATED];
            BOOL shouldRetrospect               = retrospect ? [retrospect boolValue] : NO;
            BOOL shouldAnaimate                 = animated ? [animated boolValue] : YES;
            
            viewDataModel.queryForInitMethod    = [NSMutableDictionary dictionaryWithDictionary:params];
            [viewDataModel.queryForInitMethod setValue:viewDataModel.identifier forKey:APPURL_PARAM_IDENTIFIER];
            viewDataModel.viewInstanceMethod    = nil;
            viewDataModel.queryForInstanceMethod= nil;
            
            UIViewController *viewController = [self pushViewControllerWithViewDataModel:viewDataModel propertyDict:params retrospect:shouldRetrospect animated:shouldAnaimate];
            NSLog(@"Open with native，viewController=%@",[viewController class]);
            handles = YES;
        } else if (isWeb) {
            // query补参数
            if (params.count > 0 && [url rangeOfString:@"?"].location == NSNotFound) {
                
                url = [url stringByAppendingString:@"?"];
                url = [url stringByAppendingString:[params nb_toQueryString]];
            }
            
            // 使用webview打开
            NSString * viewIdentifier     = APPURL_VIEW_IDENTIFIER_WEBVIEW;
            NSString * title              = [params objectForKey:APPURL_PARAM_TITLE];
            NSString * needsNavigationBar = [params objectForKey:APPURL_PARAM_NEEDSNAVIGATIONBAR];
            NSString * retrospect         = [params objectForKey:APPURL_PARAM_RETROSPECT];
            NSString * animated           = [params objectForKey:APPURL_PARAM_ANIMATED];
            
            title                     = title ? title : @"";
            needsNavigationBar        = needsNavigationBar ? needsNavigationBar : @"true";
            NSDictionary * jumpParams = @{APPURL_PARAM_TITLE: title,
                                          APPURL_PARAM_NEEDSNAVIGATIONBAR: needsNavigationBar,
                                          APPURL_PARAM_URL: url,
                                          APPURL_PARAM_DESC: viewDataModel.desc ? viewDataModel.desc : @"",
                                          APPURL_PARAM_IDENTIFIER : (viewDataModel ? viewDataModel.identifier : viewIdentifier),
                                          };
            
            BOOL shouldRetrospect     = retrospect ? [retrospect boolValue] : NO;
            BOOL shouldAnaimate       = animated ? [animated boolValue] : YES;
            
            [self gotoViewWithIdentifier:viewIdentifier
                            queryForInit:jumpParams
                        queryForInstance:nil
                      propertyDictionary:@{@"urlString": url}
                              retrospect:shouldRetrospect
                                animated:shouldAnaimate];
            
            handles = YES;
        }
    
    }
    
    return handles;
}

- (BOOL)openViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)queryForInit
{
    return [self openViewWithIdentifier:identifier queryForInit:queryForInit propertyDictionary:nil];
}

- (BOOL)openViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)queryForInit
            propertyDictionary:(NSDictionary *)propertyDic
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:queryForInit];
    NBViewDataModel *viewDataModel = [self viewDataModelForIdentifier:identifier];
    
    if (viewDataModel.type == ViewTypeLocalH5) {
//        for (NSString *tempKey in params.allKeys) {
//            NSObject *object = [params objectForKey:tempKey];
//            if ([object isKindOfClass:[BaseModel class]]) {
//                [params removeObjectForKey:tempKey];
//            }
//        }
        NSString *url = [NBURLMap urlForViewWithIdentifier:identifier params:params];
        return openURL(url);
    } else if(viewDataModel.type == ViewTypeOnlineH5) {
        
        // format url
//        for (NSString *tempKey in params.allKeys) {
//            NSObject *object = [params objectForKey:tempKey];
//            if ([object isKindOfClass:[BaseModel class]]) {
//                [params removeObjectForKey:tempKey];
//            }
//        }
        
        NSString *url = [NBURLMap urlForWebWithIdentifier:identifier params:params];
        
        return openURL(url);
    }
    
    NSString * retrospect               = [queryForInit objectForKey:APPURL_PARAM_RETROSPECT];
    NSString * animated                 = [queryForInit objectForKey:APPURL_PARAM_ANIMATED];
    
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:queryForInit];
    
    
    
    [newParams setValue:identifier forKey:APPURL_PARAM_IDENTIFIER];
    [newParams setValue:viewDataModel.desc forKey:APPURL_PARAM_TITLE];
    
    BOOL shouldRetrospect               = retrospect ? [retrospect boolValue] : NO;
    BOOL shouldAnaimate                 = animated ? [animated boolValue] : YES;
    
    [self gotoViewWithIdentifier:identifier
                    queryForInit:newParams
                queryForInstance:nil
              propertyDictionary:propertyDic
                      retrospect:shouldRetrospect
                        animated:shouldAnaimate];
    
    return YES;
}

- (UIViewController *)viewControllerWithIdentifier:(NSString *)identifier {
    NBViewDataModel * viewDataModel = [self viewDataModelForIdentifier:identifier];
    if (viewDataModel == nil) {
        return nil;
    }
    
    Class viewClass = viewDataModel.viewClass;
    if (viewClass && viewDataModel.type == ViewTypeNative) {
        
        SEL initMethod = [viewDataModel.viewInitMethod pointerValue];
        
        NSObject * object = nil;
        
        if (viewClass && initMethod) {
            NSMutableDictionary *params = nil;
            
            if (viewDataModel.webUrl) {
                params = [NBURLHelper getURLParamsWithURL:[NSURL URLWithString:viewDataModel.webUrl] defaultKey:viewDataModel.paramKey];
            }
            viewDataModel.queryForInitMethod = params;
            [viewDataModel.queryForInitMethod setValue:viewDataModel.identifier forKey:APPURL_PARAM_IDENTIFIER];
            object               = [viewClass alloc];
            [self configObject:object withViewDataModel:viewDataModel propertyDict:nil shouldCallInitMethod:YES];
        } else {
            object = [[viewClass alloc] init];
        }
        
        if ([object respondsToSelector:@selector(setDesc:)]) {
            [object performSelector:@selector(setDesc:) withObject:viewDataModel.desc];
        }
        
        if (object && [object isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)object;
        }
        
    } else {
        
        NSString *fielUrlString = [NBURLMap fileUrlWithFilePath:viewDataModel.filePath];
        if (viewDataModel.type == ViewTypeOnlineH5) {
            fielUrlString = viewDataModel.webUrl;
        }
        
        NSMutableDictionary *query = [NSMutableDictionary dictionary];
        [query setValue:fielUrlString forKey:@"_url"];
        [query setValue:viewDataModel.desc forKey:@"_desc"];
        [query setValue:viewDataModel.identifier forKey:APPURL_PARAM_IDENTIFIER];
        
        if ([self.delegate respondsToSelector:@selector(navigatorWebViewControllerForURL:)]) {
            UIViewController *webVC = [self.delegate navigatorWebViewControllerForURL:fielUrlString];
            return webVC;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(navigatorAuthForViewModel:)]) {
        [self.delegate navigatorAuthForViewModel:viewDataModel];
    }
    
    return nil;
}

- (BOOL)hasIdentifier:(NSString *)identifier
{
    NBViewDataModel * viewDataModel = [self viewDataModelForIdentifier:identifier];
    return viewDataModel != nil;
}

#pragma mark - jump
- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
            propertyDictionary:(NSDictionary *)propertyDictionary{
    if (identifier) {
        [self gotoViewWithIdentifier:identifier
                        queryForInit:initParams
                    queryForInstance:nil
                  propertyDictionary:propertyDictionary
                          retrospect:NO
                            animated:YES];
    }
}

- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
              queryForInstance:(NSDictionary *)instanceParams
            propertyDictionary:(NSDictionary *)propertyDictionary{
    if (identifier) {
        [self gotoViewWithIdentifier:identifier
                        queryForInit:initParams
                    queryForInstance:instanceParams
                  propertyDictionary:propertyDictionary
                          retrospect:NO
                            animated:YES];
    }
}

- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
              queryForInstance:(NSDictionary *)instanceParams
            propertyDictionary:(NSDictionary *)propertyDictionary
                    retrospect:(BOOL)retrospect
                      animated:(BOOL)animated{
    if (identifier) {
        NBViewDataModel * viewDataModel     = [self viewDataModelForIdentifier:identifier];
        viewDataModel.queryForInitMethod    = [NSMutableDictionary dictionaryWithDictionary:initParams];
        viewDataModel.viewInstanceMethod    = [NSValue valueWithPointer:@selector(doInitializeWithQuery:)];
        viewDataModel.queryForInstanceMethod= [NSMutableDictionary dictionaryWithDictionary:instanceParams];
        if (!viewDataModel) {
            NSLog(@"identifier=%@ 未在viewMap中注册",identifier);
        }
        [self pushViewControllerWithViewDataModel:viewDataModel propertyDict:propertyDictionary retrospect:retrospect animated:animated];
    }
}

#pragma mark - perform
- (void)processService:(SEL)selector params:(NSDictionary *)params{
    if (!selector) {
        return;
    }
    
    if (self.topViewController && [self.topViewController respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
                                           [self.topViewController performSelector:selector withObject:params];
                                           );
    } else if (self.rootViewController && [self.rootViewController respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
                                           [self.rootViewController performSelector:selector withObject:params];
                                           );
    } else if ([self respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
                                           [self performSelector:selector withObject:params];
                                           );
    }
}


@end
