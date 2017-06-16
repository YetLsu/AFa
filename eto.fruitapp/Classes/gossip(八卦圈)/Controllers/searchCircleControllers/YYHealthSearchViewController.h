//
//  YYHealthSearchViewController.h
//  eto.fruitapp
//
//  Created by Apple on 16/1/9.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYHealthSearchViewController,YYCircleModel;

@protocol YYHealthSearchViewControllerDelegate <NSObject>

- (void)healthCellClickWithModel:(YYCircleModel *)model;

@end

@interface YYHealthSearchViewController : UIViewController
@property (nonatomic,weak) UITableView *headlthTableView;
@property (nonatomic,weak) id<YYHealthSearchViewControllerDelegate>delegate;

@end
