//
//  YYCircleModel.m
//  圈子_V1
//
//  Created by Apple on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCircleModel.h"

@implementation YYCircleModel
+ (id)circleModelWithLeftImageName:(NSString *)leftImageName withPrefixTitle:(NSString *)prefixTitle withReplyNumber:(NSInteger)replyNumber withContent:(NSString *)content withJoinNumber:(NSInteger)joinNumber withReadNumber:(NSInteger)readNumber withJoin:(BOOL)join andBcid:(int)bcid withCategoryC:(NSString *)categoryC{
    return [[self alloc] initWithLeftImageName:leftImageName withPrefixTitle:prefixTitle withReplyNumber:replyNumber withContent:content withJoinNumber:joinNumber withReadNumber:readNumber withJoin:join andBcid:bcid withCategoryC:categoryC];
}


- (id)initWithLeftImageName:(NSString *)leftImageName withPrefixTitle:(NSString *)prefixTitle withReplyNumber:(NSInteger)replyNumber withContent:(NSString *)content withJoinNumber:(NSInteger)joinNumber withReadNumber:(NSInteger)readNumber withJoin:(BOOL)join andBcid:(int)bcid withCategoryC:(NSString *)categoryC{
    if (self = [super init]) {
        self.leftImageName = leftImageName;
        self.prefixTitle = prefixTitle;
        self.replyNumber = replyNumber;
        self.content = content;
        self.joinNumber = joinNumber;
        self.readNumber = readNumber;
        self.join = join;
        self.bcid = bcid;
        self.categoryC = categoryC;
    }
    return self;
}

@end
