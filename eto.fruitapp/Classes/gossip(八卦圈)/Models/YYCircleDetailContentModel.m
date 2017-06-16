//
//  YYCircleDetailContentModel.m
//  圈子_V1
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYCircleDetailContentModel.h"

@implementation YYCircleDetailContentModel

+(id)CircleDetailContentModelWithTieID:(NSInteger)tieID withTitle:(NSString *)title withUserName:(NSString *)userName withTime:(NSString *)time withZanNumber:(NSInteger)zanNumber withCommentNumber:(NSInteger)commentNumber{
    return [[self alloc] initWithTieID:tieID withTitle:title withUserName:userName withTime:time withZanNumber:zanNumber withCommentNumber:commentNumber];
}

- (id)initWithTieID:(NSInteger)tieID withTitle:(NSString *)title withUserName:(NSString *)userName withTime:(NSString *)time withZanNumber:(NSInteger)zanNumber withCommentNumber:(NSInteger)commentNumber{
    if (self = [super init]) {
        self.tieID = tieID;
        self.title = title;

        self.userName = userName;
        self.time = time;
        self.zanNumber = zanNumber;
        self.commentNumber = commentNumber;
    }
    return self;
}

@end
