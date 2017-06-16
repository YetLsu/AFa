//
//  YYOrderPayController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/19.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYOrderMessageController.h"
#import "YYShopOrderModel.h"
#import "YYOnlinePayController.h"
#import "YYShopViewController.h"

typedef enum{
    YYLineTypeTop,
    YYLineTypeBottom
}YYLineType;

@interface YYOrderMessageController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton *bottomBtn;
//传下来的数据
@property (nonatomic, strong) YYShopOrderModel *model;
@property (nonatomic, strong) NSArray *priceArray;
@end

@implementation YYOrderMessageController

- (instancetype)initWithModel:(YYShopOrderModel *)model andPriceArray:(NSArray *)priceArray{
    if (self = [super init]) {
        self.model = model;
        self.priceArray = priceArray;
        
        self.view.backgroundColor = YYGrayColor;
        //添加tableview
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 667) style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        self.tableView = tableView;
        self.tableView.backgroundColor = YYGrayColor;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //设置没分割线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        添加底部按钮
        [self addBottomBtn];
        
        //设置上面右边的电话按钮
        UIImage *image = [UIImage imageNamed:@"order_call"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(callBtnClick)];
       
        
    }
    return self;
}
#pragma mark 电话按钮被点击
- (void)callBtnClick{
    
}
/**
 *  添加底部按钮
 */
- (void)addBottomBtn{
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 626, widthScreen, 41)];
    [self.view addSubview:bottomBtn];
    self.bottomBtn = bottomBtn;
    [self.bottomBtn setBackgroundColor:YYGreenBGColor];
    [self.bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if (self.model.isOld) {//表示订单过期
        [self.bottomBtn setTitle:@"订单过期关闭" forState:UIControlStateNormal];
        self.bottomBtn.enabled = NO;
    }else{
        [self.bottomBtn setTitle:@"去支付" forState:UIControlStateNormal];
    }
    [self.bottomBtn addTarget:self action:@selector(gotoPay) forControlEvents:UIControlEventTouchUpInside];
}
//去支付
- (void)gotoPay{
    YYOnlinePayController *onlineController = [[YYOnlinePayController alloc] initWithAllPrice:88.00 andShopName:self.model.shopName];
    [self.navigationController pushViewController:onlineController animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark tableView的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return 2;
    }
    return self.priceArray.count+4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    if (indexPath.section == 0) {//第0组单元格
        if (indexPath.row == 0) {
            cell.textLabel.text = @"等待支付";
            cell.textLabel.textColor = YYOrangeColor;
            
            cell.detailTextLabel.text = @"预期为支付订单将自动取消";
            cell.detailTextLabel.textColor = YYGrayTextColor;
            
            UIButton *cancelOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(275, 18, 85, 25)];
            [cancelOrderBtn setBackgroundImage:[UIImage imageNamed:@"order_btnBGOrange"] forState:UIControlStateNormal];
            [cell.contentView addSubview:cancelOrderBtn];
            [cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cancelOrderBtn setTitleColor:YYOrangeColor forState:UIControlStateNormal];
            cancelOrderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        else{
            [self threeStateWithCell:cell];
        }
    }
    else if (indexPath.section == 2){//第二组单元格
        if (indexPath.row == 0) {
            cell.textLabel.text = @"配送信息";
        }
        else if (indexPath.row == 1){
            cell.textLabel.text = @"本订单由老王水果店提供配送, 配送费¥0";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            [self addLineViewWithFrame:CGRectMake(16, 0, 290, 1) andCell:cell];

        }
    }
    else if (indexPath.section == 1){//第一组单元格
        if (indexPath.row == 0) {
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 50, 40)];
            iconView.image = [UIImage imageNamed:@"010"];
            [cell.contentView addSubview:iconView];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 16, 150, 20)];
            nameLabel.text = self.model.shopName;
            [cell.contentView addSubview:nameLabel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 1){
            [self blankCellWithCell:cell Line:YYLineTypeTop];
        }
        else if (indexPath.row == self.priceArray.count + 2){
            [self blankCellWithCell:cell Line:YYLineTypeBottom];
        }
        else if (indexPath.row == self.priceArray.count + 3){//再买点按钮的cell
            [self nextBuyWithCell:cell];
        }
        else{
            cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            [self priceWithCell:cell andIndexPath:indexPath];
            }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
