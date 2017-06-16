//
//  YYCircleTableViewCell.h
//  圈子_V1
//
//  Created by Apple on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCircleModel;
@interface YYCircleTableViewCell : UITableViewCell
@property (nonatomic,strong) YYCircleModel *model;
@property (nonatomic,assign) CGFloat cellRowHeight;

+ (id)circleTableView:(UITableView *)tableView;

@end
