//
//  YYSubmitMoneyViewController.m
//  eto.fruitapp
//
//  Created by wyy on 15/10/30.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYSubmitMoneyViewController.h"

@interface YYSubmitMoneyViewController ()
- (IBAction)finishedClick;//完成

@end

@implementation YYSubmitMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
 *  完成
 */
- (IBAction)finishedClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
