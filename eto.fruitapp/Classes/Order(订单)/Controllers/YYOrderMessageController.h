//
//  YYOrderPayController.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/19.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYShopOrderModel;
@interface YYOrderMessageController : UIViewController
- (instancetype)initWithModel:(YYShopOrderModel *)model andPriceArray:(NSArray *)priceArray;
@end
