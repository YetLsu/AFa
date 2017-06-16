//
//  YYBuyShopModel.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/5.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYBuyShopModel : NSObject
//店名
@property (copy, nonatomic) NSString *name;

//店图标
@property (strong, nonatomic) UIImage *shopIcon;

//销量
@property (copy, nonatomic) NSString* sellCount;
//起送价
@property (copy, nonatomic) NSString *startCarryPrice;
//配送价
@property (copy, nonatomic) NSString *carryPrice;
//配送时间
@property (copy, nonatomic) NSString *time;

//星级
@property (assign, nonatomic) int xingNum;

@end
