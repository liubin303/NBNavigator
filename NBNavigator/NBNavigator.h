//
//  NBNavigator.h
//  Pods
//
//  Created by 刘彬 on 2017/7/7.
//
//

#import "NBBaseNavigator.h"

@class NBViewDataModel;
@class NBNavigator;

// 打开url
BOOL openURL(NSString * url);

@interface NBNavigator : NBBaseNavigator


/*!
 @method
 @abstract      打开url链接
 @param         url: 要打开的url
 @discussion    url可以使用类 NBURLMap 中提供的方法来生成
 @return        void
 */
- (BOOL)openURL:(NSString *)url;

/*!
 @method
 @abstract      根据identifier打开对应的页面
 @param         identifier: 页面标识
 @param         queryForInit:初始化方法参数，初始化方法需遵从NBNavigatorProtocol协议中initWithQuery:
 @discussion    根据identifier打开对应的页面，初始化参数可以为object，如果使用H5打开页面会过滤掉object的参数。所以如果要传递一个对象，需要传递object和objectId两个参数，使用native可以使用object对象，使用H5页面则需要使用objectId参数。
 使用示例：[[NBNavigator sharedInstance] openViewWithIdentifier:APPURL_VIEW_IDENTIFIER_THEMEDETAIL
 queryForInit:@{@"_themeId":@"1",@"_theme":theme}];
 @return        BOOL
 */
- (BOOL)openViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)queryForInit;

/*!
 @method
 @abstract      根据identifier打开对应的页面
 @param         identifier: 页面标识
 @param         queryForInit:初始化方法参数，初始化方法需遵从NBNavigatorProtocol协议中initWithQuery:
 @param         propertyDictionary: 属性字典，存放了ViewController相应的属性key，value
 @discussion    根据identifier打开对应的页面，初始化参数可以为object，如果使用H5打开页面会过滤掉object的参数。所以如果要传递一个对象，需要传递object和objectId两个参数，使用native可以使用object对象，使用H5页面则需要使用objectId参数。
 使用示例：[[NBNavigator sharedInstance] openViewWithIdentifier:APPURL_VIEW_IDENTIFIER_THEMEDETAIL
 queryForInit:@{@"_themeId":@"1",@"_theme":theme}];
 @return        BOOL
 */
- (BOOL)openViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)queryForInit
            propertyDictionary:(NSDictionary *)propertyDic;

/*!
 @method
 @abstract      根据identifier获取对应的ViewController Class
 @param         identifier: 页面标识
 @discussion    使用示例：[[NBNavigator sharedInstance] viewControllerWithIdentifier:@"detail"];
 @return        UIViewController
 */
- (UIViewController *)viewControllerWithIdentifier:(NSString *)identifier;

/*!
 @method
 @abstract      判断是否有identifier对应的ViewController Class
 @param         identifier: 页面标识
 @discussion    使用示例：[[NBNavigator sharedInstance] hasIdentifier:@"detail"];
 @return        是否包含
 */
- (BOOL)hasIdentifier:(NSString *)identifier;

/*!
 @method
 @abstract      根据配置参数进行页面跳转
 @param         identifier: view标识，用来索引相应的viewcontroller
 @param         initParams: 初始化方法参数，初始化方法需遵从NBNavigatorProtocol协议中initWithQuery:
 @param         propertyDictionary: 属性字典，存放了ViewController相应的属性key，value
 @discussion    使用示例：
 [[NBNavigator sharedInstance] gotoViewWithIdentifier:APPURL_IDENTIFIER_WEBVIEW queryForInit:@{@"_url": @"http://www.baidu.com"} propertyDictionary:@{@"title": @"你好"}];
 @return        void
 */
- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
            propertyDictionary:(NSDictionary *)propertyDictionary;

/*!
 @method
 @abstract      根据配置参数进行页面跳转
 @param         identifier: view标识，用来索引相应的viewcontroller
 @param         initParams: 初始化方法参数，初始化方法需遵从NBNavigatorProtocol协议
 @param         instanceParams: 实例化方法参数,需遵从NBNavigatorProtocol协议
 @param         propertyDictionary: 属性字典，存放了相应的属性key，value
 @discussion    使用示例：
 [[NBNavigator sharedInstance] gotoViewWithIdentifier:APPURL_IDENTIFIER_WEBVIEW queryForInit:@{@"_url": @"http://www.baidu.com"} propertyDictionary:@{@"title": @"你好"}];
 @return        void
 */
- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
              queryForInstance:(NSDictionary *)instanceParams
            propertyDictionary:(NSDictionary *)propertyDictionary;


/*!
 @method
 @abstract      根据配置参数进行页面跳转
 @param         identifier: view标识，用来索引相应的viewcontroller
 @param         initParams: 初始化方法参数，初始化方法需遵从NBNavigatorProtocol协议
 @param         instanceParams: 实例化方法参数,需遵从NBNavigatorProtocol协议
 @param         propertyDictionary: 属性字典，存放了相应的属性key，value
 @param         retrospect: 是否回溯，即当viewcontroller已经在导航堆栈中，是否要跳转回去到这个页面
 @param         animated: 是否需要页面切换效果
 @discussion    使用示例：
 [[NBNavigator sharedInstance] gotoViewWithIdentifier:APPURL_IDENTIFIER_WEBVIEW queryForInit:@{@"_url": @"http://www.baidu.com"} propertyDictionary:@{@"title": @"你好"}];
 @return        void
 */
- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
              queryForInstance:(NSDictionary *)instanceParams
            propertyDictionary:(NSDictionary *)propertyDictionary
                    retrospect:(BOOL)retrospect
                      animated:(BOOL)animated;


@end
