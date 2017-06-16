//
//  YYRecipeSearchViewController.h
//  eto.fruitapp
//
//  Created by Apple on 16/1/9.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYRecipeSearchViewController,YYCircleModel;
@protocol YYRecipeSearchViewControllerDelegate <NSObject>

- (void)recipeCellClickWithModel:(YYCircleModel *)model;

@end

@interface YYRecipeSearchViewController : UIViewController
@property (nonatomic,weak) UITableView *recipeTableView;
@property (nonatomic,weak) id<YYRecipeSearchViewControllerDelegate>delegate;


@end
