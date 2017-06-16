//
//  YYMyCircleFreindTableViewCell.h
//  圈子_V1
//
//  Created by Apple on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YYMyCircleFriendModel;

@protocol YYMyCircleFriendModelDelegate <NSObject>

@optional
- (void)attationBtnGuanZhuWith:(NSString *)attation bfuid:(NSString *)bfuid;

- (void)attationBtnQuGuanWith:(NSString *)attation bfuid:(NSString *)bfuid;

@end

@interface YYMyCircleFreindTableViewCell : UITableViewCell
@property (nonatomic,strong) YYMyCircleFriendModel *model;
@property (nonatomic,assign) CGFloat rowHeight;
@property (nonatomic,weak) id<YYMyCircleFriendModelDelegate>delegate;

+ (id)myCircleFreindTableViewCellWiThTableView:(UITableView *)tableView;

@end
