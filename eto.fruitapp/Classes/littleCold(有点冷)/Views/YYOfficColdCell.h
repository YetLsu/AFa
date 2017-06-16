//
//  YYOfficAndCustomTableViewCell.h
//  OfficAndCustomColdModel
//
//  Created by Apple on 15/12/6.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOfficColdCellModel,YYOfficColdCellFrame;
@interface YYOfficColdCell : UITableViewCell

@property (nonatomic,strong) YYOfficColdCellFrame *cellFrame;

+ (instancetype)OfficAndCustomColdCellWithTableView:(UITableView *)tableView;

@end
