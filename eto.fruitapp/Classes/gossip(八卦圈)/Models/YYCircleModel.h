//
//  YYCircleModel.h
//  圈子_V1
//
//  Created by Apple on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYCircleModel : NSObject
@property (nonatomic,copy) NSString *leftImageName; //左侧的图
@property (nonatomic,copy) NSString *prefixTitle;//前缀的标题   eg:#来讲讲你的故事#
@property (nonatomic,assign) NSInteger replyNumber;//回复量     eg:今日8888
@property (nonatomic,copy) NSString *content; //这个话题的描述文字
@property (nonatomic,assign) NSInteger joinNumber; //参与的人数
@property (nonatomic,assign) NSInteger readNumber; //阅读量
@property (nonatomic) BOOL join;
@property (nonatomic,assign) int bcid;//圈子的id
@property (nonatomic,copy) NSString *categoryC;//圈子的分类


+ (id)circleModelWithLeftImageName:(NSString *)leftImageName withPrefixTitle:(NSString *)prefixTitle withReplyNumber:(NSInteger)replyNumber withContent:(NSString *)content withJoinNumber:(NSInteger)joinNumber withReadNumber:(NSInteger)readNumber withJoin:(BOOL)join andBcid:(int)bcid withCategoryC:(NSString *)categoryC;



@end
