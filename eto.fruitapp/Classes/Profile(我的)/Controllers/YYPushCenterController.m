//
//  YYPushCenterController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/3.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYPushCenterController.h"
#import "YYNoticeCenterTableViewController.h"


@interface YYPushCenterController ()
@property (nonatomic, weak) UIButton *messageBtn;
@property (nonatomic, weak) UIButton *notificationBtn;
@end

@implementation YYPushCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知中心";
    self.view.backgroundColor = YYViewBGColor;
    
    //添加通知消息View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 100)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    //添加消息15,15,20,16
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 20, 16)];
    headerView.image = [UIImage imageNamed:@"profile_message"];
    [view addSubview:headerView];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 40, 50)];
    [view addSubview:messageLabel];
    messageLabel.text = @"消息";
    //添加右边的数字label
    
    [[YYFruitTool shareFruitTool] addLineViewWithFrame:CGRectMake(15, 50, widthScreen -30, 0.5) andView:self.view];
    //添加通知
    UIImageView *headerView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 64, 20, 20)];
    headerView1.image = [UIImage imageNamed:@"profile_push"];
    [view addSubview:headerView1];
    
    UILabel *messageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 50, 40, 50)];
    [view addSubview:messageLabel1];
    messageLabel1.text = @"通知";

    //消息按钮
    UIButton *btn0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 49)];
    [self.view addSubview:btn0];
    btn0.backgroundColor = [UIColor clearColor];
    self.messageBtn = btn0;
    [self.messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //通知按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 51, widthScreen, 49)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor clearColor];
    self.notificationBtn = btn;
    [self.notificationBtn addTarget:self action:@selector(notificationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)messageBtnClick{
    
    YYNoticeCenterTableViewController *Notification = [[YYNoticeCenterTableViewController alloc] initWithCategory:1];
    [self.navigationController pushViewController:Notification animated:YES];
}

- (void)notificationBtnClick{
    YYNoticeCenterTableViewController *Notification = [[YYNoticeCenterTableViewController alloc] initWithCategory:1];
    [self.navigationController pushViewController:Notification animated:YES];
}
@end

