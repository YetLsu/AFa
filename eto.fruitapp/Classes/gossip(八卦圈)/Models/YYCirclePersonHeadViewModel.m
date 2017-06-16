//
//  YYCirclePersonHeadViewModel.m
//  圈子_V1
//
//  Created by Apple on 15/12/18.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCirclePersonHeadViewModel.h"

@implementation YYCirclePersonHeadViewModel

+(id)circlePersonHeadViewModelWithPersonHeadPic:(NSString *)personHeadPic withPersonBGI:(NSString *)personBGI withUserName:(NSString *)userName withCircleFriendNumber:(NSInteger)circleFriendNumber withAttationNumber:(NSInteger)attationNumber{
    
    return [[self alloc] initWithPersonHeadPic:personHeadPic withPersonBGI:personBGI withUserName:userName withCircleFriendNumber:circleFriendNumber withAttationNumber:attationNumber];
}



- (id)initWithPersonHeadPic:(NSString *)personHeadPic withPersonBGI:(NSString *)personBGI withUserName:(NSString *)userName withCircleFriendNumber:(NSInteger)circleFriendNumber withAttationNumber:(NSInteger)attationNumber{
    if (self = [super init]) {
        self.personHeadPic = personHeadPic;
        self.personBGI = personBGI;
        self.userName = userName;
        self.circleFriendNumber = circleFriendNumber;
        self.attationNumber = attationNumber;
        
    }
    return self;
}

@end
