//
//  YYOnlinePayController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/18.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYOnlinePayController.h"
#import "YYShopOrderModel.h"
#import "YYTabBarController.h"
#import "YYOrderViewController.h"

#import "Order.h"
#import "DataSigner.h"

#import "AppDelegate.h"

@interface YYOnlinePayController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (nonatomic, copy) NSString *orderString;
@property (nonatomic, strong) YYShopOrderModel *model;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic,assign) CGFloat allprice;
@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, strong)UIButton *zhifubaoBtn;
@property (nonatomic, strong)UIButton *wechatBtn;
@property (nonatomic, strong)UIButton *cardBtn;
@end

@implementation YYOnlinePayController
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
/**
 *  自定义方法创建在线支付控制器
 */
- (instancetype)initWithAllPrice:(CGFloat)allprice andShopName:(NSString *)shopName{
    if (self = [super init]) {
        self.allprice = allprice;
        self.shopName = shopName;
        
        self.title = @"在线支付";
        self.view.backgroundColor = YYGrayColor;
        
        [self addTableView];
        
        [self addSurePayBtn];
    }
    return self;
}
/**
 *  添加确认支付按钮
 */
- (void)addSurePayBtn{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 480, 345, 40)];
    [btn setTitle:@"确认支付" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"003"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(surePayClick) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  确认支付被点击
 */
- (void)surePayClick{
    //支付宝支付
    if (self.zhifubaoBtn.selected) {
        [self aliPay];
    }
    else if (self.wechatBtn.selected){
        [self wechatPay];
    }
    else if (self.cardBtn.selected){
        
    }
}
/**
 *  微信支付
 */
- (void)wechatPay{
    AppDelegate *delegate = [[AppDelegate alloc] init];
    [delegate sendPay_demo];
}
/**
 *  支付宝支付
 */
- (void)aliPay{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088121008794792";
    NSString *seller = @"2811432473@qq.com";
    NSString *privateKey = @"MIICXAIBAAKBgQDAs0eO6IBKBxkhxsFsKk2v2TqUKzBGQMO2VxV9RSWJNHdUzEPeQ4YWJwn+Ywq9ax7b5CsXaEBoA7APVDhWlG/Jve+kOe2eZddpJGiMFH51W8Qabg76BkvB76KxN2oWBT4oLuhS3mdI865f4BozHxTMWW67ZCbzrdaavovZiAjnMwIDAQABAoGAeFtBdYPIJPR8APmn84wUi6GtEcBL3YUz+B46IMzgXer0IXWXaipYhFuLxWRM3/QZCRRgybTmjVDIVTqwGXuKuaop6SNlfU8lg06vhtjF+MeMqxTQA0cLUAX7N26n7gET3uwET4uJpjDIsJb5lnucoLp6NXB1EpupnWsfkgvfZ3kCQQD7HnbrcKYt+9Dn0nTaKYXT0/ogZZzF0iBSt0zqR4F0djIXWB7EGeioPsRDp+TW4/QC3aeCzSUw3UBSWiTZysnlAkEAxHIhlZ5eU0VOJiqSoeBMkGc8/oipMGX5Y0LgzYx4lAvpjzpsuoAZSfXzSJPeacsjbkUtmwa4XN0tida52zT7NwJAFrjY9dDJmJuSeYd3f04Gh/ZESa4oE1ZCCnn/gatasVkIi0gz8HaPsLmNNLn6YN9bcu7ve0xosxUx/sGdV/+baQJBAItpq+fwwmQ6NSHk6Lc05WE9ww2oktmkJP6KwdteK1x1r8VT40HgExJoF8WUGy3dWkGxmpIAjOpqlRzTZIbq7LUCQGAQyDf+qeuZIGAVpwqMe7EAy0aNbWFWbOaMDztnkSU1K9lf/fCRpjAyqkllyQ2/W2N4P/leY3OmMWUP4iMG3pg=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"苹果"; //商品标题
    order.productDescription = @"qqq"; //商品描述
    order.amount = @"0.01"; //商品价格
    order.notifyURL =  @"http://www.sxeto.com/fruitApp/alipay/notify_url.php"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"eto.fruitapp";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    YYLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    
    //把该次订单的信息保存到模型
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *dateStr = [dateFormatter stringFromDate:date];
    YYShopOrderModel *model = [[YYShopOrderModel alloc] initWithOrderState:0 shopImage:[UIImage imageNamed:@"sort_cherry"] shopName:@"" orderDate:dateStr number:2 price:0.01 old:NO];
    self.model = model;
    
    
    
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        self.orderString = orderString;
        //返回支付结果
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            YYLog(@"reslut = %@",resultDic);
            NSString *resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"6001"]) {
                YYLog(@"等待支付");
                model.orderState = YYOrderStateNeedPay;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"放弃支付" message:@"是否放弃支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"继续支付", nil];
                [alertView show];
                
                //把新的订单保存到本地
                [[YYFruitTool shareFruitTool] saveOrdersToDocumentsAddOrder:model];
                [YYFruitTool shareFruitTool].upDate = YES;
                
                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                YYOrderViewController *orderController = delegate.tabbarController.orderController;
                [orderController.tableView reloadData];
            }
            else if ([resultStatus isEqualToString:@"9000"]){
                YYLog(@"支付成功");
                model.orderState = YYOrderStateFinishPay;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"完成支付" message:@"已经完成支付，请等待卖家接单" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                
                //把新的订单保存到本地
                [[YYFruitTool shareFruitTool] saveOrdersToDocumentsAddOrder:model];
                [YYFruitTool shareFruitTool].upDate = YES;
                
                AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                YYOrderViewController *orderController = delegate.tabbarController.orderController;
                [orderController.tableView reloadData];
            }
        }];
        
    }

}
//支付宝继续支付
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[AlipaySDK defaultService] payOrder:self.orderString fromScheme: @"eto.fruitapp" callback:^(NSDictionary *resultDic) {
            YYLog(@"reslut = %@",resultDic);
            NSString *resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"6001"]) {
                YYLog(@"等待支付");
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"放弃支付" message:@"是否放弃支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"继续支付", nil];
                [alertView show];
        
                
            }
            else if ([resultStatus isEqualToString:@"9000"]){
                YYLog(@"支付成功");
                self.model.orderState = YYOrderStateFinishPay;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"完成支付" message:@"已经完成支付，请等待卖家接单" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                [[YYFruitTool shareFruitTool] changeOrderToDocumentsAddOrder:self.model];
            }
        }];

    }
}
#pragma mark添加tableView
- (void)addTableView{
    //tableview高460
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 460) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundColor = YYGrayColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}
#pragma mark tableView的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 4;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:230/255.0 alpha:1.0];
        cell.textLabel.text = @"订单总价";
        cell.textLabel.textColor = YYOrangeColor;
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",self.allprice];
        cell.detailTextLabel.textColor = YYOrangeColor;
        
    }
    else if (indexPath.section == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"订单名称: %@",self.shopName];
    }
    else if (indexPath.section == 2){
        cell.textLabel.text = @"帐户余额";
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 0, 50, 44)];
        priceLabel.text = @"¥11";
        priceLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:priceLabel];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(330, 0, 45, 44)];
        [button setImage:[UIImage imageNamed:@"address0"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"address"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"address"] forState:UIControlStateHighlighted];
        button.imageView.contentMode = UIViewContentModeLeft;
        [cell.contentView addSubview:button];
        [button addTarget:self action:@selector(circleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"第三方支付平台";
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 100, 44)];
            [cell.contentView addSubview:label];
            label.text = [NSString stringWithFormat:@"¥%.2f",self.allprice];
            label.textColor = YYOrangeColor;
        }
        else if (indexPath.row == 1){
            self.zhifubaoBtn = [[UIButton alloc] init];
            self.zhifubaoBtn.tag = 201;
            [self cellWithCell:cell andIconImage:[UIImage imageNamed:@"sort_zhifubao"] andTitle:@"支付宝" andButton:self.zhifubaoBtn];
        }
        else if (indexPath.row == 2){
            
            self.wechatBtn = [[UIButton alloc] init];
            self.wechatBtn.tag = 202;
            [self cellWithCell:cell andIconImage:[UIImage imageNamed:@"sort_wechat"] andTitle:@"微信" andButton:self.wechatBtn];
        }
        else if (indexPath.row == 3){

            self.cardBtn = [[UIButton alloc] init];
            self.cardBtn.tag = 203;
            [self cellWithCell:cell andIconImage:[UIImage imageNamed:@"sort_cart"] andTitle:@"银行卡" andButton:self.cardBtn];
           
        }

    }
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
#pragma mark三个支付cell
- (void)cellWithCell:(UITableViewCell *)cell andIconImage:(UIImage *)icon andTitle:(NSString *)title andButton:(UIButton *)button{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 40)];
    imageView.image = icon;
    imageView.contentMode = UIViewContentModeCenter;
    [cell.contentView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 6, 100, 20)];
    nameLabel.text = title;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:nameLabel];
    
    UILabel *longLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 28, 220, 20)];
    longLabel.font = [UIFont systemFontOfSize:13];
    longLabel.text = [NSString stringWithFormat:@"推荐以安装%@客户端的用户使用",title];
    longLabel.textColor = YYGrayLineColor;
    [cell.contentView addSubview:longLabel];
    
    button.frame = CGRectMake(330, 0, 45, 44);
    [button setImage:[UIImage imageNamed:@"address0"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"address"] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"address"] forState:UIControlStateHighlighted];
    button.imageView.contentMode = UIViewContentModeLeft;
    
    [cell.contentView addSubview:button];
    [button addTarget:self action:@selector(circleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark小圆圈被点击
- (void)circleBtnClick:(UIButton *)sender{
    [self switchBtnTag:sender];
    
}
#pragma mark设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 35;
    }
    if (indexPath.section == 3) {
        if (indexPath.row != 0) {
            return 60;
        }
    }
    return 44;
}
#pragma mark设置组标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 14;
}
/**
 *  当选中某行时
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    for (UIView *btn in cell.contentView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [self switchBtnTag:(UIButton *)btn];
        }
    }
}
//点击支付方式时调用
- (void)switchBtnTag:(UIButton *)btn{
    switch (btn.tag) {
        case 201:
            self.wechatBtn.selected = NO;
            self.cardBtn.selected = NO;
            break;
        case 202:
            self.zhifubaoBtn.selected = NO;
            self.cardBtn.selected = NO;
            break;
        case 203:
            self.wechatBtn.selected = NO;
            self.zhifubaoBtn.selected = NO;
            break;
        default:
            break;
    }
    btn.selected = !btn.selected;

}
@end
