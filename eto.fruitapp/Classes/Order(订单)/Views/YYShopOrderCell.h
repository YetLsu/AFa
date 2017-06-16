//
//  YYShopOrderCell.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/19.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYShopOrderFrame, YYShopOrderCell, YYShopOrderModel;

@protocol YYShopOrderCellDelegate<NSObject>

@optional
- (void)gotoPayControllerWithModel:(YYShopOrderModel *)model;

@end

@interface YYShopOrderCell : UITableViewCell
@property (nonatomic, strong)YYShopOrderFrame *orderFrame;

@property (nonatomic, weak) id<YYShopOrderCellDelegate> delegate;

+ (instancetype)shopOrderCellWithTableView:(UITableView *)tableView;
@end
