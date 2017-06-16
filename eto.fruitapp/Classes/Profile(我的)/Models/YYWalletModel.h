//
//  YYWalletModel.h
//  eto.fruitapp
//
//  Created by wyy on 15/10/30.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYWalletModel : NSObject
@property (weak, nonatomic) NSString *buyExpense;//消费或退款

@property (weak, nonatomic) NSString *remainingSum;//剩余金额

@property (weak, nonatomic) NSString *data;//时间

@property (weak, nonatomic) NSString *money;

@property (assign,nonatomic, getter=isIncome)BOOL income;//是否是收入


- (instancetype)initWithBuyExpense:(NSString *)buyExpense andRemainingSum:(NSString *)remainingSum anddata:(NSString *)data andMoney:(NSString *)money andIncome:(BOOL)income;
@end
