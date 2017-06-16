//
//  YYDetailCommentFrame.m
//  YYDetaileCommentCellModel
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYDetailCommentFrame.h"
#import "YYDetailCommentModel.h"

@implementation YYDetailCommentFrame

- (void)setMdel:(YYDetailCommentModel *)model{
    _model = model;
    self.contentSize = [model.commentContent boundingRectWithSize:CGSizeMake(570/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
    if (model.commentContent) {
        self.rowHeight =  99-13 + self.contentSize.height;
    }else{
        self.rowHeight = 99 - 13;
    }
    
}



@end
