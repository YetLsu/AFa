//
//  YYDetailCommentFrame.h
//  YYDetaileCommentCellModel
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YYDetailCommentModel;
@interface YYDetailCommentFrame : NSObject

@property (nonatomic,strong) YYDetailCommentModel *model;
@property (nonatomic,assign) CGFloat rowHeight;
@property (nonatomic) CGSize contentSize;

@end
