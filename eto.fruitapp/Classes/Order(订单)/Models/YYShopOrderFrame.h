//
//  YYShopOrderFrame.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/19.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYShopOrderModel;

@interface YYShopOrderFrame : NSObject
@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) YYShopOrderModel *model;
@end
