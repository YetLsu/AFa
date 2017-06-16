//
//  YYSearchCircleAllTableViewController.h
//  圈子_V1
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYAllSearchCircleController,YYCircleModel;

@protocol YYAllSearchCircleControllerDelegate <NSObject>

@optional
- (void)detailCellClickWithModel:(YYCircleModel *)model;

@end

@interface YYAllSearchCircleController : UIViewController
@property (nonatomic, weak) UITableView *allTableView;

@property (nonatomic, weak) id<YYAllSearchCircleControllerDelegate> delegate;
@end
