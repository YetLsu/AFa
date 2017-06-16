//
//  YYFruitShopModel.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/4.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYFruitShopModel : NSObject
//店名
@property (copy, nonatomic)  NSString *shopName;
//地址
@property (copy, nonatomic)  NSString *address;
//营业时间
@property (copy, nonatomic)  NSString *openTime;
//距离
@property (copy, nonatomic)  NSString *distance;
//店图标
@property (strong, nonatomic) UIImage *shopIcon;
//评价
@property (assign, nonatomic) int xingNumber;
@end
