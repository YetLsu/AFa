//
//  YYSelectFruitView.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/9.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYSelectFruitView;

@protocol YYSelectFruitViewDelegate <NSObject>

@optional
- (void)gotoSureOrder:(NSArray *)array;

@end

@interface YYSelectFruitView : UIView

@property (nonatomic, weak) id<YYSelectFruitViewDelegate> delegate;

- (instancetype)initWithDatas:(NSMutableDictionary *)datas andkeys:(NSArray *)keys andFrame:(CGRect)frame;
@end
