//
//  YYCirclePersonHeadViewModel.h
//  圈子_V1
//
//  Created by Apple on 15/12/18.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCirclePersonHeadViewModel : NSObject
@property (nonatomic,copy) NSString *personHeadPic;
@property (nonatomic,copy) NSString *personBGI;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,assign) NSInteger circleFriendNumber;
@property (nonatomic,assign) NSInteger attationNumber;

+ (id)circlePersonHeadViewModelWithPersonHeadPic:(NSString *)personHeadPic withPersonBGI:(NSString *)personBGI withUserName:(NSString *)userName withCircleFriendNumber:(NSInteger)circleFriendNumber withAttationNumber:(NSInteger)attationNumber;

@end
