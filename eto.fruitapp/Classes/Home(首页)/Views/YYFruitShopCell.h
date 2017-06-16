//
//  YYFruitShopCell.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/4.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYFruitShopModel;

@interface YYFruitShopCell : UITableViewCell

@property (nonatomic, strong)YYFruitShopModel *model;
+ (instancetype) fruitShopCellWithTableView:(UITableView *)tableView;
@end
