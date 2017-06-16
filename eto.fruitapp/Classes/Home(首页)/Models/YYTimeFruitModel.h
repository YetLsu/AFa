//
//  YYTimeFruitModel.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/21.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYTimeFruitModel : NSObject
@property (nonatomic, strong) UIImage *fruitImage;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *fruitName;
@property (nonatomic, copy) NSString *fruitCapacity;//水果容量
@property (nonatomic, assign) CGFloat fruitPrcie;
@property (nonatomic, assign) NSInteger saleNumber;

- (instancetype)initWithFruitImage:(UIImage *)image shopName:(NSString *)shopName fruitName:(NSString *)fruitName fruitCapacity:(NSString *)fruitCapacity fruitPrice:(CGFloat)fruitPrice saleNumber:(NSInteger) saleNumber;
@end
