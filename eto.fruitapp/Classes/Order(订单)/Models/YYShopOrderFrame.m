//
//  YYShopOrderFrame.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/19.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYShopOrderFrame.h"
#import "YYShopOrderModel.h"

@implementation YYShopOrderFrame
- (void)setModel:(YYShopOrderModel *)model{
    _model = model;
    if (model.orderState == YYOrderStateNeedPay){
        self.rowHeight = 125;
    }else{
        self.rowHeight = 82;
    }
}
@end
