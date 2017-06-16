//
//  YYShopView.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/9.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YYShopViewDelegate <NSObject>

@optional
- (void)selectWayInShopViewClick;

@end

@interface YYShopView : UIView
@property (nonatomic, weak) id<YYShopViewDelegate> delegate;
@end
