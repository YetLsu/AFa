//
//  YYRegisterController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/3.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYRegisterController.h"
#import "MBProgressHUD+CZ.h"
#import "YYProfileViewController.h"
#import "YYLoginController.h"
#import "YYAccountTool.h"
#import "YYNavigationController.h"
#import "YYTabBarController.h"
#import <SMS_SDK/SMSSDK.h>



@interface YYRegisterController ()<UIAlertViewDelegate>
@property(nonatomic, weak) UITextField *phoneTextField;//账号
@property (nonatomic, weak) UITextField * authenticationField;//验证码
@property (nonatomic, weak) UITextField *passWordField;//设置登录密码

@property (nonatomic,assign) int timeCount;//计时

@end

@implementation YYRegisterController
- (void)previousProfile{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"navigation_previous"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(previousProfile)];
    
    //增加登录页面的背景图片
    CGFloat margin = 15/ 275.5 * widthScreen;
    CGFloat imageViewW = widthScreen - 2 * margin;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, 15 + 64, imageViewW, 150)];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = YYViewBGColor;
    [self.view addSubview: imageView];
    
    //在view上增加账号输入框
    self.phoneTextField = [self createTextFieldWithImageFrame:CGRectMake(20, 15, 21.5, 24) andSuperView:imageView andImage:[UIImage imageNamed:@"profile_account"]];
    self.phoneTextField.placeholder = @"请输入11位中国大陆手机号码";
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    //增加线条
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(10/ 375.0 *widthScreen, 50, imageViewW - 2 * 10/ 375.0 *widthScreen, 0.5) andView:imageView];
    
    //增加验证码输入框
    self.authenticationField = [self createTextFieldWithImageFrame:CGRectMake(22, 62, 16, 23.5) andSuperView:imageView andImage:[UIImage imageNamed:@"profile_phone"]];
    self.authenticationField.placeholder = @"请输入短信验证码";
    
    //增加线条
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(10/ 375.0 *widthScreen, 100, imageViewW - 2 * 10/ 375.0 *widthScreen, 0.5) andView:imageView];
    
    //设置登录密码
    self.passWordField = [self createTextFieldWithImageFrame:CGRectMake(21, 112, 17, 23.5) andSuperView:imageView andImage:[UIImage imageNamed:@"profile_password"]];
    self.passWordField.placeholder = @"请设置登录密码";
    
    //增加button
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(margin, 214 + (15 + 25)/ 667.0 *heightScreen, imageViewW, 42)];
    [self.view addSubview:registerBtn];
    [registerBtn setTitle:@"注册并登录" forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_yellowbg"] forState:UIControlStateNormal];

    [registerBtn addTarget:self action:@selector(registerAndLogin) forControlEvents:UIControlEventTouchUpInside];

}
/**
 *  注册并登录
 *
 */
