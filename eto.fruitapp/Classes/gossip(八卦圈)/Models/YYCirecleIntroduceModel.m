//
//  YYCirecleIntroduceModel.m
//  圈子_V1
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCirecleIntroduceModel.h"

@implementation YYCirecleIntroduceModel
+ (id)CirecleIntroduceModelWithLeftImageString:(NSString *)leftImageString withCirclefriend:(NSInteger)circlefriend withJoinNumber:(NSInteger)joinNumber withCategory:(NSString *)category withCircleIntroduce:(NSString *)circleIntroduce{
    return [[self alloc] initWithLeftImageString:leftImageString withCirclefriend:circlefriend withJoinNumber:joinNumber withCategory:category withCircleIntroduce:circleIntroduce];
}

- (id)initWithLeftImageString:(NSString *)leftImageString withCirclefriend:(NSInteger)circlefriend withJoinNumber:(NSInteger)joinNumber withCategory:(NSString *)category withCircleIntroduce:(NSString *)circleIntroduce{
    if (self = [super init]) {
        self.leftImageString = leftImageString;
        self.circlefriend = circlefriend;
        self.joinNumber = joinNumber;
        self.category = [NSString stringWithFormat:@"分类：%@",category];
        self.circleIntroduce = [NSString stringWithFormat:@"圈子介绍：%@",circleIntroduce];
        
    }
    return self;
}

@end
