//
//  NBNavigatorViewController.m
//  Pods
//
//  Created by 刘彬 on 2017/7/17.
//
//

#import "NBNavigatorViewController.h"

@interface NBNavigatorViewController ()

@end

@implementation NBNavigatorViewController

- (instancetype)initWithQuery:(NSDictionary *)query {
    if (self = [super init]) {
        self.query = query;
        self.identifier = [query objectForKey:APPURL_PARAM_IDENTIFIER];
        self.desc = [query objectForKey:APPURL_PARAM_DESC];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.query.allKeys containsObject:APPURL_PARAM_TITLE]) {
        self.title = [self.query objectForKey:APPURL_PARAM_TITLE];
    }
    if ([self.query.allKeys containsObject:APPURL_PARAM_TABBARINDEX]) {
        self.tabBarController.selectedIndex = [[self.query objectForKey:APPURL_PARAM_TABBARINDEX] integerValue];
    }
    if ([self.query.allKeys containsObject:APPURL_PARAM_NEEDSNAVIGATIONBAR]) {
        self.navigationController.navigationBarHidden = ![[self.query objectForKey:APPURL_PARAM_NEEDSNAVIGATIONBAR] boolValue];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
