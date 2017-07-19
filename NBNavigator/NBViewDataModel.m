//
//  NBViewDataModel.m
//  Pods
//
//  Created by 刘彬 on 2017/7/7.
//
//

#import "NBViewDataModel.h"

@implementation NBViewDataModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

- (NSNumber *)viewConformsToProtocol:(Protocol *)protocol {
    NSNumber * flag = nil;
    
    if (self.viewClass) {
        flag = [NSNumber numberWithBool:[self.viewClass conformsToProtocol:protocol]];
    }
    
    return flag;
}

- (void)didReceiveMemoryWarning
{
    // 有内存警告 清理缓存
    self.cachedController = nil;
    self.queryForInitMethod = nil;
    self.queryForInstanceMethod = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
