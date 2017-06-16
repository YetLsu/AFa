//
//  YYOfficColdCookBookController.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/8.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOfficColdCookBookController;
@protocol YYOfficColdCookBookControllerDelegate <NSObject>
- (void)pushControllerWithController:(UIViewController *)viewController;
@end
@interface YYOfficColdCookBookController : UIViewController
@property (nonatomic, strong) UITableView *cookBookTableView;
@property (nonatomic,weak) id<YYOfficColdCookBookControllerDelegate>delegate;

- (instancetype)initWithTableViewHeight:(CGFloat)height;
@end
