//
//  YYOfficColdAllController.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/8.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOfficColdAllController;
@protocol YYOfficColdAllControllerDelegate <NSObject>

@optional
- (void)pushControllerWithController:(UIViewController *)viewController;

@end

@interface YYOfficColdAllController : UIViewController

@property (nonatomic, weak) id<YYOfficColdAllControllerDelegate> delegate;

@property (nonatomic, strong) UITableView *allTableView;

- (instancetype)initWithTableViewHeight:(CGFloat)height;
@end
