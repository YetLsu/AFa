//
//  YYSureOrderController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/18.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYSureOrderController.h"
#import "YYOrderCell.h"
#import "YYOrderMOdel.h"
#import "YYAddRemarksController.h"
#import "YYFruitModel.h"
#import "YYOnlinePayController.h"


typedef enum{
    YYLineTypeTop,
    YYLineTypeBottom
}YYLineType;


@interface YYSureOrderController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong) NSArray *priceArray;

@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, assign) CGFloat sumPrice;

@end

@implementation YYSureOrderController
- (instancetype)initWithArray:(NSArray *)priceArray andShopName:(NSString *)shopName{
    if (self = [super init]) {
        self.shopName = shopName;
        self.priceArray = priceArray;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(previousController)];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.title = @"确认订单";
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 627) style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //计算总价
        [self calculateSumPrice];
        [self addButtomView];
    }
    return self;
}
/**
 *  点击左侧的返回
 */
- (void)previousController{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  计算总价
 */
- (void)calculateSumPrice{
    self.sumPrice = 0;
    for (YYFruitModel *model in self.priceArray) {
        self.sumPrice += model.selectNumber * model.fruitPreice.floatValue;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)addButtomView{
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, 627, 375, 40)];
    [self.view addSubview:buttomView];
    //添加总计label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 275, 40)];
    label.text = [NSString stringWithFormat:@"   总计¥%.2f",self.sumPrice];
    
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:22];
    
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [buttomView addSubview:label];
    
    //添加立即购买按钮
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(275, 0, 100, 40)];
    [buyBtn setTitle:@"确认下单" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor = YYGreenColor;
    [buttomView addSubview:buyBtn];
    //监听确认下单按钮
    [buyBtn addTarget:self action:@selector(sureBuyFruitClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark点击确认下单按钮 
- (void)sureBuyFruitClick{
    YYOnlinePayController *onlinePay = [[YYOnlinePayController alloc] initWithAllPrice:self.sumPrice andShopName:self.shopName];
    [self.navigationController pushViewController:onlinePay animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
//返回每组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 ) {
        return 1;
    }else if (section == 3) return self.priceArray.count + 3;
    
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    
    if (indexPath.section == 0) {
        cell = [self cellWithPlaceholder:@"请填写配送地址" andImage:[UIImage imageNamed:@"sort_address_green"]];
        
        //添加分割线
        [self addLineViewWithFrame:CGRectMake(0, 0, widthScreen, 1) andCell:cell];
        [self addLineViewWithFrame:CGRectMake(0, 44, widthScreen, 1) andCell:cell];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 1){
    
        if (indexPath.row == 0) cell = [self twoSectionWithtext:@"送达时间" andTitle:@"极速送达"];
        else cell = [self twoSectionWithtext:@"鲜果备注" andTitle:@"点击添加备注"];
        
        //添加分割线
        [self addLineViewWithFrame:CGRectMake(0, 0, widthScreen, 1) andCell:cell];
        [self addLineViewWithFrame:CGRectMake(0, 44, widthScreen, 1) andCell:cell];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 2){
        
        if (indexPath.row == 0) cell = [self cellRightBtnWithText:@"在线支付"];
        else cell = [self cellRightBtnWithText:@"货到付款"];
        
        //添加分割线
        [self addLineViewWithFrame:CGRectMake(0, 0, widthScreen, 1) andCell:cell];
        [self addLineViewWithFrame:CGRectMake(0, 44, widthScreen, 1) andCell:cell];
        
    } else if (indexPath.section == 3){
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0) {
            cell = [self cellWithLine:YYLineTypeTop];
        } else if (indexPath.row == self.priceArray.count + 1){
            cell = [self cellWithLine:YYLineTypeBottom];
        } else if (indexPath.row == self.priceArray.count + 2){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            cell.textLabel.text = @"配送费";
            cell.textLabel.textColor = YYOrangeColor;
            
            cell.detailTextLabel.text = @"本订单由老王水果店提供配送";
            cell.detailTextLabel.textColor = YYGrayTextColor;
            
            UILabel *takePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 5, 40, 30)];
            [cell.contentView addSubview:takePriceLabel];
            takePriceLabel.textAlignment = NSTextAlignmentRight;
            
            takePriceLabel.text = @"¥20";
            takePriceLabel.textColor = YYOrangeColor;
            
        } else{
            YYFruitModel *model = self.priceArray[indexPath.row - 1];
            cell.textLabel.text = model.fruitName;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = YYGrayTextColor;
            cell.detailTextLabel.text = model.fruitPreice;
            
            UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 60, 20)];
            [cell.contentView addSubview:middleLabel];
            middleLabel.text = [NSString stringWithFormat:@"%ld斤",model.selectNumber];
            middleLabel.textColor = YYGrayTextColor;
            middleLabel.font = [UIFont systemFontOfSize:15];
            
        }
    }
    
    return cell;
    
}
//第一组时创建一个cell
- (UITableViewCell *)twoSectionWithtext:(NSString *)text andTitle:(NSString *)title{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = text;
    //添加上面和下面的分割线
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 245, 44)];
    label.text = title;
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = YYGrayLineColor;
    
    [cell.contentView addSubview:label];
    return cell;
}
/**
 *  添加线条
 */
- (void)addLineViewWithFrame:(CGRect)frame andCell:(UITableViewCell *)cell{
    UIView *view = [[UIView alloc] init];
    [cell.contentView addSubview:view];
    view.frame = frame;
    view.backgroundColor = YYGrayLineColor;
}
//第零组时创建一个左侧带图标的textField
- (UITableViewCell *)cellWithPlaceholder:(NSString *)placeholder andImage:(UIImage *)icon{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 375, 44)];
    field.placeholder = placeholder;
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = icon;
    iconView.height = 44;
    iconView.width = 44;
    iconView.contentMode = UIViewContentModeCenter;
    
    field.leftView = iconView;
    field.leftViewMode = UITextFieldViewModeAlways;
    
    [cell.contentView addSubview:field];
    
    return cell;
}
//第二组创建右边有按钮的Cell
- (UITableViewCell *)cellRightBtnWithText:(NSString *)text{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = text;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(315, 2, 40,40)];
    btn.imageView.contentMode = UIViewContentModeCenter;
    [cell.contentView addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"address0"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"address"] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:@"address"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnCircleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
//第三组的空白cell创建
- (UITableViewCell *)cellWithLine:(YYLineType)lineType{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 11)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:whiteView];
    
    if (lineType == YYLineTypeTop) {
        [self addLineViewWithFrame:CGRectMake(0, 0, widthScreen, 1) andCell:cell];
    }else{
        [self addLineViewWithFrame:CGRectMake(16, 10, widthScreen - 32, 1) andCell:cell];
    }
    return cell;
}


//右侧小图标被点击
- (void)btnCircleClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}
/**
 *  设置每个单元格的行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 3){
        if (indexPath.row == 0 ||indexPath.row == self.priceArray.count + 1) {
            return 10;
        }else if (indexPath.row == self.priceArray.count + 2){
            return 55;
        }
        else return 20;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 30;
    }
    return 10;
}

#pragma mark选中tableView的某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"期望送达时间" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"立即送出" otherButtonTitles:@"1小时后送出", nil];
            [actionsheet showInView:self.view];
        }
        else if(indexPath.row == 1){
            YYAddRemarksController *addController = [[YYAddRemarksController alloc] init];
            [self.navigationController pushViewController:addController animated:YES];
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
}
/**
 *  设置组标题
 */
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return @"已购买的水果";
    }
    return nil;
}
@end

