//
//  YYOrderCell.h
//  点餐系统
//
//  Created by wyy on 15/11/16.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYOrderMOdel;

@interface YYOrderCell : UITableViewCell


@property (nonatomic, strong) YYOrderMOdel *orderModel;
- (instancetype)initWithCell;

+ (instancetype)orderCellWithTableView:(UITableView *)tableView;
@end
