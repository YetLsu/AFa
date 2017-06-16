//
//  YYCookSearchViewController.h
//  eto.fruitapp
//
//  Created by Apple on 16/1/9.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYCookSearchViewController,YYCircleModel;
@protocol YYCookSearchViewControllerDelegate <NSObject>

- (void)cookCellClickWithModel:(YYCircleModel *)model;

@end

@interface YYCookSearchViewController : UIViewController
@property (nonatomic,weak) UITableView *cookTableView;
@property (nonatomic,weak) id<YYCookSearchViewControllerDelegate>delegate;

@end
