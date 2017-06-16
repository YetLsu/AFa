//
//  YYMyCircleFriendModel.h
//  圈子_V1
//
//  Created by Apple on 15/12/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYMyCircleFriendModel : NSObject
@property (nonatomic,copy) NSString *leftImageStr;//左图的名字
@property (nonatomic,copy) NSString *friendName;//圈友名字
@property (nonatomic,copy) NSString *contentStr;//圈友心情
@property (nonatomic,copy) NSString *buid;//圈友的id
@property (nonatomic,copy) NSString *attention;//关注的状态

+ (id)myCircleFriendModelWithLeftImageStr:(NSString *)leftImageStr withFriendName:(NSString *)friendName withContentStr:(NSString *)contentStr withBuid:(NSString *)buid withAttention:(NSString *)attention;

@end
