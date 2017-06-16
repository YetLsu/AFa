//
//  YYSetUserNameController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/2.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYSetUserNameController.h"
#import "YYSetPassWordController.h"
#import "YYAccountTool.h"

#define YYUserIconImageData @"YYUserIconImage"
#define YYUserNickName @"YYUserNickName"
#define YYUserPhone @"YYUserPhone"
#define YYSetUserName @"YYSetUserName"

@interface YYSetUserNameController ()
@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, copy) NSString *placedor;
@property (nonatomic, copy) NSString *footText;
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@end

@implementation YYSetUserNameController
- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}
- (instancetype)initWithTitle:(NSString *)title placedor:(NSString *)placedor footTexe:(NSString *)footText andTag:(NSInteger)tag{
    if (self = [super init]) {
        self.title = title;
        self.placedor = placedor;
        self.footText = footText;
        self.tag = tag;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YYViewBGColor;
   
    // 增加textField
    [self addMyTextField];
    
    if (self.tag == 0) {//修改用户名
//        创建下方的label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 62, widthScreen - 20, 20)];
        [self.view addSubview:label];
        label.text = self.footText;
        label.textColor = YYGrayTextColor;
        label.font = [UIFont systemFontOfSize:13];
        //添加确认按钮
        [self addSureBtnWithbtnFrame:CGRectMake(20, 90, widthScreen - 40, 42)];
    }
    else if (self.tag == 1){//修改密码，下面创建一个忘记密码按钮
       //添加确认按钮
        [self addSureBtnWithbtnFrame:CGRectMake(20, 70, widthScreen - 40, 42)];
    }

}
/**
 *  添加确认按钮
 */
- (void)addSureBtnWithbtnFrame:(CGRect)btnFrame{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [self.view addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_yellowbg"] forState:UIControlStateNormal];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  增加textField
 *
 */
- (void)addMyTextField{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, widthScreen, 42)];
    [self.view addSubview:textField];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = self.placedor;
    UIView *leftView = [[UIView alloc] init];
    leftView.width = 20;
    leftView.height = 42;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    self.textField = textField;

    
}

/**
 *  添加忘记密码按钮
 */
- (void)addForgetPassWordBtn{
    UIButton *forgetPasswordBtn = [[UIButton alloc] initWithFrame:CGRectMake(widthScreen - 60 - 20, 62, 60, 20)];
    [self.view addSubview:forgetPasswordBtn];
    [forgetPasswordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [forgetPasswordBtn setTitleColor:YYGrayTextColor forState:UIControlStateNormal];
}
#pragma mark 确认按钮点击
- (void)sureClick{
    if (self.textField.text.length == 0) {
        [MBProgressHUD showError:@"请输入昵称"];
        return;
    }
    if (self.tag == 0) {//点击修改用户名
       
        [self setUserName];
    }
    else if (self.tag == 1){//点击修改密码
        //1提交到服务器验证原密码是否正确
        
        //2若正确弹出输入新密码控制器
        YYSetPassWordController *passController = [[YYSetPassWordController alloc] initWithTag:0];
        [self.navigationController pushViewController:passController animated:YES];
        
    }
   
}
/**
 *  修改用户名
 */
- (void)setUserName{
    NSString *nickName = self.textField.text;
    
    NSString *setNickNameUrlStr = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=44&buid=%@&nickname=%@",[YYAccountTool account].userUID, nickName];
    
    setNickNameUrlStr = [setNickNameUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.manager GET:setNickNameUrlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        YYLog(@"修改昵称请求成功%@",responseObject);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            YYLog(@"修改成功");
            [MBProgressHUD showSuccess:@"修改成功"];
            YYAccount *account = [YYAccountTool account];
            
            account.userNickName = self.textField.text;
            
            [YYAccountTool saveAccount:account];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:YYSetUserName object:nil];
            [self.navigationController popViewControllerAnimated:YES];

        }
        else if ([responseObject[@"msg"] isEqualToString:@"error"]){
            [MBProgressHUD showError:@"修改失败"];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        YYLog(@"修改昵称请求失败%@",error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
