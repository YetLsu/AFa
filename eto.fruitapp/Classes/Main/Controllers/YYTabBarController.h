//
//  YYTabBarController.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/5.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYOrderViewController,YYNavigationController;
@interface YYTabBarController : UITabBarController
@property (nonatomic, weak) YYOrderViewController *orderController;

@property (nonatomic, weak) YYNavigationController *profile;
//- (YYNavigationController *)addChildControllerWithChildControllerOut:(UIViewController *)vc image:(UIImage *)image selectImage:(UIImage *)selImage title:(NSString *)title;
@end
