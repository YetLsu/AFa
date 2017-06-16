//
//  YYNoticCenterTableViewCell.h
//  通知中心
//
//  Created by Apple on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYNoticCenterModel;
@interface YYNoticCenterTableViewCell : UITableViewCell
@property (nonatomic, strong)YYNoticCenterModel *model;
@property (nonatomic,assign) CGFloat rowHeight;
@property (nonatomic,weak) UIImageView *pointImageView;
@property (nonatomic,weak) UILabel *titleLabel;

+ (id)noticeTableViewCell:(UITableView *)tableView;

@end
