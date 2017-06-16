//
//  YYCirecleIntroduceModel.h
//  圈子_V1
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCirecleIntroduceModel : NSObject
@property (nonatomic,copy) NSString *leftImageString;//左图名
@property (nonatomic,assign) NSInteger circlefriend;//圈友数
@property (nonatomic,assign) NSInteger joinNumber;//参与数
@property (nonatomic,copy) NSString *category;//分类
@property (nonatomic,copy) NSString *circleIntroduce;//圈子介绍


+ (id)CirecleIntroduceModelWithLeftImageString:(NSString *)leftImageString withCirclefriend:(NSInteger)circlefriend withJoinNumber:(NSInteger)joinNumber withCategory:(NSString *)category withCircleIntroduce:(NSString *)circleIntroduce;


@end
