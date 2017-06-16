//
//  YYCircleDetailContentModel.h
//  圈子_V1
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCircleDetailContentModel : NSObject
@property (nonatomic,assign) NSInteger tieID;//帖子的ID bspid//帖子的id
@property (nonatomic,copy) NSString *title;//帖子标题
@property (nonatomic,copy) NSString *userName;//用户名
@property (nonatomic,copy) NSString *time;//时间
@property (nonatomic,assign) NSInteger zanNumber;//赞数
@property (nonatomic,assign) NSInteger commentNumber;//评论数



+ (id)CircleDetailContentModelWithTieID:(NSInteger)tieID withTitle:(NSString *)title withUserName:(NSString *)userName withTime:(NSString *)time withZanNumber:(NSInteger)zanNumber withCommentNumber:(NSInteger)commentNumber;

@end
