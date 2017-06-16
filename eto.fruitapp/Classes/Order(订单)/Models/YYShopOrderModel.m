//
//  YYShopOrderModel.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/19.
//  Copyright © 2015年 wyy. All rights reserved.
//typedef enum{
/*
YYOrderStateNeedPay,//需要支付
YYOrderStateCancel,//订单过期
YYOrderStateFinishPay,//完成支付,等待收货
YYORderStateFinishOrder,//完成订单
YYOrderStateWaitSaller //等待商家配送
}YYOrderState;

@interface YYShopOrderModel : NSObject <NSCoding>

@property (nonatomic, assign) YYOrderState orderState;
@property (nonatomic, strong) UIImage *shopImage;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *orderDate;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign, getter=isOld) BOOL old;//是否过期
 */
#define YYKeyOrderState @"YYKeyOrderState"
#define YYKeyImage @"YYKeyImage"
#define YYKeyshopName @"YYKeyshopName"
#define YYKeyorderDate @"YYKeyorderDate"
#define YYKeynumber @"YYKeynumber"
#define YYKeyprice @"YYKeyprice"
#define YYKeyold @"YYKeyold"

#import "YYShopOrderModel.h"

@implementation YYShopOrderModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.orderState forKey:YYKeyOrderState];
    [aCoder encodeObject:self.shopImage forKey:YYKeyImage];
    [aCoder encodeObject:self.shopName forKey:YYKeyshopName];
    [aCoder encodeObject:self.orderDate forKey:YYKeyorderDate];
    [aCoder encodeInteger:self.number forKey:YYKeynumber];
    [aCoder encodeFloat:self.price forKey:YYKeyprice];
    [aCoder encodeBool:self.old forKey:YYKeyold];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.orderState = [aDecoder decodeIntForKey:YYKeyOrderState];
        self.shopImage = [aDecoder decodeObjectForKey:YYKeyImage];
        self.shopName = [aDecoder decodeObjectForKey:YYKeyshopName];
        self.orderDate = [aDecoder decodeObjectForKey:YYKeyorderDate];
        self.number = [aDecoder decodeIntegerForKey:YYKeynumber];
        self.price = [aDecoder decodeFloatForKey:YYKeyprice];
        self.old = [aDecoder decodeBoolForKey:YYKeyold];
    }
    return self;
}
- (instancetype)initWithOrderState:(YYOrderState)orderState shopImage:(UIImage *)shopImage shopName:(NSString *)shopName orderDate:(NSString *)orderDate number:(NSInteger)number price:(CGFloat)price old:(BOOL)old{
    if (self = [super init]) {
        self.orderState = orderState;
        self.shopImage = shopImage;
        self.shopName = shopName;
        self.orderDate = orderDate;
        self.number = number;
        self.price = price;
        self.old = old;
    }
    return self;
}
@end
