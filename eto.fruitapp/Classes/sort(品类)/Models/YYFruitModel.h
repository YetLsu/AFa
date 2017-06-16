//
//  YYFruitModel.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/6.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYFruitModel : NSObject
@property (strong, nonatomic) UIImage *fruitIconImage;
@property (copy, nonatomic) NSString *fruitName;
@property (copy, nonatomic) NSString *saleNumber;
@property (copy, nonatomic) NSString *fruitPreice;
@property (nonatomic, assign) NSInteger selectNumber;
@end
