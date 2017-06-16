//
//  YYGoLoginController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/3.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYGoLoginController.h"
#import "YYLoginController.h"
#import "YYRegisterController.h"
#import "YYNavigationController.h"

@interface YYGoLoginController ()

@end

@implementation YYGoLoginController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:254/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    
    //增加图片
    CGFloat imageViewW = 225/375.0*widthScreen;
    CGFloat imageViewH = 140/667.0*heightScreen;
    CGFloat imageViewX = (widthScreen - imageViewW)/2.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, 200/667.0*heightScreen, imageViewW, imageViewH)];

    [self.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"profile_noLogin"];
    
    //增加label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 420 /667.0 * heightScreen, widthScreen, 25)];
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = YYGrayTextColor;
    label.text = @"登录成功后，可以查看你的个人中心";
    
    //增加登录btn
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setViewFrame:CGRectMake(70, 465, 105, 45)];
    [self.view addSubview:loginBtn];
    
    [loginBtn setImage:[UIImage imageNamed:@"profile_login"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
//    增加注册Btn
    UIButton *registerBtn = [[UIButton alloc] init];
    [registerBtn setViewFrame:CGRectMake(200, 465, 105, 45)];
    [self.view addSubview:registerBtn];
//    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
//    [registerBtn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
    [registerBtn setImage:[UIImage imageNamed:@"profile_register"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];

}

/**
 *  登录
 */
- (void)loginClick{
    YYLoginController *login = [[YYLoginController alloc] init];
    YYNavigationController *nav = [[YYNavigationController alloc] initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:nil];
}
/**
 *  注册
 */
- (void)registerClick{

    YYRegisterController *registerController = [[YYRegisterController alloc] init];
    YYNavigationController *nav = [[YYNavigationController alloc] initWithRootViewController:registerController];

    [self presentViewController:nav animated:YES completion:nil];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
