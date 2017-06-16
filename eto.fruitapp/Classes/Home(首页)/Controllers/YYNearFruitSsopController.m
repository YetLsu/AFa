//
//  YYNearFruitSsopController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/4.
//  Copyright © 2015年 wyy. All rights reserved.


#import "YYNearFruitSsopController.h"
#import "YYFruitShopModel.h"
#import "YYFruitShopCell.h"
#import "threeBtnView.h"
#import "YYShopViewController.h"

@interface YYNearFruitSsopController ()
@property (nonatomic, strong) NSMutableArray *fruitShops;

@end

@implementation YYNearFruitSsopController
- (instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    return self;
}
- (NSMutableArray *)fruitShops{
    if (!_fruitShops) {
        _fruitShops = [NSMutableArray array];
        YYFruitShopModel *model = [[YYFruitShopModel alloc] init];
        model.shopName = @"老王水果店(鉴湖店)";
        model.address = @"柯桥区折线路330号";
        model.openTime = @"营业时间：6点—23点";
        model.distance = @"1000米";
        model.shopIcon = [UIImage imageNamed:@"010"];
        model.xingNumber = 5;
        
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];
        [_fruitShops addObject:model];

        
    }
    return _fruitShops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    threeBtnView *threeBtn = [[threeBtnView alloc] initWithThreeBtn];
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, 375, 60)];
    [headerView addSubview:threeBtn];
    threeBtn.frame = CGRectMake(0, 0, 375, 50);
    self.tableView.tableHeaderView = headerView;
    
    self.title= @"附近的水果店";
}
/**
 *  行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 140;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder] ) {
        self = [super initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fruitShops.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YYFruitShopCell *cell = [YYFruitShopCell fruitShopCellWithTableView:tableView];
    
    YYFruitShopModel *model = self.fruitShops[indexPath.row];
    
    cell.model = model;

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYFruitShopModel *model = self.fruitShops[indexPath.row];
    YYShopViewController *shopVC = [[YYShopViewController alloc] initWithShopName:model.shopName];
    
    [self.navigationController pushViewController:shopVC animated:YES];
}

@end
