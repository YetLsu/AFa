//
//  YYDetailCommentModel.m
//  YYDetaileCommentCellModel
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYDetailCommentModel.h"

@implementation YYDetailCommentModel

+ (instancetype)detailCommentModelWithHeadImageStr:(NSString *) headImageStr andUserName:(NSString *)userName andTime:(NSString *)time andCommentContent:(NSString *)commentContent andCommentNumberOfZan:(NSInteger)CommentNumberOfZan andCommentID:(NSInteger)commentID andToMan:(NSString *)toMan andUserID:(NSString *)userID{
    return [[YYDetailCommentModel alloc] initWithHeadImageStr:(NSString *) headImageStr andUserName:(NSString *)userName andTime:(NSString *)time andCommentContent:(NSString *)commentContent andCommentNumberOfZan:(NSInteger)CommentNumberOfZan andCommentID:commentID andToMan:toMan andUserID:userID];
}

- (instancetype) initWithHeadImageStr:(NSString *) headImageStr andUserName:(NSString *)userName andTime:(NSString *)time andCommentContent:(NSString *)commentContent andCommentNumberOfZan:(NSInteger)CommentNumberOfZan andCommentID:(NSInteger)commentID andToMan:(NSString *)toMan andUserID:(NSString *)userID{
    if (self = [super init]) {
        self.headImageStr = headImageStr;
        self.userName = userName;
        self.time = time;
        self.commentContent = commentContent;
        self.CommentNumberOfZan = CommentNumberOfZan;
        self.commentID = commentID;
        self.toMan = toMan;
        self.userID = userID;
    }
    return self;
}


@end
