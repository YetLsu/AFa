//
//  YYLittleColdDownCellmodel.m
//  Model12_5
//
//  Created by Apple on 15/12/5.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "YYLittleColdHotCellmodel.h"

@implementation YYLittleColdHotCellmodel

- (instancetype)initWithLittleColdDownCellmodel:(UIImage *)leftImage withLeftLabel:(NSString *)leftTitle withTitle:(NSString *)title withContent:(NSString *)content withNumberOfZan:(NSInteger)numberOfZan withNumberOfComment:(NSInteger)numberOfComment withTime:(NSString *)time{
    if (self = [super init]) {
        self.leftImage = leftImage;
        self.leftTitle = leftTitle;
        self.title = title;
        self.content = content;
        self.numberOfZan = numberOfZan;
        self.numberOfComment = numberOfComment;
        self.time = time;
    }
    return self;
}

@end
