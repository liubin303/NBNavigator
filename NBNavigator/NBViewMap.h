//
//  NBViewMap.h
//  Pods
//
//  Created by 刘彬 on 2017/7/10.
//
//

#ifndef NBViewMap_h
#define NBViewMap_h

#define APPURL_HOST_VIEW                                                @"view"
#define APPURL_HOST_SERVICE                                             @"service"
#define APPURL_LOCAL_H5_PATH                                            @"www"

// 参数，是否回溯
#define APPURL_PARAM_RETROSPECT                                         @"_retrospect"
// 参数，是否需要切换效果
#define APPURL_PARAM_ANIMATED                                           @"_animated"
// 参数，tabbar索引
#define APPURL_PARAM_TABBARINDEX                                        @"_tabIndex"
// 参数，identifier
#define APPURL_PARAM_IDENTIFIER                                         @"_identifier"
// 参数，页面描述
#define APPURL_PARAM_DESC                                               @"_desc"
// 参数，导航栏标题
#define APPURL_PARAM_TITLE                                              @"_title"
// 参数，是否显示导航栏
#define APPURL_PARAM_NEEDSNAVIGATIONBAR                                 @"_needsNavigationBar"
// 参数，WEB URL
#define APPURL_PARAM_URL                                                @"_url"

#pragma mark - --------------------- SERVICE ---------------------

// 退出当前页面()
#define APPURL_SERVICE_IDENTIFIER_VIEWEXIT                              @"viewExit"
// 退到root页面
#define APPURL_SERVICE_IDENTIFIER_POPTOROOT                             @"popToRoot"

#pragma mark - --------------------- VIEW ------------------------
// 首页
#define APPURL_VIEW_IDENTIFIER_INDEX                                    @"index"
// 登录
#define APPURL_VIEW_IDENTIFIER_LOGIN                                    @"login"
// webview
#define APPURL_VIEW_IDENTIFIER_WEBVIEW                                  @"webview"

#endif /* NBViewMap_h */
