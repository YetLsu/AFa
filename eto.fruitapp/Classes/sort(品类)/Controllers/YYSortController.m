//
//  YYSortController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/5.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYSortController.h"
#import "YYSortThreeBtn.h"
#import "YYBuyShopModel.h"
#import "YYBuyShopCell.h"
#import "YYShopViewController.h"
#import "YYFastBuyController.h"

@interface YYSortController ()
@property (strong, nonatomic) NSMutableArray *arrayModels;
@end

@implementation YYSortController
- (instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:UITableViewStyleGrouped];

    return self;
}


- (NSMutableArray *)arrayModels{
    if (!_arrayModels) {
        _arrayModels = [NSMutableArray array];
        YYBuyShopModel *model = [[YYBuyShopModel alloc] init];
        model.name = @"老王水果店(鉴湖店)";
        model.sellCount = @"50单";
        model.startCarryPrice = @"14";
        model.carryPrice = @"15";
        model.time = @"平均40分钟";
        model.shopIcon = [UIImage imageNamed:@"010"];
        model.xingNum = 4;
        
        [_arrayModels addObject:model];
        [_arrayModels addObject:model];
        [_arrayModels addObject:model];
        [_arrayModels addObject:model];
        [_arrayModels addObject:model];
        [_arrayModels addObject:model];
      
        
    }
    return _arrayModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setNavigationItem];
    
    //设置tableviewHeaderView
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, 375, 108)];
    
    [self setImageViewWithHeaderView:headerView];
    
    [self setThreeBtnWithHeaderView:headerView];
    
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.rowHeight = 140;
    
    
   
}
- (void) fastBuy{
    YYFastBuyController *fastBuy = [[YYFastBuyController alloc] init];
    [self.navigationController pushViewController:fastBuy animated:YES];
}
- (void)search{
    YYLog(@"search");
}
//设置headerView的图片
- (void)setImageViewWithHeaderView:(UITableViewHeaderFooterView *)headerView{
    //加入图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 58)];
    imageView.image = [UIImage imageNamed:@"sorttitleImage"];
    [headerView addSubview:imageView];
}

//设置headerView的三个按钮
- (void)setThreeBtnWithHeaderView:(UITableViewHeaderFooterView *)headerView{
    //加入三个按钮
    YYSortThreeBtn *btnView = [[YYSortThreeBtn alloc] init];
    btnView.frame = CGRectMake(0, 58, 375, 40);
    [headerView addSubview:btnView];
}


//设置navigationItem
- (void)setNavigationItem{
    //设置左边的按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  极速购物" style:UIBarButtonItemStylePlain target:self action:@selector(fastBuy)];
    //设置中间的按钮
    UIButton *btn = [[UIButton alloc] init];
    btn.width = 200;
    btn.height = 40;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *address = [defaults stringForKey:YYAddressKey];
    if (!address) {
        address = @"正在获取地址";
    }
    
    [btn setTitle:address forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"sortAddress"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    self.navigationItem.titleView = btn;
    //设置右边的按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sort_search_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    self.navigationItem.rightBarButtonItem = item;
}
#pragma mark - tableView数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrayModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYBuyShopCell *cell = [YYBuyShopCell buyShopCellWithTableView:tableView];
    
    YYBuyShopModel *model = self.arrayModels[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

//选中某行时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYBuyShopModel *model = self.arrayModels[indexPath.row];
    YYShopViewController *shopVC = [[YYShopViewController alloc] initWithShopName:model.name];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}
@end
