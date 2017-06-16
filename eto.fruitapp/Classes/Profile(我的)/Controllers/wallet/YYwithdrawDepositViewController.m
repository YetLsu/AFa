//
//  YYwithdrawDepositViewController.m
//  eto.fruitapp
//
//  Created by wyy on 15/10/30.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYwithdrawDepositViewController.h"
#import "YYSubmitMoneyViewController.h"

@interface YYwithdrawDepositViewController ()<UIAlertViewDelegate>
- (IBAction)submitClick;//提交
@property (weak, nonatomic) IBOutlet UILabel *money;

@end

@implementation YYwithdrawDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.money.textColor = YYYellowTextColor;
    self.money.text = [NSString stringWithFormat:@"%.2f元",15.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"提现";
    [super viewWillAppear:animated];
}
/**
 *  提交
 */
- (IBAction)submitClick {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认提现1元" message:@"提现至您最近用于支付或充值的资金帐户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        YYSubmitMoneyViewController *submitVc = [[YYSubmitMoneyViewController alloc] init];
        [self.navigationController pushViewController:submitVc animated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
