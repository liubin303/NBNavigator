//
//  DetailViewController.m
//  NBNavigatorDemo
//
//  Created by 刘彬 on 2017/7/14.
//  Copyright © 2017年 NB. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (instancetype)initWithQuery:(NSDictionary *)query{
    self = [super initWithQuery:query];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Detail";
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"self.userId=%@",self.userId);
    
    NSArray *URLList = @[@"nbn://service/viewExit",
                         @"nbn://service/popToRoot",
                         @"open detail with url",
                         @"push to detail",
                         @"goto a unknow identifier",
                         @"goto detail with nil",
                         @"goto detail with parameter",
                         @"goto detail with property",
                         ];
    
    [URLList enumerateObjectsUsingBlock:^(NSString *  _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
        [self buildBtnForTitle:url atIndex:idx];
    }];
}


- (void)btnAction:(UIButton *)btn{
    switch (btn.tag-1000) {
        case 0:
        case 1:
            openURL(btn.ff_normalTitle);
            break;
        case 2:{
            NSString *url = [NBURLMap urlForViewWithIdentifier:@"detail" params:@{@"urlString":@"https://m.163.com"}];
            openURL(url);
            break;
        }
        case 3:{
            [[NBNavigator sharedInstance] pushViewControllerWithViewDataModel:[[NBNavigator sharedInstance] viewDataModelForIdentifier:@"detail"] propertyDict:@{@"userId":@"1000"} animated:YES];
            break;
        }
        case 4:{
            [[NBNavigator sharedInstance] gotoViewWithIdentifier:@"xxxxx" queryForInit:nil queryForInstance:nil propertyDictionary:nil retrospect:NO animated:NO];
            break;
        }
        case 5:{
            [[NBNavigator sharedInstance] gotoViewWithIdentifier:@"detail" queryForInit:nil propertyDictionary:nil];
            break;
        }
        case 6:{
            [[NBNavigator sharedInstance] gotoViewWithIdentifier:@"detail" queryForInit:@{@"userId":@"8888"} propertyDictionary:nil];
            break;
        }
        case 7:{
            [[NBNavigator sharedInstance] gotoViewWithIdentifier:@"detail" queryForInit:nil propertyDictionary:@{@"userId":@"8888"}];
            break;
        }
            
        default:
            break;
    }
    
}

- (void)buildBtnForTitle:(NSString *)title atIndex:(NSInteger)index{
    UIButton *btn = [UIButton ff_buttonWithSize:CGSizeMake(320, 50)
                                   cornerRadius:5
                                           font:[UIFont systemFontOfSize:14]
                                    normalColor:[UIColor whiteColor]
                                  selectedColor:[UIColor whiteColor]
                                  disabledColor:[UIColor whiteColor]
                                  normalBgColor:[UIColor blackColor]
                                selectedBgColor:[UIColor blackColor]
                                disabledBgColor:[UIColor blackColor]];
    btn.ff_normalTitle = title;
    btn.ff_centerX = self.view.ff_centerX;
    btn.ff_y = 80+index*(20+50);
    btn.tag = 1000+index;
    [btn ff_addTarget:self touchAction:@selector(btnAction:)];
    [self.view addSubview:btn];
}

@end
