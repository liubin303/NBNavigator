//
//  NBNavigatorViewController.h
//  Pods
//
//  Created by 刘彬 on 2017/7/17.
//
//

#import <UIKit/UIKit.h>
#import "NBNavigatorProtocol.h"
#import "NBViewMap.h"
#import "NBNavigator.h"
#import "NBURLMap.h"

@interface NBNavigatorViewController : UIViewController<NBNavigatorProtocol>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSDictionary *query;

@end
