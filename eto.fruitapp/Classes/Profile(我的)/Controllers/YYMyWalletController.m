//
//  YYMyWalletController.m
//  eto.fruitapp
//
//  Created by wyy on 15/12/4.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYMyWalletController.h"
#import "YYwithdrawDepositViewController.h"
#import "YYWalletCell.h"
#import "YYWalletModel.h"

@interface YYMyWalletController ()
@property (nonatomic, assign) CGFloat money;

@property (nonatomic, strong) NSArray *billArrays;//账单数组
@property (nonatomic, weak) UIView *noBillView;//没有账单时显示的view
@end

@implementation YYMyWalletController
/**
 * 没有账单时显示的view
 */
- (UIView *)noBillView{
    if (!_noBillView) {
        CGFloat x = (widthScreen - 85)/ 2.0;
        UIView *noBillView = [[UIView alloc] initWithFrame:CGRectMake(x, (390 - 64)/667.0 *heightScreen, 85, 105)];
        [self.view addSubview:noBillView];
        _noBillView = noBillView;
        
        //增加图片进view
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 85, 65)];
        [_noBillView addSubview:imageview];
        imageview.image = [UIImage imageNamed:@"007"];
        
        //增加label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 85, 20)];
        label.text = @"暂无交易记录";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = YYGrayTextColor;
        [_noBillView addSubview:label];
        
    }
    return _noBillView;
}
- (instancetype)init{
    return self = [super initWithStyle:UITableViewStyleGrouped];
}

- (NSArray *)billArrays{
    if (!_billArrays) {
        
        YYWalletModel *model = [[YYWalletModel alloc] initWithBuyExpense:@"消费" andRemainingSum:@"余额：0" anddata:@"2015-7-17" andMoney:@"11" andIncome:YES];
        
        _billArrays = @[model,model, model];
        
    }
    return _billArrays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   // 把tableview的headerView设置为钱包信息的view
    self.tableView.tableHeaderView = [self headerViewWithFrame:CGRectMake(0, 0, widthScreen, 130 / 667.0 * heightScreen + 30)];
    
    //如果账单数组没值加载暂无交易记录的view
    if (self.billArrays.count == 0) {
        self.noBillView.hidden = NO;
    }else{
        self.noBillView.hidden = YES;
    }
    
    
}

- (UIView *)headerViewWithFrame:(CGRect)headerFrame{
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat margin = 15/375.0 * widthScreen;
    //增加帐户余额label
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 35/667.0 *heightScreen, 120, 23)];
    [headerView addSubview:accountLabel];
    accountLabel.textColor = YYYellowTextColor;
    accountLabel.text = @"帐户余额（元）";
    
    //增加帐户余额的钱label
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 63 / 667.0 *heightScreen, 200, 35)];
    moneyLabel.textColor = YYYellowTextColor;
    moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.money];
    moneyLabel.font = [UIFont systemFontOfSize:30];
    [headerView addSubview:moneyLabel];
    
    //增加提现按钮
    UIButton *getMoney = [[UIButton alloc] initWithFrame:CGRectMake(widthScreen - 76 - margin, 50/667.0 * heightScreen, 76, 33)];
    [headerView addSubview:getMoney];
    [getMoney setTitle:@"提现" forState:UIControlStateNormal];
    [getMoney setTitleColor:YYYellowTextColor forState:UIControlStateNormal];
    [getMoney addTarget:self action:@selector(getMoneyClick) forControlEvents:UIControlEventTouchUpInside];
    
    //增加最近余额明细label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 130 / 667.0 * heightScreen, widthScreen, 30)];
    [headerView addSubview:label];
    label.backgroundColor = YYViewBGColor;
    label.text = @"    最近余额明细";
    label.textColor = YYGrayTextColor;
    label.font = [UIFont systemFontOfSize:15];
    
    
    return headerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMoneyClick{
    YYwithdrawDepositViewController *withDraw = [[YYwithdrawDepositViewController alloc] init];
    [self.navigationController pushViewController:withDraw animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.billArrays.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYWalletCell *cell = [YYWalletCell walletCellWithTableView:tableView];
    
    YYWalletModel *model = self.billArrays[indexPath.row];
    
    cell.model = model;

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}




@end
