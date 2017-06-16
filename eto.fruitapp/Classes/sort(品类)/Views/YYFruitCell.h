//
//  YYFruitCell.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/6.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYFruitCell, YYFruitModel;

@protocol YYFruitCellDelegate <NSObject>

@optional
- (void)cellAllPriceWithModel:(YYFruitModel *)model;

@end

@interface YYFruitCell : UITableViewCell

@property (nonatomic, strong) YYFruitModel *model;

@property (nonatomic, weak) id<YYFruitCellDelegate> delegate;

+ (instancetype)fruitCellWithTableView:(UITableView *)tableView;
@end
