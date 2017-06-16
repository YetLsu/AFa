//
//  YYTimeFruitModel.m
//  eto.fruitapp
//
//  Created by wyy on 15/11/21.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "YYTimeFruitModel.h"

@implementation YYTimeFruitModel
- (instancetype)initWithFruitImage:(UIImage *)image shopName:(NSString *)shopName fruitName:(NSString *)fruitName fruitCapacity:(NSString *)fruitCapacity fruitPrice:(CGFloat)fruitPrice saleNumber:(NSInteger) saleNumber{
    if (self = [super init]) {
        self.fruitImage = image;
        self.shopName = shopName;
        self.fruitName = fruitName;
        self.fruitCapacity = fruitCapacity;
        self.fruitPrcie = fruitPrice;
        self.saleNumber = saleNumber;
    }
    return self;
}
@end
