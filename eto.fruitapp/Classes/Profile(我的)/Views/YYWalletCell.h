//
//  YYWalletCell.h
//  eto.fruitapp
//
//  Created by wyy on 15/10/30.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYWalletModel;

@interface YYWalletCell : UITableViewCell
@property (nonatomic, strong) YYWalletModel *model;

+ (instancetype)walletCellWithTableView:(UITableView *)tableView;
@end
