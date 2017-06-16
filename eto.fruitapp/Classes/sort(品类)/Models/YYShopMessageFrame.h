//
//  YYShopMessageFrame.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/10.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYShopMessageModel;

@interface YYShopMessageFrame : NSObject
@property (nonatomic, assign) CGRect labelFrame;
@property (nonatomic, assign) CGRect rightIconFrame;
@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) YYShopMessageModel *model;
@end
