//
//  YYCircleDetailContentTableViewCell.h
//  圈子_V1
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCircleDetailContentModel;
@interface YYCircleDetailContentTableViewCell : UITableViewCell
@property (nonatomic,strong) YYCircleDetailContentModel *model;
@property (nonatomic,assign) CGFloat cellRowHeight;

+ (id)circleDetailContentTableViewCell:(UITableView *)table;

@end
