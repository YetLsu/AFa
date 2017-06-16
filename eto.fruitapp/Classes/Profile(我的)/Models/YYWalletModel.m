//
//  YYWalletModel.m
//  eto.fruitapp
//
//  Created by wyy on 15/10/30.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYWalletModel.h"

@implementation YYWalletModel
- (instancetype)initWithBuyExpense:(NSString *)buyExpense andRemainingSum:(NSString *)remainingSum anddata:(NSString *)data andMoney:(NSString *)money andIncome:(BOOL)income{
    if (self =[super init]) {
        self.buyExpense = buyExpense;
        self.remainingSum = remainingSum;
        self.data = data;
        self.money = money;
        self.income = income;
    }
    return self;
}
@end
