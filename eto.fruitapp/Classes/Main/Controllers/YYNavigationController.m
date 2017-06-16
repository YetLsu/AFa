//
//  YYNavigationController.m
//  eto.fruitapp
//
//  Created by wyy on 15/10/30.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYNavigationController.h"

@interface YYNavigationController ()

@end

@implementation YYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    attr[NSForegroundColorAttributeName] = [UIColor colorWithRed:161/255.0 green:199/255.0 blue:133/255.0 alpha:1];
    [item setTitleTextAttributes:attr forState:UIControlStateNormal];
    
    //设置导航条颜色

    UINavigationBar *navBar = [UINavigationBar appearance];
    
    [navBar setBarTintColor:YYNavigationBarColor];
}

+ (void)initialize{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIImage *image = [UIImage imageNamed:@"navigation_previous"];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navigationLeftBtnClick)];
    }
    
    [super pushViewController:viewController animated:YES];
}
- (void)navigationLeftBtnClick{
    
    [self popViewControllerAnimated:YES];
}
- (void)pushToRootController:(UIViewController *)VC{
    
    [self popToRootViewControllerAnimated:NO];
    [self pushViewController:VC animated:NO];

}

@end
