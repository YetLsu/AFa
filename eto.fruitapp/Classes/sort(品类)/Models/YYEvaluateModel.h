//
//  YYEvaluateModel.h
//  eto.fruitapp
//
//  Created by wyy on 15/11/9.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYEvaluateModel : NSObject

@property (nonatomic, strong) UIImage *userIcon;//用户头像
@property (nonatomic, copy) NSString *phone;//用户手机号
@property (nonatomic, copy) NSString *data;//哪一天
@property (nonatomic, copy) NSString *time;//具体时间
@property (nonatomic, assign) NSInteger starCount;//星星数量
@property (nonatomic, assign) NSInteger deliverySpeed; //送餐速度
@property (nonatomic, copy) NSString *evaluate;//用户评价

@end
