//
//  AppDelegate.m
//  NBNavigatorDemo
//
//  Created by 刘彬 on 2017/7/7.
//  Copyright © 2017年 NB. All rights reserved.
//

#import "AppDelegate.h"
#import "NBNavigator.h"
#import "NBURLHelper.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "WebViewController.h"
#import "NBViewMap.h"

@interface AppDelegate ()<NBNavigatorDelegate,UITabBarDelegate>

@property (nonatomic, strong) UITabBarController *tabbarController;

@end

@implementation AppDelegate

#pragma mark - NBNavigatorDelegate
- (void)navigatorWillChangeTabbarToIndex:(NSInteger)index{
    if (index > self.tabbarController.viewControllers.count-1) {
        return;
    }
    self.tabbarController.selectedIndex = index;
    [[NBNavigator sharedInstance] setupRootViewController:self.tabbarController.viewControllers[self.tabbarController.selectedIndex]];
}

- (UIViewController *)navigatorWebViewControllerForURL:(NSString *)urlString{
    WebViewController *webvc = [[WebViewController alloc] init];
    return webvc;
}

- (NSString *)navigatorPathOfLocalH5{
    return @"www";
}

- (BOOL)navigatorAuthForViewModel:(NBViewDataModel *)viewModel{
    if (viewModel.role == ViewRoleLogin) {
        [[NBNavigator sharedInstance] openViewWithIdentifier:APPURL_VIEW_IDENTIFIER_LOGIN queryForInit:nil propertyDictionary:nil];
        return NO;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //优先初始化sdk，将资源加载
    [NBNavigator sharedInstance].delegate = self;
    self.window = [[NBNavigator sharedInstance] window];
    self.window.autoresizesSubviews = YES;
    
    //a.初始化一个tabBar控制器
    UITabBarController *tb=[[UITabBarController alloc]init];
    //设置控制器为Window的根控制器
    self.window.rootViewController=tb;
    
    //b.创建子控制器
    
    FirstViewController *c1=[[FirstViewController alloc]init];
    c1.view.backgroundColor=[UIColor grayColor];
    
    UINavigationController *navc1 = [[UINavigationController alloc] initWithRootViewController:c1];
    navc1.tabBarItem.title=@"消息";
    navc1.tabBarItem.image=[UIImage imageNamed:@"tab_recent_nor"];
    navc1.tabBarItem.badgeValue=@"123";
    
    SecondViewController *c2=[[SecondViewController alloc]init];
    c2.view.backgroundColor=[UIColor brownColor];
    
    UINavigationController *navc2 = [[UINavigationController alloc] initWithRootViewController:c2];
    navc2.tabBarItem.title=@"联系人";
    navc2.tabBarItem.image=[UIImage imageNamed:@"tab_buddy_nor"];
    
    ThirdViewController *c3=[[ThirdViewController alloc]init];
    c3.view.backgroundColor = [UIColor yellowColor];
    
    UINavigationController *navc3 = [[UINavigationController alloc] initWithRootViewController:c3];
    navc3.tabBarItem.title=@"动态";
    navc3.tabBarItem.image=[UIImage imageNamed:@"tab_qworld_nor"];
    
    FourthViewController *c4=[[FourthViewController alloc]init];
    c4.view.backgroundColor=[UIColor greenColor];
    
    UINavigationController *navc4 = [[UINavigationController alloc] initWithRootViewController:c4];
    navc4.tabBarItem.title=@"设置";
    navc4.tabBarItem.image=[UIImage imageNamed:@"tab_me_nor"];
    
    tb.viewControllers=@[navc1,navc2,navc3,navc4];
    
    self.tabbarController = tb;
    self.tabbarController.delegate = self;
    [[NBNavigator sharedInstance] setupRootViewController:self.tabbarController.viewControllers[self.tabbarController.selectedIndex]];
    //设置工程的scheme identifier
    [NBURLHelper setSchemeIdentifier:@"com.nb.navigator"];

    self.window.rootViewController = tb;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [[NBNavigator sharedInstance] setupRootViewController:viewController];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [[NBNavigator sharedInstance] openURL:[url absoluteString]];
}

@end
