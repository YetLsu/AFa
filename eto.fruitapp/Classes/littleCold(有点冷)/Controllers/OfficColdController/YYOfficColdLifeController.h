//
//  YYOfficColdLifeController.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/8.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOfficColdLifeController;
@protocol YYOfficColdLifeControllerDelegate <NSObject>
- (void)pushControllerWithController:(UIViewController *)viewController;

@end

@interface YYOfficColdLifeController : UIViewController
@property (nonatomic, strong) UITableView *lifeTableView;
@property (nonatomic,weak) id<YYOfficColdLifeControllerDelegate>delegate;

- (instancetype)initWithTableViewHeight:(CGFloat)height;
@end
