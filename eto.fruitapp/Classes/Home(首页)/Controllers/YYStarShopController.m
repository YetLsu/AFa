//
//  YYStarShopController.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/21.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYStarShopController.h"
#import "YYFruitShopModel.h"
#import "YYFruitShopCell.h"
#import "YYShopViewController.h"

@interface YYStarShopController ()
@property (nonatomic, strong) NSMutableArray *fruitShops;

@end

@implementation YYStarShopController

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

- (instancetype)init{
    return self = [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"明星店铺";
    //创建地址view和背景图片放在headerView中
    self.tableView.tableHeaderView = [self createImageAndSearchBarHeaderViewWithFrame:CGRectMake(0, 0, widthScreen, 225)];
    
    self.tableView.rowHeight = 140;
}
#pragma mark 创建地址view和背景图片放在headerView中
- (UIView *)createImageAndSearchBarHeaderViewWithFrame:(CGRect)headerFrame{
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    
    //添加背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:headerView.bounds];
    imageView.image = [UIImage imageNamed:@"home_starFruit"];
    [headerView addSubview:imageView];
    //添加地址view
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, widthScreen - 20, 35)];
    addressLabel.text = @"湖西路408号";
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.textColor = YYGrayTextColor;
    addressLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:addressLabel];

    
    //在addressLabel上添加addressImage
    //计算文字的size
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    CGSize addressTextSize = [addressLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    
    CGFloat addressImageX = (addressLabel.frame.size.width - addressTextSize.width)/2 - 25;
    UIImageView *addressImage = [[UIImageView alloc] initWithFrame:CGRectMake(addressImageX, 5, 25, 25)];
    addressImage.image = [UIImage imageNamed:@"sortAddress"];
    addressImage.contentMode = UIViewContentModeCenter;
    [addressLabel addSubview:addressImage];
   
    return headerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fruitShops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YYFruitShopCell *cell = [YYFruitShopCell fruitShopCellWithTableView:tableView];
    
    YYFruitShopModel *model = self.fruitShops[indexPath.row];
    
    cell.model = model;
    
    return cell;
}



@end
