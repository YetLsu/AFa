//
//  AppDelegate.h
//  eto.fruitapp
//
//  Created by wyy on 15/10/28.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, weak) YYTabBarController *tabbarController;

- (void)sendPay_demo;
@end

