//
//  YYTabBarController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/5.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYTabBarController.h"
#import "YYHomeViewController.h"
#import "YYSortController.h"
#import "YYOrderViewController.h"
#import "YYProfileViewController.h"
#import "YYNavigationController.h"
#import "YYGoLoginController.h"
#import "YYLittleColdViewController.h"
#import "YYGossipViewController.h"
#import "YYAccountTool.h"

@interface YYTabBarController ()

@end

@implementation YYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YYHomeViewController *home = [[YYHomeViewController alloc] init];
    [self addChildControllerWithChildController:home image:[UIImage imageNamed:@"tabbar_home_normal"] selectImage:[UIImage imageNamed:@"tabbar_home_high"] title:@"首页"];
    
//    YYSortController *sort = [[YYSortController alloc] init];
//    [self addChildControllerWithChildController:sort image:[UIImage imageNamed:@"tabbar_2_normal"] selectImage:[UIImage imageNamed:@"tabbar_2_high"] title:@"品类"];
    
//    YYOrderViewController *order = [[YYOrderViewController alloc] init];
//    [self addChildControllerWithChildController:order image:[UIImage imageNamed:@"tabbar_3_normal"] selectImage:[UIImage imageNamed:@"tabbar_3_high"] title:@"订单"];
//    self.orderController = order;
    
    YYLittleColdViewController *little = [[YYLittleColdViewController alloc] init];
    
    [self addChildControllerWithChildController:little image:[UIImage imageNamed:@"tabbar_littleCold_normal"] selectImage:[UIImage imageNamed:@"tabbar_LittleCold_high"] title:@"有点冷"];

    
    YYGossipViewController *gossip = [[YYGossipViewController alloc] init];
    [self addChildControllerWithChildController:gossip image:[UIImage imageNamed:@"tabbar_gossip_normal"] selectImage:[UIImage imageNamed:@"tabbar_gossip_high"] title:@"八卦圈"];
    //配置文件是否存在uid
//    YYAccount *account = [YYAccountTool account];
  
//    if (account.userUID) {//存在uid[UIImage imageNamed:@"tabbar_profile_normal"]
//    [UIImage imageNamed:@"tabbar_profile_high"]@"我的"
            YYProfileViewController *profile = [[YYProfileViewController alloc] init];
    self.profile = [self addChildControllerWithChildController:profile image:[UIImage imageNamed:@"tabbar_profile_normal"] selectImage:[UIImage imageNamed:@"tabbar_profile_high"] title:@"我的"];
//    }
//    else{//不存在uid
       
//    }

    
}
- (void)reloadView{
  
    YYLog(@"");
}
- (YYNavigationController *)addChildControllerWithChildController:(UIViewController *)vc image:(UIImage *)image selectImage:(UIImage *)selImage title:(NSString *)title{
    
    vc.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.title = title;
    
    NSMutableDictionary *attrHigh = [NSMutableDictionary dictionary];
    attrHigh[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    [vc.tabBarItem setTitleTextAttributes:attrHigh forState:UIControlStateNormal];
    
    [vc.tabBarItem setTitleTextAttributes:attrHigh forState:UIControlStateSelected];
    
    YYNavigationController *nav = [[YYNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
    
    return nav;
    
}
//- (YYNavigationController *)addChildControllerWithChildControllerOut:(UIViewController *)vc image:(UIImage *)image selectImage:(UIImage *)selImage title:(NSString *)title{
//    vc.tabBarItem.image = image;
//    vc.tabBarItem.selectedImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
//    vc.title = title;
//    
//    NSMutableDictionary *attrHigh = [NSMutableDictionary dictionary];
//    attrHigh[NSForegroundColorAttributeName] = [UIColor colorWithRed:126/255.0 green:190/255.0 blue:78/255.0 alpha:1];
//    
//    [vc.tabBarItem setTitleTextAttributes:attrHigh forState:UIControlStateSelected];
//    
//    YYNavigationController *nav = [[YYNavigationController alloc] initWithRootViewController:vc];
//    
//    return nav;
//}
@end
