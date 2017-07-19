//
//  NBViewDataModel.h
//  Pods
//
//  Created by 刘彬 on 2017/7/7.
//
//

#import <Foundation/Foundation.h>

/*!
 *  @brief 界面类型
 */
typedef NS_ENUM(NSInteger, ViewType) {
    ViewTypeNative,
    ViewTypeLocalH5,
    ViewTypeOnlineH5,
};

/*!
 *  @brief 界面权限
 */
typedef NS_ENUM(NSInteger, ViewRole) {
    ViewRoleNone,
    ViewRoleLogin,
};

/*!
 @class
 @abstract      view相关数据封装，这些数据用于viewcontroller全局跳转使用
 */
@interface NBViewDataModel : NSObject

// view 的类
@property (nonatomic, strong)   Class                viewClass;
// view 初始化方法
@property (nonatomic, strong)   NSValue             *viewInitMethod;
// view 实例化方法
@property (nonatomic, strong)   NSValue             *viewInstanceMethod;
// 初始化方法参数，是字典类型
@property (nonatomic, strong)   NSMutableDictionary *queryForInitMethod;
// 实例方法参数，字典类型
@property (nonatomic, strong)   NSMutableDictionary *queryForInstanceMethod;
// identifier
@property (nonatomic, copy)     NSString            *identifier;
// view对应的H5页面的URL
@property (nonatomic, copy)     NSString            *webUrl;
// view对应的本地HTML文件的路径
@property (nonatomic, copy)     NSString            *filePath;
// view 加载的类型：0:本地   1:local h5   2:web H5
@property (nonatomic, assign)   ViewType             type;
// view 权限：0:无   1:登录
@property (nonatomic, assign)   ViewRole             role;
// view描述信息
@property (nonatomic, copy)     NSString            *desc;
// webUrl 中的XXX.htmlkey，例如 www.xxx.com/detail/101.html  101对应的Key
@property (nonatomic, copy)     NSString            *paramKey;
@property (nonatomic, copy)     NSString            *inTab;

// 使用缓存
@property (nonatomic, assign) BOOL useCache;
// 缓存下的Controller
@property (nonatomic, strong) NSObject *cachedController;

/*!
 @property
 @abstract      字典，用来存放属性键值对
 */
//@property (nonatomic, strong)   NSDictionary        *    propertyDictionary;

/*!
 @method
 @abstract      viewcontroller是否遵守协议
 @param         protocol: 协议
 @return        NSNumber,是否遵守协议
 */
- (NSNumber *)viewConformsToProtocol:(Protocol *)protocol;


@end