#pragma mark设置再买点按钮
- (void)nextBuyWithCell:(UITableViewCell *)cell{
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(22, 6, 90, 30)];
    [nextBtn setTitle:@"再买点" forState:UIControlStateNormal];
    [nextBtn setTitleColor:YYGreenColor forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"order_btnBGGreen"] forState:UIControlStateNormal];
    [cell.contentView addSubview:nextBtn];
    
    UILabel *allPrice = [[UILabel alloc]initWithFrame:CGRectMake(255, 10, 110, 20)];
    allPrice.text = @"合计 ¥88.00";
    [cell.contentView addSubview:allPrice];
    allPrice.textColor = YYOrangeColor;
}
#pragma mark设置水果名称重量价格
- (void)priceWithCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{

    
    NSArray *array = self.priceArray[indexPath.row - 2];
    
    cell.textLabel.text = array[0];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
//    cell.textLabel.textColor = YYGrayTextColor;
    cell.detailTextLabel.text = array[1];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 60, 20)];
    [cell.contentView addSubview:middleLabel];
    middleLabel.text = array[2];
//    middleLabel.textColor = YYGrayTextColor;
    middleLabel.font = [UIFont systemFontOfSize:15];

}
#pragma mark 添加线条
- (void)addLineViewWithFrame:(CGRect)frame andCell:(UITableViewCell *)cell{
    UIView *view = [[UIView alloc] init];
    [cell.contentView addSubview:view];
    view.frame = frame;
    view.backgroundColor = YYGrayLineColor;
}

#pragma mark设置空白cell
- (void)blankCellWithCell:(UITableViewCell *)cell Line:(YYLineType)lineType{
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 11)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:whiteView];
    
    if (lineType == YYLineTypeTop) {
        [self addLineViewWithFrame:CGRectMake(16, 0, widthScreen - 32, 1) andCell:cell];
    }else{
        [self addLineViewWithFrame:CGRectMake(16, 10, widthScreen - 32, 1) andCell:cell];
    }
}

#pragma mark 设置各个单元格
/**
 *  第一组单元格三个状态的单元格
 */
/**
 *  YYOrderStateNeedPay,//需要支付
 YYOrderStateCancel,//订单过期
 YYOrderStateFinishPay,//完成支付,等待收货
 YYORderStateFinishOrder,//完成订单
 YYOrderStateWaitSaller //等待商家配送
 *
 */
