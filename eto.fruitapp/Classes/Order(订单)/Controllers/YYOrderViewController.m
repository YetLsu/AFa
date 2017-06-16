//
//  YYOrderViewController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/5.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYOrderViewController.h"
#import "YYShopOrderModel.h"
#import "YYShopOrderFrame.h"
#import "YYShopOrderCell.h"
#import "YYOnlinePayController.h"
#import "YYOrderMessageController.h"
#define YYOrderStatePath @"orderState.achieve"

@interface YYOrderViewController ()<YYShopOrderCellDelegate>

@property (nonatomic, strong) NSMutableArray *orderFrames;
@property (nonatomic, strong) NSMutableArray *orders;

@property (nonatomic, strong) NSArray *priceArray;
@end

@implementation YYOrderViewController

//增加本地推送按钮
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"5秒后提醒" style:UIBarButtonItemStylePlain target:self action:@selector(pushText)];
    
}
- (void)pushText{
        //请求用户允许推送
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    UILocalNotification *localNot = [[UILocalNotification alloc] init];
    
    localNot.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    localNot.alertBody = @"购买水果";
    
    localNot.soundName = UILocalNotificationDefaultSoundName;
    
    localNot.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNot];
}

- (NSArray *)priceArray{
    if (!_priceArray) {
        _priceArray = [NSArray array];
        NSArray *arr0 = @[@"苹果", @"1.5斤", @"¥33.00"];
        NSArray *arr1 = @[@"西瓜", @"1个", @"¥33.00"];
        NSArray *arr2 = @[@"橘子", @"2斤", @"¥22.00"];
        _priceArray = @[arr0, arr1, arr2];
        
    }
    return _priceArray;
}
/**
 *  cell的去支付被点击之后调用
 *
 */
- (void)gotoPayControllerWithModel:(YYShopOrderModel *)model{

    model.old = NO;
    YYOnlinePayController *onlinePay = [[YYOnlinePayController alloc] initWithAllPrice:0.01 andShopName:model.shopName];

    [self.navigationController pushViewController:onlinePay animated:YES];
 
}

//加载订单的模型frame
- (NSMutableArray *)orderFrames{
    BOOL upDate = [YYFruitTool shareFruitTool].isUpDate;
    
    if (!_orderFrames || upDate) {

        _orderFrames = [NSMutableArray array];
        
        self.orders = [[YYFruitTool shareFruitTool] ordersFromDocuments];
        
        for (int i =0; i < self.orders.count; i++) {
            YYShopOrderFrame *shopFrame = [[YYShopOrderFrame alloc] init];
            shopFrame.model = self.orders[i];
            [_orderFrames addObject:shopFrame];
        }
        
    }
    return _orderFrames;

}
//使tableview变为分组样式
- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
    
}

#pragma mark订单的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderFrames.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYShopOrderCell *cell = [YYShopOrderCell shopOrderCellWithTableView:tableView];
    cell.delegate = self;
    
    YYShopOrderFrame *shopFrame = self.orderFrames[indexPath.section];
    
    cell.orderFrame = shopFrame;
    
    return cell;
}
#pragma mark tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYShopOrderFrame *shopFrame = self.orderFrames[indexPath.section];
    return shopFrame.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYShopOrderFrame *orderFrame = self.orderFrames[indexPath.section];
    YYShopOrderModel *orderModel = orderFrame.model;
    YYOrderMessageController *orderController = [[YYOrderMessageController alloc] initWithModel:orderModel andPriceArray:self.priceArray];
    orderController.title = orderModel.shopName;
    [self.navigationController pushViewController:orderController animated:YES];
}
@end
