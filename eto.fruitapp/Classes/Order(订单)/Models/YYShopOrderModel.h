//
//  YYShopOrderModel.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/19.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
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

- (instancetype) initWithOrderState:(YYOrderState)orderState shopImage:(UIImage *)shopImage shopName:(NSString *)shopName orderDate:(NSString *)orderDate number:(NSInteger)number price:(CGFloat)price old:(BOOL)old;

@end
