//
//  YYCirclePersonTableViewCell.h
//  圈子_V1
//
//  Created by Apple on 15/12/18.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPersonCellModel;
@interface YYCirclePersonTableViewCell : UITableViewCell
@property (nonatomic,strong) YYPersonCellModel *model;
@property (nonatomic,assign) CGFloat rowHeight;



+ (id)circlePersonTableViewCell:(UITableView *)tableView;

@end
