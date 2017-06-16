//
//  YYTimeFruitController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/21.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYTimeFruitController.h"
#import "YYTimeFruitModel.h"
#import "YYTimeFruitCell.h"

@interface YYTimeFruitController ()
@property (nonatomic, strong) NSArray *fruits;

@end

@implementation YYTimeFruitController

- (instancetype)init{
    return self = [super initWithStyle:UITableViewStyleGrouped];
}
- (NSArray *)fruits{
    if (!_fruits) {
        YYTimeFruitModel *model = [[YYTimeFruitModel alloc] initWithFruitImage:[UIImage imageNamed:@"sort_cherry"] shopName:@"老王的水果店" fruitName:@"新疆天然大荔枝"fruitCapacity:@"1斤装" fruitPrice:20 saleNumber:1000];
        _fruits = @[model, model, model, model, model, model, model, model, model, model, model, model];
    }
    return _fruits;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"时令水果";
    
    self.tableView.rowHeight = 120;
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, 120)];
    headerView.image = [UIImage imageNamed:@"home_time"];
    self.tableView.tableHeaderView = headerView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.fruits.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYTimeFruitCell *cell = [YYTimeFruitCell timeFruitCellWithTableView:tableView];
    
    YYTimeFruitModel *model = self.fruits[indexPath.row];
    
    cell.model = model;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
@end
