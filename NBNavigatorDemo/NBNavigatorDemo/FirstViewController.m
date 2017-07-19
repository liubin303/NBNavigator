//
//  FirstViewController.m
//  NBNavigatorDemo
//
//  Created by 刘彬 on 2017/7/7.
//  Copyright © 2017年 NB. All rights reserved.
//

#import "FirstViewController.h"
#import "FFUIFactory.h"
#import "NBNavigator.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"1";
    NSArray *URLList = @[@"https://m.fengqu.com/user/login.html",
                         @"https://www.baidu.com",
                         @"https://m.nbn.com/login.html",
                         @"nbn://view/login",
                         @"nbn://view/login?_title=水水水水&_tabIndex=4",
                         @"nbn://view/second?title=second",
                         @"https://m.nbn.com/third.html"];
    
    [URLList enumerateObjectsUsingBlock:^(NSString *  _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
        [self buildBtnForTitle:url atIndex:idx];
    }];
}

- (void)btnAction:(UIButton *)btn{
    openURL(btn.ff_normalTitle);
}

- (void)buildBtnForTitle:(NSString *)title atIndex:(NSInteger)index{
    UIButton *btn = [UIButton ff_buttonWithSize:CGSizeMake(320, 50)
                                   cornerRadius:5
                                           font:[UIFont systemFontOfSize:14]
                                    normalColor:[UIColor blackColor]
                                  selectedColor:[UIColor blackColor]
                                  disabledColor:[UIColor blackColor]
                                  normalBgColor:[UIColor whiteColor]
                                selectedBgColor:[UIColor whiteColor]
                                disabledBgColor:[UIColor whiteColor]];
    btn.ff_normalTitle = title;
    btn.ff_centerX = self.view.ff_centerX;
    btn.ff_y = 100+index*(20+50);
    [btn ff_addTarget:self touchAction:@selector(btnAction:)];
    [self.view addSubview:btn];
}
@end
