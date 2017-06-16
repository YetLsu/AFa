//
//  YYSquareViewController.h
//  eto.fruitapp
//
//  Created by wyy on 15/12/20.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYSquareViewController, YYDynamicMessageModel;

@protocol YYSquareViewControllerDelegate <NSObject>

@optional
- (void)dynamicMessageClickWithModel:(YYDynamicMessageModel *)model;

- (void)enlargeSquarePic:(NSInteger)tag;

@end

@interface YYSquareViewController : UIViewController
@property (nonatomic, strong) UITableView *squareTableView;

@property (nonatomic, weak)id<YYSquareViewControllerDelegate> delegate;
@end
