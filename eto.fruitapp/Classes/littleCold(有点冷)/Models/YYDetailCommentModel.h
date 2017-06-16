//
//  YYDetailCommentModel.h
//  YYDetaileCommentCellModel
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYDetailCommentModel : NSObject

@property (nonatomic,strong) NSString *headImageStr;
@property (nonatomic,copy) NSString *userName;
#warning 时间设置
@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSString *commentContent;
@property (nonatomic,assign) NSInteger CommentNumberOfZan;

@property (nonatomic, assign) NSInteger commentID;

@property (nonatomic,strong) NSString *toMan;//对谁说的

@property (nonatomic,strong) NSString *userID;

+ (instancetype)detailCommentModelWithHeadImageStr:(NSString *) headImageStr andUserName:(NSString *)userName andTime:(NSString *)time andCommentContent:(NSString *)commentContent andCommentNumberOfZan:(NSInteger)CommentNumberOfZan andCommentID:(NSInteger)commentID andToMan:(NSString *)toMan andUserID:(NSString *) userID;


@end
