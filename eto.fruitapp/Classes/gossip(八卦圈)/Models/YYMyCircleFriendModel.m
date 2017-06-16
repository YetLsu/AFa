//
//  YYMyCircleFriendModel.m
//  圈子_V1
//
//  Created by Apple on 15/12/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYMyCircleFriendModel.h"

@implementation YYMyCircleFriendModel

+ (id)myCircleFriendModelWithLeftImageStr:(NSString *)leftImageStr withFriendName:(NSString *)friendName withContentStr:(NSString *)contentStr withBuid:(NSString *)buid withAttention:(NSString *)attention{
    return [[self alloc] initWithLeftImageStr:leftImageStr withFriendName:friendName withContentStr:contentStr withBuid:buid withAttention:attention];
}

- (id)initWithLeftImageStr:(NSString *)leftImageStr withFriendName:(NSString *)friendName withContentStr:(NSString *)contentStr withBuid:(NSString *)buid withAttention:(NSString *)attention{
    if (self = [super init]) {
        self.leftImageStr = leftImageStr;
        self.friendName = friendName;
        self.contentStr = contentStr;
        self.buid = buid;
        self.attention = attention;
    }
    return self;
}


@end
