//
//  YYSetPassWordController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/2.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYSetPassWordController.h"
#import "YYAccountTool.h"



@interface YYSetPassWordController ()
@property (nonatomic, weak) UITextField *firstField;
@property (nonatomic, weak) UITextField *secondField;
@property (nonatomic, weak) UITextField *securityCodeField;
@property (nonatomic, weak) UILabel *securityCodeLabel;

/**
 *  tag表示哪个控制器,0修改密码，1修改手机号
 */
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;
@end

@implementation YYSetPassWordController
- (AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}
- (instancetype)initWithTag:(NSInteger)tag{
    if (self = [super init]) {
        self.tag = tag;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YYViewBGColor;
    
    
    if (self.tag == 0) {//修改密码
        self.title = @"修改密码";
        //增加输入原密码textField
        self.firstField = [self createMyTextFieldWithFrame:CGRectMake(0, 10, widthScreen, 42) withPlaceholder:@"请输入原密码"];
        //中间增加一条线
        [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(20, 41.5, widthScreen - 40, 0.5) andView:self.firstField];

        //增加输入新密码textField
        self.secondField = [self createMyTextFieldWithFrame:CGRectMake(0, 52, widthScreen, 42) withPlaceholder:@"请输入新密码"];
        
        //增加确认按钮
        [self addSureBtnWithbtnFrame:CGRectMake(20, 112, widthScreen - 40, 42) WithTitle:@"确认"];
    }
    else if (self.tag == 1){//修改手机号
        self.title = @"更换绑定手机";
        [self addLabelWithFrame:CGRectMake(0, 10, widthScreen, 42)];
        //添加输入验证码textField
        self.securityCodeField = [self createMyTextFieldWithFrame:CGRectMake(0, 52, widthScreen, 42) withPlaceholder:@"请输入验证码"];
        
        //预留输错密码的提示label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 97, widthScreen - 20, 20)];
        label.text = @"验证码输入错误";
        label.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:label];
        self.securityCodeLabel = label;
        self.securityCodeLabel.textColor = YYYellowTextColor;
        //加载时先设置为隐藏
//        self.securityCodeLabel.hidden = YES;
        
        //添加验证后绑定新手机按钮
        [self addSureBtnWithbtnFrame:CGRectMake(20, 122, widthScreen - 40, 42) WithTitle:@"验证后绑定新手机"];
    }
    
}
/**
 * 第一行添加带发送验证码按钮和电话label的view；
 *
 */
- (void)addLabelWithFrame:(CGRect)labelFrame{
 
//    添加UI view用来放label
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, widthScreen, 42)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    //创建带发送验证码按钮的label；
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, widthScreen, 42)];
  
    [view addSubview:label];
    label.text = [YYAccountTool account].userPhone;
    
    //添加右边的发送验证码
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(widthScreen - 100 - 20, 6, 100, 30)];
    [view addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_yellowbg"] forState:UIControlStateNormal];
    [btn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendSecurityCode) forControlEvents:UIControlEventTouchUpInside];
    //添加一条横线
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(20, 41.5, widthScreen - 40, 0.5) andView:view];


}
/**
 *  发送验证码
 *
 */
- (void)sendSecurityCode{
    YYLog(@"发送验证码");
}
/**
 *  添加确认按钮或验证后绑定新手机按钮
 */
- (void)addSureBtnWithbtnFrame:(CGRect)btnFrame WithTitle:(NSString *)title{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [self.view addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_yellowbg"] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  点击确认按钮你
 *
 */
- (void)sureClick{
    if (self.tag == 0) {//0修改密码
        YYLog(@"修改密码");
        NSString *setPassWordUrl = [NSString stringWithFormat:@"http://www.sxeto.com/fruitApp/Buyer.php?mode=43&buid=%@&oldpassword=%@&newpassword=%@",[YYAccountTool account].userUID, self.firstField.text, self.secondField.text];
        
        [self.manager GET:setPassWordUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary * responseObject) {
            YYLog(@"改密码请求成功%@",responseObject);
            if([responseObject[@"msg"] isEqualToString:@"ok"]){//成功修改密码
                [MBProgressHUD showSuccess:@"成功修改密码"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [MBProgressHUD showError:@"原密码错误"];
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            YYLog(@"改密码请求失败%@",error);
        }];
    }
    else{//1修改手机号
        YYLog(@"修改手机号");
    }
}

/**
 *  增加textField
 *
 */
- (UITextField *)createMyTextFieldWithFrame:(CGRect)fieldFrame withPlaceholder:(NSString *)placeholder{
    UITextField *textField = [[UITextField alloc] initWithFrame:fieldFrame];
    [self.view addSubview:textField];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = placeholder;
    UIView *leftView = [[UIView alloc] init];
    leftView.width = 20;
    leftView.height = 42;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    
    return textField;
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