- (void)threeStateWithCell:(UITableViewCell *)cell {
    [self addLineViewWithFrame:CGRectMake(16, 0, widthScreen - 32, 1) andCell:cell];
    
   YYOrderState orderState = self.model.orderState;
    NSArray *array;
    //不同状态的按钮
    UIButton *btn1 = [[UIButton alloc] init];
    [self addBtnWithCell:cell andBtn:btn1 andImage:[UIImage imageNamed:@"order_1"] andTitleColor:YYGrayTextColor  andTitle:@"等待支付"];
    
    UIButton *btn3 = [[UIButton alloc] init];
    [self addBtnWithCell:cell andBtn:btn3 andImage:[UIImage imageNamed:@"order_3"] andTitleColor:YYGreenColor andTitle:@"订单提交"];
    
    UIButton *btn4 = [[UIButton alloc] init];
    [self addBtnWithCell:cell andBtn:btn4 andImage:[UIImage imageNamed:@"order_4"] andTitleColor:YYGrayTextColor andTitle:@"等待接单"];
    
    UIButton *btn5 = [[UIButton alloc] init];
    [self addBtnWithCell:cell andBtn:btn5 andImage:[UIImage imageNamed:@"order_5"] andTitleColor:YYGrayTextColor  andTitle:@"等待送达"];
    
    UIButton *btn7 = [[UIButton alloc] init];
    [self addBtnWithCell:cell andBtn:btn7 andImage:[UIImage imageNamed:@"order_7"] andTitleColor:YYGreenColor andTitle:@"订单取消"];
    
    UIButton *btn9 = [[UIButton alloc] init];
    [self addBtnWithCell:cell andBtn:btn9 andImage:[UIImage imageNamed:@"order_9"] andTitleColor:YYGreenColor andTitle:@"商家接单"];
    
    UIButton *btn10 = [[UIButton alloc] init];
    [self addBtnWithCell:cell andBtn:btn10 andImage:[UIImage imageNamed:@"order_10"] andTitleColor:YYGreenColor andTitle:@"完成接单"];


    
    switch (orderState) {
        case YYOrderStateNeedPay:{//等待支付
            array = @[btn1, btn4, btn5];
            break;
        }
        case YYOrderStateCancel:{//订单取消
           array = @[btn3, btn7];
            break;
        }
        case YYOrderStateFinishPay:{//完成支付,等待商家接单
            array = @[btn3, btn4, btn5];
            break;
        }
        case YYORderStateFinishOrder:{//完成订单
            array = @[btn3, btn9, btn10];
            break;
        }
        case YYOrderStateWaitSaller:{//商家接单，等待商家配送
            array = @[btn3, btn9, btn10];
            break;
        }
        default:
            break;
    }
    //增加三个按钮
   
    [self setBtnFrameWithbtnArray:array andCell:cell];
    //增加两条横线
//    [self addLineViewWithFrame:CGRectMake(140, 29, 23, 1) andCell:cell];
//    [self addLineViewWithFrame:CGRectMake(223, 29, 23, 1) andCell:cell];
    
}

#pragma mark 添加不同状态的按钮到cell  订单状态
- (void)addBtnWithCell:(UITableViewCell *)cell andBtn:(UIButton *)btn andImage:(UIImage *)image andTitleColor:(UIColor *)titleColor andTitle:(NSString *)title {
    [cell.contentView addSubview:btn];
    
    [btn setTitle:title forState:UIControlStateNormal];
     btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    [btn setImage:image forState:UIControlStateNormal];
     btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 20, 0);
     btn.titleEdgeInsets = UIEdgeInsetsMake(30, -30, 0, 0);
}
#pragma mark 根据传入的按钮数组，以及按钮的frame 按钮宽为50高为55
- (void)setBtnFrameWithbtnArray:(NSArray *)btnArrays andCell:(UITableViewCell *)cell{
    CGFloat btnW = (50 / 375.0) * widthScreen;
    CGFloat btnH = (55 / 667.0) *heightScreen;
    CGFloat btnMargin = btnW * 0.5;
    CGFloat headerFootMargin = (widthScreen - btnArrays.count * btnW - (btnArrays.count - 1) * btnMargin) / 2;
    
    CGFloat btnY = 10;
    CGFloat btnX = 0;
    
    CGFloat lineX = 0;
    CGFloat lineW = 20;
    CGFloat lineY = 27.5;
    
    for (int i = 0; i < btnArrays.count; i++) {
        UIButton *btn = btnArrays[i];
        btnX = headerFootMargin + i * (btnW + btnMargin);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        if (i !=0 ) {//加横线
            lineX = headerFootMargin + i * btnW + (25/375.0) * widthScreen * (i- 1) + (2.5 /375) * widthScreen;
            [self addLineViewWithFrame:CGRectMake(lineX, lineY, lineW, 1) andCell:cell];
        }

    }
    
    
}




#pragma mark 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
       
        return 75;
    }
    else if (indexPath.section == 2){
        return 45;
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) return 66;
        
        else if (indexPath.row == self.priceArray.count + 3) return 50;
            
        else if (indexPath.row == 1 || indexPath.row == self.priceArray.count + 2) return 10;
        else return 20;
    }
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 6;
}
#pragma mark当某行被选中时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        YYShopViewController *shop = [[YYShopViewController alloc] initWithShopName:self.model.shopName];
        [self.navigationController pushViewController:shop animated:YES];
    }
}
@end
