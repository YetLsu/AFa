//
//  YYLoginController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/3.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYLoginController.h"
#import "YYRegisterController.h"
#import "YYProfileViewController.h"
#import "MBProgressHUD+CZ.h"
#import "YYAccountTool.h"
#import "YYNavigationController.h"
#import "YYTabBarController.h"

@interface YYLoginController ()

@property (weak, nonatomic) UITextField *userName;
@property (weak, nonatomic) UITextField *password;

@end

@implementation YYLoginController
//返回主界面
- (void)previousProfile{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setRightBarButton{
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(widthScreen -  YY16WidthMargin - 60, 2, 60, 40);
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:registBtn];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile_register_1"]  style:UIBarButtonItemStylePlain target:self action:@selector(registerClick)];
    //self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    UIImage *image = [UIImage imageNamed:@"navigation_previous"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(previousProfile)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //添加右上角的注册
    
    [self setRightBarButton];
   
    
    //增加登录页面的背景图片
    CGFloat margin = 15/ 275.5 * widthScreen;
    CGFloat imageViewW = widthScreen - 2 * margin;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, 15 + 64, imageViewW, 100)];
    imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = YYViewBGColor;
    [self.view addSubview: imageView];
    
    //在view上增加账号输入框
    self.userName = [self createTextFieldWithImageFrame:CGRectMake(15, 10, 22, 25) andSuperView:imageView andImage:[UIImage imageNamed:@"profile_account"]];
    self.userName.placeholder = @"手机号";
    self.userName.keyboardType = UIKeyboardTypeNumberPad;
    
    
    
    //增加线条
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(10/ 375.0 *widthScreen, 50, imageViewW - 2 * 10/ 375.0 *widthScreen, 0.5) andView:imageView];
    
    self.password = [self createTextFieldWithImageFrame:CGRectMake(18, 61, 18, 25) andSuperView:imageView andImage:[UIImage imageNamed:@"profile_password"]];
    self.password.placeholder = @"请输入密码";
    self.password.secureTextEntry  = YES;
    
    //增加button
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(margin, 164 + (15 + 25)/ 667.0 *heightScreen, imageViewW, 42)];
    [self.view addSubview:loginBtn];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_yellowbg"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加找回密码按钮
    UIButton *foundBtn = [[UIButton alloc] initWithFrame:CGRectMake(widthScreen - 70 -margin, 164 + 42 + (15 + 25 + 8)/ 667.0 *heightScreen, 70, 20)];
    [foundBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [foundBtn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
    foundBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:foundBtn];
    [foundBtn addTarget:self action:@selector(foundPassWord) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  创建带图片的textField
 */
- (UITextField *)createTextFieldWithImageFrame:(CGRect)imageFrame andSuperView:(UIImageView *)superView andImage:(UIImage *)image{
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:imageFrame];
    iconView.image = image;
    [superView addSubview:iconView];
    
    UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(15 + 22 + 10, 0, superView.frame.size.width - 15 - 22- 10, 50)];
    if (imageFrame.origin.y > 50) {
        userName.y = 50;
    }
    [superView addSubview:userName];
    
    return userName;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  点击登陆按钮发送请求
 */
- (void)loginBtnClick {
    
    YYLog(@"登陆");
    NSString *userName = self.userName.text;
    NSString *passWord = self.password.text;
    if ([userName isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入账号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    else if ([passWord isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=42&username=%@&password=%@",userName,passWord];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 2. 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:10.0];
    
    // 3. 连接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError) {
            YYLog(@"请求失败%@",connectionError);
            return;
        }
        // 反序列化
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        YYLog(@"%@",result);
        if ([result[@"msg"] isEqualToString:@"ok"]) {
            YYLog(@"登录成功");
            //把uid保存到配置文件
#warning 第一次登录之后保存信息
            YYAccount *account =  [[YYAccount alloc] init];;
            account.userUID = result[@"buid"];
            account.userNickName = result[@"nickname"];
            account.userIconImage = nil;
            account.userPhone = result[@"username"];
            account.landed = @"YES";
            
             //http://www.sxeto.com/fruitApp/7E643900247907B907053B48D8593351/headimg/head.png
            if ([result[@"bgimg"] isEqualToString:@" "]) {
                account.userBackgroundUrlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/%@",result[@"bgimg"]];
            }else{
               account.userBackgroundImage = [UIImage imageNamed:@"bgq_person_bgimage"];
            }
            
           
            
            
            [YYAccountTool saveAccount:account];
#pragma mark注册通知
            YYTabBarController *tabbar = [[YYTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
            [self.view endEditing:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        else{
            [MBProgressHUD showError:@"账号或密码错误"];
        }
    }];

}
/**
 *  点击注册按钮发送请求
 */
- (void)registerClick{
    YYLog(@"注册按钮");
    YYRegisterController *registerController = [[YYRegisterController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
}
/**
 *  点击找回密码
 */
- (void)foundPassWord{
    YYLog(@"找回密码");
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end