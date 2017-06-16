//
//  YYCircleTableViewCell2.h
//  圈子_V1
//
//  Created by Apple on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCircleModel;
@protocol YYCircleTableViewCell2Delegate <NSObject>

@optional

- (void)joinToCircle:(int)bcid;

- (void)quitCircle:(int)bcid;

@end
@interface YYCircleTableViewCell2 : UITableViewCell
@property (nonatomic,strong) YYCircleModel *model;
@property (nonatomic,assign) CGFloat cellRowHeight;
@property (nonatomic,weak) id<YYCircleTableViewCell2Delegate>delegate;

+ (id)circleTableViewUn:(UITableView *)tableView;

@end
