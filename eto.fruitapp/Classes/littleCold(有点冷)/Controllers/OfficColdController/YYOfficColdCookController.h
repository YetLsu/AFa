//
//  YYOfficColdCookController.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/8.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOfficColdCookController;
@protocol YYOfficColdCookControllerDelegate <NSObject>
- (void)pushControllerWithController:(UIViewController *)viewController;

@end
@interface YYOfficColdCookController : UIViewController
@property (nonatomic, strong) UITableView *cookTableView;
@property (nonatomic,weak) id<YYOfficColdCookControllerDelegate>delegate;

- (instancetype)initWithTableViewHeight:(CGFloat)height;
@end
