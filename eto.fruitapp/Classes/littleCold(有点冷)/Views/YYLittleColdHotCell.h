//
//  YYTableViewCell.h
//  Model12_5
//
//  Created by Apple on 15/12/5.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYLittleColdHotCellmodel;


@interface YYLittleColdHotCell : UITableViewCell
@property (nonatomic,strong) YYLittleColdHotCellmodel *hotCellModel;


+ (instancetype)littleColdHotCellWithTableView:(UITableView *)tableView;

@end