- (void)registerAndLogin{
    YYLog(@"注册并登录");
    //先验证验证码是否正确

    NSString *userName = self.phoneTextField.text;
    NSString *passWord = self.passWordField.text;
    NSString *authentication = self.authenticationField.text;

    if (userName.length != 11) {
        [MBProgressHUD showError:@"请输入11位手机号" toView:self.view];
        return;
    }
    else if (passWord.length == 0){
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    else if (authentication.length == 0){
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    [SMSSDK commitVerificationCode:authentication phoneNumber:userName zone:@"86" result:^(NSError *error) {        
        if (!error) {
            YYLog(@"验证成功");
            [self registerUserWithPhone:userName andPassWord:passWord];
        }
        else
        {
            YYLog(@"错误信息:%@",error);
            [MBProgressHUD showError:@"验证失败"];
        }
    }];

    
}
#pragma mark 注册
- (void)registerUserWithPhone:(NSString *)userName andPassWord:(NSString *)passWord{
    NSString *urlString = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=41&username=%@&password=%@",userName,passWord];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 2. 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:10.0];
    
    // 3. 连接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError) {
            YYLog(@"%@",connectionError);
            return;
        }
        // 反序列化
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([result[@"msg"] isEqualToString:@"ok"]) {
            YYLog(@"注册成功");
            //把uid保存到account
            YYAccount *account = [[YYAccount alloc] init];
            
            account.userPhone = self.phoneTextField.text;
            account.userUID = result[@"buid"];
            
            [YYAccountTool saveAccount:account];
            
//            YYProfileViewController *profile = [[YYProfileViewController alloc] init];
//            [self.navigationController pushViewController:profile animated:YES];
            YYTabBarController *tabbar = [[YYTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
            
            [self dismissViewControllerAnimated:YES completion:nil];

            
        }
        else if ([result[@"msg"] isEqualToString:@"exsit"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该用户已经存在" message:@"是否去登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            
            [alert show];
        }
        
        YYLog(@"%@", result);
  
    }];

}
/**
 *  创建带图片的textField,如果是验证码的输入框增加按钮
 */
- (UITextField *)createTextFieldWithImageFrame:(CGRect)imageFrame andSuperView:(UIImageView *)superView andImage:(UIImage *)image{
    
    CGFloat imageViewW = widthScreen - 2 * 15/ 275.5 * widthScreen;
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:imageFrame];
    iconView.image = image;
    [superView addSubview:iconView];

    UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(15 + 22 + 10, 0, superView.frame.size.width - 15 - 22- 10, 50)];
    if (imageFrame.origin.y > 50 && imageFrame.origin.y < 100) {//输入验证码，改y值和宽度
        userName.y = 50;
        userName.width = imageViewW - 100 - 15 - 22 - 10;
        //增加发送验证码按钮
        UIButton *sendAuthenticationBtn = [[UIButton alloc] initWithFrame:CGRectMake
        (imageViewW - 10 - 90 , 50, 90, 50)];
        [superView addSubview:sendAuthenticationBtn];
        
        [sendAuthenticationBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [sendAuthenticationBtn setTitleColor:[UIColor colorWithRed:177/255.0 green:151/255.0 blue:36/255.0 alpha:1] forState:UIControlStateNormal];
        [sendAuthenticationBtn setTitleColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1] forState:UIControlStateSelected];
        sendAuthenticationBtn.tag = 100001;
        sendAuthenticationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [sendAuthenticationBtn addTarget:self action:@selector(sendAuthenticationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (imageFrame.origin.y > 100){
        userName.y = 100;
       
    }
    [superView addSubview:userName];
    
    return userName;
}
#pragma mark发送验证码按钮被点击
- (void)sendAuthenticationBtnClick:(UIButton *)sender{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            [MBProgressHUD showSuccess:@"成功发送验证码"];
            [sender setTitle:[NSString stringWithFormat:@"60秒后重新获取"] forState:UIControlStateSelected];
            sender.selected = YES;
            sender.userInteractionEnabled = NO;
            
            self.timeCount = 60;//60秒后重发
            if (sender.selected == YES) {
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime:) userInfo:nil repeats:YES];
                
            }
            
            
        }
        else{
            YYLog(@"%@",error.userInfo[@"getVerificationCode"]);
           [MBProgressHUD showError:@"验证码发送失败"];
        }
    }];
   
   
}
- (void)changeTime:(id)sender{
    UIButton *Btn = [self.view viewWithTag:100001];
    self.timeCount--;
    YYLog(@"%d",self.timeCount);
    [Btn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",self.timeCount] forState:UIControlStateSelected];
    if (self.timeCount == 0) {
        Btn.selected = NO;
        [sender invalidate];
        Btn.userInteractionEnabled = YES;
        [Btn setTitle:@"重新发送" forState:UIControlStateNormal];
        //[Btn setTitle:[NSString stringWithFormat:@"60秒后重新获取"] forState:UIControlStateSelected];
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  已存在的时候点击确定或者取消
 *
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//去登录页面
        YYLoginController *login = [[YYLoginController alloc] init];
        YYNavigationController *nav = (YYNavigationController *)self.navigationController;
        [nav pushToRootController:login];
    }
    
}

@end
