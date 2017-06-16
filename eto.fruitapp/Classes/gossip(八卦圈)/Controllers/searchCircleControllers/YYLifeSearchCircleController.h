//
//  YYSearchCircleLifeTableViewController.h
//  圈子_V1
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YYLifeSearchCircleController,YYCircleModel;
@protocol YYLifeSearchCircleControllerDelegate <NSObject>

- (void)lifeCellClickWithModel:(YYCircleModel *)model;

@end

@interface YYLifeSearchCircleController : UIViewController
@property (nonatomic,weak) UITableView *lifeTableView;
@property (nonatomic,weak) id<YYLifeSearchCircleControllerDelegate>delegate;

@end
