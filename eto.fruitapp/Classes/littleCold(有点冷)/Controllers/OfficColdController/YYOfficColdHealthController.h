//
//  YYOfficColdHealthController.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/8.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOfficColdHealthController;
@protocol YYOfficColdHealthControllerDelegate <NSObject>
- (void)pushControllerWithController:(UIViewController *)viewController;

@end
@interface YYOfficColdHealthController : UIViewController
@property (nonatomic, strong) UITableView *healthTableView;
@property (nonatomic,weak) id<YYOfficColdHealthControllerDelegate>delegate;

- (instancetype)initWithTableViewHeight:(CGFloat)height;
@end
