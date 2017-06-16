//
//  YYCircleDetailTableViewController.h
//  圈子_V1
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYCircleModel;
@interface YYCircleDetailTableViewController : UITableViewController
@property (nonatomic,assign) NSInteger *value;

- (instancetype)initWithCircleModel:(YYCircleModel *)model;
@end
