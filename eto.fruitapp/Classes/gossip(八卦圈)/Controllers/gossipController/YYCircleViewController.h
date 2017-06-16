//
//  YYCircleViewController.h
//  圈子_V1
//
//  Created by Apple on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCircleViewController,YYCircleModel;
@protocol YYCircleViewControllerDelegate <NSObject>

- (void)CircleModelClickWithModel:(YYCircleModel *)model;

@end
@interface YYCircleViewController : UIViewController


@property (nonatomic, strong) UITableView *circleTableView;
@property (nonatomic,weak) id<YYCircleViewControllerDelegate>delegate;

-(instancetype)initWithFlag:(NSString *)flag;//从1是来自八卦圈的，2来自首页的

@end
